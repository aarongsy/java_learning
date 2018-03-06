//判断
function Assert(b,message){if(!b)alert(message);return b;}

function hModulo(a,b){return Math.round(a-(Math.floor(a/b)*b));}
//加载xml
function getXMLParser(s)
{
	var parser=null;
	if(document.implementation&&document.implementation.createDocument)
	{
		parser=(new DOMParser()).parseFromString(s,"text/xml");
	}
	else if(window.ActiveXObject)
	{
		parser=new ActiveXObject("Microsoft.XMLDOM");
		parser.async=false;
		if(parser.loadXML(s)==false)
		{
			alert("error, malformed xml");
		};
	}
	else{alert('Your browser cannot handle this script (no xml parser found)');}
return parser;
}
//修正事件
function fixEvent(a)
{
if(typeof a=="undefined")
	a=window.event;
if(typeof a.layerX=="undefined")
	a.layerX=a.offsetX;
if(typeof a.layerY=="undefined")
	a.layerY=a.offsetY;
if(typeof a.target=="undefined")
	a.target=a.srcElement;
if(typeof a.which=="undefined")
	a.which=a.keyCode;
return a;
}
//是否左键点击
function isLeftClick(event)
{
	var leftclick=false;
	if(event.which)
		leftclick=(event.which==1);
	else if(event.button)
		leftclick=(event.button==1);
	return leftclick;
}
//是否右键点击
function isRightClick(event){var rightclick=false;if(event.which)rightclick=(event.which==3);else if(event.button)rightclick=(event.button==2);return rightclick;}

function isAlphaNumeric(keyCode){if(keyCode >=32&&keyCode <=125)return true;return false;}

var ModalDialog=null;
function dialogBox(text,buttons,notifier,height,width)
{
	if(ModalDialog==null)
	{
		ModalDialog=document.createElement("DIV");
		ModalDialog.style.position="absolute";
		ModalDialog.style.height="100%";
		ModalDialog.style.width="100%";
		ModalDialog.style.top="0px";
		ModalDialog.style.left="0px";
		document.body.appendChild(ModalDialog);
	}
	var d=document.createElement("DIV");
	d.style.display="block";
	d.style.position="absolute";
	d.style.border="1px solid #000000";
	d.style.filter="alpha(opacity=90)";
	d.style.opacity="0.9";
	d.style.zIndex=100;
	ModalDialog.appendChild(d);
	d.style.margin="10px";
	d.style.width=width+"px";
	d.style.height=height+"px";
	d.style.top=Math.max(0,document.body.scrollTop+(document.body.clientHeight-parseInt(d.style.height))/2);
	d.style.left=Math.max(0,document.body.scrollLeft+(document.body.clientWidth-parseInt(d.style.width))/2);
	d.style.backgroundColor=_EDITBOXBGCOLOR;
	var i="<table>";i+="<tr><td align='center' colspan="+buttons.length+">";
	i+=text;
	i+="</td></tr>";
	i+="<tr>";
	for(var j=0;j<buttons.length;j++)
	{
		i+="<td id='button"+j+"'>";
		i+=buttons[j];i+="</td>";
	}
	i+="</tr></table>";
	d.innerHTML=i;
	for(var j=0;j<buttons.length;j++)
	{
		var b=document.getElementById('button'+j);
		b.style.border="1px solid #000000";
		b.style.cursor="pointer";b.value=j;
		b.onmouseover=divHighlightHandler;
		b.onmouseout=divUnhighlightHandler;
		b.onmousedown=function()
		{
			notifier.notify(this.value);
			document.body.removeChild(ModalDialog);
			ModalDialog=null;
		};
	}
}

var _DAYSOFTHEWEEK=new Array("<font color='blue'>周日</font>","<font color='blue'>周一</font>","<font color='blue'>周二</font>","<font color='blue'>周三</font>","<font color='blue'>周四</font>","<font color='blue'>周五</font>","<font color='blue'>周六</font>");
var _MONTHSOFTHEYEAR=new Array("1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月");
var _SHORTMONTHSOFTHEYEAR=new Array("Jan","Feb","Mar","Apr","May","June","July","Aug","Sep","Oct","Nov","Dec");
//属于一周的哪天
function dayOfWeek(month,day,year){month=parseInt(month);day=parseInt(day);year=parseInt(year);var m=hModulo(month-2,12);if(month==1||month==2)year--;if(m==0)m=12;var D=hModulo(year,100.00);var C=(year-D)/100.00;var f=day+Math.floor(2.6*m-0.2)+D+Math.floor(D/4.00)+Math.floor(C/4.00)-2*C;return hModulo(f,7);}
//属于一月的哪周
function weekOfMonth(month,day,year){var d=dayOfWeek(month,1,year);var r=parseInt(Math.floor((parseInt(day)+parseInt(d)-1)/7))+1;return r;}
//前一天
function dayBefore(date){var day=date[1];var month=date[0];var year=date[2];var rday;var rmonth;var ryear;if(day==1){rmonth=monthBefore(new Array(month,year))[0];ryear=monthBefore(new Array(month,year))[1];rday=daysInMonth(rmonth,ryear);}else{rday=parseInt(day)-1;rmonth=month;ryear=year;}
return new Array(rmonth,rday,ryear);}
//后一天
function dayAfter(date){var day=date[1];var month=date[0];var year=date[2];var rday;var rmonth;var ryear;if(isMonth31(month)&&day==31){rday=1;rmonth=monthAfter(new Array(month,year))[0];ryear=monthAfter(new Array(month,year))[1];}else if(isMonth30(month)&&day==30){rday=1;rmonth=monthAfter(new Array(month,year))[0];ryear=monthAfter(new Array(month,year))[1];}else if(isMonth29(month)&&day==29){rday=1;rmonth=monthAfter(new Array(month,year))[0];ryear=monthAfter(new Array(month,year))[1];}else if(isMonth28(month)&&day==28){rday=1;rmonth=monthAfter(new Array(month,year))[0];ryear=monthAfter(new Array(month,year))[1];}else{rday=parseInt(day)+1;rmonth=month;ryear=year;}
return new Array(rmonth,rday,ryear);}
//前一周
function weekBefore(date){var x=date;for(var i=0;i<7;i++){x=dayBefore(x);}
return x;}
//后一周
function weekAfter(date){var x=date;for(var i=0;i<7;i++){x=dayAfter(x);}
return x;}
//前一月
function monthBefore(date){var month=date[0];var year=date[1];if(month==1){return new Array(12,parseInt(year)-1);}else return new Array(parseInt(month)-1,year);}
//后一月
function monthAfter(date){var month=date[0];var year=date[1];if(month==12){return new Array(1,parseInt(year)+1);}else return new Array(parseInt(month)+1,year);}
//返回某天属于的周
function getWeekDate(col,month,day,year){var d=dayOfWeek(month,day,year);var today=new Array(month,day,year);if(col==d)return today;while(col < d){today=dayBefore(today);d--;}
while(col > d){today=dayAfter(today);d++;}
return today;}
//判断是否有31、30、29、28
function isMonth31(month,year){if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)return true;else return false;}
function isMonth30(month,year){if(month==4||month==6||month==9||month==11)return true;else return false;}
function isMonth29(month,year){if(month!=2)return false;else if(leapYear(year))return true;else return false;}
function isMonth28(month,year){if(month!=2)return false;else if(leapYear(year))return false;else return true;}
//返回某月的天
function daysInMonth(month,year){if(isMonth31(month,year))return 31;if(isMonth30(month,year))return 30;if(isMonth29(month,year))return 29;if(isMonth28(month,year))return 28;return null;}
//闰年
function leapYear(year){if(hModulo(year,4)==0){if(hModulo(year,100)==0){if(hModulo(year,400)==0)return true;else return false;}else return true;}
else return false;}
//返回60格式的时间
function timeTo60(time){if(time==_NOTIME)return _NOTIME;var ipart=parseInt(time);var fpart=time-parseInt(time);return ipart*100+fpart*60;}
function timeToDecimal(time){if(time==_NOTIME)return _NOTIME;return Math.floor(time/100.00)+hModulo(time,100)/60.00
}
//格式化时间
function timeToString(time,format)
{
	if(time==_NOTIME)return "";
	var r;
	var hr=parseInt(time);
	var min=time-hr;
	if(hr==24)hr=0;
	if(min*60 < 10)
		r=hr+":0"+parseInt(min*60);
	else 
		r=hr+":"+parseInt(min*60);
	return r;
}

function fullTimesToString(starttime,stoptime){var numrows=(stoptime-starttime)/_TIMEINTERVAL;var rowH=new Array(numrows);if(_CLOCK==_12HOURSHORT){for(var i=0;i<numrows;i++){rowH[i]=timeToString(starttime+i*_TIMEINTERVAL,_12HOURCLOCK);}
}else
for(var i=0;i<numrows;i++){rowH[i]=timeToString(starttime+i*_TIMEINTERVAL,_CLOCK);}
return rowH;}

//日、周期的时间轴
function timesToString(starttime,stoptime)
{
	var numrows=(stoptime-starttime)/_TIMEINTERVAL;
	var rowH=new Array(numrows);
	for(var i=0;i<numrows;i++)
	{
		var time=starttime+i*_TIMEINTERVAL;
		if(time-parseInt(time)==0)
		{
			var s=timeToString(time,_CLOCK);
			rowH[i]="<span>"+s+"</span>";
		}
		else
			rowH[i]="&nbsp;";
	}
	return rowH;
}
//是否是最大日期
function isLargestDate(s,format){if(format==_DATE_MMDDYYYY&&s==_LARGESTDATE)return true;var d=parseDateString(s,format);if(d[0]==1&&d[1]==1&&d[2]==2038)return true;return false;}
//格式化日期
function convertDateStringOut(s)
{
	if(s==null || s=="0")return "";
	var d=parseDateString(s);
	return d[2]+"-"+d[0]+"-"+d[1];
}
function convertDateStringIn(s){if(s==null)return "";var d=parseDateString2(s);return d[0]+"/"+d[1]+"/"+d[2];}
function getTodayString(){var today=new Date();return(today.getMonth()+1)+"/"+today.getDate()+"/"+today.getFullYear();}
function parseDateString(s,format)
{
	var m,d,y;
	try{	
		if(format != null)
		{
			y=s.substring(0,s.indexOf('年'));
			m=s.substring(s.indexOf('年')+1,s.indexOf('月'));
			d=s.substring(s.indexOf('月')+1,s.indexOf('日'));
		}
		else
		{
			m=s.substring(0,s.indexOf('/'));
			d=s.substring(s.indexOf('/')+1,s.lastIndexOf('/'));
			y=s.substring(s.lastIndexOf('/')+1,s.length);
		}
		m=removePrefixZeros(m);
		d=removePrefixZeros(d);
		if(isNaN(m)||isNaN(d)||isNaN(y))return null;
		if(m < 1||m > 12||y < 0||d < 0||d > daysInMonth(m,y))return null;
		else
			return new Array(m,d,y);
	}catch(er){return null;}
}
function removePrefixZeros(s){if(s==null)return s;if(s.substr(0,1)=="0")return removePrefixZeros(s.substr(1,s.length-1));return s;}
function parseDateString2(s){var y=s.substring(0,s.indexOf('-'));var m=s.substring(s.indexOf('-')+1,s.lastIndexOf('-'));var d=s.substring(s.lastIndexOf('-')+1,s.length);m=removePrefixZeros(m);d=removePrefixZeros(d);if(isNaN(m)||isNaN(d)||isNaN(y))return null;if(m < 1||m > 12||y < 0||d < 0||d > daysInMonth(m,y))return null;else return new Array(m,d,y);}
function dateBefore(s1,s2){var t1=parseDateString(s1);var t2=parseDateString(s2);var res=false;if(t1==null||t2==null)res=false;else if(parseInt(t1[2])< parseInt(t2[2]))res=true;else if(parseInt(t1[2])==parseInt(t2[2])&&parseInt(t1[0])< parseInt(t2[0]))res=true;else if(parseInt(t1[2])==parseInt(t2[2])&&parseInt(t1[0])==parseInt(t2[0])&&parseInt(t1[1])< parseInt(t2[1]))res=true;return res;}
//日期显示格式
function dateToString(date,format)
{
if(format==null)
	format=_DATE;
if(format==_DATE_MMDDYYYY)
	return date[0]+"/"+date[1]+"/"+date[2];
else if(format==_DATE_DDMMYYYY)
	return date[1]+"/"+date[0]+"/"+date[2];
else if(format==_DATE_YYYYMMDD)
	return date[2]+"/"+date[0]+"/"+date[1];
else if(format==_DATE_MNAMEDYYYY)
	return date[2] + "年" + _MONTHSOFTHEYEAR[date[0]-1]+date[1]+"日";
else if(format==_DATE_MNAMED)
	return date[2] + "年" + _MONTHSOFTHEYEAR[date[0]-1]+date[1]+"日";
else if(format==_DATE_SMNAMED)
	return  date[0]+"/"+date[1];
}

function y2k(number){return(number < 1000)? number+1900:number;}
//获取某天属于某周
function getWeek(month,day,year){month--;var when=new Date(year,month,day);var newYear=new Date(year,0,1);var offset=7+1-newYear.getDay();if(offset==8)offset=1;var daynum=((Date.UTC(y2k(year),when.getMonth(),when.getDate(),0,0,0)-Date.UTC(y2k(year),0,1,0,0,0))/1000/60/60/24)+1;var weeknum=Math.floor((daynum-offset+7)/7);if(weeknum==0){year--;var prevNewYear=new Date(year,0,1);var prevOffset=7+1-prevNewYear.getDay();if(prevOffset==2||prevOffset==8)weeknum=53;else weeknum=52;}
return weeknum;}

function ConvertEventsByMonth(elist,date){var eresult=ProcessMonthRepeats(date,elist);return eresult;}

function SameWeeklyCheck(rep,day){if(rep==null)return false;if(rep&Math.pow(2,day)){return true;}
else return false;}
function SameWeeklyDate(event,date){var month=date[1];var year=date[0];var day=date[2];var dayof=dayOfWeek(month,day,year);var rep=event.rep;if((SameWeeklyCheck(rep,0)&&dayof==0)||
(SameWeeklyCheck(rep,1)&&dayof==1)||
(SameWeeklyCheck(rep,2)&&dayof==2)||
(SameWeeklyCheck(rep,3)&&dayof==3)||
(SameWeeklyCheck(rep,4)&&dayof==4)||
(SameWeeklyCheck(rep,5)&&dayof==5)||
(SameWeeklyCheck(rep,6)&&dayof==6)){return true;}
return false;}
function IsDayExclude(exclude,date){var month=date[1];var year=date[0];var day=date[2];var key=month+"/"+day+"/"+year;if(typeof(exclude[key])!='undefined'){return true;}
return false;}
function GetEventExcludes(event){var excludes=new Array();var elist=event.excludes;for(var i=0;i<elist.length;i++){var key=elist[i];excludes[key]=1;}
return excludes;}
//处理月份重复
function ProcessMonthRepeats(date,events){var month=date[1];var year=date[0];var day=date[2];var eresult=new Array();for(var i=0;i<events.length;i++){var event=events[i];var excludes=new Array();if(event.hasexclude==1){excludes=GetEventExcludes(event);}
if(event.reptype==4){if(event.smonth==month){if(event.repnum <=0){continue;}
if(((year-parseInt(event.syear))% event.repnum)==0){if(event.hasexclude==1&&IsDayExclude(excludes,date)){continue;}
var cevent=copyEvent(event);var endmonthday=daysInMonth(month,year);cevent.syear=year;if(endmonthday < cevent.sday){cevent.sday=endmonthday;}
eresult.push(cevent);}
}
}
else if(event.reptype==3){if(event.repnum <=0){continue;}
var monthDiff=((year-parseInt(event.syear))*12)+(month-parseInt(event.smonth));if((monthDiff % event.repnum)==0){if(event.hasexclude==1&&IsDayExclude(excludes,date)){continue;}
var cevent=copyEvent(event);var endmonthday=daysInMonth(month,year);cevent.syear=year;cevent.smonth=month;if(endmonthday < cevent.sday){cevent.sday=endmonthday;}
eresult.push(cevent);}
}
else if(event.reptype==2){if(event.repnum <=0){continue;}
var thestart=new Date(event.syear,parseInt(event.smonth)-1,event.sday);var current=new Date(year,month-1,day);var diffmod=Math.round((current-thestart)/(1000*60*60*24))% event.repnum;var diffadd=event.repnum-diffmod;if(diffmod==0){diffadd=0;}
var startday=1+diffadd;if(event.smonth==month&&
event.syear==year){startday=event.sday;}
var endday=daysInMonth(month,year);var enddate=parseDateString(event.enddate);var eyear=enddate[2];var emonth=enddate[0];var eday=enddate[1];if(emonth==month&&
eyear==year){endday=eday;}
for(var j=startday;j <=endday;j++){var newdate=new Array(year,month,j);if(SameWeeklyDate(event,newdate)){var weekDiff=((year-parseInt(event.syear))*52)+(getWeek(month,j,year)-parseInt(event.sweek));if((weekDiff % event.repnum)==0){if(event.hasexclude==1&&IsDayExclude(excludes,newdate)){continue;}
var cevent=copyEvent(event);cevent.sday=j;cevent.smonth=month;cevent.syear=year;eresult.push(cevent);}
}
}
}
else if(event.reptype==1){if(event.repnum <=0){continue;}
var thestart=new Date(parseInt(event.syear),parseInt(event.smonth)-1,parseInt(event.sday));var current=new Date(year,month-1,day);var diffmod=Math.round((current-thestart)/(1000*60*60*24))% event.repnum;var diffadd=event.repnum-diffmod;if(diffmod==0){diffadd=0;}
var startday=1+diffadd;if(event.smonth==month&&
event.syear==year){startday=event.sday;}
var endday=daysInMonth(month,year);var enddate=parseDateString(event.enddate);var eyear=enddate[2];var emonth=enddate[0];var eday=enddate[1];if(emonth==month&&
eyear==year){endday=eday;}
for(var j=startday;j <=endday;j=parseInt(j)+parseInt(event.repnum)){var thedate=new Array(year,month,j);if(event.hasexclude==1&&IsDayExclude(excludes,thedate)){continue;}
var cevent=copyEvent(event);cevent.sday=j;cevent.smonth=month;cevent.syear=year;eresult.push(cevent);}
}
else{eresult.push(event);}
}
return eresult;}

//事件列表 －前
function EventList_inPrev(event)
{
	var startdate=parseDateString(event.startdate);
	if(startdate[2] < EVENTLIST_YEAR)
		{return true;}
	else if(startdate[2]==EVENTLIST_YEAR&&startdate[0] < EVENTLIST_MONTH)
		{return true;}
	return false;
}
//事件列表 －后
function EventList_inNext(event){var enddate=parseDateString(event.enddate);if(enddate[2] > EVENTLIST_YEAR){return true;}
else if(enddate[2]==EVENTLIST_YEAR&&
enddate[0] > EVENTLIST_MONTH){return true;}
return false;}
//事件列表 －删除
function EventList_Drop(event){for(var i=0;i<EVENTLIST_XML.length;i++){if(event.id==EVENTLIST_XML[i].id){EVENTLIST_XML.splice(i,1);break;}
}
if(EventList_inPrev(event)){for(var i=0;i<EVENTLIST_XML_PREV.length;i++){if(event.id==EVENTLIST_XML_PREV[i].id){EVENTLIST_XML_PREV.splice(i,1);break;}
}
}
if(EventList_inNext(event)){for(var i=0;i<EVENTLIST_XML_NEXT.length;i++){if(event.id==EVENTLIST_XML_NEXT[i].id){EVENTLIST_XML_NEXT.splice(i,1);break;}
}
}
}
//根据ID从事件列表中取出
function EventList_FetchByID(id){for(var i=0;i<EVENTLIST_XML.length;i++){if(id==EVENTLIST_XML[i].id){var event=copyEvent(EVENTLIST_XML[i]);return event;}
}
return null;}
//生成事件
function EventList_RegenEvent(event){EVENTLIST_XML.push(event);if(EventList_inPrev(event)){EVENTLIST_XML_PREV.push(copyEvent(event));}
if(EventList_inNext(event)){EVENTLIST_XML_NEXT.push(copyEvent(event));}
}
//打印事件
function EventList_Print(elist){if(elist.length > 0){for(var i=0;i<elist.length;i++){var event=elist[i];alert("evlist: "+i+"="+eventToString(event));}
}else{alert("evlist: empty");}
}
//更新事件列表
function EventList_Update(reqtype,event,excludedate)
{
	if(reqtype=='repdel')
	{
		var oldevent = EventList_FetchByID(event.id);
		if(oldevent==null){return;}
		EventList_Drop(event);
		if(oldevent.excludes==null)
		{oldevent.excludes=new Array();}
		oldevent.excludes.push(excludedate);
		oldevent.hasexclude=1;EventList_RegenEvent(oldevent);
	}
	else if(reqtype=='del'){EventList_Drop(event);}
	else if(reqtype=='new'){EventList_RegenEvent(event);}
	else if(reqtype=='repmove')
	{
		var oldid=event.id;
		var oldevent=EventList_FetchByID(oldid);
		if(oldevent==null){return;}
		EventList_Drop(oldevent);
		if(oldevent.excludes==null){oldevent.excludes=new Array();}
		oldevent.excludes.push(excludedate);
		oldevent.hasexclude=1;
		EventList_RegenEvent(oldevent);
		event.id=0;event.reptype=0;
		event.repnum=1;
		event.rep=0;
		event.hasexclude=0;
		event.excludes=null;
		event.startdate=excludedate;
		event.enddate=excludedate;
		EventList_RegenEvent(event);
	}
	else if(reqtype=='mod'){EventList_Drop(event);EventList_RegenEvent(event);}
}

//添加导航栏
function addNavBar(owner,element)
{
	var d=document.getElementById(element);
	var navbar=newNavBar(owner);
	if(owner)getCatInfo();
	navbar.parent=element;
	d.appendChild(navbar);
	addNavListeners(navbar);
	refreshNavBar(navbar);
	return navbar;
}
//刷新导航栏
function refreshNavBar(navbar)
{
	navbar.style.border="0px";
	navbar.style.borderBottom="0px";
	var todayB=document.getElementById('navTodayButton');
	var monthB=document.getElementById('navMonthButton');
	var dayB=document.getElementById('navDayButton');
	var weekB=document.getElementById('navWeekButton');
	var addEventB=document.getElementById('navAddEventButton');
	setStyle1(todayB);setStyle1(monthB);setStyle1(weekB);setStyle1(dayB);
	if(navbar.owner){setStyle1(addEventB);}
	if(navbar.pnbuttons!=null)refreshPrevNextBar(navbar.pnbuttons);
}
//设置样式
function setStyle1(e){e.style.border="2px solid #fff";e.style.backgroundColor=_HEADERCOLOR;e.style.cursor="pointer";}
//刷新前后按钮
function refreshPrevNextBar(pn)
{
	//pn.style.fontSize=_MEDIUMFONTSIZE;
	//pn.style.fontFamily=_USERFONT;
	//pn.firstChild.style.filter="alpha(Opacity=100, FinishOpacity=50, Style=1, StartX=0, StartY=0, FinishX=0, FinishY=100)";
	//pn.style.border="1px solid #000000";
	//pn.style.borderBottom="0px";
	//pn.firstChild.style.backgroundColor=_DARKERHEADERCOLOR;
	var p=document.getElementById('navPrev');
	var m=document.getElementById('navMid');
	var n=document.getElementById('navNext');
	n.style.border=m.style.border=p.style.border="0px";
}
//添加导航栏事件监听
function addNavListeners(navbar)
{
var todayB=document.getElementById('navTodayButton');
var monthB=document.getElementById('navMonthButton');
var dayB=document.getElementById('navDayButton');
var weekB=document.getElementById('navWeekButton');
var addEventB=document.getElementById('navAddEventButton');
if(navbar.owner)
	addEventB.onmousedown=function()
	{
		resetNewEventDiv(navbar.currentCalendar);
		document.onkeydown=null;
		document.onkeypress=null;
		showEditLayer(null,navbar.currentCalendar,true)
	};
	todayB.onmousedown=function()
	{
		var cc=navbar.currentCalendar;
		var d=new Date();
		var cal=makeCalendar(d.getMonth()+1,d.getDate(),d.getFullYear(),cc.starttime,cc.stoptime,cc.view,cc.owner,cc.parent);
		setNavCurrentCalendar(navbar,cal);
	}
	monthB.onmousedown=function()
	{
		var cc=navbar.currentCalendar;
		var cal=makeCalendar(cc.month,cc.day,cc.year,cc.starttime,cc.stoptime,_MONTHVIEW,cc.owner,cc.parent);
		setNavCurrentCalendar(navbar,cal);
	}
	weekB.onmousedown=function()
	{
		var cc=navbar.currentCalendar;
		var cal=makeCalendar(cc.month,cc.day,cc.year,cc.starttime,cc.stoptime,_WEEKVIEW,cc.owner,cc.parent);
		setNavCurrentCalendar(navbar,cal);
	}
	dayB.onmousedown=function()
	{
	var cc=navbar.currentCalendar;
	var cal=makeCalendar(cc.month,cc.day,cc.year,cc.starttime,cc.stoptime,_DAYVIEW,cc.owner,cc.parent);
	setNavCurrentCalendar(navbar,cal);
	}
}
//添加前后按钮
function addPrevNextButtons(element)
{
	var d=document.getElementById(element);
	var pn=newPrevNextButtons();
	d.appendChild(pn);
	refreshPrevNextBar(pn);
	return pn;
}
function registerNavBar(navbar,calendar){calendar.navbar=navbar;}
//点击导航栏上的按钮后显示对应的日历
function setNavCurrentCalendar(navbar,calendar)
{
	if(navbar.currentCalendar==calendar)return;
	if(navbar.currentCalendar!=null)
	{
		cleanUpCalendar(navbar.currentCalendar);
		navbar.currentCalendar.parentNode.removeChild(navbar.currentCalendar);
	}
	if(_CALENDAR_PINUPS=='hon'){getNewHONImage(calendar);}
	registerNavBar(navbar,calendar);
	navbar.currentCalendar=calendar;
	if(navbar.isLocal)
		{addEvents(navbar.localEvents,calendar);navbar.APIparent.notifyListeners();}
	else 
		addEventsToCalendar(calendar);
	calendar.style.display="block";
	var monthB=document.getElementById('navMonthButton');
	var dayB=document.getElementById('navDayButton');
	var weekB=document.getElementById('navWeekButton');
	monthB.innerHTML="月";
	weekB.innerHTML="周";
	dayB.innerHTML="日";
	setBackgroundColor(dayB,weekB,monthB);
	if(calendar.view==_DAYVIEW)
	{
	dayB.innerHTML="<b>日</b>";
	dayB.style.backgroundColor=_DARKERHEADERCOLOR;
	}
	else if(calendar.view==_WEEKVIEW)
	{
	weekB.innerHTML="<b>周</b>";
	weekB.style.backgroundColor=_DARKERHEADERCOLOR;
	}
	else if(calendar.view==_MONTHVIEW)
	{
	monthB.innerHTML="<b>月</b>";
	monthB.style.backgroundColor=_DARKERHEADERCOLOR;
	}
	setPrevNextListeners(navbar,navbar.currentCalendar);
}
//设置按钮背景颜色
function setBackgroundColor(dayB,weekB,monthB)
{
	dayB.style.backgroundColor="#E8EEF7";
	weekB.style.backgroundColor="#E8EEF7";
	monthB.style.backgroundColor="#E8EEF7";
}
//注册前后按钮
function registerPrevNextButtons(navbar,pnbuttons)
{
	navbar.pnbuttons=pnbuttons;
	var p=document.getElementById('navPrev');
	var m=document.getElementById('navMid');
	var n=document.getElementById('navNext');
	navbar.prevButton=p;
	navbar.midButton=m;
	navbar.nextButton=n;
}
//设置前后按钮事件监听
function setPrevNextListeners(navbar,calendar)
{
	Assert(navbar.prevButton!=null&&navbar.nextButton!=null,"addPNListeners: no buttons exist!");
	navbar.prevButton.style.cursor=navbar.nextButton.style.cursor="pointer";
	if(calendar.view==_WEEKVIEW)
	{
		navbar.midButton.firstChild.firstChild.nodeValue=dateToString(getDate(0,calendar),_DATE_MNAMED)+" — "+dateToString(getDate(6,calendar),_DATE_MNAMED);
		navbar.prevButton.onmousedown=function()
		{
			var weekbefore=weekBefore(new Array(calendar.month,calendar.day,calendar.year));
			var cal=makeCalendar(weekbefore[0],weekbefore[1],weekbefore[2],calendar.starttime,calendar.stoptime,_WEEKVIEW,calendar.owner,calendar.parent);
			setNavCurrentCalendar(navbar,cal);
		}
		navbar.nextButton.onmousedown=function()
		{
			var weekafter=weekAfter(new Array(calendar.month,calendar.day,calendar.year));
			var cal=makeCalendar(weekafter[0],weekafter[1],weekafter[2],calendar.starttime,calendar.stoptime,_WEEKVIEW,calendar.owner,calendar.parent);
			setNavCurrentCalendar(navbar,cal);
		}
	}
	else if(calendar.view==_DAYVIEW)
	{
		navbar.midButton.firstChild.firstChild.nodeValue=dateToString(new Array(calendar.month,calendar.day,calendar.year),_DATE_MNAMEDYYYY);
		navbar.prevButton.onmousedown=function()
		{
			var daybefore=dayBefore(new Array(calendar.month,calendar.day,calendar.year));
			var cal=makeCalendar(daybefore[0],daybefore[1],daybefore[2],calendar.starttime,calendar.stoptime,_DAYVIEW,calendar.owner,calendar.parent);
			setNavCurrentCalendar(navbar,cal);
		}
		navbar.nextButton.onmousedown=function()
		{
			var dayafter=dayAfter(new Array(calendar.month,calendar.day,calendar.year));
			var cal=makeCalendar(dayafter[0],dayafter[1],dayafter[2],calendar.starttime,calendar.stoptime,_DAYVIEW,calendar.owner,calendar.parent);
			setNavCurrentCalendar(navbar,cal);
		}
	}
	else if(calendar.view==_MONTHVIEW)
	{
		navbar.midButton.firstChild.firstChild.nodeValue=calendar.year+"年"+_MONTHSOFTHEYEAR[calendar.month-1];
		navbar.prevButton.onmousedown=function()
		{
			var monthbefore=monthBefore(new Array(calendar.month,calendar.year));
			var cal=makeCalendar(monthbefore[0],calendar.day,monthbefore[1],calendar.starttime,calendar.stoptime,_MONTHVIEW,calendar.owner,calendar.parent);
			setNavCurrentCalendar(navbar,cal);
		}
		navbar.nextButton.onmousedown=function()
		{
			var monthafter=monthAfter(new Array(calendar.month,calendar.year));
			var cal=makeCalendar(monthafter[0],calendar.day,monthafter[1],calendar.starttime,calendar.stoptime,_MONTHVIEW,calendar.owner,calendar.parent);
			setNavCurrentCalendar(navbar,cal);
		}
	}
}
//新加导航栏
function newNavBar(owner)
{
	var d=document.createElement("DIV");
	d.currentCalendar=null;
	d.owner=owner;
	if(owner)
		d.innerHTML="<table class='calnav' width='100%' cellspacing='0' cellpadding='0'><tr align='center'>"
				+  "<td id='navPrev' width='32px' align='center'><img src='btn_prev.gif'/></td>"
				+  "<td id='navNext' width='32px' align='center'><img src='btn_next.gif'/></td>"
				+  "<td id='navTodayButton' width='50px'><b>今天</b></td>"
				+  "<td align=left><span id='SyswinPrevNext'></span></td>"
				+  "<td id='navAddEventButton' width='100px'>Add New Event</td><td>&nbsp</td>"
				
				+  "<td width='20%'>&nbsp</td>"
				+  "<td id='navDayButton' width='40px'>日</td>"
				+  "<td id='navWeekButton' width='40px'>周</td>"
				+  "<td id='navMonthButton' width='40px'>月</td>"
				+  "<td>&nbsp</td></tr></table>";
	else 
		d.innerHTML="<table class='calnav' width='100%' cellspacing='0' cellpadding='0'><tr align='center'>"
				+  "<td id='navAddEventButton'>&nbsp;</td>"
				+  "<td id='navPrev' width='32px' align='center'><img src='btn_prev.gif'/></td>"
				+  "<td id='navNext' width='32px' align='center'><img src='btn_next.gif'/></td>"
				+  "<td id='navTodayButton' width='50px'><b>今天</b></td>"
				+  "<td align=left><span id='SyswinPrevNext'></span></td>"
				+  "<td width='30%'>&nbsp</td>"
				+  "<td id='navDayButton' width='40px'>日</td>"
				+  "<td id='navWeekButton' width='40px'>周</td>"
				+  "<td id='navMonthButton' width='40px'>月</td>"
				+  "<td>&nbsp</td></tr></table>";
	return d;
}

//新加前后按钮
function newPrevNextButtons()
{
	var d=document.createElement("DIV");
	d.innerHTML="<table width='250'><tr><td id='navMid' align='left'><span>navMid</span></td></tr></table>";
	return d;
}
function forcetime1(){var index=document.addevent.stime.selectedIndex;var index2=document.addevent.etime.selectedIndex;if(index >-1){if(index >=index2){document.addevent.etime.selectedIndex=index+1;}
}}
function forcetime2(){var index=document.addevent.stime.selectedIndex;var index2=document.addevent.etime.selectedIndex;if(index >=index2){if(index2 < 1){document.addevent.stime.selectedIndex=0;document.addevent.etime.selectedIndex=1;}else{document.addevent.stime.selectedIndex=index2-1;}
}}
function forcealert(){document.addevent.smsnote.checked=true;}
function hastimeOn(){document.addevent.hastime[0].checked=1;}
function setMiniDate(month,day,year,e1){var date1=document.getElementById(e1);date1.notify(month,day,year);}
function changeMiniMonth(month,year,notifier,element,m1,d1,y1){var cal=document.getElementById(element);cal.innerHTML=makeMiniCal(month,-1,year,notifier,element,m1,d1,y1);}

//生成右边的小日历
function makeMiniCal(month,day,year,notifier,element,m1,d1,y1)
{
	var dim=daysInMonth(month,year);
	var numrows=weekOfMonth(month,dim,year);
	var day1=-1*dayOfWeek(month,1,year)+1;
	var res="<table cellpadding=0 cellspacing=0 style='width:120px;border:1px solid #000;font-size:10px;"+"'>";
	res+="<tr align=center><td style='cursor:pointer' onclick=changeMiniMonth('"+monthBefore(new Array(month,year))[0]+"','"+monthBefore(new Array(month,year))[1]+"','"+notifier+"','"+element+"','"+m1+"','"+d1+"','"+y1+"')><</td>";
	res+="<td colspan=5>" + year + " " +_SHORTMONTHSOFTHEYEAR[parseInt(month)-1]+"</td>";
	res+="<td style='cursor:pointer' onclick=changeMiniMonth('"+monthAfter(new Array(month,year))[0]+"','"+monthAfter(new Array(month,year))[1]+"','"+notifier+"','"+element+"','"+m1+"','"+d1+"','"+y1+"')>></td></tr>";
	res+="<tr align=center><td>日</td><td>一</td><td>二</td><td>三</td><td>四</td><td>五</td><td>六</td></tr>";
	var today=new Date();
	for(var i=0;i<numrows;i++)
	{
		res+="<tr align=center>";
		for(var j=0;j<7;j++)
		{
			if(day1 <=0||day1>dim)
				res+="<td>&nbsp;</td>";
			else{
			var js="javascript:setMiniDate("+month+","+day1+","+year+",\""+notifier+"\");";
			js+="changeMiniMonth("+month+","+year+",\""+notifier+"\",\""+element+"\","+month+","+day1+","+year+")";
			res+="<td style='cursor:pointer' onclick='"+js+"'><div style='";
			if(today.getFullYear()==year&&today.getMonth()+1==month&&today.getDate()==day1)
				res+="background-color:#000;color:#FFF;";
			if(d1==day1&&year==y1&&month==m1)
				res+="border:1px solid #FF0000'";else res+="border:1px solid #FFF'";res+="'>"+day1+"</div></td>";
			}
			day1++;
		}
	res+="</tr>";
	}
	res+="</table>";
	return res;
}

var editLayerDiv=null;
//显示事件编辑层
function showEditLayer(cellNode,calendar,newevent,eventskeleton)
{
hideToolTip();
document.onkeypress=document.onkeydown=null;
var editLayer;
if(editLayerDiv==null)
{
	editLayerDiv=document.createElement("DIV");
	editLayerDiv.style.position="absolute";
	editLayerDiv.style.height="100%";
	editLayerDiv.style.width="100%";
	editLayerDiv.style.top="0px";
	editLayerDiv.style.left="0px";
	document.body.appendChild(editLayerDiv);
}
editLayer=document.createElement("DIV");
editLayer.style.display="block";
editLayer.style.position="absolute";
editLayer.style.border="1px solid #000000";
editLayer.style.zIndex=3;
editLayerDiv.appendChild(editLayer);
var event;
if(newevent)
	{
		if(eventskeleton!=null)
			event=eventskeleton;
		else 
			event=makeBlankEvent();
	}
else 
	event=cellNode.event;
editLayerDiv.style.display="block";
editLayer.style.width="600px";
editLayer.style.margin="1px";
var estHt=320;
editLayer.style.top=Math.max(0,document.body.scrollTop+(document.body.clientHeight-estHt)/2);
editLayer.style.left=Math.max(0,document.body.scrollLeft+(document.body.clientWidth-parseInt(editLayer.style.width))/2);
editLayer.style.backgroundColor=_EDITBOXBGCOLOR;
i="<form name='addevent'><div id='editdrag' style='height:20px;background-color:#3578FF;width:600px;color:white;font-size:13px;'>事件信息&nbsp</div>";
i+="<table cellspacing=0 border=0 width='100%' height='100%'><tr><td valign='top'>";
i+="<TABLE>";
i+="<TR><TD>事件名称</TD><TD><INPUT></TD></TR>";
i+="<TR><TD align='right' valign='top'>事件类型</TD><TD><table><tr><td><DIV id=catname_"+event.id+">"+event.catname+"</DIV></td><td><DIV id=catcolor_"+event.id+">&nbsp;</DIV></td></tr></table></TD></TR>";
i+="<TR><TD align='right' valign='top'>事件内容</TD><TD><TEXTAREA></TEXTAREA></TD></TR></TABLE>";
i+="<TABLE>";
i+="<TR><TD align='right' valign='top'><b>时间:</b> </TD><TD><DIV id=stime_"+event.id+"></DIV></TD></TR>";
i+="<TR><TD align='right' valign='top'><b>日期:</b> </TD><TD style='border:1px solid #888888'><DIV id=sdate_"+event.id+"></DIV></TD></TR>";
i+="</table></td>";

i+="<td valign='top'>";
i+="<table style='width:285px;'>";
i+="<tr><td colspan=2 style='font-size:13px'>事件选项:</td></tr>";
i+="<TR><TD align='left' style='width:100px;height:30px'><b>隐私级别:</b> </td><td align='left'><div id=privacy_"+event.id+"></DIV></TD></TR>";
i+="<tr><td colspan=2><b>通知: </b></td></tr>";
i+="<TR><td colspan=2><span align='right' id='email'></span><span id='email2'></span></td></TR>";
i+="<TR><td colspan=2><span align='right' id='sms'></span><span id='sms2'></span></td></tr>";
i+="<tr><td colspan=2>&nbsp;</td></tr>";
i+="<TR><TD valign='top' colspan=2><b>重复: </b></TD></tr><tr><TD colspan=2 style='border:1px solid #888888'>";
i+="<DIV id=repeat_"+event.id+"></DIV>";i+="<table width='100%' cellspacing=0 cellpadding=0>";
i+="<tr><td id=repnum_"+event.id+"></td><td rowspan=2 id='minical2'></td></tr>";
i+="<tr><td id=repend_"+event.id+"></td></tr>";
i+="<tr><td colspan=2 id=rep_"+event.id+"></TD></tr>";
i+="</table></td></tr>";
i+="</TABLE>";
i+="</td>";

i+="</tr></table>";
i+="<TABLE align='center' width='50%'><TR><TD width='30%' id=close_"+event.id+">Save</TD>";
i+="<TD width='30%' id=cancel_"+event.id+">Cancel</TD>";i+="<TD width='30%' id=delete_"+event.id+">Delete Event</TD></TR>";
i+="</TABLE></form>";
editLayer.innerHTML=i;
var dragbar=document.getElementById('editdrag');
dragbar.style.cursor="move";
dragbar.onmousedown=function(a)
{
	a=fixEvent(a);
	c.lastMouseX=a.clientX;
	c.lastMouseY=a.clientY;
	function dragmove(a)
	{
		a=fixEvent(a);
		editLayer.style.top=parseInt(editLayer.style.top)+(a.clientY-c.lastMouseY)+"px";
		editLayer.style.left=parseInt(editLayer.style.left)+(a.clientX-c.lastMouseX)+"px";
		c.lastMouseX=a.clientX;
		c.lastMouseY=a.clientY;
	}
	if(isIE)document.attachEvent("onmousemove",dragmove);
	document.onmouseup=function()
	{
		if(isIE)document.detachEvent("onmousemove",dragmove);
	};
}
var rt=editLayer.getElementsByTagName("TABLE");
for(var j=0;j<rt.length;j++)
{
	rt[j].style.fontFamily=_USERFONT;
	rt[j].style.fontSize="12px";
	if(j==rt.length-1)rt[j].style.fontSize="12px";
}
var s1=editLayer.getElementsByTagName("INPUT")[0];
var s2=editLayer.getElementsByTagName("TEXTAREA")[0];
s1.focus();
s1.value=event.subject;
s2.value=event.eventdesc;
s2.style.overflow="auto";
s1.style.width=s2.style.width="175px";
s2.style.height="100px";
s1.style.fontSize=s2.style.fontSize="10px";
s1.style.fontFamily=s2.style.fontFamily=_USERFONT;
s1.style.border=s2.style.border="1px solid #000000";
s1.style.backgroundColor=s2.style.backgroundColor=editLayer.style.backgroundColor;
var catname=document.getElementById("catname_"+event.id);
var catcolor=document.getElementById("catcolor_"+event.id);
catname.style.cursor="pointer";
catname.value=event.catname;
catname.idvalue=event.catid;
catname.onmousedown=function()
{
	if(catname.value==null||catname.value=="null")
	{catname.value=getDefaultCat().name;}
	else
	{
		for(var i=0;i<categoryInfo.cats.length;i++)
		{
			if(catname.idvalue==categoryInfo.cats[i].id)
			{
				catname.value=categoryInfo.cats[hModulo(i+1,categoryInfo.cats.length)].name;
				catname.idvalue=categoryInfo.cats[hModulo(i+1,categoryInfo.cats.length)].id;
				catcolor.value=categoryInfo.cats[hModulo(i+1,categoryInfo.cats.length)].color;catcolor.style.backgroundColor="#"+catcolor.value;break;
			}
		}
	}
	catname.innerHTML=catname.value;
}
catname.onmouseover=divHighlightHandler;
catname.onmouseout=divUnhighlightHandler;
catcolor.style.border="1px solid #000000";
catcolor.value=event.catcolor;
if(event.catcolor!=null)catcolor.style.backgroundColor="#"+event.catcolor;
catcolor.style.height="10px";
catcolor.style.width="20px";
catcolor.style.border="1px solid #000000";
var stime=document.getElementById("stime_"+event.id);
stime.value=event.stime;
var tempi="<input type='radio' name='hastime'";
if(event.stime!=_NOTIME)tempi+=" checked";
tempi+=">";
tempi+="<select name='stime' onClick='javascript:hastimeOn()' onchange='javascript:forcetime1()'>";
var ts=fullTimesToString(0,24+_TIMEINTERVAL);
for(var i=0;i<ts.length;i++)
{
	tempi+="<option value="+i*_TIMEINTERVAL;
	if(event.stime==i*_TIMEINTERVAL)tempi+=" selected";tempi+=">"+ts[i]+"</option>";
}
tempi+="</select>";
tempi+=" To ";
tempi+="<select name='etime' onClick='javascript:hastimeOn()' onchange='javascript:forcetime2()'>";
var ts=fullTimesToString(0,24+_TIMEINTERVAL);
for(var i=0;i<ts.length;i++)
{
	tempi+="<option value="+i*_TIMEINTERVAL;
	if(event.etime==i*_TIMEINTERVAL)tempi+=" selected";tempi+=">"+ts[i]+"</option>";
}
tempi+="</select><br>";
tempi+="<input type='radio' name='hastime'";
if(event.stime==_NOTIME)tempi+=" checked";
tempi+=">No Time";
stime.innerHTML=tempi;
var sdate=document.getElementById("sdate_"+event.id);
sdate.notify=function(month,day,year)
{
	sdate.value=dateToString(new Array(month,day,year),_DATE);
	sdate.day=day;
	sdate.month=month;
	sdate.year=year;
	sdate.firstChild.innerHTML=sdate.value;
	var s=document.getElementById("sdateInput");
	s.value=sdate.value;
};
tempi="<div>date_goes_here</div>";
tempi+="<table><tr>";
tempi+="<div style='margin:2px'><input id='sdateInput' size=10 maxlength=10></div>";
var today=new Date();
var js="javascript:setMiniDate("+(parseInt(today.getMonth())+1)+","+today.getDate()+","+today.getFullYear()+",\""+"sdate_"+event.id+"\");";
js+="changeMiniMonth("+(parseInt(today.getMonth())+1)+","+today.getFullYear()+",'sdate_"+event.id+"',\"minical\","+(parseInt(today.getMonth())+1)+","+today.getDate()+","+today.getFullYear()+")";
tempi+="<div id='sdateToday' style='text-align:center;cursor:pointer;border:1px solid #000;padding:3px;margin:2px;font-size:12px' onmousedown="+js+">Today</div>";tempi+="</td>";
tempi+="<td>";
tempi+="<span id='minical'>"+makeMiniCal(event.smonth,event.sday,event.syear,"sdate_"+event.id,'minical',event.smonth,event.sday,event.syear)+"</span>";
tempi+="</td>";
tempi+="<td>";
tempi+="</tr></table>";
sdate.innerHTML=tempi;
var sdateInput=document.getElementById("sdateInput");
sdateInput.onkeypress=function(a)
{
	a=fixEvent(a);
	if(a.which==13)
	{
		var s=document.getElementById("sdateInput").value;
		var date=parseDateString(s);
		if(date!=null){changeMiniMonth(date[0],date[2],"sdate_"+event.id,'minical',date[0],date[1],date[2]);sdate.notify(date[0],date[1],date[2]);}
	}
}
sdate.notify(event.smonth,event.sday,event.syear);
document.getElementById("sdateToday").onmouseover=divHighlightHandler;
document.getElementById("sdateToday").onmouseout=divUnhighlightHandler;
sdate.firstChild.onmouseover=divHighlightHandler;
sdate.firstChild.onmouseout=divUnhighlightHandler;
sdate.firstChild.style.cursor="pointer";
sdate.childNodes[1].style.display="none";
sdate.firstChild.onmousedown=function()
{
	if(sdate.childNodes[1].style.display=="none")sdate.childNodes[1].style.display="block";
	else sdate.childNodes[1].style.display="none";
};
var privacy=document.getElementById("privacy_"+event.id);
privacy.parentNode.onmouseover=divHighlightHandler;
privacy.parentNode.onmouseout=divUnhighlightHandler;
if(event.priv==1)
{
	privacy.innerHTML="Private";
	privacy.value=2;
}
else if(event.favoriteonly==1)
{
	privacy.innerHTML="Favorites Only";
	privacy.value=1;
}
else{privacy.innerHTML="None";privacy.value=0;}
privacy.style.cursor="pointer";
privacy.onmousedown=function()
{
	if(privacy.value==0)
	{
		privacy.innerHTML="Favorites Only";
		privacy.value=1;
	}
	else if(privacy.value==1)
	{
		privacy.innerHTML="Private";
		privacy.value=2;
	}
	else if(privacy.value==2){privacy.innerHTML="None";privacy.value=0;}
}
var repeat=document.getElementById("repeat_"+event.id);
var repnum=document.getElementById("repnum_"+event.id);
var repend=document.getElementById("repend_"+event.id);
var rep=document.getElementById("rep_"+event.id);
var rependcal=document.getElementById("minical2");
repnum.style.display="";
repend.style.display="";
rependcal.style.display="";
rep.style.display="none";
repeat.value=event.reptype;
if(event.reptype==0)
{
	repeat.innerHTML="None";
	repnum.style.display="none";
	repend.style.display="none";
	rependcal.style.display="none";
}
else if(event.reptype==1)
{
	repeat.innerHTML="Day";
}
else if(event.reptype==2)
{
	repeat.innerHTML="Week";
	rep.style.display="";
}
else if(event.reptype==3)
{
	repeat.innerHTML="Month";
}else if(event.reptype==4)
{
	repeat.innerHTML="Year";
}
repeat.style.cursor="pointer";
repeat.onmouseover=divHighlightHandler;
repeat.onmouseout=divUnhighlightHandler;
repeat.onmousedown=function()
{
	if(repeat.value==0)
	{
		repeat.value=1;
		this.firstChild.nodeValue="Day";
		repnum.style.display="";
		repend.style.display="";
		rependcal.style.display="";
		repnum.setLabel("Day(s)");
	}
	else if(repeat.value==1)
	{
		repeat.value=2;
		this.firstChild.nodeValue="Week";
		rep.style.display="";
		repnum.setLabel("Week(s)");
	}
	else if(repeat.value==2)
	{
		repeat.value=3;
		this.firstChild.nodeValue="Month";
		rep.style.display="none";
		repnum.setLabel("Month(s)");
	}
	else if(repeat.value==3)
	{
		repeat.value=4;
		this.firstChild.nodeValue="Year";
		repnum.setLabel("Year(s)");
	}
	else if(repeat.value==4)
	{
		repeat.value=0;this.firstChild.nodeValue="None";
		repnum.style.display="none";
		repend.style.display="none";
		rependcal.style.display="none";
		rep.style.display="none";
	}
}
if(event.repnum==null)repnum.value=1;
else 
	repnum.value=event.repnum;
var temp1="<table><tr><td>Every <INPUT name='repnum' size=1 value="+repnum.value+"><SPAN></SPAN></td></tr></table>";
repnum.innerHTML=temp1;
repnum.setLabel=function(label)
	{this.getElementsByTagName("SPAN")[0].innerHTML=label;}
if(repeat.value==1)repnum.setLabel("Day(s)");
if(repeat.value==2)repnum.setLabel("Week(s)");
if(repeat.value==3)repnum.setLabel("Month(s)");
if(repeat.value==4)repnum.setLabel("Year(s)");
var edate=parseDateString(event.enddate);
if(event.enddate!=null&&edate!=null)repend.value=dateToString(edate,_DATE);
else 
	repend.value=dateToString(new Array(event.smonth,event.sday,event.syear),_DATE);
temp1="<table><tr>";temp1+="<td>End on: <table><tr><td><input type='radio' name='enddate'";
if(isLargestDate(repend.value,_DATE))temp1+="checked";temp1+=">No end date</td></tr><tr><td><input type='radio' name='enddate'";
if(!isLargestDate(repend.value,_DATE)){temp1+="checked";}
temp1+="><input size=8 id='prefs_repend' value='";
if(isLargestDate(repend.value,_DATE))dateToString(new Array(event.smonth,event.sday,event.syear),_DATE);
else 
	temp1+=repend.value;temp1+="'></td></tr></table></td>";
temp1+="</tr></table>";
repend.innerHTML=temp1;
document.getElementById("prefs_repend").notify=function(month,day,year)
{
	this.value=dateToString(new Array(month,day,year,_DATE));
	document.addevent.enddate[1].checked=true;
}
document.getElementById("prefs_repend").onkeypress=function(a)
{
	a=fixEvent(a);
	if(a.which==13)
	{
		var s=this.value;
		var date=parseDateString(s,_DATE);
		if(date!=null){changeMiniMonth(date[0],date[2],"prefs_repend",'minical2',date[0],date[1],date[2]);}
	}
	document.addevent.enddate[1].checked=true;
}
var enddate;
if(!isLargestDate(repend.value,_DATE))
	enddate=parseDateString(repend.value,_DATE);
else 
	enddate=new Array(event.smonth,event.sday,event.syear);

temp1=makeMiniCal(enddate[0],enddate[1],enddate[2],'prefs_repend','minical2',enddate[0],enddate[1],enddate[2]);
rependcal.innerHTML=temp1;
function checkRepeat(rep,day)
{
	if(rep==null)return "";if(rep&Math.pow(2,day)){return "checked";}
else return "";
}

function getRepeat()
{
	var hash=0;
	if(document.getElementById('week_sun').checked)hash|=1;
	if(document.getElementById('week_mon').checked)hash|=2;
	if(document.getElementById('week_tue').checked)hash|=4;
	if(document.getElementById('week_wed').checked)hash|=8;
	if(document.getElementById('week_thu').checked)hash|=16;
	if(document.getElementById('week_fri').checked)hash|=32;
	if(document.getElementById('week_sat').checked)hash|=64;
	return hash;
}
temp1="<table border=0 cellspacing=0 cellpadding=0><TR align=center>";
temp1+="<TD>Repeat on:</TD>";
temp1+="<TD><input type=checkbox id='week_sun' value='1' "+checkRepeat(event.rep,0)+"></TD>";
temp1+="<TD><input type=checkbox id='week_mon' value='1' "+checkRepeat(event.rep,1)+"></TD>";
temp1+="<TD><input type=checkbox id='week_tue' value='1' "+checkRepeat(event.rep,2)+"></TD>";
temp1+="<TD><input type=checkbox id='week_wed' value='1' "+checkRepeat(event.rep,3)+"></TD>";
temp1+="<TD><input type=checkbox id='week_thu' value='1' "+checkRepeat(event.rep,4)+"></TD>";
temp1+="<TD><input type=checkbox id='week_fri' value='1' "+checkRepeat(event.rep,5)+"></TD>";
temp1+="<TD><input type=checkbox id='week_sat' value='1' "+checkRepeat(event.rep,6)+"></TD>";
temp1+="</TR><TR align=center style='font-size:10px;'><TD>&nbsp;</TD><TD>S</TD><TD>M</TD><TD>T</TD><TD>W</TD><TD>T</TD><TD>F</TD><TD>S</TD></TR></table>";
rep.innerHTML=temp1;
var email=document.getElementById('email');
var email2=document.getElementById('email2');
temp1="<input type=checkbox name='emailnote' value='1'";
if(event.emailnote==1)temp1+=" checked";
temp1+=">";
email.innerHTML=temp1;
email2.innerHTML="Include in daily/weekly emails";
var sms=document.getElementById('sms');
var sms2=document.getElementById('sms2');
temp1="<input type=checkbox name='smsnote' value='1'";
if(event.smsnote==1)temp1+=" checked";
temp1+=">";
sms.innerHTML=temp1;
temp1="通过 <select name='emailorsms' onchange='javascript:forcealert()'><option value=0>SMS</option><option value=1>email</option></select>";
temp1+="在<select name='alertbefore' onchange='javascript:forcealert()'><option value=0>15 分钟</option><option value=1>30 分钟</option><option value=2>1 小时</option><option value=3>2 小时</option><option value=4>4 小时</option><option value=5>1 天</option><option value=6>3 天</option><option value=7>7 天</option></select>前提醒"
sms2.innerHTML=temp1;
if(event.emailorsms!=null)document.addevent.emailorsms[event.emailorsms].selected=true;
if(event.alertbefore!=null)document.addevent.alertbefore[event.alertbefore].selected=true;

var cancelButton=document.getElementById("cancel_"+event.id);
var saveButton=document.getElementById("close_"+event.id);
var deleteButton=document.getElementById("delete_"+event.id);
deleteButton.onmouseover=cancelButton.onmouseover=saveButton.onmouseover=function()
{
	this.style.backgroundColor=_BUTTONHIGHLIGHTCOLOR;
};
deleteButton.onmouseout=cancelButton.onmouseout=saveButton.onmouseout=function(){this.style.backgroundColor=_EDITBOXBGCOLOR;}

saveButton.notify=function(value)
{
	if(value==0)
	{
		sendXMLEditEvent(event,calendar);
		hideEditLayer();
		removeAllEventsFromCalendar(calendar);
		addEventsToCalendar(calendar);
	}
	else if(value==1){sendXMLRepMoveEvent(event,calendar);hideEditLayer();}
	else if(value==2){}
}
saveButton.onmousedown=function()
{
	var error="";if(s1.value=="")error+="\nEvent subject is blank.";
	var sdate=parseDateString(document.getElementById("sdate_"+event.id).value,_DATE);
	if(sdate==null){error+="\nInvalid start date:"+document.getElementById("sdate_"+event.id).value};
	var edate=parseDateString(document.getElementById("prefs_repend").value,_DATE);
	if(repeat.value!=0&&edate==null&&document.addevent.enddate[1].checked)
	{
		error+="\nInvalid end date:"+document.getElementById("prefs_repend").value
	};
	if(repeat.value!=0&&edate!=null&&sdate!=null&&document.addevent.enddate[1].checked&&dateBefore(edate[0]+"/"+edate[1]+"/"+edate[2],sdate[0]+"/"+sdate[1]+"/"+sdate[2]))
		error+="\nEvent end date "+document.getElementById("prefs_repend").value+" cannot be before start date "+document.getElementById("sdate_"+event.id).value+".";
	if(repeat.value!=0&&document.addevent.repnum.value==0)
		error+="\nEvent cannot be repeated 0 times.";
	if(repeat.value==2&&getRepeat()==0)
		error+="\nRepeat By Week is currently set to repeat on no days.  Please specify which days of the week to repeat on.";
	if(error!=""){alert("Error!"+error);return;}
	
event.subject=s1.value;
event.eventdesc=s2.value;
event.catid=catname.idvalue;
event.catname=catname.value;
event.catcolor=catcolor.value;
if(document.addevent.hastime[0].checked==true)
{
	event.stime=document.addevent.stime.value;
	event.etime=document.addevent.etime.value;
}
else{event.stime=_NOTIME;event.etime=_NOTIME;}

var d=parseDateString(document.getElementById("sdate_"+event.id).value,_DATE);
if(d==null){alert("Error!\nInvalid date:"+document.getElementById("sdate_"+event.id).value);return}

event.olddate=new Array(event.smonth,event.sday,event.syear);
event.smonth=d[0];event.sday=d[1];
event.syear=d[2];
event.favoriteonly=0;event.priv=0;
if(privacy.value==1)event.favoriteonly=1;
if(privacy.value==2)event.priv=1;

var oldreptype=event.reptype;
event.reptype=repeat.value;
event.repnum=document.addevent.repnum.value;
if(event.reptype==2)
{
	event.rep=getRepeat();
}
else if(event.reptype==0){event.startdate=event.enddate=event.smonth+"/"+event.sday+"/"+event.syear;}

if(document.addevent.enddate[1].checked)
{
	event.enddate=edate[0]+"/"+edate[1]+"/"+edate[2];
}
else if(document.addevent.enddate[0].checked){event.enddate=_LARGESTDATE;}

if(document.addevent.emailnote.checked)
	event.emailnote=1;
else 
	event.emailnote=0;
if(document.addevent.smsnote.checked)
	event.smsnote=1;
else 
	event.smsnote=0;

event.emailorsms=document.addevent.emailorsms.value;
event.alertbefore=document.addevent.alertbefore.value;
hideEditLayer();
if(newevent)
{
	sendXMLAddEvent(event,calendar);
	removeAllEventsFromCalendar(calendar);
	addEventsToCalendar(calendar);
}
else
{
	if(oldreptype!=0)
	{
		dialogBox("<div style='font-size:12px'>This event is repeated.<br>I want to save changes for:</div>",new Array("All occurrences","Just this occurrence","Cancel"),saveButton,100,400);
	}
	else if(sendXMLEditEvent(event,calendar)){}
	else{alert("Error in saving event.");}
	
	if(event.reptype!=0)
	{
		removeAllEventsFromCalendar(calendar);
		addEventsToCalendar(calendar);
	}
	else
		refreshEvent(event,cellNode,calendar);
}
}
cancelButton.onmousedown=function(){hideEditLayer();}
if(newevent)deleteButton.style.display="none";
deleteButton.notify=function(value)
{
	if(value==0)
	{
		sendXMLDeleteEvent(event,calendar);
		hideEditLayer();
		removeAllEventsFromCalendar(calendar);
		addEventsToCalendar(calendar);
	}
	else if(value==1)	
	{
		sendXMLRepDeleteEvent(event,calendar);
		hideEditLayer();
		removeAllEventsFromCalendar(calendar);
		addEventsToCalendar(calendar);
	}
	else if(value==2)
	{
		var daybefore=dayBefore(new Array(event.smonth,event.sday,event.syear));
		event.enddate=daybefore[0]+"/"+daybefore[1]+"/"+daybefore[2];
		sendXMLEditEvent(event,calendar);
		hideEditLayer();
		removeAllEventsFromCalendar(calendar);
		addEventsToCalendar(calendar);
	}else if(value==3){}
}
deleteButton.onmousedown=function()
{
	if(event.reptype!=0)
	{
		dialogBox("<div style='font-size:12px'>This event is repeated.<br>Which ones do you want to delete?</div>",new Array("All occurrences","Just this occurrence","Future occurrences","Cancel"),deleteButton,100,450);
	}
	else if(confirm("Delete event?"))
	{
		if(sendXMLDeleteEvent(event,calendar))
		{
			if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
				removeDOMEvent(cellNode,calendar);
			else if(calendar.view==_MONTHVIEW)
			{
				removeDOMEvent(cellNode,calendar);
			}
			hideEditLayer();
		}
		else{alert("Error in deleting event.");}
	}
}
deleteButton.style.cursor=saveButton.style.cursor=cancelButton.style.cursor="pointer";
deleteButton.style.border=saveButton.style.border=cancelButton.style.border="1px solid #000000";
deleteButton.align=saveButton.align=cancelButton.align="center";
}

function hideEditLayer()
{
	if(editLayerDiv!=null)
	{
		if(editLayerDiv.childNodes.length >0)
			editLayerDiv.removeChild(editLayerDiv.firstChild);
		editLayerDiv.style.display="none";
	}
}

var _DEBUG=false;
var _DEBUG2=false;
var _DEBUG3=false;
var categoryInfo={"defcatid":null,"cats":null};
var c={"closestCell":null,"lastMouseX":0,"lastMouseY":0,"highlightedCells":null,"activeMonthNode":null};
var EVENTLIST_XML;
var EVENTLIST_XML_PREV;
var EVENTLIST_XML_NEXT;
var EVENTLIST_MONTH=null;
var EVENTLIST_YEAR=null;
function preventContextMenu(a)
{
	a=fixEvent(a);
	if(a.button==2){a.preventDefault();}
}

var isSafari;
var isMoz;
var isIE;

//初始化日历
function initCalendar()
{
	if(navigator.userAgent.indexOf("Safari")> 0){isSafari=true;isMoz=false;isIE=false;}
	else if(navigator.product=="Gecko"){isSafari=false;isMoz=true;isIE=false;}
	else{isSafari=false;isMoz=false;isIE=true;}
	if(isIE)
	{
		document.body.onselectstart=function(a)
		{
			a=fixEvent(a);
			if(a.target.tagName=="INPUT"||a.target.tagName=="TEXTAREA")
				return true;
			else 
				return false;
		};
	}
	if(isMoz)
		document.addEventListener("click",preventContextMenu,false);
	else if(isIE)
		document.attachEvent("contextmenu",preventContextMenu);
}
//得到分类信息
function getCatInfo()
{
	var parser = new ActiveXObject('Microsoft.XMLDOM');
	parser.async = false;
	if(parser.readyState!=4)
	{			
		parser.onreadystatechange= false;
	}   
	parser.load( "eventcat.xml" );
	categoryInfo.defcatid=parser.firstChild.getAttribute("defcatid");
	var cats=parser.getElementsByTagName("cat");
	categoryInfo.cats=new Array(cats.length);
	for(var i=0;i<cats.length;i++)
	{
		categoryInfo.cats[i]=makeCategory(cats[i].getAttribute("id"),cats[i].getAttribute("name"),cats[i].getAttribute("color"));
	}
	setStatusDiv("&nbsp;Retrieved user category information.&nbsp;");
}

function getCatInfo1(){var url=_REQHOST;url+="?a=event&req=xmlcat";sendCatReq(url);}
function handleCatReq(httpObj)
{
	if(httpObj.readyState==4&&httpObj.status==200)
	{
		results=httpObj.responseText;
		if(_DEBUG2)alert("handleCatReq received:\n"+results);
		var parser=getXMLParser(results);
		categoryInfo.defcatid=parser.firstChild.getAttribute("defcatid");
		var cats=parser.getElementsByTagName("cat");
		categoryInfo.cats=new Array(cats.length);
		for(var i=0;i<cats.length;i++)
		{
			categoryInfo.cats[i]=makeCategory(cats[i].getAttribute("id"),cats[i].getAttribute("name"),cats[i].getAttribute("color"));
		}
		setStatusDiv("&nbsp;Retrieved user category information.&nbsp;");
	}
}
//获取默认分类
function getDefaultCat()
{
	for(var i=0;i<categoryInfo.cats.length;i++)
	{
		if(categoryInfo.cats[i].id==categoryInfo.defcatid)
			return categoryInfo.cats[i];
	}
	return null;
}
//生成分类
function makeCategory(id,name,color){var cat={"id":id,"name":name,"color":color};return cat;}
function sendCatReq(url){try{var http=getHTTPObject();if(http){if(_DEBUG2)alert("Sending: "+url);http.open("GET",url,true);http.onreadystatechange=function(){handleCatReq(http)};http.send(null);}
}catch(e){alert("firefox jacks up..."+e);}
}
//xmlhttp对象
function getHTTPObject(){var xmlhttp;/*@cc_on
  @if (@_jscript_version >= 5)
    try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
        xmlhttp = false;
      }
    }
  @else
  xmlhttp = false;
  @end @*/
if(!xmlhttp&&typeof XMLHttpRequest!='undefined'){try{xmlhttp=new XMLHttpRequest();}catch(e){xmlhttp=false;}
}
return xmlhttp;}

function isRenderPrevMonth(calendar){if(calendar.view==_DAYVIEW){return false;}
else if(calendar.view==_MONTHVIEW){return false;}
else if(calendar.view==_WEEKVIEW){var startweek=getWeekDate(0,calendar.month,calendar.day,calendar.year);var endweek=getWeekDate(6,calendar.month,calendar.day,calendar.year);if(startweek[0]!=endweek[0]){return true;}
return false;}
return false;}
function isRenderNextMonth(calendar){if(calendar.view==_DAYVIEW){return false;}
else if(calendar.view==_MONTHVIEW){return false;}
else if(calendar.view==_WEEKVIEW){var startweek=getWeekDate(0,calendar.month,calendar.day,calendar.year);var endweek=getWeekDate(6,calendar.month,calendar.day,calendar.year);if(startweek[0]!=endweek[0]){return true;}
return false;}
return false;}
function handleCalHttp(http,calendar,type,month,year){if(http.readyState==4&&http.status==200){results=http.responseText;if(_DEBUG2)alert("handleCalHttp received:\n"+results);if(type=="this"){EVENTLIST_XML=createEvents(results);EVENTLIST_MONTH=month;EVENTLIST_YEAR=year;var date=new Array(year,month,1);var exploded=ConvertEventsByMonth(EVENTLIST_XML,date);addEvents(exploded,calendar);setStatusDiv("&nbsp;Done!&nbsp;");}
else if(type=="prev"){EVENTLIST_XML_PREV=createEvents(results);var date=new Array(year,month,1);var exploded=ConvertEventsByMonth(EVENTLIST_XML_PREV,date);if(isRenderPrevMonth(calendar)){addEvents(exploded,calendar);setStatusDiv("&nbsp;Done!&nbsp;");}
}
else if(type=="next"){EVENTLIST_XML_NEXT=createEvents(results);var date=new Array(year,month,1);var exploded=ConvertEventsByMonth(EVENTLIST_XML_NEXT,date);if(isRenderNextMonth(calendar)){addEvents(exploded,calendar);setStatusDiv("&nbsp;Done!&nbsp;");}
}
}
}
function makeCalHttp(url,calendar,type,month,year)
{
	url = "GetContent.aspx"
	var http=getHTTPObject();
	try{if(http)
	{
		if(_DEBUG2)alert("Sending: "+url);
		http.open("GET",url,true);
		http.onreadystatechange=function()
		{
			handleCalHttp(http,calendar,type,month,year)};
			http.send(null);
		}
	}catch(e){alert("firefox jacks up..."+e);}
}
function sendXML(event,url,calendar)
{
	var http=getHTTPObject();
	try{
			if(http)
			{
				if(_DEBUG2)alert("Sending: "+url.replace(/&/g,' &'));
				setStatusDiv("&nbsp;Updating your calendar...&nbsp;");
				http.open("GET",url,true);
				http.onreadystatechange=function(){readReturn(http,calendar);};
				http.send(null);
			}
		}catch(e){alert("firefox jacks up2..."+e);}
}

//添加日历事件
function addEventsToCalendar(calendar)
{
	var month=calendar.month;
	var day=calendar.day;
	var year=calendar.year;
	var reqstr='xml';
	if(_CALENDAR_REQMODE=='plan')
		{reqstr='planxml';}

	function eventlist_undefined(elist)
	{
		if(typeof(elist)=='undefined')
			{return true;}
		return false;
	}
	
	function eventlist_stale()
	{
		if(calendar.month!=EVENTLIST_MONTH||calendar.year!=EVENTLIST_YEAR)
			{return true;}
		return false;
	}
	
	var pdate=monthBefore(new Array(month,year));
	var ndate=monthAfter(new Array(month,year));
	var pmonth=pdate[0];
	var pyear=pdate[1];
	var nmonth=ndate[0];
	var nyear=ndate[1];
	var date=new Array(calendar.year,calendar.month,1);
	var date_prev=new Array(pyear,pmonth,1);
	var date_next=new Array(nyear,nmonth,1);

	function makeThisMonthHttp(){var url=_REQHOST;url+='?a=ajax&req='+reqstr+'&m='+month+'&d='+day+'&y='+year;url+="&hash="+Math.random();if(_DEBUG)alert("ajax request: "+url);setStatusDiv("&nbsp;Loading calendar...&nbsp;");makeCalHttp(url,calendar,"this",month,year);}
	function makeNextMonthHttp(){var urlnext=_REQHOST;urlnext+='?a=ajax&req='+reqstr+'&m='+nmonth+'&d=1'+'&y='+nyear+'&prefetch=1';urlnext+="&hash="+Math.random();if(_DEBUG)alert("ajax request: "+urlnext);makeCalHttp(urlnext,calendar,"next",nmonth,nyear);}
	function makePrevMonthHttp(){var urlprev=_REQHOST;urlprev+='?a=ajax&req='+reqstr+'&m='+pmonth+'&d=1'+'&y='+pyear+'&prefetch=1';urlprev+="&hash="+Math.random();if(_DEBUG)alert("ajax request: "+urlprev);makeCalHttp(urlprev,calendar,"prev",pmonth,pyear);}
	function renderThisMonth(){var exploded=ConvertEventsByMonth(EVENTLIST_XML,date);addEvents(exploded,calendar);}
	function renderPrevMonth(){var exploded_prev=ConvertEventsByMonth(EVENTLIST_XML_PREV,date_prev);addEvents(exploded_prev,calendar);}
	function renderNextMonth(){var exploded_next=ConvertEventsByMonth(EVENTLIST_XML_NEXT,date_next);addEvents(exploded_next,calendar);}

	if(eventlist_undefined(EVENTLIST_XML))
	{
		makeThisMonthHttp();makeNextMonthHttp();makePrevMonthHttp();
	}
	else if(eventlist_stale())
	{
	var xml_pdate=monthBefore(new Array(EVENTLIST_MONTH,EVENTLIST_YEAR));
	var xml_ndate=monthAfter(new Array(EVENTLIST_MONTH,EVENTLIST_YEAR));
	var xml_pmonth=xml_pdate[0];
	var xml_pyear=xml_pdate[1];
	var xml_nmonth=xml_ndate[0];
	var xml_nyear=xml_ndate[1];
	if(calendar.month==xml_pmonth&&calendar.year==xml_pyear&&!eventlist_undefined(EVENTLIST_XML_PREV))
	{EVENTLIST_XML_NEXT=EVENTLIST_XML;EVENTLIST_XML=EVENTLIST_XML_PREV;makePrevMonthHttp();EVENTLIST_MONTH=month;EVENTLIST_YEAR=year;renderThisMonth();if(isRenderNextMonth(calendar)){renderNextMonth();}
	}
	else if(calendar.month==xml_nmonth&&calendar.year==xml_nyear&&!eventlist_undefined(EVENTLIST_XML_NEXT))
	{
		EVENTLIST_XML_PREV=EVENTLIST_XML;EVENTLIST_XML=EVENTLIST_XML_NEXT;makeNextMonthHttp();EVENTLIST_MONTH=month;EVENTLIST_YEAR=year;renderThisMonth();
		if(isRenderPrevMonth(calendar)){renderPrevMonth();}
	}
	else{makeThisMonthHttp();makeNextMonthHttp();makePrevMonthHttp();}
	}
	else
	{
		setStatusDiv("&nbsp;PreLoading calendar...&nbsp;");
		renderThisMonth();
		if(isRenderNextMonth(calendar)){renderNextMonth();}
		if(isRenderPrevMonth(calendar)){renderPrevMonth();}
		setStatusDiv("&nbsp;Done!&nbsp;");
	}
}
//从日历上删除所有事件
function removeAllEventsFromCalendar(calendar)
{
	if(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW)
	{
		for(var i=0;i<calendar.numrows;i++)
		{
			for(var j=0;j<calendar.numrcols;j++)
			{
				var td=getTD(i,j,calendar,true);
				if(td==null)continue;
				if(!td.empty)removeCell(td.firstChild,calendar);
			}
		}
		if(calendar.hasTimelessRow)
		{
			for(var j=0;j<calendar.numvcols;j++)
			{
				var td=getTD(_TIMELESSROW,j,calendar,true);
				if(td==null)continue;
				if(!td.empty)
				{
					while(td.childNodes.length > 0)
						{td.removeChild(td.lastChild);}
					td.empty=true;
					var img=document.createElement("IMG");
					img.height=img.width=1;
					td.appendChild(img);
				}
			}
		}
	}
	else if(calendar.view==_MONTHVIEW)
	{
		for(var i=0;i<calendar.numrows;i++)
		{
			for(var j=0;j<calendar.numrcols;j++)
			{
				var td=getTD(i,j,calendar,true);
				if(td==null||td.isEmpty)continue;
				while(td.firstChild.childNodes.length > 1)
					{removeDOMEvent(td.firstChild.lastChild,calendar);}
			}
		}
	}
}

//事件ID列表更新
function EventListId_Update(event)
{
	function isRightEvent(e)
	{
		if(e.id==0&&event.subject==e.subject&&event.stime==e.stime&&event.etime==e.etime&&event.sday==e.sday&&event.smonth==e.smonth&&event.syear==e.syear)
			{return true;}
		return false;
	}
	for(var i=0;i<EVENTLIST_XML.length;i++)
	{
		var e=EVENTLIST_XML[i];
		if(isRightEvent(e))
			{e.id=event.id;break;}
	}
	
	if(EventList_inPrev(event))
	{
		for(var i=0;i<EVENTLIST_XML_PREV.length;i++)
		{
			var e=EVENTLIST_XML_PREV[i];
			if(isRightEvent(e)){e.id=event.id;break;}
		}
	}

	if(EventList_inNext(event))
	{
		for(var i=0;i<EVENTLIST_XML_NEXT.length;i++)
		{
			var e=EVENTLIST_XML_NEXT[i];
			if(isRightEvent(e))
				{e.id=event.id;break;}
		}
	}
}
//返回
function readReturn(http,calendar)
{
	if(http.readyState==4&&http.status==200)
	{
		results=http.responseText;
		if(_DEBUG2)alert("readReturn received:\n"+results);
		var parser=getXMLParser(results);
		if(parser.firstChild == null || parser.firstChild.tagName=="badevent")
		{
			alert("操作失败，服务器无响应。请稍等片刻再试！");
			return;
		}
		var reqtype="";
		if(parser.getElementsByTagName("event").length > 0)
			reqtype=parser.getElementsByTagName("event")[0].getAttribute("reqtype");
		if(reqtype=="new"||reqtype=="repmove")
		{
			var subject=parser.getElementsByTagName("eventval")[0].getAttribute("subject");
			var stime=parser.getElementsByTagName("time")[0].getAttribute("stime");
			var etime=parser.getElementsByTagName("time")[0].getAttribute("etime");
			var sday=parser.getElementsByTagName("date")[0].getAttribute("sday");
			var smonth=parser.getElementsByTagName("date")[0].getAttribute("smonth");
			var syear=parser.getElementsByTagName("date")[0].getAttribute("syear");
			var startdate=convertDateStringIn(parser.getElementsByTagName("date")[0].getAttribute("startdate"));
			var enddate=convertDateStringIn(parser.getElementsByTagName("date")[0].getAttribute("enddate"));
			var event=makeBlankEvent();
			event.id=parser.getElementsByTagName("event")[0].getAttribute("id");
			event.subject=subject;
			event.stime=timeToDecimal(stime);
			event.etime=timeToDecimal(etime);
			event.sday=sday;
			event.smonth=smonth;
			event.syear=syear;
			event.startdate=startdate;
			event.enddate=enddate;
			EventListId_Update(event);
			removeAllEventsFromCalendar(calendar);
			addEventsToCalendar(calendar);
		}
		else if(reqtype=="mod"){}
		else if(reqtype=="del"){}
		setStatusDiv("&nbsp;Updated.&nbsp;");
	}
}
//xml相关 
function sendXMLRepDeleteEvent(event,calendar){if(_DEBUG)alert("repdel\n "+eventToString(event));var url=_REQHOST;url+="?a=event&req=repdel&id="+event.id;url+="&excludedate="+event.syear+"-"+event.smonth+"-"+event.sday;sendXML(event,url,calendar);EventList_Update("repdel",event,event.smonth+"/"+event.sday+"/"+event.syear);return true;}
function sendXMLDeleteEvent(event,calendar){if(_DEBUG)alert("del\n "+eventToString(event));var url=_REQHOST;url+="?a=event&req=del&id="+event.id;sendXML(event,url,calendar);EventList_Update("del",event,null);return true;}
function sendXMLAddEvent(event,calendar)
{
	if(_DEBUG)alert("add\n "+eventToString(event));
	var url=_REQHOST;url+="?a=event&req=new";
	url+=makeEventPostURLString(event);
	sendXML(event,url,calendar);
	EventList_Update("new",event,null);
	return true;
}
//事件发送
function sendXMLResizeEvent(event,calendar)
{
	if(_DEBUG)alert("resize\n "+eventToString(event));
	sendXMLReqMod(event,calendar);
	return true;
}
function sendXMLMoveEvent(event,calendar)
{
	if(_DEBUG)alert("move\n "+eventToString(event));
	sendXMLReqMod(event,calendar);
	return true;
}
function sendXMLRepMoveEvent(event,calendar){if(_DEBUG)alert("repmove\n "+eventToString(event));var url=_REQHOST;url+="?a=event&req=repmove";url+="&excludedate="+event.olddate[2]+"-"+event.olddate[0]+"-"+event.olddate[1];url+=makeEventPostURLString(event);sendXML(event,url,calendar);EventList_Update("repmove",event,event.olddate[0]+"/"+event.olddate[1]+"/"+event.olddate[2]);return true;}

//此处需要处理ssfok
function sendXMLReqMod(event,calendar)
{
	try
	{
		var url=_REQHOST;
		var cevent=copyEvent(event);
		var startdate=parseDateString(event.startdate);
		if(cevent.reptype!=0)
		{
			cevent.smonth=startdate[0];
			cevent.sday=startdate[1];
			cevent.syear=startdate[2];
		}
		url+="?a=event&req=mod";
		url+=makeEventPostURLString(cevent);
		sendXML(event,url,calendar);
		EventList_Update("mod",cevent,null);
	}
	catch(er){}
}
function sendXMLEditEvent(event,calendar){if(_DEBUG)alert("edit\n "+eventToString(event));sendXMLReqMod(event,calendar);return true;}
function makeEventPostURLString(event)
{
	url="&subject="+encodeURIComponent(event.subject);
	url+="&id="+event.id;
	if(event.eventdesc!=null)url+="&eventdesc="+encodeURIComponent(event.eventdesc);
	if(event.catid!=null)url+="&catid="+event.catid;
	if(event.catcolor!=null)url+="&catcolor="+event.catcolor;
	if(event.catname!=null)url+="&catname="+encodeURIComponent(event.catname);
	url+="&stime="+timeTo60(event.stime);
	url+="&etime="+timeTo60(event.etime);
	url+="&sday="+event.sday;
	url+="&smonth="+event.smonth;
	url+="&syear="+event.syear;
	if(event.priv!=null)url+="&private="+event.priv;
	if(event.favoriteonly!=null)url+="&favoriteonly="+event.favoriteonly;
	if(event.reptype!=null)url+="&reptype="+event.reptype;
	if(event.repnum!=null)url+="&repnum="+event.repnum;
	if(event.rep!=null)url+="&rep="+event.rep;
	if(event.emailnote!=null)url+="&emailnote="+event.emailnote;
	if(event.smsnote!=null)url+="&smsnote="+event.smsnote;
	if(event.emailorsms!=null)url+="&emailorsms="+event.emailorsms;
	if(event.alertbefore!=null)url+="&alertbefore="+event.alertbefore;
	if(event.startdate!=null)url+="&startdate="+convertDateStringOut(event.startdate);
	if(event.enddate!=null)url+="&enddate="+convertDateStringOut(event.enddate);
	return url;
}

//生成事件
function createEvents(XMLStream)
{
	var parser=getXMLParser(XMLStream);
	var eventsList=parser.getElementsByTagName("event");
	var events=new Array(eventsList.length);
	if(_DEBUG)alert("createEvents: found "+eventsList.length+" events");
	for(var i=0;i<eventsList.length;i++)
	{
		var xEventVal=eventsList[i].getElementsByTagName("eventval")[0];
		var xCat=eventsList[i].getElementsByTagName("cat")[0];
		var xTime=eventsList[i].getElementsByTagName("time")[0];
		var xDate=eventsList[i].getElementsByTagName("date")[0];
		var xRep=eventsList[i].getElementsByTagName("rep")[0];
		var xExcludes=eventsList[i].getElementsByTagName("excludes")[0];
		var xNotif=eventsList[i].getElementsByTagName("notification")[0];
		var id=eventsList[i].getAttribute("id");
		var priv=eventsList[i].getAttribute("private");
		var favoriteonly=eventsList[i].getAttribute("favoriteonly");
		var subject=xEventVal.getAttribute("subject");
		var eventdesc=xEventVal.getAttribute("eventdesc");
		var catid=xCat.getAttribute("catid");
		var catname=xCat.getAttribute("catname");
		var catcolor=xCat.getAttribute("catcolor");
		var stime=xTime.getAttribute("stime");
		var etime=xTime.getAttribute("etime");
		var sday=xDate.getAttribute("sday");
		var sweek=xDate.getAttribute("sweek");
		var smonth=xDate.getAttribute("smonth");
		var syear=xDate.getAttribute("syear");
		var startdate=convertDateStringIn(xDate.getAttribute("startdate"));
		var enddate=convertDateStringIn(xDate.getAttribute("enddate"));
		var reptype=xRep.getAttribute("reptype");
		var repnum=xRep.getAttribute("repnum");
		var rep=xRep.getAttribute("reps");
		var hasexclude=xRep.getAttribute("hasexclude");
		var excludes=null;
		if(hasexclude=="1")
		{
			var exs=xExcludes.getElementsByTagName("ex");
			excludes=new Array(exs.length);
			for(var j=0;j<excludes.length;j++)
			{excludes[j]=convertDateStringIn(exs[j].getAttribute("exdate"));}
		}

		var emailnote=xNotif.getAttribute("emailnote");
		var smsnote=xNotif.getAttribute("smsnote");
		var emailorsms=xNotif.getAttribute("emailorsms");
		var alertbefore=xNotif.getAttribute("alertbefore");

		events[i]=makeEvent(id,subject,eventdesc,catid,catname,catcolor,stime,etime,sday,sweek,smonth,syear,
		startdate,enddate,reptype,repnum,rep,hasexclude,excludes,priv,favoriteonly,emailnote,smsnote,emailorsms,alertbefore);
	}
	return events;
}

//生成Grid
function makeGrid(rows,cols,height,width,parent)
{
	var t=document.createElement("TABLE");
	t.parent=parent;t.align="center";
	t.cellPadding="0";
	t.cellSpacing="0";
	t.numrows=rows;
	t.numvcols=cols;
	t.numrcols=cols;
	t.hasRowHeaders=false;
	t.hasColHeaders=false;
	t.hasTimelessRow=false;
	var tb=document.createElement("TBODY");
	t.appendChild(tb);
	for(var i=0;i < rows;i++)
	{
		var tr=document.createElement("TR");
		for(var j=0;j < cols;j++)
		{
			var td=makeTD(i,i,j,height,width);
			tr.appendChild(td);
		}
		tb.appendChild(tr);
	}
	
	t.setBackground=function(url)
		{this.style.backgroundImage="url('"+url+"')";}
	document.getElementById(parent).appendChild(t);
	return t;
}

function spawnNewRowAt(row,grid,headername)
{
	Assert(row >=0&&row <=grid.numrows,"cannot spawn new row at "+row);
	var cols=grid.numrcols;
	var tb=grid.getElementsByTagName("TBODY")[0];
	var tr=document.createElement("TR");
	if(grid.hasRowHeaders)
	{
		var header=makeHeader(row,-1,headername)
		header.style.textAlign="right";
		tr.appendChild(header);
	}
	for(var j=0;j < cols;j++)
	{
		var td=makeTD(row,row,j,_CELLHEIGHTPX+1,_CELLWIDTHPX);
		tr.appendChild(td);
	}
	if(row==grid.numrows)
		{tb.appendChild(tr);}
	else if(row==0)
		{tb.insertBefore(tr,getTR(row,grid));}
	else{
		alert("spawnNewRowAt: sorry, can't add to row:"+row+" yet!");
		return;	}
}
//生成TD
function makeTD(rowstart,rowend,realcol,height,width)
{
	var td=document.createElement("TD");
	td.vAlign="top";
	td.style.height=height;
	td.style.width=width;
	td.rowstart=rowstart;
	td.rowend=rowend;
	td.rcol=realcol;
	td.empty=true;
	td.style.borderLeft=_CELLBORDERSTYLE;
	td.style.borderTop=_CELLBORDERSTYLE;
	td.borderLeftO=_CELLBORDERSTYLE;
	td.borderTopO=_CELLBORDERSTYLE;
	td.style.borderBottom="0px";
	td.style.borderRight="0px";
	td.style.overflow="auto";
	var img=document.createElement("IMG");
	img.height=1;img.width=1;
	var dbg=document.createTextNode(rowstart+","+realcol);
	if(_DEBUG)
		td.appendChild(dbg);
	else 
		td.appendChild(img);
	return td;
}
//生成头部
function makeHeader(row,col,name)
{
	var td=document.createElement("TD");
	td.rowSpan=1;
	td.colSpan=1;
	td.rowstart=row;
	td.rowend=row;
	td.rcol=col;
	td.empty=false;
	td.vAlign="top";
	td.style.border=_HEADERBORDERSTYLE;
	td.style.textAlign="center";
	td.style.width=_CELLWIDTHPX;
	td.style.height=_CELLHEIGHTPX+1;
	td.style.backgroundColor=_DARKERHEADERCOLOR;
	var div=document.createElement("DIV");
	div.style.fontSize="10px";
	div.style.position="relative";
	div.style.fontFamily=_USERFONT;
	div.innerHTML=name;
	td.appendChild(div);
	return td;
}
//生成行头
function addRowHeadings(names,grid)
{
	Assert(names.length==grid.numrows,"addRowHeadings:namelength does not match grid length!");
	var tb=grid.childNodes[0];
	if(grid.hasColHeaders)
	{
		tb.firstChild.insertBefore(makeHeader(-1,-1," "));
	}

	for(var i=0;i<grid.numrows;i++)
	{
		var header=makeHeader(i,-1,names[i]);
		header.style.textAlign="right";
		if(grid.hasColHeaders)
		{
			for(var j=0;j<grid.numvcols;j++)
			{
				getColHeader(j,grid).width=parseInt(100/(grid.numvcols+1))+"%";
			}
			tb.childNodes[i+1].insertBefore(header,tb.childNodes[i+1].firstChild);
		}
		else
		{
			tb.childNodes[i].insertBefore(header,tb.childNodes[i].firstChild);
		}		
	}
	grid.hasRowHeaders=true;
}
//增加行头
function changeRowHeadings(names,grid)
{
	Assert(grid.hasRowHeaders,"changeRowHeadings: grid has no row headings!");
	Assert(names.length==grid.numrows,"changeRowHeadings:namelength does not match grid length!");
	for(var i=0;i<grid.numrows;i++)
	{
		var rh=getRowHeader(i,grid);
		rh.firstChild.innerHTML=names[i];
	}
}
//增加头列
function addColHeadings(names,grid)
{
	Assert(names.length==grid.numvcols,"addColHeadings:namelength does not match grid length!");
	var tb=grid.childNodes[0];
	var tr=document.createElement("TR");
	if(grid.hasRowHeaders)
		tr.appendChild(makeHeader(-1,-1," "));
	for(var i=0;i<grid.numvcols;i++)
	{
		var header=makeHeader(-1,i,names[i]);
		header.style.padding="2px";
		tr.appendChild(header);
	}
	tb.insertBefore(tr,tb.firstChild);
	grid.hasColHeaders=true;
}

function changeColHeadings(names,grid)
{
	Assert(grid.hasColHeaders,"changeColHeadings: grid has no col headings!");
	Assert(names.length==grid.numvcols,"changeColHeadings:namelength does not match grid length!");
	for(var i=0;i<grid.numvcols;i++)
	{
		var rh=getColHeader(i,grid);
		rh.firstChild.firstChild.nodeValue=names[i];
	}
}
//获取TD
function getTD(row,realcol,grid,includeHiddenTDs)
{
	var col=realcol;
	if(grid.hasRowHeaders)col++;
	if(!includeHiddenTDs)
	{
		if(row==_TIMELESSROW)
		{
			return getTR(row,grid).childNodes[col];
		}
		for(var i=0;i<grid.numrows;i++)
		{
			var tr=getTR(i,grid);
			if(row <=tr.childNodes[col].rowend&&row >=tr.childNodes[col].rowstart)
				{return tr.childNodes[col];}
		}
	}
	else
	{
		var tr=getTR(row,grid);
		if(tr==null){if(_DEBUG)alert("getTD: could not find TR row,realcol:"+row+","+realcol);return null;}
		else return tr.childNodes[col];
	}
	if(_DEBUG)alert("getTD: could not find cell at "+row+","+col);
	
	return null;
}

function getTDs(row,vcol,grid)
{
	Assert(grid.hasColHeaders,"getTDs: grid has no col headers!");
	var b=getRCol(vcol,grid);
	var a=new Array(b.length);
	for(var i=0;i < b.length;i++){a[i]=getTD(row,b[i],grid,false);}
	return a;
}

//获取TR
function getTR(row,grid)
{
	var r=row;
	if(grid.hasColHeaders)
		r++;
	if(grid.hasTimelessRow)
		r++;
	if(row==_TIMELESSROW)
	{
		return grid.firstChild.childNodes[grid.hasColHeaders?1:0];
	}
	else if(row==-1)
	{
		return grid.firstChild.childNodes[0];
	}
	else 
		return grid.firstChild.childNodes[r];
}

function appendCell(row,vcol,DOMNode,grid){var cell=getTD(row,vcol,grid,true);var img=cell.getElementsByTagName("IMG")[0];if(img!=null)cell.removeChild(img);cell.appendChild(DOMNode);cell.empty=false;}
//月日历增加单元
function addCell(rowstart,rowstop,vcol,preferredRCol,DOMNode,grid)
{
	var rs=getRCol(vcol,grid);
	var rcol=null;
	if(preferredRCol >=rs[0]&&preferredRCol <=rs[rs.length-1])
		{rcol=preferredRCol;}
	else 
		rcol=rs[0];
	if(isEmpty(rowstart,rowstop,rcol,grid))
	{
		for(var i=rowstart+1;i<=rowstop;i++)
			{getTD(i,rcol,grid,false).style.display="none";}
		var cell=getTD(rowstart,rcol,grid,false);
		cell.rowstart=rowstart;
		cell.rowend=rowstop;
		cell.empty=false;
		cell.rowSpan=rowstop-rowstart+1;
		cell.appendChild(DOMNode);
		var img=cell.getElementsByTagName("IMG")[0];
		if(img!=null)cell.removeChild(img);return;
	}
	
	for(var j=0;j<rs.length;j++)
	{
		if(isEmpty(rowstart,rowstop,rs[j],grid))
		{
			for(var i=rowstart+1;i<=rowstop;i++)
			{
				getTD(i,rs[j],grid,false).style.display="none";
			}
			var cell=getTD(rowstart,rs[j],grid,false);
			cell.rowstart=rowstart;
			cell.rowend=rowstop;
			cell.empty=false;
			cell.rowSpan=rowstop-rowstart+1;
			cell.appendChild(DOMNode);
			var img=cell.getElementsByTagName("IMG")[0];
			if(img!=null)cell.removeChild(img);
			return;
		}
	}
	if(preferredRCol!=null)rcol=preferredRCol;
	spawnNewColumnBefore(vcol,rcol,grid);
	addCell(rowstart,rowstop,vcol,preferredRCol,DOMNode,grid);
}
function removeCell(DOMNode,grid){var p=DOMNode.parentNode;if(p.rowSpan > 1){var rcol=p.rcol;for(var i=p.rowstart+1;i<=p.rowend;i++){getTD(i,rcol,grid,true).style.display="";}
p.rowSpan=1;p.rowend=p.rowstart;}
p.empty=true;p.removeChild(DOMNode);var img=document.createElement("IMG");img.height=img.width=1;p.appendChild(img);removeEmptyCols(getVCol(p.rcol,grid),grid);}
function getColHeader(vcol,grid){return getTD(-1,vcol,grid,true);}
function getTimelessTD(vcol,grid){return getTD(_TIMELESSROW,vcol,grid,true);}
function getRowHeader(row,grid){return getTD(row,-1,grid,true);}
function getCornerHeader(grid){return getTD(-1,-1,grid,true);}
function removeEmptyCols(vcol,grid)
{
	Assert(grid.hasColHeaders,"removeEmptyCols: grid has no col headers!");
	if(getColHeader(vcol,grid).colSpan==1)return;
	var a=new Array(getColHeader(vcol,grid).colSpan);
	for(var i=0;i<a.length;i++){a[i]=false;}
	for(var i=0;i<grid.numrows;i++)
	{
		var tds=getTDs(i,vcol,grid);
		for(var j=0;j<tds.length;j++)
			{if(!tds[j].empty)a[j]=true;}
	}
	var rcs=getRCol(vcol,grid);
	for(var i=0;i<a.length;i++)
	{
		if(a[i]==false)
		{
			grid.numrcols--;removeEmptyCol(rcs[i],grid);
			getColHeader(vcol,grid).colSpan--;
			if(grid.hasTimelessRow)
				{getTimelessTD(vcol,grid).colSpan--;}
		}
	}
}
function removeEmptyCol(realcol,grid){for(var i=0;i<grid.numrows;i++){getTR(i,grid).removeChild(getTD(i,realcol,grid,true));}
offsetCellsRightOf(realcol-1,-1,grid);}
function spawnNewColumnBefore(vcol,rcol,grid)
{
	var rs=getRCol(vcol,grid);
	Assert(rcol >=rs[0]&&rcol <=rs[rs.length-1]+1,"spawnNewColumnBefore: invalid rcol or vcol: "+rcol);
	if(grid.hasColHeaders){getColHeader(vcol,grid).colSpan++;}
	if(grid.hasTimelessRow){getTimelessTD(vcol,grid).colSpan++;}
	for(var i=0;i<grid.numrows;i++)
	{
		var td=makeTD(i,i,rcol,_CELLHEIGHTPX,_CELLWIDTHPX+1);
		var td0=getTD(i,0,grid,true);td.style.borderTop=td0.style.borderTop;
		td.borderTopO=td.style.borderTop;
		td.style.borderLeft=td0.style.borderLeft;
		td.borderLeftO=td.style.borderLeft;
		getTR(i,grid).insertBefore(td,getTD(i,rcol,grid,true));
	}
	grid.numrcols++;offsetCellsRightOf(rcol,1,grid);
}
function getVCol(rcol,grid){Assert(grid.hasColHeaders,"getVCol: grid has no col headers!");var a=0;for(var i=0;i<grid.numvcols;i++){a+=getColHeader(i,grid).colSpan;if(rcol < a)return i;}
Assert(false,"getVCol: invalid rcol: "+rcol);}
function getRCol(vcol,grid){Assert(grid.hasColHeaders,"getVCol: grid has no col headers!");var a=0;for(var i=0;i<vcol;i++){a+=getColHeader(i,grid).colSpan;}
var r=new Array(getColHeader(vcol,grid).colSpan);for(var i=0;i<r.length;i++)r[i]=a+i;return r;}
function refreshDebug(grid){if(!_DEBUG)return;for(var i=0;i<grid.numrows;i++){for(var j=0;j<grid.numrcols;j++){var td=getTD(i,j,grid,true);td.firstChild.nodeValue=td.rowstart+"-"+td.rowend+","+td.rcol;}
}
}
function offsetCellsRightOf(rcol,offset,grid){for(var i=0;i<grid.numrows;i++){for(var j=rcol+1;j<grid.numrcols;j++){getTD(i,j,grid,true).rcol+=offset;}
}
refreshDebug(grid);}
function offsetCellsBelow(row,offset,grid){for(var i=row+1;i<grid.numrows;i++){for(var j=0;j<grid.numrcols;j++){var td=getTD(i,j,grid,true);td.rowstart+=offset;td.rowend+=offset;}
}
refreshDebug(grid);}
function isEmpty(rowstart,rowstop,col,grid){for(var i=rowstart;i <=rowstop;i++){var c=getTD(i,col,grid,false);if(c==null)alert(i+" "+col);if(!c.empty)return false;}
return true;}

//生成日历
function makeCalendar(month,day,year,starttime,stoptime,viewmode,owner,parent)
{
	if(viewmode==_DAYVIEW)
	{return makeDayCalendar(month,day,year,starttime,stoptime,owner,parent);}
	else if(viewmode==_WEEKVIEW){return makeWeekCalendar(month,day,year,starttime,stoptime,owner,parent);}
	else if(viewmode==_MONTHVIEW){return makeMonthCalendar(month,day,year,starttime,stoptime,owner,parent);}
}
//生成月日历
function makeMonthCalendar(month,day,year,starttime,stoptime,owner,parent)
{
	var d=dayOfWeek(month,1,year);
	var dim=daysInMonth(month,year);
	var numrows=weekOfMonth(month,dim,year);
	var nDocumentWidth = document.body.clientWidth - 120;
	var g=makeGrid(numrows,7,_CELLMONTHHEIGHTPX,nDocumentWidth,parent);
	g.month=month;
	g.day=day;
	g.year=year;
	g.starttime=starttime;
	g.stoptime=stoptime;
	g.activeNode=null;
	g.view=_MONTHVIEW;
	g.owner=owner;
	var colH=_DAYSOFTHEWEEK;
	addColHeadings(colH,g);
	var r=0;
	for(var i=0;i<daysInMonth(month,year);i++)
	{
		var cellNode=cellMonthHtml(month,i+1,year,null,g);
		addCell(r,r,d,d,cellNode,g);
		cellNode.parentNode.day=i+1;
		cellNode.parentNode.vAlign="top";
		var newHt=cellNode.parentNode.offsetHeight-8;
		cellNode.style.height=newHt;
		d++;
		if(d==7)r++;
		d=hModulo(d,7);
		
		//当前日的背景颜色
		if(cellNode.style.backgroundColor == "#ffffcc")	
			cellNode.parentNode.style.backgroundColor = "#FFFFCC";
	}
	if(owner)addAddEventListener(g);
	g.style.border="1px solid #000000";
	for(var i=0;i<7;i++)
	{
		var h=getColHeader(i,g);
		h.style.left=(14*i)+"%";
		h.style.width="14%";
	}
	return g;
}
//生成天日历
function makeDayCalendar(month,day,year,starttime,stoptime,owner,parent)
{
	var numrows=(stoptime-starttime)/_TIMEINTERVAL;
	var nDocumentWidth = document.body.clientWidth - 120;
	var g=makeGrid(numrows,1,_CELLHEIGHTPX+1,nDocumentWidth,parent);
	g.month=month;
	g.day=day;
	g.year=year;
	g.starttime=starttime;
	g.stoptime=stoptime;
	g.view=_DAYVIEW;
	g.owner=owner;
	var colH=new Array(1);
	var d=dayOfWeek(month,day,year);
	colH[0]="<span>"+_DAYSOFTHEWEEK[d]+"</span>";
	g.activeNode=null;
	var rowH=timesToString(starttime,stoptime);
	addRowHeadings(rowH,g);
	addColHeadings(colH,g);
	getCornerHeader(g).firstChild.style.margin="0px";
	getCornerHeader(g).style.width= nDocumentWidth * 0.09;
	getCornerHeader(g).style.height="18px";
	getCornerHeader(g).firstChild.innerHTML="<span style='font-size:12px;font-weight:bold;'>"+g.year+"</span>";
	if(owner)addAddEventListener(g);
	addTimelessRow(g);
	addColHeaderListeners(g);
	
	var today=new Date();
	var nCur = -1;
	var h=getColHeader(0,g);
	var hd = getDate(0,g);
	if(today.getMonth()+1==hd[0]&&today.getDate()==hd[1]&&today.getFullYear()==hd[2])
	{
		h.style.backgroundColor = "#BBCCDD";
		h.style.textAlign="center";
		h.style.width = nDocumentWidth * 0.91;
		nCur = 0;
	}
	else
	{
		h.style.textAlign="center";
		h.style.width = nDocumentWidth - 100;
	}
		
	//为当前日加背景色
	if(nCur > -1)
	{
		var tb=g.childNodes[0];
		for(var i=1;i<=numrows;i++)
		{
			tb.childNodes[i].childNodes[nCur+1].style.backgroundColor = "#FFFFCC";	
		}
	}
	
	for(var i=1;i < numrows;i+=2)
	{
		var td=getTD(i,0,g,true);
		td.style.borderTop=_CELLBORDERSTYLE2;
		td.borderTopO=_CELLBORDERSTYLE2;
	}
	g.style.border="1px solid #000000";
	return g;
}
//生成周日历
function makeWeekCalendar(month,day,year,starttime,stoptime,owner,parent)
{
	var numrows=(stoptime-starttime)/_TIMEINTERVAL;
	var nDocumentWidth = document.body.clientWidth - 120;
	var g=makeGrid(numrows,7,_CELLHEIGHTPX+1,nDocumentWidth,parent);
	g.month=month;
	g.day=day;
	g.year=year;
	g.starttime=starttime;
	g.stoptime=stoptime;
	g.view=_WEEKVIEW;
	g.owner=owner;
	var colH=datesToString(g);
	g.activeNode=null;
	var rowH=timesToString(starttime,stoptime);
	addRowHeadings(rowH,g);
	addColHeadings(colH,g);
	getCornerHeader(g).style.width= nDocumentWidth * 0.09;
	getCornerHeader(g).style.height="18px";
	addColHeaderListeners(g);
	if(owner)addAddEventListener(g);
	addTimelessRow(g);
	for(var i=1;i < numrows;i+=2)
	{
		for(var j=0;j < 7;j++)
		{
			var td=getTD(i,j,g,true);
			td.style.borderTop=_CELLBORDERSTYLE2;
			td.borderTopO=_CELLBORDERSTYLE2;
		}
	}
	getCornerHeader(g).firstChild.style.margin="0px";
	getCornerHeader(g).firstChild.innerHTML="<span style='font-size:12px;font-weight:bold;'>"+g.year+"</span>";
	getCornerHeader(g).style.left="0%";
	
	var today=new Date();
	var nCur = -1;
	for(var i=0;i<7;i++)
	{
		var h=getColHeader(i,g);
		var hd = getDate(i,g);
		if(today.getMonth()+1==hd[0]&&today.getDate()==hd[1]&&today.getFullYear()==hd[2])
		{
			h.style.backgroundColor = "#BBCCDD";
			nCur = i;
		}
				
		h.style.left=(13*i)+"%";
		h.style.width="13%";
	}
	
	//为当前日加背景色
	if(nCur > -1)
	{
		var tb=g.childNodes[0];
		for(var i=1;i<=numrows;i++)
		{
			tb.childNodes[i].childNodes[nCur+1].style.backgroundColor = "#FFFFCC";	
		}
	}
	
	g.style.border="1px solid #000000";
	return g;
}
//添加Timeless行
function addTimelessRow(calendar)
{
	if(calendar.hasTimelessRow)return;
	spawnNewRowAt(0,calendar,"&nbsp;");
	for(var i=0;i<calendar.numvcols;i++)
	{
		var td=getTimelessTD(i,calendar);
		td.rowstart=td.rowstop=_TIMELESSROW;
		//td.style.height="1px";
	}
	if(getTimelessTD(-1,calendar)!=null)
	{
		getTimelessTD(-1,calendar).style.height="1px";
		//getTimelessTD(-1,calendar).style.display= "none";
	}
	calendar.hasTimelessRow=true;	
}
//增加列头的事件监听
function addColHeaderListeners(calendar)
{
	for(var i=0;i<calendar.numvcols;i++)
	{
	var ch=getColHeader(i,calendar);
	ch.style.cursor="pointer";
	//ch.onmouseover=function(){this.style.backgroundColor=_DARKERHEADERCOLOR;}
	//ch.onmouseout=function(){this.style.backgroundColor=_HEADERCOLOR};
	ch.onmousedown=function(){
		var d=getDate(getVCol(this.rcol,calendar),calendar);
		setNavCurrentCalendar(calendar.navbar,makeCalendar(d[0],d[1],d[2],calendar.starttime,calendar.stoptime,_DAYVIEW,calendar.owner,calendar.parent));};
	}
}
//获取日期
function getDate(col,calendar)
{
	if(calendar.view==_WEEKVIEW)
	{
		Assert(col >=0&&col <=6,"getDate: invalid col: "+col);
		var d=dayOfWeek(calendar.month,calendar.day,calendar.year);
		var today=new Array(calendar.month,calendar.day,calendar.year);
		if(col==d)return today;
		while(col < d){today=dayBefore(today);d--;}
		while(col > d){today=dayAfter(today);d++;}
		return today;
	}
	else if(calendar.view==_DAYVIEW)
	{
		Assert(col==0,"getDate: invalid col");
		return new Array(calendar.month,calendar.day,calendar.year);
	}
	else if(calendar.view==_MONTHVIEW)
	{Assert(false,"getDate: not implemented");return null;}
	return null;
}
//拷贝事件
function copyEvent(event)
{
	var e={"id":event.id,
	"subject":event.subject,
	"eventdesc":event.eventdesc,
	"catid":event.catid,
	"catname":event.catname,
	"catcolor":event.catcolor,
	"stime":event.stime,
	"etime":event.etime,
	"sday":event.sday,
	"sweek":event.sweek,
	"smonth":event.smonth,
	"syear":event.syear,
	"startdate":event.startdate,
	"enddate":event.enddate,
	"reptype":event.reptype,
	"repnum":event.repnum,
	"rep":event.rep,
	"hasexclude":event.hasexclude,
	"excludes":event.excludes,
	"priv":event.priv,
	"favoriteonly":event.favoriteonly,
	"emailnote":event.emailnote,
	"smsnote":event.smsnote,
	"emailorsms":event.emailorsms,
	"alertbefore":event.alertbefore
	}
	return e;
}
//生成空事件
function makeBlankEvent()
{
	var today=new Date();
	var todayString=getTodayString();
	var priv=0;
	var favoriteonly=0;
	if(_EVENT_PRIVACY_DEFAULT==1)
	{
		priv=0;
		favoriteonly=1;
	}
	else if(_EVENT_PRIVACY_DEFAULT==2)
	{
		priv=1;
		favoriteonly=0;
	}
	return makeEvent(0,"","",getDefaultCat().id,getDefaultCat().name,getDefaultCat().color,_NOTIME,_NOTIME,today.getDate(),0,today.getMonth()+1,today.getFullYear(),
	todayString,_LARGESTDATE,0,1,0,0,null,
	priv,favoriteonly,
	1,0,0,0);
}
//生成事件
function makeEvent(id,subject,eventdesc,catid,catname,catcolor,stime,etime,sday,sweek,smonth,syear,
startdate,enddate,reptype,repnum,rep,hasexclude,excludes,priv,favoriteonly,emailnote,smsnote,emailorsms,alertbefore)
{
	var e={"id":id,
	"subject":subject,
	"eventdesc":eventdesc,
	"catid":catid,
	"catname":catname,
	"catcolor":catcolor,
	"stime":null,
	"etime":null,
	"sday":sday,
	"sweek":sweek,
	"smonth":smonth,
	"syear":syear,
	"startdate":startdate,
	"enddate":enddate,
	"reptype":reptype,
	"repnum":repnum,
	"rep":rep,
	"hasexclude":hasexclude,
	"excludes":excludes,
	"priv":priv,
	"favoriteonly":favoriteonly,
	"emailnote":emailnote,
	"smsnote":smsnote,
	"emailorsms":emailorsms,
	"alertbefore":alertbefore
	}
	if(stime!=_NOTIME)e.stime=timeToDecimal(stime);
	else e.stime=_NOTIME;if(etime!=_NOTIME)e.etime=timeToDecimal(etime);
	else e.etime=_NOTIME;
	return e;
}
//添加多事件
function addEvents(e,calendar)
{
	for(var i=0;i < e.length;i++)
	{
		if(getDOMEventById(e[i],calendar)==null)
			{addEvent(e[i],null,calendar);}
	}
	setActiveNode(null,calendar);
}
function addSimpleEvent(subject,month,day,year,calendar)
{
	var e=makeBlankEvent();
	e.subject=subject;
	e.smonth=month;
	e.sday=day;
	e.syear=year;
	e.startdate=e.enddate=month+"/"+day+"/"+year;
		if(eventOnCalendar(e,calendar)){addEvent(e,0,calendar);}
	sendXMLAddEvent(e);
}
//添加单事件
function addEvent(event,preferredRCol,calendar)
{
	if(_DEBUG)alert("adding event:"+eventToString(event));
	if(!eventOnCalendar(event,calendar))
	{
		if(_DEBUG){alert("addEvent: event not on calendar! \n"+eventToString(event)+" \n\n"+calendarToString(calendar));}
		return;
	}
	if(event.stime!=_NOTIME&&event.etime-event.stime==0)return;
	if(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW)
	{
		while(event.stime!=_NOTIME&&calendar.starttime > event.stime)
		{
			spawnNewRowAt(0,calendar,"*");
			calendar.numrows++;
			calendar.starttime-=_TIMEINTERVAL;
			offsetCellsBelow(0,1,calendar);
			changeRowHeadings(timesToString(calendar.starttime,calendar.stoptime),calendar);
			if(calendar.starttime-parseInt(calendar.starttime)==0)
			{
				for(var i=0;i<calendar.numrcols;i++)
				{
					var td1=getTD(1,i,calendar,true);
					td1.style.borderTop=td1.borderTopO=_CELLBORDERSTYLE2;
				}
			}
		}
		while(event.stime!=_NOTIME&&calendar.stoptime < event.etime)
		{
			spawnNewRowAt(calendar.numrows,calendar,"*");
			calendar.numrows++;
			calendar.stoptime+=_TIMEINTERVAL;
			changeRowHeadings(timesToString(calendar.starttime,calendar.stoptime),calendar);
			if(calendar.stoptime-parseInt(calendar.stoptime)==0)
			{
				for(var i=0;i<calendar.numrcols;i++)
				{
					var td1=getTD(calendar.numrows-1,i,calendar,true);
					td1.style.borderTop=td1.borderTopO=_CELLBORDERSTYLE2;
				}
			}
		}
		var vcol;
		if(calendar.view==_WEEKVIEW)
			vcol=dayOfWeek(event.smonth,event.sday,event.syear);
		if(calendar.view==_DAYVIEW)
			vcol=0;
		var cellNode=cellHtml(event);
		var rowstart,rowstop;
		if(event.stime==_NOTIME)
		{
			rowstart=rowstop=_TIMELESSROW;
			appendCell(rowstart,vcol,cellNode,calendar);
			cellNode.style.height=_CELLHEIGHTPX;
		}
		else{if(event.etime > calendar.stoptime&&_DEBUG)
		{
			alert("addEvent: event.etime too big");
			return;
		}
		if(event.stime < calendar.starttime&&_DEBUG){alert("addEvent: event.stime too small");return;}
		rowstart=(event.stime-calendar.starttime)/_TIMEINTERVAL;
		rowstop=rowstart+(event.etime-event.stime)/_TIMEINTERVAL-1;
		addCell(rowstart,rowstop,vcol,preferredRCol,cellNode,calendar);
		var newHt=cellNode.parentNode.offsetHeight-_MARGIN*2-3;
		cellNode.td4.style.height=newHt;
		cellNode.td5.style.height=newHt;
		cellNode.td6.style.height=newHt;
	}
	addNonOwnerListeners(cellNode,calendar);
	if(calendar.owner){addListeners(cellNode,calendar);setActiveNode(cellNode,calendar);}
	return cellNode;
	}
	else if(calendar.view==_MONTHVIEW)
	{
		var row=weekOfMonth(event.smonth,event.sday,event.syear)-1;var col=dayOfWeek(event.smonth,event.sday,event.syear);
		var td=getTD(row,col,calendar,true);
		var cellNode=appendMonthEvent(td.firstChild,event,calendar);
		removeCell(td.firstChild,calendar);
		addCell(row,row,col,col,cellNode,calendar);
		addMonthNonOwnerListeners(cellNode,calendar);if(calendar.owner){addMonthListeners(cellNode,calendar);}
	}
}
//通过ID获取事件Dom
function getDOMEventById(event,calendar)
{
	if(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW)
	{
		var rowstart;
		var rowstop;
		rowstart=(event.stime-calendar.starttime)/_TIMEINTERVAL;
		rowstop=rowstart+(event.etime-event.stime)/_TIMEINTERVAL-1;
		if(event.stime==_NOTIME)rowstart=rowstop=_TIMELESSROW;
		var rcs;
		if(calendar.view==_WEEKVIEW)rcs=getRCol(dayOfWeek(event.smonth,event.sday,event.syear),calendar);
		else rcs=getRCol(0,calendar);
		for(var i=0;i<rcs.length;i++)
		{
			var td=getTD(rowstart,rcs[i],calendar,false);
			if(td!=null&&!td.empty)
			{
				var e2=td.firstChild.event;
				if(e2.id==event.id){return td.firstChild;}
			}
		}
	return null;
	}
	else if(calendar.view==_MONTHVIEW)
	{
		var td=getTD(weekOfMonth(event.smonth,event.sday,event.syear)-1,dayOfWeek(event.smonth,event.sday,event.syear),calendar,true);
		if(td==null||td.empty)return null;
		else
		{
			var es=td.firstChild.getElementsByTagName("DIV");
			for(var i=0;i<es.length;i++)
			{
				if(es[i].event!=null)
				{
					if(es[i].event.id==event.id)
						return es[i];
				}
			}
		}
		return null;
	}
}
//获取事件Dom
function getDOMEvent(event,calendar)
{
	if(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW)
	{
		var rowstart;var rowstop;
		rowstart=(event.stime-calendar.starttime)/_TIMEINTERVAL;
		rowstop=rowstart+(event.etime-event.stime)/_TIMEINTERVAL-1;
		if(event.stime==_NOTIME)rowstart=rowstop=_TIMELESSROW;
		var rcs;
		if(calendar.view==_WEEKVIEW)rcs=getRCol(dayOfWeek(event.smonth,event.sday,event.syear),calendar);
		else rcs=getRCol(0,calendar);
		for(var i=0;i<rcs.length;i++)
		{
			var td=getTD(rowstart,rcs[i],calendar,false);
			if(td!=null&&!td.empty)
			{
				var e2=td.firstChild.event;
				if(e2.stime==event.stime&&e2.etime==event.etime&&e2.subject==event.subject)
				{return td.firstChild;}
			}
		}
	return null;
	}
	else if(calendar.view==_MONTHVIEW)
	{
		var td=getTD(weekOfMonth(event.smonth,event.sday,event.syear)-1,dayOfWeek(event.smonth,event.sday,event.syear),calendar,true);
		if(td==null||td.empty)return null;
		else
		{
			var es=td.firstChild.getElementsByTagName("DIV");
			for(var i=0;i<es.length;i++)
			{
				if(es[i].event!=null)
				{
					if(es[i].event.subject==event.subject&&es[i].event.stime==event.stime&&es[i].event.etime==event.etime)
						return es[i];
				}
			}
		}
	return null;
	}
}
//移除事件Dom
function removeDOMEvent(eventDOM,calendar)
{
	if(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW)
	{
		var event=eventDOM.event;
		if(_DEBUG)alert("removing event:"+event.subject+" "+event.stime+"to"+event.etime+" day"+event.sday);
		removeCell(eventDOM,calendar);
		setActiveNode(null,calendar);
	}
	else if(calendar.view==_MONTHVIEW)
	{
		var oldlist=eventDOM.parentNode.eventsList;
		var newlist=new Array(oldlist.length-1);
		var offset=0;
		for(var i=0;i<newlist.length;i++)
		{
			if(eventDOM.event.id==oldlist[i].id){offset=1;}
			newlist[i]=oldlist[i+offset];
		}
		eventDOM.parentNode.eventsList=newlist;
		eventDOM.parentNode.removeChild(eventDOM);
	}
}
//是否为边角
function inCorners(td)
{
	if(cornersDefined()&&td.rcol==c.corner1.rcol)
	{
		if(c.corner1.rowstart <=c.corner3.rowstart)
		{
			if(td.rowstart >=c.corner1.rowstart&&td.rowstart <=c.corner3.rowstart){return true;}
		}
		if(c.corner1.rowstart > c.corner3.rowstart)
		{
			if(td.rowstart >=c.corner3.rowstart&&td.rowstart <=c.corner1.rowstart){return true;}
		}
	}
	return false;
}
//双击添加事件
function dblClickAddEvent(a)
{
	var calendar=navbar.currentCalendar;
	a=fixEvent(a);
	var event=makeBlankEvent();
	var c1=null,c2=null,c3=null,c4=null;
	if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
	{
		if(a.target.tagName!="TD"||!a.target.empty){return;}
		if(cornersDefined()&&inCorners(a.target))
		{
			if(cornersDefined())
			{
				var r=rotateCorners();
				c1=r[0];c2=r[1];c3=r[2];c4=r[3];
			}
			var newdate=getDate(getVCol(c1.rcol,calendar),calendar);
			var sday=newdate[1];
			var sweek=0;var smonth=newdate[0];var syear=newdate[2];
			if(c1.rowstart==_TIMELESSROW)
				{event.stime=event.etime=_NOTIME;}
			else
			{
				event.stime=calendar.starttime+c1.rowstart*_TIMEINTERVAL;
				event.etime=calendar.starttime+c4.rowstart*_TIMEINTERVAL+_TIMEINTERVAL;
			}
			event.sday=sday;event.smonth=smonth;
			event.syear=syear;
			event.startdate=event.enddate=smonth+"/"+sday+"/"+syear;
			showEditLayer(null,calendar,true,event);
		}
	}
	else if(calendar.view==_MONTHVIEW)
	{
		c1=getActiveNode(calendar);
		if(c1==a.target||c1==a.target.parentNode)
		{
			var sday=c1.day;
			var smonth=calendar.month;
			var syear=calendar.year;
			event.sday=sday;
			event.smonth=smonth;
			event.syear=syear;
			event.startdate=event.enddate=smonth+"/"+sday+"/"+syear;
			showEditLayer(null,calendar,true,event);
		}
	}
}
//添加事件监听
function addAddEventListener(calendar)
{
	if(!isIE)
	{
		document.addEventListener('dblclick',dblClickAddEvent,false);
	}
	else
	{
		document.attachEvent('ondblclick',dblClickAddEvent);
	}

	if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
	{
		calendar.onmousedown=function(a)
		{
			setActiveNode(null,calendar);
			a=fixEvent(a);
			if(a.target.tagName!="TD"||!a.target.empty)
				{return;}
			if(cornersDefined()&&inCorners(a.target))
				{return;}
			setCorners(a.target,a.target,a.target,a.target,calendar);
			var td=a.target;
			if(td.rowstart==_TIMELESSROW)
			{
				setCorners(a.target,a.target,a.target,a.target,calendar);
			}
			c.lastMouseX=a.clientX;
			c.lastMouseY=a.clientY;
			if(td.rowstart!=_TIMELESSROW)
				document.onmousemove=function(a)
				{
					a=fixEvent(a);
					var td=a.target;
					if(a.target.tagName!="TD"||!a.target.empty)
						{return;}
			var row=td.rowstart;
			if(row==_TIMELESSROW)
				{return false;}
			var col=td.rcol;
			var oldc1=c.corner1;
			var oldc2=c.corner2;
			var oldc3=c.corner3;
			var oldc4=c.corner4;
			if(row!=c.corner3.rowstart)
			{
				setCorners(true,true,getTD(row,c.corner3.rcol,calendar,true),getTD(row,c.corner4.rcol,calendar,true),calendar);
			}
			
			if(!allEmpty(calendar))
			{
				setCorners(oldc1,oldc2,oldc3,oldc4,calendar);
			}
			c.lastMouseX=a.clientX;
			c.lastMouseY=a.clientY;
			return false;
		}
	
		document.onmouseup=function()
		{
			c.lastMouseX=0;
			c.lastMouseY=0;
			document.onmousemove=null;
			document.onmouseup=null;
		}
		return false;
	}
	}
	else if(calendar.view==_MONTHVIEW)
	{
		calendar.onmousedown=function(a)
		{
			a=fixEvent(a);
			var td=null;
			if(a.target.tagName=="DIV")
			{
				if(!a.target.parentNode.empty && a.target.parentNode.tagName=="TD")
				{
					td=a.target.parentNode;
				}
			}
			
			if(!a.target.empty && a.target.tagName=="TD")
			{
				td=a.target;
			}

			if(td!=null&&td.rowstart!=-1)
			{
				setActiveNode(td,calendar);
				if(c.activeMonthNode!=null)
					unhighlightMonthNode(c.activeMonthNode);
				showAddEventTips(td,calendar);
				document.onmouseup=function()
				{
					document.onmousemove=null;
					document.onmouseup=null;
				}
			}
		}
	}
}
//显示添加事件的层
function showAddEventTips(cs,calendar)
{
	resetNewEventDiv(calendar);
	showToolTip(o(cs,true)+cs.offsetWidth,o(cs,false),"<center>双击添加事件</center>");
	setTimeout(function(){hideToolTip()},5000);
	toolTipStyle().border="1px dashed #666666";
	toolTipStyle().width="70px";
	toolTipStyle().backgroundColor="#F6F792";
	toolTipStyle().filter="alpha(opacity=70)";
	toolTipStyle().opacity="0.7";
	document.onkeypress=function(a)
	{
		showToolTip(o(cs,true)+cs.offsetWidth,o(cs,false),"<center>Press enter to save</center>");
		toolTipStyle().border="1px dashed #666666";
		toolTipStyle().width="70px";
		toolTipStyle().backgroundColor="#F6F792";
		toolTipStyle().filter="alpha(opacity=70)";
		toolTipStyle().opacity="0.7";
		a=fixEvent(a);
		handleAddEvent(a,calendar);
		return false;
	}
	document.onkeydown=function(a)
	{
		a=fixEvent(a);
		if(a.which==8)
		{
			newEventDiv.innerHTML=newEventDiv.innerHTML.substr(0,newEventDiv.innerHTML.length-1);
			a.cancelBubble=true;
			if(a.stopPropagation)a.stopPropagation();
			return false;
		}
		else if(a.which==27){resetNewEventDiv(calendar);}
	}
}
var newEventDiv=null;
function handleAddEvent(a,calendar)
{
	a=fixEvent(a);
	var c1=null,c2=null,c3=null,c4=null;
	if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
	if(cornersDefined()){var r=rotateCorners();c1=r[0];c2=r[1];c3=r[2];c4=r[3];}

	if(calendar.view==_MONTHVIEW&&getActiveNode(calendar)!=null){c1=getActiveNode(calendar);}
	if(c1!=null)
	{
		if(newEventDiv==null)
		{
			newEventDiv=document.createElement("DIV");
			newEventDiv.style.display="block";
			newEventDiv.style.position="absolute";
			newEventDiv.style.top=(o(c1,false)+5)+"px";
			newEventDiv.style.left=(o(c1,true)+5)+"px";
			newEventDiv.style.width=c1.offsetWidth-10;
			newEventDiv.style.border="0px";
			newEventDiv.style.fontFamily=_USERFONT;
			newEventDiv.style.fontSize="10px";
			newEventDiv.style.zIndex=3;
			document.body.appendChild(newEventDiv);
			newEventDiv.innerHTML="";
		}
		var pressedKey=String.fromCharCode(a.which).toLowerCase();
		if(a.ctrlKey&&pressedKey=="v"&&calendar.clipboard!=null)
		{
			hideToolTip();
			if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
			{
				var event=copyEvent(calendar.clipboard);
				var newdate=getDate(getVCol(c1.rcol,calendar),calendar);
				var sday=newdate[1];var sweek=0;var smonth=newdate[0];var syear=newdate[2];
				if(c1.rowstart==_TIMELESSROW)
				{
					event.stime=event.etime=_NOTIME;
				}
				else
				{
					var length=Math.max(event.etime-event.stime,_TIMEINTERVAL);
					event.stime=calendar.starttime+c1.rowstart*_TIMEINTERVAL;
					event.etime=event.stime+length;
				}
				event.sday=sday;event.smonth=smonth;event.syear=syear;
				addEvent(event,c1.rcol,calendar);
				sendXMLAddEvent(event,calendar);
				setStatusDiv("Event "+event.subject+" pasted.");
				resetNewEventDiv(calendar);
			}
		}
		else if(a.which==13&&newEventDiv.innerHTML.length>0)
		{
			hideToolTip();
			var event;
			if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
			{
				var newdate=getDate(getVCol(c1.rcol,calendar),calendar);
				var sday=newdate[1];
				var smonth=newdate[0];
				var syear=newdate[2];
				event=makeBlankEvent();
				event.sday=sday;event.smonth=smonth;event.syear=syear;
				event.startdate=event.enddate=smonth+"/"+sday+"/"+syear;
				if(c1.rowstart==_TIMELESSROW){event.stime=event.etime=_NOTIME;}
				else{event.stime=calendar.starttime+c1.rowstart*_TIMEINTERVAL;event.etime=calendar.starttime+(c3.rowstart+1)*_TIMEINTERVAL;}
			}
			else if(calendar.view==_MONTHVIEW)
			{
				var sday=c1.day;var smonth=calendar.month;var syear=calendar.year;
				event=makeBlankEvent();
				event.sday=sday;event.smonth=smonth;event.syear=syear;
				event.startdate=event.enddate=smonth+"/"+sday+"/"+syear;
			}
			event.subject=newEventDiv.innerHTML;
			addEvent(event,c1.rcol,calendar);
			sendXMLAddEvent(event,calendar);
			resetNewEventDiv(calendar);
		}
		else if(isAlphaNumeric(a.which))
		{
			newEventDiv.innerHTML+=String.fromCharCode(a.which);
		}
	}
}
//复位新事件
function resetNewEventDiv(calendar){if(newEventDiv!=null)document.body.removeChild(newEventDiv);newEventDiv=null;hideToolTip();}
//添加无所属的监听
function addNonOwnerListeners(cellNode,calendar)
{
	Assert(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW);
	//cellNode.onmousemove=showCellDetails;
	//cellNode.onmouseout=function(a){hideToolTip();return true;};
}
//添加监听
function addListeners(cellNode,calendar)
{
	Assert(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW);
	var moveArea=cellNode.td5;
	var sResizeArea=cellNode.td8;
	var nResizeArea=cellNode.td2;
	moveArea.style.cursor="move";
	sResizeArea.style.cursor="s-resize";
	nResizeArea.style.cursor="n-resize";
	cellNode.onmousedown=function(a){setActiveNode(cellNode,calendar);return true;}
	moveArea.ondblclick=function(){showEditLayer(cellNode,calendar,false);}
	moveArea.onmousedown=function(a){a=fixEvent(a);return moveAreaEventHandler(a,cellNode,calendar);}

if(cellNode.event.stime==_NOTIME)
	sResizeArea.onmousedown=null;
else
	sResizeArea.onmousedown=function(a)
	{
		a=fixEvent(a);
		setActiveNode(cellNode,calendar);
		h().innerHTML="";
		h().style.border=_CELLBORDERHIGHLIGHTSTYLE;
		h().style.display="block";
		h().style.height=cellNode.parentNode.offsetHeight+"px";
		h().style.width=cellNode.parentNode.offsetWidth+"px";
		h().style.top=o(cellNode,false)+"px";
		h().style.left=o(cellNode,true)+"px";
		c.lastMouseX=a.clientX;
		c.lastMouseY=a.clientY;
		document.onmousemove=function(b)
		{
			b=fixEvent(b);
			highlightClosestCellBelow(b.clientX,parseInt(h().style.top)+parseInt(h().style.height)+b.clientY-c.lastMouseY,calendar);
			resizeRect(parseInt(h().style.height)+b.clientY-c.lastMouseY,parseInt(h().style.width));
			c.lastMouseX=b.clientX;
			c.lastMouseY=b.clientY;
			return true;
		};
		document.onmouseup=function()
		{
			h().style.border="0px";
			var e=c.closestCell;
			if(e==null)
			{
				h().style.display="none";
				c.lastMouseX=0;c.lastMouseY=0;
				document.onmousemove=null;
				document.onmouseup=null;
				return true;
			}
			for(var i=0;i<calendar.numrcols;i++)
			{
				var td=getTD(e.rowstart+1,i,calendar,false);
				if(td!=null)td.style.borderTop=td.borderTopO;
			}
			c.closestCell=null;
			var t=getActiveNode(calendar);
			var preferredRCol=t.parentNode.rcol;
			t.event.etime=getStartTime(e,calendar)+_TIMEINTERVAL;
			if(t.event.reptype!=0)
			{
				t.event.notify=function(value)
				{
					if(value==0)
					{
						sendXMLMoveEvent(t.event,calendar);
						removeAllEventsFromCalendar(calendar);
						addEventsToCalendar(calendar);
					}
					else if(value==1)
					{
						t.event.olddate=new Array(t.event.smonth,t.event.sday,t.event.syear);
						sendXMLRepMoveEvent(t.event,calendar);
						removeDOMEvent(t,calendar);
						addEventsToCalendar(calendar);
					}
					else if(value==2){}
				}
				dialogBox("<div style='font-size:18px'>This event is repeated.<br>I want to change times for:</div>",new Array("All occurrences","Just this occurrence","Cancel"),t.event,100,300);
			}
			else if(sendXMLResizeEvent(t.event,calendar))
			{
				removeDOMEvent(t,calendar);
				addEvent(t.event,preferredRCol,calendar);
			}
			else{alert("Error resizing event.");}
			h().style.display="none";
			c.lastMouseX=0;c.lastMouseY=0;
			document.onmousemove=null;
			document.onmouseup=null;
			return true;
		};
		
		a.cancelBubble=true;
		if(a.stopPropagation)a.stopPropagation();
		return false;
	};
if(cellNode.event.stime==_NOTIME)
	nResizeArea.onmousedown=null;
else
	nResizeArea.onmousedown=function(a)
	{
		a=fixEvent(a);
		setActiveNode(cellNode,calendar);
		h().innerHTML="";
		h().style.border=_CELLBORDERHIGHLIGHTSTYLE;
		h().style.display="block";
		h().style.height=cellNode.parentNode.offsetHeight+"px";
		h().style.width=cellNode.parentNode.offsetWidth+"px";
		h().style.top=o(cellNode,false)+"px";
		h().style.left=o(cellNode,true)+"px";
		c.lastMouseX=a.clientX;
		c.lastMouseY=a.clientY;
		var bottomLimit=o(cellNode,false)+cellNode.parentNode.offsetHeight;
		document.onmousemove=function(b)
		{
			b=fixEvent(b);
			var offsetY=b.clientY-c.lastMouseY;
			highlightClosestCellAbove(b.clientX,parseInt(h().style.top)+offsetY,calendar);
			if(parseInt(h().style.top)<=bottomLimit)
			{
				resizeRect(parseInt(h().style.height)-offsetY,parseInt(h().style.width));
				h().style.top=parseInt(h().style.top)+offsetY+"px";
				c.lastMouseX=b.clientX;
				c.lastMouseY=b.clientY;
			}
			else
			{
				h().style.top=bottomLimit+"px";
				h().style.height=1;
			}
			return true;
		};
	document.onmouseup=function()
	{
			h().style.border="";
			var e=c.closestCell;
			if(e==null)
			{
				h().style.display="none";
				c.lastMouseX=0;
				c.lastMouseY=0;
				document.onmousemove=null;
				document.onmouseup=null;
				return true;
			}
			for(var i=0;i<calendar.numrcols;i++)
			{
				getTD(e.rowstart,i,calendar,false).style.borderTop=getTD(e.rowstart,i,calendar,false).borderTopO;
			}
			c.closestCell=null;
			var t=getActiveNode(calendar);
			var preferredRCol=t.parentNode.rcol;
			t.event.stime=getStartTime(e,calendar);
			if(t.event.reptype!=0)
			{
				t.event.notify=function(value)
				{
					if(value==0)
					{
					sendXMLMoveEvent(t.event,calendar);
					removeAllEventsFromCalendar(calendar);
					addEventsToCalendar(calendar);
					}
					else if(value==1)
					{
					t.event.olddate=new Array(t.event.smonth,t.event.sday,t.event.syear);
					sendXMLRepMoveEvent(t.event,calendar);
					removeDOMEvent(t,calendar);
					addEventsToCalendar(calendar);
					}
					else if(value==2){}
				}
				dialogBox("<div style='font-size:18px'>This event is repeated.<br>I want to change times for:</div>",new Array("All occurrences","Just this occurrence","Cancel"),t.event,100,300);
			}
			else if(sendXMLResizeEvent(t.event,calendar))
			{
				removeDOMEvent(t,calendar);
				addEvent(t.event,preferredRCol,calendar);
			}
			else{alert("Error resizing event.");}
			
			h().style.display="none";
			c.lastMouseX=0;c.lastMouseY=0;
			document.onmousemove=null;
			document.onmouseup=null;
			return true;
	};
	
	a.cancelBubble=true;
	if(a.stopPropagation)a.stopPropagation();
	return false;
	};
}

//移动区间事件提交
function moveAreaEventHandler(a,cellNode,calendar)
{
	a=fixEvent(a);
	setActiveNode(cellNode,calendar);
	c.closestCell=cellNode.parentNode;
	c.lastMouseX=a.clientX;
	c.lastMouseY=a.clientY;
	h().style.height=cellNode.offsetHeight+"px";
	h().style.width=cellNode.offsetWidth+"px";
	h().style.top=o(cellNode,false)+"px";
	h().style.left=o(cellNode,true)+"px";
	if(cellNode.event.stime==_NOTIME)
	{
		h().innerHTML="<table>"+cellNode.innerHTML+"</table>";
		h().firstChild.style.border=cellNode.style.border;
		h().firstChild.style.height=cellNode.style.height;
		h().firstChild.style.width=cellNode.style.width;
		h().firstChild.style.backgroundColor=cellNode.style.backgroundColor;
	}
	else 
		h().innerHTML=cellNode.parentNode.innerHTML;

	cellNode.onmousemove=function()
	{
		h().style.display="block";
		this.onmousemove=null;
	};
	document.onmousemove=function(b)
	{
		b=fixEvent(b);
		var left=parseInt(h().style.left);
		var top=parseInt(h().style.top);
		showRect(left+b.clientX-c.lastMouseX,top+b.clientY-c.lastMouseY);
		c.lastMouseX=b.clientX;c.lastMouseY=b.clientY;
		return true;
	};
	document.onmouseup=function(b)
	{
		b=fixEvent(b);
		var left=parseInt(h().style.left);
		var top=parseInt(h().style.top);
		highlightClosestCell(left+b.clientX-c.lastMouseX,top+b.clientY-c.lastMouseY,calendar);
		getActiveNode(calendar).onmousemove=showCellDetails;

		if(c.closestCell!=null&&c.closestCell!=getActiveNode(calendar).parentNode)
		{
			var e=c.closestCell;
			if(c.highlightedCells!=null)
			{
				highlightCells(c.highlightedCells,_ORIGBORDERSTYLE,calendar);
			}
			c.highlightedCells=null;
			c.closestCell=null;
			var t=getActiveNode(calendar);
			var newdate=getDate(getVCol(e.rcol,calendar),calendar);
			var preferredRCol=e.rcol;
			var eventLength=t.event.etime-t.event.stime;
			if(eventLength <=0)eventLength=_TIMEINTERVAL;
			t.event.stime=getStartTime(e,calendar);
			t.event.etime=t.event.stime+eventLength;
			if(t.event.stime==_NOTIME)
				t.event.etime=_NOTIME;
			t.event.olddate=new Array(t.event.smonth,t.event.sday,t.event.syear);
			t.event.smonth=newdate[0];
			t.event.sday=newdate[1];
			t.event.syear=newdate[2];
			if(t.event.reptype!=0)
			{
				t.event.notify=function(value)
				{
					if(value==0)
					{
						sendXMLMoveEvent(t.event,calendar);
						hideEditLayer();
						removeAllEventsFromCalendar(calendar);
						addEventsToCalendar(calendar);
					}
					else if(value==1)
					{
						sendXMLRepMoveEvent(t.event,calendar);
						hideEditLayer();
						removeAllEventsFromCalendar(calendar);
						addEventsToCalendar(calendar);
					}
					else if(value==2){}
				}
				dialogBox("<div style='font-size:18px'>This event is repeated.<br>I want to move for:</div>",new Array("All occurrences","Just this occurrence","Cancel"),t.event,100,300);
			}
			else if(sendXMLMoveEvent(t.event,calendar))
			{
				removeDOMEvent(t,calendar);
				t=addEvent(t.event,preferredRCol,calendar);
			}
			else{alert("Error moving event.");}
			setActiveNode(t,calendar);
		}
		h().style.display="none";
		c.lastMouseX=0;c.lastMouseY=0;
		document.onmousemove=null;
		document.onmouseup=null;
		return false;
	};
	a.cancelBubble=true;
	if(a.stopPropagation){a.stopPropagation();}
	return false;
}
//获取开始时间
function getStartTime(cell,calendar)
{
	var r;
	if(cell.rowstart==_TIMELESSROW)
	{r=_NOTIME;}
	else{r=calendar.starttime+cell.rowstart*_TIMEINTERVAL;}
	return r;
}
//高亮靠近单元
function highlightClosestCell(x,y,calendar)
{
	Assert(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW,"cal not week or day view!");
	var e=null;
	var d=getActiveNode(calendar);
	var ht=d.parentNode.rowSpan;
	var closestRow;
	var closestCol;
	var ff=10000000;
	var gg=10000000;
	for(var i=0;i<calendar.numrows-ht+1;i++)
	{
		var td=getRowHeader(i,calendar);
		if(ff>Math.abs(o(td,false)-y))
		{
			ff=Math.abs(o(td,false)-y);
			closestRow=i;
		}
	}
	var td=getRowHeader(_TIMELESSROW,calendar);
	if(ff>Math.abs(o(td,false)-y))
	{
		ff=Math.abs(o(td,false)-y);
		closestRow=_TIMELESSROW;
	}
	for(var i=0;i<calendar.numrcols;i++)
	{
		var td=getTD(0,i,calendar,true);
		if(closestRow==_TIMELESSROW&&i<calendar.numvcols)
			td=getTD(_TIMELESSROW,i,calendar,true);
		if(gg>Math.abs(o(td,true)-x))
		{
			gg=Math.abs(o(td,true)-x);
			closestCol=i;
		}
	}
	
	e=getTD(closestRow,closestCol,calendar,true);
	if(e==c.closestCell){return e;}
	else if(e!=null&&e!=d)
	{
		if(c.highlightedCells!=null&&c.closestCell!=null&&c.closestCell!=e)
		{
			highlightCells(c.highlightedCells,_ORIGBORDERSTYLE,calendar);
			c.highlightedCells=null;
		}
		var row=e.rowstart;
		var col=e.rcol;
		if(row==_TIMELESSROW)
		{
		c.highlightedCells=new Array(1);
		c.highlightedCells[0]=e;
		}
		else{
			c.highlightedCells=new Array(ht);
			for(var i=0;i<ht;i++)
			{
				var td=getTD(row+i,col,calendar,true);
				c.highlightedCells[i]=td;
			}
		}
	highlightCells(c.highlightedCells,_CELLBORDERHIGHLIGHTSTYLE,calendar);
	c.closestCell=e;
	return e;
	}
	else if(e!=null)return e;
	else{return null;
	}
}
//高亮单元
function highlightCells(cellArray,style,calendar)
{
	var row=cellArray[0].rowstart;
	var col=cellArray[0].rcol;
	for(var i=0;i<cellArray.length;i++)
	{
		var td=getTD(row+i,col,calendar,true);
		if(td==null)continue;
		if(i==0)
		{
			if(style==_ORIGBORDERSTYLE){td.style.borderTop=td.borderTopO;}
			else{td.style.borderTop=style;}
		}
		if(style==_ORIGBORDERSTYLE)
			td.style.borderLeft=td.borderLeftO;
		else{td.style.borderLeft=style;}

		var td2=getTD(row+i,col+1,calendar,true);
		if(td2!=null)
		{
			if(style==_ORIGBORDERSTYLE)td2.style.borderLeft=td2.borderLeftO;
			else{td2.style.borderLeft=style;}
		}
	}
	if(row==_TIMELESSROW)
	{
		var rcs=getRCol(col,calendar);
		for(var i=0;i<rcs.length;i++)
		{
			var td=getTD(0,rcs[i],calendar,true);
			if(style==_ORIGBORDERSTYLE)
				td.style.borderTop=td.borderTopO;
			else{td.style.borderTop=style;}
		}
	}
	else{
		var td=getTD(row+cellArray.length,col,calendar,true);
		if(td!=null)
		{
			if(style==_ORIGBORDERSTYLE)
				td.style.borderTop=td.borderTopO;
			else{td.style.borderTop=style;}
		}
	}
}
//高亮靠近单元以下
function highlightClosestCellBelow(x,y,calendar)
{if(c.closestCell!=null){for(var i=0;i<calendar.numrcols;i++){var td=getTD(c.closestCell.rowstart+1,i,calendar,true)
if(td!=null)
td.style.borderTop=td.borderTopO;}
}
var e=null;var f=100000000;var p=getActiveNode(calendar).parentNode;var useThisCol=p.rcol;
if(calendar.hasRowHeaders)useThisCol=-1;for(var i=p.rowstart;i<calendar.numrows;i++){var g=getTD(i,useThisCol,calendar,true);var l=Math.abs(o(g,false)+g.clientHeight-y);if(isNaN(l))continue;if(l<f){f=l;e=g}
}
if(e!=null&&e!=getActiveNode(calendar)){for(var i=0;i<calendar.numrcols;i++){var td=getTD(e.rowstart+1,i,calendar,false);if(td!=null)td.style.borderTop=_CELLBORDERHIGHLIGHTSTYLE;}
c.closestCell=e;return e;}else{alert("highlightClosestCellBelow: could not find closest cell");return null;}
}
//高亮靠近单元以上
function highlightClosestCellAbove(x,y,calendar){if(c.closestCell!=null)
{for(var i=0;i<calendar.numrcols;i++){getTD(c.closestCell.rowstart,i,calendar,true).style.borderTop=getTD(c.closestCell.rowstart,i,calendar,true).borderTopO;}
}
var e=null;var f=100000000;var p=getActiveNode(calendar).parentNode;var useThisCol=p.rcol;
if(calendar.hasRowHeaders)useThisCol=-1;for(var i=0;i<=p.rowend;i++){var g=getTD(i,useThisCol,calendar,true);var l=Math.abs(o(g,false)-y);
if(isNaN(l))continue;if(l<f){f=l;e=g}
}
if(e!=null&&e!=getActiveNode(calendar)){for(var i=0;i<calendar.numrcols;i++){getTD(e.rowstart,i,calendar,false).style.borderTop=_CELLBORDERHIGHLIGHTSTYLE;}
c.closestCell=e;return e;}else{alert("highlightClosestCellAbove: could not find closest cell");return null;}
}
//返回对象的OffsetLeft或OffsetTop
function o(a,c)
{
	var b=0;
	while(a!=null)
	{
		b+=a["offset"+(c?"Left":"Top")];
		a=a.offsetParent;
	}
	return b;
}
//显示矩行
function showRect(x,y){h().style.top=y+"px";h().style.left=x+"px";}
//调整矩行
function resizeRect(height,width){h().style.height=height+"px";h().style.width=width+"px";}

var n;
function h()
{
	if(!n)
	{
		n=document.createElement("DIV");
		n.style.display="none";
		n.style.position="absolute";
		n.style.cursor="move";
		n.style.top="10px";
		n.style.left="10px";
		document.body.appendChild(n);
	}
	return n;
}
//更改时间格式
function changeTimeFormat(format,calendar){_CLOCK=format;changeRowHeadings(timesToString(calendar.starttime,calendar.stoptime),calendar);}
//更改日期格式
function changeDateFormat(format,calendar)
{
	_DATE=format;
	changeColHeadings(datesToString(calendar),calendar);
}
//刷新事件
function refreshEvent(event,cellNode,calendar)
{
	if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
	{
		var preferredRCol=cellNode.parentNode.rcol;
		removeDOMEvent(cellNode,calendar);
		addEvent(event,preferredRCol,calendar);
	}
	else if(calendar.view==_MONTHVIEW)
	{
		if(event.catcolor!=null)
			cellNode.style.backgroundColor="#"+event.catcolor;
		cellNode.innerHTML=singleMonthEventHtml(event);
	}
}
//单元内的HTML
function cellHtml(event)
{
	var table=document.createElement("TABLE");
	var margin=_MARGIN;
	table.event=event;
	table.style.width="100%";
	table.style.border="0";
	table.cellSpacing="0";
	table.cellPadding="0";
	if(event.catcolor!=null&&event.catcolor!="")
	{
		table.style.backgroundColor="#"+event.catcolor;
		table.style.filter="alpha(Opacity=100, FinishOpacity=50, Style=1, StartX=0, StartY=0, FinishX="+_CELLWIDTHPX*2+", FinishY=0)";
	}
	table.style.border=_TABLEBORDERSTYLE;
	var tb=document.createElement("TBODY");
	table.appendChild(tb);
	var row1=document.createElement("TR");	var row2=document.createElement("TR");	var row3=document.createElement("TR");
	var td1=table.td1=document.createElement("TD");	var td2=table.td2=document.createElement("TD");	var td3=table.td3=document.createElement("TD");
	var td4=table.td4=document.createElement("TD");	var td5=table.td5=document.createElement("TD");	var td6=table.td6=document.createElement("TD");
	var td7=table.td7=document.createElement("TD");	var td8=table.td8=document.createElement("TD");	var td9=table.td9=document.createElement("TD");
	row1.appendChild(td1);row1.appendChild(td2);row1.appendChild(td3);
	row2.appendChild(td4);row2.appendChild(td5);row2.appendChild(td6);
	row3.appendChild(td7);row3.appendChild(td8);row3.appendChild(td9);
	tb.appendChild(row1);
	tb.appendChild(row2);
	tb.appendChild(row3);
	td1.style.height=margin;
	td1.style.width=margin;
	td2.style.height=margin;
	td3.style.width=margin;
	td3.style.height=margin;
	td4.style.width=margin;
	td6.style.width=margin;
	td4.style.height=td5.style.height=td6.style.height=_CELLHEIGHTPX-margin*2-8;
	td7.style.height=margin;
	td7.style.width=margin;
	td8.style.height=margin;
	td9.style.width=margin;
	td9.style.height=margin;
	td5.align="center";
	td5.appendChild(document.createElement("DIV"));
	table.subjectElement=td5.firstChild;
	var theimg='';
	if(event.priv=='1'){theimg="<IMG SRC='"+_IMG_PRIVATE+"'>";}
	else if(event.favoriteonly=='1'){theimg="<IMG SRC='"+_IMG_FAVONLY+"'>";}

	table.subjectElement.innerHTML=theimg+event.subject;
	//table.subjectElement.style.fontFamily=_USERFONT;
	table.subjectElement.style.fontSize="10px";
	return table;
}
//追加月事件
function appendMonthEvent(DOMNode,event,calendar)
{
	var elist;
	if(DOMNode.eventsList==null)
	{
		elist=new Array(1);
		elist[0]=event;
	}
	else
	{
		elist=new Array(DOMNode.eventsList.length+1);
		for(var i=0;i<elist.length-1;i++)
			{elist[i]=DOMNode.eventsList[i];}
		elist[elist.length-1]=event;
	}
	return cellMonthHtml(event.smonth,event.sday,event.syear,elist,calendar);
}
//添加月日更改事件监听
function addMonthDayChangeListener(cellMonthHtml,calendar)
{
	Assert(calendar.view==_MONTHVIEW,"addMonthDayChangeLister: cal not monthview");
	var cm=cellMonthHtml;
	var cl=calendar;
	cm.dayElement.onmouseover=divHighlightHandler;
	cm.dayElement.onmouseout=function(){this.style.backgroundColor="transparent"};
	cm.dayElement.style.cursor="pointer";
	cm.dayElement.style.width="15px";
	cm.dayElement.onmousedown=function()
		{setNavCurrentCalendar(calendar.navbar,makeCalendar(cl.month,this.day,cl.year,cl.starttime,cl.stoptime,_DAYVIEW,cl.owner,cl.parent));}
}
//刷新月单元
function refreshMonthCell(day,calendar)
{
	Assert(calendar.view==_MONTHVIEW,"refreshMonthCell:not monthview!");
	var row=weekOfMonth(calendar.month,day,calendar.year)-1;
	var col=dayOfWeek(calendar.month,day,calendar.year);
	var td=getTD(row,col,calendar,true);
	var events=td.firstChild.eventsList;removeCell(td.firstChild,calendar);
	var cellNode=cellMonthHtml(calendar.month,day,calendar.year,events,calendar);
	addCell(row,row,col,col,cellNode,calendar);
	addMonthNonOwnerListeners(cellNode,calendar);
	if(calendar.owner){addMonthListeners(cellNode,calendar);}
}
//单月事件HTML
function singleMonthEventHtml(ev)
{
	var theimg='';
	if(ev.priv=='1'){theimg="<IMG SRC='"+_IMG_PRIVATE+"'>";}
	else if(ev.favoriteonly=='1'){theimg="<IMG SRC='"+_IMG_FAVONLY+"'>";}
	
	return theimg+"<span style='font-size:12px;color:white;'>"+ev.subject+" "+timeToString(ev.stime,_12HOURSHORT)+"</span>";
}
//月单元HTML
function cellMonthHtml(month,day,year,events,calendar)
{
	var cell=document.createElement("DIV");
	cell.eventsList=events;
	cell.style.margin="0px";
	var c2=document.createElement("DIV");
	var dayElement=document.createElement("DIV");
	var today=new Date();
	dayElement.innerHTML=day;
	dayElement.day=day;
	cell.dayElement=dayElement;
	c2.appendChild(dayElement);
	c2.style.fontSize="10px";
	if(today.getMonth()+1==month&&today.getDate()==day&&today.getFullYear()==year)
	{
		//c2.style.fontSize="13px";
		c2.style.backgroundColor = "#BBCCDD";
		c2.style.fontWeight="bold";
		cell.style.backgroundColor = "#ffffcc";
	}
	else
		c2.style.backgroundColor = "#E8EEF7";
		
	cell.appendChild(c2);
	if(events!=null)
	{
		for(var i=0;i<events.length;i++)
		{
			var ev=events[i];
			var c3=document.createElement("DIV");
			c3.innerHTML=singleMonthEventHtml(ev);
			if(ev.catcolor!=null&&ev.catcolor!="")
				c3.style.backgroundColor="#"+ev.catcolor;
			c3.style.fontSize="12px";
			c3.event=ev;
			c3.style.border=_CELLBORDERSTYLE;
			cell.appendChild(c3);
		}
	}
	addMonthDayChangeListener(cell,calendar);
	return cell;
}
//添加月无所属监听
function addMonthNonOwnerListeners(cellNode,calendar)
{
	var divs=cellNode.getElementsByTagName("DIV");
	for(var i=1;i<divs.length;i++)
	{
		var c3=divs[i];
		if(c3.event!=null)
		{
			//c3.onmouseover=showCellDetails;
			//c3.onmouseout=function(){hideToolTip();};
		}
	}
}
//添加月日历监听
function addMonthListeners(cellNode,calendar)
{
	var divs=cellNode.getElementsByTagName("DIV");
	for(var i=1;i<divs.length;i++)
	{
		var c3=divs[i];
		if(c3.event!=null)
		{
			c3.style.cursor="move";
			c3.ondblclick=function()
			{
				showEditLayer(this,calendar,false);
			};
			c3.onmousedown=function(a)
			{
				a=fixEvent(a);
				resizeRect(this.offsetHeight,this.offsetWidth);
				showRect(o(this,true),o(this,false));
				c.highlightedCells=null;
				c.lastMouseX=a.clientX;
				c.lastMouseY=a.clientY;
				if(c.activeMonthNode!=null)
					unhighlightMonthNode(c.activeMonthNode);
				setActiveNode(null,calendar);
				highlightMonthNode(this);
				c.activeMonthNode=this;
				document.onmousemove=function(a)
				{
					a=fixEvent(a);
					h().innerHTML="<div>"+c.activeMonthNode.innerHTML+"</div>";
					h().firstChild.style.border=c.activeMonthNode.style.border;
					h().firstChild.style.backgroundColor=c.activeMonthNode.style.backgroundColor;
					h().firstChild.style.height=c.activeMonthNode.style.height;
					h().firstChild.style.width=c.activeMonthNode.style.width;
					h().firstChild.style.textAlign="left";
					h().style.display="block";
					showRect(parseInt(h().style.left)-c.lastMouseX+a.clientX,parseInt(h().style.top)-c.lastMouseY+a.clientY);
					c.lastMouseX=a.clientX;
					c.lastMouseY=a.clientY;
					highlightClosestMonthCell(parseInt(h().style.left)+parseInt(h().style.width)/2-c.lastMouseX+a.clientX,parseInt(h().style.top)+parseInt(h().style.height)/2-c.lastMouseY+a.clientY,calendar);
				}
				document.onmouseup=function()
				{
					h().style.display="none";
					var cell=c.activeMonthNode;
					if(c.closestCell!=null&&cell!=null)
					{
						var cc=c.closestCell;
						var event=cell.event;
						event.olddate=new Array(event.smonth,event.sday,event.syear);
						event.sday=cc.day;
						if(event.reptype!=0)
						{
							event.notify=function(value)
							{
								if(value==0)
								{
									sendXMLMoveEvent(event,calendar);
									removeAllEventsFromCalendar(calendar);
									addEventsToCalendar(calendar);
								}
								else if(value==1)
								{
									sendXMLRepMoveEvent(event,calendar);
									removeDOMEvent(cell,calendar);
									addEvent(event,0,calendar);
								}
								else if(value==2){}
							}
							dialogBox("<div style='font-size:18px'>This event is repeated.<br>I want to move for:</div>",new Array("All occurrences","Just this occurrence","Cancel"),event,100,300);
						}
						else if(sendXMLMoveEvent(event,calendar))
						{
							removeDOMEvent(cell,calendar);
							addEvent(event,0,calendar);
						}
						else{alert("Error in adding event.");}
						highlightCells(new Array(c.closestCell),_ORIGBORDERSTYLE,calendar);
					}
					c.closestCell=null;
					document.onmousemove=null;
					document.onmouseup=null;
			}
			return false;
		}
	}
  }
}
//高亮月节点
function highlightMonthNode(node){node.style.border=_CELLBORDERHIGHLIGHTSTYLE;}
//取消高亮节点
function unhighlightMonthNode(node){node.style.border=_CELLBORDERSTYLE;}
//高亮靠近月单元
function highlightClosestMonthCell(x,y,calendar){var e=null;var f=100000000;for(var i=0;i<calendar.numrows;i++){for(var j=0;j<calendar.numrcols;j++){var g=getTD(i,j,calendar,true);var l=Math.sqrt(Math.pow(x-o(g,true)-g.offsetWidth/2,2)+Math.pow(y-o(g,false)-g.offsetHeight/2,2));if(isNaN(l))l=100000000;if(l<f&&!g.empty){f=l;e=g;}
}
}
if(e==c.closestCell){return e;}else if(e!=null){if(c.highlightedCells!=null&&c.closestCell!=null&&c.closestCell!=e){highlightCells(c.highlightedCells,_ORIGBORDERSTYLE,calendar);}
c.highlightedCells=new Array(1);var td=getTD(e.rowstart,e.rcol,calendar,true);highlightCells(new Array(td),_CELLBORDERHIGHLIGHTSTYLE,calendar);c.highlightedCells[0]=td;c.closestCell=e;return e;}else{alert("highlightClosestMonthCell: could not find closest cell");return null;}
}
//设置激活单元
function setActiveNode(node,calendar)
{
	if(node==null)
		{document.onkeydown=null;document.onkeypress=null;}
	if(calendar.view==_WEEKVIEW||calendar.view==_DAYVIEW)
	{
		if(calendar.activeNode==node){return;}
		if(calendar.activeNode!=null){calendar.activeNode.style.border=_TABLEBORDERSTYLE;}
		calendar.activeNode=node;
		if(node!=null)
		{
				document.onkeydown=function(a)
				{
					a=fixEvent(a);
					if(a.which==46)
					{
						var event=getActiveNode(calendar).event;
						if(event.reptype!=0)
						{
							event.notify=function(value)
							{
								if(value==0)
								{
									sendXMLDeleteEvent(event,calendar);
									removeAllEventsFromCalendar(calendar);
									addEventsToCalendar(calendar);
								}
								else if(value==1)
								{
									sendXMLRepDeleteEvent(event,calendar);
									removeDOMEvent(getActiveNode(calendar),calendar);
								}
								else if(value==2)
								{
									var daybefore=dayBefore(new Array(event.smonth,event.sday,event.syear));
									event.enddate=daybefore[0]+"/"+daybefore[1]+"/"+daybefore[2];
									sendXMLEditEvent(event,calendar);
									removeAllEventsFromCalendar(calendar);
									addEventsToCalendar(calendar);
								}else if(value==3){}
							}
							dialogBox("<div style='font-size:18px'>This event is repeated.<br>Which ones do you want to delete?</div>",new Array("All occurrences","Just this occurrence","Future occurrences","Cancel"),event,100,450);
						}
						else
							if(confirm("Delete event?"))
							{
								if(sendXMLDeleteEvent(getActiveNode(calendar).event,calendar))
								{
									if(calendar.view==_DAYVIEW||calendar.view==_WEEKVIEW)
										removeDOMEvent(getActiveNode(calendar),calendar);
									else if(calendar.view==_MONTHVIEW)
									{removeDOMEvent(getActiveNode(calendar),calendar);}
								}
								else{alert("Error in deleting event.");}
							}
						a.returnValue=false;
					}
					return a.returnValue;
			};
			window.onkeypress=function(a)
			{
				a.returnValue=true;
				var pressedKey=String.fromCharCode(a.which).toLowerCase();
				if(a.ctrlKey&&pressedKey=="c")
				{
					var e=calendar.activeNode.event;
					calendar.clipboard=copyEvent(e);
					setStatusDiv("Event "+calendar.clipboard.subject+" copied.");
					a.returnValue=false;
				}
			}
			calendar.activeNode.style.border=_CELLBORDERHIGHLIGHTSTYLE;
			setCorners(null,null,null,null,calendar);
		}
		resetNewEventDiv(calendar);
	}
	else if(calendar.view==_MONTHVIEW)
	{
		if(calendar.activeNode==node){return;}
		if(calendar.activeNode!=null){highlightCells(new Array(calendar.activeNode),_ORIGBORDERSTYLE,calendar);}
		calendar.activeNode=node;
		if(node!=null)
		{
			highlightCells(new Array(calendar.activeNode),_CELLBORDERHIGHLIGHTSTYLE,calendar);
			setCorners(null,null,null,null,calendar);
		}
		resetNewEventDiv(calendar);
	}
}
//获取激活单元
function getActiveNode(calendar){return calendar.activeNode;}
//判断是否为激活单元
function isActiveNode(node,calendar){if(node==calendar.activeNode)return true;else return false;}
//corner定义
function cornersDefined()
{
	if(c.corner1!=null&&c.corner2!=null&&c.corner3!=null&&c.corner4!=null)
		return true;
	else 
		return false;
}
//设置角
function setCorners(c1,c2,c3,c4,calendar)
{
	if(c1!=null||c2!=null||c3!=null||c4!=null)
		c.cornersCalendarOwner=calendar;
	setCornerStyles(_ORIGBORDERSTYLE,calendar);
	hideToolTip();
	if(c1!=true)c.corner1=c1;
	if(c2!=true)c.corner2=c2;
	if(c3!=true)c.corner3=c3;
	if(c4!=true)c.corner4=c4;
	if(cornersDefined())
	{
		setActiveNode(null,calendar);
		showAddEventTips(rotateCorners()[0],calendar);
	}
	else{document.onkeypress=null;}
	setCornerStyles(_CELLBORDERHIGHLIGHTSTYLE,calendar);
}
//转动四角
function rotateCorners()
{
	var c1,c2,c3,c4;
	if(c.corner4.rowstart<c.corner1.rowstart&&c.corner4.rcol<c.corner1.rcol)
	{
		c1=c.corner4;
		c2=c.corner3;
		c3=c.corner2;
		c4=c.corner1;
	}
	else if(c.corner4.rowstart<c.corner1.rowstart&&c.corner4.rcol>=c.corner1.rcol)
	{
		c1=c.corner3;
		c2=c.corner4;
		c3=c.corner1;
		c4=c.corner2;
	}
	else if(c.corner4.rowstart>=c.corner1.rowstart&&c.corner4.rcol<c.corner1.rcol)
	{
		c1=c.corner2;c2=c.corner1;c3=c.corner4;c4=c.corner3;
	}
	else if(c.corner4.rowstart>=c.corner1.rowstart&&c.corner4.rcol>=c.corner1.rcol)
	{
		c1=c.corner1;c2=c.corner2;c3=c.corner3;c4=c.corner4;
	}
	return new Array(c1,c2,c3,c4);
}
//所有是否为空
function allEmpty(grid)
{
	var r=rotateCorners();
	var c1,c2,c3,c4;
	c1=r[0];c2=r[1];c3=r[2];c4=r[3];
	for(var i=c1.rowstart;i<=c3.rowstart;i++)
	{
		for(var j=c1.rcol;j<=c2.rcol;j++)
		{
			var td=getTD(i,j,grid,false);
			if(!td.empty)
				return false;
		}
	}
	return true;
}
//设置角样式
function setCornerStyles(style,grid)
{
	if(!cornersDefined())return;
	var r=rotateCorners();
	var c1,c2,c3,c4;c1=r[0];
	c2=r[1];c3=r[2];c4=r[3];
	if(c1.rowstart==_TIMELESSROW)
	{
		var td=getTD(_TIMELESSROW,c1.rcol,grid,true);
		if(style==_ORIGBORDERSTYLE)
		{
			td.style.borderTop=td.borderTopO;
			td.style.borderLeft=td.borderLeftO;
		}
		else
		{
			td.style.borderTop=style;
			td.style.borderLeft=style;
		}
		var rcs=getRCol(c1.rcol,grid);
		for(var i=0;i<rcs.length;i++)
		{
			td=getTD(0,rcs[i],grid,true);
			if(style==_ORIGBORDERSTYLE)
				td.style.borderTop=td.borderTopO;
			else 
				td.style.borderTop=style;
		}
		if((td=getTD(_TIMELESSROW,c1.rcol+1,grid,true))!=null)
		{
			if(style==_ORIGBORDERSTYLE)
				td.style.borderLeft=td.borderLeftO;
			else td.style.borderLeft=style;
		}
		return;
	}
	for(var i=c1.rcol;i<=c2.rcol;i++)
	{
		var td=getTD(c1.rowstart,i,grid,true);
		if(style==_ORIGBORDERSTYLE)
			td.style.borderTop=td.borderTopO;
		else 
			td.style.borderTop=style;
			
		td=getTD(c3.rowstart+1,i,grid,true);
		if(td!=null)
		{
			if(style==_ORIGBORDERSTYLE)
				td.style.borderTop=td.borderTopO;
			else 
				td.style.borderTop=style;
		}
	}
	for(var i=c1.rowstart;i<=c3.rowstart;i++)
	{
		var td=getTD(i,c1.rcol,grid,true);
		if(style==_ORIGBORDERSTYLE)
			td.style.borderLeft=td.borderLeftO;
		else 
			td.style.borderLeft=style;
		td=getTD(i,c2.rcol+1,grid,true);
		if(td!=null)
		{
			if(style==_ORIGBORDERSTYLE)
				td.style.borderLeft=td.borderLeftO;
			else 
				td.style.borderLeft=style;
		}
	}
}
//清空日历
function cleanUpCalendar(calendar)
{
	if(calendar==null)return;
	setActiveNode(null,calendar);
	if(c.cornersCalendarOwner==calendar)
		setCorners(null,null,null,null,calendar);
	document.onmousedown=null;
	document.onmousemove=null;
	document.onmouseup=null;
	if(!isIE){}else{document.detachEvent('ondblclick',dblClickAddEvent);}

	hideEditLayer();
	hideToolTip();
	resetNewEventDiv(calendar);
	c.closestCell=null;
	c.highlightedCells=null;
}
//事件转换为字符串
function eventToString(e)
{
	var s="id: "+e.id;
	s+="\nsubject: "+e.subject;
	s+="\neventdesc: "+e.eventdesc;
	s+="\ncatid: "+e.catid;
	s+="\ncatname: "+e.catname;
	s+="\ncatcolor: "+e.catcolor;
	s+="\nstime: "+e.stime+"\netime: "+e.etime;
	s+="\ndate: "+e.smonth+"/"+e.sday+"/"+e.syear;
	s+="\nstartdate: "+e.startdate;
	s+="\nenddate: "+e.enddate;
	s+="\nemailnote: "+e.emailnote;
	s+="\nsmsnote: "+e.smsnote;
	s+="\nemailorsms: "+e.emailorsms;
	s+="\nalertbefore: "+e.alertbefore;
	s+="\nreptype: "+e.reptype;
	s+="\nrepnum: "+e.repnum;
	s+="\nrep: "+e.rep;
	s+="\nhasexclude: "+e.hasexclude;

	if(e.excludes!=null)
	{
		s+="\nexcludes: ";
		for(var i=0;i< e.excludes.length;i++)
			{s+=e.excludes[i]+";";}
	}
	s+="\npriv: "+e.priv;s+="\nfavonly: "+e.favoriteonly;
	return s;
}
//日历转换为字符串
function calendarToString(c)
{
	var s="month:"+c.month;
	s+="\nday:"+c.day;
	s+="\nyear:"+c.year;
	if(c.view==_DAYVIEW)s+="\ntype: dayview";
	if(c.view==_WEEKVIEW)s+="\ntype: weekview";
	if(c.view==_MONTHVIEW)s+="\ntype: monthview";
	s+="\nstime:"+c.starttime;
	s+="\netime:"+c.stoptime;
	return s;
}
//周日期转换为字符串
function datesToString(calendar)
{
	var colH=new Array("<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(0,calendar),_DATE_SMNAMED) + "(周日)</a>",
	"<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(1,calendar),_DATE_SMNAMED) + "(周一)</a>",
	"<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(2,calendar),_DATE_SMNAMED) + "(周二)</a>",
	"<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(3,calendar),_DATE_SMNAMED)+ "(周三)</a>",
	"<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(4,calendar),_DATE_SMNAMED)+ "(周四)</a>",
	"<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(5,calendar),_DATE_SMNAMED)+ "(周五)</a>",
	"<a style='font-size:"+_DAYFONTSIZE+"' href='#'>"+dateToString(getDate(6,calendar),_DATE_SMNAMED)+ "(周六)</a>");
	return colH;
}

//日历事件
function eventOnCalendar(event,cal)
{
	if(cal.view==_MONTHVIEW)
	{
		if(event.smonth!=cal.month)return false;
	}
	else if(cal.view==_DAYVIEW)
	{
		if(event.smonth!=cal.month||event.sday!=cal.day||event.syear!=cal.year)return false;
	}
	else if(cal.view==_WEEKVIEW)
	{
		if(getWeek(event.smonth,event.sday,event.syear)!=getWeek(cal.month,cal.day,cal.year))return false;
	}
	return true;
}
//显示单元详细
function showCellDetails(a)
{
	a=fixEvent(a);
	if(this.event!=null)
	{
		var txt="<i>event:</i> "+this.event.subject;
		txt+="<br><i>details:</i> "+this.event.eventdesc;
		if(this.event.stime!=_NOTIME)
			txt+="<br><i>time:</i> "+timeToString(this.event.stime,_CLOCK)+" — "+timeToString(this.event.etime,_CLOCK);
		txt+="<br><i>date:</i> "+dateToString(new Array(this.event.smonth,this.event.sday,this.event.syear));
		if(_DEBUG||_DEBUG2||_DEBUG3)
			txt=eventToString(this.event);
		showToolTip(a.clientX+document.body.scrollLeft+10,a.clientY+document.body.scrollTop+10,txt);
		toolTipStyle().fontSize="12px";
	}
	a.cancelBubble=true;
	if(a.stopPropagation)a.stopPropagation();
	return false;
	};
	
var statusDiv=null;
function setStatusDiv(content)
{
	if(statusDiv==null)
	{
		statusDiv=document.createElement("DIV");
		statusDiv.style.position="absolute";
		statusDiv.style.fontFamily=_USERFONT;
		statusDiv.style.fontSize="12px";
		statusDiv.style.color="#FFFFFF";
		statusDiv.style.backgroundColor="#CC4444";
		document.body.appendChild(statusDiv);
		statusDiv.onmouseover=function(){statusDiv.style.display="none"};
	}
	statusDiv.style.display="block";
	statusDiv.style.top=document.body.scrollTop;
	statusDiv.style.left=document.body.scrollLeft;
	if(statusDiv.hasChildNodes())
		statusDiv.removeChild(statusDiv.firstChild);
	statusDiv.innerHTML=content;
	setTimeout(function(){statusDiv.style.display="none"},3000);
}
//显示ToolTip
var toolTipDiv=null;
function showToolTip(x,y,content)
{
	if(toolTipDiv==null)
	{
		toolTipDiv=document.createElement("DIV");
		toolTipDiv.style.position="absolute";
		document.body.appendChild(toolTipDiv);
	}
	resetToolTipStyle();
	toolTipDiv.style.display="block";
	toolTipDiv.style.top=y+"px";
	toolTipDiv.style.left=x+"px";
	toolTipDiv.innerHTML=content;
}
//获取ToolTip样式
function toolTipStyle(){return toolTipDiv.style;}
//重置ToolTip样式
function resetToolTipStyle()
{
	toolTipDiv.style.border="1px solid #888888";
	toolTipDiv.style.fontSize="10px";
	toolTipDiv.style.fontFamily=_USERFONT;
	toolTipDiv.style.backgroundColor="#FFFFFF";
	toolTipDiv.style.filter="alpha(opacity=90)";
	toolTipDiv.style.opacity="0.9";
	toolTipDiv.style.padding="5px";
	toolTipDiv.style.zIndex=5;
	toolTipDiv.style.width="";
	toolTipDiv.style.height="";
}
//隐藏ToolTip
function hideToolTip(){if(toolTipDiv==null)return;else toolTipDiv.style.display="none";}
//文本高亮
function textHighlightHandler(){this.style.color=_TEXTHIGHLIGHTCOLOR;}
//取消文本高亮
function textUnhighlightHandler(){this.style.color=_TEXTCOLOR;}
//div高亮
function divHighlightHandler(){this.style.backgroundColor=_DIVHIGHLIGHTCOLOR;}
//取消div高亮
function divUnhighlightHandler(){this.style.backgroundColor=_DIVCOLOR;}

var DOW=new Array('','日','一','二','三','四','五','六');
var MOY=new Array('1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月');
var minical_cc;
var minical_nb;
var minical_elem='calpreview';
var minical_headerlight='E8EEF7';
var minical_headerdark='C3D9FF';
//获取小日历月
function minical_getMonth(year,month,day)
{
	var cc=minical_cc;
	var navbar=minical_nb;
	var cal=makeCalendar(month+1,day,year,cc.starttime,cc.stoptime,_MONTHVIEW,cc.owner,cc.parent);
	setNavCurrentCalendar(navbar,cal);
}
//获取小日历周
function minical_getWeek(year,month,day)
{
	var cc=minical_cc;
	var navbar=minical_nb;
	var cal=makeCalendar(month+1,day,year,cc.starttime,cc.stoptime,_WEEKVIEW,cc.owner,cc.parent);setNavCurrentCalendar(navbar,cal);
}
//获取小日历天
function minical_getDay(year,month,day)
{
	var cc=minical_cc;
	var navbar=minical_nb;
	var cal=makeCalendar(month+1,day,year,cc.starttime,cc.stoptime,_DAYVIEW,cc.owner,cc.parent);setNavCurrentCalendar(navbar,cal);
}
//注册小日历
function minical_registerCalendar(cc){minical_cc=cc;}
//注册小日历导航栏
function minical_registerNavbar(nb){minical_nb=nb;}
//获取js月
function makeJSMonth(month,year)
{
	var NUM_DOW=7;
	var NUM_DOM=31;
	var cal=new Date();
	var today=cal.getDate();
	var todaymon=cal.getMonth();
	var todayyear=cal.getFullYear();
	var day=cal.getDay();
	var res;
	var wtext='<img src=\'right_small.gif\' border=0>';
	cal.setDate(1);
	cal.setMonth(month);
	cal.setFullYear(year);
	var TR_s='<tr>';
	var TR_e='</tr>';
	var TD_s='<td><CENTER>';
	var TD_e='</CENTER></TD>';
	var TDW_s='<td class=\'linkedweek\'><CENTER>';
	var TDW_e='</CENTER></TD>';
	var TDHI_s="<td class='hiday'><CENTER>";
	var TDHI_e='</CENTER></TD>';
	var TDD_s='<td class=\'day\'><CENTER>';
	var TDD_e='</CENTER></TD>';
	var TH_s="<th>";
	var TH_e='</th>';
	res='<style>';
	res+="table.calendar { border: 1px solid #"+minical_headerdark+"; border-collapse:collapse;margin:0px 0px 10px 0px;}";
	res+="table.calendar A {text-decoration:none;font-size:10px;padding:2px;}";
	res+="table.calendar A:hover {background-color: #"+minical_headerdark+";text-decoration:none}";
	res+="table.calendar TR, table.calendar TD { border-collapse:collapse;}";
	res+="table.calendar TH { font-size:10px;background-color:#"+minical_headerlight+";}";
	res+="table.calendar TD A {font-size:10px;text-decoration:none; display:block; margin:0px 0px 2px 0px; }";
	res+="table.calendar TD A:hover {background-color:#"+minical_headerlight+";text-decoration:none}";
	res+="td.hiday { background-color:#"+minical_headerlight+";}";
	res+="A {text-decoration:none;font-size:10px;padding:0px;color:blue;}";
	res+="A:hover{text-decoration:underline;color:blue;}";
	res+='</style>';
	res+="<table border=0 class='calendar'>";
	res+='<th colspan=8>';
	res+='<a href=\'#\' onClick=\''+'minical_getMonth('+year+','+month+','+'1'+'); '+'makeJSMonth3('+month+','+year+','+'"'+minical_elem+'"'+'); '+'return false;'+	'\'><font color=darkblue>'+ year + '   ' + MOY[month] +'</font></a></th>';
	res+=TR_s;
	for(index=0;index < NUM_DOW+1;index++){res+=TH_s+DOW[index]+TH_e;}	
	res+=TD_e+TR_e+TR_s;
	var alweek=0;
	var skips='';
	for(index=0;index < cal.getDay();index++){skips+=TD_s+'  '+TD_e;alweek=1;}
	if(alweek)
	{
		res+=TDW_s+'<a href=\'#\' onClick=\''+'minical_getWeek('+year+','+month+','+1+'); return false;'+'\'>'+wtext+'</a>'+TDW_e+skips;
	}
	for(index=0;index < NUM_DOM;index++)
	{
		if(cal.getDate()> index)
		{
			week_day=cal.getDay();
			if(week_day==0)
			{
				res+=TR_s;
				res+=TDW_s+'<a href=\'#\' onClick=\''+'minical_getWeek('+year+','+month+','+cal.getDate()+'); return false;'+'\'>'+wtext+'</a>'+TDW_e;
			}
			if(week_day!=NUM_DOW)
			{
				var day=cal.getDate();
				if(today==cal.getDate()&&todaymon==cal.getMonth()&&todayyear==cal.getFullYear())
				{
					res+=TDHI_s+'<a href=\'#\' onClick=\''+'minical_getDay('+year+','+month+','+day+'); return false;'+'\'>'+day+'</a>'+TDHI_e;
				}
				else
				{
					res+=TDD_s+'<a href=\'#\' onClick=\''+'minical_getDay('+year+','+month+','+day+'); return false;'+'\'>'+day+'</a>'+TDD_e;
				}
			}
			if(week_day==NUM_DOW){cal+=TR_end;}
		}
		cal.setDate(cal.getDate()+1);
	}
	res+='</TD></TR></TABLE>';
	return res;
}

function Mod(a,b){return Math.round(a-(Math.floor(a/b)*b));}
//生成日期字符串
function makeDateStr(month,year){return month+':'+year;}
//生成js月
function updateJSMonth()
{
	var elem=document.getElementById('mpreview');
	var date=elem.options[elem.selectedIndex].value;
	var datearr=date.split(':');
	makeJSMonth3(parseInt(datearr[0]),parseInt(datearr[1]),minical_elem);
}
//生成js月导航
function makeJSMonthNav(month,year)
{
	var max=6;
	var res='';
	var box=document.getElementById('mpreview');
	var boxindex=0;
	box.options.length=max+max+1;
	var prevmon=month;
	var prevyear=year;
	for(i=max-1;i>=0;i--,boxindex++)
	{
		tempmon=prevmon;
		prevmon=Mod((prevmon-1),12);
		if(prevmon > tempmon){prevyear--;}
		box.options[i]=new Option(MOY[prevmon]+', '+prevyear,makeDateStr(prevmon,prevyear));
	}
	box.options[boxindex]=new Option(MOY[month]+', '+year,makeDateStr(month,year));
	box.options[boxindex].selected=true;boxindex++;
	var nextmon=month;
	var nextyear=year;
	for(i=0;i<max;i++)
	{
		tempmon=nextmon;
		var nextmon=Mod((nextmon+1),12);
		if(nextmon < tempmon){nextyear++;}
		box.options[boxindex++]=new Option(MOY[nextmon]+', '+nextyear,makeDateStr(nextmon,nextyear));
	}
}
//生成js月3
function makeJSMonth3(month,year,elem)
{
	makeJSMonthNav(month,year);
	var prevmon=Mod((month-1),12);
	var prevyear=year;
	if(prevmon > month){(prevyear--);}
	var nextmon=Mod((month+1),12);
	var nextyear=year;
	if(nextmon < month){(nextyear++);}
	var res;
	res=makeJSMonth(prevmon,prevyear);
	res+=makeJSMonth(month,year);
	res+=makeJSMonth(nextmon,nextyear);
	document.getElementById(elem).innerHTML=res;
}
//小日历初始化
function minical_init(month,year,elem){minical_elem=elem;makeJSMonth3(month-1,year,elem);}
//增加小日历
function minical_add(elem)
{
	minical_elem=elem;
	var res='';
	res+="<select id='mpreview' name='mpreview' size=1 onChange='updateJSMonth()'></select>";
	res+="<span id='"+elem+"'></span>";
	document.getElementById(elem).innerHTML=res;
	var date=new Date();
	makeJSMonth3(date.getMonth(),date.getFullYear(),elem);
}
//获取图片
function getNewHONImage(calendar)
{
	var url=_REQHOST+"?a=photos&req=hon";
	try
	{
		var http=getHTTPObject();
		if(http)
		{
			http.open("GET",url,true);
			http.onreadystatechange=function(){setNewHONImage(http,calendar)};
			http.send(null);
		}
	}catch(e){alert("firefox jacks up..."+e);}
}
//通过ID获取图片
function getNewHONImageById(string){getNewHONImage(document.getElementById(string).firstChild);}
//设置图片
function setNewHONImage(httpObj,calendar)
{
	if(httpObj.readyState==4&&httpObj.status==200)
	{
		results=httpObj.responseText;
		var parser=getXMLParser(results);
		if(parser.getElementsByTagName("bgimg")==null)return;
		if(parser.getElementsByTagName("navres")==null)return;
		var imgurl=parser.getElementsByTagName("bgimg")[0].firstChild.nodeValue;
		calendar.setBackground(imgurl);
		var i="<table class='calendar'><tr><td align='center'><div class='divlink' onmousedown='javascript:getNewHONImageById(\""+calendar.parent+"\")'><b><u>Next Image</u></b></div></tr>";
		var x=parser.getElementsByTagName("navres")[0].firstChild.nodeValue;
		i+="<tr><td>"+x.substring(9,x.length-3)+"</td></tr></table>";
		document.getElementById('hon_nav').innerHTML=i;
	}
}
