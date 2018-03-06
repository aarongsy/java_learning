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
<title><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80000")%></title><!-- 添加新日程 -->
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
    <td width="12%" class="fieldname"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%>：</td><!-- 标题 -->
    <td width="36%" class="fieldvalue"><input name="title" type="text" class="inputstyle" id="title" size="30" onpropertychange="javascript:validate(this);">
    <img id="titleImg" src="<%= request.getContextPath()%>/calendar/imgs/required.gif" border="0"></td>
    <td width="11%" class="fieldname"><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%>：</td><!-- 分类 -->
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
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402881e50de7d974010de7f5d6830136")%>：</td><!-- 地点 -->
    <td class="fieldvalue"><input name="location" type="text" class="inputstyle" id="location" size="30">    
    </td>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80001")%>：</td><!-- 事件状态 -->
    <td class="fieldvalue">
    <select name="status" id="status">
    	<option value="tentative"></option>
    	<option value="cancelled"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80002")%></option><!-- 已取消 -->
    	<option value="confirmed"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80003")%></option><!-- 已确认 -->
    	<option value="finished"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3931001c")%></option><!-- 已完成 -->
    </select>    </td>
  </tr>
  <tr>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b1f3dc000f")%>：</td><!-- 开始时间 -->
    <td class="fieldvalue">
    <button  type="button" class=Calendar onClick="javascript:getdate('fromdate');"></button>
    <input type="text" name="fromdate" id="fromdate" size="8" value="<%=date%>" readonly onpropertychange="javascript:validate(this);">
    <img id="fromdateImg" src="<%= request.getContextPath()%>/calendar/imgs/required.gif" border="0"><%=labelService.getLabelNameByKeyId("402883d934c1f3e80134c1f3e8c40000")%><!-- 日 -->

    <select name="fromtime" id="fromtime">
    	<option value=""></option>
    <%for(int t1=7;t1<24;t1++){ %>
    	<option value="<%=t1%>:00" <%if((t1+":00").equalsIgnoreCase(time1)){%>selected<%}%>><%=t1%>:00</option>
    	<option value="<%=t1%>:30" <%if((t1+":30").equalsIgnoreCase(time1)){%>selected<%}%>><%=t1%>:30</option>
    <%} %>
    </select>
    </td>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("40288035248eb3e801248f54ab930035")%>：</td><!-- 提醒方式 -->
    <td class="fieldvalue">
    <select name="alarm" id="alarm">
    	<option value="none"></option>
    	<option value="rtx"><%=labelService.getLabelNameByKeyId("40288035248eb3e801248f5647700037")%></option><!-- RTX提醒 -->    	
    	<option value="mail"><%=labelService.getLabelNameByKeyId("40288035248eb3e801248f59d942003b")%></option><!-- 邮件提醒 -->
    	<option value="sms"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80004")%></option><!-- 手机消息提醒 -->
    </select>    </td>
  </tr>
  <tr>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b24e600012")%>：</td><!-- 结束时间 -->
    <td class="fieldvalue">
    <button  type="button" class=Calendar onClick="javascript:getdate('todate');"></button>
    <input type="text" name="todate" id="todate" size="8" value="<%=date%>" readonly onpropertychange="javascript:validate(this);">
    <img id="todateImg" src="<%= request.getContextPath()%>/calendar/imgs/required.gif" border="0"><%=labelService.getLabelNameByKeyId("402883d934c1f3e80134c1f3e8c40000")%><!-- 日 -->

    <select name="totime" id="totime">
    	<option value=""></option>
    <%for(int t2=7;t2<24;t2++){ %>
    	<option value="<%=t2%>:00" <%if((t2+":00").equalsIgnoreCase(time2)){%>selected<%}%>><%=t2%>:00</option>
    	<option value="<%=t2%>:30" <%if((t2+":30").equalsIgnoreCase(time2)){%>selected<%}%>><%=t2%>:30</option>
    <%} %>
    </select>
    </td>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80005")%>：</td><!-- 紧急程度 -->
    <td class="fieldvalue">
    <select name="priority" id="priority">
    	<option value="low"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80006")%></option><!-- -不紧急 -->
    	<option value="medium" selected><%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd751b7610004")%></option><!-- 正常 -->
    	<option value="high"><%=labelService.getLabelNameByKeyId("402881ef0c768f6b010c76abd9740011")%></option><!-- 紧急 -->
    </select>    </td>
  </tr>
  <tr>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80007")%>：</td><!-- 全天事件 -->
    <td class="fieldvalue">
    <input type="checkbox" name="isallday" id="isallday"></td>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80008")%>：</td><!-- 私人事件 -->
    <td class="fieldvalue"><input type="checkbox" name="isprivate" id="isprivate"></td>
  </tr>
  <tr>
    <td class="fieldname">URL：</td>
    <td class="fieldvalue">
      <textarea name="url" cols="25" rows="4" id="url"></textarea></td>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a")%>：</td><!-- 备注 -->
    <td class="fieldvalue">
    <textarea name="description" id="description" cols="25" rows="4"></textarea></td>
  </tr>
  <tr>
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80009")%>：</td><!-- 重复事件 -->
    <td colspan="3" class="fieldvalue"><input type="checkbox" name="repeat" id="repeat"></td>
    </tr>
  <tr style="display:none">
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8000a")%>：</td><!-- 重复频率 -->
    <td colspan="3"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8000b")%><!-- 每 -->

      <input name="textfield7" type="text" class="inputstyle" id="textfield7" size="3" maxlength="3">
      <select name="select5" id="select5">
        <option value="daily"><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c7689dac80022")%></option><!-- 天 -->
        <option value="weekly"><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768a4f830025")%></option><!-- 周 -->
        <option value="monthly"><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></option><!-- 月 -->
        <option value="annually"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")%></option><!-- 年 -->
      </select>    </td>
  </tr>
  <tr style="display:none">
    <td class="fieldname"><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8000c")%>：</td><!-- 持续方式 -->
    <td colspan="3"><input type="radio" name="radio" id="radio" value="radio">
      <%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8000d")%><!-- 一直持续 -->

      <input type="radio" name="radio2" id="radio2" value="radio2">
      <%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8000e")%><!-- 重复 -->
      <input name="textfield8" type="text" class="inputstyle" id="textfield8" size="3" maxlength="3">
      <%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%><!-- 次 -->

      <input type="radio" name="radio3" id="radio3" value="radio3">
      <%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%><!-- 到 -->

      <input name="textfield9" type="text" class="inputstyle" id="textfield9">
      <%=labelService.getLabelNameByKeyId("402881ef0c768f6b010c76a2fc5a000b")%><!-- 结束 --></td>
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
		alert("<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8000f")%>");//标题未填写完整
		return false;
	}
	if(Trim(document.getElementById("fromdate").value)==""){
		alert("<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80010")%>");//开始日期未选择
		return false;
	}
	if(Trim(document.getElementById("todate").value)==""){
		alert("<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80011")%>");//结束日期未选择
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