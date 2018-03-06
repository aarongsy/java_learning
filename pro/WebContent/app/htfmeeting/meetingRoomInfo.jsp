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
	String getMRInfoSql = "select m.mname,m.requestid,(select objname from humres where id = m.msponsor) msponsor," + 
	   "(select objname from selectitem where id = m.mtype) mtype," + 
       "(select roomname from uf_admin_meetingroom where requestid = m.mloc) mloc,a.startdate,a.starttime,a.endtime " + 
       "from uf_meetingroomuser a " +
       "join uf_admin_meeting m on m.requestid = a.requestid where '" + mdate + "' = a.startdate";
	List mrInfoList = baseJdbc.executeSqlForList(getMRInfoSql);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>会议室预定</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" href="/culture/css/common.css" type="text/css"></link>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" ></script>
<script type="text/javascript" language="javascript" src="/js/main.js" ></script>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script  type='text/javascript' src='/js/workflow.js'></script>
<script  type='text/javascript' src='/js/main.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/pPageSize.js"></script>
<style type="text/css">
body,p,table,td,th,input,div,select,button,span,a,textarea{font-size: 14px;}
#tab tbody tr td{cursor:hand;background-color:#ffffff;}
.tableWrap tr.bg td{ background:#f6f4ec;}
#dateid{padding: 10, 10, 10, 20;}
#dateid #contentMain{ padding:1px 0 15px 7px;overflow-y:hidden;width: 100%;}
#dateid .timecss{padding: 10, 0, 10, 10;}
#dateid .timecss #tab{width:95%;text-align: center;border:1px solid blank;}
#dateid .metting{padding: 10, 0, 10, 10;}
.metting .mettingtab{width:95%;text-align: center;background: white;}
.mettingtab tr.bg th, tr.bg td{background:#f6f4ec;}
table.mettingtab tbody td,a{font-size: 12px;}
</style>
   <script type="text/javascript"><!--
    var dateArr = new Array('800','830','900','930','1000','1030','1100','1130','1200','1230','1300','1330','1400','1430','1500','1530','1600','1630','1700','1730','1800','1830','1900','1930','2000');
    var initStartDate = "08:00:00";
    var initEndDate = "20:00:00";

    <%--判断开始时间或结束时间是否在数据库中存在--%>
    function ifreserve(startDate,endDate,meetRoom) {
        var flag;
		 var sql = "select startdate,starttime,endtime from uf_meetingroomuser m join uf_admin_meetingroom a on  m.roomid = a.requestid where " +
		     "to_date('" + startDate + "','yyyy-MM-dd hh24:mi:ss') <= to_date(startdate||endTime,'yyyy-MM-dd hh24:mi:ss') " + 
		     "and to_date('" + endDate + "','yyyy-MM-dd hh24:mi:ss') >= to_date(startdate||startTime,'yyyy-MM-dd hh24:mi:ss')" +
		     "and roomname = '" + meetRoom + "'";
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
         " mbdate,medate from uf_admin_meeting m where requestid = '" + requestid + "'";
	   DWREngine.setAsync(false);
       DataService.getValues(sql,{ 
        callback : function(data) {
           var d = data.length;
           if (d > 0) { 
              document.all("meetRoomInfoid").style.cssText = 
                  "border: 1px solid blank;width:195;height:50;position:absolute;margin-left:" + x + 
                  ";margin-top:" + y + ";background-color:#f5f4ed;";
              var mriText = document.all("meetRoomInfoid") ;
                mriText.innerHTML = "<p style=padding-left:10px;>会议名称：" + data[0].mname + "</p>";
                if (data[0].mpopu != null && data[0].mpopu != "") {
                	mriText.innerHTML += "<p style=padding-left:10px;>应到人数：" + data[0].mpopu + "</p>" ;
                }
                 mriText.innerHTML += "<p style=padding-left:10px;>发起人：" + data[0].msponsor + "</p>" ;
                if (data[0].mbdate != null && data[0].mbdate != "") {
                	mriText.innerHTML += "<p style=padding-left:10px;>开始时间：" + data[0].mbdate + "</p>";
                }
                 if (data[0].medate != null && data[0].medate != "") {
                	 mriText.innerHTML += "<p style=padding-left:10px;>结束时间：" + data[0].medate + "</p>";
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
       var y = 0;
       y = event.clientY;
       if (x > 570) {
           x = 570;
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
                  ";margin-top:" + y + ";background-color:#f5f4ed;";
              var mriText = document.all("meetRoomInfoid") ;
                mriText.innerHTML = "<p style=padding-left:10px;>"+data[0].roomname+"（" + data[0].ename + "）</p>";
                if (data[0].place != null && data[0].place != "") {
                	mriText.innerHTML +="<p style=padding-left:10px;>"+data[0].place +",</p>";
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
    	window.location.href = "/app/htfmeeting/meetingRoomInfo.jsp?disDate=" + disDate + "&len=1";
    }

    function cutMonth() {
    	var disDate = document.all("yearmonth").innerText.toString().trim();
     	window.location.href = "/app/htfmeeting/meetingRoomInfo.jsp?disDate=" + disDate + "&len=-1";
    }

    function meetRoomInfo(day) {
    	var disDate = document.all("yearmonth").innerText.toString().trim();
    	day = day.toString().trim().length == 1 ? "0"+day.toString().trim() : day.toString().trim();
    	var date = disDate + "-" + day;
    	window.location.href = "/app/htfmeeting/meetingRoomInfo.jsp?date=" + date + "&disDate=" + disDate + "&len=0";
    }

</script>

</head>
<body>
    <div id="meetRoomInfoid"></div>
	<div id="dateid">
	 <div id="contentMain" class="contentMain">
	   <table border="0px" width="80%" cellpadding="0" cellspacing="0">
	   <colgroup>
	   		<col width="12%"/>
			<col width="80%"/>
	   </colgroup>
	   <tbody>
	   		<tr>
	   			<td>
	   				 <a href="javascript:void(0);" onclick="cutMonth();" style="color:#C83E31;text-decoration: none">&lt;&lt;</a>
	   				 <span id="yearmonth" style="font-size:14px;"><%=disDate %></span>
	   				 <a href="javascript:void(0);" onclick="addMonth();" style="color:#C83E31;text-decoration: none">&gt;&gt;</a>
	   			</td>
	   			<td>
	   				<table border="0px" cellpadding="0" cellspacing="0">
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
					        <td width="1%" align="center">
					        <a id="dayid" class="dayid" href="javascript:void(0);" onclick="meetRoomInfo('<%=i%>');" style="color:white;font-weight: bold;background:red;"><%=i %></a>
					        </td>
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
								for(int j = 1 ; j <= lastDayNum ; j++){
									String getdate = lastDay.substring(0,8)+j;
									DateFormat dateFormat = DateFormat.getDateInstance();
									Date getDate2 = dateFormat.parse(getdate);
									int getreturnint = DateHelper.getDayOfWeek(getDate2);
									String k = mdate.split("-")[2];
									if(j == Integer.parseInt(k)){
								%>
									<td width="1%" align="center"> <a id="dayid" href="javascript:void(0);" onclick="meetRoomInfo('<%=j%>');" style="color:white;font-weight: bold;background:red;"><%=workarray[getreturnint-1] %></a></td>
								<%}else{%>
									<td width="1%" align="center"><a id="dayid" href="javascript:void(0);" onclick="meetRoomInfo('<%=j%>');"><%=workarray[getreturnint-1] %></a></td>
								<%} %>
							  <%} %>
	   					</tr>
	   				</table>
	   			</td>
	   		</tr>
	   </tbody>
	</table>
	</div>
	<div class="timecss">
		<table id="tab" border="1px solid blank;">
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
			String mroomName = StringHelper.null2String(mrMap.get("roomname"));
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
	</div>
	<div class="metting">
	  <table class="mettingtab">
	    <thead>
	      <tr height="25" class="bg">
	        <th align="left">会议名称</th>
	        <th style="text-align: center;">发起人</th>
	        <th>会议类型</th>
	        <th>会议地点</th>
	        <th style="text-align: center;">开始日期</th>
	        <th style="text-align: center;">结束日期</th>
	      </tr>
	    </thead>
	    <tbody>
	      <%
	         Iterator iter3 = mrInfoList.iterator();
	         int count = 0;
	           while (iter3.hasNext()) {
	        	 Map mrinfo = (Map) iter3.next();
	        	 String requestid = StringHelper.null2String(mrinfo.get("requestid"));
	        	 String mname = StringHelper.null2String(mrinfo.get("mname"));
	        	 String morganizer = StringHelper.null2String(mrinfo.get("msponsor"));
	        	 String mtype = StringHelper.null2String(mrinfo.get("mtype"));
	        	 String mloc = StringHelper.null2String(mrinfo.get("mloc"));
	        	 String startDate = StringHelper.null2String(mrinfo.get("startdate"));
	        	 String starttime = StringHelper.null2String(mrinfo.get("startTime"));
	        	 String endtime = StringHelper.null2String(mrinfo.get("endTime"));
	        	 if(!StringHelper.isEmpty(starttime)){
	        		 starttime = starttime.substring(0,5);
	        	 }
	        	 if(!StringHelper.isEmpty(endtime)){
	        		 endtime = endtime.substring(0,5);
	        	 }
	        	 String mbdate = startDate + " " + starttime;
	        	 String medate = startDate + " " + endtime;
	        	 count++;
	      %>
	             <%if(count%2==0){%><tr height="25" class="bg"><%}else{%><tr height="25"><%} %>
	               <td align="left"><a href="javascript:onUrl('/workflow/request/workflow.jsp?requestid=<%=requestid %>')"><%=mname%></a></td>
	               <td><a href="javascript:void(0);"><%=morganizer%></a></td>
	               <td><%=mtype%></td>
	               <td><%=mloc%></td>
	               <td><%=mbdate%></td>
	               <td><%=medate%></td>
	             </tr>
	      <%
	         }
	      %>
	    </tbody>
	  </table>
	</div>
	</div>
</body>
</html>
<%
      Iterator itor = mrList.iterator();
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
      }
      out.write("</script>");
   %>
