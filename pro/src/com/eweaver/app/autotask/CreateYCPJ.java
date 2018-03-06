package com.eweaver.app.autotask;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class CreateYCPJ
{
  public void doAction()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date date = new Date();
    String str = sdf.format(date);
    String today = str.substring(0, 10);
    System.out.println("today" + today);

    String sql = "select a.requestid carappno,a.reqman,a.comtype,to_char(to_date(substr(b.finishdatetime,0,10),'yyyy-mm-dd')+1,'yyyy-mm-dd') finishdate,c.requestid cararrno2,c.cartype,c.supplyname,c.carno,c.driver from uf_oa_carapp a,requestbase b,uf_oa_cararrange c where b.id=a.requestid and b.isdelete=0 and c.requestid=a.cararrno";
    System.out.println("用车申请" + sql);
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0)
    {
      for (int i = 0; i < list.size(); i++)
      {
        Map map = (Map)list.get(i);
        String carappno = StringHelper.null2String(map.get("carappno"));
        String reqman = StringHelper.null2String(map.get("reqman"));
        String finishdate = StringHelper.null2String(map.get("finishdate"));
        String cararrno = StringHelper.null2String(map.get("cararrno2"));
        String cartype = StringHelper.null2String(map.get("cartype"));
        String supplyname = StringHelper.null2String(map.get("supplyname"));
        String carno = StringHelper.null2String(map.get("carno"));
        String driver = StringHelper.null2String(map.get("driver"));
        String comtype = StringHelper.null2String(map.get("comtype"));

        System.out.println("finishdate" + finishdate);

        String flag = "";
        if ((finishdate.equals(today)) && (!"".equals(cararrno)))
        {
          flag = "1";
          System.out.println("carappno" + carappno);
        }

        if (flag.equals("1"))
        {
          String flowno = getNo("YCPJYYYYMM", "40285a8d4b7b329a014b8a99d35e4bea", 4);
          WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
          RequestInfo request = new RequestInfo();
          request.setCreator(reqman);
          request.setTypeid("40285a8d5939f6a1015942e6a4e11bc6");
          request.setIssave("0");

          Dataset data = new Dataset();
          List list1 = new ArrayList();
          Cell cell1 = new Cell();

          cell1 = new Cell();
          cell1.setName("flowno");
          cell1.setValue(flowno);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("reqman");
          cell1.setValue(reqman);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("comtype");
          cell1.setValue(comtype);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("reqdate");
          cell1.setValue(finishdate);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("cartype");
          cell1.setValue(cartype);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("supplyname");
          cell1.setValue(supplyname);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("carno");
          cell1.setValue(carno);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("driver");
          cell1.setValue(driver);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("carappno");
          cell1.setValue(carappno);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("cararrno");
          cell1.setValue(cararrno);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("stateflag");
          cell1.setValue("40288098276fc2120127704884290211");
          list1.add(cell1);

          data.setMaintable(list1);
          request.setData(data);
          String str1 = workflowServiceImpl.createRequest(request);
          System.out.println("用车评价单" + flowno);
        }
      }
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