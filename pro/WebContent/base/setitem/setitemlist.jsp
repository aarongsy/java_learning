<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ include file="/base/init.jsp"%>
<%
%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script>
    Ext.SSL_SECURE_URL='about:blank';
    Ext.onReady(function(){
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:false,
            autoScroll:true,
            activeTab:0
        });
     addTab(contentPanel,'<%=request.getContextPath()%>/base/setitem/setiteminfobell.jsp','通讯设置','page_portrait_shot');
    // addTab(contentPanel,'<%=request.getContextPath()%>/base/setitem/setitemsubject.jsp','标题权限','application_edit.gif');
    // addTab(contentPanel,'<%=request.getContextPath()%>/base/setitem/setitemobject.jsp','对象权限自动重构','application_form');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/setitem/setitemsyssetting.jsp','系统设置','laptop_edit');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/setitem/setitemdoc.jsp','文档模块','page_paintbrush');
     addTab(contentPanel,'<%=request.getContextPath()%>/base/setitem/setitemtool.jsp','工具栏快捷搜索项','zoom');
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});

    });
</script>
</head>
<body>
</body>
</html>