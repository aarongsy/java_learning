<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.category.service.*" %>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@page import="com.eweaver.workflow.workflow.model.WorkflowUseCount"%>
<%
int division =NumberHelper.string2Int(request.getParameter("cols"),3);//列数
int width = 98/division;//每列宽百分比
StringBuffer parameters = new StringBuffer();
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String pName = e.nextElement().toString().trim();
	String pValue = StringHelper.null2String(request.getParameter(pName));
	if(!StringHelper.isEmpty(pName)){
		parameters.append("&").append(pName).append("=").append(URLEncoder.encode(pValue, "UTF-8"));
	}
}
String url="javascript:onUrl('/workflow/request/workflow.jsp?workflowid={id}"+parameters.toString()+"','{name}','tab{id}')";

EweaverUser eweaveruser = BaseContext.getRemoteUser();
StartWorkflowService startWorkflowService = new StartWorkflowService();
startWorkflowService.setUrl(url);
List[] lists =startWorkflowService.getWorkflowList(division,eweaveruser);

PermissionruleService ps = (PermissionruleService)BaseContext.getBean("permissionruleService");
boolean isSysAdmin = ps.checkUserRole(eweaveruser.getId(),"402881e50bf0a737010bf0a96ba70004",null); 
%>
<html>
<head>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type='text/javascript' language="javascript" src='/js/workflow.js'></script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui-1.9m7/ui/minified/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
<link href="/css/eweaver.css" type="text/css" rel="STYLESHEET">
<style>
div{width:<%=width%>%;height:100%;float:left;}
ul{margin:10 0 2 20;color:#333; font-size: 15px;font-weight: bold;}
li ul{;font-size: 12px;font-weight: normal;}
a{margin:2 px;}
a:link{color:#33f}
body{border: none;}
.ul-state-highlight {
	border: 1px dotted black; 
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	visibility: visible !important; 
	height: 24px !important;
	background:url("/images/base/moveHereFlag.jpg") no-repeat;
	background-position: 0px -6px;
}
.sortBtnDiv{
	position: absolute;
	top: 5px;
	right: 5px;
	width: auto;
	height: auto;
}
a.whiteButton {
    background: transparent url('/images/base/bg_whiteButton_a.gif') no-repeat scroll top right;
    color: #444;
    display: block;
    float: left;
    font: normal 12px arial, sans-serif;
    height: 24px;
    margin-right: 6px;
    padding-right: 18px; /* sliding doors padding */
    text-decoration: none;
    cursor: pointer;
}

a.whiteButton span {
    background: transparent url('/images/base/bg_whiteButton_span.gif') no-repeat;
    display: block;
    line-height: 14px;
    padding: 5px 0 5px 18px;
} 

a.whiteButton:active {
    background-position: bottom right;
    color: #000;
    outline: none; /* hide dotted outline in Firefox */
}

a.whiteButton:active span {
    background-position: bottom left;
    padding: 6px 0 4px 18px; /* push text down 1px */
} 
ul.moduleUL{
	list-style: none;
	margin-top: 20px;
	padding-left: 0px;
}
ul.firstModuleUL{
	margin-top: 0px;
}
ul.moduleUL li span{
	font-family: Microsoft YaHei;
	color:#4f6b72; 
	font-size: 13px;
	font-weight: bold;
}
ul.flowUL{
	font-size: 12px;
	font-weight: normal;
	margin-top: 5px;
	margin-left: 40px;
	list-style: none;
	padding-left: 0px;
}
ul.flowUL li{
	margin-top: 3px;
	padding-left: 16px;
	background-repeat: no-repeat;
	background-position: 0px 3px;
}
ul.flowUL li.bgStyle1{
	background-image: url("/images/base/card1.png");
}
ul.flowUL li.bgStyle2{
	background-image: url("/images/base/card2.png");
}
ul.flowUL li.bgStyle3{
	background-image: url("/images/base/card3.png");
}
ul.flowUL li a{
	font-family: Microsoft YaHei;
	color: #123885;
	text-decoration:none;
}
ul.flowUL li a:hover{
	color:red;
}
</style>
<script type="text/javascript">
$(function(){
	addClassToFirstModuleUL();
	
	bindAjaxSubmitWithForm();
});

function addClassToFirstModuleUL(){
	$(".connectedSortable ul.moduleUL").removeClass("firstModuleUL");
	$(".connectedSortable ul.moduleUL:first-child").addClass("firstModuleUL");	
}

function bindAjaxSubmitWithForm(){
	$("#sortForm").ajaxForm({
        success: function(responseText, statusText, xhr, $form){
        	if(responseText == "success"){
        		if(top.pop){
					top.pop("<span>操作成功！<span>");
				}else{
					alert("操作成功！");
				}
        		location.reload();
        	}else{
        		alert("操作失败！\n" + responseText);
        	}
        }
	}); 
}

function toBeSort(){
	$(".connectedSortable").sortable({
		connectWith: ".connectedSortable",
		placeholder: "ul-state-highlight",
		stop: function(event, ui) {
			addClassToFirstModuleUL();
		}
	}).disableSelection();

	$(".connectedSortable ul.moduleUL").css("cursor", "move");
	
	$(".connectedSortable ul.moduleUL li ul.flowUL li a").attr("href","javascript:void(0);");
	
	$("#startSortBtn").hide();
	
	$("#saveSortResultBtn").show();
}

function saveSortResult(){
	var resultStr = "[";
	var order = 0;
	var $connectedSortables = $(".connectedSortable");
	$connectedSortables.each(function(i){
		var $moduleULs = $(this).children("ul.moduleUL");
		$moduleULs.each(function(j){
			order++;
			var $moduleUL = $(this);
			var moduleId = $moduleUL.attr("id");
			var colInStartWorkFlow = i + 1;
			var dsporderInStartWorkFlow = order;
			resultStr = resultStr + "{\"id\":\""+moduleId+"\",\"colInStartWorkFlow\":"+colInStartWorkFlow+",\"dsporderInStartWorkFlow\":"+dsporderInStartWorkFlow+"},";
		});
	});
	if(resultStr != "["){
		resultStr = resultStr.substring(0, resultStr.length - 1);
	}
	resultStr = resultStr + "]";
	document.getElementById("sortResult").value = resultStr;
	
	$("#sortForm").submit();
}
</script>
</head>
<body>
<%if(isSysAdmin){%>
<div class="sortBtnDiv">
	<a class="whiteButton" id="startSortBtn" onclick="toBeSort();"><span>开始拖动排序</span></a>
	<a class="whiteButton" id="saveSortResultBtn" onclick="saveSortResult();" style="display: none;"><span>保存排序结果</span></a>
</div>	
<%} %>
<form action="/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=saveSortResult" method="post" id="sortForm" style="margin: 0px;padding: 0px;display: none;">
	<input type="hidden" id="sortResult" name="sortResult"/>
</form>

<%
WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
List<WorkflowUseCount> workflowUseCountList = workflowinfoService.getAllWorkflowUseCountByHumres();
String commonHTML = "";
if(workflowUseCountList.size()>0){
	commonHTML = startWorkflowService.getCommonWorkflowStartHtml(lists,workflowUseCountList);
}
for(int i=0;i<lists.length;i++){
	List list = lists[i];
%>

<div class="connectedSortable">
	<%if(i==0){ %>
		<%=commonHTML %>
	<%} %>
	<%for(int j=0;j<list.size();j++){
		Map m = (Map)list.get(j);
	%>
	<%=startWorkflowService.getWorkflowStartHtml(m)%>
	<%}%>
</div>

<%}%>

</body>
</html>