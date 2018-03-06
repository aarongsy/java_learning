<%@ page contentType="text/html;charset=gb2312" pageEncoding="GB2312" session="true"%>
<%request.setCharacterEncoding("GB2312");%>
<%@ include file="private.jsp"%>
<%
/*
*######################################
* eWebEditor v3.80 - Advanced online web based WYSIWYG HTML editor.
* Copyright (c) 2003-2006 eWebSoft.com
*
* For further information go to http://www.ewebsoft.com/
* This copyright notice MUST stay intact for use.
*######################################
*/


sPosition = sPosition + "修改用户名及密码";

out.print(Header());


if (sAction.equals("MODI")) {
	String sNewUsr = dealNull(request.getParameter("newusr"));
	String sNewPwd1 = dealNull(request.getParameter("newpwd1"));
	String sNewPwd2 = dealNull(request.getParameter("newpwd2"));

	if (sNewUsr.equals("")) {
		out.print(getError("新用户名不能为空！"));
		return;
	}
	if (sNewPwd1.equals("")) {
		out.print(getError("新密码不能为空！"));
		return;
	}
	if (!sNewPwd1.equals(sNewPwd2)) {
		out.print(getError("新密码和确认密码不相同！"));
		return;
	}

	sUsername = sNewUsr;
	sPassword = sNewPwd1;

	WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);

	%>
	<table border=0 cellspacing=1 align=center class=navi>
	<tr><th><%=sPosition%></th></tr>
	</table>

	<br>

	<table border=0 cellspacing=1 align=center class=list>
	<tr>
		<td>登录用户名及密码修改成功！</td>
	</tr>
	</table>
	<%
} else {
	%>
	<script language=javascript>
	function checklogin() {
		var obj;
		obj=document.myform.newusr;
		obj.value=BaseTrim(obj.value);
		if (obj.value=="") {
			BaseAlert(obj, "新用户名不能为空！");
			return false;
		}
		obj=document.myform.newpwd1;
		obj.value=BaseTrim(obj.value);
		if (obj.value=="") {
			BaseAlert(obj, "新密码不能为空！");
			return false;
		}
		if (document.myform.newpwd1.value!=document.myform.newpwd2.value){
			BaseAlert(document.myform.newpwd1, "新密码和确认密码不相同！");
			return false;
		}
		return true;
	}
	</script>

	<table border=0 cellspacing=1 align=center class=navi>
	<tr><th><%=sPosition%></th></tr>
	</table>

	<br>

	<table border=0 cellspacing=1 align=center class=form>
	<form action='?action=modi' method=post name=myform onsubmit="return checklogin()">
	<tr>
		<th>设置名称</th>
		<th>基本参数设置</th>
		<th>设置说明</th>
	</tr>
	<tr>
		<td width="15%">新用户名：</td>
		<td width="55%"><input type=text class=input size=20 name=newusr value="<%=htmlEncode(sUsername)%>"></td>
		<td width="30%"><span class=red>*</span>&nbsp;&nbsp;旧用户名：<span class=blue><%=htmlEncode(sUsername)%></span></td>
	</tr>
	<tr>
		<td width="15%">新 密 码：</td>
		<td width="55%"><input type=password class=input size=20 name=newpwd1 maxlength=30></td>
		<td width="30%"><span class=red>*</span></td>
	</tr>
	<tr>
		<td width="15%">确认密码：</td>
		<td width="55%"><input type=password class=input size=20 name=newpwd2 maxlength=30></td>
		<td width="30%"><span class=red>*</span></td>
	</tr>
	<tr><td align=center colspan=3><input type=submit name=bSubmit value="  提交  "></a>&nbsp;<input type=reset name=bReset value="  重填  "></td></tr>
	</form>
	</table>


	<%

}


out.print(Footer());
%>