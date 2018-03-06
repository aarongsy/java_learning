<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.calendar.base.service.SchedulesetService"%>
<%@page import="com.eweaver.calendar.base.model.Scheduleset"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String title = StringHelper.null2String(request.getParameter("title"));
	String startDateTime = StringHelper.null2String(request.getParameter("startDateTime"));
	String endDateTime = StringHelper.null2String(request.getParameter("endDateTime"));
	String startDate = DateHelper.getCurrentDate();
	String startTime = "";
	if(!StringHelper.isEmpty(startDateTime)){
		startDate = startDateTime.split(" ")[0];
		startTime = startDateTime.split(" ")[1] + ":00";
	}
	String endDate = "";
	String endTime = "";
	if(!StringHelper.isEmpty(endDateTime)){
		endDate = endDateTime.split(" ")[0];
		endTime = endDateTime.split(" ")[1] + ":00";
	}
	
	String categoryid = StringHelper.null2String(request.getParameter("categoryid"), "5c78e08422b085b40122b0c513ce02b7");
	String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
	String formid = StringHelper.null2String(request.getParameter("formid"));
	if(!StringHelper.isID(formid)){
		if (StringHelper.isEmpty(categoryid)) {
			WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    		formid = workflowinfoService.get(workflowid).getFormid();
		} else {
			CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
			formid = categoryService.getCategoryById(categoryid).getPFormid();
		}
	}
	
	String iscalshare = StringHelper.null2String(request.getParameter("iscalshare"));
	String shareuserid = StringHelper.null2String(request.getParameter("shareuserid"));
	
	String url = "";
	boolean isCreate = StringHelper.isEmpty(requestid) || !StringHelper.isID(requestid);
	if(isCreate){	
		if(!StringHelper.isEmpty(categoryid)){
			url = "/workflow/request/formbase.jsp?categoryid=" + categoryid;
		}else if(!StringHelper.isEmpty(workflowid)){
			url = "/workflow/request/workflow.jsp?workflowid=" + workflowid;
		}
		url += "&calendarTitle="+title+"&calendarStartDate="+startDate+"&calendarStartTime="+startTime+"&calendarEndDate="+endDate+"&calendarEndTime="+endTime;
	}else{
		url = "/workflow/request/workflow.jsp?from=report&requestid=" + requestid;
		if(!StringHelper.isEmpty(iscalshare) && !StringHelper.isEmpty(shareuserid)){
			url += "&iscalshare=" + iscalshare + "&shareuserid=" + shareuserid;
		}
	}
	
%>
<html>
<head>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function() { 
	var $scheduleinfoFrame = $("<iframe id='scheduleinfoFrame' name='scheduleinfoFrame' src='<%=url%>' frameborder='0' style='border: none;'></iframe>");
	
	$(document.body).append($scheduleinfoFrame);
	
	resizeScheduleinfoFrame();
	
});

function resizeScheduleinfoFrame(){
	$("#scheduleinfoFrame").width($(document).width());
	$("#scheduleinfoFrame").height($(document).height());
}

function getIFrameDocument(frameId){
	if(document.getElementById(frameId) && document.getElementById(frameId).contentDocument){
		return document.getElementById(frameId).contentDocument;
	}else if(document.frames[frameId] && document.frames[frameId].document){
		return document.frames[frameId].document;
	}else{
		return null;
	}
}
</script>
</head>
  
<body>

</body>
</html>