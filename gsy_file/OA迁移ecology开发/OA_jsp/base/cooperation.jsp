<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%


	DataService ds = new DataService();
	StringBuffer cont = new StringBuffer();
	String sql = "select * from selectitem where typeid='4028807327e0e09d0127e599f48e04cc'  order by dsporder";
	List dataList = ds.getValues(sql);
	StringBuffer buf1 = new StringBuffer();
	for(int k=0,size=dataList.size() ; k<size ; k++) {
		Map m = (Map)dataList.get(k);
		String objname = StringHelper.null2String(m.get("objname")) ;
		String id = StringHelper.null2String(m.get("id")) ;
		String imagefield = StringHelper.null2String(m.get("imagefield")) ;
		buf1.append("addTab(contentPanel,'/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=4028807327e0e09d0127e5ca6c59055c&con4028807327e0e09d0127e5a981e004e6_value="+id+"','"+objname+"','"+imagefield+"');");
	}
%>
<head>
<script type="text/javascript" src="/js/ext/ux/e2cs_cn.js"></script>
<script type="text/javascript" src="/js/ext/ux/e2cs_pack.js"></script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<link rel="stylesheet" type="text/css" href="/js/ext/ux/css/calendar.css">
<style type="text/css">
    .task_cnt  {white-space:normal;word-break:break-all;line-height: 1.4}
</style>
<script type="text/javascript">
 var calendarstore;
  Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载中...
    var resourceid;
    var store;
    var selected=new Array();
    var dlg0;
Ext.onReady(function() {
    Ext.QuickTips.init();
    calendarstore = new Ext.data.JsonStore({
        id:'recid',
        url: '/ServiceAction/com.eweaver.workflow.request.servlet.FormAction?action=getschedule&categoryid=5c78e08422b085b40122b0c513ce02b7&workflowid=',
        root:'result',
        fields:['recid','subject','description','startdate','enddate','color','priority','parent','resources','requestid','creator']
    });

    
    store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew=null&reportid=5c78e08422e8ee9f0122e94395a80014&isjson=1&pagesize=20&isformbase=0'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: ['id','objno','objname','orgid','mainstation','col1','extdatefield1','email','gender','extselectitemfield0']
        }),
        remoteSort: true
    });
  
     var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([{header:'<%=labelService.getLabelNameByKeyId("402883d934c0e5760134c0e576b90000") %>',//员工编号
    	dataIndex:'objno',width:0,sortable:true},
    	{header:'<%=labelService.getLabelNameByKeyId("402883d934c0e8290134c0e82a3b0000") %>',dataIndex:'objname',width:0,sortable:true},//中文名
    	{header:'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d") %>',dataIndex:'orgid',width:0,sortable:true},//部门
    	{header:'<%=labelService.getLabelNameByKeyId("402881e510e569090110e56e72330003") %>',dataIndex:'mainstation',width:0,sortable:true},//岗位
    	{header:'<%=labelService.getLabelNameByKeyId("402883d934c0eacb0134c0eacbbd0000") %>',dataIndex:'col1',width:0,sortable:true},//身份证号码
    	{header:'<%=labelService.getLabelNameByKeyId("402883d934c0ec200134c0ec20d90000") %>',dataIndex:'extdatefield1',width:0,sortable:true},//转正日期
    	{header:'<%=labelService.getLabelNameByKeyId("402883d934c0ef630134c0ef63f80000") %>',dataIndex:'email',width:0,sortable:true},//E-Mail 邮件地址
    	{header:'<%=labelService.getLabelNameByKeyId("402881e70b7728ca010b773ff0b0000c") %>',dataIndex:'gender',width:0,sortable:true},//性别
    	{header:'<%=labelService.getLabelNameByKeyId("402883d934c0f1da0134c0f1db130000") %>',dataIndex:'extselectitemfield0',width:0,sortable:true}]);//职员状态
    cm.defaultSortable = true;

 var grid = new Ext.grid.GridPanel({
                       
                       title:'<%=labelService.getLabelNameByKeyId("402883d934c0f2e00134c0f2e0cd0000") %>',//我的协作
                       
                       region: 'west',
                       store: store,                                                                      
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       //loadMask: true,
                       split:true,
                       width:400,
                      collapsible:true,
                       collapseMode:'mini',
                       viewConfig: {
                           forceFit:true,
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       bbar: new Ext.PagingToolbar({
                           pageSize: 20,
            store: store,
            displayInfo: false,
            beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示     条记录
            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>" 
        })
    });
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
    
        var humresid = rec.get('id');//日程管理
         calendarstore.baseParams.isone =0;
        calendarstore.baseParams.oneself ='';
        calendarstore.baseParams.humresid = humresid;
          calendarstore.baseParams.share = '';
        
        calendar.show();
    
        calendarstore.load();

    });
     //日程
    store.baseParams.sqlwhere="extrefobjfield15='402881e70be6d209010be75668750014'";
    
    store.load({params:{start:0, limit:20}});
    
     //日程
     calendarstore.baseParams.humresid='402881e70be6d209010be75668750014';
    calendarstore.baseParams.oneself ='';
    calendarstore.baseParams.share ='';
    
    

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
        
        title:'<%=labelService.getLabelNameByKeyId("402883d934c10c0c0134c10c0cdb0000") %>',//日程管理
        
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
		dateSelectorIcon: '/js/ext/ux/css/images/date.png',
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
        tplTaskTip:new Ext.XTemplate( '<tpl for=".">{starxl}{startval}<br>{endxl}{endval}<br><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a") %>:{creator}<hr color=\'#003366\' noshade>{details}</tpl>' ), //创建人
		iconToday:'/js/ext/ux/css/images/cms_calendar.png',
		iconMonthView:'/js/ext/ux/css/images/calendar_view_month.png',
		iconWeekView:'/js/ext/ux/css/images/calendar_view_week.png',
		iconDayView:'/js/ext/ux/css/images/calendar_view_day.png',
        iconSchedView:'/js/ext/ux/css/images/calendar_view_schedule.png',
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
				blankHTML:'<div id="{calx}-test-img" class="custom_image_addNewEvent_scheduler" style=" width:100%; background-color:#6C90B4"><div align="center" id="{sched_addevent_id}"><%=labelService.getLabelNameByKeyId("402883d934c10e960134c10e97030000") %></div></div>',//此期间内没有计划
				listItems: {
					headerTitle:"<%=labelService.getLabelNameByKeyId("402883d934c110890134c11089c30000") %>",//计划
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
						TwoMonthsTPL:'<tpl for="."><%=labelService.getLabelNameByKeyId("402883d934c111b80134c111b9100000") %>{numperiod}({datestart}-{dateend})</tpl>',//期间
						QuarterTPL:  '<tpl for="."><%=labelService.getLabelNameByKeyId("402883d934c111b80134c111b9100000") %>{numperiod}({datestart}-{dateend})</tpl>'
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
			TaskList_tplqTip: new Ext.XTemplate( '<tpl for=".">{starxl}{startval}<br>{endxl}{endval}<br><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a") %>:{creator}<hr color=\'#003366\' noshade>{details}</tpl>' ), //0.0.11
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
                //calendarstore.baseParams.humresid='402881e70be6d209010be75668750014';
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
                    var url = '/workflow/request/formbase.jsp?requestid=' + requestid;
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
                    //calendarstore.baseParams.humresid='402881e70be6d209010be75668750014';
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
                    var url = '/workflow/request/formbase.jsp?requestid=' + requestid;
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
                //calendarstore.baseParams.humresid='402881e70be6d209010be75668750014';
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
                    
                    var url = '/workflow/request/formbase.jsp?categoryid=5c78e08422b085b40122b0c513ce02b7&date='+initdate+'&time='+inittime+'&resourceid='+resourceid ;
                    
                    dlg0.getComponent('dlgpanel').setSrc(url);
                    dlg0.show();
				}
		},
		'taskDblClick':{
				fn: function (task,dxview,calendar,refviewname){
                    var requestid=task[1];
                     //var url = '/workflow/request/formbase.jsp?requestid=' + requestid;
					 var url = '/workflow/request/workflow.jsp?from=report&requestid=' + requestid;
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
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   