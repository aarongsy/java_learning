<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
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
<colgroup>
<col width="200"/>
</colgroup>
<tr><td class="FieldName">Id:</td><td class="FieldName">workflow_<%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName"><input maxlength="100" id="title1" name="title" value='<c:out value="${title}"/>'/>
<c:if test="${not empty col1}">
	<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
</c:if>
</td></tr>
<tr><td class="FieldName">流程状态:</td><td class="FieldName">
<select name="status" id="status" onchange="document.getElementById('title1').value=this.options[this.selectedIndex].text;">
<option value="0" <c:if test="${status==0}">selected</c:if> >待办事宜</option>
<option value="1" <c:if test="${status==1}">selected</c:if> >已办事宜</option>
<option value="2" <c:if test="${status==2}">selected</c:if> >办结事宜</option>
<option value="3" <c:if test="${status==3}">selected</c:if> >我的请求(未完成)</option>
<option value="4" <c:if test="${status==4}">selected</c:if> >我的请求(已完成)</option>
<option value="5" <c:if test="${status==5}">selected</c:if> >流程反馈</option>
</select>
</td></tr>
<tr><td class="FieldName">工作流:</td><td class="FieldName">
<button type="button" class="Browser" onclick="Portlet.getBrowser('/base/refobj/baseobjbrowser.jsp?id=40288032239dd0ca0123a2273d270006&idsin=<c:out value="${workflowids}"/>','workflowids','workflowidsspan','0');"></button>
<input type="hidden" name="workflowids" id="workflowids" value='<c:out value="${workflowids}"/>'/><span id="workflowidsspan"><c:out value="${workflowidsName}"/></span>
</td></tr>
<tr><td class="FieldName">标题长度:</td><td class="FieldName"><input maxlength="19" onkeyup="value=value.replace(/[^\d]/ig,'')" name="titleLength" id="titleLenght" value='<c:out value="${titleLength}"/>' /></td></tr>
<tr><td class="FieldName">行数:</td><td class="FieldName"><input maxlength="10" onkeyup="value=value.replace(/[^\d]/ig,'')" class="inputstyle2" onkeypress="checkInt_KeyPress()" name="nCount" id="nCount" length="2" size="5" value="<c:out value="${nCount}"/>"/></td></tr>
<tr><td class="FieldName">是否显示时间:</td><td class="FieldName"><input class="inputstyle2" type="checkbox"  name="isViewTime" id="isViewTime" value="1" <c:if test="${isViewTime}">checked</c:if> /></td></tr>
<tr><td class="FieldName">刷新间隔:</td>
<td class="FieldName">
<input class="inputstyle2" onblur="this.value=(parseInt(this.value)>0 && parseInt(this.value)<=5?5:this.value);" onkeypress="checkInt_KeyPress()" name="periodTime" id="periodTime" length="2" size="5" value="<c:out value="${periodTime}"/>"/>分(0为不刷新,最小5分钟)
</td></tr>

<tr><td class="FieldName" align="right">字段&nbsp;&nbsp;&nbsp;</td><td class="FieldName">&nbsp;&nbsp;&nbsp;列宽</td></tr>
<tr><td class="FieldName" align="right">
<ul style="width: 100px; text-align: left;">
<li><label for="ftitle"><input name="fieldName" id="ftitle" value="workflow" type="checkbox" checked="checked" <c:out value="${fieldsName['workflow']}"/> />标题</label></li>
<li><label for="fnodename"><input name="fieldName" id="fnodename" value="currentNode" type="checkbox" <c:out value="${fieldsName['currentNode']}"/>/>节点名称</label></li>
<li><label for="fcreater"><input name="fieldName" id="fcreater" value="creater" type="checkbox" <c:out value="${fieldsName['creater']}"/>/>流程创建者</label></li>
<li><label for="fcreatedate"><input name="fieldName" id="fcreatedate" value="createDatetime" type="checkbox" <c:out value="${fieldsName['createDatetime']}"/>/>流程创建日期</label></li>
<li><label for="lastCreater"><input name="fieldName" id="lastCreater" value="lastCreater" type="checkbox" <c:out value="${fieldsName['lastCreater']}"/>/>最后操作人</label></li>
<li><label for="lastDate"><input name="fieldName" id="lastDate" value="lastCreateDate" type="checkbox" <c:out value="${fieldsName['lastCreateDate']}"/>/>最后操作日期</label></li>
</ul>
</td><td class="FieldName">
<ul><li><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="workflowwidth" value="<c:out value="${fieldsWidth['workflowwidth']}"/>" size="5"/>%</li>
<li><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="currentNodewidth" value="<c:out value="${fieldsWidth['currentNodewidth']}"/>" size="5"/>%</li>
<li><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="createrwidth" value="<c:out value="${fieldsWidth['createrwidth']}"/>" size="5"/>%</li>
<li><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="createDatetimewidth" value="<c:out value="${fieldsWidth['createDatetimewidth']}"/>" size="5"/>%</li>
<li><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="lastCreaterwidth" value="<c:out value="${fieldsWidth['lastCreaterwidth']}"/>" size="5"/>%</li>
<li><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="lastCreateDatewidth" value="<c:out value="${fieldsWidth['lastCreateDatewidth']}"/>" size="5"/>%</li>
</ul>
<!-- 
<select size="5" name="fieldsWidth" ondblclick="TodoWorkflowPortlet.changeWidth(this);" id="fieldsWidth">
<c:forEach var="w" items="${fieldsWidth}">
<option value='<c:out value="${w}"/>'><c:out value="${w}"/></option>
</c:forEach>
</select>
-->
</td></tr>
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="TodoWorkflowPortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/></td></tr>
</table>
</form>
</c:when>
<c:otherwise>

<c:if test="${state=='maximized'}">
<iframe width="100%" height="100%" src='<c:out value="${url}"/>' border="0" frameborder="0"></iframe>
</c:if>

<c:if test="${state!='maximized'}">
<table border="0" align="center" class="Econtent" style="width:98%" cellspacing="1">
<c:forEach var="m" items="${list1}" varStatus="status">
<tr>

<c:if test="${not empty fieldsWidth['workflow']}"><td width="<c:out value="${fieldsWidth['workflow']}"/>%"><c:out value="${m['workflow']}" escapeXml="false"/></td></c:if>
<c:if test="${not empty fieldsWidth['currentNode']}"><td width="<c:out value="${fieldsWidth['currentNode']}"/>%"><c:out value="${m['currentNode']}" escapeXml="false"/></td></c:if>
<c:if test="${not empty fieldsWidth['creater']}"><td width="<c:out value="${fieldsWidth['creater']}"/>%"><c:out value="${m['creater']}" escapeXml="false"/></td></c:if>
<c:if test="${not empty fieldsWidth['createDatetime']}"><td width="<c:out value="${fieldsWidth['createDatetime']}"/>%"><c:out value="${m['createDatetime']}" escapeXml="false"/></td></c:if>
<c:if test="${not empty fieldsWidth['lastCreater']}"><td width="<c:out value="${fieldsWidth['lastCreater']}"/>%"><c:out value="${m['lastCreater']}" escapeXml="false"/></td></c:if>
<c:if test="${not empty fieldsWidth['lastCreateDate']}"><td width="<c:out value="${fieldsWidth['lastCreateDate']}"/>%"><c:out value="${m['lastCreateDate']}" escapeXml="false"/></td></c:if>
</tr>
<c:if test="${!status.last}"><tr height="1"><td class="line" colspan='5'></td></tr></c:if>
</c:forEach>
<c:if test="${totalSize>0}">
<tr><td colspan="5" align="right" style="padding-right:20px;"><a href="javascript:onUrl('<c:out value="${url}"/>','<c:out value="${title}"/>','moreTodoWorkflow_<c:out value="${status}"/>')"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015")%><!-- 更多 --><span title="未读/总数">(<c:out value="${unreadSize}"/>/<c:out value="${totalSize}"/>)</span>..</a></td></tr>
</c:if>
</table>
<c:if test="${empty list1}">&nbsp;<%=labelService.getLabelNameByKeyId("4028836a36619c46013661b798830062")%></c:if>
</c:if>

</c:otherwise>
</c:choose>