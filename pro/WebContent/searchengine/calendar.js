/**
 * 浮动日历
 * @param {Object} dateStr
 * @param {Object} format
 */
function Calendar(dateStr,format){
	this.today=new Date();
	this.format=format?format:"YYYY-mm-dd";
	this.dateStr = dateStr?dateStr:this.today.getStrDate();
	this.firstDay=new Date();
	this.lastDay=new Date();
	this.date=new Date();	
	this.date.SetStrDate(this.dateStr);
	this.firstDay.SetStrDate(this.dateStr);
	this.lastDay.SetStrDate(this.dateStr);
	this.firstDay.setDate(1);
	this.lastDay.setDate(1);
	this.lastDay.add("month",1);
	this.lastDay.setDate(0);
};
/* 创建日历 */
Calendar.prototype.create=function(fieldName,fieldSpan,isNeed,pos){
	closePicker("datePicker");
	hiddenSelect();
	var parent = document.getElementsByTagName("body")[0];
	var datePicker = document.createElement("div");
	datePicker.id="datePicker";
	datePicker.style.position="absolute"; 
	datePicker.style.left = pos.x-10+"px";
	datePicker.style.top = pos.y+10*1+"px";
	datePicker.dateStr=this.dateStr;
	datePicker.fieldName=fieldName;
	datePicker.fieldSpan=fieldSpan;
	datePicker.isNeed=isNeed;	
	this.createDataTable(datePicker);
	parent.appendChild(datePicker);
	
	if(parseInt(datePicker.style.left)+parseInt(datePicker.clientWidth)>parseInt(parent.clientWidth)){
		datePicker.style.left=(parseInt(parent.clientWidth)-parseInt(datePicker.clientWidth))+"px";
	}  
	if(parseInt(datePicker.style.top)+parseInt(datePicker.clientHeight)>parseInt(parent.clientHeight)){
		datePicker.style.top=(parseInt(parent.clientHeight)-parseInt(datePicker.clientHeight))+"px";
	}  
	if(window.timeselectup==1){  
		try{
			if(window.buttonh==null){
				window.expandsflag=1;
				changeButton();
				datePicker.style.top=(parseInt(datePicker.style.top)-parseInt(datePicker.clientHeight)/2+20)+"px";
			} else{
				datePicker.style.top=(parseInt(datePicker.style.top)-parseInt(datePicker.clientHeight)+20)+"px";
			}
		}catch(e){} 
	} 
};
Calendar.prototype.createDataTable = function(datePicker){
	datePicker.innerHTML="";
	var table = document.createElement("table");
	table.cellSpacing = 0;
	table.cellPadding = 0;
	var header = table.insertRow(0);
	header.className="header";
	var cell = header.insertCell(0);
	cell.innerHTML="<a href=javascript:pickerHelper('datePicker'); title='"+language.HELP+"'>?</a>";
	cell = header.insertCell(1);
	cell.colSpan="5";
	var select = document.createElement("Select");
	select.id="yearSelect";
	select.style.display="none";
	select.onchange = function(){
		changeYear(0, select.value);
	};
	for(var i=1930,j=0;i<2020;i++,j++){
		select.options[j] = new Option(i, i);
		if(i==this.dateStr.substring(0,4)){
			select.options[j].selected=true;
		}
	}
	cell.appendChild(select);
	var span = document.createElement("Span");
	span.id="yearSpan";
	span.onclick=function(){
		span.style.display="none";
		select.style.display="";
	};
	span.appendChild(document.createTextNode(this.date.getFullYear()));
	cell.appendChild(span);
	cell.appendChild(document.createTextNode(" , "));
	var monthSelect = document.createElement("Select");
	monthSelect.id="monthSelect";
	monthSelect.style.display="none";
	monthSelect.onchange = function(){
		changeMonth(0, monthSelect.value);
	};
	for(var i=0;i<12;i++){
		monthSelect.options[i] = new Option(language.MONTH[i], i);
		if(i==this.dateStr.substring(5,7)*1-1){
			monthSelect.options[i].selected=true;
		}
	}
	cell.appendChild(monthSelect);
	var monthSpan = document.createElement("Span");
	monthSpan.id="monthSpan";
	monthSpan.onclick=function(){
		monthSpan.style.display="none";
		monthSelect.style.display="";
	};
	monthSpan.appendChild(document.createTextNode(this.date.getLocaleMonth()));
	cell.appendChild(monthSpan);
	cell = header.insertCell(2);
	cell.innerHTML="<a href=javascript:closePicker('datePicker'); title='"+language.CLOSE+"'>&#x00d7;</a>";
		
	var todayHeader = table.insertRow(1);
	todayHeader.className="header";
	var cell = todayHeader.insertCell(0);
	cell.innerHTML="<a href=javascript:changeYear(-1); title='"+language.PREYEAR+"'>&#x00ab;</a>";
	cell = todayHeader.insertCell(1);
	cell.innerHTML="<a href=javascript:changeMonth(-1); title='"+language.PREMONTH+"'>&#x2039;</a>";
	cell = todayHeader.insertCell(2);
	cell.colSpan="3";
	cell.innerHTML="<a href=javascript:clickday('"+this.today.getStrDate()+"');>"+language.TODAY+"</a>";
	cell = todayHeader.insertCell(3);
	cell.innerHTML="<a href=javascript:changeMonth(1); title='"+language.NEXTMONTH+"'>&#x203a;</a>";	
	cell = todayHeader.insertCell(4);
	cell.innerHTML="<a href=javascript:changeYear(1); title='"+language.NEXTYEAR+"'>&#x00bb;</a>";
	
	var weekHeader = table.insertRow(2);
	weekHeader.className="week";
	var cell = weekHeader.insertCell(0);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_SUN));
	cell = weekHeader.insertCell(1);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_MON));
	cell = weekHeader.insertCell(2);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_TUE));
	cell = weekHeader.insertCell(3);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_WED));
	cell = weekHeader.insertCell(4);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_THU));
	cell = weekHeader.insertCell(5);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_FRI));
	cell = weekHeader.insertCell(6);
	cell.appendChild(document.createTextNode(language.SHORT_WEEK_SAT));

	var days=this.date.getDaysInMonth();
	var preDays=this.date.getPreDays();
	var aftDays=this.date.getAftDays();
	var totalCount=days*1+preDays*1+aftDays*1;
	this.date.setDate(0);
	this.date.add("day", 0-preDays);
	var j=3;
	for(var i=0;i<totalCount;){
		this.createRow(table,j);
		i+=7;j++;
	}
	
	var footer = table.insertRow(j);
	footer.className="footer";
	var cell = footer.insertCell(0);
	cell.innerHTML="<a href=javascript:changeYear(-10); title='"+language.PRETENYEAR+"'>&#x00ab;</a>";
	cell = footer.insertCell(1);
	cell.innerHTML="<a href=javascript:changeMonth(-3); title='"+language.PRETHREEMONTH+"'>&#x2039;</a>";
	cell = footer.insertCell(2);
	cell.colSpan="3";
	cell.innerHTML="<a href=javascript:cancel('datePicker'); >"+language.CANCEL+"</a>";
	cell = footer.insertCell(3);
	cell.innerHTML="<a href=javascript:changeMonth(3); title='"+language.NEXTTHREEMONTH+"'>&#x203a;</a>";
	cell = footer.insertCell(4);
	cell.innerHTML="<a href=javascript:changeYear(10); title='"+language.NEXTTENYEAR+"'>&#x00bb;</a>";
	
	datePicker.appendChild(table);
}
/* 生成日历中的一行 */
Calendar.prototype.createRow=function(table,index){
	var line = table.insertRow(index);
	for(var i=0;i<7;i++){
		this.date.add("day", 1);		
		var cell = line.insertCell(i);		
		cell.innerHTML="<a href=javascript:clickday('"+this.date.getStrDate()+"');>"+this.date.getFullDate()+"</a>";	
		var beforLen = this.date.getTime()-this.firstDay.getTime();
		var aftLen = this.date.getTime()-this.lastDay.getTime();
		if (beforLen < 0 || aftLen > 0) {//不在本月
			cell.className = "out";
		}
		else {
			if (this.date.getMonth() == this.today.getMonth() && this.date.getDate() == this.today.getDate()) {//今天
				cell.className = "today";
			}
			else {
				cell.className = "date";
			}
		}
	}
};
function closePicker(picker){
	var ele = document.getElementById(picker);
	if(ele){
		var parent = document.getElementsByTagName("body")[0];
		if(window.timeselectup==1){ 
			if(window.expandsflag==1){
				try{  
				window.buttonh=1;
				changeButton();
				}catch(e){}
				window.expandsflag=null;
			} 
		} 
		parent.removeChild(ele);
	}
	showSelect();
}
function clickday(dateStr){
	var datePicker = document.getElementById("datePicker");
	if(datePicker){
		var fieldName=datePicker.fieldName;
		var fieldSpan=datePicker.fieldSpan;
		var isNeed=datePicker.isNeed;
		if(dateStr){
			document.getElementById(fieldSpan).innerHTML = dateStr;
			document.all(fieldName).value = dateStr;			
		}else{
			document.all(fieldName).value = "";
			if (isNeed == 1) {
				document.getElementById(fieldSpan).innerHTML = "<img src=/vimgs/checkinput.gif>";
			}else{
				document.getElementById(fieldSpan).innerHTML = "";
			}
		}
		if(window.timeselectup==1){ 
			if(window.expandsflag==1){
				try{  
				window.buttonh=1;
				changeButton();
				}catch(e){}
				window.expandsflag=null;
			} 
		} 
		var parent = document.getElementsByTagName("body")[0];
		parent.removeChild(datePicker);
	}
	showSelect();
}
function changeMonth(n,month){
	var datePicker = document.getElementById("datePicker");
	if(datePicker){
		var dateStr=datePicker.dateStr;
		var date=new Date();	
		date.SetStrDate(dateStr);
		date.add("month",n);
		if(month){
			date.setMonth(month);
		}
		var cal = new Calendar(date.getStrDate());
		cal.createDataTable(datePicker);
		cal=null;
		datePicker.dateStr=date.getStrDate();
	}
}
function changeYear(n,year){
	var datePicker = document.getElementById("datePicker");
	if(datePicker){
		var dateStr=datePicker.dateStr;
		var date=new Date();	
		date.SetStrDate(dateStr);
		date.add("year",n);
		if(year){
			date.setFullYear(year);
		}		
		var cal = new Calendar(date.getStrDate());
		cal.createDataTable(datePicker);
		cal=null;
		datePicker.dateStr=date.getStrDate();
	}
}
/**
 * 浮动时间选择框
 */
function Timer(format){
	this.format=format?format:"HH:mm";
	this.beginTime ="08:30";
	this.beginTime ="17:30";
	this.date=new Date();
}
Timer.prototype.create=function(fieldName,fieldSpan,isNeed,pos){
	closePicker("timePicker");
	hiddenSelect();
	var parent = document.getElementsByTagName("body")[0];
	var timePicker = document.createElement("div");
	timePicker.id="timePicker";
	var hour = this.date.getHours();
	var minute = this.date.getMinutes();
	if(hour<10)	hour ="0" + hour;
	if(minute<10)	minute ="0" + minute;
	timePicker.hour=hour;
	timePicker.minute=minute;
	timePicker.style.position="absolute";
	timePicker.style.left = pos.x-10+"px";
	timePicker.style.top = pos.y+10*1+"px";
	timePicker.fieldName=fieldName;
	timePicker.fieldSpan=fieldSpan;
	timePicker.isNeed=isNeed;	
	this.createTimeTable(timePicker);
	parent.appendChild(timePicker);
};
Timer.prototype.createTimeTable = function(timePicker){
	timePicker.innerHTML="";
	var table = document.createElement("table");
	table.cellSpacing = 0;
	table.cellPadding = 0;
	var header = table.insertRow(0);
	header.className="header";
	var cell = header.insertCell(0);
	cell.innerHTML="<a href=javascript:pickerHelper('timePicker'); title='"+language.HELP+"'>?</a>";
	cell = header.insertCell(1);
	cell.colSpan="4";
	cell.appendChild(document.createTextNode(this.date.getHours()+":"+this.date.getMinutes()));
	cell = header.insertCell(2);
	cell.innerHTML="<a href=javascript:closePicker('timePicker'); title='"+language.CLOSE+"'>&#x00d7;</a>";

	var hourHeader = table.insertRow(1);
	hourHeader.className="header";
	var cell = hourHeader.insertCell(0);
	cell.colSpan=4;
	cell.appendChild(document.createTextNode(language.HOUR));
	cell = hourHeader.insertCell(1);
	cell.colSpan=2;
	cell.appendChild(document.createTextNode(language.MINUTE));

	for(var i=0;i<6;i++){
		var row = table.insertRow(2+i);
		var cell = row.insertCell(0);
		cell.className="hour";
		var hour = i;
		if(hour<10)	hour="0"+hour;
		cell.innerHTML="<a href='javascript:' onclick=javascript:clickHour('"+hour+"');return false;>"+hour+"</a>";
		cell = row.insertCell(1);
		cell.className="hour";
		hour=6+i;
		if(hour<10)	hour="0"+hour;
		cell.innerHTML="<a href='javascript:' onclick=javascript:clickHour('"+(hour)+"');return false;>"+(hour)+"</a>";
		cell = row.insertCell(2);
		cell.className="hour";
		cell.innerHTML="<a href='javascript:' onclick=javascript:clickHour('"+(12+i)+"');return false;>"+(12+i)+"</a>";
		cell = row.insertCell(3);
		cell.className="hour";
		cell.innerHTML="<a href='javascript:' onclick=javascript:clickHour('"+(18+i)+"');return false;>"+(18+i)+"</a>";
		cell = row.insertCell(4);
		cell.className="minute";
		var minute = 5*i;
		if(minute<10)	minute="0"+minute;
		cell.innerHTML="<a href=javascript:clickMinute('"+minute+"')>"+minute+"</a>";
		cell = row.insertCell(5);
		cell.className="minute";
		cell.innerHTML="<a href=javascript:clickMinute('"+(30+5*i)+"')>"+(30+5*i)+"</a>";
	}
	
	var footer = table.insertRow(8);
	footer.className="footer";
	var cell = footer.insertCell(0);
	cell.colSpan=6;
	cell.innerHTML="<a href=javascript:cancel('timePicker'); >"+language.CANCEL+"</a>";
	timePicker.appendChild(table);
};
function cancel(picker){
	var picker = document.getElementById(picker);
	var fieldName=picker.fieldName;
	var fieldSpan=picker.fieldSpan;
	var isNeed=picker.isNeed;
	document.all(fieldName).value = "";
	if (isNeed == 1) {
		document.getElementById(fieldSpan).innerHTML = "<img src=/vimgs/checkinput.gif>";
	}else{
		document.getElementById(fieldSpan).innerHTML = "";
	}
	if(window.timeselectup==1){ 
			if(window.expandsflag==1){
				try{  
				window.buttonh=1;
				changeButton();
				}catch(e){}
				window.expandsflag=null;
			} 
	} 
	var parent = document.getElementsByTagName("body")[0];
	parent.removeChild(picker);
	showSelect();
}
function clickHour(hour){
	var ev = window.event;
	var el = ev.srcElement;
	document.getElementById("timePicker").hour=hour;
	var tmp = document.getElementById("clickedHour");
	if(tmp){
		tmp.id="";
		tmp.style.color="";
		tmp.style.backgroundColor="";
	}
	el.id="clickedHour";
	el.style.color="#fff";
	el.style.backgroundColor="#5276b2";
}
function clickMinute(minute){
	var timePicker = document.getElementById("timePicker");
	var hour = timePicker.hour;
	var fieldName=timePicker.fieldName;
	var fieldSpan=timePicker.fieldSpan;
	var timeStr = hour+":"+minute;
	document.all(fieldName).value = timeStr;
	document.getElementById(fieldSpan).innerHTML = timeStr;
	var parent = document.getElementsByTagName("body")[0];
	parent.removeChild(timePicker);
	showSelect();
}
function pickerHelper(picker){
	if(picker=='datePicker'){
		alert(language.TATEPICKERHELP);
	}else if(picker=='timePicker'){
		alert(language.TIMEPICKERHELP);
	}
}
function hiddenSelect(){
	var selects = document.getElementsByTagName("select");
	var len = selects.length;
	for(var i=0;i<len;i++){
		var select = selects[i];
		select.style.display="none";
	}
}
function showSelect(){
	var selects = document.getElementsByTagName("select");
	var len = selects.length;
	for(var i=0;i<len;i++){
		var select = selects[i];
		select.style.display="";
	}
}
