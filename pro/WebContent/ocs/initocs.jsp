<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
	String userName=eweaveruser.getUsername();
	String ocspassword=session.getAttribute("ocspassword")==null?"":session.getAttribute("ocspassword").toString();
	HumresService humresService=(HumresService)BaseContext.getBean("humresService");
%>
<html>
  <head>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/ocs/js/PEEIMUtil.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
	<script>
	Ext.onReady(function(){
		<%if("402883b530490dcb013049963a2b0039".equals(humresService.getIMMessageType())){%>
			$("#div1").css("display","block");
			$("#div2").css("display","none");
		<%}else{%>
			$("#div1").css("display","none");
			$("#div2").css("display","block");
		<%}%>
	})
	
	function initData(){
		var myMask = new Ext.LoadMask(Ext.getBody(), {
		    msg: '正在处理，请稍后...',
		    removeMask: true //完成后移除
		});
		myMask.show();
		
		Ext.Ajax.request({
			timeout:100000000,
	        url: '<%=request.getContextPath()%>/ServiceAction/ocs.OCSAction',
	        params:{},
	        success: function(request) {
	            $("#div4").html(request.responseText);
	            myMask.hide();
	        },
	        failure: function (request) {
		        myMask.hide();
		        Ext.Msg.alert('错误', request.responseText);
		    }
	    });
	}
	
	function entry(){
		<%if("".equals(ocspassword)){%>
			alert("无法获取OCS密码，请重新登录系统！");
		<%}else{%>
			PEEIM.RunEim('<%=userName%>','<%=ocspassword%>');
		<%}%>
	}
	</script>
  </head>
  <body>
  	<div id="div1">
	  	<input type="button" value="OCS初始化" name="B3" onclick="initData();"><br>
		<div id="div3" style="">处理结果：</div>
		<div id="div4"></div>
	</div>
	<div id="div2">OCS未启用</div>
  </body>
</html>
