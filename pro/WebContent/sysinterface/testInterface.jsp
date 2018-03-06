<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ taglib uri="/WEB-INF/tags/eweaver.tld" prefix="ew"%>
<%@ page import="com.eweaver.sysinterface.ds.model.*"%>
<%@ page import="com.eweaver.sysinterface.ds.service.*"%>
<%@ page import="com.eweaver.sysinterface.base.*"%>
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

   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
		<title>数据接口列表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		</head>
		<body>
		<%
		InterfaceControlCenter interfaceControl = InterfaceControlCenter.getInstance();
		//interfaceControl.callInterface("4028823e321e402e01321e5eddf10005","4028823e321ed3d001321ee3e81e0002","node");
		interfaceControl.callInterface("4028822f3237a4750132380a52830006");
		 %>
	<div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div>
	</body>
</html>