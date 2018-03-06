<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>

<%@ include file="/systeminfo/init.jsp" %>

<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String needfav ="1";
String needhelp ="";
boolean isfromtab =  false;
String leavetype = "";
String otherleavetype = "";
String leavesqlwhere = "";
String currentdate =DateHelper.getCurrentDate();
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);
int currentmonth=today.get(Calendar.MONTH)+1;  
int currentday=today.get(Calendar.DATE);  
int yearcnd=currentyear;
String yearcnd1 = request.getParameter("yearcnd");
String userCndID=request.getParameter("userCndID");
if(yearcnd1!=null)yearcnd=Integer.parseInt(yearcnd1);

EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
if(userCndID==null||userCndID.length()<1)
{
	userCndID="";
	userCndID=eweaveruser1.getId();
}
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16559,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
Calendar today = Calendar.getInstance ();
String currentDate = add0(today.get(Calendar.YEAR), 4) + "-"
                   + add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                   + add0(today.get(Calendar.DAY_OF_MONTH), 2);

String fromDate = Util.null2String(request.getParameter("fromDate"));
String toDate = Util.null2String(request.getParameter("toDate"));

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);
int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);

//安全检查  
//查询的开始日期和结束日期必须有值且长度为10
if(fromDate==null||fromDate.trim().equals("")||fromDate.length()!=10
 ||toDate==null||toDate.trim().equals("")||toDate.length()!=10){
	return;
}
//非考勤管理员只能看到自己的记录
if(!HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
	resourceId=user.getUID();
}

//根据resourceId给departmentId、subCompanyId赋值
if(resourceId>0){
	departmentId=Util.getIntValue(ResourceComInfo.getDepartmentID(""+resourceId),0);
}

//根据departmentId给、subCompanyId赋值
if(departmentId>0){
	subCompanyId=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentId),0);
}
%>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='HrmScheduleDiffReport.jsp?fromDate="+fromDate+"&toDate="+toDate+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&resourceId="+resourceId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>




<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<%
   ExcelFile.init ();
   String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelName(20078,user.getLanguage()) ;

   ExcelFile.setFilename(fileName) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle excelStyle = ExcelFile.newExcelStyle("Header") ;
   //excelStyle.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   excelStyle.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   excelStyle.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   excelStyle.setAlign(ExcelStyle.WeaverHeaderAlign) ;

   ExcelSheet es = ExcelFile.newExcelSheet(fileName) ;
   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   //es.addColumnwidth(8000) ;

%>

<%
    HrmScheduleDiffManager.setUser(user);
    int totalWorkingDays=HrmScheduleDiffManager.getTotalWorkingDays(fromDate,toDate);
    String totalWorkingDaysDesc=SystemEnv.getHtmlLabelName(18861,user.getLanguage())+totalWorkingDays+SystemEnv.getHtmlLabelName(20079,user.getLanguage());

    ExcelRow er  = es.newExcelRow() ;
    er.addStringValue(fileName, "Header" ) ;

    er  = es.newExcelRow() ;
    er.addStringValue(totalWorkingDaysDesc, "Header" ) ;
%>

<table  border=0 width="100%" >
<tbody>
<tr>
  <td align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr>
  <td align="right" ><%=totalWorkingDaysDesc%></td>
</tr>
</tbody>
</table>

<%
   er  = es.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15390,user.getLanguage()), "Header" ) ; 
   er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20081,user.getLanguage())+"（A）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20081,user.getLanguage())+"（B）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20082,user.getLanguage())+"（A）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20082,user.getLanguage())+"（B）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1919,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1920,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20083,user.getLanguage())+"（A）"+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20083,user.getLanguage())+"（B）"+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20084,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20085,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20086,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage()), "Header" ) ;
   
%>

<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="12%">
  <COL width="12%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="10%">
<tbody>
<tr>
  <td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
  <td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
  <td colspan=11 align="center"><%=SystemEnv.getHtmlLabelName(20080,user.getLanguage())%></td> 
  <td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>  
</tr>

<tr>
  <td colspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
  <td colspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20082,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td> 
  <td colspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20083,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td> 
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20084,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20086,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
</tr> 
 
<tr>
  <td align="center">A</td>
  <td align="center">B</td>
  <td align="center">A</td>
  <td align="center">B</td>
  <td align="center">A</td>
  <td align="center">B</td> 
</tr>
 
<%  
   
   


   



    List scheduleList=HrmScheduleDiffManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	String departmentName="";
	String resourceName="";
	String beLateA="";
	String beLateB="";
	String leaveEarlyA="";
	String leaveEarlyB="";
	String sickLeave="";
	String privateAffairLeave="";
	String otherLeaveA="";
	String otherLeaveB="";
	String evection="";
	String tempOut="";
	String absentFromWork="";
	String noSign="";
	String remark="";

    for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		departmentName=Util.null2String((String)scheduleMap.get("departmentName"));
		resourceName=Util.null2String((String)scheduleMap.get("resourceName"));
		beLateA=Util.null2String((String)scheduleMap.get("beLateA"));
		beLateB=Util.null2String((String)scheduleMap.get("beLateB"));
		leaveEarlyA=Util.null2String((String)scheduleMap.get("leaveEarlyA"));
		leaveEarlyB=Util.null2String((String)scheduleMap.get("leaveEarlyB"));
		sickLeave=Util.null2String((String)scheduleMap.get("sickLeave"));
		privateAffairLeave=Util.null2String((String)scheduleMap.get("privateAffairLeave"));
		otherLeaveA=Util.null2String((String)scheduleMap.get("otherLeaveA"));
		otherLeaveB=Util.null2String((String)scheduleMap.get("otherLeaveB"));
		evection=Util.null2String((String)scheduleMap.get("evection"));
		tempOut=Util.null2String((String)scheduleMap.get("out"));
		absentFromWork=Util.null2String((String)scheduleMap.get("absentFromWork"));
		noSign=Util.null2String((String)scheduleMap.get("noSign"));
		remark=Util.null2String((String)scheduleMap.get("remark"));


		er = es.newExcelRow() ;
        er.addStringValue(departmentName);
        er.addStringValue(resourceName);
        er.addStringValue(beLateA);
        er.addStringValue(beLateB);
        er.addStringValue(leaveEarlyA);
        er.addStringValue(leaveEarlyB);
        er.addStringValue(sickLeave);
        er.addStringValue(privateAffairLeave);
        er.addStringValue(otherLeaveA);
        er.addStringValue(otherLeaveB);
        er.addStringValue(evection);
//        er.addStringValue(tempOut);
        er.addStringValue(absentFromWork);
        er.addStringValue(noSign);
        er.addStringValue(remark);

%>
<tr>
  <td><%=departmentName%></td>
  <td><%=resourceName%></td>
  <td align="right"><%=beLateA%></td>
  <td align="right"><%=beLateB%></td>
  <td align="right"><%=leaveEarlyA%></td>
  <td align="right"><%=leaveEarlyB%></td>
  <td align="right"><%=sickLeave%></td>
  <td align="right"><%=privateAffairLeave%></td>
  <td align="right"><%=otherLeaveA%></td>
  <td align="right"><%=otherLeaveB%></td>
  <td align="right"><%=evection%></td>
<!--  <td align="right"><%=tempOut%></td>-->
  <td align="right"><%=absentFromWork%></td>
  <td align="right"><%=noSign%></td>
  <td align="right"><%=remark%></td>

</tr>
<%    
 } 
%>
</tbody>
</table>

<%
    er  = es.newExcelRow() ;
    er.addStringValue(SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate) ;

    er  = es.newExcelRow() ;
    er.addStringValue(SystemEnv.getHtmlLabelName(85,user.getLanguage())+":") ;


	if(user.getLanguage()==8){
        er  = es.newExcelRow() ;
        er.addStringValue("Be Late:A:before 9 o'clock,B:after 9 o'clock(include 9 o'clock);") ;

        er  = es.newExcelRow() ;
        er.addStringValue("Leave Early:A:after 17 o'clock,B:before 17 o'clock(include 17 o'clock);") ;

        er  = es.newExcelRow() ;
        er.addStringValue("Other Leave Type:A:has salary;B:no salary.") ;
	}else{
        er  = es.newExcelRow() ;
        er.addStringValue(labelService.getLabelNameByKeyId("402883de352db85b01352db85e150012")) ;//迟到：A：09点以前迟到，B：09点后迟到(包括09点)；

        er  = es.newExcelRow() ;
        er.addStringValue(labelService.getLabelNameByKeyId("402883de352db85b01352db85e150013")) ;//早退：A：17点以后早退，B：17点前早退（包括17点）；

        er  = es.newExcelRow() ;
        er.addStringValue(labelService.getLabelNameByKeyId("402883de352db85b01352db85e150014")) ;//其他假别：A：带薪假；B：非带薪。
	}

%>


<table class=ViewForm border=0 width="100%">
<tbody>

<tr>
  <td align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
</tr>
<TR class=Title> 
<TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>:</TH>
</TR>
<tr>
  <td align="left" >
<%if(user.getLanguage()==8){%>
Be Late:A:before 9 o'clock,B:after 9 o'clock(include 9 o'clock);<br>
Leave Early:A:after 17 o'clock,B:before 17 o'clock(include 17 o'clock);<br>
Other Leave Type:A:has salary;B:no salary.<br>
<%}else{%>
<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150012")%><br><!-- 迟到：A：09点以前迟到，B：09点后迟到(包括09点)； -->
<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150013")%><br><!-- 早退：A：17点以后早退，B：17点前早退（包括17点）； -->
<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150014")%><br><!-- 其他假别：A：带薪假；B：非带薪。 -->
<%}%>
  </td>
</tr>
<tr>
  <td align="center" >
  [<a href="HrmScheduleDiffSignInDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20241,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffSignOutDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20242,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffBeLateDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20088,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffLeaveEarlyDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20089,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffAbsentFromWorkDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20090,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffNoSignDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20091,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffLeaveDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffEvectionDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20093,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffOutDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20094,user.getLanguage())%></a>]
  </td>
</tr>


</tbody>
</table>



</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>
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
/*select   convert(varchar(10),dateadd(day,id,'+@datebeg+'),120)   from   (  select   id=a.id+b.id*10+c.id*100+d.id*1000   from     
  (   
  select   id=0   union   all   select   1   
  union   all   select   id=2   union   all   select   3   
  union   all   select   id=4   union   all   select   5   
  union   all   select   id=6   union   all   select   7   
  union   all   select   id=8   union   all   select   9   
  )   a,(   
  select   id=0   union   all   select   1   
  union   all   select   id=2   union   all   select   3   
  union   all   select   id=4   union   all   select   5   
  union   all   select   id=6   union   all   select   7   
  union   all   select   id=8   union   all   select   9   
  )   b,(   
  select   id=0   union   all   select   1   
  union   all   select   id=2   union   all   select   3   
  union   all   select   id=4   union   all   select   5   
  union   all   select   id=6   union   all   select   7   
  union   all   select   id=8   union   all   select   9   
  )   c,(   
  select   id=0   union   all   select   1   
  union   all   select   id=2   union   all   select   3   
  union   all   select   id=4   union   all   select   5   
  union   all   select   id=6   union   all   select   7   
  union   all   select   id=8   union   all   select   9   
  )   d   
  )   aa   
  where   dateadd(day,id,'+@datebeg+')   <=     '+@dateend+'   order   by   id)*/

%>




