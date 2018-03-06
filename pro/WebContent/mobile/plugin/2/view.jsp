<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>

<%
String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));
String detailid = StringHelper.null2String(request.getParameter("detailid"));
String from = StringHelper.null2String(request.getParameter("from"));
String module = StringHelper.null2String(request.getParameter("module"));
String scope = StringHelper.null2String(request.getParameter("scope"));
String title = StringHelper.null2String(request.getParameter("title"));
String clienttype = StringHelper.null2String(request.getParameter("clienttype"));
ServiceUser user = new ServiceUser();
user.setId(sessionkey);
EweaverClientServiceImpl pluginService = (EweaverClientServiceImpl)BaseContext.getBean("eweaverClientServiceImpl");
Mdocument mdocument = pluginService.getDocument(detailid,true,user);
String doccontent = mdocument.getDoccontent();
if(doccontent != null) {
    doccontent = doccontent.replaceAll("/ServiceAction/com\\.eweaver\\.document\\.file\\.FileDownload\\?attachid=","/download.do?fileid=");
}
%>
<!DOCTYPE html>
<html>
<head>
	<title><%=mdocument.getDocsubject() %></title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<style type="text/css">
	/* 顶部回退导航栏 Start */
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
	}
	a {
		text-decoration: none;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
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
	.content {
		background:url(/mobile/images/viewBg.png) repeat;margin:0;
		width:100%;
	}
	.maincontent {
		margin-left:8px;margin-right:8px;margin-top:1px;
	}
	
	.articleBody {
		width:100px;
		height:100%;
		border-left:1px solid #C5CACE;
		border-right:1px solid #C5CACE;
		border-bottom:1px solid #C5CACE;
		background:#fff;
		-moz-border-bottom-left-radius: 5px;
		-moz-border-bottom-right-radius: 5px;
		-webkit-border-bottom-left-radius: 5px; 
		-webkit-border-bottom-right-radius: 5px; 
		border-bottom-left-radius:5px;
		border-bottom-left-radius:5px;
		overflow-x:scroll;width:100%;
		scrollBar-face-color: green; 
		scrollBar-hightLight-color: red; 
		scrollBar-3dLight-color: orange; 
		scrollBar-darkshadow-color:blue; 
		scrollBar-shadow-color:yellow; 
		scrollBar-arrow-color:purple; 
		scrollBar-track-color:black; 
		scrollBar-base-color:pink; 
	}
	
	.articleBody div {
		margin-left:8px;margin-right:8px;padding-top:10px;padding-bottom:10px;font-size:12px;
		width:100% !important;
	}
	.articleBody table {
		width:100% !important;
	}
	.articleBody td {
		width:100% !important;
	}
	.articleBody tr {
		width:100% !important;
	}
	.articleBody span {
		width:100% !important;
	}
	/* 栏目快HEAD START */
	.blockHead {
		width:100%;
		height:24px;
		line-height:24px;
		font-size:12px;
		font-weight:bold;
		color:#fff;
		border-top:1px solid #0084CB;
		border-left:1px solid #0084CB;
		border-right:1px solid #0084CB;
		-moz-border-top-left-radius: 5px;
		-moz-border-top-right-radius: 5px;
		-webkit-border-top-left-radius: 5px; 
		-webkit-border-top-right-radius: 5px; 
		border-top-left-radius:5px;
		border-top-left-radius:5px;
		background:#0084CB;
		background: -moz-linear-gradient(0, #31B1F6, #0084CB);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6), to(#0084CB));
	}
	
	.m-l-14 {
		margin-left:14px;
	}
	
	/* 栏目快HEAD END */
	/* 列表项后置导航 */
	.itemnavpoint {
		float:right;height:100%;width:26px;text-align:center;
	}
	/* 列表项后置导航图  */
	.itemnavpoint img {
		width:10px;
		heigth:14px;
		margin-top:16px;
	}
	.subtitle {
		height:17px;line-height:17px;font-size:12px;
	}
	.title {
		height:33px;line-height:33px;font-weight:bold;
	}
	.linespace {
		height:2px;overflow:hidden;
	}
	
	</style>
</head>
<body>
<div>
<%if(ClientType.WEB.toString().equalsIgnoreCase(clienttype)) { %>
<div id="header">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="/home.do">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;font-size:9pt;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title">查看文档</div>
					</td>
				</tr>
			</table>
		</div>
	<%} %>
	<div class="content">
		
		<div class="maincontent">
		   <div class="blockHead">
				<span class="m-l-14">摘要</span>
			</div>
			<div class="articleBody">
				<!-- 文章标题 -->
			    <div style="title">&nbsp;&nbsp;<%=mdocument.getDocsubject() %></div>
				<%if(mdocument.getId() != -1) {%>
				<!-- 文章创建者、所有者、创建日期 -->
				<div class="subtitle">&nbsp;&nbsp;&nbsp;创建者&nbsp;:&nbsp;&nbsp;&nbsp;<%=mdocument.getDoccreater() %></div>
				<div class="subtitle">&nbsp;&nbsp;&nbsp;所有者&nbsp;:&nbsp;&nbsp;&nbsp;<%=mdocument.getDoccreater() %></div>
				<div class="subtitle">&nbsp;&nbsp;&nbsp;修改日期&nbsp;:&nbsp;&nbsp;&nbsp;<%=mdocument.getDoclastmoddate() %></div>
			</div>
			<!-- 间隔 -->
			<div class="linespace"></div>
					
			<!-- 内容、正文 -->
			<div class="blockHead">
				<span class="m-l-14">内容</span>
			</div>
			<div class="articleBody">
				<div>
					<%=doccontent %>
				</div>
			</div>
			<!-- 间隔 -->
			<div class="linespace"></div>
			
			
			<div class="blockHead">
				<span class="m-l-14">附件</span>
			</div>
			<div class="articleBody" style="min-height:10px;">
				<table id="head" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;">
				<%
				Map<String, Map<String, String>> attachMaps = mdocument.getAttachments();
				if(attachMaps != null && !attachMaps.isEmpty()) {
					
				
				int attindex = 0;
				for(Map.Entry<String,Map<String,String>> attentry : attachMaps.entrySet()) {
				    Map<String,String> attmap = attentry.getValue();
				    String attid = attmap.get("FILEID");
				    String attname = attmap.get("FILENAME");
				    String attsize = attmap.get("FILESIZE");
				    attindex ++;
				%>
				<tr style="height:28px;font-size:12px;line-height:28px;border-top:1px solid #C2CED7;">
								<td style="word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow-x:hidden;">
									<a href="/download.do?fileid=<%=attid%>" rel="external" style="color:#000;">
										<%if(attname.indexOf(".")==-1){%>
										&nbsp;&nbsp;<%=mdocument.getDocsubject()+"正文" %>.&nbsp;doc(<%=attsize %>KB)
									<%}else{%>
									    &nbsp;&nbsp;<%=attname %>(<%=attsize %>KB)
									<%}%>	
									</a>
								</td>
								<td valign="right" align="right" width="10px" valign="center" style="padding-top:7px">
									<img src="/mobile/images/rightArrow.png">
								</td>
							</tr>
				<%
				}
				}
				 %>
				
					</table>
			</div>
			
			<!-- 间隔 -->
			<div style="height:12px;overflow:hidden;"></div>
			<%} %>
		</div>
	</div>
</div>
</body>
</html>