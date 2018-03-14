<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%
/**
**s代表请假开始时间，e代表请假结束时间,osp代表开始日期的班别的计划开始时间,oep代表开始日期班别的计划结束时间,tsp代表结束日期的班别的计划开始时间,tep代表结束日期班别的计划结束时间,sr代表班别的休息开始时间,er代表班别的休息结束时间
**/
	DataService ds = new DataService();
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String reqman=StringHelper.null2String(request.getParameter("reqman"));
		String startdate=StringHelper.null2String(request.getParameter("startdate"));
		String starttime=StringHelper.null2String(request.getParameter("starttime"));
		String enddate=StringHelper.null2String(request.getParameter("enddate"));
		String endtime=StringHelper.null2String(request.getParameter("endtime"));
		String therules=StringHelper.null2String(request.getParameter("therules"));
		JSONObject jo = new JSONObject();		
		if (startdate.equals(enddate)){//同一天
			//获取班别信息
			String sql = "select a.requestid,a.pstime,a.petime,a.rstime,a.retime from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='"+reqman+"' and b.thedate='"+startdate+"'";
			List ls = baseJdbcDao.executeSqlForList(sql);
			if (ls.size()>0){
				Map m = (Map)ls.get(0);
				String pstime = StringHelper.null2String(m.get("pstime"));
				String petime = StringHelper.null2String(m.get("petime"));
				String rstime = StringHelper.null2String(m.get("rstime"));
				String retime = StringHelper.null2String(m.get("retime"));
				String reqid = StringHelper.null2String(m.get("requestid"));
				if((reqid.equals("40285a904931f62b014937218d0b2bc6") || reqid.equals("40285a904931f62b014937218df82c0e")) && therules.equals("40285a904931f62b014936582eae18d4")){//休息班时且请假类型不含假期时不计算
					jo.put("MSG", "false");
				}else{
					SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date s = ft.parse(startdate+" "+starttime);
					Date sp = ft.parse(startdate+" "+pstime);
					Date e = ft.parse(startdate+" "+endtime);
					Date ep = ft.parse(startdate+" "+petime);
					if (rstime.equals("")){//无休息时间
						//判断请假开始时间是否大于班别开始时间															
						Date st = null;
						if (s.getTime()>sp.getTime()){
							st = s; 
						} else st = sp;		
						//判断请假结束时间是否大于班别结束时间					
						Date en = null;
						if (e.getTime()>ep.getTime()){
							en = ep;
						} else en = e;
						//计算请假时数
						if ((s.getTime()>ep.getTime()) || (e.getTime()<sp.getTime())){//开始时间晚于计划结束时间或结束时间早于计划开始时间
							jo.put("MSG", "false");
						} else {
							double a = (en.getTime() - st.getTime()) / 1000.000 / 60 / 60;
							jo.put("MSG","true");
							jo.put("total",String.format("%.2f",a));
						}					
					}else{//有休息时间
						String msg = "true";
						double a = 0.0;
						double b = 0.0;
						Date sr = ft.parse(startdate+" "+rstime);
						Date er = ft.parse(startdate+" "+retime);
						if (s.getTime()<=sp.getTime()){
							if (e.getTime()<=sp.getTime()){
								msg = "false";
							}else if(e.getTime()>=sp.getTime() && e.getTime()<=sr.getTime()){
								msg = "true";
								a = e.getTime() - sp.getTime();
								b = 0;
							}else if(e.getTime()>sr.getTime() && e.getTime()<er.getTime()){
								msg = "true";
								a = sr.getTime() - sp.getTime();
								b = 0;
							}else if(e.getTime()>=er.getTime() && e.getTime()<=ep.getTime()){
								msg = "true";
								a = sr.getTime() - sp.getTime();
								b = e.getTime() - er.getTime();
							}else if(e.getTime()>sp.getTime()){
								msg = "true";
								a = sr.getTime() - sp.getTime();
								b = ep.getTime() - er.getTime();
							}
						}else if(s.getTime()>sp.getTime() && s.getTime()<=sr.getTime()){
							if(e.getTime()<sp.getTime()){
								msg = "false";
							}else if(e.getTime()>=sp.getTime() && e.getTime()<=sr.getTime()){
								msg = "true";
								a = e.getTime() - s.getTime();
								b = 0;
							}else if(e.getTime()>sr.getTime() && e.getTime()<er.getTime()){
								msg = "true";
								a = sr.getTime() - s.getTime();
								b = 0;
							}else if(e.getTime()>=er.getTime() && e.getTime()<=ep.getTime()){
								msg = "true";
								a = sr.getTime() - s.getTime();
								b = e.getTime() - er.getTime();
							}else if(e.getTime()>ep.getTime()){
								msg = "true";
								a = sr.getTime() - s.getTime();
								b = ep.getTime() - er.getTime();
							}
						}else if(s.getTime()>sr.getTime() && s.getTime()<er.getTime()){
							if(e.getTime()<=er.getTime()){
								msg = "false";
							}else if(e.getTime()>er.getTime() && e.getTime()<ep.getTime()){
								msg = "true";
								a = e.getTime() - er.getTime();
								b = 0;
							}else if(e.getTime()>=ep.getTime()){
								msg = "true";
								a = ep.getTime() - er.getTime();
								b = 0;
							}
						}else if(s.getTime()>=er.getTime() && s.getTime()<ep.getTime()){
							if(e.getTime()<=er.getTime()){
								msg = "false";
							}else if(e.getTime()>er.getTime() && e.getTime()<ep.getTime()){
								msg = "true";
								a = e.getTime() - s.getTime();
								b = 0;
							}else if(e.getTime()>=ep.getTime()){
								msg = "true";
								a = ep.getTime() - s.getTime();
								b = 0;
							}
						}else if(s.getTime()<=ep.getTime()){
							msg = "false";
						}
						if(msg.equals("true")){
							double total = (a+b) / 1000.000 / 60 / 60 ;
							jo.put("MSG","true");
							jo.put("total",String.format("%.2f",total));
						}else jo.put("MSG","false");
					}
				}
			} else {//无班别信息时直接返回				
				jo.put("MSG","false");
			}
		}else {//跨天时
			String msg = "true";
			double a = 0.0;
			double b = 0.0;
			double c = 0.0;
			SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			//开始日期的班别信息
			String sql = "select a.requestid,a.pstime,a.petime,a.rstime,a.retime from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='"+reqman+"' and b.thedate='"+startdate+"'";
			List ls = baseJdbcDao.executeSqlForList(sql);
			//结束日期的班别信息
			String sql2 = "select a.requestid,a.pstime,a.petime,a.rstime,a.retime from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='"+reqman+"' and b.thedate='"+enddate+"'";
			List ls2 = baseJdbcDao.executeSqlForList(sql2);
			if (ls.size()>0 && ls2.size()>0){
				//开始日期
				Map m = (Map)ls.get(0);
				String spstime = StringHelper.null2String(m.get("pstime"));
				String spetime = StringHelper.null2String(m.get("petime"));
				String srstime = StringHelper.null2String(m.get("rstime"));
				String sretime = StringHelper.null2String(m.get("retime"));
				String sreqid = StringHelper.null2String(m.get("requestid"));				
				Date s = ft.parse(startdate+" "+starttime);//开始时间
				Date osp = ft.parse(startdate+" "+spstime);//开始日期班别计划开始时间
				Date oep = ft.parse(startdate+" "+spetime);//开始日期班别计划结束时间
				
				//结束日期
				Map m2 = (Map)ls2.get(0);
				String epstime = StringHelper.null2String(m2.get("pstime"));
				String epetime = StringHelper.null2String(m2.get("petime"));
				String erstime = StringHelper.null2String(m2.get("rstime"));
				String eretime = StringHelper.null2String(m2.get("retime"));
				String ereqid = StringHelper.null2String(m2.get("requestid"));
				Date e = ft.parse(enddate+" "+endtime);//结束时间
				Date tsp = ft.parse(enddate+" "+epstime);//结束时间班别计划开始时间
				Date tep = ft.parse(enddate+" "+epetime);//结束时间班别计划结束时间
				if(((sreqid.equals("40285a904931f62b014937218d0b2bc6") || sreqid.equals("40285a904931f62b014937218df82c0e")) && therules.equals("40285a904931f62b014936582eae18d4")) && (!sreqid.equals("40285a904931f62b014937218d0b2bc6") && !sreqid.equals("40285a904931f62b014937218df82c0e"))){//开始日期为休息班，结束日期不为休息班
					a = 0.0;
					if(erstime.equals("")){//结束日期不含休息时数
						if(e.getTime()<=tsp.getTime()){
							b = 0.0;
						}else if(e.getTime()>tsp.getTime() && e.getTime()<tep.getTime()){
							b = e.getTime() - tsp.getTime();
						}else if(e.getTime()>=tep.getTime()){
							b = tep.getTime() - tsp.getTime();
						}
					}else{//结束日期含休息时数
						Date sr = ft.parse(enddate+" "+erstime);
						Date er = ft.parse(enddate+" "+eretime);
						if(e.getTime()<=tsp.getTime()){
							b = 0.0;
						}else if(e.getTime()>tsp.getTime() && e.getTime()<sr.getTime()){
							b = e.getTime() - tsp.getTime();
						}else if(e.getTime()>=tep.getTime() && e.getTime()<=sr.getTime()){
							b = sr.getTime() - tsp.getTime();
						}else if(e.getTime()>sr.getTime() && e.getTime()<er.getTime()){
							b = (sr.getTime() - tsp.getTime()) + (e.getTime() - er.getTime());
						}else if(e.getTime()>=er.getTime()){
							b = (sr.getTime() - tsp.getTime()) + (tep.getTime() - er.getTime());
						}
					}
				}else if((sreqid.equals("40285a904931f62b014937218d0b2bc6") || sreqid.equals("40285a904931f62b014937218df82c0e")) && (sreqid.equals("40285a904931f62b014937218d0b2bc6") || sreqid.equals("40285a904931f62b014937218df82c0e"))){//开始日期为休息班，结束日期为休息班
					a = 0.0;
					b = 0.0;
				}else if((!sreqid.equals("40285a904931f62b014937218d0b2bc6") && !sreqid.equals("40285a904931f62b014937218df82c0e")) && (sreqid.equals("40285a904931f62b014937218d0b2bc6") || sreqid.equals("40285a904931f62b014937218df82c0e"))){//开始日期不为休息班，结束日期为休息班
					b = 0.0;
					if(srstime.equals("")){//开始日期不含休息时数
						if(s.getTime()<=osp.getTime()){
							a = 0.0;
						}else if(s.getTime()>osp.getTime() && s.getTime()<oep.getTime()){
							a = s.getTime() - osp.getTime();
						}else if(s.getTime()>=oep.getTime()){
							a = oep.getTime() - osp.getTime();
						}
					}else{//开始日期含休息时数
						Date sr = ft.parse(enddate+" "+srstime);
						Date er = ft.parse(enddate+" "+sretime);
						if(s.getTime()<=osp.getTime()){
							a = 0.0;
						}else if(s.getTime()>osp.getTime() && s.getTime()<sr.getTime()){
							a = s.getTime() - osp.getTime();
						}else if(s.getTime()>=sr.getTime() && s.getTime()<=er.getTime()){
							a = sr.getTime() - osp.getTime();
						}else if(s.getTime()>er.getTime() && s.getTime()<oep.getTime()){
							a = (sr.getTime()-osp.getTime()) + (s.getTime() - er.getTime());
						}else if(s.getTime()>=oep.getTime()){
							a = (sr.getTime() - osp.getTime()) + (oep.getTime() - er.getTime());
						}
					}
				}else if((!sreqid.equals("40285a904931f62b014937218d0b2bc6") && !sreqid.equals("40285a904931f62b014937218df82c0e")) && (!sreqid.equals("40285a904931f62b014937218d0b2bc6") && !sreqid.equals("40285a904931f62b014937218df82c0e"))){//开始日期不为休息班，结束日期不为休息班
					if(srstime.equals("") && erstime.equals("")){//开始不含休息，结束不含休息
						if(e.getTime()<=tsp.getTime()){
							a = 0.0;
						}else if(e.getTime()>tsp.getTime() && e.getTime()<tep.getTime()){
							a = e.getTime() - tsp.getTime();
						}else if(e.getTime()>=tep.getTime()){
							a = tep.getTime() - tsp.getTime();
						}
						if(s.getTime()<=osp.getTime()){
							b = 0.0;
						}else if(s.getTime()>osp.getTime() && s.getTime()<oep.getTime()){
							b = s.getTime() - osp.getTime();
						}else if(s.getTime()>=oep.getTime()){
							b = oep.getTime() - osp.getTime();
						}
					}else if(srstime.equals("") && !erstime.equals("")){//开始不含休息，结束含休息
						if(e.getTime()<=tsp.getTime()){
							a = 0.0;
						}else if(e.getTime()>tsp.getTime() && e.getTime()<tep.getTime()){
							a = e.getTime() - tsp.getTime();
						}else if(e.getTime()>=tep.getTime()){
							a = tep.getTime() - tsp.getTime();
						}
						Date sr = ft.parse(enddate+" "+erstime);
						Date er = ft.parse(enddate+" "+eretime);
						if(e.getTime()<=tsp.getTime()){
							b = 0.0;
						}else if(e.getTime()>tsp.getTime() && e.getTime()<sr.getTime()){
							b = e.getTime() - tsp.getTime();
						}else if(e.getTime()>=tep.getTime() && e.getTime()<=sr.getTime()){
							b = sr.getTime() - tsp.getTime();
						}else if(e.getTime()>sr.getTime() && e.getTime()<er.getTime()){
							b = (sr.getTime() - tsp.getTime()) + (e.getTime() - er.getTime());
						}else if(e.getTime()>=er.getTime()){
							b = (sr.getTime() - tsp.getTime()) + (tep.getTime() - er.getTime());
						}
					}else if(!srstime.equals("") && erstime.equals("")){//开始含休息，结束不含休息
						Date sr = ft.parse(enddate+" "+srstime);
						Date er = ft.parse(enddate+" "+sretime);
						if(s.getTime()<=osp.getTime()){
							a = 0.0;
						}else if(s.getTime()>osp.getTime() && s.getTime()<sr.getTime()){
							a = s.getTime() - osp.getTime();
						}else if(s.getTime()>=sr.getTime() && s.getTime()<=er.getTime()){
							a = sr.getTime() - osp.getTime();
						}else if(s.getTime()>er.getTime() && s.getTime()<oep.getTime()){
							a = (sr.getTime()-osp.getTime()) + (s.getTime() - er.getTime());
						}else if(s.getTime()>=oep.getTime()){
							a = (sr.getTime() - osp.getTime()) + (oep.getTime() - er.getTime());
						}
						if(s.getTime()<=osp.getTime()){
							b = 0.0;
						}else if(s.getTime()>osp.getTime() && s.getTime()<oep.getTime()){
							b = s.getTime() - osp.getTime();
						}else if(s.getTime()>=oep.getTime()){
							b = oep.getTime() - osp.getTime();
						}
						
					}else if(!srstime.equals("") && !erstime.equals("")){//开始含休息，结束含休息
						Date sr = ft.parse(enddate+" "+srstime);
						Date er = ft.parse(enddate+" "+sretime);
						if(s.getTime()<=osp.getTime()){
							a = 0.0;
						}else if(s.getTime()>osp.getTime() && s.getTime()<sr.getTime()){
							a = s.getTime() - osp.getTime();
						}else if(s.getTime()>=sr.getTime() && s.getTime()<=er.getTime()){
							a = sr.getTime() - osp.getTime();
						}else if(s.getTime()>er.getTime() && s.getTime()<oep.getTime()){
							a = (sr.getTime()-osp.getTime()) + (s.getTime() - er.getTime());
						}else if(s.getTime()>=oep.getTime()){
							a = (sr.getTime() - osp.getTime()) + (oep.getTime() - er.getTime());
						}
						Date esr = ft.parse(enddate+" "+erstime);
						Date eer = ft.parse(enddate+" "+eretime);
						if(e.getTime()<=tsp.getTime()){
							b = 0.0;
						}else if(e.getTime()>tsp.getTime() && e.getTime()<esr.getTime()){
							b = e.getTime() - tsp.getTime();
						}else if(e.getTime()>=tep.getTime() && e.getTime()<=esr.getTime()){
							b = esr.getTime() - tsp.getTime();
						}else if(e.getTime()>esr.getTime() && e.getTime()<eer.getTime()){
							b = (esr.getTime() - tsp.getTime()) + (e.getTime() - eer.getTime());
						}else if(e.getTime()>=eer.getTime()){
							b = (esr.getTime() - tsp.getTime()) + (tep.getTime() - eer.getTime());
						}
					}
				}				
			}else{//无班别的情况
				msg = "false";
			}
			//跨多天的情况
			SimpleDateFormat sft = new SimpleDateFormat("yyyy-MM-dd");
			Date thestart = sft.parse(startdate);
			Date theend = sft.parse(enddate);
			int dnums = (int)((theend.getTime() - thestart.getTime()) / 1000 / 60 / 60 / 24);
			if(dnums > 1){
				Calendar cdr = Calendar.getInstance();
				for(int i=1;i<dnums;i++){
					cdr.setTime(thestart);
					cdr.add(Calendar.DAY_OF_MONTH,i);
					String nextDate = sft.format(cdr.getTime());
					
				}
			}
			if(msg.equals("true")){
				double total = (a+b+c) / 1000.000 / 60 / 60 ;
				jo.put("MSG","true");
				jo.put("total",String.format("%.2f",total));
			}else{
				jo.put("MSG","false");
				jo.put("total",0);
			}
		}

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>