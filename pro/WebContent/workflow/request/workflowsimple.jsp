<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.WorkflowService"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>

<%

	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
%>
<script language="javascript">
//alert(window.parent.document.all("workflowtable"));
var rowindex = window.parent.document.all("tr_<%=requestid%>").rowIndex;
window.parent.document.all("workflowtable").deleteRow(rowindex);
//window.parent.document.all("workflowtable").fireEvent("deleteRow",rowindex);
window.parent.document.all("hiderdialog").fireEvent("onclick");
</script>
