<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogDao"%>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%> 
<%@ include file="/blog/bloginit.jsp" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<jsp:useBean id="appDao" class="com.eweaver.blog.AppDao"></jsp:useBean>
<html>
<head>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<script type='text/javascript' src='js/blogUtil.js'></script>
<LINK href="/ecology/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDrag.js"></script>
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
  String isSignInOrSignOut="";//StringHelper.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能
%>
<body>
<%--<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>
<div style="width:100%;" >
  <div align="center" id="reportTitle" style="margin-top: 8px;font-weight: bold;font-size: 15px;color: #123885;display: <%=!"other".equals(from)?"block":"none"%>"><%=year+"-"+monthStr%> 我的报表</div><!-- 我的报表 -->
  <div style="margin-top: 3px;margin-bottom: 15px">
         <div class="lavaLampHead">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>,'<%=monthStr%>','我的报表')"><%=i%>月</a></li><!-- 月 -->
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
	<div id="blogReportDiv"> 
	</div>
	<div style="margin-top: 8px;text-align: left;">
	   说明：
	       <span style="margin-right: 8px"><img src="images/submit-no.png" align="absmiddle" style="margin-right: 5px" />未提交</span>
	       <span  style="margin-right: 8px"><img src="images/submit-ok.png" align="absmiddle" style="margin-right: 5px" />已提交</span>
	       <%if(appDao.getAppVoByType("mood").isActive()) {%>
	       <span  style="margin-right: 8px"><img src="images/mood-unhappy.png" align="absmiddle" width="16px" style="margin-right: 5px" />不高兴</span>
	       <span  style="margin-right: 8px"><img src="images/mood-happy.png" align="absmiddle" width="16px" style="margin-right: 5px" />高兴</span>
	       <%} %>
	      <%if(isSignInOrSignOut.equals("1")){ %> 
	       <span style="margin-right: 8px;"><img src="images/sign-absent.png" width="18px" align="absmiddle"  style="margin-right: 5px" />旷工/span>
	       <span style="margin-right: 8px;"><img src="images/sign-no.png" width="18px" align="absmiddle"  style="margin-right: 5px" />迟到</span>
	       <span style="margin-right: 8px;"><img src="images/sign-ok.png" width="18px" align="absmiddle"  style="margin-right: 5px" />正常</span>
	      <%} %>  
	</div>
</div>		
<script type="text/javascript">
  jQuery(document).ready(function(){   
     window.parent.displayLoading(1,"data");
     jQuery("#blogReportDiv").load("myReportRecord.jsp?userid=<%=userid%>&year=<%=year%>&month=<%=month%>&isSignInOrSignOut=<%=isSignInOrSignOut%>",function(){
        window.parent.displayLoading(0);
     });
     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
  });
  
  function changeMonth(year,month,monthstr,title){
      window.parent.displayLoading(1,"data");
	  jQuery("#blogReportDiv").load("myReportRecord.jsp?userid=<%=userid%>&isSignInOrSignOut=<%=isSignInOrSignOut%>&year="+year+"&month="+month+"&nowDate="+(new Date()).getTime(),function(){
	       window.parent.displayLoading(0);
	  });
	  jQuery("#reportTitle").html(year+"-"+monthstr+" "+title);
  }
  
  function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="myReport.jsp?year="+year;
  } 
</script>	
</body>
</html>