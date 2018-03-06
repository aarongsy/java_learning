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

public class Purchase_Z_CCP_PO_DG
{
  public String functionname;

  public static void main(String[] str)
  {
    Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
    app.findData("", "", "", "");
  }

  public Purchase_Z_CCP_PO_DG(String functionname)
  {
    setFunctionname(functionname);
  }

  public Map<String, JCoTable> findData(String ebeln) {
    return findData(ebeln, "", "", "");
  }

  public Map<String, String> upData(Map<String, String> inMap)
  {
    Map retMap = new HashMap();
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "Z_CCP_PO_DG";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("FLAG", "UP");

      JCoTable jcotable = function.getTableParameterList().getTable("IT_HEAD_UP");

      jcotable.appendRow();
      if (inMap.containsKey("EBELN"))
        jcotable.setValue("EBELN", StringHelper.null2String((String)inMap.get("EBELN")));
      if (inMap.containsKey("EBELP"))
        jcotable.setValue("EBELP", StringHelper.null2String((String)inMap.get("EBELP")));
      if (inMap.containsKey("LGORT"))
        jcotable.setValue("LGORT", StringHelper.null2String((String)inMap.get("LGORT")));
      if (inMap.containsKey("WERKS"))
        jcotable.setValue("WERKS", StringHelper.null2String((String)inMap.get("WERKS")));
      if (inMap.containsKey("LFIMG"))
        jcotable.setValue("LFIMG", StringHelper.null2String((String)inMap.get("LFIMG")));
      if (inMap.containsKey("CAR_NO"))
        jcotable.setValue("CAR_NO", StringHelper.null2String((String)inMap.get("CAR_NO")));
      if (inMap.containsKey("BUDAT"))
        jcotable.setValue("BUDAT", StringHelper.null2String((String)inMap.get("BUDAT")));
      if (inMap.containsKey("GEWEI"))
        jcotable.setValue("GEWEI", StringHelper.null2String((String)inMap.get("GEWEI")));
      if (inMap.containsKey("PACK")) {
        jcotable.setValue("PACK", StringHelper.null2String((String)inMap.get("PACK")));
      }
      function.execute(SapConnector.getDestination("sanpowersap"));

      JCoTable retable = function.getTableParameterList().getTable("IT_HEAD_LOG");

      if (retable != null) {
        retMap.put("EBELN", StringHelper.null2String(retable.getString("EBELN")));
        retMap.put("EBELP", StringHelper.null2String(retable.getString("EBELP")));
        retMap.put("ZMARK", StringHelper.null2String(retable.getString("ZMARK")));
        retMap.put("ZMESS", StringHelper.null2String(retable.getString("ZMESS")));
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    return retMap;
  }

  public Map<String, JCoTable> findData(String ebeln, String eadat, String eadae, String werks)
  {
    try
    {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "Z_CCP_PO_DG";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("FLAG", "DOWN");

      JCoTable jcotable = function.getTableParameterList().getTable(
        "IT_HEAD_DOWN");

      jcotable.appendRow();
      jcotable.setValue("EBELN", ebeln);
      jcotable.setValue("EBELT", ebeln);
      jcotable.setValue("WERKS", werks);
      jcotable.setValue("EADAT", eadat);
      jcotable.setValue("EADAE", eadae);

      function.execute(
        SapConnector.getDestination("sanpowersap"));

      Map retMap = new HashMap();
      retMap.put("main", 
        function.getTableParameterList().getTable("IT_ITEM_DOWN"));

      if (function.getTableParameterList().getTable("IT_ZUJIAN_DOWN")
        .getNumRows() > 0) {
        retMap.put(
          "detail", 
          function.getTableParameterList().getTable(
          "IT_ZUJIAN_DOWN"));
      }
      return retMap;
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public void savePurchase(String purchaseorder) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();
    String reqid = "";
    System.out.println("start savePurchase !");
    Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
    Map tabMap = app.findData(purchaseorder);
    JCoTable purchaseTable = (JCoTable)tabMap.get("main");

    JSONArray array = new JSONArray();
    if (purchaseTable != null)
    {
      for (int i = 0; i < purchaseTable.getNumRows(); i++) {
        String buyer = StringHelper.null2String(purchaseTable
          .getString("BUKRS"));
        String purchaseorg = StringHelper.null2String(purchaseTable
          .getString("EKORG"));
        purchaseorder = StringHelper.null2String(purchaseTable
          .getString("EBELN"));
        String purchaseitem = StringHelper.null2String(purchaseTable
          .getString("EBELP"));
        String purchasetype = StringHelper.null2String(purchaseTable
          .getString("BSART"));
        String vendorno = StringHelper.null2String(purchaseTable
          .getString("LIFNR"));
        String vendorname = StringHelper.null2String(purchaseTable
          .getString("NAME1"));
        String materialno = StringHelper.null2String(purchaseTable
          .getString("MATNR"));
        String materialdesc = StringHelper.null2String(purchaseTable
          .getString("MAKTX"));
        String plant = StringHelper.null2String(purchaseTable
          .getString("WERKS"));
        String quantity = StringHelper.null2String(purchaseTable
          .getString("MENGE"));
        String openquantity = StringHelper.null2String(purchaseTable
          .getString("LFIMG"));
        String purchunit = StringHelper.null2String(purchaseTable
          .getString("BPRME"));
        String unitoftext = StringHelper.null2String(purchaseTable
          .getString("MSEHT"));
        String deliverydate = StringHelper.null2String(purchaseTable
          .getString("EINDT"));
        String bulkflag = StringHelper.null2String(purchaseTable
          .getString("SCHGT"));
        String purchasing = StringHelper.null2String(purchaseTable
          .getString("EKGRP"));
        String materialtype = StringHelper.null2String(purchaseTable
          .getString("MTART"));
        String pruchaseno = StringHelper.null2String(purchaseTable
          .getString("BANFN"));
        String storageloc = StringHelper.null2String(purchaseTable
          .getString("LGORT"));
        String goodsgroup = StringHelper.null2String(purchaseTable
          .getString("SPART"));
        String delflag = StringHelper.null2String(purchaseTable
          .getString("LOEKZ"));
        String batchnum = StringHelper.null2String(purchaseTable
          .getString("CHARG"));
        String assetsno = StringHelper.null2String(purchaseTable
          .getString("ANLN1"));
        String deliverylimit = StringHelper.null2String(purchaseTable
          .getString("UEBTO"));

        String overmark = StringHelper.null2String(purchaseTable
          .getString("UEBTK"));
        String lacking = StringHelper.null2String(purchaseTable
          .getString("UNTTO"));
        String uploadmark = StringHelper.null2String(purchaseTable
          .getString("ZYUP"));

        String applicant = StringHelper.null2String(purchaseTable
          .getString("AFNAM"));
        String applyloc = StringHelper.null2String(purchaseTable
          .getString("LGOBE"));
        String costcentre = StringHelper.null2String(purchaseTable
          .getString("KOSTL"));
        String createman = StringHelper.null2String(purchaseTable
          .getString("NAME2"));
        String permitcode = StringHelper.null2String(purchaseTable
          .getString("ZGMZBH"));

        String purchasenum = StringHelper.null2String(purchaseTable
          .getString("ZMENGE1"));

        String purchasemid = StringHelper.null2String(purchaseTable
          .getString("ZMATNR"));

        String purchexpiry = StringHelper.null2String(purchaseTable
          .getString("ZDATELOW2"));
        String purchdeadline = StringHelper.null2String(purchaseTable
          .getString("ZDATEHIGH2"));

        String memo1 = StringHelper.null2String(purchaseTable
          .getString("BEIZHU1"));
        String memo2 = StringHelper.null2String(purchaseTable
          .getString("BEIZHU2"));
        String memo3 = StringHelper.null2String(purchaseTable
          .getString("BEIZHU3"));

        StringBuffer buffer = new StringBuffer(4096);
        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_purchase where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and purchaseorder = '" + 
          purchaseorder + 
          "' and purchaseitem = '" + 
          purchaseitem + "'");

        if (list.size() < 1) {
          buffer.append("insert into uf_lo_purchase");
          buffer.append("(id,requestid,buyer,purchaseorg,purchaseorder,purchaseitem,purchasetype,vendorno,vendorname,materialno,materialdesc,plant,quantity,openquantity,purchunit,unitoftext,deliverydate,bulkflag,purchasing,materialtype,pruchaseno,storageloc,goodsgroup,delflag,batchnum,assetsno,deliverylimit,overmark,lacking,uploadmark,vouchertype,applicant,applyloc,costcentre,createman,permitcode,citymark,transportno,purchasenum,transportnum,purchasemid,transportcomp,transportname,transexpiry,transdeadline,purchexpiry,purchdeadline,carsno,memo1,memo2,memo3,runningno,covermark,downloadtime) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(buyer).append("',");
          buffer.append("'").append(purchaseorg).append("',");
          buffer.append("'").append(purchaseorder).append("',");
          buffer.append("'").append(purchaseitem).append("',");
          buffer.append("'").append(purchasetype).append("',");
          buffer.append("'").append(vendorno).append("',");
          buffer.append("'").append(vendorname).append("',");
          buffer.append("'").append(materialno).append("',");
          buffer.append("'").append(materialdesc).append("',");
          buffer.append("'").append(plant).append("',");
          buffer.append("'").append(quantity).append("',");
          buffer.append("'").append(openquantity).append("',");
          buffer.append("'").append(purchunit).append("',");
          buffer.append("'").append(unitoftext).append("',");
          buffer.append("'").append(deliverydate).append("',");
          buffer.append("'").append(bulkflag).append("',");
          buffer.append("'").append(purchasing).append("',");
          buffer.append("'").append(materialtype).append("',");
          buffer.append("'").append(pruchaseno).append("',");
          buffer.append("'").append(storageloc).append("',");
          buffer.append("'").append(goodsgroup).append("',");
          buffer.append("'").append(delflag).append("',");
          buffer.append("'").append(batchnum).append("',");
          buffer.append("'").append(assetsno).append("',");
          buffer.append("'").append(deliverylimit).append("',");
          buffer.append("'").append(overmark).append("',");
          buffer.append("'").append(lacking).append("',");
          buffer.append("'").append(uploadmark).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(applicant).append("',");
          buffer.append("'").append(applyloc).append("',");
          buffer.append("'").append(costcentre).append("',");
          buffer.append("'").append(createman).append("',");
          buffer.append("'").append(permitcode).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(purchasenum).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(purchasemid).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(purchexpiry).append("',");
          buffer.append("'").append(purchdeadline).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(memo1).append("',");
          buffer.append("'").append(memo2).append("',");
          buffer.append("'").append(memo3).append("',");
          buffer.append("'").append(purchaseorder + purchaseitem)
            .append("',");
          buffer.append("'1',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

          FormBase formBase = new FormBase();
          String categoryid = "402864d1491b914a01491c40b48b024f";

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
            "uf_lo_purchase");
        } else {
          Map rm = (Map)list.get(0);
          reqid = StringHelper.null2String(rm.get("requestid"));
          buffer.append("update uf_lo_purchase set ");
          buffer.append("buyer='").append(buyer).append("',");
          buffer.append("purchaseorg='").append(purchaseorg)
            .append("',");
          buffer.append("purchasetype='").append(purchasetype)
            .append("',");
          buffer.append("vendorno='").append(vendorno).append("',");
          buffer.append("vendorname='").append(vendorname)
            .append("',");
          buffer.append("materialno='").append(materialno)
            .append("',");
          buffer.append("materialdesc='").append(materialdesc)
            .append("',");
          buffer.append("plant='").append(plant).append("',");
          buffer.append("quantity='").append(quantity).append("',");
          buffer.append("openquantity='").append(openquantity)
            .append("',");
          buffer.append("purchunit='").append(purchunit).append("',");
          buffer.append("unitoftext='").append(unitoftext)
            .append("',");
          buffer.append("deliverydate='").append(deliverydate)
            .append("',");
          buffer.append("bulkflag='").append(bulkflag).append("',");
          buffer.append("purchasing='").append(purchasing)
            .append("',");
          buffer.append("materialtype='").append(materialtype)
            .append("',");
          buffer.append("pruchaseno='").append(pruchaseno)
            .append("',");
          buffer.append("storageloc='").append(storageloc)
            .append("',");
          buffer.append("goodsgroup='").append(goodsgroup)
            .append("',");
          buffer.append("delflag='").append(delflag).append("',");
          buffer.append("batchnum='").append(batchnum).append("',");
          buffer.append("assetsno='").append(assetsno).append("',");
          buffer.append("deliverylimit='").append(deliverylimit)
            .append("',");
          buffer.append("overmark='").append(overmark).append("',");
          buffer.append("lacking='").append(lacking).append("',");
          buffer.append("uploadmark='").append(uploadmark)
            .append("',");

          buffer.append("applicant='").append(applicant).append("',");
          buffer.append("applyloc='").append(applyloc).append("',");
          buffer.append("costcentre='").append(costcentre)
            .append("',");
          buffer.append("createman='").append(createman).append("',");
          buffer.append("permitcode='").append(permitcode)
            .append("',");

          buffer.append("transportno='").append(purchasenum)
            .append("',");

          buffer.append("purchasemid='").append(purchasemid)
            .append("',");

          buffer.append("purchexpiry='").append(purchexpiry)
            .append("',");
          buffer.append("purchdeadline='").append(purchdeadline)
            .append("',");

          buffer.append("memo1='").append(memo1).append("',");
          buffer.append("memo2='").append(memo2).append("',");
          buffer.append("memo3='").append(memo3).append("',");
          buffer.append("downloadtime=").append(
            "to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
          buffer.append("where covermark='1' and purchaseorder = '")
            .append(purchaseorder);
          buffer.append("' and purchaseitem = '")
            .append(purchaseitem).append("'");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);

          baseJdbc.update("delete uf_lo_purchasedetail where requestid = '" + StringHelper.null2String(reqid) + "'");
        }

        JCoTable detailTable = (JCoTable)tabMap.get("detail");
        if (detailTable != null)
        {
          for (int j = 0; j < detailTable.getNumRows(); j++)
          {
            String purchaseno = StringHelper.null2String(detailTable.getString("EBELN"));

            String purchaseitems = StringHelper.null2String(detailTable.getString("EBELP"));

            String materialno2 = StringHelper.null2String(detailTable.getString("MATNR"));

            String werks = StringHelper.null2String(detailTable.getString("WERKS"));

            String demand = StringHelper.null2String(detailTable.getString("BDMNG"));

            String unit = StringHelper.null2String(detailTable.getString("MEINS"));

            String requdate = StringHelper.null2String(detailTable.getString("BDTER"));

            String lotno = StringHelper.null2String(detailTable.getString("CHARG"));

            String address = StringHelper.null2String(detailTable.getString("LGORT"));

            buffer = new StringBuffer(4096);

            buffer.append("insert into uf_lo_purchasedetail");
            buffer.append("(id,requestid,rowindex,purchaseno,purchaseitems,materielno,werks,demand,unit,requdate,lotno,address) values");
            buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
            buffer.append("'").append(StringHelper.null2String(reqid)).append("',");
            buffer.append("'").append(StringHelper.specifiedLengthForInt(j, 3)).append("',");

            buffer.append("'").append(purchaseno).append("',");
            buffer.append("'").append(purchaseitems).append("',");
            buffer.append("'").append(materialno2).append("',");
            buffer.append("'").append(werks).append("',");
            buffer.append("'").append(demand).append("',");
            buffer.append("'").append(unit).append("',");
            buffer.append("'").append(requdate).append("',");
            buffer.append("'").append(lotno).append("',");
            buffer.append("'").append(address).append("')");

            baseJdbc.update(buffer.toString());

            detailTable.nextRow();
          }
        }

        purchaseTable.nextRow();
      }
    }

    System.out.println("end savePurchase !");
  }

  public void updatePurchase(String purchaseorder)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();
    String reqid = "";
    System.out.println("start updatePurchase !");
    Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
    Map tabMap = app.findData(purchaseorder);
    JCoTable purchaseTable = (JCoTable)tabMap.get("main");

    JSONArray array = new JSONArray();
    if (purchaseTable != null)
    {
      for (int i = 0; i < purchaseTable.getNumRows(); i++) {
        String buyer = StringHelper.null2String(purchaseTable
          .getString("BUKRS"));
        String purchaseorg = StringHelper.null2String(purchaseTable
          .getString("EKORG"));
        purchaseorder = StringHelper.null2String(purchaseTable
          .getString("EBELN"));
        String purchaseitem = StringHelper.null2String(purchaseTable
          .getString("EBELP"));
        String purchasetype = StringHelper.null2String(purchaseTable
          .getString("BSART"));
        String vendorno = StringHelper.null2String(purchaseTable
          .getString("LIFNR"));
        String vendorname = StringHelper.null2String(purchaseTable
          .getString("NAME1"));
        String materialno = StringHelper.null2String(purchaseTable
          .getString("MATNR"));
        String materialdesc = StringHelper.null2String(purchaseTable
          .getString("MAKTX"));
        String plant = StringHelper.null2String(purchaseTable
          .getString("WERKS"));
        String quantity = StringHelper.null2String(purchaseTable
          .getString("MENGE"));
        String openquantity = StringHelper.null2String(purchaseTable
          .getString("LFIMG"));
        String purchunit = StringHelper.null2String(purchaseTable
          .getString("BPRME"));
        String unitoftext = StringHelper.null2String(purchaseTable
          .getString("MSEHT"));
        String deliverydate = StringHelper.null2String(purchaseTable
          .getString("EINDT"));
        String bulkflag = StringHelper.null2String(purchaseTable
          .getString("SCHGT"));
        String purchasing = StringHelper.null2String(purchaseTable
          .getString("EKGRP"));
        String materialtype = StringHelper.null2String(purchaseTable
          .getString("MTART"));
        String pruchaseno = StringHelper.null2String(purchaseTable
          .getString("BANFN"));
        String storageloc = StringHelper.null2String(purchaseTable
          .getString("LGORT"));
        String goodsgroup = StringHelper.null2String(purchaseTable
          .getString("SPART"));
        String delflag = StringHelper.null2String(purchaseTable
          .getString("LOEKZ"));
        String batchnum = StringHelper.null2String(purchaseTable
          .getString("CHARG"));
        String assetsno = StringHelper.null2String(purchaseTable
          .getString("ANLN1"));
        String deliverylimit = StringHelper.null2String(purchaseTable
          .getString("UEBTO"));

        String overmark = StringHelper.null2String(purchaseTable
          .getString("UEBTK"));
        String lacking = StringHelper.null2String(purchaseTable
          .getString("UNTTO"));
        String uploadmark = StringHelper.null2String(purchaseTable
          .getString("ZYUP"));

        String applicant = StringHelper.null2String(purchaseTable
          .getString("AFNAM"));
        String applyloc = StringHelper.null2String(purchaseTable
          .getString("LGOBE"));
        String costcentre = StringHelper.null2String(purchaseTable
          .getString("KOSTL"));
        String createman = StringHelper.null2String(purchaseTable
          .getString("NAME2"));
        String permitcode = StringHelper.null2String(purchaseTable
          .getString("ZGMZBH"));

        String purchasenum = StringHelper.null2String(purchaseTable
          .getString("ZMENGE1"));

        String purchasemid = StringHelper.null2String(purchaseTable
          .getString("ZMATNR"));

        String purchexpiry = StringHelper.null2String(purchaseTable
          .getString("ZDATELOW2"));
        String purchdeadline = StringHelper.null2String(purchaseTable
          .getString("ZDATEHIGH2"));

        String memo1 = StringHelper.null2String(purchaseTable
          .getString("BEIZHU1"));
        String memo2 = StringHelper.null2String(purchaseTable
          .getString("BEIZHU2"));
        String memo3 = StringHelper.null2String(purchaseTable
          .getString("BEIZHU3"));

        StringBuffer buffer = new StringBuffer(4096);
        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_purchase where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and purchaseorder = '" + 
          purchaseorder + 
          "' and purchaseitem = '" + 
          purchaseitem + "'");

        if (list.size() < 1) {
          buffer.append("insert into uf_lo_purchase");
          buffer.append("(id,requestid,buyer,purchaseorg,purchaseorder,purchaseitem,purchasetype,vendorno,vendorname,materialno,materialdesc,plant,quantity,openquantity,purchunit,unitoftext,deliverydate,bulkflag,purchasing,materialtype,pruchaseno,storageloc,goodsgroup,delflag,batchnum,assetsno,deliverylimit,overmark,lacking,uploadmark,vouchertype,applicant,applyloc,costcentre,createman,permitcode,citymark,transportno,purchasenum,transportnum,purchasemid,transportcomp,transportname,transexpiry,transdeadline,purchexpiry,purchdeadline,carsno,memo1,memo2,memo3,runningno,covermark,downloadtime) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(buyer).append("',");
          buffer.append("'").append(purchaseorg).append("',");
          buffer.append("'").append(purchaseorder).append("',");
          buffer.append("'").append(purchaseitem).append("',");
          buffer.append("'").append(purchasetype).append("',");
          buffer.append("'").append(vendorno).append("',");
          buffer.append("'").append(vendorname).append("',");
          buffer.append("'").append(materialno).append("',");
          buffer.append("'").append(materialdesc).append("',");
          buffer.append("'").append(plant).append("',");
          buffer.append("'").append(quantity).append("',");
          buffer.append("'").append(openquantity).append("',");
          buffer.append("'").append(purchunit).append("',");
          buffer.append("'").append(unitoftext).append("',");
          buffer.append("'").append(deliverydate).append("',");
          buffer.append("'").append(bulkflag).append("',");
          buffer.append("'").append(purchasing).append("',");
          buffer.append("'").append(materialtype).append("',");
          buffer.append("'").append(pruchaseno).append("',");
          buffer.append("'").append(storageloc).append("',");
          buffer.append("'").append(goodsgroup).append("',");
          buffer.append("'").append(delflag).append("',");
          buffer.append("'").append(batchnum).append("',");
          buffer.append("'").append(assetsno).append("',");
          buffer.append("'").append(deliverylimit).append("',");
          buffer.append("'").append(overmark).append("',");
          buffer.append("'").append(lacking).append("',");
          buffer.append("'").append(uploadmark).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(applicant).append("',");
          buffer.append("'").append(applyloc).append("',");
          buffer.append("'").append(costcentre).append("',");
          buffer.append("'").append(createman).append("',");
          buffer.append("'").append(permitcode).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(purchasenum).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(purchasemid).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(purchexpiry).append("',");
          buffer.append("'").append(purchdeadline).append("',");
          buffer.append("'").append("").append("',");
          buffer.append("'").append(memo1).append("',");
          buffer.append("'").append(memo2).append("',");
          buffer.append("'").append(memo3).append("',");
          buffer.append("'").append(purchaseorder + purchaseitem)
            .append("',");
          buffer.append("'0',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

          FormBase formBase = new FormBase();
          String categoryid = "402864d1491b914a01491c40b48b024f";

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
            "uf_lo_purchase");
        } else {
          Map rm = (Map)list.get(0);
          reqid = StringHelper.null2String(rm.get("requestid"));

          buffer.append("update uf_lo_purchase set ");
          buffer.append("buyer='").append(buyer).append("',");
          buffer.append("purchaseorg='").append(purchaseorg)
            .append("',");
          buffer.append("purchasetype='").append(purchasetype)
            .append("',");
          buffer.append("vendorno='").append(vendorno).append("',");
          buffer.append("vendorname='").append(vendorname)
            .append("',");
          buffer.append("materialno='").append(materialno)
            .append("',");
          buffer.append("materialdesc='").append(materialdesc)
            .append("',");
          buffer.append("plant='").append(plant).append("',");
          buffer.append("quantity='").append(quantity).append("',");
          buffer.append("openquantity='").append(openquantity)
            .append("',");
          buffer.append("purchunit='").append(purchunit).append("',");
          buffer.append("unitoftext='").append(unitoftext)
            .append("',");
          buffer.append("deliverydate='").append(deliverydate)
            .append("',");
          buffer.append("bulkflag='").append(bulkflag).append("',");
          buffer.append("purchasing='").append(purchasing)
            .append("',");
          buffer.append("materialtype='").append(materialtype)
            .append("',");
          buffer.append("pruchaseno='").append(pruchaseno)
            .append("',");
          buffer.append("storageloc='").append(storageloc)
            .append("',");
          buffer.append("goodsgroup='").append(goodsgroup)
            .append("',");
          buffer.append("delflag='").append(delflag).append("',");
          buffer.append("batchnum='").append(batchnum).append("',");
          buffer.append("assetsno='").append(assetsno).append("',");
          buffer.append("deliverylimit='").append(deliverylimit)
            .append("',");
          buffer.append("overmark='").append(overmark).append("',");
          buffer.append("lacking='").append(lacking).append("',");
          buffer.append("uploadmark='").append(uploadmark)
            .append("',");

          buffer.append("applicant='").append(applicant).append("',");
          buffer.append("applyloc='").append(applyloc).append("',");
          buffer.append("costcentre='").append(costcentre)
            .append("',");
          buffer.append("createman='").append(createman).append("',");
          buffer.append("permitcode='").append(permitcode)
            .append("',");

          buffer.append("transportno='").append(purchasenum)
            .append("',");

          buffer.append("purchasemid='").append(purchasemid)
            .append("',");

          buffer.append("purchexpiry='").append(purchexpiry)
            .append("',");
          buffer.append("purchdeadline='").append(purchdeadline)
            .append("',");

          buffer.append("memo1='").append(memo1).append("',");
          buffer.append("memo2='").append(memo2).append("',");
          buffer.append("memo3='").append(memo3).append("',");
          buffer.append("downloadtime=").append(
            "to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
          buffer.append("where purchaseorder = '")
            .append(purchaseorder);
          buffer.append("' and purchaseitem = '")
            .append(purchaseitem).append("'");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);

          baseJdbc.update("delete uf_lo_purchasedetail where requestid = '" + StringHelper.null2String(reqid) + "'");
        }

        JCoTable detailTable = (JCoTable)tabMap.get("detail");
        if (detailTable != null)
        {
          for (int j = 0; j < detailTable.getNumRows(); j++)
          {
            String purchaseno = StringHelper.null2String(detailTable.getString("EBELN"));

            String purchaseitems = StringHelper.null2String(detailTable.getString("EBELP"));

            String materialno2 = StringHelper.null2String(detailTable.getString("MATNR"));

            String werks = StringHelper.null2String(detailTable.getString("WERKS"));

            String demand = StringHelper.null2String(detailTable.getString("BDMNG"));

            String unit = StringHelper.null2String(detailTable.getString("MEINS"));

            String requdate = StringHelper.null2String(detailTable.getString("BDTER"));

            String lotno = StringHelper.null2String(detailTable.getString("CHARG"));

            String address = StringHelper.null2String(detailTable.getString("LGORT"));

            buffer = new StringBuffer(4096);

            buffer.append("insert into uf_lo_purchasedetail");
            buffer.append("(id,requestid,rowindex,purchaseno,purchaseitems,materielno,werks,demand,unit,requdate,lotno,address) values");
            buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
            buffer.append("'").append(StringHelper.null2String(reqid)).append("',");
            buffer.append("'").append(StringHelper.specifiedLengthForInt(j, 3)).append("',");

            buffer.append("'").append(purchaseno).append("',");
            buffer.append("'").append(purchaseitems).append("',");
            buffer.append("'").append(materialno2).append("',");
            buffer.append("'").append(werks).append("',");
            buffer.append("'").append(demand).append("',");
            buffer.append("'").append(unit).append("',");
            buffer.append("'").append(requdate).append("',");
            buffer.append("'").append(lotno).append("',");
            buffer.append("'").append(address).append("')");

            baseJdbc.update(buffer.toString());

            detailTable.nextRow();
          }
        }

        purchaseTable.nextRow();
      }
    }

    System.out.println("end updatePurchase !");
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