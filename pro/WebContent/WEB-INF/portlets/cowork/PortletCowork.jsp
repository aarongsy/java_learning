<%@ page language="java" pageEncoding="UTF-8" import="java.util.*" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ include file="/common/taglibs.jsp" %>
<script>
function rePositionCurrentPortalTab(){
	var currentTabId = Light.portal.GetFocusedTabId();
    var index = currentTabId.substring(8, currentTabId.length);
	// Light.portal.tabs[index].rePositionAll();
}
</script>
<!-- ---------创建，编辑 页面开始----------- -->
<c:choose>
<c:when test="${mode=='edit'}">
<html>
<body>
<div style="height:130px" >
<form action="<portlet:actionURL portletMode='EDIT'/>">
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
<col width="100" />
<col width="*"/>
<tr><td class="FieldName">Id:</td><td class="FieldName">document_<%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName">
<input class="inputstyle2" type="text" id="reportLabel" name="label" value="<c:out value="${label}"/>"/></td></tr>
<tr><td class="FieldName">协作类别:</td><td class="FieldName">
<%
String browserid = CoworkHelper.getParams("coworktype");

%>
<button type="button" class="Browser" onclick="Portlet.getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=browserid%>','coworktype','coworktypespan','0');"></button>
<input type="hidden" name="coworktype" id="coworktype" value='<c:out value="${coworktype}"/>' />
<span id="coworktypespan"><c:out value="${coworktypename}"/></span>
</td>
</tr>
<tr><td class="FieldName">统计方式:</td><td class="FieldName">
<select name="counttype" id="counttype">
<option value="0" <c:if test="${counttype=='0'}">selected="selected"</c:if>>全部</option>
<option value="1" <c:if test="${counttype=='1'}">selected="selected"</c:if>>未读</option>
</select>
</td>
</tr>
<tr><td class="FieldName">显示行数:</td><td class="FieldName"><input class="inputstyle2"  name="ncount" id="ncount" value="<c:out value="${ncount}"/>"/>
</td></tr>
<tr><td class="FieldName">是否显示未读数:</td><td class="FieldName">
<input class="inputstyle2" id="showunread" name="showunread" type="checkbox" value="<c:out value="${showunread}"/>" <c:if test="${showunread=='1'}">checked="checked"</c:if>/>
</td></tr>
<tr><td class="FieldName">副标題显示方式:</td><td class="FieldName">
<select name="subhead" id="subhead">
<option value="2" <c:if test="${subhead=='2'}">selected="selected"</c:if>>无</option>
<option value="0" <c:if test="${subhead=='0'}">selected="selected"</c:if>>协作描述</option>
<option value="1" <c:if test="${subhead=='1'}">selected="selected"</c:if>>最后回复</option>
</select>
</td>
</tr>
<tr><td class="FieldName">其他显示方式:</td><td class="FieldName">
<select name="otherview" id="otherview">
<option value="2" <c:if test="${otherview=='2'}">selected="selected"</c:if>>无</option>
<option value="0" <c:if test="${otherview=='0'}">selected="selected"</c:if>>最后回复人员</option>
<option value="1" <c:if test="${otherview=='1'}">selected="selected"</c:if>>最后回复日期</option>
</select>
</td></tr>
<tr><td colspan="2" align="center">
<input type="button" name="btnOk" value="确定" onclick="PortletCowork.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/></td></tr>
</table>
</form>
</div>
</body>
</html>
</c:when>
<c:otherwise>
<!-- ---------创建，编辑 页面结束----------- -->
<!-- 展现 （协作信息）开始  --------------------------------------------------------- -->
<%
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />未设置好协作区关联表单信息，请联系管理员！</h5>");
	return;
}
JSONObject jsonObj = (JSONObject)request.getAttribute("cowork_jsonobj");
Long ncount=10L;
String coworktype="";
String showunread="";
String subhead="2";
String counttype="0";
String otherview="2";
if(jsonObj!=null){
	Object obj=null;
	obj=jsonObj.get("ncount");
	if(obj!=null) ncount = (Long)obj;
	obj=jsonObj.get("coworktype");
	if(obj!=null) coworktype = (String)obj;
	obj=jsonObj.get("showunread");
	if(obj!=null) showunread = (String)obj;
	obj=jsonObj.get("subhead");
	if(obj!=null) subhead = (String)obj;
	obj=jsonObj.get("counttype");
	if(obj!=null) counttype = (String)obj;
	obj=jsonObj.get("otherview");
	if(obj!=null) otherview = (String)obj;
}
String type=""; //全部协作 - 参与协作 - 我的协作 - 停止协作 - 关闭协作
String tagid="402881e83abf0214013abf0220810290";//全部（没有隐藏） - 重要（没有隐藏） - 隐藏  说明：未读已经包含在了三类里面无需另加入
String order="unread";
String searchtype=coworktype;
String searchobjname="";
Map<String,String> map = new HashMap<String,String>();
map.put("type",type);
map.put("tagid",tagid);
map.put("order",order);
map.put("searchtype",searchtype);
map.put("searchobjname",searchobjname);
map.put("showunread",showunread);
map.put("subhead",subhead);
map.put("counttype",counttype);
map.put("otherview",otherview);
%>
<html>
<body scroll="no" style="overflow-y:hidden">
<script type="text/javascript">
//创建工具提示文件加载
function showtip(){ 
	$('.unread').each(function(){
		// 设置提示的内容
		$(this).qtip({
			content: $(this).attr('tipstr'),
			position: {
				corner: {
					tooltip: 'rightTop',
					target: 'rightMiddle'
				}
			},
			style: {
				tip: true, // 给它一个语音气泡提示与自动角点检测
				name: 'cream',
				border:'1px', /*边框颜色*/
				color: '#999',
				font:'Microsoft YaHei',
				background:'#ffffa3'
			}
		});
	});
	
}

$(document).ready(function(){
		 showtip();
});
</script>
<link  type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/app/cooperation/css/portlet.css" />
<%
int pageNo = 1;
int pageSize = ncount.intValue();
/*计算总页数*/
CoWorkService coWorkService = new CoWorkService();
List<Map<String,String>> portal = coWorkService.getCoworkPortal(pageNo,pageSize,map);
%>
<table width="100%" border="0" style="table-layout:fixed;" cellpadding="0" cellspacing="0" >
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/main.js"></script>
   <%
   if(portal!=null && portal.size()>0){
	   for(Map<String,String> pm:portal){
		   String subject=StringHelper.null2String(pm.get("subject"));
		   String requestid=StringHelper.null2String(pm.get("requestid"));
		   String tipimg=StringHelper.null2String(pm.get("tipimg"));
		   String coworksubhead = "";
		   if(subhead.equals("0")){
		       coworksubhead=StringHelper.null2String(pm.get("coworkremark"));
		   }else{
			   coworksubhead=StringHelper.null2String(pm.get("lastcontent"));
		   }
		   String otherproperties = "";
		   if(otherview.equals("0")){
			   otherproperties = StringHelper.null2String(pm.get("objname"));
		   }else{
			   otherproperties = StringHelper.null2String(pm.get("lastdate"));
		   }
   %>
    <%if(!subhead.equals("2") && !otherview.equals("2")){%>
	<tr style="height: 45px;">
	<td style="word-break:keep-all;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" class="title d2">
	<a href="javascript:readCowork('<%=requestid%>','<c:out value="${requestScope.responseId}"/>','<%=StringHelper.convertToUnicode(subject)%>');" ><%=subject %></a><br/>
	<%=coworksubhead %>
	</td>
    <td style="padding-left: 3px" width="65px" id="<%=requestid %>_tipimg">
    <div class="d4" ><%=otherproperties %></div><br/>
    <div class="d3" ><%=tipimg %></div>
    </td> 
	</tr> 
	<tr style="height:1px" >
    <td style="background-color: #D2DCE8;" colspan="2">
    </td>
    </tr>
    <%}else if(!subhead.equals("2") && otherview.equals("2")){%>
    <tr style="height: 45px;">
	<td style="word-break:keep-all;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" class="title d2">
	<a href="javascript:readCowork('<%=requestid%>','<c:out value="${requestScope.responseId}"/>','<%=StringHelper.convertToUnicode(subject)%>');" ><%=subject %></a><br/>
	<%=coworksubhead %>
	</td>
    <td style="padding-left: 3px" width="60px" id="<%=requestid %>_tipimg">
    <div class="d3" ><%=tipimg %></div>
    </td> 
	</tr> 
	<tr style="height:1px" >
    <td style="background-color: #D2DCE8;" colspan="2">
    </td>
    </tr>	
    <%}else if(subhead.equals("2") && !otherview.equals("2")){%>
    <tr style="height: 25px;">
	<td style="word-break:keep-all;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" class="title d2">
	<a href="javascript:readCowork('<%=requestid%>','<c:out value="${requestScope.responseId}"/>','<%=StringHelper.convertToUnicode(subject)%>');" ><%=subject %></a>
	</td>
    <td style="padding-left: 3px" width="110px" id="<%=requestid %>_tipimg">
    <div class="d4" ><%=otherproperties %>&nbsp;&nbsp;</div><div class="d3" ><%=tipimg %></div>
    </td> 
	</tr> 
	<tr style="height:1px" >
    <td style="background-color: #D2DCE8;" colspan="2">
    </td>
    </tr>	
    <%}else if(subhead.equals("2") && otherview.equals("2")){%>
    <tr style="height:25px;">
	<td style="word-break:keep-all;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" class="title d2">
	<a href="javascript:readCowork('<%=requestid%>','<c:out value="${requestScope.responseId}"/>','<%=StringHelper.convertToUnicode(subject)%>');" ><%=subject %></a>
	</td>
    <td style="padding-left: 3px" width="60px" id="<%=requestid %>_tipimg">
    <div class="d3" ><%=tipimg %></div>
    </td> 
	</tr> 
	<tr style="height:1px" >
    <td style="background-color: #D2DCE8;" colspan="2">
    </td>
    </tr>
    <%}%>
	<%}} %>
    </table>
</body>
</html>
<!-- 展现 （协作信息）结束  --------------------------------------------------------- -->
</c:otherwise>
</c:choose>
