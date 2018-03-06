<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
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
String deptcnd=request.getParameter("orgidcnd");
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
if(deptcnd==null||deptcnd.length()<1)
{
	deptcnd="";
	deptcnd=eweaveruser1.getOrgid();
}
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
<%
String sql = "";
//or orgids like '%"+deptcnd+"%'
if(SQLMap.getDbtype().equals(SQLMap.DBTYPE_ORACLE))
	sql = "select id requestid,objname,moduleid,nvl((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=0 and creater in (select id from humres where orgid='"+deptcnd+"' )),0) nums,nvl((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=1 and creater in (select id from humres where orgid='"+deptcnd+"')),0) finishnums from workflowinfo t where isactive=1 and isdelete=0 order by moduleid,dsporder";
else
	sql = "select id requestid,objname,moduleid,isnull((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=0 and creater in (select id from humres where orgid='"+deptcnd+"' )),0) nums,isnull((select count(*) from requestbase where workflowid=t.id and isdelete=0 and isfinished=1 and creater in (select id from humres where orgid='"+deptcnd+"')),0) finishnums from workflowinfo t where isactive=1 and isdelete=0 order by moduleid,dsporder";
	List dList = ds.getValues(sql);
	int size2 = dList.size();
	String ids1="'0'";
	String ids2="'0'";
	for(int j=0;j<size2;j++){
		Map m1 = (Map)dList.get(j);
		String typeid=m1.get("moduleid").toString();
		int  nums=Integer.parseInt(m1.get("nums").toString());
		int finishnums=Integer.parseInt(m1.get("finishnums").toString());
		if(nums>0)
		{
			ids1=ids1+",'"+typeid+"'";
		}
		if(finishnums>0)
		{
			ids2=ids2+",'"+typeid+"'";
		}
	}
	sql = "select id requestid,objname typename,dsporder from module where pid is null and isdelete=0 and id in ("+ids1+") order by dsporder";
	List tList = ds.getValues(sql);
	sql = "select id requestid,objname typename,dsporder from module where pid is null and isdelete=0 and id in ("+ids2+")order by dsporder";
	List tList2 = ds.getValues(sql);
	int size = tList.size();
	int size3 = tList2.size();
%>
<table width="98%">
<tr><td width="50%" valign=top>
<table width="100%">
<tr bgcolor="#D9DFEE">
<td colspan=2><b>请求未完成：</b></td>
</tr>
<tr>
	<%
	StringBuffer buf = new StringBuffer();
	buf.append("<td width=\"50%\"><div id=\"div0\" style=\"width:200px\">");
	if(size>0){
		for(int i=0;i<size;i++){
			Map m = (Map)tList.get(i);
			String requestid=m.get("requestid").toString();
			buf.append("<ul><li id=\""+requestid+"\" level=\"1\" >");
			buf.append("<b>"+m.get("typename").toString()+"</b></li>");
			for(int j=0;j<size2;j++){
				Map m1 = (Map)dList.get(j);
				String typeid=m1.get("moduleid").toString();
				String nums=m1.get("nums").toString();
				if(Integer.parseInt(nums)<1)continue;
				String finishnums=m1.get("finishnums").toString();
				String requestidsub=m1.get("requestid").toString();
				if(typeid.indexOf(requestid)>-1)
				{
					buf.append("<ul><li id=\""+requestidsub+"\" level=\"2\" >");
					buf.append("<a href=\"javascript:onUrl('"+url+requestidsub+"&isfinished=0','"+m1.get("objname").toString()+ "')\">"+m1.get("objname").toString()+"</a>( "+nums+" / "+(Integer.parseInt(nums)+Integer.parseInt(finishnums))+")</li></ul>");
				}
			}
			buf.append("</ul>");
			if(i==5)
			{
			
				buf.append("</div></td><td width=\"50%\"><div id=\"div1\"  style=\"width:200px\">");
			}
		}
	}
	buf.append("</div></td>");
	out.println(buf.toString());
	%>
</tr>
</table>
</td>
<td width="50%" valign=top>
<table width="100%">
<tr bgcolor="#D9DFEE">
<td colspan=2><b>请求已完成：</b></td>
</tr>
<tr>
	<%
	StringBuffer buf1 = new StringBuffer();
	buf1.append("<td width=\"50%\"><div id=\"div01\" style=\"width:200px\">");
	if(size3>0){
		for(int i=0;i<size3;i++){
			Map m = (Map)tList2.get(i);
			String requestid=m.get("requestid").toString();
			buf1.append("<ul><li id=\""+requestid+"\" level=\"1\" >");
			buf1.append("<b>"+m.get("typename").toString()+"</b></li>");
			for(int j=0;j<size2;j++){
				Map m1 = (Map)dList.get(j);
				String typeid=m1.get("moduleid").toString();
				String nums=m1.get("nums").toString();
				String finishnums=m1.get("finishnums").toString();
				if(Integer.parseInt(finishnums)<1)continue;
				String requestidsub=m1.get("requestid").toString();
				if(typeid.indexOf(requestid)>-1)
				{
					buf1.append("<ul><li id=\""+requestidsub+"\" level=\"2\" >");
					buf1.append("<a href=\"javascript:onUrl('"+url+requestidsub+"&isfinished=1','"+m1.get("objname").toString()+ "')\">"+m1.get("objname").toString()+" </a>( "+finishnums+" / "+(Integer.parseInt(nums)+Integer.parseInt(finishnums))+")</li></ul>");
				}
			}
			buf1.append("</ul>");
			if(i==5)
			{
			
				buf1.append("</div></td><td width=\"50%\"><div id=\"div11\"  style=\"width:200px\">");
			}
		}
	}
	buf1.append("</div></td>");
	out.println(buf1.toString());
	%>
</tr>
</table>
</td></tr></table>
</body>
</html>