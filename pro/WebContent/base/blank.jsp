<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String tagetUrl = StringHelper.trimToNull(request.getParameter("tagetUrl"));
if(StringHelper.trimToNull(request.getParameter("isclose"))!=null){%>
<script language='javascript'>
	if(window.opener!=null){//关闭window.open窗口
		<%if(tagetUrl!=null){%>
		window.opener.location = '<%=tagetUrl%>';
		<%}else{%>	
		window.opener.location.reload();
		<%}%>	
		self.close();
	}else if(window.dialogArguments!=null){//关闭showmodeldialog窗口,
		<%if(tagetUrl!=null){%>
			window.dialogArguments.location = '<%=tagetUrl%>';
		<%}else{%>
			window.dialogArguments.location.reload();
		<%}%>	
	self.close();
	}else{
	history.go(-2);
}
</script>
<%}%>