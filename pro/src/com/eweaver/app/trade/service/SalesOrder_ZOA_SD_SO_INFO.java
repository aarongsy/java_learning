package com.eweaver.app.trade.service;

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

public class SalesOrder_ZOA_SD_SO_INFO
{
  public String functionname;

  public SalesOrder_ZOA_SD_SO_INFO(String functionname)
  {
    setFunctionname(functionname);
  }

  public Map<String, String> findData(String vbeln) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      Map retMap = new HashMap();
      String functionName = "ZOA_SD_SO_INFO";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("VBELN", vbeln);

      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();

      retMap.put("vbeln", vbeln);
      retMap.put("auart", StringHelper.null2String(function.getExportParameterList().getValue("AUART")));
      retMap.put("typed", StringHelper.null2String(function.getExportParameterList().getValue("TYPED")));
      retMap.put("bstnk", StringHelper.null2String(function.getExportParameterList().getValue("BSTNK")));
      retMap.put("prctr", StringHelper.null2String(function.getExportParameterList().getValue("PRCTR")));
      retMap.put("bukrs_vf", StringHelper.null2String(function.getExportParameterList().getValue("BUKRS_VF")));
      retMap.put("butxt", StringHelper.null2String(function.getExportParameterList().getValue("BUTXT")));
      retMap.put("sdabw", StringHelper.null2String(function.getExportParameterList().getValue("SDABW")));
      retMap.put("specd", StringHelper.null2String(function.getExportParameterList().getValue("SPECD")));
      retMap.put("kunnr", StringHelper.null2String(function.getExportParameterList().getValue("KUNNR")));
      retMap.put("name1", StringHelper.null2String(function.getExportParameterList().getValue("NAME1")));
      retMap.put("land1", StringHelper.null2String(function.getExportParameterList().getValue("LAND1")));
      retMap.put("stras1", StringHelper.null2String(function.getExportParameterList().getValue("STRAS1")));
      retMap.put("sunnr", StringHelper.null2String(function.getExportParameterList().getValue("SUNNR")));
      retMap.put("name2", StringHelper.null2String(function.getExportParameterList().getValue("NAME2")));
      retMap.put("land2", StringHelper.null2String(function.getExportParameterList().getValue("LAND2")));
      retMap.put("stras2", StringHelper.null2String(function.getExportParameterList().getValue("STRAS2")));
      retMap.put("zterm", StringHelper.null2String(function.getExportParameterList().getValue("ZTERM")));
      retMap.put("text1", StringHelper.null2String(function.getExportParameterList().getValue("TEXT1")));
      retMap.put("inco1", StringHelper.null2String(function.getExportParameterList().getValue("INCO1")));
      retMap.put("bezei", StringHelper.null2String(function.getExportParameterList().getValue("BEZEI")));
      retMap.put("inco2", StringHelper.null2String(function.getExportParameterList().getValue("INCO2")));
      retMap.put("waerk", StringHelper.null2String(function.getExportParameterList().getValue("WAERK")));
      retMap.put("zlsch", StringHelper.null2String(function.getExportParameterList().getValue("ZLSCH")));
      retMap.put("text2", StringHelper.null2String(function.getExportParameterList().getValue("TEXT2")));

      return retMap;
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }
  public JCoTable findDetail(String vbeln) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      Map retMap = new HashMap();
      String functionName = "ZOA_SD_SO_INFO";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("VBELN", vbeln);

      function.execute(
        SapConnector.getDestination("sanpowersap"));

      return function.getTableParameterList().getTable("SD_SO_ITEMS");
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }

    return null;
  }
  public void saveSaleOrder(String vbeln) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();
    SalesOrder_ZOA_SD_SO_INFO app = new SalesOrder_ZOA_SD_SO_INFO(
      "ZOA_SD_SO_INFO");
    Map salesMap = app.findData(vbeln);
    JCoTable salesTable = app.findDetail(vbeln);

    StringBuffer buffer = new StringBuffer(4096);
    if (salesMap != null) {
      List list = baseJdbc
        .executeSqlForList("select * from uf_tr_salesorder where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and orderno = '" + 
        (String)salesMap.get("vbeln") + "'");

      if (list.size() < 1)
      {
        buffer.append("insert into uf_tr_salesorder");
        buffer.append("(id,requestid,orderno,companycode,company,factory,auart,typed,bstnk,prctr,sdabw,specd,kunnr,name1,land1,stras1,sunnr,name2,land2,stras2,zterm,text1,inco1,bezei,inco2,waers,zlsch,text2,covermark,downloadtime) values");

        buffer.append("('").append(IDGernerator.getUnquieID())
          .append("',");
        buffer.append("'").append("$ewrequestid$").append("',");
        buffer.append("'").append((String)salesMap.get("vbeln")).append("',");
        buffer.append("'").append((String)salesMap.get("bukrs_vf")).append("',");
        buffer.append("'").append((String)salesMap.get("butxt")).append("',");

        buffer.append("(select id from orgunittype where id=(select typeid from orgunit where isdelete = 0 and objno='")
          .append((String)salesMap.get("bukrs_vf"))
          .append("')),");
        buffer.append("'").append((String)salesMap.get("auart")).append("',");
        buffer.append("'").append((String)salesMap.get("typed")).append("',");
        buffer.append("'").append((String)salesMap.get("bstnk")).append("',");
        buffer.append("'").append((String)salesMap.get("prctr")).append("',");
        buffer.append("'").append((String)salesMap.get("sdabw")).append("',");
        buffer.append("'").append((String)salesMap.get("specd")).append("',");
        buffer.append("'").append((String)salesMap.get("kunnr")).append("',");
        buffer.append("'").append((String)salesMap.get("name1")).append("',");
        buffer.append("'").append((String)salesMap.get("land1")).append("',");
        buffer.append("'").append((String)salesMap.get("stras1")).append("',");
        buffer.append("'").append((String)salesMap.get("sunnr")).append("',");
        buffer.append("'").append((String)salesMap.get("name2")).append("',");
        buffer.append("'").append((String)salesMap.get("land2")).append("',");
        buffer.append("'").append((String)salesMap.get("stras2")).append("',");
        buffer.append("'").append((String)salesMap.get("zterm")).append("',");
        buffer.append("'").append((String)salesMap.get("text1")).append("',");
        buffer.append("'").append((String)salesMap.get("inco1")).append("',");
        buffer.append("'").append((String)salesMap.get("bezei")).append("',");
        buffer.append("'").append((String)salesMap.get("inco2")).append("',");
        buffer.append("'").append((String)salesMap.get("waerk")).append("',");
        buffer.append("'").append((String)salesMap.get("zlsch")).append("',");
        buffer.append("'").append((String)salesMap.get("text2")).append("',");
        buffer.append("'0',");
        buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");

        FormBase formBase = new FormBase();
        String categoryid = "40285a904931f62b01493c1057805593";

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
          "uf_tr_salesorder");

        for (int j = 0; j < salesTable.getNumRows(); j++)
        {
          String posnr = StringHelper.null2String(salesTable.getString("POSNR"));
          String matnr = StringHelper.null2String(salesTable.getString("MATNR"));
          String kwmeng = StringHelper.null2String(salesTable.getString("KWMENG"));
          String vrkme = StringHelper.null2String(salesTable.getString("VRKME"));
          String arktx = StringHelper.null2String(salesTable.getString("ARKTX"));
          String aeskd = StringHelper.null2String(salesTable.getString("AESKD"));
          String lgort = StringHelper.null2String(salesTable.getString("LGORT"));
          String charg = StringHelper.null2String(salesTable.getString("CHARG"));
          String vdatu = StringHelper.null2String(salesTable.getString("VDATU"));
          String klmeng = StringHelper.null2String(salesTable.getString("KLMENG"));
          String meins = StringHelper.null2String(salesTable.getString("MEINS"));
          String netpr = StringHelper.null2String(salesTable.getString("NETPR"));
          String netwr = StringHelper.null2String(salesTable.getString("NETWR"));
          String maktx = StringHelper.null2String(salesTable.getString("MAKTX"));
          String kwert = StringHelper.null2String(salesTable.getString("KWERT"));

          String rowindex = "0" + j;
          if (rowindex.length() == 2)
            rowindex = "0" + rowindex;
          else if (rowindex.length() > 3) {
            rowindex = rowindex.substring(rowindex.length() - 3);
          }

          buffer = new StringBuffer(4096);
          buffer.append("insert into uf_tr_saleslist");
          buffer.append("(id,requestid,rowindex,vbeln,posnr,matnr,kwmeng,vrkme,arktx,aeskd,lgort,charg,vdatu,klmeng,meins,netpr,netwr,maktx,kwert) values");

          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(rowindex).append("',");
          buffer.append("'").append(vbeln).append("',");
          buffer.append("'").append(posnr).append("',");
          buffer.append("'").append(matnr).append("',");
          buffer.append("'").append(kwmeng).append("',");
          buffer.append("'").append(vrkme).append("',");
          buffer.append("'").append(arktx).append("',");
          buffer.append("'").append(aeskd).append("',");
          buffer.append("'").append(lgort).append("',");
          buffer.append("'").append(charg).append("',");
          buffer.append("'").append(vdatu).append("',");
          buffer.append("'").append(klmeng).append("',");
          buffer.append("'").append(meins).append("',");
          buffer.append("'").append(netpr).append("',");
          buffer.append("'").append(netwr).append("',");
          buffer.append("'").append(maktx).append("',");
          buffer.append("'").append(kwert).append("')");

          insertSql = buffer.toString();
          insertSql = insertSql.replace("$ewrequestid$", 
            formBase.getId());
          baseJdbc.update(insertSql);

          salesTable.nextRow();
        }
      } else {
        buffer.append("update uf_tr_salesorder set ");
        buffer.append("company=(select id from orgunit where isdelete = 0 and objno='")
          .append((String)salesMap.get("bukrs_vf"))
          .append("'),");
        buffer.append("factory=(select id from orgunittype where id=(select typeid from orgunit where isdelete = 0 and objno='")
          .append((String)salesMap.get("bukrs_vf"))
          .append("')),");
        buffer.append("auart='").append((String)salesMap.get("auart")).append("', ");
        buffer.append("typed='").append((String)salesMap.get("typed")).append("', ");
        buffer.append("bstnk='").append((String)salesMap.get("bstnk")).append("', ");
        buffer.append("prctr='").append((String)salesMap.get("prctr")).append("', ");
        buffer.append("sdabw='").append((String)salesMap.get("sdabw")).append("', ");
        buffer.append("specd='").append((String)salesMap.get("specd")).append("', ");
        buffer.append("kunnr='").append((String)salesMap.get("kunnr")).append("', ");
        buffer.append("name1='").append((String)salesMap.get("name1")).append("', ");
        buffer.append("land1='").append((String)salesMap.get("land1")).append("', ");
        buffer.append("stras1='").append((String)salesMap.get("stras1")).append("', ");
        buffer.append("sunnr='").append((String)salesMap.get("sunnr")).append("', ");
        buffer.append("name2='").append((String)salesMap.get("name2")).append("', ");
        buffer.append("land2='").append((String)salesMap.get("land2")).append("', ");
        buffer.append("stras2='").append((String)salesMap.get("stras2")).append("', ");
        buffer.append("zterm='").append((String)salesMap.get("zterm")).append("', ");
        buffer.append("text1='").append((String)salesMap.get("text1")).append("', ");
        buffer.append("inco1='").append((String)salesMap.get("inco1")).append("', ");
        buffer.append("bezei='").append((String)salesMap.get("bezei")).append("', ");
        buffer.append("inco2='").append((String)salesMap.get("inco2")).append("', ");
        buffer.append("waers='").append((String)salesMap.get("waerk")).append("', ");
        buffer.append("zlsch='").append((String)salesMap.get("zlsch")).append("', ");
        buffer.append("text2='").append((String)salesMap.get("text2")).append("', ");
        buffer.append("downloadtime=to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");

        buffer.append("where covermark = '1' and orderno = '").append(vbeln).append("'");

        String insertSql = buffer.toString();
        int isup = baseJdbc.update(insertSql);
        if (isup == 1) {
          String reqid = ds.getValue("select requestid from uf_tr_salesorder a where orderno = '" + vbeln + "' and exists(select 1 from formbase where a.requestid = id and isdelete <> 1)");
          baseJdbc.update("delete uf_tr_saleslist where requestid = '" + reqid + "'");

          for (int j = 0; j < salesTable.getNumRows(); j++)
          {
            String posnr = StringHelper.null2String(salesTable.getString("POSNR"));
            String matnr = StringHelper.null2String(salesTable.getString("MATNR"));
            String kwmeng = StringHelper.null2String(salesTable.getString("KWMENG"));
            String vrkme = StringHelper.null2String(salesTable.getString("VRKME"));
            String arktx = StringHelper.null2String(salesTable.getString("ARKTX"));
            String aeskd = StringHelper.null2String(salesTable.getString("AESKD"));
            String lgort = StringHelper.null2String(salesTable.getString("LGORT"));
            String charg = StringHelper.null2String(salesTable.getString("CHARG"));
            String vdatu = StringHelper.null2String(salesTable.getString("VDATU"));
            String klmeng = StringHelper.null2String(salesTable.getString("KLMENG"));
            String meins = StringHelper.null2String(salesTable.getString("MEINS"));
            String netpr = StringHelper.null2String(salesTable.getString("NETPR"));
            String netwr = StringHelper.null2String(salesTable.getString("NETWR"));
            String maktx = StringHelper.null2String(salesTable.getString("MAKTX"));
            String kwert = StringHelper.null2String(salesTable.getString("KWERT"));

            String rowindex = "0" + j;
            if (rowindex.length() == 2)
              rowindex = "0" + rowindex;
            else if (rowindex.length() > 3) {
              rowindex = rowindex.substring(rowindex.length() - 3);
            }

            buffer = new StringBuffer(4096);
            buffer.append("insert into uf_tr_saleslist");
            buffer.append("(id,requestid,rowindex,vbeln,posnr,matnr,kwmeng,vrkme,arktx,aeskd,lgort,charg,vdatu,klmeng,meins,netpr,netwr,maktx,kwert) values");

            buffer.append("('").append(IDGernerator.getUnquieID())
              .append("',");
            buffer.append("'").append(reqid).append("',");
            buffer.append("'").append(rowindex).append("',");
            buffer.append("'").append(vbeln).append("',");
            buffer.append("'").append(posnr).append("',");
            buffer.append("'").append(matnr).append("',");
            buffer.append("'").append(kwmeng).append("',");
            buffer.append("'").append(vrkme).append("',");
            buffer.append("'").append(arktx).append("',");
            buffer.append("'").append(aeskd).append("',");
            buffer.append("'").append(lgort).append("',");
            buffer.append("'").append(charg).append("',");
            buffer.append("'").append(vdatu).append("',");
            buffer.append("'").append(klmeng).append("',");
            buffer.append("'").append(meins).append("',");
            buffer.append("'").append(netpr).append("',");
            buffer.append("'").append(netwr).append("',");
            buffer.append("'").append(maktx).append("',");
            buffer.append("'").append(kwert).append("')");

            insertSql = buffer.toString();
            baseJdbc.update(insertSql);

            salesTable.nextRow();
          }
        }
      }
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