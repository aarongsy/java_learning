package com.eweaver.app.sap.product;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.util.List;
import org.json.simple.JSONArray;

public class Order_Z_CCP_ORDER_DG
{
  public String functionname;

  public static void main(String[] str)
  {
    Order_Z_CCP_ORDER_DG app = new Order_Z_CCP_ORDER_DG("Z_CCP_ORDER_DG");
    app.findData("", "", "", "");
  }

  public Order_Z_CCP_ORDER_DG(String functionname)
  {
    setFunctionname(functionname);
  }

  public JCoTable findData(String ebeln) {
    return findData(ebeln, "", "", "");
  }

  public JCoTable findData(String vbeln, String wadat, String wadae, String werks)
  {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "Z_CCP_ORDER_DG";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("FLAG", "DOWN");

      JCoTable jcotable = function.getTableParameterList().getTable(
        "IT_HEAD_O");

      jcotable.appendRow();
      if (vbeln.length() > 0) {
        jcotable.setValue("VBELN_VL", vbeln);
        jcotable.setValue("VBELN_VT", vbeln);
      }
      if (werks.length() > 0) {
        jcotable.setValue("WERKS", werks);
      }
      if (("".equals(vbeln)) || (vbeln.length() < 1)) {
        if (wadat.length() > 0) jcotable.setValue("WADAT", wadat);
        if (wadae.length() > 0) jcotable.setValue("WADAE", wadae);
      }
      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();

      return function.getTableParameterList().getTable(
        "IT_ITEM_O");
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }

    return null;
  }

  public void saveOrder(String salesdocno) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();
    System.out.println("saveOeder Start !");
    Order_Z_CCP_ORDER_DG app = new Order_Z_CCP_ORDER_DG("Z_CCP_ORDER_DG");
    JCoTable orderTable = app.findData(salesdocno);

    JSONArray array = new JSONArray();
    if (orderTable != null) {
      for (int i = 0; i < orderTable.getNumRows(); i++)
      {
        salesdocno = 
          StringHelper.null2String(orderTable.getString("VBELN_VA"));
        String salesitem = 
          StringHelper.null2String(orderTable.getString("POSNR_VA"));
        String salestype = 
          StringHelper.null2String(orderTable.getString("AUART"));
        String customerno = 
          StringHelper.null2String(orderTable.getString("BSTNK"));
        String soldto = 
          StringHelper.null2String(orderTable.getString("KUNAG"));
        String soldtoname = 
          StringHelper.null2String(orderTable.getString("NAME_SOLD"));
        String shipto = 
          StringHelper.null2String(orderTable.getString("KUNNR"));
        String shiptoname = 
          StringHelper.null2String(orderTable.getString("NAME_SHIP"));
        String shiptoaddress = 
          StringHelper.null2String(orderTable.getString("ADD_SHIP"));
        String materialno = 
          StringHelper.null2String(orderTable.getString("MATNR"));
        String materialdesc = 
          StringHelper.null2String(orderTable.getString("MAKTX"));
        String quantity = 
          StringHelper.null2String(orderTable.getString("KWMENG"));
        String salesunit = 
          StringHelper.null2String(orderTable.getString("VRKME"));
        String unitoftext = 
          StringHelper.null2String(orderTable.getString("MSEHT"));
        String plant = 
          StringHelper.null2String(orderTable.getString("WERKS"));
        String materialtype = 
          StringHelper.null2String(orderTable.getString("VKAUS"));
        String planneddate = 
          StringHelper.null2String(orderTable.getString("WADAT"));
        String packagecode = 
          StringHelper.null2String(orderTable.getString("AESKD"));
        String dangerous = 
          StringHelper.null2String(orderTable.getString("FERTH"));
        String goodsgroup = 
          StringHelper.null2String(orderTable.getString("SPART"));

        StringBuffer buffer = new StringBuffer(4096);
        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_salesorder where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and salesdocno = '" + 
          salesdocno + 
          "' and salesitem = '" + 
          salesitem + "'");

        if (list.size() < 1) {
          buffer.append("insert into uf_lo_salesorder");
          buffer.append("(id,requestid,salesdocno,salesitem,salestype,customerno,soldto,soldtoname,shipto,shiptoname,shiptoaddress,materialno,materialdesc,quantity,salesunit,unitoftext,plant,materialtype,planneddate,packagecode,dangerous,goodsgroup,runningno,covermark,downloadtime) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(salesdocno).append("',");
          buffer.append("'").append(salesitem).append("',");
          buffer.append("'").append(salestype).append("',");
          buffer.append("'").append(customerno).append("',");
          buffer.append("'").append(soldto).append("',");
          buffer.append("'").append(soldtoname).append("',");
          buffer.append("'").append(shipto).append("',");
          buffer.append("'").append(shiptoname).append("',");
          buffer.append("'").append(shiptoaddress).append("',");
          buffer.append("'").append(materialno).append("',");
          buffer.append("'").append(materialdesc).append("',");
          buffer.append("'").append(quantity).append("',");
          buffer.append("'").append(salesunit).append("',");
          buffer.append("'").append(unitoftext).append("',");
          buffer.append("'").append(plant).append("',");
          buffer.append("'").append(materialtype).append("',");
          buffer.append("'").append(planneddate).append("',");
          buffer.append("'").append(packagecode).append("',");
          buffer.append("'").append(dangerous).append("',");
          buffer.append("'").append(goodsgroup).append("',");
          buffer.append("'").append(salesdocno + salesitem)
            .append("',");
          buffer.append("'1',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

          FormBase formBase = new FormBase();
          String categoryid = "402864d1493058d20149306cbe6700b6";

          formBase.setCreatedate(DateHelper.getCurrentDate());
          formBase.setCreatetime(DateHelper.getCurrentTime());
          formBase.setCreator(StringHelper.null2String(userId));
          formBase.setCategoryid(categoryid);
          formBase.setIsdelete(Integer.valueOf(0));
          FormBaseService formBaseService = (FormBaseService)
            BaseContext.getBean("formbaseService");
          formBaseService.createFormBase(formBase);
          String insertSql = buffer.toString();
          insertSql = insertSql.replace("$ewrequestid$", 
            formBase.getId());
          baseJdbc.update(insertSql);
          PermissionTool permissionTool = new PermissionTool();
          permissionTool.addPermission(categoryid, formBase.getId(), 
            "uf_lo_salesorder");
        } else {
          buffer.append("update uf_lo_salesorder set ");
          buffer.append("salestype='").append(salestype).append("',");
          buffer.append("customerno='").append(customerno).append("',");
          buffer.append("soldto='").append(soldto).append("',");
          buffer.append("soldtoname='").append(soldtoname).append("',");
          buffer.append("shipto='").append(shipto).append("',");
          buffer.append("shiptoname='").append(shiptoname).append("',");
          buffer.append("shiptoaddress='").append(shiptoaddress).append("',");
          buffer.append("materialno='").append(materialno).append("',");
          buffer.append("materialdesc='").append(materialdesc).append("',");
          buffer.append("quantity='").append(quantity).append("',");
          buffer.append("salesunit='").append(salesunit).append("',");
          buffer.append("unitoftext='").append(unitoftext).append("',");
          buffer.append("plant='").append(plant).append("',");
          buffer.append("materialtype='").append(materialtype).append("',");
          buffer.append("planneddate='").append(planneddate).append("',");
          buffer.append("packagecode='").append(packagecode).append("',");
          buffer.append("dangerous='").append(dangerous).append("',");
          buffer.append("goodsgroup='").append(goodsgroup).append("',covermark='0',");
          buffer.append("downloadtime=").append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
          buffer.append("where covermark='1' and salesdocno = '").append(salesdocno);
          buffer.append("' and salesitem = '").append(salesitem).append("'");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);
        }
        orderTable.nextRow();
      }
    }

    System.out.println("end saveOrder !");
  }

  public void updateOrder(String salesdocno)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();
    System.out.println("updateOeder Start !");
    Order_Z_CCP_ORDER_DG app = new Order_Z_CCP_ORDER_DG("Z_CCP_ORDER_DG");
    JCoTable orderTable = app.findData(salesdocno);

    JSONArray array = new JSONArray();
    if (orderTable != null) {
      for (int i = 0; i < orderTable.getNumRows(); i++)
      {
        salesdocno = 
          StringHelper.null2String(orderTable.getString("VBELN_VA"));
        String salesitem = 
          StringHelper.null2String(orderTable.getString("POSNR_VA"));
        String salestype = 
          StringHelper.null2String(orderTable.getString("AUART"));
        String customerno = 
          StringHelper.null2String(orderTable.getString("BSTNK"));
        String soldto = 
          StringHelper.null2String(orderTable.getString("KUNAG"));
        String soldtoname = 
          StringHelper.null2String(orderTable.getString("NAME_SOLD"));
        String shipto = 
          StringHelper.null2String(orderTable.getString("KUNNR"));
        String shiptoname = 
          StringHelper.null2String(orderTable.getString("NAME_SHIP"));
        String shiptoaddress = 
          StringHelper.null2String(orderTable.getString("ADD_SHIP"));
        String materialno = 
          StringHelper.null2String(orderTable.getString("MATNR"));
        String materialdesc = 
          StringHelper.null2String(orderTable.getString("MAKTX"));
        String quantity = 
          StringHelper.null2String(orderTable.getString("KWMENG"));
        String salesunit = 
          StringHelper.null2String(orderTable.getString("VRKME"));
        String unitoftext = 
          StringHelper.null2String(orderTable.getString("MSEHT"));
        String plant = 
          StringHelper.null2String(orderTable.getString("WERKS"));
        String materialtype = 
          StringHelper.null2String(orderTable.getString("VKAUS"));
        String planneddate = 
          StringHelper.null2String(orderTable.getString("WADAT"));
        String packagecode = 
          StringHelper.null2String(orderTable.getString("AESKD"));
        String dangerous = 
          StringHelper.null2String(orderTable.getString("FERTH"));
        String goodsgroup = 
          StringHelper.null2String(orderTable.getString("SPART"));

        StringBuffer buffer = new StringBuffer(4096);
        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_salesorder where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and salesdocno = '" + 
          salesdocno + 
          "' and salesitem = '" + 
          salesitem + "'");

        if (list.size() < 1) {
          buffer.append("insert into uf_lo_salesorder");
          buffer.append("(id,requestid,salesdocno,salesitem,salestype,customerno,soldto,soldtoname,shipto,shiptoname,shiptoaddress,materialno,materialdesc,quantity,salesunit,unitoftext,plant,materialtype,planneddate,packagecode,dangerous,goodsgroup,runningno,covermark,downloadtime) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(salesdocno).append("',");
          buffer.append("'").append(salesitem).append("',");
          buffer.append("'").append(salestype).append("',");
          buffer.append("'").append(customerno).append("',");
          buffer.append("'").append(soldto).append("',");
          buffer.append("'").append(soldtoname).append("',");
          buffer.append("'").append(shipto).append("',");
          buffer.append("'").append(shiptoname).append("',");
          buffer.append("'").append(shiptoaddress).append("',");
          buffer.append("'").append(materialno).append("',");
          buffer.append("'").append(materialdesc).append("',");
          buffer.append("'").append(quantity).append("',");
          buffer.append("'").append(salesunit).append("',");
          buffer.append("'").append(unitoftext).append("',");
          buffer.append("'").append(plant).append("',");
          buffer.append("'").append(materialtype).append("',");
          buffer.append("'").append(planneddate).append("',");
          buffer.append("'").append(packagecode).append("',");
          buffer.append("'").append(dangerous).append("',");
          buffer.append("'").append(goodsgroup).append("',");
          buffer.append("'").append(salesdocno + salesitem)
            .append("',");
          buffer.append("'0',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

          FormBase formBase = new FormBase();
          String categoryid = "402864d1493058d20149306cbe6700b6";

          formBase.setCreatedate(DateHelper.getCurrentDate());
          formBase.setCreatetime(DateHelper.getCurrentTime());
          formBase.setCreator(StringHelper.null2String(userId));
          formBase.setCategoryid(categoryid);
          formBase.setIsdelete(Integer.valueOf(0));
          FormBaseService formBaseService = (FormBaseService)
            BaseContext.getBean("formbaseService");
          formBaseService.createFormBase(formBase);
          String insertSql = buffer.toString();
          insertSql = insertSql.replace("$ewrequestid$", 
            formBase.getId());
          baseJdbc.update(insertSql);
          PermissionTool permissionTool = new PermissionTool();
          permissionTool.addPermission(categoryid, formBase.getId(), 
            "uf_lo_salesorder");
        } else {
          buffer.append("update uf_lo_salesorder set ");
          buffer.append("salestype='").append(salestype).append("',");
          buffer.append("customerno='").append(customerno).append("',");
          buffer.append("soldto='").append(soldto).append("',");
          buffer.append("soldtoname='").append(soldtoname).append("',");
          buffer.append("shipto='").append(shipto).append("',");
          buffer.append("shiptoname='").append(shiptoname).append("',");
          buffer.append("shiptoaddress='").append(shiptoaddress).append("',");
          buffer.append("materialno='").append(materialno).append("',");
          buffer.append("materialdesc='").append(materialdesc).append("',");
          buffer.append("quantity='").append(quantity).append("',");
          buffer.append("salesunit='").append(salesunit).append("',");
          buffer.append("unitoftext='").append(unitoftext).append("',");
          buffer.append("plant='").append(plant).append("',");
          buffer.append("materialtype='").append(materialtype).append("',");
          buffer.append("planneddate='").append(planneddate).append("',");
          buffer.append("packagecode='").append(packagecode).append("',");
          buffer.append("dangerous='").append(dangerous).append("',");
          buffer.append("goodsgroup='").append(goodsgroup).append("',covermark='0',");
          buffer.append("downloadtime=").append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
          buffer.append("where salesdocno = '").append(salesdocno);
          buffer.append("' and salesitem = '").append(salesitem).append("'");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);
        }
        orderTable.nextRow();
      }
    }
    System.out.println("end updateOrder !");
  }

  public void getSAPData(String functionname) {
  }

  public String getFunctionname() {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}