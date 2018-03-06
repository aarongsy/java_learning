<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.service.DocbaseService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ include file="/base/init.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%@ page import="java.net.URLEncoder"%>

<%
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String docid = StringHelper.null2String(request.getParameter("id"));
String attachid = StringHelper.null2String(request.getParameter("attachid"));
String attachCanEdit=StringHelper.null2String(request.getParameter("attachcanedit"));
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");

Attach attach = attachService.getAttach(attachid);
int righttype = permissiondetailService.getAttachOpttype(docid);
String editType="0,0";
if(righttype%15==0){
    pagemenustr +="addBtn(tb,'下载','L','package_down',function(){javascript:savelocalFile()});";
}
if("1".equals(attachCanEdit)){
    pagemenustr +="addBtn(tb,'保存','S','accept',function(){javascript:saveDocFile()});";
    editType="3,1";
}
String attachType = ".doc";
if (attach.getFiletype().indexOf("word") != -1) {
	attachType = ".doc";
} else if (attach.getFiletype().indexOf("excel") != -1||StringHelper.null2String(attach.getObjname()).endsWith(".xls")) {
	attachType = ".xls";
}else if(attach.getFiletype().indexOf("sheet") != -1||StringHelper.null2String(attach.getObjname()).endsWith(".xlsx")){
	attachType = ".xlsx";
}else if (attach.getFiletype().indexOf("powerpoint") != -1||StringHelper.null2String(attach.getObjname()).endsWith(".ppt")) {
	attachType = ".ppt";
}else if(attach.getFiletype().indexOf("presentation") != -1||StringHelper.null2String(attach.getObjname()).endsWith(".pptx")){
	attachType = ".pptx";
}
%>
<html>
<head>
<title><%=attach.getObjname()%></title>
<meta http-equiv="content-type" content="text/html; charset=gb2312">
<style type="text/css">

    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
       .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
      a { color:blue; cursor:pointer; }

</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/examples/grid/RowExpander.js'></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/ux/TreeGrid.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>

<script type="text/javascript">
Ext.LoadMask.prototype.msg='正在加载,请稍候...';
var viewport=null;
Ext.onReady(function() {
     var tb = new Ext.Toolbar();
     tb.render('pagemenubar');
     <%=pagemenustr%>
});
</script>
</head>
<body onload="initObject();">
<div id="content">

<div id="pagemenubar"></div>
	<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
		<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
			<param name="WebUrl" value="<%=WebOffice.mServerName%>">
			<param name="RecordID" value="<%=docid%>">
			<param name="Template" value="">
			<param name="FileName" value="<%=attach.getObjname()%>">
			<param name="FileType" value="<%=attachType%>">
			<param name="UserName" value="<%=currentuser.getObjname()%>">
			<param name="EditType" value="<%=editType%>">
			<param name="PenColor" value="#FF0000">
            <param name="Print" value="false">
			<param name="PenWidth" value="1">
			<param name="ShowToolBar" value="0">
			<param name="ShowMenu" value="0">
		</object>
	</div>
</div>

</body>
<script language="javascript">
 function initObject(){
 	document.WebOffice.WebSetMsgByName("OFFICEID","<%=attachid%>");
    document.WebOffice.WebOpen();
     //document.WebOffice.WebToolsEnable('Standard',2521,false);
}
//作用：保存office正文到本地
function savelocalFile(){
	location.href='/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid=<%=attachid%>&download=1';
}

function saveDocFile(){
	var ret=document.WebOffice.WebSave();
	if(ret){
		alert("保存成功！");
	}else{
		alert("保存失败！");
	}
}
</script>
</html>