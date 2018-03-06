<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.eweaver.base.msg.*"%>
<%
//---------------------------------------
String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
String operatemode = request.getParameter("operatemode");
String otherextpages = StringHelper.null2String(request.getParameter("otherextpages"));
String directnodeid = StringHelper.null2String(request.getParameter("directnodeid"));
String userId = BaseContext.getRemoteUser().getId();
DataService dataService = new DataService();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
//提交的
if(operatemode.equals("submit")||operatemode.equals("save")){
	String sql = "select mainbodyattach from uf_doc_ratifymain where requestid='"+requestid+"'";
	List checklist= baseJdbc.executeSqlForList(sql);
	if(checklist.size()>0){
		Map m1 = (Map)checklist.get(0);
        String docId = StringHelper.null2String(m1.get("mainbodyattach"));
      	//删除编辑权限
        String permissionSQL = "update permissiondetail set opttype=3 where objid='"+docId+"' and userid='"+userId+"' and opttype>14";
        dataService.executeSql(permissionSQL);
        //在线签批
		EweaverMessageProducer producer = (EweaverMessageProducer) BaseContext.getBean("eweaverMessageProducer");
		EweaverMessage msg = new EweaverMessage();
		Map map = new HashMap();
		map.put("docId",docId);//文档ID
		map.put("nodeNO",3);//节点编号(对应审批中的5个节点，1为创建节点，5未打印节点，2，3，4为审批节点)
		map.put("userId",userId);//当前节点操作者ID
		msg.setParaMap(map);
		msg.setMsgtype(EweaverMessage.MESSAGE_TYPE_USER);
		msg.setUserKey("signatureMessage");
		producer.send(msg);
	}
	
	if(!StringHelper.isEmpty(otherextpages)){
		otherextpages = "/workflow/extpage/"+otherextpages;
		otherextpages += "?requestid="+StringHelper.null2String(requestid)+"&operatemode="+operatemode+"&directnodeid="+directnodeid+"&targeturl="+URLEncoder.encode(targeturl);
		response.sendRedirect(otherextpages);
		return;
	}
}

targeturl="/workflow/request/close.jsp?mode=submit";
%>
<script>
var commonDialog=top.leftFrame.commonDialog;
if(commonDialog){
	var frameid=parent.contentPanel.getActiveTab().id+'frame';
	var tabWin=parent.Ext.getDom(frameid).contentWindow;
	if(!commonDialog.hidden){
		commonDialog.hide();
		tabWin.location.reload();
	}else{
		tabWin.location.href="<%=targeturl%>";
	}
}
</script>

