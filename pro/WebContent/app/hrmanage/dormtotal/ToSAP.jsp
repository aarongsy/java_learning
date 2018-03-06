<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>

<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("toSap")){	
		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");		
		JSONObject jo = new JSONObject();		
		String sql = "select id,sapid,valimonth,nowtype from uf_hr_dormtotalsub where requestid='"+requestid+"' and NVL(msgtype,'0')<>'I'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				
				Map map = (Map)list.get(i);
				String theId = StringHelper.null2String(map.get("id"));//生效月份
				String theMonth = StringHelper.null2String(map.get("valimonth"));//生效月份
				theMonth = theMonth.replace("-", "");
				theMonth = theMonth + "01";
				String sapid = StringHelper.null2String(map.get("sapid"));//SAP员工工号
				String nowtype = StringHelper.null2String(map.get("nowtype"));//勤宿状态
				String money = "0";
				if(nowtype.equals("40285a904931f62b0149560be5650421")){
					money = "100";
				}
				//创建SAP对象		
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT0014_S1_CREATE";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				System.out.println("PERNR:"+sapid+",BEGDA:"+theMonth+",ENDDA:99991231,LGART:7060,BETRG:"+money+",WAERS：RMB");
				//插入字段
				function.getImportParameterList().setValue("PERNR",sapid);
				function.getImportParameterList().setValue("BEGDA",theMonth);
				function.getImportParameterList().setValue("ENDDA","99991231");
				function.getImportParameterList().setValue("LGART","7060");
				function.getImportParameterList().setValue("BETRG",money);
				function.getImportParameterList().setValue("WAERS","RMB");

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
					jo.put("msg","true");
				} catch (JCoException e) {
					// TODO Auto-generated catch block  
					jo.put("msg","false");
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					jo.put("msg","false");
					e.printStackTrace();
				}

				//返回值
				String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
				String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
				String upsql="update uf_hr_dormtotalsub set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where id='"+theId+"'";
				baseJdbc.update(upsql);
			}		
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>