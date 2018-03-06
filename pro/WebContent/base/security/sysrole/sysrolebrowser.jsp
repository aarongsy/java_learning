<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
  
<%
   String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
   if(selectItemId.equals("")) selectItemId = "402881ea0b8bf8e3010b8bfd2885000a";//默认角色
   String sqlwhere = StringHelper.null2String(request.getParameter("sqlwhere"));
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881ea0b8bf8e3010b8bfc850b0009",null);   //角色类型
   SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");
   Sysrole sysrole = new Sysrole();
   String keyfield=StringHelper.null2String(request.getParameter("keyfield"));
   String showfield=StringHelper.null2String(request.getParameter("showfield"));
   if(StringHelper.isEmpty(showfield)){
	   showfield = "rolename";
   }
   List roleList = sysroleService.getAllSysroleByRoletype(selectItemId);
   Selectitem selectitem = new Selectitem(); 
   String refid=StringHelper.null2String(request.getParameter("refid"));
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=getsysrolelistbrowser&refid="+refid+"&sqlwhere="+sqlwhere;    
%>
 <%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
    pagemenustr +=  "addBtn(tb,'清除','C','cancel',function(){onClear()});";
   pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";

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
                    fields: ['rolename','roledesc','id']


                })

            });
            var sm = new Ext.grid.CheckboxSelectionModel();

            var cm = new Ext.grid.ColumnModel([{header: "角色名称", sortable: false,  dataIndex: 'rolename'},
                {header: "角色描述", sortable: false,   dataIndex: 'roledesc'}
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
               sm.on('rowselect',function(selMdl,rowIndex,rec ){
                   getArray(rec.get('id'),rec.get('<%=showfield %>'));

               });


            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
            });
            store.baseParams.selectItemId='<%=selectItemId%>' ;
            store.load({params:{start:0, limit:20}});
        });
        </script>
       <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
          
  </head>
  <body>
  <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div> 
   <form action="<%= request.getContextPath()%>/base/security/sysrole/sysrolebrowser.jsp" name="EweaverForm" id="EweaverForm"  method="post">
      <table id="searchTable">
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcca6ef9c0034")%>
		 </td>                  
         <td class="FieldValue">
		     <select class="inputstyle" id="selectItemId" name="selectItemId" onChange="javascript:onSearch();">
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
    
	    </tr>        
       </table>
 </form>
  </div>
<script language="javascript">
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
</SCRIPT>
    <script >
   function onClear(){
    if(!Ext.isSafari)
       getArray("0","");
        else{
       dialogValue=["0",""];
            parent.win.close();
        }
}
function onReturn(){
    if(!Ext.isSafari)
        window.parent.close();
        else{
            parent.win.close();
        }
}
    function getArray(id,value){
        if(!Ext.isSafari){
        window.parent.returnValue = [id,value];
        window.parent.close();
        }else{
      	 dialogValue=[id,value];
            parent.win.close();
        }
    }
</script>
  </body>
</html>
