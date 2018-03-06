<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>


<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String reqman=StringHelper.null2String(request.getParameter("reqman"));
		String beginDate=StringHelper.null2String(request.getParameter("startdate"));
		String beginTime=StringHelper.null2String(request.getParameter("starttime"));
		String endDate=StringHelper.null2String(request.getParameter("enddate"));
		String endTime=StringHelper.null2String(request.getParameter("endtime"));
		String theType=StringHelper.null2String(request.getParameter("theType"));
		double hours = 0.0;
		boolean flag = true;
		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date theBegin = ft.parse(beginDate);
		Date theEnd = ft.parse(endDate);
		int nums = (int)((theEnd.getTime() - theBegin.getTime()) / 1000 / 60 / 60 / 24);
		Calendar cdr = Calendar.getInstance();		
		String pstime = "";
		String petime = "";
		String rstime = "";
		String retime = "";
		String classno = "";
		ArrayList<String> dateList = new ArrayList<String>();
		for(int i=0;i<nums+1;i++){	
			cdr.setTime(theBegin);
			cdr.add(Calendar.DAY_OF_MONTH,i);
			String today = ft.format(cdr.getTime());
			String sql = "select a.classno,a.pstime,a.petime,a.rstime,a.retime from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='"+reqman+"' and b.thedate='"+today+"'";
			List ls = baseJdbcDao.executeSqlForList(sql);
			if (ls.size()>0){
				Map m = (Map)ls.get(0);
				pstime = StringHelper.null2String(m.get("pstime"));
				petime = StringHelper.null2String(m.get("petime"));
				rstime = StringHelper.null2String(m.get("rstime"));
				retime = StringHelper.null2String(m.get("retime"));
				classno = StringHelper.null2String(m.get("classno"));
				SimpleDateFormat sft = new SimpleDateFormat("HH:mm:ss");
				Date ps = sft.parse(pstime);
				Date pe = sft.parse(petime);
				if(ps.getTime()>=pe.getTime()){//跨天					
					cdr.setTime(theBegin);
					cdr.add(Calendar.DAY_OF_MONTH,i+1);
					String nextDay = ft.format(cdr.getTime());
					pstime = today + " " + pstime;
					petime = nextDay + " " + petime;
				}else{
					pstime = today + " " + pstime;
					petime = today + " " + petime;
				}
				if(!rstime.equals("")){//含休息时间
					Date rs = sft.parse(rstime);
					Date re = sft.parse(retime);
					if(rs.getTime()<ps.getTime()){//开始休息时间、结束休息时间都跨天
						cdr.setTime(theBegin);
						cdr.add(Calendar.DAY_OF_MONTH,i+1);
						String nextDay = ft.format(cdr.getTime());
						rstime = nextDay + " " + rstime;
						retime = nextDay + " " + retime;
					}else if(rs.getTime()>=re.getTime()){//结束休息时间跨天
						cdr.setTime(theBegin);
						cdr.add(Calendar.DAY_OF_MONTH,i+1);
						String nextDay = ft.format(cdr.getTime());
						rstime = today + " " + rstime;
						retime = nextDay + " " + retime;
					}else{
						rstime = today + " " + rstime;
						retime = today + " " + retime;
					}
				}
				if(theType.equals("40285a904931f62b014936582eae18d3") || (!theType.equals("40285a904931f62b014936582eae18d3") && !classno.equals("OFF"))){//含休假或（不含休假且班别编号不为OFF）
					dateList.add(pstime);//计划开始时间
					if(!rstime.equals("")){
						dateList.add(rstime);//休息开始时间
						dateList.add(retime);//休息结束时间
					}					
					dateList.add(petime);//计划结束时间
				}
			}else{
				flag = false;
				break;
			}
		}
		if(flag && dateList.size()>0){
			String beginDateTime = beginDate + " " + beginTime;
			String endDateTime = endDate + " " + endTime;
			SimpleDateFormat sdt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date sp = sdt.parse(beginDateTime);
			Date ep = sdt.parse(endDateTime);
			Date listBegin = sdt.parse(dateList.get(0));
			Date listEnd = sdt.parse(dateList.get(dateList.size()-1));
			if(sp.getTime()>=ep.getTime()){
				hours = 0.0;
			}else{
				if(ep.getTime()<=listBegin.getTime()){//请假结束时间比排班开始时间早
					hours = 0.0;
				}else if(sp.getTime()>=listEnd.getTime()){//请假开始时间比排班开始时间晚
					hours = 0.0;
				}else{
					//开始时间在时间轴上的处理
					int begin = -1;
					for(int i=0;i<dateList.size();i++){
						Date listDate = sdt.parse(dateList.get(i));
						if(sp.getTime()>listDate.getTime()){
							begin = i;
						}
					}
					if(begin!=-1){
						if(begin % 2 == 0){//偶数位
							dateList.set(begin, beginDateTime);	
							for(int m=0;m<begin;m++){
								dateList.remove(0);
							}
						}else{//奇数位
							for(int m=0;m<begin+1;m++){
								dateList.remove(0);
							}
						}
					}
					//结束时间在时间轴上的处理
					int end = 0;
					for(int i=0;i<dateList.size();i++){
						Date listDate = sdt.parse(dateList.get(i));
						if(ep.getTime()>=listDate.getTime()){
							end = i;
						}
					}
					if(end % 2 == 0){
						//插入结束时间
						dateList.set(end+1, endDateTime);
						//清楚结束时间后面的值
						int thesize = dateList.size();
						for(int m=(end+2);m<thesize;m++){
							dateList.remove(end+2);
						}
					}else{
						int thesize = dateList.size();
						for(int m=(end+1);m<thesize;m++){
							dateList.remove(end+1);
						}
					}
					//时数计算
					for(int n=1;n<dateList.size();n+=2){
						Date s = sdt.parse(dateList.get(n-1));
						Date e = sdt.parse(dateList.get(n));
						hours = hours + (e.getTime()-s.getTime()) / 1000.000 / 60 / 60;
						
					}
				}				
			}			
		}else{
			hours = 0.0;
		}		
		JSONObject jo = new JSONObject();		
		jo.put("total", String.format("%.2f",hours));
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
	if(action.equals("getQuo")){
		String objvalue=StringHelper.null2String(request.getParameter("objvalue"));//请假扣减定额
		String hid=StringHelper.null2String(request.getParameter("hid"));//sap员工编号
		String sday=StringHelper.null2String(request.getParameter("sday"));//请假开始日期
		double total = 0.00;
		String[] obj = objvalue.split(",");
		for(int i=0;i<obj.length;i++){
			String sql = "select quoid from uf_hr_quota where requestid='"+obj[i]+"'";//获取请假定额SAP编码
			DataService ds = new DataService();
			String quoid = ds.getValue(sql);
			if(quoid.length()>1){		
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT2006_GET";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				sday = sday.replace("-", "");
				//插入字段
				function.getImportParameterList().setValue("PERNR",hid);
				function.getImportParameterList().setValue("KTART",quoid);
				function.getImportParameterList().setValue("ENDDA",sday);

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				//返回值
				JCoTable retTable = function.getTableParameterList().getTable("IT2006");
				Map<String,String> retMap = new HashMap<String,String>();
				if (retTable != null) {
					for (int n = 0; n < retTable.getNumRows(); n++) {
						String ZEINH = StringHelper.null2String(retTable.getString("ZEINH"));
						String ANZHL = StringHelper.null2String(retTable.getString("ANZHL"));
						if(ZEINH.equals("010")){
							retMap.put(n+"",StringHelper.null2String(Double.valueOf(ANZHL)*8)); 
						}else retMap.put(n+"",ANZHL); 
						retTable.nextRow();
					}
				}
				if(retMap.size()>0){
					total = total + Double.valueOf(retMap.get("0"));
				}
			}			
		}
		
		JSONObject jo = new JSONObject();	
		jo.put("old",String.format("%.2f",total));		
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>
