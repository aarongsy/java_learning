<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.homepage.model.WebSkin" %>
<%@ page import="com.eweaver.homepage.dao.WebSkinDao" %>
<%
WebSkinDao skinDao=(WebSkinDao)BaseContext.getBean("webSkinDao");
String action=StringHelper.null2String(request.getParameter("action"));
String id=StringHelper.null2String(request.getParameter("id"));
WebSkin skin=new WebSkin();
skin.setName("");
skin.setPath("");
String isDefault="";
if(action.equalsIgnoreCase("save") && request.getMethod().equalsIgnoreCase("post")){

	if(!StringHelper.isEmpty(id))skin.setId(id);
	skin.setName(StringHelper.null2String(request.getParameter("name")));
	skin.setPath(StringHelper.null2String(request.getParameter("path")));
	skin.setIsdefault(NumberHelper.getIntegerValue(request.getParameter("isdefault"),0));
	if(skin.getIsdefault()==1){//将原来的默认设为空
		skinDao.executeHql("update WebSkin set isdefault=0 where isdefault=1");
	}
	/** 这里解压上传的文件 **/
	skin.setSkinFname("");
	skinDao.save(skin);
	
	out.println("<script>var id=top.frames[1].contentPanel.getActiveTab().getId();");
	out.println("var frame=top.frames[1].Ext.getDom(id+'frame');");
	out.println("frame.contentWindow.location.reload();");
	out.println("top.frames[1].commonDialog.hide();</script>");
	return;
}else if(!StringHelper.isEmpty(id)){
	skin=skinDao.getObjectById(id);
	isDefault=(skin.getIsdefault()!=null && skin.getIsdefault().intValue()==1)?"checked":"";
}
 %>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
  <title>网站皮肤编辑</title>
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
    		alert('标题不能为空!');
    		Ext.getDom('name').focus();
    		return;
    	}
    	if(Ext.isEmpty(DWRUtil.getValue('path'))){
    		alert('皮肤名称不能为空!');
    		Ext.getDom('path').focus();
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
<form action="<%=request.getContextPath()%>/homepage/skinEdit.jsp" name="form1"  id="form1" method="post">
<input type="hidden" name="action" value="save"/>
<input type="hidden" name="id" value="<%=id%>"/>
<table>
    <colgroup>
        <col width="100">
    </colgroup>
    <tr><td>标题:</td><td><input id="name" name="name" value="<%=skin.getName()%>"/></td></tr>
    <tr><td>皮肤名称:</td><td><input id="path" name="path" value="<%=skin.getPath()%>"/>(只能英文字母和数字)</td></tr>
    <tr><td>是否默认:</td><td><input type="checkbox" name="isdefault" value="1" <%=isDefault%>/></td></tr>
    <tr><td>选择文件:</td><td><input type="file" name="skinFname"/></td></tr>
</table>
</form>
  </body>
</html>
