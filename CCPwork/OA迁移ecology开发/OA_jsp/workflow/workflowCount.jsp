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
String url="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=search&workflowid=";
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
<tr bgcolor="#D9DFEE">
<td colspan=2><b>未完成工作：</b></td>
<td colspan=2><b>已完成工作：</b></td>
</tr>
<tr>
	<%
		StringBuffer buf = new StringBuffer();
	StringBuffer buf1 = new StringBuffer();
	buf.append("<td width=\"25%\"><div id=\"div0\" style=\"width:200px\">");
	buf1.append("<td width=\"25%\"><div id=\"div0\" style=\"width:200px\">");

	String sql = "";
	if(SQLMap.getDbtype().equals(SQLMap.DBTYPE_ORACLE))
		sql = "select id requestid,objname,moduleid,nvl((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=0),0) nums,nvl((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=1),0) finishnums from workflowinfo t where isactive=1 and isdelete=0 order by moduleid,dsporder";
	else
		sql = "select id requestid,objname,moduleid,isnull((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=0),0) nums,isnull((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=1),0) finishnums from workflowinfo t where isactive=1 and isdelete=0 order by moduleid,dsporder";
	List dList = ds.getValues(sql);
	sql = "select id requestid,objname typename,dsporder from module where pid is null and isdelete=0 and id in (select distinct moduleid from workflowinfo where isactive=1 and isdelete=0) order by dsporder";
	List tList = ds.getValues(sql);
	int size = tList.size();
	int size2 = dList.size();
	if(size>0){
		for(int i=0;i<size;i++){
			Map m = (Map)tList.get(i);
			String requestid=m.get("requestid").toString();
			buf.append("<ul><li id=\""+requestid+"\" level=\"1\" >");
			buf.append("<b>"+m.get("typename").toString()+"</b></li>");
			buf1.append("<ul><li id=\""+requestid+"\" level=\"1\" >");
			buf1.append("<b>"+m.get("typename").toString()+"</b></li>");
			for(int j=0;j<size2;j++){
				Map m1 = (Map)dList.get(j);
				String typeid=m1.get("moduleid").toString();
				String nums=m1.get("nums").toString();
				String finishnums=m1.get("finishnums").toString();
				String requestidsub=m1.get("requestid").toString();
				if(typeid.indexOf(requestid)>-1)
				{
					buf.append("<ul><li id=\""+requestidsub+"\" level=\"2\" >");
					buf.append("<a href=\"javascript:onUrl('"+url+requestidsub+"&isfinished=0','"+m1.get("objname").toString()+ "')\">"+m1.get("objname").toString()+"</a>( "+nums+" / "+(Integer.parseInt(nums)+Integer.parseInt(finishnums))+")</li></ul>");
					buf1.append("<ul><li id=\""+requestidsub+"\" level=\"2\" >");
					buf1.append("<a href=\"javascript:onUrl('"+url+requestidsub+"&isfinished=1','"+m1.get("objname").toString()+ "')\">"+m1.get("objname").toString()+" </a>( "+finishnums+" / "+(Integer.parseInt(nums)+Integer.parseInt(finishnums))+")</li></ul>");
				}
			}
			buf.append("</ul>");
			buf1.append("</ul>");
			if(i==5)
			{
			
				buf.append("</div></td><td width=\"25%\"><div id=\"div1\"  style=\"width:200px\">");
				buf1.append("</div></td><td width=\"25%\"><div id=\"div1\"  style=\"width:200px\">");
			}
		}
	}
	buf.append("</div></td>");
	buf.append("</div></td>");
	out.println(buf.toString());
	out.println(buf1.toString());
	%>
</tr>
</table>
</body>
</html>