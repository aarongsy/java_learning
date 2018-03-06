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
	baseJdbc.update("update  uf_customer set suppstatus=decode((select totaladvise from uf_ser_facility where requestid='"+requestid+"'),'2c91a0302bbcd476012be61178770a3c','2c91a0302bbcd476012be214af8b06a2','2c91a0302bbcd476012be61178770a3d','2c91a0302bbcd476012be214af8b06a3','2c91a0302bbcd476012be214af8b06a2'),firstevadate='"+DateHelper.getCurrentDate()+"',evatimes=1,files=(select files from uf_ser_facility  where requestid='"+requestid+"') where requestid=(select rmdsname from  uf_ser_facility where requestid='"+requestid+"')");
baseJdbc.update("update uf_ser_article  set flowstate='2c91a0302bbcd476012be610f27e0a39' where requestid='"+requestid+"'");
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

