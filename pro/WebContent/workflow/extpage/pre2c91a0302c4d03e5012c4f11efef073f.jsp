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
//表单ID:2c91a0302c2fe2d1012c358dc96306ab	设备调拨单
//	日期:	reqdate
//	设备名称:	devicename
//	资产原值:	originalcost
//	调入部门:	imporg
//	签名1:	sign1
//	签名3:	sign3
//	签名5:	sign5
//	签名日期2:	signdate2
//	签名日期3:	signdate3
//	签名日期5:	signdate5
//	数量:	numbers
//	调出专业室:	extdept
//	调拨原因或依据:	reason
//	签名2:	sign2
//	出厂编号:	deviceNO
//	调入专业室:	impdept
//	签名4:	sign4
//	发起人:	reqman
//	设备编码:	devicecoding
//	签名日期1:	signdate1
//	签名日期4:	signdate4
//	编号:	flowno
//	规格型号:	model
//	调出部门:	exporg
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
		baseJdbc.update("update uf_device_equipment set reqorgunit=(select imporg from uf_device_allot where requestid='"+requestid+"'),specialtys=(select impdept from uf_device_allot where requestid='"+requestid+"') where requestid=(select to_char(devicecoding) from uf_device_allot where requestid = '"+requestid+"')");
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



