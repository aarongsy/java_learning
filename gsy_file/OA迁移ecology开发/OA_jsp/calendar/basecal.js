/*双击事件,获取鼠标点击的时间*/
function dblClickGrid(objDiv){
	var oEvent=window.event;
	var oElement=oEvent.srcElement;
	if(oElement.id=="colorDiv"){
		oElement=oElement.parentElement;
	}
	var time1="",time2="";
	var num=oElement.id.substring(1);
	if(num%2==1){
		time1=(num-1)/2+7+":30";
		time2=(num-1)/2+8+":00";
	}else{
		time1=num/2+7+":00";
		time2=num/2+7+":30";
	}
	openEventWin(time1,time2);
}
/*单击事件,单元格变为浅黄色*/
function clickGrid(objDiv){
	var oEvent=window.event;
	var oElement=oEvent.srcElement;
	changeColor(oElement);//改变颜色
}
/*打开事件添加窗口*/
function openEventWin(time1,time2){
	var year=$("theYear").value;
	var month=$("theMonth").value*1+1;
	var day=$("theDay").value;
	var url="/calendar/event/eventcreate.jsp";
	var parameters="year="+year+"&month="+month+"&day="+day+"&time1="+time1+"&time2="+time2;
	openDivWin(url+"?"+parameters,700,450);
}
/*打开DIV窗口*/
function openDivWin(url,width,height){
	var maskDiv=$("maskDiv");
	var eventDiv=$("eventDiv");
	var eventFrame=$("eventFrame");
	maskDiv.style.display="";
	eventDiv.style.display="";
	eventDiv.style.zIndex =200;
	eventDiv.style.posission="absolute";
	eventDiv.style.width=width;
	eventDiv.style.height=height;
	eventDiv.style.left=50;
	eventDiv.style.top=30;
	eventFrame.src=url;
	eventFrame.height=height;
	eventFrame.width=width;
}
/*打开窗口*/
function openWin(url,title,width,height){
	var left=(screen.width-width)/2;
	var top=(screen.height-height)/2-30;
	window.open(url, title, "height="+height+", width="+width+", top="+top+", left="+left+", toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}
/*改变单元格颜色*/
function changeColor(objDiv){
	var oldDiv=$("colorDiv");
	if(oldDiv!=null){
		oldDiv.removeNode(true);
	}
	var oDiv=document.createElement("DIV");
	oDiv.id="colorDiv";
	oDiv.styleSheets=objDiv.styleSheets;
	oDiv.style.position="relative";
	oDiv.style.width="100%";
	oDiv.style.height="3ex";	
	oDiv.style.backgroundColor="#fbfda5";
	oDiv.style.marginLeft="3px";
	oDiv.style.border="none";
	objDiv.appendChild(oDiv);	
}

/*点击小日历事件*/
function clickCal(flag){
	var year=$("theYear").value;
	var month=$("theMonth").value;
	var oElement=window.event.srcElement;
	var day=oElement.innerText;
	changeCal(year,month,flag,day);
	getEvent(year,month,flag,day);
}
/*调用后台方法重新生成minicalendar*/
function getMiniCal(flag){
	var year=$("theYear").value;
	var month=$("theMonth").value;
	var xmlhttp=new Ajax();
	var url="../ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction";
	var parameters="action=getMiniCal&year="+year+"&month="+month+"&flag="+flag;
	var miniCal=$("minical");
	xmlhttp.open("GET",url+"?"+parameters,true);	
	xmlhttp.onreadystatechange=function(){
	    if (xmlhttp.readyState == 4) {
	        if (xmlhttp.status == 200) {
				var miniCalHtml=xmlhttp.responseText;
				miniCal.innerHTML=miniCalHtml;
	        }else{
				alert("数据读取发生异常，请稍后在试");
			}
	    }
	}	
	xmlhttp.send(null);
}
/*获取大日历中的事件*/
function getEvent(year,month,flag,day){
	
}
/*修改大日历中的时间显示*/
function changeCal(year,month,flag,day){
	//alert(year+"年"+month+"月"+day+"日");
}
function Ajax(){
	var xmlhttp;
	if (window.XMLHttpRequest) {
	   xmlhttp = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
	   xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	return xmlhttp;
}
function $(id){
	return document.getElementById(id);
}