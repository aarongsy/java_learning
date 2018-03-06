<jsp:directive.page contentType="text/html; charset=UTF-8"/>
<%@page import="java.util.List"%>
<%@page import="org.light.portal.core.PortalUtil"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<jsp:directive.include file="/common/taglibs.jsp"/>
<jsp:directive.include file="/light/init.jsp"/>
<jsp:directive.page import="org.light.portal.core.service.PortalService"/>
<jsp:directive.page import="org.light.portal.core.entity.PortalTab"/>
<jsp:directive.page import="org.light.portal.core.entity.PortletObject"/>
<% 
	labelService = (LabelService)BaseContext.getBean("labelService");
%>
<jsp:declaration><![CDATA[
private void main(HttpServletRequest request){
	PortalService ps=PortalUtil.getPortalService();
	PortalTab tab=null;
	String action=StringHelper.null2String(request.getParameter("action"));
	int id=NumberHelper.string2Int(request.getParameter("id"),0);
	if(id>0 && action.equalsIgnoreCase("update")){
		tab=ps.getPortalTabById(id);
	}else if(action.equalsIgnoreCase("save")){
		tab=new PortalTab();
		if(id>0)tab.setId(id);
		tab.setLabel(StringHelper.null2String(request.getParameter("label")));
		tab.setUrl(StringHelper.null2String(request.getParameter("url")));
		tab.setColor(StringHelper.null2String(request.getParameter("color")));
		tab.setWidths(StringHelper.null2String(request.getParameter("widths")));
		tab.setPortletWindowType(StringHelper.null2String(request.getParameter("portletWindowType")));
		tab.setUserId("role_public");
		tab.setCloseable(NumberHelper.string2Int(request.getParameter("closeable")));
		tab.setEditable(NumberHelper.string2Int(request.getParameter("editable")));
		tab.setMoveable(NumberHelper.string2Int(request.getParameter("moveable")));
		tab.setAllowAddContent(NumberHelper.string2Int(request.getParameter("allowAddContent")));
		tab.setDefaulted(NumberHelper.string2Int(request.getParameter("defaulted")));
		tab.setBetween(NumberHelper.string2Int(request.getParameter("between")));
		ps.save(tab);
		tab=null;
		action=null;
	}else if(id>0 && action.equalsIgnoreCase("portlets")){
		List<PortletObject> portletsList=ps.getPortletsByTab(id);
		request.setAttribute("portlets",portletsList);
		request.setAttribute("tabId",id);
	}else if(action.equalsIgnoreCase("savePortlet")){//保存portlet的编辑
		PortletObject obj=new PortletObject();
		obj.setId(NumberHelper.string2Int(request.getParameter("id"),0));
		obj.setColumn(NumberHelper.string2Int(request.getParameter("column")));
		obj.setRow(NumberHelper.string2Int(request.getParameter("row")));
		obj.setLabel(StringHelper.null2String(request.getParameter("label")));
		obj.setIcon(StringHelper.null2String(request.getParameter("icon")));
		obj.setUrl(StringHelper.null2String(request.getParameter("url")));
		obj.setName(StringHelper.null2String(request.getParameter("name")));
		obj.setPath(StringHelper.null2String(request.getParameter("path")));
		obj.setCloseable(NumberHelper.string2Int(request.getParameter("closeable"),0));
		obj.setRefreshMode(NumberHelper.string2Int(request.getParameter("refreshMode"),1));
		obj.setEditMode(NumberHelper.string2Int(request.getParameter("editMode"),1));
		obj.setHelpMode(NumberHelper.string2Int(request.getParameter("helpMode"),0));
		obj.setConfigMode(NumberHelper.string2Int(request.getParameter("configMode"),0));
		obj.setAutoRefreshed(NumberHelper.string2Int(request.getParameter("autoRefreshed"),0));
		obj.setPeriodTime(NumberHelper.string2Int(request.getParameter("periodTime"),0));
		obj.setShowNumber(NumberHelper.string2Int(request.getParameter("showNumber"),0));
		obj.setParameter(StringHelper.null2String(request.getParameter("parameter")));
		obj.setAllowJS(NumberHelper.string2Int(request.getParameter("allowJS"),0));
		obj.setPageRefreshed(NumberHelper.string2Int(request.getParameter("pageRefreshed"),0));
		obj.setClientCached(NumberHelper.string2Int(request.getParameter("clientCached"),0));
		obj.setTabId(NumberHelper.string2Int(request.getParameter("tabId")));
		obj.setBarBgColor(StringHelper.null2String(request.getParameter("barBgColor")));
		obj.setBarFontColor(StringHelper.null2String(request.getParameter("barFontColor")));
		obj.setContentBgColor(StringHelper.null2String(request.getParameter("contentBgColor")));
		//obj.setPreferences();
		obj.setWindowStatus(NumberHelper.string2Int(request.getParameter("windowStatus"),0));
		obj.setMode(NumberHelper.string2Int(request.getParameter("mode"),0));
		ps.save(obj);
	}//end if.
	List<PortalTab> list1=ps.getPortalTabByUser("role_public");
	if(action.equalsIgnoreCase("newPortalTab")){
		/*
		tab=list1.get(0);//新建PortalTab,设置默认值
		tab.setId(list1.size()+1);
		tab.setLabel("NewTab");
		tab.setPortletWindowType("PortletWindow2");
		tab.setWidths() var columns = 3;
		  var between = 10;
		  var widths ="&width0=300&width1=300&width2=300"; 
		  var closeable = "1";
		  var defaulted = "0";
		*/
	}//end if.
	
	request.setAttribute("list1",list1);
	request.setAttribute("action",action);
	request.setAttribute("tab",tab);
}//end main;
]]>
</jsp:declaration>
<jsp:scriptlet>this.main(request);</jsp:scriptlet>
<html>
<head>
<jsp:include flush="true" page="/common/meta.jsp"/>
<title>PortalConfig</title>
<script language="javascript">
WeaverUtil.imports(['<%=request.getContextPath()%>/dwr/engine.js','<%=request.getContextPath()%>/dwr/util.js','<%=request.getContextPath()%>/dwr/interface/RemotePortal.js']);
WeaverUtil.isDebug=false;

//<c:if test="${!empty tabId}">
var tabId=<c:out value="${tabId}"/>;
//</c:if>
function doEdit(id){
	window.location.href="<%=request.getContextPath()%>/light/portalConfig.jsp?action=update&id="+id;
}

function doDelete(id){
	if(confirm("<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be10000") %>")){//确定删除该Portal.tab吗(Y/N)?
		RemotePortal.delPortalTab(id,function(data){
			$('portalTab_'+id).parent.removeNode($('portalTab_'+id));
			alert('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20001") %>'+((data>=0)?'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0045") %>!':'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>!'));//删除Porttal.tab  成功  错误
		});
	}//end if.
}

function portalTab(){
	window.location.href="<%=request.getContextPath()%>/light/portalConfig.jsp?action=newPortalTab";
}

function doPortlets(id){
	window.location.href="<%=request.getContextPath()%>/light/portalConfig.jsp?action=portlets&id="+id;

}
function doDelPortlet(id){
	if(confirm("<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20002") %>")){//确定删除该Portlets tab吗(Y/N)?
		RemotePortal.delPortletObjectById(id,function(data){
			$('porletId_'+id).parent.removeNode($('porletId_'+id));
			alert('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20003") %>'+((data>=0)?'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0045") %>!':'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>!'));//删除Portlet  成功  错误
		});
	}//end if.
}

function doEditPortlet(id){
	//Dwr获取数据编辑
	RemotePortal.getPortletObjectById(id,function(data){
		$('editPortletDiv').style.display='';
		var obj=null,i=null;	
		for(i in data){
			if(WeaverUtil.isEmpty($(i))) continue;
			obj=data[i];
			if(WeaverUtil.isFunction(obj)) continue;
			if(i.startsWith('support')) continue;//i=i.charAt(7).toLowerCase()+i.substring(8);				
			$(i).value=WeaverUtil.isEmpty(obj)?"":obj;
		}//end for.
	});
}

function doCancelEditPortlet(obj){
	obj.form.reset();
	$('editPortletDiv').style.display='none';
}
function newPortlet(){
	$('EweaverForm3').reset();
	$('tabId').value=tabId;
	$('tabId').readOnly=true;
	$('editPortletDiv').style.display='';
}
</script>
</head>
	<body>
	<h3>PortalConfig</h3>
	
	<table style="width:900;" border="1">
	<tr>
	<td>id</td><td>label</td><td>url</td><td>closeable</td><td>editable</td><td>moveable</td><td>allowAddContent</td><td>color</td>
	<td>defaulted</td><td>between</td><td>widths</td><td>portletWindowType</td><td><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %><!-- 操作 --><a href="javascript:new portalTab()"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20004") %><!-- 新建PortalTab --></a></td>
	</tr>
	<c:forEach items="${list1}" var="t">
	<tr id='portalTab_<c:out value="${t.id }"/>'>
	<td><c:out value="${t.id }"/>&nbsp;</td><td><c:out value="${t.label}"/>&nbsp;</td>
	<td><c:out value="${t.url}"/>&nbsp;</td><td><c:out value="${t.closeable}"/>&nbsp;</td>
	<td><c:out value="${t.editable}"/>&nbsp;</td><td><c:out value="${t.moveable }"/>&nbsp;</td><td><c:out value="${t.allowAddContent }"/>&nbsp;</td>
	<td><c:out value="${t.color }"/>&nbsp;</td><td><c:out value="${t.defaulted }"/></td>&nbsp;<td><c:out value="${t.between }"/>&nbsp;</td>
	<td><c:out value="${t.widths }"/>&nbsp;</td><td><c:out value="${t.portletWindowType }"/>&nbsp;</td>
	<td><a href="javascript:doEdit(<c:out value="${t.id }"/>)"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b7750a15b000b") %><!-- 编辑 --></a>&nbsp;/&nbsp;<a href="javascript:doDelete(<c:out value="${t.id }"/>)"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %><!-- 删除 --></a>&nbsp;/&nbsp;<a href="javascript:doPortlets(<c:out value="${t.id }"/>)"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20005") %><!-- 管理 --></a>
	</td>
	</tr>
	</c:forEach>
	</table>
	<c:if test="${!empty tab}">
	<hr/>
<form action="<%=request.getContextPath()%>/light/portalConfig.jsp" method="post" name="EweaverForm">
<input type="hidden" name="action" value="save"/>
<input name="id" type="hidden" id="id" value='<c:out value="${tab.id}"/>' />
<table width="413" style="width:400px;" border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td align="right">label</td>
    <td><input name="label" type="text" id="label" value='<c:out value="${tab.label}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">url</td>
    <td><input name="url" type="text" id="url" value='<c:out value="${tab.url}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">closeable</td>
    <td><input name="closeable" type="text" id="closeable" value='<c:out value="${tab.closeable}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">editable</td>
    <td><input name="editable" type="text" id="editable" value='<c:out value="${tab.editable}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">moveable</td>
    <td><input name="moveable" type="text" id="moveable" value='<c:out value="${tab.moveable}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">allowAddContent</td>
    <td><input name="allowAddContent" type="text" id="allowAddContent" value='<c:out value="${tab.allowAddContent}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">color</td>
    <td><input name="color" type="text" id="color" value='<c:out value="${tab.color}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">defaulted</td>
    <td><input name="defaulted" type="text" id="defaulted" value='<c:out value="${tab.defaulted}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">between</td>
    <td><input name="between" type="text" id="between" value='<c:out value="${tab.between}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">widths</td>
    <td><input name="widths" type="text" id="widths" value='<c:out value="${tab.widths}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td align="right">portletWindowType</td>
    <td><input name="portletWindowType" type="text" id="portletWindowType" value='<c:out value="${tab.portletWindowType}"/>' />
    &nbsp;</td>
  </tr>
  <tr>
    <td><input name="btnOk" type="submit" id="btnOk" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>" /><!-- 确定 --></td>
    <td><input name="btnCancel" type="button" id="btnCancel" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>" /><!-- 取消 --></td>
  </tr>
</table>
</form>
</c:if>

<c:if test="${!empty portlets}">
<hr/>
<form action="<%=request.getContextPath()%>/light/portalConfig.jsp" method="post" name="EweaverForm2">
<table width="829" border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td width="61">id</td>
    <td width="61">label</td>
    <td width="61">row</td>
    <td width="61">column</td>
    <td width="61">icon</td>
    <td width="61">url</td>
    <td width="61">name</td>
    <td width="61">path</td>
    <td width="85">closeable</td>
    <td width="98">refreshMode</td>
    <td width="100">operate&nbsp;&nbsp;<a href="javascript:newPortlet()"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028") %><!-- 新建 --></a></td>
  </tr>
<c:forEach var="portlet" items="${portlets }">
  <tr id='porletId_<c:out value="${portlet.id}"/>'>
    <td><c:out value="${portlet.id}"/>&nbsp;</td>
    <td><c:out value="${portlet.label}"/>&nbsp;</td>
    <td><c:out value="${portlet.row}"/>&nbsp;</td>
    <td><c:out value="${portlet.column}"/>&nbsp;</td>
    <td><c:out value="${portlet.icon}"/>&nbsp;</td>
    <td><c:out value="${portlet.url}"/>&nbsp;</td>
    <td><c:out value="${portlet.name}"/>&nbsp;</td>
    <td><c:out value="${portlet.path}"/>&nbsp;</td>
    <td><c:out value="${portlet.closeable}"/>&nbsp;</td>
    <td><c:out value="${portlet.refreshMode}"/>&nbsp;</td>
    <td><a href="javascript:doDelPortlet(<c:out value="${portlet.id }"/>);"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %><!-- 删除 --></a>&nbsp;/&nbsp;<a href="javascript:doEditPortlet(<c:out value="${portlet.id }"/>);"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b7750a15b000b") %><!-- 编辑 --></a></td>
  </tr>
</c:forEach>
</table>
</form>
</c:if>
<hr/>
<form id="EweaverForm3" name="EweaverForm3" method="post" action="<%=request.getContextPath()%>/light/portalConfig.jsp">
<input type="hidden" name="action" value="savePortlet"/>
<div style="display:none" id="editPortletDiv">
<table style="width:450px" width="453" border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td colspan="2"><strong><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20006") %><!-- 修改Portlet --></strong><br></td>
  </tr>
  <tr>
    <td align="right">id<br></td>
    <td><input name="id" type="text" readonly="readonly" id="id" /><br></td>
  </tr>
  <tr>
    <td align="right">label<br></td>
    <td><input name="label" type="text" id="label" /><br></td>
  </tr>
  <tr>
    <td align="right">row<br></td>
    <td><input name="row" type="text" id="row" /><br></td>
  </tr>
  <tr>
    <td align="right">column<br></td>
    <td><input name="column" type="text" id="column" /><br></td>
  </tr>
  <tr>
    <td align="right">icon<br></td>
    <td><input name="icon" type="text" id="icon" /><br></td>
  </tr>
  <tr>
    <td align="right">url<br></td>
    <td><input name="url" type="text" id="url" /><br></td>
  </tr>
  <tr>
    <td align="right">name<br></td>
    <td><input name="name" type="text" id="name" /><br></td>
  </tr>
  <tr>
    <td align="right">path<br></td>
    <td><input name="path" type="text" id="path" /><br></td>
  </tr>
  <tr>
    <td align="right">closeable<br></td>
    <td><input name="closeable" type="text" id="closeable" /><br></td>
  </tr>
  <tr>
    <td align="right">refreshMode<br></td>
    <td><input name="refreshMode" type="text" id="refreshMode" /><br></td>
  </tr>
  <tr>
    <td align="right">editMode<br></td>
    <td><input name="editMode" type="text" id="editMode" /><br></td>
  </tr>
  <tr>
    <td align="right">helpMode<br></td>
    <td><input name="helpMode" type="text" id="helpMode" /><br></td>
  </tr>
  <tr>
    <td align="right">configMode<br></td>
    <td><input name="configMode" type="text" id="configMode" /><br></td>
  </tr>
  <tr>
    <td align="right">autoRefreshed<br></td>
    <td><input name="autoRefreshed" type="text" id="autoRefreshed" /><br></td>
  </tr>
  <tr>
    <td align="right">periodTime<br></td>
    <td><input name="periodTime" type="text" id="periodTime" /><br></td>
  </tr>
  <tr>
    <td align="right">showNumber<br></td>
    <td><input name="showNumber" type="text" id="showNumber" /><br></td>
  </tr>
  <tr>
    <td align="right">parameter<br></td>
    <td><input name="parameter" type="text" id="parameter" /><br></td>
  </tr>
  <tr>
    <td align="right">allowJS<br></td>
    <td><input name="allowJS" type="text" id="allowJS" /><br></td>
  </tr>
  <tr>
    <td align="right">pageRefreshed<br></td>
    <td><input name="pageRefreshed" type="text" id="pageRefreshed" /><br></td>
  </tr>
  <tr>
    <td align="right">clientCached<br></td>
    <td><input name="clientCached" type="text" id="clientCached" /><br></td>
  </tr>
  <tr>
    <td align="right">tabId<br></td>
    <td><input name="tabId" type="text" id="tabId" /><br></td>
  </tr>
  <tr>
    <td align="right">barBgColor<br></td>
    <td><input name="barBgColor" type="text" id="barBgColor" /><br></td>
  </tr>
  <tr>
    <td align="right">barFontColor<br></td>
    <td><input name="barFontColor" type="text" id="barFontColor" /><br></td>
  </tr>
  <tr>
    <td align="right">contentBgColor<br></td>
    <td><input name="contentBgColor" type="text" id="contentBgColor" /><br></td>
  </tr>
  <tr>
    <td align="right">preferences<br></td>
    <td><input name="preferences" type="text" id="preferences" /><br></td>
  </tr>
  <tr>
    <td align="right">windowStatus<br></td>
    <td><input name="windowStatus" type="text" id="windowStatus" /><br></td>
  </tr>
  <tr>
    <td align="right">mode<br></td>
    <td><input name="mode" type="text" id="mode" /><br></td>
  </tr>
  <tr>
    <td width="105"><input type="submit" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>"/><!-- 确定 --><br></td>
    <td width="335"><br><input type="button" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>" onclick="doCancelEditPortlet(this);"/><!-- 取消 --><br><br></td>
  </tr>
</table>
</form>
</div>

	</body>
</html>