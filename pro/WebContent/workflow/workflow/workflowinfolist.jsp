<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%
      String rootid="r00t";
String roottext=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2396930016");//系统模块
  String workflowid  =  StringHelper.null2String(request.getParameter("workflowid"));
  String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  ForminfoService forminfoService =(ForminfoService)BaseContext.getBean("forminfoService"); 
  Forminfo forminfo = null;
  SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
  Setitem gmode=setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
    String graphmode ="0";
    if(gmode!=null&&!StringHelper.isEmpty(gmode.getItemvalue())){
       graphmode=gmode.getItemvalue();
    }
  List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//资源类型  
//  if(selectItemId.equals("") && selectitemlist.size()>0) 
//   selectItemId = ((Selectitem) selectitemlist.get(0)).getId();
  Selectitem selectitem = new Selectitem();
  WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
  Workflowinfo workflowinfo = new Workflowinfo();
  List workflowinfoList = new ArrayList();
  Map m = new HashMap();

 Map tempMap = (Map)request.getSession().getAttribute("workflowinfoMap");
 if (tempMap!=null) m = tempMap;
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=getworkflowinfolist";
String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
if(!StringHelper.isEmpty(moduleid))
action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=getworkflowinfolist&moduleid="+moduleid;
%>
<%
  pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    if(!StringHelper.isEmpty(moduleid))
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onCreate('"+request.getContextPath()+"/workflow/workflow/workflowinfocreate.jsp?moduleid="+moduleid+"')});";
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042")+"','R','erase',function(){onReset()});";//清空条件
    pagemenustr+="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934c1b7b70134c1b7b8860000")+"','X','cut',function(){onMove()});";//移动
    if(!StringHelper.isEmpty(moduleid))
    pagemenustr+="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550016")+"','M','page',function(){showWizard()});";//生成菜单
   String rootidmenu="r00t";
   String roottextmenu=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2347c00015");//用户菜单


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
     var currentworkflowid;
     var currentmenuname;
       var step1,step2,step3,step4,step5;
            var wizard;
    Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
    var store;
    var selected = new Array();
    var dlg0;
    var dlgtree;
    var  moduleTree;
    var nodeid;
     var pidvalue;
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
        step1 = new Ext.ux.Wiz.Card({
                             title : '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0004")%>',//选择页面配置的菜单
                             id:'s1',
                             items : [{
                                 border    : false,
                                 bodyStyle : 'background:none;',
                                 contentEl:'div1'
                             }]
                         });
                         var text1;
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
                                text1= new Ext.form.TextField({
                                     name       : 'menuname',
                                     fieldLabel : 'MenuName',
                                     allowBlank : false,
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
            title        : '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0006")%>',//选择上级菜单  
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
                        contentEl      :'divdisplay'
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
                         wizard.render(document.body);
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
                                 url = '<%=request.getContextPath()%>/workflow/request/workflow.jsp?&workflowid='+currentworkflowid;
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
                                          Ext.Msg.buttonText = {ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
                                     Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550020")%>');//配置页面菜单成功
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
                fields: ['workflowname','formname','str','modify','workflowshare','workflowview','modulename','id']


            })

        });
        var sm = new Ext.grid.CheckboxSelectionModel();

        var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%>", sortable: false, width:400, dataIndex: 'workflowname'},//流程名称
            {header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c7243a5fa0069")%>",  sortable: false, width:200, dataIndex: 'formname'},//流程表单
            {header: "<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")%>",  sortable: false, width:80, dataIndex: 'str'},//状态
            {header: "&nbsp;",  sortable: false, width:80, dataIndex: 'modify'},
            {header: "&nbsp;",  sortable: false, width:100, dataIndex: 'workflowshare'},
            {header: "&nbsp;",  sortable: false, width:100, dataIndex: 'workflowview'},
            {header: "<%=labelService.getLabelNameByKeyId("402883d934c1ba280134c1ba29730000")%>",  sortable: false, width:100, dataIndex: 'modulename'}//模块名称
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
                      displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示     条记录
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
               var reqid=rec.get('id');
               currentworkflowid=rec.get('id');
               currentmenuname=rec.get('workflowname');
               text1.setValue(currentmenuname);
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
               currentworkflowid='';
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
                               selected.remove(reqid)
                                return;
                            }
                        }

           }
                   );
        wizard.render(Ext.getBody());         
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        onSearch();
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
            width:viewport.getSize().width * 0.9,
            height:viewport.getSize().height * 0.9,
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
                                           url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=move',
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
     <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=search" name="EweaverForm" id="EweaverForm" method="post" onsubmit="return false">

      <!-- input type="hidden" name="selectItemId" value="<%=selectItemId%>"-->
      <table id=searchTable>
       <tr>
   		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881ee0c715de3010c72411ed60060")%><!-- 流程名称-->
		 </td>     
		 <td class="FieldValue" width=15%>
			<input type="text"  name="objname" class="InputStyle2" value="" />
   
		 </td>
           <%if(StringHelper.isEmpty(moduleid)){%>
		
            <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelNameByKeyId("402883d934c1bfa30134c1bfa4540000")%><!-- 模块 -->
		 </td>
         <td class="FieldValue" width="15%">

              <button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden"  name="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
           <%}%>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881ee0c715de3010c7243a5fa0069")%><!-- 流程表单-->
		 </td>     


		 <td class="FieldValue" width=15%>
			<button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/workflow/form/forminfobrowser.jsp?objtype=0&moduleid=<%=moduleid%>','formid','formidspan','0');"></button>
			<input type="hidden"  name="formid" value=""/>
			<span id="formidspan"></span>
		 </td>
		 <td class="FieldName" width=10% nowrap>
			<%=labelService.getLabelNameByKeyId("402881e70c864b41010c867b2eb40010")%><!-- 流程状态--><!-- 是否有效-->
		 </td>     



		 
		 <td class="FieldValue" width=15%>
		   <select class="inputstyle" name="isactive" id="isactive" onchange="javascript:onSearch();">
		     <option value='1' selected="selected"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%></option><!-- 显示 -->
		     <option value='2' ><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%></option><!-- 隐藏 -->
             <option value='0' ><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0003")%></option><!-- 禁用 -->
		   </select>
		 </td>
		 
	    </tr>        
       </table>
     </form>
     </div>
    <div id="div1" >
      <h2><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0007")%></h2><!--欢迎，页面配置。 请选择你所希望的菜单
      --><br>
      <table>
          <tr>
               <td><input type="radio" name="radioname" value="1" checked onclick="step2.setSkip(false);step3.setSkip(false);step4.setSkip(true)" ><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0008")%></td><!-- workflow.jsp页面 -->
          </tr>
          <tr>
              <td><input type="radio" name="radioname"  value="2" onclick="step2.setSkip(true);step3.setSkip(true);step4.setSkip(false)"><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0009")%></td><!-- 自定义流程页面菜单 -->
          </tr>
      </table>
  </div>
   <div id="div2">
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

  <div id="div3" >
    <table>
        <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname1" id="menuname1" value="" class="InputStyle2" onchange="step4.fireEvent('clientvalidation',this)"></td>
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
            <td><textarea rows="5" cols="35"  name="urll" id="urll" class="InputStyle" onchange="step4.fireEvent('clientvalidation',this)"></textarea></td>
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
<script type="text/javascript">
    function BrowserImages(obj){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=contextPath+ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=contextPath+ret
}
    function showWizard(){
          if(currentworkflowid==null||currentworkflowid==''){
             Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a000a")%>')//请选择要生成页面的工作流程!
             return;
         }
         document.getElementById('menuname1').value=currentmenuname;
        document.getElementById('urll').value='<%=request.getContextPath()%>/workflow/request/workflow.jsp?&workflowid='+currentworkflowid;
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

    function onMove()
    {
       if (selected.length == 0) {
            Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a000b")%>');//请选择要移除的内容！
            return;
        }
         this.dlgtree.show();
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
    function onDraw(workflowid,workflowname) {
        <%if(graphmode.equals("0")){%>
        var url = "<%=request.getContextPath()%>/workflow/workflow/workflowlayout.jsp?workflowid=" + workflowid;
        openDialog(url, "<%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039")%>", "dialogWidth:1024px;dialogHeight:768px;dialogLeft:10px;dialogTop:10px;center:yes;help:yes;resizable:yes;status:yes");//流程图
        <%}else{%>
        var url = "<%=request.getContextPath()%>/wfdesigner/editors/grapheditor.jsp?workflowid=" + workflowid;
        sfeather="dialogWidth:"+screen.width*0.8+"px;dialogHeight:"+screen.height*0.8+"px;center:yes;resizable:yes;status:no;maximize=yes";
        openDialog(url, "<%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039")%>", sfeather);//流程图
        //openWin(url,'流程图-'+workflowname,'comment_edit')
        <%}%>
    }
    function onSubmit() {
        document.EweaverForm.submit();
    }
    function onCreate(url) {
          this.dlg0.getComponent('dlgpanel').setSrc(url);
      this.dlg0.show()

    }
    function onSearch()
    {
        var o = $('#EweaverForm').serializeArray();
        var data = {};
        for (var i = 0; i < o.length; i++) {
            if (o[i].value != null && o[i].value != "") {
                data[o[i].name] = o[i].value;
            }
        }
        store.baseParams = data;
        store.load({params:{start:0, limit:20}});
    }
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
        Ext.Msg.buttonText = {yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>'};//是    否    
        Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380075")%>', function (btn, text) {//您确定要删除吗?
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=delete',
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

    function nodeonCreate(url) {
        var id = openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>" + url);
    }
    
    function onModify(id) {
        document.location = "<%=request.getContextPath()%>/workflow/workflow/workflowinfomodify.jsp?id=" + id+"&moduleid=<%=moduleid%>";

    }
   function onReset(){
        $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').val('');
         $('#EweaverForm select').val('');
   }
</script>
  </body>
</html>
