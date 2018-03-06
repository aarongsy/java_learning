<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.workflow.report.service.CombinefieldService" %>
<%@ page import="com.eweaver.workflow.report.model.Combinefield" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%
int pageSize=20;
int gridWidth=700;
int gridHeight=330;
String reportid = request.getParameter("reportid");
String keyfield = StringHelper.null2String(request.getParameter("keyfield"));
String showfield = StringHelper.null2String(request.getParameter("showfield"));
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String isshow = StringHelper.null2String(request.getParameter("isshow"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String showCheckbox= StringHelper.null2String(request.getParameter("showCheckbox"));
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
 paravaluehm = new HashMap();
}
FormService formService = (FormService) BaseContext.getBean("formService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
CombinefieldService combinefieldService = (CombinefieldService)BaseContext.getBean("combinefieldService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
 reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
 String idsin=StringHelper.null2String(request.getParameter("idsin"));
 String refid=StringHelper.null2String(request.getParameter("refid"));

int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据
String jsonStr=null;
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(fieldsearchMap == null){
   fieldsearchMap=new HashMap();
   fieldsearchMap=request.getParameterMap();
}
if(fieldsearchMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=fieldsearchMap.keySet();
        for(Object key:keySet){
            String value=(String)fieldsearchMap.get(key);
            if(!StringHelper.isEmpty(value))
            jsonObject.put(key,value);
        }
        if(!"".equals(sqlwhere.trim())){
        jsonObject.put("sqlwhere",sqlwhere);
        }
        jsonStr=jsonObject.toString();
    }
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
Reportdef reportdef = reportdefService.getReportdef(reportid);
Forminfo forminfo = forminfoService.getForminfoById(reportdef.getFormid());
%>
<!--页面菜单开始-->
<%
paravaluehm.put("{reportid}",reportid);
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','erase',function(){onClear()});";//清除
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){onReturn()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','R','accept',function(){onSubmit()});";//确定
%>
<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    .icon-del {background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif) ! important;
    }

</style>
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/ext/resources/css/RowActions.css" type="text/css">
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}


</script>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript">
//多选Checkbox函数
function onClickMutiBox(box, fieldid) {
	var field = document.getElementById('con' + fieldid+'_value');
	if (box.checked) {
		if (field.value) {
			field.value = field.value + ',' + box.value;
		} else {
			field.value = box.value;
		}
	} else {
		var tempValue = field.value + ',';
		tempValue = tempValue.replace(box.value + ',','');
		field.value = tempValue.substring(0,tempValue.length-1);
	}
}
var showfield = '<%=showfield%>';
Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
var store;
var selectedStore;
var sm;
var dialogValue;
var idsin=window.parent.dialogArguments;
 if(Ext.isSafari){
 	<%if(!StringHelper.isEmpty(idsin)){%>
 		idsin = "<%=idsin%>";
 	<%}%>
 }
var myData = {
    records : []
};

    <%
        String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&reportid=" + reportid+"&isbrowser=1";
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=" + reportid+"&isbrowser=1";
if(!StringHelper.isEmpty(sysmodel)){
 action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&reportid=" + reportid+"&isbrowser=1";
 action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid=" + reportid+"&isbrowser=1";
}else{
 //pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}
        String cmstr="";
        String cmstr1="";
        String noMatchShowField="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        if(keyfield.equals(""))
        keyfield="requestid";
        fieldstr+="'"+keyfield+"'";

        Map reporttitleMap = new HashMap();
       int k=0;
  while(it.hasNext()){
   Reportfield reportfield = (Reportfield) it.next();
   if(!StringHelper.null2String(reportfield.getIsbrowser()).equals("1"))
   continue;
   reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
   Integer showwidth = reportfield.getShowwidth();
   String widths = "";
   if(showwidth!=null && showwidth.intValue()!=-1){
    widths = "width=" + showwidth + "%";
   }
   Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
   String thtmptype = "";
   if(formfields.getHtmltype() != null){
    thtmptype = formfields.getHtmltype().toString();
   }
   String tfieldtype = "";
   if(formfields.getFieldtype()!=null){
    tfieldtype = formfields.getFieldtype().toString();
   }
   String styler = "";
   if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
    styler = "style='text-align :right'";
   }
          String fieldname=labelService.getLabelName(formfields.getFieldname()) ;
          String showname = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
          int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
          if(cmstr1.equals("")){
          noMatchShowField=fieldname;
          cmstr1+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:false}";
          }
          if(fieldname.equals(showfield)){
          noMatchShowField="";
          cmstr1="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:false}";
          }
          if(cmstr.equals(""))
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            else
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
       k++;
      }
      if(!noMatchShowField.equals("")&&StringHelper.isEmpty(showfield))
      showfield=noMatchShowField;
       reportdatalist.add(reporttitleMap);//生成excel报表时用到
      %>
      
   
    Ext.grid.RowSelectionModel.override({
        initEvents : function() {
            this.grid.on("rowclick", function(grid, rowIndex, e) {
                var target = e.getTarget();
                if (target.className !== 'x-grid3-row-checker' && e.button === 0 && !e.shiftKey && !e.ctrlKey) {
                    if(target.tagName=='A'){
                    e.stopEvent();
                    }
                    this.selectRow(rowIndex, true);
                    grid.view.focusRow(rowIndex);
                }
                else if (e.shiftKey &&this.last !== false && this.lastActive !== false) {
                        var last = this.last;
                        this.selectRange(this.last,rowIndex);
                        this.grid.getView().focusRow(rowIndex);
                        if (last !== false) {
                            this.last = last;
                        }
                    }

            }, this);
            this.rowNav = new Ext.KeyNav(this.grid.getGridEl(), {
                "up" : function(e) {
                    if (!e.shiftKey) {
                        this.selectPrevious(e.shiftKey);
                    } else if (this.last !== false && this.lastActive !== false) {
                        var last = this.last;
                        this.selectRange(this.last, this.lastActive - 1);
                        this.grid.getView().focusRow(this.lastActive);
                        if (last !== false) {
                            this.last = last;
                        }
                    } else {
                        this.selectFirstRow();
                    }
                },
                "down" : function(e) {
                    if (!e.shiftKey) {
                        this.selectNext(e.shiftKey);
                    } else if (this.last !== false && this.lastActive !== false) {
                        var last = this.last;
                        this.selectRange(this.last, this.lastActive + 1);
                        this.grid.getView().focusRow(this.lastActive);
                        if (last !== false) {
                            this.last = last;
                        }
                    } else {
                        this.selectFirstRow();
                    }
                },
                scope: this
            });

        }
    });
    Ext.onReady(function(){

    	if(typeof(idsin)=='string' && !Ext.isEmpty(idsin)){
    			Ext.Ajax.request({
    		         url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=getidsins',
    		           sync:true,
    		           method:'POST',
    		           params:{idsin:idsin,showfield:'<%=showfield%>',refid:'<%=refid%>'},
    		           success: function(res) {
    		               myData =Ext.util.JSON.decode(res.responseText);
    		           }
    		      });
    	    
    	}
    	
    <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>
    store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&browserm=1&pagesize="+pageSize+"&isformbase="+isformbase+"&keyfield="+keyfield%>'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: [<%=fieldstr%>]
        }),
        remoteSort: true,
        autoLoad:false
    });
    //store.setDefaultSort('id', 'desc');
    sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
    cm.defaultSortable = true;
                   var grid = new Ext.grid.GridPanel({
                       title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050005")%>',//待选
                       region: 'center',
                       autoScroll: true, 
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       loadMask: true,
                       enableColumnMove:false,
                       viewConfig: {
                           forceFit: false,
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       bbar: new Ext.PagingToolbar({
                           pageSize: <%=pageSize%>,
            store: store,
            displayInfo: true,
            beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
            refreshText:"<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027")%>",//刷新
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%>{0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示    条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
        })
    });

    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
    <% if(StringHelper.isEmpty(isshow)||!isshow.equals("0")){%>
    store.load({params:{start:0, limit:<%=pageSize%>}});
    <%}%>
    store.on('load',function(st,recs){

        for(var i=0;i<recs.length;i++){
            var reqid=recs[i].get('<%=keyfield%>');
            selectedStore.each(function(record){
                if(record.get('<%=keyfield%>')==reqid){
                  	sm.selectRecords([recs[i]],true);
                }
            })
            
    	}});
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
       try{
           var foundItem = selectedStore.find('<%=keyfield%>', rec.data.<%=keyfield%>);
           if(foundItem==-1)
           selectedStore.add(rec);
        }catch(e){}
    });
    sm.on('rowdeselect',function(selMdl,rowIndex,rec ){
        try{
            var foundItem = selectedStore.find('<%=keyfield%>', rec.data.<%=keyfield%>);
            if(foundItem!=-1)
                selectedStore.remove(selectedStore.getAt(foundItem));
        }catch(e){}
    }
            );
    //selected grid
        var sm1 = new Ext.grid.RowSelectionModel();
        var action = new Ext.ux.grid.RowActions({
            header:"<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' onclick='selectedStore.removeAll();sm.clearSelections();'>",
            actions:[{
                iconCls:'icon-del',
                tooltip:'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>',//删除
                style:'icon-del'
            }]
        });
        var cm1 = new Ext.grid.ColumnModel([<%=cmstr1%>,action]);
        cm1.defaultSortable = false;
        
        selectedStore = new Ext.data.JsonStore({
            fields : [<%=fieldstr%>,'action'],
            data   : myData,
            root   : 'records'
        });
        
        action.on({
            action:function(grid, record, action, row, col) {
                selectedStore.remove(record);
                var foundItem = store.find('<%=keyfield%>', record.data.<%=keyfield%>);
                if (foundItem != -1)
                    sm.deselectRow(foundItem);
            }}
                );
        var selectedGrid = new Ext.grid.GridPanel({
            title:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050006")%>',//已选
            region: 'east',
            ddGroup: 'selectedGridDDGroup',
            ddText:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050007")%>',//拖动
            enableDragDrop: true,            
            store: selectedStore,
            cm: cm1,
            trackMouseOver:false,
            sm:sm1 ,
            enableColumnHide:false,
            enableHdMenu:false,
            collapseMode:'mini',
            split:true,
            width: 225,
            loadMask: true,
            plugins:[action],
            enableColumnMove:false,
            viewConfig: {
                forceFit: true,
                enableRowBody:true,
                getRowClass : function(record, rowIndex, p, store) {
                    return 'x-grid3-row-collapsed';
                }
            },
            bbar:[{
                text: '<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050008")%>',//清空
                handler : function() {
                    selectedStore.removeAll();
                    sm.clearSelections();
                }
            }],
            store: selectedStore
        });

        //Viewport
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,split:true,contentEl:'divSearch',height:screen.height*0.7*0.2},grid,selectedGrid]
        });
        //d&d
        var selectedGridDropTargetEl =  selectedGrid.getView().el.dom.childNodes[0].childNodes[1];

        var selectedGridDropTarget = new Ext.dd.DropTarget(selectedGridDropTargetEl, {
                ddGroup    : 'selectedGridDDGroup',
                copy       : false,
                notifyDrop : function(ddSource, e, data){
                    var targetEl = e.getTarget();
                    var rowIndex = selectedGrid.getView().findRowIndex(targetEl);
                    if(typeof(rowIndex)=='boolean')
                    return false;
                    selectedStore.remove(ddSource.dragData.selections[0]);
                    selectedStore.insert(rowIndex, ddSource.dragData.selections[0]);
                    return true;                   
                },
                notifyEnter:function(ddSource, e, data){
                    var proxy = ddSource.getProxy();
                    proxy.update(ddSource.dragData.selections[0].get(showfield));
                }
            });

    });

</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">

<div id="divSearch">
 <div id="pagemenubar">
 </div>
 <!--页面菜单结束-->
     <form action="<%=action%>" id="EweaverForm" name="EweaverForm" method="post" onsubmit="onSearch2();return false;">
     <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
 <!--条件>
 <%
 //隐藏初使查询条件
 String initsqlwhere = StringHelper.null2String(request.getAttribute("initsqlwhere"));
 String initquerystr = StringHelper.null2String(request.getAttribute("initquerystr"));
 String[] convalue = initquerystr.split("&");
 for(int i=0; i < convalue.length; i++){
     String tempcon = convalue[i];
     if(!StringHelper.isEmpty(tempcon)){
         String[] conv = tempcon.split("=");
         String con = conv[0];
         String vle = "";
         if(conv.length==2){
             vle = conv[1];
         }
         %>
         <input type='hidden' name="<%=con %>" value="<%=vle %>">
         <%
     }
 }
 %>
 <input type='hidden' name="sqlwhere" id="sqlwhere" value="<%=initsqlwhere %>">
 <input type='hidden' name="initquerystr" id="initquerystr" value="<%=initquerystr %>">
 <!--  ***************************************************************************************************************************-->
 <%
 //得到初使查询条件：
 Map hiddenMap = (Map)request.getAttribute("hiddenMap");
 String descorasc = StringHelper.null2String(request.getParameter("descorasc"));//表明前一次是升序还是降序？？
 if(descorasc.equals("desc")){
     descorasc = "asc";
 }else{
     descorasc = "desc";
 }
 String fieldopt = "";
 String fieldopt1 = "";
 String fieldvalue = "";
 String fieldvalue1 = "";
 ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");
 List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid2(reportid);
 List formfieldlist = new ArrayList();
 it = reportSearchfieldList.iterator();
  StringBuffer directscript=new StringBuffer();
 while(it.hasNext()){
     Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
     String formfieldid = reportsearchfield.getFormfieldid();
     Formfield formfield = formfieldService.getFormfieldById(formfieldid);
     formfieldlist.add(formfield);
 }
 DataService dataService = new DataService();
 String[] checkcons = request.getParameterValues("check_con");
  %>
 <%if(hiddenMap != null){
   for(Object o:hiddenMap.keySet()){
       String value=(String)hiddenMap.get(o);
 %>
       <input type='hidden' name="<%=o.toString() %>" id="initquerystr" value="<%=value %>">
 <%
   }
 }%>
   <table id="myTable" class=viewform>
     <%
 int linecolor=0;
 int tmpcount = 0;
 boolean showsep = true;
 Iterator fieldit = formfieldlist.iterator();
Map _fieldcheckMap=new HashMap();
while(fieldit.hasNext()){
  Formfield formfield = (Formfield)fieldit.next();
  String _htmltype = StringHelper.null2String(formfield.getHtmltype());
  String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
  String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
//系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
  if("402881e80c33c761010c33c8594e0005".equals(forminfo.getId()) || "402881e50bff706e010bff7fd5640006".equals(forminfo.getId())){
 	 Formfield _field = formfieldService.getFormfieldByName(forminfo.getId(), _fieldcheck);
 	 if(_field!=null){
 	 	_fieldcheck = _field.getId();
 	 }
  }
  String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");
     }
  if(!_fieldcheck.equals("")&&fieldvalue!=null&&!fieldvalue.equals("")){
     _fieldcheckMap.put(_fieldcheck,fieldvalue);
  }
}
 Iterator fieldit1 = formfieldlist.iterator();
 while(fieldit1.hasNext()){
     Formfield formfield = (Formfield)fieldit1.next();
     String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");
     }
     if(tmpcount%3==0){
 %>
 <tr class=title >
     <%
     }
 String htmltype = String.valueOf(formfield.getHtmltype());
 String type = formfield.getFieldtype();
 String _fieldid = StringHelper.null2String(formfield.getId());
 String _formid = StringHelper.null2String(formfield.getFormid());
 String _fieldname = StringHelper.null2String(formfield.getFieldname());
 String _htmltype = StringHelper.null2String(formfield.getHtmltype());
 String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
 String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
 String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
 String _style ="";
 String _value="";
 String htmlobjname = _fieldid;
  boolean combinefieldflag=false;
 String combineobjname="";
  if(id.equals("40288035249e012493f200077c7d3901")){
   List list=combinefieldService.getCombinefieldByReportid(reportid);
   if(list.size()>0){
    Combinefield combinefield=(Combinefield)list.get(0);
    if(!StringHelper.isEmpty(combinefield.getObjname())){
    combineobjname=combinefield.getObjname();
      combinefieldflag=true;
    }
   }
  }
 %>
     <td  class="FieldName" width='10%' nowrap>
 <%
 String name = formfield.getFieldname();
 name = "d."+name;
 %>
  <% if(combinefieldflag){%>
     <%=StringHelper.null2String(combineobjname)%>
  <% }else{ 
	  Reportfield reportfield = reportfieldService.getReportfieldByFormFieldId(reportid, formfield.getId());
	  String label;
 	  if(reportfield != null && reportfield.getId() != null){
 		 label = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
 	  }else{
 		 label = labelCustomService.getLabelNameByFormFieldForCurrentLanguage(formfield);
 	  }
  %>
     <%=label%>
  <%}%>     
  <%
 if(htmltype.equals("1")){
     if(type.equals("1")){//文本
 %>
     <td  class="FieldValue" width='15%' nowrap>
       <input type=text class=inputstyle size=30 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"/>
     </td>
    <%
    }else if(type.equals("2")){//整数
 %>
     <td  class="FieldValue" width='15%' nowrap>
       <input type=text class=inputstyle size=5 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' >--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle size=5 name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' >
     </td>
     <%
    }
    else if(type.equals("3")){//浮点数
    %>
     <td  class="FieldValue" width='15%' nowrap>
       <input type=text class=inputstyle size=5 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'>-<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>-<!-- 到 -->
       <input type=text class=inputstyle size=5 name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'>
     </td>
     <%
    }
    else if(type.equals("4")||type.equals("6")){//日期
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
    %>
             <td  class="FieldValue" width='15%' nowrap>
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onclick="WdatePicker(<%=fieldcheck %>)">
                    -
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value1"  value="<%=StringHelper.null2String(fieldvalue1)%>" onclick="WdatePicker(<%=fieldcheck %>)">   
                 </td>
     <%
    }
    else if(type.equals("5")){//时间
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
    	if(StringHelper.isEmpty(fieldcheck)){
    		fieldcheck ="{startDate:'%H:00:00',dateFmt:'H:mm:ss'}";
    	}
            StringBuffer sb = new StringBuffer("");
         sb.append("<td width=15% class='FieldValue' nowrap>");
         sb.append("<input type=\"text\" class=inputstyle size=10 name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\" onclick=\"WdatePicker("+fieldcheck+")\"  >");
         sb.append("</td>");
            out.print(sb.toString());
    }
      %>
 <%}
 else if(htmltype.equals("2")){//多行文本
 if(tmpcount%3==2){
 %>
     <td colspan=3 width='15%'  class="FieldValue" nowrap>
         <TEXTAREA style="width:200" ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
     </td>
  <%}else{%>
     <td colspan=3 width='15%'  class="FieldValue" nowrap>
       <TEXTAREA style="width:100%"  ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
     </td>
     <%}
 }
 else if(htmltype.equals("3")){//带格式文本
         //StringBuffer sb = new StringBuffer("");
         //sb.append("<td class='FieldValue'><input type=\"hidden\" name=\"field_"+_fieldid+"\"  value=\""+_value.replaceAll("\"","'")+"\" >");
         //sb.append("<IFRAME ID=\"eWebEditor"+_fieldid+"\" src=\"/plugin/ewe/ewebeditor.htm?id=field_"+_fieldid+"&style=eweaver\" frameborder=\"0\" scrolling=\"no\" "+_style+"></IFRAME></td>");
         //out.print(sb.toString());
 }
 else if(htmltype.equals("4")){//check框
 %>
     <td  class="FieldValue" nowrap>
             <INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldopt).equals("1")){%> checked <%}%>  flag=0 onclick="gray(this)" >
     </td>
     <%}
 else if(htmltype.equals("5")){//选择项
             List list ;
             if(_fieldcheckMap.get(_fieldid)!=null){
             list = selectitemService.getSelectitemList(type,(String)_fieldcheckMap.get(_fieldid));
             }
             else
             list = selectitemService.getSelectitemList(type,null);
             StringBuffer sb = new StringBuffer("");
           //系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
             if("402881e80c33c761010c33c8594e0005".equals(forminfo.getId()) || "402881e50bff706e010bff7fd5640006".equals(forminfo.getId())){
            	 Formfield _field = formfieldService.getFormfieldByName(forminfo.getId(), _fieldcheck);
            	 if(_field!=null){
            	 	_fieldcheck = _field.getId();
            	 }
             }
             sb.append("<input type=\"hidden\" name=\"field_"
                             + _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
             sb.append("<td width='15%' class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
       + "',"+ "-1" +")\"  >");
             String _isempty = "";
             if(StringHelper.isEmpty(fieldvalue))
                 _isempty = " selected ";
             sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
             for(int i=0;i<list.size();i++){
                 Selectitem _selectitem = (Selectitem)list.get(i);
                 String _selectvalue = StringHelper.null2String(_selectitem.getId());
                 String _selectname = labelCustomService.getLabelNameBySelectitemForCurrentLanguage(_selectitem);
                 String selected = "";
                 if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
                     selected = " selected ";
                 sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
             }
             sb.append("</select>\n\r</td> ");
             out.print(sb.toString());
 }
 else if(htmltype.equals("6")){ // 关联选择
             Refobj refobj = refobjService.getRefobj(type);
             if(refobj != null){
                 String _refid = StringHelper.null2String(refobj.getId());
                 String _refurl = StringHelper.null2String(refobj.getRefurl());
                 String _viewurl = StringHelper.null2String(refobj.getViewurl());
                 String _reftable = StringHelper.null2String(refobj.getReftable());
                 String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                 String _viewfield = StringHelper.null2String(refobj.getViewfield());
                 String showname = "";
                 int isdirect=NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0).intValue();
                 String _selfield=StringHelper.null2String(refobj.getSelfield());
                 _selfield=StringHelper.getEncodeStr(_selfield);
                 if(!StringHelper.isEmpty(fieldvalue)){
                     String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
                     List valuelist = dataService.getValues(sql);
                     Map tmprefmap = null;
                     String tmpobjname = "";
                     String tmpobjid = "";
                     for(int i=0;i<valuelist.size();i++){
                         tmprefmap = (Map)valuelist.get(i);
                         tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
                         try{
                             tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                         }catch(Exception e){
                             tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
                         }
                         if(!StringHelper.isEmpty(_viewurl)){//以里面定义为主
                             showname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
                             showname += tmpobjname;
                             showname += "</a>";
                         }else{
                             if(i==valuelist.size()-1){
                                 showname += tmpobjname;
                             }else{
                                 showname += tmpobjname + ", ";
                             }
                         }
                     }
                 }
                 String checkboxstr = "";
                 if("orgunit".equals(_reftable)){
                     String checked = "";
                     if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
                         checked = "checked";
                     }
                     checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
                 }
                 StringBuffer sb = new StringBuffer("");
                 sb.append("<td width='15%' class='FieldValue'>");
                 if(isdirect==1)
                {
                  //加一个用于提示的文本框
                    if (!StringHelper.isEmpty(_selfield)) {
                	    _selfield = _selfield.replaceAll("\r\n"," ");
					}
                    sb.append("<input type=text class=\"InputStyle2\" name="+_fieldid+" id="+_fieldid+" onfocus=\"checkdirect(this)\">");
                    directscript.append(" $(\"#"+_fieldid+"\").autocomplete(\""+request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable="+_reftable+"&viewfield="+_viewfield+"&selfield="+_selfield+"&keyfield="+_keyfield+"\", {\n" +
                                         "\t\twidth: 260,\n" +
                                                    "        max:15,\n" +
                                                    "        matchCase:true,\n" +
                                                    "        scroll: true,\n" +
                                                    "        scrollHeight: 300,          \n" +
                                                    "        selectFirst: false});");


                                 directscript.append("\n" +
                                     "                             $(\"#"+_fieldid+"\").result(function(event, data, formatted) {\n" +
                                     "                                     if (data)\n" +
                                     "                                         document.getElementById('con"+_fieldid+"_value').value=data[1];\n" +
                                     "                                 });");

                }
                 String fieldCheck = formService.parserRefParam(new HashMap(), formfield.getFieldcheck());
                 fieldCheck = StringHelper.replaceString(fieldCheck, "'", "%27");
                  sb.append("\n\r<button  type=button class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+fieldCheck+"','"+_viewurl+"','0');\"></button>");
                  if(isdirect==1)
                 sb.append("\n\r<input type=\"hidden\"id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 else
                 sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
                 sb.append(showname);
                 sb.append("</span>\n\r").append(checkboxstr).append("</td> ");
                 out.print(sb.toString());
             }
 }
 else if(htmltype.equals("7")){ //附件
             StringBuffer sb = new StringBuffer("");
             sb.append("<td width='15%'> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
             if(!StringHelper.isEmpty(_value)){
                 Attach attach = attachService.getAttach(_value);
                 String attachname = StringHelper.null2String(attach.getObjname());
                 sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
             }
             sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" >\n\r</td> ");
             out.print(sb.toString());
 }
 else if(htmltype.equals("8")){//checkbox（多选）
     List list ;
     if(_fieldcheckMap.get(_fieldid)!=null){
     list = selectitemService.getSelectitemList(type,(String)_fieldcheckMap.get(_fieldid));
     }
     else{
          list = selectitemService.getSelectitemList(type,null);
     }
	 StringBuffer sb = new StringBuffer("");
	 sb.append("<td class=\"FieldValue\" width=15% nowrap> \n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\"");
	 if(fieldvalue!=null){
		 sb.append(fieldvalue);
	 }
	 sb.append("\" >");
	 for(int i=0;i<list.size();i++){
		 Selectitem _selectitem = (Selectitem)list.get(i);
         String _selectvalue = StringHelper.null2String(_selectitem.getId());
         String _selectname = labelCustomService.getLabelNameBySelectitemForCurrentLanguage(_selectitem);
         String selected = "";
         sb.append("<input type='checkbox' ");
		 if(fieldvalue!=null&&fieldvalue.indexOf(_selectvalue)!=-1){
			 sb.append(" checked=\"checked\" ");
		 }
		 sb.append(" name='"+_fieldid+"' id='"+_fieldid+"' value='"+_selectvalue+"' onclick=javascript:onClickMutiBox(this,'"+_fieldid+"') ><label style='padding:0 10 0 2;'>"+_selectname+"</label>");
	 }
	 sb.append("</td>");
	 out.print(sb.toString()); 
 }
  if(linecolor==0) linecolor=1;
           else linecolor=0;
   if(htmltype.equals("2")){
     tmpcount += 2 ;
   }
   else{
     tmpcount += 1;
   }
 }%>
   </table>
 </form>
 </div>
<!-- 条件结束-->
 <script type="text/javascript">
      var inputid;
      var spanid;
      var temp;
     function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;
      temp=0;
  }
      var $j = jQuery.noConflict();
      $j(document).ready(function($){
              <%=directscript%>
         $.Autocompleter.Selection = function(field, start, end) {
             if( field.createTextRange ){
              var selRange = field.createTextRange();
              selRange.collapse(true);
              selRange.moveStart("character", start);
              selRange.moveEnd("character", end);
              selRange.select();
              if(inputid==undefined||spanid==undefined)
                 return;
               var len=field.value.indexOf("  ");
                 var lenspance=field.value.indexOf(" ");

                   if(temp==0&&len>0){
                   temp=1;
               var  length=field.value.length;

               var data=field.value;

              document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
             document.getElementById('con'+spanid+'span').innerHTML= data.substring(len,length);
                   }else if(temp==0&&lenspance>0){

                 var data=field.value;

              document.getElementById(inputid).value=data;
             document.getElementById('con'+spanid+'span').innerHTML= data;

                   }else{
                       document.getElementById(inputid).value="";                      
                   }
       } else if( field.setSelectionRange ){
              field.setSelectionRange(start, end);
          } else {
                 if( field.selectionStart ){
                  field.selectionStart = start;
                  field.selectionEnd = end;
              }
          }
          field.focus();
      };

       });
      </script>
  <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
  <script language="javascript" type="text/javascript">
   function onSearch(pageno){
          document.EweaverForm.pageno.value=pageno;
       document.EweaverForm.submit();
   }
   function createexcel(){
          document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
       document.EweaverForm.submit();
   }
   function onSearch2(){
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
   $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
   function onSearch3(){
          document.all('EweaverForm').action="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>";
       document.all('EweaverForm').submit();
   }
   //点击按列排序
   function listorder(input){
          document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
       document.EweaverForm.submit();
   }
   function fillotherselect(elementobj,fieldid,rowindex){
 var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值
 var objname = "field_"+fieldid+"_fieldcheck";
 var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)
 if(fieldcheck=="")
  return;
// DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
  // var sql ="<%=SQLMap.getSQLString("workflow/report/resultlistbrowserm.jsp")%>";
  var sql = "select * from (select '' id,' ' objname,0 dsporder from selectitem union select s.id,s.objname,s.dsporder from selectitem s where pid = '"+elementvalue+"') t order by dsporder";
	DataService.getValues(sql,{
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
 );
}
    function createList(data,fieldcheck,rowindex)
 {
  var select_array =fieldcheck.split(",");
  for(loop=0;loop<select_array.length;loop++){
   var objname = "con"+select_array[loop]+"_value";
   if(rowindex != -1)
    objname += "_"+rowindex;
   if(document.all(objname) == null){
    return;
   }
            removeAllOptions(document.all(objname));
            addOptions(document.all(objname), data);
      fillotherselect(document.all(objname),select_array[loop],rowindex);
  }
 }
   function removeAllOptions(obj) {
       var len = obj.options.length;
       for (var i = len; i >= 0; i--) {
           obj.options[i] = null
       }
   }
   function addOptions(obj, data) {
       var len = data.length;
       for (var i=0; i<len; i++) {
           if(data[i].id==null){
             data[i].id="";
           }
           obj.options.add(new Option(data[i].objname,data[i].id ));
       }
   }
   function onSubmit(){
       var ids='';
       var names='';
       selectedStore.each(function(record){
           if(ids!=''){
           ids+=','+record.get('<%=keyfield%>');
           names+=','+record.get('<%=showfield%>');
           }
           else{
           ids+=record.get('<%=keyfield%>');
           names+=record.get('<%=showfield%>');
           }
       })
       if(!Ext.isSafari)
       getArray(ids,names);
       else{
        dialogValue=new Array();
        dialogValue[0]=ids;
        dialogValue[1]=names;
        window.parent.returnValue=dialogValue;
        window.parent.close();
        parent.win.close();
       }
   }
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
   
    var win;
  

 function getdate(inputname,inputspan,isneed){
	var id;
    try{
    id=window.showModalDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",null,"dialogHeight:320px;dialogwidth:275px");
    }catch(e){}

	if (id!=null) {
		document.all(inputname).value = id;
		document.all(inputspan).innerHTML = id;
        if (id==""&&isneed=="1")
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
    }
 }

  function gettime(inputname,inputspan,isneed){
	var id;
    try{
    id=window.showModalDialog("<%=request.getContextPath()%>/plugin/clock.jsp",null,"dialogHeight:320px;dialogwidth:275px");
    }catch(e){}

	if (id!=null) {
		document.all(inputname).value = id;
		document.all(inputspan).innerHTML = id;
        if (id==""&&isneed=="1")
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
    }
 }
               function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态(找出为空的数据)
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}
   </script>
<script language=vbs>

 
 Sub oc_CurrentMenuOnMouseOut(icount)
     document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
 End Sub
 Sub oc_CurrentMenuOnClick(icount)
     document.all("oc_divMenuDivision"&icount).style.visibility = ""
 End Sub
     Sub SaveTemplate_onclick
         Dim data, name, bpublic
         data = window.showModalDialog("<%=request.getContextPath()%>/workflow/report/savesearchtemplate.jsp?reportid=<%=reportid%>",,_
             "dialogheight:240px;dialogwidth:330px;resizable:no;scroll:no")
         If Not IsEmpty(data) Then
             name = data(0)
             bpublic = data(1)
         End If
         If Len(name) > 0 Then
             document.all("contempname").value=name
             document.all("ispublic").value=bpublic
             document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=savecondition"
             document.EweaverForm.target=""
             document.EweaverForm.Submit
         End If
     End Sub    
    
 </SCRIPT>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
 <script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
<script type="text/javascript">
Ext.onReady(function(){
<%
if(!"".equals(StringHelper.null2String(session.getAttribute("checksqlwhere")))){
%>
onSearch2();
<%
}
session.removeAttribute("checksqlwhere");
%>
});
</script>
</html>