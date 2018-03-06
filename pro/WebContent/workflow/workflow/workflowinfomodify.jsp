<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.word.service.WordModuleService"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.form.dao.FormfieldDao" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.word.model.WordModule"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%
	String id = StringHelper.null2String(request.getParameter("id"));
	WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
	Workflowinfo workflowinfo = workflowinfoService.get(id);
	LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
	SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	Selectitem selectitem = null;
	WordModuleService wordModuleService=(WordModuleService)BaseContext.getBean("wordModuleService");
	ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
	WorkflowVersionService workflowVersionService=(WorkflowVersionService)BaseContext.getBean("workflowVersionService");
	Forminfo forminfo = null;
	Formfield formfield = null;
	FormfieldDao formfieldDao  =(FormfieldDao)BaseContext.getBean("formfieldDao"); 
	String tab = StringHelper.null2String(request.getParameter("tab"));
	List selectitemlist = selectitemService.getSelectitemList("4028819d0e521bf9010e5237454d000a",null);//提醒类型
    String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
    String rootidmenu="r00t";
    String roottextmenu=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2347c00015");//用户菜单
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    Setitem gmode=setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
    String graphmode ="0";
    if(gmode!=null&&!StringHelper.isEmpty(gmode.getItemvalue())){
       graphmode=gmode.getItemvalue();
    }
    String defTitleStr1 = StringHelper.null2String(workflowinfo.getDeftitle());
  	//默认标题中含有英文双引号转换
    if(defTitleStr1.length()>0){
    	defTitleStr1 = defTitleStr1.replaceAll("\"","&#34;");
    }
  	
  	boolean isWorkflowVersionEnable=workflowVersionService.isWorkflowVersionEnable();
  	
  	WorkflowVersion workflowVersion=workflowVersionService.getWorkflowVersionByWorkflowid(id);
  	
  	String buttonStyle="";
  	if(isWorkflowVersionEnable&&workflowVersion!=null){
  		buttonStyle="display:none;";
  	}
  	
	String groupid="";
	if(workflowVersion!=null){
		groupid=workflowVersion.getGroupid();
	}
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

        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
        <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
        <script src='<%=request.getContextPath()%>/dwr/interface/FormlayoutService.js'></script>
        <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
        <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/plugin/ajaxtabs/ajaxtabs.css"/>
        <script  type='text/javascript' src='/js/workflow.js'></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/plugin/ajaxtabs/ajaxtabs.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
        <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
          <script type="text/javascript">
          var jq = jQuery.noConflict();
            var step1,step2,step3,step4,step5;
            var wizard;
            var pidvalue;
            var dlg0;
               var  menutree ;
             Ext.onReady(function() {
                 Ext.QuickTips.init();
                    menutree = new Ext.tree.TreePanel({
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
          menutree.on('checkchange',function(n,c){
     pidvalue=n.id ;
    })

                 step1 = new Ext.ux.Wiz.Card({
                     title : '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0004")%>',//选择页面配置的菜单
                     id:'s1',
                     items : [{
                         border    : false,
                         bodyStyle : 'background:none;',
                         contentEl:'div1'
                     }]
                 });

                 step2 = new Ext.ux.Wiz.Card({
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
                         new Ext.form.TextField({
                             name       : 'menuname',
                             fieldLabel : 'MenuName',
                             allowBlank : false,
                             value:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")%><%=workflowinfo.getObjname()%>',//新建
                             disabled:false
                         })
                     ]
                 });

                 step3 = new Ext.ux.Wiz.Card({
                     title        : '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0005")%>',//请选择图片
                     monitorValid : true,
                     id:'s3',
                     defaults     : {
                         labelStyle : 'font-size:11px'
                     },
                     items : [{
                         border    : false,
                         bodyStyle : 'background:none;padding-bottom:30px;',
                         contentEl      : 'div2'
                     } ]
                 });
                 step4 = new Ext.ux.Wiz.Card({
                     title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001b")%>',//自定义页面
                     id:'s4',
                     monitorValid : true,
                     defaults     : {
                         labelStyle : 'font-size:11px'
                     },
                     items : [{
                         border    : false,
                         bodyStyle : 'background:none;padding-bottom:30px;',
                         contentEl      : 'div3'
                     }]
                 });
                 step5 = new Ext.ux.Wiz.Card({
                     title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001c")%>',//选择主菜单
                     id:'s5',
                     monitorValid : true,
                     defaults     : {
                         labelStyle : 'font-size:11px'
                     },
                     items :[ {xtype:"checkbox",
                name:"checkname",
                id:"checkname",
                fieldLabel:"<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001d")%>"},//打开用户菜单
                {xtype:"label",
                text :" <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980016")%>:"},//添加到
                         menutree,
                         {
	                        border    : false,
	                        bodyStyle : 'background:none;padding-bottom:30px;',
	                        contentEl :'divdisplay'
               			 }]
                      });
                 wizard = new Ext.ux.Wiz({
                     title : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001e")%>',//生成页面菜单
                     headerConfig : {
                         title : '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379006a")%>'//欢迎页面配置
                     },
                     listeners: {
                         finish: function() {
                             saveConfig(this.getWizardData())
                         }
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
				              //-------
                     if (obj.s1.radioname == 1) { //
                         menuname = obj.s2.menuname;
                         imagfile = obj.s3.imagfile;
                         url = '<%=request.getContextPath()%>/workflow/request/workflow.jsp?&workflowid=<%=workflowinfo.getId()%>';
                         pid = pidvalue;
                     } else {
                         menuname = obj.s4.menuname1;
                         imagfile = obj.s4.imagfile1;
                         url = obj.s4.urll;
                         pid =pidvalue;
                     }
                     Ext.Ajax.request({
                         url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=createpage',
                         params:{menuname:menuname,imagfile:imagfile,url:url,pid:pid,displayPosition:displayPosition,ismenuorg:ismenuorg} ,
                         success: function() { 
                             if(Ext.getDom('checkname').checked==true){
                                           this.dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/menu/menumanager.jsp?menutype=2');
                                        this.dlg0.show()
                                     }else{
                                      Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                             Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550020")%>');//配置页面菜单成功
                             };
                         }
                     });
                 }
              dlg0 = new Ext.Window({
            layout:'border',
            closeAction:'hide',
            plain: true,
            modal :true,
            width:Ext.getBody().getViewSize().width*0.8,
            height:Ext.getBody().getViewSize().height*0.8,
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


             });
        </script>
        <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
       <script>
           function init(){
 changeType();
 cycleChange();
 onCheck('iscreateDoc');
 onCheck('isapprovable');
 onCheck('istrigger');
 onCheck('isemail');
 onCheck('issms');
 ///begin 选择提醒  add by 2011-09-28 cjl ////
 onCheck('selemail');
 onCheck('selsms');
 onCheck('selpopup');
 onCheck('selrtx');
///end 选择提醒///
 setTimeout("addFormField('0')", 300);
 //addFormField();
 setTimeout("selectField()", 300);
 //selectField();
 //changeTab();
}

//提醒类型
function changeType(){
	var remindObj=document.getElementById("remindtype");
	document.getElementById("divSelectNotify").style.display = 'none';
	document.getElementById("divForceNotify").style.display = 'none';
    
	if (remindObj.value=='4028819d0e521bf9010e5238bec2000c'){ //4028819d0e521bf9010e5238bec2000c为不提醒
    	document.all("isemail").checked = false;
    	document.all("issms").checked = false;
    	document.all("isrtx").checked = false;
        document.all("ispopup").checked = false;
        document.all("selemail").checked = false;
    	document.all("selsms").checked = false;
    	document.all("selrtx").checked = false;
        document.all("selpopup").checked = false;
  	}else if(remindObj.value=='4028819d0e521bf9010e5238bec2000e'){//强制提醒
  	    document.getElementById("divForceNotify").style.display = 'inline';   	
        document.all("selemail").checked = false;
    	document.all("selsms").checked = false;
    	document.all("selrtx").checked = false;
        document.all("selpopup").checked = false;
  	}else if(remindObj.value=='4028819d0e521bf9010e5238bec2000d'){//选择提醒
 		document.getElementById("divSelectNotify").style.display = 'inline';
        document.all("isemail").checked = false;
    	document.all("issms").checked = false;
    	document.all("isrtx").checked = false;
        document.all("ispopup").checked = false;
  	}
  	 onCheck('isemail');
	 onCheck('issms');
	 onCheck('ispopup');
	 onCheck('isrtx');
	 onCheck('selemail');
	 onCheck('selsms');
	 onCheck('selpopup');
	 onCheck('selrtx');
}
           function cycleChange(){
                var triggerdatetr = document.getElementById("triggerdatetr");
                var triggerdatetr2 = document.getElementById("triggerdatetr2");
                var triggerdate2select = document.getElementById("triggerdate2");
                var triggertimetr = document.getElementById("triggertimetr");
             if (document.all("triggercycle").value=='1'){
                triggerdatetr.style.display ='none';
                triggerdatetr2.style.display ='none';
                triggerdate2select.style.display='none';
                triggertimetr.style.display='';
             }
             if (document.all("triggercycle").value=='2'){
               triggerdatetr2.style.display ='';
               triggerdate2select.style.display='';
               triggerdatetr.style.display='none'
               triggertimetr.style.display='';
               addSelect(7);
               getDate();
             }
             if (document.all("triggercycle").value=='3'){
               triggerdatetr2.style.display ='';
               triggerdate2select.style.display='';
               triggerdatetr.style.display='none'
               triggertimetr.style.display='';
               addSelect(31);
               getDate();
             }
             if (document.all("triggercycle").value=='4'){
               triggerdatetr2.style.display ='none';
               triggerdate2select.style.display='none';
               triggerdatetr.style.display ='none';
             //  document.all("triggerdatespan").innerText="";
               triggerdatetr.style.display='';
               triggertimetr.style.display='';
             }
           }

 function onCheck(checkName) {
    //是否附件生成文档
           if(checkName=="iscreateDoc"){
              if (document.all("iscreateDoc").checked){
		         document.all("iscreateDoc").value='1';
		         document.getElementById("iscreateDocTR1").style.display='block';
		         document.getElementById("iscreateDocTR2").style.display='block';
		      }else{
		         document.all("iscreateDoc").value='0';
		         document.getElementById("iscreateDocTR1").style.display='none';
		         document.getElementById("iscreateDocTR2").style.display='none';
		      }
           }
           if(checkName=="isShowInMobile"){
              if (document.all("isShowInMobile").checked){
		         document.all("isShowInMobile").value='1';
		         //document.getElementById("isShowInMobileTR").style.display='block';
		      }else{
		         document.all("isShowInMobile").value='0';
		         //document.getElementById("isShowInMobileTR").style.display='none';
		      }
           }
//是否有效
    if (checkName=="isactive") {
       if (document.all("isactive").checked){
         document.all("isactive").value='1';
       }else{
         document.all("isactive").value='0';
       }
    }
//是否审批流程
    if (checkName=="isapprovable") {
      var approveobjTr = document.getElementById("approveobjtr");
      var approveobjTr1 = document.getElementById("approveobjtr1");
      var approveobjSelect = document.getElementById("approveobj");
      var approveobjtypeSelect = document.getElementById("approveobjtype");
      if (document.all("isapprovable").checked){
        approveobjTr.style.display='';
        approveobjTr1.style.display='';
        approveobjSelect.style.display='';
        approveobjtypeSelect.style.display='';
        document.all("isapprovable").value='1';
      }else{
         approveobjTr.style.display='none';
         approveobjTr1.style.display='none';
         approveobjSelect.style.display='none';
         approveobjtypeSelect.style.display='none';
         document.all("isapprovable").value='0';
      }
    }
//是否触发
    if (checkName=="istrigger"){
      var triggercycletr = document.getElementById("triggercycletr");
      var triggercycleselect = document.getElementById("triggercycle");
      var triggertimetr = document.getElementById("triggertimetr");
      var  triggerdatetr = document.getElementById("triggerdatetr");
      var triggerdatetr2 = document.getElementById("triggerdatetr2");
      var triggerdate2select = document.getElementById("triggerdate2");

      if (document.all("istrigger").checked) {
         triggercycletr.style.display ='';
         triggercycleselect.style.display ='';
         triggertimetr.style.display ='';
     //    triggerdatetr2.style.display ='';
      //   triggerdate2select.style.display ='';
      //   triggerdatetr.style.display ='';
       //  triggercycleselect.options[0].selected=true;
         document.all("istrigger").value='1';
      }else{
         triggercycletr.style.display ='none';
         triggercycleselect.style.display ='none';
         triggertimetr.style.display ='none';
         triggerdatetr2.style.display ='none';
         triggerdate2select.style.display ='none';
         triggerdatetr.style.display ='none';
        // cycleChange();
         document.all("istrigger").value='0';
      }
    }
     //是否邮件
  if (checkName=="isemail") {
     var emailmodeltr = document.getElementById("emailmodeltr");
     if (document.all("isemail").checked){
       //emailmodeltr.style.display='';
       document.all("isemail").value='1';
     }else{
       //emailmodeltr.style.display='none';
       document.all("isemail").value='0';
     }
  }
//是否消息
  if (checkName=="issms"){
    var msgmodeltr = document.getElementById("msgmodeltr");
    if (document.all("issms").checked) {
       //msgmodeltr.style.display='';
       document.all("issms").value='1';
    }else{
       //msgmodeltr.style.display='none';
       document.all("issms").value='0';
    }
  }

 ///////////////////////////////////选择提醒//////////////////////////////////////////
       //选择邮件
  if (checkName=="selemail") {
     if (document.all("selemail").checked){
       document.all("selemail").value='1';
     }else{
       document.all("selemail").value='0';
     }
  }
//选择消息
  if (checkName=="selsms"){
    if (document.all("selsms").checked) {
       document.all("selsms").value='1';
    }else{
       document.all("selsms").value='0';
    }
  }
//选择否弹出式
  if (checkName=="selpopup") {
     if (document.all("selpopup").checked){
       document.all("selpopup").value='1';
     }else{
       document.all("selpopup").value='0';    
     } 
  }
//选择rtx
  if (checkName=="selrtx"){
    if (document.all("selrtx").checked) {
       document.all("selrtx").value='1';
    }else{
       document.all("selrtx").value='0';   
    }
  }
    ///////////////////////////////////选择提醒//////////////////////////////////////////

}

       </script>
<script type="text/javascript">
      //附件生成文档目录
	  function changeDocType(){
			   var fid = document.getElementsByName("formid")[0].value;
				if(fid && fid.length==32){
				  DataService.getValues(createList_doc,"select id,labelname from formfield where formid=\'"+fid+"\' and isdelete = 0 and htmltype=6 and fieldtype=\'402883ee3205018e0132056968450005\'");
				}else{
				  DWRUtil.removeAllOptions("createDocField");
				}
			}
			
	 function createList_doc(data) //第一个必须添加空进去
		{
		    DWRUtil.removeAllOptions("createDocField");
		    DWRUtil.addOptions("createDocField",["  "]);
	        DWRUtil.addOptions("createDocField", data,"id","labelname");
		}
	
</script>
	</head>
	<body onload="javascript:init();changeTab();">
		<br />
		<ul id="maintab" class="shadetabs">
			<li class="selected">
				<a id=tab1 href="#default" rel="ajaxcontentarea">
					<%=labelService.getLabelName("402881ec0bdc2afd010bdd32351a0021")%><!-- 流程信息-->
				</a>
			</li>

			<li>
				<a id=tab2 href="<%=request.getContextPath()%>/workflow/workflow/nodeinfolist.jsp?workflowid=<%=id%>" rel="ajaxcontentarea">
					<%=labelService.getLabelName("402881ee0c715de3010c7250d6b5007e")%><!-- 节点管理-->
				</a>
			</li>
            <%if(graphmode.equals("0")){%>
			<li>
				<a id=tab3 href="<%=request.getContextPath()%>/workflow/workflow/exportview.jsp?workflowid=<%=id%>" rel="ajaxcontentarea">
					<%=labelService.getLabelName("402881ee0c715de3010c725142490081")%><!-- 出口管理-->
				</a>
			</li>
            <%}%>
			<li>
				<a id=tab4  href="<%=request.getContextPath()%>/workflow/form/formlayoutlist2.jsp?workflowid=<%=id%>" rel="ajaxcontentarea"><%=labelService.getLabelName("402881ee0c715de3010c7251b2340084")%><!-- 表单布局-->
				</a>
			</li>
			<li>
				<a id=tab5  href="<%=request.getContextPath()%>/workflow/workflow/workflowdoctype.jsp?workflowid=<%=id%>" rel="ajaxcontentarea"><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a000c")%><!--关联数据授权--><!-- 文档字段类型-->
				</a>
			</li>
			<li>
				<a id=tab6  href="<%=request.getContextPath()%>/workflow/workflow/workflowinclude.jsp?workflowid=<%=id%>" rel="ajaxcontentarea">流程全局脚本</a>
			</li>
			<%if(isWorkflowVersionEnable){%>
			<li>
				<a id=tab7  href="<%=request.getContextPath()%>/workflow/version/workflowversionlist.jsp?workflowid=<%=id%>" rel="ajaxcontentarea">流程版本管理</a>
			</li>
			<%}%>
			
		</ul>
		<div id="ajaxcontentarea" class="contentstyle">
			<!--页面菜单开始-->
			<%pagemenustr += "{S," +labelService.getLabelName("402881e60aabb6f6010aabbda07e0009") + ",javascript:onSubmit()}";
              pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:onReturn()}";
              pagemenustr += "{M,"+labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550016")+",javascript:showWizard()}";//生成菜单
              pagemenustr += "{G,"+labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039")+",javascript:onDraw('"+id+"','"+workflowinfo.getObjname()+"')}";//流程图
              pagemenustr += "{C,"+labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a000d")+",javascript:onCopy('"+id+"','"+workflowinfo.getObjname()+"')}";//流程复制
              pagemenustr += "{T,"+labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a000e")+",javascript:nodeonCreate('/base/security/addpermission.jsp?objid="+id+"&&objtable=workflowinfo&&istype=1&&formid="+workflowinfo.getFormid()+"&&workflowshare=1')}";//流程共享
              if(isWorkflowVersionEnable){
                  pagemenustr += "{V,"+"新增版本"+",javascript:addVersion('"+id+"','"+workflowinfo.getObjname()+"')}";//新增版本
              }
            %>
			<div id="pagemenubar" style="z-index:100;"></div>
			<%@ include file="/base/pagemenu.jsp"%>
			<!--页面菜单结束-->
			<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=modify" name="EweaverForm" method="post">
				<input type="hidden" name="id" value="<%=id%>">
                <input type="hidden" name="moduleid" value="<%=workflowinfo.getModuleid()%>">
				<img src="<%=request.getContextPath()%>/images/colse.gif"  width=0px height=0px border=0 onload="init();">
				<table class=noborder>
					<colgroup>
						<col width="15%">
						<col width="85%">
					</colgroup>
					<tr class=Title>
						<th colspan=2 nowrap>
							<%=labelService.getLabelName("402881ec0bdc2afd010bdd32351a0021")%><!-- 流程信息-->
						</th>
						<!-- 流程信息 -->
					</tr>
					<tr>
						<td class="Line" colspan=2 nowrap></td>
					</tr>
					<tr>
						<!--  流程名称 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c72411ed60060")%><!-- 流程名称-->
						</td>
						<td class="FieldValue">
							<input type="text" class="InputStyle2" style="width:90%" name="objname" value="<%=StringHelper.null2String(workflowinfo.getObjname())%>" onChange="checkInput('objname','objnamespan')"/>
						    <span id="objnamespan"/></span>
							<%=labelCustomService.getLabelPicHtml(workflowinfo.getId(), LabelType.Workflowinfo) %>
						</td>
					</tr>
					<tr style="display:none;" >
						<!--  流程类型 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881e50c6d5390010c6d5d5d220007")%><!-- 流程类型-->
						</td>
						<td class="FieldValue">

							<input type="hidden" name="objtype" value="<%=StringHelper.null2String(workflowinfo.getObjtype())%>" />
							<input type="hidden" name="tab" value="<%=tab%>" />
						</td>
					</tr>
					<tr>
						<!--  流程表单 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c7243a5fa0069")%><!-- 流程表单-->
						</td>
						<td class="FieldValue">
							<input type="button" style="<%=buttonStyle%>" class=Browser onclick="javascript:getBrowser('/workflow/form/forminfobrowser.jsp?moduleid=<%=moduleid%>','formid','formidspan','0');addFormField('1');" />
							<input type="hidden" name="formid" id="formid" value="<%=StringHelper.null2String(workflowinfo.getFormid())%>" onChange="javascript:addFormField('0');checkInput('formid','formidspan');" />
							<%String formname = "";
								if (!StringHelper.null2String(workflowinfo.getFormid()).equals("")) {
									forminfo = forminfoService.getForminfoById(StringHelper
											.null2String(workflowinfo.getFormid()));
									if (forminfo != null)
										formname = forminfo.getObjname();
								}
							%>
							<span id="formidspan" />
								<a href="<%=request.getContextPath()%>/workflow/form/forminfomodify.jsp?isworkflow=1&moduleid=<%=moduleid%>&id=<%=StringHelper
									.null2String(workflowinfo.getFormid()) %>"><%=formname%></a>
							</span>
						</td>
					</tr>
					<tr>
						<!-- 是否有效 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402881e70c864b41010c867b2eb40010")%><!--流程状态--><!-- 是否有效-->
						</td>
						<td class="FieldValue">
                            <select name='isactive'>
                                <option value="1" <% if (StringHelper.null2String(workflowinfo.getIsactive()).equals("1")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%></option><!-- 显示 -->
                                <option value="2" <% if (StringHelper.null2String(workflowinfo.getIsactive()).equals("2")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%></option><!-- 隐藏 -->
                                <option value="0" <% if (StringHelper.null2String(workflowinfo.getIsactive()).equals("0")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0003")%></option><!-- 禁用 -->
                            </select>
						</td>
					</tr>
					<tr><!-- 是否公文 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028803221c7e69f0121c81e6d830002")%>
					</td>
					<td class="FieldValue">
                        <input  type='checkbox' name='isdocument' value='1' <%if(StringHelper.null2String(workflowinfo.getIsDoc()).equalsIgnoreCase("1")) out.print("checked"); %> onclick="onCheckDocument(this)"/>
					</td>
				</tr>
				<%	String docTempId=StringHelper.null2String(workflowinfo.getDocTemplate());
					  String docTempName="";
					  if(!StringHelper.isEmpty(docTempId)){
					  	WordModule wm=wordModuleService.getWordModule(docTempId);
					  	if(wm!=null)docTempName=wm.getObjname();
					  }
					String docTempShow="none";
					if(StringHelper.null2String(workflowinfo.getIsDoc()).equalsIgnoreCase("1")) docTempShow="";
				%>
				<tr id="docTemplateRow" style="display:<%=docTempShow%>;">
					<td class="FieldName" nowrap><!-- 套红模板-->
                         <%=labelService.getLabelName("4028803221c7e69f0121c821a58c0003")%>
					</td>
					<td class="FieldValue">
					   <input type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/document/base/wordmodulebrowser.jsp?docTemplateType=4','docTemplate','docTemplatespan','0');" />
					   <input type="hidden" id="docTemplate" value="<%=docTempId%>" name="docTemplate"/><span id="docTemplatespan"><%=docTempName%></span>
					</td>
				</tr>
					<tr style="display:none">
						<!-- 是否审批流程 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c72581f1c0087")%><!-- 是否审批流程-->
						</td>
						<td class="FieldValue">
							<input type='checkbox' name='isapprovable' value="<%=StringHelper.null2String(workflowinfo.getIsapprovable())%>" <% if (StringHelper.null2String(workflowinfo.getIsapprovable()).equals("1")){%> <%="checked"%> <%}%>
								onClick="javascript:onCheck('isapprovable')" />
						</td>
					</tr>
					<tr id="approveobjtr" style="display:none">
						<!-- 审批对象 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c7258808e008a")%><!-- 审批对象-->
						</td>
						<td class="FieldValue">
							<select class="inputstyle" name="approveobj" id="approveobj">

							</select>
						</td>
					</tr>
					<tr id="approveobjtr1" style="display:none">
						<!-- 审批对象类型 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881e70cc93649010cca10a7d40008")%><!-- 审批对象类型-->
						</td>
						<td class="FieldValue">
							<select class="inputstyle" name="approveobjtype" id="approveobjtype">

							</select>
						</td>
					</tr>
					<tr><!-- 提醒类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028819d0e521bf9010e525d08b70010")%><!-- 提醒类型-->
					</td>
					<td  class="FieldValue">
                       <select  class="inputstyle"  name="remindtype" id="remindtype" onChange="javascript:changeType()">
                       <%for(int i=0;i<selectitemlist.size();i++){
                       selectitem=(Selectitem)selectitemlist.get(i);
                       %>
					   <option value="<%=selectitem.getId()%>" <%if(selectitem.getId().equals(workflowinfo.getRemindtype())){%> selected<%}%>>
						<%=selectitem.getObjname()%>
					   </option>
					   <%}%>
                       </select>
                       
                       &nbsp;
                       <!-- 选择提醒方式 -->
                       <div id="divSelectNotify" style="display:<%="4028819d0e521bf9010e5238bec2000d".equals(workflowinfo.getRemindtype())?"inline":"none"%>;">
                       邮件<input type='checkbox' name='selemail' value="<%=StringHelper.null2String(workflowinfo.getSelemail())%>" <% if (StringHelper.null2String(workflowinfo.getSelemail()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selemail')" />
                       短信<input type='checkbox' name='selsms' value="<%=StringHelper.null2String(workflowinfo.getSelsms())%>" <% if (StringHelper.null2String(workflowinfo.getSelsms()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selsms')" />
                       弹出窗口<input type='checkbox' name='selpopup' value="<%=StringHelper.null2String(workflowinfo.getSelpopup())%>" <% if (StringHelper.null2String(workflowinfo.getSelpopup()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selpopup')" />
                       即时通讯<input type='checkbox' name='selrtx' value="<%=StringHelper.null2String(workflowinfo.getSelrtx())%>" <% if (StringHelper.null2String(workflowinfo.getSelrtx()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selrtx')"/>
                       </div>
                       
                       <!-- 强制提醒方式 -->
                       <div id="divForceNotify" style="display:<%="4028819d0e521bf9010e5238bec2000e".equals(workflowinfo.getRemindtype())?"inline":"none"%>;">
                       邮件<input type='checkbox' name='isemail' value="<%=StringHelper.null2String(workflowinfo.getIsemail())%>" <% if (StringHelper.null2String(workflowinfo.getIsemail()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('isemail')" />
                       短信<input type='checkbox' name='issms' value="<%=StringHelper.null2String(workflowinfo.getIssms())%>" <% if (StringHelper.null2String(workflowinfo.getIssms()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('issms')" />
                       弹出窗口<input type='checkbox' name='ispopup' value="1" <% if (StringHelper.null2String(workflowinfo.getIspopup()).equals("1")){%><%="checked"%><%}%> />
                       即时通讯<input type='checkbox' name='isrtx' value=1 <% if (workflowinfo.getIsrtx()!=null&&workflowinfo.getIsrtx().intValue()==1){%><%="checked"%><%}%> onClick="javascript:onCheck('isrtx')" />
                       </div>
					</td>
					</tr>

				<!-- begin 是否在手机版中显示此流程-->
				 <tr id="isShowInMobileTR">
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402882443551562e0135515639a20000")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isShowInMobile' value='1' <% if (workflowinfo.getIsShowInMobile()!=null&&workflowinfo.getIsShowInMobile().intValue()==1){%><%="checked"%><%}%>  onClick="javascript:onCheck('isShowInMobile');" />
					</td>
				  </tr>
				<!-- begin 是否流程附件生成文档 -->
				 <tr style="display:none; ">
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028835d32130dfd013213405bef0003")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='iscreateDoc' id="iscreateDoc" value="" <% if (workflowinfo.getIscreateDoc()!=null&&workflowinfo.getIscreateDoc().intValue()==1){%><%="checked"%><%}%> onClick="javascript:onCheck('iscreateDoc')" />
					</td>
				  </tr>
				  
				  <tr id="iscreateDocTR1" style="display:none"><!-- 流程附件生成文档目录 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028835d32130dfd01321340b4f10004")%><!-- 流程附件生成文档目录-->
					</td>
					<td  class="FieldValue" >
		                       <!-- 设置目录 -->
		                       <script type="text/javascript">
		                             /**
										     选择附件生成文档目录
										     */
										function add_dir(data){
											 document.all("defaultDocDirspan").innerHTML = data[0].objname;
										 }
										     
										function getBrowserNew(viewurl,inputname,inputspan,isneed){
											var id;
										    try{
										    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
										    }catch(e){}
											if (id!=null) {
											if (id[0] != '0') {
												document.all(inputname).value = id[0];
												DWREngine.setAsync(false);//同步 
												DataService.getValues(add_dir,"select objname from category where id=\'"+id[0]+"\' and isdelete =0");
										    }else{
												document.all(inputname).value = '';
												if (isneed=='0')
												document.all(inputspan).innerHTML = '';
												else
												document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
										        }
										   }
										 }
		                       </script>
		                       <span id="createDocDir3span" >
		                            <%
		                                 String img ="<img src="+request.getContextPath()+"/images/base/checkinput.gif>";
							             String docdir ="";
							             String docid ="";
						                 String sql="select id,objname from CATEGORY where id='"+StringHelper.null2String(workflowinfo.getDefaultDocDir())+"' AND isdelete =0";
						                 DataService dataService = new DataService();
						                 List<Map<String,Object>> list1 = dataService.getValues(sql);
						                 for(int i=0;i<list1.size();i++){
						                    Map map = list1.get(i);
						                    docid = map.get("id").toString();
						                    docdir =map.get("objname").toString();
						                 }
						            %>
						               <input type="hidden" name="defaultDocDir" id="defaultDocDir" value="<%=docid%>" onchange="javascript:checkInput('defaultDocDir','defaultDocDirspan')"/>
									   <input type="button" class=Browser onclick="javascript:getBrowserNew('/base/refobj/treeviewerBrowser.jsp?id=402881182b0b5c99012b0bb445f1010c&rootID=40288148117d0ddc01117d8c36e00dd4','defaultDocDir','defaultDocDirspan','0');" />
									   <span id="defaultDocDirspan" /><%=docdir%></span>
		                       </span>
					</td>
				 </tr>
				   <tr id="iscreateDocTR2" style="display:none"><!-- 流程附件生成文档目录 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028835d32130dfd0132134109d50005")%><!-- 流程附件生成文档目录-->
					</td>
					<td  class="FieldValue" >
							  <span id="createDocDir2span" ><%=labelService.getLabelName("4028835d32130dfd0132134168a00006")%>
		                       <!-- 相关字段 -->
		                         <select  class="inputstyle"  name="createDocField" id="createDocField" >
		                         <option value="">&nbsp;&nbsp;</option>
			                      <% 
									if (!StringHelper.null2String(workflowinfo.getFormid()).equals("")) {
										if (forminfo == null){
											forminfo = forminfoService.getForminfoById(StringHelper.null2String(workflowinfo.getFormid()));
										}else{
											 List list = formfieldDao.getAllFieldByFormId(forminfo.getId());
			                       for(int i=0;i<list.size();i++){
			                    	   formfield = (Formfield)(list.get(i));
			                    	   if(formfield.getHtmltype()==6 && "402883ee3205018e0132056968450005".equals(formfield.getFieldtype())){
			                       %>
								   <option value="<%=formfield.getId()%>" <%if(formfield.getId().equals(workflowinfo.getCreateDocField())){%> selected<%}%>>
									<%=formfield.getLabelname()%>
								   </option>
								   <%}}}}%>
		                         </select>
		                       </span>
					</td>
				 </tr>
				<!-- end 是否流程附件生成文档 -->
					<tr>
						<!-- 是否触发 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c7258e5df008d")%><!-- 是否触发-->
						</td>
						<td class="FieldValue">
							<input type='checkbox' name='istrigger' value="<%=StringHelper.null2String(workflowinfo.getIstrigger())%>" <% if (StringHelper.null2String(workflowinfo.getIstrigger()).equals("1")){%> <%="checked"%> <%}%> onClick="javascript:onCheck('istrigger')" />
						</td>
					</tr>
					<tr id="triggercycletr" style="display:none">
						<!-- 触发周期 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c72596ebf0090")%><!-- 触发周期-->
						</td>
						<td class="FieldValue">
							<select class="inputstyle" name="triggercycle" id="triggercycle" onChange="javascript:cycleChange()">
								<option value="1" <%if (StringHelper.null2String(workflowinfo.getTriggercycle()).equals("1")){%> <%="selected"%> <%}%>>
									<%=labelService.getLabelName("402881ee0c715de3010c7259da670093")%><!-- 每日-->
								</option>
								<option value="2" <%if (StringHelper.null2String(workflowinfo.getTriggercycle()).equals("2")){%> <%="selected"%> <%}%>>
									<%=labelService.getLabelName("402881ee0c715de3010c725a3d910096")%><!-- 每周-->
								</option>
								<option value="3" <%if (StringHelper.null2String(workflowinfo.getTriggercycle()).equals("3")){%> <%="selected"%> <%}%>>
									<%=labelService.getLabelName("402881ee0c715de3010c725aa0f80099")%><!-- 每月-->
								</option>
								<option value="4" <%if (StringHelper.null2String(workflowinfo.getTriggercycle()).equals("4")){%> <%="selected"%> <%}%>>
									<%=labelService.getLabelName("402881ee0c715de3010c725b0621009c")%><!-- 每年-->
								</option>
							</select>
						</td>
					</tr>


					<tr id="triggerdatetr" style="display:none">
						<!-- 触发日期 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c725b7327009f")%><!-- 触发日期-->
						</td>
							<td class="FieldValue">
						<input type=text class=inputstyle size=10 name="triggerdate" value="<%if (StringHelper.null2String(workflowinfo.getTriggercycle()).equals("4")){%><%=StringHelper.null2String(workflowinfo.getTriggerdate())%><%}%>" onclick="WdatePicker()">
							</td>
					</tr>
					<tr id="triggerdatetr2" style="display:none">
						<!-- 触发日期2 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c725c5dde00a2")%><!-- 触发日期2-->
						</td>
						<td class="FieldValue">
						    <input type="hidden" name="tempdate" value="<%=StringHelper.null2String(workflowinfo.getTriggerdate())%>"  />
							<select class="inputstyle" name="triggerdate2" id="triggerdate2" onChange="getDate()">

							</select>
						</td>
					</tr>

					<tr id="triggertimetr" style="display:none">
						<!-- 触发时间 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c725d619d00a5")%><!-- 触发时间-->
						</td>
						<td class="FieldValue">
						<input type=text class=inputstyle size=10 name="triggertime" value="<%=StringHelper.null2String(workflowinfo.getTriggertime())%>" onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})">
						</td>
					</tr>
					<tr>
						<!-- 是否允许代理 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402883fa3bda3e74013bda3e7a6e0000")%><!-- 是否允许代理-->
						</td>
						<td class="FieldValue">
							<input type='checkbox' name='isPermitActing' value="1" <% if (StringHelper.null2String(workflowinfo.getIsPermitActing()).equals("1")){%> <%="checked"%> <%}%> />
						</td>
					</tr>
					<tr>
						<!-- 是否使用草稿布局 -->
						<td class="FieldName" nowrap>
							是否使用草稿布局<!-- 是否使用草稿布局-->
						</td>
						<td class="FieldValue">
							<input type='checkbox' name='isUseDraftlayout' value="1" <% if (StringHelper.null2String(workflowinfo.getIsUseDraftlayout()).equals("1")){%> <%="checked"%> <%}%> />
						</td>
					</tr>
					<tr>
						<!--  帮助文档 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c725dd26f00a8")%><!-- 帮助文档-->
						</td>
						<td class="FieldValue">
							<!-- <input type="button" class=Browser onclick="javascript:getBrowser('/document/base/docbasebrowser.jsp','helpdoc','helpdocspan','0');" /> -->
							<input type="button" class=Browser onclick="javascript:getrefobj('helpdoc','helpdocspan','402881e70bc70ed1010bc710b74b000d','','/document/base/docbaseview.jsp?id=','0');" />
							<input type="hidden" name="helpdoc" value="<%=StringHelper.null2String(workflowinfo.getHelpdoc())%>" />
							<%String docname = "";
			                  DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
			                  if (workflowinfo.getHelpdoc()!=null)
		                        docname = docbaseService.getSubjectByDoc(StringHelper.null2String(workflowinfo.getHelpdoc()));
		                   	%>
							<span id="helpdocspan" />
								<%=docname%>
							</span>
						</td>
					</tr>
					<tr>
						<!--  默认标题 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ec0bdc2afd010bdc44cf81000a")%><!-- 默认标题-->
						</td>
						<td class="FieldValue">
							<input type="text" maxlength="128" class="InputStyle2" style="width:90%" name="deftitle" value="<%=defTitleStr1%>" onChange="checkInput('deftitle','deftitlespan')"/>
						    <span id="deftitlespan"/></span>
						</td>
					</tr>
                    <tr><!--  排序参数 -->
                        <td class="FieldName" nowrap>
                              <%=labelService.getLabelName("402880371b9ff70f011b9ffffed70004")%><!-- 排序参数-->
                        </td>
                        <td class="FieldValue">
                           <input type="text" class="InputStyle2" style="width:50%" name="dsporder" value="<%=StringHelper.null2String(workflowinfo.getDsporder())%>" />
                        </td>
                    </tr>
                    <tr>
	                   <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220021")%></td><!-- 数据删除类型 -->
	                   <td class="FieldValue">
	                        <select class="inputstyle" style="width:120px" id="deleteType" name="deleteType">
	                        	<option <%if(!workflowinfo.isReallyDelete()){ %> selected="selected" <%} %> value="0"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220022")%></option><!-- 逻辑删除 -->
	                        	<option <%if(workflowinfo.isReallyDelete()){ %> selected="selected" <%} %> value="1"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220023")%></option><!-- 物理删除 -->
	                        </select>
	                        &nbsp;<label style="font-size:12px;">(<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220024")%>)</label><!-- 逻辑删除为假删除,物理删除会直接删除数据 -->
	                   </td>
                	</tr>
                    <tr>
						<!--  流程描述 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c725e939000ab")%><!-- 流程描述-->
						</td>
						<td class="FieldValue">
							<TEXTAREA STYLE="width=95%" class=InputStyle rows=5 name="objdesc"><%=StringHelper.null2String(workflowinfo.getObjdesc())%>
                     </TEXTAREA>
						</td>
					</tr>

				</table>
			</form>

		</div>
        <div id="divObj" style="display:none">
            <table id="displayTable">
                <thead>
                <tr><th colspan="8" style="background-color:#f7f7f7;height:22"><b><span style="color:green"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0011")%><!-- 无法删除 --></span>,<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0012")%><!-- 您选择的布局正被以下权限设置所引用,请先删除以下权限 -->:</b></th></tr>
                <tr style="background-color:#f7f7f7;height:22">
                <!--<th align="center"><b>ObjId</b></th>-->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7cb27c0029")%></b></th><!-- 权限类型 -->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39340039")%></b></th><!-- 所属分类 -->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0013")%></b></th><!-- 所属节点 -->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%></b></th><!-- 流程名称 -->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa8999a3001b")%></b></th><!-- 操作类型 -->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0014")%></b></th><!-- 限制对象 -->
                <th align="center" width="40"></th>
                <th align="center"><a href="javascript:goDelete()"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%></a></th><!-- 删除 -->
                </tr>
                </thead>

                <tbody id="refreshBody"><!-- 在这刷新 -->
                </tbody>
            </table>
        </div>
        <div id="showDivObj" style="position:absolute; width:0px; height:22px; z-index:100; visibility:visible; left: 0px; top: 200px;display:none;background-color:#666666">
            <table>
                <thead>
                <tr><th colspan="5" style="background-color:#f7f7f7;height:20"><a id="msg" href="javascript:void(0)"></a></th></tr>
                </thead>
            </table>
        </div>
        <input type="hidden" id="checkLayoutId"/>
      <div id="div1" style="display:none;">
      <h2><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0007")%></h2><!-- 欢迎，页面配置。 请选择你所希望的菜单 -->
      <br>
      <table>
          <tr>
               <td><input type="radio" name="radioname" value="1" checked onclick="step2.setSkip(false);step3.setSkip(false);step4.setSkip(true)" ><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0008")%></td><!-- workflow.jsp页面 -->
          </tr>
          <tr>
              <td><input type="radio" name="radioname"  value="2" onclick="step2.setSkip(true);step3.setSkip(true);step4.setSkip(false)"><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0009")%></td>
          </tr>
      </table>
  </div>
   <div id="div2" style="display:none;">
      <br>
      <table>
          <tr>
					<td >
						imgfile
					</td>
					<td >
						<input type="text" name="imagfile" id="imagfile"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step3.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%></a><!-- 浏览.. -->
					</td>
				</tr>
      </table>
  </div>

  <div id="div3" style="display:none;">
    <table>
        <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname1" id="menuname1" value="<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")%><%=workflowinfo.getObjname()%>" class="InputStyle2" onchange="step4.fireEvent('clientvalidation',this)"></td><!-- 新建 -->
        </tr>
        <tr>
            <td>imgfile:</td>
            <td >
						<input type="text" name="imagfile1" id="imagfile1"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step4.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre1" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%></a><!-- 浏览.. -->
					</td>
        </tr>
        <tr>
            <td>url:</td>
            <td><textarea rows="5" cols="35"  name="urll" id="urll" class="InputStyle" onchange="step4.fireEvent('clientvalidation',this)">/workflow/request/workflow.jsp?&workflowid=<%=workflowinfo.getId()%></textarea></td>
        </tr>
    </table>
  </div>
  
  <div id="divdisplay" style="display:none;">
    <table border="0">
        <tr>
					<td width="20%">菜单显示位置:</td> 
					<td>
						  	<input type="checkbox" name="displayPosition1" value="left"  checked="checked" />左侧
						  	<input type="checkbox" name="displayPosition1" value="top"  />顶部
					</td>
		</tr>
        <tr>
					<td width="20%">是否同步组织单元:</td> 
					<td>
						<input type="radio" name="ismenuorg1" checked="checked" value="1">是
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg1" value="0">否
					</td>
		</tr>
    </table>
  </div>
<script language="javascript">

function onCheckDocument(obj){
	document.getElementById('docTemplateRow').style.display=obj.checked?'':'none';
}
function BrowserImages(obj){
	var ret=openDialog(contextPath+"/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=contextPath+ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=contextPath+ret
}

	var req;
	var selectindex = 0 ;
	function checkShow(fieldid){
		if (document.all(fieldid+"isshow").checked == false ){
			document.all(fieldid+"iseditable").checked = false ;
			document.all(fieldid+"notnull").checked = false ;
			document.all("all_isshow").checked = false ;
		}
	}

	function checkEditable(fieldid){
		if (document.all(fieldid+"iseditable").checked == true ){
			document.all(fieldid+"isshow").checked = true ;
		}
		else {
			document.all("all_iseditable").checked = false ;
			document.all(fieldid+"notnull").checked = false ;
		}
	}

	function checkNotnull(fieldid){
		if (document.all(fieldid+"notnull").checked == true ){
			document.all(fieldid+"iseditable").checked = true ;
			document.all(fieldid+"isshow").checked = true ;
		}
		else {
			document.all("all_notnull").checked = false ;
		}
	}

	function allisshow(){
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];
			var checkbox_isshow = document.all("all_isshow");
			if (checkbox_isshow.checked == true ){
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = true ;
				}
			}
			else {
				document.all("all_iseditable").checked = false ;
				document.all("all_notnull").checked = false ;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = false ;
					document.all(fieldid+"iseditable").checked = false ;
					document.all(fieldid+"notnull").checked = false ;
				}
			}
		}
	}

	function alliseditable(){

		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];
			var checkbox_editable = document.all("all_iseditable");
			if (checkbox_editable.checked == true ){
				document.all("all_isshow").checked = true;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = true ;
					document.all(fieldid+"iseditable").checked = true ;
				}
			}
			else {
				document.all("all_notnull").checked = false ;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"iseditable").checked = false ;
					document.all(fieldid+"notnull").checked = false ;
				}
			}
		}
	}

	function allisnotnull(){
		var tables = document.getElementsByTagName("table");
		if ( tables.length == 0 ) return ;
		for (var t=0;t<tables.length;t++){
			var table = tables[t];
			var checkbox_notnull = document.all("all_notnull");
			if ( checkbox_notnull.checked == true ){
				document.all("all_isshow").checked = true ;
				document.all("all_iseditable").checked = true ;
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText;
					document.all(fieldid+"isshow").checked = true ;
					document.all(fieldid+"iseditable").checked = true ;
					document.all(fieldid+"notnull").checked = true ;
				}
			}
			else {
				for (var i=1;i<table.rows.length;i++){
					var fieldid = table.rows(i).cells(0).innerText ;
					document.all(fieldid+"notnull").checked = false ;
				}
			}
		}

	}

	function onSubmitStyle(){
		var curnodeid = document.all("nodeid").value ;
		var tables = document.getElementsByTagName("table");
		if (tables.length==0) return ;
		for (var k=0;k<tables.length;k++){
			var table = tables[k];
			var formid = table.id ;
			for ( var i=1;i<table.rows.length;i++ ){
				var fieldid = table.rows(i).cells(0).innerText;
				onOK(fieldid,formid);
			}
		}
		alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0068")%>.");//保存成功
		selectindex++;
		if (selectindex==document.all("nodeid").options.length-1){
			selectindex = 0 ;
		}
		//document.all("nodeid").options[selectindex].selected = true ;
	}

	function onNodeChange(){
		for(var i=0;i<document.StyleForm.length;i++){
			var e = document.StyleForm.elements[i];
			if(e.type == "checkbox") e.checked = false ;
			if(e.type == "text") e.value = "" ;
		}

		var curnodeid = document.all("nodeid").value;

		var workflowid = "<%=id%>" ;

	    var url = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowNodeStyleAction?from=node&workflowid=" + workflowid + "&curnodeid=" + curnodeid ;

	    if (window.XMLHttpRequest) {

	        req = new XMLHttpRequest();

	    } else if (window.ActiveXObject) {

	        req = new ActiveXObject("Microsoft.XMLHTTP");

	    }
	    req.open("POST", url, true);
	    req.onreadystatechange = callback;
	    req.send(null);
	}

	function callback() {
	    if (req.readyState == 4) {
	        if (req.status == 200) {
	            parseMessage();
	        }
	    }
	}

	function parseMessage() {
		var xmlDoc = req.responseXML;
		var styles = xmlDoc.getElementsByTagName("style");
		if (styles.length!=0){
			for (var i=0;i<styles.length;i++){
				var nodevalue = styles[i].childNodes[0].nodeValue;
				nodevalue = decode(nodevalue);
				var values = nodevalue.split("~");
				var formid = values[0];
				var fieldid = values[1];
				var showstyle = values[2];
				var defaultvalue = values[3];
					var checkbox_isshow = document.all(fieldid+"isshow");
					var checkbox_iseditable = document.all(fieldid+"iseditable");
					var checkbox_notnull = document.all(fieldid+"notnull");
					var input_defaultvalue = document.all(fieldid+"showname");
					if (showstyle == 3){
						checkbox_isshow.checked = true ;
						checkbox_iseditable.checked = true;
						checkbox_notnull.checked = true ;
					}
					else if (showstyle == 2){
						checkbox_isshow.checked = true ;
						checkbox_iseditable.checked = true;
						checkbox_notnull.checked = false ;
					}
					else if (showstyle == 1){
						checkbox_isshow.checked = true ;
						checkbox_iseditable.checked = false;
						checkbox_notnull.checked = false ;
					}
					else if (showstyle == 0){
						checkbox_isshow.checked = false ;
						checkbox_iseditable.checked = false;
						checkbox_notnull.checked = false ;
					}
					input_defaultvalue.value = Trim(defaultvalue) ;
			}
		}
		else {
			var tables = document.getElementsByTagName("table");
			for (var i=0;i<tables.length;i++){
				var table = tables[i];
				for (var k=1;k<table.rows.length;k++){
					var showname = table.rows(k).cells(2).innerText;
					var fieldid = table.rows(k).cells(0).innerText ;

					var checkbox_isshow = document.all(fieldid+"isshow");
					var checkbox_iseditable = document.all(fieldid+"iseditable");
					var checkbox_notnull = document.all(fieldid+"notnull");

					checkbox_isshow.checked = false ;
					checkbox_iseditable.checked = false;
					checkbox_notnull.checked = false ;
					//document.all(fieldid+"showname")=showname ;
				}
			}
		}
	}

	function onOK(fieldid,formid){
		var workflowid = "<%=id%>";
		var curnodeid = document.all("nodeid").value;
		var showstyle ;
		if ( !document.all(fieldid+"isshow").checked ){
			showstyle = 0;
		}
		else {
			if ( !document.all(fieldid+"iseditable").checked ){
				showstyle = 1;
			}
			else {
				if ( !document.all(fieldid+"notnull").checked ){
					showstyle = 2;
				}
				else showstyle = 3;
			}
		}

		var showname = document.all(fieldid+"showname").value;
		showname = " " + showname + " " ;
		var style = formid+"~"+fieldid + "~" + showstyle + "~" + showname + "~";;
		style = encode(style);
		var url = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowNodeStyleAction?from=field&workflowid=" + workflowid + "&curnodeid=" + curnodeid + "&style=" + style;
	    if (window.XMLHttpRequest) {
	        req = new XMLHttpRequest();
	    } else if (window.ActiveXObject) {
	        req = new ActiveXObject("Microsoft.XMLHTTP");
	    }

	    req.open("POST", url, true);
	    req.onreadystatechange = callback2;
	    req.send(null);
	}

	function callback2(){
	    if (req.readyState == 4) {
	        if (req.status == 200) {
	        }
	    }
	}
	var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
			document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
	
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
	        			document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
	        	
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
</script>

<script type="text/javascript">
//Start Ajax tabs script for UL with id="maintab" Separate multiple ids each with a comma.
startajaxtabs("maintab")
</script>
<script language="javascript">
  function showWizard(){
      dlg0.render(Ext.getBody());
      Ext.get('div1').setVisible(true);
      Ext.get('div2').setVisible(true);
      Ext.get('div3').setVisible(true);
      Ext.get('divdisplay').setVisible(true);
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
             if (menutree.getChecked().length>0)
                 this.wizard.nextButton.setDisabled(false);
             else {
                 this.wizard.nextButton.setDisabled(true);
             }

              });
    }


function getDate(){
 	var destList  = document.all("triggerdate2");
	var len = destList.options.length;
	var tempdate = document.all("tempdate").value;
	if  (len>0){
	 for(var i = (len-1); i >= 0; i--) {
	  if (destList.options[i].value == tempdate) {
	    destList.options[i].selected = true;
	   }
  	 }
  	}

}

function addSelect(num){
 	var destList  = document.all("triggerdate2");
	var len = destList.options.length;
	if  (len>0){
	 for(var i = (len-1); i >= 0; i--) {
	  if ((destList.options[i] != null)) {
	    destList.options[i] = null;
	   }
  	 }
  	}

  for (var j=1;j<=num;j++){
    var oOption = document.createElement("OPTION");
 	destList.options.add(oOption);
 	<%if (StringHelper.null2String(workflowinfo.getTriggercycle()).equals("4")){%>
	if(j==<%=StringHelper.null2String(workflowinfo.getTriggerdate())%>) destList.selectedIndex= j-1;
	<%}%>
	oOption.value = j;
	oOption.innerText = j;
 }
}
function onSubmit(){
   	checkfields="objname,objtype,formid,deftitle";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   		window.close();
   	}
}

function addFormField(temp){
    try {
        if (document.all("formid").value != null)
            getformfield(document.all("formid").value);
    } catch(ex) {
    }
    if(temp=="1")
      changeDocType();
}

    function getformfield(formid){
       	DataService.getValues(createList,"select distinct id,labelname from formfield where (formid='"+formid+"' or formid in (select pid from formlink where oid='"+formid+"' and typeid=1))  and isdelete<1");
    }


    function createList(data)
	{
	    DWRUtil.removeAllOptions("approveobj");
	    DWRUtil.addOptions("approveobj", data,"id","labelname");
	    setTimeout("selectField()", 300);
	    DWRUtil.removeAllOptions("approveobjtype");
	    DWRUtil.addOptions("approveobjtype", data,"id","labelname");
	    setTimeout("selectFieldtype()", 300);
	 //   changeTab();
	}

function selectFieldtype(){
  var destList  = document.all("approveobjtype");if(!destList)return;
 // alert("test1");
  var len  = destList.options.length;
//  alert(len);
   var ss = "<%=StringHelper.null2String(workflowinfo.getApproveobjtype())%>";
 //  alert(ss);
  if (len>0){
    for (var j=0;j<=len-1;j++){
   //   alert(j+"??");
     if (destList.options[j].value==ss)
     {
   //  alert(j+"jj1");
      destList.selectedIndex= j;
    //  alert(j+"jj2");
      }
    }
  }

}

function selectField(){
    try {
        var destList = document.all("approveobj");
        // alert("test1");
        var len = destList.options.length;
        //  alert(len);
        var ss = "<%=StringHelper.null2String(workflowinfo.getApproveobj())%>";
        //  alert(ss);
        if (len > 0) {
            for (var j = 0; j <= len - 1; j++) {
                //   alert(j+"??");
                if (destList.options[j].value == ss)
                {
                    //  alert(j+"jj1");
                    destList.selectedIndex = j;
                    //  alert(j+"jj2");
                }
            }
        }
    } catch(ex) {
    }

}

   function onReturn(){
     document.location.href="<%=request.getContextPath()%>/workflow/workflow/workflowinfolist.jsp";
   }

   //nodelist functions begin
   function nodeonSubmit(){
    document.EweaverForm.submit();
  }
   function nodeonDelete(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=delete&id="+id+"&workflowid=<%=id%>";
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
	   	}
   		tab2.fireEvent("onclick");

 //  document.EweaverForm.action="/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=delete&id="+id;
   // document.EweaverForm.submit();
  }
  function changeTab(){
     var tabId = document.all("tab").value;
     if (tabId=="3")
       tab3.fireEvent("onclick");
  }
  var win;
  function nodeonCreate(url){
	  if(!Ext.isSafari){
    	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
	  }else{
		//----
		        if (!win) {
		             win = new Ext.Window({
		                layout:'border',
		                width:Ext.getBody().getWidth()*0.8,
		                height:Ext.getBody().getHeight()*0.85,
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
	                   // win.getComponent('dialog').setSrc('about:blank');
	                } ;
		        win.render(Ext.getBody());
		        var dialog = win.getComponent('dialog');
		        dialog.setSrc(url);
		        win.show();
		    }
   	tab2.fireEvent("onclick");
  }
  function nodeonSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
	document.EweaverForm.submit();
   }
   function onDraw(workflowid,workflowname) {
       
       var url = "/wfdesigner/editors/grapheditor.jsp?workflowid=" + workflowid;
       sfeather="dialogWidth:"+screen.width*0.8+"px;dialogHeight:"+screen.height*0.8+"px;center:yes;resizable:yes;status:no;maximize=yes";
       openDialog(url, "<%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039")%>", sfeather);//流程图
       //openWin(url,'流程图-'+workflowname,'comment_edit')
       
   }

   //nodelist functions end
</script>

 <script language="JavaScript" src="<%=request.getContextPath()%>/js/addRowBg.js" >
</script>
  <script language="javascript">
var rowColor="" ;
rowindex = 0;
delids = "";
var row = 0;
function addExportRow(thenodeoptions,formid){
	if(document.all("check_node")){
		if(document.all("check_node").length>1){
			row = document.all("check_node").length +1;
		}else{
			row = 1;
		}

	}
	var oOption=document.EweaverForm.curnode.options[document.EweaverForm.curnode.selectedIndex];
	if(oOption.value == -1){
		alert("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0056")%>");//请选择一个节点
		return;
	}

	tmpval = oOption.value;
	tmptype = tmpval;

	tmptype = tmptype.substring(tmptype.indexOf("_")+1);

	ncol = vTable.cols;
	rowColor = getRowBg();
	oRow = vTable.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		//oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input  type='checkbox' name='check_node' value='1'><input  type='hidden' name='id'> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = oOption.text + "<input type='hidden' name='startnodeid' value='"+tmpval+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");

				var temphtml = "javascript:getBrowser('/workflow/workflow/exportbrowser.jsp?formid=" + formid + "','condition" +  row + "','conditionspan" +  row + "','0');";
				var sHtml = "<input type='button'  class=Browser onclick= " + temphtml + " />";
				sHtml += "<input type='hidden'  name='condition" + row + "' />";
				sHtml += "<span id='conditionspan" + row + "'/></span>";
				//var sHtml = "";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class=inputstyle name='conditionname'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class=inputstyle name='linkname'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='endnodeid'>";
				sHtml+= "<option value='-1'><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a305fd0028")%></option>";//请选择目标节点
				sHtml+= thenodeoptions;
				sHtml+= "</select>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}

}
function deleteExportRow()
{
	alert("<%=labelService.getLabelNameByKeyId("402881e90aac1cd3010aac1d97730001")%>");//确定要删除吗？
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {

				if(document.forms[0].elements[i].value!='0'){
					var did = document.forms[0].elements[i].value;
					document.all("delids").value =document.all("delids").value +",'"+did+"'";

				}

				vTable.deleteRow(rowsum1+1);
			}else {
			  document.all("row").value = document.all("row").value + "," + rowsum1;
			}
			rowsum1 -=1;
		}
	}
    window.document.EweaverForm.action = window.document.EweaverForm.action + "&delete=true";
	window.document.EweaverForm.submit();
}


function isdel(){
	var count = 0;
	len = document.forms[0].elements.length;
	var i=0;

	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			if(document.forms[0].elements[i].checked==true) {
					count++;
			}
	}

	if(count>0){
		return true;
	}else{
		return false;
	}

}
function saveExportAll(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;

	window.document.EweaverForm.submit();

	tab3.fireEvent("onclick");
}



function checkEndnodeId(){
	var lenstartnodeid = document.EweaverForm.startnodeid.length;
	if(lenstartnodeid > 1){
		var i=0;
		var target ="";
		for(i=0; i<lenstartnodeid; i++){
			if(document.EweaverForm.endnodeid[i].value == "-1"){
				alert("<%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a305fd0028")%>");//请选择目标节点
				return false;
			}
		}
	}else{
		if(document.EweaverForm.endnodeid.value == "-1"){
			alert("<%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a305fd0028")%>");//请选择目标节点
			return false;
		}
	}

	return true;
}

</script>
    <script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
	</body>
</html>
<script language="javascript">
   function onReturn(){
     document.location.href="<%=request.getContextPath()%>/workflow/workflow/workflowinfolist.jsp?moduleid=<%=moduleid%>";
   }
   function onSubmit(){
   	checkfields="objname,formid,deftitle";
   	// 如果选择默认目录时 必填此项
   	//把if里面的条件的false和&&后面的代码顺序换了一下
   	if( false && document.getElementById("iscreateDoc").value=="1"){  //添加faslse 使defaultDocDir 不必填
   	    checkfields = checkfields+",defaultDocDir";
   	}
   	//checkmessage='<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';
   	checkmessage='<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
		document.EweaverForm.submit();
		return true;
   	}
	return false;
   }

   function onCopy(workflowid,workflowname) {
       if(confirm('<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a000f")%><< ' + workflowname + ' >>?')) {//是否复制流程
          Ext.Ajax.request({
           url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=copy',
           params:{workflowid:workflowid,workflowname:workflowname},
           success: function(response) {
             var rs = response.responseText;
             if(rs == 0) {
                 alert('<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220033")%>');//流程ID为空无法复制!
             } else {
                 if(confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044")%><< ' + workflowname + ' >><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220034")%>' )) {//流程      复制完成!是否直接打开?
                     document.location.href = '/workflow/workflow/workflowinfomodify.jsp?id='+rs+'&moduleid=<%=moduleid%>';
                 }
             }           
           }
      	   });     
       }
      
   }

   function addVersion(workflowid,workflowname) {
       if(confirm('是否新增版本<< ' + workflowname + ' >>?')) {//是否复制流程
          Ext.Ajax.request({
           url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=addversion',
           params:{workflowid:workflowid,workflowname:workflowname},
           success: function(response) {
             var rs = response.responseText;
             if(rs == 0) {
                 alert('流程ID为空无法新增版本！');//流程ID为空无法复制!
             } else {
                 if(confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044")%><< ' + workflowname + ' >>新增版本完成！是否直接打开？' )) {//流程      复制完成!是否直接打开?
                     document.location.href = '/workflow/workflow/workflowinfomodify.jsp?id='+rs+'&moduleid=<%=moduleid%>';
                 }
             }
           }
      	   });
       }
      
   }
   
   function onsubmitLayout(url){
     document.location.href="<%=request.getContextPath()%>"+url;
   }

   function oncreateformfield(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
   	tab2.fireEvent("onclick");
   }

   function oncreateformlink(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
   	tab3.fireEvent("onclick");
   }


   function onmodifyformlayout(url,layoutName){
	var getLayoutId=function(){
		return url.substring(url.indexOf('&layoutid=')+'&layoutid='.length,url.indexOf('&nodeid='));
	};
	layoutName='<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000e")%>'+(Ext.isEmpty(layoutName)?'':'['+layoutName+']');//修改布局
	//top.onUrl(contextPath+url,layoutName,'modifyLayout_'+getLayoutId());
	window.open(url,'modifyLayout_'+getLayoutId());
   }
   function onCloneFormlayout(forminfoid,layoutid){
		var thisUrl = '<%=request.getContextPath()%>/workflow/form/formlayoutClone.jsp?forminfoid='+forminfoid+'&layoutid='+layoutid+'&nodeid=';
		if(document.getElementById('curnode').value=='-1'){
			if(!confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001d")%>')){//还没有选择复制布局所在的节点，是否继续？
				return;
			}
		}
		thisUrl +=document.getElementById('curnode').value;
		url=contextPath+thisUrl;
		window.open(url,'modifyLayout_'+layoutid);
	}
	function onsetfieldstyle(url){
	 	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+ url,window,
				"dialogHeight: "+screen.availHeight+"; dialogWidth: "+screen.availWidth+"; center: Yes; help: No; resizable: yes; status: No");
	   	tab4.fireEvent("onclick");
	}

   function oncreateformlayout(url,layoutName){
       var url = "<%=request.getContextPath()%>" + url + "&nodeid=" + document.layoutform.curnode.value;
       var getLayoutId = function() {
           var layoutid = url.substring(url.indexOf('&layoutid=') + '&layoutid='.length, url.indexOf('&nodeid='));
           if (layoutid.length != 32 && layoutid.indexOf('/') > -1) {
               if (url.indexOf('layouttype=2') > -1) { //编辑
                   return '<%=id%>2';
               } else if (url.indexOf('layouttype=1') > -1) {  //显示
                   return '<%=id%>1';
               } else if (url.indexOf('layouttype=3') > -1) { //打印
                   return '<%=id%>3';
               }
           } else {
               return layoutid;
           }

       };
       layoutName = '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000d")%>' + (Ext.isEmpty(layoutName) ? '' : '[' + layoutName + ']');//新建布局
       //top.onUrl(url,layoutName,'createLayout_'+getLayoutId());
       window.open(url, 'createLayout_' + getLayoutId());
       tab4.fireEvent("onclick");
   }
	function checkselect(btname){
		if(document.layoutform.curnode.value == "-1"){
			var len = layoutTb.rows.length;
			var selectid = document.all("curnode").value;
			var i;

			for(i=1; i<len; i++){
				var workflowname = document.all("workflowtempvalue" + i).value;
				var nodetempvalue = document.all("nodetempvalue" + i).value;

				if(Trim(workflowname) == Trim(nodetempvalue)){
						alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001e")%>");//此节点的表单布局已经存在.....
						return false;
				}
			}
			return true;
		}else{
			var len = layoutTb.rows.length;
			var selectid = document.all("curnode").value;
			var i;

			for(i=1; i<len; i++){

				var nodeid = document.all("nodetemp" + i).value;
				var layoutname = document.all("layouttemp" + i).value;

				if((btname == layoutname && selectid == nodeid)){
					alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001e")%>");//此节点的表单布局已经存在.....
					return false;
				}
			}
		}
		return true;
	}

   function onSetStyle(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+ url,window,
			"dialogHeight: "+screen.availHeight+"; dialogWidth: "+screen.availWidth+"; center: Yes; help: No; resizable: yes; status: No");
   	tab4.fireEvent("onclick");

   }

    function onDeleteFormfield(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=delete&id="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab2.fireEvent("onclick");
   	}
    function onDeleteFormlink(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlinkAction?action=delete&id="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab3.fireEvent("onclick");
   	}

    function onDeleteFormlayout(id){
        document.getElementById("checkLayoutId").value=id;
        FormlayoutService.checkOptLayout(id,callback);
   	}

   	function callback(data){
        if(data!=null&&data!=""){
            alert(data);
        }else{
            var id=document.getElementById("checkLayoutId").value;
            FormlayoutService.getPermissionObj(id,showTable);
   	    }
   	}

    function showTable(data){
      if(data!="" && data!=null){
          sAlert(data);
      }else{
          var id=document.getElementById("checkLayoutId").value;
          showAlert(id);
      }
    }

    function addTable(data){
          var refreshBody=document.getElementById("refreshBody");
          DWRUtil.removeAllRows(refreshBody);//删除table的更新元素
          DWRUtil.addRows(refreshBody, data, [ getPermissionType,getCategoryName,getNodeinfoName,getWorkflowName,getOpttype,getOperateObj,toShow,toDelete ],//getCheck,getAllUnit是表的对应的列,
          {
             rowCreator:function(options) {//创建行，对其进行增添颜色
             var row = document.createElement("tr");
             var index = options.rowIndex * 50;
             row.style.color = "#999999";
             row.style.height = 20;
             return row;
             },
             cellCreator:function(options) {//创建单元格，对其进行增添颜色
             var td = document.createElement("td");
             var index = 255 - (options.rowIndex * 50);
             td.style.backgroundColor = "#f7f7f7";
             td.style.fontWeight = "bold";
             return td;
             }
          });
    }
//    var getObjid = function(data) { return '<a href="javascript:void(0)">'+data.objid+'</a>' };
    var i=0;
    var getPermissionType = function(data) { return data.permissiontype };
    var getCategoryName = function(data) { return data.categoryName.length>6?'<a href="javascript:void(0)" id="'+data.id+'_'+(++i)+'" onmouseover="showDiv(\''+data.id+'_'+i+'\',\''+data.categoryName+'\')" onmouseout="document.getElementById(\'showDivObj\').style.display=\'none\'">'+data.categoryName.substring(0,6)+'...</a>':data.categoryName };
    var getNodeinfoName = function(data) { return data.nodeinfoName.length>6?'<a href="javascript:void(0)" id="'+data.id+'_'+(++i)+'" onmouseover="showDiv(\''+data.id+'_'+i+'\',\''+data.nodeinfoName+'\')" onmouseout="document.getElementById(\'showDivObj\').style.display=\'none\'">'+data.nodeinfoName.substring(0,6)+'...</a>':data.nodeinfoName };
    var getWorkflowName = function(data) { return data.workflowName.length>6?'<a href="javascript:void(0)" id="'+data.id+'_'+(++i)+'" onmouseover="showDiv(\''+data.id+'_'+i+'\',\''+data.workflowName+'\')" onmouseout="document.getElementById(\'showDivObj\').style.display=\'none\'">'+data.workflowName.substring(0,6)+'...</a>':data.workflowName };
    var getOpttype = function(data) { return data.opttype.length>16?'<a href="javascript:void(0)" id="'+data.id+'_'+(++i)+'" onmouseover="showDiv(\''+data.id+'_'+i+'\',\''+data.opttype+'\')" onmouseout="document.getElementById(\'showDivObj\').style.display=\'none\'">'+data.opttype.substring(0,16)+'...</a>':data.opttype };
    var getOperateObj = function(data) { return data.operateObj.length>18?'<a href="javascript:void(0)" id="'+data.id+'_'+(++i)+'" onmouseover="showDiv(\''+data.id+'_'+i+'\',\''+data.operateObj+'\')" onmouseout="document.getElementById(\'showDivObj\').style.display=\'none\'">'+data.operateObj.substring(0,18)+'...</a>':data.operateObj };
    var toShow = function(data) { return '<a href="javascript:onUrl(\'/base/security/addpermission.jsp?objtable='+data.objTable+'&istype=1&objid='+data.objid+'&formid='+data.formid+'\',\'<%=labelService.getLabelNameByKeyId("402881ed0c29ccef010c2a9592ac0019")%>\',\''+data.objid+'\')"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd7a2f730012")%></a>' };//权限定义    查看
    var toDelete = function(data) {
        return '<input type="checkbox" name="unitCheck" value="'+data.id+'"/>';
    };

       function showAlert(id){
	    if( confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0002")%>')){//确定要删除您选择的布局吗?

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=delete&layoutid="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab4.fireEvent("onclick");
   	}

    function showDiv(id,data){
        var obj=document.getElementById(id);
        var rect = GetAbsoluteLocation(obj);
        var top = rect.absoluteTop;
        var left = rect.absoluteLeft;
        var divObj=document.getElementById("showDivObj");
        document.getElementById("msg").innerHTML="&nbsp;"+data;

        document.getElementById("msg").style.width=data.length>42?data.length*11-30:data.length*12;
        divObj.style.top=top+20;
        if(data.length>40){
            divObj.style.left=left-260;
        }else{
            divObj.style.left=left-80;
        }
        divObj.style.display="block";
    }

    function goDelete(){
        var ruleids="";
        var allCheckBox = document.getElementsByName("unitCheck");
        for(i=0;i<allCheckBox.length;i++){
            if(allCheckBox[i].type=="checkbox"&&allCheckBox[i].checked==true){
                ruleids+=allCheckBox[i].value+",";
            }
        }
        if(ruleids==""||ruleids==null){
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0003")%>");//请选择需要删除的项!
        }else{
            FormlayoutService.deletepermissionrule(ruleids,deleteCallBack);
        }
    }

    function deleteCallBack(data){
        if(data=="ok"){
            var mychoose=document.getElementById("divObj");
            var mytable=document.getElementById("displayTable");
            mychoose.appendChild(mytable);
            var bgObj=document.getElementById("bgDiv");
            document.body.removeChild(bgObj);
            var msgObj=document.getElementById("msgDiv");
            document.body.removeChild(msgObj);

            var id=document.getElementById("checkLayoutId").value;
            FormlayoutService.getPermissionObj(id,showTable);
        }else{
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0004")%>");//删除失败,请重试!
        }
    }
//*********************************模式对话框特效(start)*********************************//
            function sAlert(data){
            var msgw,msgh,bordercolor;
            msgw=780;//提示窗口的宽度
            msgh=320;//提示窗口的高度
            bordercolor="#336699";//提示窗口的边框颜色

            var sWidth,sHeight;
            sWidth=document.body.offsetWidth;
            sHeight=document.body.offsetHeight;

            var bgObj=document.createElement("div");
            bgObj.setAttribute('id','bgDiv');
            bgObj.style.position="absolute";
            bgObj.style.top="0";
            bgObj.style.background="#777";
            bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
            bgObj.style.opacity="0.6";
            bgObj.style.left="0";
            bgObj.style.width=sWidth + "px";
            bgObj.style.height=sHeight + "px";
            document.body.appendChild(bgObj);
            var msgObj=document.createElement("div")
            msgObj.setAttribute("id","msgDiv");
            msgObj.setAttribute("align","center");
            msgObj.style.position="absolute";
            msgObj.style.background="white";
            msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
            msgObj.style.border="1px solid " + bordercolor;
            msgObj.style.width=msgw + "px";
            msgObj.style.height=msgh + "px";
          msgObj.style.top=(document.documentElement.scrollTop + (sHeight-msgh)/2) + "px";
          msgObj.style.left=(sWidth-msgw)/2 + "px";

          var title=document.createElement("h4");
          title.setAttribute("id","msgTitle");
          title.setAttribute("align","right");
          title.style.margin="0";
          title.style.padding="3px";
          title.style.background=bordercolor;
          title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
          title.style.opacity="0.75";
          title.style.border="1px solid " + bordercolor;
          title.style.height="18px";
          title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
          title.style.color="white";
          title.style.cursor="pointer";
          title.innerHTML="关闭";
          title.onclick=function(){
            var mychoose=document.getElementById("divObj");
            var mytable=document.getElementById("displayTable");
            mychoose.appendChild(mytable);
            document.body.removeChild(bgObj);
            document.getElementById("msgDiv").removeChild(title);
            document.body.removeChild(msgObj);
        }
          document.body.appendChild(msgObj);
          document.getElementById("msgDiv").appendChild(title);
		  var mytable=document.getElementById("displayTable");
	      document.getElementById("msgDiv").appendChild(mytable);
          addTable(data);
      }
//*********************************模式对话框特效(end)*********************************//

//*********************************得到网页中元素的绝对位置(start)*********************************//
    function GetAbsoluteLocation(element)
    {
        if ( arguments.length != 1 || element == null )
        {
            return null;
        }
        var offsetTop = element.offsetTop;
        var offsetLeft = element.offsetLeft;
        var offsetWidth = element.offsetWidth;
        var offsetHeight = element.offsetHeight;
        while( element = element.offsetParent )
        {
            offsetTop += element.offsetTop;
            offsetLeft += element.offsetLeft;
        }
        return { absoluteTop: offsetTop, absoluteLeft: offsetLeft,
            offsetWidth: offsetWidth, offsetHeight: offsetHeight };
    }
//*********************************得到网页中元素的绝对位置(end)*********************************//

    function onDeleteFormlayout(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=delete&layoutid="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");

	   	}

   		tab4.fireEvent("onclick");
   	}
   function onPopup(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show()

   }

    function docheck(o){
        var i = o.value;
        document.all("doctypeid"+i).value="givenpermission";
    }

function doSaveJSCode(){
	Ext.Ajax.request({
		url: '/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction',
		params: {
			action: 'saveJSCode',
			workflowid: Ext.get('workflowid').dom.value,    
			jsCode: Ext.get('jsCode').dom.value
		},    
		success: function(response, options){
			alert('<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001e")%>');//保存成功!
		}
	})
}
</script>
<script>
var win;
    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";
    var fck=param.indexOf("function:");
    if(fck>-1){}else{
       var param = parserRefParam(inputname,param);
    }
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
	var browserName=navigator.userAgent.toLowerCase();
	var isSafari = /webkit/i.test(browserName) &&!(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName));
	/*
     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
     */
    var isStationBrowserInSafari = isSafari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
    //流程单选 || 工作流程单选 || 工作流程多选
	var isWorkflowBrowserInSafari = isSafari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
	//员工多选
	var isHumresBrowserInSafari = isSafari && refid == '402881eb0bd30911010bd321d8600015';	
	if(!Ext.isSafari){
    try{
            //var url ='<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            //if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
            //    url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            //}
            //alert(url);
            //if(typeof(param)=='undefined'){
	        //     id=window.showModalDialog(url,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
             //}else{
            //	 id=window.showModalDialog(url,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
             //}
             id = window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
	        //id=window.showModalDialog(url,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes;');
    	//id=openDialog(url);
    }catch(e){return}
    if (id!=null) {
    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
          if(fck>-1){
          funcname=param.substring(9);
      scripts="valid="+funcname+"('"+id[0]+"');";
        eval(scripts) ;
        if(!valid){  //valid默认的返回true;
         document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
          }
          }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }else{
    url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;

    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                    if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) {  //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0')
                                document.all(inputspan).innerHTML = '';
                            else
                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

                }
            }
        }
	    var winHeight = Ext.getBody().getHeight() * 0.9;
	    var winWidth = Ext.getBody().getWidth() * 0.9;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:winWidth,
                height:winHeight,
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
        dialog.setSrc(url);
        win.show();
    }
    }
</script>
<script>
function onActiveWorkflowVersion(workflowid){
 	if( confirm('确定启动该版本？')){
		var myMask = new Ext.LoadMask(Ext.getBody(), {
		    msg: '正在处理，请稍后...',
		    removeMask: true //完成后移除
		});
		myMask.show();
		
 		Ext.Ajax.request({
 			timeout:100000000,
			url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.version.servlet.WorkflowVersionAction?action=activeworkflowversion&workflowid='+ workflowid,
			params:{},
			success: function(response) {
				onModify("<%=groupid%>");
				myMask.hide();
			},
	        failure: function (request) {
		        Ext.Msg.alert('','请求超时！');
		        myMask.hide();
		    }
        });
	}
}

function onWorkflowidall(){
	var workflowidall=jq("#workflowidall").attr("checked");
	if(workflowidall){
		jq("input[name=workflowid]").attr("checked","true");
	}else{
		jq("input[name=workflowid]").removeAttr("checked");
	}
}

function onComparewf(workflowid){
	var workflowids="";
	var con=0;
	jq("input[type=checkbox][name=workflowid]:checked").each(function(){
		workflowids+=jq(this).val()+",";
		con+=1;
	})
	
	if(con<2){
		alert('请选择两个或两个以上版本进行比较！');
	}else{
		var url = "<%=request.getContextPath()%>/workflow/version/comparewf.jsp?workflowids=" + workflowids+"&width="+screen.width*0.8+"&height="+screen.height*0.8;
		sfeather="dialogWidth:"+screen.width*0.8+"px;dialogHeight:"+screen.height*0.8+"px;center:yes;resizable:yes;status:no;maximize=yes";
	    openDialog(url, "<%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039")%>比较", sfeather);//流程图
	}
}

function onComparenode(workflowid){
	var workflowids="";
	var con=0;
	jq("input[type=checkbox][name=workflowid]:checked").each(function(){
		workflowids+=jq(this).val()+",";
		con+=1;
	})
	
	if(con<2){
		alert('请选择两个或两个以上版本进行比较！');
	}else{
		var url = "<%=request.getContextPath()%>/workflow/version/comparenode.jsp?workflowids=" + workflowids+"&width="+screen.width*0.8+"&height="+screen.height*0.8;
		sfeather="dialogWidth:"+screen.width*0.8+"px;dialogHeight:"+screen.height*0.8+"px;center:yes;resizable:yes;status:no;maximize=yes";
	    openDialog(url, "<%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039")%>比较", sfeather);//节点
	}
}

function onVersionactivepolicy(workflowid){
	var url = "<%=request.getContextPath()%>/workflow/version/versionactivepolicylist1.jsp?workflowid=" + workflowid+"&width="+screen.width*0.8+"&height="+screen.height*0.8;
	sfeather="dialogWidth:"+screen.width*0.8+"px;dialogHeight:"+screen.height*0.8+"px;center:yes;resizable:yes;status:no;maximize=yes";
    openDialog(url, "版本启用策略", sfeather);//版本启用策略
	//window.open(url);
}

function onModify(id) {
    document.location = "<%=request.getContextPath()%>/workflow/workflow/workflowinfomodify.jsp?id=" + id+"&moduleid=<%=moduleid%>";
}


</script>
<script language="JavaScript" src="<%= request.getContextPath()%>/js/addRowBg.js" ></script>