<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/main/pubMain.jsp"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.util.NumberHelper" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.document.base.service.DocbaseService" %>
<%@ page import="com.eweaver.humres.base.service.StationinfoService" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService" %>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink" %>
<%@ page import="com.eweaver.base.security.util.PermissionUtil2" %>
<%@ page import="com.eweaver.external.IRtxSyncData" %>
<%@ page import="com.eweaver.attendance.service.AttendanceService" %>
<%@ page import="com.eweaver.attendance.model.Attendance" %>
<%@ page import="com.eweaver.base.menu.MenuDisPositionEnum"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.skin.SkinConstant"%>
<%@ page import="com.eweaver.base.skin.model.Skin"%>
<%@ page import="com.eweaver.base.skin.service.SkinService"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.eweaver.app.bbs.discuz.client.Client" %>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.app.bbs.discuz.util.XMLHelper" %>
<%@ page import="org.light.portal.core.service.PortalService"%>
<%@ page import="org.light.portal.core.entity.PortalTab"%>
<%@ page import="com.eweaver.portal.service.PortalorgService"%>
<%

//bbs单点登录
  Client client = new Client();
  Sysuser sysuser = new Sysuser();
  Sysuserrolelink sysuserrolelink  = new Sysuserrolelink();
  sysuser = sysuserService.getSysuserByObjid(currentuser.getId());
  String bbsusername = StringHelper.null2String(sysuser.getLongonname());
//-----------------登陆使用OA密码start----------------
//-----从Cookie中获取用户名和密码
  String usernameCookie=""; 
  String passwordCookie=""; 
  try{ 
  	Cookie[] cookies=request.getCookies(); 
  	if(cookies!=null){ 
  		for(int i=0;i<cookies.length;i++){ 
  			if(cookies[i].getName().equals("eweaveruser")){  
  				String cookiename_value = StringHelper.getDecodeStr(cookies[i].getValue());
	  			if(!StringHelper.isEmpty(cookiename_value)){
	  				String name=cookiename_value.split("-")[0];
					usernameCookie=name;
					if(cookiename_value.split("-").length>1)
						passwordCookie=cookiename_value.split("-")[1]; 
				}
  			} 
  		} 
  	} 
  }catch(Exception e){ 
  	e.printStackTrace(); 
  }
  client.uc_user_register(bbsusername,passwordCookie,"baidu@163.com");
  String result = client.uc_user_login(bbsusername, passwordCookie);
  //-----------------登陆使用OA密码end----------------
   PrintWriter pw = response.getWriter();
   String $ucsynlogin = "";
			LinkedList<String> rs = XMLHelper.uc_unserialize(result);
			if(rs.size()>0){
				int $uid = Integer.parseInt(rs.get(0));
				String $username = rs.get(1);
				String $password = rs.get(2);
				String $email = rs.get(3);
				if($uid > 0) {
					response.addHeader("P3P"," CP=\"CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR\"");
	
				    System.out.println("登录成功");
					System.out.println($username);
					System.out.println($password);
					System.out.println($email);
						
				 $ucsynlogin = client.uc_user_synlogin($uid);
			        //pw.write($ucsynlogin);
			        out.println($ucsynlogin);
				} else if($uid == -1) {
					System.out.println("用户不存在,或者被删除");
				} else if($uid == -2) {
					System.out.println("密码错");
				} else {
					System.out.println("未定义");
				}
			}
 %>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService");
MenuService menuService = (MenuService)BaseContext.getBean("menuService") ;
PermissionruleService permissionruleService = (PermissionruleService)BaseContext.getBean("permissionruleService") ;
DataService dataService = new DataService();

String userName = currentuser.getObjname();
String deptName = orgunitService.getOrgunitName(currentuser.getOrgid());

//重新查询一次humres，因为init.jsp中的currentuser在用户更改头像后并不能及时加载出imgfile(可能为null或者之前的图片)
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
Humres humres = humresService.getHumresById(currentuser.getId());

String ocsuserName=eweaveruser.getUsername();
String ocspassword=session.getAttribute("ocspassword")==null?"":session.getAttribute("ocspassword").toString();
//密码包含单引号处理
ocspassword = ocspassword.replaceAll("\'","\\\\\'");
//获取当前用户门户tab的名称
PortalService portalService = (PortalService)BaseContext.getBean("portalService");
String currentPortalTabName = portalService.getCurrentPortalTabName(request);

List isProtalAdminList = new ArrayList();
if(!isSysAdmin){
	List protalTempList = dataService.getValues("SELECT a.id,a.label FROM LIGHT_PORTAL_TAB a WHERE a.manageids LIKE '%"+currentuser.getId()+"%'");
	for(int i=0;i<protalTempList.size();i++){
		Map tempMap = (Map)protalTempList.get(i);
		String tempProtalId = StringHelper.null2String(tempMap.get("id"));
		isProtalAdminList.add(tempProtalId);
	}
}

%>
<html>
<head>
<title><%=labelService.getLabelName("402881eb0bcd354e010bcdc2b9f10023")%></title>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<link type="text/css" rel="stylesheet" href="/js/jquery/plugins/crselect/crselect.css"/> 
<script type="text/javascript" src="/js/jquery/plugins/crselect/crselect.js"></script>
<link rel="stylesheet" href="/js/jquery/plugins/ztree v3.x/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="/js/jquery/plugins/ztree v3.x/jquery.ztree.all-3.1.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/hoverIntent/jquery.hoverIntent.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/layout/jquery.layout-latest.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui-1.9m7/ui/minified/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/easing/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/mousewheel/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/cycle/jquery.cycle.all.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/mb.menu/inc/jquery.metadata.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/mb.menu/inc/mbMenu.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/jquery-ui-1.9m7/themes/base/minified/jquery-ui.min.css"/>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/mb.menu/css/mbmenu.css" media="screen" />
<script type="text/javascript" src="/js/jquery/plugins/contextMenu/jquery.contextMenu.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/contextMenu/jquery.contextMenu.css"/>
<script type="text/javascript" src="/js/jquery/plugins/qtip/jquery.qtip.min.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/qtip/jquery.qtip.min.css"/>
<script type="text/javascript" src="/js/main/eweaverTabs.js"></script>
<script type="text/javascript" src="/js/main/main.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/ocs/js/PEEIMUtil.js"></script>
<link rel="stylesheet" type="text/css" href="/css/main.css"/>
<% if(userMainPage.getIsUseSkin()){ //当前用户选择的首页是使用皮肤的%>
<link rel="stylesheet" type="text/css" id="main_css" href="<%=currentSkin.getBasePath() %>/<%=SkinConstant.MAIN_CSS_NAME %>"/> 
<% } %>
<jsp:include page="/main/pubLeftFrame.jsp"></jsp:include>
<script>
var cachedArrayMenu = null;
var currentPortalTabName = '<%=currentPortalTabName%>';
function controlPortalMenuDisplay(){
	if(cachedArrayMenu != null){
		var isVisible = $portalMenuContainer.is(":visible");
		if(isVisible){
			$portalMenuContainer.hide();
		}else{
			buildPortalMenuWithArrayData(cachedArrayMenu);
		}
	}else{
		buildPortalMenu();
	}
}

/**
 * 动态构建门户下拉菜单
 * @return {TypeName} 
 */
function buildPortalMenu(){
	var portalFrameId = getIframeIdByTabid(portalTabId);
	var pIframe = document.getElementById(portalFrameId);
	var w = pIframe.contentWindow;
	var a = {
        method: "post",
        postBody: "",
        onSuccess: function(b) {
            var jsonB = $.parseJSON(b.responseText);
            var arrayMenu = jsonB.portalMenu;
            buildPortalMenuWithArrayData(arrayMenu);
            cachedArrayMenu = arrayMenu;
        },
        on404: function(b) {
            alert('Error 404: location "' + b.statusText + '" was not found.')
        },
        onFailure: function(b) {
            alert("Error " + b.status + " -- " + b.statusText)
        }
    };
    w.Light.ajax.sendRequest(w.Light.portal.contextPath + w.Light.getPortalTabsByUserRequest, a)
}

var portalAdminArray = <%=isProtalAdminList.toString()%>;

function buildPortalMenuWithArrayData(arrayMenu){
	var portalFrameId = getIframeIdByTabid(portalTabId);
	var pIframe = document.getElementById(portalFrameId);
	var w = pIframe.contentWindow;
	
	$portalMenuContainer.html("");
    var $menu = $("<ul id='portalMenu'></ul>"); 
    $portalMenuContainer.append($menu);
           
	$.each(arrayMenu, function(i, tab){
       	if(tab.pid=="0"){//顶级门户
       		$menu.append("<li id='liTab"+tab.id+"'><a href='javascript:openTab("+tab.id+");void(0);'>"+tab.name+"</a></li>");	
       	}else{
			if(tab.pid==15){
				var _tabId = 15; 
				$("#liTab"+tab.pid).append("<ul id='ulTab"+tab.pid+"' pmenu='"+tab.pid+"' >");
				<%	
				List subprotalList = dataService.getValues("select id,objname from orgunit where isdelete=0 and typeid=\'4028804d2083a7ed012083ebb988005b\' order by dsporder");
				
				for(int i=0;i<subprotalList.size();i++){
					Map tempMap = (Map)subprotalList.get(i);
					String tempOrgId = StringHelper.null2String(tempMap.get("id"));
					String tempOrgName = StringHelper.null2String(tempMap.get("objname"));
					%>
					$("#ulTab"+tab.pid).append("<li id='liTab"+tab.id+"' ><a href='javascript:var tempProtalId=\"<%=tempOrgId%>\";openTab("+_tabId+",tempProtalId);void(0);' style='width:300px;'><%=tempOrgName%></a></li>");
					<%
				}
				%>
				$("#liTab"+tab.pid).append("</ul>");
			}
			else{
				if($("ul[pmenu='"+tab.pid+"'] li").length==0){
					$("#liTab"+tab.pid).append("<ul id='ulTab"+tab.pid+"' pmenu='"+tab.pid+"' ><li id='liTab"+tab.id+"' ><a href='javascript:openTab("+tab.id+");void(0);' style='width:200px;'>"+tab.name+"</a></li></ul>");
				}else{
					$("#ulTab"+tab.pid).append("<li id='liTab"+tab.id+"' ><a href='javascript:openTab("+tab.id+");void(0);'>"+tab.name+"</a></li>");
				}
			}
       	}
	});
	
  	<%if(isSysAdmin){%>
  		$menu.append("<li id='liTab_PortletConfig'><a href='javascript:void(0);' onclick='javascript:addPortletContent();'><span style='width:16px;height:16px;background:url(/images/silk/cog.gif) no-repeat;display:block;float:left;margin-right:3px;'></span>添加门户元素</a></li>");
  	<%}%>
	var currTabid = w.Light.getCookie(w.Light._CURRENT_TAB);
	if(currTabid != null && currTabid != "") {
		currTabid = currTabid.substring(8);
	}else{
		if(arrayMenu.length > 0){
			currTabid = arrayMenu[0].id;
		}else{
			currTabid = "";
		}
	}
	if(currTabid != ""){
		addClassFlagForCurrPortaltab("liTab"+currTabid);
	}
	

	<%if(!isSysAdmin){%>
		var liTab_PortletConfig = document.getElementById('liTab_PortletConfig');
		if(currTabid != ""&&!liTab_PortletConfig){
			portalAdminArray = <%=isProtalAdminList.toString()%>;
	  		for(var i=0;i<portalAdminArray.length;i++){
	  			if(currTabid==portalAdminArray[i]){
	  				$menu.append("<li id='liTab_PortletConfig'><a href='javascript:void(0);' onclick='javascript:addPortletContent();'><span style='width:16px;height:16px;background:url(/images/silk/cog.gif) no-repeat;display:block;float:left;margin-right:3px;'></span>添加门户元素</a></li>");
	  				break;
	  			}
	  		}
		}
	<%}%>
		
	$("#portalMenu").menu({
		select: function( event, ui ) {
			var link = ui.item.children( "a:first" );
			if(ui.item.attr("id") != "liTab_PortletConfig"){
				eweaverTabs.changeTabname(portalTabId, link.text());
			}
			if ( link.attr( "target" ) || event.metaKey || event.shiftKey || event.ctrlKey ) {
				return;
			}
			location.href = link.attr( "href" );
		}
	});
	$portalMenuContainer.show();
}

function addClassFlagForCurrPortaltab(currLiId){
	if(currLiId == ""){
		return;
	}
	var $portalMenu = $("#portalMenu");
	$("li a",$portalMenu).removeClass("currPortalTab");
	$("li a",$portalMenu).removeClass("ui-state-focus");
	$("#"+currLiId, $portalMenu).children( "a:first" ).addClass("currPortalTab");
	
	addClassFlagToParentPortaltab(currLiId);
	
	function addClassFlagToParentPortaltab(currLiId){
		var $currentUL = $("#"+currLiId, $portalMenu).parent();
		if($currentUL.attr("id") != "undefined" && $currentUL.attr("id") != "" && $currentUL.attr("id") != "portalMenu"){
			var $pPortaltab = $currentUL.parent();
			$pPortaltab.children( "a:first" ).addClass("ui-state-focus");
			addClassFlagToParentPortaltab($pPortaltab.attr("id"));
		}
	}
}

function entry(){
	<%if("".equals(ocspassword)){%>
		alert("无法获取OCS密码，请重新登录系统！");
	<%}else{%>
		PEEIM.RunEim('<%=ocsuserName%>','<%=ocspassword%>');
	<%}%>
}
</script>
</head>
<body id="mybody">
<input type="hidden" id="isNewSkin" value="1">
<input type="hidden" id="isSysAdmin" <%if(isSysAdmin){%>value="1"<%}else{%>value="0"<%} %>>
<div id="hideDiv" style="position: absolute; left: 0px; top: 0px;">
	<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC='/blank.htm' style="margin: 0;padding: 0;"></iframe>
	<input type="hidden" id="currentUserId" value="<%=currentuser.getId() %>"/>
	<input type="hidden" id="isHideMainPageLeft" value="<%=currentSkin.getIsHideMainPageLeft() %>"/>
</div>
<div id="tabMore">
	<ul>
	</ul>
</div>
<div id="header">
	<% 
		String topMenuClassName;
		List<Menu> topMenuList = menuorgService.getMenuByOrgSetting2(null,MenuDisPositionEnum.top,null); 
		if(topMenuList.isEmpty()){
			topMenuClassName = "noData";
		}else{
			topMenuClassName = "hasData";
		}
	%>
	<div class="top">
		
	</div>
	
	<div id="topMenuPrev" title="向前滚动菜单" style="display: none;"></div>
	<div id="topMenuNext" title="向后滚动菜单" style="display: none;"></div>
	<div class="topMenu <%=topMenuClassName %>">
       <table class="rootVoices" cellspacing='0' cellpadding='0' border='0' style="position: absolute;">
	        <tr>
	          <%
	          	StringBuilder topMenuStrBuilder = new StringBuilder();
	          	for(int i = 0; i < topMenuList.size(); i++){
	          		Menu topMenu = topMenuList.get(i);
	          		String menuname = labelCustomService.getLabelNameByMenuForCurrentLanguage(topMenu);
	          		if(topMenu.getChildrennum() > 0){
	          			topMenuStrBuilder.append("<td class=\"rootVoice {menu: '"+topMenu.getId()+"'}\" >"+menuname+"</td>");
	          		}else{
	          			topMenuStrBuilder.append("<td class=\"rootVoice {menu: 'empty'}\" onclick=\"onTabUrl('"+topMenu.getUrl()+"','"+menuname+"','"+topMenu.getId()+"',true);\">"+menuname+"</td>");
	          		}
	          		
	          	}
	          %>
	          <%=topMenuStrBuilder.toString() %>
	        </tr>
       </table>
	</div>
	<div class="topVersion">Version: <%=dataService.getValue("select verno from versioninfo") %></div>
	<div class="optButton">
		<ul>
			<%if(isSysAdmin){%>
				<li><span class="admin" title="开发" onClick="toBackground();"><label>开发</label></span></li>
			<%} %>
			<%if ("1".equals(isOpenIM) && sysuser.getIsopenim() == 1) {%>
				<li><span id="tdMessageState" title="IM" style="cursor:pointer;font-size:11px;color:#666;position:relative;"></span></li>
			<%} %>
			<%if("402883b530490dcb013049963a2b0038".equals(humresService.getIMMessageType())){%>
				<li><span class="rtx" title="RTX" onclick="RtxSessionLogin();"><label>RTX</label></span></li>
			<%} %>
			<%if("402883b530490dcb013049963a2b0039".equals(humresService.getIMMessageType())){%>
				<li><span class="ocs" title="OCS" onclick="entry();"><label>OCS</label></span></li>
			<%} %>
			<%
			if("1".equals(attendanceService.getAttendanceViewAttendbtn())){ 
				String attendanceText = (attendanceService.getTodayAttendance(Attendance.ATTENDANCE_IN)==null)?labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30023"):labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30024");
			%>
				<li><span class="sign" title="<%=attendanceText%>" onclick="AttendanceIn(document.getElementById('attendanceBtn'));"><label id="attendanceBtn"><%=attendanceText%></label></span></li><!-- 签到 --><!-- 签退 -->
			<%}%>
			<!-- <li><span class="changePwd" title="修改密码"><label>修改密码</label></span></li> -->
			<li><span class="refresh" title="刷新"><label>刷新</label></span></li>
		
			<li><span class="setSkin" title="皮肤设置"><label>皮肤</label></span></li>
			<!--<li><span class="activeXTest" title="<%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0000")%> "><label><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0000")%> </label></span></li> -->
			<li><span class="exit" title="退出"><label>退出</label></span></li>
			<li><span class="split"></span></li>
			<li><span class="about" title="关于"><label>关于</label></span></li>
		</ul>
	</div>
	<div class="logo"></div>
	<div class="search">
		<%if(!StringHelper.isEmpty(serachOptionHtml)){%>
			<div class="searchtype">
				<select id="searchtype" name="searchtype">
				<%=serachOptionHtml %>
				</select>
			</div>
		<%}%>
		<div class="searchcontent" <%if(StringHelper.isEmpty(serachOptionHtml)){%>style="display:none;"<%}%>>
			<span class="searchSplit"></span>
			<input type="text" name="objname" id="objname"/>
		</div>
		<div class="searchbutton" onclick="javascript:quickSearch();" <%if(StringHelper.isEmpty(serachOptionHtml)){%>style="display:none;"<%}%>>
			<span class="searchSplit"></span>
		</div>
	</div>
	<div id="headerTabs">
		<ul>
			<li class="more"><a href="javascript:showOrHideMoreTabs();"><p></p></a></li>
		</ul>
	</div>
	<div class="bottom"></div>
	<%
		/*一级菜单*/
		List menuList = menuorgService.getMenuByOrgSetting2(null,MenuDisPositionEnum.left,null);
		//移除系统设置菜单(不管是不是系统管理员)
		int deleteIndex = -1;
		for(int i = 0; i < menuList.size(); i++){
			Menu menu = (Menu)menuList.get(i);
			if(menu.getId().equals("4028808e13e143670113e1aab8a6000c")){	//系统设置
				deleteIndex = i;
				break;
			}
		}
		if(deleteIndex != -1){
			menuList.remove(deleteIndex);
		}
		
		//判断当前用户是否拥有管理控制台的权限
		boolean isHaveConsolePerms = permissionruleService.checkUserPerms(currentuser.getId(), "402881dc0d7cf641010d7cfb03d10016");
		if(isSysAdmin || isHaveConsolePerms){
			Menu sysMenu = menuService.getMenu("4028808e13e143670113e1aab8a6000c");
			menuList.add(sysMenu);
		}
	%>
	<div class="topMenuDiv">
		<!--  iframe src="" style="filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';filter:alpha(opacity=0);opacity:0;position:absolute; visibility:inherit; top:20px; left:0px; width:100%; height:100%; z-index:-1; ">
		</iframe -->
		<div class="topMenuDiv_top">
			<div id="divFloatBg"></div>
			<%
			if (currentSkin.getId().equals("05A99452DB75D2D6E050007F010041B7")){
				for(int i=0;i<menuList.size();i++){
					Menu menu = (Menu)menuList.get(i);
					String menuName = labelCustomService.getLabelNameByMenuForCurrentLanguage(menu);
			%>
						<div class="menuItem"  onClick="javascript:changeLoadLeftMenuTreeData('<%=menu.getId()%>')" title="<%=menuName%>">
							<!--<DIV class="menuItemIcon" style="background-position:-37 -111;"><img src="<%=menu.getImgfile()%>" style="width:32px;height:32px;"/></DIV>-->
							<DIV class="slideItemText"><%=menuName%></DIV>
						</div>
			<%}}%>
		</div>
		<div style="cursor:pointer;width:27px;height:55px;float:left;position:relative;top:5px;left:15px;" id="topMenuContr" style="" class="menuNavSpan_Expand"></div>
		</div>
<!-- For slide-->
<script type="text/javascript" src="/ecology/wui/common/jquery/plugin/jquery.cycle.all.js"></script>
<script type="text/javascript" src="/ecology/wui/common/jquery/plugin/jquery.easing.js"></script> 
<script language="javascript">

//顶部菜单最大高度
var TOP_MENU_MAX_HEIGHT = "210";   
jQuery(document).ready(function(){
	//导航块移动
    jQuery(".menuItem").hover(function() {
    	topMenuNavMove(this);
    }, function(){});
    //菜单展开或者收缩
    jQuery("#topMenuContr").bind("click", function() {
    	if (jQuery(".topMenuDiv").height() > 70) {
    		jQuery(this).removeClass("menuNavSpan_Contraction");
    		jQuery(this).addClass("menuNavSpan_Expand");
    		topMenuContraction();
    	} else {
    		jQuery(this).removeClass("menuNavSpan_Expand");
    		jQuery(this).addClass("menuNavSpan_Contraction");
	        topMenuExpand();
	    }
    });
    
    //光标不在菜单区域时，如果菜单时展开的则收缩。
    jQuery(".topMenuDiv").hover(function() {}, function() {
    	if (jQuery(".topMenuDiv").height() > 70) {
	    	topMenuContraction();
	    }
    });
});

function topMenuNavMove(_this) {
    $this=jQuery(_this);
    jQuery("#divFloatBg").show();
    jQuery("#divFloatBg").each(function(){jQuery.dequeue(this, "fx");}).animate({                
        top: $this.position().top -0,
        left: $this.position().left+5
    },600, 'easeOutExpo');
}

/**
* 菜单收缩
*/
function topMenuContraction() {
	jQuery("#topMenuContr").removeClass("menuNavSpan_Contraction");
    jQuery("#topMenuContr").addClass("menuNavSpan_Expand");
   	
	jQuery(".topMenuDiv").each(function() {jQuery.dequeue(this, "fx")}).animate({
		height:56
	} , 0);
	if (jQuery("#divFloatBg").offset().top >= 67 ) {
	    jQuery("#divFloatBg").hide();
	}
	jQuery(".topMenuDiv").css("background", "").css("z-index", "");
}

/**
* 菜单展开
*/
function topMenuExpand() {
	jQuery(".topMenuDiv").css("background", "url(/css/skins/skin1/images/menu_expand_bg.png)  ");
	//jQuery(".topMenuDiv").css("background-position","0 -72");
	jQuery(".topMenuDiv").css("background-repeat","no-repeat").css("z-index", "999");
	jQuery(".topMenuDiv").each(function() {jQuery.dequeue(this, "fx")}).animate({
   		height: TOP_MENU_MAX_HEIGHT
   	} , 0);
}

/**
* 点击菜单项时触发，会统计菜单点击的次数，并打开子项（左侧）
*/
function clickstatictics(_this) {
	topMenuContraction();

	//jQuery(".slideDivHidden").hide();//animate({opacity: "hide", height: "hide"}, 0);
	dymlftenu(_this);
	var ajaxUrl = "/ecology/wui/theme/ecology7/page/topMenuClickStatictics.jsp";
	ajaxUrl += "?mid=";
	ajaxUrl += jQuery(_this).attr("levelid");
	ajaxUrl += "&token=";
	ajaxUrl += new Date().getTime();
	
	jQuery.ajax({
	    url: ajaxUrl,
	    dataType: "text", 
	    contentType : "charset=gbk", 
	    error:function(ajaxrequest){alert("error");}, 
	    success:function(content){
	    }  
    });
}
</script>
</div>
<table width="100%">
	<tr>
		<td valign="top" id="menuTD">
			<%
				String menuTopClass = "ui-layout-north";
				String menuCenterClass = "ui-layout-center";
				String menuBottomClass = "ui-layout-south";
				if(currentSysModeIsWebsite){ //网站模式
					menuTopClass = "";
					menuCenterClass = "";
					menuBottomClass = "";
				}
			%>
			<div id="menu">
				<div id="menuContainer">
					<div id="menuTop" class="<%=menuTopClass %>">
						<span class="avator" onclick="onUrl('/humres/base/humresinfo.jsp?id=<%=currentuser.getId() %>','个人信息','tab402880ca16378f05011637978e6a0002');">
							<%if(!StringHelper.isEmpty(humres.getImgfile())){ //已上传头像%>	
								<img src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=humres.getImgfile() %>"/>
							<%}%>
						</span>
						<span class="avatorTitle">
							<b><a href="javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=currentuser.getId() %>','个人信息','tab402880ca16378f05011637978e6a0002');"><%=userName%></a></b>
							<%if(currUserIsCanSwitchAccount){%>
							<span id="quickSwitchAccount" title="帐号切换">(帐号切换)</span>
							<%}%>
							<br/>
							<a href="javascript:onUrl('/base/orgunit/orgunitview.jsp?reftype=402881e510e8223c0110e83d427f0018&id=<%=currentuser.getOrgid() %>','部门信息','tab<%=currentuser.getOrgid() %>');"><%=deptName%></a>
						</span>
						<div class="menuSplit"></div>
					</div>
					<div id="menuCenter" class="<%=menuCenterClass %>">
						<ul id="leftMenuTree" class="ztree"></ul>
						<div class="menuLoading">Loading...</div>
					</div>
					
					<div id="menuBottom" class="<%=menuBottomClass %>" <%if(currentSysModeIsSoftware){ %> style="display: none;" <%} %>>
						<div class="levelMenu">
							<%
					
								
								StringBuilder menuStrBuilder = new StringBuilder();
								String defaultPMenuId = null;
								for(int i = 0; i < menuList.size(); i++){	
									Menu menu = (Menu)menuList.get(i);	
									String menuName = labelCustomService.getLabelNameByMenuForCurrentLanguage(menu);
									if(i == 0){
										defaultPMenuId = menu.getId();
										menuStrBuilder.append("<ul>");
									}else if(i % 7 == 0){
										menuStrBuilder.append("</ul>").append("<ul>");
									}
									menuStrBuilder.append("<li><a href=\"javascript:changeLoadLeftMenuTreeData('"+menu.getId()+"')\"><p id=\"pTag"+menu.getId()+"\"><span class=\"icon\"><img src=\""+skinService.getMenuImgWithSkin(menu, userMainPage, currentSkin)+"\" align=\"top\"/></span><span class=\"text\">"+menuName+"</span></p></a></li>");
									if(i == (menuList.size() -1)){
										menuStrBuilder.append("</ul>");
									}
							%>
							<% } %>
							
							<%=menuStrBuilder.toString() %>
						</div>
						<!-- 页面加载后默认显示的菜单id和名称 -->
						<input type="hidden" id="defaultPMenuId" value="<%=StringHelper.null2String(defaultPMenuId) %>"/>
						<div class="menuSplit"></div>
					</div>
				</div>
				<div id="menuHandler">
					<div class="nav">
						<ul>
						</ul>
					</div>
					<div class="next"></div>
					<div class="menuSplit"></div>
				</div>
			</div>
		</td>
		<td id="rightTD" valign="top">
			<div id="rightDiv">
				<!-- 
					levelSplitFlag 和  verticalSplit 为两个标记元素，当鼠标移动到这两个元素上时，会显示出展开和收缩标记。
					 (未使用body的mousemove是因为那样会引起“鼠标移开文档，文档会抖动”的问题)
				-->
				<div class="levelSplitFlag"></div>
				<!--<div class="verticalSplitFlag"></div>  -->
				<div class="levelSplit"></div>
				<div class="verticalSplit"></div>
				<div id="content">
				</div>
				<div class="loading">页面加载中，请稍候...</div>
			</div>
		</td>
	</tr>
</table>
<div id="footer">
	<div class="copyright">Copyright © 2001-2012 Weaver Software All Rights Reserved.</div>
</div>
<div id="skinChoose" style="display: none;width: 0px;height: 0px;">
	
</div>

<div id="portalMenuContainer"></div>

<ul id="tabRightMenu" class="contextMenu">
	<li class="close"><a href="#close">关闭</a></li>
	<li class="closeOthers"><a href="#closeOthers">关闭其它选项卡</a></li>
	<li class="closeAll"><a href="#closeAll">关闭所有选项卡</a></li>
	<li class="refresh separator"><a href="#refresh">刷新</a></li>
</ul>

<!-- 签到 签退的iframe -->
<iframe id="msgFrame" frameborder="0" src="about:blank" style="display:none;position:absolute;"></iframe>
<!-- RTX的iframe -->
<iframe id="rtx" name="rtx" frameborder="0" src="about:blank" style="display:none;position:absolute;"></iframe>

<jsp:include flush="true" page="/app/birthday/rebirthday.jsp"></jsp:include>
<%if ("1".equals(isOpenIM) && sysuser.getIsopenim() == 1) {%>
<%@ include file="/messager/join.jsp" %>
<%} 

%>
</body>
</html>
<script>
function toBackground()
{
	window.open("/admin/main.jsp");
}
</script>