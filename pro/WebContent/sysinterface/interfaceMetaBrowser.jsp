<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<base target="_self"> 
<% 
String objtype = request.getParameter("objtype");
String objid = request.getParameter("objid");
%>
  <head>
   <base target="_self" />
  <title>接口树形列表</title>
  <script src='/js/jquery/1.6.2/jquery.min.js'></script>
  <script src='/js/jquery/plugins/ztree/jquery.ztree-2.6.js'></script>
  <link rel="stylesheet" href="/js/jquery/plugins/ztree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
  <script type="text/javascript">  
  var zTree;
  var objtype = '<%=StringHelper.null2String(objtype)%>';
  var objid = '<%=StringHelper.null2String(objid)%>';
  var setting = {
			checkable:true,
			checkStyle:'radio',
			checkRadioType:'all',
			async:true,
			asyncUrl :'/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=tree',
			asyncParam : ["id"],
			callback: {
				change:	zTreeOnChange
			}
		};
		
 function zTreeOnChange(event, treeId, treeNode){
 	//window.returnValue={treeNode.id,treeNode.name};
 	if(treeNode.checked == true) {
 		if(confirm('将要创建' + treeNode.name + '类型接口')) {
 			window.location.href='/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=direct&objtype='+objtype+'&objid='+objid+'&pid=' + treeNode.id;	
 		}
 	}	
 }
 
  var treeNodes = [];
  $(document).ready(function(){
		zTree = $("#tree").zTree(setting, treeNodes);
	});
  
  </script>
  </head>
  
  <body >
    请选择需要创建的接口类型
  <ul id="tree" class="tree" style="width:300px; overflow:auto;"></ul>
  </body>
</html>