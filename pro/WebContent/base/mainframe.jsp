<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>

<%
String modelname = StringHelper.trimToNull(request.getParameter("modelname"));
String tagetUrl = StringHelper.trimToNull(request.getParameter("tagetUrl"));
String myworkflow = StringHelper.trimToNull(request.getParameter("myworkflow"));
int isfinished = NumberHelper.string2Int(request.getParameter("isfinished"));
String reftype = StringHelper.null2String(request.getParameter("reftype"));
String src="";
if(modelname.equals("customer")){//客户
	src=request.getContextPath()+"/customer/customertype/customertypeview.jsp";
}else if(modelname.equals("product")){//产品
	src=request.getContextPath()+"/product/producttype/producttypeview.jsp";
}else if(modelname.equals("project")){//项目
	src=request.getContextPath()+"/project/projecttype/projecttypeview.jsp";
}else if(modelname.equals("workflow")&& StringHelper.isEmpty(myworkflow)){//流程
	src=request.getContextPath()+"/workflow/request/workflowtypeview.jsp?isfinished="+isfinished;
}else if(modelname.equals("workflow")&& myworkflow.equals("myworkflow")){//流程
	src=request.getContextPath()+"/workflow/request/myworkflowtype.jsp?isfinished="+isfinished;
}else if(modelname.equals("assets")){//资源
	src=request.getContextPath()+"/assets/assetstype/assetstypeview.jsp";
}else if(modelname.equals("document")){//文档
	src=request.getContextPath()+"/document/doctype/doctypeview.jsp";
}else if(modelname.equals("reprot")){//报表
	src=request.getContextPath()+"/workflow/report/reporttype.jsp";
}else if(modelname.equals("orgsubject")){//组织科目
	src=request.getContextPath()+"/base/subject/orgsubject.jsp?opttype=1";//设置要预算的科目
}else if(modelname.equals("setorgsubject")){
	src=request.getContextPath()+"/base/subject/orgsubject.jsp?opttype=2&reftype="+reftype;//设置一个组织预算的科目的费用

}else if(modelname.equals("mycolleague")){
	src=request.getContextPath()+"/humres/base/mycolleague.jsp";//通讯录

}else if(modelname.equals("provider")){
	src=request.getContextPath()+"/provider/providertype/providertypeview.jsp";
}else if(modelname.equals("contract")){
	src=request.getContextPath()+"/contract/contracttype/contracttypeview.jsp";
}
%>
<html>
<head>
<style>
.resizeDivClass
{
position:relative;
background-color:#cccccc;
width:6px;
z-index:1;

cursor:e-resize;

}
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td  height=100% id=oTd1 name=oTd1 width=14% style="display:''">
	<IFRAME name=HomePageIframe id=HomePageIframe src="<%=src%>" width="100%" height="100%" frameborder=no scrolling=auto>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>

<td height=100% id=oTd0 name=oTd0 width=1%>
	<IFRAME name=mainmiddleFrame id=mainmiddleFrame   src="middletoleft.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=60% style="display:''">
	<IFRAME name=HomePageIframe2 id=HomePageIframe2 src="#" width="100%" height="100%" frameborder=no scrolling=yes>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
</table>
</body>
</html>