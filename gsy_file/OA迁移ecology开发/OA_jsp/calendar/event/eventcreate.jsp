<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%
int year=NumberHelper.string2Int(request.getParameter("year"),0);
int month=NumberHelper.string2Int(request.getParameter("month"),0);
int day=NumberHelper.string2Int(request.getParameter("day"));
String time1=request.getParameter("time1");
String time2=request.getParameter("time2");
SelectitemService selectitemService=(SelectitemService)BaseContext.getBean("selectitemService");
List categoryList=selectitemService.getSelectitemList("40288183134cdd3801134db816a500bf","");
String date="";
if(year!=0&&month!=0&&day!=0){
	date=year+"-";
	if(month<10){date+="0"+month;}else{date+=month;}
	if(day<10){date+="-0"+day;}else{date+="-"+day;}
}
%>
<html>
<head>
<title>添加新日程</title>
<style type="text/css">
<!--
.inputstyle {
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: none;
	border-right-style: none;
	border-bottom-style: solid;
	border-left-style: none;
	border-top-color: #A5ACB2;
	border-right-color: #A5ACB2;
	border-bottom-color: #A5ACB2;
	border-left-color: #A5ACB2;
}
-->
</style>
</head>
<body>

<%
pagemenustr += "{S,保存,javascript:onSubmit()}";
pagemenustr += "{C,关闭,javascript:closeWin()}";
%>
<div id="pagemenubar" style="z-index:10;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<form name="EweaverForm" method="post" action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.calendar.event.servlet.EventAction?action=create">
<table width="100%" class="noborder">
  <tr>
    <td width="12%" class="fieldname">标题：</td>
    <td width="36%" class="fieldvalue"><input name="title" type="text" class="inputstyle" id="title" size="30" onpropertychange="javascript:validate(this);">
    <img id="titleImg" src="<%= request.getContextPath()%>/calendar/imgs/required.gif" border="0"></td>
    <td width="11%" class="fieldname">分类：</td>
    <td width="41%" class="fieldvalue">
    <input type="hidden" name="objtype" id="objtype" value="event">
    <select name="category" id="category">
    	<option value=""></option>
    <%for(int i=0;i<categoryList.size();i++){ 
    	Selectitem item=(Selectitem)categoryList.get(i);
    %>
      <option value="<%=item.getId()%>"><%=item.getObjname()%></option>
    <%} %>
    </select></td>
  </tr>
  <tr>
    <td class="fieldname">地点：</td>
    <td class="fieldvalue"><input name="location" type="text" class="inputstyle" id="location" size="30">    
    </td>
    <td class="fieldname">事件状态：</td>
    <td class="fieldvalue">
    <select name="status" id="status">
    	<option value="tentative"></option>
    	<option value="cancelled">已取消</option>
    	<option value="confirmed">已确认</option>
    	<option value="finished">已完成</option>
    </select>    </td>
  </tr>
  <tr>
    <td class="fieldname">开始时间：</td>
    <td class="fieldvalue">
    <button type="button" class=Calendar onClick="javascript:getdate('fromdate');"></button>
    <input type="text" name="fromdate" id="fromdate" size="8" value="<%=date%>" readonly onpropertychange="javascript:validate(this);">
    <img id="fromdateImg" src="<%= request.getContextPath()%>/calendar/imgs/required.gif" border="0">日

    <select name="fromtime" id="fromtime">
    	<option value=""></option>
    <%for(int t1=7;t1<24;t1++){ %>
    	<option value="<%=t1%>:00" <%if((t1+":00").equalsIgnoreCase(time1)){%>selected<%}%>><%=t1%>:00</option>
    	<option value="<%=t1%>:30" <%if((t1+":30").equalsIgnoreCase(time1)){%>selected<%}%>><%=t1%>:30</option>
    <%} %>
    </select>
    </td>
    <td class="fieldname">提醒方式：</td>
    <td class="fieldvalue">
    <select name="alarm" id="alarm">
    	<option value="none"></option>
    	<option value="rtx">RTX提醒</option>    	
    	<option value="mail">邮件提醒</option>
    	<option value="sms">手机消息提醒</option>
    </select>    </td>
  </tr>
  <tr>
    <td class="fieldname">结束时间：</td>
    <td class="fieldvalue">
    <button type="button" class=Calendar onClick="javascript:getdate('todate');"></button>
    <input type="text" name="todate" id="todate" size="8" value="<%=date%>" readonly onpropertychange="javascript:validate(this);">
    <img id="todateImg" src="<%= request.getContextPath()%>/calendar/imgs/required.gif" border="0">日

    <select name="totime" id="totime">
    	<option value=""></option>
    <%for(int t2=7;t2<24;t2++){ %>
    	<option value="<%=t2%>:00" <%if((t2+":00").equalsIgnoreCase(time2)){%>selected<%}%>><%=t2%>:00</option>
    	<option value="<%=t2%>:30" <%if((t2+":30").equalsIgnoreCase(time2)){%>selected<%}%>><%=t2%>:30</option>
    <%} %>
    </select>
    </td>
    <td class="fieldname">紧急程度：</td>
    <td class="fieldvalue">
    <select name="priority" id="priority">
    	<option value="low">不紧急</option>
    	<option value="medium" selected>正常</option>
    	<option value="high">紧急</option>
    </select>    </td>
  </tr>
  <tr>
    <td class="fieldname">全天事件：</td>
    <td class="fieldvalue">
    <input type="checkbox" name="isallday" id="isallday"></td>
    <td class="fieldname">私人事件：</td>
    <td class="fieldvalue"><input type="checkbox" name="isprivate" id="isprivate"></td>
  </tr>
  <tr>
    <td class="fieldname">URL：</td>
    <td class="fieldvalue">
      <textarea name="url" cols="25" rows="4" id="url"></textarea></td>
    <td class="fieldname">备注：</td>
    <td class="fieldvalue">
    <textarea name="description" id="description" cols="25" rows="4"></textarea></td>
  </tr>
  <tr>
    <td class="fieldname">重复事件：</td>
    <td colspan="3" class="fieldvalue"><input type="checkbox" name="repeat" id="repeat"></td>
    </tr>
  <tr style="display:none">
    <td class="fieldname">重复频率：</td>
    <td colspan="3">每

      <input name="textfield7" type="text" class="inputstyle" id="textfield7" size="3" maxlength="3">
      <select name="select5" id="select5">
        <option value="daily">天</option>
        <option value="weekly">周</option>
        <option value="monthly">月</option>
        <option value="annually">年</option>
      </select>    </td>
  </tr>
  <tr style="display:none">
    <td class="fieldname">持续方式：</td>
    <td colspan="3"><input type="radio" name="radio" id="radio" value="radio">
      一直持续

      <input type="radio" name="radio2" id="radio2" value="radio2">
      重复
      <input name="textfield8" type="text" class="inputstyle" id="textfield8" size="3" maxlength="3">
      次

      <input type="radio" name="radio3" id="radio3" value="radio3">
      到

      <input name="textfield9" type="text" class="inputstyle" id="textfield9">
      结束</td>
  </tr>
</table>
</form>
</body>
<script type="text/javascript">
function closeWin(){
	var eventDiv=window.parent.window.document.getElementById("eventDiv");
	var maskDiv=window.parent.window.document.getElementById("maskDiv");
	if(eventDiv==null){
		window.close();
	}else{
		eventDiv.style.display="none";
		maskDiv.style.display="none";
	}
}
function onSubmit(){
	if(validateForm()){
		EweaverForm.submit();
	}
}
function validateForm(){
	if(Trim(document.getElementById("title").value)==""){
		alert("标题未填写完整");
		return false;
	}
	if(Trim(document.getElementById("fromdate").value)==""){
		alert("开始日期未选择");
		return false;
	}
	if(Trim(document.getElementById("todate").value)==""){
		alert("结束日期未选择");
		return false;
	}
	return true;
}
function validate(Obj){
	var imgId=Obj.id+"Img";
	var img=document.getElementById(imgId);
	if(Trim(Obj.value)!=""){
		img.src="<%= request.getContextPath()%>/calendar/imgs/validated.gif";
	}else{
		img.src="<%= request.getContextPath()%>/calendar/imgs/required.gif";
	}
}
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>
</html>