<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%
	LabelService labelService=(LabelService)BaseContext.getBean("labelService");
%>

<html>
  <head>
	<meta content="0" http-equiv="Expires">
	<LINK rel=STYLESHEET type=text/css href="/css/eweaver.css">
	</head>

	<body>
		<!-- 卡片内容开始 -->
		<DIV align=center>
			<form action=""	name="TaskForm" id="TaskForm" method="post">
			<FIELDSET style="WIDTH: 98%">
					<LEGEND>
						<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5003e") %><!-- 任务信息 -->
					</LEGEND>
					<TABLE width="100%" class=noborder>
						<COLGROUP>
							<COL width="15%">
							<COL width="35%">
							<COL width="15%">
							<COL width="35%">
						</COLGROUP>
						<TBODY>
							<TR>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006") %><!-- 任务名称 -->
								</TD>
								<TD class=FieldValue >
									<INPUT style="WIDTH: 80%" id="Name" class="InputStyle2" readonly="readonly"
										value="" name="Name" type="text" onchange="checkInput('Name','Namespan')">
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0048") %><!-- 实施部门 -->
								</TD>
								<TD class=FieldValue>
									<input type="hidden" name="Office" id="Office" value="">
									<span id="Officespan" name="Officespan" ></span>
								</TD>
							</tr>
							<tr>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e") %><!-- 任务编号 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" readOnly="true" class="InputStyle2" name="TaskNo" id="TaskNo" style="width: 80%" value="">
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150057") %><!-- 任务类型 -->
								</TD>
								<TD class=FieldValue>
									<input type="hidden" name="MasterTypeHide" id="MasterTypeHide" value=""/>
									<select class="InputStyle2" name="MasterType" id="MasterType" style="width: 80%" onchange="checkInput('MasterType','MasterTypespan')" disabled="disabled">
									</select>
								</TD>
							</TR><TR>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150058") %><!-- 下达产值数 -->
								</TD>
								<TD class=FieldValue colspan="3">
									<INPUT style="WIDTH: 92%" id="ProduceQty" class="InputStyle2" readonly="readonly"
										value="" name="ProduceQty" type="text" onchange="checkInput('ProduceQty','ProduceQtyspan');fieldcheck(this,'^\\d+$','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150058") %>')" ><!-- 下达产值数 -->
								</TD>
								</tr>
								<tr>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150059") %><!-- 要求开始 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="HopeStartDate" name="HopeStartDate" value=""  style='width: 80%' readonly="readonly"
									class=inputstyle size=10 onchange="checkInput('HopeStartDate','HopeStartDatespan')" 
									onblur="checkInput('HopeStartDate','HopeStartDatespan');fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150059") %>')"><!-- 要求开始 -->
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15005a") %><!-- 要求完成 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="HopeFinishDate" name="HopeFinishDate" value=""  style='width: 80%' readonly="readonly"
									class=inputstyle size=10 onchange="checkInput('HopeFinishDate','HopeFinishDatespan')" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15005a") %>')"><!-- 要求完成 -->
								</TD>
								</tr><TR>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004f") %><!-- 预计开始 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="Start" name="Start" value=""  style='width: 80%' readonly="readonly"
									class=inputstyle size=10 onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004f") %>')"><!-- 预计开始 -->
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0046") %><!-- 预计完成 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="Finish" name="Finish" value=""  style='width: 80%' readonly="readonly"
									class=inputstyle size=10 onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0046") %>')"><!-- 预计开始 -->
								</TD>
								</tr>
								<tr>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50040") %><!-- 任务要求 -->
								</TD>
								<TD class=FieldValue colspan="3">
									<textarea rows="0" cols="0" style="WIDTH: 92%;height: 80px" id="Require" name="Require" class="InputStyle2" readonly="readonly"></textarea>
								</TD>
								</tr>
						</TBODY>
					</TABLE>
				
			</FIELDSET>
			</form>
		</DIV>
	</body>
</html>
<!-- 数据初始化代码 -->
<script type="text/javascript">
function setSelect(DomID,ListID){
	var select = document.getElementById(DomID);
	for(var i=0;i<select.length;){
		select.remove(i);
	}
	var op = document.createElement("option");
	select.appendChild(op);
	op.value        = '';
	op.innerHTML    = '';
	var data = window.parent.selectProject[ListID];
	for(var i=0;i<data.length;i++){
		var op = document.createElement("option");
		select.appendChild(op);
		op.value        = data[i].ID;
		op.innerHTML    = data[i].OBJNAME;
	}
}
setSelect('MasterType','2c91a84e2aa7236b012aa737d8930006');//任务类型
//设置document元素中的值
function setValue(id,value,SpanValue){
	document.getElementById(id).value = value;
	if(SpanValue){
		document.getElementById(id+'span').innerHTML = SpanValue;
	}
}
var task = window.parent.project.tree.getSelected();
setValue('Name',task.Name?task.Name:"");
setValue('TaskNo',task.TaskNo?task.TaskNo:"");
setValue('Office',task.Office?task.Office:"",task.OfficeName?task.OfficeName:"");
setValue('MasterType',task.MasterType?task.MasterType:"");
setValue('Require',task.Require?task.Require:"");
setValue('ProduceQty',task.ProduceQty?task.ProduceQty:"");
setValue('Start',task.Start?task.Start.format('Y-m-d'):"");
setValue('Finish',task.Finish?task.Finish.format('Y-m-d'):"");
setValue('HopeStartDate',task.HopeStartDate?task.HopeStartDate.format('Y-m-d'):"");
setValue('HopeFinishDate',task.HopeFinishDate?task.HopeFinishDate.format('Y-m-d'):"");

</script>