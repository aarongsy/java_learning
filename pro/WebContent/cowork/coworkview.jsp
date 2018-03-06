<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<jsp:directive.page import="com.eweaver.base.category.service.CategoryService"/>
<jsp:directive.page import="com.eweaver.base.category.model.*"/>
<jsp:directive.page import="com.eweaver.cowork.model.*"/>
<html>
<head>
<style type="text/css">
	html,body{padding-left: 10px !important;}
     #pagemenubar table {width:0}
</style>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script>
   <%
   String categoryid=StringHelper.null2String(request.getParameter("categoryid"));
  CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
  List list1=new ArrayList();
   List list=categoryService.getchild(categoryid,list1);

   %>
    Ext.onReady(function(){
     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:false,
            autoScroll:true,
            activeTab:0
        });
        
        addTab(contentPanel,"<%=request.getContextPath()%>/cowork/cowork.jsp?categoryid=<%=categoryid%>&isall=1","<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72432b110066")%>",'page_portrait');
       
        <%for(int i=0;i<list.size();i++){
        String id=(String)list.get(i);
       Category category= categoryService.getCategoryById(id);
        %>
        addTab(contentPanel,"<%=request.getContextPath()%>/cowork/cowork.jsp?categoryid=<%=id%>","<%=category.getObjname()%>",'page_portrait');
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

