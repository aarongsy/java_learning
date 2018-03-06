<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@page import="com.eweaver.base.menu.service.MenuService"%>
<%@page import="com.eweaver.base.menu.dao.MenuorgDao"%>
<%@page import="com.eweaver.base.menu.model.Menu"%>
<%@ include file="/base/init.jsp"%>
<%
/*查询出受权限控制的用户菜单*/
MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService");
MenuService menuService = (MenuService)BaseContext.getBean("menuService");
List<Menu> allUserMenu = menuorgService.getAllUserMenu(false);
allUserMenu = menuService.orderTheMenuList(allUserMenu, null);//对菜单进行排序(仅在list中)
allUserMenu = menuService.generateLevel(allUserMenu);//为菜单生成级别(仅在list中)
%>
<!DOCTYPE HTML>
<html>
<head>
<title>ShortCut Manage</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery/ui/jquery-ui-1.8.18.custom.min.js"></script>
<link rel="stylesheet" href="/js/jquery/ui/themes/base/jquery.ui.all.css"/>
<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
<script type="text/javascript" src="/base/shortcut/js/shortcutmanage.js"></script>
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->
<style type="text/css">
*,span{
	font-family: Microsoft YaHei;
}
#open{
	border: 1px solid #999;
	margin-top: 10px;
	margin-left: 20px;
	width: 557px;
}
#open table{
	margin-left: 3px;
}
#levelMenu{
	border: 1px solid #999;
	margin-top: 10px;
	margin-left: 20px;
	float: left;
	width: 120px;
}
#levelMenu ul{
	list-style: none;
	margin:0px;
}
#levelMenu ul li a{
	height: 1em;
	cursor: pointer;
	text-decoration: none;
}
#levelMenu ul li a p{
	margin:0px;
	border-bottom: 1px solid #999;
	height: 26px;
	padding: 4px;
	position: relative;
}
#levelMenu ul li a:hover p{
	background: #DFDFDF;
}
#levelMenu ul li a p .icon img{
	width: 16px;
	height: 16px;
}
#levelMenu ul li a p .text{
	font-weight: bold;
	position: absolute;
	left: 25px;
	top: 6px;
}
#childMenu{
	width: 200px;
	float: left;
	margin-top: 10px;
	margin-left: 20px;
	border: 1px solid #999;
}
#childMenu div{
	display: none;
}
#childMenu div ul li{
	padding: 2px;
}
#childMenu div ul li img{
	width: 16px;
	height: 16px;
	margin-right: 2px;
}
#selectedElement{
	width: 200px;
	float: left;
	margin-top: 10px;
	margin-left: 20px;
	border: 1px solid #999;
	position: relative;
}
#selectedElement .title a{
	position: absolute;
	right: 2px;
	top: 7px;
	cursor: pointer;
	text-decoration: none;
}
#selectedElement .title a .enter{
	background:url("/images/doc_edit.png") no-repeat;
	font-weight: normal;
	padding-left: 18px;
}
#selectedElement div ul li{
	padding: 2px;
	position: relative;
}
#selectedElement div ul li .icon{
	margin-right: 5px;
}
#selectedElement div ul li .icon img{
	width: 16px;
	height: 16px;
}
#selectedElement div ul li .text{
	padding-top: 2px;
	margin-right: 15px;
}
#selectedElement div ul li .handler{
	position: absolute;
	right: 5px;
	top: 5px;
}
#selectedElement div ul li .handler img{
	width: 16px;
	height: 16px;
	margin-right: 2px;
	cursor: pointer;
}
div .title{
	display: block;
	height: 26px;	
	border-bottom: 1px solid #999;
	background: #DFDFDF;
	position: relative;
	font-weight: bold;
	padding: 7px;
}
#manualEnter{
	display: none;
}
#manualEnter table{
	line-height: 30px;
}
#manualEnter input{
	width: 200px;
}
.tip{
	border: 1px solid #999;
	color: blue;
	padding: 5px 10px;
	position: absolute;
	z-index: 10;
	top: 2px;
	right: 2px;
}
</style>
</head>
  
<body>
  <div id="open">
  	<table>
  		<colgroup>
  			<col width="90px;"></col>
  		</colgroup>
  		<tr>
  			<td><span>页面打开方式：</span></td>
  			<td>
				<input type="radio" name="openMode" value="0" onclick="modifyOpenMode()"/><span>当前页</span>
				<input type="radio" name="openMode" value="1" onclick="modifyOpenMode()"/><span>新窗口</span>
				<input type="radio" name="openMode" value="2" onclick="modifyOpenMode()"/><span>tab页</span>
			</td>
  		</tr>
  	</table>
  </div>
  <div id="levelMenu"><!-- 一级菜单 -->
  	<div class="title">一级菜单</div>
  	<ul>
  		<%for(int i = 0; i < allUserMenu.size(); i++){
			Menu userMenu = allUserMenu.get(i);
			if(userMenu.getCol3().equals("0")){%>
				<li><a id="levelMenu_<%=userMenu.getId() %>" href="#" onclick="openChildMenuDiv('<%=userMenu.getId() %>')"><p><span class="icon"><img src="<%=userMenu.getImgfile() %>" align="middle"/></span><span class="text"><%=userMenu.getMenuname() %></span></p></a></li>
			<%}
  		  }
		%>
  	</ul>
  </div>
  <div id="childMenu"><!-- 子菜单 -->
  		<span class="title">子功能菜单</span>
		<%
			StringBuffer childMenuDivStrBuffer = new StringBuffer();
			for(int i = 0; i < allUserMenu.size(); i++){
				Menu userMenu = allUserMenu.get(i);
				if(i == 0){
					childMenuDivStrBuffer.append("<div id=\"childMenu_"+userMenu.getId()+"\"><ul>");
				}else if(userMenu.getCol3().equals("0")){
					childMenuDivStrBuffer.append("</ul></div><div id=\"childMenu_"+userMenu.getId()+"\"><ul>");
				}
				if(!userMenu.getCol3().equals("0")){
					int paddingLeft = (NumberHelper.getIntegerValue(userMenu.getCol3()) - 1) * 20 + 4;
					if(userMenu.getChildrennum() == 0){
						childMenuDivStrBuffer.append("<li style=\"padding-left:"+paddingLeft+"px;\">");
						childMenuDivStrBuffer.append("<input type=\"checkbox\" id=\"cb_"+userMenu.getId()+"\" onclick=\"createOrDeleteSelectedElement(this,'"+userMenu.getId()+"','"+userMenu.getImgfile()+"','"+userMenu.getMenuname()+"')\"/>");
						childMenuDivStrBuffer.append("<img src=\""+userMenu.getImgfile()+"\" align=\"middle\"/>");
						childMenuDivStrBuffer.append(userMenu.getMenuname());
						childMenuDivStrBuffer.append("</li>");
					}else{
						childMenuDivStrBuffer.append("<li style=\"padding-left:"+paddingLeft+"px;\">");
						childMenuDivStrBuffer.append("<img src=\""+userMenu.getImgfile()+"\" align=\"middle\"/>");
						childMenuDivStrBuffer.append(userMenu.getMenuname());
						childMenuDivStrBuffer.append("</li>");
					}
				}
				if(i == (allUserMenu.size() - 1)){
					childMenuDivStrBuffer.append("</ul></div>");
				}
			}
		%>
		<%=childMenuDivStrBuffer.toString() %>
  </div>
  <div id="selectedElement">
  	<form action="">
  	<span class="title">已选择<a href="#" onclick="createManualEnterDialog();"><span class="enter">手动输入</span></a></span>
  	
  	<div>
  		<ul>
  			<li>
  				<span class="icon"><img src="/images/silk/arrow_branch.gif" align="middle"/></span>
  				<span class="text">新建(文档)</span>
  				<span class="handler"><img src="/images/iconDelete.gif" align="middle"/></span>
  			</li>
  			<li>
				<span class="icon"><img src="/images/silk/arrow_branch.gif" align="middle"/></span>
  				<span class="text">查询文档</span>
  				<span class="handler"><img src="/images/iconDelete.gif" align="middle"/></span>
			</li>
  		</ul>
  	</div>
  	</form>
  </div>
  
  <!-- 手动输入div 弹出窗口显示 -->
  <div id="manualEnter">
	<form id="manualEnterForm" action="" method="post" enctype="multipart/form-data">
		<table>
			<colgroup>
  				<col width="90px;"></col>
  			</colgroup>
			<tr>
				<td>快速入口名称：</td>
				<td>
					<input type="text" id="customData_objname" name="customData_objname" onchange="checkInput('customData_objname','customData_objnamespan')"/>
					<span id="customData_objnamespan" name="customData_objnamespan" style="color: red"/>
						<img src="/images/base/checkinput.gif"/>
					</span>
				</td>
			</tr>
			<tr>
				<td>对应图片：</td>
				<td>
					<input type="file" id="customData_picPath" name="customData_picPath" onchange="checkInput('customData_picPath','customData_picPathspan')"/>
					<span id="customData_picPathspan" name="customData_picPathspan" style="color: red"/>
						<img src="/images/base/checkinput.gif"/>
					</span>
				</td>
			</tr>
			<tr>
				<td>点击链接路径：</td>
				<td>
					<input type="text" id="customData_openUrl" name="customData_openUrl" onchange="checkInput('customData_openUrl','customData_openUrlspan')"/>
					<span id="customData_openUrlspan" name="customData_openUrlspan" style="color: red"/>
						<img src="/images/base/checkinput.gif"/>
					</span>
				</td>
			</tr>
		</table>
	</form>
  </div>
</body>
</html>
