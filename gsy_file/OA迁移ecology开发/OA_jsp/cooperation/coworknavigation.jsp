<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.cowork.model.*"%>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%@ include file="init.jsp"%>
<%
String type=StringHelper.null2String(request.getParameter("type"));
String tagid=StringHelper.null2String(request.getParameter("tagid"));
String searchtype=StringHelper.null2String(request.getParameter("searchtype"));
String searchobjname=StringHelper.null2String(request.getParameter("searchobjname"));
String order=StringHelper.null2String(request.getParameter("order"));
String coworkid = StringHelper.null2String(request.getParameter("coworkid"));
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link  type="text/css" rel="stylesheet" href="/app/cooperation/css/default.css" />
<%if(userMainPage.getIsUseSkin()){%>
<link rel="stylesheet" type="text/css" id="main_css" href="<%=currentSkin.getBasePath() %>/cooperation.css"/> 
<%}%>
<link href="/js/jquery/plugins/qtip/jquery.qtip.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/app/cooperation/js/jquery.infinitescroll.min.js"></script>
<script type="text/javascript" src="/app/cooperation/js/jquery.masonry.min.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" src="/app/cooperation/js/jquery.qtip-1.0.0-rc3.js"></script>
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

function item_masonry(){ 
	$(".infinite_scroll").masonry({ 
		// options 设置选项
		itemSelector : ".masonry_brick",//class 选择器
		columnWidth : 240 ,             //一列的宽度 Integer
		isAnimated:false,                //使用jquery的布局变化 Boolean
		animationOptions:{
		   queue: false,
		   duration: 500   //jquery animate属性 渐变效果 Object { queue: false, duration: 500 }
		},
		gutterWidth:0,                  //列的间隙 Integer
		isFitWidth:true,                // 适应宽度 Boolean
		isResizableL:true,              // 是否可调整大小 Boolean
		isRTL:false                     //使用从右到左的布局 Boolean
	});	
}

$(function(){
	item_masonry();	
	//$(".item").fadeIn();
	var sp = 1;
	$(".infinite_scroll").infinitescroll({
		navSelector  	: "#more",
		nextSelector 	: "#more a",
		itemSelector 	: ".item",
		loading:{
			img: "/app/cooperation/images/masonry_loading_1.gif",
			msgText: ' ',
			finishedMsg: ' ',
			finished: function(){
				sp++;
				/*if(sp>=10){ //到第10页结束事件
					$("#more").remove();
					$("#infscr-loading").hide();
					$(window).unbind(".infscr");
				}else{
					$(document).trigger('retrieve.infscr');
				}*/
			}	
		},errorCallback:function(){ 
		}
		
	},function(newElements){
		var $newElems = $(newElements);
		$(".infinite_scroll").masonry("appended", $newElems, false);
		$newElems.fadeIn();
		item_masonry();	
		return;
	});
});

function readCowork(requestid){
	onPPP_openURL('frameRight','/app/cooperation/coworkview.jsp?id='+requestid);
	var t=window.setTimeout(function (){
	   Ext.Ajax.timeout = 900000;
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=readCoWork',
	       params:{requestid:requestid},
	       sync:true,
	       success: function(res) {
	        var xml=res.responseXML;
	        var cellHtml = xml.getElementsByTagName("cell")[0].childNodes[0].nodeValue;
	        // alert(xml.getElementsByTagName("cell")[0].childNodes[0].nodeValue);
		    var div = document.getElementById(requestid+"_tipimg");
		    div.innerHTML=cellHtml;
		    
	       }
	   });
	},1000);
}
function onChangTag(requestid,tagid){
	   Ext.Ajax.timeout = 900000;
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=changeCoWorkTag',
	       params:{requestid:requestid,tagid:tagid},
	       sync:true,
	       success: function(res) {
	       var xml=res.responseXML;
	       //var cellHtml = xml.getElementsByTagName("cell")[0].text+"";
            var cellHtml = xml.getElementsByTagName("cell")[0].childNodes[0].nodeValue+"";//在全部协作页面，当点击协作记录或者标为重要的五角星图标时，会出现undefined字样；
            if(cellHtml && cellHtml!=""){
            	var div = document.getElementById(requestid+"_tagimg");
 	    	        div.innerHTML=cellHtml;
            }
	       }
	   });
}
</script>
</head>
<body>
<div class="infinite_scroll" style="height: auto">
<%
int pageNo = 1;
int pageSize = 15;
/*计算总页数*/
CoWorkService coWorkService = new CoWorkService();
String coworkhtml = coWorkService.getCoworkNavigation(tagid,type,searchtype,searchobjname,pageNo,pageSize,order);
for(int i=0;i<1;i++){
%>
	<%=coworkhtml %>
	<%} %>
</div>
<div id="more"><a href="/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=getcoworklist&abc=<%=Math.random()%>&page=2&type=<%=type%>&tagid=<%=tagid%>&searchtype=<%=searchtype%>&searchobjname=<%=searchobjname%>&order=<%=order%>&pagesize=<%=pageSize %>"></a></div>
<!-- <div style="display:none;" id="gotopbtn" class="to_top"><a title="返回顶部" href="javascript:void(0);"></a></div>-->
<script type="text/javascript">
$(function(){
    <% if(!StringHelper.isEmpty(coworkid)){%>
    	readCowork('<%=coworkid%>');
    <%}%>
	/*$(window).scroll(function(){
		$(window).scrollTop()>400 ? $("#gotopbtn").css('display','').click(function(){
			$(window).scrollTop(0);
		}):$("#gotopbtn").css('display','none');	
	});*/
});
</script>

</body>
</html>
  