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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class Createtzsbtx
{
  public void doAction()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sqlString = "";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date date = new Date();
    Calendar cal = Calendar.getInstance();
    cal.setTime(date);
    int nowday=cal.get(Calendar.DAY_OF_WEEK);//当前星期数
	int year = cal.get(Calendar.YEAR);//获取年份
	int month=cal.get(Calendar.MONTH);//获取月份
	int day=cal.get(Calendar.DATE);//获取日
    String str = sdf.format(date);

    //sqlString = "select months_between(to_date(a.edate, 'yyyy-mm-dd'), to_date('" + str + "', 'yyyy-mm-dd')) as months,a.area,a.edate,to_char(to_date(a.edate,'yyyy-mm-dd')-14,'yyyy-mm-dd') as bdate,dqtxpsn,jbpsn,a.onedept,a.twodept,appno,a.requestid,(select b.objno from getcompanyview b where b.requestid=a.comcode) comcode,(select license from uf_oa_licensename c where requestid=a.zzname) zzname from uf_se_zzinfomian a where 0=(select isdelete from formbase where id=a.requestid) and a.isvalid='40288098276fc2120127704884290210'";
    sqlString = "select months_between(to_date(a.dates, 'yyyy-mm-dd'), to_date('" + str + "', 'yyyy-mm-dd')) as months,a.factory as area,a.dates as edate,to_char(to_date(a.dates,'yyyy-mm-dd')-14,'yyyy-mm-dd') as bdate,a.person as dqtxpsn,a.onedept,a.twodept,a.appno,a.requestid,a.ccode as comcode,a.specialtype as zzname from v_se_tzsbbb a where 0=(select isdelete from formbase where id=a.requestid) and a.ifuseful='40288098276fc2120127704884290210' and a.dates is not null";
	System.out.println("特种设备到期提醒" + sqlString);
    List list = baseJdbc.executeSqlForList(sqlString);
    System.out.println("长度" + list.size());
    if (list.size() > 0)
    {
      for (int i = 0; i < list.size(); i++)
      {
        Map map = (Map)list.get(i);
        String months = StringHelper.null2String(map.get("months"));
        String area = StringHelper.null2String(map.get("area"));
        String edate = StringHelper.null2String(map.get("edate"));
        String bdate = StringHelper.null2String(map.get("bdate"));
        String dqtxpsn = StringHelper.null2String(map.get("dqtxpsn"));
        //String jbpsn = StringHelper.null2String(map.get("jbpsn"));
        String onedept = StringHelper.null2String(map.get("onedept"));
        String twodept = StringHelper.null2String(map.get("twodept"));
        String lsh = StringHelper.null2String(map.get("appno"));
        String comcode = StringHelper.null2String(map.get("comcode"));
        String zzname = StringHelper.null2String(map.get("zzname"));
        String requestid = StringHelper.null2String(map.get("requestid"));
        String txpsn = dqtxpsn + "," + "40285a9049ade1710149ade778ca024d"+ "," +"297e55a64a7f0de8014a7f1005790002";
        String context = lsh + ":" + comcode + "设备类型为:" + zzname + "于" + edate + "号前到期提醒";
        String flag = "";
        String sql = "select remindcycle from uf_se_tzsbdqtx  where factype='" + area + "' and isexpire='40288098276fc2120127704884290210' and leftexpire<" + months + " and rightexpire>=" + months;

        List lists = baseJdbc.executeSqlForList(sql);
        System.out.println(sql + "长度：" + lists.size());
        if (lists.size() > 0)
        {
          for (int j = 0; j < lists.size(); j++)
          {
            Map maps = (Map)lists.get(j);
            String remindcycle = StringHelper.null2String(maps.get("remindcycle"));
            flag = "";

            if (remindcycle.equals("40285a8d5644a787015668df2fba31f2"))
            {
              System.out.println("到期每周1次");
              try {
                Date datea = sdf.parse(edate+" 00:00:00");
                cal.setTime(datea);
              }
              catch (ParseException e)
              {
                e.printStackTrace();
              }

              int nowdaya=cal.get(Calendar.DAY_OF_WEEK);
              if (nowday == nowdaya)
              {
                flag = "1";
              }
            }
            else if (remindcycle.equals("40285a8d5644a787015668df2fb931f0"))
            {
              System.out.println("到期每月1次");
              int dsya = Integer.parseInt(edate.split("-")[2]);

              if (dsya == 31)
              {
                if ((month == 4) || (month == 6) || (month == 9) || (month == 11))
                {
                  if (day == 30)
                  {
                    flag = "1";
                  }
                }
                else if (month == 2)
                {
                  if (day == 28)
                  {
                    flag = "1";
                  }

                }
                else if (day == dsya)
                {
                  flag = "1";
                }

              }
              else if ((dsya == 29) || (dsya == 30))
              {
                if (month == 2)
                {
                  if (day == 28)
                  {
                    flag = "1";
                  }

                }
                else if (day == dsya)
                {
                  flag = "1";
                }

              }
              else if (day == dsya)
              {
                flag = "1";
              }

            }
            else
            {
              System.out.println("到期每月2次");
              int dsye = Integer.parseInt(edate.split("-")[2]);
              int dsyb = Integer.parseInt(bdate.split("-")[2]);

              if ((dsye == 31) || (dsyb == 31))
              {
                if ((month == 4) || (month == 6) || (month == 9) || (month == 11))
                {
                  if (day == 30)
                  {
                    flag = "1";
                  }
                }
                else if (month == 2)
                {
                  if (day == 28)
                  {
                    flag = "1";
                  }

                }
                else if ((day == dsye) || (day == dsyb))
                {
                  flag = "1";
                }

              }
              else if ((dsye == 29) || (dsye == 30) || (dsyb == 29) || (dsyb == 30))
              {
                if (month == 2)
                {
                  if (day == 28)
                  {
                    flag = "1";
                  }

                }
                else if ((day == dsye) || (day == dsyb))
                {
                  flag = "1";
                }

              }
              else if ((day == dsye) || (day == dsyb))
              {
                flag = "1";
              }
            }
          /*  if(str.equals("2017-03-21")&&Double.valueOf(months)<1.00d&&Double.valueOf(months)>0.00d)
            {
            	flag = "1";
            }*/
            if (flag.equals("1"))
            {
              String flowno = getNo("TXYYYYMMDD", "40285a8d5644a7870156965583b109c4", 3);
              WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
              RequestInfo request = new RequestInfo();
              request.setCreator("402881e70be6d209010be75668750014");
              request.setTypeid("40285a8d5644a787015659863330255b");
              request.setIssave("0");

              Dataset data = new Dataset();
              List list1 = new ArrayList();
              Cell cell1 = new Cell();

              cell1 = new Cell();
              cell1.setName("title");
              cell1.setValue("特种设备到期提醒-" + zzname + "!");
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("flowno");
              cell1.setValue(flowno);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("rdate");
              cell1.setValue(new SimpleDateFormat("yyyy-mm-dd").format(new Date()));
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("area");
              cell1.setValue(area);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("model");
              cell1.setValue("特种设备");
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("psnno");
              cell1.setValue(txpsn);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("context");
              cell1.setValue(context);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("linkform");
              cell1.setValue("<a href=/workflow/request/formbase.jsp?requestid=" + requestid + ">特种设备：" + zzname + "</a>");
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("yl1");
              cell1.setValue("");
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("yl2");
              cell1.setValue(twodept);
              list1.add(cell1);

              data.setMaintable(list1);
              request.setData(data);
              String str1 = workflowServiceImpl.createRequest(request);
            }
          }
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