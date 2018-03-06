<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.*" %>
<%@ page import="com.eweaver.humres.base.service.*" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ taglib uri="/WEB-INF/tlds/authz.tld" prefix="authz"%>

<%
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
	response.sendRedirect("/main/login.jsp");
	return;
}
Humres currentuser = eweaveruser.getHumres();
MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService") ;
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
    LabelService labelService = (LabelService)BaseContext.getBean("labelService");

String orgid = currentuser.getOrgid();
List menuList = null;
boolean isOrgMenuDefined = menuorgService.isOrgDefined(orgid);
String from = "menuorg" ;
if (isOrgMenuDefined) {
	menuList = menuorgService.getSubmenu(orgid,null);
}
else{//看上及有没有定义
	
	Orgunitlink orgunitlink = orgunitService.getOrgunitlink(orgid) ;
	while (orgunitlink.getPid()!=null){
		orgid = orgunitlink.getPid();
		if (menuorgService.isOrgDefined(orgid)){
			menuList = menuorgService.getSubmenu(orgid,null);
			break;
		}
		else {
			orgunitlink = orgunitService.getOrgunitlink(orgid) ;
		}
	}
}
if (menuList==null){//都没有定义

	menuList = menuService.getSubMenus(null,"1,2","1");
	from = "menu" ;
	//menuList = menuorgService.getSubmenuorg(orgid,null,"1");
}

int menubarNum = 0;
StringBuffer xmlMenuBar = new StringBuffer("<menu>");	//<menu><menubar id="0" icon="/images/folder.png" name="Favorites"></menubar></menu>
StringBuffer xmlMenu = new StringBuffer();

for(int i=0;i<menuList.size();i++){
	Menu menu = (Menu)menuList.get(i);
	if (menu.getId().equals("402881df0f9e8df5010f9e90f4c30004")) continue ;
        String _menuname=labelService.getLabelName(menu.getMenuname()); // 把menuname存放的是标签管理的关键字
          if(StringHelper.isEmpty(_menuname))
          _menuname=menu.getMenuname();
	String _imgfile=StringHelper.filterJString2(StringHelper.null2String(menu.getImgfile()));
	String _id=menu.getId();
	String _pid=menu.getPid();

	if(menu.getId().equals("4028808e13e143670113e1aab8a6000c")){//EWTS-000014,系统设置菜单权限判断
%>
		<authz:authorize ifAllGranted="AUTH_402881dc0d7cf641010d7cfb03d10016">
		<%
		xmlMenuBar.append("<menubar id=\""+i+"\" icon=\""+_imgfile+"\" name=\""+_menuname+"\"></menubar>");
		menubarNum++;
		%>
		</authz:authorize>
<%
	}else{
		xmlMenuBar.append("<menubar id=\""+i+"\" icon=\""+_imgfile+"\" name=\""+_menuname+"\"></menubar>");
		menubarNum++;
	}

	List menuList2 = null ;
	if (from.equals("menu")){
		menuList2 = menuService.getSubMenus(_id,"1,2","1") ;
	}
	else {
		menuList2 = menuorgService.getSubmenu(orgid,_id);
	}

	/*========================================================== 
	var myMenu_2=[
		['<img src=/images_face/ecologyFace_2/LeftMenuIcon/DOC_16.gif>','新建文档','/docs/docs/DocList.jsp?isuserdefault=1','mainframe','新建文档'],
		['<img src=/images_face/ecologyFace_2/LeftMenuIcon/DOC_17.gif>','我的文档','/docs/search/DocView.jsp','mainframe','我的文档'],
		['<img src=/images_face/ecologyFace_2/LeftMenuIcon/DOC_83.gif>','订阅历史','/docs/docsubscribe/DocSubscribeHistory.jsp','mainframe','订阅历史']
	];
	*/
	xmlMenu.append("var myMenu_"+i+"=[");
	xmlMenu.append(menuService.getMenuArray(menuList2));
	xmlMenu.append("];");
}
xmlMenuBar.append("</menu>");
//System.out.println(xmlMenuBar);
%>
<HTML>
<HEAD>
<TITLE>高效源于协同</TITLE>
<META http-equiv=Content-Language content=zh-cn>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<META content="MSHTML 6.00.2600.0" name=GENERATOR>
<script language="javascript" src="/js/left.js"></script>
<style id="popupmanager">
.popupMenu{
	width: 100px;
	border: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	background-image: url(/images/popup/bg_menu.gif);
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 21px;
	padding: 1px;
}
.popupMenuRowHover{
	height: 21px;
	border: 1px solid #0A246A;
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: expression(parentElement.offsetWidth-27);
	position: relative;
	left: 28;
}
</style>
<style type="text/css">
body{margin:0;padding:0;}
#divMenuBox td{padding:0}
#divFavContent{display:none;}
*{font-family:MS Shell Dlg;font-size:12px}

#divFavContent{display:none;}
.OTtable{
	border:0px solid #AAA;
	width:100%;
	height:100%;
	background-color:#7B7B7B;
}
.OTtd{
	line-height:18px;
	padding-left:2px
}
.OTspan{display:none;}

/* 左菜单分类背景色(图) */
.folder{
	height:25px;
	padding:0 0 0 10px;
	color:#000;
	cursor:hand;
	background-image:url(<%=request.getContextPath()%>/images/main/StyleGray/leftbarBgImage.jpg);
	background-color:#C4C4C4;
}
.folder img{margin:0 10px 0 10px;vertical-align:middle}
.folderMouseOver{
	height:25px;
	padding:0 0 0 10px;
	color:#000;
	cursor:hand;
	background-image:url(<%=request.getContextPath()%>/images/main/StyleGray/leftbarBgImageH.jpg);
	background-color:#C4C4C4;
}
.folderMouseOver img{margin:0 10px 0 10px;vertical-align:middle}
.file{
	vertical-align:top;
	padding:0px;
}
.file a{
	color:;
	text-decoration:none;
}
.handle{
	height:3px;
	background-color:#333;
	background-image:url(<%=request.getContextPath()%>/images/main/StyleGray/leftmenuToggleHBg.jpg);
	cursor:row-resize;
	text-align:center;
}
#thumbBox{
	height:39px;
	text-align:right;
	background-image:url(<%=request.getContextPath()%>/images/main/thumbBoxBg.jpg);
	background-repeat:no-repeat;
}
#thumbBox img{margin-right:5px}
#rightArrow{cursor:hand}
</style>
<base target="mainframe"/>
</head>

<body>
<script language="javascript">
var FolderCount = <%=menubarNum+4%>;
function getXML(){
	dom.async = false;
	dom.loadXML('<%=xmlMenuBar.toString()%>');	
}
<%=xmlMenu.toString()%>
/*
function memorizeThumb(){
	var remainRows = Math.ceil((document.body.clientHeight-menuMargin-102)/23)-1;
	if(tbl.rows.length-4>remainRows){
		for(var i=1;i<=tbl.rows.length-4-remainRows;i++){
			if(tbl.rows.length>4){
				delRow();
			}
		}
	}else if(tbl.rows.length-4<remainRows){
		for(var i=1;i<=remainRows-(tbl.rows.length-4);i++){
			if(arrayFolder.length>currentThumbCount){
				addRow();
			}
		}
	}
}
*/

/*
==============================================
PopupMenu
==============================================
*/
var oPopup = window.createPopup();
function GetPopupCssText(){
	var styles = document.styleSheets;
	var csstext = "";
	for(var i=0; i<styles.length; i++){
		if (styles[i].id == "popupmanager")
			csstext += styles[i].cssText;
	}
	return csstext;
}

function showFav(){
	var popupX = 0;
	var popupY = 0;
	contentBox = document.getElementById("divFavContent");
	var o = event.srcElement;
	while(o.tagName!="BODY"){
		popupX += o.offsetLeft;
		popupY += o.offsetTop;
		o = o.offsetParent;
	}
	var oPopBody = oPopup.document.body;
	var s = oPopup.document.createStyleSheet();
	s.cssText = GetPopupCssText();
    oPopBody.innerHTML = contentBox.innerHTML;
	oPopBody.attachEvent("onmouseout",mouseout);

	//
	for(var i=0;i<oPopup.document.getElementsByTagName("TD").length;i++){
		if(oPopup.document.getElementsByTagName("TD")[i].getAttribute("menuid")!=null){
			oPopup.document.getElementsByTagName("TD")[i].onclick = function(){slideFolder(this);};
			oPopup.document.getElementsByTagName("TD")[i].onmouseover = function(){this.className='popupMenuRowHover';};
			oPopup.document.getElementsByTagName("TD")[i].onmouseout = function(){this.className='popupMenuRow';};
		}
	}

	oPopup.show(0, 0, 100, 0);
	var realHeight = oPopBody.scrollHeight;
	oPopup.hide();

	oPopup.show(popupX+20, popupY, 100, realHeight, document.body);
}

function mouseout(){
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
}
function redirect(url){
	window.open("<%=request.getContextPath()%>"+url);
}
function redirectMainFrame(url){
	parent.mainframe.location.href = "<%=request.getContextPath()%>"+url;
}
</script>

<table id="divMenuBox" style="width:100%;height:100%;border-top:2px solid #6F6F6F;border-bottom:2px solid #6F6F6F;" cellpadding="0" cellspacing="0">
<TR>
	<TD style="height:100%;padding:4px 0 4px 4px;background-image:url(<%=request.getContextPath()%>/images/main/StyleGray/leftmenuBoxBg.jpg);background-position:right;background-repeat:repeat-y"></TD>
	<td style="height:100%;width:5px;padding:0px 0 0px 0px;background-image:url(<%=request.getContextPath()%>/images/main/StyleGray/leftmenuToggleBg.jpg);text-align:center"><img src="/images/main/StyleGray/handleV.gif"/></td>
</TR>
</table>

<div id="divFavContent">
	<div class="popupMenu">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
		<tr height="25">
			<td class="popupMenuRow" onmouseover="this.className='popupMenuRowHover';" onmouseout="this.className='popupMenuRow';" id="popupWin_Menu_Setting">
				<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
					<tr>
						<td width="28">&nbsp;</td>
						<td onclick=""></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="3">
			<td>
				<div class="popupMenuSep"><img height="1px"></div>
			</td>
		</tr>
	</table>
	</div>
</div>

</BODY>
</HTML>
