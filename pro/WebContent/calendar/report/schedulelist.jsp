<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.DataService"%>
<%@ include file="/base/init.jsp"%>
<%
String path = request.getContextPath();
String tagerUrl ="/ServiceAction/com.eweaver.calendar.report.ScheduleAction?action=search";
DataService dataService = new DataService();
String sql="select * from selectitem where typeid='408948fe24709ac30124714b34170141'";
List<Map> mapList=dataService.getValues(sql);
%> 
<html>
<head>
<title>日程列表</title>
  <script type="text/javascript" src="<%=path%>/js/jquery-latest.pack.js"></script>
  <script type='text/javascript' src="<%=path%>/js/tx/jquery.autocomplete.pack.js"></script>
  <link rel="stylesheet" type="text/css" href="<%=path%>/js/tx/jquery.autocomplete.css"/>	
<link rel="stylesheet" type="text/css" href="<%=path %>/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="<%=path %>/css/maincss.css" />
<style type="text/css">
	.x-toolbar table {
		width: 0
	}
	a{
		color: blue;
		cursor: pointer;
	}
	#pagemenubar table {
		width: 0
	}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {
		width: 0
	}
</style>
<script type="text/javascript">
		var tagerUrl = "<%=tagerUrl%>";
</script>
<script type="text/javascript" src="<%=path %>/js/main.js"></script>
<script type="text/javascript" src="<%=path %>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=path %>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=path %>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=path %>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=path %>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=path %>/js/ext/ux/AutoRefresher.js"></script>
<script type="text/javascript" src="schedulelist.js"></script>
<script type="text/javascript" language="javascript" src="<%=path %>/datapicker/WdatePicker.js"></script>
</head>
<body>
<div id="divSearch">
<div id="pagemenubar"></div>
<form action="" id="TWForm" name="TWForm" method="post">
<input type="hidden" id="sqlstr1" name="sqlstr1" value="" >
<table class="viewform">
	<tr class="title">
		<td class="FieldName" nowrap>部门</td>
		<td class="FieldValue" nowrap>
			<button  type="button" class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','department','departmentspan','0');"></button>
			<input type="hidden"  name="department" value=""/>
			<span id="departmentspan"/></span>
		</td>
		<td class="FieldName" nowrap>相关人员</td>
		<td class="FieldValue" nowrap>
			<button  type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');"></button>
			<input type="hidden"  name="creator" value=""/>
			<span id="creatorspan"/></span>
		</td>
	</tr>
	<tr class="title">
		<td class="FieldName" nowrap>开始日期</td>
		<td class="FieldValue" noWrap>
			<input name="startdate" style="width:100" onclick="WdatePicker()" value="<%=DateHelper.getCurrentDate()%>" readonly="readonly">
		</td>
		<td class="FieldName" nowrap>截止日期</td>
		<td class="FieldValue" noWrap>
			<input name="enddate" style="width:100" onclick="WdatePicker()" value="<%=DateHelper.getCurrentDate()%>" readonly="readonly">
		</td>
	</tr>
</table>
</form>
</div>
<script type="text/javascript">
	
    function doRefresh(){
        top.contentPanel.getActiveTab().getFrameWindow().location.reload(true);
    }
    function doBack(){
        top.contentPanel.getActiveTab().getFrameWindow().history.back();
    }
    function doForward(){
        top.contentPanel.getActiveTab().getFrameWindow().history.forward();
    }
    function doDestroy(){
        top.contentPanel.items.each(function(item){
                       top.contentPanel.remove(item);                      
        });
    }
    
	function getBrowser(viewurl,inputname,inputspan,isneed){
	    var id;
	    try{
	    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
				document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
		
		    }
	    }
	}
</script>
</body>
</html>