<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%
  String rootid="r00t";
String roottext=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2396930016");//系统模块
String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
Selectitem selectitem;
String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=getreportdeflist";
String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
if(!StringHelper.isEmpty(moduleid))
action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=getreportdeflist&moduleid="+moduleid;
     String rootidmenu="r00t";
   String roottextmenu=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2347c00015");//用户菜单
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    if(!StringHelper.isEmpty(moduleid))
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','C','accept',function(){onCreate()});";
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除
    pagemenustr+="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934c1b7b70134c1b7b8860000")+"','X','cut',function(){onMove()});";//移动
   if(!StringHelper.isEmpty(moduleid))
     pagemenustr+="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550016")+"','M','page',function(){showWizard()});";//生成菜单

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


  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>

    <script language="javascript">
    var currentreportid;
    var currentmenuname;
     var step1,step2,step3,step4,step5,step6,step7,step8;
     var wizard;
      var pidvalue;
    Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
    var store;
    var selected = new Array();
    var dlg0;
    var dlgtree;
   var nodeid;
    var  moduleTree
    var menutree;
    Ext.onReady(function() {
        Ext.QuickTips.init();
    <%if(!pagemenustr.equals("")){%>
        var tb = new Ext.Toolbar();
        tb.render('pagemenubar');
    <%=pagemenustr%>
    <%}%>
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
        var text1
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
                 text1=new Ext.form.TextField({
                        name       : 'menuname',
                        fieldLabel : 'MenuName',
                        allowBlank : false,
                         value:currentmenuname,
                       disabled:false
                    })
                ]
            });
           step5=new Ext.ux.Wiz.Card({
                title        : '<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec713003d")%>',//图片
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
                        contentEl :'divdisplay'
                }
                         ]
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
    })

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
                      url='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=1&reportid='+currentreportid;
                  }else if(obj.s2.radioname2==2){ // 流程数据
                    url='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=2&reportid='+currentreportid;
                  }else if(obj.s2.radioname2==3){   //全部数据
                      url='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid='+currentreportid;
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
                     url='/workflow/report/reportsearch.jsp?isformbase=1&reportid='+currentreportid;
                  }else if(obj.s3.radioname3==2){ //流程查询页面
                      url='/workflow/report/reportsearch.jsp?isformbase=2&reportid='+currentreportid;
                  }else if(obj.s3.radioname3==3){ //全部查询页面
                         url='/workflow/report/reportsearch.jsp?isformbase=0&reportid='+currentreportid;
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
                                        this.dlg0.show()
                                     }else{
                                      Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                                  Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550020")%>');//配置页面菜单成功
                             }
                         }
                   });
              }
        store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '<%=action%>'
            }),
            reader: new Ext.data.JsonReader({
                root: 'result',
                totalProperty: 'totalcount',
                fields: ['objname','objtypename','objdesc','modulename','id']


            })

        });
        var sm = new Ext.grid.CheckboxSelectionModel();

        var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402881e80ca5d67a010ca5e245050009")%>", sortable: false,  dataIndex: 'objname'},//报表名称
            {header: "<%=labelService.getLabelNameByKeyId("402881540c9f83d6010c9f9c69800006")%>", sortable: false,   dataIndex: 'objtypename'},//报表类型
            {header: "<%=labelService.getLabelNameByKeyId("402881e80ca5d67a010ca5e3d98c000c")%>",  sortable: false, dataIndex: 'objdesc'},//报表描述
            {header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%>",  sortable: false, dataIndex: 'modulename'}//模块名称
        ]);
        cm.defaultSortable = true;
        var grid = new Ext.grid.GridPanel({
            region: 'center',
            store: store,
            cm: cm,
            trackMouseOver:false,
            sm:sm ,
            loadMask: true,
             viewConfig: {
                                     forceFit:true,
                                     enableRowBody:true,
                                     sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                     sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                     columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                     getRowClass : function(record, rowIndex, p, store){
                                         return 'x-grid3-row-collapsed';
                                     }
                                 },
                                 bbar: new Ext.PagingToolbar({
                                     pageSize: 20,
                      store: store,
                      displayInfo: true,
                      beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                      afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                      firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                      prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                      nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                      lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                      displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%>{0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示    条记录
                      emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                  })

        });


        //Viewport
        store.on('load',function(st,recs){
               for(var i=0;i<recs.length;i++){
                   var reqid=recs[i].get('id');
               for(var j=0;j<selected.length;j++){
                           if(reqid ==selected[j]){
                                sm.selectRecords([recs[i]],true);
                            }
                        }
           }
           }
                   );
           sm.on('rowselect',function(selMdl,rowIndex,rec ){
               currentreportid=rec.get('id');
               currentmenuname=rec.get('objname');
               var start=currentmenuname.indexOf('>');
               var end=currentmenuname.lastIndexOf('<');
               text1.setValue(currentmenuname.substring(start+1,end));
               var reqid=rec.get('id');
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
                                return;
                            }
                        }
               selected.push(reqid)
           }
                   );
           sm.on('rowdeselect',function(selMdl,rowIndex,rec){
               var reqid=rec.get('id');
               currentreportid='';
               currentmenuname='';
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
                               selected.remove(reqid)
                                return;
                            }
                        }

           }
                   );
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        wizard.render(Ext.getBody());

        store.baseParams.selectItemId='<%=selectItemId%>'
        store.load({params:{start:0, limit:20}});
        moduleTree = new Ext.tree.TreePanel({
                  // animate:true,
                   //title: '&nbsp;',
                    checkModel: 'single',
                   animate: false,
                   useArrows :true,
                   containerScroll: true,
                   autoScroll:true,

                   //lines:true,
                   region:'center',
                   collapsible: true,
                   collapsed : false,
                   rootVisible:true,
                   root:new Ext.tree.AsyncTreeNode({
                       text: '<%=roottext%>',
                       id:'<%=rootid%>',
                       iconCls:'pkg',
                       expanded:true,
                       hrefTarget:'moduleframe',
                       href:'<%=request.getContextPath()%>/base/module/modulemodify.jsp',
                       allowDrag:false,
                       allowDrop:true
                   }),
               loader:new Ext.tree.TreeLoader({
                   dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig&isonlytree=1",
                   preloadChildren:false,
                    baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
               }
                       )
           });
         moduleTree.on('checkchange',function(n,c){
     nodeid=n.id ;
    })
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
                    store.load({params:{start:0, limit:20}});
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

         dlgtree = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.4,
           height:viewport.getSize().height * 0.4,
           buttons: [{
               text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>',//确定
               handler  : function() {
                   this.disable();
                   Ext.Ajax.request({
                                           url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=move',
                                                params:{ids:selected.toString(),nodeid:nodeid},
                                               success: function() {

                                                   selected=[];
                                                   this.dlgtree.hide();
                                                   onSearch();

                                               }
                                           });

                   this.enable();                 
               }

           },{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%>',//取消
               handler  : function() {
                   dlgtree.hide();
               }
           }],
           items:[moduleTree]
       });
       dlgtree.render(Ext.getBody());
    });
    </script>
     <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
 <div id="divSearch">
<div id="pagemenubar"></div>

      	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=search" name="EweaverForm" id="EweaverForm" method="post" onsubmit="return false">
		   <table id=searchTable>
       <tr>
         <%if(StringHelper.isEmpty(moduleid)){%>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881540c9f83d6010c9f9c69800006")%>
		 </td>                  
         <td class="FieldValue">
		     <select class="inputstyle" id="selectitemid" name="selectitemid" onChange="javascript:onSearch();">
                  <option value="" <%=selectItemId==null?"selected":""%>></option>
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectitem.getId().equals(selectItemId)) selected = "selected";              
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>
                   
                   <%
                   } // end while
                   %>
		       </select>
		      
          </td>
            <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("402883d934c1bfa30134c1bfa4540000")%><!-- 模块 -->
		 </td>
         <td class="FieldValue" width="15%">

              <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden"  name="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
           <%}%>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("4028818f1006078f0110061a70250009")%>
		 </td>                  
         <td class="FieldValue">
		     <select class="inputstyle" id="objtype2" name="objtype2" onChange="javascript:onSearch();">
                  <option value="" ></option>
				  <option value="workflow"><%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f5a17310043")%></option><!-- 流程报表 -->
                  <option value="sql"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000f")%></option><!-- SQL报表 -->
                  <option value="birt"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460010")%></option><!-- BIRT报表 -->
		       </select> 
          </td>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("402881e80ca5d67a010ca5e245050009")%><!-- 报表名称 -->
		 </td>                  
          <td class="FieldValue">
             <input type="text" name= "objname" id="objname"/>
          </td>
	    </tr>    
   </table>
      	</form>
      </div>
 <div id="divstep1">
   <table>
       <tr>
           <td><input type="radio" name="radioname" value="1" checked onclick="step3.setSkip(true);step2.setSkip(false)"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550018")%></td><!-- 报表列表 -->
       </tr>
        <tr>
           <td><input type="radio" name="radioname"  value="2" onclick="step3.setSkip(false);step2.setSkip(true)"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550019")%></td><!-- 报表查询 -->
       </tr>
   </table>
</div>
 <div id="divstep2">
   <table>
       <tr>
           <td><input type="radio" name="radioname2" checked onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="1"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550023")%></td><!-- 表单报表 -->
       </tr>
        <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="2"><%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f5a17310043")%></td><!-- 流程报表 -->
       </tr>
       <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="3"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550024")%></td><!--全部数据报表  -->
       </tr>
       <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(true);step5.setSkip(true);step6.setSkip(false);step7.setSkip(true)" value="4"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550025")%></td><!-- 自定义报表 -->
       </tr>
   </table>
     </div>
     <div id="divstep3">
   <table>
       <tr>
           <td><input type="radio" name="radioname3" checked onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="1"><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550026")%></td><!-- 表单查询页面 -->
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
            <td><input type="text" name="menuname1" id="menuname1" value="" class="InputStyle2" onchange="step6.fireEvent('clientvalidation',this)"></td>
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
            <td><textarea rows="5" cols="35"  name="urll" id="urll" class="InputStyle" onchange="step6.fireEvent('clientvalidation',this)">/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search</textarea></td>
          </tr>
      </table>
  </div>
 <div id="divsearch1">
      <br>
      <table>
          <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname2" id="menuname2" value="" class="InputStyle2" onchange="step7.fireEvent('clientvalidation',this)"></td>
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
            <td><textarea rows="5" cols="35"  name="url2" id="url2" class="InputStyle" onchange="step7.fireEvent('clientvalidation',this)">/workflow/report/reportsearch.jsp?</textarea></td>
          </tr>
      </table>
  </div>
  
  <div id="divdisplay" >
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
 <script language="javascript" type="text/javascript">
     function BrowserImages(obj){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=contextPath+ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=contextPath+ret
}
     function showWizard(){
         if(currentreportid==null||currentreportid==''){
             Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220002")%>')//请选择要生成页面的报表!
             return;
         }
          var start=currentmenuname.indexOf('>');
          var end=currentmenuname.lastIndexOf('<');
        document.getElementById('menuname1').value=currentmenuname.substring(start+1,end);
        document.getElementById('menuname2').value=currentmenuname.substring(start+1,end);
         document.getElementById('urll').value='/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid='+currentreportid;
         document.getElementById('url2').value='/workflow/report/reportsearch.jsp?isformbase=1&reportid='+currentreportid;
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
      function onMove()
    {
       if (selected.length == 0) {
            Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1c4290134c1c42a830000")%>');//请选择要移动的内容！
            return;
        }
         this.dlgtree.show();
    }
     function onCreate()
     {
         location.href='<%=request.getContextPath()%>/workflow/report/reportcreate.jsp?moduleid=<%=moduleid%>';
     }
  function onSearch(){
 var o = $('#EweaverForm').serializeArray();
      var data = {};
      for (var i = 0; i < o.length; i++) {
          if (o[i].value != null && o[i].value != "") {
              data[o[i].name] = o[i].value;
          }
      }
      store.baseParams = data;
      store.load({params:{start:0, limit:20}});  }
       $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch();
       }
   });
      function onDelete()
     {
         if (selected.length == 0) {
             Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
             Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000")%>');//请选择要删除的内容！
             return;
         }
         Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>'};//是    否
         Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075")%>', function (btn, text) {//您确定要删除吗?
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=delete',
                     params:{ids:selected.toString()},
                     success: function() {
                         selected = [];
                         store.load({params:{start:0, limit:20}});
                     }
                 });
             } else {
                 selected = [];
                 store.load({params:{start:0, limit:20}});
             }
         });

     }
      function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        try {
            id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                document.all(inputname).value = id[0];
                document.all(inputspan).innerHTML = id[1];
            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
        }
    }         
</script>
  </body>
</html>
