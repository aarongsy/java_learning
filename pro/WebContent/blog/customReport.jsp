<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogDao"%>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%--<%@page import="weaver.conn.RecordSet"%>--%>
<%--<%@page import="weaver.hrm.company.SubCompanyComInfo"%>--%>
<%--<%@page import="weaver.hrm.company.DepartmentComInfo"%>--%>
<%@page import="com.eweaver.blog.WorkDayDao"%>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<jsp:useBean id="appDao" class="com.eweaver.blog.AppDao"></jsp:useBean>
<%@ include file="/blog/bloginit.jsp" %>

<head>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<LINK href="/ecology/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<script type='text/javascript' src='js/blogUtil.js'></script>
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/ecology/wui/theme/ecology7/jquery/js/zDrag.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/default/global.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/xtheme-gray.css"/>
<style>
 .name{padding-left: 33px}
 .conDiv{margin-top: 8px;height:30px;}
 .conDiv .conType{float: left;text-align: left}
 .conDiv .conType select{width:60px}
 .conDiv .operationdiv{float: right;}
 .conDiv .operationdiv .operationItem{margin-right: 8px;float: right}
 .conDiv .conLine{width:100%;;border-top:1px solid  #c2E2E7;line-height:1px;margin-top: 5px;float: left;}
</style>
</head>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String userid=""+user.getId();
String tempid=StringHelper.null2String(request.getParameter("tempid"));
String isnew=StringHelper.null2String(request.getParameter("isnew"));
double index=0.0;
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
String reportType=StringHelper.null2String(request.getParameter("reportType"));
if("".equals(reportType)){
	reportType="blog";
}
String monthStr=month<10?("0"+month):(""+month);

WorkDayDao dayDao=new WorkDayDao(user);
Map dayMap=dayDao.getStartAndEndOfMonth(year,month);
List totaldateList=(List)dayMap.get("totaldateList");
String startdate=(String)dayMap.get("startdate");
String enddate=(String)dayMap.get("enddate");

TreeMap workdayMap=dayDao.getWorkDaysMap(startdate, enddate);

//SubCompanyComInfo subCompanyComInfo=new SubCompanyComInfo();
//DepartmentComInfo departmentComInfo=new DepartmentComInfo();
BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

String tempName="自定义报表"; //自定义报表
String sql="select * from blog_reportTemp where id="+tempid;
//RecordSet recordSet=new RecordSet();
//recordSet.execute(sql);
List reportTempList = baseJdbcDao.executeSqlForList(sql);
if(reportTempList.size()>0){
	Map recordSet = (Map)reportTempList.get(0);
	tempName=StringHelper.null2String(recordSet.get("tempName"));
}
%>
<%
 String pagemenustr =  "addBtn(tb,'锁定','S','accept',function(){doLock()});";
 pagemenustr +=  "addBtn(tb,'编辑','S','accept',function(){doEdit()});";
 pagemenustr +=  "addBtn(tb,'对比','S','accept',function(){doCompare()});";
%>
<body>
 <div id="divTopMenu"></div>
<%-- <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
<%-- <% --%>
<%--   if(isnew.equals("true")){--%>
<%--	 RCMenu += "{锁定,javascript:doLock(),_self} ";--%>
<%--	 RCMenuHeight += RCMenuHeightStep ;  --%>
<%--   }else{	 --%>
<%--	 RCMenu += "{编辑,javascript:doEdit(),_self} ";--%>
<%--	 RCMenuHeight += RCMenuHeightStep ;--%>
<%--   }--%>
<%--  RCMenu += "{对比,javascript:doCompare(),_self} ";--%>
<%--  RCMenuHeight += RCMenuHeightStep ;--%>
<%-- %>--%>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>
<div id="pagemenubar"> </div>
<div style="width:100%;">
  <div align="center" id="reportTitle" style="margin-top: 8px;" >
    <span style="font-weight: bold;font-size: 15px;color: #123885;"><%=year+"-"+monthStr+" "%></span><span id="titleSpan" style="font-weight: bold;font-size: 15px;color: #123885;"><%=tempName%></span>  
    <input type="text" id="titleText" value="<%=tempName%>" style="display: none">
    <a href="#" id="editTitle" onclick="editTitle()" style="margin-left: 8px;display: <%=isnew.equals("true")?"":"none"%>">编辑</a><!-- 编辑 -->
    <a href="#" id="savaTitle" onclick="saveTitle()" style="margin-left: 8px;display: none">保存</a><!-- 保存 -->
  </div>
  <div style="margin-top: 3px;margin-bottom: 15px">
         <div class="lavaLampHead">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>)"><%=i%>月</a></li><!-- 月 -->
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
		  <a href="#" onclick="changeReport(this,'blog')" style="margin-right: 8px;<%="blog".endsWith(reportType)?"font-weight:bold;text-decoration:underline !important":"" %>">微博报表</a><!-- 微博报表 -->
		  <%if(appDao.getAppVoByType("mood").isActive()){ %>
		  <a href="#" onclick="changeReport(this,'mood')" style="margin-right: 8px;<%="mood".endsWith(reportType)?"font-weight:bold;text-decoration:underline !important":"" %>">心情报表</a><!-- 心情报表 -->
		  <%} %>
	  </div>
	  <div style="float: right;">
	  	<%if("blog".equals(reportType)) {%>
	     <div class="remarkDiv" style="text-align: left;" id="blogRemarks">
	         <span style="margin-right: 8px"><img src="images/submit-no.png" align="absmiddle" style="margin-right: 5px" />未提交</span>
	         <span  style="margin-right: 8px"><img src="images/submit-ok.png" align="absmiddle" style="margin-right: 5px" />已提交</span>
	         <span  style="margin-right: 8px">"总计"格式为"<font color="red">未提交总数</font>/应提交总数"</span>  
	     </div>
	     <%} if("mood".equals(reportType)) {%>
	    <div class="remarkDiv" style="text-align: left;" id="moodRemarks">
	          <span  style="margin-right: 8px"><img src="images/mood-unhappy.png" align="absmiddle" width="16px" style="margin-right: 5px" />不高兴</span>
	          <span  style="margin-right: 8px"><img src="images/mood-happy.png" align="absmiddle" width="16px" style="margin-right: 5px" />高兴</span>
	          <span  style="margin-right: 8px">"总计"格式为"<font color="red">不高兴总天数</font>/总天数"</span>
	    </div>
	    <%} %>
	 
	  </div>
	</div>
    <%
     List conditionList=reportManager.getConditionList(tempid);
    %>
    <div id="blogReportDiv" style="overflow-x:auto;width: 100%">
     <%if(conditionList.size()>0){%>
      <table id="blogReportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	    <tr style="background: url('images/report-head-bg.png');background-repeat: repeat-x;" height="20px">
		    <td style="width:120px" class="tdWidth" nowrap="nowrap">
			    <div style="float: left;">
	             <input type="checkbox"  onclick="selectBox(this)" title="全选"/>  <!-- 全选 -->
	            </div>
		        <div style="float: left;">
				   <a class="btnEcology" id="compareBtn"  href="javascript:void(0)" onclick="compareChart('blogReportList','<%=reportType %>')">
					 <div class="left" style="width:45px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span>对比</span></div><!-- 对比 -->
					 <div class="right"> &nbsp;</div>
				   </a>
			    </div>
		    </td><!-- 对比 -->
		    <%
		      for(int i=0;i<totaldateList.size();i++){
		    	  int day=((Integer)totaldateList.get(i)).intValue();
		    	 
		    	  boolean isWorkday=false;
		    	  Object object=workdayMap.get(year+"-"+(month<10?("0"+month):""+month)+"-"+(day<10?("0"+day):""+day));
		    	  if(object!=null){
		    	     isWorkday=((Boolean)object).booleanValue();
		    	  if(isWorkday){   
		    %>
		      <td class="tdWidth" nowrap="nowrap"><%=day%></td>
		    <%}}else{%>
		      <td class="tdWidth" nowrap="nowrap"><%=day%></td>	
		    <%}}%>
		    <td style="width: 5%" align="center">
		      <%if("blog".equals(reportType))
			    out.println("工作指数");
		       else
		    	out.println("心情指数");
		      %>
		    </td><!-- 工作指数 -->
	    </tr>
    <%
     for(int j=0;j<conditionList.size();j++){
    	Map comditionMap=(Map)conditionList.get(j); 
    	 
        String id=(String)comditionMap.get("id");
        String type=(String)comditionMap.get("type");
        String content=(String)comditionMap.get("content");
    %>
    <%
    if(type.equals("1")){
    	//查看人员状态，非正常状态人员不显示在自定义报表中
    	String status=StringHelper.null2String(humresService.getHumresById(content).getHrstatus());
    	if(status.equals("4028804c16acfbc00116ccba13802935"))
    	   continue;	
    	if("blog".equals(reportType)){
			 Map resultMap=reportManager.getBlogReportByUser(content,year,month); 
			 List reportList=(List)resultMap.get("reportList");
			 int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
			 int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
			 double workIndex=((Double)resultMap.get("workIndex")).doubleValue();        //工作指数 
   %>
	<tr class="item<%=id%>">
	    <td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><%=humresService.getHrmresNameById(content)%></a><img src="images/delete.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    %>
	     <%if(isWorkday){%>
		    <td align="center">
		       <%if(isSubmited){%>
		        <div><img src="images/submit-ok.png" /></div>
		       <%}else{ %>
		        <div><img src="images/submit-no.png" /></div> 
		       <%} %> 
		    </td>
		  <%}else{%>
	    <%}}else{%>
	       <td >&nbsp;</td>
	    <%}
	    }%>
	    <td><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday%>天"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=content%>',<%=year%>,<%=type%>,'微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
 <%}else{
	 Map resultMap=reportManager.getMoodReportByUser(content,year,month); 
	  
	 List reportList=(List)resultMap.get("reportList");
	 int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
	 int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
	 double moodIndex=((Double)resultMap.get("moodIndex")).doubleValue();        //工作指数 
	 int happyDays=((Integer)resultMap.get("happyDays")).intValue();
	 int unHappyDays=((Integer)resultMap.get("unHappyDays")).intValue();
 %>
	 <tr class="item<%=id%>">
	    <td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><%=humresService.getHrmresNameById(content)%></a><img src="images/delete.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%
	    	for(int i=0;i<totaldateList.size();i++){
	    		    	 if(i<reportList.size()){
	    		    		
	    		    		 Map map=(Map)reportList.get(i);
		    		    	 boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
		    		         String faceImg=(String)map.get("faceImg");
	    		  %> 
	    		       <%if(isWorkday){%>
	    			    <td align="center">
	    			       <%if("".equals(faceImg)){%>
	    			        &nbsp;
	    			       <%}else{ %>
	    			        <div><img src="<%=faceImg %>" /></div> 
	    			       <%} %> 
	    			    </td>
	    			  <%}else{%>
	    		  <%}}else{%>
	    		        <td >&nbsp;</td>
	    		 <%}}%>

	     <td><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><span title="不高兴<%=unHappyDays%>天高兴<%=happyDays%>天"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=content%>',<%=year%>,<%=type%>,'心情报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
     </tr>
	 <%
 }
    	}else if(type.equals("2")||type.equals("3")){
  	
	  if("blog".equals(reportType)){
		  Map resultMap= reportManager.getOrgReportCount(userid,content,type,year,month); 
	  	  if(resultMap==null) continue;
		  List resultCountList=(List)resultMap.get("resultCountList");
		  List isWorkdayList=(List)resultMap.get("isWorkdayList");
		  int totalAttention=((Integer)resultMap.get("totalAttention")).intValue();
		  int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();
		  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();
		  double workIndex=((Double)resultMap.get("workIndex")).doubleValue();
		  String orgName=orgunitService.getOrgunitName(content);
 %>
	<tr class="item">
	    <td align="left"><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><span style="cursor: pointer;" onclick="extendRecord(this,'<%=content%>',<%=type%>,<%=year%>,<%=month %>,<%=id%>,'<%=reportType %>')" extend="false" isLoad='false'><img src="images/extend.png" /><%=orgName%></span><img src="images/delete.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unsubmit=((Integer)resultCountList.get(i)).intValue();
	        	if(isWorkday){
	    %>
	            <td align="center" style="width: 18px;"><span style="color:red"><%=unsubmit%></span>/<%=totalAttention%></td>
	    <%   		
	        	}else{
	    %>
	    <%    		
	        	}
	        }else{
	    %>
	            <td>&nbsp;</td>
	    <%    	
	        }
	    } %>
	    <td>
	    	<% 
	    	
	    			index=workIndex;
	    		
	    	%>
	    	<span title="未提交<%=totalUnsubmit%>天应提交<%=totalWorkday*totalAttention%>天"><%=reportManager.getReportIndexStar(index)%></span><%=index%><a href="javascript:openChart('<%=reportType %>','<%=content%>',<%=year%>,<%=type%>,'微博报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
	
  <%}
	  else{
		  Map resultMap= reportManager.getOrgMoodReportCount(userid,content,type,year,month);  
	  	  if(resultMap==null) continue;
		  List resultCountList=(List)resultMap.get("resultCountList");
		  List isWorkdayList=(List)resultMap.get("isWorkdayList");
		  String orgName=orgunitService.getOrgunitName(content);
		  
		  %>
		  <tr class="item">
	    <td align="left"><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><span style="cursor: pointer;" onclick="extendRecord(this,'<%=content%>',<%=type%>,<%=year%>,<%=month %>,<%=id%>,'<%=reportType %>')" extend="false" isLoad='false'><img src="images/extend.png"/><%=orgName%></span><img src="images/delete.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unHappy=((Integer)((HashMap)resultCountList.get(i)).get("unhappy")).intValue();
			    int happy=((Integer)((HashMap)resultCountList.get(i)).get("happy")).intValue();
	        	if(isWorkday){
	    %>
	            <td align="center" style="width: 18px;"><span style="color:red"><%=unHappy%></span>/<%=unHappy+happy%></td>
	    <%   		
	        	}else{
	    %>
	    <%    		
	        	}
	        }else{
	    %>
	            <td>&nbsp;</td>
	    <%    	
	        }
	    } %>
	    <td>
	    
	    		<span title="不高兴<%=resultMap.get("totalUnHappyDays") %>天高兴<%=resultMap.get("totalHappyDays") %>天"><%=reportManager.getReportIndexStar(((Double)resultMap.get("totalMoodIndex")).doubleValue())%></span><%=resultMap.get("totalMoodIndex") %><a href="javascript:openChart('<%=reportType %>','<%=content%>',<%=year%>,<%=type%>,'<%=orgName%>心情报表')" style="text-decoration: none"><img src="images/chart.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
		  <%
	  }
}
}%>
</table>
<%}%>
</div>
    
</div>	
<div>
    <div style="width:100%;;border-top:1px solid  #c2E2E7;line-height:1px;margin-top: 5px;"></div>
    <div id="condition"  style="margin-right: 8px;float: right;margin-top:8px;margin-bottom: 20px;display: <%=isnew.equals("true")?"":"none"%>">
       <a class="btnEcology" href="#" onclick="addCondition()">
			<div class="left" style="width:60px"><span >添加条件</span></div><!-- 添加条件 -->
			<div class="right"> &nbsp;</div>
	   </a>
    </div>
</div>
<script type="text/javascript">
     Ext.onReady(function() {
         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
     });
 </script>
<script type="text/javascript">

  //锁定报表
  function doLock(){
    window.parent.displayLoading(1,"page");
    window.location.href="customReport.jsp?isnew=false&tempid=<%=tempid%>&year=<%=year%>&month=<%=month%>";
  }
  //编辑报表
  function doEdit(){
    window.parent.displayLoading(1,"page");
    window.location.href="customReport.jsp?isnew=true&tempid=<%=tempid%>&year=<%=year%>&month=<%=month%>";
  }

  function extendRecord(obj,value,type,year,month,conditionid,reportType){
	  if(jQuery(obj).attr("extend")=="true"){
	     jQuery(obj).parent().parent().parent().find(".item"+conditionid).hide();
	     jQuery(obj).attr("extend","false");
	     jQuery(obj).find("img").attr("src","images/extend.png");
	  }else{
	     jQuery(obj).parent().parent().parent().find(".item"+conditionid).show();
	     jQuery(obj).attr("extend","true");
	     jQuery(obj).find("img").attr("src","images/shousuo.png");
	     if(jQuery(obj).attr("isLoad")=="false"){
	        window.parent.displayLoading(1,"data");
	        jQuery.post("customReportRecord.jsp?reportType="+reportType+"&tempid=<%=tempid%>&isAppend=true&isExtend=true&year="+year+"&month="+month+"&value="+value+"&conditionid="+conditionid+"&type="+type+"",function(data){
	           jQuery(obj).parent().parent().after(data);
	           window.parent.displayLoading(0);
	        });
	        jQuery(obj).attr("isLoad","true");
	     }   
	  }   
   }   

   var type="blog";
   jQuery(document).ready(function(){   
     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
     window.parent.displayLoading(0);
  });
  
   function selectBox(obj){
    if(jQuery(obj).attr("checked")){
       jQuery(".condition").attr("checked",true);
    }else{
       jQuery(".condition").attr("checked",false);
    }
  }
  
 function changeMonth(year,month){
    window.parent.displayLoading(1,"page");
    window.location.href="customReport.jsp?isnew=<%=isnew%>&tempid=<%=tempid%>&year="+year+"&month="+month+"&reportType=<%=reportType%>";
  }
  
 function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="customReport.jsp?isnew=<%=isnew%>&tempid=<%=tempid%>&year="+year+"&reportType=<%=reportType%>";
 } 

  function changeReport(obj,typeTemp){
      window.parent.displayLoading(1,"page"); 
	  reportType=typeTemp;
	  window.location.href="customReport.jsp?isnew=<%=isnew%>&tempid=<%=tempid%>&year=<%=year%>&month=<%=month%>&reportType="+typeTemp;

	   jQuery(".reportTab a").css("font-weight","normal");
	   jQuery(obj).css("font-weight","bold");
	   jQuery(".reportDiv").hide();
	   jQuery("#"+type+"ReportDiv").show();
	   jQuery(".remarkDiv").hide();
	   jQuery("#"+type+"Remarks").show();
  }
  var compareYear=<%=year%>;
  var compareMonth=<%=month%>;
  var reportType="<%=reportType%>";
  
  function compareChart(reportdiv,charType){
  
   var conType="";    
   var conValue="";
   var conditions=jQuery("#"+reportdiv).find(".condition:checked"); 
   if(conditions.length==0){
      alert("请选择条件");//请选择条件
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
	diag.Title =reportName;
	reportName=reportName.replace(/\'/,"'");
	diag.URL = "compareChart.jsp?title="+reportName+"&conValue="+conValue+"&conType="+conType+"&year="+compareYear+"&month="+compareMonth+"&chartType="+charType;
    diag.show();
  }
  
   var index=2;
   function addCondition(){
        index++;
        var str="<div class='conDiv' id='con_"+index+"'><div class='conType'>报表条件："+getShareTypeStr()+getShareContentStr()+ //报表条件
        "</div><div class='operationdiv'>"+
        "<div class='operationItem'><a class='btnEcology' href='#' onclick='deleteCon("+index+")'><div class='left' style='width:45px'><span >删除</span></div><div class='right'> &nbsp;</div></a></div>"+	//删除
		"</div><div class='conLine'></div><div id='blog_"+index+"'></div><div style='display:none' id='mood_"+index+"'></div></div>"
        
        jQuery("#condition").before(str);
     }
    
    function deleteCon(index){
       jQuery("#con_"+index).remove();
    } 
  
   function getShareTypeStr(){
	   /*
		return  "<select class='sharetype inputstyle' id='sharetype_"+index+"'  name='sharetype' onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected>人员</option>" +
        "	<option value='2'>分部</option>" +
        "	<option value='3'>部门</option>" +
        "</select>";   
        */
        return  "<select class='sharetype inputstyle' id='sharetype_"+index+"'  name='sharetype' onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected>人员</option>" +
        //"	<option value='2'>分部</option>" +
        "	<option value='3'>部门</option>" +
        "</select>"; 
	}
	
   function getShareContentStr(){
	   /*
		return   "<BUTTON type='button' class='Browser  btnShare' onClick=\"onShowResource('relatedshareid_"+index+"','showrelatedsharename_"+index+"',"+index+")\" type=\"t1\"></BUTTON>"+		
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowSubcompany('relatedshareid_"+index+"','showrelatedsharename_"+index+"',"+index+")\"  type=\"t2\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowDepartment('relatedshareid_"+index+"','showrelatedsharename_"+index+"',"+index+")\"   type=\"t3\"></BUTTON>"+ 
       "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\"relatedshareid_"+index+"\" value=''>"+ 
       "<input type='hidden' name='shareid' value='0'>"+
       "<span id=showrelatedsharename_"+index+" class='showrelatedsharename'  name='showrelatedsharename'></span>";
       */
       return   "<BUTTON type='button' class='Browser  btnShare' onClick=\"getrefobj('relatedshareid_"+index+"','showrelatedsharename_"+index+"','402881eb0bd30911010bd321d8600015','','/humres/base/humresinfo.jsp?id=','0')\" type=\"t1\"></BUTTON>"+
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowSubcompany('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t2\"></BUTTON>"+
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"getrefobj('relatedshareid_"+index+"','showrelatedsharename_"+index+"','40287e8e12066bba0112068b730f0e9c','','/base/orgunit/orgunitview.jsp?id=','0')\"   type=\"t3\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"getrefobj('relatedshareid_"+index+"','showrelatedsharename_"+index+"','4028819a0f16b8f1010f1796c5cc000b','','','0')\"  type=\"t4\"></BUTTON>"+
       "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\"relatedshareid_"+index+"\" value=''>"+ 
       "<input type='hidden' name='shareid' value='0'>"+
       "<span id=showrelatedsharename_"+index+" class='showrelatedsharename'  name='showrelatedsharename'></span>";
	}	  
   
   function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		jQuerytr.find(".btnShare").hide();		
		jQuerytr.find(".relatedshareid").val("");
		jQuerytr.find(".showrelatedsharename").html("");
		
		//jQuerytr.find(".shareSecLevel").val("");
		jQuerytr.find(".shareSecLevel").hide();

		if(thisvalue==5){
			jQuerytr.find(".showrelatedsharename").hide();
		} else {
			jQuerytr.find(".showrelatedsharename").show();
			jQuerytr.find("button")[(jQuery(obj).val()-1)].style.display='';
		}	
		if(thisvalue!=1){
			jQuerytr.find(".shareSecLevel").show();
		}	
	}
	
	/*检查当前用户对选择人员是否具有查看权限*/
   function isCanView(attentionid){
     var flag=false;
     jQuery.ajax({   
        type: "post",   
        url: "blogOperation.jsp?operation=isCanView&attentionid="+attentionid,   
        async:false,   
        success: function(data){   
           data=jQuery.trim(data);
	       if(data=="true")
	            flag=true;
        }   
     });
     if(!flag)
        alert("无查看权限");
     return flag;

   }
    
    var year=<%=year%>;
    var month=<%=month%> ;
    function createReport(index){
       var isAppend=true;
       var value=jQuery("#relatedshareid_"+index).val();
       var type=jQuery("#sharetype_"+index).val();
       if(value==""){
           alert("请选择条件"); //请选择条件
           return ;
       }    
       if(jQuery.trim(jQuery("#blogReportDiv").html())=="")
           isAppend=false;
       window.parent.displayLoading(1,"data");
       jQuery.post("customReportRecord.jsp?reportType=<%=reportType%>&tempid=<%=tempid%>&isAppend="+isAppend+"&isExtent=false&year="+year+"&month="+month+"&value="+value+"&index="+index+"&type="+type+"&reportType="+reportType,function(data){
          data=jQuery.trim(data);
          if(data=="null")
             alert("没有可查看人员"); //没有可查看人员 
          else{   
	          if(isAppend)
	            jQuery("#blogReportList tbody").append(data);
	          else
	            jQuery("#blogReportDiv").html(data);  
	            jQuery("#con_"+index).remove();  
          }  
         window.parent.displayLoading(0); 
       });
       
    }
   
  function delCon(obj,index){
    if(window.confirm("确认删除条件?")){ //确认删除条件
	    jQuery(obj).parent().parent().remove();
	    jQuery(".item"+index).remove();
	    jQuery.post("blogOperation.jsp?operation=delCondition&conditionid="+index); 
    }
  } 
   
  function editTitle(){
     jQuery("#titleSpan").hide();
     jQuery("#titleText").show();
     jQuery("#editTitle").hide();
     jQuery("#savaTitle").show();
  }
  
  var reportName="<%=tempName%>";
  function saveTitle(){
     var tempName=jQuery("#titleText").val();
     var reg = /^[\w\u4e00-\u9fa5]+$/;
     //var reg = /^[a-zA-Z0-9\u4e00-\u9fa5]+$/;
     if(!reg.test(tempName)){
        alert("请输入字母、数字、中文或下划线！");
        return ;
     }
     
     jQuery("#titleSpan").show();
     jQuery("#titleText").hide();
     jQuery("#editTitle").show();
     jQuery("#savaTitle").hide();
     
     jQuery('#<%=tempid%>', window.parent.document).find(".tabTitle").text(tempName);
     jQuery('#<%=tempid%>', window.parent.document).find(".tabTitle").attr("title",tempName);
     
     reportName=tempName;
     jQuery("#titleSpan").text(tempName);
     jQuery.post("blogOperation.jsp?operation=editReport&tempid=<%=tempid%>&tempName="+tempName);
  }
  
  //对比
 function doCompare(){
   jQuery("#compareBtn").click();
 }  
 
 
 function onShowSubcompany(inputid,spanid,index){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	          createReport(index);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
 }
 
  function onShowDepartment(inputid,spanid,index){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	          createReport(index);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
function onShowResource(inputid,spanid,index){
  var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if(id1){
	  var id=id1.id;
	  var name=id1.name;
	  if(id!=""&&isCanView(id)){
	     jQuery("#"+inputid).val(id);
	     jQuery("#"+spanid).html(name);
	     createReport(index);
	  }else{
	     jQuery("#"+inputid).val("");
	     jQuery("#"+spanid).html("");
	  }
  }
  
}
 function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
    if (document.getElementById(inputname.replace("field", "input")) != null) {
        document.getElementById(inputname.replace("field", "input")).value = "";
    }
    var fck = param.indexOf("function:");
    if (fck > -1) {
    }
    else {
        var param = parserRefParam(inputname, param);
    }
    var idsin = document.getElementsByName(inputname)[0].value;
    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
    }
    var id;
    var browserName=navigator.userAgent.toLowerCase();
    var isSafari = /webkit/i.test(browserName) &&!(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName));
    /*
     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
     */
    var isStationBrowserInSafari = isSafari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
    //流程单选 || 工作流程单选 || 工作流程多选
	var isWorkflowBrowserInSafari = isSafari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
	//员工多选
	var isHumresBrowserInSafari = isSafari && refid == '402881eb0bd30911010bd321d8600015';	
	
    if (!Ext.isSafari) {
        try {
            // id=openDialog(url,idsin);
            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
        } 
        catch (e) {
            return
        }
        
        if (id != null) {
            if (id[0] != '0') {
                document.getElementById(inputname).value = id[0];
                document.getElementById(inputspan).innerHTML = id[1];
                if (fck > -1) {
                    funcname = param.substring(9);
                    scripts = "valid=" + funcname + "('" + id[0] + "');";
                    eval(scripts);
                    if (!valid) { //valid默认的返回true;
                        document.all(inputname).value = '';
                        if (isneed == '0') 
                            document.all(inputspan).innerHTML = '';
                        else 
                            document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                    }
                }
            }
            else {
                document.all(inputname).value = '';
                if (isneed == '0') 
                    document.all(inputspan).innerHTML = '';
                else 
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                
            }
        }
    }
    else {
        url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
        var callback = function(){
            try {
                id = dialog.getFrameWindow().dialogValue;
            } 
            catch (e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    WeaverUtil.fire(document.all(inputname));
                    document.all(inputspan).innerHTML = id[1];
                    if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) { //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0') 
                                document.all(inputspan).innerHTML = '';
                            else 
                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                }
                else {
                    document.all(inputname).value = '';
                    if (isneed == '0') 
                        document.all(inputspan).innerHTML = '';
                    else 
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                    
                }
            }
        }
        if (!win) {
            win = new Ext.Window({
                layout: 'border',
                width: Ext.getBody().getWidth() * 0.85,
                height: Ext.getBody().getHeight() * 0.85,
                plain: true,
                modal: true,
                items: {
                    id: 'dialog',
                    region: 'center',
                    iconCls: 'portalIcon',
                    xtype: 'iframepanel',
                    frameConfig: {
                        autoCreate: {
                            id: 'portal',
                            name: 'portal',
                            frameborder: 0
                        },
                        eventsFollowFrameLinks: false
                    },
                    closable: false,
                    autoScroll: true
                }
            });
        }
        win.close = function(){
            this.hide();
            win.getComponent('dialog').setSrc('about:blank');
            callback();
        }
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
   }
function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
		strend = inputname.substring(38);
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				pvalue = getValidStr(document.all(pname).value);
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
			}
			spos = _fieldcheck.indexOf("$",epos+1);
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				var etag = _fieldcheck.substring(epos);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}

function getValidStr(str) {
	str+="";
	if (str=="undefined" || str=="null")
		return "";
	else
		return str;
}
</script>	
</body>
</html>