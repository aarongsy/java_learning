<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.log.model.Log"%>
<%@ page import="com.eweaver.base.log.service.LogService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="org.hibernate.criterion.DetachedCriteria"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService"%>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<%
Log log = new Log();
Map queryFilter = (Map)request.getAttribute("queryFilter");

SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
MenuService menuService = (MenuService) BaseContext.getBean("menuService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");

String logtype=StringHelper.null2String(queryFilter.get("logtype"));
String logtypename=logtype==""?"":selectitemService.getSelectitemById(logtype).getObjname();
String objid=StringHelper.null2String(queryFilter.get("objid"));
String mid=StringHelper.null2String(queryFilter.get("mid"));
String midname=mid==""?"":menuService.getMenu(mid).getMenuname();
String submitor=StringHelper.null2String(queryFilter.get("submitor"));
String submitorname=submitor==""?"":humresService.getHumresById(submitor).getObjname();
String submitdate=StringHelper.null2String(queryFilter.get("submitdate"));
String submitdate2=StringHelper.null2String(queryFilter.get("submitdate2"));

   // 是否系统管理员 
   SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
   SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService) BaseContext.getBean("sysuserrolelinkService");
   boolean issysadmin = false;
   String humresroleid = "402881e50bf0a737010bf0a96ba70004";//系统管理员角色id
   Sysuser sysuser = new Sysuser();
   Sysuserrolelink sysuserrolelink  = new Sysuserrolelink();
   sysuser = sysuserService.getSysuserByObjid(currentuser.getId());
   issysadmin = sysuserrolelinkService.isRole(humresroleid,sysuser.getId());
%>
<%

    if(issysadmin){
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";

    }
%>
<html>
  <head>
  <style type="text/css">
      TABLE {
          width: 0;
      }
  </style>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
   <script language="javascript">
          Ext.LoadMask.prototype.msg='加载中,请稍后...';
             var store;
             var selected=new Array();
        
           <%
            String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.log.servlet.LogAction?action=getloglist";
           %>
                   Ext.onReady(function(){
                  // alert('1');
            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
            <%=pagemenustr%>
        <%}%>
                  //  alert(2);
             store = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=action%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',
                    <% if(issysadmin){%>
                     fields: ['logtypename','objname','submitorname','datatime','submitip','logdesc','logid']
                     <%}else{%>
                        fields: ['logtypename','objname','submitorname','datatime','submitip']
                     <%}%>
                 })

             });
             //store.setDefaultSort('id', 'desc');
           //alert(3);
             var sm=new Ext.grid.CheckboxSelectionModel();
                      <%if(issysadmin){%>
             var cm = new Ext.grid.ColumnModel([sm, {header: "日志类型",width:150,  sortable: false,  dataIndex: 'logtypename'},
                         {header: "对象名称",width:200, sortable: false,   dataIndex: 'objname'},
                         {header: "提交者",width:150,  sortable: false, dataIndex: 'submitorname'},
                         {header: "提交时间",width:150, sortable: false, dataIndex: 'datatime'},
                         {header: "IP地址",width:150, sortable: false, dataIndex: 'submitip'},
                         {header: "描述", sortable: false, dataIndex: 'logdesc',id:'logdesc'}]);
                <%}else{%>
                     var cm = new Ext.grid.ColumnModel([
                         {header: "日志类型", width:150, sortable: false,  dataIndex: 'logtypename'},
                         {header: "对象名称", width:200,sortable: false,   dataIndex: 'objname'},
                         {header: "提交者", width:150 , sortable: false, dataIndex: 'submitorname'},
                         {header: "提交时间;",width:150,   sortable: false, dataIndex: 'datatime'},
                         {header: "IP地址", width:150,  sortable: false, dataIndex: 'submitip' ,id:'submitip' }
                          ]);
                       <%}%>
             cm.defaultSortable = true;
                            var grid = new Ext.grid.GridPanel({
                                region: 'center',
                                store: store,
                                cm: cm,
                                trackMouseOver:false,
                                <%if(issysadmin){%>
                                 sm:sm ,
                                 autoExpandColumn:'logdesc',
                                 <%}else{%>
                                   autoExpandColumn:'submitip',
                                  <%}%>
                                loadMask: true,
                                viewConfig: {
                                  //  forceFit: true
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
       <%if(issysadmin){%>
                      store.on('load',function(st,recs){
        for(var i=0;i<recs.length;i++){
            var reqid=recs[i].get('logid');
        for(var j=0;j<selected.length;j++){
                    if(reqid ==selected[j]){
                         sm.selectRecords([recs[i]],true);
                     }
                 }
    }
    });
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
        var reqid=rec.get('logid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                         return;
                     }
                 }
        selected.push(reqid)
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('logid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid)
                         return;
                     }
                 }

    }
            );
               <%}%>

             //Viewport
         var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
               onSearch();

         });

          function onDelete() {
              var totalsize = selected.length;
              if (totalsize == 0) {
                  Ext.Msg.buttonText={ok:'确定'};
                  Ext.MessageBox.alert('', '请选中您所要删除的日志！');
                  return;
              }
              Ext.Msg.buttonText={yes:'是',no:'否'};              
              Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.log.servlet.LogAction?action=delete',
                          params:{ids:selected.toString()},
                          success: function() {
                             onSearch();
                          }
                      });
                  } else {
                      selected=[];
                     onSearch();
                  }
              });


          }
   </script>
  </head>
  <body>
     <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.log.servlet.LogAction?action=search" id="EweaverForm" name="EweaverForm" method="post">
 		<input type=hidden name="objid" value="<%=objid%>">
		<table <%if(!issysadmin){%> style="display:none;" <%}%> style="width: auto;">
            <tr>
				<td class="FieldName">
					<%=labelService.getLabelName("402881e70b65e2b3010b65e466610003")%>
				</td>
				<td class="FieldValue">
					<input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=402881e50acce3e2010acd3ea4e70003','logtype','logtypespan','0');"/>
				    <input type="hidden"  name="logtype" />
					<span id="logtypespan"></span>
				</td>

				<%--<td class="FieldName">
					<%=labelService.getLabelName("402881e70b65f558010b65f9d4d40003")%>
				</td>
				<td class="FieldValue">
					<button  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/menu/menubrowser.jsp?menutype=3&isshow=1','mid','midspan','0');"></button>
						<input type="hidden"  name="mid"/>
					<span id="midspan"></span>
				</td>--%>
				<td class="FieldName">
					<%=labelService.getLabelName("402881e70b65e2b3010b65e58e950005")%>
				</td>
				<td class="FieldValue">
					<input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp','submitor','submitorspan','0');"/>
						<input type="hidden"  name="submitor" />
					<span id="submitorspan"></span>
				</td>	
				<td class="FieldName">
					<%=labelService.getLabelName("402881e70b65e2b3010b65e6a7780007")%>
				</td>
				<td class="FieldValue">
					<%--<button  class=Calendar onclick="javascript:getdate('submitdate','submitdatespan','0');"></button>
						<input type="hidden"  name="submitdate" />
					<span id="submitdatespan"></span>
					-&nbsp&nbsp
					<button  class=Calendar onclick="javascript:getdate('submitdate2','submitdate2span','0');"></button>
						<input type="hidden"  name="submitdate2" />
					<span id="submitdate2span"></span>--%>
					<input type="text"  name="submitdate" size="10" onclick="WdatePicker()"/>
					-&nbsp&nbsp
					<input type="text"  name="submitdate2" size="10" onclick="WdatePicker()"/>
				</td>													
			</tr>
		</table>
    </form>
    </div>

<script language="javascript" type="text/javascript">
var currentindex = 0;
	function showdesp(e){
		//alert(event.srcElement.parentElement.id) ;
		var trid = e.id + "1";
		//var index = e.rowIndex+1 ;
		//var table = document.all("logTable") ;
		//alert(table.rows(index));
		if (event.srcElement.tagName!="a"&&event.srcElement.tagName!="A"){
			if (document.all(trid).style.display == "none"){
				document.all(trid).style.display="";
			}
			else{
				document.all(trid).style.display = "none" ;
			}
		}
		currentindex = e.rowIndex ;
	}

	function gotourl(e){
		if (event.srcElement.tagName=="a"||event.srcElement.tagName=="A"){
			
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

    function onSearch(){
	   var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
       store.load({params:{start:0, limit:20}});
    }
</script>

  </body>
</html>
