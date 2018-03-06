<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.Constants"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<%
request.setCharacterEncoding("UTF-8");
MenuService menuService = (MenuService) BaseContext.getBean("menuService");
SysresourceService sysresourceService = (SysresourceService) BaseContext.getBean("sysresourceService");

String pid= StringHelper.null2String(request.getParameter("pid")).trim();
String pidname= pid==""?"":menuService.getMenu(pid).getMenuname();

   String objtype = StringHelper.null2String(request.getParameter("objtype")).trim();
   if(objtype.equals("")) objtype = "402881e80b9a072f010b9a38f931000d";//默认资源
   Selectitem selectitem = new Selectitem();
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881e80b9a072f010b9a36bfc80009",null);//资源类型    
   String resname= StringHelper.null2String(request.getParameter("resname")).trim();
   String resstring = StringHelper.null2String(request.getParameter("resstring")).trim();
   String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysresourceAction?action=getsysresourcelist";
%>

<!--页面菜单开始-->
<%
     pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onsearch()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+"','N','add',function(){onCreate('/base/security/sysresource/sysresourcecreate.jsp','1')});";
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
  
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script language="javascript">
   Ext.SSL_SECURE_URL='about:blank';
   Ext.LoadMask.prototype.msg='加载...';
   var store;
   var selected = new Array();
   var dlg0;
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
               fields: ['resnames','resstring','restypeName','logName','checkbox','id']


           })

       });
       var sm = new Ext.grid.CheckboxSelectionModel();

       var cm = new Ext.grid.ColumnModel([sm, {header: "资源名称", width:100, sortable: false,  dataIndex: 'resnames'},
           {header: "资源串", sortable: false, width:500,   dataIndex: 'resstring'},
           {header: "资源类型",  sortable: false,width:50, dataIndex: 'restypeName'},
           {header: "日志类型",  sortable: false, width:50,dataIndex: 'logName'},
           {header: "是否记录日志",  sortable: false,width:50, dataIndex: 'checkbox'}
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
        store.baseParams.pid = '<%=pid%>';
       store.baseParams.objtype = '<%=objtype%>';
       store.baseParams.resname = '<%=resname%>';
       store.baseParams.resstring = '<%=resstring%>';
       store.load({params:{start:0, limit:20}});
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
   });
   </script>
  </head>
  
  <body>

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
		<%--<td class="FieldName" width=10% nowrap>
					<%=labelService.getLabelName("402881e70b65f558010b65f9d4d40003")%>
		</td>
		<td class="FieldValue">
					<button  class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/menu/menubrowser.jsp?menutype=3','pid','pidspan','0');"></button>
					<input type="hidden"  name="pid" value="<%=pid%>"/>
					<span id="pidspan"><%=pidname%></span>
		</td>   --%>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcc88fa9d002d")%>
		 </td>                  
         <td class="FieldValue">
		     <select class="inputstyle" id="objtype" name="objtype" onChange="javascript:onsearch();">
                   <option value=""></option>
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(objtype.equals(selectitem.getId())) selected = "selected";
                   
                   %>
                   <option value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%></option>
                   
                   <%
                  	 } // end while
                   %>
		       </select>
          </td>
          <td class="FieldName" width=10% nowrap><!-- 资源名称-->
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc694bf8001f")%> 
		  </td>
		  <td class="FieldValue">
		     <input type="text" class="InputStyle2" style="width=95%" name="resname"/>
		  </td>
          <td class="FieldName" width=10% nowrap><!-- 资源串-->
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc96cb430030")%>
		  </td>
		  <td class="FieldValue">
		     <input type="text" class="InputStyle2" style="width=95%" name="resstring"/>
		  </td>		  
		  
	    </tr>        
             
   </table>
 </form>
</div>

 
 <SCRIPT language="javascript">
  function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
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
      store.load({params:{start:0, limit:20}});
	  }
    $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onsearch();
       }
   });
  function onCreate(url,flag){
    if (flag=="1")
       url = url + "?objtype=" + document.all("objtype").value;
       this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show()
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
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysresourceAction?action=deleteext',
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

  </script>
  </body>
</html>
