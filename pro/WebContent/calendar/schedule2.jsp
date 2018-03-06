<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String viewtype = StringHelper.null2String(request.getParameter("viewtype"));
if(StringHelper.isEmpty(viewtype)){
	viewtype = "week";
}

String iscurrentuser = StringHelper.null2String(request.getParameter("iscurrentuser"));
String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
String formid = StringHelper.null2String(request.getParameter("formid"));

String humresid = StringHelper.null2String(request.getParameter("humresid"));
if(StringHelper.isEmpty(humresid)){
	humresid = StringHelper.null2String(currentuser.getId());
}

boolean isCanCreate = false;	//设置此项为false之后，可以编辑但是不可以通过鼠标选择区域之后快速创建日程。
String oneself = StringHelper.null2String(request.getParameter("oneself"));
if(StringHelper.isEmpty(oneself) && iscurrentuser.equals("1")){	//当oneself为空并且当前用户标记是1, 即为我的日程视图
	oneself = "1";
	isCanCreate = true;
}

String calformid = StringHelper.null2String(request.getParameter("calformid"));
String iscalshare = StringHelper.null2String(request.getParameter("iscalshare"));

//下面这些参数不见得有用，只是根据以前的页面逻辑照传，怕项目上有用到(start)
String isone = StringHelper.null2String(request.getParameter("isone"), "0");
String share = StringHelper.null2String(request.getParameter("share"));//共享日程
//end
%>
<html>
<head>
	<title>Eweaver Schedule</title>
	<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
	<link href="/js/jquery/plugins/wdCalendar/css/dailog.css" rel="stylesheet" type="text/css" />
	<link href="/js/jquery/plugins/wdCalendar/css/calendar.css" rel="stylesheet" type="text/css" /> 
	<link href="/js/jquery/plugins/wdCalendar/css/dp.css" rel="stylesheet" type="text/css" />   
	<link href="/js/jquery/plugins/wdCalendar/css/alert.css" rel="stylesheet" type="text/css" /> 
	<link href="/js/jquery/plugins/wdCalendar/css/main.css" rel="stylesheet" type="text/css" /> 
  

	<script src="/js/jquery/plugins/wdCalendar/src/jquery.js" type="text/javascript"></script>  
	
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/Common.js" type="text/javascript"></script>    
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/datepicker_lang_ZH.js" type="text/javascript"></script>     
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/jquery.datepicker.js" type="text/javascript"></script>
	
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/jquery.alert.js" type="text/javascript"></script>    
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/jquery.ifrmdailog.js" defer="defer" type="text/javascript"></script>
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/wdCalendar_lang_ZH.js" type="text/javascript"></script>    
	<script src="/js/jquery/plugins/wdCalendar/src/Plugins/jquery.calendar.js" type="text/javascript"></script>
	
	<% if(!userMainPage.getIsClassic() || !"default".equals(style)){ //不是传统首页默认皮肤时(加入自定义的样式调整)%>
	<link href="/calendar/css/customCalendar.css" rel="stylesheet" type="text/css" /> 
	<% } %>
	
	<script type="text/javascript">
		$(document).ready(function() { 
            var view="<%=viewtype%>";          
           
            var op = {
                view: view,
                theme:3,
                showday: new Date(),
                EditCmdhandler:Edit,
                DeleteCmdhandler:Delete,
                ViewCmdhandler:View,    
                onWeekOrMonthToDay:wtd,
                onBeforeRequestData: cal_beforerequest,
                onAfterRequestData: cal_afterrequest,
                onRequestDataError: cal_onerror, 
                autoload:true,
                canCreate:<%=isCanCreate%>,
                url: "/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=getSchedule",  
                quickAddUrl: "/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=quickAddSchedule", 
                quickUpdateUrl: "/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=quickUpdateSchedule",
                quickDeleteUrl: "/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=quickDeleteSchedule",
                extParam : [
                	{name:"iscurrentuser", value:"<%=iscurrentuser%>"}, 
                	{name:"categoryid", value:"<%=categoryid%>"},
                	{name:"workflowid", value:"<%=workflowid%>"},
                	{name:"formid", value:"<%=formid%>"},
                	{name:"humresid", value:"<%=humresid%>"},
                	{name:"oneself", value:"<%=oneself%>"},
                	{name:"isone", value:"<%=isone%>"},
                	{name:"share", value:"<%=share%>"},
                	{name:"calformid", value:"<%=calformid%>"},
                	{name:"iscalshare", value:"<%=iscalshare%>"}
                ]
            };
            var $dv = $("#calhead");
            var _MH = document.body.clientHeight;
            var dvH = $dv.height() + 2;
            op.height = _MH - dvH;
            op.eventItems =[];

            var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
            setTimeout(function(){
            	if (p && p.datestrshow) {
	                $("#txtdatetimeshow").text(p.datestrshow);
	            }
            },500);
            $("#caltoolbar").noSelect();
            
            $("#hdtxtshow").datepicker({ picker: "#txtdatetimeshow", showtarget: $("#txtdatetimeshow"),
            onReturn:function(r){                          
                            var p = $("#gridcontainer").gotoDate(r).BcalGetOp();
                            if (p && p.datestrshow) {
                                $("#txtdatetimeshow").text(p.datestrshow);
                            }
                     } 
            });
            function cal_beforerequest(type)
            {
                var t="数据加载中...";
                switch(type)
                {
                    case 1:
                        t="数据加载中...";
                        break;
                    case 2:                      
                    case 3:  
                    case 4:    
                        t="请求正在处理中 ...";                                   
                        break;
                }
                $("#errorpannel").hide();
                $("#loadingpannel").html(t).show();    
            }
            function cal_afterrequest(type)
            {
                switch(type)
                {
                    case 1:
                        $("#loadingpannel").hide();
                        break;
                    case 2:
                    case 3:
                    case 4:
                        $("#loadingpannel").html("操作成功!");
                        window.setTimeout(function(){ $("#loadingpannel").hide();},2000);
                    break;
                }              
               
            }
            function cal_onerror(type,data)
            {
                $("#errorpannel").show();
            }
            function Edit(data)
            {
				var eurl="scheduleinfo.jsp?requestid={0}&title={1}&startDateTime={2}&endDateTime={3}&categoryid=<%=categoryid%>&formid=<%=formid%>&workflowid=<%=workflowid%>";   
				if(data)
                {
                	if(data[0] == "0"){
                		data[0] = "";
                	}
                	if(data[2] instanceof Date){
                		data[2] = dateFormat.call(data[2], "yyyy-MM-dd HH:mm");
                	}
                	if(data[3] instanceof Date){
                		data[3] = dateFormat.call(data[3], "yyyy-MM-dd HH:mm");
                	}
                    var url = StrFormat(eurl,data);
                    <%if(!StringHelper.isEmpty(iscalshare)){ //共享日程增加权限参数传递%>
                    	url += "&iscalshare=<%=iscalshare%>&shareuserid=<%=humresid%>";
                    <%}%>
                    openScheduleDialog(url, "", 600, 400);
                }
            }    
            function View(data)
            {
                var str = "";
                str += "标题：" + data[1] + "\n";
                str += "内容：" + data[9] + "\n";
                str += "开始时间：" + dateFormat.call(data[2], "yyyy-MM-dd HH:mm") + "\n";
                str += "结束时间：" + dateFormat.call(data[3], "yyyy-MM-dd HH:mm") + "\n";
                var viewUrl = "/workflow/request/workflow.jsp?from=report&requestid=" + data[0];
                str += "<a style=\"color:#112abb;text-decoration:underline;\" href=\"javascript:void(0);\" onclick=\"onUrl('"+viewUrl+"', '"+data[1]+"', 'tab"+data[0]+"');\">点击查看详细信息</a>\n";
                /*
                $.each(data, function(i, item){
                    str += "[" + i + "]: " + item + "\n";
                });*/
                $.alerts.okButton="确定";  
                hiAlert(str, '概要信息');               
            }    
            function Delete(data,callback)
            {           
                
                $.alerts.okButton="确定";  
                $.alerts.cancelButton="取消";  
                hiConfirm("确定要删除该信息吗?", '删除确认',function(r){ r && callback(0);});           
            }
            function wtd(p)
            {
               if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $("#showdaybtn").addClass("fcurrent");
            }
            //to show day view
            $("#showdaybtn").click(function(e) {
                //document.location.href="#day";
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("day").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            //to show week view
            $("#showweekbtn").click(function(e) {
                //document.location.href="#week";
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("week").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

            });
            //to show month view
            $("#showmonthbtn").click(function(e) {
                //document.location.href="#month";
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("month").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            
            $("#showreflashbtn").click(function(e){
                $("#gridcontainer").reload();
            });
            
            //Add a new event
            $("#faddbtn").click(function(e) {
                var url="scheduleinfo.jsp?categoryid=<%=categoryid%>&formid=<%=formid%>&workflowid=<%=workflowid%>";   
				openScheduleDialog(url, "新建", 600, 400);
            });
            <%if(!isCanCreate){	//在此视图中不允许新建操作%>
            	$("#faddbtn").hide();
            <%}%>
            //go to today
            $("#showtodaybtn").click(function(e) {
                var p = $("#gridcontainer").gotoDate().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }


            });
            //previous date range
            $("#sfprevbtn").click(function(e) {
                var p = $("#gridcontainer").previousRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

            });
            //next date range
            $("#sfnextbtn").click(function(e) {
                var p = $("#gridcontainer").nextRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            
            if (!dateFormat || typeof (dateFormat) != "function") {
		        var dateFormat = function(format) {
		            var o = {
		                "M+": this.getMonth() + 1,
		                "d+": this.getDate(),
		                "h+": this.getHours(),
		                "H+": this.getHours(),
		                "m+": this.getMinutes(),
		                "s+": this.getSeconds(),
		                "q+": Math.floor((this.getMonth() + 3) / 3),
		                "w": "0123456".indexOf(this.getDay())
		            };
		            if (/(y+)/.test(format)) {
		                format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
		            }
		            for (var k in o) {
		                if (new RegExp("(" + k + ")").test(format))
		                    format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		            }
		            return format;
		        };
		    }
            
		});
		
		function openScheduleDialog(url,title,width,height){
			var config = {
			    layout:'border',
			    closeAction:'close',
			    plain: true,
			    modal :true,
			    items:[{
			        id:'commondlg',
			        region:'center',
			        xtype     :'iframepanel',
			        frameConfig: {
			            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
			            eventsFollowFrameLinks : false
			        },
			        autoScroll:true
			    }]
			};
			if(getCurrentSysMode() == "1"){
				config["y"] = 100;
			}
		   	var scheduleDialog = new Ext.Window(config);
		    scheduleDialog.render(Ext.getBody());
		    scheduleDialog.setTitle(title);
		    scheduleDialog.setWidth(width);
		    scheduleDialog.setHeight(height);
		    scheduleDialog.getComponent('commondlg').setSrc(url);
		    scheduleDialog.on("close", function(){
		    	$("#gridcontainer").reload();
		    });
		    scheduleDialog.show();
		}
	</script>
</head>
  
<body>
  <div>

      <div id="calhead" style="padding-left:1px;padding-right:1px;">          
            <div class="cHead"><div class="ftitle">信息</div>
            </div>          
            
            <div id="caltoolbar" class="ctoolbar">
              <div id="faddbtn" class="fbutton">
                <div><span title='Click to Create New Event' class="addcal">

                	新建               
                </span></div>
            </div>
            <div class="btnseparator"></div>
             <div id="showtodaybtn" class="fbutton">
                <div><span title='Click to back to today ' class="showtoday">
                	今天</span></div>
            </div>
              <div class="btnseparator"></div>

            <div id="showdaybtn" class="fbutton">
                <div><span title='Day' class="showdayview">日</span></div>
            </div>
              <div  id="showweekbtn" class="fbutton fcurrent">
                <div><span title='Week' class="showweekview">周</span></div>
            </div>
              <div  id="showmonthbtn" class="fbutton">
                <div><span title='Month' class="showmonthview">月</span></div>

            </div>
            <div class="btnseparator"></div>
              <div  id="showreflashbtn" class="fbutton">
                <div><span title='Refresh view' class="showdayflash">刷新</span></div>
                </div>
             <div class="btnseparator"></div>
            <div id="sfprevbtn" title="Prev"  class="fbutton">
              <span class="fprev"></span>

            </div>
            <div id="sfnextbtn" title="Next" class="fbutton">
                <span class="fnext"></span>
            </div>
            <div id="fshowdatepbtn" class="fshowdatep fbutton">
                    <div>
                        <input type="hidden" name="txtshow" id="hdtxtshow" />
                        <span id="txtdatetimeshow"></span>

                    </div>
            </div>
            
            <div class="clear"></div>
            <div id="loadingpannel" class="ptogtitle loadicon" style="display: none;">加载中...</div>
             <div id="errorpannel" class="ptogtitle loaderror" style="display: none;">数据加载失败，请稍后重试</div>
            </div>
      </div>
      <div style="padding:1px;">

        <div class="t1 chromeColor">
            &nbsp;</div>
        <div class="t2 chromeColor">
            &nbsp;</div>
        <div id="dvCalMain" class="calmain printborder">
            <div id="gridcontainer" style="overflow-y: visible;">
            </div>
        </div>
        <div class="t2 chromeColor">

            &nbsp;</div>
        <div class="t1 chromeColor">
            &nbsp;
        </div>   
      </div>
      
  </div>
</body>
</html>
