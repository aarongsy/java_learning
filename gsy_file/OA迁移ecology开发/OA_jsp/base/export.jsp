<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
String exportflag = request.getParameter("exportflag");
if(exportflag==null)exportflag="";
String exportContent =request.getParameter("exportContentHidden");
if(exportContent==null)exportContent="";
boolean isExcel=false;
if(exportflag.equals("1"))
{
		isExcel=true;
		pageContext.setAttribute("isExcel",true);
		String fname="export.xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
}
%>
<c:if test="${!isExcel}">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
    <link href="/css/eweaver.css" type="text/css" rel="STYLESHEET">
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
      
    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
        var style='default';
    </script>
</head>
<style type="text/css">
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
       .x-toolbar table {width:0}
    .x-grid3-row-body{white-space:normal;}
  </style>
<body onload="javascript:exportPage();">
</c:if>
<form action="/app/base/export.jsp?exportflag=1" name="formExport" method="post">
<div id="exportContent">
<%=exportContent%>
</div>
<c:if test="${!isExcel}">
<input type=hidden value="" name="exportContentHidden">
</form>
</body>
<script>
function exportPage()
{
	 var repContent="";
	 var pwin=self;
	 var commonDialog=top.leftFrame.commonDialog;
	 commonDialog.hide();
	  var frameid=parent.contentPanel.getActiveTab().id+'frame';
		var pwin=parent.Ext.getDom(frameid).contentWindow;
	 if(pwin!=null&&pwin.document!=null)
	 {
		 var doc=pwin.document;
			repContent=doc.getElementById("tab1").innerHTML;
	 }
   document.getElementsByName("exportContentHidden")[0].value=repContent;
	 document.formExport.submit();
}
</script>
</c:if>

