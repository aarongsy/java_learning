<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />未设置好协作区关联表单信息，请联系管理员！</h5>");
	return;
}
String type=StringHelper.null2String(request.getParameter("type")); //全部协作 - 参与协作 - 我的协作 - 停止协作 - 关闭协作
if(StringHelper.isEmpty(type)){
	type = "1";
}
String tagid=StringHelper.null2String(request.getParameter("tagid"));//全部（没有隐藏） - 重要（没有隐藏） - 隐藏  说明：未读已经包含在了三类里面无需另开tab页
if(StringHelper.isEmpty(tagid)){
	tagid="402881e83abf0214013abf0220810290";
}
String searchtype=StringHelper.null2String(request.getParameter("searchtype"));
String searchobjname=StringHelper.null2String(request.getParameter("searchobjname"));
String order=StringHelper.null2String(request.getParameter("order"));
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link  type="text/css" rel="stylesheet" href="/js/jquery/plugins/qtip/jquery.qtip.min.css" />
<style type="text/css">
        body{padding:0;margin:0;}
		a{  
		    cursor:pointer;  
		    text-decoration:none;  
		    hide-focus: expression(this.hideFocus=true);  
		    outline:none;  
		}  
		a:link,a:visited,a:active{  
		    text-decoration:none;  
		    color: #000000;
		}  
		  
		a:focus{  
		    outline:0;   
		}
		<!--
		.item { 
			padding: 4px 0; 
			width: 100%; 
		}
		.itemgcolor1 { 
		   background-color:#F1F4F6; 
		}
		.d1{
			float: left; 
			margin:0px; 
			padding:0px; 
			width:20px;
			text-align:left;
		}
		.d2{
			float: left; 
			line-height:20px;
			margin-left:5px; 
			margin-top:0px;
			margin-bottom:0px;
			margin-right:0px;
			padding-left:8px; 
			padding-bottom:0px; 
			padding-right:0px; 
			padding-top:0px; 
		    font-family: Arial; 
			font-size: 12px; 
			text-decoration: none; 
			text-align: left;
		}
		.d3{
			float: left;
			margin:0px; 
			padding:0px;
		    font-family: Arial; 
			font-size: 10px; 
			width:auto;
			vertical-align: bottom;
			color: #999;
			border: 0 solid red;
		}
		.d4{
			float: left;
			margin:0px; 
			padding:0px;
		    font-family: Arial; 
			font-size: 11px; 
			color: #333;
			width:auto;
			text-align: right;
			border: 0 solid red;
		}
		.title
		{
			/*white-space:nowrap;*/
			/*word-break:keep-all;*/
			word-break:break-all;
			/*overflow:hidden;*/
			text-overflow:ellipsis;
			font-family: Microsoft YaHei; 
			color: #999;
		}
		
		.title a:link{font-weight:normal ;font-size: 13px; text-decoration : none ;color : #000000;}
		.title a:visited {font-weight : normal ;font-size: 13px; text-decoration : none ;color : #000000;}
		.title a:hover {font-weight : normal ;font-size: 13px; text-decoration : none ;color : blue;}
		
		.more{
		    word-break:break-all;
			text-overflow:ellipsis;
			font-family: Microsoft YaHei; 
			font-weight:normal ;
			font-size: 10px;
			text-decoration : none ;
			color : #000000;
		}
		.more:link{font-weight:normal ;font-size: 13px; text-decoration : none ;color : blue;}
		.more:visited {font-weight : normal ;font-size: 13px; text-decoration : none ;color : blue;}
		.more:hover {font-weight : normal ;font-size: 13px; text-decoration : none ;color : blue;}
		
		.remark{
		    font-family: Microsoft YaHei; 
			font-size: 11px; 
			color: #999;
		}
		
		.nbody{
		  background-color:#F8F8FA;
		}
		
		/* qtip 提示框基础样式 */
		.qtip .qtip-content{padding:10px;overflow:hidden;}
		.qtip .qtip-content .qtip-title,.qtip-cream .qtip-content .qtip-title{background-color:#F0DE7D;}
		.qtip-light .qtip-content .qtip-title{background-color:#f1f1f1;}
		.qtip-dark .qtip-content .qtip-title{background-color:#404040;}
		.qtip-red .qtip-content .qtip-title{background-color:#F28279;}
		.qtip-green .qtip-content .qtip-title{background-color:#B9DB8C;}
		
		.tipfont{
		  font-size: 11px;
		  color: #666;
		}
		-->
		
		
table.unread{
	float: left;
	height:13px;
	border:0;
	border-collapse: collapse;
}
table.unread td{
	padding: 0;
}
table.unread td.unreadCenter{
	background-color: red;
	color: #fff;
	font: 10px Arial;
	font-weight: bold;
	padding-bottom: 1px;
}
table.unread td.unreadLeft{
	width: 5px;
	background: url(/app/cooperation/images/radiusleft.png);
}
table.unread td.unreadRight{
	width: 5px;
	background: url(/app/cooperation/images/radiusright.png);
}
</style>
<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/main.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="/app/cooperation/js/jquery.qtip-1.0.0-rc3.js"></script>
<script type="text/javascript">
//创建工具提示文件加载
function showtip(){
	$('.unread').each(function(){
		// 设置提示的内容
		$(this).qtip({
			content: $(this).attr('tipstr'),
			position: {
				corner: {
					tooltip: 'rightTop',
					target: 'rightMiddle'
				}
			},
			style: {
				tip: true, // 给它一个语音气泡提示与自动角点检测
				name: 'cream',
				border:'1px', /*边框颜色*/
				color: '#999',
				font:'Microsoft YaHei',
				background:'#ffffa3'
			}
		});
	});
	
}
$(document).ready(function(){
		 showtip();
});
function readCowork(requestid){
	onUrl('/app/cooperation/allcowork.jsp?requestid='+requestid,'查看协作','tab'+requestid);
	var t=window.setTimeout(function (){
	   /*Ext.Ajax.timeout = 900000;
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=readCoWork',
	       params:{requestid:requestid},
	       sync:true,
	       success: function(res) {
	        var xml=res.responseXML;
	        var cellHtml = xml.getElementsByTagName("cell")[0].text+"";
		    var div = document.getElementById(requestid+"_tipimg");
		    div.innerHTML=cellHtml;
	       }
	   });*/
	   window.location.reload();
	},3000);
	
}
</script>
</head>
<body scroll="no" style="overflow-y:hidden">
<%
int pageNo = 1;
int pageSize = 5;
/*计算总页数*/
CoWorkService coWorkService = new CoWorkService();
Map<String,String> map = new HashMap<String,String>();
map.put("type",type);
map.put("tagid",tagid);
map.put("order",order);
map.put("searchtype",searchtype);
map.put("searchobjname",searchobjname);
List<Map<String,String>> portal = coWorkService.getCoworkPortal(pageNo,pageSize,map);
%>
<table width="100%" border="0" style="table-layout:fixed;" cellpadding="0" cellspacing="0" > 
   <%
   if(portal!=null && portal.size()>0){
	   String total="";
	   for(Map<String,String> pm:portal){
		   String subject=StringHelper.null2String(pm.get("subject"));
		   String requestid=StringHelper.null2String(pm.get("requestid"));
		   String tipimg=StringHelper.null2String(pm.get("tipimg"));
		   String coworkremark=StringHelper.null2String(pm.get("coworkremark"));
		   String objname = StringHelper.null2String(pm.get("objname"));
		   total= StringHelper.null2String(pm.get("total"));
   %>
	<tr style="height: 45px;">
	<td style="word-break:keep-all;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" class="title d2">
	<%=subject %><br>
	<%=coworkremark %>
	</td>
    <td style="padding-left: 3px" width="65px" id="<%=requestid %>_tipimg">
    <div class="d4" ><%=objname %></div><br>
    <div class="d3" ><%=tipimg %></div>
    </td> 
	</tr> 
	<tr style="height:1px" >
    <td style="background-color: #D2DCE8;" colspan="2">
    </td>
    </tr>
	<%}%>
    <tr style="height:25px">
    <td style="text-align:right" colspan ="2" valign="bottom">
	<a href="javascript:window.location.reload();"><img src="/images/silk/refresh.gif" border="0"></a>
    <a href="JavaScript:onUrl('/app/cooperation/allcowork.jsp','全部协作','tab402883443b4a1410013b4a22e7730067')" class="more">更多</a>
    &nbsp;&nbsp;
	</td>
	</tr>
	<%} %>
    </table>
</body>
</html>
  