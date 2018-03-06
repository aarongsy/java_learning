<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ include file="/common/taglibs.jsp"%>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
%>
<script type="text/javascript">
$(function(){
	$('#imgSqlWhere').qtip({
		content: 'e.g., and creator=\'$currentuser$\'...',
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
				color: '#666666',
				font:'Microsoft YaHei',
				background:'#ffffa3'
			}
	});
	$('#imgSqlOrder').qtip({
		content: 'e.g., order by createdate desc, createtime desc...',
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
				color: '#666666',
				font:'Microsoft YaHei',
				background:'#ffffa3'
			}
	});
	$('#imgTitleColors').qtip({
		content: '如果您需要设置隔行变色的效果,可设置多种颜色,多种颜色之间用逗号分隔,如：#000,#fff,red等。如未设置任何颜色,则系统默认使用黑色。',
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
				color: '#666666',
				font:'Microsoft YaHei',
				background:'#ffffa3'
			}
	});
});
</script>
<c:choose>
<c:when test="${mode=='edit'}">
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<table class="viewform" border="0" align="center" style="width:100%" cellspacing="1">
<col width="100" />
<col width="*"/>
<tr><td class="FieldName">Id:</td><td class="FieldName">document_<%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName">
<input maxlength="100" class="inputstyle2" type="text" id="reportLabel" name="label" value="<c:out value="${label}"/>"/>
<c:if test="${not empty col1}">
	<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
</c:if>
</td></tr>
<tr><td class="FieldName">目录:</td><td class="FieldName"><button type="button" class="Browser" onclick="Portlet.getBrowser('/base/refobj/baseobjbrowser.jsp?id=402880732813ed8701281545e8760113&selected=<c:out value="${categoryId}"/>&hiddenFlag=false','categoryId','categoryidspan','0','categoryId');"></button>
<input type="hidden" name="categoryId" id="categoryId" value='<c:out value="${categoryId}"/>'/><span id="categoryidspan"><c:out value="${categoryName}"/></span></td></tr>

<tr>
<td class="FieldName" style="">SQL条件:</td>
<td class="FieldName">
	<textarea name="sqlWhere" style="width:90%;float:left;"><c:out value="${sqlWhere}"/></textarea>
	<img id="imgSqlWhere" src="/images/lightbulb.png" style="" />
</td>
</tr>

<tr>
<td class="FieldName" style="">排序:</td>
<td class="FieldName">
	<textarea name="sqlOrder" style="width:90%;float:left;"><c:out value="${sqlOrder}"/></textarea>
	<img id="imgSqlOrder" src="/images/lightbulb.png" style="" />
</td>
</tr>

<tr><td class="FieldName">数量:</td><td class="FieldName"><input maxlength="10" onkeyup="value=value.replace(/[^\d]/ig,'')" class="inputstyle2"  name="nCount" value='<c:out value="${nCount}"/>'/></td></tr>
<tr><td class="FieldName">文档标题长度:</td><td class="FieldName"><input maxlength="10" onkeyup="value=value.replace(/[^\d]/ig,'')" class="inputstyle2" name="titleLength" value='<c:out value="${titleLength}"/>'/></td></tr>
<tr><td class="FieldName">文档标题颜色:</td><td class="FieldName"><input class="inputstyle2" name="titleColors" value='<c:out value="${titleColors}"/>'/><img id="imgTitleColors" src="/images/lightbulb.png"/></td></tr>
<tr><td class="FieldName">是否显示回复:</td><td class="FieldName"><input class="inputstyle2" name="showReply" type="checkbox" value='1' <c:if test="${showReply==1}">checked</c:if> /></td></tr>
<tr><td class="FieldName">仅显示未读:</td><td class="FieldName"><input class="inputstyle2" name="isnew" type="checkbox" value='1' <c:if test="${isnew==1}">checked</c:if> /></td></tr>
<tr><td class="FieldName">标题对齐方式:</td><td class="FieldName"><select name="titleAlign">
<option value="left" <c:if test="${titleAlign=='left'}">selected="selected"</c:if> >左对齐</option>
<option value="center" <c:if test="${titleAlign=='center'}">selected="selected"</c:if> >居中对齐</option>
<option value="right" <c:if test="${titleAlign=='right'}">selected="selected"</c:if> >右对齐</option>
</select></td></tr>
<tr id="abstractLengthSpan" <c:if test="${viewType=='1'}">style="display:none;"</c:if> ><td class="FieldName">摘要长度:</td><td class="FieldName"><input maxlength="10" onkeyup="value=value.replace(/[^\d]/ig,'')" class="inputstyle2" name="abstractLength" value='<c:out value="${abstractLength}"/>'/></td></tr>
<tr id="imgWidthSpan" <c:if test="${viewType=='1'}">style="display:none;"</c:if> ><td class="FieldName">图片宽度</td><td class="FieldName"><input maxlength="10" onkeyup="value=value.replace(/[^\d]/ig,'')" class="inputstyle2" name="imgWidth" value='<c:out value="${imgWidth}"/>'/></td></tr>
<tr id="isAbstract" <c:if test="${viewType=='1'}">style="display:none;"</c:if> ><td class="FieldName">是否摘要</td><td class="FieldName"><input class="inputstyle2" type="checkbox" name="isAbstract" value='1' <c:if test="${isAbstract=='1'}">checked='checked'</c:if> /></td></tr>
<tr><td class="FieldName">显示方式:</td><td class="FieldName">
<select name="viewType" id="viewType" onchange="DocbasePortlet.changeViewType(this);">
<option value="1" <c:if test="${viewType=='1'}">selected="selected"</c:if> >列表</option>
<option value="2" <c:if test="${viewType=='2'}">selected="selected"</c:if> >左图式</option>
<option value="4" <c:if test="${viewType=='4'}">selected="selected"</c:if> >合图式</option>
</select>
&nbsp;&nbsp;&nbsp;<span id="grabpicspan" <c:if test="${viewType!='4'}">style="display:none;"</c:if> >是否抓取图片:&nbsp;<input type="checkbox" name="GraBpic" id="GraBpic" value="1" <c:if test="${GraBpic=='1'}">checked='checked'</c:if> /></span></td></tr>
<tr><td class="FieldName">显示列:</td><td class="FieldName">
<label for="isAuthor"><input type="checkbox" id="isAuthor" name="isAuthor" value="1" <c:if test="${isAuthor==1}">checked</c:if> />创建者</label><input class="inputstyle2" name="creatorWidth" value="<c:out value="${creatorWidth}"/>"/><br/>
<label for="isCreateDate"><input type="checkbox" id="isCreateDate" name="isCreateDate" value="1" <c:if test="${isCreateDate==1}">checked</c:if> />创建日期</label><input class="inputstyle2" name="createDateWidth" value="<c:out value="${createDateWidth}"/>"/><br/>
<label for="isModifyDate"><input type="checkbox" id="isModifyDate" name="isModifyDate" value="1" <c:if test="${isModifyDate==1}">checked</c:if> />修改日期</label><input class="inputstyle2" name="modifyDateWidth" value="<c:out value="${modifyDateWidth}"/>"/>
</td></tr>
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="DocbasePortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/></td></tr>
</table>


</form>
</c:when>
<c:otherwise>
<c:if test="${state=='maximized'}">
<iframe width="100%" height="100%" src='<c:out value="${url}"/>' border="0" frameborder="0"></iframe>
</c:if>
<c:if test="${state!='maximized'}">
<c:if test="${viewType==1}">
	<table border="0" align="center" class="Econtent" style="width:100%" cellspacing="1">
		<!-- <col width="20" />
		<col width="70%"/>
		<col width="12%"/>
		<col width="18%"/>
		 -->
		<c:forEach var="m" items="${list1}" varStatus="status">
		<tr class="row"><td align="center" width="20" class="itemIcon">&nbsp;&nbsp;</td>
			<c:forEach var="f" items="${fields}" varStatus="fStatus">
				<c:if test="${f!='id'}">
					<td align="<c:out value="${titleAlign}"/>" width="<c:out value="${fieldWidth[f]}"/>" class="<c:out value="${f}"/>">
						<c:out value="${m[f]}" escapeXml="false"/>
					</td>
				</c:if>
			</c:forEach>
		</tr>
		<c:if test="${!status.last}"><tr height="1"><td class="line" colspan='<c:out value="${fieldsCount+1}"/>'></td></tr></c:if>
		</c:forEach>
	</table>
</c:if>

<!-- ##### -->
<c:if test="${viewType==2 || viewType==3}">
<table border="0" align="center" class="Econtent" style="width:100%" cellspacing="1">
<colgroup>
<col width="<c:out value="${imgWidth}"/>" />
<col width="*"/>
</colgroup>
<tr><td style="height:5px;"></td></tr>
<c:forEach var="m" items="${list1}" varStatus="status">
<tr><td>
<a href="javascript:onUrl('/document/base/docbaseview.jsp?id=<c:out value='${m.id}' />','<c:out value='${m.title}' />','tab<c:out value='${m.id}' />')">
<button type="button" disabled  style="width:<c:out value='${imgWidth}'/>;height:<c:out value='${imgHeight}'/>;background:transparent;border:none;padding:0;cursor:hand" hidefocus>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="<%=request.getContextPath()%>/plugin/swflash.cab#version=6,0,0,0" width='<c:out value="${imgWidth}"/>' height='<c:out value="${imgHeight}"/>' >
    <param name="allowScriptAccess" value="sameDomain"/>
    <param name="movie" value="<%=request.getContextPath()%>/images/base/playswf.swf"/>
    <param name="wmode" value="transparent"/>
    <param name="quality" value="high"/>
    <param name="menu" value="false"/>
    <param name="wmode" value="opaque"/>
    <param name="FlashVars" value='<c:out value="${m.flashImgs}" escapeXml="false"/>'/>
    <EMBED src="<%=request.getContextPath()%>/images/base/playswf.swf"
         FlashVars='<c:out value="${m.flashImgs}"/>'
         quality="high"
         width='<c:out value="${imgWidth}"/>'
		 height='<c:out value="${imgHeight}"/>'
         TYPE="application/x-shockwave-flash" 
         PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" /> 
</object>
</button>
</a>
</td>
<td valign="top" style="vertical-align:top;">
<table border="0"><tr>
<td><img src="<%=request.getContextPath()%>/light/images/esymbol.gif;" style="margin-left:4px;margin-right:4px;"/></td>
<c:forEach var="f" items="${fields}">
<td align="<c:out value="${titleAlign}"/>" width="<c:out value="${fieldWidth[f]}"/>%" class="<c:out value="${f}"/> viewType23Class">
	<c:out value="${m[f]}" escapeXml="false"/>
</td>
</c:forEach>
</tr>
<c:if test="${isAbstract==1}">
<tr><td colspan="<c:out value="${fieldsCount+1}"/>"><div class="docAbstract" style="border:0"><label style="color:gray"><c:out value="${m.abstract}" escapeXml="false"/></label></div></td></tr>
</c:if>
</table>
<!-- innerTable -->
</td>
</tr>
<c:if test="${!status.last}"><tr height="1" ><td style="height:1px" colspan="10"><hr class="split"/></td></tr></c:if>
</c:forEach>
</table>
</c:if>
<!-- ##合图式Start## -->
<c:if test="${viewType==4}">
<table border="0" align="center" width="100%" class="Econtent" cellspacing="1">
<tr>
<td width="<c:out value="${imgWidth}"/>"  style="vertical-align:top;padding-top:5px;">
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="<%=request.getContextPath()%>/plugin/swflash.cab#version=6,0,0,0" width='<c:out value="${imgWidth}"/>' height='<c:out value="${imgHeight}"/>' >
    <param name="allowScriptAccess" value="sameDomain"/>
    <param name="movie" value="<%=request.getContextPath()%>/images/base/playswf.swf"/>
    <param name="wmode" value="transparent"/>
    <param name="quality" value="high"/>
    <param name="menu" value="false"/>
    <param name="wmode" value="opaque"/>
    <param name="FlashVars" value='<c:out value="${flashImgs}" escapeXml="false"/>'/>
    <EMBED src="<%=request.getContextPath()%>/images/base/playswf.swf"
    	 allowScriptAccess="sameDomain" 
         FlashVars='<c:out value="${flashImgs}"/>'
         quality="high" menu="false" wmode="transparent" wmode="opaque"
         width='<c:out value="${imgWidth}"/>'
		 height='<c:out value="${imgHeight}"/>'
         TYPE="application/x-shockwave-flash" 
         PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" />
</object>
</td>
<td valign="top" style="vertical-align:top;">
<!-- Table.Start -->
<table width="100%" cellspacing="1">
<c:forEach var="m" items="${list1}" varStatus="status">
<tr><td class="itemIcon" width="20">&nbsp;</td>
<c:forEach var="f" items="${fields}">
<td class="<c:out value="${f}"/>" align="<c:out value="${titleAlign}"/>" width="<c:out value="${fieldWidth[f]}"/>%">
	<c:out value="${m[f]}" escapeXml="false"/>
</td>
</c:forEach>

</tr>
<c:if test="${isAbstract==1}">
<tr><td colspan="<c:out value="${fieldsCount+1}"/>"><div class="docAbstract" style="border:0"><label style="color:gray"><c:out value="${m.abstract}" escapeXml="false"/></label></div></td></tr>
</c:if>
<c:if test="${!status.last}"><tr height="1"><td class="line" colspan='<c:out value="${fieldsCount+1}"/>'></td></tr></c:if>
</c:forEach>
</table>
<!-- Table -->
</td>
</tr>
</table>
</c:if>
<!-- ##合图式End## -->
<c:if test="${empty list1}">&nbsp;<%=labelService.getLabelNameByKeyId("4028836a366236d30136623cf71b0067")%></c:if>
</c:if>
</c:otherwise>
</c:choose>
<c:if test="${docCount>0}">
<div align="right" style="height: 20px;"><a href="javascript:onUrl('<c:out value="${moreUrl}"/>','文档元素列表','DocbasePortletMore');"/>更多(<span title="未读/文档总数"><c:out value="${unread}"/>/<c:out value="${docCount}"/></span>)...</a>&nbsp;&nbsp;&nbsp;</div>
</c:if>