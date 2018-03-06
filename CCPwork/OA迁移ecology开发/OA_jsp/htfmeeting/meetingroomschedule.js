var dateArr = new Array('800','830','900','930','1000','1030','1100','1130','1200','1230','1300','1330','1400','1430','1500','1530','1600','1630','1700','1730','1800','1830','1900','1930','2000');
var initStartDate = "08:00:00";
var initEndDate = "20:00:00";

function ifreserve(startDate,endDate,meetRoom) {
	var tempSDate3 = startDate.substring(5,6);
    var tempstartDate = startDate;
    //alert(startDate+" "+tempSDate3);
    //alert(tempstartDate);
    if(tempSDate3==0){
   	   var syears = startDate.substring(0,5);
   	   //alert(syears);
   	   var sday = startDate.substring(6,startDate.length);
   	   //alert(sday); 
   	        tempSDate3 = 12;
   			tempstartDate = syears+tempSDate3+sday;
    }
    var flag;
	 var sql = "select startdate,starttime,endtime from uf_meetingroomuser m, uf_admin_meetingroom a where  m.roomid = a.requestid and " +
	     "to_date('" +jQuery.trim(startDate)+ "','yyyy-MM-dd hh24:mi:ss') < to_date(startdate||' '||endTime,'yyyy-MM-dd hh24:mi:ss') " + 
	     "and to_date('" +jQuery.trim(endDate)+ "','yyyy-MM-dd hh24:mi:ss') > to_date(startdate||' '||startTime,'yyyy-MM-dd hh24:mi:ss')" +
	     "and roomname = '" + meetRoom + "'";
	 jQuery("#sql").html(sql);
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
function useSubmitBefore() {
    var startDate = document.all("field_4028818230686b490130691901460043").value;
    var endDate = document.all("field_4028818230686b490130691901560045").value;
    
    var starttime = $('#startbs').find('option:selected').text();
        var endtime = $('#endbs').find('option:selected').text();
        
        startDate = startDate +" "+starttime;
        endDate = endDate +" "+endtime;
    
    var meetroomid = document.all("field_4028818230686b490130691901370040").value;
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
                    	var newStartDate1 = getNextDate(sDate1,i) + " " + initStartDate;
                        var newEndDate1 = getNextDate(sDate1,i) + " " + initEndDate;
                        if (filterWeekend(newStartDate1.split(" ")[0])) {
                      	  if (ifreserve(newStartDate1,newEndDate,meetroom)) {
                               return;
                       	  }
                         }
                    } else {
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
    }
}

function filterOfWeeek(everydate,week) {
	var weekday = new Date(everydate.split("-")[0],parseInt(everydate.split("-")[1]) - 1,everydate.split("-")[2]).getDay();
    if (week == weekday) {
       return true;
    }
    return false;
}

function filterWeekend(everydate) {
	//var weekday = new Date(everydate.split("-")[0],parseInt(everydate.split("-")[1]) - 1,everydate.split("-")[2]).getDay();
	//if (weekday == "6" || weekday == "0") {
    //   return false;
    //}
    return true;
}

function getNextDate(sendDate,day){ 
	var d1 = sendDate.replace(/\-/g,'\/');
	var date = new Date(d1);
	date.setDate(date.getDate()+day);
	date.setMonth(date.getMonth()+1);
	var outputdate = date.getYear() + "-" + date.getMonth() + "-" + date.getDate();
	return outputdate;
} 

function   DateDiff(sDate1,sDate2){     //sDate1和sDate2是2004-10-18格式 
    var aDate,oDate1,oDate2,iDays ;
    aDate = sDate1.split( "-") ;
    oDate1 =   new Date(aDate[1] + '-' + aDate[2] + '-' + parseInt(aDate[0])); //转换为10-18-2004格式 
    aDate = sDate2.split("-") ;
    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
    iDays = parseInt(Math.abs(oDate1 - oDate2)/1000/60/60/24);   //把相差的毫秒数转换为天数 
    return iDays ;
}   