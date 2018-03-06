<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.cowork.model.*"%>
<%@ page import="com.eweaver.cowork.service.*"%>
<html>
<head>
<style type="text/css">
     #pagemenubar table {width:0}
</style>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <%
   String categoryid=StringHelper.null2String(request.getParameter("categoryid"));
  CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
  List list1=new ArrayList();
  List list=categoryService.getchild(categoryid,list1);
   %>
<script>
    Ext.onReady(function(){
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0
        });
		 addTab(contentPanel,'coworkviewframe.jsp?categoryid=<%=categoryid%>&isall=1','<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72432b110066") %>','page_portrait');//全部
		 <%for(int i=0;i<list.size();i++){
			 String id=(String)list.get(i);
			 Category category= categoryService.getCategoryById(id);
			%>
			 addTab(contentPanel,"coworkviewframe.jsp?categoryid=<%=id%>","<%=category.getObjname()%>",'page_portrait');
        <%}%>

		var viewport = new Ext.Viewport({
			layout: 'border',
			items: [contentPanel]
		});
    });
</script>
</head>
<body>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="*">
<!-- <iframe src="" ID="iframeCoworkView" name="iframeCoworkView" style="width:100%;height:100%" scrolling="auto"/>  -->
</td></tr>
</table>
</body>
</html>
