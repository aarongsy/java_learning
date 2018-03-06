<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.service.TemplateEngine"/>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ include file="/common/taglibs.jsp"%>
<%
String viewerId=StringHelper.null2String(request.getAttribute("viewerId"));
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
%>
<c:choose>
<c:when test="${mode=='edit'}">
<form action="<portlet:actionURL portletMode='EDIT'/>" id="templatePortletForm_<c:out value="${requestScope.responseId}"/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
标题: <input name="title" id="title" maxlength="100" value='<c:out value="${title}"/>'/>
<c:if test="${not empty col1}">
	<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
</c:if>
<br/>
编辑视图: <button type="button" class="Browser" onclick="javascript:Portlet.getBrowser('<c:out value="${pageContext.request.contextPath}"/>/base/refobj/baseobjbrowser.jsp?id=402880322230826901223084d0c60003','editTemp','editTempspan','0');"></button>
<input type="hidden" id="editTemp" value='<c:out value="${editTemp}"/>' name="editTemp"/><span id="editTempspan"><c:out value="${editTempname}"/></span><br/>
配置视图: <button type="button" class="Browser" onclick="javascript:Portlet.getBrowser('<c:out value="${pageContext.request.contextPath}"/>/base/refobj/baseobjbrowser.jsp?id=402880322230826901223084d0c60003','configTemp','configTempspan','0');"></button>
<input type="hidden" id="configTemp" value='<c:out value="${configTemp}"/>' name="configTemp"/><span id="configTempspan"><c:out value="${configTempname}"/></span><br/>
显示视图: <button type="button" class="Browser" onclick="javascript:Portlet.getBrowser('<c:out value="${pageContext.request.contextPath}"/>/base/refobj/baseobjbrowser.jsp?id=402880322230826901223084d0c60003','viewTemp','viewTempspan','0');"></button>
<input type="hidden" id="viewTemp" value='<c:out value="${viewTemp}"/>' name="viewTemp"/><span id="viewTempspan"><c:out value="${viewTempname}"/></span><br/>
<c:if test="${not empty viewerId}">
<%new TemplateEngine(request,out).parseTemplate(viewerId, "");//默认空参数%>
</c:if>
<input type="button" value="Ok" onclick="TemplatePortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;
<input type="button" value="Cancel" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/>
</form>
</c:when>
<c:when test="${mode=='config'}">
<c:if test="${not empty viewerId}">
<%new TemplateEngine(request,out).parseTemplate(viewerId, "");%>
</c:if>
<c:if test="${empty viewerId}">请联系管理员，设置Portlet.config视图</c:if>
</c:when>
<c:otherwise>
<c:if test="${not empty viewerId}">
<%new TemplateEngine(request,out).parseTemplate(viewerId, "");//默认空参数%>
</c:if>
<c:if test="${empty viewerId}">请联系管理员，设置Portlet.view视图</c:if>
</c:otherwise>
</c:choose>