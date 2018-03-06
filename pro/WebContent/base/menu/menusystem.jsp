<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ include file="/base/init.jsp"%>
<%
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
List menuList = menuService.getSubMenus(null,"1","1");
%>

<html>
  <head>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.lang.*");
	dojo.require("dojo.widget.Tree");
	dojo.require("dojo.widget.TreeRPCController");
	dojo.require("dojo.widget.TreeSelector");
	dojo.require("dojo.widget.TreeNode");
	dojo.require("dojo.widget.TreeContextMenu"); 

	
</script>
<script language="javascript">
function doUrl(objval){
	var objNode = dojo.widget.manager.getWidgetById(objval);
	if(objNode != null){
		if(objNode.object != "") {
			parent.parent.mainframe.location.href = objNode.object;	
		}
	}	

}
</script>
<style>
body{background-color:#EEEEEE;}
.treeTable{border:none;}
.treeTable tr {
	vertical-align: top;
}
</style>

  </head> 
  <body >
  

<div dojoType="TreeRPCController" RPCUrl="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuTreeAction" widgetId="treeController" DNDController="create"></div>
  
<div dojoType="TreeSelector" widgetId="treeSelector"></div>

<table class="treeTable" cellpadding="10" height="100%">
<tr>
<td>
    <div dojoType="Tree" DNDMode="between" selector="treeSelector" actionsDisabled="move" widgetId="Tree"  controller="treeController"  toggler="explor" style="border:1px solid red">
  
  <%
  for(int i=0;i<menuList.size();i++){
	Menu menu1 = (Menu)menuList.get(i);
      String menuname=labelService.getLabelName(menu1.getMenuname()); // 把menuname存放的是标签管理的关键字
             if(StringHelper.isEmpty(menuname)){
                 menuname=menu1.getMenuname();
             }
	String menuid = menu1.getId();
	String imgsrc = StringHelper.null2String(menu1.getImgfile());
	int childrennum = menu1.getChildrennum().intValue();
	String isfolder = "false";
	if(childrennum>0)
		isfolder = "true";
	/*
	if(!StringHelper.isEmpty(imgsrc))
		menuname = "<img src='"+imgsrc+"' border=0>"+menuname+"</img>";		
	*/
	String url = StringHelper.null2String(menu1.getUrl());
//	if(!StringHelper.isEmpty(url)){
//		menuname = "<a href='"+url+"' target='mainframe'>"+menuname+"</a>";
//	}else{
		menuname = "<a href='#' onclick=doUrl('"+menuid+"'); >"+menuname+"</a>";
//	}
	
%>

    <div dojoType="TreeNode" widgetId="<%=menuid%>" object="<%=url%>" title="<%=menuname%>" actionsDisabled="move" isFolder="<%=isfolder%>">
    </div>
<%}%>

</div>
</td>
</tr>
</table>

  </body>
</html>
