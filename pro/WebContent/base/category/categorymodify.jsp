<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.LabelType"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@page import="com.eweaver.word.service.WordModuleService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.sysinterface.base.service.InterfaceConfigDetailService" %>
<%@ page import="com.eweaver.sysinterface.base.service.InterfaceObjLinkService" %>
<%@ page import="com.eweaver.sysinterface.base.model.InterfaceObjLink" %>
<%@ page import="com.eweaver.sysinterface.base.model.InterfaceConfigDetail" %>

<%
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
 String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
MenuService menuService = (MenuService) BaseContext.getBean("menuService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
ModuleService moduleService = (ModuleService) BaseContext.getBean("moduleService");
WordModuleService wordModuleService = (WordModuleService) BaseContext.getBean("wordModuleService");
Forminfo forminfo;
String id = StringHelper.trimToNull(request.getParameter("id"));
if(id!=null&&id.equals("r00t"))
return;
Category category = new Category();
Categorylink categorylink = new Categorylink();

if(id!=null){
	category = categoryService.getCategoryById(id);
	moduleid = category.getModuleid();
}else{
  category.setModuleid(moduleid);
}
String pid = StringHelper.trimToNull(request.getParameter("pid"));
String parentFormid = category.getPFormid();
String pidFormid = "";

if(pid != null){
  pidFormid  = categoryService.getCategoryById(pid).getPFormid();
}

if(pid == null){
	pid = category.getPid();
}
boolean  tempbol = (id==null && "402881e50bff706e010bff7fd5640006".equals(pidFormid));
pagemenustr+=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){EditOK()});";//确定
   if(!StringHelper.isEmpty(category.getModuleid()))
pagemenustr+=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550016")+"','S','page',function(){showWizard()});";//生成菜单
String tabStr="addTab(contentPanel,AddPerm(),'"+labelService.getLabelNameByKeyId("402881ed0c29ccef010c2a9592ac0019")+"','script_key');";//权限定义
//if(!("402881e50bff706e010bff7fd5640006".equals(parentFormid) || tempbol) ){  //去掉分类体系的提醒管理
 tabStr+="addTab(contentPanel,AddNotify(),'"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790068")+"','time');";//提醒管理
//}
if("4028803523cacb540123caff02a50012".equals(id)&&!StringHelper.isEmpty(category.getFormid())){
  tabStr+="addTab(contentPanel,AddIndagate(),'"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790069")+"','application');";//网上调查表单设置
}
  boolean isexistdocParent = false;
  String categoryIdorPid = id;
  if(StringHelper.isEmpty(categoryIdorPid))categoryIdorPid = pid;
  List<Category> ParentCategory = categoryService.getParentCategoryList(categoryIdorPid,null,null);
  for(Category categoryobj : ParentCategory){
	  if("40288148117d0ddc01117d8c36e00dd4".equals(categoryobj.getId())){
		  isexistdocParent = true;
	  }
  }
  String rootidmenu="r00t";
   String roottextmenu=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2347c00015");//用户菜单
   
   
   
   //Start_获取相关接口
  InterfaceConfigDetailService interfaceConfigDetailService = (InterfaceConfigDetailService)BaseContext.getBean("interfaceConfigDetailService");
  InterfaceObjLinkService interfaceObjLinkService = (InterfaceObjLinkService)BaseContext.getBean("interfaceObjLinkService");
  List<InterfaceObjLink> interfaceList = interfaceObjLinkService.findByObjid(id);
  StringBuffer interfaceNames = new StringBuffer();
  if(interfaceList != null && !interfaceList.isEmpty()) {
  	for( InterfaceObjLink interfaceObjLink : interfaceList) {
  		InterfaceConfigDetail interfaceobj = interfaceConfigDetailService.getConfigDetailById(interfaceObjLink.getInterfaceId());
  		if(interfaceobj != null) {
  			interfaceNames.append(StringHelper.null2String(interfaceobj.getName()) + ",");
  		}
  	}
  }
  //End
%>
<html>
  <head>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/ext-ux-wiz.css" />
      <style type="text/css">
           .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
      </style>

      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/engine.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/util.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js"></script>
       <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
          var dlg0;
          var step1,step2,step3,step4,step5;
          var wizard;
          var moduleTree;
          var nodeid;
          var isexistdocParent=<%=isexistdocParent%>;
          Ext.onReady(function() {
        Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       <%}%>

       var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:false,
            activeTab:0,
            items:[{contentEl:'divSum',title:'<%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772e24f50009")%>',iconCls: Ext.ux.iconMgr.getIcon('application_form'),autoScroll:true}]//基本信息
        });
       <%=tabStr%>
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
              dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width * 0.8,
                         height:viewport.getSize().height * 0.8,
                         buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%>',//取消
                             handler  : function() {
                                 dlg0.hide();
                                 dlg0.getComponent('dlgpanel').setSrc('about:blank');
                             }
                         },{
                             text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
                             handler  : function() {
                                 dlg0.hide();
                                 dlg0.getComponent('dlgpanel').setSrc('about:blank');
                             }

                         }],
                         items:[{
                             id:'dlgpanel',
                             region:'center',
                             xtype     :'iframepanel',
                             frameConfig: {
                                 autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                                 eventsFollowFrameLinks : false
                             },
                             autoScroll:true
                         }]
                     });
                     dlg0.render(Ext.getBody());

                moduleTree = new Ext.tree.TreePanel({
            checkModel: 'single',
            animate: false,
            useArrows :true,
            containerScroll: true,
            autoHeight:false,
            height:100,
            autoScroll:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottextmenu%>',
                id:'<%=rootidmenu%>',
                iconCls:'pkg',
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getmenu2",
            preloadChildren:false,
             baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
        }
                )
    });
           step1=new Ext.ux.Wiz.Card({
                title : '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0004")%>',//选择页面配置的菜单
                 id:'s1',
                items : [{
                    border    : false,
                    bodyStyle : 'background:none;',
                    contentEl: 'divstep1'
                }]
            });
              var text1;
    step2=new Ext.ux.Wiz.Card({
                title   : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001a")%>',//菜单名
                id:'s2',
                monitorValid : true,
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        html:''
                    },
                  text1= new Ext.form.TextField({
                        name       : 'menuname',
                        fieldLabel : 'MenuName',
                        allowBlank : false,
                        value:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")%><%=category.getObjname()%>',//新建
                       disabled:false
                    })
                ]
            });
     step3=new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0005")%>',//请选择图片
                monitorValid : true,
                id:'s3',
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      : 'divstep2'
                    } ]
            });
     step4= new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001b")%>',//自定义页面
                id:'s4',
                monitorValid : true,
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      :'divsec'
                }]
            });
              step5= new Ext.ux.Wiz.Card({
                  title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001c")%>',//选择主菜单
                  id:'s5',
                  monitorValid : true,
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                  items :[  {xtype:"checkbox",
                name:"checkname",
                id:"checkname",
                fieldLabel:"<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001d")%>"},//打开用户菜单
                {xtype:"label",
                text :" <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980016")%>:"},//添加到
moduleTree,
				{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      :'divdisplay'
                }
]
                      });
        moduleTree.on('checkchange',function(n,c){
     nodeid=n.id ;
    })

    wizard = new Ext.ux.Wiz({
        title : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001e")%>',//生成页面菜单
      
        headerConfig : {
            title : '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006a")%>'//欢迎页面配置
        },
         listeners: {
            finish: function() { saveConfig( this.getWizardData() ) }
         },
        cardPanelConfig : {
            defaults : {
                baseCls    : 'x-small-editor',
                bodyStyle  : 'padding:40px 15px 5px 120px;background-color:#F6F6F6;',
                border     : false
            }

        },
        width:Ext.getBody().getViewSize().width*0.8,
        height:Ext.getBody().getViewSize().height*0.8,
        cards : [step1,step2,step3,step4,step5]
    });
       
          function saveConfig(obj) {
              var menuname;
              var imagfile;
              var url;
              var pid;
              //菜单位置
              var displayPosition = "";
				var displayPositionArray = document.getElementsByName("displayPosition1");
				if(displayPositionArray){
					for(var i = 0; i < displayPositionArray.length; i++){
						if(displayPositionArray[i].checked){
							displayPosition += displayPositionArray[i].value + ",";
						}
					}
					if(displayPosition != ""){
						displayPosition = displayPosition.substring(0,displayPosition.length-1);
					}
				}
			//是否同步组织单元
			var ismenuorg="";
              var ismenuorgArray=document.getElementsByName("ismenuorg1");
              if(ismenuorgArray){
					for(var i = 0; i < ismenuorgArray.length; i++){
						if(ismenuorgArray[i].checked){
							ismenuorg += ismenuorgArray[i].value ;
						}
					}
				}
			//----------
              if (obj.s1.radioname == 1) { //formbase.jsp页面
                  menuname = obj.s2.menuname;
                  imagfile = obj.s3.imagfile;
                  url = '<%=request.getContextPath()%>/workflow/request/formbase.jsp?categoryid=<%=category.getId()%>';
                  pid =nodeid;
              } else {
                   menuname = obj.s4.menuname1;
                  imagfile = obj.s4.imagfile1;
                  url =obj.s4.urll;
                  pid = nodeid;
              }
                   Ext.Ajax.request({
                       url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=createpage',
                        params:{menuname:menuname,imagfile:imagfile,url:url,pid:pid,displayPosition:displayPosition,ismenuorg:ismenuorg} ,
                         success: function() {

                             if (Ext.getDom('checkname').checked == true) {
                                 this.dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/menu/menumanager.jsp?menutype=2');
                                 this.dlg0.show()
                             } else {
                                 Ext.Msg.buttonText = {ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                                 Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550020")%>');//配置页面菜单成功
                             }
                         }
                   });
              }
              wizard.render(Ext.getBody());
          });
      </script>
  </head> 
  <body>
  <script>Ext.BLANK_IMAGE_URL = '<%= request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
<div id="divSum">
<div id="pagemenubar"> </div>
   
<input type="hidden" value="<%=moduleid%>" name="moduleid" id="moduleid"/>
  <table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				 <tbody>
				<tr>
          			<td class="FieldName">ID</td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="id"  id="id" value="<%=StringHelper.null2String(id)%>" readonly/>
          			</td>
        		</tr>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcd354e010bcd3a9b3b0009")%><!-- 分类名 --></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="objname" id="objname" onchange='checkInput("objname","objnamespan")'  onkeypress="checkQuotes_KeyPress()" value="<%=StringHelper.null2String(category.getObjname())%>"/>
          				<span id="objnamespan">
          				<% if(StringHelper.null2String(category.getObjname()).equals("")){%>
							<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
						<%}%>
						<% if(id!= null){%>
							<%=labelCustomService.getLabelPicHtml(id, LabelType.Category) %>
						<%} %>
          				
          				</span></td>
        		</tr>
  				
        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006b")%><!-- 分类说明 --></td>
          			<td class="FieldValue"><textarea class="inputstyle" style="width:100%" name="objdesc" id="objdesc"><%=StringHelper.null2String(category.getObjdesc()) %></textarea></td>
        		</tr>	

        		<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcd354e010bcd3c169b000a")%></td>
          			<td class="FieldValue"><input type="hidden" name="pid" id="pid" value="<%=StringHelper.null2String(pid)%>"/>       			
          			<input type="hidden" name="oid" id="oid" value="<%=StringHelper.null2String(pid)%>"/>       			
          				<button type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/category/categorybrowser.jsp','pid','pidspan','0');"></button>
             			<span id="pidspan"><%=StringHelper.null2String(categoryService.getCategoryPath(pid,null,null))%></span>
             		</td>
        		</tr>

        		<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" name="dsporder" id="dsporder" onkeypress="checkInt_KeyPress" value="<%=StringHelper.null2String(category.getDsporder())%>"></td>
        		</tr>
                <%
                    
                    String formid = "";
                    String formname = "";
                    String formtbname = "";
  
                    formid = StringHelper.null2String(category.getPFormid());
                    
                    if (!formid.equals("")) {
                        forminfo = forminfoService.getForminfoById(formid);
                        formname = StringHelper.null2String(forminfo.getObjname());
                        formtbname = StringHelper.null2String(forminfo.getObjtablename());
                    }

                %>
                <tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%><!-- 表单名称 -->
					<td class="FieldValue">
					    <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?moduleid=<%=category.getModuleid()%>','formid','formidspan','0');showLayOptByFormid();"></button>
                        <input type="hidden"  name="formid" id="formid" value="<%=formid%>"/>
                        <input type="hidden"  name="formtbname" id="formtbname" value="<%=formtbname%>"/>
                        <span id="formidspan">	
                            <%if(!StringHelper.isEmpty(formname)){%>
                        		<a href="<%=request.getContextPath()%>/workflow/form/forminfomodify.jsp?moduleid=<%=moduleid%>&id=<%=formid%>"><%=formname%></a>
                        	<%}else{
                        		if(!isexistdocParent){
                        	%>
                        		<img src="<%=request.getContextPath()%>/images/base/checkinput.gif"/>
                        	<%}}%>
                        </span>
                    </td>
				</tr>                
<%

            String humresname="";
            Humres humres;
            humres=humresService.getHumresById(StringHelper.null2String(category.getHumresid()));
			if(humres!=null){
			    humresname=StringHelper.null2String(humres.getObjname());
			}

            String strDefHql="from Formlayout where formid='"+formid+"'";
            List listdef1 = ((FormlayoutService)BaseContext.getBean("formlayoutService")).findFormlayout(strDefHql);
            List layoutlist = new ArrayList();
            layoutlist.addAll(listdef1);

            strDefHql="from Reportdef where formid=(select id from Forminfo where isdelete<1 and objtype=0 and objtablename='"+formtbname+"') and isdelete<1";
            List listdef2 = ((ReportdefService)BaseContext.getBean("reportdefService")).findReportdef(strDefHql);
            List reportlist = new ArrayList();
            reportlist.addAll(listdef2);

            String mcreatelayoutid = "";
            String mviewlayoutid = "";
            String meditlayoutid = "";
            String mreflayoutid = "";
            String mprintlayoutid = "";
            String mreportid = "";
            String mdefindsource1 = "（"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")+"）";//自定义
            String mdefindsource2 = "（"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")+"）";//自定义
            String mdefindsource3 = "（"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")+"）";//自定义
            String mdefindsource4 = "（"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")+"）";//自定义
            String mdefindsource5 = "（"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")+"）";//自定义
            String mdefindsource6 = "（"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da140077")+"）";//自定义

            mcreatelayoutid = StringHelper.null2String(category.getCreatelayoutid());
            if (mcreatelayoutid.equals("")) {
                mcreatelayoutid = StringHelper.null2String(category.getPCreatelayoutid());
                mdefindsource1 = "（"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006c")+"）";//继承上级
            }
            mviewlayoutid = StringHelper.null2String(category.getViewlayoutid());
            if (mviewlayoutid.equals("")) {
                mviewlayoutid = StringHelper.null2String(category.getPViewlayoutid());
                mdefindsource2 = "（"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006c")+"）";//继承上级
            }
            meditlayoutid = StringHelper.null2String(category.getEditlayoutid());
            if (meditlayoutid.equals("")) {
                meditlayoutid = StringHelper.null2String(category.getPEditlayoutid());
                mdefindsource3 = "（"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006c")+"）";//继承上级
            }
            mreflayoutid = StringHelper.null2String(category.getReflayoutid());
            if (mreflayoutid.equals("")) {
                mreflayoutid = StringHelper.null2String(category.getPReflayoutid());
                mdefindsource4 = "（"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006c")+"）";//继承上级
            }
            
            mprintlayoutid = StringHelper.null2String(category.getPrintlayoutid());
            if (mreflayoutid.equals("")) {
                mreflayoutid = StringHelper.null2String(category.getPrintlayoutid());
                mdefindsource6 = "（"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006c")+"）";//继承上级
            }
            
            mreportid = StringHelper.null2String(category.getReportid());
            if (mreportid.equals("")) {
                mreportid = StringHelper.null2String(category.getPReportid());
                mdefindsource5 = "（"+labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006c")+"）";//继承上级
            }

%>
								<tr><!--  接口配置-->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b46000e")%><!-- 请选择接口 -->
					</td>
					<td class="FieldValue">
						<button  type="button" class=Browser onclick="javascript:getBrowser('/sysinterface/interfacemanager.jsp?objtype=category&objid=<%=category.getId()%>','interfacepage','interfacepagespan','0')"></button>
						<span id="interfacepagespan"><%=interfaceNames %></span>
					</td>
				</tr>	
				<%-- 分类管理员 --%>
                <tr style="display:none">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881ec0bdc2afd010bdc43bd200008")%>
					</td>
					<td class="FieldValue">
		        		<button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/humres/base/humresbrowser.jsp','humresid','humresidspan','0');"></button>
				        <input type="hidden" name="humresid" id="humresid" value="<%=StringHelper.null2String(category.getHumresid())%>"/>
				       <span id="humresidspan"><%=humresname%></span>
					</td>
				</tr>
                <%-- 新建布局 --%>
				<tr style="">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("40288011127e623e01127e8a35fd000b")%>
					</td>
					
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="createlayoutid" name="createlayoutid" <%if(!isexistdocParent){%>onchange='checkInput("createlayoutid","createLaynamespan")'<%}%>>
                        <option value="" <%=mcreatelayoutid==null?"selected":""%>></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            if(formlayout.getTypeid().intValue() == 2){
                            	String selected = "";
                                if(formlayout.getId().equals(mcreatelayoutid)) 
                                	selected = "selected";
                        %>
                                <option value=<%=formlayout.getId()%> <%=selected%>><%=formlayout.getLayoutname()%></option>
                        <%}}%>
                        </select>
                        <span id="createLaynamespan">
	          				<%
	          				if(StringHelper.isEmpty(mcreatelayoutid)){
	          					if(!isexistdocParent){
	          				%>
	                        	<img src="<%=request.getContextPath()%>/images/base/checkinput.gif"/>
	                        <%}}%>
          				</span>
                        <%=mdefindsource1%>
                    </td>

				</tr>
                <%-- 查看布局 --%>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("40288011127e623e01127e8c89ff000e")%>
					</td>
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="viewlayoutid" name="viewlayoutid" <%if(!isexistdocParent){%>onchange='checkInput("viewlayoutid","viewLaynamespan")'<%}%>>
                        <option value="" <%=mviewlayoutid==null?"selected":""%>></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            if(formlayout.getTypeid().intValue() == 1){
                                String selected = "";
                                if(formlayout.getId().equals(mviewlayoutid)) 
                                    selected = "selected";%>
                                <option value=<%=formlayout.getId()%> <%=selected%>><%=formlayout.getLayoutname()%></option>
                            <%}
                        }%>
                        </select>
                        <span id="viewLaynamespan">
                        	<%if(StringHelper.isEmpty(mviewlayoutid)){
                        		if(!isexistdocParent){
                        	%>
                        		<img src="<%=request.getContextPath()%>/images/base/checkinput.gif"/>
                       		<%}}%>
                        </span>
                        <%=mdefindsource2%>
                    </td>
				</tr>
                <%-- 修改布局 --%>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("40288011127e623e01127e8c1154000d")%>
					</td>
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="editlayoutid" name="editlayoutid" <%if(!isexistdocParent){%>onchange='checkInput("editlayoutid","editLaynamespan")'<%}%>>
                        <option value="" <%=meditlayoutid==null?"selected":""%>></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            if(formlayout.getTypeid().intValue() == 2){
                                String selected = "";
                                if(formlayout.getId().equals(meditlayoutid)) 
                                    selected = "selected";%>
                                <option value=<%=formlayout.getId()%> <%=selected%>><%=formlayout.getLayoutname()%></option>
                            <%}
                        }%>
                        </select>
                        <span id="editLaynamespan">
                        	<%if(StringHelper.isEmpty(meditlayoutid)){
                        		if(!isexistdocParent){
                        	%>
                        		<img src="<%=request.getContextPath()%>/images/base/checkinput.gif"/>
                       		<%}}%>
                        </span>
                        <%=mdefindsource3%>
                    </td>

				</tr>
                <%-- 引用布局display:none --%>
				<tr style="">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("40288011127e623e01127e8baa0f000c")%>
					</td>
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="reflayoutid" name="reflayoutid" >
                        <option value="" <%=mreflayoutid==null?"selected":""%>></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            if(formlayout.getTypeid().intValue() == 1){
                                String selected = "";
                                if(formlayout.getId().equals(mreflayoutid)) 
                                    selected = "selected";%>
                                <option value=<%=formlayout.getId()%> <%=selected%>><%=formlayout.getLayoutname()%></option>
                            <%}
                        }%>
                        </select>
                        <%=mdefindsource4%>
                    </td>

				</tr>
				<%-- 打印布局ID display:none --%>
				<tr>
                   <td class="FieldName" nowrap="">
                   <%=labelService.getLabelName("4028831d3710762201371076232a0293")%>
                   </td>
                   <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="printlayoutid" name="printlayoutid" >
                        <option value="" <%=mreflayoutid==null?"selected":""%>></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            if(formlayout.getTypeid().intValue() == 3){
                                String selected = "";
                                if(formlayout.getId().equals(mprintlayoutid)) 
                                    selected = "selected";%>
                                <option value=<%=formlayout.getId()%> <%=selected%>><%=formlayout.getLayoutname()%></option>
                            <%}
                        }%>
                        </select>
                        <%=mdefindsource6%>
                    </td>
               </tr>
                <%-- 关联报表 --%>
				<tr >
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881f00c9078ba010c907b291a0006")%>
					</td>
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="reportid" name="reportid" >
                        <option value="" <%=mreportid==null?"selected":""%>></option>
                        <%
                        for(int i=0; i<reportlist.size(); i++){
                            Reportdef reportdef=(Reportdef)reportlist.get(i);
                            String selected = "";
                            if(reportdef.getId().equals(mreportid)) 
                                selected = "selected";%>
                            <option value=<%=reportdef.getId()%> <%=selected%>><%=reportdef.getObjname()%></option>
                        <%}%>
                        </select>
                        <%=mdefindsource5%>
                    </td>

				</tr>
				<tr>
                   <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220021")%><!-- 数据删除类型 --></td>
                   <td class="FieldValue">
                        <select class="inputstyle" style="width:180px" id="deleteType" name="deleteType">
                        	<option <%if(!category.isReallyDelete()){ %> selected="selected" <%} %> value="0"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220022")%><!-- 逻辑删除 --></option>
                        	<option <%if(category.isReallyDelete()){ %> selected="selected" <%} %> value="1"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220023")%><!-- 物理删除 --></option>
                        </select>
                        &nbsp;<label style="font-size:12px;">(<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220024")%>)<!-- 逻辑删除为假删除,物理删除会直接删除数据 --></label>
                   </td>
               </tr>
               <tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006d")%><!-- 是否新建 --></td>
                   <td class="FieldValue">
                       <select class="inputstyle" id="isfastnew" name="isfastnew">
                           <%
                               String selected1="";
                               String selected2="";
                            if(category.getIsfastnew()==null?true:category.getIsfastnew()==0){
                               selected1="selected";
                            }else{
                                selected2="selected";
                            }
                           %>
                           <option value="0" <%=selected1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 --></option>
                           <option value="1" <%=selected2%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 --></option>
                       </select>
                   </td>
               </tr>
               <tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("4028831d37106daa0137106db6560293")%><!-- 是否打印 --></td>
                   <td class="FieldValue">
                       <select class="inputstyle" id="isprint" name="isprint">
                           <%
                               String selectedpint1="";
                               String selectedpint2="";
                            if(category.getIsprint()==null?false:category.getIsprint()==0){
                               selectedpint1="selected";
                            }else{
                                selectedpint2="selected";
                            }
                           %>
                           <option value="0" <%=selectedpint1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 --></option>
                           <option value="1" <%=selectedpint2%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 --></option>
                       </select>
                   </td>
               </tr>
                 <tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%><!-- 模块名称 --></td>
                   <td class="FieldValue">
                       <%
                         String modulename="";
                           if(!StringHelper.isEmpty(category.getModuleid()))
                               modulename= moduleService.getModule(category.getModuleid()).getObjname();


                       %>
                     <input class="inputstyle" type="text" size="30" name="modulename"  id="modulename" value="<%=modulename%>" readonly/>
                   </td>
               </tr>
                 <tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006e")%><!-- 唯一性校验字段 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" type="text" name="uniquefliter" size="30" id="uniquefliter" value="<%=StringHelper.null2String(category.getUniquefliter())%>"/>
                   </td>
               </tr>
               <tr>
                   <td class="FieldName"><%=labelService.getLabelNameByKeyId("402881e53b175fc4013b175fc5520284")%><!-- 附件保存路径 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" type="text" style="width: 232px;" id="attachSavePath" name="attachSavePath" value="<%=StringHelper.null2String(category.getAttachSavePath())%>"/>
                     (注：目前该设置仅对文档分类有效)
                   </td>
               </tr>
               <tr>
                   <td class="FieldName" ><%=labelService.getLabelNameByKeyId("402883f93c83f5c7013c83f5cd2f0000")%><!-- 文档Office附件是否可编辑 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" type="checkbox" name="docattachcanedit"  id="docattachcanedit" value="1" <% if(1==NumberHelper.string2Int(category.getDocattachcanedit(),0)){%>checked<%}%>/>
                     (注：目前该设置仅对文档分类有效)
                   </td>
               </tr>
				<tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("402881e70be696fd010be6b390970093")%><!-- 是否记录日志 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" type="checkbox" name="col1"  id="col1" value="1" <% if("1".equalsIgnoreCase(category.getCol1())) out.print("checked");%> />
                   </td>
               </tr>
				<tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006f")%><!-- 接口类名 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" name="actionClazz"  id="actionClazz" size="60" value="<%=StringHelper.null2String(category.getActionClazz())%>"/>
                   </td>
               </tr>
				<tr>
                   <td class="FieldName" nowrap=""><%=labelService.getLabelNameByKeyId("40288035251035db0125106d98880006")%><!-- 是否允许导入明细记录 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" type="checkbox" name="importDetail"  id="importDetail" value="1" <% if(category.getImportDetail()==1) out.print("checked");%> />
                   </td>
               </tr>
               <tr>
                   <td class="FieldName" ><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790070")%><!-- 是否文档审批 --></td>
                   <td class="FieldValue">
                     <input class="inputstyle" onclick="Ext.getDom('approveDiv').style.display=(this.checked?'':'none');" type="checkbox" name="isApprove"  id="isApprove" value="1" <% if(1==category.getIsApprove()) out.print("checked");%> />
                   </td>
               </tr>
               </tbody>
                <tbody id="approveDiv" style="display:<%=(category.getIsApprove()==1)?"":"none" %>;">
               <%  
            String workflowname="";
            Workflowinfo workflowinfo=workflowinfoService.get(category.getWorkflowid());
			if(workflowinfo!=null) workflowname=StringHelper.null2String(workflowinfo.getObjname());
			%>
			<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881ec0bdc2afd010bdc484834000f")%>
					</td>
					<td class="FieldValue">
		        		<button type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/workflow/workflowinfobrowser.jsp','workflowid','workflowidspan','0');getFields('docField');"></button>
				        <input type="hidden" name="workflowid" id="workflowid" value="<%=StringHelper.null2String(category.getWorkflowid())%>"/>
				        <span id="workflowidspan"><%=workflowname%></span>
					</td>
				</tr>
			 <tr>
                   <td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790071")%><!-- 文档字段 --></td>
                   <td class="FieldValue">
                     <select name="docField" id="docField"></select>
                   </td>
             </tr>

               </tbody>
               <tbody>
               <tr>
               	   <td class="FieldName"><%=labelService.getLabelNameByKeyId("402883f23f1d8141013f1d81422200a1")%><!-- 关联HTML模版 --></td>
               	   <td class="FieldValue">
				        <button type="button" class=Browser onclick="javascript:getBrowser('/document/base/wordmodulebrowser.jsp?docTemplateType=3','refHtmlTemplateId','refhtmlTemplateIdSpan','0')"></button>
				        <input type="hidden" id="refHtmlTemplateId" name="refHtmlTemplateId" value="<%=StringHelper.null2String(category.getRefHtmlTemplateId())%>">
				        <span id="refhtmlTemplateIdSpan"><%=StringHelper.null2String(wordModuleService.getWordModule(StringHelper.null2String(category.getRefHtmlTemplateId())).getObjname())%></span>
				        &nbsp;&nbsp;(注：目前该设置仅对文档分类有效)
					</td>
               </tr>
               <tr>
               	   <td class="FieldName"><%=labelService.getLabelNameByKeyId("402883f23f1d8141013f1d81422200a4")%><!-- 关联WORD模版 --></td>
               	   <td class="FieldValue">
		        		<button type="button" class=Browser onclick="javascript:getBrowser('/document/base/wordmodulebrowser.jsp?docTemplateType=4','refWordTemplateId','refWordTemplateIdSpan','0');"></button>
				        <input type="hidden" name="refWordTemplateId" id="refWordTemplateId" value="<%=StringHelper.null2String(category.getRefWordTemplateId())%>"/>
				        <span id="refWordTemplateIdSpan"><%=StringHelper.null2String(wordModuleService.getWordModule(StringHelper.null2String(category.getRefWordTemplateId())).getObjname())%></span>
						&nbsp;&nbsp;(注：目前该设置仅对文档分类有效)
					</td>
               </tr>
               <tr>
               	   <td class="FieldName"><%=labelService.getLabelNameByKeyId("402883f23f1d8141013f1d81422200a7")%><!-- 关联EXCEL模版 --></td>
               	   <td class="FieldValue">
		        		<button type="button" class=Browser onclick="javascript:getBrowser('/document/base/wordmodulebrowser.jsp?docTemplateType=5','refExcelTemplateId','refExcelTemplateIdSpan','0');"></button>
				        <input type="hidden" name="refExcelTemplateId" id="refExcelTemplateId" value="<%=StringHelper.null2String(category.getRefExcelTemplateId())%>"/>
				        <span id="refExcelTemplateIdSpan"><%=StringHelper.null2String(wordModuleService.getWordModule(StringHelper.null2String(category.getRefExcelTemplateId())).getObjname())%></span>
						&nbsp;&nbsp;(注：目前该设置仅对文档分类有效)
					</td>
               </tr>
               </tbody>
               
              
 			</table>
</div>
  <div id="divstep1">
      <h2><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0007")%><!-- 欢迎，页面配置。 请选择你所希望的菜单 --></h2>
      <br>
      <table>
          <tr>
               <td><input type="radio" name="radioname" value="1" checked onclick="step2.setSkip(false);step3.setSkip(false);step4.setSkip(true)" ><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790072")%><!-- formbase.jsp页面菜单 --></td>
          </tr>
          <tr>
              <td><input type="radio" name="radioname"  value="2" onclick="step2.setSkip(true);step3.setSkip(true);step4.setSkip(false)"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790073")%><!-- 自定义页面菜单 --></td>
          </tr>
      </table>
  </div>
   <div id="divstep2" >
      <br>
      <table>
          <tr>
					<td >
						imgfile
					</td>
					<td >
						<input type="text" name="imagfile" id="imagfile"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2"  onchange="step3.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%><!-- 浏览.. --></a>
					</td>
				</tr>
      </table>
  </div>
  <div id="divsec" >
    <table>
        <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname1"  id="menuname1" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")%><%=category.getObjname()%>" class="InputStyle2" onchange="step4.fireEvent('clientvalidation',this)" ></td><!-- 新建 -->
        </tr>
        <tr>
            <td>imgfile:</td>
            <td >
						<input type="text" name="imagfile1" id="imagfile1"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step4.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre1" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%><!-- 浏览.. --></a>
					</td>
        </tr>
        <tr>
            <td>url:</td>
            <td><textarea rows="5" cols="35"  name="urll" id="urll" class="InputStyle" onchange="step4.fireEvent('clientvalidation',this)">/workflow/request/formbase.jsp?categoryid=<%=category.getId()%></textarea></td>
        </tr>
    </table>
  </div>   
  <div id="divdisplay" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition1" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition1" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg1" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg1" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  </body>
<script type="text/javascript">
  var browserFlag;
  function BrowserImages(obj){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.children[0].value=ret;
    if(obj.parentNode.children[1].tagName=='IMG')
    obj.parentNode.children[1].src=contextPath+ret
    if(obj.parentNode.children[2].tagName=='IMG')
    obj.parentNode.children[2].src=contextPath+ret
}

<%if(category.getIsApprove()==1 && !StringHelper.isEmpty(category.getWorkflowid())){%>
Ext.onReady(function(){
	getFields('docField','<%=category.getDocField()%>');
});
<%}%>
function getFields(id,selected){
	DWRUtil.removeAllOptions(id);
	var opts=Ext.getDom(id).options;
	FormfieldService.getFeildsByWorkflow(DWRUtil.getValue('workflowid'),function(d){
		for(var i=0;i<d.length;i++){
			var opt=document.createElement("option");
			opts.add(opt);
			opt.value=d[i].id;
			opt.text=d[i].name;
			if(!Ext.isEmpty(selected) && selected==id) opt.selected=true;//如果已存在则选中状态
		}
	});
}

   function EditOK() {
		if(Ext.getDom('isApprove').checked&& (!Ext.isEmpty(Ext.getDom('workflowid').value)) && Ext.isEmpty(Ext.getDom('docField').value)){
			alert('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790078")%>');//审批流程必须指定一文档字段,用来关联需要审批的文档用!
			return;
		}
		if(Ext.getDom("isprint").value=="0"&&Ext.getDom("printlayoutid").value==""){
			alert("请选择打印布局ID！！！");
			return;
		}
		var id = document.getElementById("id").value;
		var pid = document.getElementById("pid").value;
		var oid = document.getElementById("oid").value;
		var objname = document.getElementById("objname").value;
        var objdesc = document.getElementById("objdesc").value;
		var dsporder = document.getElementById("dsporder").value;
        var formid = document.getElementById("formid").value;
        var isApprove = document.getElementById("isApprove").checked?"1":"0";
        var importDetail = document.getElementById("importDetail").checked?"1":"0";
        var workflowid = document.getElementById("workflowid").value;
        var docField = document.getElementById("docField").value;
        var humresid = document.getElementById("humresid").value;
        var createlayoutid = document.getElementById("createlayoutid").value;
        var viewlayoutid = document.getElementById("viewlayoutid").value;
        var editlayoutid = document.getElementById("editlayoutid").value;
        var reflayoutid = document.getElementById("reflayoutid").value;
        var printlayoutid = document.getElementById("printlayoutid").value;
        var reportid = document.getElementById("reportid").value;
		var uniquefliter = document.getElementById("uniquefliter").value;
		var actionClazz=document.getElementById("actionClazz").value;
        var isfastnew=document.getElementById("isfastnew").value;
        var isprint=document.getElementById("isprint").value;
        var moduleid=document.getElementById("moduleid").value;
        var col1=document.getElementById("col1").checked?"1":"0";
        var deleteType = document.getElementById("deleteType").value;
        var attachSavePath = document.getElementById("attachSavePath").value;
        var docattachcanedit=document.getElementById("docattachcanedit").checked?"1":"0";
        var refHtmlTemplateId = document.getElementById("refHtmlTemplateId").value;
        var refWordTemplateId = document.getElementById("refWordTemplateId").value;
        var refExcelTemplateId = document.getElementById("refExcelTemplateId").value;
        if(objname == ""){
			alert("<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>");
			return;
		}
        <%if(!isexistdocParent){%>
        	if(formid == "" || createlayoutid == "" || viewlayoutid == "" || editlayoutid == ""){
        		alert("<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>");
				return;
        	}
        <%}%>
		//----浏览器兼容性修改为ajax请求----
		var result;
		var url="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.category.servlet.CategoryTreeAction?action=modify";
			Ext.Ajax.request({   
					url: url,   
					method : 'post',
					params:{   
						id : id,
						pid : pid,
						oid : oid,
						dsporder : dsporder,
						objname : objname,
						objdesc : objdesc,
						formid : formid,
						actionClazz : actionClazz,
						isApprove : isApprove,
						importDetail : importDetail,
						workflowid : workflowid,
						docField : docField,
						humresid : humresid,
						createlayoutid : createlayoutid,
						viewlayoutid : viewlayoutid,
						editlayoutid : editlayoutid,
						reflayoutid : reflayoutid,
						printlayoutid : printlayoutid,
						reportid : reportid,
						uniquefliter : uniquefliter,
						isfastnew : isfastnew,
						isprint : isprint,
						moduleid : moduleid,
						col1 : col1,
						deleteType : deleteType,
						attachSavePath : attachSavePath,
						docattachcanedit:docattachcanedit,
						refHtmlTemplateId: refHtmlTemplateId,
						refWordTemplateId: refWordTemplateId,
						refExcelTemplateId: refExcelTemplateId,
						sourceurl:window.location.pathname
					}, 
					success: function (response)    
			        {   
						result=Ext.util.JSON.decode(response.responseText);
						var cid = result.id;
						var iscreate = result.iscreate;
					   	if(id != ""){
							var selectedNode = parent.categoryTree.getSelectionModel().getSelectedNode();
							if(selectedNode != null){
								var showname = getValidStr(document.getElementById("objname").value);
								//selectedNode.setText(showname);
								Ext.Ajax.request({   
									url: '/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=getLabelnameWithSync',   
									method : 'post',
									params:{   
										keyword : id,
										cnlabelname : showname
									}, 
									success: function (response)    
							        {   
							        	selectedNode.setText(response.responseText);
							        	window.location='categorymodify.jsp?id='+id;
							        },
								 	failure: function(response,opts) {    
									 	alert('Error', response.responseText);   
									}  
								});  
							}

						}else{	//create
							if(result != null){
								var tree = parent.categoryTree;
								var selectedNode = tree.getSelectionModel().getSelectedNode();
				                selectedNode.reload();
								//var treeNode = tree.getNodeById(cid);
								//tree.getSelectionModel().select(treeNode); 
								//treeNode.fireEvent('click',treeNode);  
								if(selectedNode.id!='r00t'){
					                window.location='categorymodify.jsp?id='+selectedNode.id;
								}else{
									window.location='about:blank';
								}
							}
						}
			        },
				 	failure: function(response,opts) {    
					 	alert('Error', response.responseText);   
					}  
				});  
		//------------------------------------
	}

 function showWizard(){
     wizard.show();
     step2.setSkip(false);
     step3.setSkip(false);
     step4.setSkip(true);
     step3.on('clientvalidation', function(){
                   if(document.getElementById('imagfile').value!=null&&document.getElementById('imagfile').value!='')
                   this.wizard.nextButton.setDisabled(false);//可编辑
                   else{
                   this.wizard.nextButton.setDisabled(true);  //不可编辑
                   }

           });
      step4.on('clientvalidation', function(){
          if ((document.getElementById('menuname1').value != null && document.getElementById('menuname1').value != '')&&(document.getElementById('imagfile1').value != null && document.getElementById('imagfile1').value != '')&&(document.getElementById('urll').value != null && document.getElementById('urll').value != ''))
              this.wizard.nextButton.setDisabled(false);
          else {
              this.wizard.nextButton.setDisabled(true);
          }

           });
      step5.on('clientvalidation', function(){
             if (moduleTree.getChecked().length>0)
                 this.wizard.nextButton.setDisabled(false);
             else {
                 this.wizard.nextButton.setDisabled(true);
             }

              });
 }
function AddPerm() {
    var id = getEncodeStr(document.getElementById("id").value);
    var formid = getEncodeStr(document.getElementById("formid").value);
    var formtbname = document.getElementById("formtbname").value;
    return "<%= request.getContextPath()%>/base/security/addpermission.jsp?objtable="+formtbname+"&istype=1&objid="+id+"&formid="+formid;
}
function AddNotify() {
    var id = getEncodeStr(document.getElementById("id").value);
    return url="<%= request.getContextPath()%>/base/notify/notifyDefineList.jsp?categoryId="+id;
}
  function AddIndagate(){
      var formid = getEncodeStr(document.getElementById("formid").value);
      return "<%= request.getContextPath()%>/indagate/indagateformset.jsp?formid="+formid;

  }
  var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
    browserFlag = id;
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
	}else{
		//----
	    var callback = function() {
	            try {
	                id = dialog.getFrameWindow().dialogValue;
	            } catch(e) {
	            }
	            if (id!=null) {
	            	if (id[0] != '0') {
	            		document.all(inputname).value = id[0];
	            		document.all(inputspan).innerHTML = id[1];
	                }else{
	            		document.all(inputname).value = '';
	            		if (isneed=='0')
	            		document.all(inputspan).innerHTML = '';
	            		else
	            		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

	                  }
	             }
	        }
	        if (!win) {
	             win = new Ext.Window({
	                layout:'border',
	                width:Ext.getBody().getWidth()*0.8,
	                height:Ext.getBody().getHeight()*0.75,
	                plain: true,
	                modal:true,
	                items: {
	                    id:'dialog',
	                    region:'center',
	                    iconCls:'portalIcon',
	                    xtype     :'iframepanel',
	                    frameConfig: {
	                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
	                        eventsFollowFrameLinks : false
	                    },
	                    closable:false,
	                    autoScroll:true
	                }
	            });
	        }
	        win.close=function(){
	                    this.hide();
	                    win.getComponent('dialog').setSrc('about:blank');
	                    callback();
	                } ;
	        win.render(Ext.getBody());
	        var dialog = win.getComponent('dialog');
	        dialog.setSrc(viewurl);
	        win.show();
	    }
		
	//----
 }
function showLayOptByFormid(){
	var formid = document.getElementById('formid');
	if(typeof(browserFlag) == 'undefined') return;
	Ext.Ajax.request({   
		url: '/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=getformlayoutListByFormid',   
		method : 'post',
		params:{formid : formid.value}, 
		success: function (response){   
			var results = Ext.util.JSON.decode(response.responseText);
			var resultLayout = results.resultLayout;
			DWRUtil.removeAllOptions('createlayoutid');
			DWRUtil.removeAllOptions('viewlayoutid');
			DWRUtil.removeAllOptions('editlayoutid');
			DWRUtil.removeAllOptions('reflayoutid');
			DWRUtil.removeAllOptions('printlayoutid');
			DWRUtil.removeAllOptions('reportid');
			Ext.getDom('createlayoutid').options.add(new Option('',''));
			Ext.getDom('viewlayoutid').options.add(new Option('',''));
			Ext.getDom('editlayoutid').options.add(new Option('',''));
			Ext.getDom('reflayoutid').options.add(new Option('',''));
			Ext.getDom('printlayoutid').options.add(new Option('',''));
			Ext.getDom('reportid').options.add(new Option('',''));
			for(var i = 0;i < resultLayout.length; i++){
				var opt = document.createElement("option");
				var opts = Ext.getDom('createlayoutid').options;
				if(resultLayout[i].typeid == 2){
					opts.add(opt);
					opt.value = resultLayout[i].id;
					opt.text = resultLayout[i].layoutname;
					opts = Ext.getDom('editlayoutid').options;
					opt = document.createElement("option");
				}else if(resultLayout[i].typeid == 1){
					opts = Ext.getDom('viewlayoutid').options;
					opts.add(opt);
					opt.value = resultLayout[i].id;
					opt.text = resultLayout[i].layoutname;
					opts = Ext.getDom('reflayoutid').options;
					opt = document.createElement("option");
				}else if(resultLayout[i].typeid == 3){
					opts = Ext.getDom('printlayoutid').options;
				}else if(resultLayout[i].typeid == 5){
					if(formid.value != ''){
						opt = document.createElement("option");
						opts = Ext.getDom('reportid').options;
					}
				}
				opts.add(opt);
				opt.value = resultLayout[i].id;
				if(resultLayout[i].typeid !=5){ 
					opt.text = resultLayout[i].layoutname;
				}else{ 
					opt.text = resultLayout[i].objname;
				}
			}
			
			if(isexistdocParent){
				if(formid.value == '')checkInput("formid","formidspan");
				checkInput("createlayoutid","createLaynamespan");
				checkInput("viewlayoutid","viewLaynamespan");
				checkInput("editlayoutid","editLaynamespan");
			}
		}
	}); 
}
</script>
</html>