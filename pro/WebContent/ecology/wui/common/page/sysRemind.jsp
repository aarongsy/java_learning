<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
  int labelid=Util.getIntValue(((String)request.getAttribute("labelid")==null?request.getParameter("labelid"):(String)request.getAttribute("labelid")),0);
  String msg=SystemEnv.getHtmlLabelName(labelid,7);
%>
<html>
  <head>
    <title>系统提醒</title>
    <script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui.css'/>
    <script type="text/javascript">
    var intervalTime = 2;
    $(document).ready(function () {
        //$(body).css("overflow", "hidden");
    	var pTop= document.body.offsetHeight/2 + document.body.scrollTop - 154;
        var pLeft= document.body.offsetWidth/2 - 50;
        $("#messageArea").css("top", pTop);
		/*
        var interval = setInterval(function () {
            if (intervalTime != -1) {
				$("#autoCloseArea").html("页面" + intervalTime-- + "秒后自动关闭");
            } else {
            	clearInterval(interval);
				window.close();
            }
        }, 1000);
        */
    });
    </script>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;" align="center" id="messageArea">
    <div style="width: 582px;font-size:16px;height:309px;background:url(/wui/common/page/images/error.png) no-repeat;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:128px; width:123px;background: url(/wui/common/page/images/error_left.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    	<!-- 
    		<div style="width:100%;" align="right" id="autoCloseArea">页面3秒后自动关闭</div>
    	 -->
    </div>
	<div style=" height:120px; border-left:solid 1px #e3e3e3; margin:20px; float:left; margin-left:40px;margin-top:80px"></div>
	<div style="height:260px; width:320px; float:left;margin-top:40px; line-height:25px;">
		
		<%if(labelid==1){ //浏览器版本不支持提醒
		    String browserName=Util.null2String(request.getParameter("browserName"));
		    String browserVersion=request.getParameter("browserVersion");
		    String minVersion="";
		    if(browserName.equals("IE"))
		    	minVersion="IE 8";
		    else if(browserName.equals("FF"))
		    	minVersion="Firefox 9";
		    else if(browserName.equals("Chrome"))
		    	minVersion="Chrome 14";
		    else if(browserName.equals("Safari"))
		    	minVersion="Safari 5";
		%>
		  <p style=" font-weight:bold">
		             您当前的浏览器是<%=browserName%>浏览器， 版本是<%=browserVersion%>,版本过低，请升级<%=browserName%>至<span style="color: red;"><%=minVersion%></span>以上，或者使用其他浏览器！<br>
		            <a href="http://windows.microsoft.com/zh-CN/internet-explorer/products/ie/home"  style="text-decoration: underline !important;">IE</a>&nbsp;
		            <a href="http://www.google.cn/chrome/intl/zh-CN/landing_chrome.html" style="text-decoration: underline !important;">Chrome</a>&nbsp;
		            <a href="http://www.firefox.com.cn/download/"  style="text-decoration: underline !important;">Firefox</a>&nbsp;
		            <a href="http://www.apple.com.cn/safari/download/"  style="text-decoration: underline !important;">Safari</a>
		  </p>   
		<%}else if(labelid==2){  //移动设备访问提醒
			 String browserOS=Util.null2String(request.getParameter("browserOS"));
		%>   
			<p style=" font-weight:bold">
	                 很抱歉当前系统暂不支持<span style="color: red;"><%=browserOS%></span>访问，移动设备请使用E-Mobile访问！
            </p>
			
		 <%}else if(labelid==3){
			 String browserOS=Util.null2String(request.getParameter("browserOS"));
			 String browserName=Util.null2String(request.getParameter("browserName"));
		 %>
		     <p style=" font-weight:bold">
	                 很抱歉当前系统暂不支持<span style="color: red;"><%=browserOS%>系统下<%=browserName%>浏览器</span>访问，请使用IE或chrome访问！
             </p>
		 <%}else{%>
		
			<p style=" font-weight:bold">
					很抱歉，当前浏览器暂不支持"<span style="color: red;"><%=msg%></span>"！
			</p>
			<p>
			  <%if(labelid==27889||labelid==27890){%><!-- 主题不支持提醒 -->
				请使用IE8或IE8以上版本访问。或者跳转到<a href="/wui/theme/ecology7/page/skinSetting.jsp?skin=default&theme=ecologyBasic">EcologyBasic主题</a>
			  <%}else{%>
			    1、请使用IE8或IE8以上版本访问。<br>
				不支持原因：由于此功能依赖于IE浏览器的Activex， 
				我们正在努力的寻求解决方案，使其能在多浏览器下运行，给您造成的不便敬请谅解！
			  <%}%>	
			 </p>  
		<%}%>	 
		<p>
			如还有疑问请联系系统管理员。</p>
		</div>
    </div>
    
</div>
</body>
</html>    
  
