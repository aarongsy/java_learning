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
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
<col width="100" />
<col width="*"/>
<tr><td class="FieldName">Id:</td><td class="FieldName">rss_<%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName">
<input class="inputstyle2" type="text" id="reportLabel" name="label" style="width:80%" value='<c:out value="${label}"/>'/>
<c:if test="${not empty col1}">
	<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
</c:if>
</td></tr>
<tr><td class="FieldName">数量:</td><td class="FieldName"><input class="inputstyle2"  name="nCount" value='<c:out value="${nCount}"/>'/></td></tr>
<tr><td class="FieldName">文档标题长度:</td><td class="FieldName"><input class="inputstyle2" name="titleLength" value='<c:out value="${titleLength}"/>'/></td></tr>
<tr><td class="FieldName">搜索条件:</td><td class="FieldName">
<input class="inputstyle2" type="text" id="url" name="url" style="width:80%" value='<c:out value="${url}"/>'/>
<br>
<input type="radio" name="showReply" id="showReply"  value="0" <c:if test="${showReply==0}">checked</c:if>>搜索标题 <input type="radio" name="showReply" id="showReply"  value="1" <c:if test="${showReply==1}">checked</c:if>>搜索内容</label>
</td></tr>
<tr style="display:none"><td class="FieldName">显示设置</td>
<td class="FieldName">
<!--<label for="isCreateDate"><input type="checkbox" id="isCreateDate" name="isCreateDate" value="1" <c:if test="${isCreateDate==1}">checked</c:if> />日期</label><br>
<label for="isModifyDate"><input type="checkbox" id="isModifyDate" name="isModifyDate" value="1" <c:if test="${isModifyDate==1}">checked</c:if> />时间</label>-->
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="RssReadPortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/></td></tr>
</table>
</form>
</c:when>
<c:when test="${mode=='view'&&state!='maximized'}">


<iframe  cellspacing="0" cellpadding="0" border="0" name="cwin" id="cwin"  scrolling="yes"  width="100%" height="100%" src='/app/base/rssPortletReadView.jsp?isCreateDate=<c:out value="${isCreateDate}"/>&isModifyDate=<c:out value="${isModifyDate}"/>&showReply=<c:out value="${showReply}"/>&titleLength=<c:out value="${titleLength}"/>&nCount=<c:out value="${nCount}"/>&url=<c:out value="${url}"/>' border="0" frameborder="0"></iframe>
</c:when>
<c:when test="${mode=='view'&&state=='maximized'}">

<iframe  cellspacing="0" cellpadding="0" border="0" name="cwin"  width="100%" height="100%" src='/app/base/rssPortletReadView.jsp?isCreateDate=<c:out value="${isCreateDate}"/>&isModifyDate=<c:out value="${isModifyDate}"/>&showReply=<c:out value="${showReply}"/>&titleLength=<c:out value="${titleLength}"/>&nCount=50&url=<c:out value="${url}"/>' border="0" frameborder="0"></iframe>
</c:when>
</c:choose>
<script type="text/javascript" language="javascript">   
	function iFrameHeight() {   
		var ifm= document.getElementById("cwin");   
		var subWeb = document.frames ? document.frames["iframepage"].document : ifm.contentDocument;   
		if(ifm != null && subWeb != null) {
		   ifm.height = subWeb.body.scrollHeight;
		}   
	} 
</script>

