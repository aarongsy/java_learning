<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.cowork.model.*"%>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%
String type=StringHelper.null2String(request.getParameter("type"));
String tagid=StringHelper.null2String(request.getParameter("tagid"));
String searchtype=StringHelper.null2String(request.getParameter("searchtype"));
String searchobjname=StringHelper.null2String(request.getParameter("searchobjname"));
String order=StringHelper.null2String(request.getParameter("order"));
String coworkid = StringHelper.null2String(request.getParameter("coworkid"));
String userid = StringHelper.null2String(request.getParameter("userid"));
String action = StringHelper.null2String(request.getParameter("action"));
//userid = "402881e70be6d209010be75668750014";
%>
<html>
<body>
<%
int pageNo = 1;
int pageSize = 1000;
/*计算总页数*/
CoWorkService coWorkService = new CoWorkService();
String jsonStr = "";
if(StringHelper.isEmpty(action)) {	
	jsonStr = coWorkService.getCoworkNavigationJson(userid,tagid,type,searchtype,searchobjname,pageNo,pageSize,order);
} else {
	jsonStr = coWorkService.getAllUnreadJson(userid,tagid,type,searchtype,searchobjname,pageNo,pageSize,order);
}
if (jsonStr != null && !"".equals(jsonStr)) {
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jsonStr);
	response.getWriter().flush();
	response.getWriter().close();
}
%>

</body>
</html>
  