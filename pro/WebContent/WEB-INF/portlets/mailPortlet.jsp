<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ include file="/common/taglibs.jsp"%>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
%>
<c:choose>
<c:when test="${mode=='edit'}">
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<c:if test="${not empty opt.id}">
<input type="hidden" name="id" value='<c:out value="${opt.id}"/>'/>
</c:if>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
<colgroup>
<col width="200"/>
</colgroup>
<tr><td class="FieldName">portletId:</td><td class="FieldName"><%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName">
<input name="title" id="title" value='<c:out value="${title}"/>' />
<c:if test="${not empty col1}">
	<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
</c:if>
</td></tr>
<tr><td class="FieldName">邮件帐户:</td><td class="FieldName">
<select name="mailAccount">
<c:forEach var="m" items="${accounts}"><option <c:if test="${opt.mailAccount==m.key}">selected</c:if> value='<c:out value="${m.key}"/>'><c:out value="${m.value}"/></option></c:forEach>
</select>
<c:if test="${not empty accounts}"><a href="javascript:;" onclick="onUrl('<%=request.getContextPath()%>/email/emailsettinglist.jsp','设置邮件帐户','setupMailAccount');">设置邮件帐户</a></c:if>
<c:if test="${empty accounts}"><a href="javascript:;" onclick="onUrl('<%=request.getContextPath()%>/email/emailsetting.jsp','添加邮件帐户','addMailAccount');">添加邮件帐户</a></c:if>
</td></tr>
<tr><td class="FieldName">提醒客户端:</td><td class="FieldName">
<label for="outlook"><input type="radio" id="outlook" name="mailClient" value="outlook" <c:if test="${opt.mailClient=='outlook'}">checked</c:if> />Outlook</label>&nbsp;&nbsp;
<label for="foxmail"><input type="radio" id="foxmail" name="mailClient" value="foxmail" <c:if test="${opt.mailClient=='foxmail'}">checked</c:if> />Foxmail</label>
</td></tr>
<tr><td class="FieldName">刷新周期:</td><td class="FieldName"><input size="5" name="refreshTime" value='<c:out value="${opt.refreshTime}"/>'/>(分)</td></tr>
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="MailPortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();document.mode='view';"/></td></tr>
</table>
</form>
</c:when>
<c:otherwise>
<div>
<ol id="mailList">
<li>当前邮件帐户列表为空!</li>
<!-- 
<c:if test="${not empty mailList}">
<c:forEach var="l" items="${mailList}">
<li><a href="javascript:;" onclick="MailPortlet.openClient();"><c:out value="${l}"/></a></li>
</c:forEach>
</c:if>
 -->
</ol>
<script>
try{
MailPortlet.refreshMail('<c:out value="${requestScope.responseId}"/>','<c:out value="${opt.id}"/>',<c:out value="${opt.refreshTime}"/>,'<c:out value="${opt.mailClient}"/>');
MailPortlet.getEmail();
}catch(e){alert("Error:"+e.description);}
</script>
</div>
</c:otherwise>
</c:choose>