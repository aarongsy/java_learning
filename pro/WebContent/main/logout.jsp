<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="/base/init.jsp"%>

<%	
	request.getSession(true).removeValue("eweaverusermoniter") ;
	request.getSession(true).removeValue("eweaver_user@bean") ;
	request.getSession(true).invalidate() ;
	BaseContext.killRemoteUser();
	/***********************************注销的时候注销论坛的用户 start***************************/
	Client uc = new Client();
	String ucsynlogout = uc.uc_user_synlogout();
	request.getSession().setAttribute("ucsynlogout",ucsynlogout);
	request.setAttribute("ucsynlogout",ucsynlogout);
	out.println("注销成功"+ ucsynlogout);
	/***********************************注销的时候注销论坛的用户 end ***************************/
	//response.sendRedirect("/main/login.jsp");
%>
<script>
    location.replace('<%=request.getContextPath()%>/main/login.jsp');
</script>