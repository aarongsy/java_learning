<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>

<%
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
String workflowid = request.getParameter("detailid");
String from = StringHelper.null2String((String)request.getParameter("from"));
String module = StringHelper.null2String((String)request.getParameter("module"));
String scope = StringHelper.null2String((String)request.getParameter("scope"));
String mobileSession = StringHelper.null2String((String)request.getParameter("mobileSession"));
String client = StringHelper.null2String((String)request.getParameter("client"));
String type = StringHelper.null2String((String)request.getParameter("type"));
String sessionKey = StringHelper.null2String(request.getParameter("sessionkey"));
String clienttype = StringHelper.null2String(request.getParameter("clienttype"));

ServiceUser user = new ServiceUser(); 
user.setId(sessionKey);
String requestid = null;
Workflowinfo wi = workflowinfoService.get(workflowid);
if(wi.getIsDoc()==1){
	response.sendRedirect("/mobiledoc.jsp");
	return;
}

EweaverClientServiceImpl eweaverClientService = (EweaverClientServiceImpl)BaseContext.getBean("eweaverClientServiceImpl");
WorkflowRequestInfo workflowRequestInfo =  eweaverClientService.getWorkflowRequestInfo(requestid,user,workflowid);

String userid= sessionKey;
String userSignRemark = "";
String forwardresourceids = "";
String clientip = "";

String method = "";
String workflowHtmlShow = "";
String fromWF = "";
String fromRequestid = "";

HttpServletRequest req = request;
String viewWfGraph = "<a href=\"javascript:goWfPic()\">查看流程图</a>";
if(ClientType.ANDROID.toString().equalsIgnoreCase(clienttype)){
	viewWfGraph = "";
}
%>

<%
/**
requestid = StringHelper.null2String(req.getParameter("requestid"));
if (StringHelper.isEmpty(requestid)) {
	requestid = detailid;
}**/
fromRequestid = req.getParameter("fromRequestid");

//WorkflowService workflowWebService = new WorkflowServiceImpl();
//workflowRequestInfo = workflowWebService.getWorkflowRequest4split(requestid, userid, Util.getIntValue(fromRequestid,0), 10000);
if(workflowRequestInfo==null){
	//没有权限
}
if(!workflowRequestInfo.getCanView()) {
	//没有权限
}

if(workflowRequestInfo.getWorkflowHtmlShow()!=null){
	workflowHtmlShow = workflowRequestInfo.getWorkflowHtmlShow()[0];
} else {
	workflowHtmlShow = "";
}

String subWorkflowHtmlShow="";
if(workflowRequestInfo.getWorkflowHtmlShow()[2]!=null){
	subWorkflowHtmlShow = workflowRequestInfo.getWorkflowHtmlShow()[2];
} 

workflowid = workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId();

%>

<%
	String request_fieldShowValue = "";
	String request_fieldShowIndex = "";
%>
<!DOCTYPE html>
<html>
	<head>
		<title><%=workflowRequestInfo.getWorkflowBaseInfo().getWorkflowName() %></title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<meta name="author" content="Weaver E-Mobile Dev Group" />
		<meta name="description" content="Weaver E-mobile" />
		<meta name="keywords" content="weaver,e-cology,e-mobile" />
		<meta name="viewport" content="width=device-width,minimum-scale=0.5, maximum-scale=5.0" />
		<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
		<script type="text/javascript" src="/mobile/plugin/1/js/workflow.js"></script>
		<script type="text/javascript" src="/mobile/plugin/1/js/eweaver.js"></script>
		<script type="text/javascript" src="/mobile/plugin/js/asyncbox/AsyncBox.v1.4.js"></script>
		<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
	    <link rel="stylesheet" href="/mobile/plugin/js/asyncbox/skins/ZCMS/asyncbox.css">

		<style type="text/css">
		
	a {
		text-decoration: none;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	#header #title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
.ui-li {
	filter: alpha(opacity = 85);
	-moz-opacity: 0.85;
	opacity: 0.85;
}

.ui-header {
	filter: alpha(opacity = 85);
	-moz-opacity: 0.85;
	opacity: 0.85;
	background: url('/images/header_bg.png') repeat-x;
}

.ui-bar-b {
	border: 0px;
}

.ui-btn-inner {
	border-top: 0px;
}

.ui-btn-up-c {
	border: 1px solid #FFF;
	border-bottom: 1px solid #C7D4EE;
	background: #eee;
	font-weight: bold;
	color: #444;
	cursor: pointer;
	text-shadow: 0 1px 1px #f6f6f6;
	text-decoration: none;
	background-image: -moz-linear-gradient(top, #FFF, #DFEAF3);
	background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #FFF),
		color-stop(1, #DFEAF3) );
	-ms-filter:
		"progid:DXImageTransform.Microsoft.gradient(startColorStr='#FFF', EndColorStr='#DFEAF3')"
		;
}

.ui-btn-hover-c {
	border: 1px solid #83BD07;
	border-top: 1px solid #D5EE23;
	background: #F6A93D;
	font-weight: bold;
	color: #101010;
	text-decoration: none;
	text-shadow: 0 1px 1px #fff;
	background-image: -moz-linear-gradient(top, #A7DB17, #8DC407);
	background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #A7DB17),
		color-stop(1, #8DC407) );
	-ms-filter:
		"progid:DXImageTransform.Microsoft.gradient(startColorStr='#A7DB17', EndColorStr='#8DC407')"
		;
}

.ui-btn-down-c {
	border: 1px solid #83BD07;
	border-top: 1px solid #D5EE23;
	background: #fdfdfd;
	font-weight: bold;
	color: #111111;
	text-shadow: 0 1px 1px #ffffff;
	background-image: -moz-linear-gradient(top, #8DC407, #A7DB17);
	background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #8DC407),
		color-stop(1, #A7DB17) );
	-msfilter:
		"progid:DXImageTransform.Microsoft.gradient(startColorStr='#8DC407', EndColorStr='#A7DB17')"
		;
}

.ui-view-corner {
	-moz-border-radius: 10px;
	-webkit-border-radius: 10px;
	border-radius: 10px;
}

.ui-view-opacity {
	filter: alpha(opacity = 75);
	-moz-opacity: 0.75;
	opacity: 0.75;
}

.ui-li .ui-btn-inner {
	padding-right: 20px
}

.workFlowView p {
	overflow: visible !important;
	word-break: break-all;
	white-space: normal !important;
}

.ui-input-text,.ui-select {
	width: 100% !important;
	padding: 0.4em 0 !important;
}

.ismand {
	color: red;
	font-size: 20pt;
}

.tablefieldname {
	width: 120px;
	white-space: normal;
}

.tablefieldvalue {
	white-space: normal;
}

.tablefieldvalue span {
	font-size: 12px;
}

/* 顶部回退导航栏 Start */
.headNavigation {
	width: 100%;
	height: 43px;
	border-bottom: 1px solid #838A9A;
	margin: 0;
	background: #AAAFBC;
	background: -moz-linear-gradient(0, #F4F5F7, #AAAFBC);
	background: -webkit-gradient(linear, 0 0, 0 100%, from(#F4F5F7),
		to(#AAAFBC) );
	font-size: 12px;
	color: #1D3A66;
}

.back {
	float: left;
	margin-left: 5px;
	background: url(/images/back.png) 0 0 no-repeat;
}

.logout {
	float: right;
	margin-right: 5px;
	background: url(/images/logout.png) 0 0 no-repeat;
}

.oprtbt {
	width: 52px;
	height: 31px;
	overflow: hidden;
	text-align: center;
	line-height: 30px;
	margin-top: 6px;
}

/* 顶部回退导航栏  END*/
.content {
	background: url(/images/news/viewBg.png) repeat;
	margin: 0;
	width: 100%;
}

/* 栏目快HEAD START */
.blockHead {
	width: 100%;
	height: 24px;
	line-height: 24px;
	font-size: 12px;
	font-weight: bold;
	color: #fff;
	border-top: 1px solid #0084CB;
	border-left: 1px solid #0084CB;
	border-right: 1px solid #0084CB;
	-moz-border-top-left-radius: 5px;
	-moz-border-top-right-radius: 5px;
	-webkit-border-top-left-radius: 5px;
	-webkit-border-top-right-radius: 5px;
	border-top-left-radius: 5px;
	border-top-left-radius: 5px;
	background: #0084CB;
	background: -moz-linear-gradient(0, #31B1F6, #0084CB);
	background: -webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6),
		to(#0084CB) );
}

.m-l-14 {
	margin-left: 14px;
}

/* 栏目快HEAD END */
.tblBlock {
	width: 100%;
	border-left: 1px solid #C5CACE;
	border-right: 1px solid #C5CACE;
	border-bottom: 1px solid #C5CACE;
	background: #fff;
	-moz-border-bottom-left-radius: 5px;
	-moz-border-bottom-right-radius: 5px;
	-webkit-border-bottom-left-radius: 5px;
	-webkit-border-bottom-right-radius: 5px;
	border-bottom-left-radius: 5px;
	border-bottom-left-radius: 5px;
}

.signRow {
	line-height: 25px;
	font-size: 12px;
	color: #838383;
	padding-left: 10px;
	word-break: break-all;
}

.operationBt {
	height: 26px;
	margin-left: 18px;
	margin-bottom: 10px;
	line-height: 26px;
	font-size: 14px;
	padding-left: 10px;
	padding-right: 10px;
	color: #fff;
	text-align: center;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border-radius: 5px;
	border: 1px solid #0084CB;
	background: #0084CB;
	background: -moz-linear-gradient(0, #30B0F5, #0084CB);
	background: -webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5),
		to(#0084CB) );
	overflow: hidden;
	float: left;
}

.width104 {
	width: 104px;
}

textarea {
	width: 97%;
	height: 95%;
}

input[type=text] {
	width: 97%;
	height: 28px;
}
</style>
		<script type="text/javascript">
		var fieldIdRemindType;
		var fieldIdRemindBeforeStart;
		var fieldIdRemindBeforeEnd;
		var fieldIdRemindTimesBeforeStart;
		var fieldIdRemindTimesBeforeEnd;
	$(document).ready(function () {
		var textareaArray = $("TEXTAREA");
		textareaArray.attr("horizontalScrollPolicy", "off");
		textareaArray.attr("verticalScrollPolicy", "off");
		
		textareaArray.bind("input", function () {
			$(this).css("height", $(this)[0].scrollHeight-4);
		});
		
		textareaArray.bind("propertychange", function () {
			$(this).css("height", $(this)[0].scrollHeight-4);
		});
		
		$("a[href='#'][data-rel='dialog']").attr("href","javascript:void(0);");
		
		if(fieldIdRemindType){
			doChangeRemindType(document.getElementById(fieldIdRemindType));
		}
	});
	document.onkeydown=function(event){ 
        e = event ? event :(window.event ? window.event : null); 
        if(e.keyCode==13){
            return false; 
        } 
    } 
	
	
	</script>
		<SCRIPT type="text/javascript">
	function detailview(contentId) {
		window.location.href = "/common/detailview.jsp?content=" + $("#" + contentId).val() + "&_tok=" + new Date().getTime();
	}
	
	function showDialog(url, data) {
		var top = ($( window ).height()-150)/2;
		var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
		$.open({
			id : "selectionWindow",
			url : url,
			data: "r=" + (new Date()).getTime() + data,
			title : "请选择",
			width : width,
			height : 155,
			scrolling:'yes',
			top: top,
			callback : function(action, returnValue){
			}
		});
		$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() + data);
	}

	function closeDialog() {
		$.close("selectionWindow");
	}
	function getDialogId() {
		return "selectionWindow";
	}

	function showwfsigndetail(obj, targetId) {
		$(obj).hide();
		$("#" + targetId).show();
	}

	function loadstatus(obj) {
		$(obj).attr("loadding", 1);
		$(obj).html("处理中...");
	}

	function setPageAllButtonDisabled() {
		$(".operationBt").unbind("click");
		$(".operationBt").attr("onclick", "");
		$(".operationBt").css("background", "#A4A4A4");
		$(".operationBt").css("border", "1px solid #A4A4A4");
	}
	
	function validateDate(obj){	    
		if(obj){
			var val = obj.value;
			if(val == ""){
				return true;
			}
			//使用正规表达式验证日期格式
			var reg = /^((?:19|20)\d\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/;
			if (!reg.test(val)){
				obj.value = "";
				asyncbox.alert('日期格式错误,请重新输入如2012-09-01','提示');
				return false;
			}
		}
	}
	
	function validateTime(obj){
		if(obj){
			var val = obj.value;
			if(val == ""){
				return true;
			}
			
			//使用正规表达式验证时间格式
			var reg = /^(([0-9])|([0-1][0-9])|([1-2][0-3])):([0-5][0-9]):([0-5][0-9])$/;
			if (!reg.test(val)){
				obj.value = "";
				asyncbox.alert('时间格式错误,请重新输入如12:10:11','提示');
				return false;
			}
		}
	}
	
	function validateDatetime(obj){	    
		if(obj){
			var val = obj.value;
			if(val == ""){
				return true;
			}
			//使用正规表达式验证日期格式
			var reg = /^((?:19|20)\d\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])\s{1,}(([0-1][0-9])|([1-2][0-3])):([0-5][0-9]):([0-5][0-9])$/;
			if (!reg.test(val)){
				obj.value = "";
				asyncbox.alert('日期格式错误,请重新输入如2012-09-01 09:12:11','提示');
				return false;
			}
		}
	}
	
	function validateYear(obj){
		if(obj){
			var val = obj.value;
			if(val == ""){
				return true;
			}
			
			//判断长度是否为4
			if(val.length != 4){
				obj.value = "";
				return false;
			}
			
			//使用正规表达式验证年份格式
			var reg = /^20\d{2}$/;
			if (!reg.test(val)){
				obj.value = "";
				return false;
			}
		}
	}
	
	function goWfPic() {
		window.location.href = "/wfdesigner/viewers/workflowPicture.jsp?requestid=<%=requestid%>&fromid=<%=from%>&page=workflowPicture&workflowid=<%=workflowid%>";
	}
	function goWfStatus() {
		window.location.href = "/mobile/plugin/1/workflowStatus.jsp?requestid=<%=requestid%>&fromid=<%=from%>&page=workflowStatus&workflowid=<%=workflowid%>";
	}
	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--
		$(document).ready(function(){
			setRedflag();
			setInterval("setRedflag()",1000);
		});
		
		function setRedflag(){
			$(".ismand").each(function() {
				var vid = this.id;
				vid = vid.substring(0, vid.indexOf("_"));
				if ($("#" + vid).val() != "") {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
			
			if ($("#userSignRemark").val() != "") {
				$("#userSignRemark_ismand").hide();
			} else {
				$("#userSignRemark_ismand").show();
			}
		}

		function doexpand(){
			if($('#moresigninfotext')&&$("div[name='moresigninfodiv']")) {
				if($("div[name='moresigninfodiv']")[0].style.display == "none"){
					$('#moresigninfotext').html('部分');
					$("div[name='moresigninfodiv']").show();
				} else {
					$('#moresigninfotext').html('更多');
					$("div[name='moresigninfodiv']").hide();
				}
			}
		}

		/**
		 * 获取url参数
		 */
		function getUrlParam() {
			var sessionkey = "<%=mobileSession%>";
			var module = $("input[name='module']").val();
			var scope = $("input[name='scope']").val();
			var pagesize = 5;
			var workflowid = $("input[name='workflowid']").val();
			var requestid = $("input[name='requestid']").val();
			var workflowsignid = $("input[name='workflowsignid']").val();
			
			var paras = "method=getmoreworkflowsign&sessionkey=" + sessionkey + 
				"&module=" + module + 
				"&scope=" + scope + 
				"&pagesize=" + pagesize + 
				"&workflowid=" + workflowid + 
				"&requestid=" + requestid + 
				"&pageindex=" + workflowsignid + 
				"&tk" + new Date().getTime() + "=1";
			return paras;
		}
		
		function dochecksubmit(){
			<%
			if ("1".equals(workflowRequestInfo.getTempletStatus())) {
			%>
			asyncbox.alert('请先执行套红操作！','提示');
			return false;
			<%
			} else {
			%>
			var flag = true;
			$("input#ismandfield").each(function() {
				var field = document.getElementById(this.value);
				if(field&&flag){
					if(field.value==null||field.value==""){
						asyncbox.alert('请填写相关字段!','提示');
						flag = false;
					}
				}
			});
			$("input[isrequired='1']").each(function() {				
				var field = document.getElementById(this.id);
				if(field&&flag){
					if(this.value==null||this.value==""){
						asyncbox.alert($(this).attr('lablename') + '为空!','提示');
						flag = false;						
					}
				}
			});
			if($('#userSignRemark_ismandspan').length==1&&$('#userSignRemark')&&($('#userSignRemark').val()==null||$('#userSignRemark').val()=="")){
				asyncbox.alert('请填写签字意见!','提示');
				flag = false;
			}
			<%
			if ("1".equals(workflowRequestInfo.getSignatureStatus())) {
			%>
			
			if(flag) {
				flag=confirm('该节点为签章节点，您未执行签章操作，是否确定提交？');
			}
			<%
			}
			if (workflowRequestInfo.isNeedAffirmance()) {
			%>
			if(flag) {
				flag=confirm("确认是否提交？");
			}
			<%}%>
			return flag;
			<%}%>
		}

	   function doIt() {
	        var fields = $('#workflowfrm').serialize();
	        //asyncbox.alert(fields);
	        var url = '/mobile/plugin/1/RequestOperation.jsp';
     		jQuery.post(url,fields,function(data){
     		    var rs = data.code;
     		    var thishref = window.location.href;
     		    var requestid = '';
     		    if(data.requestid) {
     		    	var requestid = data.requestid;
     		        var thishref = "/mobile/plugin/1/viewfromcreate.jsp?detailid="+requestid;     		   
     		    }
     		    if(rs == '1') {   		    	    
     		        asyncbox.alert(data.message,'提示',function(){		            
     		        	window.location.replace(thishref);
     		        });    		        
     		    } else {    		    	 
     		         asyncbox.alert(data.message,'提示',function(){		            
     		        	window.location.replace(thishref);
     		        });
     		    }			
     		},'json');
		}

		function dosubmit(_this){
			if(dochecksubmit()){
				setPageAllButtonDisabled();
				loadstatus(_this);
				
				$('#src').val("submit");
				//$('#workflowfrm').submit();
				doIt();
			}
		}
		
		function dosubnoback(_this){
			if(dochecksubmit()){
				setPageAllButtonDisabled();
				loadstatus(_this);

				$('#src').val("subnoback");
				//$('#workflowfrm').submit();
				doIt();
			}
		}
		
		function dosave(_this){
			setPageAllButtonDisabled();
			loadstatus(_this);	
			$('#src').val("save");
			doIt();
			//$('#workflowfrm').submit();
		}
		
		function docheckreject(){
			<%
			if ("2".equals(workflowRequestInfo.getTempletStatus())) {
			%>
			alert('请先取消套红！');
			return false;
			<%} else {%>
			var flag = true;
			if($('#userSignRemark_ismandspan').length==1&&$('#userSignRemark')&&($('#userSignRemark').val()==null||$('#userSignRemark').val()=="")){
				asyncbox.alert('请填写签字意见!','提示');
				flag = false;
			}
			<%
			if (workflowRequestInfo.isNeedAffirmance()) {
			%>
			if(flag) {
				flag=confirm("确认是否退回？");
			}
			<%}%>
			return flag;
			<%}%>
		}

		function doreject(_this){
			if(docheckreject()){
				setPageAllButtonDisabled();
				loadstatus(_this);
				
				$('#src').val("reject");
				//$('#workflowfrm').submit();
				doIt();
			}
		}
		
		function docheckforward(){
			var flag = true;
			if($('#forwardresourceids')&&($('#forwardresourceids').val()==null||$('#forwardresourceids').val()=="")){
				asyncbox.alert('请选择转发接收人！','提示');
				flag = false;
			}
			if($('#userSignRemark_ismandspan').length==1&&$('#userSignRemark')&&($('#userSignRemark').val()==null||$('#userSignRemark').val()=="")){
				asyncbox.alert('请填写签字意见!','提示');
				flag = false;
			}
			<%
			if (workflowRequestInfo.isNeedAffirmance()) {
			%>
			if(flag) {
				flag=confirm("确认是否转发？");
			}
			<%}%>
			return flag;
		}

		function doforward(_this){
			if(docheckforward()){
				setPageAllButtonDisabled();
				loadstatus(_this);
				$('#src').val("forward");
				//$('#workflowfrm').submit();
				doIt();
			} 
		}

		function toDocument(docid){
			location = '<s:url value="/news/view.do"/>?id='+docid+'&page.pageNo=${page.pageNo}&module=${module}&scope=${scope}&unread=${unread}&fromWF=true&requestid=${requestid}&showAll=true';
		}
		
		function toRequest(requestid){
			location = '<s:url value="/workflow/edit.do"/>?requestid='+requestid+'&page.pageNo=${page.pageNo}&module=${module}&scope=${scope}&unread=${unread}&fromWF=true&fromRequestid=${requestid}';	
		}
		
		function toURL(url,isopenwin){
			if(!isopenwin){
				if(url) location = url+"&fromWF=true&requestid=${requestid}&page.pageNo=${page.pageNo}&module=${module}&scope=${scope}&unread=${unread}";
			} else {
				window.open(url,'_blank');
			}
		}
		
		function addToRemark2(_this) {
			if ($(_this).val()!="0") {
				var remark = $('#userSignRemark').val();
				if (remark != null && remark != "") {
					$('#userSignRemark').val(remark + "\n" +$(_this).val());
				} else {
					$('#userSignRemark').val($(_this).val());
				}
			}
		}
		
		function exTblCol(ele, colCount) {
			if (colCount * 100 > $(ele).width()) {
				$(ele).children("TABLE").width(colCount * 100);
			}
		}
		
		window.onresize = function () {
			$("div[name='detailTableDiv']").each(function () {
				if ($(this).children("TABLE").width() < $(this).width()) {
					$(this).children("TABLE").width($(this).width());
				}
			});
		};
	//-->
	</SCRIPT>
	</head>

	<body>
		
		<div data-role="page" class="page workFlowView">
		<%if(ClientType.WEB.toString().equalsIgnoreCase(clienttype)){%>
		        <div id="header">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="/home.do">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;font-size:9pt;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title">查看流程</div>
					</td>
				</tr>
			</table>
		</div>
		<%}  %>
		<div style="height:0px;overflow:hidden;"></div>
		<div class="blockHead">
			<span class="m-l-14">流程信息  <%=viewWfGraph %></span>
		</div>
		<div class="tblBlock" style="width:100%;background:#fff;">



				<form id="workflowfrm" action="/mobile/plugin/1/RequestOperation.jsp" method="post" enctype="multipart/form-data">
					<input type="hidden" id="type" name="type" value="<%=type %>" />
					<input type="hidden" id="method2" name="method2" value="<%=method %>" />
					<input type="hidden" id="src" name="src" value="<%=method %>" />
					<%
					if (workflowHtmlShow != null && !"".equals(workflowHtmlShow)) {
					
					%>
							<% 
							   out.println(workflowHtmlShow);							   
							%>
						<!-- 流程明细开始 -->
					<%} if(subWorkflowHtmlShow != null && !"".equals(subWorkflowHtmlShow)) {
					%>
					<div class="blockHead">
			<span class="m-l-14">流程明细</span>
		</div>
		<div class="tblBlock" style="width:100%;background:#fff;">		
		<%=subWorkflowHtmlShow %>		
		</div>
		<%
					}
					%>
						<!-- 流程明细结束 -->
						
								<%
		String workflowsignid = "";
		//System.out.println(workflowRequestInfo.getWorkflowRequestLogs().length);
		if (!"create".equals(type) && workflowRequestInfo.getWorkflowRequestLogs() != null && workflowRequestInfo.getWorkflowRequestLogs().length > 0) {
			int workflowsigncnt = 0;
		%>
		<div class="blockHead">
				<span class="m-l-14">流转意见</span>
		</div>
		<div class="tblBlock" style="width:100%;background:#fff;" id="workflowrequestsignblock">
			<%
			WorkflowRequestLog[] workflowRequestLogs = workflowRequestInfo.getWorkflowRequestLogs();
			String dispalynone = "";
			String moredivname="";
			for (int i=0; i<workflowRequestLogs.length; i++) {
				WorkflowRequestLog wfreqlog = workflowRequestLogs[i];
				workflowsignid = wfreqlog.getId();
				String remarkSign = wfreqlog.getRemarkSign();
				String remark = wfreqlog.getRemark();
				String operatorSign = wfreqlog.getOperatorSign();
				//String agentor = wfreqlog.getAgentor();
				//String agentorDept = wfreqlog.getAgentorDept();
				String operatorDept = wfreqlog.getOperatorDept();
				String operatorName = wfreqlog.getOperatorName();
				String operateDate = wfreqlog.getOperateDate();
				String operateTime = wfreqlog.getOperateTime();
				String nodeName = wfreqlog.getNodeName();
				String operateType = wfreqlog.getOperateType();
				String receivedPersons = wfreqlog.getReceivedPersons();
				workflowsigncnt++;
				if(workflowsigncnt >= 5) {
					dispalynone = "display:none;";
					moredivname="name = \"moresigninfodiv\"";
				}
				if (i != 0) {
			%>
					<div <%=moredivname %> style="width:100%;height:1px;border-top:1px solid #CFD3D8;overflow:hidden;margin-top:5px;<%=dispalynone %>"></div>
				<%} %>
				<div style="width:100%;<%=dispalynone %>" <%=moredivname %>>
					<div class="signRow" style="font-size:14px;font-weight:bold;color:#000;">
					<%
					if (remarkSign != null) {
					%>
					<div style="width:100%;">
						<img alt="" src="/download.do?fileid=<%=remarkSign %>">
					</div>
					<%} else { %>
						<%=remark %>
					<%
					}
					%>
					</div>
					<%
					if (operatorSign != null) {
					%>
					<div style="width:100%;">
						<img alt="" src="/downloadpic.do?path=<%=operatorSign %>/>">
					</div>
					<%} else { %>
					<div class="signRow">
						
						<%
						if (operatorDept != null && !"".equals(operatorDept)) {
						%>
							<%=operatorDept %>&nbsp;/&nbsp;
						<%} %>
						<%=operatorName %>&nbsp;<%=operateDate %>&nbsp;<%=operateTime %>
							
					</div>
					<%} %>
					<div class="signRow">
						节点:<%=nodeName %>&nbsp;&nbsp;&nbsp;&nbsp;操作:<%=operateType %>
					</div>
					<!--  
					<div class="signRow">
						接收人:
						<%
						if (receivedPersons != null && receivedPersons.length() >= 15) {
						%>
						<span onclick="showwfsigndetail(this, 'wfsignreceivedp<%=i %>');" style="font-size:12px;">
							<%=receivedPersons.substring(0, 15) %>...&nbsp;&nbsp;<span style="color: blue;">显示</span>
						</span>
						<span id="wfsignreceivedp<%=i %>" style="display:none;">
							<%=receivedPersons %>
						</span>
						<%} else { %>
							<span id="wfsignreceivedp<%=i %>" style="">
								<%=receivedPersons %>
							</span>
						<%} %>
					</div>
					-->
					<%
					if ((wfreqlog.getSignDocHtmls() != null && !wfreqlog.getSignDocHtmls().equals(""))
							||(wfreqlog.getSignWorkFlowHtmls() != null && !wfreqlog.getSignWorkFlowHtmls().equals(""))
							||(wfreqlog.getAnnexDocHtmls() != null && !wfreqlog.getAnnexDocHtmls().equals(""))) {
					%>
					<br />
					<div style="border-top:1px dashed #AAAAAA;height:1px; overflow:hidden;margin-left:12px;margin-right:12px;"></div>
					<%} %>
					<%-- 相关文档 --%>
					<%
					if (wfreqlog.getSignDocHtmls() != null && !"".equals(wfreqlog.getSignDocHtmls())) {
					%>
					<div class="signRow">
						相关文档:<%=wfreqlog.getSignDocHtmls() %>
					</div>
					<%} %>
					<%-- 相关流程 --%>
					<%
					if (wfreqlog.getSignWorkFlowHtmls() != null && !"".equals(wfreqlog.getSignWorkFlowHtmls())) {
					%>
					<div class="signRow">
						相关请求:<%=wfreqlog.getSignWorkFlowHtmls() %>
					</div>
					<%} %>
					<%-- 相关附件 --%>
					<%
					if (wfreqlog.getAnnexDocHtmls() != null && !"".equals(wfreqlog.getAnnexDocHtmls())) {
 					%>
					<div class="signRow">
						相关附件:<%=wfreqlog.getAnnexDocHtmls() %>
					</div>
					<%} %>
				</div>
			<%} %>
			<%
				if (workflowsigncnt >= 5) {
			%>
				<div id="workflowsignmore" class="operationBt" style="font-size:12px;height:20px;line-height:20px;float:right;margin-right:10px;margin-top:10px;" onclick="javascript:doexpand();"><span id="moresigninfotext">更多</div>
				<div id="cleaboth" style="clear:both;"></div>
			<%
				}
			%>
		</div>
		<%} %>
		<div style="height:10px;overflow:hidden;"></div>
			<%
			if ((workflowRequestInfo.getSubmitButtonName() != null && workflowRequestInfo.getSubmitButtonName() != "")
					||(workflowRequestInfo.getSubnobackButtonName()!=null&&workflowRequestInfo.getSubnobackButtonName()!="")
					||(workflowRequestInfo.getSubbackButtonName()!=null&&workflowRequestInfo.getSubbackButtonName()!="")
					||(workflowRequestInfo.getForwardButtonName()!=null&&workflowRequestInfo.getForwardButtonName()!="")) {
			%>
			<div class="blockHead">
				<span class="m-l-14">
					流程处理
				</span>
			</div>
			<div class="tblBlock" style="width:100%;background:#fff;">
				<%} %>
			
			<table id="head" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;word-break:break-all" >
			<input type=hidden name="module2" value="<%=module %>">
			<input type=hidden name="scope2" value="<%=scope %>">
			<input type=hidden name="page.pageNo" value="1">
			<input type=hidden name="requestid" value="<%=requestid %>">
			<input type=hidden name="workflowid" value="<%=workflowid %>">
			<input type="hidden" name="workflowsignid" value='<%=workflowsignid %>'/>
			<%
			if ((workflowRequestInfo.getSubmitButtonName() != null && !workflowRequestInfo.getSubmitButtonName().equals(""))
					||(workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals(""))
					||(workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals(""))
					||(workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals(""))) {
			%>
			<tr><td>
				<table style="width:100%;">
					<tr>
						<td colspan="2" style="padding:10px 10px 0 10px;">
							<%
							if (workflowRequestInfo.getWorkflowPhrases() != null) {
							%>
							<select id="phrase" onchange="addToRemark2(this)">
								<option value="0" selected="selected">--常用批示语--</option>
								<%
								for (int i=0; i<workflowRequestInfo.getWorkflowPhrases().length; i++) {
								%>
								
									<option value="<%=workflowRequestInfo.getWorkflowPhrases()[i][1]%>"><%=workflowRequestInfo.getWorkflowPhrases()[i][0] %></option>
								<%} %>
							</select>
							<%} %>
						</td>
					</tr>
					<tr>
						<td style="white-space:normal;padding:10px 10px 0 10px;">
							<textarea id="userSignRemark" name="userSignRemark" cols="80" rows="3" style="width:100%;"></textarea>
						</td>
						<td>
						<%
						if (workflowRequestInfo.getMustInputRemark()) {
						%>
						<div id="userSignRemark_ismandspan" class="ismand">!</div>
						<%} %>
						</td>
					</tr>
				</table>
			</td></tr>
			<tr width="100%">
				<td colspan="1" style="height:0px;border-top:1px solid #CFD3D8;width:100%;"></td>
			</tr>
			<%} %>
			<%
			if (workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) {
			%>
			<tr><td>
				<table style="width:100%;">
					<tr>
						<td class="tablefieldname" style="width:75px;text-align:right;font-size:12px;color:#666666;height:25px;">转发接收人:</td>
						<td width="40px;" onclick="javascript:showDialog('/mobile/plugin/dialog.jsp', '&returnIdField=forwardresourceids&returnShowField=forwardresources&method=listBrowser&browserId=402881e70bc70ed1010bc75e0361000f&isMuti=1&requestid=<%=requestid %>&nodeid=<%=workflowRequestInfo.getCurrentNodeId() %>');">
							<a href="#" data-rel="dialog"></a>
							<div style="background-image:url(/mobile/images/search_icon.png);height:30px;width:30px;"></div>
							<input type="hidden" id="forwardresourceids" name="forwardresourceids"/>
						</td>
						<td id="forwardresources" class="tablefieldvalue" jsfn="1"></td>
					</tr>
				</table>
				
			</td></tr>
			<tr width="100%">
				<td colspan="1" style="height:10px;border-top:1px solid #CFD3D8;width:100%;"></td>
			</tr>
			<%} %>
			</table>
		
			<%
			if (workflowRequestInfo.getSubmitButtonName()!=null&&!workflowRequestInfo.getSubmitButtonName().equals("")) {
			%>
				<div class="operationBt " onclick="dosubmit(this);"><%=workflowRequestInfo.getSubmitButtonName() %></div>
			<%} %>
			<%
			if (workflowRequestInfo.getSubnobackButtonName()!=null&&!workflowRequestInfo.getSubnobackButtonName().equals("")) {
			%>
				<div class="operationBt " onclick="dosubnoback(this);"><%=workflowRequestInfo.getSubnobackButtonName()%></div>
			<%} %>
			<%
			if (workflowRequestInfo.getSubbackButtonName()!=null&&!workflowRequestInfo.getSubbackButtonName().equals("")) { 
			%>
				<div class="operationBt " onclick="dosave(this);"><%=workflowRequestInfo.getSubbackButtonName() %></div>
			<%
			}
			if (workflowRequestInfo.getRejectButtonName()!=null&&!workflowRequestInfo.getRejectButtonName().equals("")) { 
			%>
				<div class="operationBt " onclick="doreject(this);"><%=workflowRequestInfo.getRejectButtonName()%></div>
			<%
			}
			if (workflowRequestInfo.getForwardButtonName()!=null&&!workflowRequestInfo.getForwardButtonName().equals("")) { 
			%>
				<div class="operationBt " onclick="doforward(this);"><%=workflowRequestInfo.getForwardButtonName() %></div>
			<%} %>
			 <div style="clear:both;"></div>
			<div style="height:10px;overflow:hidden;"></div>
		</div>
		<div style="height:10px;overflow:hidden;"></div>
	</form>
</html>