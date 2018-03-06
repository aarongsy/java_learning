<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<%
   String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
   String objname = StringHelper.null2String(request.getParameter("objname"));
   if(selectItemId.equals("")) selectItemId = "402881ea0b8bf8e3010b8bfd2885000a";//系统角色
   SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");
 //  SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService) BaseContext.getBean("sysuserrolelinkService");
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881ea0b8bf8e3010b8bfc850b0009",null);//角色类型 
   List sysroleList = sysroleService.searchSysrole(selectItemId,objname);
   Selectitem selectitem = new Selectitem();
   Sysrole sysrole = new Sysrole();
   
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','C','accept',function(){onCreate('/base/security/sysrole/sysrolecreate.jsp','1')});";
    pagemenustr +="addBtn(tb,'删除','D','delete',function(){onDelete()});";

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


  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
         <script language="javascript">
         Ext.SSL_SECURE_URL='about:blank';
          Ext.LoadMask.prototype.msg='加载...';
             var store;
             var selected=new Array();
             var dlg0;
           <%
            String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getsysrolelist";
           %>
                   Ext.onReady(function(){
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
                       fields: ['rolename','member','permission','id']

                 })

             });
             //store.setDefaultSort('id', 'desc');

            var sm=new Ext.grid.CheckboxSelectionModel({
            	renderer:function(v,c,r){
	            	if(r.data.id=='402881e50bf0a737010bf0a96ba70004' ||
	                      r.data.id=='402881e50bf0a737010bf0b021bb0006' ||
	                      r.data.id=='402881e50bf0a737010bf0b7db070008'){
	                   	  return "<div><input type='checkbox' disabled style='margin-left:-2px;'/></div>";
	                }else{
	                	  return "<div class=\"x-grid3-row-checker\"></div>";   
	                }
            	}
            });
            sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
                   if(record.data.id=='402881e50bf0a737010bf0a96ba70004' ||
                      record.data.id=='402881e50bf0a737010bf0b021bb0006' ||
                      record.data.id=='402881e50bf0a737010bf0b7db070008'){
                   	  return false;
                   }
            }
          )
             var cm = new Ext.grid.ColumnModel([sm,{header: "角色名称",  sortable: false,  dataIndex: 'rolename'},
                         {header: "成员", sortable: false,   dataIndex: 'member'},
                         {header: "权限",  sortable: false, dataIndex: 'permission'}
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

             //Viewport
         var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
               store.baseParams.selectItemId='<%=selectItemId%>';
             store.baseParams.objname='<%=objname%>';
               store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
                             text     : '关闭',
                             handler  : function(){
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
                       
         });
          </script>
</head>
  
  <body>
<!--页面菜单开始-->
<div id="divSearch" >
  <div id="pagemenubar"></div>
<!--页面菜单结束-->   
  
   <form action="<%= request.getContextPath()%>/base/security/sysrole/sysrolelist.jsp" name="EweaverForm"  method="post">
   <input type="hidden" name="searchName" value="">
   <table id=searchTable>
       <tr>
		 <td class="FieldName" width=5% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcca6ef9c0034")%>:
		 </td>                  
         <td class="FieldValue"width="5%">
		     <select class="inputstyle" id="selectItemId" name="selectItemId" onChange="javascript:onSubmit(this.options[this.options.selectedIndex].value);">
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectItemId.equals(selectitem.getId())) selected = "selected";
                   
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>
                   
                   <%
                   } // end while
                   %>
	       </select>
         </td>
         <td class="FieldName" width=5% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcca8f4b90035")%>:
		 </td>
    	<td width="80%">&nbsp;&nbsp;<input class="infoinput"  id="objname" name="inputText" type="text" size="10" value="<%=objname%>">
    	<input type="button" name="Button" value="Search" onClick="javascript:onSearch();"></td>
     </tr>        
             
   </table>
 </form>
 </div>
<SCRIPT language="javascript"> 
  function onSubmit(value){
      store.baseParams.selectItemId=value;
       store.load({params:{start:0, limit:20}});

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
                      url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=deleteext',
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

  function onCreate(url,flag){
      if (flag == "1")
          url += "?objtype=" + document.all("selectItemId").value;
      this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show()

  } 
function onSearch(){
    var objname = document.all("inputText").value;
    store.baseParams.objname = objname;
    store.load({params:{start:0, limit:20}});

}

$(document).keydown(function(event) {
	if (event.keyCode == 13) {
		document.getElementById("objname").blur();
		onSearch();
	}
});
</SCRIPT>     
  </body>
</html>
