<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/init.jsp"%>
<%
String requestid = request.getParameter("requestid");
DataService dataService = new DataService();
String sql = "update uf_contract_billout set status='402880302ca4a416012ca581e55d013f' where requestid='"+requestid+"' ";
dataService.executeSql(sql);
%>
<SCRIPT language=javascript>
alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0047") %>');//发票已作废！
parent.doRefresh();
parent.commonDialog.hide();
</SCRIPT>
<body>
