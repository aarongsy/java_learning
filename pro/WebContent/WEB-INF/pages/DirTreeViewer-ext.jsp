<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<jsp:directive.page import="com.eweaver.base.treeviewer.model.TreeViewerInfo"/>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%--@ include file="/base/init.jsp"--%>
<%
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
String browser=StringHelper.null2String(request.getParameter("browser"));
String refid = StringHelper.null2String(request.getParameter("refid"));
boolean hiddenFlag = !StringHelper.isEmpty((String)request.getAttribute("hiddenFlag"))
						&& request.getParameter("hiddenFlag").equals("true");	//是否隐藏右边框架页面(不传值或传递其它值视为不隐藏,传值(true)则视为隐藏)
TreeViewerInfo viewer=(TreeViewerInfo)request.getAttribute("treeViewer");
int treeType = viewer.getTreeType();
int viewType=viewer.getViewType();//1为目录树 4为browser框显示
request.setAttribute("treeContextMenu",(viewType==TreeViewerInfo.TREE_VIEW_PAGE));//添加是否有树右击菜单标志
SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
Setitem orgallNameItem=setitemService.getSetitem("11171015F8BC4599A7A68388C93440FD");

//判断是否组织单元树型Browser多选
boolean bOrgTreeBrowserMulti = false;
boolean bOptionMulti = "2".equals(""+viewer.getOptionsObject().get("multi"));
if(viewType==TreeViewerInfo.TREE_VIEW_BROWSER && viewer.getTreeType()==TreeViewerInfo.TREE_TYPE_ORG && bOptionMulti){
	bOrgTreeBrowserMulti = true;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/jquery/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script type="text/javascript" src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script type="text/javascript" src='<%= request.getContextPath()%>/dwr/interface/OrgunitService.js'></script>
<title><c:out value="${title}"/></title>
<style type="text/css">
	.x-grid3-cell-inner img{cursor:pointer;}
	.divTitle{font-size:9pt;}
	.x-tree-node-cb{vertical-align: middle;}
	a:link, a:visited {
		color:#333333;
		font-size:12px;
		text-decoration:none;
	}
	a:hover{
		color:#FF3300;
	}
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
var iconBase = '<%=request.getContextPath()%>/images';
var fckBasePath= '<%=request.getContextPath()%>/fck/';
var contextPath='<%=request.getContextPath()%>';
WeaverUtil.imports(['<%=request.getContextPath()%>/dwr/engine.js','<%=request.getContextPath()%>/dwr/util.js','<%=request.getContextPath()%>/dwr/interface/TreeViewer.js']);
WeaverUtil.isDebug=false;
Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';
function stopBubble(e){//如果提供了事件对象，则这是一个非IE浏览器
	if ( e && e.stopPropagation ) //因此它支持W3C的stopPropagation()方法
		e.stopPropagation();
	else //否则，我们需要使用IE的方式来取消事件冒泡
		window.event.cancelBubble = true;
}

var level='<c:out value="${level}"/>';

var treeDat = {<c:out value="${treeText}" escapeXml="false"/>};
var viewerId='<c:out value="${treeViewer.id}"/>';
var viewerId2=null;//子树的ViewerId

var isFrame=('<%=request.getParameter("iframe")%>'=='true');

var isBrowser=true;
var isMutil=null;
var isSync=false;
var isLeafTree=false;//是否叶子结点可选，默认全部可选
<%
if(request.getParameter("mutil")==null){//如果新的无任何参数，则从树配置信息中读取
	if(viewer.getViewType()==TreeViewerInfo.TREE_VIEW_BROWSER && !StringHelper.isEmpty(viewer.getOptions())){
		out.println("var val="+viewer.getOptions()+";");
		out.println("if(val.multi>0){isMutil=(val.multi==2);isSync=val.sync;isLeafTree=val.leaf;}");
	}
}else{//如果是原先的带有参数传递的
	out.println("isMutil="+(request.getParameter("mutil").equalsIgnoreCase("true"))+";");
	if(request.getParameter("sync")!=null && request.getParameter("sync").equalsIgnoreCase("true"))
		out.println("isSync=true;");
	
	if(request.getParameter("leaf")!=null && request.getParameter("leaf").equalsIgnoreCase("true"))
		out.println("isLeafTree=true;");
}

if(browser.equalsIgnoreCase("")){
	if(viewer.getViewType()!=TreeViewerInfo.TREE_VIEW_BROWSER) out.println("isBrowser=false;");
}else{
	if(!browser.equalsIgnoreCase("0")) out.println("isBrowser=false;");
}
%>
function stripInputTag(s){
	return s.replace(/(<input[^\>]+>[\s|\S]*?<\/asp:[^\>]+>)|(<input[^\>]+\/?>)/gi,'');
}
var subTree='<c:out value="${subTree}"/>';
var optType=<c:out value="${optType}"/>;
var isContextMenu=<c:out value="${not empty treeViewer.menuObject}"/>;
//是否增加树形右击菜单
<c:if test="${treeContextMenu}">
var oMenuInfo={
<c:forEach var="m" items="${treeViewer.menuObject}" varStatus="in">"node<c:out value="${in.index}"/>":"<c:out escapeXml="false" value="${m.value}"/>",</c:forEach>
"null":null};
var oContextMenu=[
<c:forEach var="m" items="${treeViewer.menuObject}" varStatus="in">{id: 'node<c:out value="${in.index}"/>',text:'<c:out value="${m.key}"/>'},</c:forEach>
{}];
oContextMenu.length=oContextMenu.length-1;
</c:if>
var viewType='<c:out value="${treeViewer.viewType}"/>';
//<c:if test="${not empty treeViewer.options}">
var treeOptions=<c:out value="${treeViewer.options}" escapeXml="false"/>;
//</c:if>
//<c:if test="${empty treeViewer.options}">
var treeOptions={};
//</c:if>
var RequestParams=new Object();
RequestParams.__init=function(){//初始Request的请求参数
	var str=document.location.search;
	if(!Ext.isEmpty(str)){
		var names=str.split('&');
		var vals=null;
		for(var i=0;i<names.length;i++){
			vals=names[i].split('=');
			RequestParams[vals[0]]=vals[1];
		}//end.for
	}
};
//<c:if test="${not empty treeViewer.userFun}">
try{
<c:out value="${treeViewer.userFun}" escapeXml="false"/>
}catch(e){
	alert("自定义函数执行异常:"+e.description+"\n"+e.message);
}
//</c:if>

var dialogValue;
var TreeBuilder = {
	buildTreeNodes:function (dataObjs, treeParentNode,nLevel,isGetRoot){//isGetRoot表示先获取根结点
		isGetRoot=(typeof(isGetRoot)!='boolean')?false:isGetRoot;		
 		var obj = null;
		var _title = null;
		var node=null;
		var oCfg=null;
		var disabled=false;
		for(var i=0; i<dataObjs.length;i++){
			obj=dataObjs[i];
			_title = obj.title.trim();
		//if(_title!=''){
			oCfg={text: _title, 
                draggable:false, // disable root node dragging
                id:Ext.id(null,'ID'+obj.id),
                allowDrag:false,
                allowDrop:false,
                sid:''+obj.id,
                expandable:obj.isFolder,
                expanded:obj.expanded,
                leaf:!obj.isFolder
            };
            disabled=(typeof(obj.disabled)=='boolean' && obj.disabled);//标识该结点的输入控件Input是否可用
            
            if(!disabled && isMutil!=null && _title!='' && (!isLeafTree || isLeafTree && !obj.isFolder) ){
                //判断是否对此目录有创建权限
				var m = true;
				<%
				if(viewType==TreeViewerInfo.TREE_VIEW_BROWSER && viewer.getTreeType()==TreeViewerInfo.TREE_TYPE_CATEGORY 
				&&(refid.equals("402883ff3c610d3d013c610d4332004c") || refid.equals("402883ff3c610d3d013c610d4333004d"))){
				%>
			    jQuery.ajax({ 
			        type: 'POST', 
			        url:contextPath+'/app/base/CheckPermissionrOfTree.jsp?categoryid='+obj.id, 
			        async: false, 
			        success: function(res){ 
			           if (res != null) {
			                if(res.toString().startsWith("1")){
                                m = true;
			                }else{
							    m = false;
							}
			            }
			        }, 
			        error: function(XMLHttpRequest, textStatus, errorThrown){ 
			            Ext.Msg.alert('错误, 无法访问后台'); 
			        } 
                }); 
			    <%}%>
                if(isMutil){///(isSync on TreeBuilder.nodeChk(this);
				    if(m){
						//oCfg.checked=(!this.isSyncRequest)?this.isSyncChk:false;
						oCfg.checked = this.isSyncChk;
						if(treeParentNode!=null&&treeParentNode.attributes.checked!=null){
							oCfg.checked = treeParentNode.attributes.checked;
						}
						if(typeof(SelectedItems)!='undefined' && SelectedItems.isExistById(obj.id)){
						  oCfg.checked=true;
						}
						if(typeof(SelectedItems)!='undefined' && !SelectedItems.isExistById(obj.id)){
						  oCfg.checked=false;
						}
					}
				}else {
				    if(m){ 
				        oCfg.text='<input onclick="return TreeBuilder.radioCheck(this);" type="radio" name="radio1" nid="'+oCfg.id+'" value="'+obj.id+'"/>&nbsp;'+oCfg.text;
				    }
				}
			}
			node = new Ext.tree.TreeNode(oCfg);
            node.object=obj;
            <% 
            	if(5!=treeType){
            		%>
            if(this.isSyncRequest) node.LOADED=true;
            		<%
            	}
            %>
	//=========================================================================================		
			if(typeof(obj.subTree)!='undefined') node['subTree']=true;//设置子树标记
			if(treeParentNode!=null)
				treeParentNode.appendChild(node);
			else{
				this.root=node;
				if(isGetRoot)return node;
			}
			/*
			if(nLevel>0 && obj.isFolder){
				node.isExpanded=false;
				node.updateExpandIcon();
			}
			*/
		//}//End If.
			if(obj.children){
				node.LOADED=true;
				if(treeParentNode!=null){
					this.buildTreeNodes(obj.children,node,nLevel+1);
				}
				else this.buildTreeNodes(obj.children,this.root,nLevel+1);
			}
		}
	},
	loadSubTree:function(objData,node){//加载子树事件
		var keyId=node.attributes.sid;//node.id.substring(2);
		var _this=this;
		var subTree=objData.subTree;
		var OTree=subTree.split(":");
		if(OTree.length!=2){
			alert('subTree condition invalid!');return;
		}
		var viewerId=OTree[0];
		//viewerId2=viewerId;//记录子树的viewerId
		var rootId="";
		var iLevel=(_this.isSyncRequest)?99:2;
		var params='{"'+OTree[1].toLowerCase()+'":"'+keyId+'","isfrist":"'+1+'"}';//传递给子树的树条件参数
		TreeViewer.getTreeChildren(viewerId,rootId,iLevel,params,function(data){
			try{
				_this.buildTreeNodes(data[0].children,node,1);
				
			}catch(e){/*alert('Error:'+e.description);*/}
			if(_this.isSyncRequest) _this.isSyncRequest=false;
			node.ui.removeClass("x-tree-node-loading");//node.unMarkLoading();
			node.LOADED=true;
		});
	},
	paramOptions:{},//根据viewerId存在每一棵树的结点路径参数的选项.{pathParam:0|1|2,pathParams:[name1,naem2,naem3,...]}
	addParamsOptions:function(vid){
		var p=this.paramOptions[vid];//一个vid对即级联中的一棵树的ID
		if(Ext.isEmpty(p)){//first get params,retrive dwrObject
			if(viewerId==vid){//MainTree.ParamsOptions
				p={"pathParam":treeOptions.pathParam,"pathParams":treeOptions.pathParams};
			}else{
				var _callback=function(d){p=d;};
				DWREngine.setAsync(false);//设置ＤＷＲ为同步获取数据
				TreeViewer.getParamsOptionsByViewId(vid,_callback);//
				DWREngine.setAsync(true);
			}//end if.
			//alert('ln:188,获取PathParams:('+vid+')'+Ext.encode(p));
			this.paramOptions[vid]=p;
		}
	},
	getPathParam:function(node){//根据当前所在结点,得到该结点对应的路径参数对象(包括子树的处理),如果返回null表示非路径或叶子结点传参数
		var _treeValues={},_treeVal=[];
		var treeId=null;
		var hasSubTree=null;
		var nid=null;
		//alert('getPath:'+node.getPath());
		while(node!=null && typeof(node)!='undefined' && node.id!='ID'){//从树的当前结点往前回归
			nid='ID'+node.attributes.sid;//node.id;
			hasSubTree=(typeof(node.subTree)=='boolean' && node.subTree);
			if(hasSubTree || node.isLeaf()) nid=nid.substring(2)//该判断标识nid是否为叶子结点
			_treeVal.push(nid);
			if(hasSubTree){
				treeId=node.object.subTree.split(":")[0];//得到当前结点所在的subTree.rootId
				this.addParamsOptions(treeId);//从服务器端获取该SubTree的ParamsOptions设置
				if(_treeVal.length>1)_treeVal.length=_treeVal.length-1;//去掉最后一次放到子树中.
				_treeValues[treeId]=_treeVal;
				_treeVal=new Array(nid);//把最近的一个结点加入到最新的subTree中.
			}
			node=node.parentNode;
		}//end while.
		_treeValues[viewerId]=_treeVal;
		this.addParamsOptions(viewerId);//处理最上级的主树
		//alert('_treeValues:\n\n:'+Ext.encode(_treeValues));
		var strParams="";
		var options=null,len=0;
		for(var vid in _treeValues){
			options=this.paramOptions[vid];
			//alert(Ext.encode(options));
			if(options.pathParam=='0'){
				continue;
			}
			_treeVal=_treeValues[vid];
			len=_treeVal.length-1;
			for(var i=len,j=0;i>=0;i--,j++){
				nid=_treeVal[i];
				if(options.pathParam=='1' && !nid.startsWith('ID')){//不等于ID开头表示叶子结点
					strParams+="&"+options.pathParams[0]+"="+nid;
					break;//如果是取叶子结点传参数,则获取后立即返回处理另一棵树
				}else if(options.pathParam=='2'){
					if(nid.startsWith('ID')) nid=nid.substring(2);
					strParams+="&"+options.pathParams[j]+"="+nid;
				}
			}//end for.
		}
		//alert(strParams);
		
		delete _treeVal;
		delete _treeValues;		
		//alert(Ext.encode(_treeValues)+"\n\n"+Ext.encode(this.paramOptions));
		return strParams;
	},
	isSubTreeNode:function(node){//由于有可能多级子树，判断当前结点是否子树结点时还必须确认当前是那一级的子树以便得到ID来获取数据
		var isSubTree=null;
		while(node!=null && typeof(node)!='undefined'){
			if(typeof(node.subTree)=='boolean' && node.subTree){
				isSubTree=node.object.subTree.split(":")[0];//得到当前结点所在的subTree.rootId
				break;
			}
			node=node.parentNode;
		}
		return isSubTree;
	},
	tree:null,
	root:null,
    scrollTask:null,
    container:null,
	getRoot:function(){
		
	},
	buildTree:function (){
        // set the root node
		if($('orgTypeId')) $('orgTypeId').disabled=false;
		if($('switchTree')) $('switchTree').disabled=false;
        var blRoot=true;
        if(typeof(treeDat.treeNodes[0])!='undefined' && Ext.util.Format.stripTags(treeDat.treeNodes[0].title)=='')
        	blRoot=false;
		this.tree = new Ext.tree.TreePanel({
            el:'treeDiv',
			/*useArrows:true,*/
			animate:false,
			border:false,
			autoScroll:true,
			//width:document.body.clientWidth,
			height:document.body.clientHeight-47,
			rootVisible:blRoot,//(this.root.text=='')?false:true,
			enableDD:false
			<c:if test="${not empty treeViewer.menuObject and treeContextMenu}">
			,contextMenu: new Ext.menu.Menu({
				items: oContextMenu,
				listeners:{itemclick:function(item){
						var n = item.parentMenu.contextNode;
						var url=oMenuInfo[item.getId()];
						var id=n.attributes.sid;//n.id.substring(2);
						url=url.replace("${nodeId}",id);
						var oIframe=Ext.getDom('treeIframe');
						if(oIframe) oIframe.src=url;
					}//end fun.
				}//end listeners.
			})//end Menu.
			</c:if>
        });
        this.buildTreeNodes(treeDat.treeNodes,null,0);//构造子树
		this.root.LOADED=true;
		this.tree.setRootNode(this.root);//设置树根结点
		this.tree.render();
		this._listenObject();
		//this.root.expand(true, /*no anim*/true);
       // this.scrollTask=new Ext.util.DelayedTask(this.scrolltoTop);
        this.container=Ext.DomQuery.selectNode( '#treeDiv .x-panel-body');
	},
    scrolltoTop:function(){
       // this.container.scrollTop=10000;
    },
	_listenObject:function(){
		var _this=this;
				this.tree.addListener("expandnode",function(node){
		            if(!_this.scrollTask)
		            	_this.scrollTask=new Ext.util.DelayedTask(_this.scrolltoTop);
		            _this.scrollTask.delay(200,null,_this);
					if(!node.object.isFolder) return;
					if( typeof(node.LOADED)!='boolean' ){
						node.ui.addClass("x-tree-node-loading");//node.markLoading();
						//这里判断是否子树结点事件触发
						var objData=node.object;
						if(subTree!='' && typeof(objData.subTree)!='undefined'){
							_this.loadSubTree(objData,node);//加载子树_loadSubTree(objData,node)
							return;
						}//end if.
						//var rootId=""+node.getInfo().widgetId.substring(2);
						var rootId=objData.id;
						var iLevel=2;
						if(_this.isSyncRequest) iLevel=99;
						viewerId2=_this.isSubTreeNode(node);//确定是否子树结点并返回其子树的ViewId
						var vid=WeaverUtil.isEmpty(viewerId2)?viewerId:viewerId2;//判断是否子树内的结点，是则变换树ID为ViewerId
						var jsonParams=new Object();
						var objSel=$('orgTypeId');//组织维度选择框
						if(!WeaverUtil.isEmpty(objSel)){
							jsonParams.orgTypeId=DWRUtil.getValue('orgTypeId');
						}else if(optType>0) jsonParams.optType=optType;
						TreeViewer.getTreeChildren(vid,rootId,iLevel,Ext.encode(jsonParams),function(data){
							try{
								_this.buildTreeNodes(data[0].children,node,1);
							}catch(e){alert('Error:'+e.description);}
							if(_this.isSyncRequest) _this.isSyncRequest=false;
							node.ui.removeClass("x-tree-node-loading");//node.unMarkLoading();
							if(isMutil&&isSync&&node.nodechkfun){
								_this.nodeChk(node,true);
							}
						});
						node.LOADED=true;//"LOADED";
					}//end if.not loaded!
				});//end subscribe.
		
		/********************************************/
		this.tree.addListener("checkchange",function(node, blChecked){
			if(isMutil && isSync) _this.nodeChk(node,blChecked);
			if(typeof(SelectedItems)!='undefined'){
				if(blChecked){
					SelectedItems.addRow(node.object.id,stripInputTag(node.text),node.object.id);
				}else{
					SelectedItems.removeRow(node.object.id);
				}
			}//end if.
		});
		/*
		this.tree.addListener("beforeclick",function(node,e){
			if(e.getTarget().tagName=='INPUT'){
				e.stopEvent();
				e.getTarget().checked=false;
				return false;
			}
		});
		*/
		this.tree.addListener("click",function(node,e){//function(o,e)
			////////////////////////////
			var src=e.getTarget();
			if(src.tagName=="A"){
				var sUrl=src.href;
				var oIframe=Ext.getDom('treeIframe');
              if(viewType!=4){ //为browser框不执行此代码
				if(sUrl.startsWith("javascript:")){
					eval(sUrl.substring("javascript:".length));
				}else if(oIframe){
					var params=_this.getPathParam(node);
					if(!Ext.isEmpty(params)){
						if(sUrl.indexOf('?')>0)sUrl+=params;
						else sUrl+='?null=null'+params;
						//alert('url:'+sUrl);
					}//end if.
					if(sUrl!=''){
						oIframe.src=sUrl;
					}
	
				}else window.open(sUrl);
               }
				return false;
			}
			
			var btns=node.ui.getEl().getElementsByTagName("input");
			if(btns!=null && btns.length>0 && btns[0].type=='radio'){
				btns[0].checked=true;
				if(!node.object.isFolder) _this.doOk();
				return false;
			}
			if(isMutil && node.ui.checkbox){
				var blChk=!node.ui.isChecked();
				node.ui.toggleCheck(blChk);
				node.attributes.checked=blChk;//这是Bug,默认应该上一句就够了
				node.fireEvent("checkchange",node,blChk);
			}
			return false;
		});
		<c:if test="${not empty treeViewer.menuObject and treeContextMenu}">
		//注册右击事件
		this.tree.addListener("contextmenu",function(node,e){
			node.select();
		    var c = node.getOwnerTree().contextMenu;
	    	c.contextNode = node;
	        c.showAt(e.getXY());
		});
		</c:if>
	},
	isSyncRequest:false,//是否异步获取所有数据
	isSyncChk:false,//是否选中下级
	nodeChk:function(node,blChk){
		//var id=o.value;
		
		//var node=this.tree.getNodeById("ID"+id);
		if(typeof(node.LOADED)!='boolean'){
			this.isSyncChk=blChk;//o.checked;
			this.isSyncRequest=true;
			node.nodechkfun=true;
			node.expand(node);
		}else{
			node.expand(node);
			this.doChildChk(node,blChk);
			/*
			var pObj=o.parentNode.parentNode.parentNode;
			var nodes=pObj.getElementsByTagName("input");
			var obj=null;
			for(var i=0;i<nodes.length;i++){
				obj=nodes[i];
				if(obj.type=="checkbox") obj.checked=o.checked;
			}//end for.
			if(!node.isExpanded)node.expand(node);
			*/
		}
	},
	doChildChk:function(node,blChk){
		blChk = node.attributes.checked;
		var nodes=node.childNodes;
		if(typeof(nodes)=='undefined' || typeof(nodes.length)=='undefined')return;
		var sizes=nodes.length;
		for(var i=0;i<sizes;i++){
			nodes[i].ui.toggleCheck(blChk);
			nodes[i].attributes.checked = blChk;
			if(typeof(SelectedItems)!='undefined'){
				if(blChk) SelectedItems.addRow(nodes[i].object.id,Ext.util.Format.stripTags(nodes[i].text),nodes[i].object.id);
				else SelectedItems.removeRow(nodes[i].object.id);				
			}//end if.
			this.nodeChk(nodes[i],blChk);
			//this.doChildChk(nodes[i],blChk);
		}
	},
	doOk:function(){
		var ids="";
		var names="";
		if(isMutil){
			if(typeof(SelectedItems)=='undefined'){
				var nodes=this.tree.getChecked();
				if(nodes.length<=0){
					alert('请选择一项再确定！');
					return;
				}//end if.
				
				if(viewerId=='402880321d600142011d602857ee0004'&&'<%=orgallNameItem.getItemvalue()%>'=='1'){//是组织单元多选browser框需要显示路径
					DWREngine.setAsync(false);
					for(var i=0;i<nodes.length;i++){
						var node=nodes[i];
						var nodesid = node.attributes.sid;//node.id.substring(2);
						var nodetext = stripInputTag(node.text);//Ext.util.Format.stripTags(node.text);
						ids+=","+nodesid;//node.id.substring(2);
						
						OrgunitService.getOrgunitPathExceptRoot(nodesid,function(d){
							var nodeNames=d.split('/');
				    		var len=nodeNames.length;
				    		if(len>0){
					    		var nodeName=nodeNames[len-1];
					    		nodetext=names.ReplaceAll(nodeName,d);
				    		}
						});
						names+=","+nodetext;//Ext.util.Format.stripTags(node.text);
				    }
				    DWREngine.setAsync(true);
				}else{
				    for(var i=0;i<nodes.length;i++){
						var node=nodes[i];
						ids+=","+node.attributes.sid;//node.id.substring(2);
						names+=","+stripInputTag(node.text);//Ext.util.Format.stripTags(node.text);
					}
				}
				ids=ids.substring(1);
				names=names.substring(1);
			}else{
				var ar0=SelectedItems.getRowsValue();
				if(Ext.isEmpty(ar0[0])){
					alert('请选择一项再确定！');
					return ;
				}
				ids=ar0[0];
				names=ar0[1];
			}//end if.
		}else{
			//var selNode=this.tree.getSelectionModel().getSelectedNode();
			var id=null;
			var btns=document.getElementById("treeDiv").getElementsByTagName("input");//name=radio1
			var sizes=btns.length;
			var sid='';
			for(var i=0;i<sizes;i++){
				if(btns[i].checked){
					id=btns[i].value;
					sid=btns[i].getAttribute('nid');
					break;
				}
			}
			if(id!=null){
				var selNode=this.tree.getNodeById(sid);
				names=stripInputTag(selNode.text);//Ext.util.Format.stripTags(selNode.text);
				ids=id;
				//alert(viewerId);
				if(viewerId=='4028bc5c1c1ed58a011c20fd70590fa2'){//是组织单元单选browser框需要显示路径
				  if('<%=orgallNameItem.getItemvalue()%>'=='1'){
			        DWREngine.setAsync(false);
			    	OrgunitService.getOrgunitPathExceptRoot(id,function(d){
			    		var nodeNames=d.split('/');
			    		var len=nodeNames.length;
			    		if(len>0){
				    		var nodeName=nodeNames[len-1];
				    		names=names.ReplaceAll(nodeName,d);
			    		}
					});
				    DWREngine.setAsync(true);
				  }
				}
			}//end　id not null.
			if(Ext.isEmpty(ids)){
				alert('请选择一项再确定！');
				return ;
			}
		}
		//alert(JSON.stringify(ids)+"-->>>"+JSON.stringify(names));
		//return;
        if(!Ext.isSafari)
		GetVBArray(ids,names,isFrame);
        else{
            if(isFrame){
        parent.dialogValue=[ids,names];
        parent.parent.win.close();
            }else{
        dialogValue=[ids,names];
        parent.win.close();    
            }
        }
		this.doCancel();
	},
	doCancel:function(){
		if(!Ext.isSafari)
		this.pWin.close();
        else{
            if(isFrame){
        parent.parent.win.close();
            }else{
        parent.win.close();
            }
        }
	},
	doClear:function(){
		if(!Ext.isSafari)
		GetVBArray('0','',isFrame);
        else{
            if(isFrame){
        parent.dialogValue=['0',''];
        parent.parent.win.close();
            }else{
        dialogValue=['0',''];
        parent.win.close();
            }
        }
		this.doCancel();
	},
	pWin:(isFrame)?window.parent.parent:window.parent,
	chgOrgType:function(obj){
		var orgTypeId=obj.options[obj.selectedIndex].value;
		var url=location.pathname+location.search;
		var newUrl=url;
		if(url.indexOf('orgTypeId=')>0){
			newUrl=url.replace(/(orgTypeId=)\w+(&?)/gi,"$1"+orgTypeId+"$2");
		}else{
			newUrl=url+"&orgTypeId="+orgTypeId;
		}
		//alert('URL:'+newUrl);
		window.location.href=newUrl;
	},
	chgTree:function(obj){
		if(typeof(mainTree)=='undefined')return;
		var viewId=obj.options[obj.selectedIndex].value;
		var url=location.pathname+location.search;
		var newUrl=url;
		if(url.indexOf('mainTree=')>0){
			newUrl=url.replace(/(mainTree=)\w+(&?)/gi,"$1"+mainTree+"$2");
		}else{
			newUrl=url+"&mainTree="+mainTree;
		}
		newUrl=newUrl.replace(/(viewerId=)\w+(&?)/gi,"$1"+viewId+"$2");
		
		window.location.href=newUrl;
	},
	radioCheck:function(obj,e){
		e=event || e;
		stopBubble(e);
		return true;
	}
}
//<c:if test="${not empty switchTreeList}">
var mainTree='<c:out value="${mainTree}"/>';
//</c:if>
Ext.EventManager.onWindowResize(function(){
	if(TreeBuilder.tree)
	{
		if(!isBrowser){
			TreeBuilder.tree.setHeight(document.body.clientHeight-5);
		}
		}
});

<% if( viewer.getViewType()==TreeViewerInfo.TREE_VIEW_BROWSER && !StringHelper.isEmpty(request.getParameter("selected")) && bOptionMulti || bOrgTreeBrowserMulti){%>
    var myData =<c:out value="${selectedData}"  escapeXml="false"/>;

var SelectedItems={
	store:new Ext.data.SimpleStore(
		{fields: [{name: 'title'},{name: 'opt'},{name: 'value'}],
        data:myData,id:3}
    ),
    isExistById:function(id){
    	var rec=this.store.getById(id);
		return !Ext.isEmpty(rec);
    },
	addRow:function(id,title,value){
		var rec=this.store.getById(id);
		if(Ext.isEmpty(rec)){
			rec=new Ext.data.Record({title:title,value:value,opt:"<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif'/>"},id);
			this.store.add([rec]);
		}
	},
	removeRow:function(id){
		var rec=this.store.getById(id);
		if(!Ext.isEmpty(rec))
			this.store.remove(rec);
	},
	getRowsValue:function(){
		var nums = this.store.getCount();
		var ids=[],names=[],rec=null;
		for(var i=0;i<nums;i++){
			rec=this.store.getAt(i);
			ids[i]=rec.get("value");
			names[i]=rec.get("title");
			if(viewerId=='402880321d600142011d602857ee0004'&&'<%=orgallNameItem.getItemvalue()%>'=='1'){//是组织单元多选browser框需要显示路径
				DWREngine.setAsync(false);
				var nodesid = ids[i];//node.id.substring(2);
				var nodetext = names[i];//Ext.util.Format.stripTags(node.text);
				
				OrgunitService.getOrgunitPathExceptRoot(nodesid,function(d){
					var nodeNames=d.split('/');
		    		var len=nodeNames.length;
		    		if(len>0){
			    		var nodeName=nodeNames[len-1];
			    		nodetext=nodetext.ReplaceAll(nodeName,d);
			    		names[i]=nodetext;
		    		}
				});
			    DWREngine.setAsync(true);
			}
		}
		return [ids.join(','),names.join(',')];
	},
	grid:null,
	init:function(){
		this.grid.render('selectedItemsDiv');
		//this.grid.getView().getHeaderCell(0).click();//在Browser框中需要单击标题排序才会出现滚动条	
		var selectedGrid = this.grid;
		var selectedStore = this.store;
		var selectedGridDropTargetEl =  selectedGrid.getView().el.dom.childNodes[0].childNodes[1];
        var selectedGridDropTarget = new Ext.dd.DropTarget(selectedGridDropTargetEl, {
    		ddGroup    : 'selectedGridDDGroup',
    		copy       : false,
    		notifyDrop : function(ddSource, e, data){
        	var targetEl = e.getTarget();
        	var rowIndex = selectedGrid.getView().findRowIndex(targetEl);
        	if(typeof(rowIndex)=='boolean')
        		return false;              
        	selectedStore.remove(ddSource.dragData.selections[0]);
       		selectedStore.insert(rowIndex, ddSource.dragData.selections[0]);
        	return true;
    	},
    	notifyEnter:function(ddSource, e, data){
        	var proxy = ddSource.getProxy();
        	proxy.update(ddSource.dragData.selections[0].get('title'));
    	}
});
	}
};
SelectedItems.grid=new Ext.grid.GridPanel({
        store:SelectedItems.store,
        columns: [
            {id:'title',header: "名称", width: 269, sortable: <%=bOrgTreeBrowserMulti?false:true%>, dataIndex: 'title'},
            {header: "<a href='javascript:void(0);' onclick='clearSelectedItem()' >清空</a>", width: 35, dataIndex: 'opt'}
        ],
        listeners:{
        	"cellclick":function(grid,rowIndex,columnIndex,e){
        		if(columnIndex!=1)return;
        		var record = grid.getStore().getAt(rowIndex);
        		var tree_nodeid = "ID"+record.get("value");
	        	var node=TreeBuilder.tree.getNodeById(tree_nodeid);
	        	if(!Ext.isEmpty(node)){
	        		node.ui.toggleCheck(false);
	        	}else{
	        		var nodes=TreeBuilder.tree.getChecked();
					for(var i=0;i<nodes.length;i++){
						if(nodes[i].id.indexOf(tree_nodeid)==0){
							nodes[i].ui.toggleCheck(false);
							break;
						}
					}
	        	}
	        	SelectedItems.store.remove(record);
        	}
        },
        ddGroup: 'selectedGridDDGroup',
		ddText:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050007")%>',//拖动
		enableDragDrop: true,
    	stripeRows: true,
        trackMouseOver:false,
        enableColumnHide:false,
		enableHdMenu:false,
		collapseMode:'mini',
        height:473,
        width:325,
        title:'已选择:'/*,
		bbar:[{
        	text: '清空',
			handler : function(){
				SelectedItems.store.removeAll();
				var nodes=TreeBuilder.tree.getChecked();
				for(var i=0;i<nodes.length;i++)
					nodes[i].ui.toggleCheck(false);
			}
		}]*/
    });
<%}%>

function clearSelectedItem(){
	SelectedItems.store.removeAll();
	var nodes=TreeBuilder.tree.getChecked();
	for(var i=0;i<nodes.length;i++){
		nodes[i].ui.toggleCheck(false);
	}
}

var FramePanel={
id:'framePanel',
init:function(){

var leftFrameCfg={
		region:'west',
		margins:'0 0 0 0',
		width:450,
		autoScroll:false,
		collapsible: true,
		collapseMode:'mini',
		split:true,
		minSize: 100,
		//maxSize: 400,
		contentEl:'leftFrame',
		header:false,
		layout:'accordion',
		layoutConfig: {fill:true},
		title: 'Navigation',
		cls:'empty'
	};
var rightFrameCfg;

<% if(viewer.getViewType()==TreeViewerInfo.TREE_VIEW_PAGE){%>
rightFrameCfg={
				region:'center',
                margins:'0 0 0 0',
                hidden:false,
                xtype     :'iframepanel',
                frameConfig: {
                id:'treeIframe',
                name:'treeIframe'
                }
                
            };
<%}else{%>
rightFrameCfg={
				region:'center',
                margins:'0 0 0 0',
                hidden:false,
                cls:'empty',
                bodyStyle:'background:#f1f1f1',
                contentEl:'rightFrame'
            };
<%}%>


var items=[];
if(((isMutil && typeof(SelectedItems)!='undefined') || viewType=='5' || <%=bOrgTreeBrowserMulti%> ) && <%=!hiddenFlag%>){//需要右边框架	
	items=[new Ext.Panel(leftFrameCfg),rightFrameCfg];
}else{//不需要右框架
	//alert('del rightFrame.');
	rightFrameCfg.hidden=true;
	leftFrameCfg.split=false;
	leftFrameCfg.width='100%';
	leftFrameCfg.region='center';
	delete leftFrameCfg.minSize;
	delete leftFrameCfg.maxSize;
	items=[new Ext.Panel(leftFrameCfg)];
}

var viewport = new Ext.Viewport({layout:'border',items:items});

},
topBar:null,
initToolbar:function(){
	this.topBar = new Ext.Toolbar();
	this.topBar.render('pagemenubar');
	addBtn(this.topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','O','accept',function(b){TreeBuilder.doOk();});//确定
	addBtn(this.topBar,'<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")%>','B','arrow_redo',function(b){TreeBuilder.doCancel();});//返回
	addBtn(this.topBar,'<%=labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")%>','C','cancel',function(b){TreeBuilder.doClear();});//清除
}
};

//Ext.EventManager.onDocumentReady(TreeBuilder.buildTree, TreeBuilder, true);
WeaverUtil.load(function(){//为防止TreePanel的this.el.dom为null的Bug
	FramePanel.init();
	if(viewType==4) FramePanel.initToolbar();//Browser时才初始化工具栏按钮
	if(isMutil && typeof(SelectedItems)!='undefined') SelectedItems.init();
	window.setTimeout(function(){TreeBuilder.buildTree();
	if(!isBrowser){
		TreeBuilder.tree.setHeight(document.body.clientHeight-5);
	}
	},300);
	RequestParams.__init();
});
</script>
</head>
<body>
<%--
titlename=request.getAttribute("title").toString();//"上下级关系树";
pagemenustr += "{O,确定,javascript:TreeBuilder.doOk();}";
pagemenustr += "{C,取消,javascript:TreeBuilder.doCancel();}";
pagemenustr += "{L,清除,javascript:TreeBuilder.doClear();}";
--%>
<div id="leftFrame" >
<div id="pagemenubar" style="z-index:100;"></div>
<c:if test="${not empty switchTreeList}">
<span class="divTitle">&nbsp;&nbsp;浏览导航
<select id="switchTree" style="width:180px" disabled="disabled" onChange="TreeBuilder.chgTree(this);">
<c:forEach var="m" items="${switchTreeList}">
	<option <c:if test="${treeViewer.id==m.key}">selected="selected"</c:if> value='<c:out value="${m.key}"/>' ><c:out value="${m.value}"/></option>
</c:forEach>
</select></span><br/>
</c:if>
<c:if test="${(not empty orgTypeMap)&&(showtype!='false')}">
<span class="divTitle">&nbsp;&nbsp;组织维度
<select id="orgTypeId" style="width:180px" disabled="disabled" onChange="TreeBuilder.chgOrgType(this);">
<c:forEach var="m" items="${orgTypeMap}">
	<option <c:if test="${orgTypeId==m.key}">selected="selected"</c:if> value='<c:out value="${m.key}"/>' ><c:out value="${m.value}"/></option>
</c:forEach>
</select></span><br/>
</c:if>
<div id="treeDiv" style="width:100%;height:100;"></div>
</div>
<% if( viewer.getViewType()==TreeViewerInfo.TREE_VIEW_BROWSER && (bOrgTreeBrowserMulti || !StringHelper.isEmpty(request.getParameter("selected"))) ){%>
<div id="rightFrame">
<div id="selectedItemsDiv"></div>

</div>
<%}%>
</body>
</html>
