<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.ClientType" %>
<%
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
String detailid = (String)request.getParameter("detailid");
if(StringHelper.isEmpty(detailid)) {
	String url = "/mobile/plugin/6/list.jsp";
	if(request.getQueryString()!=null&&!"".equals(request.getQueryString())) url += "?" + request.getQueryString();
	response.sendRedirect(url);
	return;
}
String from = StringHelper.null2String((String)request.getParameter("from"));
String module = StringHelper.null2String((String)request.getParameter("module"));
String scope = StringHelper.null2String((String)request.getParameter("scope"));
String mobileSession = StringHelper.null2String((String)request.getParameter("mobileSession"));
WebServiceData serviceData = pluginService.getMyHumresNameByUserid(detailid);
String statusname = StringHelper.null2String((String)serviceData.getMainData().get("HRSTATUS"));//人事状态
String objname =  StringHelper.null2String((String)serviceData.getMainData().get("OBJNAME"));
String deptname =  StringHelper.null2String((String)serviceData.getMainData().get("ORGID"));
String manager =  StringHelper.null2String((String)serviceData.getMainData().get("MANAGER"));
String jobtitle =  StringHelper.null2String((String)serviceData.getMainData().get("MAINSTATION"));
String email =  StringHelper.null2String((String)serviceData.getMainData().get("EMAIL"));
String telephone =  StringHelper.null2String((String)serviceData.getMainData().get("TEL1"));
String mobile =  StringHelper.null2String((String)serviceData.getMainData().get("TEL2"));
String location =  StringHelper.null2String((String)serviceData.getMainData().get("OFFICEADDR"));
String headerpic =  StringHelper.null2String((String)serviceData.getMainData().get("IMGFILE"));
String clienttype = StringHelper.null2String(request.getParameter("clienttype"));
%>

<!DOCTYPE html>
<html>
<head>
	<title><%=objname%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	
	<!-- private css -->
	<style>
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		background: #00538D;
	}
	a {
		text-decoration: none;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
	}
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	#header #title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
		.personnelInfo {
			height:38px;;margin-left:18px;margin-right:10px;
		}
		/* 流程创建人头像区域  */
		.itempreview {
			float:left;
			height:36px;
			width:36px;
			text-align:center;
			border: 1px solid #fff; 
			background:#fff;
			-moz-border-radius: 4px;
			-webkit-border-radius: 4px; 
			border-radius:4px;
		}
		/* 流程创建人头像  */
		.itempreview img {
			width:36px;height:36px;
		}
		/* 列表项内容区域 */
		.itemcontent {
			width:100%;
			float:left;
			height:38px;
			font-size:14px;
		}
		
		/* 列表项内容名称 */
		.itemcontenttitle {
			height:18px;
			margin-top:2px;
			overflow-y:hidden;
			line-height:18px;
			font-weight:bold;
			word-break:keep-all;
			text-overflow:ellipsis;
			white-space:nowrap;
			overflow:hidden;
			font-size:14px;
			color:#405B89;
		}
		
		/* 列表项内容简介 */
		.itemcontentitdt {
			height:18px;
			overflow-y:hidden;
			line-height:18px;
			font-size:12px;
			color:#858788;
			word-break:keep-all;
			text-overflow:ellipsis;
			white-space:nowrap;
			overflow:hidden;
		}
		
		.ppost {
			font-size:12px;
		}
		
		
		.viewTblTop {
			width:100%;height:29px;
		}
		.viewTblTitle {
			width:60px;text-align:right;float:left;font-size:12px;color:#666666;
		}
		.viewTblContent {
			float:left;font-size:12px;
		}
		
		.viewTblCenter {
			width:100%;height:23px;border-top:1px solid #BBBBBB;border-bottom:1px solid #BBBBBB;
		}
		
		.viewTblHeight29 {
			height:29px;line-height:29px;
		}
		
		.viewTblHeight23{
			height:23px;line-height:23px;
		}
		
		.viewTblHeight26{
			height:26px;line-height:26px;
		}
		.operatingInfo {
			height:70px;
			margin-left:10px;
			margin-right:10px;
			background:#fff;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px; 
			border-radius:5px;
			border:1px solid #BBBBBB;
		}
		
		.operationBt {
			float:left;
			height:26px;
			margin-left:28px;
			margin-top:5px;
			line-height:26px;
			font-size:14px;
			color:#fff;
			text-align:center;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px; 
			border-radius:5px;
			border:1px solid #0084CB;
			background:#0084CB;
			background: -moz-linear-gradient(0, #30B0F5, #0084CB);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB));
			
			overflow:hidden;
		}
		.width104 {
			width:104px;
		}
		.width234 {
			width:234px;
		}
		.clearBoth {
			clear:both;
		}
	</style>
</head>
<body>
<%if(ClientType.WEB.toString().equalsIgnoreCase(clienttype)) { %>  	
     <div id="header">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:history.go(-1);">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;font-size:9pt;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title">员工信息</div>
					</td>
				</tr>
			</table>
		</div>
		<%} %>
		<div class="lineSpacing" style="width:100%;height:6px;overflow:hidden;"></div>
	<div  class="content" style="width:100%;height:100%;background:url(/mobile/images/viewBg.png) 0 0 repeat;">
		<div class="lineSpacing" style="width:100%;height:10px;overflow:hidden;"></div>		
		<!-- 详细区域 -->
		<div class="detailedblock" id="detailedblock" style="width:100%;">
			<!-- 人员信息 -->
			<div class="personnelInfo">
				<div class="itemcontent">
					<div class="itempreview">
					<%
					if (headerpic == null || "".equals(headerpic)) {
					%>
						<!-- 默认头像 -->
						<img src="/images/default.png">
					<%
					} else {
					%>
						<img src="/download.do?url=<%=headerpic %>">
					<%
					}
					%>
					</div>
					<div class="flt-l">
						<div class="itemcontenttitle">
							&nbsp;&nbsp;&nbsp;&nbsp;<%=objname %><span class="ppost">&nbsp;&nbsp;<%=jobtitle %></span>
						</div>
						<div class="itemcontentitdt">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=deptname %>
						</div>
					</div>
				</div>
			</div>
			
			<div class="lineSpacing" style="width:100%;height:10px;overflow:hidden;"></div>
			
			<!-- 人员状态相关信息 -->
			<div class="statusInfo">
				<div class="viewTblTop">
					<div class="viewTblTitle viewTblHeight29">直接上级</div><div class="viewTblContent viewTblHeight29">&nbsp;&nbsp;&nbsp;&nbsp;<%=manager %></div>
				</div>
				<div class="viewTblCenter">
					<div class="viewTblTitle viewTblHeight23">状态</div><div class="viewTblContent viewTblHeight23">&nbsp;&nbsp;&nbsp;&nbsp;<%=statusname %></div>
				</div>
				<div style="width:100%;height:26px;">
					<div class="viewTblTitle viewTblHeight26">办公室</div><div class="viewTblContent viewTblHeight26">&nbsp;&nbsp;&nbsp;&nbsp;<%=location %></div>
				</div>
			</div>
			
			<div class="lineSpacing" style="width:100%;height:14px;overflow:hidden;"></div>
			
			<!-- 人员联系相关信息 -->
			<div class="statusInfo" id="contactInfo">
				<div class="viewTblTop">
					<div class="viewTblTitle viewTblHeight29">办公电话</div><div class="viewTblContent viewTblHeight29">&nbsp;&nbsp;&nbsp;&nbsp;<%=telephone %></div>
				</div>
				<div class="viewTblCenter">
					<div class="viewTblTitle viewTblHeight23">移动电话</div><div class="viewTblContent viewTblHeight23">&nbsp;&nbsp;&nbsp;&nbsp;<%=mobile %></div>
				</div>
				<div style="width:100%;height:26px;">
					<div class="viewTblTitle viewTblHeight26">电子邮件</div><div class="viewTblContent viewTblHeight26">&nbsp;&nbsp;&nbsp;&nbsp;<%=email %></div>
				</div>
			</div>
			
			
			<div class="lineSpacing" style="width:100%;height:18px;overflow:hidden;"></div>
			
			<!-- 相关操作 -->
			<div class="operatingInfo">
				<div class="clearBoth">
					<div class="operationBt width104 m-t-5 m-r-8" onclick="javascript:window.open('tel:<%=telephone %>', '_blank')">
						拨打电话
					</div>
					<div class="operationBt width104 m-t-5" onclick="javascript:window.open('tel:<%=mobile %>', '_blank')">
						拨打手机
					</div>
				</div>
				<div class="clearBoth">
					<div class="operationBt width104 m-t-5 m-r-8" onclick="javascript:window.open('sms:<%=mobile %>', '_blank')">
						发送短信
					</div>
					<div class="operationBt width104 m-t-5" onclick="javascript:window.open('mailto:<%=email %>', '_blank')">
						发送邮件
					</div>
				</div>
			</div>
			<div class="lineSpacing" style="width:100%;height:4px;overflow:hidden;">
			</div>
		</div>
	</div>
</body>
</html>