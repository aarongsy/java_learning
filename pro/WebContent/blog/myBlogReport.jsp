<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogDao"%>
<%--<%@page import="weaver.general.GCONST"%>--%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<jsp:useBean id="appDao" class="com.eweaver.blog.AppDao"></jsp:useBean>
<%
  String userid=StringHelper.null2String(request.getParameter("userid")); //需要查看的微博(用户)id
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

<div style="width:100%;position: relative;" >
  <div align="center" id="reportTitle" style="margin-top: 8px;font-weight: bold;font-size: 15px;color: #123885;"><%=year+"-"+monthStr%> 我的报表</div><!-- 我的报表 -->
  <div style="margin-top: 3px;margin-bottom: 15px;">
         <div class="lavaLampHead" style="height: 29px">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>,'<%=monthStr%>','报表')"><%=i%>月</a></li><!-- 月 -->
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
    <div style="width:100%;overflow-x: auto;padding-bottom: 30px;">
		<div id="blogReportDiv"> 
		 
		</div>
		<div style="text-align: left;margin-top: 8px">
	          说明：<span style="margin-right: 8px"><img src="images/submit-no.png" align="absmiddle" style="margin-right: 5px" />未提交</span><!-- 说明  未提交-->
	          <span  style="margin-right: 8px"><img src="images/submit-ok.png" align="absmiddle" style="margin-right: 5px" />已提交</span><!-- 已提交 -->
	          <%if(appDao.getAppVoByType("mood").isActive()){ %>
		          <span  style="margin-right: 8px"><img src="images/mood-unhappy.png" align="absmiddle" width="16px" style="margin-right: 5px" />不高兴</span><!--不高兴-->
		          <span  style="margin-right: 8px"><img src="images/mood-happy.png" align="absmiddle" width="16px" style="margin-right: 5px" />高兴</span><!-- 高兴-->
	          <%}else{%>
	          <%}%>
		       <%if(isSignInOrSignOut.equals("1")){ %> 
			      <span style="margin-right: 8px;"><img src="images/sign-absent.png" width="18px" w align="absmiddle" style="margin-right: 5px" />旷工</span><!-- 旷工 -->
			      <span style="margin-right: 8px;"><img src="images/sign-no.png" align="absmiddle" width="18px"  style="margin-right: 5px" />迟到</span><!-- 迟到 -->
			      <span style="margin-right: 8px;"><img src="images/sign-ok.png" align="absmiddle" width="18px" style="margin-right: 5px" />正常</span><!-- 正常 -->
		       <%} %>
	     </div>  
	</div>
</div>		
<script type="text/javascript">
  jQuery(document).ready(function(){ 
     displayLoading(1,'page');  
     jQuery.post("myReportRecord.jsp?userid=<%=userid%>&year=<%=year%>&month=<%=month%>&isSignInOrSignOut=<%=isSignInOrSignOut%>",function(data){
        jQuery("#blogReportDiv").html(data);
        displayLoading(0);  
     });
     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
  });
  
  function changeMonth(year,month,monthstr,title){
     displayLoading(1,'data');  
     jQuery("#blogReportDiv").load("myReportRecord.jsp?userid=<%=userid%>&isSignInOrSignOut=<%=isSignInOrSignOut%>&year="+year+"&month="+month,function(){
     displayLoading(0); 
    });
    jQuery("#reportTitle").html(year+"-"+monthstr+" "+title);
  }
 
  function changeYear(){
    var year=jQuery("#yearSelect").val();
    jQuery.post("myBlogReport.jsp?from=other&userid=<%=userid%>&year="+year,function(a){
       jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
    });
    jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
  }   
</script>	
