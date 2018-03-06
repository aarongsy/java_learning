<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="java.util.*"%>
<%@ include file="/base/init.jsp"%>
<%
DataService ds = new DataService();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
String userid = BaseContext.getRemoteUser().getId();
String categoryid = "";
int nCount = 5;
int titleLength = 0;
String tabParams = StringHelper.null2String(request.getParameter("tabParams"));
if(!"".equals(tabParams)){
	JSONObject json = (JSONObject)JSONValue.parse(tabParams);
	categoryid = StringHelper.null2String(json.get("categoryid"));
	nCount = NumberHelper.string2Int(json.get("nCount"), 5);
	titleLength = NumberHelper.string2Int(json.get("titleLength"), 0);
}
String sql = "";
List list = null;
Map map = null;
int listSize = 0;

String requestid="", theme="", modifier="";
sql = "select a.requestid, a.theme, a.modifier from uf_collaboration a where a.partprsn like '%"+userid+"%' ";
sql+= "and not exists (select 1 from log where objid=a.requestid and submitor='"+userid+"' and logtype='402881e40b6093bf010b60a5849c0007' and isdelete=0)";
if(StringHelper.isID(categoryid)){
	sql += " and a.assittype='"+categoryid+"'";
}//System.out.println(sql);
list = ds.getValues(sql);
listSize = list.size();
%>
<table class='requestTabTable'>
<%
for(int i=0;i<listSize&&i<nCount;i++){
	map = (Map)list.get(i);
	requestid = StringHelper.null2String(map.get("requestid"));
	theme = StringHelper.null2String(map.get("theme"));
	if(titleLength>0 && theme.length()>titleLength){
		theme = theme.substring(0, titleLength) + "...";
	}
	modifier = StringHelper.null2String(map.get("modifier"));
%>
<tr>
	<td class='itemIcon'>
	<td width="*"><a href="javascript:onUrl('/app/cowork/formbase.jsp?requestid=<%=requestid %>','<%=theme %>','tab<%=requestid %>>')"><%=theme %></a></td>
	<td style="width:18%;text-align:right;word-wrap:nowrap;padding-right:5px;"><%=humresService.getHrmresNameById(modifier) %></td>
</tr>
<tr height='1'><td class='line' colspan='10'></td></tr>
<%
}
%>
</table>
<%//if(!StringHelper.isID(categoryid) && listSize>0){
if(listSize>0){
%>
<div style="text-align:right;">&nbsp;
<a href="javascript:onUrl('<%=request.getContextPath()%>/app/cowork/coworkview.jsp?categoryid=2c91a0302ab11213012ac0f5daac03ac&isall=1','<%=labelService.getLabelNameByKeyId("402883d934c0f2e00134c0f2e0cd0000") %>','moreCowork')"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015") %><!-- 更多 -->(<%=listSize%>)...</a>
</div>
<%}%>
