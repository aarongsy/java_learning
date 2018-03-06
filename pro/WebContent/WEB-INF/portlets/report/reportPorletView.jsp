<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@ include file="/common/taglibs.jsp"%>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
%>
<c:choose>
<c:when test="${mode=='edit'}">
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
<tr><td class="FieldName">Id:</td><td class="FieldName">chart_<%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName"><input class="inputstyle2" maxlength="100" type="text" id="reportLabel" name="label" value="<c:out value="${label}"/>"/>
<c:if test="${not empty col1}">
	<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
</c:if>
</td></tr>
<tr><td class="FieldName">是否显示字段名称:</td><td class="FieldName"><input name="showField" type="checkbox" value="1" <c:if test="${showField==1}">checked</c:if> /></td></tr>
<tr><td class="FieldName">报表:</td><td class="FieldName"><select class="inputstyle2" name="reportId" id="reportId" style="width:200px" onchange="ReportPortlet.getReportFields(this);">
<c:forEach var="report" items="${reports}">
<option <c:if test="${reportId==report.id}">selected="selected"</c:if> value='<c:out value="${report.id}"/>'><c:out value="${report.objname}"/></option>
</c:forEach>
</select></td></tr>
<tr><td class="FieldName">报表数据类型:</td><td class="FieldName">
<select name="isForm" id="isForm">
<c:forEach var="f" items="${reportDataType}"><option <c:if test="${f.value==isForm}">selected="selected"</c:if> value='<c:out value="${f.value}"/>'><c:out value="${f.key}"/></option></c:forEach>
</select>
</td></tr>
<tr><td class="FieldName">行数:</td><td class="FieldName"><input class="inputstyle2" maxlength="10" onkeyup="value=value.replace(/[^\d]/ig,'')"  name="nCount" id="nCount" length="2" size="5" value="<c:out value="${nCount}"/>"/></td></tr>
<tr><td class="FieldName">刷新间隔:</td><td class="FieldName"><input class="inputstyle2" onblur="this.value=(parseInt(this.value)>0 && parseInt(this.value)<=5?5:this.value);" onkeypress="checkInt_KeyPress()" name="periodTime" id="periodTime" length="2" size="5" value="<c:out value="${periodTime}"/>"/>分(0为不刷新,最小5分钟)</td></tr>
<tr><td class="FieldName">字段</td><td class="FieldName">(双击增加/删除显示列)</td></tr>
<tr><td colspan="2"  class="FieldName" valign="middle">
<div style="float:left;">
<select id="reportFields" name="reportFields" style="width:240px;height:120px;" size="5" title="双击增加字段" ondblclick="ReportPortlet.addOption(this);">
<c:forEach var="f" items="${fieldViewNames}"><option value='<c:out value="${f.key}"/>' title='<c:out value="${f.value}"/>-<c:out value="${f.key}"/>'><c:out value="${f.value}"/>-<c:out value="${f.key}"/></option></c:forEach>
</select>-&gt;
<select id="myFields" name="myFields" style="width:150px;height:120px;" size="5" title="双击删除显示字段" ondblclick="ReportPortlet.delOption(this);">
<c:forEach var="f" items="${fields}"><option value='<c:out value="${f}"/>' title='<c:out value="${fieldViewNames[f]}"/>-<c:out value="${f}"/>'><c:out value="${fieldViewNames[f]}"/>-<c:out value="${f}"/></option></c:forEach>
</select>
<select id="myFieldsWidth" style="width:50px;height:120px;" name="myFieldsWidth" size="5" title="双击修改字段"  ondblclick="ReportPortlet.changeWidth(this);">
<c:forEach var="f" items="${fieldsWidth}"><option value='<c:out value="${f}"/>' title='<c:out value="${f}"/>'><c:out value="${f}"/></option></c:forEach>
</select>
</div>
<div style="padding-left:10px;height:80px;float:left;">
<br/>
<a href="javascript:;" onclick="ReportPortlet.sortField(-1)" title="选中字段向上移动">&uarr;</a><br/>
<br/><br/>
<a href="javascript:;" onclick="ReportPortlet.sortField(1)" title="选中字段向下移动">&darr;</a>
</div>
</td></tr>
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="ReportPortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/></td></tr>
</table>
</form>
</c:when>
<c:otherwise>

<c:if test="${state=='maximized'}">
<iframe width="100%" height="100%" src='<c:out value="${url}"/>' border="0" frameborder="0"></iframe>
</c:if>

<c:if test="${state!='maximized'}">
<table border="0" align="center" class="Econtent" style="width:98%" cellspacing="1">
<col width="20" />
<c:forEach var="f" items="${fieldsWidth}">
<col width="<c:out value="${f}"/>" />
</c:forEach>
<c:set var="nFields" value="0"/>
<!--
<tr class="Header" style="font-weight:bold;"><c:forEach var="f" items="${fields}" varStatus="status"><c:set var="nFields" value="${status.count}"/><td><c:out value="${fieldViewNames[f]}"/></td></c:forEach>
</tr>
-->
<c:if test="${showField==1}">
<tr ><td align="center" width="20" >&nbsp;&nbsp;</td>
<c:forEach var="f" items="${fields}"><td align="left"><c:out value="${fieldViewNames[f]}" escapeXml="false"/></td></c:forEach></tr>
<tr height="1"><td class="line" colspan='<c:out value="${nFields+1}"/>'></td></tr>
</c:if>
<c:forEach var="m" items="${list1}" varStatus="status">
<tr class="row"><td align="center" width="20" class="itemIcon">&nbsp;&nbsp;</td><c:forEach var="f" items="${fields}"><td align="left"><c:out value="${m[f]}" escapeXml="false"/></td></c:forEach></tr>
<c:if test="${!status.last}"><tr height="1"><td class="line" colspan='<c:out value="${nFields+1}"/>'></td></tr></c:if>
</c:forEach>
<c:if test="${haveSize>0}">
<tr><td colspan="10" align="right" style="padding-right:20px;"><a href="javascript:onUrl('<c:out value="${url}"/>','<c:out value="${title}"/>','<c:out value="${tabid}"/>')"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015")%><!-- 更多 --><span title="显示数/总数">(<c:out value="${haveSize}"/>/<c:out value="${totalsize}"/>)</span>...</a></td></tr>
</c:if>
</table>
<c:if test="${empty list1}">&nbsp;<%=labelService.getLabelName("4028836a366236d30136623c4eca0065")%></c:if>
</c:if>
</c:otherwise>
</c:choose>