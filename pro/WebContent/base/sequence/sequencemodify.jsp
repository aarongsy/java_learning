<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.sequence.SequenceService"%>
<%@ page import="com.eweaver.base.sequence.Sequence"%>
<%@ include file="/base/init.jsp"%>
<%
	SequenceService sequenceService = (SequenceService) BaseContext
			.getBean("sequenceService");
	Sequence sequence = sequenceService.getSequence(request
			.getParameter("id"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
	pagemenustr += "addBtn(tb,'"
			+ labelService
					.getLabelName("402881e60aabb6f6010aabbda07e0009")
			+ "','S','accept',function(){onSubmit()});";
	pagemenustr += "addBtn(tb,'"
			+ labelService
					.getLabelName("402881e60aabb6f6010aabe32990000f")
			+ "','R','arrow_redo',function(){onReturn()});";
%>
<html>
	<head>

		<style type="text/css">
#pagemenubar table {
	width: 0
}
</style>

		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js">
</script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js">
</script>
		<script type="text/javascript">
Ext.onReady(function() {
              Ext.QuickTips.init();
          <%if (!pagemenustr.equals("")) {%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>
          });
      </script>
	</head>
	<body>
		<!--页面菜单开始-->
		<div id="pagemenubar"></div>
		<!--页面菜单结束-->

		<form
			action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.sequence.SequenceAction?action=modify"
			name="EweaverForm" method="post">
			<input type="hidden" name="id" value="<%=sequence.getId()%>">
			<input type="hidden" name="currentNo"
				value="<%=sequence.getCurrentNo()%>">
			<table>
				<!-- 列宽控制 -->
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr>
						<td class="FieldName"><%=labelService
					.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
						<td class="FieldValue">
							<input class="inputstyle" type="text" size="30" name="name"
								onchange='checkInput("name","namespan")'
								value="<%=sequence.getName()%>">
							<span id="namespan"></span>
						</td>
					</tr>
					<tr>
						<td class="FieldName">
							描述
						</td>
						<td class="FieldValue">
							<input class="inputstyle" type="text" name="description"
								value="<%=sequence.getDescription() == null ? "" : sequence
					.getDescription()%>">
						</td>
					</tr>
					<tr>
						<td class="FieldName">
							初始值
						</td>
						<td class="FieldValue">
							<input class="inputstyle" type="text" size="2" name="startNo"
								onkeypress="checkInt_KeyPress()"
								value="<%=sequence.getStartNo()%>">
						</td>
					</tr>
					<tr>
						<td class="FieldName">
							增量
						</td>
						<td class="FieldValue">
							<input class="inputstyle" type="text" size="2" name="incrementNo"
								onkeypress="checkInt_KeyPress()"
								value="<%=sequence.getIncrementNo()%>">
						</td>
					</tr>
					<tr>
						<td class="FieldName">
							周期
						</td>
						<td class="FieldValue">
							<select name="loopType">
								<%
									int loopType = sequence.getLoopType() == null ? 0 : sequence
											.getLoopType();
								%>
								<option value="0" <%if (loopType == 0) {%> selected <%}%>>
									无
								</option>
								<option value="1" <%if (loopType == 1) {%> selected <%}%>>
									年
								</option>
								<option value="2" <%if (loopType == 2) {%> selected <%}%>>
									月
								</option>
								<option value="3" <%if (loopType == 3) {%> selected <%}%>>
									日
								</option>
							</select>
					</tr>
				</tbody>
			</table>
		</form>
		<script language="javascript">
<!--
   function onSubmit(){
   	 checkfields="objname";
   	 checkmessage="<%=labelService
					.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	 if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
     }
   }
   function onReturn(){
     history.go(-1);
   }
 -->
 </script>
	</body>
</html>
