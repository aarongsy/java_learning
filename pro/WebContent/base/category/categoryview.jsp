<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="java.net.URLEncoder"%>
<%
String model = StringHelper.trimToNull(request.getParameter("model"));
String categoryid = StringHelper.trimToNull(request.getParameter("categoryid"));
String reportid = StringHelper.null2String(request.getParameter("reportid"));
String tagetUrl = StringHelper.trimToNull(request.getParameter("tagetUrl"));
String expandid = StringHelper.trimToNull(request.getParameter("expandid"));
String root = StringHelper.trimToNull(request.getParameter("root"));

List selectlist = new ArrayList();
//List categorylist = new ArrayList();

CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
Category category = categoryService.getCategoryById(categoryid);



ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
Forminfo forminfo = forminfoService.getForminfoById(category.getPFormid());

String modelname="";
modelname=forminfo.getObjtablename();

//categorylist = categoryService.getSubCategoryList2(categoryid,modelname,null,null);

%>
<html>
  <head>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
 <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>

  <script type="text/javascript">
   Ext.SSL_SECURE_URL='about:blank';   
   var categoryTree;
   Ext.override(Ext.tree.TreeLoader, {
     createNode : function(attr){
         // apply baseAttrs, nice idea Corey!
         if(this.baseAttrs){
             Ext.applyIf(attr, this.baseAttrs);
         }
         if(this.applyLoader !== false){
             attr.loader = this;
         }
         if(typeof attr.uiProvider == 'string'){
            attr.uiProvider = this.uiProviders[attr.uiProvider] || eval(attr.uiProvider);
         }

         var n = (attr.leaf ?
                         new Ext.tree.TreeNode(attr) :
                         new Ext.tree.AsyncTreeNode(attr));

     if (attr.expanded) {
             n.expanded = true;
         }

         return n;
     }
 });
   Ext.onReady(function(){
      categoryTree = new Ext.tree.TreePanel({
             animate:true,
             //title: '&nbsp;',
             //useArrows :true, //注释掉了 表示用+ 否则是三角显示
             containerScroll: true,
             autoScroll:true,
             //lines:true,
             region:'west',
             width:200,
             split:true,
             collapsible: true,
             collapsed : false,
             rootVisible:false,
             root:new Ext.tree.AsyncTreeNode({
                 text: 'category',
                 id:'r00t',
                 expanded:true,
                 allowDrag:false,
                 allowDrop:false
             }),
         loader:new Ext.tree.TreeLoader({
             dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=getChildrenForSelect&categoryid=<%=categoryid%>&model=<%=model%>&reportid=<%=reportid%>",
             preloadChildren:false
         }
                 )


     });

       //Viewport
     var viewport = new Ext.Viewport({
         layout: 'border',
         items: [categoryTree,
                 {
                 //title: '分类',
                 region:'center',
                 xtype     :'iframepanel',
                 frameConfig: {
                     id:'categoryframe', name:'categoryframe', frameborder:0 ,
                     eventsFollowFrameLinks : false
                 },
                 autoScroll:true
             }
         ]
     });

   })

   </script>

  </head> 
  <body >

 <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>

  </body>
</html>
