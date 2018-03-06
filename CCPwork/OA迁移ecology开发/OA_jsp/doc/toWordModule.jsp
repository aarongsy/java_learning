<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.keyinfo.service.KeyinfoService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.stamp.service.StampinfoService" %>
<%@ page import="com.eweaver.workflow.stamp.model.Stampinfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.word.service.WordModuleService" %>
<%@ page import="com.eweaver.word.model.WordModule" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.personalSignature.service.PersonalSignatureService" %>
<%@ page import="com.eweaver.base.personalSignature.model.PersonalSignature" %>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
 	String wordid = StringHelper.null2String(request.getParameter("wordid")).trim();
	
%>
	
<html>
<head>
<script type="text/javascript" language="javascript" src="/app/js/jquery.js"></script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/WorkflowService.js'></script>
<script src='/dwr/interface/WordModuleService.js'></script>
<script src='/dwr/interface/RequestlogService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>


<style>
	.x-panel-btns-ct {
	  padding: 0px;
	}
	.x-panel-btns-ct table {width:0}
	#pagemenubar table {width:0}
	.x-toolbar table {width:0}
	.x-grid3-row-body{white-space:normal;}
	.x-layout-collapsed{
	z-index:20;
	border-bottom:#98c0f4 0px solid  ;
	position:absolute;
	border-left:#98c0f4 0px solid;
	overflow:hidden;
	border-top:#98c0f4 0px solid;
	border-right:#98c0f4 0px solid
}
</style>
</head>
<body  onload="javascript:wordModuleExport();">
<object id="WebOffice" width="100%" height="500" classid="<%=WebOffice.clsid %>" codebase="<%=WebOffice.codebase %>">
			<param name="WebUrl" value="<%=WebOffice.mServerName%>">
			<param name="RecordID" value=""><!-- 文档模板，暂未启用 -->
			<param name="Template" value="">
			<param name="FileName" value="">
			<param name="FileType" value="">
			<param name="UserName" value="<%=currentuser.getObjname()%>">
			<param name="ExtParam" value="">
			<param name="EditType" value="1,1">
			<param name="PenColor" value="#FF0000">
			<param name="PenWidth" value="1">
			<param name="Print" value="1">
			<param name="ShowToolBar" value="1">
			<param name="ShowMenu" value="1">
</object>
<script>
var wfRedTempId='<%=wordid%>';

function wordModuleExport(){
    document.WebOffice.AppendMenu("2","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0019") %>(&S)");//保存本地文件
    document.WebOffice.AppendMenu("12","-");
    document.WebOffice.AppendMenu("13","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001a") %>(&P)");//打印文档
	document.WebOffice.CopyType="1";
	var office=document.getElementById('WebOffice');
	var wid=wfRedTempId;
	var aid=null;
	DWREngine.setAsync(false);//设置为同步获取数据
	WordModuleService.getAttachByWordModule(wid,function(data){aid=data});
	DWREngine.setAsync(true);
	if(Ext.isEmpty(aid)){
		alert('<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001b") %>:wid:'+wid+',aid:'+aid);//获取套红模板错误
		return true;
	}
	office.WebSetMsgByName("OPTION","LOADFILE");
    office.WebSetMsgByName("OFFICEID",aid);

    office.WebOpen();
    var word=office.WebObject;
	word.AcceptAllRevisions();
    var defaultValue="";
    //alert(word.Bookmarks.Count);
    var pdocument=opener.document;
    for(var i=1;i<=word.Bookmarks.Count;i++){
        var num = word.Bookmarks.Count;
        var name = word.Bookmarks.Item(i).Name;
        var bookmark = word.Bookmarks.Item(i).Range;
        if(name=='Content') continue;
        if(pdocument.getElementById(name)!=null){
            if(pdocument.getElementById(name).type=="select-one"){
                defaultValue=pdocument.getElementById(name).options[pdocument.getElementById(name).selectedIndex].text;
            }else if(pdocument.getElementById(name).type=="hidden"){
                defaultValue=pdocument.getElementById(name+"span").innerText;
            }else{
                defaultValue=pdocument.getElementById(name).value;
            }
            bookmark.Text=defaultValue;
            office.WebObject.Bookmarks.Add(name,bookmark);
        }
    }
	//alert('开始套入红头模板文件...');
	/*office.WebSetMsgByName("OPTION","INSERTFILE");
    var cid=Ext.getDom('docAttachId').value;
    office.WebSetMsgByName("contentId",cid);
    office.WebInsertFile();
	//word.Protect(2,true,'123');
    office.WebSetMsgByName("FILENAME","套红模板.doc");
    office.WebSetMsgByName("FILETYPE",".doc");
	office.WebSetMsgByName("ATTACHID","");
	word.AcceptAllRevisions();
    office.WebSave();*/
    return true;
}
</script>
</body>
</html>
<script language="javascript" for=WebOffice event="OnMenuClick(vIndex,vCaption)">
  if (vIndex==1){  
    WebOpenLocal();     //打开本地文件
  }
  if (vIndex==2){  
    WebSaveLocal();     //保存本地文件
  }
  if (vIndex==3){
    SaveDocument();     //保存正文到服务器上（不退出）
  }
  if (vIndex==5){  
    WebOpenSignature(); //签名印章
  }
  if (vIndex==6){  
    WebShowSignature(); //验证签章
  }
  if (vIndex==8){  
    WebSaveVersion();   //保存版本
  }
  if (vIndex==9){  
    WebOpenVersion();   //打开版本
  }
  if (vIndex==11){
    SaveDocument();     //保存正文到服务器上
    webform.submit();   //然后退出
  }
  if (vIndex==13){  
    WebOpenPrint();     //打印文档
  }
</script>

