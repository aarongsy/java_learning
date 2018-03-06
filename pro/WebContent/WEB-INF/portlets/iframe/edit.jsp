<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ include file="/common/taglibs.jsp"%>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
%>
<form method="post" action="<portlet:actionURL/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<fmt:bundle basename="resourceBundle">
	<table>
        <tr class="portlet-msg-alert">
            <td colspan="2"><%= request.getParameter("message") != null ?  request.getParameter("message") : ""%></td>
        </tr>
        <tr>
			<td class="portlet-table-td-left">标题</td>
			<td class="portlet-table-td-left"><input type="text" name="title" maxlength="100" class='portlet-form-input-field' value="<%=StringHelper.StringReplace(request.getAttribute("title").toString(),"\"","&quot;") %>" size="50"/>
			<c:if test="${not empty col1}">
				<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
			</c:if>
			</td>
		</tr>

        <tr>
			<td class="portlet-table-td-left">无IFrame消息</td>
			<td class="portlet-table-td-left"><input type="text" name="noiframemessage" maxlength="128" class='portlet-form-input-field' value="<%= request.getAttribute("iframemessage") %>" size="50"/></td>
		</tr>
        <tr>
			<td class="portlet-table-td-left">源URL</td>
			<td class="portlet-table-td-left"><input type="text" name="url" class='portlet-form-input-field' value="<%= request.getAttribute("iframeurl") %>" size="50"/></td>
		</tr>
		<tr>
			<td class="portlet-table-td-left">宽度(px or %)</td>
			<td class="portlet-table-td-left"><input type="text" name="width" class='portlet-form-input-field' value="<%= request.getAttribute("iframewidth") %>"/></td>
		</tr>
        <tr>
			<td class="portlet-table-td-left">高度(px)</td>
			<td class="portlet-table-td-left"><input type="text" name="height" class='portlet-form-input-field' value="<%= request.getAttribute("iframeheight") %>"/></td>
		</tr>        
		<tr>
			<td class="portlet-table-td-left">最大高度(px or %)</td>
			<td class="portlet-table-td-left"><input type="text" name="maxHeight" class='portlet-form-input-field' value="<%= request.getAttribute("iframemaxheight") %>"/></td>
		</tr>
        <tr>
			<td class='portlet-table-td-right' colspan ='2'>
			<input type='button' name='action' onClick="ExternalNetwork.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')" value='保存' class='portlet-form-button' />
			<input type='submit' name='action' onClick="document.pressed='cancel';document.mode='view';" value='取消' class='portlet-form-button' />
			</td>
        </tr>
    </table>
</fmt:bundle>
</form>