<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="utf-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ page import="com.eweaver.base.treeviewer.model.TreeViewerInfo"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
	xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/prototype/prototype.js"></script>
<title>
Tree example
</title>
<style type="text/css">
v\:* { behavior: url(#default#vml) }
.x-window-footer table,.x-toolbar table{width:auto;}
.viewType{position:relative;padding-left:10px;width:100%;height:auto;border:0px solid red;}
button.btnPlus{background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow-plus-nl.gif);width:18px;height:18px;}
button.btnSub{background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/tree/elbow-end-minus-nl.gif);width:18px;height:18px;}
.list1 li{margin-left:30px;}
.list1{list-style-type:decimal}
/*
   文本域样式 textarea
*/
.generaltextarea{width: 57%;font-size: 13px; height: 80px; padding: 1px,1px; color: #4e4e4e; background: #f7f7f7; overflow-y: auto;  margin-top:3px;margin-bottom:3px; border:1px solid #F4F2E8;} 
</style>
<%
 String moduleid= StringHelper.null2String(request.getParameter("moduleid"));
 %>
<script language="javascript" type="text/javascript">
var iconBase = '<%=request.getContextPath()%>/images';
var fckBasePath= '<%=request.getContextPath()%>/fck/';
var contextPath='<%=request.getContextPath()%>';
WeaverUtil.imports(['<%=request.getContextPath()%>/dwr/engine.js','<%=request.getContextPath()%>/dwr/util.js','<%=request.getContextPath()%>/dwr/interface/TreeViewer.js']);
WeaverUtil.isDebug=false;
var isUpdate=false;
//<c:if test="${not empty viewerInfo}">
	isUpdate=true;
//</c:if>

var topBar=null;
function initToolbar(){
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	addBtn(topBar,'保存','S','accept',onSave);
	addBtn(topBar,'预览','P','application_view_detail',onPreview);
	//addBtn(topBar,'返回','B','arrow_redo',function(){location.replace('/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction');});
}

WeaverUtil.load(function(){
	//alert("page loaded!");
	var keyField='<c:out value="${viewerInfo.dataKeyField}"/>';
	var treeFields=['<c:out value="${viewerInfo.treeFieldKey}"/>','<c:out value="${viewerInfo.treeFieldId}"/>','<c:out value="${viewerInfo.treeFieldName}"/>'];
	var treeType='<c:out value="${viewerInfo.treeType}"/>';
	var callback1=function(){
		var opts=$('fieldsList').options;
		for(var i=0;i<opts.length;i++){
			var opt=opts[i];
			if(keyField==opt.value){
				opt.selected=true;
				//addKeyField();//选择中标识字段
			}
		}
	}//end fun.
	var callback2=function(){
		var opts=$('treeFieldKey').options;
		for(var i=0;i<opts.length;i++){
			var opt=opts[i];
			if(treeFields[0]==opt.value){
				opt.selected=true;
			}else if(treeFields[1]==opt.value){
				$('treeFieldId').selectedIndex=i;
			}else if(treeFields[2]==opt.value){
				$('treeFieldName').selectedIndex=i;
			}
		}
	}//end fun.
	if(isUpdate){
		getFieldsList($('dataFormId'),'fieldsList',callback1);
		getFieldsList($('treeFormId'),['treeFieldKey','treeFieldId','treeFieldName'],callback2);
		selTree($('treeType'));
	}else $('treeType').selectedIndex=2;
	
	initToolbar();
	//SqlEditor.init(['menuUrl','treeWhere','dataWhere','subTree',/*'dataViewText',*/'menuFun','custom']);
	
	initViewType();
	//<c:if test="${viewerInfo.viewType==4 || viewerInfo.viewType==5}">
	initBrowserViewOptions();
	//</c:if>
	
	var obj=document.getElementById("treeViewLevel");
	if(obj.value==""){
		obj.value=2;
	}
});

function initViewType(){
	//<c:if test="${not empty viewerInfo.viewType}">
		Ext.get('viewTypeDiv<c:out value="${viewerInfo.viewType}"/>').setVisibilityMode(Ext.Element.DISPLAY).show();
	//</c:if>
	//<c:if test="${empty viewerInfo.viewType}">
		var opts=Ext.getDom('viewType').options;
		for(var i=0;i<opts.length;i++){
			if(opts[i].value=='1'){
				opts[i].selected=true;
				break;
			}
		}//设置显示类型的默认值
		Ext.get('viewTypeDiv1').setVisibilityMode(Ext.Element.DISPLAY).show();
	//</c:if>
	//TreeTypeView.set
	//<c:if test="${not empty viewerInfo.treeType}">
		Ext.get('treeTypeDiv<c:out value="${viewerInfo.treeType}"/>').setVisibilityMode(Ext.Element.DISPLAY).show();
	//</c:if>
	//<c:if test="${empty viewerInfo.treeType}">
		var opts=Ext.getDom('treeType').options;
		for(var i=0;i<opts.length;i++){
			if(opts[i].value=='1'){
				opts[i].selected=true;
				break;
			}
		}//设置显示类型的默认值
		Ext.get('treeTypeDiv1').setVisibilityMode(Ext.Element.DISPLAY).show();
	//</c:if>
}

/** Browser框显示样式时的选项设置，事件初始化等*/
function initBrowserViewOptions(){
	var radios=document.getElementsByName("multiSel");
	var radio=null;
	for(var i=0;i<radios.length;i++){
		Event.observe(radios[i],"click",function(e){
			radio=Event.element(e);
			$('leaf').disabled=(radio.value=="0");
			$('sync').disabled=!(radio.value=="2");
		});
	}
	//<c:if test="${not empty viewerInfo.options}">
	var val=<c:out value="${viewerInfo.options}" escapeXml="false"/>;
	//</c:if>
	//<c:if test="${empty viewerInfo.options}">
	var val={multi:0,leaf:false,sync:false};
	//</c:if>
	//<c:if test="${viewerInfo.viewType==4}">
	if(val.multi){
		$('multiSel'+val.multi).checked=true;
		$('leaf').disabled=(val.multi==0);
		$('sync').disabled=!(val.multi==2);
		$('leaf').checked=val.leaf;
		$('sync').checked=val.sync;
	}
	//</c:if>
	//初始化导舤页传参数方式的值
	//<c:if test="${not empty viewerInfo.optionsObject.pathParam}">
	$('pathParam<c:out value="${viewerInfo.optionsObject.pathParam}"/>').checked=true;
	var p=DWRUtil.getValue('pathParam');
	if($('pathParam1').checked){
		//var btns=$('pathParams').getElementsByClassName("btnPlus");
		//if(btns.length>0) btns[0].disabled=true;
	}else if($('pathParam0').checked){
		$('pathParams').disabled=true;
		var ts=$('pathParams').getElementsByTagName("input");
		Ext.each(ts,function(t){
			if(t.type!='hidden') t.disabled=true;
		});
		ts=$('pathParams').getElementsByTagName("button");
		Ext.each(ts,function(t){
			t.disabled=true;
		});
	}
	//</c:if>
}

function selTree(obj){
	var val=obj.options[obj.selectedIndex].value;
	for(var i=1;i<6;i++) Ext.get('treeTypeDiv'+i).setVisibilityMode(Ext.Element.DISPLAY).hide();
	Ext.get('treeTypeDiv'+val).setVisibilityMode(Ext.Element.DISPLAY).show();
	
	if(obj.value==3 || obj.value==5){
		Ext.get('vorder').setVisibilityMode(Ext.Element.DISPLAY).show();
	}
	else{
		Ext.get('vorder').setVisibilityMode(Ext.Element.DISPLAY).hide();
	} 
}

function onDelete(id){
	if(confirm("确认删除该记录吗(Y/N)?")){
		$('viewerId').value=id;
		$('DeleteForm').submit();
	}
}
function onUpdate(id){
	$('action').value="update";
	$('viewerId').value=id;
	$('DeleteForm').submit();
}
function onPreview(){
	var url2="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction";
	var id="<c:out value="${viewerInfo.id}"/>";
	var name="<c:out value="${viewerInfo.title}"/>";
	if(id!=""){
		onUrl(url2+"?viewerId="+id+"&rootId=&level=2","预览("+name+")","treePreview"+id);
	}
}

function onCopy(id){
	var sText="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerAction?viewerId="+id+"&rootId=&level=";
	window.clipboardData.setData("Text",sText);
	alert('URL已复制到剪贴板！');
}

function onCopyBrowser(id){
	var sText="<%=request.getContextPath()%>/base/refobj/treeviewerBrowser.jsp?id="+id+"&mutil=false&sync=false";
	window.clipboardData.setData("Text",sText);
	alert('URL已复制到剪贴板！');
}

function getFieldsList(obj,ids,_callback){
	var formId=DWRUtil.getValue(obj);
	if(WeaverUtil.isEmpty(formId)){
		if(typeof(ids)=='string')ids=[ids];		
		for(var i=0;i<ids.length;i++) DWRUtil.removeAllOptions(ids[i]);
		return;
	}
	TreeViewer.getFormFields(formId,function(data){
		if(typeof(ids)=='string')ids=[ids];		
		for(var i=0;i<ids.length;i++) DWRUtil.removeAllOptions(ids[i]);
		var s=null;

		for(var i=0;i<ids.length;i++){
			DWRUtil.addOptions(ids[i],data,function(d){return d.value;},function(d){return d.text+" - "+d.value;});
		}//end if
		if(typeof(_callback)=='function')_callback();
	});
}

function getSelectItem(id){
	var url='<%=request.getContextPath()%>/base/selectitem/selectitemtypebrowser.jsp';
	var itemId=getBrowserValue(url);
	if(itemId!=null){
		$(id).value=itemId[0].trim();
		$(id+'text').value=itemId[1];
		$(id+'span').innerHTML=itemId[1];
	}//else alert('SelectItem.id is null!');
}

function addKeyField(obj){
	//var v=$F("fieldsList");
	var v=obj.options[obj.selectedIndex].value;
	if(v!=null && v!=""){
		DWRUtil.setValue('dataKeyField',v);
		DWRUtil.setValue('dataKeyFieldSpan',$("fieldsList").options[$("fieldsList").selectedIndex].text);
		//$('dataKeyFieldSpan').innerHTML=v;
	}//end if.
}
var iIndex=0;
function delViewField(obj){
	new Ext.Element(obj.parentNode).remove();
}
function addViewField(blAdd){
	var v=DWRUtil.getValue("fieldsList");
	if(v==null || v==""){
		alert('请选择一项字段！');
		return;
	}
	var txt=$("fieldsList").options[$("fieldsList").selectedIndex].text;
	
	if(blAdd)
		$('dataViewText').value=DWRUtil.getValue('dataViewText')+'${'+v+'}';
}
function onSave(b){
	if(DWRUtil.getValue('title').trim()==''){
		alert('标题不能为空!');
		$('title').focus();
		return;
	}
	var txt=DWRUtil.getValue('dataViewText').trim();
	if(txt==''){
		alert('结点HTML文本不能为空!');
		$('dataViewText').focus();
		return;
	}
	var opts=$('switchTreeSel').options;
	var ids=[];
	Ext.each(opts,function(opt){
		ids.push(opt.value);
	});
	$('switchTreeText').value=ids.join(",");
	//alert($('switchTreeText').value);
	/*
	var dataKeyField=$F('dataKeyField');
	if(dataKeyField==''){
		alert('结点关键字段不能为空!');
		return;
	}
	*/
    var moduleid='<%=moduleid%>';
    if(moduleid!=''&&document.all('moduleid').value==''){
        document.all('moduleid').value=moduleid;
    }
	document.EWeaverForm.submit();
}
function onClear(){
	$('EWeaverForm').reset();
}

function addRow(name){
	var div=document.createElement('li');
	if(typeof(name)=='string'){
		div.id=name+rowIndex2;
		var s="参数名称:<input size='30' class='InputStyle2' name='"+name+"Name"+rowIndex2+"' value=''/>";
		s+='<button type=button value="" class="btnSub" onclick="delRow(\''+name+'\','+rowIndex2+')"></button>';
		div.innerHTML=s;
		$(name).appendChild(div);
		rowIndex2+=1;
	}else{
		div.id="menuItem"+rowIndex;
		var s="名称:<input class='InputStyle2' name='menuName"+rowIndex+"' value=''/>";
		s+="&nbsp;URL:<input class='InputStyle2' id='menuUrl"+rowIndex+"' onfocus='SqlEditor.Show(event)' name='menuUrl"+rowIndex+"' value=''/>";
		s+='<button type=button value="" class="btnSub" onclick="delRow('+rowIndex+')"></button>';
		div.innerHTML=s;
		$('menuDiv').appendChild(div);
		rowIndex+=1;
	}
}
var rowIndex=100;
var rowIndex2=100;
function delRow(name,index){
	var id=null;
	if(typeof(index)!='undefined') id=name+index;
	else id="menuItem"+name;
	Ext.get(id).remove();
}

function onPathParam(obj){
	//alert('obj:'+obj.id);
	$('pathParams').disabled=(obj.value=='0');
	var ts=null;
	ts=$('pathParams').getElementsByTagName("button");
	Ext.each(ts,function(t){
		t.disabled=(obj.value!=2);
	});

	ts=$('pathParams').getElementsByTagName("input");
	Ext.each(ts,function(t){
		if(t.type!='hidden') t.disabled=(obj.value=='0');
	});
}

/** 树目录类型显示=1 */
/** 组织树类型<b>横向</b>显示=2 */
/** 组织树类型<b>纵向</b>显示=3 */
/** 树目录类型Browser框显示=4 */
/** 树目录导航页显示=5 */
function chViewType(obj){
	var val=obj.options[obj.selectedIndex].value;
	for(var i=1;i<6;i++) Ext.get('viewTypeDiv'+i).setVisibilityMode(Ext.Element.DISPLAY).hide();
	Ext.get('viewTypeDiv'+val).setVisibilityMode(Ext.Element.DISPLAY).show();
}

function removeTree(){
	var sel=$('switchTreeSel');
	if(sel.options && sel.options.length>0)
		sel.options.remove(sel.selectedIndex);
}

function addTree(){
	var _callback=function(win){
		var ids=win.document.getElementsByName("id");
		var id=null;
		Ext.each(ids,function(d){
			if(d.checked){
				id=d.value;
				throw $break;
			}
		});
		if(id==null) return;//未选择
		if(id==DWRUtil.getValue('id'))return;//当前模板
		var title=win.DWRUtil.getValue('title'+id);
		var opts=$('switchTreeSel').options;
		opt=null;
		Ext.each(opts,function(o){
			if(o.value==id){
				alert(title+'已经存在!');
				opt=o;throw $break;
			}
		});
		if(opt!=null)return;
		opt=new Option();
		opt.text=title;opt.value=id;
		$('switchTreeSel').options.add(opt);
	};
	var win=top.ExtWidnow.open('<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction?action=listTree&t='+(new Date().toString()),_callback);
}


</script>
</head>

<body>
<div id="pagemenubar" style="z-index:100;"></div>
<!-- 
<form id="DeleteForm"  name="DeleteForm" method="POST" action="#">
<input type="hidden" id="action" name="action" value="delete"/>
<input type="hidden" id="viewerId" name="id" value=""/>
</form>
 -->
<form id="EWeaverForm" name="EWeaverForm" method="post"	action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TreeViewerListAction">
<input type="hidden" id="moduleid" name="moduleid"
	value='<c:out value="${viewerInfo.moduleid}"/>'>
<input type="hidden" name="action" value="save" />
<!-- <fieldset style="width: 98%"><legend>设置树视图</legend> -->
<table width="100%" border="0" cellspacing="1" cellpadding="1">
<colgroup>
<col width="100"/>
<col width="*"/>
</colgroup>
<tr>
<td>
<strong>
设置树视图
</strong>
</td>
<td>
&nbsp;
</td>
    </tr>
  <tr>
    <td class="FieldName">ID</td>
    <td class="FieldValue"><input class="InputStyle2" style="width:220px;" readonly="readonly" type="text" name="id" value='<c:out value="${viewerInfo.id}"/>' /></td>
    </tr>
  <tr>
  <td class="FieldName">标题</td>
  <td class="FieldValue"><input size="50" class="InputStyle2" style="width:300px;" id="title" name="title" value='<c:out value="${viewerInfo.title}"/>' onblur="checkInput('title','titleSpan')" />
  <span id="titleSpan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align="absMiddle"/></span>
  </td>
  </tr>
  <tr>
  <td class="FieldName">树形样式</td>
  <td class="FieldValue">
  <fieldset><legend>
  <select class="InputStyle2" name="viewType" id="viewType" onchange="chViewType(this)">
  	<c:forEach var="vt" items="${viewType}">
	<option value='<c:out value="${vt.key}"/>' <c:if test="${viewerInfo.viewType==vt.key}">selected="selected"</c:if> ><c:out value="${vt.value}"/></option>
	</c:forEach>
  </select>
	</legend>
  <div id="viewTypeDiv1" class="viewType" style="display:none">
  <!--  树目录类型显示=1  -->

  </div>
  <div id="viewTypeDiv2"  class="viewType" style="display:none">
  <!-- 组织树类型<b>横向</b>显示=2 --> 

  </div>
  <div id="viewTypeDiv3" class="viewType" style="display:none">
  <!-- 组织树类型<b>纵向</b>显示=3  --> 

  </div>
  <div id="viewTypeDiv4" class="viewType" style="display:none">
	<label for="multiSel2"><input type="radio" id="multiSel2" name="multiSel" value="2">多选</label>&nbsp;
	<label for="multiSel1"><input type="radio" id="multiSel1" name="multiSel" value="1">单选</label>&nbsp;
	<label for="multiSel0"><input type="radio" id="multiSel0" checked="checked" name="multiSel" value="0">无</label>&nbsp;<br/>
	<label for="sync"><input type="checkbox" id="sync" name="sync" disabled="disabled" value="1"/>多选时是否选中子项</label><br/>
	<label for="leaf"><input type="checkbox" id="leaf" name="leaf" disabled="disabled" value="1"/>是否叶子结点才允许选择</label><br/>
  </div>
  <div id="viewTypeDiv5" class="viewType" style="display:none">
		<div>设置树切换下拉框:<input type="hidden" name="switchTree" id="switchTreeText" value='<c:out value="${viewerInfo.optionsObject.switchTree}"/>'/>
		<select id="switchTreeSel" style="width:120px;">
		<c:if test="${not empty viewerInfo.optionsObject.switchTree}">
		<!-- Not empty switchTree -->
		<c:forEach var="t" items="${switchTreeList}"><option value='<c:out value="${t.key}"/>'><c:out value="${t.value}"/></option></c:forEach>
		</c:if>
		</select>
		<button type=button class="btnPlus" value="" onclick="addTree();"></button>
		<button type=button class="btnSub" value="" onclick="removeTree();"></button></div>
  		<br/>
		<div>添加导航树的右击菜单:</div>
		<ol id="menuDiv" style="list-style-type:decimal;margin-left:15px;">
		<c:forEach var="m" items="${viewerInfo.menuObject}" varStatus="status">
		<li id='menuItem<c:out value="${status.index}"/>'>名称:<input class="InputStyle2"  name='menuName<c:out value="${status.index}"/>' value='<c:out value="${m.key}"/>'/>
		URL:<input class="InputStyle2"  id='menuUrl<c:out value="${status.index}"/>' name='menuUrl<c:out value="${status.index}"/>' value='<c:out value="${m.value}"/>'/>(*可用变量:${nodeId})
		<c:if test="${status.index==0}"><button type=button class="btnPlus" value="" onclick="addRow()"></button></c:if><!-- 添加按钮 -->
		<c:if test="${status.index!=0}"><button type=button class="btnSub" value="" onclick="delRow(<c:out value="${status.index}"/>)"></button></c:if>
		</li>
		</c:forEach>
		<c:if test="${empty viewerInfo.menuObject}">
		<li id='menuItem0'>名称:<input class="InputStyle2"  name='menuName0' value=''/>
		URL:<input class="InputStyle2"  id='menuUrl0' name='menuUrl0' value=''/>(*可用变量:${nodeId})
		<button type=button value="" class="btnPlus" onclick="addRow()"></button>
		</li>
		</c:if>
		</ol>
		<br/>
		<ul>
		<li>结点链接传递参数方式:</li>
		<li><label for="pathParam2"><input onclick="onPathParam(this);" type="radio" id="pathParam2" name="pathParam" value="2">结点路径参数</label>&nbsp;
			<label for="pathParam1"><input onclick="onPathParam(this);" type="radio" id="pathParam1" name="pathParam" value="1">叶子结点参数</label>&nbsp;
			<label for="pathParam0"  title="默认参数在Html文本结点中直接设置!"><input  onclick="onPathParam(this);" type="radio" id="pathParam0" checked="checked" name="pathParam" value="0">默认参数</label>
		</li>
		</ul>
		<ol id="pathParams" style="list-style-type:decimal;margin-left:15px;">
		<c:if test="${not empty viewerInfo.optionsObject.pathParams}">
			<c:forEach var="p" items="${viewerInfo.optionsObject.pathParams}" varStatus="t">
			<li id='pathParams<c:out value="${t.index}"/>'>参数名称:<input class="InputStyle2" size="30" name='pathParamsName<c:out value="${t.index}"/>' value='<c:out value="${p}"/>'/>
			<c:if test="${t.index==0}"><button type=button class="btnPlus" value="" onclick="addRow('pathParams')"></button></c:if><!-- 添加按钮 -->
			<c:if test="${t.index!=0}"><button type=button class="btnSub" value="" onclick="delRow('pathParams',<c:out value="${t.index}"/>)"></button></c:if>
			</li>
			</c:forEach>
		</c:if>
		<c:if test="${empty viewerInfo.optionsObject.pathParams}">
			<li>参数名称:<input class="InputStyle2" size="30" name="pathParamsName0" value=''/>
			<button type=button class="btnPlus" value="" onclick="addRow('pathParams')"></button>
			</li>
		</c:if>
		</ol>
		<!-- 
		菜单接口函数:function(item,nodeId){<br/>
		<textarea  class="InputStyle2" name="menuFun" id="menuFun" cols="80" rows="1"><c:out value="${viewerInfo.menuFun}"/></textarea>
		<br/>}
		 --><br/>
  </div>
  </fieldset>
  <br/>
  </td>
  </tr>
  <tr>
    <td class="FieldName">树形数据来源</td>
    <td class="FieldValue">
	默认根结点:<input type="text"  class="InputStyle2" size="40" style="width:220px;" name="rootId" value='<c:out value="${viewerInfo.optionsObject.rootId}"/>'/><br/>
	默认展开级数：<input class="InputStyle2" id="treeViewLevel" name="treeViewLevel" value='<c:out value="${viewerInfo.treeViewLevel}"/>' onblur="javascript:if(fucCheckNUM(this.value)==0){this.value=2;}"/>(级联子树不支持此功能)<br/>
    <fieldset>
    <legend>
	    <select class="InputStyle2" id="treeType" name="treeType" size="1" onchange="selTree(this)">
			<c:forEach var="m" items="${treeType}">
		      <option value='<c:out value="${m.key}"/>' <c:if test="${m.key==viewerInfo.treeType}">selected="selected"</c:if> ><c:out value="${m.value}"/></option>
			</c:forEach>
	    </select>
	</legend>

<div id="treeTypeDiv1" class="viewType" style="display:none">
<!-- 组织结构树 -->
</div>
<div id="treeTypeDiv2" class="viewType" style="display:none">
<!-- 分类体系树 -->
<c:forEach var="opt" items="${optTypes}" varStatus="i">
<label for='opttype<c:out value="${i.index}"/>'>
<input type="radio" name="optType" id='opttype<c:out value="${i.index}"/>' value='<c:out value="${opt.value}"/>' <c:if test="${opt.value==optType}">checked="checked"</c:if> />
<c:out value="${opt.key}"/></label>
</c:forEach>
</div>
<div id="treeTypeDiv3" class="viewType" style="display:none">
<!-- 表单结构树时的参数 -->
		<span id="formTreeDiv">
	树结点条件：<input class="InputStyle2" name="treeWhere" id="treeWhere" value='<c:out value="${viewerInfo.treeWhere}"/>'/>(可用变量:${userid},${orgid},${subOrgids},${bizOrgid},${bizOrgids})<br/>
      表单：<select id="treeFormId" name="treeFormId" class="InputStyle2" onchange="getFieldsList(this,['treeFieldKey','treeFieldId','treeFieldName'])">
      <c:forEach var="form" items="${formList}">
        <option value='<c:out value="${form.id}"/>' <c:if test="${form.id==viewerInfo.treeFormId}">selected="selected"</c:if> >
          <c:out value="${form.objname}"/>
          </option>
      </c:forEach>
    </select><br/>
      &nbsp;上下级关联字段：<select id="treeFieldKey" class="InputStyle2" name="treeFieldKey"></select><br/>
      &nbsp;结点标识字段：<select id="treeFieldId" class="InputStyle2" name="treeFieldId"></select><br/>
       &nbsp;结点显示名称字段：<select id="treeFieldName" class="InputStyle2" name="treeFieldName"></select>
</span>
</div>
<div id="treeTypeDiv4" class="viewType" style="display:none">
<!-- 选择项树结构的参数 -->
	<button type=button class="Browser" onclick="getSelectItem('selectItemId');"></button>
	<input type="hidden" id="selectItemId" name="selectItemId" value='<c:out value="${viewerInfo.optionsObject.selectId}"/>'>
	<input type="hidden" id="selectItemIdtext" name="selectItemIdtext" value='<c:out value="${viewerInfo.optionsObject.selectIdText}"/>'>
	<span id="selectItemIdspan"><c:out value="${viewerInfo.optionsObject.selectIdText}"/></span>
</div>
<div id="treeTypeDiv5" class="viewType" style="display:none">
<!-- 自定义树结构的参数 -->
需要定义字段别名Id和name，如(SELECT <b>f1 AS id</b>,f2,f3,<b>fname AS name</b> FROM tbale1)<br/>
<!-- <input name="customSql" id="customSql" value=''/>
-->
SQL语句:<textarea name="customSql" id="customSql" cols="60" rows="3" class="generaltextarea"><c:out value="${viewerInfo.optionsObject.customSql}"/></textarea>
</div>
</fieldset>
<br/>
<!-- end -->
</div>
	</td>
    </tr>
  <tr>
    <td class="FieldName">节点数据来源</td>
    <td  class="FieldValue"><select id="dataFormId" name="dataFormId" class="InputStyle2" onchange="getFieldsList(this,'fieldsList')">
      <c:if test="${viewerInfo.treeType!=3}"><option value="">&nbsp;&nbsp;&nbsp;</option></c:if>
      <c:forEach var="form" items="${formList}">
        <option value='<c:out value="${form.id}"/>' <c:if test="${form.id==viewerInfo.dataFormId}">selected="selected"</c:if> >
          <c:out value="${form.objname}"/>
          </option>
      </c:forEach>
    </select></td>
    </tr>
  <tr>
    <td class="FieldName" valign="top">数据关联字段</td>
    <td  class="FieldValue" valign="top">
	<select id="fieldsList" onchange="addKeyField(this)" class="InputStyle2"  name="fieldsList" style="float:left;">      
    </select>
    <input id="dataKeyField"  name="dataKeyField" type="hidden" value='<c:out value="${viewerInfo.dataKeyField}"/>' />
<!-- 		<button name="btnAddKey" class="btn" onclick="addKeyField()" id="btnAddKey">选择关联字段</button>
		<br />
-->
		<button type=button name="btnAddKey2" class="btn" onclick="addViewField(true)" id="btnAddKey2">添加显示字段</button>
<span id="dataKeyFieldSpan"><c:out value="${viewerInfo.dataKeyField}"/></span>
(*指树结构上的结点数据和树形之间的对应关系字段名)
</td>
  </tr><!-- 
  <tr>
    <td class="FieldName" valign="top">结点关联字段</td>
    <td class="FieldValue" valign="top">
    <label>
    <input id="dataKeyField"  name="dataKeyField" type="hidden" value='<c:out value="${viewerInfo.dataKeyField}"/>' />
    <span id="dataKeyFieldSpan"></span>    </label></td>
    </tr> -->
 <tr>
 <td class="FieldName">表单查询条件</td>
 <td class="FieldValue"><%--<input size="60" class="InputStyle2" name="dataWhere" id="dataWhere" value='<c:out value="${viewerInfo.dataWhere}"/>'/> --%>
     <textarea rows="5" cols="80" class="generaltextarea" name="dataWhere" id="dataWhere"><c:out value="${viewerInfo.dataWhere}"/></textarea>
 </td>
 </tr>
 <tr id='vorder' style="display:none;">
 <td class="FieldName">表单查询顺序</td>
 <td class="FieldValue">
     <input size="50" class="InputStyle2" style="width:200px;" id="vieworder" name="vieworder" value='<c:out value="${viewerInfo.vieworder}"/>' />
 </td>
 </tr>
 <tr><td class="FieldName">级联子树条件</td>
 <td class="FieldValue">
 <%--    <input size="60" class="InputStyle2" name="subTree" id="subTree" value='<c:out value="${viewerInfo.subTree}"/>'/>--%>
        <textarea rows="5" cols="80" class="generaltextarea" name="subTree" id="subTree"><c:out value="${viewerInfo.subTree}"/></textarea>
     <ol class="list1">
		<li>格式为:${子树viewerId}:子树关联参数</li>
		<li>子树关联参数说明:</li>
	    <li>a、下级树表单字段名(传递父级树节点id，下级树通过表单字段名过滤自身数据)</li>
	    <li>b、下级sql参数名(传递父级树节点id，下级树通过Sql参数过滤自身数据)</li>
	    <li>c、任意名称(上下级树不传递参数，下级树全关联至上级叶子节点)</li>
    </ol>
</td>
 </tr>
  <tr>
    <td class="FieldName">结点文本</td>
    <td class="FieldValue">
    <textarea class="generaltextarea" onblur="checkInput(this.id,'viewTextSpan')" id="dataViewText" name="dataViewText" cols="80" rows="10"><c:out value="${viewerInfo.dataViewText}"/></textarea>
    <span id="viewTextSpan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align="absMiddle"/></span><br/>
    <ol class="list1">
		<li>${key:nodeId}-树结点ID</li>
	    <li>${key:nodeName}－结点名称</li>
	    <li>${key:nodeLevel}-树层级</li>
	    <li>${key:countHumres}-根据orgid统计人员个数)</li>
	    <li>JS函数:onUrl(url,title,id,[inactive],[image])打开Tab页</li>
    </ol>
    </td>
  </tr>
  <tr>
    <td class="FieldName">自定义函数</td>
    <td class="FieldValue">
    <textarea class="generaltextarea" id="userFun" name="userFun" cols="80" rows="10"><c:out value="${viewerInfo.userFun}"/></textarea>
    <br/>(用户自定义函数用于结点单击时的自定义操作,RequestParams.$name1从URL请求中获取名为$name1的参数值)<br/>
    导航页显示时,右窗口的iframe.id=treeIframe,使用Ext.getDom('treeIframe').src=url;///访问页面...
    </td>
  </tr>  
<!--  添加树形菜单
  <tr>
    <td  class="FieldName">右击菜单</td>
    <td  class="FieldValue">
    	
	</td>
    </tr>
 -->
</table>
</form>

</body>
</html>
