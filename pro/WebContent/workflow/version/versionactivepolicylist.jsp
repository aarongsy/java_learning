<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.sun.xml.bind.v2.model.core.ID"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page
	import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@page
	import="com.eweaver.workflow.version.service.VersionActivePolicyService"%>
<%@page import="com.eweaver.workflow.version.model.VersionActivePolicy"%>

<%
	WorkflowVersionService workflowVersionService = (WorkflowVersionService) BaseContext
			.getBean("workflowVersionService");
	VersionActivePolicyService versionActivePolicyService = (VersionActivePolicyService) BaseContext
			.getBean("versionActivePolicyService");
	String workflowid = StringHelper.null2String(request
			.getParameter("workflowid"));
	WorkflowVersion workflowVersion = workflowVersionService
			.getWorkflowVersionByWorkflowid(workflowid);

	List list = new ArrayList();
	String versionid = "";
	if (workflowVersion != null) {
		versionid = StringHelper.null2String(workflowVersion.getId());
		String hql = "from VersionActivePolicy where versionid='"
				+ versionid + "' order by planstartdate desc";
		list = versionActivePolicyService.getVersionActivePolicys(hql);
	}
%>

<html>
	<head>
	<base target="_self">
		<script language="JavaScript" src="<%=request.getContextPath()%>/js/addRowBg.js"></script>
		<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
		<script>
var rowColor = "";
var ncol;
var oRow;
var oCell;


var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

function generateMixed(n) {
     var res = "";
     for(var i = 0; i < n ; i ++) {
         var id = Math.ceil(Math.random()*35);
         res += chars[id];
     }
     return res;
}

function addRow() {
	ncol = layoutTb.getAttribute("cols");
	rowColor = getRowBg();
	oRow = layoutTb.insertRow(-1);
	var startdateid=generateMixed(32);
	var enddateid=generateMixed(32);
	for (j = 0; j < ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height = 24;
		oCell.style.background = rowColor;
		switch (j) {
		case 0:
			var timeFlag = new Date().getTime();
			var oDiv = document.createElement("div");
			oDiv.style.marginLeft = "4px";
			var sHtml = "<input type='hidden' name='id'>";
			sHtml += "<input type='input' class='inputstyle' style='width:92%' id='"+startdateid+"' name='planstartdate' onclick=\"WdatePicker({maxDate:'#F{$dp.$D(\\\'"+enddateid+"\\\')}'})\" onblur=\"fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','日期');return false;\">";
			sHtml += "<span id='objname"
					+ timeFlag
					+ "span' style='width: 5%;display:inline-block;'/><img align='absMiddle' src='/images/base/checkinput.gif'/></span>";
			oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			break;
		case 1:
			var oDiv = document.createElement("div");
			var sHtml = "<input type='input' class='inputstyle' style='width:92%' id='"+enddateid+"' name='planenddate' onclick=\"WdatePicker({minDate:'#F{$dp.$D(\\\'"+startdateid+"\\\')}'})\" onblur=\"fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','日期');return false;\">";
			oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			break;
		case 2:
			var oDiv = document.createElement("div");
			var sHtml = "<select name='isenable'><option label='否' value='0' ></option><option label='是' value='1' ></option></select>";
			oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			break;
		case 3:
			var oDiv = document.createElement("div");
			var sHtml = "";
			oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			break;
		}
	}
}

function validateForm() {
	var objnames = document.getElementsByName("planstartdate");
	if (objnames) {
		for ( var i = 0; i < objnames.length; i++) {
			if (objnames[i].value.trim() == "") {
				alert("计划开始启用日期时间不能为空");
				objnames[i].focus();
				return false;
			}
		}
	}
	return true;
}
function onSubmit2() {
	if (validateForm()) {
		document.EweaverForm.submit();
	}
}

function onDeleteVersionActivePolicy(id) {
	if (confirm('确定删除？')) {
		Ext.Ajax.request({
          url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.version.servlet.VersionActivePolicyAction?action=delete&id='+ id,
          params:{},
          success: function(response) {
        	  window.location.href=window.location.href;
          }
        });
	}
}
</script>
	</head>
	<body>
		<div id="pagemenubar" style="z-index: 100;"></div>
		<div id="menubar">
			<button type="button" class='btn' accessKey="C" onclick="javascript:addRow();">
				<U>A</U>--<%=labelService
					.getLabelName("402881e60aa85b6e010aa85e6aed0001")%>
			</button>
			<button type="button" class='btn' accessKey="C" onclick="javascript:onSubmit2();">
				<U>S</U>--<%=labelService
					.getLabelName("402881e60aabb6f6010aabbda07e0009")%>
			</button>
		</div>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束-->
		<form
			action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.version.servlet.VersionActivePolicyAction?action=save"
			target="_self" name="EweaverForm" method="post">
			<input type="hidden" name="workflowid" value="<%=workflowid%>" />
			<input type="hidden" name="versionid" value="<%=versionid%>" />
			<table cols=4 id="layoutTb">
				<!-- 列宽控制 -->
				<colgroup>
					<col width="30%">
					<col width="20%">
					<col width="20%">
					<col width="30%">
				</colgroup>
				<tr class="Header">
					<td>
						计划开始启用日期时间
					</td>
					<td>
						计划结束启用日期时间
					</td>
					<td>
						是否启用
					</td>
					<td style="text-align: center"><%=labelService
					.getLabelNameByKeyId("402883d934cbbb380134cbbb39380074")%><!-- 动作 -->
					</td>
				</tr>
				<%
					boolean isLight = false;
					String trclassname = "";
					for (int i = 0; i < list.size(); i++) {
						VersionActivePolicy versionActivePolicy = (VersionActivePolicy) list.get(i);
						isLight = !isLight;
						if (isLight)
							trclassname = "DataLight";
						else
							trclassname = "DataDark";
						
						String startdateid=IDGernerator.getUnquieID().toString();
						String enddateid=IDGernerator.getUnquieID().toString();
				%>
				<tr class="<%=trclassname%>">
					<td nowrap>
						<input type="hidden" name="id"
							value="<%=versionActivePolicy.getId()%>" />
						<input type='input' class='inputstyle' style='width: 92%' id="<%=startdateid%>"
							name='planstartdate' onclick="WdatePicker({maxDate:'#F{$dp.$D(\'<%=enddateid%>\')}'})"
							onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','日期');return false;"
							datecheck="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)"
							value='<%=StringHelper.null2String(versionActivePolicy
						.getPlanstartdate())%>' />
						<span style='width: 5%; display: inline-block;' /><img
								align='absMiddle' src='/images/base/checkinput.gif' />
						</span>
					</td>
					<td nowrap>
						<input type='input' class='inputstyle' style='width: 92%' id="<%=enddateid%>"
							name='planenddate' onclick="WdatePicker({minDate:'#F{$dp.$D(\'<%=startdateid%>\')}'})"
							onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','日期');return false;"
							value='<%=StringHelper.null2String(versionActivePolicy
						.getPlanenddate())%>' />
					</td>
					<td nowrap>
						<select name="isenable">
							<option label="否" value="0"
								<%if ("0".equals(StringHelper.null2String(versionActivePolicy
						.getIsenable(), "0"))) {%>
								selected <%}%>></option>
							<option label="是" value="1"
								<%if ("1".equals(StringHelper.null2String(versionActivePolicy
						.getIsenable()))) {%>
								selected <%}%>></option>
						</select>
					</td>
					<td nowrap>
						<a
							href="javascript:onDeleteVersionActivePolicy('<%=versionActivePolicy.getId()%>');">删除</a>
					</td>
				</tr>
				<%
					}
				%>
			</table>
		</form>
	</body>
</html>