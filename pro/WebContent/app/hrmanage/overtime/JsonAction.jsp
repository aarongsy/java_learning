<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%
//读取SAP打卡数据
	String sapobjid=StringHelper.null2String(request.getParameter("sapobjid"));
	String theday=StringHelper.null2String(request.getParameter("theday"));
	String thetime=StringHelper.null2String(request.getParameter("thetime"));
	String type=StringHelper.null2String(request.getParameter("type"));
	//创建SAP对象
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZHR_TEVENT_GET";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//传入参数
	function.getImportParameterList().setValue("PERNR",sapobjid);
	function.getImportParameterList().setValue("LDATE",theday);
	function.getImportParameterList().setValue("LTIME",thetime);
	try {
		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
	} catch (JCoException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//获取表数据
	List list = new ArrayList();
	JCoTable retTable = function.getTableParameterList().getTable("TEVENT");
	if(retTable != null){
		for(int i=0;i<retTable.getNumRows();i++){
			Map<String,String> retMap = new HashMap<String,String>();
			String cardtype = StringHelper.null2String(retTable.getString("SATZA"));//进厂卡、出厂卡
			if(cardtype.equals(type)){
				String sapdate = StringHelper.null2String(retTable.getString("LDATE"));
				String saptime = StringHelper.null2String(retTable.getString("LTIME"));
				retMap.put("thedate", sapdate);
				retMap.put("thetime", saptime);
				list.add(retMap);
			}			
			retTable.nextRow();
		}
	}
	JSONObject jo = new JSONObject();
	if(list.size()>0){
		if(type.equals("P10")){//进厂卡
			Map<String,String> map = (HashMap<String,String>)list.get(0);
			try {
				jo.put("thedate", StringHelper.null2String(map.get("thedate")));
				jo.put("thetime", StringHelper.null2String(map.get("thetime")));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(type.equals("P20")){//出厂卡
			Map<String,String> map = (HashMap<String,String>)list.get(list.size()-1);
			try {
				jo.put("thedate", StringHelper.null2String(map.get("thedate")));
				jo.put("thetime", StringHelper.null2String(map.get("thetime")));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}else {
		jo.put("thedate","");
		jo.put("thetime","");
	}

	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
