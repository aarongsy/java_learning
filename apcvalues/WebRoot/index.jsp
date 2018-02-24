<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/SelPageServlet"></jsp:include>
<!DOCTYPE HTML>
<html lang="zh-CN">
<head>
<title>PIMS桶槽信息V1.3</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!-- Bootstrap的UI框架基础样式 -->
<link rel="stylesheet" href="css/bootstrap.min.css?version=20171207" type="text/css">
<!-- 可选的 Bootstrap 主题文件（一般不用引入） -->
<link href="css/bootstrap-theme.min.css?version=20171207" rel="stylesheet">
<!-- 插件使用了部分font-awesome的图标，所以需要引入该样式 -->
<link rel="stylesheet" href="font-awesome/css/font-awesome.min.css?version=20171207" type="text/css">
<!-- Bootstrap3使用 -->
<link rel="stylesheet" href="css/selectpage.bootstrap3.css?version=20171207" type="text/css">
<!-- 时间选择器控件样式 -->
<link rel="stylesheet" href="css/bootstrap-datetimepicker.min.css?version=20171207" type="text/css">
<!-- Bootstrap3使用 -->
<link rel="stylesheet" href="css/b.page.bootstrap3.css?version=20171207" type="text/css">
<style type="text/css">
* {
	color : #8B4500;
}
.dt_container {
    border: none;
    margin: 0;
    padding: 0;
    display: inline-block;
    position: relative;
    vertical-align: middle;
}
.dt_clear_btn {
    position: absolute;
    top: 0;
    right: 8;
    display: none;
    width: auto;
    height: 100%;
    cursor: pointer;
    font-size: 20px;
    color: #666666;
    margin: 0px;
    padding: 7px 0px 0px 0px;
    box-sizing: border-box;
    line-height: 1;
    font-family: "Helvetica Neue Light", "HelveticaNeue-Light", "Helvetica Neue", Calibri, Helvetica, Arial;
}
.dt_input {
    background-color: white;
    border: 1px solid #ccc;
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
    box-shadow: 0px 1px 1px rgba(0,0,0,0.075) inset;
    -moz-box-shadow: 0px 1px 1px rgba(0,0,0,0.075) inset;
    -webkit-box-shadow: 0px 1px 1px rgba(0,0,0,0.075) inset;
    margin: 0px !important;
    /* width: 320px; */
    font-size: 14px;
    height: 34px;
    line-height: 34px;
    min-height: 34px;
    padding: 4px 6px;
    vertical-align: middle;
    display: block;
    width: 100%;
    outline: none;
    box-sizing: border-box;
}
table,th {
text-align : center;
}
.btn-mine{ 
	background-color: #fff;
	color: #8B4500;
	border-color: #8B4500;
}
td.danger{
	background-color: #d9534f !important;
	color: #fff;
}
</style>
<script type="text/javascript" src="js/jquery.min.js?version=20171207"></script>
<script type="text/javascript" src="js/bootstrap.min.js?version=20171207"></script>
<!-- 插件核心脚本 -->
<script type="text/javascript" src="js/selectpage.min.js?version=20171207" ></script>
<script type="text/javascript" src="js/bootstrap-datetimepicker.min.js?version=20171207"></script>
<script type="text/javascript" src="js/bootstrap-datetimepicker.zh-CN.js?version=20171207"></script>
<script type="text/javascript" src="js/b.page.min.js?version=20171207"></script>
<script type="text/javascript">
function alertView(){
	var trs = jQuery("td.danger").parent("tr").clone();
	if(trs&&trs.length>0){
		if(!sessionStorage){
			alert("浏览器版本过低，无法看到弹窗内容！");
		}else{
			window.sessionStorage.setItem("key",jQuery("<tbody>").html(trs).html());
			window.open("<c:url value="/alertView.html"></c:url>","_blank","height=500,width=665,top=240,left=300,toolbar=0,menubar=0,scrollbars=1,resizable=0,location=0,status=0");
		}
	}
	trs = null;
	return;
}
function addHtml(tb,tank,arr){
	var tnum = tank.tanknum;
	var theig = tank.tankheig;
	var ttemp = tank.tanktemp;
	var tpi = tank.tankpi;
    var tweig = tank.tankweig;
    
    var tr = jQuery("<tr>");

    if(!!!arr[tnum]){
        tr.append('<td class="warning">'+tnum+'</td>');
        tr.append('<td class="info">请维护此罐号的部门及警报值</td>');
        tr.append('<td class="warning">'+tank.material+'</td>');
        tr.append('<td class="warning">'+theig+'</td>');
        tr.append('<td class="warning">'+ttemp+'</td>');
        tr.append('<td class="warning">'+tpi+'</td>');
        tr.append('<td class="warning">'+tweig+'</td>');
        tr.append('<td class="warning">'+tank.tanktime+'</td>');
        tb.append(tr);
        return;
    }

    var gd = arr[tnum]['gd']-0;
    var wd = arr[tnum]['wd']-0;
    var yl = arr[tnum]['yl']-0;
    var bm = arr[tnum]['bm'];
    
	tr.append('<td>'+tnum+'</td>');
    
	tr.append('<td>'+bm+'</td>');		

    tr.append('<td>'+tank.material+'</td>');
    
    if(theig>gd){
    	tr.append("<td class='danger'>"+theig+"</td>");
    }else{
    	tr.append("<td>"+theig+"</td>");
    }
    
    if(!$.isNumeric(ttemp)||!(ttemp>wd)){
    	tr.append("<td>"+ttemp+"</td>");
    }else{
    	tr.append("<td class='danger'>"+ttemp+"</td>");
    }
    
    if(!$.isNumeric(tpi)||!(tpi>yl)){
    	tr.append("<td>"+tpi+"</td>");
    }else{
    	tr.append("<td class='danger'>"+tpi+"</td>");
    }
    
    if(!$.isNumeric(tweig)||!(theig>gd)){
    	tr.append("<td>"+tweig+"</td>");
    }else{
    	tr.append("<td class='danger'>"+tweig+"</td>");
    }
  
    tr.append('<td>'+tank.tanktime+'</td>');
    tb.append(tr);
}
$(function(){
	//定义数组，在服务端返回的数据也以该格式返回：Array[{Object},{...}]
	var tag_data = ${requestScope.tagData };
	//初始化选择框插件
	$('#selectPage').selectPage({
		showField : 'name',
		keyField : 'id',
		data : tag_data
	});
	//初始化时间组件
	$('.form_datetime').datetimepicker({
        language:  'zh-CN',
        format: 'yyyy-mm-dd hh:ii:ss',
        weekStart: 1,
        todayBtn:  1,
		autoclose: 1,
		todayHighlight: 1,
		forceParse: 1,
        showMeridian: 1,
        pickerPosition: "bottom-left"
    });
	$(".dt_input").on('change',function(){
		if($(this).val()!='')$(this).next(".dt_clear_btn").show();
		else $(this).next(".dt_clear_btn").hide();
	});
	$(".dt_clear_btn").on("click",function(){
		$(this).hide().prev(".dt_input").val("");
	});
	//分页初始化
	$('#page3').bPage({
	    url : '<c:url value="/BPageServlet"></c:url>',
	    //开启异步处理模式
	    asyncLoad : true,
	    //关闭服务端页面模式
	    serverSidePage : false,
	    //数据自定义填充
	    pageBarSize : 9,
	    pageSize : 70,
	    pageSizeMenu : [70,100],
	    render : function(data){
	        var tb = $('#bPage tbody');
	        tb.empty();
	        if(data && data.list && data.list.length > 0){
	        	var arr = {"TK-1336":{"gd":475,"wd":40,"yl":"N/A","bm":"RES"},"TK-05":{"gd":680,"wd":40,"yl":1,"bm":"RES"},"TK-08":{"gd":6800,"wd":40,"yl":1,"bm":"RES"},"T-0906A":{"gd":828,"wd":40,"yl":"N/A","bm":"LER"},"T-0906B":{"gd":8280,"wd":40,"yl":"N/A","bm":"LER"},"T-0907A":{"gd":8280,"wd":40,"yl":"N/A","bm":"LER"},"T-0907B":{"gd":10997.1,"wd":40,"yl":"N/A","bm":"LER"},"T-0907C":{"gd":10997.1,"wd":40,"yl":"N/A","bm":"LER"},"T-0902":{"gd":10997.1,"wd":40,"yl":"N/A","bm":"LER"},"T-0903":{"gd":10997.1,"wd":40,"yl":"N/A","bm":"LER"},"TK-1604A":{"gd":5081.3,"wd":40,"yl":1,"bm":"PFR"},"TK-1604B":{"gd":5038.8,"wd":40,"yl":1,"bm":"PFR"},"TK-0002":{"gd":6439.6,"wd":80,"yl":1,"bm":"PFR"},"ST-4250":{"gd":13965,"wd":40,"yl":"N/A","bm":"PVA"},"ST-2302":{"gd":12600,"wd":40,"yl":"N/A","bm":"PVA"},"ST-3001":{"gd":13090,"wd":40,"yl":"N/A","bm":"PVA"},"ST-3003":{"gd":13090,"wd":40,"yl":1.5,"bm":"PVA"},"ST-4601":{"gd":13090,"wd":40,"yl":"N/A","bm":"PVA"},"ST-401B":{"gd":6750,"wd":40,"yl":"N/A","bm":"PVA"},"ST-402A":{"gd":6750,"wd":40,"yl":"N/A","bm":"PVA"},"ST-402B":{"gd":6750,"wd":40,"yl":"N/A","bm":"PVA"},"ST-401A":{"gd":6300,"wd":40,"yl":"N/A","bm":"PVA"},"ST-402C":{"gd":6300,"wd":40,"yl":"N/A","bm":"PVA"},"TK800":{"gd":5566.65,"wd":40,"yl":0,"bm":"PBT"},"TK801":{"gd":5566.65,"wd":40,"yl":1.5,"bm":"PBT"},"TK-011A":{"gd":17017.2,"wd":40,"yl":2.7,"bm":"PN"},"TK-011B":{"gd":17017.2,"wd":40,"yl":2.7,"bm":"PN"},"TK-011C":{"gd":17017.2,"wd":40,"yl":2.7,"bm":"PN"},"TK-011D":{"gd":17017.2,"wd":40,"yl":2.7,"bm":"PN"},"TK-041A":{"gd":16575,"wd":40,"yl":2.7,"bm":"PN"},"TK-041B":{"gd":16575,"wd":40,"yl":2.7,"bm":"PN"},"TK-041C":{"gd":12920,"wd":40,"yl":2.7,"bm":"PN"},"TK-527A":{"gd":5380.5,"wd":40,"yl":2.7,"bm":"PN"},"TK-527B":{"gd":5380.5,"wd":40,"yl":2.7,"bm":"PN"},"TK-031A":{"gd":16660,"wd":70,"yl":3.7,"bm":"PN"},"TK-031B":{"gd":16660,"wd":70,"yl":3.7,"bm":"PN"},"TK-031C":{"gd":12835,"wd":70,"yl":3.7,"bm":"PN"},"TK-577A":{"gd":6502.5,"wd":70,"yl":2.7,"bm":"PN"},"TK-577B":{"gd":6502.5,"wd":70,"yl":2.7,"bm":"PN"},"TK-111":{"gd":18317.5,"wd":40,"yl":2,"bm":"第四桶区"},"TK-117":{"gd":18317.5,"wd":40,"yl":2,"bm":"第四桶区"},"ST-03":{"gd":13950,"wd":40,"yl":2,"bm":"第二桶区"},"ST-04":{"gd":13950,"wd":40,"yl":2,"bm":"第二桶区"},"V-4381A":{"gd":1980,"wd":40,"yl":1,"bm":"AO"},"V-4381B":{"gd":1980,"wd":40,"yl":"N/A","bm":"AO"},"V-4342":{"gd":3862.29,"wd":76,"yl":"N/A","bm":"AO"},"V-4341D1":{"gd":5347.5,"wd":76,"yl":"N/A","bm":"AO"},"V-4341D2":{"gd":5347.5,"wd":76,"yl":"N/A","bm":"AO"},"VE-217":{"gd":3720,"wd":40,"yl":"N/A","bm":"AO"},"TA-010C":{"gd":2604,"wd":40,"yl":"N/A","bm":"FP"},"TA-960":{"gd":2927.4,"wd":40,"yl":"N/A","bm":"SP"},"TA-030A":{"gd":4250,"wd":40,"yl":"N/A","bm":"SP"},"TA-030B":{"gd":4250,"wd":40,"yl":"N/A","bm":"SP"},"TA-060":{"gd":3910,"wd":40,"yl":"N/A","bm":"SP"},"TA-070":{"gd":2927.4,"wd":40,"yl":"N/A","bm":"SP"},"TA-930":{"gd":2762.5,"wd":40,"yl":"N/A","bm":"SP"},"TA-950":{"gd":2762.5,"wd":40,"yl":"N/A","bm":"SP"},"TA-020(FP)":{"gd":7486.5,"wd":40,"yl":"N/A","bm":"FP"},"TA-010A(FP)":{"gd":2604,"wd":40,"yl":"N/A","bm":"FP"},"TA-010B(FP)":{"gd":2604,"wd":40,"yl":"N/A","bm":"FP"},"TA-020(SP)":{"gd":2635,"wd":40,"yl":"N/A","bm":"SP"},"TA-010A(SP)":{"gd":2040,"wd":40,"yl":"N/A","bm":"SP"},"TA-010B(SP)":{"gd":2040,"wd":40,"yl":"N/A","bm":"SP"}};
	        	$.each(data.list,function(i,row){
	            	addHtml(tb,row,arr);
	            });             
	            alertView();
	        }else{
	        	tb.html("<tr><td colspan='7'>"+data.msg+"</td></tr>");
	        }
	    },
	    params : function(){
	        return {
	        	method : 'initBPage',
	        };
	    }
	});
	//校验时间
	$("#button").on("click",function(){
		var value1 = $("#dt_input1").val();
		var value2 = $("#dt_input2").val();
		var no = $("#selectPage").val();
		if(no==''){
			alert("请选择罐号！");
			return false;
		}
		if(value1==''||value2==''||Date.parse(value2)<=Date.parse(value1)){
			alert("请选择正确的时间段！");
			return false;
		}
		$("#page3").bPageRefresh({
			params : function(){
				return {
					method : "bPage",
					num : $("#selectPage").val(),
					startTime : $("#dt_input1").val(),
					endTime : $("#dt_input2").val()
				};
			}
		});
	});
	//隐藏fieldset
	$("legend").on("click",function(){
		$(this).next("div").slideToggle();
	});
	//定时器
	setInterval(function(){
		window.location.href = '<c:url value="/index.jsp"></c:url>';
	},1000*60*5);
});
</script>
</head>
<body>
<div class="container">
<div class="form-horizontal">
	<fieldset>
		<legend style="cursor:pointer"><span>PIMS桶槽信息查询</span></legend>
		<div>
		<div class="form-group">
			<!-- 设置文本框为插件基本元素 -->
			<label for="selectPage_text" class="col-md-1 control-label">罐号</label>
			<input type="text" id="selectPage">
		</div>
		<div class="form-group">
		<label for="dt" class="col-md-1 control-label">时间</label>
		<div class="dt_container" style="width:174px;">
			<input id="dt" class="form_datetime dt_input" type="text" data-link-field="dt_input1">
			<div class="dt_clear_btn" title="清除内容">×</div>
			<input type="hidden" class="dt_hidden" id="dt_input1" name="dtinput1">
		</div>
		<span>---</span>
		<div class="dt_container" style="width:174px;">
			<input class="form_datetime dt_input" type="text" data-link-field="dt_input2">
			<div class="dt_clear_btn" title="清除内容">×</div>
			<input type="hidden" class="dt_hidden" id="dt_input2" name="dtinput2">
		</div>
		<div class="btn-group">
		<button type="button" id="button" class="btn btn-mine">查询</button>
		</div>
		<div class="btn-group">
		<a href='<c:url value="/index.jsp"></c:url>' id="button1" class="btn btn-mine">实时数据</a>
		</div>
		<div class="btn-group">
		<button type="button" class="btn btn-mine" data-toggle="modal" data-target="#loginModal">后台维护</button>
		</div>
		</div>
		</div>
	</fieldset>
</div>
<!-- HTML代码、服务端内容填充 -->
<div>
<div>
    <!-- 定义表格框架 -->
    <table id="bPage" class="table table-striped table-bordered table-hover table-condensed">
        <thead>
            <tr>
                <%--<th class="selectColumn" >选择</th>--%>
                <th>罐号</th>
                <th>部门</th>
                <th>内容物</th>
                <th>液位高度</th>
                <th>温度</th>
                <th>压力</th>
                <th>重量</th>
                <th>时间</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<div id="page3">
</div>

</div>
</div>
<div id="loginModal" class="modal fade" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                	<button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                    <h3 class="modal-title text-center">登入后台维护中心</h3>
                </div>
                <div class="modal-body">
                    <form class="form-group">
                        <div class="form-group">
                            <input id="username" name="username" type="text" class="form-control input-lg" placeholder="账号">
                        </div>
                        <div class="form-group">
                            <input id="password" name="password" type="text" class="form-control input-lg" placeholder="密码">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button id="dl" class="btn btn-info btn-lg btn-block">登录</button>
                </div>
            </div>
        </div>
    </div>
    <div id="myModal" class="modal fade" data-backdrop="static">
    	<div class="modal-dialog modal-sm">
    		<div class="modal-content">
    			<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">×</button>
						<h4 class="modal-title">
							登录提示
						</h4>
				</div>
				<div class="modal-body">
					<p id="hello">
						账号或密码不正确，请重新输入！
					</p>
				</div>
				<div class="modal-footer">
					 <button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
				</div>
    		</div>
    	</div>
	</div>
    <script>
    	$("#dl").click(function(){
    		var user = $("#username").val();
    		var pw = $("#password").val();
    		
    		if(!!!sessionStorage){
    			$("#hello").text("浏览器版本过低，无法登录！");
    			$("#myModal").modal("show");
    		}else{
    			if(sessionStorage.getItem("mi")=="ccp1234"){
    				window.location.href = "main.html";
    				return;
    			}else{
    				sessionStorage.setItem(user,pw);
    			}
    			if(user=="mi"&&sessionStorage.getItem(user)=="ccp1234"){
    				sessionStorage.setItem(user,pw);
    				window.location.href = "main.html";
    				return;
    			}else{
    				sessionStorage.clear();
    				$("#myModal").modal("show");
    				return;
    			}
    		}
    	});
    </script>
</body>
</html>