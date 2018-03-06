package com.eweaver.app.autotask;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class CreateYCXFK
{
  public void doAction()
  {
    try
    {
      System.out.println("com.eweaver.app.autotask.CreateYCXFK..start..");
      BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
      baseJdbc.update("delete uf_fn_wkoneoffpay where requestid is null");
      baseJdbc.update("delete uf_fn_wkdividpay where requestid is null");

      Date dt = new Date();
      SimpleDateFormat matter1 = new SimpleDateFormat("yyyy-MM-dd");
      String curdate = matter1.format(dt);

      Calendar c = Calendar.getInstance();
      c.add(5, -1);
      SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      String mDateTime = formatter.format(c.getTime());
      String tyear = mDateTime.substring(0, 4);
      String tmonth = mDateTime.substring(5, 7);
      String tday = mDateTime.substring(8, 10);
      String thedate = tyear + tmonth + tday;
      System.out.println("thedate" + thedate);

      SapConnector sapConnector = new SapConnector();
      String functionName = "ZOA_MM_PAYMENT_AUTO1";
      JCoFunction function = null;
      try
      {
        function = SapConnector.getRfcFunction(functionName);
      }
      catch (Exception e)
      {
        e.printStackTrace();
      }

      function.getImportParameterList().setValue("P_DATE", thedate);
      try
      {
        function.execute(SapConnector.getDestination("sanpowersap"));
      }
      catch (JCoException e)
      {
        e.printStackTrace();
      }
      catch (Exception e)
      {
        e.printStackTrace();
      }

      JCoTable newretTable = function.getTableParameterList().getTable("ZOA_PO_2");

      if (newretTable.getNumRows() > 0)
      {
        for (int j = 0; j < newretTable.getNumRows(); j++)
        {
          String tmpid = IDGernerator.getUnquieID();
          int tnumber = j + 1;
          if (j == 0)
          {
            newretTable.firstRow();
          }
          else
          {
            newretTable.nextRow();
          }

          String types = newretTable.getString("BSART");
          String ponorder = newretTable.getString("EBELN");
          //String itemss = newretTable.getString("EBELP");
          String markss = newretTable.getString("ZTERM");
		  String text = newretTable.getString("TXZ01");
          String names = newretTable.getString("AFNAM");

          if (markss.equals("EZG4")||markss.equals("EZG5")||markss.equals("EZGT")||markss.equals("EZGP")||markss.equals("EZGQ")||markss.equals("EZGR")||markss.equals("EZGI")||markss.equals("EZGJ")||markss.equals("EZGF")||markss.equals("EZGG")||markss.equals("EZGC")||markss.equals("EZGD")||markss.equals("EZGM"))
          {
			String upsql1 = "insert into uf_fn_wkdividpay(id,requestid,purchorder,types,title,itemss)values('" + tmpid + "','','" + ponorder + "','" + types + "','" + text + "','" + names + "')";
            System.out.println("CreateYCXFK upsql1=" + upsql1);
            baseJdbc.update(upsql1);
            String sql1 = "select distinct(purchorder) purchaseno,types from uf_fn_wkdividpay where requestid is null";
            List tlist1 = baseJdbc.executeSqlForList(sql1);
            if (tlist1.size() > 0)
            {
              for (int i = 0; i < tlist1.size(); i++)
              {
                Map map1 = (Map)tlist1.get(i);
                String txt2 = StringHelper.null2String(map1.get("types"));
                String qgmanager = "";
                String managername = "";
                String cdept = "";
                String qgdept = "";
                String ysql = "select purmanager,purdept,(select objname from humres where id=a.purmanager)txtname,(select objname from orgunit where id=a.purdept)txtdept from uf_oa_purtypemanager a where a.purtype='" + txt2 + "'";
                System.out.println("CreateYCXFK ysql=" + ysql);
                List ylist = baseJdbc.executeSqlForList(ysql);
                if (ylist.size() > 0)
                {
                  Map ymap = (Map)ylist.get(0);
                  qgmanager = StringHelper.null2String(ymap.get("purmanager"));
                  managername = StringHelper.null2String(ymap.get("txtname"));
                  cdept = StringHelper.null2String(ymap.get("purdept"));
                  qgdept = StringHelper.null2String(ymap.get("txtdept"));
                  String txt5 = StringHelper.null2String(map1.get("purchaseno"));
                  String flowno = "WK" + txt5 + "-" + NumberHelper.getSequenceNo("40285a90490d16a301492b96037f4eac", 3);
                  System.out.println("CreateYCXFK flowno:" + flowno);
                  WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
                  RequestInfo request = new RequestInfo();
                  request.setCreator(qgmanager);
                  request.setTypeid("40285a8d5a8c7d36015a8ca1465f00fb");
                  request.setIssave("1");

                  Dataset data1 = new Dataset();
                  List list1 = new ArrayList();
                  Cell cell1 = new Cell();

                  cell1 = new Cell();
                  cell1.setName("title");
                  cell1.setValue("分期付款：" + managername + "-" + qgdept + "-" + flowno);

                  cell1 = new Cell();
                  cell1.setName("flowno");
                  cell1.setValue(flowno);
                  list1.add(cell1);

                  cell1 = new Cell();
                  cell1.setName("times");

                  cell1.setValue(curdate);
                  list1.add(cell1);

                  cell1 = new Cell();
                  cell1.setName("types");
                  cell1.setValue(txt2);
                  list1.add(cell1);

                  cell1 = new Cell();
                  cell1.setName("purchorder");
                  cell1.setValue(txt5);
                  list1.add(cell1);

                  data1.setMaintable(list1);
                  request.setData(data1);
                  String str1 = workflowServiceImpl.createRequest(request);

                  String sql2 = "select requestid from uf_fn_wkdividpay  where flowno='" + flowno + "'";
                  System.out.println("CreateYCXFK sql2=" + sql2);
                  List tlist2 = baseJdbc.executeSqlForList(sql2);
                  if (tlist2.size() > 0)
                  {
                    Map map2 = (Map)tlist2.get(0);
                    String resid = StringHelper.null2String(map2.get("requestid"));
                    baseJdbc.update("delete uf_fn_wkdividpay where requestid='" + resid + "' ");
                    String upsql2 = "update uf_fn_wkdividpay set requestid='" + resid + "' where purchorder='" + txt5 + "' and requestid is null";
                    baseJdbc.update(upsql2);
                  }
                }
              }
            }

          }
          else
          {
            String upsql1 = "insert into uf_fn_wkoneoffpay(id,requestid,pono,types,buyer,text)values('" + tmpid + "','','" + ponorder + "','" + types + "','" + names + "','" + text + "')";
            System.out.println("markss='B' CreateYCXFK upsql1=" + upsql1);
            baseJdbc.update(upsql1);
            String sql1 = "select distinct(pono) purchaseno,types from uf_fn_wkoneoffpay where requestid is null";
            List tlist1 = baseJdbc.executeSqlForList(sql1);
            if (tlist1.size() > 0)
            {
              for (int i = 0; i < tlist1.size(); i++)
              {
                Map map1 = (Map)tlist1.get(i);
                String txt2 = StringHelper.null2String(map1.get("types"));
                String qgmanager = "";
                String managername = "";
                String cdept = "";
                String qgdept = "";
                String ysql = "select purmanager,purdept,(select objname from humres where id=a.purmanager)txtname,(select objname from orgunit where id=a.purdept)txtdept from uf_oa_purtypemanager a where a.purtype='" + txt2 + "'";
                System.out.println("markss='B' CreateYCXFK ysql=" + ysql);
                List ylist = baseJdbc.executeSqlForList(ysql);
                if (ylist.size() > 0)
                {
                  Map ymap = (Map)ylist.get(0);
                  qgmanager = StringHelper.null2String(ymap.get("purmanager"));
                  managername = StringHelper.null2String(ymap.get("txtname"));
                  cdept = StringHelper.null2String(ymap.get("purdept"));
                  qgdept = StringHelper.null2String(ymap.get("txtdept"));
                  String txt5 = StringHelper.null2String(map1.get("purchaseno"));
                  String flowno = "WK" + txt5 + "_" + NumberHelper.getSequenceNo("40285a90490d16a301492b96037f4eac", 3);
                  System.out.println("markss='B' CreateYCXFK flowno:" + flowno);
                  WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
                  RequestInfo request = new RequestInfo();
                  request.setCreator(qgmanager);
                  request.setTypeid("40285a8d5a58e2ed015a58f06c03001b");
                  request.setIssave("1");

                  Dataset data1 = new Dataset();
                  List list1 = new ArrayList();
                  Cell cell1 = new Cell();

                  cell1 = new Cell();
                  cell1.setName("title");
                  cell1.setValue("一次性付款：" + managername + "-" + qgdept + "-" + flowno);

                  cell1 = new Cell();
                  cell1.setName("flowno");
                  cell1.setValue(flowno);
                  list1.add(cell1);

                  cell1 = new Cell();
                  cell1.setName("times");

                  cell1.setValue(curdate);
                  list1.add(cell1);

                  cell1 = new Cell();
                  cell1.setName("types");
                  cell1.setValue(txt2);
                  list1.add(cell1);

                  cell1 = new Cell();
                  cell1.setName("pono");
                  cell1.setValue(txt5);
                  list1.add(cell1);

                  data1.setMaintable(list1);
                  request.setData(data1);
                  String str1 = workflowServiceImpl.createRequest(request);

                  String sql2 = "select requestid from uf_fn_wkoneoffpay  where flowno='" + flowno + "'";
                  System.out.println("markss='B' CreateYCXFK sql2=" + sql2);
                  List tlist2 = baseJdbc.executeSqlForList(sql2);
                  if (tlist2.size() > 0)
                  {
                    Map map2 = (Map)tlist2.get(0);
                    String resid = StringHelper.null2String(map2.get("requestid"));
                    baseJdbc.update("delete uf_fn_wkoneoffpay where requestid='" + resid + "' ");
                    String upsql2 = "update uf_fn_wkoneoffpay set requestid='" + resid + "' where pono='" + txt5 + "' and requestid is null";
                    baseJdbc.update(upsql2);
                  }
                }
              }
            }
          }
        }
      }
      System.out.println("com.eweaver.app.autotask.CreateYCXFK..END..");
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  private String getNo(String formula, String id, int len)
  {
    Date newdate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
    SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd");
    formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
    formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
    formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
    formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));
    String o = NumberHelper.getSequenceNo(id, len);
    return formula + o;
  }
}