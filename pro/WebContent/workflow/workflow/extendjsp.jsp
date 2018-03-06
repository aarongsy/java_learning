<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.io.*" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.FileHelper" %>
<%@ page import="com.eweaver.base.IDGernerator" %>
<%@ page import="com.eweaver.workflow.workflow.service.ExtendJspService" %>
<%
String fileid = IDGernerator.getUnquieID();
ExtendJspService extendJspService=(ExtendJspService)BaseContext.getBean("extendJspService");
String filetype = StringHelper.null2String(request.getParameter("filetype"));
String type = StringHelper.null2String(request.getParameter("type"));
String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
String jsppageName = StringHelper.null2String(request.getParameter("filename"));//文件名

//String sysPath=getServletContext().getRealPath("/");
String sysPath=BaseContext.getRootPath();
String filepath =sysPath+ "workflow" + File.separatorChar +"extpage"+ File.separatorChar;//文件目录
String fromfile = jsppageName;//要读取的文件
String preinfo="";//帮助信息

String defaultfilename = "default";
String fileext = ".jsp";
if(filetype.equals("1"))
	fileext = ".java";


if(jsppageName.equals("")){
	jsppageName = type+fileid+ fileext;
	
	fromfile = defaultfilename + fileext;
	preinfo=extendJspService.getPreinfo(workflowid,filetype.equals("1"));
}else{
	if(jsppageName.endsWith(".java"))
		filetype = "1";
}


String content = FileHelper.loadFile(filepath+fromfile);
 if(content.startsWith("?"))
	    	content = content.substring(1);
if(filetype.equals("1")){
		String classname = jsppageName.substring(0,jsppageName.length()-5);
	    content = StringHelper.replaceString(content,"{defaultclassname}",classname);	    
}
content = preinfo + content;
%>
<html>
<head>  
</head>
  
<body>
<input type="radio" name="filetype" value="0" <%if(!filetype.equals("1")){%> checked <%}%> onclick="selectfiletype(this,0);"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0058") %><!-- JSP文件 -->
<input type="radio" name="filetype" value="1" <%if(filetype.equals("1")){%> checked <%}%>  onclick="selectfiletype(this,1);"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0059") %><!-- JAVA文件 -->	 
<script language = "javascript">
function selectfiletype(obj,type){
	if(type == 0 && obj.checked )
		location.href = "<%=request.getContextPath()%>/workflow/workflow/extendjsp.jsp?type=<%=type%>&workflowid=<%=workflowid%>&filetype=0";
	if(type == 1 && obj.checked )
		location.href = "<%=request.getContextPath()%>/workflow/workflow/extendjsp.jsp?type=<%=type%>&workflowid=<%=workflowid%>&filetype=1";
		
}
</script>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSave()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:onDelete()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:onBack()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=extpage" name="EweaverForm"  method="post">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=type%>" name="type">
<input type="hidden" value="<%=jsppageName%>" name="jsppageName">
<input type="hidden" value="<%=filepath%>" name="filepath">
<table width=100%  height=500>
<COLGROUP>
   <COL width="100%">
<tr>
	<td width=100% height=100%>
		<textarea name="content" style="width:100%;height:100%"><%=content%></textarea>
	</td>
</tr>
</table>
</form>

<script language="javascript">
function onSave()
{
	EweaverForm.src.value = "save";
	EweaverForm.submit();
}

function onDelete()
{
	EweaverForm.src.value = "delete";
	EweaverForm.submit();

}
function onBack(){
window.close();
}
</script>
</body>
</html>
