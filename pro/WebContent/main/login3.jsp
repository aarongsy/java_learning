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

<%
	LabelService labelService = (LabelService)BaseContext.getBean("labelService");
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
<%

request.getSession(true).removeAttribute("allowSwitch") ;
//Map<String,String> messageMap = new HashMap<String,String>();
//messageMap.put("CredentialsNotFoundException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20010"));//License无效
//messageMap.put("CredentialsExpiredException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20011"));//License过期
//messageMap.put("LockedException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30012"));//License超过最大用户限制
//messageMap.put("UsernameNotFoundException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30013"));//用户名不存在
//messageMap.put("NonceExpiredException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30014"));//验证码错误
///messageMap.put("BadCredentialsException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30015"));//密码错误
//messageMap.put("DisabledException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30016"));//帐号已关闭
//messageMap.put("ConcurrentLoginException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30017"));//另一个用户已登录
//messageMap.put("InsufficientAuthenticationException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30018"));//动态密码错误
//messageMap.put("USBKeyException",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be30019"));//USBKey验证失败
//messageMap.put("keyfailure",labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be3001a")+",<br/>"+labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be3001b")+"<a id=\"aHTActX\" href='/plugin/HaiKeyDriver.rar'>"+labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be3001c")+"</a>"+labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be3001d")+"");//USBKey未插入或者驱动未安装  请  点此下载  驱动  

Map<String,String> messageMap = new HashMap<String,String>();
messageMap.put("CredentialsNotFoundException","License无效");//License无效
messageMap.put("CredentialsExpiredException","License过期");//License过期
messageMap.put("LockedException","License超过最大用户限制");//License超过最大用户限制
messageMap.put("UsernameNotFoundException","用户名不存在");//用户名不存在
messageMap.put("NonceExpiredException","验证码错误");//验证码错误
messageMap.put("BadCredentialsException","密码错误");//密码错误
messageMap.put("DisabledException","帐号已关闭");//帐号已关闭
messageMap.put("ConcurrentLoginException","另一个用户已登录");//另一个用户已登录
messageMap.put("InsufficientAuthenticationException","动态密码错误");//动态密码错误
messageMap.put("USBKeyException","USBKey验证失败");//USBKey验证失败
messageMap.put("keyfailure","USBKey未插入或者驱动未安装,<br/>请<a id=\"aHTActX\" href='/plugin/HaiKeyDriver.rar'>点此下载</a>驱动");//USBKey未插入或者驱动未安装  请  点此下载  驱动  

String error = StringHelper.null2String(request.getParameter("error"));
String errorMessage = StringHelper.null2String(messageMap.get(error));

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
				String name=StringHelper.getDecodeStr(cookies[i].getValue().split("-")[0]);
				if(StringHelper.isEmpty(username)){
					username=name;
					password=cookies[i].getValue().split("-")[1]; 
				}
			} 
		} 
	} 
}catch(Exception e){ 
e.printStackTrace(); 
} 

%>


<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">window.history.forward();</script>
<style type="text/css">

.x-window-footer table{
    width:0
}
<!--
#uname,#j_password,#dynamicpass{
     height: 24px;
     line-height:24px;
     width:130px;
     vertical-align: middle;
}
body{overflow:hidden;margin:0;padding:0;}
form{margin:0;padding:0;}
table{border-collapse:collapse;width:100%;height:100%;}
*{font:12px arial;}
-->
</style>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/login.js"></script>
</head>
<body onload="javascripts:form1.uname.focus()" id="mybody">
<form name="form1" method="post" action="/j_acegi_security_check" onsubmit="javascript:return login();">
<input type='hidden' id="rndData" name="rndData" Value="<%=RndData%>">
<input type='hidden' id="encData" name="encData" Value="">
<input type='hidden' id="isusb" name="isusb" Value="<%=isUsb %>">
<input type='hidden' id="isIP" name="isIP" Value="<%=isIP %>">
<input type='hidden' id="ip" name="ip" Value="<%=ip %>">
<input type='hidden' id="isdx" name="isdx" Value="<%=isdx %>">
<input type="hidden" name="needauthcode" value="<%=needauthcode%>"/>
<input type="hidden" name="sendpass" value="<%=needdynamicpass %>">
<input type='hidden' id="j_username" name="j_username" value="<%=username%>">

 <%if(!StringHelper.isEmpty(sysid)){%>   
    <input type="hidden" name="sysid" value="<%=sysid%>">
<%}%>
<table>
<tr>
	<td style="text-align:center">
		<table style="width:1020px;height:590px;border:1px solid #C8C8C8">
		<tr>
			<td style="padding:0 0 0 60px"><img src="/images/login/login_logo.jpg"/></td>
		</tr>
		<tr>
			<td style="width:1020px;height:350px;background:url(/images/login/login_bg.jpg);vertical-align:top;">
				<div id ="messageDiv" style="height:20px;margin:115px 0 0 660px;color:#ff6666"><%=errorMessage%></div>
				<input type="text" id="uname" name="uname" tabindex="1" value="<%=username%>" style="margin:5px 0 0 660px;">
				<input type="<%=typestr%>" id="j_password" name="j_password" tabindex="2" style="margin:15px 0 0 660px">
				<%//if(needdynamicpass.equals("none")){%>					
					<input type="text" id="dynamicpass" name="dynamicpass" size="4" tabindex="4" style="width:60px;margin:8px 0 0 660px;display:none"/>					
					<input type="button" id="dynamicpassBtn" style="display:none;vertical-align:middle;border:0px;width:80px;height:22px;margin:8px 0 0 0px" value="获取动态密码" onclick="checkDynamicpass(this)"/><!-- 获取动态密码 -->
				<%//} else %>
				<%if(needauthcode.equals("1")){%>
					<img style="width:60px;height:20px;margin:10px 0 0 660px" align="absmiddle"  src="/ServiceAction/com.eweaver.base.RandOut">
					<input type="text" name="authcode" size="4" tabindex="3" style="width:70px;margin:10px 0 0 0px"/>
				<%}%>
				
				<input type="hidden" name="rememberme" value="1"><br>
				<button type="submit" style="border:0px;width:79px;height:30px;margin:8px 0 0 658px;background:url(/images/login/login_blank.gif);" value="登录" ><!-- 登录 -->登录 </button>
			</td>
		</tr>
		<tr>
			<td style="height:105px">
				<table>
				<tr>
					<td style="padding:10px 0 0px 60px;vertical-align:top">
						<img src="/images/login/weaver_logo.jpg" style="cursor:hand;" onclick="window.open('http://www.weaver.com.cn');"/>
					</td>
					<td style="padding:25px 0 0px 60px;vertical-align:top"><img src="/images/login/login_attention.jpg"/></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
	</td>
</tr>
</table>
</form>
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
</body>
<script type="text/javascript">
var myMask;
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