<%@ page language="java" contentType="application/json"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.app.sap.sjzg.SJZG_getSubjectType"%>
<%
	String EBELN = StringHelper.null2String(request.getParameter("EBELN"));
	String EBELP = StringHelper.null2String(request.getParameter("EBELP"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();
	String msg = "";
	if (!EBELN.equals("") && !EBELP.equals("")) {
		try {
			SJZG_getSubjectType temp = new SJZG_getSubjectType();
			msg = temp.findData(EBELN, EBELP);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	jo.put("msg", msg);
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
