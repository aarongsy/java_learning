<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>

<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	String sdate = StringHelper.null2String(request.getParameter("sdate"));//日期
	String edate = StringHelper.null2String(request.getParameter("edate"));//日期
	Calendar cdr = Calendar.getInstance();	
	SimpleDateFormat sdt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	Date theBegin = ft.parse(sdate);
	String delsql = "delete uf_hr_kqdetail where requestid='40285a8f5ce2350d015cf2e9900233b0'";
	baseJdbc.update(delsql);

	String humsql = "select id,objname,objno,(select nametext from uf_profe where requestid=extrefobjfield4),extrefobjfield4,extselectitemfield14 from humres where (extrefobjfield5='40285a90488ba9d101488bbd09100007' and hrstatus='4028804c16acfbc00116ccba13802935' and extselectitemfield11='40285a8f489c17ce0148f371f98a6740' and isdelete=0 and extrefobjfield4<>'40285a904931f62b01495a6ed84c2bf4' ) or id='40285a904a1d4bfd014a2e7ab5357fc3' or id='40285a904a1d4bfd014a2e79f46b7d89' or id='40285a904a1d4bfd014a2e7a64097ed5' or id='40285a904a1d4bfd014a2e79cd3e7d17' or id='40285a904a1d4bfd014a2e7ae3de004b' or id='40285a9057ff51da015803ccb1f1225e' order by objno";
	System.out.println("第一个SQL："+humsql);
	List list1 = baseJdbc.executeSqlForList(humsql);
	int sum = 0;
	if(list1.size()>0)
	{
		for(int m = 0;m<list1.size();m++)
		{
			Map mm = (Map)list1.get(m);
			String ids = StringHelper.null2String(mm.get("id"));//员工id
			String objno = StringHelper.null2String(mm.get("objno"));//员工工号
			String zc = StringHelper.null2String(mm.get("extrefobjfield4"));//员工职称

			String sql1="select to_char((to_date('"+sdate+"','yyyy-mm-dd'))+Rownum-1,'yyyy-mm-dd') as thedate from dual connect by rownum< to_date('"+edate+"','yyyy-mm-dd')-to_date('"+sdate+"','yyyy-mm-dd') +2";
			List lists = baseJdbc.executeSqlForList(sql1);
			if(lists.size()>0)
			{
				for(int k = 0;k<lists.size();k++)
				{
					Map map2 = (Map)lists.get(k);
					String thedate = StringHelper.null2String(map2.get("thedate"));
					theBegin = ft.parse(thedate);

					//获取请假信息
					String sql = "select jobno,objname,(select extrefobjfield4 from humres where id = a.objname) as zc,(select objname from orgunit where id = a.objdept) as objdeptxt,a.objdept,reason,startdate,starttime,enddate,endtime from uf_hr_vacation a where '"+thedate+"' between startdate and enddate and isvalided = '40288098276fc2120127704884290210' and 1<>(select isdelete from requestbase where id = requestid) and comtype = '40285a90488ba9d101488bbd09100007' and objname = '"+ids+"' order by jobno asc";
						
					List list = baseJdbc.executeSqlForList(sql);
					if(list.size()>0)
					{
						for(int i = 0;i<list.size();i++)
						{
							Map map = (Map)list.get(i);
							String jobno = StringHelper.null2String(map.get("jobno"));//员工工号
							String objname = StringHelper.null2String(map.get("objname"));//员工姓名
							String objdeptxt = StringHelper.null2String(map.get("objdeptxt"));//员工所属部门
							String reason = StringHelper.null2String(map.get("reason"));//事由
							String startdate = StringHelper.null2String(map.get("startdate"));//开始日期
							String starttime = StringHelper.null2String(map.get("starttime"));//开始时间
							String enddate = StringHelper.null2String(map.get("enddate"));//结束日期
							String endtime = StringHelper.null2String(map.get("endtime"));//结束时间
							String sdtime = startdate+" "+starttime;//开始日期时间
							String edtime = enddate +" "+endtime;//结束日期时间
							String objdept=StringHelper.null2String(map.get("objdept"));
								
							String clsql = "select pstime,petime from uf_hr_classinfo where requestid=(select classno from uf_hr_classplan where objname = '"+ids+"' and thedate = '"+thedate+"')";
							List list3 = baseJdbc.executeSqlForList(clsql);
							if(list3.size() >0)
							{
								Map cm = (Map)list3.get(0);
								String pstime = StringHelper.null2String(cm.get("pstime"));//计划开始时间
								String petime = StringHelper.null2String(cm.get("petime"));//计划结束时间
								SimpleDateFormat sft = new SimpleDateFormat("HH:mm:ss");
								Date ps = sft.parse(pstime);
								Date pe = sft.parse(petime);
								if(ps.getTime()>=pe.getTime()){//跨天					
									cdr.setTime(theBegin);
									cdr.add(Calendar.DAY_OF_MONTH,1);
									String nextDay = ft.format(cdr.getTime());
									pstime = thedate + " " + pstime;
									petime = nextDay + " " + petime;
								}else{
									pstime = thedate + " " + pstime;
									petime = thedate + " " + petime;
								}
								Date st = sdt.parse(sdtime);//请假开始时间
								Date se = sdt.parse(edtime);//请假结束时间

								Date sp = sdt.parse(pstime);//班别开始时间
								Date ep = sdt.parse(petime);//班别结束时间
								String ss = "";
								String ee = "";
								if(st.getTime()>sp.getTime())//班别开始时间在请假时间段外
								{
									if(ep.getTime() >st.getTime() && ep.getTime()<=se.getTime())//班别结束时间在请假时间段内
									{
										ss = sdtime;
										ee = petime;
										if(thedate.equals(enddate))
										{
											ee = edtime;
										}
									}	
									if(ep.getTime() >se.getTime())
									{
										ss = sdtime;
										ee = edtime;
									}
								}
								else if(sp.getTime() >=st.getTime() && sp.getTime() <se.getTime())//班别开始时间在请假时间段内
								{
									if(ep.getTime()<se.getTime())//班别结束时间在请假时间段内
									{
										ss = pstime;
										ee = petime;
										if(thedate.equals(enddate))
										{
											ee = edtime;
										}
									}
									else//班别结束时间在请假时间段外
									{
										ss = pstime;
										ee = edtime;
									}
								}
								if(!ss.equals("") && !ee.equals(""))
								{
									ss = ss.split(" ")[1];
									ee = ee.split(" ")[1];
									
									String insql = "insert into uf_hr_kqdetail (id,requestid,psnno,psnname,dept,zc,kqtype,startdate,enddate,reason,yesno,thedate,appstart,append,objdept)values('"+IDGernerator.getUnquieID()+"','40285a8f5ce2350d015cf2e9900233b0','"+jobno+"','"+objname+"','"+objdeptxt+"','"+zc+"','请假','"+starttime+"','"+endtime+"','"+reason+"','40288098276fc2120127704884290210','"+thedate+"','"+startdate+"','"+enddate+"','"+objdept+"')";
									baseJdbc.update(insql);
									sum = sum +1;
								}
							}
						}
					}
					//获取出差信息
					String sql2 = "select ifreturn,(select objname from orgunit where id = a.objdept) as objdeptxt,a.objdept,reason,(select wm_concat(b.unit) from uf_hr_businesstripsub  b where a.requestid = b.requestid) as unit,sdate,stime,edate,etime from uf_hr_businesstrip a where psnname = '"+ids+"' and isvalided = '40288098276fc2120127704884290210' and 1<>(select isdelete from requestbase where id = requestid) and '"+thedate+"' between sdate and edate";

					List list2 = baseJdbc.executeSqlForList(sql2);
					if(list2.size()>0)
					{
						for(int j = 0;j<list2.size();j++)
						{
							Map map1 = (Map)list2.get(j);
							//String objname = StringHelper.null2String(map1.get("objname"));//员工姓名
							String objdeptxt = StringHelper.null2String(map1.get("objdeptxt"));//员工所属部门
							String reason = StringHelper.null2String(map1.get("reason"));//事由
							String unit = StringHelper.null2String(map1.get("unit"));//拜访单位
							String startdate = StringHelper.null2String(map1.get("sdate"));//开始日期
							String starttime = StringHelper.null2String(map1.get("stime"));//开始时间
							String enddate = StringHelper.null2String(map1.get("edate"));//结束日期
							String endtime = StringHelper.null2String(map1.get("etime"));//结束时间
							String sdtime = startdate+" "+starttime;//开始日期时间
							String edtime = enddate +" "+endtime;//结束日期时间
							String ifreturn = StringHelper.null2String(map1.get("ifreturn"));//是否返台休假
							String objdept=StringHelper.null2String(map1.get("objdept"));

							String allreson = reason+"："+unit;
							String clsql1 = "select pstime,petime from uf_hr_classinfo where requestid=(select classno from uf_hr_classplan where objname = '"+ids+"' and thedate = '"+thedate+"')";
							List list4 = baseJdbc.executeSqlForList(clsql1);
							if(list4.size() >0)
							{
								Map cm1 = (Map)list4.get(0);
								String pstime = StringHelper.null2String(cm1.get("pstime"));//计划开始时间
								String petime = StringHelper.null2String(cm1.get("petime"));//计划结束时间
								SimpleDateFormat sft = new SimpleDateFormat("HH:mm:ss");
								Date ps = sft.parse(pstime);
								Date pe = sft.parse(petime);
								if(ps.getTime()>=pe.getTime())//跨天	
								{								
									cdr.setTime(theBegin);
									cdr.add(Calendar.DAY_OF_MONTH,1);
									String nextDay = ft.format(cdr.getTime());
									pstime = thedate + " " + pstime;
									petime = nextDay + " " + petime;
								}else{
									pstime = thedate + " " + pstime;
									petime = thedate + " " + petime;
								}
								Date st = sdt.parse(sdtime);//请假开始时间
								Date se = sdt.parse(edtime);//请假结束时间

								Date sp = sdt.parse(pstime);//班别开始时间
								Date ep = sdt.parse(petime);//班别结束时间
								String ss = "";
								String ee = "";
								if(st.getTime()>sp.getTime())//班别开始时间在请假时间段外
								{
									if(ep.getTime() >st.getTime() && ep.getTime()<=se.getTime())//班别结束时间在请假时间段内
									{
										ss = sdtime;
										ee = petime;
										if(thedate.equals(enddate))
										{
											ee = edtime;
										}
									}	
									if(ep.getTime() >se.getTime())
									{
										ss = sdtime;
										ee = edtime;
									}
								}
								else if(sp.getTime() >=st.getTime() && sp.getTime() <se.getTime())//班别开始时间在请假时间段内
								{
									if(ep.getTime()<se.getTime())//班别结束时间在请假时间段内
									{
										ss = pstime;
										ee = petime;
										if(thedate.equals(enddate))
										{
											ee = edtime;
										}
									}
									else//班别结束时间在请假时间段外
									{
										ss = pstime;
										ee = edtime;
									}
								}
								if(!ss.equals("") && !ee.equals(""))
								{
									ss = ss.split(" ")[1];
									ee = ee.split(" ")[1];

									String insql5 = "insert into uf_hr_kqdetail (id,requestid,psnno,psnname,dept,zc,kqtype,startdate,enddate,reason,yesno,thedate,appstart,append,objdept)values('"+IDGernerator.getUnquieID()+"','40285a8f5ce2350d015cf2e9900233b0','"+objno+"','"+ids+"','"+objdeptxt+"','"+zc+"','出差','"+starttime+"','"+endtime+"','"+allreson+"','40288098276fc2120127704884290210','"+thedate+"','"+startdate+"','"+enddate+"','"+objdept+"')";
									baseJdbc.update(insql5);
									sum = sum +1;
								}	
							}
						}
					}
					//获取外训信息
					sql2 = "select (select objname from orgunit where id = b.reqdept) as objdeptxt,b.reqdept objdept,b.lesson reason, b.location unit,b.sdate,b.stime,b.edate,b.etime from uf_hr_outlessonsub a left join uf_hr_outlesson b on a.requestid=b.requestid where a.objname = '"+ids+"' and b.isvalided = '40288098276fc2120127704884290210' and 1<>(select isdelete from requestbase where id = a.requestid) and '"+thedate+"' between b.sdate and b.edate";
					//System.out.println(sql2);
					list2 = baseJdbc.executeSqlForList(sql2);
					if(list2.size()>0)
					{
						for(int j = 0;j<list2.size();j++)
						{
							Map map1 = (Map)list2.get(j);
							
							String objdeptxt = StringHelper.null2String(map1.get("objdeptxt"));//员工所属部门
							String reason = StringHelper.null2String(map1.get("reason"));//事由
							String unit = StringHelper.null2String(map1.get("unit"));//拜访单位
							String startdate = StringHelper.null2String(map1.get("sdate"));//开始日期
							String starttime = StringHelper.null2String(map1.get("stime"));//开始时间
							String enddate = StringHelper.null2String(map1.get("edate"));//结束日期
							String endtime = StringHelper.null2String(map1.get("etime"));//结束时间
							String sdtime = startdate+" "+starttime;//开始日期时间
							String edtime = enddate +" "+endtime;//结束日期时间
							String objdept=StringHelper.null2String(map1.get("objdept"));

							String allreson = reason+"："+unit;
							String clsql1 = "select pstime,petime from uf_hr_classinfo where requestid=(select classno from uf_hr_classplan where objname = '"+ids+"' and thedate = '"+thedate+"')";
							List list4 = baseJdbc.executeSqlForList(clsql1);
							if(list4.size() >0)
							{
								Map cm1 = (Map)list4.get(0);
								String pstime = StringHelper.null2String(cm1.get("pstime"));//计划开始时间
								String petime = StringHelper.null2String(cm1.get("petime"));//计划结束时间
								SimpleDateFormat sft = new SimpleDateFormat("HH:mm:ss");
								Date ps = sft.parse(pstime);
								Date pe = sft.parse(petime);
								if(ps.getTime()>=pe.getTime())  //跨天
								{					
									cdr.setTime(theBegin);
									cdr.add(Calendar.DAY_OF_MONTH,1);
									String nextDay = ft.format(cdr.getTime());
									pstime = thedate + " " + pstime;
									petime = nextDay + " " + petime;
								}else{
									pstime = thedate + " " + pstime;
									petime = thedate + " " + petime;
								}
								Date st = sdt.parse(sdtime);//请假开始时间
								Date se = sdt.parse(edtime);//请假结束时间

								Date sp = sdt.parse(pstime);//班别开始时间
								Date ep = sdt.parse(petime);//班别结束时间
								String ss = "";
								String ee = "";
								if(st.getTime()>sp.getTime())//班别开始时间在请假时间段外
								{
									if(ep.getTime() >st.getTime() && ep.getTime()<=se.getTime())//班别结束时间在请假时间段内
									{
										ss = sdtime;
										ee = petime;
										if(thedate.equals(enddate))
										{
											ee = edtime;
										}
									}	
									if(ep.getTime() >se.getTime())
									{
										ss = sdtime;
										ee = edtime;
									}
								}
								else if(sp.getTime() >=st.getTime() && sp.getTime() <se.getTime())//班别开始时间在请假时间段内
								{
									if(ep.getTime()<se.getTime())//班别结束时间在请假时间段内
									{
										ss = pstime;
										ee = petime;
										if(thedate.equals(enddate))
										{
											ee = edtime;
										}
									}
									else//班别结束时间在请假时间段外
									{
										ss = pstime;
										ee = edtime;
									}
								}
								if(!ss.equals("") && !ee.equals(""))
								{
									ss = ss.split(" ")[1];
									ee = ee.split(" ")[1];

									String insql5 = "insert into uf_hr_kqdetail (id,requestid,psnno,psnname,dept,zc,kqtype,startdate,enddate,reason,yesno,thedate,appstart,append,objdept)values('"+IDGernerator.getUnquieID()+"','40285a8f5ce2350d015cf2e9900233b0','"+objno+"','"+ids+"','"+objdeptxt+"','"+zc+"','外训','"+starttime+"','"+endtime+"','"+allreson+"','40288098276fc2120127704884290210','"+thedate+"','"+startdate+"','"+enddate+"','"+objdept+"')";
									System.out.println(insql5);
									baseJdbc.update(insql5);
									sum = sum +1;
										
								}	
							}
						}
					}
				}
			}
		}
	}
	JSONObject jo = new JSONObject();		
	jo.put("sum", sum);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      