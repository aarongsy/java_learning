<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%> 
<%@ page import="com.eweaver.workflow.request.service.OperateObjectService"%> 
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%> 
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService"%>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink"%>
<%@ page import="com.eweaver.base.security.service.acegi.InvalidException" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.eweaver.base.lics.service.LicsService"%>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");    
	String objid = request.getParameter("objid");
	String mtype = request.getParameter("mtype");
	SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
	OperateObjectService operateObjectService = (OperateObjectService) BaseContext.getBean("operateObjectService");
	HumresService humresService = (HumresService) BaseContext.getBean("humresService");
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
	boolean temp1=false;
	boolean temp2=false;
	boolean temp3=false;
	boolean temp4=false;
	String passcount ="";
	DataService dateservice = new DataService();
	String itemvalue = dateservice.getValue("select itemvalue from setitem where id='297e930d347445a101347445ca4e0000'");
	if("1".equals(itemvalue)){
		String sql ="select setitemid,passrule as passrule ,passcount as passcount,ispassmodel as ispassmodel from dynamicpassrule where setitemid='297e930d347445a101347445ca4e0000'";
		List<Map<String,Object>> list1 = dateservice.getValues(sql);
		String passrule = list1.get(0).get("passrule").toString().trim();
		int t = Integer.parseInt(passrule);
		passcount = list1.get(0).get("passcount").toString();
		boolean ispassmodel = list1.get(0).get("ispassmodel").toString().equals("1")?true:false;
		String texttype ="password";
		if(ispassmodel)texttype="text";
		switch (t){
		 case 5:
		  temp1 = true; //小写
		  break;
		 case 6:
		  temp2=true;//数字
		  break;
		 case 2:
		  temp3 = true;//xiaoshuzi
		  break;
		 case 3:
		  temp4 = true;//hum
		  break;
		}
	}
  
	String id = "";
	String logonname =""; 
	String isclosed = "0";		//帐号状态
	String isopenim = "0";		//是否启用IM
	String dynamicpass = "0";	//动态密码
	String isusbkey = "0";		//使用usbkey登录
	String usbkeyvalue = "";	//usbkey密钥
	String isIP = "0";			//外网IP登陆限制
	Sysuser sysuser = sysuserService.getSysuserByObjid(objid);
	if (sysuser!=null) {
		id = sysuser.getId();
		logonname = StringHelper.null2String(sysuser.getLongonname());
		logonname = logonname.replaceAll("\"","");
		mtype =  ""+sysuser.getMtype();
		isclosed = StringHelper.null2String(sysuser.getIsclosed(), "0");
		isopenim = StringHelper.null2String(sysuser.getIsopenim(), "0");
		dynamicpass = StringHelper.null2String(sysuser.getDynamicpass(),"0");
		isusbkey = StringHelper.null2String(sysuser.getIsusbkey(),"0");
		
		String selsql="select * from userkey where keyname='"+sysuser.getLongonname()+"'";
		List listusbkey=baseJdbcDao.getJdbcTemplate().queryForList(selsql);
		if(listusbkey.size()>0){
			usbkeyvalue=((Map) listusbkey.get(0)).get("keyvalue") == null ? "" : ((Map) listusbkey.get(0)).get("keyvalue").toString();
		}
		
		isIP = StringHelper.null2String(sysuser.getIsIP(),"0");
	}
	
	// 是否人力资源管理员 
	boolean isHumresAdmin = false;
	String humresroleid = "402881e50bf0a737010bf0b021bb0006";//人力资源管理员角色id
	PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
	Humres humres = humresService.getHumresById(StringHelper.null2String(objid));
	isHumresAdmin = permissionruleService.checkUserRole(currentuser.getId(),humresroleid,humres.getOrgid());
	if(!isHumresAdmin){	//如果不是人力资源管理员,那么检查该用户是否拥有帐号管理的权限
		isHumresAdmin = permissionruleService.checkUserPerms(currentuser.getId(), "402881d20d1a344f010d1bb9432c000e");
	}	   
	if (!isHumresAdmin && !currentuser.getId().equals(objid)){
		response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
		return;   
	}
    
    //判断修改密码的时候是否需要当前密码,仅在以下两种情况时修改密码不需要当前密码
    //1.当账户是新建的(无用户名和密码)  2.是系统管理员在修改其他人的密码(不包括系统管理员自己)
    boolean isNeedCurrPass = !((sysuser == null || sysuser.getId() == null || StringHelper.isEmpty(sysuser.getLongonname())) 
    							|| (isSysAdmin && !suser.getId().equals(sysuser.getId())));
    
	
    boolean isNoLogonnameForOpenAccount = (sysuser == null || StringHelper.isEmpty(sysuser.getLongonname()));
//    LicsService licsService = (LicsService)BaseContext.getBean("licsService");
String rvalue = "0";
try{
	operateObjectService.isOpen(sysuser);
} catch(InvalidException e) {
	rvalue = "-1";
}
	
//	String rvalue = licsService.checkLics(null);
    boolean isNoLicsForOpenAccount = (!rvalue.equals("0"));
 %>
<html>
<head>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/complexify/jquery.complexify.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/complexify/jquery.complexify.wrap.js"></script>
	<link type="text/css" rel="stylesheet" href="/js/jquery/plugins/complexify/jquery.complexify.css"/> 
	<style>
		.topbar_login A.login {
			TEXT-ALIGN: center; LINE-HEIGHT: 23px; MARGIN-TOP: 4px; WIDTH: 53px; DISPLAY: block; FLOAT: left; HEIGHT: 23px; OVERFLOW: hidden; FONT-WEIGHT: bold
		}
		.topbar_login A.login:link {
			BACKGROUND: url(../../../images/common/topbar/topbar.png) no-repeat 0px -140px
		}
		.topbar_login A.login:visited {
			BACKGROUND: url(../../../images/common/topbar/topbar.png) no-repeat 0px -140px
		}
		.topbar_login A.login:hover {
			BACKGROUND: url(../../../images/common/topbar/topbar.png) no-repeat -60px -140px; TEXT-DECORATION: none
		}
		.cbox{
			height:13px; 
			vertical-align:text-top; 
			margin-top:1px;
		}
		.statusText{
			margin-left: 3px;
		}
		.statusText_enable{
			font-weight: bold;
		}
		.statusText_unEnable{
			color: #777;
		}
		.FieldName_unEnable{
			color: #777 !important;
		}
		.marsk{
			position: absolute;
			background-image: url("/images/base/loading.gif");
			background-repeat: no-repeat;
			background-color: #fff; 
			padding-left: 31px;
			font-family: Microsoft YaHei;
			z-index: 100;
		}
		.layouttable td{
			padding-top: 2px;
			padding-bottom: 2px;
		}
	</style>
	<script>
		$(function(){
			disabledSpacebarForPassword();
			$("#logonpass").complexifyWrap();
			$("#logonpass").keyup();
		});
		
		//输入密码时禁用掉空格键
		function disabledSpacebarForPassword(){
			var logonpass = document.getElementById("logonpass");
			if(logonpass.attachEvent){
				logonpass.attachEvent("onkeydown", disabledSpacebarHandler);
			}else if(logonpass.addEventListener){
				logonpass.addEventListener("keydown", disabledSpacebarHandler, false);
			}
			
			function disabledSpacebarHandler(e){
				if(e.keyCode == 32){	//空格键
					e.returnValue = false;
				}
			}
		}
	</script>
</head>
<body>
<!--页面菜单开始-->
<%
pagemenustr += "{S,"+ labelService.getLabelNameByKeyId("0ad99e4d522b4ea193e15bd99a6e9b65") +",javascript:onSubmit()}";
%>
<div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysuserAction?action=createmodify" name="EweaverForm" id="EweaverForm"  method="post">
	<input type="hidden" name="objid"  value="<%=objid%>"/>
	<input type="hidden" name="id"  value="<%=id%>"/>
	<input type="hidden" name="mtype"  value="<%=mtype%>"/>
	<table border=0 cellpadding=0 cellspacing=0 class="layouttable"> 
		<colgroup> 
			<col width="20%">
			<col width="80%">
		</colgroup>	
	<tr>
		<td  class="settingDataGroup" colspan="2">
			<b><%=labelService.getLabelName("402881eb0bcbfd19010bccd7006a0041")%>/<%=labelService.getLabelName("402881eb0bcbfd19010bccd7f1bd0042")%> </b>
		</td>
	</tr>
	<tr>
		<TD class="FieldName"><LABEL for=username><%=labelService.getLabelName("402881eb0bcbfd19010bccd7006a0041")%> <FONT color=red>*</FONT></LABEL></TD>
		<td class="FieldValue">
		<input type="text" tabIndex=3 maxLength=15 size=25 onblur=checkusername() name="logonname" id="logonname" value="<%=logonname%>" onChange="checkInput('logonname','logonnamespan')" <%if (!isHumresAdmin){%><%="readOnly"%><%}%>/>
		<span id="logonnamespan"/>&nbsp;<%=StringHelper.null2String(request.getAttribute("msg"))%></span>
		</td>
	</tr>
	<% if(isNeedCurrPass){%>
	<TR><!-- 当前密码 -->
		<TD class="FieldName"><LABEL for=currPassword><%=labelService.getLabelNameByKeyId("402883953cfbf58e013cfbf590660001") %><FONT color=red>*</FONT></LABEL></TD>
        <TD class="FieldValue">           
          	<input type="password" id="currlogonpass" name="currlogonpass" tabIndex=4 size=25 value="" onblur="$('#currlogonpassspan').html('');"/>
			<span id="currlogonpassspan" style="color: red;"/><%=StringHelper.null2String(request.getAttribute("currlogonpassMsg"))%></span>
        </TD>
	</TR>		
	<% }%>
	<TR><!-- 新密码 -->
		<TD class="FieldName"><LABEL for=password><%=labelService.getLabelNameByKeyId("402883953cfbf58e013cfbf590660003") %><FONT color=red>*</FONT></LABEL></TD>
        <TD class="FieldValue">           
          	<input type="password"  id=logonpass name="logonpass" tabIndex=4 size=25 value="<%=StringHelper.null2String(request.getAttribute("newlogonpass"))%>" onblur="checkInputPASS('logonpass');checkInputPASSSame('logonpass2','logonpass');"/>
			<span id="logonpassspan"/></span>
        </TD>
	</TR>
	<TR><!-- 确认新密码 -->
		<TD class="FieldName"><LABEL for=password2><%=labelService.getLabelNameByKeyId("402883953cfbf58e013cfbf590670005") %><FONT color=red>*</FONT></LABEL></TD>
		<TD class="FieldValue">
			<input type="password" id=logonpass2  name="logonpass2" tabIndex=5 size=25 value="<%=StringHelper.null2String(request.getAttribute("newlogonpass"))%>" onblur="checkInputPASSSame('logonpass2','logonpass');"/>
			<span id="logonpass2span"/>&nbsp;</span>
		</TD>
    </TR>
	<tr>
		<td class="settingDataGroup" colspan="2">
			<b><%=labelService.getLabelNameByKeyId("761e5f5378984bf185df93e60997905d") %></b>
		</td>
	</tr>
	<%
		PropertiesHelper propertiesHelper = new PropertiesHelper();
		Setitem setitemIM = setitemService.getSetitem("40288347363855d101363855d2030293");
		boolean isEnabledIM = propertiesHelper.isEnabledWeaverim() && "1".equals(setitemIM.getItemvalue());
        if(isEnabledIM){
    %>
	<tr>
	    <td class="FieldName" nowrap>
		    <%=labelService.getLabelName("402883473638890b013638891515028d")%> <!-- 启用IM  -->
		</td>
		<td class="FieldValue">
            <%if(isHumresAdmin){%>
            	<input type="checkbox" class="cbox" id="isopenim" onclick="javascript:changeStatus('isopenim','isopenim');" value="1"/><span class="statusText"></span>
            <%}else{%>
                <%if(isopenim.equals("1")){%><%=labelService.getLabelName("4028831334d4c04c0134d4c04e980012")%><%}%>	<!-- 打开 -->
                <%if(isopenim.equals("0")){%><%=labelService.getLabelName("297eb4b8126b334801126b906528001d")%><%}%>	<!-- 关闭 -->
            <%}%>
            <input type="hidden" name="isopenim" value="<%=isopenim %>">
		</td>
	</tr>
	<%	} %>
	<tr <%if("402881e70be6d209010be75668750014".equals(objid)){%> style="display: none;" <%}%>>
		<td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bccd900700044")%>	<!-- 帐号状态  -->
		</td>
		<td class="FieldValue">
			<%if(isHumresAdmin){%>
				<input type="checkbox" class="cbox" id="isclosed" onclick="javascript:changeStatus('isclosed','isclosed');" value="0"/><span class="statusText"></span>
			<%}else{%>
                <%if(isclosed.equals("0")){%><%=labelService.getLabelName("4028831334d4c04c0134d4c04e980012")%><%}%>	<!-- 打开 -->
                <%if(isclosed.equals("1")){%><%=labelService.getLabelName("297eb4b8126b334801126b906528001d")%><%}%>	<!-- 关闭 -->
            <%}%>
            <input type="hidden" name="isclosed" value="<%=isclosed %>">
            <span id="isclosedspan" style="margin-left: 5px; color: red;"></span>
		</td>
	</tr>
	<%
		Setitem setitemDynamicpass = setitemService.getSetitem("402888534deft8d001besxe952edgy15");
		boolean isEnabledDynamicpass = "1".equals(setitemDynamicpass.getItemvalue());
		if(isEnabledDynamicpass) {
	%>
	<tr>
		<td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0009") %><!-- 使用动态密码 -->
		</td>
		<td class="FieldValue">
			<%if(isHumresAdmin){%>
				<input type="checkbox" class="cbox" id="dynamicpass" onclick="javascript:changeStatus('dynamicpass','dynamicpass');" value="1"/><span class="statusText"></span>
			<%}else{%>
                <%if(dynamicpass.equals("1")){%><%=labelService.getLabelName("4028831334d4c04c0134d4c04e980012")%><%}%>	<!-- 打开 -->
                <%if(dynamicpass.equals("0")){%><%=labelService.getLabelName("297eb4b8126b334801126b906528001d")%><%}%>	<!-- 关闭 -->
            <%}%>
            <input type="hidden" name="dynamicpass" value="<%=dynamicpass %>">
		</td>
	</tr>
	<%	} %>	
	<%
		Setitem setitemUsbkey = setitemService.getSetitem("402888534deft8d001besxe952edgy16");
		boolean isEnabledUsbkey = "1".equals(setitemUsbkey.getItemvalue());
		if(isEnabledUsbkey) {
	%>
	<tr>
		<td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f000a") %><!-- 使用usbkey登录 -->
		</td>
		<td class="FieldValue">
			<%if(isHumresAdmin){%>
				<input type="checkbox" class="cbox" id="isusbkey" onclick="javascript:changeStatus('isusbkey','isusbkey');" value="1"/><span class="statusText"></span>
			<%}else{%>
                <%if(isusbkey.equals("1")){%><%=labelService.getLabelName("4028831334d4c04c0134d4c04e980012")%><%}%>	<!-- 打开 -->
                <%if(isusbkey.equals("0")){%><%=labelService.getLabelName("297eb4b8126b334801126b906528001d")%><%}%>	<!-- 关闭 -->
            <%}%>
            <input type="hidden" name="isusbkey" value="<%=isusbkey %>">
		</td>
	</tr>
	<%	} %>
	<%
		if(isEnabledUsbkey && isHumresAdmin) {
	%>
	<tr>
		<td class="FieldName" nowrap>
		   <%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f0008") %><!-- usbkey密钥 -->
		</td>
		<td class="FieldValue">
			<input type="text" size=25 id="usbkeyvalue" name="usbkeyvalue" value="<%=usbkeyvalue%>"  />
			<a href="javascript:changeStatus('usbkeyvalue','usbkeyvalue');" style="margin-left: 3px;">保存修改</a>
		</td>
	</tr> 
	<%	}else{ %>
			<input type="hidden" name="usbkeyvalue" value="<%=usbkeyvalue%>"/>
	<%	} %>
	<%
		Setitem setitemIP = setitemService.getSetitem("4028836134c18c690134c18c6b680000");
		boolean isEnabledIP = "1".equals(setitemIP.getItemvalue());
		if(isEnabledIP){
	%>
	<tr>
		<td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f000b") %><!-- 外网IP登陆限制 -->
		</td>
		<td class="FieldValue">
			<%if(isHumresAdmin){%>
				<input type="checkbox" class="cbox" id="isIP" onclick="javascript:changeStatus('isIP','isIP');" value="1"/><span class="statusText"></span>
			<%}else{%>
                <%if(isIP.equals("1")){%><%=labelService.getLabelName("4028831334d4c04c0134d4c04e980012")%><%}%>	<!-- 打开 -->
                <%if(isIP.equals("0")){%><%=labelService.getLabelName("297eb4b8126b334801126b906528001d")%><%}%>	<!-- 关闭 -->
            <%}%>
            <input type="hidden" name="isIP" value="<%=isIP%>"/>
		</td>
	</tr>
	<%	} %>
</table>
</form> 
<script type="text/javascript">
function checkPwd(pwd1,pwd2){
	if (pwd1 == pwd2) {
		return true;
     }else{
		return false;
	}
}
   
function onSubmit(){
 	checkfields="logonname,logonpass";
 	<%if(isNeedCurrPass){%>
 		checkfields += ",currlogonpass";
 	<%}%>
 	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
	if(checkForm(EweaverForm,checkfields,checkmessage) && updatepasswork()){
		if (checkPwd(document.all("logonpass").value,document.all("logonpass2").value)){
			document.EweaverForm.submit();
		}else{
			alert("<%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f000d") %>");//两次密码不相同
		}
	}
	event.srcElement.disabled = false;
}

function switchMaster(obj) {
    if (obj.value == "1") {
        document.all("multiAccount").style.display = "none";
    } else {
        document.all("multiAccount").style.display = "block";
    }
}
var req;
function validate(objid) {
    var idField = document.getElementById("logonname");  
    var url = "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysuserAction?action=validate&&objid="+objid+"&&logonname=" + escape(idField.value);

    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }

    req.open("GET", url, true);
    req.onreadystatechange = callback;
    req.send(null);
}

function callback() {
    if (req.readyState == 4) {
        if (req.status == 200) {
       		 parseMessage;
            //alert(req.responseText);           
        }
    }
}

function parseMessage() {
	document.getElementById("userIdMessage").innerHTML = req.responseText;
    //var message = req.responseXML.getElementsByTagName("msg")[0];
    //setMessage(message.childNodes[0].nodeValue);
}

function setMessage(message) {
     var userMessageElement = document.getElementById("userIdMessage");
     userMessageElement.innerHTML = "<font color=\"red\">" + message + " </font>";
}
function updatepasswork(){
	if (checkPwd(document.getElementById("logonpass").value,document.getElementById("logonpass2").value)){
		if(!checkInputPASS('logonpass')){
			return false;
		}
		if(!checkInputPASS('logonpass2')){
			return false;
		}
		document.getElementById("logonpass2span").innerHTML="";
		document.EweaverForm.submit();
	}else{
		document.getElementById("logonpass2span").innerHTML="<font color='red'><%=labelService.getLabelNameByKeyId("402883f635850b880135850b886f000d") %></font>";//两次密码不相同
		return false;
	}
}
/**
 * 验证长度处理函数
 * @param {Object} elementname
 * @param {Object} min
 * @param {Object} max
 * @return {TypeName} 
 */
function checkInputLenthnew(elementname){
	var tmpvalue = document.getElementById(elementname).value;
	var tmpvalue = Trim(tmpvalue);
	<%if(!"".equals(passcount)){%>
	if(tmpvalue.length >= <%=passcount%>){
		document.getElementById(elementname+"span").innerHTML="";
		 return true;
	}
	else{
	 	msg='<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002c") %>'+<%=passcount%>+'<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002d") %>';//请输入不小于//位字符
	 	document.getElementById(elementname+"span").innerHTML="<font color='red'>"+msg+"</font>";
	 	return false;
	}
	<%}%>
}
 /*
  * 验证包含数字  
  * @param {Object} elementname
  * @param {Object} min
  * @param {Object} max
  * @return {TypeName} 
  */
 function checkInputPASS(elementname){
	var tmpvalue = document.getElementById(elementname).value;
	var tmpvalue = Trim(tmpvalue);
	<%if(temp1){%>
	if(checkInputLenthnew(elementname)){
	if(!/[a-z]+/.test(tmpvalue)){
		msg="&nbsp;<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002e") %>";//输入密码不符合小写字母!
	 	msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>"+msg+"</font>";
	 	warning(elementname,msg);
	 	return false;
	}else{
		
	 	msg="<img src=\"/images/base/bacocheck.gif\" width=\"13\" height=\"13\">";
	 	warning(elementname,msg);
	 	return true;
	 	}
	}
	<%
	}
	else if(temp4){%>
	if(checkInputLenthnew(elementname)){
	if(!/[0-9]+/.test(tmpvalue)||!/[A-Z]+/.test(tmpvalue)||!/[a-z]+/.test(tmpvalue)){
		msg="&nbsp;<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be4002f") %>";//输入密码不符合数字加大小写字母!
	 	msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>"+msg+"</font>";
	 	warning(elementname,msg);
	 	return false;
	}else{
	 	msg="<img src=\"/images/base/bacocheck.gif\" width=\"13\" height=\"13\">";
	 	warning(elementname,msg);
	 	return true;
	 	}
	}
	<%}
	else if(temp2){%>
	if(checkInputLenthnew(elementname)){
	if(!/[0-9]+/.test(tmpvalue)){
		msg="&nbsp;<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40030") %>";//输入密码不符合数字!
	 	msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>"+msg+"</font>";
	 	warning(elementname,msg);
	 	return false;
	}else{
	 	msg="<img src=\"/images/base/bacocheck.gif\" width=\"13\" height=\"13\">";
	 	warning(elementname,msg);
	 	return true;
	 	}
	}
	<%
	}
	else if(temp3){%>
	if(checkInputLenthnew(elementname)){
	if(!/[0-9]+/.test(tmpvalue)||!/[a-z]+/.test(tmpvalue)){
		msg="&nbsp;<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be40031") %>";//输入密码不符合数字加小字母!
	 	msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>"+msg+"</font>";
	 	warning(elementname,msg);
	 	return false;
	}else{
	 	msg="<img src=\"/images/base/bacocheck.gif\" width=\"13\" height=\"13\">";
	 	warning(elementname,msg);
	 	return true;
	 	}
	}
	<%}
	else{%>
		msg="<img src=\"/images/base/bacocheck.gif\" width=\"13\" height=\"13\">";
	 	warning(elementname,msg);
	 	return true;
	<%}%>
	
	return true;
}
/*
  * 验证是否一样 
  * @param {Object} elementname
  * @param {Object} min
  * @param {Object} max
  * @return {TypeName} 
  */
 function checkInputPASSSame(elementname,elementnameform){
	var tmpvalue = document.getElementById(elementname).value;
	//var tmpvalue = Trim(tmpvalue);
	var tmpvalue2 = document.getElementById(elementnameform).value;
	//var tmpvalue2 = Trim(tmpvalue2);
	var msg="";
	if(tmpvalue.length>0){
		if(tmpvalue2==tmpvalue){
			msg="<img src=\"/images/base/bacocheck.gif\" width=\"13\" height=\"13\">";
	 		warning(elementname,msg);
	 		return true;
		}else{
			msg="&nbsp;<%=labelService.getLabelNameByKeyId("265b6f3fc75d4c309e9e23432fde3ef8") %>";//两次输入的密码不一致，请检查后重试。The passwords you entered do not match. Please re-enter your passwords. 
	 		msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>"+msg+"</font>";
	 		warning(elementname,msg);
	 		return false;
		}

	}else{
	 	msg="";
	 	warning(elementname,msg);
	 	return true;
	}
	return true;
 }
	var lastusername="<%=logonname%>";
	function checkusername() {
		var logonname = document.getElementById("logonname");
		//未过滤@ . _
		var flag = false;
		for(var i = 0; i < logonname.value.length; i++){
			var c = logonname.value.charAt(i);
			var isChinese = /[\u4E00-\u9FA5]/gi.test(c);
			var isLetter = /[a-zA-Z]/gi.test(c);
			var isNumber = /[0-9]/gi.test(c);
			var isSpecialChar = /[@._]/gi.test(c);
			if(!isChinese && !isLetter && !isNumber && !isSpecialChar){
				flag = true;
				break;
			}
		}		 
		if(flag){
			msg="<img src=\"/images/base/bacocross.gif\" width=\"13\" height=\"13\"><font color='red'>帐号中包含特殊字符，请更正</font>";
			warning("logonname",msg);
			logonname.value = "";
			logonname.focus();
		}
		return;
		var username = Trim($('logonname').value);
		if(username == lastusername) {
			return;
		} else {
			lastusername = username;
		}
		var cu = '<%=StringHelper.null2String(request.getAttribute("msg"))%>';
		var unlen = username.replace(/[^\x00-\xff]/g, "**").length;
 
		if(unlen < 3 || unlen > 15) {
			warning(cu, unlen < 3 ? profile_username_tooshort : profile_username_toolong);
			return;
		}
        ajaxresponse(username);
	}
	function warning(elementname,msg)
	{
		document.getElementById(elementname+"span").innerHTML=msg;
	}
	function ajaxresponse(username) {
	
		Ext.Ajax.request({
						 url: '/app/ft/taskDeal.jsp?action='+type+'',//执行ajax处理的jsp, 参数传递是id1,id2,id3......
						 params:{username:username},
						 success: function(res) {
							 var str=res.responseText;
							 if(str.indexOf('succeed')>-1)
							 {
								obj.style.display = '';
                				obj.innerHTML = '<img src="/images/base/bacocheck.gif" width="13" height="13">';
                				obj.className = "warning";
							 }else
							 {
							 	warning(obj, s);//您输入的用户名已经被他人使用 Your username is already in use by someone else
							 	
							 }
						 }
		});
	
	}
	
	function checkpassword2(confirm) {
		var password = $('password').value;
		var password2 = $('password2').value;
		var cp2 = $('checkpassword2');
		if(password2 != '') {
			checkpassword(true);
		}
		if(password == '' || (confirm && password2 == '')) {
			cp2.style.display = 'none';
			return;
		}
		if(password != password2) {
			warning(cp2, profile_passwd_notmatch);
		} else {
			cp2.style.display = '';
			cp2.innerHTML = '<img src="/images/base/bacocheck.gif" width="13" height="13">';
		}
	}
	
	function changeStatus(eleId,fieldName){
		var ele = document.getElementById(eleId);
		var eleType = ele.getAttribute("type").toLowerCase();
		var v;
		if(eleType == "checkbox"){
			v = ele.checked ? ele.value : (1 - parseInt(ele.value)); //此处(1 - parseInt(ele.value))是为了达到勾中或未勾中时1，0互反
		}else if(eleType == "text" || eleType == "password"){
			v = ele.value;
		}else{
			alert("无法识别所操作的元素类型");
			reurn;
		}
		<% if(isNoLogonnameForOpenAccount){ %>
			if(fieldName == "isclosed" && v == "0"){
				$("#isclosedspan").html("此用户没有账号，无法打开");
				ele.checked = false;
				return;
			}
		<% } %>
		<% if(isNoLicsForOpenAccount){ %>
			if(fieldName == "isclosed" && v == "0"){
				$("#isclosedspan").html("无License, 无法打开帐号");
				ele.checked = false;
				return;
			}
		<% } %>
		$.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI("/ServiceAction/com.eweaver.base.security.servlet.SysuserAction?action=modifyAccountStatus&id=<%=id%>&v=" + v + "&fieldName=" + fieldName),
		 	data: "{}",
		 	async: false,
		 	beforeSend: function(XMLHttpRequest){
		 		createMask(eleId);
		 		return true;
		 	},
		 	success: function(responseText, textStatus) 
		 	{
		 		var resultObj = $.parseJSON(responseText);
		 		var saveFlag = resultObj["saveFlag"];
		 		if(saveFlag == "0"){
		 			alert("操作失败");
		 			removeMask(eleId);
		 		} else if(saveFlag == "2"){
		 			var toPage = resultObj["toPage"];
		 			window.location.href = toPage;
		 		}else if(saveFlag == "1"){
		 			$("input[type='hidden'][name='"+eleId+"']").val(v);
		 			removeMaskAndChangeStyle(eleId);
		 		}
		 	},
		 	error: function (XMLHttpRequest, textStatus, errorThrown) {
			    alert(errorThrown);
			    removeMask(eleId);
			}
		});
	}
	
	function createMask(eleId){
		$ele = $("#" + eleId);
		var t = $ele.parent().offset().top + 1;
		var l = $ele.parent().offset().left + 1; 
		var w = $ele.parent().outerWidth() - 1;
		var h = $ele.parent().outerHeight() - 2;
		var $mask = $("<div id='mask_"+eleId+"' class='marsk'>正在保存,请稍候...</div>");
		$mask.css({'top': t+'px', 'left': l+'px', 'width': w+'px', 'height': h+'px', 'line-height': h+'px', 'background-position': '10px '+((h-16)/2)+'px'});
		$(document.body).append($mask);
	}
	
	function removeMaskAndChangeStyle(eleId){
		setTimeout(function(){
			$("#mask_" + eleId).remove();
			changeStatusTextAndStyle();
		},400);
	}
	
	function removeMask(eleId){
		$("#mask_" + eleId).remove();
	}
	
	function doChecked(eleId, v){
		var ele = document.getElementById(eleId);
		if(ele){
			ele.checked = ele.value == v ? true : false;
		}
	}
	
	function changeStatusTextAndStyle(){
		var eleIds = ["isopenim","isclosed","dynamicpass","isusbkey","isIP"];
		for(var i = 0; i < eleIds.length; i++){
			var eleId = eleIds[i];
			var $ele = $("#" + eleId);
			if($ele.length > 0){
				var $statusText = $ele.parent().find(".statusText");
				var $fieldName = $ele.parent().prev();
				if($ele[0].checked){
					$statusText.html("已打开");
					$statusText.removeClass("statusText_unEnable");
					$statusText.addClass("statusText_enable");
					$fieldName.removeClass("FieldName_unEnable");
				}else{
					$statusText.html("打开");
					$statusText.removeClass("statusText_enable");
					$statusText.addClass("statusText_unEnable");
					$fieldName.addClass("FieldName_unEnable");
				}
			}
		}
		var $usbkeyvalue = $("#usbkeyvalue");
		if($usbkeyvalue.length > 0){
			var $fieldName = $usbkeyvalue.parent().prev();
			if($usbkeyvalue.val() != ""){
				$fieldName.removeClass("FieldName_unEnable");
			}else{
				$fieldName.addClass("FieldName_unEnable");
			}
		}
	}
	
	window.onload = function(){
		doChecked('isopenim','<%=isopenim%>');
		doChecked('isclosed','<%=isclosed%>');
		doChecked('dynamicpass','<%=dynamicpass%>');
		doChecked('isusbkey','<%=isusbkey%>');
		doChecked('isIP','<%=isIP%>');
		changeStatusTextAndStyle();
	};
</script>

  </body>
</html>
