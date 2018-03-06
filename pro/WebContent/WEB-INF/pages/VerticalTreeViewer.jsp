<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<%
int nodeWidth=NumberHelper.string2Int(request.getParameter("width"),140);
int nodeHeight=NumberHelper.string2Int(request.getParameter("height"),100);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>Tree example </title>
<style type="text/css">
 v\:* { behavior: url(#default#vml) }
.tree{FONT-SIZE:8pt;}
#treeContainer{border:0px solid red}
.tree ul{margin-top:20px;}
.tree li{list-style-type:none;margin-bottom:20px;margin-left:<%=nodeWidth/3%>px;}
.tree .title{border:2px outset;background-color:#659BF5;}
.tree .node{border:2px outset;background-color:#51B5EE;}
.tree .nodeStyle{position:relative;z-index:100;padding:2px;width:<%=nodeWidth%>px;height:<%=nodeHeight%>px;}
.tree .nodeStyle .nodeName{height:20px;text-align:center;overflow:hidden;}
.tree .nodeStyle .nodeBody{background-color:gainsboro;padding:2px;color:#000000;height:<%=nodeHeight-24%>px;overflow:auto;word-wrap: break-word; word-break: normal;vertical-align:middle;}
.tree .root{/*margin-bottom:40px;margin-left:200px;*/border:2px outset;color:white;background-color:#1397D4;}
.tree .column{float:left;width:100px;margin-right:20px;margin-top:10px;}
.rootLink{text-align:right;padding-right:20px;}
</style>

<script language="javascript" type="text/javascript">
WeaverUtil.isDebug=true;
var level='<c:out value="${level}"/>';
WeaverUtil.load(function(){
	_initDrawTree();
});
var CTree={nodeWidth:<%=nodeWidth%>,nodeHeight:<%=nodeHeight%>,rootLineHeight:40};
function _drawLine(p1,p2){
	var pos1={x:p1.x+20/*CTree.nodeWidth/4*/,y:p1.y+CTree.nodeHeight+8};
	var pos2={x:p2.x,y:p2.y+CTree.nodeHeight/2};
	var line={x:pos2.x-pos1.x,y:pos2.y-pos1.y};

	
	var sStyle='style="position:absolute;z-index:10;left:'+pos1.x+'px;top:'+(pos1.y)+'px;"';
	var lines=new Array(2);
	lines[0]='<v:line '+sStyle+' from="0,0" to="0,'+line.y+'"></v:line>';
	lines[1]='<v:line '+sStyle+' from="0,'+line.y+'" to="'+line.x+','+line.y+'"></v:line>';
	document.body.appendChild(document.createElement(lines[0]));
	document.body.appendChild(document.createElement(lines[1]));
}

function _drawRootLine(p1,p2){
	var pos1={x:p1.x+CTree.nodeWidth/2,y:p1.y+CTree.nodeHeight};
	var pos2={x:p2.x+CTree.nodeWidth/2,y:p2.y};
	
	var line={x:pos2.x-pos1.x,y:pos2.y-pos1.y};
	var sStyle='style="position:absolute;z-index:10;left:'+pos1.x+'px;top:'+(pos1.y)+'px;"';
	var lines=null;
	if(WeaverUtil.isEmpty(document.getElementById('rootLine'))){	
		var cssStyle='style="position:absolute;z-index:10;left:'+(pos1.x+CTree.nodeWidth/2)+'px;top:'+(pos1.y)+'px;"';
		lines='<v:line id="rootLine" '+cssStyle+' from="0,0" to="0,'+CTree.rootLineHeight+'"></v:line>';
		document.body.appendChild(document.createElement(lines));
	}

	lines='<v:line '+sStyle+' from="'+CTree.nodeWidth/2+','+CTree.rootLineHeight+' " to="'+line.x+','+CTree.rootLineHeight+'"></v:line>';
	document.body.appendChild(document.createElement(lines));
	lines='<v:line '+sStyle+' from="'+line.x+','+CTree.rootLineHeight+'" to="'+line.x+','+line.y+'"></v:line>';
	document.body.appendChild(document.createElement(lines));
}

function _initDrawTree(){
	if(!$('treeContainer')){WeaverUtil.log("树视图构造失败！");return;}
	//var nodes=Ext.query('div[@class$=title]');//nodes=document.getElementsByClassName("title");	
	
	/*
	var sumWidth=0;	
	for(var i=0;i<nodes.length;i++){
		var node=nodes[i];
		sumWidth+=node.parentNode.offsetWidth+20;
	}
	
	var maxWidth=screen.width-200;//document.body.scrollWidth;
	if(level=='2' && sumWidth>maxWidth){//只有两级的话，则平行显示两行。
		var n=Math.ceil(sumWidth/maxWidth);//原长度，计算出折行数，用来位移首结点
		sumWidth=maxWidth;
		var numPerLine=Math.floor(maxWidth/(CTree.nodeWidth+20));
		var nodes=$A(document.getElementsByClassName("column"));
		//WeaverUtil.log("nodes.len:"+nodes.length+",lines:"+n+",numPerLine:"+numPerLine);
		for(var i=1;i<n;i++){
			if(numPerLine*i>nodes.length){alert("size:"+numPerLine*i);break;}
			nodes[numPerLine*i].style.marginLeft=10*i+"px";
			//WeaverUtil.log("nodes["+(numPerLine*i)+"]="+10*i);
		}//end for.
	}
	if(sumWidth<=0) sumWidth=maxWidth;
	var rootLeft=Math.ceil((sumWidth-CTree.nodeWidth*2-20)/2);
	if(rootLeft<0){
		rootLeft=maxWidth/3;
		if(nodes.length==1) nodes[0].style.marginLeft=maxWidth/3+CTree.nodeWidth/2+"px";
	}
	$('treeContainer').style.width=sumWidth+"px";
	$('root').style.marginLeft=rootLeft+"px";	
	$('root').style.width=CTree.nodeWidth*2+'px';

	var root=WeaverUtil.getPosition($('root'));
	for(var i=0;i<nodes.length;i++){
		var node=nodes[i];
		pos1=WeaverUtil.getPosition(node);
		_drawRootLine(root,pos1);
	}
	*/
	
	var nodes=Ext.query('div[@class$=node]');//var nodes=document.getElementsByClassName("node");
	var parent=null,pos2=null,pos1=null;
	for(var i=0;i<nodes.length;i++){
		var node=nodes[i];
		parent=$(node.getAttribute("_parentId"));
		
		pos1=WeaverUtil.getPosition(parent);
		pos2=WeaverUtil.getPosition(node);
		_drawLine(pos1,pos2);
	}

}
function onSuperior(pid){//转到根结点的上级结点去
	var url=location.pathname+location.search;
	var newUrl=url.replace(/(rootId=)\w+&/gi,"$1"+pid+"&");
	window.location.href=newUrl;
}
</script>
</head>

<body>
<%
titlename=request.getAttribute("title").toString();//"上下级关系树";
//pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<table align="center" width="100%"><tr><td>
<c:out value="${treeText}" escapeXml="false"/>
</td></tr></table>
</body>
</html>
