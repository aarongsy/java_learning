<%@ page buffer="64kb" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>

<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>

<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlink" %>


<%
    int gridWidth=700;
    String str=request.getParameter("str");
   String id=StringHelper.null2String(request.getParameter("id"));
   String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=search&id=" +id;
    String action3 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=getJson&id=" +id;
   ReportdefService reportdefService=(ReportdefService)BaseContext.getBean("reportdefService");
   Reportdef reportdef=new Reportdef();
   if(id!=""){
    reportdef=reportdefService.getReportdef(id);
   }
   String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
   String selectItemId = StringHelper.trimToNull(reportdef.getObjtype());
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
   Selectitem selectitem;
   ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
   FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
   RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
   int viewType=NumberHelper.getIntegerValue(reportdef.getViewType(),0);
   String groupby=StringHelper.null2String(reportdef.getGroupby());
   String groupby1=StringHelper.null2String(reportdef.getGroupby1());
   String groupby2=StringHelper.null2String(reportdef.getGroupby2());
   String groupbytree=StringHelper.null2String(reportdef.getGroupbytree());
   String treeby=StringHelper.null2String(reportdef.getTreeby());
   Forminfo forminfo=new Forminfo();

   HumresService humresService = (HumresService)BaseContext.getBean("humresService");
   PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
   String[] objopts = null;
    /**
   String members = "";
   if(reportdef.getObjopts() != null){
      	objopts = reportdef.getObjopts().split(",");
		StringBuffer opts = new StringBuffer("");
		StringBuffer optids =  new StringBuffer("");
		for(int k=0; k < objopts.length; k++){
			String humrename = humresService.getHrmresNameById(objopts[k]);
			opts.append(humrename).append(",");
		}

		if(opts.toString().contains(",")){
			 members = opts.toString().substring(0,opts.toString().lastIndexOf(","));
		}
   }
  */
 paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
   List reportfieldList = (List)request.getAttribute("reportfieldList");
String reportid = request.getParameter("reportid");

WorkflowVersionService workflowVersionService=(WorkflowVersionService)BaseContext.getBean("workflowVersionService");
	boolean isWorkflowVersionEnable=workflowVersionService.isWorkflowVersionEnable();
String trisshowversionquerystyle="display:none;";
if("2".equals(StringHelper.null2String(reportdef.getIsformbase()))&&isWorkflowVersionEnable){
	trisshowversionquerystyle="display:block;";
}
%>
<%
String formid="";
String formname="";
formid=StringHelper.null2String(reportdef.getFormid());
String reportobjname = StringHelper.null2String(reportdef.getObjname());
if(!StringHelper.isEmpty(reportobjname)){
	reportobjname = reportobjname.replaceAll("\\'","\\\\\'");
	reportobjname = reportobjname.replaceAll("\"","&quot;");
}
if(formid!=""){
   forminfo=forminfoService.getForminfoById(formid);
   formname=StringHelper.null2String(forminfo.getObjname());
}
 String rootidmenu="r00t";
 String roottextmenu=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2347c00015");//用户菜单
%>
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/ext-ux-wiz.css" />
        <style type="text/css">
    TABLE {
	    width:0;
    }
    /*TD{*/
        /*width:16%;*/
    /*}*/
.x-panel-tl {
background:#F0F4F5 none repeat scroll 0 0;
border-color:#D0D0D0;
}
.x-panel-tr {
background:#F0F4F5 none repeat scroll 0 0;
}
.x-panel-tl .x-panel-header {
background:#F0F4F5 none repeat scroll 0 0;
border:1px solid #F0F4F5;
color:#333333;

}

</style>

  
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
     <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/columnLock.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/ux/css/columnLock.css"/>
 <script type="text/javascript">
 Ext.override(Ext.grid.ColumnModel,{
         isLocked :function(colIndex){
		//if(this.config[colIndex] instanceof Ext.grid.CheckboxSelectionModel){return true;}
              //  return this.config[colIndex].locked === true;
         }
});
Ext.override(Ext.grid.CheckboxSelectionModel,{
    selectRow : function(index, keepExisting, preventViewNotify){
            if(this.locked || (index < 0 || index >= this.grid.store.getCount())) return;
            var r = this.grid.store.getAt(index);
            if(r && this.fireEvent("beforerowselect", this, index, keepExisting, r) !== false){
                /*if(!keepExisting || this.singleSelect){
                    this.clearSelections();
                }*/
                this.selections.add(r);
                this.last = this.lastActive = index;
                if(!preventViewNotify){
                    this.grid.getView().onRowSelect(index);
                }
                this.fireEvent("rowselect", this, index, r);
                this.fireEvent("selectionchange", this);
            }
        },
    handleMouseDown : function(g, rowIndex, e){
        if(e.button !== 0 || this.isLocked()){
            return;
        };
        var view = this.grid.getView();
        if(e.shiftKey && this.last !== false){
            var last = this.last;
            this.selectRange(last, rowIndex, e.ctrlKey);
            this.last = last;             view.focusRow(rowIndex);
        }else{
            var isSelected = this.isSelected(rowIndex);
            if((e.ctrlKey||e.getTarget().className=='x-grid3-row-checker') && isSelected){
                this.deselectRow(rowIndex);
            }else if(!isSelected || this.getCount() > 1){
                this.selectRow(rowIndex, e.ctrlKey || e.shiftKey||e.getTarget().className=='x-grid3-row-checker');
                view.focusRow(rowIndex);
            }
        }
    },
    onHdMouseDown : function(e, t){
        if(t.className == 'x-grid3-hd-checker'){
            e.stopEvent();
            var hd = Ext.fly(t.parentNode);
            var isChecked = hd.hasClass('x-grid3-hd-checker-on');
            if(isChecked){
                hd.removeClass('x-grid3-hd-checker-on');
                this.clearSelections();
            }else{
                hd.addClass('x-grid3-hd-checker-on');
                this.selectAll();
            }
        }
    }
});
Ext.override(Ext.grid.LockingGridView, {
	getEditorParent : function(ed){
		return this.el.dom;
	},
	refreshRow : function(record){
		Ext.grid.LockingGridView.superclass.refreshRow.call(this, record);
		var index = this.ds.indexOf(record);
		this.getLockedRow(index).rowIndex = index;
	}
});
  var step1,step2,step3,step4,step5,step6,step7,step8;
  var wizard;
  var dlg0;
  Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
var store;
var cm;
  var pidvalue;
  var menutree;
Ext.onReady(function(){
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
    step1=new Ext.ux.Wiz.Card({
                title : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550017")%>',//配置报表种类
                id:'s1',
                items : [{
                    border    : false,
                    bodyStyle : 'background:none;',
                    contentEl: 'divstep1'
                }]
            });

    step2=new Ext.ux.Wiz.Card({
                title   : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550018")%>',//报表列表
                id:'s2',
                monitorValid : true,
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl:'divstep2'
                    }]
            });

     step3=new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550019")%>',//报表查询
                monitorValid : true,
                id:'s3',
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      :  'divstep3'
                    } ]
            });
    var text1;
    var checkbox;
      step4=new Ext.ux.Wiz.Card({
                title   : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001a")%>',//菜单名
                id:'s4',
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
                       value:'<%=reportobjname%><%=labelService.getLabelNameByKeyId("402881e80b708c4f010b70a20640002b")%>',//列表
                       disabled:false
                    })
                ]
            });
           step5=new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220008")%>',//图片
                monitorValid : true,
                id:'s5',
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      :  'divimg'
                    } ]
            });

           step6=new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001b")%>',//自定义页面
                monitorValid : true,
                id:'s6',
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      :  'divlist'
                    } ]
            });
     step7=new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001b")%>',//自定义页面
                monitorValid : true,
                id:'s7',
                defaults     : {
                    labelStyle : 'font-size:11px'
                },
                items : [{
                        border    : false,
                        bodyStyle : 'background:none;padding-bottom:30px;',
                        contentEl      :  'divsearch1'
                    } ]
            }); 
     step8= new Ext.ux.Wiz.Card({
                     title        : '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1455001c")%>',//选择主菜单
                     id:'s8',
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
                        contentEl      :'divdisplay'
                }]
                      });
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
        cards : [step1,step2,step3,step4,step5,step6,step7,step8]
    });


    wizard.on('beforeclose',function(){
        this.hide();
        this.cardPanel.getLayout().setActiveItem(0);
    });

          function saveConfig(obj) {
              var url;
              var menuname;
              var pid;
              var imagfile;
              var menuname2;
              var imagfile2;
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
              if(obj.s1.radioname==1){
                  menuname=obj.s4.menuname;
                  pid=pidvalue;
                  imagfile=obj.s5.imagfile;
                  if(obj.s2.radioname2==1){ //表单数据
                      url='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=1&reportid=<%=reportdef.getId()%>';
                  }else if(obj.s2.radioname2==2){ // 流程数据
                    url='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=2&reportid=<%=reportdef.getId()%>';
                  }else if(obj.s2.radioname2==3){   //全部数据
                      url='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid=<%=reportdef.getId()%>';
                  }else{  //自定义报表数据
                     menuname=obj.s6.menuname1;
                     pid=pidvalue;
                     imagfile=obj.s6.imagfile1;
                     url=obj.s6.urll;
                  }

              }else{
                    menuname=obj.s4.menuname;
                  pid=pidvalue;
                  imagfile=obj.s5.imagfile;
                if(obj.s3.radioname3==1){//表单查询页面
                     url='/workflow/report/reportsearch.jsp?reportid=<%=reportdef.getId()%>&isformbase=1';
                  }else if(obj.s3.radioname3==2){ //流程查询页面
                      url='/workflow/report/reportsearch.jsp?reportid=<%=reportdef.getId()%>&isformbase=2';
                  }else if(obj.s3.radioname3==3){ //全部查询页面
                         url='/workflow/report/reportsearch.jsp?reportid=<%=reportdef.getId()%>&isformbase=0';
                  }else{//自定义查询页面
                    menuname=obj.s7.menuname2;
                     pid=pidvalue;
                     imagfile=obj.s7.imagfile2;
                     url=obj.s7.url2;
                  }
              }
              Ext.Ajax.request({
                       url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=createpage',
                        params:{menuname:menuname,imagfile:imagfile,url:url,pid:pid,displayPosition:displayPosition,ismenuorg:ismenuorg} ,
                         success: function() {
                                 if(Ext.getDom('checkname').checked==true){
                                           this.dlg0.getComponent('dlgpanel').setSrc('<%=request.getContextPath()%>/base/menu/menumanager.jsp?menutype=2');
                                        this.dlg0.show();
                                     }else{
                                      Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                             Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550020")%>');//配置页面菜单成功
                             }
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
        dlg0.render(Ext.getBody());
    function formatDate(value){
            return value ? value.dateFormat('M d, Y') : '';
        };
        function formatOrder(value){
          var record=orderCombo.store.getById(value);
		  if (typeof(record) == "undefined")
			  return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>';//否
		  else
			  return record.get('text');
        };
      function formatSum(value){
          var record=sumCombo.store.getById(value);
		  if (typeof(record) == "undefined")
			  return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>';//否
		  else
			  return record.get('text');
        };
       function formatCol3(value){
          var record=col3Combo.store.getById(value);
		  if (typeof(record) == "undefined")
			  return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>';//否
		  else
			  return record.get('text');
        };
      function formatHref(value){
          var record=hrefbox.store.getById(value);
		  if (typeof(record) == "undefined")
			  return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>';//否
		  else
			  return record.get('text');
        };
        function formatBrowser(value){
          var record=browserCombo.store.getById(value);
		  if (typeof(record) == "undefined")
			  return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>';//否
		  else
			  return record.get('text');
        };
      function formatShowMethod(value){
          if(!value)value=-1;
          if(showMethodCombo.store.getById(value)==undefined)
          return;
          var record=showMethodCombo.store.getById(value);
          return record.get('text');
        };
        // shorthand alias
        var fm = Ext.form;



        // the column model has information about grid columns
        // dataIndex maps the column to the specific data field in
        // the data store (created below)

        var orderCombo=new Ext.form.ComboBox({
                   typeAhead: true,
                   triggerAction: 'all',
                   transform:'isorderfield',
                   lazyRender:true,
                   listClass: 'x-combo-list-small'
                });
        var sumCombo=new Ext.form.ComboBox({
                   typeAhead: true,
                   triggerAction: 'all',
                   transform:'issum',
                   lazyRender:true,
                   listClass: 'x-combo-list-small'
                });
        var col3Combo=new Ext.form.ComboBox({
                   typeAhead: true,
                   triggerAction: 'all',
                   transform:'col3',
                   lazyRender:true,
                   listClass: 'x-combo-list-small'
                });
     var hrefbox=new Ext.form.ComboBox({
                   typeAhead: true,
                   triggerAction: 'all',
                   transform:'ishreffield',
                   lazyRender:true,
                   listClass: 'x-combo-list-small'
                });
        var browserCombo=new Ext.form.ComboBox({
                   typeAhead: true,
                   triggerAction: 'all',
                   transform:'isbrowser',
                   lazyRender:true,
                   listClass: 'x-combo-list-small'
                });
        var showMethodCombo=new Ext.form.ComboBox({
               typeAhead: true,
               triggerAction: 'all',
               transform:'showmethod',
               lazyRender:true,
               listClass: 'x-combo-list-small'}) ;
         var sm = new Ext.grid.CheckboxSelectionModel();
         cm = new Ext.grid.LockingColumnModel([
                 sm,
             {
              //   id:'common',
                 header: "<%=labelService.getLabelNameByKeyId("402881e70c919ba6010c923424cc000a")%>",//表单字段
                 dataIndex: 'fieldname',
                 width:100,
                 locked:true,
                 editor: new fm.TextField({
                     allowBlank: false,
                     readOnly:true
                 })
             },{
               header: '',
               dataIndex: 'label',
                width:15,
                locked:true
            },{

               header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc55f035001a")%>",//显示名称
               dataIndex: 'labelname',
                 width:100,
                 locked:true,
               //sortable:true,
           editor: new fm.TextField({
                   allowBlank: false
               })
            },{
               header: "<%=labelService.getLabelNameByKeyId("402880371b9ff70f011b9ffffed70004")%>",//显示顺序
               dataIndex:'dsporder',
                 width:100,
                //sortable:true,

               editor: new fm.TextField({
                   allowBlank: true
               })
            },{
               header: "<%=labelService.getLabelNameByKeyId("402881e70c90eb3b010c910fc4a70007")%>",//是否排序
               dataIndex: 'isorderfield',
                 width:100,
                //sortable:true,

               renderer:formatOrder,
               editor:orderCombo
            },{
               header: "<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220009")%>",//默认排序优先级
               dataIndex: 'priorder',
                 width:100
                //sortable:true,

               /* editor: new fm.TextField({
                   allowBlank: true
               })*/
            }
             ,{
               header: "<%=labelService.getLabelNameByKeyId("402881e70c90eb3b010c91106f7d000a")%>",//是否统计
               dataIndex: 'issum',
               renderer:formatSum,
                 width:100,
                //sortable:true,

               editor: sumCombo
            }
            ,{
               header: "是否提示",//是否提示
               dataIndex: 'col3',
               renderer:formatCol3,
                 width:100,
                //sortable:true,

               editor: col3Combo
            }
            ,{
                header: "<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000a")%>",//是否表单链接字段
               dataIndex: 'ishreffield',
               renderer:formatHref,
                 width:100,
                //sortable:true,

               editor: hrefbox  
             },{
               header: "<%=labelService.getLabelNameByKeyId("402881e70c90eb3b010c91129376000d")%>",//链接路径
               dataIndex:'hreflink',
                 width:300,
                //sortable:true,

               editor: new fm.TextField({
                   allowBlank: true
               })
            },{
               header: "<%=labelService.getLabelNameByKeyId("402881e70c90eb3b010c911423ea0010")%>",//报警条件
               dataIndex:'alertcond',
                //sortable:true,
                 width:300,
               editor: new fm.TextField({
                   allowBlank: true
               })
            },{
               header:"<%=labelService.getLabelNameByKeyId("402881e30f50a062010f50b92a0d00b2")%>",//显示列宽
               dataIndex:'showwidth',
                 width:100,
               //sortable:true,

            editor: new fm.NumberField({
               allowBlank: false,
               allowNegative: false,
               maxValue: 100000
           })
            },{
               header:"SQL",
               dataIndex:'sql',
                 width:300,
                //sortable:true,

            editor: new fm.TextField({
                   allowBlank: true
               })
            },{
               header: "Browser",
               dataIndex: 'isbrowser',
               renderer:formatBrowser,
                 width:100,
                //sortable:true,

               editor: browserCombo
            },{
               header:"ReportfieldID",
               dataIndex:'reportfieldid',
               hidden:true,
                 width:100,
             //sortable:true,

                editor: new fm.TextField({
                   allowBlank: true
               })

            },{
               header:"<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000b")%>",//显示方式
               dataIndex:'showmethod',
               renderer:formatShowMethod,
               editor:showMethodCombo,
                 width:100,
               allowBlank: true
            },{
               header:"htmltype",
               dataIndex:'htmltype',
               hidden:true,
              editor: new fm.TextField({
                   allowBlank: true
               })

            },{
                 header:"fieldtype",
                 dataIndex:'fieldtype',
                 hidden:true,
                 editor: new fm.TextField({
                   allowBlank: true
                            })

            },
                 {
               header:"formid",
               dataIndex:'formid',
              hidden:true,
             //sortable:true,

                editor: new fm.TextField({
                   allowBlank: true
               })

            },{
               header:"<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006c")%>",//表名
               dataIndex:'formname',
               width:100,
             //sortable:true,

                editor: new fm.TextField({
                   allowBlank: true,
                    readOnly:true
                    
               })

            }


        ]);

        // by default columns are sortable
        //cm.defaultSortable = true;

        // this could be inline, but we want to define the Plant record
        // type so we can add records dynamically
        var Plant = Ext.data.Record.create([
               // the "name" below matches the tag name to read, except "availDate"
               // which is mapped to the tag "availability"
               {name: 'fieldname', type: 'string'},
               {name: 'label', type: 'auto'},
               {name: 'labelname', type: 'string'},
               {name: 'dsporder', type: 'string'},
               {name: 'isorderfield'},
                {name: 'priorder',type:'string'},
               {name: 'issum'},
               {name: 'col3',type:'string'},
               {name: 'hreflink', type: 'string'},             // automatic date conversions
               {name: 'alertcond', type: 'string'},
               {name: 'showwidth', type: 'string'},
               {name: 'sql', type: 'string'},
                {name: 'htmltype', type: 'string'},
                {name: 'fieldtype', type: 'string'},
                {name: 'isbrowser'},
                {name: 'showmethod',type:'string'},
               {name: 'reportfieldid', type: 'string'},
                {name: 'formid', type: 'string'},
                {name: 'formname', type: 'string'},
               {name: 'indoor', type: 'bool'}
          ]);
      var showmethod_array1 = [
          ['0','<%=labelService.getLabelNameByKeyId("402881e50acff854010ad05534de0005")%>'],//选择项
          ['1','<%=labelService.getLabelNameByKeyId("402883d934c165d70134c165d8590000")%>'],//图标
          ['2','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000c")%>']//图标+选择项
      ]

      var showmethod_array2 = [
          ['3','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000d")%>'],//数值
          ['4','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000e")%>']//进度条
      ]

    // create the Data Store
    store = new Ext.data.Store({
         proxy: new Ext.data.HttpProxy({
            url: '<%=action3%>'
        }),

        // the return will be XML, so lets set up a reader
     reader: new Ext.data.JsonReader({
         root: 'result',
         totalProperty: 'totalCount',
         fields: ['fieldname','label','labelname','dsporder','isorderfield','ishreffield','priorder','issum','col3','hreflink','alertcond','showwidth','sql','isbrowser','reportfieldid','indoor','showmethod','htmltype','fieldtype','formid','formname']
        }),
        remoteSort: true
    });
    // create the editor grid
   var grid = new Ext.grid.LockingEditorGridPanel({
        store: store,
        cm: cm,
        sm:sm,
        region: 'center',
     //   autoExpandColumn:'common',
         loadMask: true,
        frame:true,
        clicksToEdit:1,
        viewConfig: {
                           center: {autoScroll: true},
                           forceFit:false,
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
        tbar: [{
            text: '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360052")%>',//新增字段
            handler : function(){
                var p = new Plant({
                    fieldname: '',
                    labelname: '',
                    dsporder: '',
                    isorderfield: '0',
                    issum: '0',
                    col3:'0',
                    hreflink:'',
                    alertcond:'',
                    showwidth:'',
                    sql:'',
                    isbrowser:'0',
                    reportfieldid:'',
                    indoor:false
                });
                grid.stopEditing();
                store.insert(0, p);
                grid.startEditing(0, 0);
                //selectAllChange(sm,grid);
            }
        }]
    });
    grid.on("cellclick",function (grid, rowIndex, columnIndex, e) {
          var record = grid.store.getAt(rowIndex);
        if (columnIndex == 6 && (record.get('isorderfield') == 1 || record.get('isorderfield') == 2))
        {
            grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                allowBlank: true

            })));
        } else if (columnIndex == 6) {


            grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                allowBlank: true,
                readOnly:true
            })));
        }
        if (columnIndex == 16) {
            var record = grid.store.getAt(rowIndex);
            if (record.get('htmltype') == 5) {
                grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                    typeAhead: true,
                    triggerAction: 'all',
                    store: new Ext.data.SimpleStore({
                        fields: ['value', 'text'],
                        data : showmethod_array1
                    }),
                    mode: 'local',
                    valueField:'value',
                    displayField:'text',
                    lazyRender:true,
                    listClass: 'x-combo-list-small'})));
            } else if (record.get('htmltype') == 1) {
                 if(record.get('fieldtype')==2||record.get('fieldtype')==3){
                 grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                    typeAhead: true,
                    triggerAction: 'all',
                    store: new Ext.data.SimpleStore({
                        fields: ['value', 'text'],
                        data : showmethod_array2
                    }),
                    valueField:'value',
                    displayField:'text',
                    mode: 'local',
                    lazyRender:true,
                    listClass: 'x-combo-list-small'})));}
                   else
                   {
                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                    allowBlank: true,
                    readOnly:true
                })));
                   }
            } else {

                grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                    allowBlank: true,
                    readOnly:true
                })));
            }
        }
    });
    grid.on('validateedit',function(e){
        if(e.column==5){
            if(e.value==0||e.value==3);
            e.record.set('priorder',''); 
        }
    })
     wizard.render(Ext.getBody());
 // trigger the data store load
    store.load();
    store.on('load',function(st,recs) {
        for (var i = 0; i < recs.length; i++) {
            var indoor = recs[i].get('indoor');
            if (indoor) {
                sm.selectRecords([recs[i]], true);
            }
        }
    }
            );
    sm.on('rowselect', function(selMdl, rowIndex, rec) {
        rec.set('indoor', true);
		//selectAllChange(this,this.grid);
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        rec.set('indoor', false); 
        //selectAllChange(this,this.grid);
    }
            );
      	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini',height:300},grid]
	});
	
});
/*
function selectAllChange(sm,grid){
	//return false;
	var storelen = store.getCount();
	var selectedlen = sm.getSelections().length;
	var gridEl = grid.getEl();//得到表格的EL对象   
	var hd = gridEl.select('div.x-grid3-hd-checker');//得到表格头部的全选CheckBox框
	//alert(storelen+"-"+selectedlen);
	
	if(storelen==selectedlen){
		//var isChecked = hd.hasClass('x-grid3-hd-checker-on');   
        //判断头部的全选CheckBox框是否选中，如果是，则删除   
			hd.addClass('x-grid3-hd-checker-on');
	}else{
		var isChecked = hd.hasClass('x-grid3-hd-checker-on');   
        //判断头部的全选CheckBox框是否选中，如果是，则删除   
        if(isChecked){   
            hd.removeClass('x-grid3-hd-checker-on');   
        }
	}
	return false;
}
*/
 function myLoad(){
     var myTable=document.getElementById("mytable");
     myTable.style.width=document.body.clientWidth-10;

}
</script>
    <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head> 
 <body  style="margin:10px,10px,10px,0px;padding:0px" onload="myLoad()">

 <div id="divSearch">

 <%


paravaluehm.put("{id}",id);
int righttype = permissiondetailService.getOpttype(id);
if(righttype%3!=0){
    response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
    return;
}
if(righttype%15==0){
	pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
	pagemenustr += "{D,"+labelService.getLabelName("402881e70caedf88010caf7e85e10020")+",javascript:window.open('"+request.getContextPath()+"/workflow/report/reportdefsearch.jsp?id="+id+"&formid="+reportdef.getFormid()+"');}";
    pagemenustr += "{M,"+labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000f")+",javascript:showWizard()}";//生成报表菜单
    pagemenustr += "{C,"+labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220010")+",javascript:onCopyReport('"+id+"','"+reportobjname+"')}";//报表复制
}
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:location.href='/workflow/report/reportdeflist.jsp?moduleid="+moduleid+"';}";
//if(righttype%165==0)
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
//pagemenustr += _pagemenuService2.getPagemenuStr(id,paravaluehm); 
 if(pagemenuorder.equals("3")) {
	pagemenustr =_pagemenuService2.getPagemenuStr(theuri,paravaluehm)+pagemenustr;
}else{
	pagemenustr =pagemenustr+_pagemenuService2.getPagemenuStr(theuri,paravaluehm);
}
pagemenustr += "{K,"+labelService.getLabelName("402881e70c430602010c4374bffd0010")+",javascript:window.open('"+request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable=reportdef&objid="+id+"')}";
   if("docbase".equals(forminfo.getObjtablename())||"humres".equals(forminfo.getObjtablename())){;}else{
     pagemenustr += "{V,"+labelService.getLabelNameByKeyId("402881ee0c715de3010c71b9b409001c")+",javascript:onUrl('/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid="+reportdef.getId()+"','"+labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220011")+"','tab"+reportdef.getId()+"') }";//预览    预览报表
   }
 String pagemenubarstr = _pagemenuService2.getPagemenuBarstr(pagemenustr);
  pagemenubarstr=pagemenubarstr.replace("\\\"","\"") ;
%>
 <div id="pagemenubar" style="z-index:100;">
 <%=pagemenubarstr%>
  </div>

<!-- form -->
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=modify&id=<%=id%>" name="EweaverForm" id="EweaverForm" method="post">
 <input type="hidden" name="jsonstr" id="jsonstr" value="">
 <input type="hidden" name="id" value="<%=StringHelper.null2String(reportdef.getId())%>">
 <input type="hidden" name="moduleid" value="<%=StringHelper.null2String(reportdef.getModuleid())%>">
 <input type="hidden"  name="objtype2" value="workflow"/>
<table id="mytable">
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>
  <tr>
	<td valign=top width="100%">
		       <table class=noborder>
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tr>
					<td class="FieldName" nowrap>
					    <%=labelService.getLabelName("402881e80ca5d67a010ca5e245050009")%><!-- 报表名称-->
					</td>
					<td class="FieldValue">
					<%
						String repobjname = reportobjname.replaceAll("\\\\\'","\\'");
					%>
						<input type="text" class="InputStyle2" style="width:50%" name="objname" value="<%=repobjname%>"/>
						<%if((StringHelper.null2String(reportdef.getObjname())).equals("")){%>
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
						<%}%>
					</td>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%><!-- 表单名称 -->
					<td class="FieldValue">
                    <%  if(!StringHelper.isEmpty(formid)&&forminfo.getObjtype()==1){%>   <!--抽象表单-->
                       <input type="hidden"  name="formid" value="<%=formid%>"/>
                    <%=formname%>
                    <%}else{%>
                       <%-- <button  class=Browser onclick="javascript:getBrowser('/workflow/form/forminfobrowser.jsp','formid','formidspan','0');"></button>--%>
						<input type="hidden"  name="formid" value="<%=formid%>"/>
						<span id="formidspan"><%=formname%></span>
                     <%}%>
                    </td>
				</tr>
                   <%
                   if(!StringHelper.isEmpty(formid)&&forminfo.getObjtype()==1)//为抽象表单
                   {
                   %>
                    <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220012")%>：<!-- 主表名称 -->
					</td>
					<td class="FieldValue">
					<%
                      String forminfotable = forminfo.getObjtablename();
                  String sql = "select id from forminfo where objtablename='" + forminfotable + "' and objtype=0";
                   List list = forminfoService.getBaseJdbcDao().getJdbcTemplate().queryForList(sql);
                        String forminfoid="";
                     for (Object o : list) {
                     forminfoid = ((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
                     }
                      Forminfo Forminfomain=forminfoService.getForminfoById(forminfoid);

                    %>
                      <%=Forminfomain.getObjname()%>
                    </td>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220013")%>：<!-- 从表名称 -->
					</td>
					<td class="FieldValue">
                      <input name="secformid" id="secformid" value="<%=reportdef.getSecformid()%>" type="hidden"/>
                        <%
                            Forminfo forminfoforsec=forminfoService.getForminfoById(reportdef.getSecformid());
                        %>
                        <%=forminfoforsec.getObjname()%>
                    </td>
				</tr>
                   <%}%>
                
                 <%if("docbase".equals(forminfo.getObjtablename())||"humres".equals(forminfo.getObjtablename())){
                     ;//屏蔽掉 文档报表和人力资源报表
                 }else{%>
                  <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006a")%><!-- 数据源 -->
					</td>
                    <td class="FieldValue">
                      <select class="inputstyle" id="isformbase" name="isformbase" <%if(isWorkflowVersionEnable){%>onchange="formbasechange();"<%}%>>
                        <%
                            String selectedone="";
                            String selectedtwo="";
                            String selectedthree="";

                          if(!StringHelper.isEmpty(reportdef.getIsformbase())&&StringHelper.trimToNull(reportdef.getIsformbase()).equals("0"))
                          {
                             selectedone = "selected";
                          }else if(!StringHelper.isEmpty(reportdef.getIsformbase())&&StringHelper.trimToNull(reportdef.getIsformbase()).equals("1")){
                             selectedtwo = "selected";
                          }else if((StringHelper.isEmpty(reportdef.getIsformbase()))||(!StringHelper.isEmpty(reportdef.getIsformbase())&&StringHelper.trimToNull(reportdef.getIsformbase()).equals("2"))){
                              selectedthree = "selected";
                          }

                        %>

                     <option value="0" <%=selectedone%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220014")%></option><!-- 全部数据 -->
                    <option value="1 " <%=selectedtwo%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220015")%></option><!-- 表单数据 -->
                     <option value="2"<%=selectedthree%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220016")%></option><!-- 流程数据 -->
                      </select>
					</td>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220017")%><!--  报表前显示CheckBox -->
                    </td>
                    <td class="FieldValue">
                        <select class="inputstyle" id="isbatchupdate" name="isbatchupdate">
                            <%
                                String selbatch0="";
                                String selbatch1="";
                                if(reportdef.getIsbatchupdate().intValue()==1){
                                      selbatch1="selected";
                                }else{
                                    selbatch0="selected";
                                }
                            %>
                            <option value="0" <%=selbatch0%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                            <option value="1" <%=selbatch1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                        </select>
                    </td>
                </tr>
                <tr id="trisshowversionquery" style="<%=trisshowversionquerystyle%>">
                	<td class="FieldName">
						显示流程版本查询条件
					</td>
					<td class="FieldValue" colspan="3">
						<select class="inputstyle" style="width:180px" id="isshowversionquery" name="isshowversionquery">
                        	<option <%if(!"1".equals(StringHelper.null2String(reportdef.getIsshowversionquery()))){ %> selected="selected" <%} %> value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                        	<option <%if("1".equals(StringHelper.null2String(reportdef.getIsshowversionquery()))){ %> selected="selected" <%} %> value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                        </select>
                    </td>
                </tr>
				<tr style="display:none;" >
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881540c9f83d6010c9f9c69800006")%><!-- 报表类型 -->
					</td>
					<td class="FieldValue">
                    <input name="selectitemid" id="selectitemid" value="<%=selectItemId%>" type="hidden"/>
					</td>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220018")%><!-- 数据监控 -->
					</td>
					<td class="FieldValue">
					 <select class="inputstyle" id="reportusge" name="reportusge">
                        <%
                            String selected1="";
                            String selected2="";
                        if(StringHelper.isEmpty(reportdef.getReportusage().toString())||(!StringHelper.isEmpty(reportdef.getReportusage().toString())&&reportdef.getReportusage().intValue()==0)){
                             selected1 = "selected";

                         }else if(!StringHelper.isEmpty(reportdef.getReportusage().toString())&&reportdef.getReportusage().intValue()==1){
                             selected2 = "selected";

                         }
                        %>

                     <option value="0"<%=selected1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                    <option value="1"<%=selected2%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->

                      </select>
					</td>
				</tr>
                <%}%>

               <%if(!StringHelper.isEmpty(formid)&&forminfo.getObjtype()==1){%>

               <%}else{%>
                <tr>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220019")%></td><!-- 显示模式 -->
					<td class="FieldValue" colspan="3">
					    <select id="viewType" name="viewType" onchange="changeViewType(this)">
                            <option value="0" <%if(viewType==0){%>selected<%}%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522001a")%></option><!-- 分页 -->
                            <option value="1" <%if(viewType==1){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0065")%></option><!-- 分组 -->
                            <option value="3" <%if(viewType==3){%>selected<%}%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522001b")%></option><!-- 多级分组 -->
                            <option value="2" <%if(viewType==2){%>selected<%}%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522001c")%></option><!-- 上下级 -->
                        </select>
                    </td>
				</tr>
                <%}%>
                <tr id="trexcel">
                    <td class="FieldName"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522001d")%></td><!-- 是否要导出Excel -->
                    <td class="FieldValue">
                        <select id="isexpexcel" name="isexpexcel">
                               <%
                            String selectedexcel1="";
                            String selectedexcel2="";
                            if(reportdef.getIsexpexcel().intValue()==0){
                                selectedexcel1="selected";
                            }else if(reportdef.getIsexpexcel().intValue()==1){
                              selectedexcel2="selected";
                            }
                        %>
                            <option value="1" <%=selectedexcel2%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                            <option value="0" <%=selectedexcel1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                        </select>
                    </td>
                  <td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522001e")%><!-- 是否定时刷新 -->
					</td>
					<td class="FieldValue">
					 <select class="inputstyle" id="isrefresh" name="isrefresh" onchange="RefreshChange(this)">
                        <%
                            String selected1="";
                            String selected2="";
                            if(reportdef.getIsrefresh().intValue()==0){
                                selected1="selected";
                            }else if(reportdef.getIsrefresh().intValue()==1){
                              selected2="selected";
                            }
                        %>

                    <option value="0" <%=selected1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                    <option value="1" <%=selected2%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->

                      </select>
					</td>
                </tr>
                <%if(reportdef.getIsrefresh().intValue()==0||reportdef.getIsrefresh().intValue()==-1){%>
                  <tr id="trdefaulttime" style="display:none">
                      <%}else{%>
                <tr id="trdefaulttime" style="display:block">
                    <%}%>
                  <td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522001f")%><!-- 默认刷新时间 -->
					</td>
					<td class="FieldValue">
					 <select class="inputstyle" id="defaulttime" name="defaulttime">
                         <%
                             String sel1 = "";
                             String sel2 = "";
                             String sel4 = "";
                             String sel5 = "";
                             String sel6 = "";
                             String sel7 = "";
                             String sel8 = "";
                             if (reportdef.getDefaulttime().intValue() == -1) {
                                sel1="selected";
                             } else if (reportdef.getDefaulttime().intValue() == 0) {
                                sel2="selected";
                             }  else if (reportdef.getDefaulttime().intValue() == 1) {
                                sel4="selected";
                             } else if (reportdef.getDefaulttime().intValue() == 2) {
                                 sel5="selected";
                             } else if (reportdef.getDefaulttime().intValue() == 5) {
                                 sel6="selected";
                             } else if (reportdef.getDefaulttime().intValue() == 10) {
                                  sel7="selected";
                             } else if (reportdef.getDefaulttime().intValue() == 15) {
                                 sel8="selected";
                             } else {
                               sel5="selected";
                             }


                         %>
                         <option value="-1" <%=sel1%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220020")%></option><!-- 从不 -->
                         <option value="0" <%=sel2%>>0</option>
                         <option value="1" <%=sel4%>>1</option>
                         <option value="2" <%=sel5%>>2</option>
                         <option value="5" <%=sel6%> >5</option>
                         <option value="10" <%=sel7%>>10</option>
                         <option value="15" <%=sel8%>>15</option>
                     </select>
					</td>
                </tr>
                <tr>
                	<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220021")%><!-- 数据删除类型 -->
					</td>
					<td class="FieldValue" colspan="3">
						<select class="inputstyle" style="width:180px" id="deleteType" name="deleteType">
                        	<option <%if(!reportdef.isReallyDelete()){ %> selected="selected" <%} %> value="0"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220022")%></option><!-- 逻辑删除 -->
                        	<option <%if(reportdef.isReallyDelete()){ %> selected="selected" <%} %> value="1"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220023")%></option><!-- 物理删除 -->
                        </select>
                        &nbsp;(<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220024")%>)<!-- 逻辑删除为假删除,物理删除会直接删除数据 -->
					</td>
                </tr>
                <!-- 查询限制条件(start) -->
                <tr class=Title>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220025")%><!-- 查询限制条件 -->
                    </td>
                    <td class="FieldValue" colspan="3">
                       <textarea style="width:100%" rows=4 name="selectConditions" ><%=StringHelper.null2String(reportdef.getSelectConditions())%></textarea>
                    </td>
                </tr>
                <!-- 查询限制条件(start) -->
                <%
ReportfieldService reportfieldService = (ReportfieldService) BaseContext.getBean("reportfieldService");
List reportfieldLists = reportfieldService.getReportfieldListByReportID(id);

    Forminfo forminfoObj = forminfoService.getForminfoById(reportdef.getFormid());

    List listObj=new ArrayList();
    List list = formfieldService.getAllFieldByFormIdExist(reportdef.getFormid());
    Iterator itObj=list.iterator();

    while(itObj.hasNext()){
        Formfield formfield = (Formfield)itObj.next();
        if(formfield != null && formfield.getHtmltype()!=null && formfield.getHtmltype()==6){
            Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
            if(forminfoObj.getObjtablename().equals(refobj.getReftable())){
                listObj.add(formfield);
            }
        }

    }
%>
                <tr id='grouptr' <%if(viewType==0||viewType==2){%>style='display:none'<%}%>>
					<td class="FieldName" nowrap>
                   <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220026")%><!-- 默认分组字段 -->
                    <td class="FieldValue" colspan="3">
					    <select id="groupby" name="groupby">
                            <%for(Object o:reportfieldLists){%>
                            <option value="<%=((Reportfield)o).getFormfieldid()%>" <%if(groupby.equals(((Reportfield)o).getFormfieldid())){%>selected<%}%>><%=((Reportfield)o).getShowname()%></option>
                            <%}%>
                        </select>
                    </td>
				</tr>
                <tr id='mgrouptr1' <%if(viewType==0||viewType==2||viewType==1){%>style='display:none'<%}%>>
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220027")%><!--  默认分组字段1 -->
                    <td class="FieldValue" colspan="3">
					    <select id="groupby1" name="groupby1">
                            <option value=""><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220028")%></option><!-- 未定义 -->
                            <%for(Object o:reportfieldLists){%>
                            <option value="<%=((Reportfield)o).getFormfieldid()%>" <%if(groupby1.equals(((Reportfield)o).getFormfieldid())){%>selected<%}%>><%=((Reportfield)o).getShowname()%></option>
                            <%}%>
                        </select>
                    </td>
				</tr>
                <tr id='mgrouptr2' <%if(viewType==0||viewType==2||viewType==1){%>style='display:none'<%}%>>
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220029")%><!-- 默认分组字段2 -->
                    <td class="FieldValue" colspan="3">
					    <select id="groupby2" name="groupby2">
                            <option value=""><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220028")%></option><!-- 未定义 -->
                            <%for(Object o:reportfieldLists){%>
                            <option value="<%=((Reportfield)o).getFormfieldid()%>" <%if(groupby2.equals(((Reportfield)o).getFormfieldid())){%>selected<%}%>><%=((Reportfield)o).getShowname()%></option>
                            <%}%>
                        </select>
                    </td>
				</tr>
                <tr id='grouptr1' <%if(viewType!=2){%>style='display:none'<%}%>>
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522002b")%><!--  自身关联字段 -->
                    <td class="FieldValue" colspan="3">
					    <select id="groupbytree" name="groupbytree">
                            <%for(Object o:listObj){%>
                            <option value="<%=((Formfield)o).getId()%>" <%if(groupbytree.equals(((Formfield)o).getId())){%>selected<%}%>><%=((Formfield)o).getLabelname()%></option>
                            <%}%>
                        </select>
                    </td>
				</tr>

                <tr id='treetr' <%if(viewType!=2){%>style='display:none'<%}%>>
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522002a")%><!-- 树关联显示字段 -->
                    <td class="FieldValue" colspan="3">
					    <select id="treeby" name="treeby">
                            <%for(Object o:reportfieldLists){%>
                            <option value="<%=((Reportfield)o).getFormfieldid()%>" <%if(treeby.equals(((Reportfield)o).getFormfieldid())){%>selected<%}%>><%=((Reportfield)o).getShowname()%></option>
                            <%}%>
                        </select>
                    </td>
				</tr>

		        <tr class="fieldname">
					<td nowrap><%=labelService.getLabelNameByKeyId("402881e80ca5d67a010ca5e3d98c000c")%></td><!-- 报表描述 -->
					<td class="FieldValue" colspan="3">
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="objdesc"><%=StringHelper.null2String(reportdef.getObjdesc())%></TEXTAREA>
					</td>
				</tr>
                <tr class="fieldname">
					<td nowrap><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522002c")%></td><!-- 脚本内容 -->
					<td class="FieldValue" colspan="3">
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="jscontent"><%=StringHelper.null2String(reportdef.getJscontent())%></TEXTAREA>
					</td>
				</tr>

</table>

               <br>
               <select name="isorderfield" id="isorderfield" style="display: none;">
                   <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                   <option value="3"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                   <option value="1"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522002d")%></option><!-- 默认升序 -->
                   <option value="2"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522002e")%></option><!-- 默认降序 -->

               </select>
               <select name="issum" id="issum" style="display: none;">
                   <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                   <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->

               </select>
               <select name="col3" id="col3" style="display: none;">
                   <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                   <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->

               </select>
                 <select name="ishreffield" id="ishreffield" style="display: none;">
                   <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                   <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->

               </select>
               <select name="isbrowser" id="isbrowser" style="display: none;">
                   <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                   <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->

               </select>
               <select name="showmethod" id="showmethod" style="display: none;">
                   <option value="-1"></option>
                   <option value="0"><%=labelService.getLabelNameByKeyId("402881e50acff854010ad05534de0005")%></option><!--选择项  -->
                   <option value="1"><%=labelService.getLabelNameByKeyId("402883d934c165d70134c165d8590000")%></option><!-- 图标 -->
                   <option value="2"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000c")%></option><!-- 图标+选择项 -->
                   <option value="3"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000d")%></option><!-- 数值 -->
                   <option value="4"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000e")%></option><!-- 进度条 -->
               </select>


</form>
 </div>
<div id="divstep1">
   <table style="width: 100">
       <tr>
       <td><input type="radio" name="radioname" value="1" checked onclick="step3.setSkip(true);step2.setSkip(false)">
        <%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550018")%></td><!-- 报表列表 -->
       </tr>
        <tr>
         <td><input type="radio" name="radioname"  value="2" onclick="step3.setSkip(false);step2.setSkip(true)">
         <%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550019")%></td><!-- 报表查询 -->
       </tr>
   </table> 
</div>
 <div id="divstep2">
   <table style="width: 100">
       <tr>
           <td><input type="radio" name="radioname2" checked onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="1"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550023")%></td><!-- 表单报表 -->
       </tr>
        <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="2"><%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f5a17310043")%></td><!-- 流程报表 -->
       </tr>
       <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="3"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550024")%></td><!-- 全部数据报表 -->
       </tr>
       <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(true);step5.setSkip(true);step6.setSkip(false);step7.setSkip(true)" value="4"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550025")%></td><!-- 自定义报表 -->
       </tr>
   </table>
     </div>
     <div id="divstep3">
   <table style="width: 100%">
       <tr>
           <td><input type="radio" name="radioname3" checked onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="1"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550026")%></td><!--表单查询页面  -->
       </tr>
        <tr>
           <td><input type="radio" name="radioname3" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="2"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550027")%></td><!-- 流程查询页面 -->
       </tr>
       <tr>
           <td><input type="radio" name="radioname3" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="3"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220000")%></td><!-- 全部数据查询页面 -->
       </tr>
       <tr>
           <td><input type="radio" name="radioname3" onclick="step4.setSkip(true);step5.setSkip(true);step6.setSkip(true);step7.setSkip(false)" value="4"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220001")%></td><!-- 自定义查询页面 -->
       </tr>
   </table>
</div>
  <div id="divimg">
      <br>
      <table>
          <tr>
					<td >
						imgfile
					</td>
					<td >
						<input type="text" name="imagfile" id="imagfile"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step5.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%></a><!-- 浏览.. -->
					</td>
				</tr>
      </table>
  </div>
 <div id="divlist">
      <br>
      <table>
          <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname1" id="menuname1" value="<%=reportdef.getObjname()%><%=labelService.getLabelNameByKeyId("402881e80b708c4f010b70a20640002b")%>" class="InputStyle2" onchange="step6.fireEvent('clientvalidation',this)"></td><!-- 列表 -->
          </tr>
          <tr>
					<td >
						imgfile:
					</td>
					<td >
						<input type="text" name="imagfile1" id="imagfile1"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step6.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre1" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%></a><!-- 浏览.. -->
					</td>
				</tr>
          <tr>

               <td>url:</td>
            <td><textarea rows="5" cols="35"  name="urll" id="urll" class="InputStyle" onchange="step6.fireEvent('clientvalidation',this)">/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=<%=reportdef.getId()%></textarea></td>
          </tr>
      </table>
  </div>
 <div id="divsearch1">
      <br>
      <table>
          <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname2" id="menuname2" value="<%=reportdef.getObjname()%><%=labelService.getLabelNameByKeyId("402881e80b708c4f010b70a20640002b")%>" class="InputStyle2" onchange="step7.fireEvent('clientvalidation',this)"></td><!-- 列表 -->
          </tr>
          <tr>
					<td >
						imgfile:
					</td>
					<td >
						<input type="text" name="imagfile2" id="imagfile2"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step7.fireEvent('clientvalidation',this)" />
						<img id="imgFilePre2" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);"><%=labelService.getLabelNameByKeyId("402883fb35e5b5730135e5b574950000")%></a><!-- 浏览.. -->
					</td>
				</tr>
          <tr>

               <td>url:</td>
            <td><textarea rows="5" cols="35"  name="url2" id="url2" class="InputStyle" onchange="step7.fireEvent('clientvalidation',this)">/workflow/report/reportsearch.jsp?reportid=<%=reportdef.getId()%></textarea></td>
          </tr>
      </table>
  </div>
  
  <div id="divdisplay" >
    <table border="0" style="width: 100%">
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
    function MakeCondition(){
        document.location.href="<%=request.getContextPath()%>/workflow/report/reportdefsearch.jsp?id=<%=id%>&formid=<%=reportdef.getFormid()%>";
    }
 function BrowserImages(obj){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=contextPath+ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=contextPath+ret
}
function onSubmit(){
if(document.getElementById("viewType")!=null && document.getElementById("viewType").value==1){

    if(document.getElementById("groupby").value==null||document.getElementById("groupby").value==""){
        alert("<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522002f")%>");//分组显示模式下默认分组字段不能为空
        return;
    }
}else if(document.getElementById("viewType")!=null && document.getElementById("viewType").value==2){
    if(document.getElementById("groupbytree").value==null||document.getElementById("groupbytree").value==""){
        alert("<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220030")%>");//上下级显示模式下自身关联字段不能为空
        return;
    }
    if(document.getElementById("treeby").value==null||document.getElementById("treeby").value==""){
        alert("<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220031")%>");//上下级显示模式下树关联显示字段不能为空
        return;
    }
}

    var records = store.getModifiedRecords(); 
    var datas = new Array();
    for(var i=0,len=records.length;i<len;i++){
    	datas.push(records[i].data);
    }
    document.getElementById('jsonstr').value = Ext.util.JSON.encode(datas);
    checkfields = "";
    checkmessage = "<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
    if (checkForm(EweaverForm, checkfields, checkmessage)) {
        document.EweaverForm.submit();
    }
}
function addpermission(url) {
	openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>" + url);

}
  function changeViewType(o){
      if(o.value==0){
       document.getElementById('grouptr').style.display ='none';
       document.getElementById('mgrouptr1').style.display ='none';
       document.getElementById('mgrouptr2').style.display ='none';
       document.getElementById('grouptr1').style.display ='none';   
       document.getElementById('treetr').style.display ='none';
        document.getElementById('trexcel').style.display='';
      }
      else if(o.value==1){
       document.getElementById('grouptr').style.display ='';
       document.getElementById('mgrouptr1').style.display ='none';
       document.getElementById('mgrouptr2').style.display ='none';
       document.getElementById('grouptr1').style.display ='none';
       document.getElementById('treetr').style.display ='none';
          document.getElementById('trexcel').style.display='none';


      }
      else if(o.value==2){
       document.getElementById('grouptr').style.display ='none';
       document.getElementById('mgrouptr1').style.display ='none';
       document.getElementById('mgrouptr2').style.display ='none';   
       document.getElementById('grouptr1').style.display ='';
       document.getElementById('treetr').style.display ='';
     document.getElementById('trexcel').style.display='none';

      }
      else if(o.value==3){
       document.getElementById('grouptr').style.display ='';
       document.getElementById('mgrouptr1').style.display ='';
       document.getElementById('mgrouptr2').style.display ='';
       document.getElementById('grouptr1').style.display ='none';
       document.getElementById('treetr').style.display ='none';
          document.getElementById('trexcel').style.display='none';


      }

  }
  function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
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
 }
    function showWizard(){
      wizard.show();
        step3.setSkip(true);
        step2.setSkip(false);
        step4.setSkip(false);
        step5.setSkip(false);
        step6.setSkip(true);
        step7.setSkip(true);
        step5.on('clientvalidation', function(){
                   if(document.getElementById('imagfile').value!=null&&document.getElementById('imagfile').value!='')
                   this.wizard.nextButton.setDisabled(false);
                   else{
                   this.wizard.nextButton.setDisabled(true);
                   }

           });
         step6.on('clientvalidation', function(){
          if ((document.getElementById('menuname1').value != null && document.getElementById('menuname1').value != '')&&(document.getElementById('imagfile1').value != null && document.getElementById('imagfile1').value != '')&&(document.getElementById('urll').value != null && document.getElementById('urll').value != ''))
              this.wizard.nextButton.setDisabled(false);
          else {
              this.wizard.nextButton.setDisabled(true);
          }

           });
         step7.on('clientvalidation', function(){
          if ((document.getElementById('menuname2').value != null && document.getElementById('menuname2').value != '')&&(document.getElementById('imagfile2').value != null && document.getElementById('imagfile2').value != '')&&(document.getElementById('url2').value != null && document.getElementById('url2').value != ''))
              this.wizard.nextButton.setDisabled(false);
          else {
              this.wizard.nextButton.setDisabled(true);
          }

           });
         step8.on('clientvalidation', function(){
             if (menutree.getChecked().length>0)
                 this.wizard.nextButton.setDisabled(false);
             else {
                 this.wizard.nextButton.setDisabled(true);
             }

              });
    }
    function RefreshChange(obj){
       if(obj.value==0){
         document.all('trdefaulttime').style.display='none';
       }else{
           document.all('trdefaulttime').style.display='block';
       }
    }
    
   function onCopyReport(reportid,reportname) {
       if(confirm('<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220032")%><< ' + reportname + ' >>?')) {//是否复制报表
          Ext.Ajax.request({
           url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=copy',
           params:{reportid:reportid,reportname:reportname},
           success: function(response) {
             var rs = response.responseText;
             if(rs == 0) {
                 alert('<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220033")%>');//流程ID为空无法复制!
             } else {
                 if(confirm('<%=labelService.getLabelNameByKeyId("402881f00c9078ba010c907b291a0006")%><< ' + reportname + ' >><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220034")%>' )) {//报表      复制完成!是否直接打开?
                     document.location.href = '/workflow/report/reportmodify.jsp?id='+rs+'&moduleid=<%=reportdef.getModuleid()%>';
                 }
             }           
           }
      	   });     
       }
      
   }
   
   function formbasechange(){
	   var value=document.getElementById("isformbase").value;
	   if(value=="2"){
		   document.getElementById("trisshowversionquery").style.display="";
	   }else{
		   document.getElementById("trisshowversionquery").style.display="none";
	   }
   }
</script>

</body>
</html>
