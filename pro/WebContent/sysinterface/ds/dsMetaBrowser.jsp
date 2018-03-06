<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <title>数据源树形列表</title>
  <script src='/js/jquery/1.6.2/jquery.min.js'></script>
  <script src='/js/jquery/plugins/ztree/jquery.ztree-2.6.js'></script>
  <link rel="stylesheet" href="/js/jquery/plugins/ztree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
  <script type="text/javascript">  
  var zTree;
  var setting = {
			checkable:true,
			checkStyle:'radio',
			checkRadioType:'all',
			async:true,
			asyncUrl :'/ServiceAction/com.eweaver.sysinterface.ds.servlet.DsMetaAction?action=tree',
			asyncParam : ["id"],
			callback: {
				change:	zTreeOnChange
			}
		};
 function zTreeOnChange(event, treeId, treeNode){
 	//window.returnValue={treeNode.id,treeNode.name};
 	if(confirm('将要创建' + treeNode.name + '类型数据源')) {
 		window.location.href='/ServiceAction/com.eweaver.sysinterface.ds.servlet.DsMetaAction?action=direct&pid=' + treeNode.id;	
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