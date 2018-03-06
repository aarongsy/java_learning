<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
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
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List checklist= baseJdbc.executeSqlForList("select reqtype from uf_device_seal where requestid='"+requestid+"'"); 
	if(checklist.size()>0)
	{
		Map m1 = (Map)checklist.get(0);
		String reqtype = StringHelper.null2String(m1.get("reqtype"));
		if(reqtype.equals("2c91a0302c3d90d7012c3efee29007ad"))
		{
			baseJdbc.update("update uf_device_equipment set equipmentstate='2c91a0302c2fe2d1012c349aa31e0393' where requestid in (select name from uf_device_seal_sub where requestid='"+requestid+"')");
		}
		else if(reqtype.equals("2c91a0302c3d90d7012c3efee29007ae"))
		{
			baseJdbc.update("update uf_device_equipment set equipmentstate='2c91a0302c2fe2d1012c349aa31e038f' where requestid in (select name from uf_device_seal_sub where requestid='"+requestid+"')");
		}
		else if(reqtype.equals("2c91a0302c3d90d7012c3efee29007af"))
		{
			//2c91a0302c2fe2d1012c349759490389,2c91a0302c2fe2d1012c349759490388,2c91a0302c2fe2d1012c349759490387
			
			baseJdbc.update("update uf_device_equipment t set rank=nvl((select id from selectitem where typeid='2c91a0302c2fe2d1012c3496fb1d0386' and dsporder=(select dsporder from selectitem where id=t.rank)+1),rank)  where requestid in (select name from uf_device_seal_sub where requestid='"+requestid+"')");
		}
		
	}

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

