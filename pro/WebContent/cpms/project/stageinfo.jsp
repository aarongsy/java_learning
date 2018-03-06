<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%@ page import="java.math.BigDecimal"%>
<%
String taskid = StringHelper.null2String(request.getParameter("taskid"));
String projectid = StringHelper.null2String(request.getParameter("projectid"));
String sql = "select t.*,h.objname as hname from cpms_task t left join humres h on t.manager=h.id where t.projectid='"+projectid+"' and t.pid='"+taskid+"' order by t.wbs";
DataService dataService = new DataService();
List list = dataService.getValues(sql);
String taskSQL = "select t.*,h.objname as hname,s1.objname as statusname from cpms_task t left join humres h on t.manager=h.id left join selectitem s1 on s1.id=t.status where t.requestid='"+taskid+"'";
Map stage = dataService.getValuesForMap(taskSQL);
String statusname = StringHelper.null2String(stage.get("statusname"));
String planstart = StringHelper.null2String(stage.get("planstart"));
String planfinish = StringHelper.null2String(stage.get("planfinish"));
String startdate = StringHelper.null2String(stage.get("startdate"));
String finishdate = StringHelper.null2String(stage.get("finishdate"));

//任务延迟判断
boolean delayStart = StringHelper.isEmpty(startdate)&&DateHelper.getCurrentDate().compareTo(planstart)>0||startdate.compareTo(planstart)>0;
boolean delayFinish = StringHelper.isEmpty(finishdate)&&DateHelper.getCurrentDate().compareTo(planfinish)>0||finishdate.compareTo(planfinish)>0;

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>任务阶段信息</title>
<link  type="text/css" rel="stylesheet" href="/cpms/styles/cpms.css" />
</head>
<body onload="init();" style="padding: 0;margin: 0;overflow: hidden;">
<div id="stageinfo" style="padding: 5 10 5 10;width:100%">
	<span style="color: #6d469b;font-weight: bold;">〖阶段信息〗</span>
	<table class="layouttable">
		<tr>
			<td class="fieldname" width="10%" align="right">阶段名称:</td>
			<td class="fieldvalue" width="40%">
				<a href="javascript:openTask('<%=stage.get("projectid")%>','<%=stage.get("requestid")%>','<%=stage.get("objname")%>');" title="查看详细进展信息"><%=stage.get("objname")%></a>
			</td>
			<td class="fieldname"  width="12%" align="right">责任人:</td>
			<td class="fieldvalue"  width="40%"><%=StringHelper.null2String(stage.get("hname"))%></td>
		</tr>
		<tr>
			<td class="fieldname" width="10%" align="right">计划开始日期:</td>
			<td class="fieldvalue" width="40%"><%=planstart%></td>
			<td class="fieldname"  width="12%" align="right">计划完成日期:</td>
			<td class="fieldvalue"  width="40%"><%=planfinish%></td>
		</tr>
		<tr>
			<td class="fieldname" width="10%" align="right">实际开始日期:</td>
			<td class="fieldvalue" width="40%">
				<%=startdate%>
				<%if(delayStart){%><span style="color:red">开始时间延期</span><%}%>
			</td>
			<td class="fieldname"  width="10%" align="right">实际完成日期:</td>
			<td class="fieldvalue"  width="40%">
				<%=finishdate%>
				<%if(delayFinish){%><span style="color:red">完成时间延期</span><%}%>
			</td>
		</tr>
		<tr style="display:none">
			<td class="fieldname" width="10%" align="right">计划工时:</td>
			<td class="fieldvalue" width="40%"></td>
			<td class="fieldname"  width="10%" align="right">实际工时:</td>
			<td class="fieldvalue"  width="40%"></td>
		</tr>
		<tr>
			<td class="fieldname" width="10%" align="right">完成进度:</td>
			<td class="fieldvalue">
			<%
			BigDecimal progress = (BigDecimal)stage.get("objpercent");
			progress = progress==null?BigDecimal.ZERO:progress;
			String colorbd="#999";
			String colorbg="#ddd";
			String imgSrc="/cpms/images/bullet_orange.gif";
			if(progress.intValue()>0){
				colorbd="#50abff";
				colorbg="#d4e6ff";
				imgSrc="/cpms/images/bullet_right.gif";
			}
			if(progress.intValue()==100){
				colorbd="#9fc54e";
				colorbg="#dbeace";
				imgSrc="/cpms/images/bullet_tick.gif";
			}
			%>
			<div>
				<img src="<%=imgSrc%>" style="float: left">
				<div style="width:200px;height:12px;background-color:<%=colorbg%>;border: <%=colorbd%> 1px solid;float:left; padding:1 0 0 0;margin:2 0 0 0">
					<div style="background-color: <%=colorbd%>;width:<%=progress.intValue()*2%>px;height:10px;overflow:hidden;"></div>
				</div><%=stage.get("objpercent")%>%
			</div>
			</td>
			<td class="fieldname" width="10%" align="right">任务状态:</td>
			<td class="fieldvalue"><%=statusname%></td>
		</tr>
	</table>
</div>
<%if(list.size()>0){%>
<div id="stageinfo" style="padding: 5 10 5 10;width:100%">
	<span style="color: #5e84c2;font-weight: bold;">〖子任务信息〗</span>
	<table id="treetable" border=1>
		<TR class=header>
			<TD style="WIDTH: 30px">wbs</TD>
			<TD style="WIDTH: 30%">任务名称</TD>
			<TD style="WIDTH: 20%">进度</TD>
			<TD style="WIDTH: 10%">责任人</TD>
			<TD style="WIDTH: 10%">计划开始</TD>
			<TD style="WIDTH: 10%">计划结束</TD>
			<TD style="WIDTH: 10%">实际开始</TD>
			<TD style="WIDTH: 10%">实际结束</TD>
		</TR>
		<%
		for(int i=0;i<list.size();i++){
			Map task =(Map)list.get(i);
			String id = (String)task.get("requestid");
		%>
		<tr height="25px">
			<td width="30px"><%=StringHelper.null2String(task.get("wbs"))%></td>
			<td><a href="javascript:openTask('<%=task.get("projectid")%>','<%=task.get("requestid")%>','<%=StringHelper.null2String(task.get("objname"))%>');"><%=StringHelper.null2String(task.get("objname"))%></a></td>
			<td>
			<%
			BigDecimal percent = (BigDecimal)task.get("objpercent");
			percent = percent==null?BigDecimal.ZERO:percent;
			colorbd="#999";
			colorbg="#ddd";
			imgSrc="/cpms/images/bullet_orange.gif";
			if(percent.intValue()>0){
				colorbd="#50abff";
				colorbg="#d4e6ff";
				imgSrc="/cpms/images/bullet_right.gif";
			}
			if(percent.intValue()==100){
				colorbd="#9fc54e";
				colorbg="#dbeace";
				imgSrc="/cpms/images/bullet_tick.gif";
			}
			%>
			<div>
				<img src="<%=imgSrc%>" style="float: left">
				<div style="width:100px;height:10px;background-color:<%=colorbg%>;border: <%=colorbd%> 1px solid;float:left; padding:1 0 0 0;margin:2 0 0 0">
					<div style="background-color: <%=colorbd%>;width:<%=percent.intValue()%>px;height:8px;overflow:hidden;"></div>
				</div><%=percent.intValue()%>%
			</div>
			</td>
			<td><%=StringHelper.null2String(task.get("hname"))%></td>
			<td><%=StringHelper.null2String(task.get("planstart"))%></td>
			<td><%=StringHelper.null2String(task.get("planfinish"))%></td>
			<td><%=StringHelper.null2String(task.get("startdate"))%></td>
			<td><%=StringHelper.null2String(task.get("finishdate"))%></td>
		</tr>
		<%}%>
	</table>
</div>
<%}%>
<%if(!StringHelper.isEmpty(StringHelper.null2String(stage.get("flowreqid")))){%>
<div id="chartDiv" style="padding: 5 10 5 10;width:100%">
	<span style="color: #567f40;font-weight: bold;">〖任务流程图〗</span>
	<input type="hidden" id="flowreqid" value="<%=stage.get("flowreqid")%>">
	<iframe id="chartframe" width="100%" height="300px" frameborder="0"></iframe>
</div>
<%}%>
</body>
<script type="text/javascript">
function openTask(projectid,id,objname){
	onUrl('/cpms/project/taskinfo_process.jsp?projectid='+projectid+'&taskid='+id,objname,'exec_'+id);
}
function openFlow(requestid,title){
	onUrl('/workflow/request/workflow.jsp?requestid='+requestid,title,'tab_'+requestid);
}
function init(){
	var height =document.body.scrollHeight;
	if(parent&&parent.resetHeight){parent.resetHeight(height);}
	var flow = document.getElementById('flowreqid');
	if(flow){
		var frame = document.getElementById('chartframe');
		frame.src='/wfdesigner/viewers/graphviewer.jsp?requestid='+flow.value;
		frame.geight = frame.document.body.scrollHeight;
	}
}
</script>
</html>

