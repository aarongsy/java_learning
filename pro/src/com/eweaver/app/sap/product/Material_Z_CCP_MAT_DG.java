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

public class Material_Z_CCP_MAT_DG
{
  public String functionname;

  public static void main(String[] str)
  {
    Material_Z_CCP_MAT_DG app = new Material_Z_CCP_MAT_DG(
      "Z_CCP_MAT_DG");
    app.findData("", "", "");
  }

  public Material_Z_CCP_MAT_DG(String functionname)
  {
    setFunctionname(functionname);
  }

  public Map<String, JCoTable> findData(String material)
  {
    return findData(material, "1010", "1");
  }

  public Map<String, JCoTable> findData(String material, String plant, String bom_usage) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "Z_CCP_MAT_DG";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("MATERIAL", material);
      function.getImportParameterList().setValue("PLANT", plant);
      function.getImportParameterList().setValue("BOM_USAGE", bom_usage);

      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();
      Map retMap = new HashMap();
      retMap.put("main", function.getTableParameterList().getTable("T_STKO"));
      retMap.put("detail", function.getTableParameterList().getTable("T_STPO"));
      return retMap;
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public void saveMaterial(String material, String plant, String bom_usage) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String userId = BaseContext.getRemoteUser().getId();

    Material_Z_CCP_MAT_DG app = new Material_Z_CCP_MAT_DG(
      "Z_CCP_MAT_DG");

    Map materialMap = app.findData(material, plant, bom_usage);
    JCoTable mainTable = (JCoTable)materialMap.get("main");
    JCoTable detailTable = (JCoTable)materialMap.get("detail");
    JSONArray array = new JSONArray();
    if (mainTable != null)
      for (int i = 0; i < mainTable.getNumRows(); i++)
      {
        String packcode = StringHelper.null2String(mainTable
          .getString("MATNR"));
        String packname = StringHelper.null2String(mainTable
          .getString("MAKTX"));
        String packnum = StringHelper.null2String(mainTable
          .getString("QUAN"));
        String packunit = StringHelper.null2String(mainTable
          .getString("UNIT"));

        StringBuffer buffer = new StringBuffer(512);

        List list = baseJdbc
          .executeSqlForList("select * from uf_lo_packmain where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and packcode = '" + 
          packcode + "'");

        if (list.size() < 1) {
          buffer.append("insert into uf_lo_packmain");
          buffer.append("(id,requestid,packcode,packname,packnum,packunit,editdate) values");
          buffer.append("('").append(IDGernerator.getUnquieID())
            .append("',");
          buffer.append("'").append("$ewrequestid$").append("',");
          buffer.append("'").append(packcode).append("',");
          buffer.append("'").append(packname).append("',");
          buffer.append("'").append(packnum).append("',");
          buffer.append("'").append(packunit).append("',");
          buffer.append("to_char(sysdate,'yyyy-MM-dd'))");

          FormBase formBase = new FormBase();
          String categoryid = "402864d1491b914a01491ce95a9302f3";

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
            "uf_lo_packmain");

          for (int j = 0; j < detailTable.getNumRows(); j++) {
            String pmno = StringHelper.null2String(mainTable
              .getString("MATNR"));
            String pmname = StringHelper.null2String(mainTable
              .getString("MAKTX"));
            String pmnum = StringHelper.null2String(mainTable
              .getString("QUAN"));
            String pmunit = StringHelper.null2String(mainTable
              .getString("UNIT"));
            String rowindex = "0" + j;
            if (rowindex.length() == 2)
              rowindex = "0" + rowindex;
            else if (rowindex.length() > 3) {
              rowindex = rowindex.substring(rowindex.length() - 3);
            }
            buffer = new StringBuffer(512);

            buffer.append("insert into uf_lo_packdetail");
            buffer.append("(id,requestid,rowindex,seqno,pmno,pmname,pmnum,pmunit) values");
            buffer.append("('").append(IDGernerator.getUnquieID())
              .append("',");
            buffer.append("'").append("$ewrequestid$").append("',");
            buffer.append("'").append(rowindex).append("',");
            buffer.append("'").append(j).append("',");
            buffer.append("'").append(pmno).append("',");
            buffer.append("'").append(pmname).append("',");
            buffer.append("'").append(pmnum).append("',");
            buffer.append("'").append(pmunit).append("')");

            insertSql = buffer.toString();
            insertSql = insertSql.replace("$ewrequestid$", 
              formBase.getId());
            baseJdbc.update(insertSql);

            detailTable.nextRow();
          }
        }
        else {
          buffer.append("update uf_lo_packmain set ");
          buffer.append("packname='").append(packname).append("',");
          buffer.append("packnum='").append(packnum).append("',");
          buffer.append("packunit='").append(packunit).append("',");
          buffer.append("editdate=").append("to_char(sysdate,'yyyy-MM-dd') ");
          buffer.append("where packcode = '").append(packcode).append("'");

          String insertSql = buffer.toString();
          int isup = baseJdbc.update(insertSql);
          if (isup == 1) {
            String reqid = ds.getValue("select requestid from uf_lo_packmain a where packcode = '" + packcode + "' and exists(select 1 from formbase where a.requestid = id and isdelete <> 1)");
            baseJdbc.update("delete uf_lo_packdetail where requestid = '" + reqid + "'");

            for (int j = 0; j < detailTable.getNumRows(); j++) {
              String pmno = StringHelper.null2String(mainTable
                .getString("MATNR"));
              String pmname = StringHelper.null2String(mainTable
                .getString("MAKTX"));
              String pmnum = StringHelper.null2String(mainTable
                .getString("QUAN"));
              String pmunit = StringHelper.null2String(mainTable
                .getString("UNIT"));
              String rowindex = "0" + j;
              if (rowindex.length() == 2)
                rowindex = "0" + rowindex;
              else if (rowindex.length() > 3) {
                rowindex = rowindex.substring(rowindex.length() - 3);
              }
              buffer = new StringBuffer(512);

              buffer.append("insert into uf_lo_packdetail");
              buffer.append("(id,requestid,rowindex,seqno,pmno,pmname,pmnum,pmunit) values");
              buffer.append("('").append(IDGernerator.getUnquieID())
                .append("',");
              buffer.append("'").append(reqid).append("',");
              buffer.append("'").append(rowindex).append("',");
              buffer.append("'").append(j).append("',");
              buffer.append("'").append(pmno).append("',");
              buffer.append("'").append(pmname).append("',");
              buffer.append("'").append(pmnum).append("',");
              buffer.append("'").append(pmunit).append("')");

              insertSql = buffer.toString();
              baseJdbc.update(insertSql);

              detailTable.nextRow();
            }
          }
        }

        mainTable.nextRow();
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