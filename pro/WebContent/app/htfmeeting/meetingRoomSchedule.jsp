<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/base/init.jsp"%>

<%
    String mdate = "";
    String disDate = "";
    Date newDate = new Date();
    DateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd");
	if (request.getParameter("date") != null) {
		mdate = newFormat.format(new Date(request.getParameter("date").replace("-","/")));
	} else {
		if (request.getParameter("disDate") != null) {
	      mdate = request.getParameter("disDate") + "-01";
		} else {
		  mdate = newFormat.format(newDate).toString().trim();
		}
	}
    if (request.getParameter("disDate") != null) {
    	String len = request.getParameter("len");
    	disDate = request.getParameter("disDate");
    	disDate = DateHelper.monthMove(disDate,Integer.parseInt(len));
    } else {
    	disDate = newFormat.format(newDate).toString().trim().substring(0,7);
    }
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String selMeetRoomSql = "select m.requestid,a.roomname,m.starttime,m.endtime,m.startdate from uf_meetingroomuser m join uf_admin_meetingroom a on m.roomid = a.requestid where m.startdate = '" + mdate + "'";
    List mrList = baseJdbc.executeSqlForList(selMeetRoomSql);
	String getMeettingRoomSql = "select id,roomname from uf_admin_meetingroom";
	List meetRoomList = baseJdbc.executeSqlForList(getMeettingRoomSql);
%>
<html>
<head>
<title>会议室预定</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" href="/app/htfmeeting/common.css" type="text/css"></link>
<link rel="stylesheet" href="/app/htfmeeting/share.css"/>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" ></script>
<script type="text/javascript" language="javascript" src="/js/main.js" ></script>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script  type='text/javascript' src='/js/workflow.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/pPageSize.js"></script>
<style type="text/css">
body,p,table,td,input,div,select,button,span,a,textarea{font-size: 14px;}
#tab tbody tr td{cursor:hand;background-color:#ffffff;font-size:14px;}
.meetingcontent{padding: 0px 0px 0px 0px;margin: 0px;text-align: center;}
.meetingcontent #dateid{width:1000px;height:100%;background-color:#ffffff;padding: 5px 5px 0px 0px;}
#dateid a {font-size:12;color:blank;}
#btn_s{width: 60%;overflow: hidden;}
.hrcss{background-color: #ffffff;border-bottom: #c83e31 2px solid;}
.hycss{ margin-top:10;margin-left:0;}
.maincss{background-color:#f5f5ed;width:1000px;text-align: center;margin-top: 0px;}
.timecss{padding:10,10,10,15;width:100%;text-align: center;}
.timecss .tab{text-align: center;border:1px solid blank;}
</style>
   <script type="text/javascript">
   <%
   pagemenustr +="addBtn(tb,'保存','S','erase',function(){onSubmit()});";
   %>
   Ext.onReady(function(){
              Ext.QuickTips.init();
          <%if(!pagemenustr.equals("")){%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>
          });
    var dateArr = new Array('800','830','900','930','1000','1030','1100','1130','1200','1230','1300','1330','1400','1430','1500','1530','1600','1630','1700','1730','1800','1830','1900','1930','2000');
    var initStartDate = "08:00:00";
    var initEndDate = "20:00:00";
    var cyclenum;
    <%--判断开始时间或结束时间是否在数据库中存在--%>
    function ifreserve(startDate,endDate,meetRoom) {
    	var tempSDate3 = startDate.substring(5,6);
    	var tempstartDate = startDate;
    	  /*if(tempSDate3==0){
   			   var syears = startDate.substring(0,5);
   			   var sday = startDate.substring(6,startDate.length);
   			   tempSDate3 = 12;
   			   tempstartDate = syears+tempSDate3+sday;
          }*/
        var flag;
		 var sql = "select startdate,starttime,endtime from uf_meetingroomuser m, uf_admin_meetingroom a where  m.roomid = a.requestid and " +
		     "to_date('" + tempstartDate + "','yyyy-MM-dd hh24:mi:ss') < to_date(startdate||endTime,'yyyy-MM-dd hh24:mi:ss') " + 
		     "and to_date('" + endDate + "','yyyy-MM-dd hh24:mi:ss') > to_date(startdate||startTime,'yyyy-MM-dd hh24:mi:ss')" +
		     "and roomname = '" + meetRoom + "'";
		    //document.all("sqldebug").innerHTML=sql;
    	 DWREngine.setAsync(false);
         DataService.getValues(sql,{ 
           callback : function(data) {
              var d = data.length;
              if (d > 0) 
              { 
                  alert("该会议室在" + data[0].startdate + " " + data[0].starttime + "-" + data[0].endtime + "已经被预定");
                  document.all("field_4028818230686b490130691901460043").value = "";
                  document.all("field_4028818230686b490130691901560045").value = "";
                  document.all("field_4028818230686b490130691901460043").focus();
        		  flag = true;
              } else {
                 flag = false;
                  }
           }
        });
         DWREngine.setAsync(true);
         return flag;
    }
    <%--获取开始的td--%>
    function getStartTd(sdate,meetroom) {
      var startTd = 0;
      var fstartDate = sdate.split(" ")[0];
   	  startMonth = fstartDate.split("-")[1];
   	  startDay = fstartDate.split("-")[2];
   	  var lstartDate = sdate.split(" ")[1];
   	  startHour = lstartDate.split(":")[0];
   	  startMinute = lstartDate.split(":")[1];
   	  hm = (startHour+startMinute).substring(0,1) == "0" ? (startHour+startMinute).substring(1,4) : (startHour+startMinute);
   	  if ( parseInt(hm) < 800 ||  parseInt(hm) > 2000) {
   		  return 0;
      }
   	  for (var i = 0 ; i < dateArr.length ; i++) {
            if ( parseInt(hm) >= parseInt(dateArr[i])) {
              startTd++;
            }
      }
      return startTd;
    }

    <%--得到结束的td--%>
    function getEndTd(edate,meetroom) {
      var endTd = 0;
      var fendDate = edate.split(" ")[0];
  	  endMonth = fendDate.split("-")[1];
  	  endDay = fendDate.split("-")[2];
  	  var lendDate = edate.split(" ")[1];
  	  endHour = lendDate.split(":")[0];
  	  endMinute = lendDate.split(":")[1];
  	  hm = (endHour+endMinute).substring(0,1) == "0" ? (endHour+endMinute).substring(1,4) : endHour+endMinute;
  	  if (parseInt(hm) < 800 || parseInt(hm) > 2000) {
  		  return 0;
      }
  	  for (var i = 0 ; i < dateArr.length ; i++) {
          if (parseInt(hm) > parseInt(dateArr[i])) {
            endTd++;
          }
       }
      return endTd;
    }

    <%--获取会议室所在table的行索引--%>
    function getRow(mroom) {
       var table = document.all("tab");
       for (var j = 1 ; j < table.rows.length ; j++) {
          if (mroom == table.rows[j].cells[0].innerText) {
             return j;
          }
       }
    }

    var startTd = 0;
    var endTd = 0;
    <%--画开始--%>
    function drawStartTd(sdate,meetroom,requestid) {
       var row = getRow(meetroom);
       var table = document.all("tab");
       startTd = getStartTd(sdate,meetroom);
       table.rows[row].cells[startTd].innerHtml = "<div style='display:none;'>" + requestid + "<div>";
       table.rows[row].cells[startTd].attachEvent("onmouseover", orientation);
       table.rows[row].cells[startTd].attachEvent("onmouseout", outevent);
       table.rows[row].cells[startTd].style.cssText = "background-color:red;";
    }

    <%--画开始--结束--%>
    function drawEndTd(edate,meetroom,requestid) {
       var row = getRow(meetroom);
       var table = document.all("tab");
       endTd = getEndTd(edate,meetroom);
       for (var s = startTd ; s < endTd + 1 ; s++) {
    	   table.rows[row].cells[s].innerHtml = "<div style='display:none;'>" + requestid + "<div>";
    	   table.rows[row].cells[s].attachEvent("onmouseover", orientation);
    	   table.rows[row].cells[s].attachEvent("onmouseout", outevent);
           table.rows[row].cells[s].style.cssText = "background-color:red;";
	      }
    }

    function outevent() {
       document.all("meetRoomInfoid").style.cssText = "display:none;";;
    }

	function orientation() {
       var td = event.srcElement;
       var x = 0;
       x = event.clientX;
       var y = 0;
       y = event.clientY;
       if (x > 570) {
          x = 570;
       } 
       //alert(event.clientX + "---" + event.offsetY);
       var requestid = td.innerHtml.substring(27,59).trim();
       var sql = "select mname,mpopu,(select objname from humres where id = m.msponsor) msponsor," + 
         "mbdate,medate from uf_admin_meeting m where requestid = '" + requestid + "'";
	   DWREngine.setAsync(false);
       DataService.getValues(sql,{ 
        callback : function(data) {
           var d = data.length;
           if (d > 0) { 
               document.all("meetRoomInfoid").style.cssText = 
                   "border: 1px solid blank;width:195;height:50;position:absolute;margin-left:" + x + 
                   ";margin-top:" + y + ";background-color:#f5f4ed;text-align:left;";
               var mriText = document.all("meetRoomInfoid");
                 mriText.innerHTML = "<p style=padding-left:10px;>会议名称：" + data[0].mname + "</p>";
                 if (data[0].mpopu != null && data[0].mpopu != "") {
                 	mriText.innerHTML += "<p style=padding-left:10px;>应到人数：" + data[0].mpopu + "</p>" ;
                 }
                  mriText.innerHTML += "<p style=padding-left:10px;>发起人：" + data[0].msponsor + "</p>" ;
                 if (data[0].mbdate != null && data[0].mbdate != "") {
                 	mriText.innerHTML += "<p style=padding-left:10px;>开始时间：" + data[0].mbdate.substring(0,16) + "</p>";
                 }
                  if (data[0].medate != null && data[0].medate != "") {
                 	 mriText.innerHTML += "<p style=padding-left:10px;>结束时间：" + data[0].medate.substring(0,16) + "</p>";
                  }
            }
        }
       });
       DWREngine.setAsync(true);
     }
     
     function roomoutevent() {
       document.all("meetRoomInfoid").style.cssText = "display:none;";;
    }

	function roomorientation(roomid) {
       var td = event.srcElement;
       var x = 0;
       x = event.clientX;
       var y = 15;
       y = event.clientY;
       if (x > 60) {
           x = 60;
        } 
       //alert(event.clientX + "---" + event.offsetY);
      // var requestid = td.innerHtml.substring(27,59).trim();
       //
       var sql = "select id,requestid,place,roomname,ename,capacity,instr,isprojector" + 
         " from uf_admin_meetingroom m where m.id = '" + roomid + "'";
	   DWREngine.setAsync(false);
       DataService.getValues(sql,{ 
        callback : function(data) {
           var d = data.length;
           if (d > 0) { 
              document.all("meetRoomInfoid").style.cssText = 
                  "border: 1px solid blank;width:195;height:50;position:absolute;margin-left:" + x + 
                  ";margin-top:" + y + ";background-color:#f5f4ed;text-align: left;";
              var mriText = document.all("meetRoomInfoid") ;
                mriText.innerHTML = "<p style=padding-left:10px;>"+ data[0].roomname+"（" + data[0].ename + "）</P>";
                if (data[0].place != null && data[0].place != "") {
                	mriText.innerHTML +=  "<p style=padding-left:10px;>" + data[0].place +"，</p>";
                }
                if (data[0].capacity != null && data[0].capacity != "") {
                	mriText.innerHTML += "<p style=padding-left:10px;>最大人数：" + data[0].capacity+"人，</p>" ;
                }
                if (data[0].isprojector != null && data[0].isprojector != "") {
                	if(data[0].isprojector=='4028818231a3061c0131a30e1e1f0020'){
                		mriText.innerHTML += "<p style=padding-left:10px;>有投影仪</p>" ;
                	}else{
                		mriText.innerHTML += "<p style=padding-left:10px;>无投影仪</p>";
                	}
                }
                mriText.innerHTML += "<br>";
                if (data[0].instr != null && data[0].instr != "") {
                	mriText.innerHTML += "<p style=padding-left:10px;>说明：" + data[0].instr +"</p>";
                }
           }
        }
       });
       DWREngine.setAsync(true);
     }
    <%--取消model框--%>
    function onReturn() {
       if (Ext.isIE) {
    	 window.parent.close();
       } else {
         parent.window.close();
       }
    }
    <%--提交--%>
    function onSubmit() {
        var startDate = document.all("field_4028818230686b490130691901460043").value;
        var endDate = document.all("field_4028818230686b490130691901560045").value;
        var starttime = $('#startbs').find('option:selected').text();
        var endtime = $('#endbs').find('option:selected').text();
        
        startDate = startDate +" "+starttime;
        endDate = endDate +" "+endtime;
        if(startDate.length<16){
        	alert('日期起不能够为空！');
        	return;
        }
        
        if(endDate.length<16){
        	alert('日期止不能够为空！');
        	return;
        }

        var meetroomid = document.all("field_4028818230686b490130691901370040").value;
        if(meetroomid==""){
        	alert("请选择会议室");
        	return;
        }
        var meetroom = document.all("field_4028818230686b490130691901370040span").innerText;
        var weeks = document.all("field_4028818230686b49013069190175004a").value;
        if (meetroom == "") {
          return;
        } else if (weeks == "") {
          return;
        }
        if (startDate == null || startDate == "") {
        	document.all("field_4028818230686b490130691901460043").focus();
        	return;
        } else if (endDate == null || endDate == "") {
        	document.all("field_4028818230686b490130691901560045").focus();
        	return;
        } else if (getStartTd(startDate,meetroom) == 0) {
      		document.all('field_4028818230686b490130691901460043').value = "";
      	   	document.all('field_4028818230686b490130691901460043').focus();
      	   	return;
        } else if (getEndTd(endDate,meetroom) == 0) {
        	document.all('field_4028818230686b490130691901560045').value = "";
    		document.all('field_4028818230686b490130691901560045').focus();
    		return;
        } else if (new Date(startDate.replace(/\-/g,'\/')) > new Date(endDate.replace(/\-/g,'\/'))) {
        		alert("开始日期大于结束日期");
            	document.all('field_4028818230686b490130691901560045').value = "";
        		document.all('field_4028818230686b490130691901560045').focus();
        		return;
        } else {
               var sDate1 = startDate.split(" ")[0];
               var sDate2 = endDate.split(" ")[0];
               var dayCount = DateDiff(sDate1,sDate2);
               if (weeks == "4028818231a311210131a3539e7a00ec") {
                   if (dayCount == 0) {
                      if (filterWeekend(startDate.split(" ")[0])) {
                         if (ifreserve(startDate,endDate,meetroom)) {
                       	   return;
                   	     }
                      }
                   } else {
                     for (var i = 0 ; i <= dayCount ; i++) {
                        if (i == 0) {
                        	var newStartDate = getNextDate(sDate1,i) + " " + startDate.split(" ")[1];
                            var newEndDate = getNextDate(sDate1,i) + " " + initEndDate;
                            if (filterWeekend(newStartDate.split(" ")[0])) {
                          	  if (ifreserve(newStartDate,newEndDate,meetroom)) {
                                   return;
                           	  }
                             }
                        }
                        if (i != dayCount && i != 0) {
                        	var newStartDate = getNextDate(sDate1,i) + " " + initStartDate;
                            var newEndDate = getNextDate(sDate1,i) + " " + initEndDate;
                            if (filterWeekend(newStartDate.split(" ")[0])) {
                          	  if (ifreserve(newStartDate,newEndDate,meetroom)) {
                              	  //alert(2);
                                   return;
                           	  }
                             }
                        } else if (i == dayCount) {
                        	var newSDate = getNextDate(sDate1,i) + " " + initStartDate;
                            var newEDate = getNextDate(sDate1,i) + " " + endDate.split(" ")[1];
                            if (filterWeekend(newSDate.split(" ")[0])) {
                         	  if (ifreserve(newSDate,newEDate,meetroom)) {
                                  return;
                          	  }
                            }
                        }
                     }
                   }
               } else if (weeks == "4028818231a311210131a3539e7a00ed") {
            	   if (getEndTd(endDate,meetroom) < getStartTd(startDate,meetroom)){
            		   document.all('field_4028818230686b490130691901560045').value = "";
            		   document.all('field_4028818230686b490130691901560045').focus();
                       return;
                   }
            	   for (var j = 0 ; j <= dayCount ; j++) {
            		   var newSDate2 = getNextDate(sDate1,j) + " " + startDate.split(" ")[1];
            		   var newEDate2 = getNextDate(sDate1,j) + " " + endDate.split(" ")[1];
            		   if (filterWeekend(newSDate2.split(" ")[0])) {
                     	  if (ifreserve(newSDate2,newEDate2,meetroom)) {
                              return;
                      	  }
                        }
                   }
               } 
               else {
                   if (weeks == "4028818231a311210131a3539e7a00ee") cyclenum = 1;
                   if (weeks == "4028818231a311210131a3539e7a00ef") cyclenum = 2;
                   if (weeks == "4028818231a311210131a3539e7a00f0") cyclenum = 3;
                   if (weeks == "4028818231a311210131a3539e7a00f1") cyclenum = 4;
                   if (weeks == "4028818231a311210131a3539e7a00f2") cyclenum = 5;
            	   if (getEndTd(endDate,meetroom) < getStartTd(startDate,meetroom)){
            		   document.all('field_4028818230686b490130691901560045').value = "";
            		   document.all('field_4028818230686b490130691901560045').focus();
                       return;
                   }
            	   for (var k = 0 ; k <= dayCount ; k++) {
            		   var newSDate3 = getNextDate(sDate1,k) + " " + startDate.split(" ")[1];
            		   var newEDate3 = getNextDate(sDate1,k) + " " + endDate.split(" ")[1];
            		   if (filterOfWeeek(newSDate3.split(" ")[0],cyclenum)) {
                     	  if (ifreserve(newSDate3,newEDate3,meetroom)) {
                              return;
                      	  }
                       }
                   }
               }
        <%--如果这段时间都没被预定，则成功预定提交--%>
        if (Ext.isIE) {
        	window.opener.document.all("field_4028818230686b490130691901460043").value = startDate;//开始时间
            window.opener.document.all("field_4028818230686b490130691901560045").value = endDate;//结束时间
            //window.opener.document.getElementsByName("field_4028818230686b490130691901460043")[0].value=1;
            //alert(window.opener.document.getElementsByName("field_4028818230686b490130691901460043")[0]);
            var selObj = window.opener.document.all("field_4028818230686b49013069190175004a");
            for (var i = 0 ; i < selObj.options.length ; i++) {
               if (selObj.options[i].value == weeks) {
                  selObj.options[i].selected = true;
                  break;
               }
            }
            window.opener.document.all("field_4028818230686b490130691901370040").value = meetroomid;
            window.opener.document.all("field_4028818230686b490130691901370040span").innerText = meetroom;//会议室
          } else {
            parent.window.close();
            parent.window.document.all("field_4028818230686b490130691901460043").value = startDate;//开始时间
            parent.window.document.all("field_4028818230686b490130691901560045").value = endDate;//结束时间
            var selObj = window.opener.document.all("field_4028818230686b49013069190175004a");
            for (var i = 0 ; i < selObj.options.length ; i++) {
               if (selObj.options[i].value == weeks) {
                  selObj.options[i].selected = true;
                  break;
               }
            }
            parent.window.document.all("field_4028818230686b490130691901370040").value = meetroomid;
            parent.window.document.all("field_4028818230686b490130691901370040span").innerText = meetroom;//会议室
          }
        onReturn();
        }
    }
    <%--得到星期--%>
    function filterOfWeeek(everydate,week) {    	
		var weekday = new Date(everydate.split("-")[0],parseInt(everydate.split("-")[1]) - 1,everydate.split("-")[2]).getDay();
        if (week == weekday) {
           return true;
        }
        return false;
    }
    
    <%--通过日期来过滤周末--%>
    function filterWeekend(everydate) {
    /*alert("everydate111==="+everydate);
    var mon = everydate.split("-")[1].toString().substring(0,1) == "0" ? parseInt(everydate.split("-")[1].toString().substring(0,1)) : .toString().substring(0,1);
    //alert(everydate.split("-")[0]+"---"+(parseInt(everydate.split("-")[1])+1)+"---"+everydate.split("-")[2]);
    	var weekday = new Date(everydate.split("-")[0],mon ,everydate.split("-")[2]).getDay();
    	alert("weekday====="+weekday);
    	if (weekday == 6 || weekday == 0) {
           return false;
        }*/
        return true;
    }
    <%--根据已有日期计算N天的日期--%>
    function getNextDate(sendDate,day){ 
    	<%--s   =   '2006-07-04'; 
    	d   =   new   Date(Date.parse(s.replace('\-',   '\/'))); 
    	t   =   [d.getYear(),   d.getMonth()+1,   d.getDay() + 30]; 
    	alert(t.join('-')); --%>
    	var d1 = sendDate.replace(/\-/g,'\/');
    	var date = new Date(d1);
    	date.setDate(date.getDate()+day);
    	date.setMonth(date.getMonth()+1);
    	var outputdate = date.getYear() + "-" + date.getMonth() + "-" + date.getDate();
    	return outputdate;
    } 

    //计算天数差的函数，通用 
    function   DateDiff(sDate1,sDate2){     //sDate1和sDate2是2004-10-18格式 
        var aDate,oDate1,oDate2,iDays ;
        aDate = sDate1.split( "-") ;
        oDate1 =   new Date(aDate[1] + '-' + aDate[2] + '-' + parseInt(aDate[0])); //转换为10-18-2004格式 
        aDate = sDate2.split("-") ;
        oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
        iDays = parseInt(Math.abs(oDate1 - oDate2)/1000/60/60/24);   //把相差的毫秒数转换为天数 
        return iDays ;
    }   

    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";
    var fck=param.indexOf("function:");
        if(fck>-1){}else{
            var param = parserRefParam(inputname,param);
        }
	var idsin = document.getElementsByName(inputname)[0].value;
        var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
        }
	var id;
    if(Ext.isIE){
    try{
    id=openDialog(url,idsin);
    }catch(e){return}
    if (id!=null) {
    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
  if(fck>-1){
          funcname=param.substring(9);
      scripts="valid="+funcname+"('"+id[0]+"');";
        eval(scripts) ;
        if(!valid){  //valid默认的返回true;
         document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
          }
          }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
            }
         }
    }else{
    url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                     if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) {  //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0')
                                document.all(inputspan).innerHTML = '';
                            else
                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

                }
            }
        }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
                plain: true,
                modal:true,
                items: {
                    id:'dialog',
                    region:'center',
                    iconCls:'portalIcon',
                    xtype     :'iframepanel',
                    frameConfig: {
                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                        eventsFollowFrameLinks : false
                    },
                    closable:false,
                    autoScroll:true
                }
            });
        }
        win.close=function(){
                    this.hide();
                    win.getComponent('dialog').setSrc('about:blank');
                    callback();
                }
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
    }
    function addMonth() {
        var disDate = document.all("yearmonth").innerText.toString().trim();
    	window.location.href = "/app/htfmeeting/meetingRoomSchedule.jsp?disDate=" + disDate + "&len=1";
    }

    function cutMonth() {
    	var disDate = document.all("yearmonth").innerText.toString().trim();
     	window.location.href = "/app/htfmeeting/meetingRoomSchedule.jsp?disDate=" + disDate + "&len=-1";
    }

    function meetRoomInfo(day) {
    	var disDate = document.all("yearmonth").innerText.toString().trim();
    	day = day.toString().trim().length == 1 ? "0"+day.toString().trim() : day.toString().trim();
    	var date = disDate + "-" + day;
    	//window.showModalDialog('/workflow/request/meetingRoomSchedule.jsp?time='+ new Date() + "&date=" + date + "&disDate=" + disDate + "&len=0",window,'dialogHeight: 468px; dialogWidth: 824px; center: Yes; help: No; resizable: yes; status: no;Maximize=yes;Minimize=yes');  
    	window.location.href = "/app/htfmeeting/meetingRoomSchedule.jsp?date=" + date + "&disDate=" + disDate + "&len=0";
        }
    function startfun(nowobj){
    	var startval = $(nowobj).val();
    	var endval = $('#endbs').val();
    	var optionindex = parseInt(startval)+parseInt(2);
    	$("#endbs option").each(function(){
    		if($(this).val()==optionindex){
    			$(this).attr("selected","true");
    			return;
    		}
    	});
    	if(startval==20){
    		$("#endbs option:last").attr("selected","true");
    	}
    }
    function endfun(nowobj){
    	var endval = $(nowobj).find('option:selected').text();
    	var startval = $('#startbs').find('option:selected').text();
    	if(endval.replace(":","")<=startval.replace(":","")){
    		alert("选择的结束时间不能够小于或等于开始时间!");
    	    $("#endbs option:last").attr("selected","true");
    	}
    }
    function enddatefun(nowobj){
    	var weekval = $('#field_4028818230686b49013069190175004a').find('option:selected').val();
    	var startdate = $('#field_4028818230686b490130691901460043').val();
    	    startdate = startdate.replace("-",""); startdate = startdate.replace("-","");
    	var downdate = $(nowobj).val();
    	    downdate = downdate.replace("-","");downdate = downdate.replace("-","");
    	if(weekval=='4028818231a311210131a3539e7a00ec'){
    		if(downdate!=startdate){
    		   alert('单次中,日期起和日期止必须为同一时间!');
    		   $(nowobj).val($('#field_4028818230686b490130691901460043').val());
    		}
    	}
    	fieldcheck(nowobj,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','结束日期');
    }
    function stadatefun(nowobj){
    	var weekval = $('#field_4028818230686b49013069190175004a').find('option:selected').val();
    	var enddate = $('#field_4028818230686b490130691901560045').val();
    	    enddate = enddate.replace("-",""); enddate = enddate.replace("-","");
    	var downdate = $(nowobj).val();
    	    downdate = downdate.replace("-","");downdate = downdate.replace("-","");
    	    if(weekval=='4028818231a311210131a3539e7a00ec'){
	    		if(downdate!=enddate){
	    		   alert('单次中,日期起和日期止必须为同一时间!');
	    		   $(nowobj).val($('#field_4028818230686b490130691901560045').val());
	    		}
    		}else{
    			if(downdate>enddate){
    				alert('日期起必须小于或等于日期止!');
    				$(nowobj).val($('#field_4028818230686b490130691901560045').val());
    			}
    		}
    	fieldcheck(nowobj,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','结束日期');
    }
   function changeenddate(obj){
	   $('#field_4028818230686b490130691901560045').val($(obj).val());
   }
</script>

</head>
<body>
	<div id="pagemenubar"></div>
    <div class="meetingcontent">
	    <div id="meetRoomInfoid"></div>
		<div id="dateid">
		    	<div class="layoutdiv">
		    		<h1 style="font-size: 20px;">会议室预定</h1>
		    	</div>
		</div>
		<div style="width:90%;text-align: center;margin-top: 0px;">
	      <div style="background-color:#f5f5ed;">
			<table border="0px;" width="100%" cellpadding="0" cellspacing="0">
				    <colgroup>
				    	<col width="11%"/>
				    	<col width="80%"/>
				    </colgroup>
					<tbody>
						<tr>
							<td>
							<a href="javascript:void(0);" onclick="cutMonth();">&lt;&lt;</a>
							<span id="yearmonth" style="font-size:14;"><strong><%=disDate %></strong></span>
							<a href="javascript:void(0);" onclick="addMonth();">&gt;&gt;</a>
							</td>
							<td>
								<table border="0px;">
									<tr>
										<%
									      String nextMonth = DateHelper.monthMove(disDate,1).toString();
									      String lastDay = DateHelper.dayMove(nextMonth+"-01",-1); 
									      int lastDayNum = Integer.parseInt(lastDay.split("-")[2]);
									      for (int i = 1 ; i <= lastDayNum ; i++) {
									    	  int top = 55;
										      int left = 132 + 18*i;
									    	  String k = mdate.split("-")[2];
									    	  if (i == Integer.parseInt(k)) {
									   %>
			        					<td width="1%" align="center"><a href="javascript:void(0);" onclick="meetRoomInfo('<%=i%>');"  style="color:white;font-weight: bold;background:red;"><%=i %></a></td>
									   <%
									    	  } else {
									   %>
						        		<td width="1%" align="center"><a id="dayid" href="javascript:void(0);" onclick="meetRoomInfo('<%=i%>');"><%=i %></a></td>
									   <% 	  
									    	  }
									      }
									   %>
									</tr>
									<tr>
										  <%
									  	    String [] workarray = {"日","一","二","三","四","五","六"};
									  		for(int j = 1 ; j <= lastDayNum; j++){
									  			String getdate = lastDay.substring(0,8)+j;
										  		DateFormat dateFormat = DateFormat.getDateInstance();
										  		Date getDate2 = dateFormat.parse(getdate);
										  		int getreturnval = DateHelper.getDayOfWeek(getDate2);
										  		int top = 55;
											    int left = 132 + 18*j;
										    	String k = mdate.split("-")[2];
										    	if (j == Integer.parseInt(k)) {
									  	  %>
								  	    <td align="center"><a href="javascript:void(0);" onclick="meetRoomInfo('<%=j%>');" style="color:white;font-weight: bold;background:red;"><%=workarray[getreturnval-1]%></a></td>
								  	  <%}else{%>
								  		<td align="center"><a href="javascript:void(0);" onclick="meetRoomInfo('<%=j%>');"><%=workarray[getreturnval-1]%></a></td>
								  	  <% } %>
								  	<%} %>	
									</tr>
								</table>
							</td>
						</tr>
					</tbody>
			</table>
	  </div>
	   <div class="timecss">
		<table id = "tab" border="1px solid blank;" class="tab">
			<thead>
				<tr style="height:25;">
					<td nowrap="nowrap">时间(h)</td>
					<td colspan="2">08:00</td>
					<td colspan="2">09:00</td>
					<td colspan="2">10:00</td>
					<td colspan="2">11:00</td>
					<td colspan="2">12:00</td>
					<td colspan="2">13:00</td>
					<td colspan="2">14:00</td>
					<td colspan="2">15:00</td>
					<td colspan="2">16:00</td>
					<td colspan="2">17:00</td>
					<td colspan="2">18:00</td>
					<td colspan="3">19:00</td>
				</tr>
			</thead>
			<tbody id="tbody">
       <%
          Iterator mrIter2 = meetRoomList.iterator();
    	  while (mrIter2.hasNext()) {
			Map mrMap = (Map) mrIter2.next();
			String mroomName = mrMap.get("roomname").toString();
			String id = StringHelper.null2String(mrMap.get("id"));
		%>
		       <tr style="height:25;">
				  <td onmouseout="roomoutevent();" onmouseover="roomorientation('<%=id %>');"><%=mroomName%></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
				  <td></td><td></td>
			   </tr>
        <%}%>
			</tbody>
		</table>
<%--		<p><hr class="hrcss"/></p>--%>
	  </div>
	   
	    <div style="padding:5,10,10,15;width:100%;background-color:#f5f5ed;">
		<table border="0px;" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="11%">
				<col width="6%">
				<col width="6%">
				<col width="9%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
				<col width="9%">
				<col width="9%">
			    <col width="9%">
				<col width="10%">
			</colgroup>
			<tbody>
				<tr>
					<td style="text-align: right;">选择会议室：</td>
					<td>
						<button type=button  class=Browser name="button_4028818230686b490130691901370040" onclick="javascript:getrefobj('field_4028818230686b490130691901370040','field_4028818230686b490130691901370040span','402881823197b2ce0131989fad4f1066','','','0');"></button>
						<input type="hidden" name="field_4028818230686b490130691901370040" value=""  >
						<span id="field_4028818230686b490130691901370040span" name="field_4028818230686b490130691901370040span"></span>
					</td>
					<td align="center">周期：</td>
					<td>
						<input type="hidden" name="field_4028818230686b49013069190175004a_fieldcheck" value="" >
						<select class="InputStyle2" name="field_4028818230686b49013069190175004a" id="field_4028818230686b49013069190175004a" onChange="fillotherselect(this,'4028818230686b49013069190175004a',-1);checkInput('field_4028818230686b49013069190175004a','field_4028818230686b49013069190175004aspan')" style="width: 70px;font-size: 14px;">
							<option value=""  ></option>
							<option value="4028818231a311210131a3539e7a00ec"  selected  >单次</option>
							<option value="4028818231a311210131a3539e7a00ed"  >每天</option>
							<option value="4028818231a311210131a3539e7a00ee"  >每周一</option>
							<option value="4028818231a311210131a3539e7a00ef"  >每周二</option>
							<option value="4028818231a311210131a3539e7a00f0"  >每周三</option>
							<option value="4028818231a311210131a3539e7a00f1"  >每周四</option>
							<option value="4028818231a311210131a3539e7a00f2"  >每周五</option>
						</select>
						<span id="field_4028818230686b49013069190175004aspan" name="field_4028818230686b49013069190175004aspan" ></span>
					</td>
					<td style="text-align:right;">日期起：</td>
					<td align="center"><input type="text" id="field_4028818230686b490130691901460043" name="field_4028818230686b490130691901460043" value="<%=DateHelper.getCurrentDate()%>" onchange="changeenddate(this)" style='width: 100%' class=inputstyle size=10   onclick="WdatePicker()"/></td>
					<td align="center">日期止：</td>
					<td align="center"><input type="text" id="field_4028818230686b490130691901560045" name="field_4028818230686b490130691901560045" value="<%=DateHelper.getCurrentDate()%>"  style='width: 100%' class=inputstyle size=10 onclick="WdatePicker()"></td>
					<td style="text-align:right;">时间起：</td>
					<td>
					    <% 
					        String [] startarray = {"08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30",
					    		"13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30",
					    		"18:00","18:30","19:00"};
						%>
						<select onchange="startfun(this)" id="startbs">
						   <% for(int i = 0; i<startarray.length-1; i++){ %>
							<option value="<%=i %>"><%=startarray[i] %></option>
						   <%} %>
						</select>
					</td>
					<td style="text-align:center;">时间止：</td>
					<td>
					  <select id="endbs" onchange="endfun(this)">
					    <% for(int i = 1; i<startarray.length; i++){ %>
						<option value="<%=i %>"><%=startarray[i] %></option>
						<%} %>
					  </select>
					</td>
				</tr>
			</tbody>
		</table>
	  </div>
<%--	   <div align="center" style="margin-top: -10px;background-color:#f5f5ed;">--%>
<%--	     <div class="operationbtn">--%>
<%-- 	 		<input name="" type="button" value="保 存" onclick="onSubmit()" class="btnred02" id="editfun"/>--%>
<%-- 	 		<input name="" type="button" value="关 闭"  class="btnred02" onclick="onReturn()" id="closewin">--%>
<%--      	</div>--%>
<%--	  --%>
<%--	</div>--%>
	</div>
	<span id="sqldebug"></span>
</body>
</html>
<%
      Iterator itor = mrList.iterator();
      //StringBuffer strb = new StringBuffer("");
      out.write("<script type='text/javascript'>");
      while (itor.hasNext()) {
    	  Map itorMap = (Map)itor.next();
    	  String requestid = StringHelper.null2String(itorMap.get("requestid"));
    	  String mroomname = StringHelper.null2String(itorMap.get("roomname"));
    	  String starttime = StringHelper.null2String(itorMap.get("starttime"));
    	  String endtime = StringHelper.null2String(itorMap.get("endtime"));
    	  String startdate = StringHelper.null2String(itorMap.get("startdate"));
    	  String newsDate = startdate + " " + starttime;
    	  String neweDate = startdate + " " + endtime;
    	  out.write("drawStartTd('" + newsDate + "','" + mroomname + "','" + requestid + "');");
    	  out.write("drawEndTd('" + neweDate + "','" + mroomname + "','" + requestid + "');");
    	  //strb.append(mroomname + "," + starttime + "," + newsDate + "," + neweDate + "-");
      }
      out.write("</script>");
     // strb = strb.deleteCharAt(strb.length() - 1);
   %>
