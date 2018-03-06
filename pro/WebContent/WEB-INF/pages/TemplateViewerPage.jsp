<%@ page buffer="none" contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*,com.eweaver.base.util.VtlEngineHelper,java.io.*" %>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.service.TemplateEngine"/>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%
out.println("<div id=\"loading\" style=\"position:absolute;width:100%;height:100%;left:0px;top:0px;background-color:#ffffff;-moz-opacity:0.6;filter:alpha(opacity=60)\">");
out.println("<div style=\"position:absolute;top:200px;width:100%;text-align:center;\"><img src=\""+request.getContextPath()+"/js/ext/resources/images/default/grid/loading.gif\"/>正在运算数据，请稍候....</div>");
out.println("</div>");
out.flush();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- <script language="javascript" src="/js/prototype.js"></script>
 -->
<script language="javascript" src="/js/weaverUtil.js"></script>
<script language="javascript" src="/js/main.js"></script>
<title>模板解析</title>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
<script type="text/javascript">
var iconBase = '/images';
var fckBasePath= '/fck/';
var contextPath='';
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js','/dwr/interface/SelectitemService.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

var topBar=null;
WeaverUtil.load(function(){
	var div=document.createElement("div");
	div.id="pagemenubar";
	Ext.getBody().insertFirst(div);
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	topBar.addSpacer();
	addBtn(topBar,'保存为Excel','E','page_excel',Save2Excel);
	//var idx=location.href.indexOf('?');
    //if(idx>0) document.formExport.action= document.formExport.action+location.href.substring(idx);
});
function Save2Html(){
	if(!document.getElementById('type')){
		alert('导出功能需要在<form>标记内添加<input type="hidden" id="type" name="type">的字段!');
		return;
	}
	document.getElementById('type').value="html";
	//document.forms[0].target="_blank";
	document.forms[0].submit();
	document.getElementById('type').value="";
}
function Save2Excel(){
	if(!document.getElementById('type')){
		alert('导出功能需要在<form>标记内添加<input type="hidden" id="type" name="type">的字段!');
		return;
	}
	document.getElementById('type').value="excel";
	//document.forms[0].target="_blank";
	document.forms[0].submit();
	document.getElementById('type').value="";
}

function browserBox(bid,inputname,isneed,_callback){
	var ret=0;
	var url="/base/refobj/baseobjbrowser.jsp?id="+bid;
	var id = openDialog("/base/popupmain.jsp?url="+encodeURIComponent(url));
	var isCheck=false;
	var inputspan=inputname+'Span';
	if(typeof(isneed)=='undefined')isCheck=false;
	else if(typeof(isneed)=='string')isCheck=(isneed=='0' || isneed.toLowerCase()=='y' || isneed.toLowerCase()=='f')?false:true;
	else if(typeof(isneed)=='number')isCheck=(isneed==0)?false:true;
	else if(typeof(isneed)=='boolean')isCheck=isneed;

	if(typeof(id)!='undefined'){
		if(Object.prototype.toString.apply(id) === '[object Array]'&&id[0]!="0"){
			$(inputname).value =id[0];
			$(inputspan).innerHTML =id[1];
		}else{
			$(inputname).value = "";
			$(inputspan).innerHTML =(isCheck)?"<img src=/images/base/checkinput.gif>":"";
		}
		if(typeof(_callback)=='function'){
			_callback($(inputname).value,inputname);
		}
	}else ret=-1;	
	return ret;
}//end fun.


/**动态异步加载模块视图
 * @vid as String //视图模板ID
 * @cid as String //视图模板显示区域ID
 * @params as Object //参数对象
 * @_callback as Function //回调函数，成功后的回调函数
 */
function loadView(vid,cid,_params,_callback){
	if(Ext.isEmpty(_params))_params='';
	$(cid).style.height="50px";
	$(cid).style.width="100%";
	var myMask = new Ext.LoadMask($(cid), {msg:"请稍等,数据加载中...",removeMask:true});
	var ofg={
		url: '/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?action=partview',
		method:'post',
		timeout:180000,//三分钟
		success:function(resp,opt){
			myMask.hide();
			var ret=resp.getResponseHeader.ret;
			if(parseInt(ret)<0){
				opt.failure(resp,opt);
			}else{
				$(cid).innerHTML=resp.responseText;
				if(typeof(_callback)=='function')_callback();
			}
		},
		failure:function(resp,opt){
			myMask.hide();
			alert('视图模板{'+vid+'}加载错误:'+resp);
			$(cid).innerHTML='<pre>'+resp.responseText+'</pre>';			
		},
		//headers:{ 'my-header': 'foo'}
		params:{id:vid,where:_params}
	};
	myMask.show();
	Ext.Ajax.request(ofg);
}//end fun.

function getSubSelect(obj,chid,allowEmpty,val)
{
	if(Ext.isEmpty(chid)){alert('联运下拉框的子项id不能为空!');return;}
	var pid=obj.options[obj.selectedIndex].value; 
	SelectitemService.getSelectitemList('',pid,function(data){
		DWRUtil.removeAllOptions(chid);
		if(!Ext.isEmpty(allowEmpty)) DWRUtil.addOptions(chid,{text:''});
		DWRUtil.addOptions(chid,data,function(s){return s.id;},function(s){return s.objname;});
		if(!Ext.isEmpty(val)){
			var opts=Ext.getDom(chid).options;
			for(var i=0;i<opts.length;i++){
				if(opts[i].value==val)opts[i].selected=true;
			}
		}//end if.
	}); 
}

var viewerId='<%=request.getParameter("id")%>';

/**
 * 动态获取单个数据项,对应服务器端TreeViewerRemote.getSQLValue()方法
 * 局部数据并带格式化文本的，则新建模板调用loadView()来实现
 * @objName as String //当前指定模板中定义好的数据对象名，并以sql*前缀。（其指向于一条select语句）
 * @sqlWhere as String //为指定objName指向Sql的参数，这里只传送Where为安全起见，防止客户端注入Sql语句
 */
function getSQLValue(objName, sqlWhere){
	if(!objName.startsWith("SQL"))return "";
	var ret=null;
	DWREngine.setAsync(false);//设置ＤＷＲ为同步获取数据	
	TreeViewer.getSQLValue(viewerId,objName,sqlWhere,function(data){ret=data;});
	DWREngine.setAsync(true);//重置ＤＷＲ为异步请求
	return ret;
}
window.onload=function(){
	Ext.removeNode(Ext.getDom('loading'));
};
</script>
</head>

<body>
<!-- 
<form action="/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction" name="formExport" method="post">
<input type="hidden" name="id" value='<c:out value="${viewerId}"/>'/>
<input type="hidden" name="type" id="exportType" value='excel'/>
</form>
--><%
String viewerId=request.getAttribute("viewerId").toString();
String jsonWhere="";
if(request.getAttribute("jsonWhere")!=null)
	jsonWhere=request.getAttribute("jsonWhere").toString();
request.setAttribute("_responseScope",response);
new TemplateEngine(request,out).parseTemplate(viewerId, jsonWhere);
%>
</body>
</html>
