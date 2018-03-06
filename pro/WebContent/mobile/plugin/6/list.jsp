<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%
String clienttype = StringHelper.null2String(request.getParameter("clienttype"));
 %>
<!DOCTYPE html>
<html>
<head>
<title>组织架构</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
<style type="text/css">
  {color:blue}
  a:-webkit-any-link{text-decoration: none;}
</style>
<script type='text/javascript' src='/js/jquery/1.6.2/jquery.min.js'></script>
</head>
<body >
<div style="background:url(/mobile/images/viewBg.png) repeat;margin:0;padding-bottom:10px;">
	
	<div data-role="content">
	<script type="text/javascript">
	      function doChange(obj){
	        $(".addressName").val($(obj).val());
	      }
	      function doSubmit(url){
             $(".addressForm").attr("action",url);
             $("#addressForm").submit();                	      
	      }
	 </script>
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
	
	      .addressSearchBtn .ui-btn-inner{padding:6px 8px 6px 18px !important}
	      .addressSearchBtn .ui-btn-text{margin-left:12px !important}
	      .addressSearchText .ui-input-search{height:30px !important}
	      
		.searchText {
			width:100%;
			height:24px;
			margin-left:auto;
			margin-right:auto;
			border: 1px solid #687D97; 
			background:#fff;
			-moz-border-radius: 12px;
			-webkit-border-radius: 12px; 
			border-radius:12px;
			-webkit-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
			-moz-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
			box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		}
		
		.operationBt {
			height:26px;
			margin-left:18px;
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
			float:left;
		}
		.width50 {
			width:50px;
		}
		
		.organizaions {
		
			background-attachment: scroll;
			background-clip: border-box;
			background-color: white;
			background-image: none;
			background-origin: padding-box;
			border-bottom-color: #CCC;
			border-bottom-left-radius: 10px;
			border-bottom-right-radius: 10px;
			border-bottom-style: solid;
			border-bottom-width: 1px;
			border-left-color: #CCC;
			border-left-style: solid;
			border-left-width: 1px;
			border-right-color: #CCC;
			border-right-style: solid;
			border-right-width: 1px;
			border-top-color: #CCC;
			border-top-left-radius: 10px;
			border-top-right-radius: 10px;
			border-top-style: solid;
			border-top-width: 1px;
			clear: both;
			color: #333;
			display: block;
			font-family: Helvetica, Arial, sans-serif;
			font-size: 15px;
			margin-bottom: 0px;
			margin-left: 10px;
			margin-right: 10px;
			margin-top: 10px;
			opacity: 0.75;
			overflow-x: hidden;
			overflow-y: hidden;
			padding-bottom: 6px;
			padding-left: 15px;
			padding-right: 15px;
			padding-top: 6px;
			position: relative;
			text-shadow: white 0px 1px 0px;
		}
		
		.searchArea {
			width:100%;
			height:42px;
			text-align:center;
			position:relative;
			background:#7F94AF;
			background: -moz-linear-gradient(0, #A4B0C0, #7F94AF);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#A4B0C0), to(#7F94AF));
		}
	 </style>
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
						<div id="title">组织</div>
					</td>				
				</tr>
			</table>
		</div>
		<%} %>
	<div class="organizaions" id="orgtree">
	</div>
	<SCRIPT LANGUAGE="JavaScript">
	<!--
	window.onload = initOrg;
	function expand(tableid){
		var obj =  document.getElementById(tableid+"_icon");
		var tabobj = document.getElementById(tableid);
		if(obj&&tabobj){
			if(tabobj.style.display == "block"){
				obj.src = "/mobile/images/expand_xp.gif";
				tabobj.style.display = "none";
			} else {
				obj.src = "/mobile/images/collapse_xp.gif";
				tabobj.style.display = "block";
			}
		}
	}
	
	function initOrg() {
	   
		var ajaxUrl = "/mobile/plugin/6/orgdata.jsp";
	    jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=utf-8", 
		    error:function(ajaxrequest){
		    	alert("sorry!请重试!");
		    }, 
		    success:function(content){
		        //alert(content);
		        document.getElementById('orgtree').innerHTML=content;	    	
		    }  
	    });
	}
	
	/**
	 * ajax方式获取当前点击上级部门的下级部分或者人员

	 * @param _this 当前点击部门信息
	 */
	function getChild(_this) {
		if ($(_this).attr("_ajax") == "1") {
			return true;
		} 
		var orgType = $(_this).attr("_type");
		var orgLevel = $(_this).attr("_level");
		var orgComId = "0";
		var orgSubId = "0";
		var orgDepId = "0";
		
		if (orgType == "0") {
			orgComId = $(_this).attr("_id");
			orgType = "1";
		} else if (orgType == "1") {
			orgComId = $(_this).attr("_comid");
			orgSubId = $(_this).attr("_id");
			orgType = "1,2";
		} else if (orgType == "2") {
			orgComId = $(_this).attr("_comid");
			orgSubId = $(_this).attr("_subid");
			orgDepId = $(_this).attr("_id");
			orgType = "2,3";
		} else {
			return ;
		}
		
		var ajaxUrl = "/mobile/plugin/6/orgdata.jsp"
		ajaxUrl += "?orgComId=" + orgComId + "&orgSubId=" + orgSubId + "&orgDepId=" + orgDepId + "&orgType=" + orgType + "&orgLevel=" + (parseInt(orgLevel) + 1) + "&time=" + new Date().getTime();;
		$(_this).parent().after("<tr><td id=\""+$(_this).attr("_type")+"_"+$(_this).attr("_id")+"\" style=\"display:block;word-break:break-all\"><img style=\"padding-left:" + (parseInt(orgLevel) + 1)*10 + "px\" src=\"/mobile/images/ajax-loader.gif\">正在加载中...</td></tr>");
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=utf-8", 
		    error:function(ajaxrequest){
		    	alert("sorry!请重试!");
		    	$("#" + $(_this).attr("_type")+"_"+$(_this).attr("_id")).parent().html("");
		    }, success:function(content){
		        //alert(content);
		    	if (content != '' && content.replace(/(^\s*)|(\s*$)/g, "") != "") {
		    		//$(_this).parent().after("<tr><td id=\""+$(_this).attr("_type")+"_"+$(_this).attr("_id")+"\" style=\"display:block;word-break:break-all\">" + content + "</td></tr>");
		    		$("#" + $(_this).attr("_type")+"_"+$(_this).attr("_id")).html(content);
		    	} else {
		    		$("#" + $(_this).attr("_type")+"_"+$(_this).attr("_id")).parent().html("");
		    	}
				
				$($(_this).children().find("img").get(0)).attr("src", "/mobile/images/collapse_xp.gif");
						    	
		    	$(_this).attr("_ajax", "1");
		    }  
	    });
	}
	//-->
	</SCRIPT>	
    </div>
</div>
</body>
</html>