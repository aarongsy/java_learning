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
	    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		//System.out.println("start..............");
		String hid=StringHelper.null2String(request.getParameter("hid"));//sap员工编号
		String currentdate=StringHelper.null2String(request.getParameter("currentdate"));//当前年度的年
		String lastdate=StringHelper.null2String(request.getParameter("lastdate"));//当前年的上一年
		//System.out.println(hid);
		double total = 0.00;
		String quoid = "10";		
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
				//sday = sday.replace("-", "");
				//插入字段
				function.getImportParameterList().setValue("PERNR",hid);//sap员工编号
				function.getImportParameterList().setValue("KTART",quoid);//请假定额SAP编码
				function.getImportParameterList().setValue("BEGDA",lastdate+"1101");//请假开始日期(上一年度的11月1号)
				function.getImportParameterList().setValue("ENDDA",currentdate+"1031");//请假结束日期(当前年度的10月31号)
				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//System.out.println();
				//返回值
				String ANZHL="";
				String ZEINH="";
				JCoTable retTable = function.getTableParameterList().getTable("IT2006");
				Map<String,String> retMap = new HashMap<String,String>();
				//System.out.println(retTable.getNumRows());
				if (retTable != null) {
					for (int n = 0; n < retTable.getNumRows(); n++) {
						 ZEINH = StringHelper.null2String(retTable.getString("ZEINH"));
						 ANZHL = StringHelper.null2String(retTable.getString("ANZHL"));
						if(ZEINH.equals("010")){
							retMap.put(n+"",StringHelper.null2String(Double.valueOf(ANZHL)*8)); 
						}else retMap.put(n+"",ANZHL);
						//System.out.println(ZEINH+":"+ANZHL);
						retTable.nextRow();
					}
				}
				if(retMap.size()>0){
					total = total + Double.valueOf(retMap.get("0"));
				}

		JSONObject jo = new JSONObject();	
		jo.put("old",String.format("%.2f",total));		
		jo.put("ANZHL",ANZHL);	
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
%>
