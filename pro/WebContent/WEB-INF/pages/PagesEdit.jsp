<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.homepage.model.Pages"%>
<%@ page import="com.eweaver.base.util.PageHelper"%>
<%
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");  
Map<String,String> typeMap=new HashMap<String,String>();
List<Selectitem> list1=selectitemService.getSelectitemList("40288032225e14b201225e4627e30001",null);
for(Selectitem item:list1)typeMap.put(item.getId(),item.getObjname());
Pages pages=null;
Object pobj=request.getAttribute("page");
if(pobj!=null)pages=(Pages)pobj;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
<style>
<!--
.x-window-footer table,.x-toolbar table{width:auto;}
-->
</style>
<script type="text/javascript">
var url="<%=request.getRequestURI()%>";

var isChg=false;

var Page={
	Save:function(){
		if(Ext.isEmpty(Ext.getDom('title').value)){
			alert('标题不能为空!');
			Ext.getDom('title').focus();
			return;
		}
		isChg=false;
		Ext.EventManager.on("text", 'change',chgFlag);
		document.form1.submit();
	},
	Cancel:function(){
		if(isChg && !confirm('页面内容已修改但未保存,确定退出编辑吗(Y/N)?'))return;
		var p=top.frames[1].contentPanel.getActiveTab();
		top.frames[1].contentPanel.remove(p);
	},
	Preview:function(){
		window.open('/index.jsp?id=<c:out value="${page.id}"/>');
	},
	insertElement:function(){
	}
};
var topBar=null;
function initToolbar(){
	topBar = new Ext.Toolbar({region:'north'});
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'保存','S','accept',Page.Save);
	addBtn(topBar,'取消','C','arrow_redo',Page.Cancel);
	addBtn(topBar,'预览','D','application_view_detail',Page.Preview);
	addBtn(topBar,'插入元素','I','add',Page.insertElement);
}

function resizeArea(){
	Ext.getDom('text').style.width=(document.body.clientWidth-14)+'px';
	Ext.getDom('text').style.height=(document.body.clientHeight-90)+'px';
}
function chgFlag(){
	isChg=true;
	Ext.EventManager.un("text", 'change',chgFlag);
}
Ext.onReady(function(){
	initToolbar();
	Ext.EventManager.on(window, 'resize', resizeArea);
	resizeArea();
	Ext.EventManager.on("text", 'change',chgFlag);
});

</script>
</head>

<body>
<div id="pagemenubar" style="z-index:100;"></div>
<form name="form1" id="form1" method="post" action="<%=request.getRequestURI()%>">
<input type="hidden" name="action" value="save"/>
<input type="hidden" name="id" value='<c:out value="${page.id}"/>'/>
<table border="1">
  <tr>
    <td>标题:</td><td><input id="title" name="title" value='<c:out value="${page.title}"/>'/></td>
  </tr>
  <tr><td>类别</td><td><select name="type" id="type">
  <%PageHelper.outputOptions(typeMap,(pages==null)?"":pages.getType(),out);%>
  </select>
  <label for="isHomepage"><input type="checkbox" name="isHomepage" value="1" <c:if test="${page.isHomepage==1}">checked</c:if> />是否首页</label>
  </td></tr>
  <tr><td>
  <span style="color:red;font-weight:bold;">Tips:</span>
  </td><td>
    编辑完整HTML页时,请在&lt;head&gt;标记内加变量<span style="color:green;font-weight:bold;">${headerFiles}</span>,文档的DocType头声明为<span style="color:green;font-weight:bold;">xhtml1-transitional.dtd</span>,否则CSS和JS效果会有异常Bug!  
  </td>
  </tr>
  <tr><td colspan="2">
  <textarea id="text" style="width:600px;height:600px;" name="text"><c:out value="${text}"/></textarea>
  </td></tr>
</table>
</form>
</body>
</html>
