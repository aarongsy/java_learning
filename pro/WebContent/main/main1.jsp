<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
EweaverUser eweaveruser2 = BaseContext.getRemoteUser();
DataService dateservice2 = new DataService();
String sql2 = "select isupdatepass,customdate from loginuppass where isdelete =0 and objid ='"+eweaveruser2.getHumres().getId()+"'";
List<Map<String,Object>> list2 = dateservice2.getValues(sql2);
String str2 = dateservice2.getValue("select itemvalue from setitem where id='297e930d347445a101347445ca4e0000'");
if(str2!=null && "1".equals(str2)){
	/**begin 先判断密码是否在设置的有效期**/
	//com.eweaver.base.security.servlet.CustomPass.setCustompassword(list2); //暂且注释掉 因为有效期不能正确判断到每个人
	/**end******************************/
}
if( str2!=null && "1".equals(str2) &&  list2!=null && list2.size()> 0 && !"1".equals(list2.get(0).get("isupdatepass").toString())){
%>
<%}else if(str2!=null && "1".equals(str2) && ( list2 == null || ( list2!=null && list2.size() == 0 )) ){%>
<%	
} %>
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
<%@page import="com.eweaver.base.menu.MenuDisPositionEnum"%>
<%@page import="com.eweaver.base.menu.model.*"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

request.getSession(true).setAttribute("eweaveruser",eweaveruser);
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
MenuService menuService = (MenuService)BaseContext.getBean("menuService") ;
MenuorgService menuorgService = (MenuorgService)BaseContext.getBean("menuorgService") ;
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
StationinfoService stationService= (StationinfoService) BaseContext.getBean("stationinfoService");
BaseJdbcDao baseJdbcDao= (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
AttendanceService attendanceService=(AttendanceService)BaseContext.getBean("attendanceService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
String username = currentuser.getObjname();
String currentdate = DateHelper.getCurrentDate();
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
String emailurl=StringHelper.null2String(request.getParameter("emailurl"));
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String isUsb = StringHelper.null2String(setitemService.getSetitem("402888534deft8d001besxe952edgy16").getItemvalue());
Integer usbMark = su.getIsusbkey();
boolean isCheckUsb = "1".equals(isUsb) && usbMark == 1;
boolean allowSwitch=false;
if(!"1".equals(emailurl)){
	allowSwitch =sysuserService.isAllowSwitch();//是否允许账号管理员切换到任何其他用户
	if(allowSwitch && sysuserService.checkUserPerm(su,"/ServiceAction/com.eweaver.base.security.servlet.SwitchUserAction") && StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals("")){
		request.getSession(true).setAttribute("allowSwitch",su.getId());
	}
}
String initpage;
String orgunitid=currentuser.getOrgid();                         
Orgunit orgunit=orgunitService.getOrgunit(orgunitid);
initpage = request.getContextPath()+"/portal.jsp";
String fillins="";
      // 是否系统管理员
SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService) BaseContext.getBean("sysuserrolelinkService");
boolean issysadmin = false;
String humresroleid = "402881e50bf0a737010bf0a96ba70004";//系统管理员角色id
Sysuser sysuser = new Sysuser();
Sysuserrolelink sysuserrolelink  = new Sysuserrolelink();
sysuser = sysuserService.getSysuserByObjid(currentuser.getId());
issysadmin = sysuserrolelinkService.isRole(humresroleid,sysuser.getId());
String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":eweaveruser.getSysuser().getLanguage();
eweaveruser.setLanguage(StringHelper.isEmpty(language)?"zh_CN":language);
boolean isSwitchState = !StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals("")
                        &&!StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals(su.getId())
                        &&allowSwitch;//是否处理切换账号状态
%>
<html>
<head>
<style>
.x-window-footer table,.x-toolbar table{width:auto;}
.x-toolbar{background:url();border:0;}
</style>
<title><%=labelService.getLabelName("402881eb0bcd354e010bcdc2b9f10023")%></title>

<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
	var dlg0;
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
    MenuorgService.clearAllMenu();
    List menuList2 = menuorgService.getMenuByOrgSetting2(null,MenuDisPositionEnum.top);
    for(int i=0;i<menuList2.size();i++){
    	Menu menu = (Menu)menuList2.get(i);
    	String menuname = labelCustomService.getLabelNameByMenuForCurrentLanguage(menu);
    	sb.append("tbmenu.add({text:'"+menuname+"'");
    	sb.append(menuorgService.getExtMenu(menu.getId()));
    	sb.append("});");
    }
    menuorgService.clearAllMenu();
    out.println(sb);
    %>
    
	var nav = new Ext.KeyNav("objname", {
	    "enter" : function(e){
	        quickSearch();
	    },
	    scope:this
	});
	    dlg0 = new Ext.Window({
	   layout:'border',
	   closeAction:'hide',
	   plain: true,
	   modal :true,
	   width:500,
	   height:350,
	   buttons: [
	       <%if(issysadmin){%>
	       {
	       text     : '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30021") %>',//注册
	       handler  : function() {
	             openlics();
	       }
	   }, {
	       text     : '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30022") %>',//手机版注册
	       handler  : function() {
	             openmlics();
	       }
	   },<%}%>{
	        text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
	        handler  : function() {
	            dlg0.hide();
	            dlg0.getComponent('dlgpanel').setSrc('about:blank');
	        }
	    }],
	    items:[{
	        id:'dlgpanel',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }]
	});
	dlg0.render(Ext.getBody());
	 });
	 
</script>
</head>
<BODY id="mybody" style="margin:0;padding:0;overflow-y:hidden" onload="init();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" style="background: #D2DCE8;">
	<tr id="main_top"><td colspan="4"> 
		<div id="logo"></div>
		<div id="right" style="height: 20px"></div> 
	</td></tr>
	<tr><td id="main_toolbar" align="right" <%if(language.equals("zh_CN")){ %> style="padding: 0 0 0 190px;width:300"<%}else{ %>style="padding: 0 0 0 200px;width:300"<%} %>>
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
				<form id="quicksearch" name="quicksearch" method="post" action="" onsubmit="return false">
				<td >
					
			<select id="searchtype" name="searchtype" <%if(language.equals("zh_CN")){ %> style="width: 80px"<%}else{ %> style="width: 120px"<%} %> nowrap>
			<%
	         SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	         ReportSearchfieldService reportSearchfieldService = (ReportSearchfieldService) BaseContext.getBean("reportSearchfieldService");
	         List setitemlist = setitemService.getAllSetitemByTypeId("402880371b76ca76011b76ed58a80003");
	         FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
	         ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");
	         Formfield formfield=new Formfield();
	         Reportdef reportdef=new Reportdef();
	         List reportdefList=reportdefService.getReportdefList();
	         Iterator it= setitemlist.iterator(); 
	         while (it.hasNext()){
	    	 	Setitem setitem =  (Setitem)it.next();
	            Iterator itObj= reportdefList.iterator();
	            while(itObj.hasNext()){
	           		reportdef=(Reportdef)itObj.next();                       
	            	if(!reportdef.getId().equals(setitem.getItemvalue()))	continue; 
	            	String formfieldName=StringHelper.null2String(setitem.getItemdesc());
	            	formfield=formfieldService.getFormfieldByName(reportdef.getFormid(),formfieldName);
	            	if(reportdef==null||formfield==null)	continue;  
	            	String viewtype=String.valueOf(reportdef.getViewType());                     
	            	String reportId=StringHelper.null2String(setitem.getItemvalue());
	            	String formfieldId="";
	                formfieldId=StringHelper.null2String(formfield.getId());
	                List<Reportsearchfield> reportsearchfields = reportSearchfieldService.getReportsearchfieldByReportid(reportId);
	                for (Reportsearchfield searchfield : reportsearchfields) {
	                     if (StringHelper.null2String(searchfield.getIsfillin()).equals("1")&&formfieldId.equals(searchfield.getFormfieldid())) {
	                         if (fillins.equals("")){
	                             fillins += reportId;
	                         }else{
	                             fillins += "," + reportId;
	                         }
	                     }
	                 }
	             	if("402881e80c33c761010c33c8594e0005".equals(reportdef.getFormid())){
	                 	formfieldId=formfieldId+",humres";
	             	}
	             	if("402881e50bff706e010bff7fd5640006".equals(reportdef.getFormid())){
	                	formfieldId=formfieldId+",docbase";
	            	}    
					%>
					<%String labelname = labelCustomService.getLabelNameBySetitemForCurrentLanguage(setitem); %>
	              	<option value="<%=reportId+";"+formfieldId+";"+viewtype%>"><%=labelname%></option>
					<%
				}
			}
	        %>
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
			<td>
			<%if("1".equals(attendanceService.getAttendanceViewAttendbtn())){ %>
			<button type="button" id="attendanceBtn" onclick="AttendanceIn(this);" style="width:50px;padding:0px;cursor: pointer;"> <%=(attendanceService.getTodayAttendance(Attendance.ATTENDANCE_IN)==null)?labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30023"):labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30024")%></button><!-- 签到 --><!-- 签退 -->
		<%}%></td>
			</tr>
		</table>
		</td>
		<td id="topmenu" width="*"></td>
		<td width="150px" style="text-align:right;padding: 0 10px 0 0;">
			<%=labelService.getLabelName("欢迎您") %>: <%=username%><!-- 欢迎您 -->
			<%if(
			!StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals("")&&
			!StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals(su.getId())&&
				allowSwitch){%>
			<a href="javascript:switchSysAdmin('<%=(String)request.getSession(true).getAttribute("allowSwitch")%>')">(<%=sysuserService.get((String)request.getSession(true).getAttribute("allowSwitch")).getLongonname()%>)</a>
			<%}%>
		</td>
		<td width="80">
		<span onclick="javascript:openwinlics();" title="<%=labelService.getLabelNameByKeyId("ECF2041D912C4D93AE6FBA002676DDEF") %>" style="cursor: hand;"><img src="/images/main/toolbar_help.gif"/></span>
		<%if(humresService.useRTX()){%>
			<span width=20px><img onclick="javascript:RtxSessionLogin();" src="/rtx/images/rtxon.gif" width="16" height="16"/></span>
		<%}%>
		<span onclick="javascript:logOff();" title="<%=labelService.getLabelNameByKeyId("ADE1D73F390248C7B661B47BD31F06D3") %>" style="cursor: hand;"><img src="/images/main/toolbar_exit.gif"/></span>
		</td>
	</td>
	</tr>
	<tr><td colspan="4">
		<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC='/blank.htm'></iframe>
		<iframe id="leftFrame" name="leftFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" scrolling="NO" src="leftFrame.jsp"></iframe>
		<iframe id="msgFrame" frameborder="0" src="about:blank" style="display:none;position:absolute;"></iframe>
		<iframe id="rtx"  name="leftFrame"  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" scrolling="NO" style="display:none;position:absolute;" SRC=''></iframe>
	</td></tr>
</table>
<script language="javascript" type="text/javascript">
var fillins='<%=fillins%>';
function init(){
	loadvoting();
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
function logOff(){	//退出
	if(confirm("<%=labelService.getLabelNameByKeyId("A0C96F463F9E46DF9BA3659AA2D5EEE3")%>")){
		location.href="/main/logout.jsp";		
	}
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
function getIEv(){
	//alert(window.navigator.appName);
	//alert(window.navigator.appVersion);
	var strVer=window.navigator.appVersion;
	var iev=0;
	if(strVer.substr(17,4)=="MSIE"){
		iev=strVer.substr(22,1);
	}
	//alert(iev);
	return iev;
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

function openwinlics(){
   var url="/version/version.jsp";
   this.dlg0.getComponent('dlgpanel').setSrc(url);
   this.dlg0.show() ;
}
function openlics(){
    var url='/base/lics/licsin.jsp';
    openWin(url,600,800);
}
function openmlics(){
    var url='/base/lics/mlicsin.jsp';
    openWin(url,600,800);
}
function openWin(url,title,height,width){
	var left=(screen.width-width)/2;
	var top=(screen.height-height)/2-30;
	window.open(url, title, "height="+height+", width="+width+", top="+top+", left="+left+", toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}
function loadvoting(){
	<%
	String sql="select distinct requestid from indagatecontent icontent where requestid in( select id from formbase fb where fb.isdelete<>1 )";
	String sqlsel=PermissionUtil2.getPermissionSql2(sql,"indagatecontent","6");
	String sqlselrequestid=sqlsel+" and  icontent.requestid not in(select requestid from indagateremark)";
    List list=baseJdbcDao.getJdbcTemplate().queryForList(sqlselrequestid);
    if(list.size()<=0){
	    String sqlselcreator=sqlsel+" and '"+currentuser.getId()+"' not in (select creator from indagateremark where requestid=icontent.requestid)";
	    list=baseJdbcDao.getJdbcTemplate().queryForList(sqlselcreator);
    }
     for(Object o:list){
      String requestidstr=((Map) o).get("requestid") == null ? "" : ((Map) o).get("requestid").toString();
     %>
     Ext.Ajax.request({
     url: '/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=compareDate',
     params:{requestid:'<%=requestidstr%>'},
     success: function(res){
       if(res.responseText=='true'){
         var url='/indagate/indagate.jsp?requestid=<%=requestidstr%>';
         openWin(url,'<%=requestidstr%>',600,800);  
       }
     }
     });
	<%}%>
}
if('<%=emailurl%>'==1){
	setTimeout("openworkflow()", 1500);
}
function initrtx(){
	var obj=document.getElementById("RTXAX");
	//alert(obj);
	RTXCRoot=null;
	RTXCRoot = obj.GetObject("KernalRoot");
	strSessionKey=getstrSessionKey()
}

var RTXCRoot = null;
var strSessionKey = null;
function RtxSessionLogin(){
    document.getElementById("rtx").src = "/interfaces/rtxlogin.jsp";
	document.getElementById("rtx").contentWindow.doRefresh();
	//window.open('/interfaces/rtxlogin.jsp','RTX','height=1, width=1, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no,alwaysLowered=no ');
    //alert(1);
	//strSessionKey=null;
	// alert(2);
	//if(RTXCRoot==null){
	//    initrtx();
	//}//end.if
	//try{
	// alert(3);
	//	var ret = RTXCRoot.LoginSessionKey(severip,serverport,'<%=BaseContext.getRemoteUser().getUsername()%>', strSessionKey);
	//}catch (e)
	//{
	// alert(4);
	//	alert(e.name + ": " + e.message);
	//	if(e.message=='远程服务器不存在或不可用'){
	//		window.location.reload(true);
	//	}
	//}
}

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

function openworkflow() {
    onUrl('/workflow/request/workflow.jsp?from=report&requestid=<%=requestid%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30026") %>');//提醒中的流程
}
function AttendanceMsg(msg){
	var el=Ext.get('msgFrame');
	if(typeof(msg)=='boolean' && msg===false){
		el.enableDisplayMode().hide();
		return;
	}
	var w=300;
	var h=50;
	var frame=el.dom;
	el.enableDisplayMode().show();
	el.setSize(w,h);
	var x=(Ext.getBody().getSize().width-w)/2+'px';
	var y=(Ext.getBody().getSize().height-h)/2+'px';
	el.setLeftTop(x,y);
	var doc=frame.contentWindow.document;
	var temp=new Ext.XTemplate('<html><head></head><body scroll="no" style="margin:0px;margin-right:0px;padding:0px;border:1px solid #000000;">',
	'<table width="100%" height="100%" border="0">',
	'<colgroup><col width="90%"/><col width="10%"/></colgroup>',
	'<tr><td align="center" style="font-size:12px;">{msg}</td>',
	'<td align="center" valign="top"><img src="'+contextPath+'/images/base/bacocross.gif" onclick="parent.AttendanceMsg(false);" style="cursor:pointer"/></td>',
	'</tr></table>',
	//'<div style="background-color:gray;width:100%;">{msg}ddddddddddd</div>',
	'</body></html>');
	doc.open();
	doc.write(temp.apply({msg:msg}));
	doc.close();
}
function AttendanceIn(obj){
Ext.Ajax.request({
   url: contextPath+'/ServiceAction/com.eweaver.attendance.servlet.AttendanceAction?action=attendance',
   success: function(res){
   		var data=Ext.decode(res.responseText);
  		obj.innerHTML=data[0];
  		AttendanceMsg(data[1]);
   },
   failure: function(res){
   	alert('Error:'+res.responseText);
   }
});
}
<%
//如果开启了自动弹出签到确认框并未签到且是工作日时才自动显示确认框.
if(attendanceService.isAutoAttendance() && attendanceService.isWorkday() && attendanceService.getTodayAttendance(Attendance.ATTENDANCE_IN)==null){%>
	if(confirm('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30027") %>')) AttendanceIn(Ext.getDom('attendanceBtn'));//确定签到吗(Y/N)?	
<%}%>
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
