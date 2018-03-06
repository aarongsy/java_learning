<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<@ page contentType="text/html; charset=UTF-8"%>
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
if(operatemode.equals("submit")||operatemode.equals("save")){
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	baseJdbc.update("update  uf_customer set suppstatus=decode((select YN from uf_supplier_fp  where requestid='"+requestid+"'),'2c91a0302bbcd476012be8789ebc2155','2c91a0302bbcd476012be214af8b06a2','2c91a0302bbcd476012be8789ebc2156','2c91a0302bbcd476012be214af8b06a3','2c91a0302bbcd476012be214af8b06a2'),evadate='"+DateHelper.getCurrentDate()+"',evatimes=nvl(evatimes,1)+1 where requestid=(select suppname from  uf_supplier_fp  where requestid='"+requestid+"')");
baseJdbc.update("update uf_supplier_fp  set flowstate='2c91a0302bbcd476012be610f27e0a39' where requestid='"+requestid+"'");
}
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

