<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%
String resourceids=StringHelper.null2String(request.getParameter("resourceids"));
String returntype = StringHelper.null2String(request.getParameter("returntype"));
    //页面传过来的自定义组id
String initgroupid=StringHelper.null2String(request.getParameter("groupid"));
String coworkid=StringHelper.null2String(request.getParameter("coworkid"));
String workID = StringHelper.null2String(request.getParameter("workID"));
String cowtypeid = StringHelper.null2String(request.getParameter("cowtypeid"));
String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));
String status=StringHelper.null2String(request.getParameter("status"));
   
String tabid="0";
if(StringHelper.isEmpty(returntype)) {
	returntype = "2";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<% 
String objtype = request.getParameter("objtype");
String objid = request.getParameter("objid");
%>
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
  <title>资源树形列表</title>
   <link href="/mobile/plugin/browser/css/Weaver.css" rel="stylesheet" type="text/css" >
    <script type="text/javascript" src="/mobile/plugin/js/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/js/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="/mobile/plugin/js/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<script type="text/javascript" src="/mobile/plugin/js/jquery/plugin/zTree/js/jquery.ztree.excheck.min.js"></script>
	<style>
	  .ztree span{word-break:break-all;}
	</style>
  </head>
	<BODY style="overflow-y: hidden;padding: 0px;margin: 0px;">
    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow style="width: 100%">
                    <tr>
                        <td  valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="CategoryBrowser.jsp" method=post>
							<input class=inputstyle type=hidden name=id value="<%=objid%>">
							<input class=inputstyle type=hidden name=type value="<%=objtype%>">
                                <div style="height: 430px;">
                                <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;TABLE-LAYOUT:fixed;word-break:break-all" width="100%">     
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD height=430 colspan="4" width="500" nowrap="nowrap">                                            
                                                <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
	                                            	<ul id="tree" class="ztree"></ul>
	                                            </div>                                             
                                          </TD>
                                      </TR>                                    
                                </TABLE>
                                </div>
                                <div style="height: 40px;padding-top: 25px;" align="center">
                                    <BUTTON type="button" class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-保存</BUTTON>
	                                <BUTTON type="button" class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-清除</BUTTON>
                                    <BUTTON type="button" class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-关闭</BUTTON>
                                </div>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
    </table>
  <script type="text/javascript">  
  var selectallflag=true;
	var isremember = "";
	var selectedids = "";
	var cxtree_id = "";
	var cxtree_ids;
	if(selectedids!="0"&&selectedids!=""){
		cxtree_id = "";
		cxtree_ids = cxtree_id.split(',');
		cxtree_id = cxtree_ids[0];
	} 
  var zTree;
  var objtype = '<%=StringHelper.null2String(resourceids)%>';
  var objid = '<%=StringHelper.null2String(objid)%>';
  var returntype = '<%=returntype%>';
  var action = '';
  if(objtype == 2) {
      action = 'getHrmTree';
  } else if(objtype == 1) {
      action = 'getOrgTree';
  } else if(objtype == 3) {
      action = 'getDocDirTree';
  } else if(objtype == 4) {
      action = 'getWfTree';
  }
  /**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时		
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/ServiceAction/com.eweaver.mobile.plugin.servlet.ResourceBorwserAction?action="+action+"&id=" + treeNode.id + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/ServiceAction/com.eweaver.mobile.plugin.servlet.ResourceBorwserAction?action="+action+"&"+ new Date().getTime() + "=" + new Date().getTime();
	    }
	};
  var setting = {
  			async: {
				enable: true,
				url:getAsyncUrl,
				autoParam:["id", "name=n", "level=lv"],
				dataFilter: filter
			},	
			check: {
			enable: true,       //启用checkbox或者radio
			chkStyle: "checkbox",  //check类型为checkbox
			chkboxType: { "Y":"", "N": ""} 
		},
		view: {
			expandSpeed: ""     //效果
		},		
			callback: {
				onCheck: zTreeOnCheck,
				onClick: zTreeOnClick,   //节点点击事件
				onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			}
			
		};
		function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    //alert(treeNode.isParent);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	};
		function filter(treeId, parentNode, childNodes) {
			if (!childNodes) return null;
			for (var i=0, l=childNodes.length; i<l; i++) {
				childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
			}
			return childNodes;
		}
		
	 function zTreeOnChange(event, treeId, treeNode){
	 	//window.returnValue={treeNode.id,treeNode.name};
	 	//if(treeNode.checked == true) {
	 	//	if(confirm('将要创建' + treeNode.name + '类型接口')) {
	 	//		window.location.href='/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=direct&objtype='+objtype+'&objid='+objid+'&pid=' + treeNode.id;	
	 	//	}
	 	//}	
	 }
 
  	var treeNodes = [];
  	$(document).ready(function(){
		$.fn.zTree.init($("#tree"), setting);
	});
  	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
        
        //var rootnodes = treeObj.getNodesByParamFuzzy("type", "1", null);
        //setIsExistsCheckbox(treeObj, rootnodes, true);
        
	    if (selectallflag) {
	    	 if (treeNode != undefined && treeNode != null) {
	 		    if (treeNode.checked) {
	 			    var childrenNodes = treeNode.childs;
	 		    	for (var i=0; i<childrenNodes.length; i++) {
	 		    		treeObj.checkNode(childrenNodes[i], true, false);
	 				}
	 		    }
	 	    }
	    }
		var node = null;
		
	    if (cxtree_ids != undefined && cxtree_ids != null) {
		    for (var z=0; z<cxtree_ids.length; z++) {
				node = treeObj.getNodeByParam("id", "secField_" + cxtree_ids[z], null);
			    if (node != undefined && node != null ) {
			    	treeObj.selectNode(node);
			    	treeObj.checkNode(node, true, false);
			    }
		    }
		}
	}
	
	function onSaveJavaScript(){
	    var nameStr="";
	    var idStr = "";
	    var treeObj = $.fn.zTree.getZTreeObj("tree");
		var nodes = treeObj.getCheckedNodes(true);	
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}		
		//alert(nodes.length);
		
		for (var i=0; i<nodes.length; i++) {		    
			if (nodes[i].type==objtype) {		
			    if(i == 0) {
			    	nameStr +=  nodes[i].id;
			    	idStr +=  nodes[i].name;
			    } else {
			    	nameStr += "," + nodes[i].id;
					idStr += "," + nodes[i].name;
			    }				
			}
		}

		//alert('OK');
		resultStr = nameStr + "$" + idStr;
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    //alert(trunStr);
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			if(returntype == 2) {
				var returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
	        	window.parent.returnValue  = returnjson;
			} else if(returntype ==1) {
				var returnjson = returnVBArray[0];
	        	window.parent.returnValue  = returnjson;
			}
	        window.parent.close();
	    } else {
	        window.parent.close();     
		}
    }
    
    function onClear() {
    		if(returntype == 2) {
				var returnjson = {id:"", name:""};
	        	window.parent.returnValue  = returnjson;
			} else if(returntype ==1) {
				var returnjson = "";
	        	window.parent.returnValue  = returnjson;
			}
	    window.parent.close();
	}
	
	function needSelectAll(flag, obj){
		selectallflag = flag;
	   
	   	var treeObj = $.fn.zTree.getZTreeObj("tree");
	   	var type = { "Y":"", "N": ""};
	   	if(selectallflag){
	   		type = { "Y":"s", "N": "s"};
	   	}
	   	treeObj.setting.check.chkboxType = type;
	   	var i = $(obj).html().indexOf('>');
	   	if(selectallflag){
	        a = $(obj).html().substring(0,i+1)+'全选';
	    } else{
	    	a = $(obj).html().substring(0,i+1)+'全不选';
	    }
		$(obj).html(a);
	}
	
	function zTreeOnCheck(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);

		var nodes = treeNode.childs;
		
		if (nodes == null || nodes == undefined) {
			treeObj.reAsyncChildNodes(treeNode, "refresh");
		} else {
			if (selectallflag && treeNode.checked) {
		    	for (var i=0; i<nodes.length; i++) {
			    	if (nodes[i].checked) {
			    		treeObj.checkNode(nodes[i], false, false);	
			    	}
			    	treeObj.checkNode(nodes[i], true, false);
				}
			}
		}
	}
	
	function check() {}
	
	/**
	 * 设置某些节点集合是否显示checkbox
	 */
	function setIsExistsCheckbox(treeObj, nodes, flag) {
		if (nodes != undefined && nodes != null) {
			for (var i=0; i<nodes.length; i++) {
				if (nodes[i].nocheck == flag) {
					continue;
				}
				
				nodes[i].nocheck = flag;
				treeObj.updateNode(nodes[i]);
			}
		}
	}
	//-->
  </script>
  </body>
</html>