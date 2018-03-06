<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPage"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%
response.setHeader("cache-control", "no-cache"); 
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String workflowids=StringHelper.null2String(request.getParameter("workflowids"));
SetitemService setitemService0=(SetitemService) BaseContext.getBean("setitemService");
WorkflowVersionService workflowVersionService=(WorkflowVersionService)BaseContext.getBean("workflowVersionService");

EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
if(StringHelper.isEmpty(style)){
	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
        style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
}
/*首页类型*/
MainPageDefined mainPageDefined = (MainPageDefined)BaseContext.getBean("mainPageDefined");
MainPage userMainPage = mainPageDefined.getMainPageByType(eweaveruser.getSysuser().getMainPageType());
if(!userMainPage.getIsClassic()){//非传统的首页
	style = "gray";	//新首页使用Ext样式灰色作为默认的样式(无论之前用户选择的传统模式皮肤是什么颜色)
}
List list=new ArrayList();
workflowids=StringHelper.formatMutiIDs(workflowids);
String hql="from WorkflowVersion where workflowid in("+workflowids+") order by version asc";
list=workflowVersionService.getWorkflowVersions(hql);

String width=StringHelper.null2String(request.getParameter("width"),"0");
String height=StringHelper.null2String(request.getParameter("height"),"0");
int divwidth=NumberHelper.float2int(Float.valueOf(width));
int divheight=NumberHelper.float2int(Float.valueOf(height));

if(list!=null&&list.size()>0){
	divwidth=divwidth/(list.size());
	divheight=divheight-25;
}
%>
<html>
<head>
<%if(!userMainPage.getIsClassic()){//非传统的首页,去掉流程图的边框%>
	<style type="text/css">
		.x-panel-body{
			border: none !important;
		}
	</style>
<%} %>

<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script>
</script>
</head>
<body style="overflow:hidden;">
<table>
	<tr>
	<%
		if(list!=null&&list.size()>0){
			for(int i=0;i<list.size();i++){
				WorkflowVersion workflowVersion2=(WorkflowVersion)list.get(i);
				%>
				<td>
					<iframe scrolling="auto" width="<%=divwidth%>" height="<%=divheight%>" style="border-style:inset;" src="showworkflowinfo.jsp?workflowid=<%=workflowVersion2.getWorkflowid()%>"></iframe>
				</td>
				<%
			}
		}
	%>
	</tr>
</table>
</body>
</html>
