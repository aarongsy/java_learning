<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
        String ccode=StringHelper.null2String(request.getParameter("ccode"));
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
		System.out.println(requestid);
		String selloutno=StringHelper.null2String(request.getParameter("selloutno"));//售达方简码


		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_GET_CUSTOMER_CREDIT";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			//插入字段

			function.getImportParameterList().setValue("P_KUNNR","KSMH02");//客户简码
			function.getImportParameterList().setValue("P_KKBER","1010");//公司代码
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}


			String P_FLAG = function.getExportParameterList().getValue("P_FLAG").toString();
			String P_LEFT = function.getExportParameterList().getValue("P_LEFT").toString();
			System.out.println("----剩余额度--------:"+P_LEFT);

			String upsql = "update uf_lo_passfactory  set freeze='"+P_FLAG+"',leftnum='"+P_LEFT+"' where  requestid = '"+requestid+"'";
			System.out.println(upsql);
			baseJdbc.update(upsql);
			JSONObject jo = new JSONObject();		
			jo.put("msg", P_FLAG);
			jo.put("acdocno", P_LEFT);
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			//System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
	

%>








