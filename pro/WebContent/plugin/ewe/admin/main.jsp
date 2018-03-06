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


sPosition = sPosition + "后台管理首页";

out.print(Header());


	%>

	<table border=0 cellspacing=1 align=center class=navi>
	<tr><th><%=sPosition%></th></tr>
	</table>

	<br>

	<table border=0 cellspacing=1 align=center class=list>
	<tr><th colspan=2>eWebEditor 3.8 版权、常用联系方法、技术支持</th></tr>
	<tr>
		<td width="15%">软件版本：</td>
		<td width="85%">eWebEditor Version 3.8 简体中文专业版</td>
	</tr>
	<tr>
		<td width="15%">版权所有：</td>
		<td width="85%"><a href="http://www.ewebsoft.com" target="_blank">eWebSoft.com</a>&nbsp;&nbsp;已获得国家版权局颁发的《计算机软件著作权登记证书》,登记号:2004SR06549</td>
	</tr>
	<tr>
		<td width="15%">程序制作：</td>
		<td width="85%">eWeb开发团队</td>
	</tr>
	<tr>
		<td width="15%">主页地址：</td>
		<td width="85%"><a href="http://www.eWebSoft.com" target=_blank>http://www.eWebSoft.com</a>&nbsp;&nbsp;&nbsp;<a href="http://www.webasp.net" target=_blank>http://www.webasp.net</a></td>
	</tr>
	<tr>
		<td width="15%">产品介绍：</td>
		<td width="85%"><a href="http://www.eWebEditor.net" target=_blank>http://www.eWebEditor.net</a></td>
	</tr>
	<tr>
		<td width="15%">论坛地址：</td>
		<td width="85%"><a href="http://bbs.webasp.net" target=_blank>http://bbs.webasp.net</a></td>
	</tr>
	<tr>
		<td width="15%">联系方式：</td>
		<td width="85%">OICQ:589808&nbsp;&nbsp;&nbsp;&nbsp;Email:<a href="mailto:service@ewebsoft.com">service@ewebsoft.com</a></td>
	</tr>
	</table>

	<br>

	<table border=0 cellspacing=1 align=center class=list>
	<tr><th colspan=2>服务器的有关参数</th></tr>
	<tr>
		<td width="20%">服务器名：</td>
		<td width="80%"><%=request.getServerName()%></td>
	</tr>
	<tr>
		<td width="20%">服务器IP：</td>
		<td width="80%"><%=request.getRemoteAddr()%></td>
	</tr>
	<tr>
		<td width="20%">服务器端口：</td>
		<td width="80%"><%=String.valueOf(request.getServerPort())%></td>
	</tr>
	<tr>
		<td width="20%">服务器时间：</td>
		<td width="80%"><%=(new java.util.Date() ).toLocaleString()%></td>
	</tr>
	<tr>
		<td width="20%">URI路径：</td>
		<td width="80%"><%=request.getRequestURI()%></td>
	</tr>
	<tr>
		<td width="20%">Servlet路径：</td>
		<td width="80%"><%=request.getServletPath()%></td>
	</tr>
	<tr>
		<td width="20%">Context路径：</td>
		<td width="80%"><%=request.getContextPath()%></td>
	</tr>
	<tr>
		<td width="20%">物理路径：</td>
		<td width="80%"><%=application.getRealPath("/")%></td>
	</tr>
	<tr>
		<td width="20%">Server Info：</td>
		<td width="80%"><%=getServletConfig().getServletContext().getServerInfo()%></td>
	</tr>
	</table>

<%
out.print(Footer());
%>
