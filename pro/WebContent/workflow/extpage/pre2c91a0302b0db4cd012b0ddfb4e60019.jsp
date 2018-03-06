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
	if(checklist.size()>0){
		Map m1 = (Map)checklist.get(0);
		String ftaskid = StringHelper.null2String(m1.get("taskno"));
		String docno = StringHelper.null2String(m1.get("docno"));
		String ifprint = StringHelper.null2String(m1.get("ifprint"));
        String mainbodyattach = StringHelper.null2String(m1.get("mainbodyattach"));
		List node= baseJdbc.executeSqlForList("select requestid,MASTERTYPE,critical from edo_task where taskno='"+docno+"'");
		if(node.size()>0){
			Map m2 = (Map)node.get(0);
			String requestid1 = StringHelper.null2String(m2.get("requestid"));
			String mastertype = StringHelper.null2String(m2.get("MASTERTYPE"));
			String critical = StringHelper.null2String(m2.get("critical"));
			baseJdbc.update("update edo_task set status='"+status+"',indentfinishdate='"+DateHelper.getCurrentDate()+"' where requestid='"+requestid1+"'");
			//if(ifprint.equals("2c91a0302aa21947012aa31fc13e00ab"))status="2c91a0302aa21947012aa232f1860013";
			if(critical.equals("1")){
				baseJdbc.update("update edo_task set status='"+status+"',INDENTFINISHDATE='"+DateHelper.getCurrentDate()+"' where requestid='"+ftaskid+"'");
			}
	baseJdbc.update("update uf_contract_dist t set implementdate='"+DateHelper.getCurrentDate()+"' where  requestid in (select a.projectid from edo_task a,uf_contract b  where b.requestid=a.projectid and b.state='2c91a0302ab11213012ab12bf0f00022' and  a.requestid='"+ftaskid+"' and a.department=t.orgid) and not exists(select id from edo_task where STATUS not in ('2c91a0302aa21947012aa232f1860012','2c91a0302aa21947012aa232f1860011','2c91a0302aa21947012aa232f1860013') and model='2c91a84e2aa7236b012aa737d8930006' and projectid=t.requestid and department=t.orgid)");

	baseJdbc.update("update uf_contract t set state='2c91a0302a8cef72012a8eabe0e803f2',implementdate='"+DateHelper.getCurrentDate()+"' where  requestid in (select projectid from edo_task where requestid='"+ftaskid+"') and not exists(select id from uf_contract_dist where implementdate is null and requestid=t.requestid) and state='2c91a0302ab11213012ab12bf0f00022'");
		}
		//List ctasklist=baseJdbc.executeSqlForList("select requestid,docno from edo_task where  parenttaskuid='"+ftaskid+"' and //model='2c91a84e2aa7236b012aa737d8930007'");
		//List cchecklist= baseJdbc.executeSqlForList("select ifprint,nodeid from uf_doc_ratifymain where requstid='"+requestid+"'");

		//baseJdbc.update("update edo_task set status='"+status+"',INDENTFINISHDATE='"+DateHelper.getCurrentDate()+"' where requestid='"+ftaskid+"'");

		//在线签批
		String userId = BaseContext.getRemoteUser().getId();
		EweaverMessageProducer producer = (EweaverMessageProducer) BaseContext.getBean("eweaverMessageProducer");
		EweaverMessage msg = new EweaverMessage();
		Map map = new HashMap();
		map.put("docId",mainbodyattach);//文档ID
		map.put("nodeNO",5);//节点编号(对应审批中的5个节点，1为创建节点，5未打印节点，2，3，4为审批节点)
		map.put("userId",userId);//当前节点操作者ID
		msg.setParaMap(map);
		msg.setMsgtype(EweaverMessage.MESSAGE_TYPE_USER);
		msg.setUserKey("signatureMessage");
		producer.send(msg);
		
		//生成pdf
		System.out.println("生成pdf:"+mainbodyattach);
		if(mainbodyattach.length()>0){
			EweaverMessage pdfmsg = new EweaverMessage();
			Map pdfmap = new HashMap();
			pdfmap.put("docId",mainbodyattach);
			pdfmsg.setParaMap(map);
			pdfmsg.setMsgtype(EweaverMessage.MESSAGE_TYPE_USER);
			pdfmsg.setUserKey("convertMessage");
			producer.send(pdfmsg);
		}
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

