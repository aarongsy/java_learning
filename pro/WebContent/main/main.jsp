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
<%@ page import="com.eweaver.base.util.StringEncode" %>
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
<%@page import="com.eweaver.base.menu.MenuDisPositionEnum"%>
<%@page import="com.eweaver.base.menu.model.*"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.eweaver.app.bbs.discuz.client.Client" %>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.app.bbs.discuz.util.XMLHelper" %>
<%
//bbs单点登录
  Client client = new Client();
  Sysuser sysuser_bbs = new Sysuser();
  sysuser_bbs = sysuserService.getSysuserByObjid(currentuser.getId());
  String bbsusername = StringHelper.null2String(sysuser_bbs.getLongonname());
//-----------------登陆使用OA密码start----------------
//-----从Cookie中获取用户名和密码
  String usernameCookie=""; 
  String passwordCookie=""; 
  try{ 
  	Cookie[] cookies=request.getCookies(); 
  	if(cookies!=null){ 
  		for(int i=0;i<cookies.length;i++){ 
  			if(cookies[i].getName().equals("eweaveruser")){  
  				String name=StringHelper.getDecodeStr(cookies[i].getValue().split("-")[0]);
				usernameCookie=name;
				if(cookies[i].getValue().split("-").length>1){
					passwordCookie = cookies[i].getValue().split("-")[1]; 
					passwordCookie = StringEncode.decrypt(passwordCookie);
				}				
  			} 
  		} 
  	} 
  }catch(Exception e){ 
  	e.printStackTrace(); 
  }
  String sss = client.uc_user_register(bbsusername,passwordCookie,"baidu@163.com");
  String result = client.uc_user_login(bbsusername, passwordCookie);
  //-----------------登陆使用OA密码end----------------
   PrintWriter pw = response.getWriter();
   String $ucsynlogin = "";
	LinkedList<String> rs = XMLHelper.uc_unserialize(result);
	try{
		if(rs.size()>0){
			int $uid = Integer.parseInt(StringHelper.null2String(rs.get(0)));
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
	}catch(Exception e){ 
  		e.printStackTrace(); 
  	}
	
 %>
<%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

request.getSession(true).setAttribute("eweaveruser",eweaveruser);
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
MenuService menuService = (MenuService)BaseContext.getBean("menuService") ;
MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService") ;
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
StationinfoService stationService= (StationinfoService) BaseContext.getBean("stationinfoService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");

String currentdate = DateHelper.getCurrentDate();
String initpage;
String orgunitid=currentuser.getOrgid();                         
Orgunit orgunit=orgunitService.getOrgunit(orgunitid);
initpage = request.getContextPath()+"/portal.jsp";
// 是否系统管理员
SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService) BaseContext.getBean("sysuserrolelinkService");
boolean issysadmin = false;
String humresroleid = "402881e50bf0a737010bf0a96ba70004";//系统管理员角色id
Sysuser sysuser = new Sysuser();
Sysuserrolelink sysuserrolelink  = new Sysuserrolelink();
sysuser = sysuserService.getSysuserByObjid(currentuser.getId());
issysadmin = sysuserrolelinkService.isRole(humresroleid,sysuser.getId());

String ocsuserName=eweaveruser.getUsername();
String ocspassword=session.getAttribute("ocspassword")==null?"":session.getAttribute("ocspassword").toString();
%>
<html>
<head>
<style>
.x-toolbar{background:url();border:0;}
</style>
<title><%=labelService.getLabelName("402881eb0bcd354e010bcdc2b9f10023")%></title>

<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/ocs/js/PEEIMUtil.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/hoverIntent/jquery.hoverIntent.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/qtip/jquery.qtip.min.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/qtip/jquery.qtip.min.css"/>

<link rel="stylesheet" type="text/css" href="/css/main.css"/>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
	var isCheckUsb = <%=isCheckUsb%>;
	var isSwitchState = <%=isSwitchState%>;
	Ext.onReady(function() {
	      //Ext.QuickTips.init();
	      
	 if(isCheckUsb && !isSwitchState) {
	 	loadUsbObject();
	 	window.setInterval("ValidateUsb()",1000);
	 }     
	//顶部菜单生成
	var tbmenu = new Ext.Toolbar();
    tbmenu.render('topmenu');
    <%
    StringBuffer sb = new StringBuffer();
    List menuList2 = menuorgService.getMenuByOrgSetting2(null,MenuDisPositionEnum.top, null);
    List<Menu> cacheMenuList = menuorgService.getAllUserMenu(true);
    for(int i=0;i<menuList2.size();i++){
    	Menu menu = (Menu)menuList2.get(i);
    	String menuname = labelCustomService.getLabelNameByMenuForCurrentLanguage(menu);
    	sb.append("tbmenu.add({text:'"+menuname+"'");
    	sb.append(menuorgService.getExtMenu(menu.getId(), cacheMenuList));
    	sb.append("});");
    }
    out.println(sb);
    %>
    	initQtipForButton();
	 });
	
function entry(){
	<%if("".equals(ocspassword)){%>
		alert("无法获取OCS密码，请重新登录系统！");
	<%}else{%>
		PEEIM.RunEim('<%=ocsuserName%>','<%=ocspassword%>');
	<%}%>
}
function hideTopMenuWhenMouseout(m){
	var t = $(".x-menu").offset().top; 
	var l = $(".x-menu").offset().left; 
	$(".x-menu").mouseout(function(event){
		var t = $(this).offset().top;
		var l = $(this).offset().left; 
		var h = $(this).outerHeight() - 2;
		var w = $(this).outerWidth() - 2;
		if(event.pageX < (l) || event.pageX > (l + w) || event.pageY < t || event.pageY > (t + h)){
			m.hide();
		}
	});
}
function initQtipForButton(){
	var $btns = $("#toolbarTD").children("span.forQtip");
	$btns.qtip({
		content: {
			attr : 'title'
		},
		position: {
			my: 'top center', 
      		at: 'bottom center',
      		adjust : {
      			x: 0,
      			y: 5
      		}
		},
		style: {
			classes: 'optButtonQtip'
		},
		show: {
            effect: function() {
                $(this).fadeTo(500, 1);
            }
        }
	});
}
</script>
</head>
<BODY id="mybody" style="margin:0;padding:0;overflow-y:hidden" onload="init();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(/images/main/top_bg_<%=style%>.jpg)">
	<tr id="main_top"><td colspan="4"> 
		<div id="logo"></div>
		<div id="right" style="height: 20px"></div> 
	</td></tr>
	<tr><td id="main_toolbar" align="right" <%if(language.equals("zh_CN")){ %> style="padding: 0 0 0 190px;<%if(!StringHelper.isEmpty(serachOptionHtml)){%>width:300;<%}else{%>width:120;<%}%>"<%}else{ %>style="padding: 0 0 0 200px;<%if(!StringHelper.isEmpty(serachOptionHtml)){%>width:300;<%}else{%>width:120;<%}%>"<%} %>>
		<table <%if(language.equals("zh_CN")){ %> width="90%" <%}else{ %> width="100%" <%} %> border="0" style="margin: 0;padding: 0">
			<tr> 
				<td >
					<span onclick="javascript:doRefresh();" title="<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027") %>"><!-- 刷新 --><img src="/images/silk/arrow_refresh.gif"/></span>
				</td>
				<td>
					<span id="hidemenuSpan" onclick="javascript:hideMenu();" title="<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003") %>"><!-- 隐藏 --><img src="/images/silk/application_split.gif"/></span>
				<td>
					<span onclick="javascript:hideLeftMenu();" title=""><img src="/images/silk/application_side_list.gif"/></span>
				</td>
				<td>
					<span class="separator"></span>
				</td>
				<%if(!StringHelper.isEmpty(serachOptionHtml)){%>
				<form id="quicksearch" name="quicksearch" method="post" action="" onsubmit="return false">
					<td >
						<select id="searchtype" name="searchtype" <%if(language.equals("zh_CN")){ %> style="width: 80px"<%}else{ %> style="width: 120px"<%} %> nowrap>
							<%=serachOptionHtml %>
				        </select>
	       			</td>
			        <td>
						<input type="text" name="objname" id="objname" <%if(language.equals("zh_CN")){ %> style="width:100px;padding:0" <%}else{ %> style="width:90px;padding:0"  <%} %>onmouseover="javascript:this.select();" />
					</td>
				</form>
				<td>
					<span style="padding-top: 3px" class="search" onclick="javascript:quickSearch();" title="<%=labelService.getLabelName("搜索") %>"><!--  -->
						<img src="/images/main/searchbutton.png" />
					</span>
				</td>
				<%}%>
			<td>
			<%if("1".equals(attendanceService.getAttendanceViewAttendbtn())){ %>
			<button type="button" id="attendanceBtn" onclick="AttendanceIn(this);"  style="width:50px;padding:0px;cursor: pointer;"> <%=(attendanceService.getTodayAttendance(Attendance.ATTENDANCE_IN)==null)?labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30023"):labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30024")%></button><!-- 签到 --><!-- 签退 -->
		<%}%></td>
			</tr>
		</table>
		</td>
		<td id="topmenu" width="*"></td>
		<td width="170px" style="text-align:right;padding: 0 10px 0 0;">
			<%=labelService.getLabelName("欢迎您") %>: <%=username%><!-- 欢迎您 -->
			<%if(currUserIsCanSwitchAccount){%>
			<span id="quickSwitchAccount" title="帐号切换">(帐号切换)</span>
			<%}%>
		</td>
		<td width="140" align="right" style="padding-right: 15px;" id="toolbarTD">
		<%
		  if ("1".equals(isOpenIM) && sysuser.getIsopenim() == 1) {
		 %>
		<span class="forQtip" title="IM" id="tdMessageState" style="cursor:pointer;font-size:11px;color:#666;position:relative;"></span>
		<%} %>
		<%if("402883b530490dcb013049963a2b0038".equals(humresService.getIMMessageType())){%>
			<span class="forQtip" width=20px title="rtx"><img style="cursor:pointer;" onclick="javascript:RtxSessionLogin();" src="/images/silk/group.gif" width="16" height="16"/></span>
		<%}%>
		<%if("402883b530490dcb013049963a2b0039".equals(humresService.getIMMessageType())){%>
			<span class="forQtip" width=20px title="启动OCS"><img style="cursor:pointer;"  onclick="javascript:entry();" src="/images/silk/comments.gif" width="16" height="16"/></span>
		<%}%>
		
		<span class="forQtip" onclick="javascript:openactiveXChooseDialog();" title="<%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0000")%> " style="cursor: hand;"><img src="/images/silk/table_connect.gif"/></span><!-- 插件检测 -->
		
		<span class="forQtip" onclick="javascript:openSkinChooseDialog();" title="皮肤设置" style="cursor: hand;"><img src="/images/silk/images.gif" style="color: hand;"/></span>
		<span class="forQtip" onclick="javascript:openwinlics();" title="<%=labelService.getLabelNameByKeyId("ECF2041D912C4D93AE6FBA002676DDEF") %>" style="cursor: hand;"><img width="16" height="16" src="/images/silk/help.gif"/></span>
		<span class="forQtip" onclick="javascript:logOff();" title="<%=labelService.getLabelNameByKeyId("ADE1D73F390248C7B661B47BD31F06D3") %>" style="cursor: hand;"><img src="/images/silk/monitor_go.gif"/></span>
		</td>
	</td>
	</tr>
	<tr><td colspan="4">
		<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC='/blank.htm'></iframe>
		<iframe id="leftFrame" name="leftFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" scrolling="NO" src="leftFrame.jsp"></iframe>
		<iframe id="msgFrame" frameborder="0" src="about:blank" style="display:none;position:absolute;"></iframe>
		<iframe id="rtx"  name="rtx"  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" scrolling="NO" style="display:none;position:absolute;" SRC=''></iframe>
	</td></tr>
</table>
<div id="skinChoose" style="display: none;">
</div>
<%if ("1".equals(isOpenIM) && sysuser.getIsopenim() == 1) {%>
<%@ include file="/messager/join.jsp" %>
<%} %>
<script language="javascript" type="text/javascript">
var fillins='<%=fillins%>';
function init(){
	
}
function loadUsbObject(){
	var myObject = document.createElement('object');
	document.getElementById("mybody").appendChild(myObject);
	myObject.setAttribute('id','htactx');
	myObject.setAttribute('name','htactx');
	myObject.setAttribute('codebase','/plugin/HTActX.cab#version=1,0,0,1');
	myObject.classid= "clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E";
}
function switchSysAdmin(obj) {
	window.location.href="/ServiceAction/com.eweaver.base.security.servlet.SwitchSysAdminAction?id="+obj;
}
function goMainFrame(o){
    alert("show portal!!!");
	o.contentWindow.document.frames[1].document.location.href = "<%=initpage%>";
}
function hideMenu(){//顶部菜单显示、隐藏
	if(main_top.style.display==""){
		main_top.style.display="none";
		document.getElementById("hidemenuSpan").title="<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %>";//显示
	}else{
		main_top.style.display="";
		document.getElementById("hidemenuSpan").title="<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003") %>";//隐藏
	}
	resizeIframePortal();
}
function hideLeftMenu(){
	var o = top.frames[1].accordion;
	if(o.collapsed){o.expand();}else{o.collapse();}
}
function toolBarRefresh(){
	try{
		document.getElementById("leftFrame").contentWindow.document.getElementById("mainframe").contentWindow.document.location.reload();
	}catch(exception){}
}
function toolBarFavourite(){ //收藏夹
	if( typeof(document.getElementById("leftFrame").contentWindow.document.frames[1].contentWindow) == undefined ){
		alert("<%=labelService.getLabelName("该页面不可收藏")%>");
		return false;
	}
	var o = document.getElementById("leftFrame").contentWindow.document.frames[1].document.all("btnFav");
	if(o!=null)	o.click();
}
function quickSearch(){
    var _objvalue = document.all("objname").value;
    var select=document.quicksearch.searchtype.options;
    var param;
    var selectText;
    for(var i=0;i<select.length;i++){
        if(select[i].selected==true){
            param=select[i].value;
            selectText=select[i].text;
        }
    }
    var temparr = param.split(';');
    var reportid=temparr[0];
    var field=temparr[1];
    var viewtype=temparr[2];
    if(fillins.indexOf(reportid)>-1){
        if(_objvalue==''){
        top.frames[1].pop('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30025") %>');//请输入查询条件
        return;
        }
    }
    if(field.indexOf(",")>-1){
        var tableName=field.substring(field.indexOf(",")+1);
        field=field.substring(0,field.indexOf(","));
        if("humres"==tableName){
            document.quicksearch.action = contextPath+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&sysmodel=1&reportid="+reportid+"&con"+field+"_value="+_objvalue;
        }else if("docbase"==tableName){
            document.quicksearch.action = contextPath+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&sysmodel=1&reportid="+reportid+"&con"+field+"_value="+_objvalue;
        }
    }else{
        document.quicksearch.action = contextPath+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase="+viewtype+"&reportid="+reportid+"&con"+field+"_value="+_objvalue;
    }
    document.getElementById("leftFrame").contentWindow.onUrl(document.quicksearch.action,selectText,'qs'+reportid);
}
function doBack(){
    document.getElementById("leftFrame").contentWindow.doBack();
}
function doForward(){
    document.getElementById("leftFrame").contentWindow.doForward();
}
function doUrl(url){
	if(url != ""){
		document.getElementById("leftFrame").contentWindow.document.getElementById("mainframe").src = url;
	}
}
function doRefresh(){
    document.getElementById("leftFrame").contentWindow.doRefresh();
}
function closewinie7(){
  var n = window.event.screenX - window.screenLeft;
  var b = n > document.documentElement.scrollWidth-20;
  if(b && window.event.clientY < 0 || window.event.altKey)
  {
    //alert('close');
    top.location.href="/main/closewin.jsp";
  }else{
    //alert('refresh');
  }
}
function closewinie6(){
	//alert(window.screenLeft+":::"+window.screenTop);
	if(window.screenLeft>=10000&&window.screenTop>=10000){
		  top.location.href="/main/closewin.jsp";
	}
}

var GObject={
	_callback:null,
	oFrame:null
};//需要用全局变量保存不每次调用的对象
var ExtWidnow={
	object:null,
	open:function(url,_call){
		var _this=this;
		if(!this.object){
		this.object = new Ext.Window({
        	el:'hello-win',
            layout:'fit',
            html:'<iframe id="winIframe" src="/blank.htm" frameborder="0" width="100%" height="100%"></iframe>',
            modal:true,
            width:600,
            height:400,
            closeAction:'hide',
            plain: true,
            buttons: [{text:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>',handler:function(){_this.ok(_this);}},//确定
				{text:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>', handler: function(){_this.object.hide();}}//取消
				]
		});
		}
		GObject._callback=_call;
		this.object.show();
		if(!GObject.oFrame) GObject.oFrame=document.getElementById('winIframe');
		GObject.oFrame.src=url;
		return this.object;
	},
	ok:function(obj){
		var win=GObject.oFrame.contentWindow;
		var ret=GObject._callback(win);
		//if(ret) GObject.oFrame.src="about:blank";
		obj.object.hide();
	}
};

function initrtx(){
	var obj=document.getElementById("RTXAX");
	//alert(obj);
	RTXCRoot=null;
	RTXCRoot = obj.GetObject("KernalRoot");
	strSessionKey=getstrSessionKey()
}

var RTXCRoot = null;
var strSessionKey = null;

function getstrSessionKey() {	
	var url = '/ServiceAction/com.eweaver.external.RTXAction?action=getstrSessionKey';
	jQuery.ajaxSetup({async: false});
	var params = {};
	var strSessionKey = "";
	jQuery.post(url,params,function(data){
		strSessionKey = data;
	});
	return strSessionKey;
}

function resizeIframePortal(){
	var a = top.frames[1].contentPanel.items.get(0).getFrame();
	if(a&&a.dom){
		a.dom.style.padding = "0";
	}
}
if(window.attachEvent){//IE   
	window.attachEvent("onresize",resizeIframePortal);
}
function retryUsb() {
	if(confirm("<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40028") %>")) {//请插入USBKey,是否重试?
		ValidateUsb();
	} else {
		location.href="<%=request.getContextPath()%>/main/logout.jsp"
	}
}
var skinChooseDialog;
function openSkinChooseDialog(){
	skinChooseDialog = new Ext.Window({
        layout:'border',
        closeAction:'hide',
        plain: true,
        modal :true,
        items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }]
    });
    skinChooseDialog.render(Ext.getBody());
	var url='/main/skinchoose.jsp';
    skinChooseDialog.setTitle('皮肤设置');
    skinChooseDialog.setWidth(805);
    skinChooseDialog.setHeight(500);
    skinChooseDialog.getComponent('commondlg').setSrc(url);
    skinChooseDialog.show();
}
function closeSkinChooseDialogAndToTargetUrl(targetUrl){
	if(skinChooseDialog){
		skinChooseDialog.hide();
		toTargetUrl(targetUrl);
	}
}

//插件检测
var activeXChooseDialog;
function openactiveXChooseDialog(){
	activeXChooseDialog = new Ext.Window({
        layout:'border',
        closeAction:'hide',
        plain: true,
        modal :true,
        items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }]
    });
    activeXChooseDialog.render(Ext.getBody());
	var url='/activeXRemind/activeXTest.jsp';
    activeXChooseDialog.setTitle('插件检测');
    activeXChooseDialog.setWidth(805);
    activeXChooseDialog.setHeight(500);
    activeXChooseDialog.getComponent('commondlg').setSrc(url);
    activeXChooseDialog.show();
}


/*是否使用新的首页(/main/mian.jsp 和 /mian/index.jsp 均包含此方法, 返回结果相反)*/
function isUseNewMainPage(){
	return false;
}
</script>
<%if(humresService.useRTX()){%>
<OBJECT id="RTXAX" style="display:none" data="data:application/x-oleobject;base64,fajuXg4WLUqEJ7bDM/7aTQADAAAaAAAAGgAAAA==" classid="clsid:5EEEA87D-160E-4A2D-8427-B6C333FEDA4D"></OBJECT>
<%} %>
<div id="hello-win" class="x-hidden">
    <div class="x-window-header"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40029") %><!-- 对话框 --></div>    
</div>
<jsp:include flush="true" page="/app/birthday/rebirthday.jsp"></jsp:include>
</body>
<script type="text/vbscript">
Dim FirstDigest
Dim Digest
dim EnData
Digest= "01234567890123456"

dim bErr

sub ShowErr(Msg)
	bErr = true
	Document.Writeln "<FONT COLOR='#FF0000'>"
	Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P><P ALIGN='CENTER'><B>ERROR:</B>"
	Document.Writeln "<P>&nbsp;</P><P ALIGN='CENTER'>"
	Document.Writeln Msg
	Document.Writeln " failed, and returns 0x" & hex(Err.number) & ".<br>"
	Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P>"
	Document.Writeln "</FONT>"
End Sub


function ValidateUsb()
Digest = "01234567890123456"
usbname = "<%=su.getLongonname()%>"
On Error Resume Next
Dim TheForm
Set TheForm = Document.forms("form1")

bErr = false

'Let detecte whether the haikey Safe Active Control loaded.
'If we call any method and the Err.number be set to &H1B6, it
'means the hakey Safe Active Control had not be loaded.
dim LibVer
LibVer = htactx.GetLibVersion
If Err.number <> 0 Then
    call retryUsb
	Validate = false
	Exit function
Else
	'MsgBox "Load ActiveX success!"
	dim hCard
	hCard = 0
	hCard = htactx.OpenDevice(1)'打开设备
	If Err.number<>0 or hCard = 0 then
		'MsgBox "请插入您的HeiKey."
        call retryUsb
		Validate = false
		Exit function
	End if
	'MsgBox "open device success!"

	htactx.VerifyUserPin hCard, CStr("1111")'校验口令
	If Err.number<>0 Then
		'ShowErr "Verify User PIN Failure!!!"
		Validate = false
		htactx.CloseDevice hCard
		Exit function
	End if
	'MsgBox "Verify user pin success!"

	dim UserName
	UserName = htactx.GetUserName(hCard)'获取用户名
    TheForm.j_username.Value=UserName
	If Err.number<>0 Then
		'ShowErr "Get User Name Failure!!!"
		Validate = false
		htactx.CloseDevice hCard
		Exit function
	End if
	If 	usbname<>UserName then
    	call retryUsb
    End if
End If
End function
</script>
</html>
