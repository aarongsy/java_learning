<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ include file="/base/init.jsp"%>
<%
String selectitemtypeid = StringHelper.trimToNull(request.getParameter("selectitemtypeid"));
 String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
      String rootid="r00t";
	String roottext="系统模块";
      pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    if(!StringHelper.isEmpty(moduleid)){
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','C','add',function(){onCreate('"+request.getContextPath()+"/base/selectitem/selectitemtypecreate.jsp?moduleid="+moduleid+"')});";
    }

 String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=getselectitemtypelist";

if(!StringHelper.isEmpty(moduleid))
    action=request.getContextPath()+"/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=getselectitemtypelist&moduleid="+moduleid;
    String sql="select * from selectitemtype where pid is null and moduleid is null";
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List selectitemlist=baseJdbcDao.getJdbcTemplate().queryForList(sql);
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";
    pagemenustr+="addBtn(tb,'移动','X','cut',function(){onMove()});";
	
%>

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

    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
    <script language="javascript">
    Ext.SSL_SECURE_URL='about:blank';
    Ext.LoadMask.prototype.msg='加载...';
    var store;
    var selected = new Array();
    var dlg0;
    var dlgtree;
    var nodeid;
     var  moduleTree
    Ext.onReady(function() {
        Ext.QuickTips.init();
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
                fields: ['objname','modify','modulename','id']


            })

        });
        var sm = new Ext.grid.CheckboxSelectionModel();
        var cm = new Ext.grid.ColumnModel([sm, {header: "select字段名", sortable: false,  dataIndex: 'objname'},
            {header: "模块名称",  sortable: false, dataIndex: 'modulename'},
            {header: "&nbsp;",  sortable: false, dataIndex: 'modify'}

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

        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        store.baseParams.selectitemtypeid='<%=selectitemtypeid%>' ;
        store.baseParams.moduleid = '<%=moduleid%>';
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
                                            url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=move',
                                                 params:{ids:selected.toString(),nodeid:nodeid},
                                                success: function() {
                                                    selected=[];
                                                    this.dlgtree.hide();
                                                    onSearch();
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
	<form  name="EweaverForm" method="post" id="EweaverForm">
		<table style="border:0">
            <tr>
                 <%if(StringHelper.isEmpty(moduleid)){%>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
		 </td>
         <td class="FieldValue">

              <select class="inputstyle" style='size:30;' id="selectitemtypeid" name="selectitemtypeid" onChange="javascript:onSearch();">
                  <option value=""></option>
              
                  <%
                  for(Object o:selectitemlist){
                         String id=((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
                         String objname=((Map) o).get("objname") == null ? "" : ((Map) o).get("objname").toString();
					  String selected = "";
					  if(id.equals(selectitemtypeid)) selected = "selected";
                   %>
                   <option value=<%=id%> <%=selected%>><%=objname%></option>

                   <%
                   } // end while
                   %>
		       </select>
          </td>
           <td class="FieldName" width=10% nowrap>
			 模块
		 </td>
         <td class="FieldValue" width="15%">

              <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/module/modulebrowser.jsp','moduleid','moduleidspan','0');"></button>
			<input type="hidden"  name="moduleid" value=""/>
			<span id="moduleidspan"></span>
          </td>
           <%}%>
                <td  class="FieldName" nowrap>
            select字段名
          </td>
          <td class="FieldValue">
             <input type="text" name= "objname" id="objname" />
          </td>
            </tr>
       
		</table>
		 <input type="hidden" name="deleteid" value="">
	</form>
      </div>
    
      
<script language="javascript">
	 
var nav = new Ext.KeyNav("objname", {
    "enter" : function(e){
        onSearch();
    },
    scope:this
}); 
	
      function onDelete()
               {
                   for(var i=0;i<selected.length;i++){
                       var id=selected[i];
                       if(id=='4028803522c5ca070122c5d78b8f0002') { //语言种类 不可删除
                           Ext.Msg.buttonText={ok:'确定'};
                       Ext.MessageBox.alert('', '不可删除！');
                       return;
                       }
                   }
                   if (selected.length == 0) {
                       Ext.Msg.buttonText={ok:'确定'};
                       Ext.MessageBox.alert('', '请选择要删除的内容！');
                       return;
                   }
                   Ext.Msg.buttonText={yes:'是',no:'否'};
                   Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                       if (btn == 'yes') {
                           Ext.Ajax.request({
                               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=deleteext',
                               params:{ids:selected.toString()},
                               success: function(res) {
                                   selected = [];
                                   store.load({params:{start:0, limit:20}});
                               }
                           });
                       } else {

                       }
                   });

               }
    function onModify(id,moduleid){
          document.location = "<%=request.getContextPath()%>/base/selectitem/selectitemtypemodify.jsp?moduleid="+moduleid+"&id="+id;
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

   function onSubmit(){
   		document.EweaverForm.submit();
   }
    function onCreate(url){
         //document.EweaverForm.submit();
          this.dlg0.getComponent('dlgpanel').setSrc(url);
          this.dlg0.show()
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
      store.load({params:{start:0, limit:20}});
     }
       $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch();
       }
   });
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
	function toUrl(url)
	{
		window.location.href=url;
	}
	</script>
  </body>
</html>
