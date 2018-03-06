<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/dwr/engine.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/TreeViewer.js"></script>

<title>DynamicReport example </title>
<style type="text/css">
	.x-toolbar table {width:0}
	#pagemenubar table {width:0}
	.x-panel-btns-ct {padding: 0px;}
	.x-panel-btns-ct table {width:0}
</style>

<script language="javascript" type="text/javascript">

var topBar=null;
function Save(){
	if(chk()) document.form1.submit();
}
function Cancel(){
	var url=contextPath+'/ServiceAction/ServiceAction/com.eweaver.report.servlet.DynamicReportListAction';
	location.replace(url);
}

function chk(){
	
	var formIds=[];
	var opts=document.getElementById('formList').options;
	var obj=null;
	for(var i=0;i<opts.length;i++){
		var fid=opts[i].value;
		obj=new Object();
		if(fid.startsWith('sql')) obj.label=opts[i].text;
		obj.formId=fid;
		obj.sql=opts[i].getAttribute("_sql");
		formIds[i]=obj;
	}
	Report.formIds=formIds;
	document.getElementById("data").value=Ext.encode(Report);
	return true;
}
//<c:if test="${empty viewer}">
var Report={data:{},formIds:""};
//</c:if>
//<c:if test="${not empty viewer}">
var Report=<c:out value="${viewer.objectNames}" escapeXml="false"/>;
//</c:if>
Ext.onReady(function(){

	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'保存','S','accept',Save);
	addBtn(topBar,'取消','C','arrow_redo',Cancel);
/*
	FCKEditorExt.complete=function(fck){
		//var fck=FCKeditorAPI.GetInstance('htmlText');
		fck.Events.AttachEvent("mouseover",function(d){
			alert('ddd:'+d);
		});
		alert('ok..');
	};
*/
	FCKEditorExt.initEditor('htmlText',false,FCKEditorExt.REPORT);
	
	var formList=$('formList').options;
	var formObj={};
	for(var i=0;i<formList.length;i++)formObj[formList[i].value]=formList[i];
	var forms=Report.formIds;
	for(var i=0;i<forms.length;i++){
		var form=forms[i];
		formObj[form.formId].setAttribute("_sql",form.sql);
	}//end for.
    try{
	$('sql').value=formList[formList.selectedIndex].getAttribute("_sql");
    }catch(e){}

});

function chForm(obj){
	var opt=obj.options[obj.selectedIndex];
	$('sql').value=opt.getAttribute("_sql");
}
function setSql2obj(oTxt){
	var obj=$('formList');
	if(!Ext.isEmpty(oTxt.value.trim()))
		obj.options[obj.selectedIndex].setAttribute("_sql",oTxt.value);
}
function addUserSql(){//添加自定义ＳＱＬ
	var sqlName=prompt("请输入该SQL语句的标识名称：");
	var obj=$('formList');
	if(sqlName){
		var opt=document.createElement("OPTION");
		opt.text=sqlName;
		opt.value=WeaverUtil.generateId('sql');
		opt.selected=true;
		obj.options.add(opt);
		$('sql').value='';
		$('sql').focus();
	}
}
function addForm(isDel){
	var select=$('formList');
	if(isDel){//delete formId;
		var opt=select.options[select.selectedIndex];
		var vv=opt.value;
		var data=Report.data;
		for(var i in data){
			if(data[i].formId==vv){
				alert('该表单被字段{'+data[i].label+'}使用中，请先删除字段再操作!');
				return;
			}
		}
		select.removeChild(opt);
		$('sql').value=select.options[select.selectedIndex].getAttribute('_sql');
		return;
	}
	var url=contextPath+'/base/refobj/baseobjbrowser.jsp?id=402880a51daeee72011daf01434a0002';
	var val=getBrowserValue(url);
	if(Object.prototype.toString.apply(val) === '[object Array]'){
		var opt=document.createElement("option");
		opt.value=val[0];opt.text=val[1];
		opt.selected=true;
		select.add(opt);
		TreeViewer.getFormTableName(opt.value,function(tbName){
			//alert('tbName:'+tbName);
			$('sql').value="select * from "+tbName;
		});
	}//end if
}
</script>
</head>

<body>
<div id="pagemenubar"> </div>
<br/>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.report.servlet.DynamicReportListAction"
	method="post" name="form1" onsubmit="return chk()">
<input type="hidden" name="data" id="data" value="" />
<input type="hidden" name="action" value="save" />
<input type="hidden" name="id" value="<c:out value="${viewer.id}"/>"/>
<!-- <input type="hidden" name="formIds" id="formIds" value="" /> -->
<table width="755" border="1" cellspacing="0" cellpadding="0">
<tr><td align="right">标题：</td>
<td> <input	type="text" name="title" value="<c:out value="${viewer.title}"/>"/></td>
</tr>
<tr>
<td align="right">表单：</td>
<td><select id="formList" style="width:150px;" onchange="chForm(this)">
<c:forEach items="${formList}" var="form">
<option value="<c:out value="${form.key}"/>"><c:out value="${form.value}"/></option>
</c:forEach>
<!--
	<option value="31jasldghj3142">销售统计表单</option>
	<option value="3972919alajl13">项目业绩表单</option>
	<option value="skj32uis94ted32tds">test form</option>
	<option value="sssssssskkkkk">ddddd</option>
-->
	</select>
<a href="javascript:;" onclick="addUserSql();">添加自定义SQL</a>&nbsp;
<a href="javascript:;" onclick="addForm();">添加表单</a>&nbsp;
<a href="javascript:;" onclick="addForm(1);">删除</a>
</td>
</tr>
<!-- 
<tr><td align="right">自定义参数：</td><td><textarea style="width:500px" name="args" id="args"></textarea></td></tr>
 -->
<tr><td align="right">表单查询语句：</td><td><textarea onblur="setSql2obj(this)" style="width:500px;height:80px;" id="sql"></textarea>(使用<b><i>${varName}</i></b>引用页面传递过来的参数！)</td></tr>
</table>

<textarea name="htmlText" id="htmlText" style="width:100%;height:400px;">
<c:if test="${not empty viewer}"><c:out value="${viewer.templateText}"/></c:if>
<c:if test="${empty viewer}">
<p>&nbsp;</p>

<table class="report" bordercolor="#0000FF" border="1" style="border: 1px solid #0000FF;border-collapse: collapse;" width="500" cellspacing="0" cellpadding="0" >
    <tbody>
        <tr>
            <td width="200"></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </tbody>
</table>
<p>&nbsp;</p>
</c:if>
</textarea>
</form>
<!-- 
<input type="button" value="View data.." onclick="document.getElementById('txt').value=JSON.stringify(Report.data);" />
<textarea id="txt" style="width:500px;height:200px;"></textarea>
 --> 
</body>
</html>
