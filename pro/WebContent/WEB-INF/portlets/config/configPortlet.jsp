<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.eweaver.portal.service.PortletStyleService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.portal.model.PortletStyle"%>
<%@ page import="org.light.portal.core.entity.PortletObjectConfig"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@ include file="/common/taglibs.jsp"%>
<%
PortletStyleService portletStyleService = (PortletStyleService)BaseContext.getBean("portletStyleService");
List<PortletStyle>  portletStyleList = portletStyleService.getAllPortletStyle();
PortletObjectConfig portletObjectConfig = (PortletObjectConfig)request.getAttribute("portletObjectConfig");
String portletStyleId = (portletObjectConfig == null ? "" : portletObjectConfig.getPortletStyleId());
int colspan = NumberHelper.getIntegerValue(request.getAttribute("colspan"), 1);
int totalColumns = NumberHelper.getIntegerValue(request.getAttribute("totalColumns"), 3);
%>
<html>
<head>
</head>
<body>
<fmt:bundle basename="resourceBundle">
<form name="form_<c:out value="${requestScope.responseId}"/>">
<input type="hidden" name="configId" value="<c:out value="${portletObjectConfig.id}"/>"/>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
	<col width="50" />
	<col width="*"/>
	<tr>
		<td class="FieldName">
			样式：
		</td>
		<td class="FieldName">
			<select id="portletStyleId" name="portletStyleId" class="inputstyle2" style="width: 150px;">
				<option value=""></option>
				<% for(PortletStyle portletStyle : portletStyleList){ %>
						<option value="<%=portletStyle.getId() %>" <%if(portletStyle.getId().equals(portletStyleId)){%> selected="selected" <%}%>><%=portletStyle.getObjname() %></option>
				<% } %>
			</select> 
		</td>
	</tr>
	<tr>
		<td class="FieldName">
			跨列：
		</td>
		<td class="FieldName">
			<select id="colspan" name="colspan" class="inputstyle2" style="width: 150px;">
				<option value=""></option>
				<% for(int i = 1; i <= totalColumns; i++){ %>
					<option value="<%=i %>" <%if(colspan == i){%> selected="selected" <%}%>><%=i %></option>	
				<% } %>
			</select> 
		</td>
	</tr>
<tr>
	<td align="left" colspan='2'>
		<div style="margin-top: 5px;">
			<input name='Submit' type='button' value='<fmt:message key="portlet.button.save"/>' class='portlet-form-button' style="width: 50px;height: 20px;cursor: pointer;"
		 	onclick="javascript:configPortlet('<c:out value="${requestScope.responseId}"/>');" />
			<input name='Submit' type='button' value='取消' class='portlet-form-button' style="width: 50px;height: 20px;cursor: pointer;"
		 	onclick="javascript:cancelConfigPortlet('<c:out value="${requestScope.responseId}"/>');" />
		</div>
	</td>
</tr>
</table>
</form>
</fmt:bundle>
</body>
</html>