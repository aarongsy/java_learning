<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService" %>
<%@ page import="com.eweaver.base.security.model.Sysuser" %>
<%@ page import="com.eweaver.userkey.HTSrvAPI" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%
	LabelService labelService = (LabelService)BaseContext.getBean("labelService");
	DataService dataService = new DataService();
%>
<%
	String ip = request.getHeader("X-Forwarded-For");
	if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getHeader("Proxy-Client-IP");
	}
	if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getHeader("WL-Proxy-Client-IP");
	}
	if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getHeader("HTTP_CLIENT_IP");
	}
	if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	}
	if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getRemoteAddr();
	}
%>
<%!
	private static String getErrorMessage(String exceptionName, String language){
		LabelService labelService = (LabelService)BaseContext.getBean("labelService");
		if(StringHelper.isEmpty(language)){
			language = "zh_CN";
		}
		Map<String,String> messageMap = new HashMap<String,String>();
		messageMap.put("CredentialsNotFoundException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091be30002", language));//License无效
		messageMap.put("CredentialsExpiredException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091be30005", language));//License过期
		messageMap.put("LockedException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091be30008", language));//License超过最大用户限制
		messageMap.put("UsernameNotFoundException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091be3000b", language));//用户名不存在
		messageMap.put("NonceExpiredException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091be3000e", language));//验证码错误
		messageMap.put("BadCredentialsException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091c020011", language));//密码错误
		messageMap.put("DisabledException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091c020014", language));//帐号已关闭
		messageMap.put("ConcurrentLoginException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091c020017", language));//另一个用户已登录
		messageMap.put("InsufficientAuthenticationException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091c02001a", language));//动态密码错误
		messageMap.put("USBKeyException", labelService.getLabelNameByKeyId("402881e43c23091a013c23091c02001d", language));//USBKey验证失败
		messageMap.put("keyfailure", labelService.getLabelNameByKeyId("402881e43c23091a013c23091c020020", language));//USBKey未插入或者驱动未安装
		return messageMap.get(exceptionName);
	}
%>
<%
request.getSession(true).removeAttribute("allowSwitch") ;
SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
String needauthcode = StringHelper.null2String(setitemService.getSetitem("402881e40ac0e0b2010ac13ff4ee0003").getItemvalue());
String needdynamicpass = StringHelper.null2String(setitemService.getSetitem("402888534deft8d001besxe952edgy15").getItemvalue());
String isUsb = StringHelper.null2String(setitemService.getSetitem("402888534deft8d001besxe952edgy16").getItemvalue());
String isIP = StringHelper.null2String(setitemService.getSetitem("4028836134c18c690134c18c6b680000").getItemvalue());
String sysid=StringHelper.null2String(request.getParameter("sysid"));
String ispassmodel=StringHelper.null2String(request.getParameter("ispassmodel"));
String typestr="password";
if(!StringHelper.isEmpty(sysid)&&"1".equals(ispassmodel)){
           typestr="text";
}
SysuserService sysuserService = (SysuserService)BaseContext.getBean("sysuserService");
Sysuser sysuser=sysuserService.get(sysid);

String isdx=StringHelper.null2String(setitemService.getSetitem("402880e71284a7ed011284fcf3de0012").getItemvalue());

String RndData="";
int nRndLen;
char Upper = '9';
char Lower = '0';
	Random r = new Random();
for(int i=0; i<15; i++)
{
   int tempval = (int)((int)Lower + (r.nextFloat() * ((int)(Upper - Lower))));
   RndData += new Character((char)tempval).toString();
}
session.setAttribute("RandomData",RndData);
nRndLen = RndData.length();

//从Cookie中获取用户名和密码
String username=StringHelper.null2String(sysuser.getLongonname()); 
String password=""; 
try{ 
	Cookie[] cookies=request.getCookies(); 
	if(cookies!=null){ 
		for(int i=0;i<cookies.length;i++){ 
			if(cookies[i].getName().equals("eweaveruser")){  
				String cookiename_value = StringHelper.getDecodeStr(cookies[i].getValue());
				if(StringHelper.isEmpty(username) && !StringHelper.isEmpty(cookiename_value)){
					username = StringHelper.null2String(cookiename_value.split("-")[0]);
					if(cookiename_value.split("-").length>1){
						password = StringHelper.null2String(cookiename_value.split("-")[1]); 
						password = StringEncode.decrypt(password); 
					}
					
				}
			} 
		} 
	} 
}catch(Exception e){ 
	e.printStackTrace(); 
}
boolean isEnabledMultiLanguage = LabelCustomService.isEnabledMultiLanguage();
String loginPageLanguage = StringHelper.null2String(StringHelper.getDecodeStr(CookieHelper.getCookie(request, "loginPageLanguage")));
String languageOfSession = StringHelper.null2String(session.getAttribute("loginPageLanguage"));
if(!StringHelper.isEmpty(languageOfSession)){
	loginPageLanguage = languageOfSession;
}
String error = StringHelper.null2String(request.getParameter("error"));
String errorMessage = StringHelper.null2String(getErrorMessage(error, loginPageLanguage));
%>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript">window.history.forward();</script>
	<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
	<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="/js/ext/ext-all.js"></script>
	<script src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/crselect/crselect.js"></script>
	<link type="text/css" rel="stylesheet" href="/js/jquery/plugins/crselect/crselect.css"/> 
	<script type="text/javascript" src="/js/login.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/login.css"/>
</head>
<body onload="javascripts:form1.uname.focus()" id="mybody">
  <div id="loginMain">
  <form name="form1" method="post" action="/j_acegi_security_check" onsubmit="javascript:return login();">
  	<input type='hidden' id="rndData" name="rndData" Value="<%=RndData%>">
	<input type='hidden' id="encData" name="encData" Value="">
	<input type='hidden' id="isusb" name="isusb" Value="<%=isUsb %>">
	<input type='hidden' id="isIP" name="isIP" Value="<%=isIP %>">
	<input type='hidden' id="ip" name="ip" Value="<%=ip %>">
	<input type='hidden' id="isdx" name="isdx" Value="<%=isdx %>">
	<input type="hidden" id="needauthcode" name="needauthcode" value="<%=needauthcode%>"/>
	<input type="hidden" id="sendpass" name="sendpass" value="<%=needdynamicpass %>">
	<input type='hidden' id="j_username" name="j_username" value="<%=username%>">
	<input type="hidden" id="rememberme" name="rememberme" value="0">
	
	<%if(!StringHelper.isEmpty(sysid)){%>   
    <input type="hidden" name="sysid" value="<%=sysid%>">
	<%}%>
  	<div id="loginBox">
  		<div id="messageDiv"><%=errorMessage%></div>
  		<div id="loginBox_uname">
  			<input type="text" id="uname" name="uname" tabindex="1" value="<%=username%>">
  		</div>
  		<div id="loginBox_j_password">
  			<input type="<%=typestr%>" id="j_password" name="j_password" tabindex="2">
  		</div>
  		<div id="loginBox_dynamicpass">
	  		<%
	  		String sql = "select * from dynamicpassrule where setitemid='402888534deft8d001besxe952edgy15'";
	  		List dataList = dataService.getValues(sql);
	  		Map data = new HashMap();
	  		if(!dataList.isEmpty()){
	  			data = (Map)dataList.get(0);
	  		}
	  		String ispassmodel2 = data.get("ispassmodel") == null ? "" : data.get("ispassmodel").toString(); //是否明码输入
	  		String typestr2="0".equals(ispassmodel2)?"password":"text";
	  		%>
  			<input type="<%=typestr2%>" id="dynamicpass" name="dynamicpass" size="4" tabindex="4" style="display:none;"/>					
			<input type="button" id="dynamicpassBtn" value="获取动态密码" onclick="checkDynamicpass(this)" style="display:none;"/><!-- 获取动态密码 -->
  		</div>
		<%if(needauthcode.equals("1")){%>
		<div id="loginBox_authcode">
			<img id="authcodeImg" align="absmiddle" src="/ServiceAction/com.eweaver.base.RandOut">
			<input type="text" id="authcode" name="authcode" size="4" tabindex="3"/>
		</div>
		<%}%>
		
		<% if(isEnabledMultiLanguage){ %>
		<div id="loginBox_language">
			<select id="language" name="language">
				<option value="">选择系统语言</option>
				<%
					String languageSQL = "select id,objname,objdesc,typeid from selectitem where typeid='4028803522c5ca070122c5d78b8f0002' and isdelete=0 order by dsporder";
		            List languageList = dataService.getValues(languageSQL);
					for(int i = 0; i < languageList.size(); i++){
						Map languageMap = (Map)languageList.get(i);
						String languageName = StringHelper.null2String(languageMap.get("objname"));
						String languageDesc = StringHelper.null2String(languageMap.get("objdesc"));
				%>
						<option value="<%=languageName %>"><%=languageDesc %></option>
				<% } %>
			</select>
			<script type="text/javascript">
				jQuery(function(){
					selectedLanguage();
					positionLanguage();
	   				jQuery("#language").CRselectBox();
   				});
			</script>
		</div>
		<% } %>
		
  		<div id="loginBox_btnSubmit">
  			<button type="submit" id="btnSubmit" value="登录" >登录 </button>
  		</div>
  	</div>
  	<div id="logo" onclick="window.open('http://www.weaver.com.cn');"></div>
  </form>
  
  <div id="footer">提示：需要运行在Microsoft IE 8.0以上，如果您是首次登录系统请确认您的浏览器版本，最佳显示分辨率为1366*768。</div>
  
  <div id="progressBarhome" style="display:block;">
	<div id="progressBar" style="display:block;">
		<div class="status" id="p1text" style="display:inline;"></div>
		<div id="p1" style="width:300px;display:inline"></div>
		<div id="importMessage" style="display:none;">
		    <a href='javascript:void(0)' style="text-decoration: none">对不起，您还没有安装haikey插件，不允许USB登录<!-- 对不起，您还没有安装haikey插件，不允许USB登录 --></a><br><br>
		    <a id="aHTActX" href='/plugin/HaiKeyDriver.rar'>点击下载相关插件<!-- 点击下载相关插件 --></a>
		</div>
	</div>
   </div>
  
  </div>
</body>
<script type="text/javascript">
var myMask;
var isdx="<%=isdx %>";
Ext.onReady(function() {
    var nav = new Ext.KeyNav("j_password", {
        "enter" : function(e){
        	if(login()) {
        		form1.submit();	
        	}           
        },
        scope : this
    });
    if(form1.uname.value){
    	form1.j_password.focus();
    }else{
    	form1.uname.focus();
    }
});

function getLanguage(){
	if("<%=loginPageLanguage%>" != ""){
		return "<%=loginPageLanguage%>";
	}
	if(getSelectElementLanguage() != ""){
		return getSelectElementLanguage();
	}
	if(getBrowserLanguage() != ""){
		return getBrowserLanguage();
	}
	return "zh_CN";
}

function getSelectElementLanguage(){
	var languageEle = document.getElementById("language");
	if(languageEle){
		return languageEle.value;
	}
	return "";
}

function getBrowserLanguage(){
	var language = window.navigator.language; 
	if(!language){
		language = window.navigator.browserLanguage; 
	}
	if(language){
		language = language.replace("-","_");
		return language;
	}
	return "";
}

function selectedLanguage(){
	var languageVal = getLanguage();
	var languageEle = document.getElementById("language");
	for(var i = 0; languageEle && i < languageEle.options.length; i++){
		var languageOpt = languageEle.options[i];
		if(languageOpt.value.toLowerCase() == languageVal.toLowerCase()){
			languageOpt.selected = true;
			break;
		}
	}
}

function positionLanguage(){
	var isEnabledDynamicpass = $("#dynamicpass").length > 0 && $("#dynamicpass").is(":visible");
	var isEnabledAuthcode = $("#loginBox_authcode").length > 0 && $("#loginBox_authcode").is(":visible");
	if((isEnabledDynamicpass || isEnabledAuthcode) && <%=isEnabledMultiLanguage%>){	//当启用了动态密码或者验证码时，重新定位多语言选择
		var bodyWidth = $(document.body).width();
	
		var $loginBox = $("#loginBox");
		var $loginBox_language = $("#loginBox_language");
		
		var rightMargin = 10; //距离页面右边的距离
		var left = bodyWidth - $loginBox.position().left - $loginBox_language.outerWidth(true) - rightMargin;
		
		var topMargin = 10; //距离页面上边的距离
		var top = topMargin - $loginBox.position().top;
		
		$loginBox_language.css({"left" : left + "px", "top" : top + "px"});
		
		var $CRselectBox = $("#loginBox_language .CRselectBox");
		if($CRselectBox.length > 0){	//重新更改选项的位置
			var ul_top = $CRselectBox.offset().top + $CRselectBox.outerHeight(true) + 1; 
			var ul_left = $CRselectBox.offset().left; 
			$(".CRselectBoxOptions").css({"top": ul_top + "px", "left": ul_left + "px"});
		}
	}
}
</script>
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


function Validate()
Digest = "01234567890123456"
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
    location.href="<%=request.getContextPath()%>/main/login.jsp?error=keyfailure"
	Validate = false
	Exit function
Else
	'MsgBox "Load ActiveX success!"
	dim hCard
	hCard = 0
	hCard = htactx.OpenDevice(1)'打开设备
	If Err.number<>0 or hCard = 0 then
		'MsgBox "请插入您的HeiKey."
        location.href="<%=request.getContextPath()%>/main/login.jsp?error=keyfailure"
		Validate = false
		Exit function
	End if
	'MsgBox "open device success!"

	htactx.VerifyUserPin hCard, CStr("1111")'校验口令
	If Err.number<>0 Then
		ShowErr "Verify User PIN Failure!!!"
		Validate = false
		htactx.CloseDevice hCard
		Exit function
	End if
	'MsgBox "Verify user pin success!"

	dim UserName
	UserName = htactx.GetUserName(hCard)'获取用户名
    TheForm.j_username.Value=UserName
	If Err.number<>0 Then
		ShowErr "Get User Name Failure!!!"
		Validate = false
		htactx.CloseDevice hCard
		Exit function
	End if

	Digest = htactx.HTSHA1("<%=(String)session.getAttribute("RandomData")%>",<%=nRndLen%>)
	If Err.number<>0 Then
		ShowErr "SHA1 failed."
		Validate = false
		htactx.CloseDevice hCard
		Exit function
	End if
	'MsgBox "SHA1 success!" + Digest

	Digest = Digest&"04040404"'对SHA1数据进行补码
	EnData = htactx.HTCrypt(hCard,0 ,0,Digest, len(Digest))'DES3加密SHA1后的数据
	If Err.number<>0 Then
		ShowErr "HashToken compute"
		Validate = false
		htactx.CloseDevice hCard
		Exit function
	End if
	'MsgBox "Encrypt success!" + EnData
	htactx.CloseDevice hCard
	'MsgBox "close device success!"
	TheForm.encData.Value=EnData
    submitForm()
End If
End function
</script>
</html>
