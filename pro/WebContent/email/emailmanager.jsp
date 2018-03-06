<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.email.model.Emailsetinfo" %>
<%@ page import="com.eweaver.email.service.EmailsetinfoService" %>
<%

    String rootid = "r00t";
    String roottext = labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80039");//我的邮件
    EmailsetinfoService emailsetinfoService  = (EmailsetinfoService) BaseContext.getBean("emailsetinfoService");
    List<Emailsetinfo> list=emailsetinfoService.getEmailsetinfos("from Emailsetinfo where userid='"+eweaveruser.getId()+"'");

%>

<html>
  <head>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
</style>
     <script type="text/javascript">
       function onItemCheck(item, checked){
           document.getElementById("divloading").style.display="block";
             item.disable();
             var id=item.id;
              Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=getemail',
                     params:{id:id},
                     success: function(res) {
                         item.enable();
                         document.getElementById("divloading").style.display="none";
                        emailframe.location="<%=request.getContextPath()%>/email/emailsendtolist.jsp";
                     }
                 });
    }
 </script>
  <script type="text/javascript">
  Ext.SSL_SECURE_URL='about:blank';
  var emailTree;
  Ext.override(Ext.tree.TreeLoader, {
	createNode : function(attr){
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
          <%
       String strmenulist="";
                int i=0;
                for(Emailsetinfo est:list){
                 String objname=est.getObjname();
                String id=StringHelper.null2String(est.getId());
                if(i==0){
                   strmenulist="{id:'"+id+"',text:'"+objname+"',iconCls: Ext.ux.iconMgr.getIcon('email'),handler:onItemCheck}";
                }else{
                    strmenulist+=",{id:'"+id+"',text:'"+objname+"',iconCls: Ext.ux.iconMgr.getIcon('email'),handler:onItemCheck}";
                }
                i++;
                }
                %>
       var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [<%=strmenulist%>  ]
    });
  Ext.onReady(function(){
     emailTree = new Ext.tree.TreePanel({
            animate:true,
            //title: '&nbsp;',
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            //lines:true,
            region:'west',
            width:250,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
           tbar: [{
            text: '<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8003a")%>',//写 信
            iconCls:Ext.ux.iconMgr.getIcon('email_edit'),
            handler : function() {
                emailframe.location ='sendemail.jsp';

            }
        },
          '-'
         ,{
            text: '<%=labelService.getLabelNameByKeyId("40288184119b6f4601119c3cdd77002d")%>',//高级搜索
            iconCls:Ext.ux.iconMgr.getIcon('email_magnify'),
            handler : function() {
                 emailframe.location ='emailonsearch.jsp';
            }
           }  ,
        '-',

        {
            id:'getmail',
            text:'<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8003b")%>',//收取邮件
            iconCls: Ext.ux.iconMgr.getIcon('email_open'),
            menu:menu
        },
             Ext.get('divloadinga').dom.innerHTML
           ],
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottext%>',
                id:'<%=rootid%>',
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=getemailtypeconfig",
            preloadChildren:false
        }
                )
    });
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [emailTree,
                {
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'emailframe', name:'emailframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});
  });

  </script>

  <style>

   </style>
  </head>
  <body >
  <p align="center"></p>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
     <div id="divloadinga" >
     <span id="divloading" style="display:none"><img src="<%=request.getContextPath()%>/images/base/loading.gif" alt="" ></span>
    </div>
  </body>
</html>
