<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.portal.service.PortletStyleService"%>
<%@ page import="com.eweaver.portal.model.PortletStyle"%>
<%@ include file="/base/init.jsp"%>
<%
String saveFlag = StringHelper.null2String(request.getParameter("saveFlag"));
String id = StringHelper.null2String(request.getParameter("id"));
PortletStyleService portletStyleService = (PortletStyleService)BaseContext.getBean("portletStyleService");
PortletStyle portletStyle = portletStyleService.getPortletStyleById(id);
%>
<html>
<head>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/modcoder_excolor/jquery.modcoder.excolor.js"></script>
<script type="text/javascript" src="/portal/style/js/portletstylemodify.js"></script>
<link rel="stylesheet" type="text/css" href="/portal/style/css/portletstylemodify.css"/>
<link rel="stylesheet" href="/js/jquery/ui/themes/base/jquery.ui.all.css"/>
<script type="text/javascript" src="/js/jquery/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="/js/jquery/ui/tabs/jquery.ui.tabs.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
<link href="/css/portal.css" rel="stylesheet" type="text/css">
<% if(userMainPage.getIsUseSkin()){ //当前用户选择的首页是使用皮肤的%>
<link href="<%=currentSkin.getBasePath() %>/<%=SkinConstant.PORTAL_CSS_NAME %>" rel="stylesheet" type="text/css">
<% } %>
<script type="text/javascript" type="text/javascript">
	$(function(){
		doChecked('hasHeader','<%=portletStyle.getHasHeader()%>');
		doChecked('headerCornerStyle','<%=portletStyle.getHeaderCornerStyle()%>');
		doChecked('hasHeaderRefreshBtn','<%=portletStyle.getHasHeaderRefreshBtn()%>');
		doChecked('hasHeaderMinBtn','<%=portletStyle.getHasHeaderMinBtn()%>');
		doChecked('hasHeaderMaxBtn','<%=portletStyle.getHasHeaderMaxBtn()%>');
		
		doChecked('hasFooter','<%=portletStyle.getHasFooter()%>');
		doChecked('footerCornerStyle','<%=portletStyle.getFooterCornerStyle()%>');
		doChecked('hasFooterRefreshBtn','<%=portletStyle.getHasFooterRefreshBtn()%>');
		doChecked('hasFooterMinBtn','<%=portletStyle.getHasFooterMinBtn()%>');
		doChecked('hasFooterMaxBtn','<%=portletStyle.getHasFooterMaxBtn()%>');
		
		doSelected('windowTopBorderStyle','<%=portletStyle.getWindowTopBorderStyle()%>');
		doSelected('windowRightBorderStyle','<%=portletStyle.getWindowRightBorderStyle()%>');
		doSelected('windowBottomBorderStyle','<%=portletStyle.getWindowBottomBorderStyle()%>');
		doSelected('windowLeftBorderStyle','<%=portletStyle.getWindowLeftBorderStyle()%>');
		
		doSelected('headerBGImageRepeat','<%=portletStyle.getHeaderBGImageRepeat()%>');
		doSelected('footerBGImageRepeat','<%=portletStyle.getFooterBGImageRepeat()%>');
		
		doPreview();
		
		changeImmediatePreview(1);
	});
	
</script>
</head>
<body>
	<div id="pagemenubar"></div>
	<form action="/ServiceAction/com.eweaver.portal.servlet.PortletStyleAction?action=modifyPortletStyle" method="post" id="EweaverForm">
	<input type="hidden" name="id" value="<%=portletStyle.getId() %>"/>
	<input type="hidden" id="saveFlag" value="<%=saveFlag %>"/>
	<div id="styleDiv">
	<div id="leftDiv">
		<div id="baseinfoDiv">
			<fieldset>
				<legend><img src="/images/arrow_show.jpg" class="arrow" onclick="showOrHiddenInfo(this, 'baseInfo')"/><%=labelService.getLabelNameByKeyId("9985462e52d84ca3a5f427e8563889ae") %><!-- 样式基础信息 --></legend>
				<div id="baseInfo" style="display: block;">
					<table>
						<colgroup>
							<col width="70px"></col>
							<col width="*"></col>
						</colgroup>
						<tr>
							<td class="explain"><%=labelService.getLabelNameByKeyId("88a480c12fe047f2be87cf2b8d4fbe51") %><!-- 样式名称 -->：</td>
							<td class="content">
								<input type="text" id="objname" name="objname" class="textStyle" value="<%=portletStyle.getObjname() %>"/>
								<span id="objnameTipMessage"></span>
							</td>
						</tr>
						<tr>
							<td class="explain"><%=labelService.getLabelNameByKeyId("bfa91c45b75d4f1ebfb7728eb17d9c64") %><!-- 描述 -->：</td>
							<td class="content">
								<input type="text" id="description" name="description" class="textStyle" style="width: 50%" value="<%=StringHelper.null2String(portletStyle.getDescription()) %>"/>
							</td>
						</tr>
					</table>
				</div>
			</fieldset>
		</div>
		<div>
		<div id="previewDiv">
			<div id="previewHead">
				<span><%=labelService.getLabelNameByKeyId("e354021dde0d4364ba201cf3532b60d1") %><!-- 预览区 --></span>
				<img src="/images/refresh.png" onclick="doPreview();"/>
			</div>
			<div id="previewContent">
				
			</div>
			<span class="immediatePreview">
				<a href="javascript:void(0);" id="closeImmediatePreview" onclick="changeImmediatePreview(0);" style="display: none;"><%=labelService.getLabelNameByKeyId("7daa51455dcc48c882a70267658b2b5c") %><!-- 关闭即时预览 --></a>
				<a href="javascript:void(0);" id="openImmediatePreview" onclick="changeImmediatePreview(1);" style="display: none;"><%=labelService.getLabelNameByKeyId("6aa180440310425dbe8a2ca679011513") %><!-- 打开即时预览 --></a>
			</span>
		</div>
		</div>
	</div>
	<div id="rightDiv">
		<!-- the tabs -->
		<ul>
			<li><a href="#tabs-window"><%=labelService.getLabelNameByKeyId("18094e314c8446ffa70864a1bbbbb5e6") %><!-- 窗体样式设置 --></a></li>
			<li><a href="#tabs-header"><%=labelService.getLabelNameByKeyId("cb1d283ec8504c4e9397c80f82f63cff") %><!-- 标题栏样式设置 --></a></li>
			<li><a href="#tabs-footer"><%=labelService.getLabelNameByKeyId("435f01bacbdc43d5bd2c793a36d7637f") %><!-- 底部样式设置 --></a></li>
		</ul>
		
		<!-- tab "panes" -->
		<div id="tabs-window">
			<table>
				<colgroup>
					<col width="85px"></col>
					<col width="*"></col>
				</colgroup>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("32123de43f654e028c611d68c785d218") %><!-- 字体大小 -->：</td>
					<td class="content">
						<input type="text" id="windowFontSize" name="windowFontSize" class="textStyle" style="width: 50px;" value="<%=StringHelper.null2String(portletStyle.getWindowFontSize()) %>"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("0d5305820083446bbb6b25d440e7c2fd") %><!-- 字体 -->：</td>
					<td class="content">
						<input type="text" id="windowFontFamily" name="windowFontFamily" class="textStyle" style="width: 180px;" value="<%=StringHelper.null2String(portletStyle.getWindowFontFamily()) %>"/>
					</td>
				</tr>
				<tr>
					<td class="explain">窗体背景色：</td>
					<td class="content">
						<input type="text" id="windowBGColor" name="windowBGColor" value="<%=StringHelper.null2String(StringHelper.trimToNull(portletStyle.getWindowBGColor()), "#ffffff") %>" size="8"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("91dd5809b59c45988224882e83487139") %><!-- 上边框设置 -->：</td>
					<td class="content">
						<%=labelService.getLabelNameByKeyId("cabf960a2c924d81b8a35d6566a99096") %><!-- 宽度 -->: <input type="text" id="windowTopBorderWidth" name="windowTopBorderWidth" class="textStyle" style="width: 50px;" value="<%=StringHelper.null2String(portletStyle.getWindowTopBorderWidth()) %>"/>PX
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("f3357685ed614c469fa1e4aeb9ed5640") %><!-- 样式 -->: </span>
						<select id="windowTopBorderStyle" name="windowTopBorderStyle" style="width: 100px;">
							<option value="none"><%=labelService.getLabelNameByKeyId("e6b64e61142a4ddeb016da4420537cb6") %><!-- 无 --> </option>
							<option value="hidden"><%=labelService.getLabelNameByKeyId("cac9798a088b431aa76bcb93e152aa60") %><!-- 隐藏 --></option>
							<option value="solid"><%=labelService.getLabelNameByKeyId("29d22ac0bc2f4b7ea268093ad359fcf6") %><!-- 实线 --></option>
							<option value="dotted"><%=labelService.getLabelNameByKeyId("1ae56b39077042df8f72f0b61b085e4a") %><!-- 虚线(线宽偏细) --></option>
							<option value="dashed"><%=labelService.getLabelNameByKeyId("ca825f961c7b492da879c4c0edc0a5b4") %><!-- 虚线(线宽偏粗) --></option>
						</select>
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("d47fa6d68225457f85674f3c144a42e9") %><!-- 颜色 -->: </span>
						<input type="text" id="windowTopBorderColor" name="windowTopBorderColor" value="<%=StringHelper.null2String(portletStyle.getWindowTopBorderColor()) %>" size="8"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("11155592ad5246299b8ab3e67c301ccf") %><!-- 右边框设置 -->：</td>
					<td class="content">
						<%=labelService.getLabelNameByKeyId("cabf960a2c924d81b8a35d6566a99096") %><!-- 宽度 -->: <input type="text" id="windowRightBorderWidth" name="windowRightBorderWidth" class="textStyle" style="width: 50px;" value="<%=StringHelper.null2String(portletStyle.getWindowRightBorderWidth()) %>"/>PX
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("f3357685ed614c469fa1e4aeb9ed5640") %><!-- 样式 -->: </span>
						<select id="windowRightBorderStyle" name="windowRightBorderStyle" style="width: 100px;">
							<option value="none"><%=labelService.getLabelNameByKeyId("e6b64e61142a4ddeb016da4420537cb6") %><!-- 无 --> </option>
							<option value="hidden"><%=labelService.getLabelNameByKeyId("cac9798a088b431aa76bcb93e152aa60") %><!-- 隐藏 --></option>
							<option value="solid"><%=labelService.getLabelNameByKeyId("29d22ac0bc2f4b7ea268093ad359fcf6") %><!-- 实线 --></option>
							<option value="dotted"><%=labelService.getLabelNameByKeyId("1ae56b39077042df8f72f0b61b085e4a") %><!-- 虚线(线宽偏细) --></option>
							<option value="dashed"><%=labelService.getLabelNameByKeyId("ca825f961c7b492da879c4c0edc0a5b4") %><!-- 虚线(线宽偏粗) --></option>
						</select>
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("d47fa6d68225457f85674f3c144a42e9") %><!-- 颜色 -->: </span>
						<input type="text" id="windowRightBorderColor" name="windowRightBorderColor" value="<%=StringHelper.null2String(portletStyle.getWindowRightBorderColor()) %>" size="8"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("b43c9a308480422599f95a911ad6fcae") %><!-- 下边框设置 -->：</td>
					<td class="content">
						<%=labelService.getLabelNameByKeyId("cabf960a2c924d81b8a35d6566a99096") %><!-- 宽度 -->: <input type="text" id="windowBottomBorderWidth" name="windowBottomBorderWidth" class="textStyle" style="width: 50px;" value="<%=StringHelper.null2String(portletStyle.getWindowBottomBorderWidth()) %>"/>PX
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("f3357685ed614c469fa1e4aeb9ed5640") %><!-- 样式 -->: </span>
						<select id="windowBottomBorderStyle" name="windowBottomBorderStyle" style="width: 100px;">
							<option value="none"><%=labelService.getLabelNameByKeyId("e6b64e61142a4ddeb016da4420537cb6") %><!-- 无  --></option>
							<option value="hidden"><%=labelService.getLabelNameByKeyId("cac9798a088b431aa76bcb93e152aa60") %><!-- 隐藏 --></option>
							<option value="solid"><%=labelService.getLabelNameByKeyId("29d22ac0bc2f4b7ea268093ad359fcf6") %><!-- 实线 --></option>
							<option value="dotted"><%=labelService.getLabelNameByKeyId("1ae56b39077042df8f72f0b61b085e4a") %><!-- 虚线(线宽偏细) --></option>
							<option value="dashed"><%=labelService.getLabelNameByKeyId("ca825f961c7b492da879c4c0edc0a5b4") %><!-- 虚线(线宽偏粗) --></option>
						</select>
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("d47fa6d68225457f85674f3c144a42e9") %><!-- 颜色 -->: </span>
						<input type="text" id="windowBottomBorderColor" name="windowBottomBorderColor" value="<%=StringHelper.null2String(portletStyle.getWindowBottomBorderColor()) %>" size="8"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("becad5162d394bb1bc2b61ff1125099c") %><!-- 左边框设置 -->：</td>
					<td class="content">
						<%=labelService.getLabelNameByKeyId("cabf960a2c924d81b8a35d6566a99096") %><!-- 宽度 -->: <input type="text" id="windowLeftBorderWidth" name="windowLeftBorderWidth" class="textStyle" style="width: 50px;" value="<%=StringHelper.null2String(portletStyle.getWindowLeftBorderWidth()) %>"/>PX
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("f3357685ed614c469fa1e4aeb9ed5640") %><!-- 样式 -->: </span>
						<select id="windowLeftBorderStyle" name="windowLeftBorderStyle" style="width: 100px;">
							<option value="none"><%=labelService.getLabelNameByKeyId("e6b64e61142a4ddeb016da4420537cb6") %><!-- 无 --> </option>
							<option value="hidden"><%=labelService.getLabelNameByKeyId("cac9798a088b431aa76bcb93e152aa60") %><!-- 隐藏 --></option>
							<option value="solid"><%=labelService.getLabelNameByKeyId("29d22ac0bc2f4b7ea268093ad359fcf6") %><!-- 实线 --></option>
							<option value="dotted"><%=labelService.getLabelNameByKeyId("1ae56b39077042df8f72f0b61b085e4a") %><!-- 虚线(线宽偏细) --></option>
							<option value="dashed"><%=labelService.getLabelNameByKeyId("ca825f961c7b492da879c4c0edc0a5b4") %><!-- 虚线(线宽偏粗) --></option>
						</select>
						<span>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("d47fa6d68225457f85674f3c144a42e9") %><!-- 颜色 -->: </span>
						<input type="text" id="windowLeftBorderColor" name="windowLeftBorderColor" value="<%=StringHelper.null2String(portletStyle.getWindowLeftBorderColor()) %>" size="8"/>
					</td>
				</tr>
			</table>
			<span class="tip">
				提示：如果不需要边框，可以把各边框的样式设置为"无"或者"隐藏",或者将边框的宽度设置为0 。
			</span>
		</div>
		<div id="tabs-header">
			<table>
				<colgroup>
					<col width="120px"></col>
					<col width="*"></col>
				</colgroup>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("8707fa95c012480d9ae6d6eb1d4c6cd6") %><!-- 是否显示标题栏 -->：</td>
					<td class="content">
						<input type="radio" name="hasHeader" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasHeader" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("1eefec06a269484089b00f4e72abdbcd") %><!-- 标题栏高度 -->：</td>
					<td class="content">
						<input type="text" id="headerHeight" name="headerHeight" class="textStyle" style="width: 50px;" value="<%=portletStyle.getHeaderHeight() %>"/>PX
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("da2e2b7ae32a49c3b20f1a6ce9a744a6") %><!-- 标题栏背景色 -->：</td>
					<td class="content">
						<input type="text" id="headerBGColor" name="headerBGColor" value="<%=portletStyle.getHeaderBGColor() %>" size="8"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("930e9e2f670c449bb1c33ac563f3e2af") %><!-- 标题栏背景图片 -->：</td>
					<td class="content">
						<input type="text" id="headerBGImage" name="headerBGImage" class="textStyle" style="width: 280px;" value="<%=StringHelper.null2String(portletStyle.getHeaderBGImage()) %>"/>
						<span> 
							<select id="headerBGImageRepeat" name="headerBGImageRepeat">
								<option value="no-repeat"><%=labelService.getLabelNameByKeyId("a549b1b2e7914df39d1c51bff54a6dbf") %><!-- 不平铺 --></option>
								<option value="repeat-x"><%=labelService.getLabelNameByKeyId("863ca9c9c58f40d4a3dd9005cdba97c8") %><!-- 横向平铺 --></option>
								<option value="repeat-y"><%=labelService.getLabelNameByKeyId("bf2d7ce3387a4fb7a0107b3eeb4f6656") %><!-- 纵向平铺 --></option>
								<option value="repeat"><%=labelService.getLabelNameByKeyId("786497c492df44f68b44a880ba08d411") %><!-- 横向纵向平铺 --></option>
							</select>
						</span>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("d3b16590e91f431594480ee096070b99") %><!-- 边角显示样式 -->：</td>
					<td class="content">
						<input type="radio" name="headerCornerStyle" value="1"/><span><%=labelService.getLabelNameByKeyId("4ccabaded6e54eb4b8a31302d342cba9") %><!-- 直角 --></span>
						<input type="radio" name="headerCornerStyle" value="0"/><span><%=labelService.getLabelNameByKeyId("40bab46ea19b47d38e42feeb3ce70bbc") %><!-- 圆角 --></span>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("a1dccded2dc64a5b9a9cbee69782d678") %><!-- 刷新按钮 -->：</td>
					<td class="content">
						<input type="radio" name="hasHeaderRefreshBtn" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasHeaderRefreshBtn" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
						&nbsp;<%=labelService.getLabelNameByKeyId("6b713c1d108149deabef298ec524bdc5") %><!-- 图片路径 -->&nbsp;<input type="text" id="headerRefreshBtnPath" name="headerRefreshBtnPath" class="textStyle" style="width: 220px;" value="<%=portletStyle.getHeaderRefreshBtnPath() %>"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("1a73531b41ae450d86312596243a4876") %><!-- 最小化按钮 -->：</td>
					<td class="content">
						<input type="radio" name="hasHeaderMinBtn" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasHeaderMinBtn" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
						&nbsp;<%=labelService.getLabelNameByKeyId("6b713c1d108149deabef298ec524bdc5") %><!-- 图片路径 -->&nbsp;<input type="text" id="headerMinBtnPath" name="headerMinBtnPath" class="textStyle" style="width: 220px;" value="<%=portletStyle.getHeaderMinBtnPath() %>"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("04034aa5c750470b92a5e6725fd07cac") %><!-- 最大化按钮 -->：</td>
					<td class="content">
						<input type="radio" name="hasHeaderMaxBtn" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasHeaderMaxBtn" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
						&nbsp;<%=labelService.getLabelNameByKeyId("6b713c1d108149deabef298ec524bdc5") %><!-- 图片路径 -->&nbsp;<input type="text" id="headerMaxBtnPath" name="headerMaxBtnPath" class="textStyle" style="width: 220px;" value="<%=portletStyle.getHeaderMaxBtnPath() %>"/>
					</td>
				</tr>
			</table>
		</div>
		
		
		<div id="tabs-footer">
			<table>
				<colgroup>
					<col width="120px"></col>
					<col width="*"></col>
				</colgroup>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("3dc56c4214eb4b3f852a466d1d449f07") %><!-- 是否显示底部 -->：</td>
					<td class="content">
						<input type="radio" name="hasFooter" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasFooter" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("056a9c9b0e434423a1b7e1389cf6a3a0") %><!-- 底部高度 -->：</td>
					<td class="content">
						<input type="text" id="footerHeight" name="footerHeight" class="textStyle" style="width: 50px;" value="<%=portletStyle.getFooterHeight() %>"/>PX
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("4a8445387bef475696d8d0e89062bb16") %><!-- 底部背景色 -->：</td>
					<td class="content">
						<input type="text" id="footerBGColor" name="footerBGColor" value="<%=portletStyle.getFooterBGColor() %>" size="8"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("2301f1688b3a4a5b99a538952a847f3c") %><!-- 底部背景图片 -->：</td>
					<td class="content">
						<input type="text" id="footerBGImage" name="footerBGImage" class="textStyle" style="width: 280px;" value="<%=StringHelper.null2String(portletStyle.getFooterBGImage()) %>"/>
						<span> 
							<select id="footerBGImageRepeat" name="footerBGImageRepeat">
								<option value="no-repeat"><%=labelService.getLabelNameByKeyId("a549b1b2e7914df39d1c51bff54a6dbf") %><!-- 不平铺 --></option>
								<option value="repeat-x"><%=labelService.getLabelNameByKeyId("863ca9c9c58f40d4a3dd9005cdba97c8") %><!-- 横向平铺 --></option>
								<option value="repeat-y"><%=labelService.getLabelNameByKeyId("bf2d7ce3387a4fb7a0107b3eeb4f6656") %><!-- 纵向平铺 --></option>
								<option value="repeat"><%=labelService.getLabelNameByKeyId("786497c492df44f68b44a880ba08d411") %><!-- 横向纵向平铺 --></option>
							</select>
						</span>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("d3b16590e91f431594480ee096070b99") %><!-- 边角显示样式 -->：</td>
					<td class="content">
						<input type="radio" name="footerCornerStyle" value="1"/><span><%=labelService.getLabelNameByKeyId("4ccabaded6e54eb4b8a31302d342cba9") %><!-- 直角 --></span>
						<input type="radio" name="footerCornerStyle" value="0"/><span><%=labelService.getLabelNameByKeyId("40bab46ea19b47d38e42feeb3ce70bbc") %><!-- 圆角 --></span>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("a1dccded2dc64a5b9a9cbee69782d678") %><!-- 刷新按钮 -->：</td>
					<td class="content">
						<input type="radio" name="hasFooterRefreshBtn" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasFooterRefreshBtn" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
						&nbsp;<%=labelService.getLabelNameByKeyId("6b713c1d108149deabef298ec524bdc5") %><!-- 图片路径 -->&nbsp;<input type="text" id="footerRefreshBtnPath" name="footerRefreshBtnPath" class="textStyle" style="width: 220px;" value="<%=portletStyle.getFooterRefreshBtnPath() %>"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("1a73531b41ae450d86312596243a4876") %><!-- 最小化按钮 -->：</td>
					<td class="content">
						<input type="radio" name="hasFooterMinBtn" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasFooterMinBtn" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
						&nbsp;<%=labelService.getLabelNameByKeyId("6b713c1d108149deabef298ec524bdc5") %><!-- 图片路径 -->&nbsp;<input type="text" id="footerMinBtnPath" name="footerMinBtnPath" class="textStyle" style="width: 220px;" value="<%=portletStyle.getFooterMinBtnPath() %>"/>
					</td>
				</tr>
				<tr>
					<td class="explain"><%=labelService.getLabelNameByKeyId("04034aa5c750470b92a5e6725fd07cac") %><!-- 最大化按钮 -->：</td>
					<td class="content">
						<input type="radio" name="hasFooterMaxBtn" value="1"/><span><%=labelService.getLabelNameByKeyId("0671e4913b184cb798190ca493bc6958") %><!-- 显示 --></span>
						<input type="radio" name="hasFooterMaxBtn" value="0"/><span><%=labelService.getLabelNameByKeyId("a62c12cc97484ade9810fd092518105d") %><!-- 隐藏 --></span>
						&nbsp;<%=labelService.getLabelNameByKeyId("6b713c1d108149deabef298ec524bdc5") %><!-- 图片路径 -->&nbsp;<input type="text" id="footerMaxBtnPath" name="footerMaxBtnPath" class="textStyle" style="width: 220px;" value="<%=portletStyle.getFooterMaxBtnPath() %>"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	</div>
	</form>
</body>
</html>
