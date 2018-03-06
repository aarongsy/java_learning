<jsp:directive.page contentType="text/html; charset=UTF-8"/>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="org.light.portal.core.PortalUtil"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<jsp:directive.include file="/common/taglibs.jsp"/>
<jsp:directive.include file="/light/init.jsp"/>
<jsp:directive.page import="org.light.portal.core.entity.PortletObjectRef"/>
<jsp:directive.page import="org.light.portal.core.service.PortalService"/>
<% 
	labelService = (LabelService)BaseContext.getBean("labelService");
%>
<jsp:declaration><![CDATA[
private void main(HttpServletRequest request){
	PortalService ps=PortalUtil.getPortalService();
	String name=StringHelper.null2String(request.getParameter("name"));
	String action=StringHelper.null2String(request.getParameter("action"));
	PortletObjectRef ref=null;
	String info=null;
	if(action.equalsIgnoreCase("new")){
	
	}else if(action.equalsIgnoreCase("update")){
		if(!name.equalsIgnoreCase("")) ref=ps.getPortletRefByName(name);
	}else if(action.equalsIgnoreCase("save")){//保存
		ref=new PortletObjectRef();
		ref.setName(name);
		ref.setAutoRefreshed(NumberHelper.string2Int(request.getParameter("autoRefreshed"),0));
		ref.setPath(StringHelper.null2String(request.getParameter("path")));
		ref.setLabel(StringHelper.null2String(request.getParameter("label")));
		ref.setIcon(StringHelper.null2String(request.getParameter("icon")));
		ref.setUrl(StringHelper.null2String(request.getParameter("url")));	
		ref.setTag(StringHelper.null2String(request.getParameter("tag")));
		ref.setParameter(StringHelper.null2String(request.getParameter("parameter")));
		ref.setRefreshMode(NumberHelper.string2Int(request.getParameter("refreshMode"),0));	
	ref.setEditMode(NumberHelper.string2Int(request.getParameter("editMode"),0));
	ref.setHelpMode(NumberHelper.string2Int(request.getParameter("helpMode"),0));
	ref.setConfigMode(NumberHelper.string2Int(request.getParameter("configMode"),0));	
	ref.setAutoRefreshed(NumberHelper.string2Int(request.getParameter("autoRefreshed"),0));
	ref.setAllowJS(NumberHelper.string2Int(request.getParameter("allowJS"),0));
	ref.setPageRefreshed(NumberHelper.string2Int(request.getParameter("pageRefreshed"),0));
	ref.setClientCached(NumberHelper.string2Int(request.getParameter("clientCached"),0));
	ref.setPeriodTime(NumberHelper.string2Int(request.getParameter("periodTime"),0));
	ref.setShowNumber(NumberHelper.string2Int(request.getParameter("showNumber"),0));
	ref.setUserId("role_public");
		ps.save(ref);
		ref=null;
		action=null;
	}
	List<PortletObjectRef> list1 = ps.getPortletRefsByUser("role_public");
	request.setAttribute("list1",list1);
	request.setAttribute("obj",ref);
	request.setAttribute("action",action);
	request.setAttribute("info",info);
}//end main;
]]>
</jsp:declaration>
<jsp:scriptlet>this.main(request);</jsp:scriptlet>
<html>
<head>
<jsp:include flush="true" page="/common/meta.jsp"/>
<title>PortletConfig</title>
<script language="javascript">
function doSave(oForm){
	EweaverForm.submit();
}
function doNew(){
	window.location.href="<%=request.getContextPath()%>/light/portletConfig.jsp?action=new";
}
function doEdit(n){
	window.location.href="<%=request.getContextPath()%>/light/portletConfig.jsp?action=update&name="+n;
}
</script>
</head>
	<body>

	<h3>PortletConfig。。。</h3>
<c:if test="${info}"><div><c:out value="${info }"/></div></c:if>
<input type="button" value="<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20007") %>" onclick="doNew()"/><!-- 新增Portlet -->
<table>
<tr><td>
	<table style="width:400px;" border="1">
	<c:forEach items="${list1}" var="i">
	<tr><td><c:out value="${i.label}"/></td>
	<td>
	<a href="javascript:doEdit('<c:out value="${i.name}"/>');"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b7750a15b000b") %><!-- 编辑 --></a>
	</td>
	</tr>
	</c:forEach>
	</table>
</td><td>
<form action="<%=request.getContextPath()%>/light/portletConfig.jsp" id="EweaverForm" name="EweaverForm" method="post">
<input type="hidden" name="action" value="save"/>
<table id="editTable" style='width:350px;<c:if test="${empty action}">display:none;</c:if>'" width="346" border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td width="91" align="right">name</td>
    <td width="242">
    <c:if test="${action=='new'}"><input name="name" type="text" id="name" value='' /></c:if>
    <c:if test="${action=='update'}"><input name="name" type="hidden" id="name" value='<c:out value="${obj.name}"/>' /><c:out value="${obj.name}"/></c:if>
    </td>
  </tr>
  <tr>
    <td align="right">path</td>
    <td><input name="path" type="text" id="path" value='<c:out value="${obj.path}"/>' /></td>
  </tr>
  <tr>
    <td align="right">label</td>
    <td><input name="label" type="text" id="label" value='<c:out value="${obj.label}"/>' /></td>
  </tr>
  <tr>
    <td align="right">icon</td>
    <td><input name="icon" type="text" id="icon"  value='<c:out value="${obj.icon}"/>' /></td>
  </tr>
  <tr>
    <td align="right">url</td>
    <td><input name="url" type="text" id="url" value='<c:out value="${obj.url}"/>' /></td>
  </tr>
  <tr>
    <td align="right">tag</td>
    <td><input name="tag" type="text" id="tag" value='<c:out value="${obj.tag}"/>' /></td>
  </tr>
  <tr>
    <td align="right">refreshMode</td>
    <td><input name="refreshMode" type="text" id="refreshMode" value='<c:out value="${obj.refreshMode}"/>' /></td>
  </tr>
  <tr>
    <td align="right">editMode</td>
    <td><input name="editMode" type="text" id="editMode" value='<c:out value="${obj.editMode}"/>' /></td>
  </tr>
  <tr>
    <td align="right">helpMode</td>
    <td><input name="helpMode" type="text" id="helpMode" value='<c:out value="${obj.helpMode}"/>' /></td>
  </tr>
  <tr>
    <td align="right">configMode</td>
    <td><input name="configMode" type="text" id="configMode" value='<c:out value="${obj.configMode}"/>' /></td>
  </tr>
  <tr>
    <td align="right">autoRefreshed</td>
    <td><input name="autoRefreshed" type="text" id="autoRefreshed" value='<c:out value="${obj.autoRefreshed}"/>' /></td>
  </tr>
  <tr>
    <td align="right">allowJS</td>
    <td><input name="allowJS" type="text" id="allowJS" value='<c:out value="${obj.allowJS}"/>' /></td>
  </tr>
  <tr>
    <td align="right">pageRefreshed</td>
    <td><input name="pageRefreshed" type="text" id="pageRefreshed" value='<c:out value="${obj.pageRefreshed}"/>' /></td>
  </tr>
  <tr>
    <td align="right">clientCached</td>
    <td><input name="clientCached" type="text" id="clientCached" value='<c:out value="${obj.clientCached}"/>' /></td>
  </tr>
  <tr>
    <td align="right">periodTime</td>
    <td><input name="periodTime" type="text" id="periodTime" value='<c:out value="${obj.periodTime}"/>' /></td>
  </tr>
  <tr>
    <td align="right">showNumber</td>
    <td><input name="showNumber" type="text" id="showNumber" value='<c:out value="${obj.showNumber}"/>' /></td>
  </tr>
  <tr>
    <td align="right">parameter</td>
    <td><input name="parameter" type="text" id="parameter" value='<c:out value="${obj.parameter}"/>' /></td>
  </tr>
  <tr>
    <td align="right"><input type="button" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>" onclick="doSave(this.form)"/><!-- 确定 --></td>
    <td><input type="button" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>" onclick="$('editTable').style.display='none';"/><!-- 取消 --></td>
  </tr>
</table>
</form>
</td></tr>
</table>

	</body>
</html>