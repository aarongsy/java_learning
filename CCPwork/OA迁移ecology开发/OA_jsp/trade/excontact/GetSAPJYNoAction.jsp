<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	String deliveryno = "";
	String opthtml = "";
	 
	if (action.equals("getData")){
		String orderno=StringHelper.null2String(request.getParameter("orderno"));
		//System.out.println("orderno="+orderno +" ");
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_SD_OUTBD_INFO";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("VBELN",orderno);

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
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		 //System.out.println("ERR_MSG="+ERR_MSG + " FLAG="+FLAG);
		if ("X".equals(FLAG)) {
			JCoTable jcotable = function.getTableParameterList().getTable("SD_OUTBD_INFO");
			//JSONArray array = new JSONArray();
			if (jcotable != null) {
			  for (int i = 0; i < jcotable.getNumRows(); i++) {
				jcotable.setRow(i);
				String jyno = StringHelper.null2String(jcotable.getString("VBELN"));
				if ( i==0) {					
					deliveryno = jyno; 	//交运编号
					opthtml = "<OPTION value='"+jyno+"'>"+jyno+"</OPTION>";  
				}else{
					deliveryno = deliveryno +"/"+ jyno; 
					opthtml = opthtml + "<OPTION value='"+jyno+"'>"+jyno+"</OPTION>";  
				}
			  }
			}
			//System.out.println("deliveryno="+deliveryno + " opthtml="+opthtml);
		}
		JSONObject jo = new JSONObject();		
		jo.put("msg", ERR_MSG);
		jo.put("flag", FLAG);
		jo.put("deliveryno", deliveryno);
		jo.put("opthtml", opthtml);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>
