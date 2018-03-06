<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogReportManager"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>--%>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%@ include file="/blog/bloginit.jsp" %>

<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  String userid=""+user.getId();
  String title=StringHelper.null2String(request.getParameter("title"));
  String conType=StringHelper.null2String(request.getParameter("conType"));
  String conValue=StringHelper.null2String(request.getParameter("conValue"));
  String chartType=StringHelper.null2String(request.getParameter("chartType"));
  String chartName="";
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
  
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  
  String conTypes[]=conType.split(",");
  String conValues[]=conValue.split(",");
  
  List categoriesList=new ArrayList();
  List seriesDataList=new ArrayList();
  
  double workIndex=0;
  String categorie="";
  for(int i=0;i<conTypes.length;i++){
	  String type=conTypes[i];
	  String value=conValues[i];
	  if("blog".equals(chartType)){
		  	chartName="工作指数";  //工作指数
	  }else if("mood".equals(chartType)){
		  chartName="心情指数";    //心情指数
	  }
	  if(type.equals("1")){
		  if("blog".equals(chartType)){
			  workIndex=Double.parseDouble(reportManager.getBlogIndexByUser(value,year,month));
		  }else if("mood".equals(chartType)){
			  workIndex=Double.parseDouble(reportManager.getMoodIndexByUser(value,year,month));
		  }
		    
		  categorie=humresService.getHrmresNameById(value);
	  }else if(type.equals("2")||type.equals("3")){
		  if("blog".equals(chartType)){
			  workIndex=reportManager.getBlogIndexByOrg(userid,value,type,year,month);
		  }else if("mood".equals(chartType)){
			  workIndex=reportManager.getMoodIndexByOrg(userid,value,type,year,month);
		  }
		  categorie=StringHelper.null2String(orgunitService.getOrgunitName(value));
	  }
	  categoriesList.add(categorie);	
	  seriesDataList.add(new Double(workIndex));
  }
  String categories=JSONArray.fromObject(categoriesList).toString();
  String seriesData=JSONArray.fromObject(seriesDataList).toString();

%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Highcharts Example</title>
		<script type="text/javascript" src="js/report/highcharts.js"></script>
		<script type="text/javascript" src="js/report/modules/exporting.js"></script>
		<LINK href="/ecology/css/Weaver.css" type=text/css rel=STYLESHEET>
		<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
        <script type='text/javascript' src='js/timeline/easing.js'></script>
        <link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css">
        <LINK href="css/blog.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
		    var categories=eval('(<%=categories%>)');
		    var seriesData=eval('(<%=seriesData%>)');
			var chart;
			$(document).ready(function() {
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						defaultSeriesType: 'column'
					},
					credits:{
					 enabled:false
					},
					title: {
						text: '<%=title%>',
						x: -20,
						style: {
                           color: '#000000',
                           fontWeight: 'bold',
                           fontSize:'16'
                        }
					},
					subtitle: {
						text: '',
						x: -20
					},
					xAxis: {
						categories: categories
					},
					yAxis: {
						title: {
							text: ''
						},
						plotLines: [{
							value: 0,
							width: 1,
							color: '#808080'
						}],
						max:5   //最大指数
					},
					//指数提示
					tooltip: {
					    style:{
					       padding: 5
					    },
				        formatter: function() {
				            var s = '<b>'+ this.x +'</b>';
				            
				            $.each(this.points, function(i, point) {
				                s += '<br/><span style="color:#3e576f;font-weight:bold">'+ point.series.name +'</span>: '+
				                    point.y;
				            });
				            
				            return s;
				        },
				        shared: true
                    },
					exporting: {
                        enabled: false
                    },
					series: [{
						name: '<%=chartName%>',
						data: seriesData
				
					}
					/*
					, {
						name: '心情指数',
						data: [2.6, 2.4, 2.5]
				
					}, {
						name: '考勤指数',
						data: [4.9, 4.8, 4.3]
				
					}
					*/
					]
				});
				
				$(function(){$(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
				
			});

		 function changeMonth(compareYear,compareMonth){
		    window.location.href="compareChart.jsp?title=<%=title%>&chartType=<%=chartType%>&conType=<%=conType%>&conValue=<%=conValue%>&year="+compareYear+"&month="+compareMonth;
		 }
		 
		 function changeYear(){
		    var year=jQuery("#yearSelect").val();
		    window.location.href="compareChart.jsp?title=<%=title%>&chartType=<%=chartType%>&conType=<%=conType%>&conValue=<%=conValue%>&year="+year;
         } 
		 
		</script>
		
	</head>
	<body>
	  <table style="margin: 0px;padding: 0px;width: 100%" align="center">
	     <tr>
	         <td align="center" style="margin: 0px;padding: 0px;" >
		        <div id="container" style="width: 650px; height: 380px; margin: 0 auto"></div>
		
			    <div style="margin-bottom: 5px;" align="center">
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
								     <select style="width: 80px;" id="yearSelect" onchange="changeYear()">
								         <%
										   for(int i=currentYear;i>=enableYear;i--){ 
										 %>
										   <option value="<%=i%>" <%=i==year?"selected='selected'":""%>><%=i%>年</option><!-- 年 -->
									    <%} %>
								     </select>
						         </div>
				         </div>
		    </div>	
           </td>
	     </tr>
	  </table>	
	</body>
</html>
