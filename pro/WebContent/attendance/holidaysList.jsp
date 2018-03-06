<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/e2cs_cn.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/e2cs_pack.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/ux/css/calendar.css">
<style>
<!--
.x-window-footer table,.x-toolbar table{width:auto;}
.monthDay{text-align:center;height:40px;light-height:40px;vertical-align:middle;}
.weekendDay{color:#cccccc;background-color:#F1F1F1;}
.holiday{background-color:#F1F1F1 !important;color:#cccccc !important;}
.workday{background-color:#FFFFFF !important;color:#000000 !important;}
-->
</style>
<script type="text/javascript">
var weekPos1='<c:out value="${weekPos1}"/>';
var weekPos2='<c:out value="${weekPos2}"/>';
var month='<c:out value="${month}"/>';
var nWeek=<c:out value="${nWeek}"/>-1;
var days=<c:out value="${days}"/>-1;
var holidays=<c:out value="${holidays}" escapeXml="false"/>;
function initCal(){
	var tb=Ext.getDom('calTable');
	var rows=tb.rows;
	var row=null,cells=null;
	var index=1;
	var isBreak=false,day=null;
	for(var i=1;i<rows.length;i++){
		row=rows[i];
		cells=row.cells;
		for(var j=0;j<7;j++){
			if(i==1 && j<nWeek)continue;
			cells[j].innerHTML=index;
			cells[j].className='monthDay';
			if(j==0 || j==6){
				cells[j].className+=' weekendDay';
			}
			day=month+'-'+(index<=9?'0'+index:index);
			if(typeof(holidays[day])=='object'){//end.if
				var clsName=holidays[day].isHoliday?'holiday':(holidays[day].isWorkday?'workday':'');
				if(clsName!='') cells[j].className+=' '+clsName;
			}
			if(index>days){isBreak=true;break;}
			index+=1;
		}//end.for
		if(isBreak)break;
	}
}

function showMenu(e){
	e.stopEvent();
	activeTd=e.getTarget();
	var isWeekend=(activeTd.cellIndex==0 || activeTd.cellIndex==6);
	var isHoliday=activeTd.className.indexOf('holiday')>0;
	var isWorkday=activeTd.className.indexOf('workday')>0;
	if(isWeekend) isHoliday=isWorkday?false:true;
	else isHoliday=isHoliday?true:false;//周一至五默认为工作日

	ctxMenu.items.get(0).setDisabled(isHoliday);//holiday
	ctxMenu.items.get(1).setDisabled(!isHoliday);//workday
	ctxMenu.showAt(e.getXY());
}
function syncServerSet(btn){
	var el=new Ext.Element(activeTd);
	var isHoliday=(btn.id=='holiday');
	var isWorkday=(btn.id=='workday');
	var day=Ext.util.Format.htmlDecode(activeTd.innerHTML);
	var weekend=(activeTd.cellIndex==0 || activeTd.cellIndex==6);
	if(day.length==1) day='0'+day;
	Ext.Ajax.request({
	   url: contextPath+'/ServiceAction/com.eweaver.attendance.servlet.HolidaysAction?action=update',
	   success: function(res){
	   	el.removeClass((btn.id=='workday')?'holiday':'workday');
		el.addClass((btn.id=='workday')?'workday':'holiday');
	   	//alert('set:'+res.responseText);
	   },
	   failure: function(res){alert('Error:'+res.responseText);},
	   method:'POST',
	   params:{'day':month+'-'+day,
	   		'weekend':weekend,
	   		'holiday':isHoliday,
	   		'workday':isWorkday
	   	}
	});
}
function setDay(btn){

}
var activeTd=null;
var ctxMenu=null;
Ext.onReady(function(){
	initCal();
	ctxMenu=new Ext.menu.Menu({
		items: [{id:'holiday',text: '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790033")%>',handler:syncServerSet},//设置为假期
			{id:'workday',text: '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790034")%>',handler:syncServerSet}]//设置为工作日
	});
	Ext.EventManager.on("calTableBody", 'contextmenu', showMenu);	
});
function addMonth(nIndex){
	var dt =Date.parseDate(month,'Y-m').add(Date.MONTH, nIndex);
	var url=contextPath+'/ServiceAction/com.eweaver.attendance.servlet.HolidaysAction?month='+dt.format('Y-m');
	location.replace(url);
}

</script>
</head>

<body>
<style type="text/css">
#calHeader{font-weight:bold;background-color:#EEEEEE;}
.holidaySpan{background-color:#EEEEEE}
.calHeader td{height:20px !important;text-align:center;}
#calTable td{height:40px;}
</style>
<br/>
<div><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790035")%><!-- (*右击需要更改工作日和假期的单元格) --></div>
<table style="width:500px" align="center">
<tr><td>&nbsp;&nbsp;<a href="javascript:;" onclick="addMonth(-1);"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790036")%><!-- 上一月 --></a></td>
<td align="center"><c:out value="${month}"/></td>
<td align="right"><a href="javascript:;" onclick="addMonth(1);"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790037")%><!-- 下一月 --></a>&nbsp;&nbsp;</td></tr>
</table>
<table id="calTable" style="width:500px" align="center" border="1" style="border-collapse:collapse;" bordercolor="#CCCCCC" cellspacing="0" cellpadding="0">
    <tr class="calHeader">
        <td><%=labelService.getLabelNameByKeyId("402883d934c1f3e80134c1f3e8c40000")%><!-- 日 --></td>
        <td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790038")%><!-- 一 --></td>
        <td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790039")%><!-- 二 --></td>
        <td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379003a")%><!-- 三 --></td>
        <td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379003b")%><!-- 四 --></td>
        <td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379003c")%><!-- 五 --></td>
        <td><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379003d")%><!-- 六 --></td>
    </tr>
    <tbody id="calTableBody">
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    </tbody>
</table>

</body>
</html>