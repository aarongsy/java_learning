<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <title>接口树形列表</title>
  <script src='/js/jquery/1.6.2/jquery.min.js'></script>
  <script src='/js/jquery/plugins/ztree/jquery.ztree-2.6.js'></script>
  <link rel="stylesheet" href="/js/jquery/plugins/ztree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
  
  <script type="text/javascript">  
  var zTree;
  var setting = {
			checkable: true,
			checkStyle:'radio',
			checkRadioType:'all',
			async:true,
			asyncUrl :'/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=getChildren',
			asyncParam : ["id"],	
			callback: {
				change:	zTreeOnChange
			}
		};
 function zTreeOnChange(event, treeId, treeNode){
 	window.returnValue={treeNode.id,treeNode.name};
 	window.close();
 }
  var treeNodes = [];
  $(document).ready(function(){
		zTree = $("#tree").zTree(setting, treeNodes);
	});
  
  </script>
  </head>

  <body >
  <ul id="tree" class="tree" style="width:300px; overflow:auto;"></ul>
  </body>
</html>
