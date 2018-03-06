<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
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
<%@ include file="/base/init.jsp"%>
<%
String exportflag = request.getParameter("exportflag");
if(exportflag==null)exportflag="";
String exportContent =request.getParameter("repContainer");
if(exportContent==null)exportContent="";
String portrait =request.getParameter("portrait");
if(portrait==null)portrait="true";
boolean isExcel=false;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<LINK type="text/css" rel="STYLESHEET" href="/css/eweaver.css" >
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
      
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
<form action="/app/base/printPage.jsp?exportflag=1" name="formExport" method="post">
<div id="repContainer">
</div>
<!-- <input type=hidden value="" name="repContainer"> -->
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
		 var formid=doc.getElementById("formid").value;
			repContent=doc.getElementById("div"+formid).innerHTML;
	 }
   document.getElementById("repContainer").innerHTML=repContent;
	 printPrv();
}

function printPrv ()
{  
  var location="/app/base/print.jsp?&opType=preview&portrait=<%=portrait%>";
	var width=630;
	var height=540;
	var winName='previewRep';
	var winOpt='scrollbars=1';
	 if(width==null || width=='')
    width=400;
  if(height==null || height=='')
    height=200;
  if(winOpt==null)
    winOpt="";
  winOpt="width="+width+",height="+height+(winOpt==""?"":",")+winOpt+", status=1";
  var popWindow=window.open(location,winName,winOpt);
  if(popWindow==null)
  {
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000") %>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}
var commonDialog=top.leftFrame.commonDialog;
if(commonDialog){
 var frameid=parent.contentPanel.getActiveTab().id+'frame';
 var tabWin=parent.Ext.getDom(frameid).contentWindow;
 if(!commonDialog.hidden)
	{
		commonDialog.hide();
		tabWin.location.reload();
	}
</script>

