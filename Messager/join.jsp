<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.security.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService" %>
<%
	int widthMsg=262;
	int heightMsg=500;
	//DataService dataService = new DataService();
	//SysuserService sysuserService = (SysuserService)BaseContext.getBean("sysuserService");
	Sysuser currsysuser = sysuserService.getSysuserByObjid(currentuser.getId());
%>

<style  type="text/css">
#divMessagerState{
	background:#CDCDCD;
	
	height:18px;
	cursor:hand;cursor:pointer;
 	width:58px; 	
}
.txtUserState{

}
#divMessagerState .imgState{		
	width:16px;	
}

#divMessagerState .txtState{	
	word-wrap:break-word;
	color:gray;
}

#divMessager{
	position:absolute;left:50px;top:200px;background:#ffffff;
	top:2000;
	width:<%=widthMsg%>;
	height:<%=heightMsg%>;
	vertical-align:top;
}

#divMessager  .title .logo{
	color:captiontext;
	cursor:default;	
	font-family:Arial,sans-serif;
	
	font-weight:bold;
	height:1.5em;
	min-height:18px;
	padding-top:3px;
	white-space:nowrap;
	position:absolute;
	left:0px;
}
#divMessager  .title .logo font{
	vertical-align:middle;
	padding-left:3px;
	font-size:10pt;
}

#divMessager  .imgClose{	
	cursor:hand;cursor:pointer;
	position:absolute;
	right:10px;	
	top:1px;
	z-index:100;
}

#divMessager  .imgHide{	
	cursor:hand;cursor:pointer;
	position:absolute;
	right:52px;	
	top:1px;
	z-index:100;  
}

#divModiLogo{
	display:none;
	border:1px solid #ddddee;
	width:350px;
	height:350px;
	background:#EEEEFF;
	padding:10px;
	text-align:center;
	vertical-align:middle;
	position:absolute;	
}
#divModiLogo #divImg{
	border:1px solid #ddddee;
	background:#FFFFFF;
	width:330px;
	height:330px;
	margin:10px;
	padding:10px;	
	text-align:center;
	vertical-align:middle;
	overflow:auto;	
}

.messagerA A{
	COLOR: blue; TEXT-DECORATION: underline
}
.messagerA A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

.messagerA A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
.messagerA A:visited {
	COLOR: blue;TEXT-DECORATION: underline
}


.resize{	
	/*BACKGROUND-IMAGE:url('/messager/images/resize.gif');cursor: se-resize;%/
	background-repeat :no-repeat;
	height:16px;
	width: 15px;
	position: absolute;
	bottom: 0;
	right: 0;	
	z-index:100;
}


</style>
<LINK href="/messager/ui.css" type="text/css" rel="STYLESHEET">
<LINK href="/messager/css/gray/main.css" type="text/css" rel="STYLESHEET">

<script type="text/javascript" src="/messager/jquery/jqDnR.js"></script> 
<!-- For Other -->
<%@ include file="/messager/Config.jsp" %>
<script type="text/javascript" src="/messager/Util.js"></script>	

 <!-- For Window -->	
<script type="text/javascript" src="/messager/window/ControlWindow.js"></script>
<script type="text/javascript" src="/messager/window/BaseWindow.js"></script>
<script type="text/javascript" src="/messager/window/MessageWindow.js"></script>
<script type="text/javascript" src="/messager/window/ChatWindow.js"></script>



<SCRIPT type="text/javascript">	
    var isMessagerShow=false;
    var nickname="<%=username%>";
	function showMessager(objBtn){
		//alert(objBtn.outerHTML)
		var btnPosition = jQuery(objBtn).position();
		//alert(btnPosition.left+":"+btnPosition.top)		
		//var offsetX=jQuery("#divMessager").width()-20;
		//var offsetY=5;		
		//else {	
		jQuery("#divMessager").css({
			top:80,
			left:screen.width-jQuery("#divMessager").width()-30
		});
		//}	
		if($("#imgMsgStateBar").attr("src")==getUserStateImg("msg")){
			doShowAllTempMsg();									
		}  else {
			if(isMessagerShow){
				jQuery("#divMessager").fadeOut("normal"); 	
				isMessagerShow=false;			
			} else {
				jQuery("#divMessager").fadeIn("normal"); 
				isMessagerShow=true;
			}	
		}
	}			
	jQuery(function() {
		jQuery("#tdMessageState").append("<img src='/messager/images/status/im_unavailable.png' id='imgMsgStateBar' onclick='javascript:showMessager(this)' width='16px' title='正在登陆聊天服务器'/>");
		
		//jQuery("#divMessager").iedrag({handle:'.title'});
		jQuery("#divMessager").jqDrag('.title');
		
		jQuery("#imgMsgStateBar").trigger("click")
		
	});
	function onMsgHide(){
		jQuery("#divMessager").fadeOut("normal"); 	
		isMessagerShow=false;
		//jQuery("#imgMsgStateBar").trigger("click");	
	}

	function onMsgClose(){
		if(!isMesasgerUnavailable){
			if(confirm("确定要退出吗?")){ //确定要退出吗?
				logoutForMessager();
				//onMsgHide();
			}
		} else {
			onMsgHide();
		}		
	}
</SCRIPT>

<%
	//if(user.getLoginid)
%>

<div id="divMessager">		
		
		
		
		<img class="imgHide" src="/messager/images/imgHide.gif"  id="imgHide" onclick='onMsgHide()' title='隐藏聊天面板'/>
		<img class="imgClose" src="/messager/images/close.jpg"  id="imgClose" onclick='onMsgClose()' title='退出'/> 
				<div class="title"  style="background:url('/messager/css/gray/panel_title.png');height:30px;font-weight:bold;cursor:move;border-bottom:0px;margin-bottom: 0;"></div>		
				 	
					<%
					String loginid=currsysuser.getLongonname();
					String password=currsysuser.getLogonpass();
					/**String strCur=loginid+"_"+DateHelper.getCurDateTimeStr();
					String psw2=EncryptHelper.encodePassword(EncryptHelper.encodePassword(strCur)).toLowerCase();
					String strSql="select count(0) count from HrmMessagerAccount where userid='"+loginid+"'";
					String count = dataService.getValue(strSql);
					if(NumberHelper.string2Int(count) > 0){
						strSql="update HrmMessagerAccount set psw='"+psw2+"' where userid='"+loginid+"'";
					} else {
						strSql="insert into HrmMessagerAccount(userid,psw) values('"+loginid+"','"+psw2+"')";
					}
					dataService.executeSql(strSql);**/
%>
					
					 <jsp:include page="/messager/flex/wmForWeb.jsp">
						<jsp:param  name="loginid" value="<%=loginid %>"/>
						<jsp:param name="psw" value="<%=password %>" />					 	
						<jsp:param name="width" value="<%=widthMsg%>" />
						<jsp:param name="height" value="<%=heightMsg%>" />
					 </jsp:include>
	<!------------Window Template --start------------>
 	 <div class="window" id="windowTemplate">	
		<table width="100%" height="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td class="corner-top-left"></td>
				<td class="line-x-t"></td>
				<td class="corner-top-right"></td>
			</tr>
			<tr>
				<td class="line-y-l"></td>
				<td valign="top">
					 <div class="content">
						<!--标题区-->
						<div class="title">
							<div class="logo"></div>
							<div class="name">Message Window</div>
							<div class="operate"></div>
						</div>
						<!--主体区-->
						<div class="body"></div>
					</div>
				</td>
				<td class="line-y-r"></td>
			</tr>
			<tr> 
				<td class="corner-bottom-left"></td>
				<td class="line-x-b"></td>
				<td class="corner-bottom-right"></td>
			</tr>			
		</table>
        <div class="resize"></div>
		<iframe height="100%" width="100%" style="z-index:-1;position:absolute;left:0px;top:0px;"></iframe>
	 </div>
	 <!------------Window Template --end------------>		
<%@ include file="/messager/DocAccessory.jsp" %>

<div style="padding: 2px; display: none" id="divUserIcon"><IFRAME
	src="/messager/GetUserIcon.jsp?loginid=<%=loginid%>" height="100%"
	width="100%" BORDER="0" FRAMEBORDER="no" NORESIZE="NORESIZE"
	scrolling="no"></IFRAME></div>
<div style="padding: 2px; display: none" id="divIframe" class="openFrame"><IFRAME
	 id="ifmOpenPage" height="100%" width="100%" BORDER="0"
	src="" FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="no"></IFRAME></div>
<script language="javascript">
var imgWindow;
function openUserIconWindow(item){
	//imgWindow=ControlWindow.getBaseWindow("imgWindow",rMsg.headIcon,"",600,400,350,100,'divUserIcon');
	//imgWindow.show();		
}
function openPage(type, sendTo, titleStr) {
	var strStr = "/messager/OpenPage.jsp?type=" + type + "&sendTo="
			+ sendTo;
	if (type == "allhistory")  {
		var openPageWindow = ControlWindow.getBaseWindow("openPageWindow"
				+ type + sendTo.substring(0, sendTo.indexOf("@")),
				titleStr, "", 640, 400, 350, 100, 'divIframe');
		//ControlWindow.intMessagerZindex++;
		//openPageWindow.hide();
		openPageWindow.show();
		strStr = "/messager/MsgSearch.jsp";
		openPageWindow.objWindow.find("#ifmOpenPage").attr("src", strStr);
	}else {
		var openPageWindow = ControlWindow.getBaseWindow("openPageWindow"
				+ type + sendTo.substring(0, sendTo.indexOf("@")),
				titleStr, "", 640, 400, 350, 100, 'divIframe');
	    //ControlWindow.intMessagerZindex++;
	    //openPageWindow.hide();
		openPageWindow.show();
		openPageWindow.objWindow.find("#ifmOpenPage").attr("src", strStr);
	}
}

</script>

