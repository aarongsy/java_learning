<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>



<%

EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
	response.sendRedirect("/main/login.jsp");
	return;
}
Humres currentuser = eweaveruser.getHumres();
%>


</html>