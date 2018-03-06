<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>


<%
  String roleId = StringHelper.trimToNull(request.getParameter("roleId"));
  String id = StringHelper.trimToNull(request.getParameter("id"));
  String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
  SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");
  SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService)BaseContext.getBean("sysuserrolelinkService");
  Sysuserrolelink   sysuserrolelink  = new Sysuserrolelink();
  List userrolelinkList = sysuserrolelinkService.getAllSysuserrolelinkByRoleid(roleId);
  OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
  OrgunittypeService orgunittypeService = (OrgunittypeService) BaseContext.getBean("orgunittypeService");
  HumresService humresService =(HumresService) BaseContext.getBean("humresService");
  SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");  
  StationinfoService stationinfoService = (StationinfoService) BaseContext.getBean("stationinfoService");  
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getuserrolelinklist";

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onsearch()});";    
     pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"人员','S','accept',function(){onModify('/base/security/sysrole/userrolelinkcreate.jsp?roleId=" + roleId + "')});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"岗位','S','accept',function(){onModify('/base/security/sysrole/stationrolelinkcreate.jsp?roleId=" + roleId + "')});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){toBack()});";
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
          Ext.LoadMask.prototype.msg='加载中,请稍后...';
          var roleId='<%=roleId%>';
             var store;
             var selected=new Array();
             var dlg0;
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
                       fields: ['humresname','orgunitname','id']

                 })

             });
             //store.setDefaultSort('id', 'desc');

            var sm=new Ext.grid.CheckboxSelectionModel();
            sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
                   if(record.data.humresname=='sysadmin'
                		   &&(roleId=="402881e50bf0a737010bf0a96ba70004"||roleId=="402881e50bf0a737010bf0b021bb0006"||roleId=="402881e50bf0a737010bf0b7db070008"))
                   return false;
          }
          )
             var cm = new Ext.grid.ColumnModel([sm, {header: "对象名称",  sortable: true,  dataIndex: 'humresname'},
                         {header: "角色级别", sortable: true,   dataIndex: 'orgunitname'}
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
               store.baseParams.roleId='<%=roleId%>';
               store.baseParams.id='<%=id%>';
               store.load({params:{start:0, limit:20}});
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '关闭',
                             handler  : function(){
                                 dlg0.hide();
                                 store.baseParams.roleId='<%=roleId%>';
                                  store.baseParams.id='<%=id%>'
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
         });
          </script>
  </head>
  
  <body>
<!--页面菜单开始-->     

<div id="divSearch">
    <div id="pagemenubar"></div>
<!--页面菜单结束-->
 <form action="<%= request.getContextPath()%>/base/security/sysresource/sysresourcelist.jsp" name="EweaverForm" id="EweaverForm" method="post">
    <table id=searchTable>
         <colgroup>
		   <col width="10%">
		   <col width="15%">
		   <col width="10%">
		   <col width="15%">
		   <col width="10%">
		   <col width="15%">
		   <col width="10%">
		   <col width="15%">
		</colgroup>
       <tr>
          <td class="FieldName" nowrap>
			对象名称
		  </td>
		  <td class="FieldValue">
		    <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp','userid','useridspan','0');"></button>
			 <input type="hidden"   name="userid"/>
			 <span id = "useridspan"></span>
		  </td>
            <td></td>
           <td></td>
	    </tr>

   </table>
 </form>
</div>

<!--页面菜单结束-->
 <SCRIPT language="javascript">
  function onModify(url){
	  openDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url,window);
    window.location.reload();
  } 
  
  function onDelete(){
       if(selected.length==0){
              Ext.Msg.buttonText={ok:'确定'};                                                                       
              Ext.MessageBox.alert('', '请选择要删除的内容！');
              return;
              }
             Ext.Msg.buttonText={yes:'是',no:'否'};
             Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                          if (btn == 'yes') {
                              Ext.Ajax.request({
                                  url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.UserroleAction?action=delete',
                                 params:{ids:selected.toString()},
                                  success: function() {
                                       store.baseParams.roleId='<%=roleId%>';
                                        store.baseParams.id='<%=id%>';
                                      store.load({params:{start:0, limit:20}});
                                  }
                              });
                          } else {
                                store.baseParams.roleId='<%=roleId%>';
                                 store.baseParams.id='<%=id%>';
                             store.load({params:{start:0, limit:20}});
                          }
                      });


}
     function toBack(){
         <%if(id!=null&&!"".equals(id)){%>
            location.href='<%= request.getContextPath()%>/base/security/sysrole/sysrolelist_designatedusers.jsp?id=<%=id%>&selectItemId=<%=selectItemId%>';
         <%}else{%>
            location.href='<%= request.getContextPath()%>/base/security/sysrole/sysrolelist.jsp?selectItemId=<%=selectItemId%>';
         <%}%>
     }
     function onsearch()
  {
      var o = $('#EweaverForm').serializeArray();
      var data = {};
      for (var i = 0; i < o.length; i++) {
          if (o[i].value != null && o[i].value != "") {
              data[o[i].name] = o[i].value;
          }
      }
      store.baseParams = data;
      store.baseParams.roleId='<%=roleId%>';
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
            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
        }
    }
</SCRIPT>  
   
  </body>
</html>
