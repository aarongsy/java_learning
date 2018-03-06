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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.jasper.tagplugins.jstl.core.Out;

public class CreateCGBY
{
  public void doAction()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date date = new Date();
    String curdate = sdf.format(date);

    String sql = "select  months_between(to_date(sysdate),to_date(a.improvetime,'yyyy-mm-dd')+1)months,a.flower,a.requestid,a.improvetime,(select objno from getcompanyview where requestid=a.comtype)comcode,a.factype,a.purhandler from uf_oa_purcomplain a left join requestbase res on a.requestid=res.id where res.isdelete=0 and a.proofdata is null and a.improvetime is not null";
    System.out.println(sql);
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0)
    {
      for (int i = 0; i < list.size(); i++)
      {
        Map map = (Map)list.get(i);
        String flower = StringHelper.null2String(map.get("flower"));
        String resid = StringHelper.null2String(map.get("requestid"));
        String improvedate = StringHelper.null2String(map.get("improvetime"));
        String months = StringHelper.null2String(map.get("months"));
        String comcode = StringHelper.null2String(map.get("comcode"));
        String factype = StringHelper.null2String(map.get("factype"));
        String purhandler = StringHelper.null2String(map.get("purhandler"));
        String context = flower + ":请确认厂商改善完成日期并尽快上传佐证资料";

        if (isInteger(months))
        {
          System.out.println("请确认厂商改善完成日期啊啊啊啊啊啊！");
          String flowno = getNo("TXYYYYMMDD", "40285a8d5644a7870156965583b109c4", 3);
          WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
          RequestInfo request = new RequestInfo();
          request.setCreator(purhandler);
          request.setTypeid("40285a8d5644a787015659863330255b");
          request.setIssave("0");

          Dataset data = new Dataset();
          List list1 = new ArrayList();
          Cell cell1 = new Cell();

          cell1 = new Cell();
          cell1.setName("flowno");
          cell1.setValue(flowno);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("rdate");
          cell1.setValue(curdate);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("area");
          cell1.setValue(factype);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("model");
          cell1.setValue("采购管理");
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("psnno");
          cell1.setValue(purhandler);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("context");
          cell1.setValue(context);
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("linkform");
          cell1.setValue("采购抱怨申请提醒-" + flower + "!");
          list1.add(cell1);

          cell1 = new Cell();
          cell1.setName("linkflow");
          cell1.setValue(resid);
          list1.add(cell1);

          data.setMaintable(list1);
          request.setData(data);
          String str1 = workflowServiceImpl.createRequest(request);
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

  public static boolean isInteger(String str)
  {
    Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
    return pattern.matcher(str).matches();
  }
}