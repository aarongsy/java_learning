<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/dojo.js"></script>
<title><c:out value="${title}"/></title>
<style type="text/css">

</style>
<script>
    function GetVBArray(ids,names,isFrame){
        ars=[ids,names];
        if(isFrame)
        window.parent.parent.returnValue=ars;
        else
        window.parent.returnValue = ars
    }
</script>
<script language="javascript" type="text/javascript">
WeaverUtil.imports(['<%=request.getContextPath()%>/dwr/engine.js','<%=request.getContextPath()%>/dwr/util.js','<%=request.getContextPath()%>/dwr/interface/TreeViewer.js']);
WeaverUtil.isDebug=true;

dojo.require("dojo.lang.*");
dojo.require("dojo.widget.Tree");
dojo.require("dojo.widget.TreeSelector");
dojo.require("dojo.widget.TreeNode");
dojo.require("dojo.widget.TreeContextMenu");

var level='<c:out value="${level}"/>';
WeaverUtil.load(function(){

	TreeBuilder.buildTree();
	
});

var treeDat = {<c:out value="${treeText}" escapeXml="false"/>};
var viewerId='<c:out value="${viewerId}"/>';
var viewerId2=null;//子树的ViewerId
var strMutil='<%=request.getParameter("mutil")%>';
var isMutil=null;
if(strMutil=='true') isMutil=true;
else if(strMutil=='false') isMutil=false;
var isSync=('<%=request.getParameter("sync")%>'=='true');
var isLeafTree=('<%=request.getParameter("leaf")%>'=='true');//是否叶子结点可选，默认全部可选
var isFrame=('<%=request.getParameter("iframe")%>'=='true');
var isBrowser=true;
if('<%=request.getParameter("browser")%>'=='0') isBrowser=false;
var subTree='<c:out value="${subTree}"/>';

var TreeBuilder = {
	buildTreeNodes:function (dataObjs, treeParentNode,nLevel){
 		var obj = null;
		var _title = null;
		for(var i=0; i<dataObjs.length;i++){
			obj=dataObjs[i];
			_title = obj.title.trim();
			var node=null;
		if(_title!=''){
			if(isMutil!=null && _title!='' && (!isLeafTree || isLeafTree && !obj.isFolder) ){
				if(isMutil){
					_title+='<input type="checkbox" style="width:16px;height:16px" name="nodeId" value="'+obj.id+'" ';
					if(isSync) _title+=' onclick="TreeBuilder.nodeChk(this);" ';
					if(this.isSyncRequest)_title+=' checked="checked" ';
					_title+="/>";
				}else{
					_title+='<input type="radio" style="width:16px;height:16px" name="nodeId" value="'+obj.id+'"/>';
				}//end if.
			}
			node =  dojo.widget.createWidget("TreeNode",{
				title:_title,
				object:obj,/*obj.title,*/
				expandLevel:1,
				isFolder:obj.isFolder,
				widgetId:"ID"+obj.id,
				isExpanded:false
			});
			if(typeof(obj.subTree)=='boolean')node['subTree']=true;//设置子树标记
			treeParentNode.addChild(node,i);
			//treeParentNode.registerChild(node,i);
			if(nLevel>0 && obj.isFolder){
				node.isExpanded=false;
				node.updateExpandIcon();
			}
		}//End If.
			if(obj.children){
				if(node==null)node=treeParentNode;
				this.buildTreeNodes(obj.children, node,nLevel+1);
			}
		}
	},
	loadSubTree:function(keyId,node){//加载子树事件
		//alert('load subTree...');
		var _this=this;
		var OTree=subTree.split(":");		
		var viewerId=OTree[0];
		viewerId2=viewerId;//记录子树的viewerId
		var rootId="";
		var iLevel=(_this.isSyncRequest)?99:2;
		var params='{"'+OTree[1].toLowerCase()+'":"'+keyId+'"}';//传递给子树的树条件参数
		//alert('subString.params:'+params);
		TreeViewer.getTreeChildren(viewerId,rootId,iLevel,params,function(data){
			try{
				_this.buildTreeNodes(data[0].children,node,1);
			}catch(e){/*alert('Error:'+e.description);*/}
			if(_this.isSyncRequest) _this.isSyncRequest=false;
			node.unMarkLoading();
			node.state="LOADED";
		});
	},
	isSubTreeNode:function(node){//判断当前结点是否子树结点
		var isSubTree=false;
		while(node!=null && typeof(node)!='undefined'){
			if(typeof(node.subTree)!='undefined'){
				isSubTree=true;
				break;
			}
			node=node.parent;
		}
		return isSubTree;
	},
	myTreeWidget:null,
	buildTree:function (){
		this.myTreeWidget = dojo.widget.manager.getWidgetById("myTreeWidget");
		this.myTreeWidget.isFolder=true;
		this.myTreeWidget.isExpanded=false;
		this.buildTreeNodes(treeDat.treeNodes,this.myTreeWidget,0);
		this._listenObject();
	},
	_listenObject:function(){
		var _this=this;
		this.myTreeWidget.state="LOADED";
		dojo.event.topic.subscribe(this.myTreeWidget.eventNames['treeClick'],function(o){
			var node=o.source;//typeof TreeNode
			if(!node.isExpanded)return;
			if(node.state!="LOADED"){
				node.markLoading();
				//这里判断是否子树结点事件触发
				var objData=node.object;
				if(subTree!='' && typeof(objData.subTree)=='boolean' && objData.subTree){
					_this.loadSubTree(objData.id,node);//加载子树
					return;
				}//end if.
				//var rootId=""+node.getInfo().widgetId.substring(2);
				var rootId=objData.id;
				var iLevel=2;
				if(_this.isSyncRequest) iLevel=99;
				var vid=(_this.isSubTreeNode(node))?viewerId2:viewerId;//判断是否子树内的结点，是则变换树ID为ViewerId
				TreeViewer.getTreeChildren(vid,rootId,iLevel,"",function(data){
					try{
						_this.buildTreeNodes(data[0].children,node,1);
					}catch(e){/*alert('Error:'+e.description);*/}
					if(_this.isSyncRequest) _this.isSyncRequest=false;
					node.unMarkLoading();
					node.state="LOADED";
				});
			}//end if.not loaded!
		});//end subscribe.
		/********************************************/
		dojo.event.topic.subscribe(this.myTreeWidget.eventNames['titleClick'],function(o,e){
			var obj=o.source;//typeof TreeNode
			e=e || event;
			var tagName=e.srcElement.tagName;
			if(typeof(tagName)=='string' && tagName.toLowerCase()=='input')return;//
			var chks=obj.domNode.getElementsByTagName("input");
			if(chks.length>0){
				for(var i=0;i<chks.length;i++){
					obj=chks[i];
					if(obj.type=="checkbox" || obj.type=="radio"){
						obj.checked=!obj.checked;
						if(isMutil && isSync) _this.nodeChk(obj);
						break;
					}
				}//end for.
			}//else alert('chks.len < 0!');
		});
	},
	isSyncRequest:false,//是否异步获取所有数据
	isSyncChk:false,//是否选中下级
	nodeChk:function(o){
		var id=o.value;
		var node=dojo.widget.manager.getWidgetById("ID"+id);
		if(node.state!="LOADED"){
			this.isSyncChk=o.checked;
			this.isSyncRequest=true;
			node.onTreeClick(event);
		}else{
			var pObj=o.parentNode.parentNode.parentNode;
			var nodes=pObj.getElementsByTagName("input");
			var obj=null;
			for(var i=0;i<nodes.length;i++){
				obj=nodes[i];
				if(obj.type=="checkbox") obj.checked=o.checked;			
			}//end for.
			if(!node.isExpanded)node.expand();
		}
	},
	doOk:function(){
		//reloadResourceArray()
		//setResourceStr()
		//tmp = selectedids
		//curnum = 0
		var nodes=document.getElementsByName("nodeId");
		var ids="";
		var names="";
		var obj,node;
		for(var i=0;i<nodes.length;i++){
			obj=nodes[i];
			if(!obj.checked)continue;
			ids+=","+obj.value;
			node=dojo.widget.manager.getWidgetById("ID"+obj.value);
			names+=","+node.object.title;
		}
		ids=ids.substring(1);
		names=names.substring(1);
		GetVBArray(ids,names,isFrame);
		this.doCancel();
	},
	doCancel:function(){
		this.pWin.close();
	},
	doClear:function(){
		GetVBArray('0','',isFrame);
		this.doCancel();
	},
	pWin:(isFrame)?window.parent.parent:window.parent
}

</script>
</head>

<body scroll="yes">
<%
titlename=request.getAttribute("title").toString();//"上下级关系树";
pagemenustr += "{O,确定,javascript:TreeBuilder.doOk();}";
pagemenustr += "{C,取消,javascript:TreeBuilder.doCancel();}";
pagemenustr += "{L,清除,javascript:TreeBuilder.doClear();}";
%>
<div id="pagemenubar" style="z-index:100;"></div>
<%if(!StringHelper.null2String(request.getParameter("browser")).equalsIgnoreCase("0")){%>
<%@ include file="/base/pagemenu.jsp"%>
<%} %>
<table align="center" width="100%"><tr><td>
	<div dojoType="Tree"  widgetId="myTreeWidget" toggler="explor">		
	</div>
</td></tr></table>
</body>
</html>
