<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%
    String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
     String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getrefobjlist";
    if(!StringHelper.isEmpty(moduleid)){
        action=request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getrefobjlist&moduleid="+moduleid+"";
    }
     pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    if(!StringHelper.isEmpty(moduleid)){
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onPopup('"+request.getContextPath()+"/base/refobj/refobjcreate.jsp?moduleid="+moduleid+"')});";

    }
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";
    pagemenustr+="addBtn(tb,'移动','X','cut',function(){onMove()});";
    pagemenustr+="addBtn(tb,'browser向导','B','page',function(){showWizard()});";
    String rootid = "r00t";
    String roottext = "系统模块";
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
    ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
      <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>      
      <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
      <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
      <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
      
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script language="javascript">
             var j = jQuery.noConflict();
         </script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/ext-ux-wiz.css"/>
   <script language="javascript">
       var reportid;
       Ext.SSL_SECURE_URL = 'about:blank';
       Ext.LoadMask.prototype.msg = '加载...';
       var store;
       var selected = new Array();
       var dlg0;
       var dlgtree;
       var nodeid;
       var moduleTree
       var wizard;
       var stepreport1,stepreport2,stepreport3;
       var step1;
       var steptreeviewer1,steptreeviewer2;
       var fieldstore;
       var fieldselected = new Array();
   Ext.onReady(function() {
       Ext.QuickTips.init();
       step1 = new Ext.ux.Wiz.Card({
          title : '配置类型',
          id:'s1',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl:'div1'
          }]
      });
        steptreeviewer1 = new Ext.ux.Wiz.Card({
          title : '树形设置信息',
          id:'streeviewer1',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl:'divtreeviewer1'
          }]
      });
        steptreeviewer2 = new Ext.ux.Wiz.Card({
          title : '关联URL',
          id:'streeviewer2',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl:'divtreeviewer2'
          }]
      });
         stepreport1 = new Ext.ux.Wiz.Card({
          title : '报表信息',
          id:'sreport1',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl:'divreport1'
          }]
      });

       stepreport2 = new Ext.ux.Wiz.Card({
                title : '关联URL',
                id:'sreport2',
                items : [{
                    border    : false,
                    bodyStyle : 'background:none;',
                    contentEl:'divreport2'
                }]
            });
       stepreport3 = new Ext.ux.Wiz.Card({
                title : 'browser显示字段',
                id:'sreport3',
                autoScroll:true,
                items : [{
                    border    : false,
                    bodyStyle : 'background:none;',
                    contentEl:'divreport3'
                }]
            });
          wizard = new Ext.ux.Wiz({
          title : '生成browser框',
          closeAction:'hide',
          headerConfig : {
              title : '欢迎页面配置'
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
          width:Ext.getBody().getViewSize().width*0.6+10,
          height:Ext.getBody().getViewSize().height*0.8,
          cards : [step1,steptreeviewer1,steptreeviewer2,stepreport1,stepreport2,stepreport3]
      });
        function saveConfig(obj) {
           if( obj.s1.objtype==1){//报表
               var objname = obj.sreport1.objname;
               //var formid = obj.sreport1.formid;
               var formid = j('#formid').val();
               var viewfield = obj.sreport1.viewfield;
               var ischeck = document.getElementById('ischeck').value;
               var url = document.getElementById('url').innerText;
                 Ext.Ajax.request({
                      url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=createbrowser',
                      params:{objname:objname,formid:formid,url:url,keyfield:keyfield,viewfield:viewfield,ischeck:ischeck,ids:fieldselected.toString(),reportid:reportid,moduleid:'<%=moduleid%>'} ,
                      success: function() {
                          Ext.Msg.buttonText = {ok:'确定'};
                          Ext.MessageBox.alert('', '配置browser成功',function(btn,text){
                                store.load({params:{start:0, limit:20}});
                          });

                      }
                  });
           }else{  //树形
                var objname = obj.streeviewer1.tobjname;
                var viewfield;
               var keyfield;
               var objtable;
              if(document.all('treetype').value==4){
                  objtable = document.all('formvalue2').value;
                  viewfield = document.all('fieldvalue2').value;
                  keyfield = document.all('keyfieldvalue2').value;
              }else if(document.all('treetype').value==3){
                  objtable = document.all('formvalue1').innerText;
                  viewfield = document.all('treeviewfield').options[document.all('treeviewfield').selectedIndex].text;
                  keyfield = document.all('keyfieldvalue1').innerText;
              }else{
                  objtable = document.all('formvalue1').innerText;
                  viewfield = document.all('fieldvalue1').innerText;
                  keyfield = document.all('keyfieldvalue1').innerText;
              }
               var url = document.getElementById('treeurl').innerText;
                Ext.Ajax.request({
                      url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=createtreebrowser',
                      params:{objname:objname,objtable:objtable,url:url,keyfield:keyfield,viewfield:viewfield,moduleid:'<%=moduleid%>'} ,
                      success: function() {
                          Ext.Msg.buttonText = {ok:'确定'};
                          Ext.MessageBox.alert('', '配置browser成功',function(btn,text){
                                store.load({params:{start:0, limit:20}});
                          });

                      }
                  });
           }



        }

   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
   <%}%>
       store = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=action%>'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['objname','priview','refurl','reftable','keyfield','viewfield','coll','modulename','id']


           })

       });
         fieldstore = new Ext.data.Store({
           proxy: new Ext.data.HttpProxy({
               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getfeildlist'
           }),
           reader: new Ext.data.JsonReader({
               root: 'result',
               totalProperty: 'totalcount',
               fields: ['fieldname','labelname','id','formname']


           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();
         var smfield = new Ext.grid.CheckboxSelectionModel();
       var cmreport= new Ext.grid.ColumnModel([smfield, {header: "字段名称", width:150, sortable: false,  dataIndex: 'fieldname'},
		   {header: "显示名称",  sortable: false, width:100,dataIndex: 'labelname'},
            {header: "表名",  sortable: false, width:100,dataIndex: 'formname'}
       ]);

       var cm = new Ext.grid.ColumnModel([sm, {header: "browser框名称", width:150, sortable: false,  dataIndex: 'objname'},
		   {header: "关联表",  sortable: false, width:100,dataIndex: 'reftable'},
           {header: "预览", sortable: false, width:50,   dataIndex: 'priview'},
           {header: "关联URL",  sortable: false,width:200, dataIndex: 'refurl'},           
           {header: "主字段",  sortable: false,width:80, dataIndex: 'keyfield'},
           {header: "显示名称",  sortable: false, width:80,dataIndex: 'viewfield'},
           {header: "排序",  sortable: false,width:30, dataIndex: 'coll'},
           {header: "模块名称",  sortable: false,width:80, dataIndex: 'modulename'}
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
                                    sortAscText:'升序',
                                    sortDescText:'降序',
                                    columnsText:'列定义',
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }
                                },
           bbar: new Ext.PagingToolbar({
                     pageSize: 20,
                     store: store,
                     displayInfo: true,
                     beforePageText:"第",
                     afterPageText:"页/{0}",
                     firstText:"第一页",
                     prevText:"上页",
                     nextText:"下页",
                     lastText:"最后页",
                     displayMsg: '显示 {0} - {1}条记录 / {2}',
                     emptyMsg: "没有结果返回"
                 })

       });
       var reportgrid = new Ext.grid.GridPanel({
             region: 'center',
             store: fieldstore,
             cm: cmreport,
             //height:300,
             width:420,
             trackMouseOver:false,
             sm:smfield ,
             loadMask: true,
             autoHeight:true,
             autoScroll:true,
              viewConfig: {
                                      forceFit:true,
                                      enableRowBody:true,
                                      sortAscText:'升序',
                                      sortDescText:'降序',
                                      columnsText:'列定义',
                                      getRowClass : function(record, rowIndex, p, store){
                                          return 'x-grid3-row-collapsed';
                                      }
                                  }
         });
        reportgrid.render('divreport3');

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
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                              selected.remove(reqid)
                               return;
                           }
                       }

          }
                  );
              fieldstore.on('load',function(st,recs){
              for(var i=0;i<recs.length;i++){
                  var reqid=recs[i].get('id');
                  smfield.selectRecords([recs[i]],true);
          }
          }
                  );
          smfield.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('id');
              for(var i=0;i<fieldselected.length;i++){
                          if(reqid ==fieldselected[i]){
                               return;
                           }
                       }
              fieldselected.push(reqid)  ;
              if (fieldselected.length > 0) {
                  wizard.nextButton.setDisabled(false);
              } else {
                  wizard.nextButton.setDisabled(true);
              }
          }
                  );
          smfield.on('rowdeselect',function(selMdl,rowIndex,rec){
              var reqid=rec.get('id');
              for(var i=0;i<fieldselected.length;i++){
                          if(reqid ==fieldselected[i]){
                              fieldselected.remove(reqid)
                              if(fieldselected.length>0){
                                  wizard.nextButton.setDisabled(false);
                              }else{
                                  wizard.nextButton.setDisabled(true);
                              }
                               return;
                           }
                       }
          }
                  );

       var viewport = new Ext.Viewport({
           layout: 'border',
           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
       });

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
                 href:'/base/module/modulemodify.jsp',
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
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '关闭',
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
                text: '确定',
                handler  : function() {
                    this.disable();
                    Ext.Ajax.request({
                                            url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=move',
                                                 params:{ids:selected.toString(),nodeid:nodeid},
                                                success: function() {
                                                    selected=[];
                                                    this.dlgtree.hide();
                                                    store.load({params:{start:0, limit:20}});                                                    
                                                }
                                            });
                    this.enable();



                }

            },{text: '取消',
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
      <form action="" id="EweaverForm" name="EweaverForm" method="post">
          <input type="hidden" id="viewtype" name="viewtype" value="">
          <input type="hidden" id="treetype" name="treetype" value="">
          <input type="hidden" id="formid1" name="formid1" value="">
      <table>
          <tr>
         <%if(StringHelper.isEmpty(moduleid)){%>
         <td class="FieldName" width=8% nowrap>
			 模块
		 </td>
         <td class="FieldValue" width="20%">

              <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden" id="moduleid"  name="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
              <td class="FieldName" width=10% nowrap>
		 </td>
         <td></td>

                <td class="FieldName" width=10% nowrap>
		 </td>
         <td ></td>
     	 
      <%}%>
          <td class="FieldName" width=12% nowrap>
            browser框名称
          </td>
          <td class="FieldValue">
             <input type="text" name="browsername" id="browsername"/>
          </td>
       </tr>
      </table>
          </form>
  </div>
    <div id="div1" style="display:none">
      <table>
          <tr>
              <td>配置类型:
              <select id="objtype" name="objtype" onchange="typechange(this.value)">
                  <option value="0"></option>
                  <option value="1">报表设置</option>
                   <option value="2">树形设置</option>
              </select></td>
          </tr>
      </table>
    </div>
  <div id="divreport1" style="display:none">
      <table>
          <tr>
              <td>关联对象名称： </td>
              <td>
                  <input type="text" id="objname" name="objname" onchange="stepreport1.fireEvent('clientvalidation',this)">
              </td>
          </tr>
          <tr>
              <td>相关联报表：


           </td>
              <td>
                  <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/workflow/report/reportbrowser.jsp','reportvalue','reportvaluespan','0');"></button>
                            <input type="hidden"  name="reportvalue" id="reportvalue" value=""/>
                            <span id=reportvaluespan>

                            </span>

              </td>
          </tr>
          <tr>
              <td>关联数据库：
              </td>
              <td>
                  <form action="" id="EweaverForm1" name="EweaverForm1" method="post">
                         <select id="formid" name="formid" onchange="getOptionviewfield(this.value);getformid(this.value)">
                         </select>
                  </form>
              </td>
          </tr>
          <tr>
              <td>
                  显示名称：
              </td>
              <td>
                <select id="viewfield" name="viewfield" onchange="getUrl();getviewfield(this.value)">

                </select>
              </td>
          </tr>
           <tr>
              <td>
                  是否多选：
              </td>
               <td>
                   <input type="checkbox" id="ischeck" name="ischeck" value="0" onclick="ischeckaa()">
               </td>
          </tr>
      </table>

  </div>
  <div id="divreport2" style="display:none">
      <table>
          <tr>
              <td>关联URL： <textarea id="url" cols="40" rows="5">

              </textarea></td>
          </tr>
      </table>
  </div>
  <div id="divreport3" style="display:none">
  </div>
  <div id="divtreeviewer1" style="display:none">
      <table>
          <tr>
              <td>关联对象名：</td>
              <td><input type="text" id="tobjname" name="tobjname"></td>
          </tr>
          <tr>
              <td>treeviewer对象(id)：</td>
              <td>
                   <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/refobj/treeviewerBrowser1.jsp','treeviewervalue','treeviewervaluespan','0');"></button>
                            <input type="hidden"  name="treeviewervalue" id="treeviewervalue" value="" onpropertychange="opertypchange()" />
                            <span id=treeviewervaluespan>

                            </span>
              </td>

          </tr>
          <tr>
              <td>关联分类根节点(rootId)：</td>
              <td>
                <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/refobj/subcategorylistbrowser.jsp','categoryvalue','categoryvaluespan','0');"></button>
                            <input type="hidden"  name="categoryvalue" id="categoryvalue" value="" />
                            <span id=categoryvaluespan>

                            </span>
              </td>
          </tr>
         <tr>
             <td>关联表单：</td>
             <td>
                 <div id="divform1" style="display:none">
                       <span id=formvalue1>

                            </span>
                 </div>
                 <div id="divform2" style="display:none">
                   <input type="text" id="formvalue2" name="formvalue2">
                 </div>
             </td>

         </tr>
           <tr>
              <td>主字段：</td>
              <td>
                  <div id="divkeyfield1" style="display:none">
                     <span id="keyfieldvalue1">

                     </span>
                  </div>
                <div id="divkeyfield2" style="display:none">
                      <input type="text" id="keyfieldvalue2" name="keyfieldvalue2">
                </div>
              </td>
          </tr>
          <tr>
              <td>显示字段：</td>
              <td>
                  <div id="divfield1" style="display:none">
                     <span id="fieldvalue1">

                     </span>
                  </div>
                  <div id="divfield2" style="display:none">
                       <select id="treeviewfield" name="treeviewfield">

                  </select>
                  </div>
                <div id="divfield3" style="display:none">
                      <input type="text" id="fieldvalue2" name="fieldvalue2">
                </div>
              </td>
          </tr>
      </table>
  </div>
  <div id="divtreeviewer2" style="display:none">
       <table>
          <tr>
              <td>关联URL： <textarea id="treeurl" name="treeurl" cols="40" rows="5">

              </textarea></td>
          </tr>
      </table>
  </div>
<script language="javascript">
   var nav = new Ext.KeyNav("browsername", {
    	"enter" : function(e){
        	onSearch();
    	},
    	scope:this
	}); 

function getviewfield(value){
   if(value==0){
        this.wizard.nextButton.setDisabled(true);

    }else{
        this.wizard.nextButton.setDisabled(false);

    }
}
function getformid(value){
    if(value==0){
        this.wizard.nextButton.setDisabled(true);
                                                              
    }else{
        this.wizard.nextButton.setDisabled(false);

    }

}
function opertypchange() {
    var id = document.getElementById('treeviewervalue').value;
    document.all('viewtype').value = SQL('select viewtype from treeviewerinfo where id=\'' + id + '\'').split('__')[0]; //显示类型
    document.all('treetype').value = SQL('select treetype from treeviewerinfo where id=\'' + id + '\'').split('__')[0]; //树形类型
    if (document.all('viewtype').value == 4) {
        if (document.all('treetype').value == 3) {  //表单
            document.all('formid1').value = SQL('select dataformid from treeviewerinfo where id=\'' + id + '\'').split('__')[0];
            document.all('formvalue1').innerText = SQL('select objtablename from forminfo where id=\'' + document.all('formid1').value + '\'').split('__')[0];
            document.all('divform2').style.display = 'none';
            document.all('divform1').style.display = 'block';
            valuechange(document.all('formid1').value);
            document.all('divfield1').style.display = 'none';
            document.all('divfield2').style.display = 'block';
            document.all('divfield3').style.display = 'none';

            document.all('divkeyfield1').style.display='block';
            document.all('divkeyfield2').style.display='none' ;
            document.all('keyfieldvalue1').innerText='requestid';


        } else if (document.all('treetype').value == 2) {     //分类
            document.all('formvalue1').innerText = 'category';
            document.all('divform2').style.display = 'none';
            document.all('divform1').style.display = 'block';

            document.all('divfield1').style.display = 'block';
            document.all('divfield2').style.display = 'none';
            document.all('fieldvalue1').innerText = 'objname';
            document.all('divfield3').style.display = 'none';

             document.all('divkeyfield1').style.display='block';
            document.all('divkeyfield2').style.display='none' ;
            document.all('keyfieldvalue1').innerText='id';

        } else if (document.all('treetype').value == 1) {   //组织
            document.all('formvalue1').innerText = 'orgunit';
            document.all('divform2').style.display = 'none';
            document.all('divform1').style.display = 'block';

            document.all('divfield1').style.display = 'block';
            document.all('divfield2').style.display = 'none';
            document.all('fieldvalue1').innerText = 'objname';
            document.all('divfield3').style.display = 'none';

             document.all('divkeyfield1').style.display='block';
            document.all('divkeyfield2').style.display='none' ;
            document.all('keyfieldvalue1').innerText='id';

        } else if (document.all('treetype').value == 4) {   // 选择
            document.all('formvalue1').innerText = 'selectitem';
            document.all('divform2').style.display = 'none';
            document.all('divform1').style.display = 'block';

            document.all('divfield1').style.display = 'block';
            document.all('divfield2').style.display = 'none';
            document.all('fieldvalue1').innerText = 'objname';
            document.all('divfield3').style.display = 'none';

             document.all('divkeyfield1').style.display='block';
            document.all('divkeyfield2').style.display='none' ;
            document.all('keyfieldvalue1').innerText='id';

        } else {   //自定义
            document.all('divform2').style.display = 'block';
            document.all('divform1').style.display = 'none';

            document.all('divfield3').style.display = 'block';
            document.all('divfield2').style.display = 'none';
            document.all('divfield1').style.display = 'none';

              document.all('divkeyfield1').style.display='none';
            document.all('divkeyfield2').style.display='block';

        }
    }
}
    function valuechange(formid) {
        if (formid != "") {
            FormfieldService.getAllFieldByFormIdExist(formid, callbacktreeviewfield);
        }
    }
        function callbacktreeviewfield(list) {
            DWRUtil.removeAllOptions("treeviewfield");
            var viewfield = document.getElementById('treeviewfield');
            var oOption = document.createElement("OPTION");
            viewfield.options.add(oOption);
            oOption.innerText = "";
            oOption.value = "0";
            DWRUtil.addOptions("treeviewfield", list, "id", "fieldname");

        }
    function typechange(value) {
        if(value==0){
            this.wizard.nextButton.setDisabled(true);
            return;
        }
        if (value == 1) {
            steptreeviewer1.setSkip(true);
            steptreeviewer2.setSkip(true);
            stepreport1.setSkip(false);
            stepreport2.setSkip(false);
            stepreport3.setSkip(false);
                 this.wizard.nextButton.setDisabled(false);
        } else {
            steptreeviewer1.setSkip(false);
            steptreeviewer2.setSkip(false);
            stepreport1.setSkip(true);
            stepreport2.setSkip(true);
            stepreport3.setSkip(true);
                 this.wizard.nextButton.setDisabled(false);
        }

    }
    function getUrl() {
        var formid = document.getElementById('formid').value;
        if (formid == '402881e50bff706e010bff7fd5640006' || formid == '402881e80c33c761010c33c8594e0005') {
            document.getElementById('url').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&reportid=' + reportid;
        } else {
            document.getElementById('url').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browser=1&reportid=' + reportid;
        }
    }
    function ischeckaa() {
        var formid = document.getElementById('formid').value;
        if (document.getElementById('ischeck').checked) {
            if (formid == '402881e50bff706e010bff7fd5640006' || formid == '402881e80c33c761010c33c8594e0005') {
                document.getElementById('url').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browserm=1&reportid=' + reportid;
            } else {
                document.getElementById('url').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browserm=1&reportid=' + reportid;
            }
            document.getElementById('ischeck').value = 1;
        } else {
            if (formid == '402881e50bff706e010bff7fd5640006' || formid == '402881e80c33c761010c33c8594e0005') {
                document.getElementById('url').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&reportid=' + reportid;
            } else {
                document.getElementById('url').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browser=1&reportid=' + reportid;
            }
            document.getElementById('ischeck').value = 0;
        }
    }
    function getOptions(reportid){
    if(reportid!=""){
    FormfieldService.getForminfos(reportid,callback2);
    }
}

function callback2(list){
    DWRUtil.removeAllOptions("formid");
    	var formid=document.EweaverForm1.formid;
		var oOption = document.createElement("OPTION");
		formid.options.add(oOption);
		oOption.innerText ="";
		oOption.value = "0";
    DWRUtil.addOptions("formid",list,"id","objtablename");

}

    function  getOptionviewfield(formid){

    if(formid!=""){
    FormfieldService.getAllFieldByFormIdExist(formid,callbackviewfield);
    }
    }
        function callbackviewfield(list){
    DWRUtil.removeAllOptions("viewfield");
            var viewfield = document.getElementById('viewfield');
            var oOption = document.createElement("OPTION");
            viewfield.options.add(oOption);
            oOption.innerText = "";
            oOption.value = "0";
    DWRUtil.addOptions("viewfield",list,"id","fieldname");

}

     function onSearch(){
       var moduleid = document.getElementById("moduleid");
       if(moduleid){
       		store.baseParams.moduleid = moduleid.value;
       }
       var browsername = document.getElementById("browsername").value;
       store.baseParams.browsername = browsername;
       store.load({params:{start:0, limit:20}});
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
                      if(inputname=='reportvalue'){
                          reportid=id[0];
                          getOptions(id[0]);
                          fieldstore.baseParams.id=id[0];
                          fieldstore.load({params:{start:0, limit:20}});
                          this.wizard.nextButton.setDisabled(false);
                      }else if(inputname=='treeviewervalue'){
                         document.getElementById('treeurl').innerText='/base/refobj/treeviewerBrowser.jsp?id='+id[0];
                      }else if(inputname=='categoryvalue'){
                          var treeviewerid=document.getElementById('treeviewervalue').value;
                          document.getElementById('treeurl').innerText='/base/refobj/treeviewerBrowser.jsp?id='+treeviewerid+"&rootId="+id[0];
                      }

                } else {
                    this.wizard.nextButton.setDisabled(true);
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                }
            }
        }

    function onMove()
       {
          if (selected.length == 0) {
              Ext.Msg.buttonText={ok:'确定'};
               Ext.MessageBox.alert('', '请选择要移动的内容！');
               return;
              

           }
            this.dlgtree.show();
       }
   function onPopup(url){
        this.dlg0.getComponent('dlgpanel').setSrc(url);
        this.dlg0.show();

   }
  function onDelete()
     {
         if (selected.length == 0) {
             Ext.Msg.buttonText={ok:'确定'};
             Ext.MessageBox.alert('', '请选择要删除的内容！');
             return;
         }
         Ext.Msg.buttonText={yes:'是',no:'否'};
         Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=deleteext',
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
    	var strSQLs = new Array();
	var strValues = new Array();
      function SQL(param){
				param = encode(param);

				if(strSQLs.indexOf(param)!=-1){
					var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
					return retval;

				}else{
                    var _url= "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.DataAction?sql="+param;
					var XMLDoc=new ActiveXObject("MSXML");

						XMLDoc.url=_url;
						var XMLRoot=XMLDoc.root;

						var retval = getValidStr(XMLRoot.text);
						strSQLs.push(param);
						strValues.push(retval);

						return retval;
				}
			}
    function showWizard(){
      Ext.get('div1').setVisible(true);
      Ext.get('divreport1').setVisible(true);
      Ext.get('divreport2').setVisible(true);
      Ext.get('divreport3').setVisible(true);
      Ext.get('divtreeviewer1').setVisible(true);
      Ext.get('divtreeviewer2').setVisible(true);
      wizard.show();
     this.wizard.nextButton.setDisabled(true);
         stepreport1.on('clientvalidation', function() {
             if (document.getElementById('objname').value != null && document.getElementById('objname').value != '')
                 this.wizard.nextButton.setDisabled(false);
             else {
                 this.wizard.nextButton.setDisabled(true);
             }
         });
    }
 </script>
  </body>
</html>
