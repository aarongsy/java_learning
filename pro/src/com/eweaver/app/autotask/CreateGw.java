package com.eweaver.app.autotask;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.sun.org.apache.bcel.internal.generic.NEW;

import java.util.*;

public class CreateGw {
	public void doAcriond()
	{
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    String sql = "select a.requestid,a.gwmc,a.lsh,a.latestdate,a.warntimes,a.agent,(select wm_concat(id) from humres where  instr(station,((select b.mstationid from orgunit b where b.id=(select h.orgid from humres h where h.id=a.agent))))>0) as zg,a.sqrq,a.cqb from uf_oa_gwsw a where 0=(select isdelete from requestbase where id=a.requestid) and '40285a8d5644a7870156912acb677a03'=(select b.CURRENTNODEID from REQUESTINFO b where b.requestid=a.requestid)";
	    System.out.println("公文承办提醒" + sql);

	    List list = baseJdbc.executeSqlForList(sql);
	    if (list.size() > 0)
	    {
	      for (int i = 0; i < list.size(); i++) {
	        Map map = (Map)list.get(i);
	        String requestid = StringHelper.null2String(map.get("requestid"));
	        String lsh = StringHelper.null2String(map.get("lsh"));//流水号
	        String latestdate = StringHelper.null2String(map.get("latestdate"));//最后回复日期
	        String warntimes = StringHelper.null2String(map.get("warntimes"));//提醒频率
	        String agent = StringHelper.null2String(map.get("agent"));//承办人
	        String zg = StringHelper.null2String(map.get("zg"));//成本人主管
	        String sqrq = StringHelper.null2String(map.get("sqrq"));//申请日期
	        String cqb = StringHelper.null2String(map.get("cqb"));//厂区别
	        String gwmc=StringHelper.null2String(map.get("gwmc"));
	        String psnno=agent+","+zg;//提醒人员
	        String context=lsh+":请于"+latestdate+"号前执行并回复";
	        boolean flag=false;
	        if(warntimes.equals("40285a8d5644a78701565d9971b728d7"))//每天一次
	        {
	        	flag=true;
	        }
	        else if(warntimes.equals("40285a8d5644a78701565d9971b728d8"))//周一次
	        {
	        	Date date=new Date();
				 Calendar cal = Calendar.getInstance();
				 cal.setTime(date);
				 int nowday=cal.get(Calendar.DAY_OF_WEEK);
				 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");  
				 try {
					Date datea = sdf.parse(sqrq+" 00:00:00");
					cal.setTime(datea);
					int nowdaya=cal.get(Calendar.DAY_OF_WEEK);
					if(nowday==nowdaya)
					{
						flag=true;
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}  
				
	        }
	        else if(warntimes.equals("40285a8d5644a78701565d9971b728d9"))//月一次
	        {
	        	Calendar cal = Calendar.getInstance();
	            int year = cal.get(Calendar.YEAR);//获取年份
	            int month=cal.get(Calendar.MONTH);//获取月份
	            int day=cal.get(Calendar.DATE);//获取日
	        	int dsya=Integer.parseInt(sqrq.split("-")[2]);
	        	if(dsya==31)
	        	{
	        		if(month==4||month==6||month==9||month==11)
	        		{
	        			if(day==30)
		        		{
		        			flag=true;
		        		}
	        		}
	        		else if(month==2)
	        		{
	        			if(day==28)
		        		{
		        			flag=true;
		        		}
	        		}
	        		else {
	        			if(day==dsya)
						{
							flag=true;
						}
					}
	        	}
	        	else if(dsya==29||dsya==30)
	        	{
	        		if(month==2)
	        		{
	        			if(day==28)
		        		{
		        			flag=true;
		        		}
	        		}
	        		else {
	        			if(day==dsya)
						{
							flag=true;
						}
					}
	        	}
	        	else {
					if(day==dsya)
					{
						flag=true;
					}
				}
	        }
	        else //3天一次
	        {
	        	Date date=new Date();
				Calendar cal = Calendar.getInstance();		        
				cal.setTime(date);
				long time1=cal.getTimeInMillis();
				long time2=time1;
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");  
				try {
					cal.setTime(sdf.parse(sqrq+" 00:00:00"));
					time2=cal.getTimeInMillis();
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				long between_days=Math.abs((time1-time2)/(1000*3600*24));   
				int days=Integer.parseInt(String.valueOf(between_days));
				if(days%3==0)
				{
					flag=true;
				}

				 
	        }
	        //flag=true 执行提醒流程
	        if(flag==true)
	        {
	        	String flowno=getNo("TXYYYYMMDD", "40285a8d5644a7870156965583b109c4", 3);
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
				cell1.setValue("安环公文执行提醒-"+gwmc+"!");
				list1.add(cell1);
				
				cell1 = new Cell();
				cell1.setName("flowno");//
				cell1.setValue(flowno);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("rdate");//提醒日期
				cell1.setValue(new SimpleDateFormat("yyyy-mm-dd").format(new Date()));
				list1.add(cell1);
				

				cell1 = new Cell();
				cell1.setName("area");//厂区别
				cell1.setValue(cqb);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("model");//提醒模块
				cell1.setValue("安环公文");
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("psnno");//提醒人员
				cell1.setValue(psnno);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("context");//提醒内容
				cell1.setValue(context);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("linkflow");//链接流程
				cell1.setValue(requestid);
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
}
