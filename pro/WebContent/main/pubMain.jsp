<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@page import="com.eweaver.base.security.util.AccountHistorySwitch"%>
<%@ include file="/base/init.jsp"%>
<%!
private List<String> getSearchDatas(){
	String fillins = "";
	StringBuilder optionHtmlBuilder = new StringBuilder();
	LabelCustomService  labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
	SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
	SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	ReportSearchfieldService reportSearchfieldService = (ReportSearchfieldService) BaseContext.getBean("reportSearchfieldService");
	List setitemlist = setitemService.getAllSetitemByTypeId("402880371b76ca76011b76ed58a80003");
	FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
	ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");
	Formfield formfield=new Formfield();
	Reportdef reportdef=new Reportdef();
	List reportdefList=reportdefService.getReportdefList();
	Iterator it= setitemlist.iterator(); 
	while(it.hasNext()){
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
        	String searchText = labelCustomService.getLabelNameBySetitemForCurrentLanguage(setitem);
        	optionHtmlBuilder.append("<option value=\""+reportId+";"+formfieldId+";"+viewtype+"\">"+searchText+"</option>");
		}
	}
	return Arrays.asList(fillins, optionHtmlBuilder.toString());
}
%>
<%
String targeturl = StringHelper.null2String(request.getParameter("targeturl"));
String targettitle = StringHelper.null2String(request.getParameter("targettitle"));
String param = "";
if(!StringHelper.isEmpty(targeturl)) {
	targettitle = java.net.URLEncoder.encode(targettitle,"utf-8");
	param = "?targettitle="+targettitle+"&targeturl=" + targeturl;
}
//防止同用户在多浏览器窗口中来回切换传统模式的皮肤和新皮肤,再刷新,从而导致页面不正确的样式引用
if(!request.getRequestURI().equals(userMainPage.getUrl())){
	response.sendRedirect(userMainPage.getUrl()+param);
	return;
}
SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
AttendanceService attendanceService=(AttendanceService)BaseContext.getBean("attendanceService");
BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
//设置多语言信息
String language;
if(LabelCustomService.isEnabledMultiLanguage()){	//启用多语言
	language = StringHelper.isEmpty(suser.getLanguage())?"zh_CN":suser.getLanguage();
}else{	//未启用多语言(无论之前用户选择使用什么语言,一律使用中文)
	language = "zh_CN";
}
eweaveruser.setLanguage(language);
//查询搜索框
List<String> serachDatas = getSearchDatas();
String fillins = serachDatas.get(0);
String serachOptionHtml = serachDatas.get(1);
//帐号切换
Sysuser su = (Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
String emailurl = StringHelper.null2String(request.getParameter("emailurl"));
String requestid = StringHelper.null2String(request.getParameter("requestid"));

String isUsb = StringHelper.null2String(setitemService.getSetitem("402888534deft8d001besxe952edgy16").getItemvalue());
String isOpenIM = StringHelper.null2String(setitemService.getSetitem("40288347363855d101363855d2030293").getItemvalue());
Integer usbMark = su.getIsusbkey();
boolean isCheckUsb = "1".equals(isUsb) && usbMark == 1;
boolean allowSwitch = false;
if(!"1".equals(emailurl)){
	allowSwitch = sysuserService.isAllowSwitch();//是否允许账号管理员切换到任何其他用户
	if(allowSwitch && sysuserService.checkUserPerm(su,"/ServiceAction/com.eweaver.base.security.servlet.SwitchUserAction") && StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals("")){
		request.getSession(true).setAttribute("allowSwitch",su.getId());
	}
}
boolean isSwitchState = !StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals("")
						&&!StringHelper.null2String(((String)request.getSession(true).getAttribute("allowSwitch"))).equals(su.getId())
						&&allowSwitch;//是否处理切换账号状态

//判断当前用户是否可以进行账户切换
boolean currUserIsCanSwitchAccount = (sysuserService.checkUserPerm(suser,"/ServiceAction/com.eweaver.base.security.servlet.SwitchUserAction") && allowSwitch) || isSwitchState;						

String allowUserId = "";
if(isSwitchState){
	allowUserId = (String)request.getSession(true).getAttribute("allowSwitch");
} 

String username = currentuser.getObjname();
						
//如果首次登陆需要修改密码，则跳转修改密码页面
String userId=eweaveruser.getId();

DataService dataService1 = new DataService();
String sql1 = "select isupdatepass,customdate from loginuppass where isdelete =0 and objid ='"+userId+"'";
List<Map> list1 = dataService1.getValues(sql1);
String isupdatepass="";
if(list1!=null&&list1.size()>0){
	isupdatepass=list1.get(0).get("isupdatepass").toString();
}
String itemValue = dataService1.getValue("select itemvalue from setitem where id='297e930d347445a101347445ca4e0000'");
if("1".equals(itemValue)&&!"1".equals(isupdatepass)){
%>
<script>
window.location="updatepassword.jsp?objid=<%=userId%>";
</script>
<%}%>
<html>
<head>
<style type="text/css">
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
<script type="text/javascript">
var dlg0;
Ext.onReady(function(){
	dlg0 = new Ext.Window({
	   layout:'border',
	   closeAction:'hide',
	   plain: true,
	   modal :true,
	   width:500,
	   height:350,
	   buttons: [
	  <%if(isSysAdmin){%>
	   {
	       text     : '<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30021") %>',//注册
	       handler  : function() {
	             openlics();
	       }
	   }, 
	   <%}%>
	   {
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
function logOff(){	//退出
	if(confirm("<%=labelService.getLabelNameByKeyId("A0C96F463F9E46DF9BA3659AA2D5EEE3")%>")){
		location.href="/main/logout.jsp";		
	}
}
function openwinlics(){
   var url="/version/version.jsp";
   dlg0.getComponent('dlgpanel').setSrc(url);
   dlg0.show() ;
}
function openlics(){
    var url='/base/auth/authupload.jsp';
    dlg0.getComponent('dlgpanel').setSrc(url);
   dlg0.show() ;
    //window.location.href = url;
    //openWindow(url,600,800);
}
function openmlics(){
    var url='/base/lics/mlicsin.jsp';
    openWindow(url,600,800);
}
function openWindow(url,title,height,width){
	var left=(screen.width-width)/2;
	var top=(screen.height-height)/2-30;
	window.open(url, title, "height="+height+", width="+width+", top="+top+", left="+left+", toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}
function toTargetUrl(url){
	window.location.href = url;
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

function RtxSessionLogin(){
    var rnd = Math.floor(Math.random()*100000);
    document.getElementById("rtx").src = "/interfaces/rtxlogin.jsp?rnd="+rnd;
}

function loadvoting(){
	<%
	String userId1 = eweaveruser.getId();
	String sql="select distinct requestid from indagatecontent icontent where requestid in( select id from formbase fb where fb.isdelete<>1 )";
	String sqlsel=PermissionUtil2.getPermissionSql2(sql,"indagatecontent","6");
	String sqlselrequestid=sqlsel+" and  icontent.requestid not in(select requestid from indagateremark where creator ='"+userId1+"')";
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
	         openWindow(url,'<%=requestidstr%>',600,800);  
	       	//onPopup(url);
	       }
	     }
     });
	<%}%>
}

function openworkflow() {
    onUrl('/workflow/request/workflow.jsp?from=report&requestid=<%=requestid%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30026") %>');//提醒中的流程
}
function opentargeturl() {
    onUrl('<%=targeturl%>','<%=java.net.URLDecoder.decode(targettitle,"utf-8")%>');
}
Ext.onReady(function() {
	<%
	//如果开启了自动弹出签到确认框并未签到且是工作日时才自动显示确认框.
	if(attendanceService.isAutoAttendance() && attendanceService.isWorkday() && attendanceService.getTodayAttendance(Attendance.ATTENDANCE_IN)==null){%>
		if(confirm('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30027") %>')) AttendanceIn(Ext.getDom('attendanceBtn'));//确定签到吗(Y/N)?	
	<%}%>
	
	if(document.getElementById('objname') != null){
		var nav = new Ext.KeyNav("objname", {
		    "enter" : function(e){
		        quickSearch();
		    },
		    scope:this
		});
	}
	
	loadvoting();
	
	if('<%=emailurl%>'=='1'){
		setTimeout("openworkflow()", 1500);
	} else if('<%=targeturl%>'.length > 0){
		setTimeout("opentargeturl()", 1500);
	}
	
	addCssHackFlagToBody();
});

/**帐号快速切换相关的代码**/
<%if(currUserIsCanSwitchAccount){%>
function switchUser(id, objname) {
	var mask = new Ext.LoadMask(Ext.getBody(),{msg:'正在将帐号切换至 '+objname+' ...'});
	mask.show();
    top.location.href = "/ServiceAction/com.eweaver.base.security.servlet.SwitchSysAdminAction?id=" + id;
}

Ext.onReady(function() {
	var $accountSwitchBox = jQuery("<div id=\"accountSwitchBox\"></div>");
	$accountSwitchBox.html(
	"<div class=\"accountSwitchTitle\">帐号切换</div>" +
	"<div class=\"searchTextBox\">" +
		"<input type=\"text\" id=\"accountSearchText\"/>" +
		"<span class=\"searchTexTip\">输入姓名|编号|帐号进行查询...</span>" +
	"</div>" +
	"<div id=\"currSearchResult\" class=\"searchResult\">" +
		"<ul></ul>" +
	"</div>" +
	"<div id=\"historySearchResult\" class=\"searchResult\">" +
		"<ul></ul>" +
	"</div>");
	jQuery(document.body).append($accountSwitchBox);
	
	var $searchText = jQuery("#accountSearchText");
	var $searchTexTip = jQuery("#accountSwitchBox .searchTextBox .searchTexTip");
	var $currSearchResult = jQuery("#currSearchResult");
	var $historySearchResult = jQuery("#historySearchResult");
	var $quickSwitchAccount = jQuery("#quickSwitchAccount");
	
	$quickSwitchAccount.bind("click", function(e){
		var top = Math.ceil($quickSwitchAccount.offset().top + $quickSwitchAccount.height() + 3);	
		var locaCss = {"top" : top + "px"};
		<% if(userMainPage.getIsClassic()){ %>
			var right = jQuery(document.body).width() - Math.ceil($quickSwitchAccount.offset().left + $quickSwitchAccount.width());
			locaCss["right"] = right + "px";
		<% }else{%>
			var left = Math.ceil($quickSwitchAccount.offset().left);
			locaCss["left"] = left + "px";
		<% } %>
		$accountSwitchBox.css(locaCss);
		$accountSwitchBox.toggle();
		if($accountSwitchBox.is(":visible")){
			$searchText.focus();
		}
		e.stopPropagation(); 
	});
	

	var preSearchText = "";

	jQuery(document.body).bind("click", function(){
		$currSearchResult.hide();
		$historySearchResult.hide();
		$accountSwitchBox.hide();
		preSearchText = "";
	});
	
	$accountSwitchBox.hoverIntent({
		out: function(){
			$accountSwitchBox.hide();
		},
		over: function(){},
		timeout: 300
	});
	
	
	$searchText.bind("click", function(e){
		e.stopPropagation(); 
	});
	
	$searchText.bind("focus", function(){
		resetMove();
		if(this.value != ''){
			accountSeach();
		}else{
			$currSearchResult.hide();
			$historySearchResult.show();
		}
	});
	
	$searchText.bind("blur", function(){
		if(this.value == ''){
			$searchTexTip.show();
		}
	});
	
	var currPosition = -1;
	
	function resetMove(){
		if(currPosition != -1){
			currPosition = -1;
			$accountSwitchBox.find("li.currMove").removeClass("currMove");
		}
	}
	
	function moveIt(moveType){
		var $theResult = $historySearchResult.is(":visible") ? $historySearchResult : $currSearchResult;
		var $resultLi = $theResult.children("ul").children("li:not(.tipLi)");
		if($resultLi.length == 0){
			return;
		}
		
		var tempIndex = -1;
		$resultLi.each(function(index){
			if(jQuery(this).hasClass("mouseover")){
				tempIndex = index;
				return;
			}
		});
		if(tempIndex != -1){
			currPosition = (moveType == 0) ? (tempIndex - 1) : (tempIndex + 1);
		}
		
		if(currPosition >= $resultLi.length){
			currPosition = 0;
		}else if(currPosition < 0){
			currPosition = ($resultLi.length - 1);
		}
		$resultLi.removeClass("currMove");
		$resultLi.removeClass("mouseover");
		$resultLi.eq(currPosition).addClass("currMove");
		$resultLi.one("mouseover", resetMove);
	}
	
	function moveUp(){
		currPosition = currPosition - 1;
		moveIt(0);
	}
	
	function moveDown(){
		currPosition = currPosition + 1;
		moveIt(1);
	}
	
	function doEnterSwitch(){
		if(currPosition != -1){
			var $theResult = $historySearchResult.is(":visible") ? $historySearchResult : $currSearchResult;
			var $movedLi = $theResult.children("ul").children("li.currMove");
			if($movedLi.length == 1){
				$movedLi.children("a").click();
			}
		}
	}
	
	$searchText.bind("keyup", function(event){
		var keyCode = event.keyCode;
		switch(keyCode){  
			case 38 :
				moveUp();
				break;
			case 40 :
				moveDown();
				break;
			case 13 :
				doEnterSwitch();
				break;
			default :
				resetMove();
				if(this.value != ''){
					$searchTexTip.hide();
					accountSeach();
				}else{
					preSearchText = "";
					$searchTexTip.show();
					$currSearchResult.hide();
					$historySearchResult.show();
				}
				break;
		}
		
	});
	
	$searchTexTip.bind("click",function(event){
		$searchText[0].focus();
		event.stopPropagation(); 
	});
	
	function addClassWhenMouseover($liObj){
		$liObj.bind("mouseover", function(){
			jQuery(this).addClass("mouseover");
		});
		
		$liObj.bind("mouseout", function(){
			jQuery(this).removeClass("mouseover");
		});
	}
	
	var historyDatas = jQuery.parseJSON('<%=AccountHistorySwitch.getAccountsWithJson(allowUserId)%>');
	var $historyDataUL = jQuery("ul", $historySearchResult);
	if(historyDatas.length > 0){
		for(var i = 0; i < historyDatas.length; i++){
			var id = historyDatas[i].id;
			var longonname = historyDatas[i].longonname;
			var objname = historyDatas[i].objname;
			var objno = historyDatas[i].objno;
			if(id == "<%=suser.getId()%>"){
				continue;
			}
			var $historyDataLi = jQuery("<li></li>");
			var objnameContent = "<span class='account_objname'>"+objname+"</span>";
		 	var longonnameContent = "<span class='account_longonname'>"+longonname+"</span>";
		 	var objnoContent = "";
			if(objno != ""){
				objnoContent = "<span class='account_objno'>"+objno+"</span>";
			}
			$historyDataLi.append("<a href=\"javascript:void(0);\" onclick=\"javascript:switchUser('"+id+"','"+objname+"');\">" + objnameContent + objnoContent + longonnameContent + "</a>");
			$historyDataUL.append($historyDataLi);
			addClassWhenMouseover($historyDataLi);
		}
	}else{
		var $historyDataLi = jQuery("<li class='tipLi'><font class='tip'>无历史切换帐号记录</font></li>");
		$historyDataUL.append($historyDataLi);
	}

	function accountSeach(){
		var currSreachText = $searchText.val();
		if(currSreachText == preSearchText){
			return;
		}
		preSearchText = currSreachText;
		jQuery.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI("/ServiceAction/com.eweaver.base.security.servlet.SwitchSysAdminAction?action=accountSeach&accountOrName=" + currSreachText),
		 	success: function(responseText, textStatus) 
		 	{
				$historySearchResult.hide();
				$currSearchResult.show();
				var $dataUL = jQuery("ul", $currSearchResult);
				$dataUL.find("*").remove();
		 		var datas = jQuery.parseJSON(responseText);
		 		if(datas.length > 0){
		 			for(var i = 0; i < datas.length; i++){
		 				var $dataLi = jQuery("<li></li>");
		 				var id = datas[i].id;
		 				var longonname = datas[i].longonname;
		 				var objname = datas[i].objname;
		 				var isclosed = datas[i].isclosed;
		 				var objno = datas[i].objno;
		 				if(longonname == ""){
		 					$dataLi.append("<a href=\"javascript:void(0);\">"+objname+" (<font class='red'>无帐号</font>)</a>");
		 				}else{
		 					if(isclosed == 1){
		 						$dataLi.append("<a href=\"javascript:void(0);\">"+objname+" ("+longonname+") <font class='red'>[帐号关闭]</font></a>");
		 					}else{
		 						var objnameContent = "<span class='account_objname'>"+objname+"</span>";
		 						var longonnameContent = "<span class='account_longonname'>"+longonname+"</span>";
		 						var objnoContent = "";
		 						if(objno != ""){
		 							objnoContent = "<span class='account_objno'>"+objno+"</span>";
		 						}
		 						$dataLi.append("<a href=\"javascript:void(0);\" onclick=\"javascript:switchUser('"+id+"','"+objname+"');\">" + objnameContent + objnoContent + longonnameContent + "</a>");
		 					}
		 				}
		 				$dataUL.append($dataLi);
		 				addClassWhenMouseover($dataLi);
		 			}
		 		}else{
		 			var $dataLi = jQuery("<li class='tipLi'><font class='tip'>无匹配的搜索结果返回</font></li>");
		 			$dataUL.append($dataLi);
		 		}
		 	}
		});
	}
});
<%}%>
</script>	
</head>
</html>