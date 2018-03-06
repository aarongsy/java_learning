<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@page import="com.eweaver.base.menu.service.MenuService"%>
<%@page import="com.eweaver.base.menu.dao.MenuorgDao"%>
<%@page import="com.eweaver.base.menu.model.Menu"%>
<%@page import="org.light.portal.core.service.PortalService"%>
<%@page import="org.light.portal.core.entity.PortletObject"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%
String action = StringHelper.null2String(request.getParameter("action"));

LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
String responseId = StringHelper.null2String(request.getParameter("responseId"));
int portletId = NumberHelper.string2Int(request.getParameter("portletId"), -1);
PortalService portalService = (PortalService)BaseContext.getBean("portalService");
PortletObject objPortlet = portalService.getPortletById(portletId);
String portletParam = objPortlet.getParameter();
JSONObject jsonObj;
if(!StringHelper.isEmpty(portletParam)){
	jsonObj = (JSONObject)JSONValue.parse(portletParam);
}else{
	jsonObj = new JSONObject();
}
//isSysAdmin = false;
if(action.equals("modifyPortletShortcutParam")){	//充当控制器
	String[] shortcutIds = request.getParameterValues("shortcutId");
	String[] shortcutImgPaths = request.getParameterValues("shortcutImgPath");
	String[] shortcutNames = request.getParameterValues("shortcutName");
	String[] shortcutUrls = request.getParameterValues("shortcutUrl");
	String[] shortcutOpenModes = request.getParameterValues("shortcutOpenMode");
	String[] shortcutDsporders = request.getParameterValues("shortcutDsporder");
	
	JSONArray choosedShortcutDatas = (JSONArray)jsonObj.get("shortcutDatas");
	if(choosedShortcutDatas == null){
		choosedShortcutDatas = new JSONArray();
	}
	
	//保存之前先删除之前的快捷方式(是管理员，删除公共的. 不是管理员，删除自己的。)，后面会追加一批新提交快捷方式
	for(int i = (choosedShortcutDatas.size() - 1); i >= 0; i--){
		JSONObject choosedShortcutData = (JSONObject)choosedShortcutDatas.get(i);
		String userid = StringHelper.null2String(choosedShortcutData.get("userid"));
		if(isSysAdmin){
			if(StringHelper.isEmpty(userid)){//删除公共的
				choosedShortcutDatas.remove(choosedShortcutData);
			}
		}else{
			if(userid.equals(currentuser.getId())){//删除自己的
				choosedShortcutDatas.remove(choosedShortcutData);
			}
		}
	}
	//新追加的一批快捷方式
	JSONArray newShortcutDatas = new JSONArray();
	for(int i = 0; shortcutIds != null && i < shortcutIds.length; i++){
		JSONObject shortcutData = new JSONObject();
		
		String shortcutId = shortcutIds[i];
		String shortcutImgPath = shortcutImgPaths[i];
		String shortcutName = shortcutNames[i];
		String shortcutOpenMode = shortcutOpenModes[i];
		shortcutName = URLDecoder.decode(shortcutName, "utf-8");
		String shortcutUrl = shortcutUrls[i];
		Integer shortcutDsporder = NumberHelper.getIntegerValue(shortcutDsporders[i], 0);
		
		shortcutData.put("shortcutId", shortcutId);
		shortcutData.put("shortcutImgPath", shortcutImgPath);
		shortcutData.put("shortcutName", shortcutName);
		shortcutData.put("shortcutOpenMode", shortcutOpenMode);
		shortcutData.put("shortcutUrl", shortcutUrl);
		shortcutData.put("shortcutDsporder", shortcutDsporder);
		if(isSysAdmin){
			shortcutData.put("userid", "");
		}else{
			shortcutData.put("userid", currentuser.getId());
		}
		newShortcutDatas.add(shortcutData);
		labelCustomService.createOrModifyDefaultCNLabelOfShortcut(shortcutData);
	}
	if(isSysAdmin){	//如果是公共的快捷方式则追加到最前面
		choosedShortcutDatas.addAll(0, newShortcutDatas);
	}else{	//否则追加到末尾
		choosedShortcutDatas.addAll(newShortcutDatas);
	}
	
	jsonObj.put("shortcutDatas", choosedShortcutDatas);
	
	objPortlet.setParameter(jsonObj.toString());
	
	portalService.save(objPortlet);
	out.print("<script type=\"text/javascript\">parent.closeShortcutChoose('"+portletId+"','"+responseId+"');</script>");
	return;
}else{	//注意：这个else作用范围一直到文件最底部
	/*查询出受权限控制的用户菜单*/
	MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService");
	MenuService menuService = (MenuService)BaseContext.getBean("menuService");
	List<Menu> allUserMenu = menuorgService.getAllUserMenu(false);
	allUserMenu = menuService.orderTheMenuList(allUserMenu, null);//对菜单进行排序(仅在list中)
	allUserMenu = menuService.generateLevel(allUserMenu);//为菜单生成级别(仅在list中)
	
	JSONArray choosedShortcutDatas = (JSONArray)jsonObj.get("shortcutDatas");
	if(choosedShortcutDatas == null){
		choosedShortcutDatas = new JSONArray();
	}
	
	for(int i = (choosedShortcutDatas.size() - 1); i >= 0; i--){
		JSONObject choosedShortcutData = (JSONObject)choosedShortcutDatas.get(i);
		String userid = StringHelper.null2String(choosedShortcutData.get("userid"));
		if(StringHelper.isEmpty(userid)){
			if(!isSysAdmin){	//不是管理员，删除公共的快捷方式
				choosedShortcutDatas.remove(choosedShortcutData);
			}
		}else{
			if(isSysAdmin){	//管理员不管理用户私有的快捷方式
				choosedShortcutDatas.remove(choosedShortcutData);
			}else{	
				if(!userid.equals(currentuser.getId())){	//普通用户不可以管理其他人的私有快捷方式,只能管理自己的
					choosedShortcutDatas.remove(choosedShortcutData);
				}
			}
		}
	}
	
	Collections.sort(choosedShortcutDatas, new Comparator<JSONObject>() {

		public int compare(JSONObject o1, JSONObject o2) {
			int shortcutDsporder1 = NumberHelper.getIntegerValue(o1.get("shortcutDsporder"), 0);
			int shortcutDsporder2 = NumberHelper.getIntegerValue(o2.get("shortcutDsporder"), 0);
			return shortcutDsporder1 - shortcutDsporder2;
		}
	});
%>
<!DOCTYPE HTML>
<html>
<head>
<title>ShortCut Manage</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery/ui/jquery-ui-1.8.18.custom.min.js"></script>
<link rel="stylesheet" href="/js/jquery/ui/themes/base/jquery.ui.all.css"/>
<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
<script type="text/javascript" src="/base/shortcut/js/shortcutmanage2.js"></script>
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
	display:inline-block;
	word-break:break-all;
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
	height: 20px;
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
  <div id="pagemenubar"></div>
  <div id="levelMenu"><!-- 一级菜单 -->
  	<div class="title">一级菜单</div>
  	<ul>
  		<%for(int i = 0; i < allUserMenu.size(); i++){
			Menu userMenu = allUserMenu.get(i);
			if(userMenu.getCol3().equals("0")){%>
				<li><a id="levelMenu_<%=userMenu.getId() %>" href="javascript:void(0);" onclick="openChildMenuDiv('<%=userMenu.getId() %>')"><p><span class="icon"><img src="<%=userMenu.getImgfile() %>" align="middle"/></span><span class="text"><%=userMenu.getMenuname() %></span></p></a></li>
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
				if(userMenu.getMenuname() == null){
					continue;
				}
				if(i == 0){
					childMenuDivStrBuffer.append("<div id=\"childMenu_"+userMenu.getId()+"\"><ul>");
				}else if(userMenu.getCol3().equals("0")){
					childMenuDivStrBuffer.append("</ul></div><div id=\"childMenu_"+userMenu.getId()+"\"><ul>");
				}
				String menuEncodeName = URLEncoder.encode(userMenu.getMenuname(), "utf-8");
				if(!userMenu.getCol3().equals("0")){
					int paddingLeft = (NumberHelper.getIntegerValue(userMenu.getCol3()) - 1) * 20 + 4;
					if(userMenu.getChildrennum() == 0){
						boolean checked = false;
						for(int c = 0; c < choosedShortcutDatas.size(); c++){
							JSONObject choosedShortcutData = (JSONObject)choosedShortcutDatas.get(c);
							if(userMenu.getId().equals(choosedShortcutData.get("shortcutId"))){
								checked = true;
								break;
							}
						}
						childMenuDivStrBuffer.append("<li style=\"padding-left:"+paddingLeft+"px;\">");
						childMenuDivStrBuffer.append("<input type=\"checkbox\" id=\"cb_"+userMenu.getId()+"\"");
						if(checked){
							childMenuDivStrBuffer.append(" checked=\"checked\" ");
						}
						childMenuDivStrBuffer.append("onclick=\"createOrDeleteSelectedElement(this,'"+userMenu.getId()+"','"+userMenu.getImgfile()+"','"+menuEncodeName+"','"+userMenu.getUrl()+"','2')\"/>");
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
  	<form action="/base/shortcut/shortcutmanage2.jsp?action=modifyPortletShortcutParam" id="shortcutForm" method="post">
  	<input type="hidden" id="portletId" name="portletId" value="<%=portletId %>"/>
  	<input type="hidden" name="responseId" value="<%=responseId %>"/>
  	<span class="title">已选择<a href="javascript:void(0);" onclick="createManualEnterShortcut();"><span class="enter">手动输入</span></a></span>
  	
  	<div>
  		<ul>
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
				String shortcutIdsOfHidden = "";
				StringBuilder choosedShortcutHtmlBuilder = new StringBuilder();
				for(int i = 0; i < choosedShortcutDatas.size(); i++){
					JSONObject choosedShortcutData = (JSONObject)choosedShortcutDatas.get(i);
					String shortcutId = StringHelper.null2String(choosedShortcutData.get("shortcutId"));
					String shortcutImgPath = StringHelper.null2String(choosedShortcutData.get("shortcutImgPath"));
					String shortcutName = StringHelper.null2String(choosedShortcutData.get("shortcutName"));
					String shortcutOpenMode = StringHelper.null2String(choosedShortcutData.get("shortcutOpenMode"));
					String shortcutEncodeName = URLEncoder.encode(shortcutName, "utf-8");
					String shortcutUrl = StringHelper.null2String(choosedShortcutData.get("shortcutUrl"));
					int shortcutDsporder = NumberHelper.getIntegerValue(choosedShortcutData.get("shortcutDsporder"), 0);
					
					//添加权限过滤
					if(!shortcutId.startsWith("custom_") && !isHavaMenuPermission(allUserMenu, shortcutId)){
						continue;
					}
					
					choosedShortcutHtmlBuilder.append("<li id=\"selElement_"+shortcutId+"\">");
					choosedShortcutHtmlBuilder.append("<input type=\"hidden\" name=\"shortcutId\" value=\""+shortcutId+"\"/>");
					choosedShortcutHtmlBuilder.append("<input type=\"hidden\" name=\"shortcutImgPath\" value=\""+shortcutImgPath+"\"/>");
					choosedShortcutHtmlBuilder.append("<input type=\"hidden\" name=\"shortcutName\" value=\""+shortcutEncodeName+"\"/>");
					choosedShortcutHtmlBuilder.append("<input type=\"hidden\" name=\"shortcutUrl\" value=\""+shortcutUrl+"\"/>");
					choosedShortcutHtmlBuilder.append("<input type=\"hidden\" name=\"shortcutOpenMode\" value=\""+shortcutOpenMode+"\"/>");
					choosedShortcutHtmlBuilder.append("<input type=\"hidden\" name=\"shortcutDsporder\" value=\""+shortcutDsporder+"\"/>");
					choosedShortcutHtmlBuilder.append("<span class=\"icon\"><img src=\""+shortcutImgPath+"\" align=\"middle\"/></span>");
					choosedShortcutHtmlBuilder.append("<span class=\"text\">"+shortcutName+"</span>");
					choosedShortcutHtmlBuilder.append("<span class=\"handler\">");
					choosedShortcutHtmlBuilder.append("<img src=\"/images/application/fam/pencil.png\" align=\"middle\" onclick=\"editSelectedElement('"+shortcutId+"','"+shortcutImgPath+"','"+shortcutEncodeName+"','"+shortcutUrl+"','"+shortcutOpenMode+"',"+shortcutDsporder+")\" title=\"编辑\"/>");
					choosedShortcutHtmlBuilder.append("<img src=\"/images/iconDelete.gif\" align=\"middle\" onclick=\"confirmDeleteSelectedElement('"+shortcutId+"')\" title=\"删除\"/>");
					choosedShortcutHtmlBuilder.append("</span>");
					choosedShortcutHtmlBuilder.append("</li>");
					
					shortcutIdsOfHidden += shortcutId + ",";
				}
			%>
			<%=choosedShortcutHtmlBuilder.toString() %>
  		</ul>
  		
  		<input type="hidden" id="shortcutIdsOfHidden" name="shortcutIdsOfHidden" value="<%=shortcutIdsOfHidden %>"/>
  	</div>
  	</form>
  </div>
  
  <!-- 手动输入div 弹出窗口显示 -->
  <div id="manualEnter">
	<form id="manualEnterForm" action="" method="post" enctype="multipart/form-data">
		<input type="hidden" id="theType"/>
		<input type="hidden" id="customData_id" name="customData_id"/>
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
					<span id="customData_languagespan" name="customData_languagespan">
						
					</span>
				</td>
			</tr>
			<tr>
				<td>对应图片：</td>
				<td>
					<input type="text" id="customData_picPath" name="customData_picPath" onchange="checkInput('customData_picPath','customData_picPathspan')"/>
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
			<tr>
				<td >页面打开方式：</td>
				<td>
					<input style="width: 15px" type="radio" name="customData_openMode" value="1"/>弹出窗口
					<input style="width: 15px" type="radio" name="customData_openMode" value="2" checked="checked"/>tab页
				</td>
			</tr>
			<tr>
				<td>显示顺序：</td>
				<td>
					<input type="text" id="customData_dsporder" name="customData_dsporder" onchange="checkInput('customData_dsporder','customData_dsporderspan')" onkeyup="value=value.replace(/[^\d]/ig,'')" />
					<span id="customData_dsporderspan" name="customData_dsporderspan" style="color: red"/>
						<img src="/images/base/checkinput.gif"/>
					</span>
				</td>
			</tr>
		</table>
	</form>
  </div>
</body>
</html>
<%} %>
