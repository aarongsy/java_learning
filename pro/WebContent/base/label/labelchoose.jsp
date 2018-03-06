<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.LabelType"%>
<%@page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ include file="/base/init.jsp"%>
<%
String labelType = StringHelper.null2String(request.getParameter("labelType"));
//labelType="";
String formId = StringHelper.null2String(request.getParameter("formId"));
//formId="";
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
Forminfo forminfo = forminfoService.getForminfoById(formId);

%>
<html>
<head>
<title></title>
<style type="text/css">
	.x-toolbar table {width:0}
	#pagemenubar table {width:0}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {width:0}
</style>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="/base/label/js/labelchoose.js"></script>
<script type="text/javascript">
</script>
</head>
<body style="margin:0px;padding:0px">
<div id="labelPanel">
<div id="pagemenubar"></div>
	<form id="EweaverForm" name="EweaverForm" action="" method="post">
		<table>
			<tbody>
				<tr class="title">
					<td class="FieldName" nowrap width="60px;">标签类型：</td>
					<td class="FieldValue" nowrap>
						<select name="labeltype" id="labeltype" onchange="changeLabelType()">
							<option value=""></option>
							<%
								LabelType[] labelTypes = LabelType.values();
								for(LabelType l : labelTypes){%>
									<option value="<%=l.toString() %>" <%if(l.toString().equals(labelType)){%>selected="selected"<%} %>><%=l.getDisplayName() %></option>	
								<%}
							%>
						</select>
					</td>
					<td class="FieldName" nowrap width="60px;">标签名称：</td>
					<td class="FieldValue" nowrap>
						<input type="text" id="labelname" name="labelname" value="" style="width: 80px;"/>
					</td>
					<td class="FieldName" nowrap width="60px;" id="<%=LabelType.FormField.toString() %>Td1">表单：</td>
					<td class="FieldValue" nowrap id="<%=LabelType.FormField.toString() %>Td2">
						<button type=button class=Browser name="button_fromid" onclick="javascript:getrefobj('formid','formidspan','402880a51daeee72011daf01434a0002','','0');"></button>
						<input type="hidden" id="formid" name="formid" value="<%=formId %>"/>
						<span id="formidspan" name="formidspan"><%=StringHelper.null2String(forminfo.getObjname()) %></span>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
</html>