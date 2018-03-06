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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONArray;

public class Product_Z_CCP_DELIVERY_DG
{
  public String functionname;

  public static void main(String[] str)
  {
    Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG(
      "Z_CCP_DELIVERY_DG");
    app.findData("", "", "", "");
  }

  public Product_Z_CCP_DELIVERY_DG(String functionname)
  {
    setFunctionname(functionname);
  }

  public JCoTable findData(String vbeln_vl)
  {
    return findData(vbeln_vl, "", "", "");
  }

  public Map<String, String> upData(Map<String, String> inMap)
  {
    Map retMap = new HashMap();
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "Z_CCP_DELIVERY_DG";

      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("FLAG", "UP");

      JCoTable jcotable = function.getTableParameterList().getTable("IT_ITEM_I");

      jcotable.appendRow();
      if (inMap.containsKey("VBELN_VL"))
        jcotable.setValue("VBELN_VL", StringHelper.null2String((String)inMap.get("VBELN_VL")));
      if (inMap.containsKey("POSNR_VL"))
        jcotable.setValue("POSNR_VL", StringHelper.null2String((String)inMap.get("POSNR_VL")));
      if (inMap.containsKey("GARAGE_N"))
        jcotable.setValue("GARAGE_N", StringHelper.null2String((String)inMap.get("GARAGE_N")));
      if (inMap.containsKey("CAR_NO"))
        jcotable.setValue("CAR_NO", StringHelper.null2String((String)inMap.get("CAR_NO")));
      if (inMap.containsKey("LFIMG"))
        jcotable.setValue("LFIMG", StringHelper.null2String((String)inMap.get("LFIMG")));
      if (inMap.containsKey("GEWEI"))
        jcotable.setValue("GEWEI", StringHelper.null2String((String)inMap.get("GEWEI")));
      if (inMap.containsKey("NETWEI"))
        jcotable.setValue("NETWEI", StringHelper.null2String((String)inMap.get("NETWEI")));
      if (inMap.containsKey("PACK")) {
        jcotable.setValue("PACK", StringHelper.null2String((String)inMap.get("PACK")));
      }
      function.execute(SapConnector.getDestination("sanpowersap"));

      JCoTable retable = function.getTableParameterList().getTable("IT_HEAD_LOG");

      if (retable != null) {
        retMap.put("VBELN_VL", StringHelper.null2String(retable.getString("VBELN_VL")));
        retMap.put("POSNR_VL", StringHelper.null2String(retable.getString("POSNR_VL")));
        retMap.put("ZMARK", StringHelper.null2String(retable.getString("ZMARK")));
        retMap.put("ZMESS", StringHelper.null2String(retable.getString("ZMESS")));
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    return retMap;
  }

  public JCoTable findData(String vbeln_vl, String wadat, String wadae, String werks)
  {
    try
    {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "Z_CCP_DELIVERY_DG";
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

      if (vbeln_vl.length() > 0) {
        jcotable.setValue("VBELN_VL", vbeln_vl);
        jcotable.setValue("VBELN_VT", vbeln_vl);
      }
      if (werks.length() > 0) {
        jcotable.setValue("WERKS", werks);
      }
      if (("".equals(vbeln_vl)) || (vbeln_vl.length() < 1)) {
        jcotable.setValue("WADAT", wadat);
        jcotable.setValue("WADAE", wadae);
      }

      function.execute(
        SapConnector.getDestination("sanpowersap"));

      JCoParameterList returnStructure = function.getTableParameterList();

      return function.getTableParameterList().getTable("IT_ITEM_O");
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public void saveProduct(String deliveryno) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();

    Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG(
      "Z_CCP_DELIVERY_DG");
    JCoTable productTable = app.findData(deliveryno);

    JSONArray array = new JSONArray();
    if (productTable != null)
      for (int i = 0; i < productTable.getNumRows(); i++)
      {
        String deliveryitem = StringHelper.null2String(productTable
          .getString("POSNR_VL"));
        String salesdocno = StringHelper.null2String(productTable
          .getString("VBELN_VA"));
        String salesitem = StringHelper.null2String(productTable
          .getString("POSNR_VA"));
        String salestype = StringHelper.null2String(productTable
          .getString("AUART"));
        String customerno = StringHelper.null2String(productTable
          .getString("BSTNK"));
        String soldto = StringHelper.null2String(productTable
          .getString("KUNAG"));
        String soldtoname = StringHelper.null2String(productTable
          .getString("NAME_SOLD"));
        String shipto = StringHelper.null2String(productTable
          .getString("KUNNR"));
        String shiptoname = StringHelper.null2String(productTable
          .getString("NAME_SHIP"));
        String shiptoaddress = StringHelper.null2String(productTable
          .getString("ADD_SHIP"));
        String telephone = StringHelper.null2String(productTable
          .getString("TEL_NUMBER"));
        String storageloc = StringHelper.null2String(productTable
          .getString("LGORT"));
        String descofloc = StringHelper.null2String(productTable
          .getString("LGOBE"));
        String materialno = StringHelper.null2String(productTable
          .getString("MATNR"));
        String materialdesc = StringHelper.null2String(productTable
          .getString("MAKTX"));
        String quantity = StringHelper.null2String(productTable
          .getString("LFIMG"));
        String salesunit = StringHelper.null2String(productTable
          .getString("VRKME"));
        String unitoftext = StringHelper.null2String(productTable
          .getString("MSEHT"));
        String grossweight = StringHelper.null2String(productTable
          .getString("BRGEW"));
        String plant = StringHelper.null2String(productTable
          .getString("WERKS"));
        String materialofcust = StringHelper.null2String(productTable
          .getString("KDMAT"));
        String materialtype = StringHelper.null2String(productTable
          .getString("VKAUS"));
        String planneddate = StringHelper.null2String(productTable
          .getString("WADAT"));
        String standard = StringHelper.null2String(productTable
          .getString("SPECS"));
        String batchnum = StringHelper.null2String(productTable
          .getString("CHARG"));
        String packagetype = StringHelper.null2String(productTable
          .getString("PACK"));
        String packagecode = StringHelper.null2String(productTable
          .getString("AESKD"));
        String kgrate = StringHelper.null2String(productTable
          .getString("KGBTR"));
        String shipingpoint = StringHelper.null2String(productTable
          .getString("VSTEL"));
        String delipriority = StringHelper.null2String(productTable
          .getString("LPRIO"));
        String specialmark = StringHelper.null2String(productTable
          .getString("SDABW"));
        String netweight = StringHelper.null2String(productTable
          .getString("NTGEW"));
        String supplynumber = StringHelper.null2String(productTable
          .getString("BSTKD"));
        String picking = StringHelper.null2String(productTable
          .getString("KOSTK"));
        String dangerous = StringHelper.null2String(productTable
          .getString("FERTH"));
        String goodsgroup = StringHelper.null2String(productTable
          .getString("SPART"));
        String deliverylimit = StringHelper.null2String(productTable
          .getString("UEBTO"));

        String overmark = StringHelper.null2String(productTable
          .getString("UEBTK"));
        String lacking = StringHelper.null2String(productTable
          .getString("UNTTO"));
        String uploadmark = StringHelper.null2String(productTable
          .getString("ZYUP"));
        String purchcode = StringHelper.null2String(productTable
          .getString("ZGMZBH"));
        String citymark = StringHelper.null2String(productTable
          .getString("ZADDFLAG"));
        String transportno = StringHelper.null2String(productTable
          .getString("ZYSZBH"));
        String purchasenum = StringHelper.null2String(productTable
          .getString("ZMENGE1"));
        String transportnum = StringHelper.null2String(productTable
          .getString("ZMENGE2"));
        String purchasemid = StringHelper.null2String(productTable
          .getString("ZMATNR"));
        String transportcomp = StringHelper.null2String(productTable
          .getString("ZKUNNR"));
        String transportname = StringHelper.null2String(productTable
          .getString("ZKUNNRTXT"));
        String transexpiry = StringHelper.null2String(productTable
          .getString("ZDATELOW1"));
        String transdeadline = StringHelper.null2String(productTable
          .getString("ZDATEHIGH1"));
        String purchexpiry = StringHelper.null2String(productTable
          .getString("ZDATELOW2"));
        String purchdeadline = StringHelper.null2String(productTable
          .getString("ZDATEHIGH2"));
        String carsno = StringHelper.null2String(productTable
          .getString("ZCARS"));
        String memo1 = StringHelper.null2String(productTable
          .getString("BEIZHU1"));
        String Memo2 = StringHelper.null2String(productTable
          .getString("BEIZHU2"));
        String Memo3 = StringHelper.null2String(productTable
          .getString("BEIZHU3"));

        StringBuffer buffer = new StringBuffer(4096);

        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_delivery where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and deliveryno = '" + 
          deliveryno + 
          "' and deliveryitem = '" + 
          deliveryitem + "'");

        if (list.size() < 1)
        {
          buffer.append("insert into uf_lo_delivery");
          buffer.append("(id,requestid,deliveryno,deliveryitem,salesdocno,salesitem,salestype,customerno,soldto,soldtoname,shipto,shiptoname,shiptoaddress,telephone,storageloc,descofloc,materialno,materialdesc,quantity,salesunit,unitoftext,grossweight,plant,materialofcust,materialtype,planneddate,standard,batchnum,packagetype,packagecode,kgrate,shipingpoint,delipriority,specialmark,netweight,supplynumber,picking,dangerous,goodsgroup,deliverylimit,overmark,lacking,uploadmark,purchcode,citymark,transportno,purchasenum,transportnum,purchasemid,transportcomp,transportname,transexpiry,transdeadline,purchexpiry,purchdeadline,carsno,memo1,Memo2,Memo3,runningno,covermark,downloadtime) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(deliveryno).append("',");
          buffer.append("'").append(deliveryitem).append("',");
          buffer.append("'").append(salesdocno).append("',");
          buffer.append("'").append(salesitem).append("',");
          buffer.append("'").append(salestype).append("',");
          buffer.append("'").append(customerno).append("',");
          buffer.append("'").append(soldto).append("',");
          buffer.append("'").append(soldtoname).append("',");
          buffer.append("'").append(shipto).append("',");
          buffer.append("'").append(shiptoname).append("',");
          buffer.append("'").append(shiptoaddress).append("',");
          buffer.append("'").append(telephone).append("',");
          buffer.append("'").append(storageloc).append("',");
          buffer.append("'").append(descofloc).append("',");
          buffer.append("'").append(materialno).append("',");
          buffer.append("'").append(materialdesc).append("',");
          buffer.append("'").append(quantity).append("',");
          buffer.append("'").append(salesunit).append("',");
          buffer.append("'").append(unitoftext).append("',");
          buffer.append("'").append(grossweight).append("',");
          buffer.append("'").append(plant).append("',");
          buffer.append("'").append(materialofcust).append("',");
          buffer.append("'").append(materialtype).append("',");
          buffer.append("'").append(planneddate).append("',");
          buffer.append("'").append(standard).append("',");
          buffer.append("'").append(batchnum).append("',");
          buffer.append("'").append(packagetype).append("',");
          buffer.append("'").append(packagecode).append("',");
          buffer.append("'").append(kgrate).append("',");
          buffer.append("'").append(shipingpoint).append("',");
          buffer.append("'").append(delipriority).append("',");
          buffer.append("'").append(specialmark).append("',");
          buffer.append("'").append(netweight).append("',");
          buffer.append("'").append(supplynumber).append("',");
          buffer.append("'").append(picking).append("',");
          buffer.append("'").append(dangerous).append("',");
          buffer.append("'").append(goodsgroup).append("',");
          buffer.append("'").append(deliverylimit).append("',");
          buffer.append("'").append(overmark).append("',");
          buffer.append("'").append(lacking).append("',");
          buffer.append("'").append(uploadmark).append("',");
          buffer.append("'").append(purchcode).append("',");
          buffer.append("'").append(citymark).append("',");
          buffer.append("'").append(transportno).append("',");
          buffer.append("'").append(purchasenum).append("',");
          buffer.append("'").append(transportnum).append("',");
          buffer.append("'").append(purchasemid).append("',");
          buffer.append("'").append(transportcomp).append("',");
          buffer.append("'").append(transportname).append("',");
          buffer.append("'").append(transexpiry).append("',");
          buffer.append("'").append(transdeadline).append("',");
          buffer.append("'").append(purchexpiry).append("',");
          buffer.append("'").append(purchdeadline).append("',");
          buffer.append("'").append(carsno).append("',");
          buffer.append("'").append(memo1).append("',");
          buffer.append("'").append(Memo2).append("',");
          buffer.append("'").append(Memo3).append("',");
          buffer.append("'").append(deliveryno + deliveryitem)
            .append("',");
          buffer.append("'1',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

          FormBase formBase = new FormBase();
          String categoryid = "40285a9048a213b50148b01877720213";

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
            "uf_lo_delivery");
        } else {
          buffer.append("update uf_lo_delivery set ");
          buffer.append("salesdocno='").append(salesdocno).append("',");
          buffer.append("salesitem='").append(salesitem).append("',");
          buffer.append("salestype='").append(salestype).append("',");
          buffer.append("customerno='").append(customerno).append("',");
          buffer.append("soldto='").append(soldto).append("',");
          buffer.append("soldtoname='").append(soldtoname).append("',");
          buffer.append("shipto='").append(shipto).append("',");
          buffer.append("shiptoname='").append(shiptoname).append("',");
          buffer.append("shiptoaddress='").append(shiptoaddress).append("',");
          buffer.append("telephone='").append(telephone).append("',");
          buffer.append("storageloc='").append(storageloc).append("',");
          buffer.append("descofloc='").append(descofloc).append("',");
          buffer.append("materialno='").append(materialno).append("',");
          buffer.append("materialdesc='").append(materialdesc).append("',");
          buffer.append("quantity='").append(quantity).append("',");
          buffer.append("salesunit='").append(salesunit).append("',");
          buffer.append("unitoftext='").append(unitoftext).append("',");
          buffer.append("grossweight='").append(grossweight).append("',");
          buffer.append("plant='").append(plant).append("',");
          buffer.append("materialofcust='").append(materialofcust).append("',");
          buffer.append("materialtype='").append(materialtype).append("',");
          buffer.append("planneddate='").append(planneddate).append("',");
          buffer.append("standard='").append(standard).append("',");
          buffer.append("batchnum='").append(batchnum).append("',");
          buffer.append("packagetype='").append(packagetype).append("',");
          buffer.append("packagecode='").append(packagecode).append("',");
          buffer.append("kgrate='").append(kgrate).append("',");
          buffer.append("shipingpoint='").append(shipingpoint).append("',");
          buffer.append("delipriority='").append(delipriority).append("',");
          buffer.append("specialmark='").append(specialmark).append("',");
          buffer.append("netweight='").append(netweight).append("',");
          buffer.append("supplynumber='").append(supplynumber).append("',");
          buffer.append("picking='").append(picking).append("',");
          buffer.append("dangerous='").append(dangerous).append("',");
          buffer.append("goodsgroup='").append(goodsgroup).append("',");
          buffer.append("deliverylimit='").append(deliverylimit).append("',");
          buffer.append("overmark='").append(overmark).append("',");
          buffer.append("lacking='").append(lacking).append("',");
          buffer.append("uploadmark='").append(uploadmark).append("',");
          buffer.append("purchcode='").append(purchcode).append("',");
          buffer.append("citymark='").append(citymark).append("',");
          buffer.append("transportno='").append(transportno).append("',");
          buffer.append("purchasenum='").append(purchasenum).append("',");
          buffer.append("transportnum='").append(transportnum).append("',");
          buffer.append("purchasemid='").append(purchasemid).append("',");
          buffer.append("transportcomp='").append(transportcomp).append("',");
          buffer.append("transportname='").append(transportname).append("',");
          buffer.append("transexpiry='").append(transexpiry).append("',");
          buffer.append("transdeadline='").append(transdeadline).append("',");
          buffer.append("purchexpiry='").append(purchexpiry).append("',");
          buffer.append("purchdeadline='").append(purchdeadline).append("',");
          buffer.append("carsno='").append(carsno).append("',");
          buffer.append("memo1='").append(memo1).append("',");
          buffer.append("Memo2='").append(Memo2).append("',");
          buffer.append("Memo3='").append(Memo3).append("',covermark='0',");
          buffer.append("downloadtime=").append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
          buffer.append("where covermark='1' and deliveryno = '").append(deliveryno);
          buffer.append("' and deliveryitem = '").append(deliveryitem).append("'");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);
        }
        productTable.nextRow();
      }
  }

  public void updateProduct(String deliveryno)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();

    Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG(
      "Z_CCP_DELIVERY_DG");
    JCoTable productTable = app.findData(deliveryno);

    JSONArray array = new JSONArray();
    if (productTable != null)
      for (int i = 0; i < productTable.getNumRows(); i++)
      {
        String deliveryitem = StringHelper.null2String(productTable
          .getString("POSNR_VL"));
        String salesdocno = StringHelper.null2String(productTable
          .getString("VBELN_VA"));
        String salesitem = StringHelper.null2String(productTable
          .getString("POSNR_VA"));
        String salestype = StringHelper.null2String(productTable
          .getString("AUART"));
        String customerno = StringHelper.null2String(productTable
          .getString("BSTNK"));
        String soldto = StringHelper.null2String(productTable
          .getString("KUNAG"));
        String soldtoname = StringHelper.null2String(productTable
          .getString("NAME_SOLD"));
        String shipto = StringHelper.null2String(productTable
          .getString("KUNNR"));
        String shiptoname = StringHelper.null2String(productTable
          .getString("NAME_SHIP"));
        String shiptoaddress = StringHelper.null2String(productTable
          .getString("ADD_SHIP"));
        String telephone = StringHelper.null2String(productTable
          .getString("TEL_NUMBER"));
        String storageloc = StringHelper.null2String(productTable
          .getString("LGORT"));
        String descofloc = StringHelper.null2String(productTable
          .getString("LGOBE"));
        String materialno = StringHelper.null2String(productTable
          .getString("MATNR"));
        String materialdesc = StringHelper.null2String(productTable
          .getString("MAKTX"));
        String quantity = StringHelper.null2String(productTable
          .getString("LFIMG"));
        String salesunit = StringHelper.null2String(productTable
          .getString("VRKME"));
        String unitoftext = StringHelper.null2String(productTable
          .getString("MSEHT"));
        String grossweight = StringHelper.null2String(productTable
          .getString("BRGEW"));
        String plant = StringHelper.null2String(productTable
          .getString("WERKS"));
        String materialofcust = StringHelper.null2String(productTable
          .getString("KDMAT"));
        String materialtype = StringHelper.null2String(productTable
          .getString("VKAUS"));
        String planneddate = StringHelper.null2String(productTable
          .getString("WADAT"));
        String standard = StringHelper.null2String(productTable
          .getString("SPECS"));
        String batchnum = StringHelper.null2String(productTable
          .getString("CHARG"));
        String packagetype = StringHelper.null2String(productTable
          .getString("PACK"));
        String packagecode = StringHelper.null2String(productTable
          .getString("AESKD"));
        String kgrate = StringHelper.null2String(productTable
          .getString("KGBTR"));
        String shipingpoint = StringHelper.null2String(productTable
          .getString("VSTEL"));
        String delipriority = StringHelper.null2String(productTable
          .getString("LPRIO"));
        String specialmark = StringHelper.null2String(productTable
          .getString("SDABW"));
        String netweight = StringHelper.null2String(productTable
          .getString("NTGEW"));
        String supplynumber = StringHelper.null2String(productTable
          .getString("BSTKD"));
        String picking = StringHelper.null2String(productTable
          .getString("KOSTK"));
        String dangerous = StringHelper.null2String(productTable
          .getString("FERTH"));
        String goodsgroup = StringHelper.null2String(productTable
          .getString("SPART"));
        String deliverylimit = StringHelper.null2String(productTable
          .getString("UEBTO"));

        String overmark = StringHelper.null2String(productTable
          .getString("UEBTK"));
        String lacking = StringHelper.null2String(productTable
          .getString("UNTTO"));
        String uploadmark = StringHelper.null2String(productTable
          .getString("ZYUP"));
        String purchcode = StringHelper.null2String(productTable
          .getString("ZGMZBH"));
        String citymark = StringHelper.null2String(productTable
          .getString("ZADDFLAG"));
        String transportno = StringHelper.null2String(productTable
          .getString("ZYSZBH"));
        String purchasenum = StringHelper.null2String(productTable
          .getString("ZMENGE1"));
        String transportnum = StringHelper.null2String(productTable
          .getString("ZMENGE2"));
        String purchasemid = StringHelper.null2String(productTable
          .getString("ZMATNR"));
        String transportcomp = StringHelper.null2String(productTable
          .getString("ZKUNNR"));
        String transportname = StringHelper.null2String(productTable
          .getString("ZKUNNRTXT"));
        String transexpiry = StringHelper.null2String(productTable
          .getString("ZDATELOW1"));
        String transdeadline = StringHelper.null2String(productTable
          .getString("ZDATEHIGH1"));
        String purchexpiry = StringHelper.null2String(productTable
          .getString("ZDATELOW2"));
        String purchdeadline = StringHelper.null2String(productTable
          .getString("ZDATEHIGH2"));
        String carsno = StringHelper.null2String(productTable
          .getString("ZCARS"));
        String memo1 = StringHelper.null2String(productTable
          .getString("BEIZHU1"));
        String Memo2 = StringHelper.null2String(productTable
          .getString("BEIZHU2"));
        String Memo3 = StringHelper.null2String(productTable
          .getString("BEIZHU3"));

        StringBuffer buffer = new StringBuffer(4096);

        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_delivery where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and deliveryno = '" + 
          deliveryno + 
          "' and deliveryitem = '" + 
          deliveryitem + "'");

        if (list.size() < 1)
        {
          buffer.append("insert into uf_lo_delivery");
          buffer.append("(id,requestid,deliveryno,deliveryitem,salesdocno,salesitem,salestype,customerno,soldto,soldtoname,shipto,shiptoname,shiptoaddress,telephone,storageloc,descofloc,materialno,materialdesc,quantity,salesunit,unitoftext,grossweight,plant,materialofcust,materialtype,planneddate,standard,batchnum,packagetype,packagecode,kgrate,shipingpoint,delipriority,specialmark,netweight,supplynumber,picking,dangerous,goodsgroup,deliverylimit,overmark,lacking,uploadmark,purchcode,citymark,transportno,purchasenum,transportnum,purchasemid,transportcomp,transportname,transexpiry,transdeadline,purchexpiry,purchdeadline,carsno,memo1,Memo2,Memo3,runningno,covermark,downloadtime) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(deliveryno).append("',");
          buffer.append("'").append(deliveryitem).append("',");
          buffer.append("'").append(salesdocno).append("',");
          buffer.append("'").append(salesitem).append("',");
          buffer.append("'").append(salestype).append("',");
          buffer.append("'").append(customerno).append("',");
          buffer.append("'").append(soldto).append("',");
          buffer.append("'").append(soldtoname).append("',");
          buffer.append("'").append(shipto).append("',");
          buffer.append("'").append(shiptoname).append("',");
          buffer.append("'").append(shiptoaddress).append("',");
          buffer.append("'").append(telephone).append("',");
          buffer.append("'").append(storageloc).append("',");
          buffer.append("'").append(descofloc).append("',");
          buffer.append("'").append(materialno).append("',");
          buffer.append("'").append(materialdesc).append("',");
          buffer.append("'").append(quantity).append("',");
          buffer.append("'").append(salesunit).append("',");
          buffer.append("'").append(unitoftext).append("',");
          buffer.append("'").append(grossweight).append("',");
          buffer.append("'").append(plant).append("',");
          buffer.append("'").append(materialofcust).append("',");
          buffer.append("'").append(materialtype).append("',");
          buffer.append("'").append(planneddate).append("',");
          buffer.append("'").append(standard).append("',");
          buffer.append("'").append(batchnum).append("',");
          buffer.append("'").append(packagetype).append("',");
          buffer.append("'").append(packagecode).append("',");
          buffer.append("'").append(kgrate).append("',");
          buffer.append("'").append(shipingpoint).append("',");
          buffer.append("'").append(delipriority).append("',");
          buffer.append("'").append(specialmark).append("',");
          buffer.append("'").append(netweight).append("',");
          buffer.append("'").append(supplynumber).append("',");
          buffer.append("'").append(picking).append("',");
          buffer.append("'").append(dangerous).append("',");
          buffer.append("'").append(goodsgroup).append("',");
          buffer.append("'").append(deliverylimit).append("',");
          buffer.append("'").append(overmark).append("',");
          buffer.append("'").append(lacking).append("',");
          buffer.append("'").append(uploadmark).append("',");
          buffer.append("'").append(purchcode).append("',");
          buffer.append("'").append(citymark).append("',");
          buffer.append("'").append(transportno).append("',");
          buffer.append("'").append(purchasenum).append("',");
          buffer.append("'").append(transportnum).append("',");
          buffer.append("'").append(purchasemid).append("',");
          buffer.append("'").append(transportcomp).append("',");
          buffer.append("'").append(transportname).append("',");
          buffer.append("'").append(transexpiry).append("',");
          buffer.append("'").append(transdeadline).append("',");
          buffer.append("'").append(purchexpiry).append("',");
          buffer.append("'").append(purchdeadline).append("',");
          buffer.append("'").append(carsno).append("',");
          buffer.append("'").append(memo1).append("',");
          buffer.append("'").append(Memo2).append("',");
          buffer.append("'").append(Memo3).append("',");
          buffer.append("'").append(deliveryno + deliveryitem)
            .append("',");
          buffer.append("'0',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

          FormBase formBase = new FormBase();
          String categoryid = "40285a9048a213b50148b01877720213";

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
            "uf_lo_delivery");
        } else {
          buffer.append("update uf_lo_delivery set ");
          buffer.append("salesdocno='").append(salesdocno).append("',");
          buffer.append("salesitem='").append(salesitem).append("',");
          buffer.append("salestype='").append(salestype).append("',");
          buffer.append("customerno='").append(customerno).append("',");
          buffer.append("soldto='").append(soldto).append("',");
          buffer.append("soldtoname='").append(soldtoname).append("',");
          buffer.append("shipto='").append(shipto).append("',");
          buffer.append("shiptoname='").append(shiptoname).append("',");
          buffer.append("shiptoaddress='").append(shiptoaddress).append("',");
          buffer.append("telephone='").append(telephone).append("',");
          buffer.append("storageloc='").append(storageloc).append("',");
          buffer.append("descofloc='").append(descofloc).append("',");
          buffer.append("materialno='").append(materialno).append("',");
          buffer.append("materialdesc='").append(materialdesc).append("',");
          buffer.append("quantity='").append(quantity).append("',");
          buffer.append("salesunit='").append(salesunit).append("',");
          buffer.append("unitoftext='").append(unitoftext).append("',");
          buffer.append("grossweight='").append(grossweight).append("',");
          buffer.append("plant='").append(plant).append("',");
          buffer.append("materialofcust='").append(materialofcust).append("',");
          buffer.append("materialtype='").append(materialtype).append("',");
          buffer.append("planneddate='").append(planneddate).append("',");
          buffer.append("standard='").append(standard).append("',");
          buffer.append("batchnum='").append(batchnum).append("',");
          buffer.append("packagetype='").append(packagetype).append("',");
          buffer.append("packagecode='").append(packagecode).append("',");
          buffer.append("kgrate='").append(kgrate).append("',");
          buffer.append("shipingpoint='").append(shipingpoint).append("',");
          buffer.append("delipriority='").append(delipriority).append("',");
          buffer.append("specialmark='").append(specialmark).append("',");
          buffer.append("netweight='").append(netweight).append("',");
          buffer.append("supplynumber='").append(supplynumber).append("',");
          buffer.append("picking='").append(picking).append("',");
          buffer.append("dangerous='").append(dangerous).append("',");
          buffer.append("goodsgroup='").append(goodsgroup).append("',");
          buffer.append("deliverylimit='").append(deliverylimit).append("',");
          buffer.append("overmark='").append(overmark).append("',");
          buffer.append("lacking='").append(lacking).append("',");
          buffer.append("uploadmark='").append(uploadmark).append("',");
          buffer.append("purchcode='").append(purchcode).append("',");
          buffer.append("citymark='").append(citymark).append("',");
          buffer.append("transportno='").append(transportno).append("',");
          buffer.append("purchasenum='").append(purchasenum).append("',");
          buffer.append("transportnum='").append(transportnum).append("',");
          buffer.append("purchasemid='").append(purchasemid).append("',");
          buffer.append("transportcomp='").append(transportcomp).append("',");
          buffer.append("transportname='").append(transportname).append("',");
          buffer.append("transexpiry='").append(transexpiry).append("',");
          buffer.append("transdeadline='").append(transdeadline).append("',");
          buffer.append("purchexpiry='").append(purchexpiry).append("',");
          buffer.append("purchdeadline='").append(purchdeadline).append("',");
          buffer.append("carsno='").append(carsno).append("',");
          buffer.append("memo1='").append(memo1).append("',");
          buffer.append("Memo2='").append(Memo2).append("',");
          buffer.append("Memo3='").append(Memo3).append("',covermark='0',");
          buffer.append("downloadtime=").append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
          buffer.append("where deliveryno = '").append(deliveryno);
          buffer.append("' and deliveryitem = '").append(deliveryitem).append("'");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);
        }
        productTable.nextRow();
      }
  }

  public void getSAPData(String functionname)
  {
  }

  public String getFunctionname()
  {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}