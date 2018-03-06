<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.homepage.model.WebMenu" %>
<%@ page import="com.eweaver.homepage.dao.WebMenuDao" %>
<%
WebMenuDao menuDao=(WebMenuDao)BaseContext.getBean("webMenuDao");
String action=StringHelper.null2String(request.getParameter("action"));
String id=StringHelper.null2String(request.getParameter("id"));
WebMenu menu=new WebMenu();
menu.setName("");
menu.setUrl("");
if(action.equalsIgnoreCase("save") && request.getMethod().equalsIgnoreCase("post")){

	if(!StringHelper.isEmpty(id))menu.setId(id);
	menu.setName(StringHelper.null2String(request.getParameter("name")));
	menu.setUrl(StringHelper.null2String(request.getParameter("url")));
	menuDao.save(menu);
	out.println("<script>var id=top.frames[1].contentPanel.getActiveTab().getId();");
	out.println("var frame=top.frames[1].Ext.getDom(id+'frame');");
	out.println("frame.contentWindow.location.reload();");
	out.println("top.frames[1].commonDialog.hide();</script>");
	return;
}else if(!StringHelper.isEmpty(id)){
	menu=menuDao.getObjectById(id);
}
 %>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
  <title>网页菜单编辑</title>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
      <style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
      .x-panel-btns-ct {
        padding: 0px;
    }
    .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript">
    function Save(item){
    	if(Ext.isEmpty(DWRUtil.getValue('name'))){
    		alert('名称不能为空!');
    		Ext.getDom('name').focus();
    		return;
    	}
    	if(Ext.isEmpty(DWRUtil.getValue('url'))){
    		alert('地址不能为空!');
    		Ext.getDom('url').focus();
    		return;
    	}
    	document.form1.submit();
    }
	Ext.onReady(function() {
		Ext.QuickTips.init();
		var tb = new Ext.Toolbar({region:'north'});
		tb.render('pagemenubar');
		addBtn(tb,'保存','S','accept',Save);
	});
  </script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/homepage/webmenuEdit.jsp" name="form1"  id="form1" method="post">
<input type="hidden" name="action" value="save"/>
<input type="hidden" name="id" value="<%=id%>"/>
<table>
    <colgroup>
        <col width="50%">
        <col width="50%">
    </colgroup>
    <tr><td valign=top>名称:</td><td><input id="name" name="name" value="<%=menu.getName()%>"/></td></tr>
    <tr><td valign=top>地址:</td><td><input id="url" name="url" value="<%=menu.getUrl()%>" size="40"/></td></tr>
</table>
</form>
  </body>
</html>
