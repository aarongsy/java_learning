<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ taglib uri="/WEB-INF/tags/eweaver.tld" prefix="ew"%>
<%@ page import="com.eweaver.sysinterface.ds.model.*"%>
<%@ page import="com.eweaver.sysinterface.ds.service.*"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<html>  
	<head>
	<style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
		 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
		<title>数据接口类型列表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		</head>
		<ew:grid 
                   fields="name,interfaceCode,configurl,description,id" 
                   listurl="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=list" 
                   delurl="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=delete"
                   editurl="/sysinterface/interfaceMetaModify.jsp"
                   createurl="/sysinterface/interfaceMetaModify.jsp"
                   cols="接口类型名称,接口编码,接口配置URL,接口描述" 
                   candelete="true"
                   canedit="true"
                   cancreate="true"
                   >
        </ew:grid> 
		<body>
	<div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div>
	</body>
</html>