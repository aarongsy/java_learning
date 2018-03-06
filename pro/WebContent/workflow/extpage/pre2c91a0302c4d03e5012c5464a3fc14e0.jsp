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
//当前工作流包含表单是实际表单
//表单ID:402881172c4885c0012c4936855002bf	非固定资产类生产设备报废鉴定表
//	编号:	flowno
//	部门:	reqorgid
//	申请人:	reqman
//	名称:	devicename
//	制造厂:	manufactory
//	设备编号:	deviceNO
//	原值:	originalcost
//	申请报废理由:	reason
//	部门鉴定意见:	advise1
//	经营策划部审核意见:	advise2
//	经营策划部审核签名:	sign2
//	财务部签名:	sign3
//	申请部门:	reqdept
//	负责部门:	FZdept
//	日期:	reqdate
//	规格型号:	model
//	购置日期:	purchasedate
//	财务部意见:	advise3
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
		baseJdbc.update("update uf_device_equipment set equipmentstate='2c91a0302c2fe2d1012c349aa31e0391',dumpingdate='"+DateHelper.getCurrentDate()+"' where requestid in (select devicename from uf_device_scrapfgd where requestid='"+requestid+"')");
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


