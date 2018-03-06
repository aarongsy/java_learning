<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%
String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
String operatemode = request.getParameter("operatemode");
if(operatemode.equals("submit")||operatemode.equals("save")){
		String sql = "update uf_contract set state='2c91a0302ab11213012ab12bf0f00021',finishdate='"+DateHelper.getCurrentDate()+"' where requestid=(select ctrno from uf_ctr_unusual where requestid='"+requestid+"')";
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		baseJdbc.update(sql);
}
else if(operatemode.equals("reject")){

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

