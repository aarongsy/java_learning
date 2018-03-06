<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.msg.*"%>
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
	List checklist= baseJdbc.executeSqlForList("select taskno,docno,ifprint,mainbodyattach from uf_doc_ratifymain where requestid='"+requestid+"'");
	if(checklist.size()>0)
	{
		Map m1 = (Map)checklist.get(0);
        String mainbodyattach = StringHelper.null2String(m1.get("mainbodyattach "));
		//生成pdf
		if(mainbodyattach.length()>0)
		{
			String docId=mainbodyattach;
			EweaverMessageProducer producer = (EweaverMessageProducer) BaseContext.getBean("eweaverMessageProducer");
			EweaverMessage msg = new EweaverMessage();
			Map map = new HashMap();
			map.put("docId",docId);
			msg.setParaMap(map);
			msg.setMsgtype(EweaverMessage.MESSAGE_TYPE_USER);
			producer.send(msg);
		}
	}
	//ifprint
	//执行更新，主要更改提执行中的sql
}
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

