<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ include file="/base/init.jsp"%>
<%
String type=StringHelper.null2String(request.getParameter("type"));
String sendTo=new String(StringHelper.null2String(request.getParameter("sendTo")).getBytes("iso-8859-1"),"gb2312");
//String sendTo = StringHelper.null2String(request.getParameter("sendTo"));
//sendTo=new String(sendTo.getBytes("gb2312"),"utf-8");
DataService dataService = new DataService();
String sendToUserId="";
if(sendTo.indexOf("@")!=-1) sendTo=sendTo.substring(0,sendTo.indexOf("@"));
List humresids = dataService.getValues("select objid from sysuser where longonname='"+sendTo+"'");
if (humresids != null && humresids.size() > 0) {
  for (int i = 0 ; humresids != null && i < humresids.size() ; i++) {
     Map map = (Map) humresids.get(i);
     if (map != null) {
        sendToUserId=StringHelper.null2String(map.get("objid"));
     }
  }
}
if("history".equals(type)) {
	response.sendRedirect("/messager/MsgSearch.jsp?userId="+sendToUserId);
}
%>
