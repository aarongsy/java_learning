<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%
String docid = StringHelper.null2String(request.getParameter("docid"));
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
String docname=docbaseService.getSubjectByDoc(docid);
%>
<form name=abc method=post>
<input type="hidden"  name="docid" value="<%=docid%>"/>
<input type="hidden"  name="docname" value="<%=docname%>"/>
</form>
<script language='javascript'>
	if(window.opener!=null){//关闭window.open窗口
		window.opener.EweaverForm.backdoc.value=self.abc.docid.value;
		window.opener.EweaverForm.docname.value=self.abc.docname.value;
		self.close();
	}
</script>