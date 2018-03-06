<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.category.service.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%
if(eweaveruser == null){
	response.sendRedirect("/main/login.jsp");
	return;
}

int division =NumberHelper.string2Int(request.getParameter("cols"),4);//列数
int width = 98/division;//每列宽百分比
String categoryid = request.getParameter("categoryid")==null?"40288148117d0ddc01117d8c36e00dd4":(String)request.getParameter("categoryid");
String moduleid = request.getParameter("moduleid")==null?"402880732813ed87012814269eed0004":(String)request.getParameter("moduleid");

StringBuffer parameters = new StringBuffer();
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String pName = e.nextElement().toString().trim();
	String pValue = StringHelper.null2String(request.getParameter(pName));
	if(!StringHelper.isEmpty(pName)){
		parameters.append("&").append(pName).append("=").append(URLEncoder.encode(pValue, "UTF-8"));
	}
}
String url = "/document/base/docbasecreate.jsp?categoryid={id}"+parameters.toString();
int level = NumberHelper.getIntegerValue(request.getParameter("level"));
if(level<=0) level=3;
DocCategoryService docCategoryService = new DocCategoryService(moduleid);
docCategoryService.init(moduleid,categoryid);
docCategoryService.setShowLevel(level);
docCategoryService.setUrl(url);
//docCategoryService.init(moduleid,categoryid);
List<DocCategoryService.CategoryTree>[] lists = docCategoryService.getDocCategory(categoryid,division,eweaveruser);
%>
<html>
<head>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui-1.9m7/ui/minified/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
<style>
div{width:<%=width%>%;height:100%;float:left;}
ul{margin:2 0 2 20;color:#333; font-size: 12px;font-weight: bold;list-style: none;}
li ul{font-weight: normal;}
.hand{cursor: pointer;}
a{font-size: 12px;}

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
ul.topLevel{
	margin-top: 20px;
}
ul.firstTopLevel{
	margin-top: 10px;
}
ul.topLevel ul{
	margin-left: 30px;
}
ul.topLevel li{
	font-family: Microsoft YaHei;
}
ul.topLevel li a{
	font-family: Microsoft YaHei;
}
</style>
<script type="text/javascript">
$(function(){
	addClassToFirstTopLevelUL();
	
	bindAjaxSubmitWithForm();
});

function addClassToFirstTopLevelUL(){
	$(".connectedSortable ul.topLevel").removeClass("firstTopLevel");
	$(".connectedSortable ul.topLevel:first-child").addClass("firstTopLevel");	
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
			addClassToFirstTopLevelUL();
		}
	}).disableSelection();

	$(".connectedSortable ul.topLevel").css("cursor", "move");
	
	$(".connectedSortable ul.topLevel li a").attr("href","javascript:void(0);");
	
	$("#startSortBtn").hide();
	
	$("#saveSortResultBtn").show();
}

function saveSortResult(){
	var resultStr = "[";
	var order = 0;
	var $connectedSortables = $(".connectedSortable");
	$connectedSortables.each(function(i){
		var $topLevelULs = $(this).children("ul.topLevel");
		$topLevelULs.each(function(j){
			order++;
			var $topLevelUL = $(this);
			var categoryId = $topLevelUL.attr("title");
			var colInStartDocument = i + 1;
			var dsporderInStartDocument = order;
			resultStr = resultStr + "{\"id\":\""+categoryId+"\",\"colInStartDocument\":"+colInStartDocument+",\"dsporderInStartDocument\":"+dsporderInStartDocument+"},";
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
<form action="/ServiceAction/com.eweaver.base.category.servlet.CategoryAction?action=saveSortResult" method="post" id="sortForm" style="margin: 0px;padding: 0px;display: none;">
	<input type="hidden" id="sortResult" name="sortResult"/>
</form>

<%for(int i=0;i<division;i++){
	List list = lists[i];
%>
<div class="connectedSortable">
	<%for(int j=0;j<list.size();j++){
		DocCategoryService.CategoryTree tree = (DocCategoryService.CategoryTree)list.get(j);
	%>
	<ul title="<%=tree.getId() %>" class="topLevel">
	<%=docCategoryService.getCategoryHtml(tree,0)%>
	</ul>
	<%}%>
</div>
<%}%>
</body>
<script type="text/javascript">
function closeopen(img,id){
	var ul = document.getElementById(id);
	if(ul.style.display=='none'){
		ul.style.display='';
		img.src='/images/doc/folderopen.gif';
	}else{
		ul.style.display='none';
		img.src='/images/doc/folder.gif';
	}
}
</script>
</html>