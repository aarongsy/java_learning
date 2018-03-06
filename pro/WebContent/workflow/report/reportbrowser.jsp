<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%
String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
Selectitem selectitem;
String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=getreportdeflist";
String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
if(!StringHelper.isEmpty(moduleid))
action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=getreportdeflist&moduleid="+moduleid;
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','accept',function(){onSearch()});";
      pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','cancel',function(){onClear()});";//清除
     pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";


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
        store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '<%=action%>'
            }),
            reader: new Ext.data.JsonReader({
                root: 'result',
                totalProperty: 'totalcount',
                fields: ['objname','objtypename','objdesc','modulename','id','isformbase']


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
                      displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示     条记录
                      emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                  })

        });


        //Viewport
  sm.on('rowselect',function(selMdl,rowIndex,rec ){
                   getArray(rec.get('id'),rec.get('objname'),rec.get('isformbase'));

               });
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        store.baseParams.selectItemId='<%=selectItemId%>'
        store.load({params:{start:0, limit:20}});
    });
    </script>
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
			 <%=labelService.getLabelNameByKeyId("402883d934c1bfa30134c1bfa4540000")%><!--  模块-->
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
			<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460011")%><!-- 报表名称 -->
		 </td>
          <td class="FieldValue">
             <input type="text" name= "objname" id="objname"/>
          </td>
	    </tr>
   </table>
      	</form>
      </div>
 <script language="javascript" type="text/javascript">

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
         function getArray(id,value,type){
        window.parent.returnValue = [id,value,type];
        window.parent.close();
    }
</script>
<script language=vbs>
    Sub onClear
        getArray "0","",""
     End Sub

     Sub onReturn
        window.parent.Close
     End Sub
      </script>
  </body>
</html>
