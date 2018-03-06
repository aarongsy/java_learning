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
<%@ page import="com.eweaver.base.orgunit.model.Orgunit" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="org.json.simple.JSONArray" %>


<%

OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
String humresid = StringHelper.null2String(request.getParameter("requestid"));
Humres humres = humresService.getHumresById(humresid);
Sysuser sysuser = sysuserService.findBy("objid",humresid);
String reftype = "402881e510e8223c0110e83d427f0018";
List<Orgunit> ous=orgunitService.find("from Orgunit where isRoot=1");

String jsonString = sysuserService.getPermJsonString(sysuser.getId());

//pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004") + "','S','zoom',function(){onSearch()});";
%>


<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
       .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
     a { color:blue; cursor:pointer; }
</style>
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">

     var viewport=null;
     var store;

    Ext.onReady(function(){

        Ext.grid.dummyData = <%=jsonString%>;

    var xg = Ext.grid;

                       // shared reader
                       var reader = new Ext.data.ArrayReader({}, [
                          {name:'rolename'},{name:'permname'}
                       ]);
                store=new Ext.data.GroupingStore({
                               reader: reader,
                               data: xg.dummyData,
                               sortInfo:{field: 'rolename', direction: "ASC"},
                               groupField: 'rolename'
                           })

                   var grid = new Ext.grid.GridPanel({
                       region: 'center',
                       store:store ,
                       columns: [{header:'所属角色',dataIndex:'rolename',width:0,sortable:true},
                           {header:'权限名称',dataIndex:'permname',width:0,sortable:true}],
                       view: new Ext.grid.GroupingView({
                               forceFit:true,
                               startCollapsed:true,
                               hideGroupedColumn:true,
							   sortAscText:'升序',
                               sortDescText:'降序',
							   groupByText:'按此列分组',
							   showGroupsText:'分组显示',
                               columnsText:'列定义',
                               groupTextTpl: '{text} ({[values.rs.length]})'
                           }),
                       frame:true,
                           collapsible: false,
                           animCollapse: true,
                           //title: '列表',
                           iconCls: 'icon-grid'

    });

        store.on('load',function(st,recs){
                            for(var i=0;i<recs.length;i++){
                                var reqid=recs[i].get('requestid');
                                for(var j=0;j<selected.length;j++){
                                            if(reqid ==selected[j]){
                                                 sm.selectRecords([recs[i]],true);
                                             }
                                         }
                                    }
                                }
                            );

      var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });
     var c = new Ext.Panel({
               title:'角色权限(<%=humres.getObjname()%>)',iconCls:Ext.ux.iconMgr.getIcon('config'),
               layout: 'border',
               items: [grid]
           });

     var exceltab=cp.get('exceltab');
     if(exceltab==undefined)
     exceltab=0;

     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:exceltab,
            items:[c]
        });

        addTab(contentPanel,'<%=request.getContextPath()%>/base/perm/getPRule.jsp?requestid=<%=humresid%>','操作权限(<%=humres.getObjname()%>)','page_portrait');
        addTab(contentPanel,'<%=request.getContextPath()%>/base/perm/getPDetail.jsp?requestid=<%=humresid%>','卡片权限(<%=humres.getObjname()%>)','page_portrait');
        contentPanel.items.each(function(it,index,length){
         it.on('activate',function(p){
             if(length==8)
             cp.set('exceltab',index+1);
             else
             cp.set('exceltab',index);

        })
     });


	 viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
});

</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px">
  </body>
</html>