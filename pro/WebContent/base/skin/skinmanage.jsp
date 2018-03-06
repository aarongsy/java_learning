<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
	<title>skin manage</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
	<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
	<link rel="stylesheet" href="/js/jquery/ui/themes/base/jquery.ui.all.css"/>
	<script type="text/javascript" src="/js/jquery/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/tabs/jquery.ui.tabs.js"></script>
	<link rel="stylesheet" type="text/css" href="/base/skin/css/skin.css"/>
	<script type="text/javascript" src="/base/skin/js/skinmanage.js"></script>
</head>
<body>
	<div id="pagemenubar"></div>
  	<div id="main">
  		<div id="skinList">
  			<div class="title">
  				<span class="name">皮肤列表</span>
  				<span class="hideUnEnabledSKin"><input type="checkbox" id="isHideUnEnabledSKin" class="cbox" onclick="javascript:controlUnEnabledSKinShowOrHide();"/>隐藏被禁用的皮肤</span>
  			</div>
  			<div class="content">
  				<ul>
  					<!-- 
  					<li><a>
  							<p>
		  						<span class="previewpic"><img src="/css/skins/default/preview.jpg" align="center"/></span>
		  						<span class="skinName">系统皮肤</span>
  							</p>
  						</a>
  					</li>
  					<li><a>
  							<p>
		  						<span class="previewpic"><img src="/css/skins/default/preview.jpg" align="center"/></span>
		  						<span class="skinName">蓝色天空</span>
  							</p>
  						</a>
  					</li>
  					<li><a>
  							<p>
		  						<span class="previewpic"><img src="/css/skins/default/preview.jpg" align="center"/></span>
		  						<span class="skinName">唯美草原</span>
  							</p>
  						</a>
  					</li> -->
  				</ul>
  			</div>
  			<div class="bottom">
  				<span class="software" style="margin-right: 15px;"><span>软件模式皮肤</span></span>
  				<span class="website"><span>网站模式皮肤</span></span>
  			</div>
  		</div>
  		<form action="/ServiceAction/com.eweaver.base.skin.servlet.SkinAction?action=modifySkin" method="post" id="SkinForm" style="margin: 0;padding: 0;">
  		<div id="skinData">
  			<div class="title">
  				<span>皮肤信息</span>
  			</div>
  			<div id="cssData">
  				<div class="edit"><a id="editMode">最大化编辑</a></div>
				<ul>
					<li><a href="#tabs-baseData">基本信息</a></li>
					<li><a href="#tabs-globalCSS">全局样式</a></li>
					<li><a href="#tabs-mainCSS">主界面样式</a></li>
					<li><a href="#tabs-portalCSS">门户样式</a></li>
					<li><a href="#tabs-shortcutCSS">快速入口样式</a></li>
					<li><a href="#tabs-workflowCSS">流程页面样式</a></li>
				</ul>
				<div id="tabs-baseData" class="baseData">
	  				<input type="hidden" id="id" name="id"/>
	  				<input type="hidden" id="isSystem" name="isSystem"/>
	  				<table>
	  					<colgroup>
	  						<col width="115px"/>
	  						<col width="300px"/>
	  						<col width="115px"/>
	  						<col width="*"/>
	  					</colgroup>
	  					<tr>
	  						<td align="right">皮肤名称：</td>
	  						<td align="left"><input type="text" class="textStyle" id="objname" name="objname" onchange="checkInput('objname','objnamespan')"/><span id="objnamespan" name="objnamespan"></span></td>
	  						<td align="right">皮肤存放基路径：</td>
	  						<td align="left"><input type="text" class="textStyle" style="width: 180px;" id="basePath" name="basePath" readonly="readonly"/></td>
	  					</tr>
	  					<tr>
	  						<td align="right">预览效果图路径：</td>
	  						<td align="left"><input type="text" class="textStyle" style="width: 250px;" id="previewPicPath" name="previewPicPath"/></td>
	  						<td align="right">是否默认皮肤：</td>
	  						<td align="left" id="isDefaultTD">
	  							<!-- 
	  							<input type="radio" name="isDefault" value="1"/>是&nbsp;
	  							<input type="radio" name="isDefault" value="0"/>否 -->
	  						</td>
	  					</tr>
	  					<tr>
	  						<td align="right">皮肤类型：</td>
	  						<td align="left" id="skinTypeTD">
	  							<input type="radio" name="skinType" value="0"/>软件模式皮肤&nbsp;
	  							<input type="radio" name="skinType" value="1"/>网站模式皮肤
	  						</td>
	  						<td align="right">是否隐藏首页左侧：</td>
	  						<td align="left">
	  							<input type="radio" name="isHideMainPageLeft" value="1"/>是(隐藏)&nbsp;
	  							<input type="radio" name="isHideMainPageLeft" value="0"/>否(显示)
	  						</td>
	  					</tr>
	  					<tr>
	  						<td align="right" valign="top">是否启用该皮肤：</td>
	  						<td align="left" valign="top">
	  							<input type="radio" name="isEnabled" value="1" onclick="javascript:controlIsEnabledTipShowOrHide();"/>启用&nbsp;
	  							<input type="radio" name="isEnabled" value="0" onclick="javascript:controlIsEnabledTipShowOrHide();"/>禁用
	  							<span id="isEnabledSpan"></span>
	  						</td>
	  						<td align="right" valign="top">菜单图标存放路径：</td>
	  						<td align="left" valign="top">
	  							<input type="text" class="textStyle" style="width: 180px;" id="menuImgPath" name="menuImgPath"/>
	  							<span id="menuImgPathSpan"></span>
	  						</td>
	  					</tr>
	  					<tr id="isEnabledTip">
	  						<td colspan="2">
	  							(注：皮肤被禁用后前台的皮肤设置中将不会显示该皮肤,并且已使用该皮肤的用户将被强制使用默认皮肤)
	  						</td>
	  					</tr>
	  				</table>
	  			</div>
				<div id="tabs-globalCSS">
					<textarea id="globalCss" name="globalCss"></textarea>
				</div>
				
				<div id="tabs-mainCSS">
					<textarea id="mainCss" name="mainCss"></textarea>
				</div>
				
				<div id="tabs-portalCSS">
					<textarea id="portalCss" name="portalCss"></textarea>
				</div>
				
				<div id="tabs-shortcutCSS">
					<textarea id="shortcutCss" name="shortcutCss"></textarea>
				</div>
				
				<div id="tabs-workflowCSS">
					<textarea id="workflowCss" name="workflowCss"></textarea>
				</div>
			</div>
  		</div>
  		</form>
  	</div>
</body>
</html>
