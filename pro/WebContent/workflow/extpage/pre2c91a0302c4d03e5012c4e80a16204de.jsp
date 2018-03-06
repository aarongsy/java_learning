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


String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
String operatemode = request.getParameter("operatemode");
//提交的
if(operatemode.equals("submit")||operatemode.equals("save")){
		String sql = "";
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		//执行更新，主要更改提执行中的sql
		baseJdbc.update("update uf_device_equipment set equipmentstate='2c91a0302c2fe2d1012c349aa31e038f' where requestid in (select deviceno from uf_device_return_sub where requestid='"+requestid+"')");
		List<Map<String,Object>> eqpmts = (List<Map<String,Object>>)baseJdbc.executeSqlForList("select deviceno,useverdict from uf_device_return_sub where requestid='"+requestid+"'");
		if(eqpmts!=null && eqpmts.size()>0){
			for(Map<String,Object> element:eqpmts){
				baseJdbc.update("update uf_device_equipment set useverdict ='"+element.get("useverdict").toString()
						+"' where requestid='"+element.get("deviceno").toString()+"'");
			}
		}
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




