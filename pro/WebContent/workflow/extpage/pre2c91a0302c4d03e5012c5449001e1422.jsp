<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.eweaver.base.msg.EweaverMessage" %>
<%@ page import="com.eweaver.base.msg.EweaverMessageProducer" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.remind.base.AbstractNodeRemind" %>
<%@ page import="com.eweaver.workflow.request.model.Messageurl" %>
<%@ page import="com.eweaver.workflow.request.model.Requestbase" %>
<%@ page import="com.eweaver.workflow.request.service.RequestOperatorService" %>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService" %>
<%@ page import="com.eweaver.workflow.request.service.WorkflowService" %>
<%
//当前工作流包含表单是抽象表单
//固定资产类生产设备报废鉴定表_子表	ID:402881162c451102012c451ad68a0003
//	规格型号:	model
//	制造厂家:	manufactory
//	购置日期:	purchasedate
//	利用年限:	useyears
//	已使用年限:	usedyears
//	已提折旧:	depreciation
//	净值:	networth
//	关联用:	pid
//	出厂编号:	leavefactoryno
//	固定资产编号:	deviceNO
//	固定资产名称:	devicename
//	数量:	amount
//	原值:	originalcost
//固定资产类生产设备报废鉴定表_主表	ID:402881162c451102012c4518fb130002
//	使用部门:	userdept
//	经办部门:	agentdept
//	编制单位:	formationunit
//	项目负责人:	prjprincipal
//	公司负责人:	companyman
//	编号:	flowno
//	编制日期:	formationdate
//	单位:	unit
//	技术状况及损坏程度:	condition
//	经办人:	reqman
//	鉴定意见:	advise
//	鉴定人:	identifier
//	鉴定部门负责人:	identifierman
//	财务会计部:	financeman
//---------------------------------------
%>

<%
String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
String operatemode = request.getParameter("operatemode");
//提交的
if(operatemode.equals("submit")||operatemode.equals("save")){
		String sql = "";
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		//执行更新，主要更改提执行中的sql
		baseJdbc.update("update uf_device_equipment set equipmentstate='2c91a0302c2fe2d1012c349aa31e0391',dumpingdate='"+DateHelper.getCurrentDate()+"' where requestid in (select deviceno from uf_device_scrapgd_sub where requestid='"+requestid+"')");
}
//退回
else if(operatemode.equals("reject"))
{
   

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


