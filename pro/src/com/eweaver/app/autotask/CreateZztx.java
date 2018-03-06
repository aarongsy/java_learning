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

public class CreateZztx {
	public void doAction()
	{
		BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sqlString="";
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");  
		java.util.Date date=new java.util.Date(); 
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int nowday=cal.get(Calendar.DAY_OF_WEEK);//当前星期数
		int year = cal.get(Calendar.YEAR);//获取年份
		int month=cal.get(Calendar.MONTH);//获取月份
		int day=cal.get(Calendar.DATE);//获取日
		String str=sdf.format(date);  //当前日期string
		//String strn=;//今年年审日期
		//到期提醒
		sqlString="select months_between(to_date(a.edate, 'yyyy-mm-dd'), to_date('"+str+"', 'yyyy-mm-dd')) as months,a.area,a.edate,to_char(to_date(a.edate,'yyyy-mm-dd')-14,'yyyy-mm-dd') as bdate,dqtxpsn,jbpsn,a.onedept,a.twodept,appno,a.requestid,(select b.objno from getcompanyview b where b.requestid=a.comcode) comcode,(select license from uf_oa_licensename c where requestid=a.zzname) zzname from uf_se_zzinfomian a where 0=(select isdelete from formbase where id=a.requestid) and a.isvalid='40288098276fc2120127704884290210'";
		System.out.println("到期提醒"+sqlString);
		List list=baseJdbc.executeSqlForList(sqlString);
		System.out.println("长度"+list.size());
		if(list.size()>0)
		{
			for (int i = 0; i < list.size(); i++) 
			{
				Map map = (Map)list.get(i);
		        String months = StringHelper.null2String(map.get("months"));
		        String area=StringHelper.null2String(map.get("area"));
		        String edate=StringHelper.null2String(map.get("edate"));
		        String bdate=StringHelper.null2String(map.get("bdate"));
		        String dqtxpsn=StringHelper.null2String(map.get("dqtxpsn"));
		        String jbpsn=StringHelper.null2String(map.get("jbpsn"));
		        String onedept=StringHelper.null2String(map.get("onedept"));
		        String twodept=StringHelper.null2String(map.get("twodept"));
		        String lsh=StringHelper.null2String(map.get("appno"));
		        String comcode=StringHelper.null2String(map.get("comcode"));
		        String zzname=StringHelper.null2String(map.get("zzname"));
		        String requestid=StringHelper.null2String(map.get("requestid"));
		        String txpsn=dqtxpsn+","+jbpsn;
		        String context=lsh+":"+comcode+"公司证照"+zzname+"于"+edate+"号前到期提醒";
		        String flag="";
		        String sql="select remindcycle from uf_oa_licenseremind  where factype='"+area+"' and isexpire='40288098276fc2120127704884290210' and leftexpire<"+months+" and rightexpire>="+months;
		        
		        List lists=baseJdbc.executeSqlForList(sql);
		        System.out.println(sql+"长度："+lists.size());
		        if(lists.size()>0)
		        {
		        	for (int j = 0; j < lists.size(); j++) 
		        	{
						Map maps=(Map)lists.get(j);
						String remindcycle= StringHelper.null2String(maps.get("remindcycle"));//提醒周期
						flag="";
						//System.out.println(remindcycle);
						if (remindcycle.equals("40285a8d5644a787015668df2fba31f2")) //每周一次
						{
							System.out.println("到期每周1次");
							 try {
								Date datea = sdf.parse(edate+" 00:00:00");
								cal.setTime(datea);

							} catch (ParseException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
							int nowdaya=cal.get(Calendar.DAY_OF_WEEK);
							if(nowday==nowdaya)
							{
								flag="1";
							}
						}
						else if(remindcycle.equals("40285a8d5644a787015668df2fb931f0"))//每月一次
						{
							System.out.println("到期每月1次");
				        	int dsya=Integer.parseInt(edate.split("-")[2]);
				        	//int montha=Integer.parseInt(edate.split("-")[1]);
				        	if(dsya==31)
				        	{
				        		if(month==4||month==6||month==9||month==11)
				        		{
				        			if(day==30)
					        		{
					        			flag="1";
					        		}
				        		}
				        		else if(month==2)
				        		{
				        			if(day==28)
					        		{
					        			flag="1";
					        		}
				        		}
				        		else {
				        			if(day==dsya)
									{
										flag="1";
									}
								}
				        	}
				        	else if(dsya==29||dsya==30)
				        	{
				        		if(month==2)
				        		{
				        			if(day==28)
					        		{
					        			flag="1";
					        		}
				        		}
				        		else {
				        			if(day==dsya)
									{
										flag="1";
									}
								}
				        	}
				        	else {
								if(day==dsya)
								{
									flag="1";
								}
							}
						}
						else//每月两次
						{
							System.out.println("到期每月2次");
				        	int dsye=Integer.parseInt(edate.split("-")[2]);
				        	int dsyb=Integer.parseInt(bdate.split("-")[2]);
				        	/*if(dsye==29||dsye==30||dsye==31||dsyb==29||dsyb==30||dsyb==31)
				        	{
				        		if(day==28)
				        		{
				        			flag="1";
				        		}
				        	}
				        	else {
								if(day==dsye||day==dsyb)
								{
									flag="1";
								}
							}*/
				        	
				        	if(dsye==31||dsyb==31)
				        	{
				        		if(month==4||month==6||month==9||month==11)
				        		{
				        			if(day==30)
					        		{
					        			flag="1";
					        		}
				        		}
				        		else if(month==2)
				        		{
				        			if(day==28)
					        		{
					        			flag="1";
					        		}
				        		}
				        		else {
				        			if(day==dsye||day==dsyb)
									{
										flag="1";
									}
								}
				        	}
				        	else if(dsye==29||dsye==30||dsyb==29||dsyb==30)
				        	{
				        		if(month==2)
				        		{
				        			if(day==28)
					        		{
					        			flag="1";
					        		}
				        		}
				        		else {
				        			if(day==dsye||day==dsyb)
									{
										flag="1";
									}
								}
				        	}
				        	else {
								if(day==dsye||day==dsyb)
								{
									flag="1";
								}
							}
						}
						if(flag.equals("1"))
						{
							//创建分类
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
							cell1.setValue("安环证照到期提醒-"+zzname+"!");
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
							cell1.setValue(area);
							list1.add(cell1);

							cell1 = new Cell();
							cell1.setName("model");//提醒模块
							cell1.setValue("安环证照");
							list1.add(cell1);

							cell1 = new Cell();
							cell1.setName("psnno");//提醒人员
							cell1.setValue(txpsn);
							list1.add(cell1);

							cell1 = new Cell();
							cell1.setName("context");//提醒内容
							cell1.setValue(context);
							list1.add(cell1);

							cell1 = new Cell();
							cell1.setName("linkform");//链接流程
							cell1.setValue("<a href=/workflow/request/formbase.jsp?requestid="+requestid+">安环证照："+zzname+"</a>");
							list1.add(cell1);

							//cell1 = new Cell();
							//cell1.setName("yl1");//链接流程
							//cell1.setValue(onedept);
							//list1.add(cell1);
							
							cell1 = new Cell();
							cell1.setName("yl2");//链接流程
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
		//年审提醒
		
		sqlString="select months_between(to_date('"+String.valueOf(year)+"'||substr(a.sdate,5,6), 'yyyy-mm-dd'), to_date('"+str+"', 'yyyy-mm-dd')) as months,a.area,a.edate,sdate,to_char(to_date(a.edate,'yyyy-mm-dd')-14,'yyyy-mm-dd') as bdate,dqtxpsn,jbpsn,a.onedept,a.twodept,a.checkdate,appno,a.requestid,(select b.objno from getcompanyview b where b.requestid=a.comcode) comcode,(select license from uf_oa_licensename c where requestid=a.zzname) zzname from uf_se_zzinfomian a where 0=(select isdelete from formbase where id=a.requestid) and a.isvalid='40288098276fc2120127704884290210' and needcheck='40288098276fc2120127704884290210'";
		list=baseJdbc.executeSqlForList(sqlString);
		System.out.println("复审提醒"+sqlString);
		System.out.println("长度"+list.size());
		if(list.size()>0)
		{
			for (int i = 0; i < list.size(); i++) 
			{
				Map map = (Map)list.get(i);
		        String months = StringHelper.null2String(map.get("months"));
		        String area=StringHelper.null2String(map.get("area"));
		        String sdate=StringHelper.null2String(map.get("sdate"));
		        String edate=StringHelper.null2String(map.get("edate"));
		        String bdate=StringHelper.null2String(map.get("bdate"));
		        String dqtxpsn=StringHelper.null2String(map.get("dqtxpsn"));
		        String jbpsn=StringHelper.null2String(map.get("jbpsn"));
		        String onedept=StringHelper.null2String(map.get("onedept"));
		        String twodept=StringHelper.null2String(map.get("twodept"));
		        String txpsn=dqtxpsn+","+jbpsn;
		        String checkdate=StringHelper.null2String(map.get("checkdate"));
		        String lsh=StringHelper.null2String(map.get("appno"));
		        String comcode=StringHelper.null2String(map.get("comcode"));
		        String zzname=StringHelper.null2String(map.get("zzname"));
		        String requestid=StringHelper.null2String(map.get("requestid"));

		        String context=lsh+":"+comcode+"公司证照"+zzname+"于"+String.valueOf(year)+"年复审提醒";
		        
		        String flag1="";
		        if(checkdate.equals(""))
		        {
		        	checkdate=sdate;
		        }
		        if(Integer.parseInt(sdate.split("-")[0])<year&&year<Integer.parseInt(edate.split("-")[0])&&Integer.parseInt(checkdate.split("-")[0])<year)
		        {
			        String sqln="select remindcycle from uf_oa_licenseremind  where factype='"+area+"' and isreview='40288098276fc2120127704884290210' and leftexpire<"+months+" and rightexpire>="+months;
			        List listn=baseJdbc.executeSqlForList(sqln);
			        System.out.println(sqln+"长度："+listn.size());
			        if(listn.size()>0)
			        {
			        	for (int k = 0; k < listn.size(); k++) 
			        	{
							Map mapn=(Map)listn.get(k);
							String remindcycle= StringHelper.null2String(mapn.get("remindcycle"));//提醒周期
							flag1="";
							if (remindcycle.equals("40285a8d5644a787015668df2fba31f2")) //每周一次
							{
								System.out.println("年审每周1次");
								 try {
									Date datea = sdf.parse(edate+" 00:00:00");
									cal.setTime(datea);

								} catch (ParseException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								int nowdaya=cal.get(Calendar.DAY_OF_WEEK);
								if(nowday==nowdaya)
								{
									flag1="1";
								}
							}
							else if(remindcycle.equals("40285a8d5644a787015668df2fb931f0"))//每月一次
							{
								System.out.println("年审每月1次");
					        	int dsya=Integer.parseInt(edate.split("-")[2]);
					        	if(dsya==31)
					        	{
					        		if(month==4||month==6||month==9||month==11)
					        		{
					        			if(day==30)
						        		{
					        				flag1="1";
						        		}
					        		}
					        		else if(month==2)
					        		{
					        			if(day==28)
						        		{
					        				flag1="1";
						        		}
					        		}
					        		else {
					        			if(day==dsya)
										{
					        				flag1="1";
										}
									}
					        	}
					        	else if(dsya==29||dsya==30)
					        	{
					        		if(month==2)
					        		{
					        			if(day==28)
						        		{
					        				flag1="1";
						        		}
					        		}
					        		else {
					        			if(day==dsya)
										{
					        				flag1="1";
										}
									}
					        	}
					        	else {
									if(day==dsya)
									{
										flag1="1";
									}
								}
							}
							else//每月两次
							{
								System.out.println("年审每月2次");
					        	int dsye=Integer.parseInt(edate.split("-")[2]);
					        	int dsyb=Integer.parseInt(bdate.split("-")[2]);
					        	if(dsye==31||dsyb==31)
					        	{
					        		if(month==4||month==6||month==9||month==11)
					        		{
					        			if(day==30)
						        		{
					        				flag1="1";
						        		}
					        		}
					        		else if(month==2)
					        		{
					        			if(day==28)
						        		{
					        				flag1="1";
						        		}
					        		}
					        		else {
					        			if(day==dsye||day==dsyb)
										{
					        				flag1="1";
										}
									}
					        	}
					        	else if(dsye==29||dsye==30||dsyb==29||dsyb==30)
					        	{
					        		if(month==2)
					        		{
					        			if(day==28)
						        		{
					        				flag1="1";
						        		}
					        		}
					        		else {
					        			if(day==dsye||day==dsyb)
										{
					        				flag1="1";
										}
									}
					        	}
					        	else {
									if(day==dsye||day==dsyb)
									{
										flag1="1";
									}
								}
							}
							if(flag1.equals("1"))
							{
								//创建分类
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
								cell1.setValue("安环证照年审提醒-"+zzname+"!");
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
								cell1.setValue(area);
								list1.add(cell1);

								cell1 = new Cell();
								cell1.setName("model");//提醒模块
								cell1.setValue("安环证照");
								list1.add(cell1);

								cell1 = new Cell();
								cell1.setName("psnno");//提醒人员
								cell1.setValue(txpsn);
								list1.add(cell1);

								cell1 = new Cell();
								cell1.setName("context");//提醒内容
								cell1.setValue(context);
								list1.add(cell1);

								cell1 = new Cell();
								cell1.setName("linkform");//链接流程
								cell1.setValue("<a href=/workflow/request/formbase.jsp?requestid="+requestid+">安环证照："+zzname+"</a>");
								list1.add(cell1);
							
								
								//cell1 = new Cell();
							//	cell1.setName("yl1");//链接流程
								//cell1.setValue(onedept);
								//list1.add(cell1);
								
								cell1 = new Cell();
								cell1.setName("yl2");//链接流程
								cell1.setValue(twodept);
								list1.add(cell1);

								data.setMaintable(list1);
								request.setData(data);
								String str1 = workflowServiceImpl.createRequest(request);
							}
						}
			        }
		        }
			}//end for
		}//end if
		//end 年审
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
