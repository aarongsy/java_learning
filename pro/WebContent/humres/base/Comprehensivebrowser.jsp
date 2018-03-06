<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script>
   <%
   String refobjid=StringHelper.null2String(request.getParameter("refid"));
RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
Refobj refobj=refobjService.getRefobj(refobjid);
String sqlwhere = StringHelper.null2String(request.getParameter("sqlwhere"));
String reportwhere = StringHelper.null2String(request.getParameter("reportwhere"));
if(!"".equals(reportwhere)){
    reportwhere = "&reportwhere="+reportwhere;
}
List list=new ArrayList();
if(!StringHelper.isEmpty(refobj.getMgid()))
list=StringHelper.string2ArrayList(refobj.getMgid(),",");
   %>
    Ext.onReady(function(){
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0
        });
        <%for(int i=0;i<list.size();i++){
         String id=(String)list.get(i);
         Refobj rf1=refobjService.getRefobj(id);
        %>
        addTab(contentPanel,"<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id=<%=id%>&sqlwhere=<%=sqlwhere%><%=reportwhere%>","<%=rf1.getObjname()%>",'page_portrait');
        <%}%>
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
    });

</script>
</head>
<body>
<div id="divSum">
<div id="pagemenubar"> </div>
	<form id="eweaverForm"></form>
    </div>
    </body>
<script type="text/javascript">
</script>
</html>

