<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.log.service.LogService"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.document.base.servlet.DocbaseAction" %>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ include file="/base/init.jsp"%>
<%
Map alluserStrMap = (Map)request.getAttribute("alluserStrMap");
Map userMap = (Map)request.getAttribute("userMap");
Map stationMap = (Map)request.getAttribute("stationMap");
Map orgunitMap = (Map)request.getAttribute("orgunitMap");

%>
<%


	String alluserStr3 = (String)alluserStrMap.get("alluserStr3");
	String alluserStr15 = (String)alluserStrMap.get("alluserStr15");
	String alluserStr105 = (String)alluserStrMap.get("alluserStr105");
	String alluserStr165 = (String)alluserStrMap.get("alluserStr165");
    String alluserStr6 = (String)alluserStrMap.get("alluserStr6");


	List user3 = null;
	List station3 = null;
	List orgunit3 = null;

	List user15 = null;
	List station15 = null;
	List orgunit15 = null;

	List user105 = null;
	List station105 = null;
	List orgunit105 = null;

	List user165 = null;
	List station165 = null;
	List orgunit165 = null;

    List user6=null;
    List station6=null;
    List orgunit6=null; //监控

	user3 = (List)userMap.get("user3");
	station3 = (List)stationMap.get("station3");
	orgunit3 = (List)orgunitMap.get("orgunit3");

	user15 = (List)userMap.get("user15");
	station15 = (List)stationMap.get("station15");
	orgunit15 = (List)orgunitMap.get("orgunit15");

	user105 = (List)userMap.get("user105");
	station105 = (List)stationMap.get("station105");
	orgunit105 = (List)orgunitMap.get("orgunit105");

	user165 = (List)userMap.get("user165");
	station165 = (List)stationMap.get("station165");
	orgunit165 = (List)orgunitMap.get("orgunit165");

    user6=(List)userMap.get("user6");
    station6=(List)stationMap.get("station6");
    orgunit6=(List)stationMap.get("orgunit6");
    String readerStr="{name:'opttype'},{name:'opter'}";
	String colStr="{header:'操作类型',sortable: true,dataIndex:'opttype'},{header:'操作者',sortable: true,dataIndex:'opter'}";
    JSONArray jsondata=new JSONArray();
    if(!alluserStr3.equals("")){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(3);
        jsonArray.add(alluserStr3);
        jsondata.add(jsonArray);
    }
    if(user3 != null){
	for(int i=0; i < user3.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(3);
        jsonArray.add(user3.get(i));
        jsondata.add(jsonArray);
    }
    }
    if(station3 != null){
	for(int i=0; i < station3.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(3);
        jsonArray.add(station3.get(i));
        jsondata.add(jsonArray);

    }
    }
    if(orgunit3 != null){
	for(int i=0; i < orgunit3.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(3);
        jsonArray.add(orgunit3.get(i) );
        jsondata.add(jsonArray);

    }
    }
    //15
    if(!alluserStr15.equals("")){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(15);
        jsonArray.add(alluserStr15);
        jsondata.add(jsonArray);
    }
    if(user15 != null){
	for(int i=0; i < user15.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(15);
        jsonArray.add(user15.get(i));
        jsondata.add(jsonArray);
    }
    }
    if(station15 != null){
	for(int i=0; i < station15.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(15);
        jsonArray.add(station15.get(i));
        jsondata.add(jsonArray);

    }
    }
    if(orgunit15 != null){
	for(int i=0; i < orgunit15.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(15);
        jsonArray.add(orgunit15.get(i) );
        jsondata.add(jsonArray);

    }
    }
    //105
    if(!alluserStr105.equals("")){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(105);
        jsonArray.add(alluserStr105);
        jsondata.add(jsonArray);
    }
    if(user105 != null){
	for(int i=0; i < user105.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(105);
        jsonArray.add(user105.get(i));
        jsondata.add(jsonArray);
    }
    }
    if(station105 != null){
	for(int i=0; i < station105.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(105);
        jsonArray.add(station105.get(i));
        jsondata.add(jsonArray);

    }
    }
    if(orgunit105 != null){
	for(int i=0; i < orgunit105.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(105);
        jsonArray.add(orgunit105.get(i) );
        jsondata.add(jsonArray);

    }
    }
    //6
    if(!alluserStr6.equals("")){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(6);
        jsonArray.add(alluserStr6);
        jsondata.add(jsonArray);
    }
    if(user6 != null){
	for(int i=0; i < user6.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(6);
        jsonArray.add(user6.get(i));
        jsondata.add(jsonArray);
    }
    }
    if(station6 != null){
	for(int i=0; i < station6.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(6);
        jsonArray.add(station6.get(i));
        jsondata.add(jsonArray);

    }
    }
    if(orgunit6 != null){
	for(int i=0; i < orgunit6.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(6);
        jsonArray.add(orgunit6.get(i) );
        jsondata.add(jsonArray);

    }
    }
    //165
    if(!alluserStr165.equals("")){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(165);
        jsonArray.add(alluserStr165);
        jsondata.add(jsonArray);
    }
    if(user165 != null){
	for(int i=0; i < user165.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(165);
        jsonArray.add(user165.get(i));
        jsondata.add(jsonArray);
    }
    }
    if(station165 != null){
	for(int i=0; i < station165.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(165);
        jsonArray.add(station165.get(i));
        jsondata.add(jsonArray);

    }
    }
    if(orgunit165 != null){
	for(int i=0; i < orgunit165.size(); i++){
        JSONArray jsonArray=new JSONArray();
        jsonArray.add(165);
        jsonArray.add(orgunit165.get(i) );
        jsondata.add(jsonArray);

    }
    }
%>
<HTML><HEAD>
    <style type="text/css">
          .x-toolbar table {
              width: 0
          }

          #pagemenubar table {
              width: 0
          }

          .x-panel-btns-ct {
              padding: 0px;
          }

          .x-panel-btns-ct table {
              width: 0
          }
      </style>

                        
                        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
                        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
     <script type="text/javascript">
                            window.onload=function(){
                                  Ext.QuickTips.init();
                            <%if(!pagemenustr.equals("")){%>
                                var tb = new Ext.Toolbar();
                                tb.render('pagemenubar');
                            <%=pagemenustr%>
                            <%}%>
                       var xg = Ext.grid;

                       // shared reader
                       var reader = new Ext.data.ArrayReader({}, [
                          <%=readerStr%>
                       ]);

                       var grid = new xg.GridPanel({
                           region: 'center',
                           hideHeaders:true,
                           store: new Ext.data.GroupingStore({
                               reader: reader,
                               data: xg.dummyData,
                               sortInfo:{field: 'opttype', direction: "ASC"},
                               groupField:'opttype'
                           }),
                           columns: [
                               <%=colStr%>
                           ],

                           view: new Ext.grid.GroupingView({
                               forceFit:true,
                               startCollapsed:false,
                               hideGroupedColumn:true,
                               groupTextTpl: '<tpl if="gvalue==3">查看</tpl><tpl if="gvalue==15">编辑</tpl><tpl if="gvalue==105">删除</tpl><tpl if="gvalue==165">共享</tpl><tpl if="gvalue==6">监控</tpl>'
                           }),
                           frame:true,
                           collapsible: false,
                           animCollapse: true,
                           //title: '列表',
                           iconCls: 'icon-grid'
                       });
                           //Viewport

	                       var viewport = new Ext.Viewport({
                           layout: 'border',
                           items: [grid]
	                       });
                           
                   };
              // Array data for the grids
                   Ext.grid.dummyData = <%=jsondata.toString()%>;


    </script>
</HEAD>

<BODY>
<!--页面菜单开始-->     
<%
//pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:history.go(-1)}";
%>
<div id="pagemenubar"></div>
<!--页面菜单结束-->


</BODY>

</HTML>