<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%
//---------------------------------------
String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
String operatemode = request.getParameter("operatemode");
String status="2c91a0302aa21947012aa232f1860011";
//提交的
if(operatemode.equals("submit")||operatemode.equals("save")){
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List checklist= baseJdbc.executeSqlForList("select taskno,docno,ifprint from uf_doc_ratifymain where requestid='"+requestid+"'");
	if(checklist.size()>0)
	{
		Map m1 = (Map)checklist.get(0);
		String ftaskid = StringHelper.null2String(m1.get("taskno"));
		String docno = StringHelper.null2String(m1.get("docno"));
		String ifprint = StringHelper.null2String(m1.get("ifprint"));
		List node= baseJdbc.executeSqlForList("select requestid,MASTERTYPE,critical from edo_task where taskno='"+docno+"'");
		if(node.size()>0)
		{
			Map m2 = (Map)node.get(0);
			String requestid1 = StringHelper.null2String(m2.get("requestid"));
			String mastertype = StringHelper.null2String(m2.get("MASTERTYPE"));
			String critical = StringHelper.null2String(m2.get("critical"));
			baseJdbc.update("update edo_task set status='"+status+"',indentfinishdate='"+DateHelper.getCurrentDate()+"' where requestid='"+requestid1+"'");
			
			if(critical.equals("1"))
			{
				baseJdbc.update("update edo_task set status='"+status+"',indentfinishdate='"+DateHelper.getCurrentDate()+"' where requestid='"+ftaskid+"'");
			}
		}
		//List ctasklist=baseJdbc.executeSqlForList("select requestid,docno from edo_task where  parenttaskuid='"+ftaskid+"' and //model='2c91a84e2aa7236b012aa737d8930007'");
		//List cchecklist= baseJdbc.executeSqlForList("select ifprint,nodeid from uf_doc_ratifymain where requstid='"+requestid+"'");

		//baseJdbc.update("update edo_task set status='"+status+"',finish1='"+DateHelper.getCurrentDate()+"' where requestid='"+ftaskid+"'");
	}
	//ifprint
	//执行更新，主要更改提执行中的sql
}

//2c91a0302aa21947012aa232f1860011
//2c91a0302aa21947012aa232f1860013
//2c91a0302acbe28f012acbf9b9c700d5 过程任务
//2c91a0302acabc4e012acac9706b000b 主报告
%>
<%
	targeturl="/workflow/request/close.jsp?mode=submit";
%>
<script>
var commonDialog=top.leftFrame.commonDialog;
if(commonDialog){
	var frameid=parent.contentPanel.getActiveTab().id+'frame';
	var tabWin=parent.Ext.getDom(frameid).contentWindow;
	if(!commonDialog.hidden)
	{
		commonDialog.hide();
		tabWin.location.reload();
	}
	else
	{
		tabWin.location.href="<%=targeturl%>";
	}
}
</script>

