<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Comparator"%>
<%!
private boolean isHavaMenuPermission(List<Menu> allUserMenu, String menuId){
	boolean flag = false;
	for(Menu userMenu : allUserMenu){
		if(userMenu.getId().equals(menuId)){
			if(userMenu.getPid() == null){	//如果拥有子菜单的权限，那么它一定会拥有其上所有父节点的权限(直到根节点)
				flag = true;
			}else{
				flag = isHavaMenuPermission(allUserMenu, userMenu.getPid());
			}
		}
	}
	return flag;
}
%>
<%
String portletId = StringHelper.null2String(request.getAttribute("portletId"));
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
String label = StringHelper.null2String(request.getAttribute("label"));
//String linkOpenMode = StringHelper.null2String(request.getAttribute("linkOpenMode"));
String height = StringHelper.null2String(request.getAttribute("height"));
JSONArray shortcutDatas = (JSONArray)request.getAttribute("shortcutDatas");

MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService");
List<Menu> allUserMenu = menuorgService.getAllUserMenu(false);
%>
<c:choose>
<c:when test="${mode=='edit'}">

<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
	<col width="150" />
	<col width="*"/>
	<tr><td class="FieldName">Id:</td><td class="FieldName">shortcut_<%=portletId%></td></tr>
	<tr>
		<td class="FieldName">标题:</td>
		<td class="FieldName">
			<input class="inputstyle2" type="text" id="reportLabel" name="label" value="<%=StringHelper.StringReplace(label,"\"","&quot;")%>" onblur="checkInputByteLenth('reportLabel',0,200)"/>
			<c:if test="${not empty col1}">
				<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
			</c:if>
		</td>
	</tr>
	<!-- <tr>
		<td class="FieldName">链接页面打开方式:</td>
		<td class="FieldName">
			<input type="radio" name="linkOpenMode" value="0"/>当前页
			<input type="radio" name="linkOpenMode" value="1"/>弹出窗口
			<input type="radio" name="linkOpenMode" value="2"/>tab页
		</td>
	</tr>
	 -->
	<tr>
		<td class="FieldName">高度:</td>
		<td class="FieldName">
			<input class="inputstyle2" type="text" name="height" value="<%=height%>" onkeyup="value=value.replace(/[^\d]/ig,'')"/>px
		</td>
	</tr>
	<tr>
		<td colspan="2" class="FieldName">
			<table style="line-height: 20px;">
				<tr style="background-color:#DFDFDF;">
					<td>已选择</td>
					<td align="right"><a href="javascript:openShortcutChoose('<%=portletId%>','<c:out value="${requestScope.responseId}"/>');">配置</a></td>
				</tr>
				<% 
					//排序
					Collections.sort(shortcutDatas, new Comparator<JSONObject>() {
						public int compare(JSONObject o1, JSONObject o2) {
							int shortcutDsporder1 = NumberHelper.getIntegerValue(o1.get("shortcutDsporder"), 0);
							int shortcutDsporder2 = NumberHelper.getIntegerValue(o2.get("shortcutDsporder"), 0);
							return shortcutDsporder1 - shortcutDsporder2;
						}
					});
				
					for(int i = 0; i < shortcutDatas.size(); i++){ 
						JSONObject shortcutData = (JSONObject)shortcutDatas.get(i);
						String shortcutId = StringHelper.null2String(shortcutData.get("shortcutId"));
						String shortcutImgPath = StringHelper.null2String(shortcutData.get("shortcutImgPath"));
						String shortcutName = StringHelper.null2String(shortcutData.get("shortcutName"));
						String shortcutUrl = StringHelper.null2String(shortcutData.get("shortcutUrl"));
						String shortcutOpenMode = StringHelper.null2String(shortcutData.get("shortcutOpenMode"));
						if(StringHelper.isEmpty(shortcutOpenMode)){
							shortcutOpenMode = "2";
						}
						int shortcutDsporder = NumberHelper.getIntegerValue(shortcutData.get("shortcutDsporder"), 0);
						
						String userid = StringHelper.null2String(shortcutData.get("userid"));
						if(!StringHelper.isEmpty(userid)){	//不显示非公共的快捷方式
							continue;
						}
						
						//权限过滤
						if(!shortcutId.startsWith("custom_") && !isHavaMenuPermission(allUserMenu, shortcutId)){
							continue;
						}
				%>
						<tr id="shortcut_tr_<%=portletId%>_<%=shortcutId%>">
							<td>
								<img src="<%=shortcutImgPath%>" align="middle" style="width:14px;height:14px;"/></span>
		  						<span style="margin-left: 3px;display:inline-block;word-break:break-all;"><%=shortcutName%></span>
		  						<input type="hidden" name="shortcutId" value="<%=shortcutId%>"/>
		  						<input type="hidden" name="shortcutName" value="<%=shortcutName%>"/>
		  						<input type="hidden" name="shortcutImgPath" value="<%=shortcutImgPath%>"/>
		  						<input type="hidden" name="shortcutOpenMode" value="<%=shortcutOpenMode%>"/>
		  						<input type="hidden" name="shortcutUrl" value="<%=shortcutUrl%>"/>
		  						<input type="hidden" name="shortcutDsporder" value="<%=shortcutDsporder%>"/>
		  					</td>
		  					<td align="right">
		  						<span><img src="/images/iconDelete.gif" align="middle" style="cursor: pointer;" onclick="$('#shortcut_tr_<%=portletId%>_<%=shortcutId%>').remove();Light.portal.tabs[Light.getPortletById('<c:out value="${requestScope.responseId}"/>').tIndex].rePositionPortlets(Light.getPortletById('<c:out value="${requestScope.responseId}"/>'));"/></span>
		  					</td>
						</tr>
				<%	} %>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="button" name="btnOk" value="确定" onclick="ShortcutPortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
			<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/>
		</td>
	</tr>
</table>
</form>
</c:when>
<c:otherwise>
<%
String currentUserId = BaseContext.getRemoteUser().getHumres().getId();
//删除掉其他用户的快捷方式，只显示公共的和自己的
for(int i = (shortcutDatas.size() - 1); i >= 0; i--){
	JSONObject shortcutData = (JSONObject)shortcutDatas.get(i);
	String userid = StringHelper.null2String(shortcutData.get("userid"));
	if(!StringHelper.isEmpty(userid) && !userid.equals(currentUserId)){
		shortcutDatas.remove(shortcutData);
	}
}
//删除重复的快捷方式
for(int i = (shortcutDatas.size() - 1); i >= 0; i--){
	JSONObject shortcutData = (JSONObject)shortcutDatas.get(i);
	String shortcutId = StringHelper.null2String(shortcutData.get("shortcutId"));
	for(int j = i - 1; j >= 0; j--){
		JSONObject shortcutData2 = (JSONObject)shortcutDatas.get(j);
		String shortcutId2 = StringHelper.null2String(shortcutData2.get("shortcutId"));
		if(shortcutId.equals(shortcutId2)){
			shortcutDatas.remove(shortcutData);
			break;
		}
	}
}
//添加权限过滤
for(int i = (shortcutDatas.size() - 1); i >= 0; i--){
	JSONObject shortcutData = (JSONObject)shortcutDatas.get(i);
	String shortcutId = StringHelper.null2String(shortcutData.get("shortcutId"));
	if(shortcutId.startsWith("custom_")){	//手动输入的快捷方式
		continue;
	}
	if(!isHavaMenuPermission(allUserMenu, shortcutId)){
		shortcutDatas.remove(shortcutData);
	}
}
//排序
Collections.sort(shortcutDatas, new Comparator<JSONObject>() {

	public int compare(JSONObject o1, JSONObject o2) {
		String userid1 = StringHelper.null2String(o1.get("userid"));
		String userid2 = StringHelper.null2String(o2.get("userid"));
		int shortcutDsporder1 = NumberHelper.getIntegerValue(o1.get("shortcutDsporder"), 0);
		int shortcutDsporder2 = NumberHelper.getIntegerValue(o2.get("shortcutDsporder"), 0);
		if(StringHelper.isEmpty(userid1) && StringHelper.isEmpty(userid2)){	//都是公共的快捷方式
			return shortcutDsporder1 - shortcutDsporder2;
		}else if(!StringHelper.isEmpty(userid1) && !StringHelper.isEmpty(userid2)){	//都是私有的快捷方式
			return shortcutDsporder1 - shortcutDsporder2;
		}else{	//保证在有序的情况下使公共的快捷方式排在前面
			if(StringHelper.isEmpty(userid1)){	
				return -1;
			}else{
				return 1;
			}
		}
		
	}
});

//多语言
for(int i = 0; i < shortcutDatas.size(); i++){
	JSONObject shortcutData = (JSONObject)shortcutDatas.get(i);
	String shortcutName = labelCustomService.getLabelNameByShortcutForCurrentLanguage(shortcutData);
	shortcutData.put("shortcutName", shortcutName);
}
%>
<script type="text/javascript">

var shortcutInitialWidth;
var shortcutInitialHeight;
$(document).ready(function(){ 
	shortcutInitialWidth = $('#shortcutDataDiv_<%=portletId%> ul li').outerWidth(true);
	shortcutInitialHeight = $('#shortcutDataDiv_<%=portletId%> ul li').outerHeight(true);

	var shortcutDatas = getShortcutDatas();

	if(shortcutDatas.length != 0){
		doShortcutCycle();

		$('#shortcutDataDiv_<%=portletId%>').bind("resize", doShortcutCycle);
	}

});
//获取快速入口元素数据集
function getShortcutDatas(){
	var datas = '<%=shortcutDatas.toString().replaceAll("\\'", "\\\\'")%>';
	var shortcutDatas;
	try{
		shortcutDatas = eval("(" + datas + ")");
	}catch(e){
		alert("快速入口元素[<%=portletId%>]的数据未能被成功解析");
		shortcutDatas = [];
	}
	return shortcutDatas;
}
//计算一页可以放多少数据
function calculateShortcutPageDataCount(){
	var shortcutDataDivWidth = $('#shortcutDataDiv_<%=portletId%>').width();
	var shortcutDataDivHeight = $('#shortcutDataDiv_<%=portletId%>').height();
	var rowCount = parseInt(shortcutDataDivHeight / shortcutInitialHeight);	//可以放几行
	var columnCount = parseInt(shortcutDataDivWidth / shortcutInitialWidth);	//每行可以放几个
	var pageDataCount = rowCount * columnCount;	//一页可以放几个
	return pageDataCount;
}
//计算一页可以放多少页
function calculateShortcutPageCount(){
	var shortcutDatas = getShortcutDatas();
	var pageDataCount = calculateShortcutPageDataCount();
	var pagecount;
	if(shortcutDatas.length % pageDataCount == 0){
		pagecount = parseInt(shortcutDatas.length / pageDataCount);
	}else{
		pagecount = parseInt(shortcutDatas.length / pageDataCount) + 1;
	}
	return pagecount;
}
//填充html
function fillHtmlInShortcutDataDiv(){
	var shortcutDatas = getShortcutDatas();
	var pageDataCount = calculateShortcutPageDataCount();
	var h = "";
	for(var i = 0; i < shortcutDatas.length; i++){
		var shortcutData = shortcutDatas[i];
		var shortcutId = shortcutData["shortcutId"];
		var shortcutImgPath = shortcutData["shortcutImgPath"];
		var shortcutName = shortcutData["shortcutName"];
		var shortcutUrl = shortcutData["shortcutUrl"];
		var shortcutOpenMode = shortcutData["shortcutOpenMode"];
		if(typeof(shortcutOpenMode)=='undefined'||shortcutOpenMode==""){
			shortcutOpenMode="2";
		}
		if(i == 0){
			h += "<ul>";
		}else if(i % pageDataCount == 0){
			h += "</ul><ul>";
		}
		//确定打开链接的方式
		var href = "";
		var target = "";
		if(shortcutOpenMode == "0"){	//当前页面打开
			href = shortcutUrl;
		}else if(shortcutOpenMode == "1"){	//新窗口打开
			href = shortcutUrl;
			target = "_blank";
		}else{	//tab页打开
			href = "javascript:onUrl('"+shortcutUrl+"','"+shortcutName.ReplaceAll("'", "\\'")+"','tab"+shortcutId+"')";
		}
		h += "<li>";
		h += "<span class=\"pic\"><a href=\""+href+"\" target=\""+target+"\"><img src=\""+shortcutImgPath+"\"/></a></span>";
		h += "<span class=\"text\" style=\"overflow:hidden;\">"+shortcutName+"</span>";
		h += "</li>";
		if(i == (shortcutDatas.length - 1)){
			h += "</ul>";
		}
	}
	$('#shortcutDataDiv_<%=portletId%>').html(h);

	//绑定鼠标经过时的事件,因门户页面未使用标准解析方式,所以span不支持hover伪类
	$('#shortcutDataDiv_<%=portletId%> ul li span.pic').bind('mouseover', function(){
		$(this).addClass("onover");
	});
	$('#shortcutDataDiv_<%=portletId%> ul li span.pic').bind('mouseout', function(){
		$(this).removeClass("onover");
	});
}
//更新页面翻页数字索引
function updateShortcutPageNoInfo(){
	var pagecount = calculateShortcutPageCount();
	$('#shortcutHandlerPageCount_<%=portletId%>').html(pagecount);
	$('#shortcutHandlerCurrentPage_<%=portletId%>').html(1);
}
//轮显
function doShortcutCycle(){
	var shortcutDataDivHeight = $('#shortcutDataDiv_<%=portletId%>').height();
	if(shortcutDataDivHeight < shortcutInitialHeight){
		alert("元素高度不够至少一行数据的显示,请修改高度或者样式");
		$('#shortcutDataDiv_<%=portletId%>').html("");
		return;
	}
	fillHtmlInShortcutDataDiv();
	updateShortcutPageNoInfo();
	$('#shortcutDataDiv_<%=portletId%>').cycle({
		fx:      'scrollRight',	
		prev:    '#shortcutHandlerPrev_<%=portletId%>',
		next:    '#shortcutHandlerNext_<%=portletId%>',
		speed: 200,	//幻灯片过渡的速度
		timeout: 0,	//不自动切换 
		slideExpr: 'ul',
		cleartype:  true,
		onPrevNextEvent: doPreNext
	});
	function doPreNext(isNext, zeroBasedSlideIndex, slideElement){
		$('#shortcutHandlerCurrentPage_<%=portletId%>').html(zeroBasedSlideIndex + 1);
	};
	$('#shortcutDataDiv_<%=portletId%>').cycle("pause");
}
</script>
<div id="shortcut">
	<div class="data" id="shortcutDataDiv_<%=portletId%>" style="height: <%=height%>px; overflow: hidden;">
		<ul style="visibility:hidden;"><!-- 占位的ul,便于通过js计算要生成的内容的高宽,没有内容js是获取不到高度和宽度的 -->
			<li>
				<span class="pic"><a><img src="/images/excel.gif"/></a></span>
				<span class="text">占位ul</span>
			</li>
		</ul>
	</div>
	<div class="handler">
		<div class="prev" id="shortcutHandlerPrev_<%=portletId%>"></div>
		<div class="pageInfo" id="shortcutHandlerPageInfo_<%=portletId%>"><span class="currentpage" id="shortcutHandlerCurrentPage_<%=portletId%>"></span>of<span class="pagecount" id="shortcutHandlerPageCount_<%=portletId%>"></span></div>
		<div class="next" id="shortcutHandlerNext_<%=portletId%>"></div>
		<div class="setting" id="shortcutHandlerSetting_<%=portletId%>" onclick="javascript:openShortcutChoose('<%=portletId%>','<c:out value="${requestScope.responseId}"/>');"></div>
	</div>
</div>
</c:otherwise>
</c:choose>