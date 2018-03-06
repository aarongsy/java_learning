<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>

<%@ include file="/base/init.jsp"%>
<%
String color1="lightblue";//周末
String color2="darkblue";//无效日期
String color3="#FF0000";//节假日
String color4="#CC00FF";//占用
String color5="#FFFF00";//多个占用
String searchdate = StringHelper.null2String(request.getParameter("searchdate"));
if(searchdate==null||searchdate.length()<1) searchdate=DateHelper.getCurrentDate();
SimpleDateFormat formater=new SimpleDateFormat();
SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
Calendar today = new GregorianCalendar();
Date startdate = f.parse(searchdate);
today.setTime(startdate);
int currentyear=today.get(Calendar.YEAR);
int currentmonth=today.get(Calendar.MONTH)+1;  
int currentday=today.get(Calendar.DATE);  
int yearcnd=currentyear;
String action=StringHelper.null2String(request.getParameter("action"));
String viewType=StringHelper.null2String(request.getParameter("viewType"));
if(viewType==null||viewType.equals("")) viewType="3";//1:日视图,2:周视图,3月视图
String firstDate =getFirstDayOfMonth(searchdate);
String lastDate =getLastDayOfMonth(searchdate);
int  days =getMonthDays(searchdate);
%>
<%
	DataService ds = new DataService();
	String viewName="";
	StringBuffer cont = new StringBuffer();
	String sql = "select requestid,carName objname,carNO objno from uf_carinfo t  order by carNO";
	List objnameList = ds.getValues(sql);
	String where="";
	 if(viewType.equals("3"))
	{
		where= " and ( beginDate between '"+firstDate+"'  and '"+lastDate+"' or endDate between '"+firstDate+"'  and '"+lastDate+"')";
		viewName=labelService.getLabelNameByKeyId("402883d934c1ea690134c1ea6a400000");
	}
	sql = "select t.requestid,t.title objname,t.carNO objid,t.starttime,t.userange,t.finishtime,reqMan,reqDept,driver,carNO,beginPlace,endPlace from (select requestid,title,reqMan,reqDept,driver,carNO,beginPlace,userange,endPlace, beginDate,beginTime,endDate,endTime,description,beginDate+' '+beginTime  starttime,endDate+' '+endtime finishTime from uf_carusereq x where 1=1 "+where+" and exists(select id from requestbase where id=x.requestid and isdelete=0) ) t order by starttime";

	List dataList = ds.getValues(sql);
%>
<%!

	private String dateAdd(String curDate,int days) 
	{
		Calendar c = Calendar.getInstance();
		c.setTime(java.sql.Date.valueOf(curDate));   //设置当前日期
		c.add(Calendar.DATE, days); //日期加1
		Date date1 = c.getTime(); //结果
		SimpleDateFormat formater=new SimpleDateFormat();
		formater.applyPattern("yyyy-MM-dd");
		String nextDate=formater.format(date1);
		return nextDate;

	}      
	private String toWeek(String str)   
	{   	    
		String []bigNum={"日","一","二","三","四","五","六","七","八","九"};
		int t=Integer.parseInt(str);    
		return bigNum[t];          
	}
%>
<c:if test="${!isExcel}">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934c1ece20134c1ece30b0000") %></title><!-- 车辆使用视图 -->
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>

<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
<style type=text/css>.TH {
	CURSOR: auto; BACKGROUND-COLOR: beige
}
.PARENT {
	CURSOR: auto
}
.TH {
	CURSOR: auto; HEIGHT: 25px; BACKGROUND-COLOR: beige
}
.TODAY {
	CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.T_HOUR {
	BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.TI TD {
	BORDER-TOP: 0px; FONT-SIZE: 13px;  BORDER-LEFT: 0px; CURSOR: auto; POSITION: relative; 
}
.CU {
	
}
.SD {
	CURSOR: auto; COLOR: white; BACKGROUND-COLOR: mediumblue
}
.L {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.LI {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.L1 {
	BORDER-TOP: white 1px solid; BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.MI TD {
	BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}
</style>
</head>
<script type="text/javascript">
/*WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

var topBar=null;
WeaverUtil.load(function(){
	var div=document.createElement("div");
	div.id="pagemenubar";
	Ext.getBody().insertFirst(div);
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	
	//addBtn(topBar,'日视图','S','calendar',function(){document.getElementById('viewType').value="1";onSearch();});
	//topBar.addSpacer();
	//topBar.addSpacer();
	//topBar.addSeparator();
	topBar.addSeparator();
	addBtn(topBar,'月视图','S','calendar',function(){document.getElementById('viewType').value="3";onSearch();});
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'周视图','S','calendar',function(){document.getElementById('viewType').value="2";onSearch();});
	topBar.addSpacer();
	topBar.addSpacer();

	topBar.addSeparator();
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.formExport.action= document.formExport.action+location.href.substring(idx);
});
function Save2Html(){
	document.getElementById('exportType').value="html";
	document.formExport.target="_blank";
	document.formExport.submit();
}
function Save2Excel(){
	document.getElementById('exportType').value="excel";
	//document.formExport.target="_blank";
	document.formExport.submit();
}*/
function onSearch(){
	if(checkIsNull())
		document.formExport.submit();
}
function checkIsNull()
{
	var searchdate=document.getElementsByName('searchdate');
	if(searchdate[0].value==null||searchdate[0].value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934c1ee7a0134c1ee7afe0000") %>");//日期不能为空!
		return false;
	}
	return true;
}
</script>
</head>
<body>
<form action="/app/car/CarUseReport.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" name="viewType" id="viewType" value="<%=viewType%>"/>
</c:if>
<br>
<center>
<div style="width:98%">
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883d934c1ece20134c1ece30b0000") %><!-- 车辆使用视图 --></CENTER></div>
<TABLE style="width:100%">
<TBODY>
<TR>
<TD width="100%" align="center"><input type=text class=inputstyle readonly size=20 name="searchdate"  value="<%=searchdate%>" onclick="WdatePicker()" onchange="javascript:onSearch();" style="text-align:center;background:#AF60FF">
</tr></tbody></table>
  <table border=0 cellspacing=0 cellpadding=0 bgcolor="" width="100%" style="width:100%">
	<TR class=Title>
		<TH align="left" width="70%"><%=viewName%>&nbsp;&nbsp;&nbsp;&nbsp;</TH>
		<td align="right" width="30%">

			<table >
			<tr><td >
			
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="" >
			<tr><td bgcolor="<%=color4%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c1f0610134c1f061a80000") %><!-- 占用 -->
			</td><td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color5%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c1f1940134c1f194910000") %><!-- 多个占用 -->
			</td>
			</table>
		</td>
	</TR>
	</table>
<br>
<table cellSpacing=0 cellPadding=0 style="TABLE-LAYOUT: fixed; WIDTH: 100%;BORDER-LEFT 1px solid;"  >
<tr><td>
<table class=MI  id=AbsenceCard  width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%;table-layout:fixed;BORDER-RIGHT: 1px solid;">
<tr  bgcolor=#C7CFC5>
<%

	Calendar tempday = Calendar.getInstance();
	cont.append("<td width=\"10%\" align=center>"+labelService.getLabelNameByKeyId("402883d934c1f2c00134c1f2c16c0000")+"</td>");//车辆
	for(int x=1;x<=days;x++)
	{
		cont.append("<td width="+Math.round(77/days)+"% align=center>"+x+labelService.getLabelNameByKeyId("402883d934c1f3e80134c1f3e8c40000")+"</td>");//日
	
	}
	cont.append("</tr>");
	String innertext="";
	String bgcolor="white";
	for(int i=0,size=objnameList.size();i<size;i++)
	{
			Map m = (Map)objnameList.get(i);
			String objname = StringHelper.null2String(m.get("requestid"));
			//cont.append("<TR class=Line><TD colspan=\""+days+"\" ></TD></TR> ");
			cont.append("<tr height=25><td align=center>"+StringHelper.null2String(m.get("objname"))+"</TD>");
			
			for(int j=1;j<=days;j++)
			{
				bgcolor="white";
				String mintime = currentyear+"-"+add0(currentmonth,2)+"-"+add0(j,2);
				String maxtime = mintime+" 23:59:59";
				boolean isweekend=false;
				innertext="&nbsp;";
				tempday.clear();
				tempday.set(currentyear,currentmonth-1,j);
				if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)) {bgcolor=color1;isweekend=true;}
				int count=0;
				String ids="";
				String thenowday=mintime;
				for(int k=0,size1=dataList.size();k<size1;k++)
				{
					Map m1 = (Map)dataList.get(k);
					String requestid = StringHelper.null2String(m1.get("requestid"));
					String objname1 = StringHelper.null2String(m1.get("objid"));
					String starttime = StringHelper.null2String(m1.get("starttime"));
					String endtime = StringHelper.null2String(m1.get("finishtime"));
					
					if(objname1.indexOf(objname)>-1)
					{
						if((starttime.compareToIgnoreCase(mintime) >= 0 && starttime.compareToIgnoreCase(maxtime)<=0)||(endtime.compareToIgnoreCase(mintime) >= 0 && endtime.compareToIgnoreCase(maxtime)<=0))
						{
							ids=ids+requestid+",";
							count=count+1;
								String title = StringHelper.null2String(m1.get("objname")) ;
								String beginPlace = StringHelper.null2String(m1.get("beginPlace")) ;
								String endPlace = StringHelper.null2String(m1.get("endPlace")) ;
								String reqMan = getBrowserDicValue("humres","id","objname",StringHelper.null2String(m1.get("reqMan"))) ;
								String userange = getSelectDicValue(StringHelper.null2String(m1.get("userange"))) ;
								thenowday+="&#13;"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")+"："+objname+"&#13;"+labelService.getLabelNameByKeyId("402883d934c1f5a10134c1f5a18c0000")+"："+reqMan+"&#13;"+labelService.getLabelNameByKeyId("402881820d467b14010d4687e3be0008")+"："+starttime+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+endtime+"&#13;"+labelService.getLabelNameByKeyId("402883d934c1f7e20134c1f7e35f0000")+"："+beginPlace+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+endPlace+"&#13;"+labelService.getLabelNameByKeyId("402883d934c1f8c60134c1f8c7000000")+"："+userange+"&#13;";
								
						}
						//if(count>1)break;
					}
					else
					{
						continue;
					}
				}
				if(ids.length()>0)ids=ids.substring(0,ids.length()-1);
				if(count==0)
					innertext="<div width:100%;\" onclick=\"javascript:showRecord('"+ids+"','"+objname+"','"+mintime+"');\">&nbsp;</div>";
				else if(count==1)
					innertext="<div style=\"background-color:"+color4+";width:100%;height:12\" onclick=\"javascript:showRecord('"+ids+"','"+objname+"','"+mintime+"');\" >&nbsp;</div>";
				else if(count>1)
					innertext="<div style=\"background-color:"+color5+";width:100%;height:12\" onclick=\"javascript:showRecord('"+ids+"','"+objname+"','"+mintime+"');\">&nbsp;</div>";
				cont.append("<td bgColor=\""+bgcolor+"\"  onmouseover=\"javascript:this.bgColor='#66FF99';\" onmouseout=\"javascript:this.bgColor='"+bgcolor+"';\" style=\"CURSOR: hand;\" title=\""+thenowday+"\">"+innertext+"</td>");
			
			}
			cont.append("</TR>");
	}
	out.println(cont);
		%>	
</table></td></TR>
<tr>
<td style="BORDER-top: 1px solid;">
&nbsp;
</td></TR>
<tr>
<td>
<br>
<div id="detail"></div>
<br>
</td></TR>
</table>
</div>
<!--周视图-->
 <!--  <table class=MI id=AbsenceCard 
	style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
	cellSpacing=0 cellPadding=0>
		<tr>	
			<td>
				<table width="100%" border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=23%>周</td>
						
							<td width=11% align=center>日</td>
						
							<td width=11% align=center>一</td>
						
							<td width=11% align=center>二</td>
						
							<td width=11% align=center>三</td>
						
							<td width=11% align=center>四</td>
						
							<td width=11% align=center>五</td>
						
							<td width=11% align=center>六</td>
				    </tr>
</table></td></TR></table> -->
</div>
</body>
</html>
<script>
function showRecord(ids,objname,date)
 {
	 //if(ids.length<1)return;
	 document.getElementById('detail').innerHTML="<%=labelService.getLabelNameByKeyId("402883d934c1f9d80134c1f9d9620000") %>....................";
	 Ext.Ajax.request({
			 url: '<%=request.getContextPath()%>/app/car/CarUseReportList.jsp',
			 params:{ids:ids,objname:objname,date:date},
			 success: function(res) {
				 //var str=res.responseText;
				 var data=res.responseText;
				 document.getElementById('detail').innerHTML=data;
			 }
	 });

 }
showRecord('');
</script>
<%!
	private String add0(int nums,int len)
	{
		String str= String.valueOf(nums);
		for(int i=len,tlen=str.length();i>tlen;i--)
		{
			str="0"+str;
		}
		return str;
	}
	private String getSelectDicValue(String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select OBJNAME from selectitem where id='"+dicID+"'");
	}
	/**
	 * 取brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValue(String tab,String idCol,String valueCol,String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicID+"'");
	}
	
	/**
	 * 取批量brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValues(String tab,String idCol,String valueCol,String dicID)
	{
		String dicValue="";
		if(dicID==null||dicID.length()<1)return "";
		String[] dicIDs = dicID.split(",");
		DataService ds = new DataService();
		for(int i=0,size=dicIDs.length;i<size;i++)
		{
			dicValue=dicValue+","+ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicIDs[i]+"'");
		}
		if(dicValue.length()<1)dicValue="";
		else dicValue=dicValue.substring(1,dicValue.length());
		return dicValue;
	}
	private boolean isWeekEnd(String date,List holidaysList)
	{
		
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Calendar today = new GregorianCalendar();
	    Date startdate;
		int i=-1;
		try {
			startdate = f.parse(date);
		    today.setTime(startdate);
			i=today.getTime().getDay();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		boolean isweekend=false;
		if(i==0||i==6)
		{
			isweekend=true;
		}
		int size2=holidaysList.size();
		for(int k=0 ; k<size2 ; k++) {
			Map m = (Map)holidaysList.get(k);
			String tempdatefrom = StringHelper.null2String(m.get("date1")) ;
			String daytype = StringHelper.null2String(m.get("daytype"));
			String isholiday1 = StringHelper.null2String(m.get("isholiday"));
			String isworkday = StringHelper.null2String(m.get("isworkday"));
			if(date.compareToIgnoreCase(tempdatefrom) !=0 ) continue ;
			if(isworkday.equals("1")&&daytype.equals("2"))
			{
					isweekend=false;
			}
			break;

		}
		return isweekend;
	}
	private String addDate(String date)
	{
	
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Calendar today = new GregorianCalendar();
	    Date startdate;
		int i=-1;
		try {
			startdate = f.parse(date);
		    today.setTime(startdate);
		    today.add(Calendar.DATE,1);
			i=today.getTime().getDay();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return f.format(today.getTime());
		
	}
	   /** 
   *取得每月的第一天 
   * @return 
   */ 
   public static String getFirstDayOfMonth(String  date) 
   { 
	   SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
       Calendar cal = Calendar.getInstance(); 
       try {
    	   cal.setTime(f.parse(date));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       cal.set(Calendar.HOUR_OF_DAY, 0); 
       cal.set(Calendar.MINUTE, 0); 
       cal.set(Calendar.SECOND, 0); 
       cal.add(Calendar.DATE,-cal.get(Calendar.DAY_OF_MONTH)+1); 
       String start = f.format(cal.getTime()); 
       return start; 
           
   } 
   /** 
   *取得每月的最后一天  
   * @return 
   */ 
   public static String getLastDayOfMonth(String  date) 
   { 
	   SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	   Calendar cal = Calendar.getInstance(); 
	   try {
		   cal.setTime(f.parse(date));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	   cal.add(Calendar.DATE,-cal.get(Calendar.DAY_OF_MONTH)+1); 
	   cal.add(Calendar.MONTH, 1); 
	   cal.add(Calendar.DATE,-1); 
	   cal.set(Calendar.HOUR_OF_DAY, 23); 
	   cal.set(Calendar.MINUTE, 59); 
	   cal.set(Calendar.SECOND, 59); 
	   String end = f.format(cal.getTime()); 
	   return end; 
   } 
   /** 
    *取得某个月的天数  
    * @return 
    */ 
    public static int getMonthDays(String  date) 
    { 
 	   SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
 	   Calendar cal = Calendar.getInstance(); 
 	   try {
 		   cal.setTime(f.parse(date));
 		} catch (Exception e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 		}
 	   int num=cal.getActualMaximum(Calendar.DAY_OF_MONTH);  
 	   return num; 
    } 
	%>