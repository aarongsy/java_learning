<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ include file="/base/init.jsp"%>
<%
String orgid=request.getParameter("id");
String isOrgDefined=request.getParameter("isOrgDefined");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
Orgunit orgunit=orgunitService.getOrgunit(orgid);
MenuorgService menuorgService = (MenuorgService) BaseContext.getBean("menuorgService");
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
List menuList = menuService.getSubMenus(null,"2",null);
%>
<html>
<head>
</head>
<body onLoad="expandMenu()">
<input type=hidden name="orgid" value="<%=orgid%>">
<input type="hidden" id="orgunitName" name="orgunitName" value="<%=orgunit.getObjname()%>"> 
<%
if("true".equals(isOrgDefined)){
%>
<div dojoType="LayoutContainer" layoutChildPriority='top-bottom' style="width: 100%; height: 100%;overflow:auto;overflow-x:hidden">
  <div dojoType="ContentPane" layoutAlign="top">
    <div class="newButtons">
      <div style="float: left; margin-right: 10px;">
        <button dojoType="Button" onClick="onSubmit()"> <%=labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")%></button>
      </div>
      <div style="float: left; margin-right: 10px;">
        <button dojoType="Button" onClick="onDelete()"> <%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%></button>
      </div>
    </div>
  </div>
  <div dojoType="ContentPane" layoutAlign="top" style="margin-top:5px;margin-left:5px;">
      <div dojoType="Tree" DNDMode="between" widgetId="<%=orgid%>"  controller="menuTreeController"  toggler="explor" style="width: 200px; height: 100%;overflow:auto">
      	<%
		for(int i=0;i<menuList.size();i++){
		Menu menu=(Menu)menuList.get(i);
          String menuname=labelService.getLabelName(menu.getMenuname());// 把menuname存放的是标签管理的关键字
        if(StringHelper.isEmpty(menuname))
        menuname=menu.getMenuname();
		String menuid = menu.getId();
		int childrennum = menu.getChildrennum().intValue();
		menuname = "<a>"+menuname+"</a>";									
		String checked="";
		if(menuorgService.isMenuDefined(menu.getId(),orgid)) checked="checked";
		menuname = "<input type=checkbox  style='width:16px;height:16px' name=checklist id=checklist  "
			+checked+" value="+menuid+"><input type=hidden name=idlist value="+menuid+">"+menuname;
		%>
      	<div dojoType="TreeNode" widgetId="<%=menuid%>" objectId="<%=menuid%>" title="<%=menuname%></a>" isFolder="<%=childrennum>0?true:false%>"></div>
      	<%
      	}
      	%>
      </div>
  </div>
</div>
<%}else{%>
<div dojoType="LayoutContainer" layoutChildPriority='top-bottom' style="width: 100%; height: 100%;overflow:auto;overflow-x:hidden">
  <div dojoType="ContentPane" layoutAlign="top">
    <div class="newButtons">
      <div style="float: left; margin-right: 10px;">
        <button dojoType="Button" onClick="onCreate()" title="新建<%=orgunit.getObjname()%>组织菜单">新建</button>
      </div>
    </div>
  </div>
  <div dojoType="ContentPane" layoutAlign="top">
    <div style="margin-left:5px;margin-top: 5px;">
      <a><%=orgunit.getObjname()%></a>未定义组织菜单，点新建按钮新建           
    </div>
  </div>
</div>
<%}%>
</body>
</html>