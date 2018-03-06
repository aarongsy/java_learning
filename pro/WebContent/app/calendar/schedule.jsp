<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportfield" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.Page" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.NumberHelper" %>
<%@ page import="com.eweaver.base.util.SqlHelper" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%

EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
%>
<script language="javascript">
var obj = window;
if(window.opener != null && obj.opener != obj){
	obj.close();
	obj = window.opener;
}
while(obj.parent != null && obj.parent != obj)
	obj = obj.parent;

obj.location = "<%= request.getContextPath()%>/main/login.jsp";

</script>
<%
//	response.sendRedirect("/main/login.jsp");
	return;
}
if(null==eweaveruser.getOrgids()){
	eweaveruser.setOrgids("");
}
Humres currentuser = eweaveruser.getHumres();
//if(eweaveruser.getUsertype().equals("1")){
//	currentuser = ((HumresService)BaseContext.getBean("humresService")).getHumresById(eweaveruser.getId());
//}
%>

<%
String titlename="WeaverSoft Eweaver";
String titleimage=request.getContextPath()+"/images/main/titlebar_bg.jpg";
String pagemenustr="";
String pagemenuorder="0";
HashMap paravaluehm = new HashMap();
String theuri = request.getRequestURI().replace(request.getContextPath(),"");
LabelService labelService = (LabelService) BaseContext.getBean("labelService");
SetitemService setitemService0=(SetitemService)BaseContext.getBean("setitemService");
String style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
if(StringHelper.isEmpty(style)){
	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
        style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
}
%>
<head>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/e2cs_cn.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/e2cs_pack.js"></script>
<script src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script language="JScript.Encode" src="<%= request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%= request.getContextPath()%>/js/browinfo.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/ux/css/calendar.css">
<style type="text/css">
    .task_cnt  {white-space:normal;word-break:break-all;line-height: 1.4}
</style>
   <%
int pageSize=20;
int gridWidth=700;
int gridHeight=330;
String reportid = request.getParameter("reportid");
String oneself=StringHelper.null2String(request.getParameter("oneself"));
String share=StringHelper.null2String(request.getParameter("share"));//共享日程
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
String isnew=request.getParameter("isnew");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}

int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据
%>
 <%
   String isresource=StringHelper.null2String(request.getParameter("isresource"));
     String action2="";
     if(StringHelper.isEmpty(isresource))
     {
       action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&reportid=" + reportid;//日程
     }else
     {
      action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew="+isnew+"&action=search&reportid=" + reportid;//资源
     }
        String cmstr="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
      if(StringHelper.isEmpty(isresource))
      {
        fieldstr+="'id'";
      }else{
        fieldstr+="'requestid'";}
        Map reporttitleMap = new HashMap();
       int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();
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

         	String fieldname=formfields.getFieldname() ;
         	String showname=reportfield.getShowname();
         	int sortable= NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
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
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到
 %>
<script type="text/javascript">
<%
   String iscurrentuser=StringHelper.null2String(request.getParameter("iscurrentuser"));
   String categoryid=StringHelper.null2String(request.getParameter("categoryid"));
   String workflowid=StringHelper.null2String(request.getParameter("workflowid"));
   String humresid="";
  humresid=StringHelper.null2String(currentuser.getId());
%>

 var calendarstore;
<%
 String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.FormAction?action=getschedule&categoryid="+categoryid+"&workflowid="+workflowid;
%>
  Ext.LoadMask.prototype.msg='加载...';
    var resourceid;
    var store;
    var selected=new Array();
    var dlg0;
Ext.onReady(function() {
    Ext.QuickTips.init();
    calendarstore = new Ext.data.JsonStore({
        id:'recid',
        url: '<%=action%>',
        root:'result',
        fields:['recid','subject','description','startdate','enddate','color','priority','parent','resources','requestid','creator']
    });

    <%if(StringHelper.isEmpty(iscurrentuser)){%>
    store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase=0"%>'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: [<%=fieldstr%>]
        }),
        remoteSort: true
    });

     var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);
    cm.defaultSortable = true;

 var grid = new Ext.grid.GridPanel({
                       <%if(StringHelper.isEmpty(isresource)){%>
                       title:'我的下属',
                       <%}else{%>
                      title:'资源列表',
                      <%}%>
                       region: 'west',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       //loadMask: true,
                       split:true,
                       width:300,
                      collapsible:true,
                       collapseMode:'mini',
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
                           pageSize: <%=pageSize%>,
            store: store,
            displayInfo: false,
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
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
    <%if(StringHelper.isEmpty(isresource)){%>
        var humresid = rec.get('id');//日程管理
         calendarstore.baseParams.isone =0;
        calendarstore.baseParams.oneself ='<%=oneself%>';
        calendarstore.baseParams.humresid = humresid;
          calendarstore.baseParams.share = '<%=share%>';
        <%if(StringHelper.isEmpty(iscurrentuser)){%>
        calendar.show();
    <%}}else{%>
        resourceid = rec.get('requestid');//资源管理
        calendarstore.baseParams.resourceid = resourceid;
        calendar.show();
    <%}%>
        calendarstore.load();

    });
    <%if(StringHelper.isEmpty(isresource)){
        String stations=currentuser.getStation();
        String humressqlwhere="extrefobjfield15='"+ humresid+"'";
        if(!StringHelper.isEmpty(stations)){
                stations="'"+stations.replaceAll(",","','")+"'";
       humressqlwhere ="extrefobjfield15='"+ humresid+"' or ("+"exists (select 'X' from (select oid from stationlink where pid in("+stations+") ) tmp where tbalias.station like '%'"+SqlHelper.getConcatStr()+"tmp.oid"+SqlHelper.getConcatStr()+"'%'  )"+")";
        }

    %> //日程
    store.baseParams.sqlwhere="<%=StringHelper.getEncodeStr(humressqlwhere)%>";
    <%}%>
    store.load({params:{start:0, limit:<%=pageSize%>}});
    <%}%>
   <% if(StringHelper.isEmpty(isresource)){%>  //日程
     calendarstore.baseParams.humresid='<%=humresid%>';
    calendarstore.baseParams.oneself ='<%=oneself%>';
    calendarstore.baseParams.share ='<%=share%>';
    <%if(!StringHelper.isEmpty(iscurrentuser)){%>
     calendarstore.baseParams.ismy=1; //我的日程
    <%}%>
    <%}%>

    //init calendar

	buttonx1= new Ext.menu.Item({ id: 'buttonx1_task', iconCls:'x-calendar-month-btnmv_task',	text: "Custom menu test 1" });
	buttonx2= new Ext.menu.Item({ id: 'buttonx2_task',iconCls:'x-calendar-month-btnmv_task',	text: "Custom menu test 2" });

	buttonz1= new Ext.menu.Item({ id: 'buttonz1_task', iconCls:'x-calendar-month-btnmv_task',	text: "Custom action 1" });
	buttonz2= new Ext.menu.Item({ id: 'buttonz2_task',iconCls:'x-calendar-month-btnmv_task',	text: "Custom action 2" });

	boton_daytimertask  = new Ext.menu.Item({ id: 'btnTimerTask', iconCls:'task_time', text: "Set Task Alarm...."  });
	boton_daytimertaskb = new Ext.menu.Item({ id: 'btnTimerOff' , iconCls:'task_time_off', text: "Delete Task's Alarm...."  });

	button_sched_1= new Ext.menu.Item({ id: 'buttonx1_task',iconCls:'x-calendar-month-btnmv_task',text: "Custom menu  on sched test 1" });
	button_sched_2= new Ext.menu.Item({ id: 'buttonx2_task',iconCls:'x-calendar-month-btnmv_task',text: "Custom menu  on sched test 2" });

	var calendar = new Ext.ECalendar({
		id: 'test_calendar',
		name: 'test_calendar',
        <%if(StringHelper.isEmpty(isresource)){
        %>
        title:'日程管理',
        <%}else{%>
        title:'资源管理',
        <%}%>
        fieldsRefer:{ //0.0.11
			id:'recid',
			subject:'subject',
			description:'description',
			color:'color',
			startdate:'startdate',
			enddate:'enddate',
			priority:'priority',
			parent:'parent'
		},
		storeOrderby:'priority', 	//0.0.11
		storeOrder:'DESC',		//0.0.11
		showCal_tbar: true,
		showRefreshbtn:true,
		currentView: 'month',
		currentdate: new Date(),
		dateSelector: true,
		dateSelectorIcon: '<%= request.getContextPath()%>/js/ext/ux/css/images/date.png',
		dateSelectorIconCls: 'x-cmscalendar-icon-date-selector',
		dateformat :'Y-m-d',
		header: true,
		iconCls: 'x-cmscalendar-icon-main',
		store:calendarstore,
        monitorBrowserResize:true,
        widgetsBind: {bindMonth:null,bindDay:null,binWeek:null},
		tplTaskZoom: new Ext.XTemplate(
		'<tpl for=".">',
			'<div class="ecal-show-basetasktpl-div"><b>Subject:</b>{subject}<br>',
			'<b>Starts:</b>{startdate}<br><b>Ends:</b>{enddate}',
			'<br><b>Details:</b><div><hr><div>{description}<div><hr>',
		'</tpl>'
		),
        tplTaskTip:new Ext.XTemplate( '<tpl for=".">{starxl}{startval}<br>{endxl}{endval}<br>创建人:{creator}<hr color=\'#003366\' noshade>{details}</tpl>' ),
		iconToday:'<%= request.getContextPath()%>/js/ext/ux/css/images/cms_calendar.png',
		iconMonthView:'<%= request.getContextPath()%>/js/ext/ux/css/images/calendar_view_month.png',
		iconWeekView:'<%= request.getContextPath()%>/js/ext/ux/css/images/calendar_view_week.png',
		iconDayView:'<%= request.getContextPath()%>/js/ext/ux/css/images/calendar_view_day.png',
        iconSchedView:'<%= request.getContextPath()%>/js/ext/ux/css/images/calendar_view_schedule.png',
        loadMask:false, //0.0.12
		customMaskText:'<br>Wait a moment please...!<br>Processing Information for calendar', //0.0.12
		//-------- NEW on 0.0.10 -------------------
		sview:{
				header: true, headerFormat:'M-Y',
				headerButtons: true,
				headerAction:'event',  //gotoview
				periodselector:false,
				blankzonebg:'#6C90B4',
				//sched_addevent_id
				blankHTML:'<div id="{calx}-test-img" class="custom_image_addNewEvent_scheduler" style=" width:100%; background-color:#6C90B4"><div align="center" id="{sched_addevent_id}">此期间内没有计划</div></div>',
				listItems: {
					headerTitle:"计划",
					periodFormats:{
						Day:		'l - d - F  - Y',
						DayScheduler_format: 'd',
						hourFormat: 'h:i a',
						startTime:  '7:00:00 am',
						endTime:    '10:00:00 pm',
						WeekTPL:  	'<tpl for=".">Week No.{numweek} Starting on {datestart} Ending on {dateend}</tpl>',
						WeekFormat:	'W',
						DatesFormat:'d/m/Y',
						Month:'M-Y',
						TwoMonthsTPL:'<tpl for=".">期间{numperiod}({datestart}-{dateend})</tpl>',
						QuarterTPL:  '<tpl for=".">期间{numperiod}({datestart}-{dateend})</tpl>'
					},
					useStoreColor:false,
					descriptionWidth:246,
					parentLists:false, //to expand collapse Parent Items if false all tasks shown as parent
					launchEventOn:'click',
					editableEvents:true, // If true a context menu will appear
					ShowMenuItems:[0,0,0,0,0,0,0,0], // ADD, EDIT, DELETE, GO NEXT PERIOD , GO PREV PERIOD, Chg Month, Chg Week, CHG Day
					taskdd_ShowMenuItems:[0,0,0],    // ADD, EDIT, DELETE
					moreMenuItems:[button_sched_1,button_sched_2],
					taskdd_BaseColor:'#6C90B4',
					taskdd_clsOver:'test_taskovercss_sched',
					taskdd_showqtip:true,
					taskdd_shownames:true
				},
				listbody:{
					periodType:e2cs.schedviews.subView.TwoMonths,
					headerUnit:e2cs.schedviews.Units.Days,
					headerUnitWidth:25
				}
		},
		//-------------------------------------------
		mview:{
			header: true,
			headerFormat:'Y-F',
			headerButtons: true,
			dayAction:'event',    //dayAction: //viewday , event, window
            //moreMenuItems:[buttonx1,buttonx2],
            showTaskcount: false,
            taskStyle:'margin-top:10px;', //Css style for text in day(if it has tasks and showtaskcount:true)
            showTaskList: true,
            showNumTasks: 10 ,
            TaskList_launchEventOn:'click', //0.0.11
			TaskList_tplqTip: new Ext.XTemplate( '<tpl for=".">{starxl}{startval}<br>{endxl}{endval}<br>创建人:{creator}<hr color=\'#003366\' noshade>{details}</tpl>' ), //0.0.11
			ShowMenuItems:[0,1,1,0,0,0],  //0.0.11  - ADD, nextmonth, prevmonth, chg Week , CHG Day, chg Sched,
			//TaskList_moreMenuItems:[buttonz1,buttonz2], 	  //0.0.11
			TaskList_ShowMenuItems:[0,0,0]//0.0.11 	- Add, DELETE, EDIT
		},
		wview:{
			headerlabel:'Semana #',
			headerButtons: true,
			dayformatLabel:'D j',
            //moreMenuItems:[buttonx1,buttonx2],
			style: 'google',
			alldayTaksMore:'window',
			alldayTasksMaxView:300,
            startTime: '07:00:00 am',
			endTime:   '11:59:59 pm',
			store: null,
			task_width:40,
			tasksOffset:40,
            headerDayClick:'viewday',
			ShowMenuItems:[0,1,1,0,0,0],	//0.0.11  add, go next w , go prev w , chg month , chg day, chg sched
			task_ShowMenuItems:[0,0,0,0,0], //0.0.11  add, delete, edit, go next w , go prev w
			task_eventLaunch:'click',		//0.0.11
			task_clsOver:'test_taskovercss'
		},
		dview:{
			header:true,
			headerFormat:'Y - F  - d (周l)',
			headerButtons: true,
            moreMenuItems:[],

			// day specific
			//hourFormat: 'G',
            hourFormat: 'h',
			startTime: '07:00:00 am',
			endTime:   '11:59:59 pm',
			// task settings
			store: null,
			taskBaseColor: '#ffffff',
            taskAdd_dblclick: false,				//added on 0.0.7
			taskAdd_timer_dblclick:true,		//0.0.11
            task_clsOver:'test_taskovercss',
            task_DDeditable:true, 			    //0.0.11
			task_eventLaunch:'dblclick',
			useMultiColorTasks: false,
			multiColorTasks:[],
			tasks:[],
            //moreMenuItems:[	boton_daytimertask,	boton_daytimertaskb	],
		    task_clsOver:'test_taskovercss',
			ShowMenuItems:[0,1,1,0,0,0],		//0.0.11 ADD, next day, prev day , chg Month , CHG Week, chg Sched, (for daybody menu)
			task_DDeditable:true, 			    //0.0.11
			task_eventLaunch:'dblclick',  		    //0.0.11 'click, dblclick, if set to '' then no action is taken
			task_ShowMenuItems:[0,0,0,0,0]
		}
    });

    //dayClick only event on this object
	calendar.viewmonth.on({
		'dayClick':{
				fn: function(datex, mviewx, calx) {

                    calendarstore.baseParams.date =new Date(datex).format('Y-m-d');
                    calendarstore.baseParams.view='viewday';
                    calendarstore.load();
                    calx.currentdate= datex;
                    calx.selector_dateMenu.picker.setValue(datex);
                    calx.currentView='day';
                    calx.viewday.render();

				},
				scope:this
		},
		'beforeMonthChange':{
				fn: function(currentdate,newdate) {
					//alert ("change month to " + newdate.format('m/Y') + ' Actual date=' + currentdate.format('m/Y') );
					return false;
				},
				scope:this
		},
		'afterMonthChange':{
            fn: function(newdate) {
                calendarstore.baseParams.date=newdate.format('Y-m');
                //calendarstore.baseParams.humresid='<%=humresid%>';
                calendarstore.baseParams.view='viewmonth';
                calendarstore.load();
            },
				scope:this
		}
	});


	calendar.viewweek.on({
		'dblClickTaskAllDay':{
				fn: function(task,dxview,calendar) {
                    var requestid = task[1];
                    var url = '<%= request.getContextPath()%>/workflow/request/formbase.jsp?requestid=' + requestid;
                    dlg0.getComponent('dlgpanel').setSrc(url);
                    dlg0.show();
				},
				scope:this
		},
		'beforeWeekChange':{
			fn: function (currentDate, newDate){
					return false;
			}
		},
		'afterWeekChange':{
			fn: function(newdate) {
                tmpdate = new Date(newdate);
                tmpdate.getDay()
                var initdate = new Date(newdate.add(Date.DAY, ((tmpdate.getDay() - 1) * -1)).format('m/d/Y') + ' ' + calendar.dview.startTime);
                var enddate = new Date(newdate.add(Date.DAY, +(7 - newdate.getDay())).format('m/d/Y') + ' ' + calendar.dview.endTime);
                calendarstore.baseParams.initdate = initdate.format('Y-m-d');
                calendarstore.baseParams.enddate = enddate.format('Y-m-d');
                calendarstore.baseParams.view='viewweek';
                calendarstore.load();
            },
				scope:this
		}
	});

	//'beforeDayChange' and  'afterDayChange' unique events on day view
	calendar.viewday.on({
		'beforeDayChange':{
				fn: function(currentdate, newdate) {
					//alert ("change to " + newdate.format('m/d/Y') + ' Actual date=' + currentdate.format('m/d/Y') );
					return false;
				},
				scope:this
		},
		'afterDayChange':{
				fn: function(newdate) {
					calendarstore.baseParams.date =newdate.format('Y-m-d');
                    //calendarstore.baseParams.humresid='<%=humresid%>';
                    calendarstore.baseParams.view='viewday';
                    calendarstore.load();
				},
				scope:this
		}
	});

    calendar.viewscheduler.on({
		'headerClick':{
				fn: function(refunit,datex, mviewx, calx) {

				},
				scope:this
		},
		'listItemSendData':{
				fn:function(recordId,dataObj){
                    var requestid = recordId;
                    var url = '<%= request.getContextPath()%>/workflow/request/formbase.jsp?requestid=' + requestid;
                    dlg0.getComponent('dlgpanel').setSrc(url);
                    dlg0.show();
				}
		},
		'beforePeriodChange':{
				fn:function(refperiod,datexold,datexnew){
					if (refperiod==1){ //week
						//do your stuff here
					} else {
						//do your stuff here
					}
					return false;
				},
				scope:this
		},
		'afterPeriodChange':{
				fn:function(refperiod,datexnew){
			    calendarstore.baseParams.date=datexnew.format('Y-m');
                //calendarstore.baseParams.humresid='<%=humresid%>';
                calendarstore.baseParams.view='viewmonth';
                calendarstore.load();
				}
		}
	});
	calendar.on({
		'beforeChangeDate': {
			fn: function( newdate , calobj){
				return true;
			}
		},
		'afterChangeDate':{
			fn: function( newdate , calobj){
                calendarstore.baseParams.date =new Date(newdate).format('Y-m-d');
                calendarstore.baseParams.view='viewday';
                calendarstore.load();

            }
		},
		'onChangeView':{
			fn: function(newView, oldView, calobj){
				//Ext.get("samplebox_cview").update("<b>Current View:</b> " + newView);
			},scope: this
		},
		'beforeChangeView':{
				fn: function (newView,OldView,calendarOBJ){
					if (newView==OldView){
						return true;
					}
                    if (newView == 'month') {
                        calendarstore.baseParams.date = calendarOBJ.currentdate.format('Y-m');
                        calendarstore.baseParams.view = 'viewmonth';
                        calendarstore.load();
                        return true;
                    }
                    if(OldView=='day'&&newView=='week') {
                        newdate = calendarOBJ.currentdate;
                        tmpdate = new Date(newdate);
                        tmpdate.getDay();
                        var initdate = new Date(newdate.add(Date.DAY, ((tmpdate.getDay() - 1) * -1)).format('m/d/Y') + ' ' + calendar.dview.startTime);
                        var enddate = new Date(newdate.add(Date.DAY, +(7 - newdate.getDay())).format('m/d/Y') + ' ' + calendar.dview.endTime);
                        calendarstore.baseParams.initdate = initdate.format('Y-m-d');
                        calendarstore.baseParams.enddate = enddate.format('Y-m-d');
                        calendarstore.baseParams.view = 'viewweek';
                        calendarstore.load();
                    }
				},scope:this
		},
		'taskAdd':{
				fn: function( datex ) {
                    var initdatetime = new Date(datex).format('Y-m-d H:m:s') ;
                    var initdate=initdatetime.substring(0,10);
                    var inittime=initdatetime.substring(11,14)+'00:00';
                    <%if(workflowid.equals("")){%>
                    var url = '<%= request.getContextPath()%>/workflow/request/formbase.jsp?categoryid=<%=categoryid%>&date='+initdate+'&time='+inittime+'&resourceid='+resourceid ;
                    <%}else{%>
                    var url = '<%= request.getContextPath()%>/workflow/request/workflow.jsp?workflowid=<%=workflowid%>&date='+initdate+'&time='+inittime+'&resourceid='+resourceid ;
                    <%}%>
                    dlg0.getComponent('dlgpanel').setSrc(url);
                    dlg0.show();
				}
		},
		'taskDblClick':{
				fn: function (task,dxview,calendar,refviewname){
                    var requestid=task[1];
                     //var url = '<%= request.getContextPath()%>/workflow/request/formbase.jsp?requestid=' + requestid;
					 var url = '<%= request.getContextPath()%>/workflow/request/workflow.jsp?from=report&requestid=' + requestid;
                     this.dlg0.getComponent('dlgpanel').setSrc(url);
                    this.dlg0.show();
				},
				scope:this
		},
		'beforeTaskDelete': {
				fn: function (datatask,dxview) {
					return false;
					// do your stuff to check if the event/task could be deleted
				}, scope:this
		},
		'onTaskDelete':{
			fn:function(datatask){
				//var r=confirm("Delete event " + datatask[1] + " " + datatask[2] + "...? YES/NO" );
				//return r;
				// do your stuf for deletion and return the value
			},scope:this
		},
	   'afterTaskDelete':{
	   		fn: function(datatask,action){
				action ? alert("Event: " + datatask[1] + " " + datatask[2] + " Deleted"): alert("Event Delete was canceled..!");
				// perform any action after deleting the event/task
			},scope:this
 	    },
		'beforeTaskEdit': {
				fn: function (datatask,dxview) {
					return false;
				}, scope:this
		},
	   'onTaskEdit':{
			fn:function(datatask){
				//var r=confirm("Edit event " + datatask[1] + " " + datatask[2] + "...? YES/NO" );
				return true;
				// do your stuf for editing and return the value
			},scope:this
	    },
	    'afterTaskEdit':{
	   		fn: function(datatask,action){
				// perform any action after deleting the event/task
				if (action){
					//alert("Event: " + datatask[1] + " " + datatask[2] + " Edited");
				} else {
					//alert("Event Edit was canceled..!");
				}
				return false;
			},scope:this
	    },
		'beforeTaskMove':{
				fn: function (datatask,Taskobj,dxview,TaskEl) { // return "true" to cancel or "false" to go on
					return true;
				}, scope:this
		},
		'TaskMoved':{
				fn: function (newDataTask,Taskobj,dxview,TaskEl) {   // do some stuff
					var test=21;  // use breakpoint in firefox here
					task = newDataTask;
					datatest ='Task id:'  + task[0] + ' ' + task[2] + '<br>';
					datatest+='recid:'    + task[1] + '<br>';
					datatest+='starts:'    + task[3] + '<br>';
					datatest+='ends:'   + task[4] + '<br>';
					datatest+='contents:' + task[5] + '<br>';
					datatest+='index:'    + task[6] + '<br>';
					Ext.Msg.alert('Information Modified task', datatest);
//					var myrecordtask = prueba.store.getAt( (parseInt(task[6])-1) ); //Alert...!   base number of index are 1  not 0
//					myrecordtask.set('startdate',task[3] );
//					myrecordtask.set('enddate',task[4] );
//					prueba.store.commitChanges();

				}, scope:this
		},
		'customMenuAction':{
				fn: function (MenuId, Currentview, datatask,objEl,dxview){
					var datatest = '';
					if (Currentview=='month'){
						task = datatask;
						datatest ='Day :'  + task[0] + '<br>';
						datatest+='type:'  + task[1] + '<br>';
						Ext.Msg.alert('(Month) Information- ' + Currentview, datatest);
					} else if (Currentview=='day'){
						task = datatask;
						datatest ='Task id:'  + task[0] + ' ' + task[1] + '<br>';
						datatest+='starts:'    + task[2] + '<br>';
 						datatest+='Ends:'   + task[3] + '<br>';
 						datatest+='contents:' + task[4] + '<br>';
						datatest+='index:'    + task[5] + '<br>';
						datatest+='Test Menu:'  + MenuId + '<br>';
						Ext.Msg.alert('(Day) Task information' + Currentview, datatest);
					} else if (Currentview=='week'){

					}
				},scope:this
		}

	});

    //Viewport
   <%if(StringHelper.isEmpty(iscurrentuser)){%>
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid,{
                    region:'center',
					header:false,
                    width: 500,
                    layout:'fit',
                    margins:'0 0 0 0',
                    items:[calendar]
                 }]
	});

    calendar.hide();// 当打开的页面不是我的日程时,初次加载隐藏日程控件
  <%}else{%>

     var viewport = new Ext.Viewport({
        layout: 'border',
        items: [ {
                    region:'center',
					header:false,
                    width: 500,
                    layout:'fit',
                    margins:'0 0 0 0',
                    items:[calendar]
                 }]
	});
    <%}%>
    var myMask = new Ext.LoadMask(Ext.getBody());
    calendarstore.on('beforeload', function() {
        myMask.show();
    });
    calendarstore.on('load', function() {
        myMask.hide();
        calendar.refreshCalendarView()
    });
    calendar.tools.refresh.removeAllListeners();
    calendar.tools.refresh.on('click',function(){calendarstore.load()}) ;
    <%if(!StringHelper.isEmpty(iscurrentuser)){%>
    calendarstore.load();
    <%}%>
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
                           dlg0.getComponent('dlgpanel').setSrc('about:blank');
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
</body>
</html>