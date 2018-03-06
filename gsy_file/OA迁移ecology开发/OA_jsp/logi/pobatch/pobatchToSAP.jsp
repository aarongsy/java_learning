<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.app.weight.servlet.Uf_lo_pobatchToSapAction"%>

<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	//DataService ds = new DataService();
	String action = StringHelper.null2String(request.getParameter("action")); 	
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	JSONObject jsonObject = new JSONObject();
	System.out.println("action="+action+" requestid="+requestid);
	
	if ( "multi".equals(action) ) {
		Uf_lo_pobatchToSapAction app = new Uf_lo_pobatchToSapAction();
		String flag = app.pobatchToSap(requestid);
		if( "".equals(flag) ){
			jsonObject.put("msg","true");
			jsonObject.put("info","批量上抛SAP成功");
		} else {		
			jsonObject.put("msg","false");
			jsonObject.put("info","批量上抛SAP失败"+flag);	
		}
	}
	if ( "single".equals(action) ) {
		String id = StringHelper.null2String(request.getParameter("id"));
		Uf_lo_pobatchToSapAction app = new Uf_lo_pobatchToSapAction();
		String flag = app.pobatchToSapBySingle(requestid,id);
		if( "".equals(flag) ){
			jsonObject.put("msg","true");
			jsonObject.put("info","单条上抛SAP成功");
		} else {		
			jsonObject.put("msg","false");
			jsonObject.put("info","单条上抛SAP失败"+flag);	
		}
	}	
	response.getWriter().write(jsonObject.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>