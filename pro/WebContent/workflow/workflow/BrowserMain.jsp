
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<html>
  <head>
    <link href="<%=request.getContextPath()%>/css/eweaver.css" type="text/css" rel="STYLESHEET">
  </head>
<%
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
%>

</html>

<html>
  <head>
  </head> 
  <body>
     
     
<HTML><HEAD>
</HEAD>

<BODY>
<DIV id="TopTitle" class=TopTitle Style="display:''">
	<IMG src="<%=request.getContextPath()%>/images/main/titlebar_bg.jpg">
	<%=labelService.getLabelNameByKeyId("402881e80b708c4f010b70a20640002b") %><!-- 列表 -->
	
	<BUTTON type="button" id=btnFav title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280029") %>" onclick="javascript:addFav();" style="display:'none'"><!-- 加入收藏夹 -->
	</BUTTON>	
</DIV>
</BODY> 
<!-- 按钮条 --> 
     	<div id="menubar">
<!-- 提交按钮 -->
	  <button type="button" class='btn' accesskey="S" onclick="javascript:onSubmit();">
	  	<u>S</u>--<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009") %><!-- 提交 -->
	  </button>
	</div> 
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search" name="EweaverForm" method="post">
		<TEXTAREA NAME="condition" ROWS="20" COLS="60"></TEXTAREA>
    </form>
<script language="javascript" type="text/javascript">
	function onSubmit(){
  		alert("condision");
	
   		//document.EweaverForm.submit();
		window.close();
  }

</script>
  </body>
</html>
