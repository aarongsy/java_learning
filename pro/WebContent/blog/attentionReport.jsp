<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/blog/bloginit.jsp" %>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%@ include file="/blog/bloginit.jsp" %>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<jsp:useBean id="appDao" class="com.eweaver.blog.AppDao"></jsp:useBean>
<html>
<head>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<LINK href="/ecology/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<script type='text/javascript' src='js/blogUtil.js'></script>
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDrag.js"></script>
<script type='text/javascript' src='/js/main.js'></script>
</head>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String userid=""+user.getId();
String from=StringHelper.null2String(request.getParameter("from"));
String type=StringHelper.null2String(request.getParameter("type"));

Calendar calendar=Calendar.getInstance();
int currentMonth=calendar.get(Calendar.MONTH)+1;
int currentYear=calendar.get(Calendar.YEAR);

int year=NumberHelper.getIntegerValue(request.getParameter("year"),currentYear).intValue();

BlogDao blogDao=new BlogDao();
Map monthMap=blogDao.getCompaerMonth(year);
int startMonth=((Integer)monthMap.get("startMonth")).intValue();   //开始月份
int endMonth=((Integer)monthMap.get("endMonth")).intValue();       //结束月份

Map enbaleDate=blogDao.getEnableDate();
int enableYear=((Integer)enbaleDate.get("year")).intValue();      //微博开始使用年

int month=NumberHelper.getIntegerValue(request.getParameter("month"),endMonth).intValue();
String monthStr=month<10?("0"+month):(""+month);

BlogManager blogManager=new BlogManager(user);
List attentionList=blogManager.getMyAttention(userid);

%>
<body>
<div id="divTopMenu"></div>
<%--<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
<%--   <%--%>
<%--     RCMenu += "{对比,javascript:doCompare(),_self} ";--%>
<%--	 RCMenuHeight += RCMenuHeightStep ;--%>
<%--   %>--%>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>
<%if(attentionList.size()>0){ %>
<div style="width:100%;">
  <div align="center" id="reportTitle" class="reportTitle" style="display: <%=!"other".equals(from)?"block":"none"%>"><%=year+"-"+monthStr%>关注报表</div><!-- 关注报表 -->
  <div style="margin-top: 3px;margin-bottom: 15px">
       <div class="lavaLampHead">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>,'<%=monthStr%>','关注报表')"><%=i%>月</a></li><!-- 月 -->
					  <%}%>
					</ul>
			  </div>	
			  <div class="report_yearselect" align="right">
			     <select class="yearSelect" id="yearSelect" onchange="changeYear()">
			         <%
					   for(int i=currentYear;i>=enableYear;i--){ 
					 %>
					   <option value="<%=i%>" <%=i==year?"selected='selected'":""%>><%=i%>年</option><!-- 年 -->
				    <%} %>
			     </select>
			  </div>	
         </div>
    </div>
    
	<div align="left" style="margin-top: 8px">
	  <div style="float: left;" class="reportTab">
	  <!-- 报表类型 -->
		  报表类型：
		  <a href="#" onclick="changeReport(this,'blog')" style="margin-right: 8px;" class="items">微博报表</a><!-- 微博报表 -->
		  <%if(appDao.getAppVoByType("mood").isActive()){ %>
		  <a href="#" onclick="changeReport(this,'mood')" style="margin-right: 8px;">心情报表</a><!-- 心情报表 -->
		  <%} %>
	  </div>
	  <div style="float: right;">
	     <div class="remarkDiv" style="text-align: left;" id="blogRemarks">
	         <span style="margin-right: 8px"><img src="images/submit-no.png" align="absmiddle" width="16px" style="margin-right: 5px" />未提交</span>
	         <span  style="margin-right: 8px"><img src="images/submit-ok.png" align="absmiddle" width="16px" style="margin-right: 5px" />已提交</span>
	         <span  style="margin-right: 8px">"总计"格式为"<font color="red">未提交总数</font>/应提交总数"</span>  
	     </div>
	    <div class="remarkDiv" style="text-align: left;display: none;" id="moodRemarks">
	          <span  style="margin-right: 8px"><img src="images/mood-unhappy.png" align="absmiddle" width="16px" style="margin-right: 5px" />不高兴</span>
	          <span  style="margin-right: 8px"><img src="images/mood-happy.png" align="absmiddle" width="16px" style="margin-right: 5px" />高兴</span>
	          <span  style="margin-right: 8px">"总计"格式为"<font color="red">不高兴总天数</font>/总天数"</span>
	    </div>
	  </div>
	</div>
    
    <div id="reportDiv">
    
    </div>
    <br>
    <br>
</div>
<%}else
	out.println("<div class='norecord'>当前没有被关注的人</div>");	//当前没有被关注的人
%>	
<script type="text/javascript">
   var type="blog";
   jQuery(document).ready(function(){
    if(<%=attentionList.size()%>>0) {  
	     window.parent.displayLoading(1,"data");
	     jQuery("#reportDiv").load("attentionReportRecord.jsp?year=<%=year%>&month=<%=month%>&type=blog&nowtime="+(new Date()).getTime(),function(){
	        window.parent.displayLoading(0);
	     });
	     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
     }else
        window.parent.displayLoading(0); 
  });
  
   function selectBox(obj){
    if(jQuery(obj).attr("checked")){
       jQuery(".condition").attr("checked",true);
    }else{
       jQuery(".condition").attr("checked",false);
    }
  }
  
 function changeMonth(year,month,monthstr,title){
    window.parent.displayLoading(1,"data");
    jQuery("#reportDiv").load("attentionReportRecord.jsp?year="+year+"&month="+month+"&type="+type,function(){
       window.parent.displayLoading(0);
    });
    jQuery("#reportTitle").html(year+"-"+monthstr+" "+title);
    
    compareYear=year;
    compareMonth=month;
  }
  
  function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="attentionReport.jsp?year="+year;
  } 
  
  function changeReport(obj,typeTemp){
	type=typeTemp;
	window.parent.displayLoading(1,"data");
	jQuery("#reportDiv").load("attentionReportRecord.jsp?year="+compareYear+"&month="+compareMonth+"&type="+type+"",function(){
	   window.parent.displayLoading(0);
	});
	   jQuery(".reportTab a").removeClass("items");
	   jQuery(obj).addClass("items");
	   jQuery(".reportDiv").hide();
	   jQuery("#"+type+"ReportDiv").show();
	   jQuery(".remarkDiv").hide();
	   jQuery("#"+type+"Remarks").show();
  }
  var compareYear=<%=year%>;
  var compareMonth=<%=month%>;
  
  function compareChart(reportdiv,title,charType){
   var conType="";    
   var conValue="";
   var conditions=jQuery("#"+reportdiv).find(".condition:checked"); 
   if(conditions.length==0){
      alert("对不起，请选择人员！"); //对不起，请选择人员!
      return ;
   }
   conditions.each(function(){
      conType=conType+","+jQuery(this).attr("conType");
      conValue=conValue+","+jQuery(this).attr("conValue");
   });
   conType=conType.substr(1);
   conValue=conValue.substr(1);
   
    var diag = new Dialog();
    diag.Modal = true;
    diag.Drag=false;
	diag.Width = 680;
	diag.Height = 425;
	diag.ShowButtonRow=false;
	diag.Title =title;
	diag.URL = "compareChart.jsp?title="+title+"&conValue="+conValue+"&conType="+conType+"&year="+compareYear+"&month="+compareMonth+"&chartType="+charType;
    diag.show();
  }

//对比
function doCompare(){
   jQuery("#compareBtn").click();
}
  
</script>	
</body>
</html>