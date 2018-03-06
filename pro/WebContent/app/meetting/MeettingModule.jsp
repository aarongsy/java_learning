<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
DataService ds = new DataService();
String url="/workflow/request/workflow.jsp?workflowid=2828a86427ace2b50127ad65e2940193&moduleid=";
%>
<html>
	<head>
	<style>
	#div0,#div1,#div2,#div3{width:25%;height:100%;float:left;}
	ul{margin-left:25px;font-size:11}
	/*ul{  list-style-type:CIRCLE;}*/
	.CIRCLE {list-style-type:CIRCLE;}
	a:link, a:visited {text-decoration: underline; color: blue}
	a:hover {text-decoration: underline; color: red; }
	</style>
	<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="/js/ext/ext-all.js"></script>
	<script  type='text/javascript' src='/js/main.js'></script>
	<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
	<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
	<script type="text/javascript" language="javascript" src="/js/weaverUtil.js"></script>
	<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
	<script src='<%=request.getContextPath()%>/dwr/interface/ModuleService.js'></script>
	<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
	<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajaxqueue.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
	</head>
<body>
<center>
<table width="90%">
<td width="50%"><div id="div0" style="width:280px">
<%
StringBuffer buf = new StringBuffer();
String sql = "select requestid,objname,host,handler,style,place,place2,Mannumber from uf_meeting  x where ismodule=1 and isvalid='40288098276fc2120127704884290210' ";
List dList = ds.getValues(sql);
int size2 = dList.size();
buf.append("<ul><li  level=\"1\" >");
buf.append("<b>自定义会议</b></li>");
buf.append("<ul><li id=\"0\" level=\"2\" >");
buf.append("<a href=\""+url+"\">新会议申请</a></li></ul>");
buf.append("</ul>");
buf.append("<ul><li  level=\"1\" >");
buf.append("<b>会议模板</b></li>");
for(int j=0;j<size2;j++){
	Map m1 = (Map)dList.get(j);
	String objname=m1.get("objname").toString();
	String requestid=m1.get("requestid").toString();
	buf.append("<ul><li id=\""+requestid+"\" level=\"2\" >");
	buf.append("<a href=\""+url+requestid+"\">"+objname+"</a></li></ul>");
}
buf.append("</ul>");
out.println(buf.toString());
%>
</div></td></tr>
</table>
</body>
</html>