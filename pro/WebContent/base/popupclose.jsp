<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String objid = StringHelper.null2String(request.getParameter("objid"));
String objname = StringHelper.getDecodeStr(StringHelper.null2String(request.getParameter("objname")));
%>
<SCRIPT LANGUAGE=javascript>
     window.parent.returnValue = new Array("<%=objid%>","<%=objname%>");     
     window.parent.close();
</SCRIPT>