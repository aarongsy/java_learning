<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.homepage.model.*" %>
<%@ page import="com.eweaver.homepage.dao.*" %>
<%
WebMenuRefDao menuRefDao=(WebMenuRefDao)BaseContext.getBean("webMenuRefDao");
WebMenuDao menuDao=(WebMenuDao)BaseContext.getBean("webMenuDao");
String action=StringHelper.null2String(request.getParameter("action"));
String id=StringHelper.null2String(request.getParameter("id"));
String pid=StringHelper.null2String(request.getParameter("pid"));
WebMenuRef menu=new WebMenuRef();
menu.setMenuid("");
menu.setDsporder(Integer.valueOf(0));
menu.setPid(pid);
String target0="checked";
String target1="";
String menuName="";
if(action.equalsIgnoreCase("save") && request.getMethod().equalsIgnoreCase("post")){
	if(!StringHelper.isEmpty(id))menu.setId(id);
	menu.setMenuid(StringHelper.null2String(request.getParameter("menuid")));
	menu.setPid(StringHelper.null2String(request.getParameter("pid")));
	menu.setDsporder(NumberHelper.getIntegerValue(request.getParameter("dsporder"),0));
	menu.setTarget(NumberHelper.getIntegerValue(request.getParameter("target"),0));
System.out.println("t:"+menu.getTarget());
	menuRefDao.save(menu);
	out.println("<script>parent.location.reload();");
	out.println("</script>");
	return;
}else if(!StringHelper.isEmpty(id)){
	menu=menuRefDao.getObjectById(id);
	WebMenu m=menuDao.getObjectById(menu.getMenuid());
	if(m!=null)menuName=m.getName();
	target0=(menu.getTarget()!=null &&  menu.getTarget().intValue()==0)?"checked":"";
	target1=(menu.getTarget()!=null &&  menu.getTarget().intValue()==1)?"checked":"";
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
    	if(Ext.isEmpty(DWRUtil.getValue('menuid'))){
    		alert('菜单项不能为空!');
    		Ext.getDom('name').focus();
    		return;
    	}
    	document.form1.submit();
    }
	Ext.onReady(function() {
		Ext.QuickTips.init();
		var tb = new Ext.Toolbar({region:'north'});
		tb.render('pagemenubar');
		addBtn(tb,'保存','S','accept',Save);
		addBtn(tb,'返回','B','arrow_redo',function(){location.href="about:blank";});
	});

function getMenuId(obj){
	var ret=openDialog("/homepage/webmenu.jsp?action=browser");
	if(Ext.isArray(ret)){
		Ext.getDom('menuid').value=ret[0];
		Ext.getDom('menuidspan').innerHTML=ret[1];
	}
}
  </script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/homepage/webmenuRefEdit.jsp" name="form1"  id="form1" method="post">
<input type="hidden" name="action" value="save"/>
<input type="hidden" name="pid" value="<%=StringHelper.null2String(menu.getPid())%>"/>
<table>
    <colgroup>
        <col width="50%">
    </colgroup>
    <tr><td>ID:<%=id%><input type="hidden" name="id" readonly="readonly" size="40" value="<%=id%>"/></td>
    <tr><td valign=top>菜单项:
    <button type="button"  class="Browser" name="menuidBtn" onclick="getMenuId()"></button>
    <input type="hidden" name="menuid" id="menuid" value="<%=menu.getMenuid()%>"/>
    <span id="menuidspan"><%=menuName%></span>
    </td></tr>
    <tr><td>顺序:<input name="dsporder" value="<%=menu.getDsporder()%>"/></td></tr>
    <tr><td>打开方式:<input type="radio" name="target" value="0" <%=target0%>/>默认(当前窗口)&nbsp;
    <input type="radio" name="target" value="1" <%=target1%>/>新窗口</td></tr>
</table>
</form>
  </body>
</html>
