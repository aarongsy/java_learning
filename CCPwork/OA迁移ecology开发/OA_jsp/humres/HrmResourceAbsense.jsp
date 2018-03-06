<%@ page contentType="text/html; charset=UTF-8"%>
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
<%

String imagefilename = "/images/hdMaintenance.gif";
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
String userCndID=request.getParameter("userCndId");
if(yearcnd1!=null)yearcnd=Integer.parseInt(yearcnd1);
String datefrom = "" ;
String dateto = "" ;
String datenow = "" ;
ArrayList ids = new ArrayList() ;
ArrayList resourceids = new ArrayList() ;
ArrayList diffids = new ArrayList() ;
ArrayList startdates = new ArrayList() ;
ArrayList starttimes = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList endtimes = new ArrayList() ;
ArrayList subjects = new ArrayList() ;

ArrayList memos = new ArrayList() ;
String color1="lightblue";//周末
String color2="darkblue";//无效日期
String color3="#FF0000";//节假日

String color5="#33FF66";//年假
String color6="#CCFF00";//调休
String color7="#669999";//其他请假
String color4="#CC00FF";//加班
String color8="#3E52C1";//出差
String htmlstr="";
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
if(userCndID==null||userCndID.length()<1)
{
	userCndID="";
	userCndID=eweaveruser1.getId();
}
%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
</head>
<%@ include file="/base/init.jsp"%>
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
<BODY>
<FORM id=frmmain name=frmmain method=post action="HrmResourceAbsense.jsp">
<input class=inputstyle type=hidden name=currentdate value="<%=currentdate%>">
<input class=inputstyle type=hidden name=movedate value="">
  <TABLE  style="width:100%;" class="TI" >
    <col width=20%> <col width=30%>  <col width=10%> <col width=40%>
    <TR > 
      <Td colspan=4 align="center"><% if(userCndID.equals(eweaveruser1.getId()))out.println(labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0000"));//我的考勤视图
	  else{out.println(getBrowserDicValue("humres","id","objname",userCndID)+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000b")); }//的考勤视图
	  
	  %></Td>
    </TR>
    <TR class=Spacing> 
      <TD CLASS=Sep1 colspan=4></TD>
    </TR>
	<tr style="height:15">
	<td colspan=1 align=right style="height:15;text-align:left">
	<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001")%>:&nbsp;&nbsp;<%=yearcnd%><select name="yearcnd" style="height:10;width:60;font-size:11" style="display:none" ><!-- 年度 -->
	<%

	for(int i=currentyear-2;i<currentyear+5;i++)
	{
		if(i==yearcnd)
			out.println("<option value='"+i+"' selected>"+i+"</option>");
		else 
			out.println("<option value='"+i+"'>"+i+"</option>");
	}
	
	%>
	</select>
	</td>
	<td colspan=3 align=right style="height:15;text-align:right">
			<table >
			<tr><td >
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="" >
			<tr><td bgcolor="<%=color1%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0002")%><!-- 周末 -->
			</td><td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color2%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0003")%><!-- 无效日期 -->
			</td>
			<td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color3%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0004")%><!-- 节假日 -->
			</td>
			<td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color5%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0006")%><!-- 年假 -->
			</td>
			<td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color6%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0007")%><!-- 调休 -->
			</td>
			<td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color7%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0008")%><!-- 其他请假 -->
			</td>
			<td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color8%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000c")%><!-- 出差 -->
			</td>
			<td>
			<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
			<tr><td bgcolor="<%=color4%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000d")%><!-- 加班 -->
			</td>
			</tr>
			</table>
	</td>
	</tr>
    <TR>
	<TD class=Line colSpan=4></TD>
	</TR> 
  </table>
  <br>
  <table class=MI id=AbsenceCard style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: and; BORDER-BOTTOM: 1px solid" cellSpacing=0 cellPadding=0>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  int i=0;
	  int j=0;
	  for(i=0;i<32;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%if(i>0){%><%=i%><%} else {%>&nbsp<%}%></td>
	  	<%
	  }
	  %>
	</tr>
	<%
	StringBuffer buf = new StringBuffer();
	String bgcolor="white";
	String title="";
        //String bgcolor = ScheduleDiffComInfo.getColor(diffid);
	Calendar tempday = Calendar.getInstance();
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;
	ArrayList tempids = new ArrayList() ;
	ArrayList tempdiffids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	int canlink = 0 ;
	DataService ds = new DataService();
	String sql="select date1,isholiday,isworkday,daytype from holidaysinfo where convert(varchar(4),cast(date1 as datetime),120)='"+yearcnd+"'";
	//where  x.reqman='"+eweaveruser1.getId()+"'  and exists(select id from requestbase where isfinished=1 and id=x.requestid)
	List holidaysList = ds.getValues(sql);
	//6fb8f5627ac92460127acc541bf0016
	sql="select title,begindate,enddate,isnull(reqdays,0) reqdays,reqStyle  from uf_leave x where  x.reqman='"+userCndID+"'  and exists(select id from requestbase where isfinished=1 and id=x.requestid) and convert(varchar(4),cast(begindate as datetime),120)='"+yearcnd+"'";
	List leaveList = ds.getValues(sql);
	int size3=leaveList.size();
	
	int overTimeDaysYear=0;
	

	sql="select title,reqman,requestid,actualbegindate begindate,actualenddate enddate,actualdays reqdays,outArea reqstyle from uf_workout x where reqman='"+userCndID+"'   and exists(select id from requestbase where isfinished=1 and id=x.requestid) and convert(varchar(4),cast(actualbegindate as datetime),120)='"+yearcnd+"'";
	List outList = ds.getValues(sql);


	sql ="select title,reqman,requestid,begindate,begintime,enddate,endtime,totalDays reqdays from uf_overtime x where reqman='"+userCndID+"' and convert(varchar(4),cast(begindate as datetime),120)='"+yearcnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by begindate";
	List overList = ds.getValues(sql);

	int size2=holidaysList.size();
	int size4=outList.size();
	int size5=overList.size();

	for(j=1;j<13;j++){
		String monthbeg=yearcnd+"-"+add0(j,2)+"-01";
		String monthend=yearcnd+"-"+add0(j,2)+"-32";
		String where=" and (y.startdate between '"+monthbeg+"' and '"+monthend+"' or y.enddate between '"+monthbeg+"' and '"+monthend+"')";
		//sql="select t.requestid,t.objname,t.teacher,t.starttime,t.endtime,t.cource courseid,t.startdatea,t.enddatea from (select x.requestid,x.objname,x.cource,y.teacher,x.status,x.startdate startdatea,x.datetime enddatea,y.startdate starttime,y.enddate endtime from uf_training x,uf_trainingteacher y where x.requestid=y.requestid and y.teacher='"+userCndID+"'  "+where+" and exists(select id from requestbase where id=x.requestid and isdelete=0) and x.status in ('40288148264c135a01264c31cbc00026','40288148264c135a01264c31cbc00028','4028803d27564fde012756b0b95f00c6')  ) t order by starttime";
		//List meetList = ds.getValues(sql);
		//int size1=meetList.size();
		buf.append("<tr height=25>");
		for(i=0;i<32;i++){
			canlink=0 ;
			bgcolor="white";
			tempids.clear() ;
			tempdiffids.clear() ;
				
			tempstartdates.clear() ;
			tempenddates.clear() ;
			tempstarttimes.clear() ;
			tempendtimes.clear() ;
			tempsubjects.clear() ;
			if(i==0){
				bgcolor="white";
				canlink=0;
				if(j==1) innertext="1"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==2) innertext="2"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==3) innertext="3"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==4) innertext="4"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==5) innertext="5"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==6) innertext="6"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==7) innertext="7"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==8) innertext="8"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==9) innertext="9"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==10) innertext="10"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==11) innertext="11"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
				if(j==12) innertext="12"+labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028");//月
			}
			else  
			{
				boolean isweekend=false;
				boolean isholiday=false;
				innertext="&nbsp;";
				tempday.clear();
				tempday.set(Integer.valueOf(currentdate.substring(0,4)),j-1,i);
				if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)&&i>0) {bgcolor=color1;isweekend=true;}
				if((tempday.getTime().getMonth()!=(j-1))&&i>0) 
				{ 
					bgcolor=color2;canlink=1;
					
				}
				if(!bgcolor.equals(color2)){
					thenowday=add0(tempday.get(Calendar.YEAR), 4) +"-"+add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
					for(int k=0 ; k<size2 ; k++) {
						Map m = (Map)holidaysList.get(k);
						String tempdatefrom = StringHelper.null2String(m.get("date1"),"0") ;
						String daytype = StringHelper.null2String(m.get("daytype"));
						String isholiday1 = StringHelper.null2String(m.get("isholiday"));
						String isworkday = StringHelper.null2String(m.get("isworkday"));
						if(thenowday.compareToIgnoreCase(tempdatefrom) !=0 ) continue ;
						if(isholiday1.equals("1"))
						{
							isholiday=true;
							innertext="<div style=\"background-color:"+color3+";width:100%;height:12\">&nbsp;</div>";
							thenowday+="&#13;"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0004");//节假日
							if(isweekend)isweekend=false;

						}
						else if(isweekend&&isworkday.equals("1")&&daytype.equals("2"))isweekend=false;
						
						break;

					}
					
					/*for(int k=0 ; k<size1 ; k++) {
						Map m = (Map)meetList.get(k);
						String tempdatefrom = StringHelper.null2String(m.get("starttime"),"0") ;
						String tempdateto = StringHelper.null2String(m.get("endtime"),"0") ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
						
						innertext="<div style=\"background-color:"+color4+";width:100%;height:12\">&nbsp;</div>";
						if(isweekend)
						{
							innertext="<div style=\"background-color:"+color2+";width:50%;height:12\">&nbsp;</div><div style=\"background-color:"+color4+";width:50%;height:12\">&nbsp;</div>";
							overTimeDaysYear++;
						}
						else if(isholiday)
						{
							innertext="<div style=\"background-color:"+color3+";width:50%;height:12\">&nbsp;</div><div style=\"background-color:"+color4+";width:50%;height:12\">&nbsp;</div>";
							overTimeDaysYear++;
						}
						String startdatea = StringHelper.null2String(m.get("startdatea"),"0") ;
						String enddatea = StringHelper.null2String(m.get("enddatea"),"0") ;
						String objname = StringHelper.null2String(m.get("objname")) ;
						String course = getBrowserDicValues("uf_course","requestid","objname",StringHelper.null2String(m.get("courseid"),"0")) ;
						thenowday+="&#13;培训："+objname+"&#13;"+"日期："+startdatea+"至"+enddatea+"&#13;"+"课程："+course;
						break;
					}*/

					for(int k=0 ; k<size3 ; k++) {
						Map m = (Map)leaveList.get(k);
			
						String tempdatefrom = StringHelper.null2String(m.get("begindate"),"0") ;
						String tempdateto = StringHelper.null2String(m.get("enddate"),"0") ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
						String reqstyle = StringHelper.null2String(m.get("reqstyle")) ;

						double adjustDays=0;
						//调休判断
						if(reqstyle.equals("402880982773f2390127743da22200a9"))
						{
							adjustDays=Double.valueOf(StringHelper.null2String(m.get("reqDays"),"0") );
							//continue;
						}
						if(isweekend||isholiday)continue;
						//if(adjustDays>0)
						//{
							
						//	innertext="<div style=\"background-color:"+color6+";width:100%;height:12\">&nbsp;</div>";
							//adjustDays=adjustDays-1;
						//}
						//else
						//{
							if(reqstyle.equals("402880982773f2390127743da22200aa"))
								innertext="<div style=\"background-color:"+color5+";width:100%;height:12\">&nbsp;</div>";
							else if (reqstyle.equals("402880982773f2390127743da22200a9"))
                                   innertext="<div style=\"background-color:"+color6+";width:100%;height:12\">&nbsp;</div>";
							else
								innertext="<div style=\"background-color:"+color7+";width:100%;height:12\">&nbsp;</div>";
						//}
						String startdatea = StringHelper.null2String(m.get("startdatea"),"0") ;
						String enddatea = StringHelper.null2String(m.get("enddatea"),"0") ;
						String objname = StringHelper.null2String(m.get("title")) ;
						String reqstylename = getSelectDicValue(reqstyle) ;
						thenowday+="&#13;"+labelService.getLabelNameByKeyId("402883d934c04a450134c04a465d0000")+"："+objname+"&#13;"+""+labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")+"："+tempdatefrom+""+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000e")+tempdateto+"&#13;"+labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026")+"："+reqstylename;//请假//日期//至//类型
						break;
					}

					//出差
					for(int k=0 ; k<size4 ; k++) {
						Map m = (Map)outList.get(k);
			
						String tempdatefrom = StringHelper.null2String(m.get("begindate"),"0") ;
						String tempdateto = StringHelper.null2String(m.get("enddate"),"0") ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
						innertext="<div style=\"background-color:"+color8+";width:100%;height:12\">&nbsp;</div>";
						String startdatea = StringHelper.null2String(m.get("begindate"),"0") ;
						String enddatea = StringHelper.null2String(m.get("enddate"),"0") ;
						String objname = StringHelper.null2String(m.get("title")) ;
						thenowday+="&#13;"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000c")+"："+objname+"&#13;"+labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")+"："+tempdatefrom+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000e")+tempdateto+"&#13;";//出差//日期//至
						break;
					}
					//加班
					for(int k=0 ; k<size5 ; k++) {
						Map m = (Map)overList.get(k);
			
						String tempdatefrom = StringHelper.null2String(m.get("begindate"),"0") ;
						String tempdateto = StringHelper.null2String(m.get("enddate"),"0") ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;

						innertext="<div style=\"background-color:"+color4+";width:100%;height:12\">&nbsp;</div>";
						String startdatea = StringHelper.null2String(m.get("begindate"),"0") ;
						String enddatea = StringHelper.null2String(m.get("enddate"),"0") ;
						String objname = StringHelper.null2String(m.get("title")) ;
						thenowday+="&#13;"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000d")+"："+objname+"&#13;"+labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")+"："+tempdatefrom+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000e")+tempdateto+"&#13;";//加班//日期//至
						break;
					}
				}
			}

			buf.append("<TD bgColor="+bgcolor+"  " ); 
			if(canlink==0) { 
				if(i!=0) 
				{
					buf.append(" title="+thenowday+"");  
				}
			} else 
			{
				buf.append(" title='"+title+"' "); 
			}
			buf.append(">"); 
			buf.append(innertext);
			buf.append("</TD>");
		}	
		buf.append("</tr>");
	}
	buf.append("</table>");
	buf.append("</td>");
	buf.append("</tr>");
	buf.append("</table>");
	out.println(buf.toString());
%>
  <br>
  <br>
<%

double extintfield1 =0.0;
double usenums =0.0;
double leftnums =0.0;
List ls=null;
sql="select hlds,hlds-hasnum-hasnum1 leftnum,hasnum from (select hlds,isnull((select sum(theYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and  (convert(varchar(4),beginDate,120)= h.atyear) and beginDate  between h.begindate and h.enddate),0) hasnum,isnull((select sum(prevYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (convert(varchar(4),beginDate,120)= convert(varchar(4),h.atyear+1)) and beginDate  between h.begindate and h.enddate),0) hasnum1 from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and t.objid='"+userCndID+"'  and  convert(varchar(4),h.atyear+1)='"+yearcnd+"') n ";
ls = ds.getValues(sql);
if(ls.size()>0)
{
	Map m = (Map)ls.get(0);
	leftnums = Double.valueOf(m.get("leftnum").toString());
}

sql="select hlds,hlds-hasnum leftnum,hasnum from (select hlds,isnull((select sum(theYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (convert(varchar(4),beginDate,120)=convert(varchar(4), h.atyear)) and beginDate  between h.begindate and h.enddate),0) hasnum from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and convert(varchar(4),t.hyear)='"+yearcnd+"' and t.objid='"+userCndID+"') n   ";
ls =ds.getValues(sql);
if(ls.size()>0)
{
	Map m = (Map)ls.get(0);
	extintfield1 = Double.valueOf(m.get("hlds").toString());
	leftnums = leftnums+Double.valueOf(m.get("leftnum").toString());
	usenums = Double.valueOf(m.get("hasnum").toString());
}

%>
<table><tr><td valign="top">
<fieldset width="100%"><legend><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f000a")%></legend><!-- 年假信息 -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="50%" />
	<col width="50%" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000b")%>：</td><td colspan="1" align="center" rowspan="1" ><%=extintfield1%></td><!-- 本年年假天数 -->
   </tr>
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000c")%>：</td><td colspan="1" align="center" rowspan="1" ><%=usenums%></td><!-- 已使用年假天数 -->
	 <tr style="background:#E0ECFC;border:1px solid #c3daf9;">
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000d")%>：</td><td colspan="1" align="center" rowspan="1" ><%=leftnums%></td><!-- 年假剩余可用天数 -->
  </tr></table></fieldset>

<%

  StringBuffer buf1 = new StringBuffer();
	double adjustDaysYear=0;
	double reqDaysYear=0;
	for(int k=0 ; k<size3 ; k++) {
		Map m = (Map)leaveList.get(k);
		String reqstyle = StringHelper.null2String(m.get("reqstyle")) ;
		String objname = StringHelper.null2String(m.get("title")) ;
		String begindate = StringHelper.null2String(m.get("begindate")) ;
		String enddate = StringHelper.null2String(m.get("enddate")) ;
		double adjustDays=Double.valueOf(StringHelper.null2String(m.get("reqdays")) );
		adjustDaysYear=adjustDaysYear+adjustDays;	
		double reqDays=Double.valueOf(m.get("reqdays").toString());
		reqDaysYear=reqDaysYear+reqDays;	
		buf1.append("<tr style=\"height:25;\" "+(k%2==0?"bgcolor=\"#ECEBEA\"":"")+" >");
		buf1.append("<td align=\"center\">"+objname+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(reqstyle)+"</td>");
		buf1.append("<td align=\"center\">"+begindate+" - "+enddate+"</td>");
		buf1.append("<td align=\"center\">"+reqDays+"</td>");
		buf1.append("</tr>");
	}
	buf1.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf1.append("<td height=\"25\" colspan=\"3\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")+"</b></td>");//合计
	buf1.append("<td colspan=\"1\"  align=\"right\"><b>"+reqDaysYear+"</b></td>");
	buf1.append("</tr>");
%>
<%

  StringBuffer buf2 = new StringBuffer();
	double outdays=0;
	for(int k=0 ; k<size4 ; k++) {
		Map m = (Map)outList.get(k);
		String reqstyle = StringHelper.null2String(m.get("reqstyle")) ;
		String objname = StringHelper.null2String(m.get("title")) ;
		String begindate = StringHelper.null2String(m.get("begindate")) ;
		String enddate = StringHelper.null2String(m.get("enddate")) ;
		double reqDays=Double.valueOf(StringHelper.null2String(m.get("reqdays")) );
		outdays=outdays+reqDays;	
		buf2.append("<tr style=\"height:25;\" "+(k%2==0?"bgcolor=\"#ECEBEA\"":"")+" >");
		buf2.append("<td align=\"center\">"+objname+"</td>");
		buf2.append("<td align=\"center\">"+getSelectDicValue(reqstyle)+"</td>");
		buf2.append("<td align=\"center\">"+begindate+" - "+enddate+"</td>");
		buf2.append("<td align=\"center\">"+reqDays+"</td>");
		buf2.append("</tr>");
	}
	buf2.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf2.append("<td height=\"25\" colspan=\"3\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")+"</b></td>");//合计
	buf2.append("<td colspan=\"1\"  align=\"right\"><b>"+outdays+"</b></td>");
	buf2.append("</tr>");
%>
<%

  StringBuffer buf3 = new StringBuffer();
	double overdays=0;
	for(int k=0 ; k<size5 ; k++) {
		Map m = (Map)overList.get(k);
		
		String objname = StringHelper.null2String(m.get("title")) ;
		String begindate = StringHelper.null2String(m.get("begindate")) ;
		String enddate = StringHelper.null2String(m.get("enddate")) ;	
		double reqDays=Double.valueOf(m.get("reqdays").toString());
		overdays=overdays+reqDays;		
		buf3.append("<tr style=\"height:25;\" "+(k%2==0?"bgcolor=\"#ECEBEA\"":"")+" >");
		buf3.append("<td align=\"center\">"+objname+"</td>");
		
		buf3.append("<td align=\"center\">"+begindate+" - "+enddate+"</td>");
		buf3.append("<td align=\"center\">"+reqDays+"</td>");
		buf3.append("</tr>");
	}
	buf3.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf3.append("<td height=\"25\" colspan=\"2\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")+"</b></td>");//合计
	buf3.append("<td colspan=\"1\"  align=\"right\"><b>"+overdays+"</b></td>");
	buf3.append("</tr>");
%>
<%
	double jbnum=0.0;
	double hasnum=0.0;
	sql="select isnull(sum(totalDays),0.0) jbdays from uf_overtime m where reqMan='"+userCndID+"' and exists(select id from requestbase where isdelete=0 and id=m.requestid and isfinished=1)";
		ls =ds.getValues(sql);
		if(ls.size()>0)
		{
			Map m = (Map)ls.get(0);
			jbnum = Double.valueOf(m.get("jbdays").toString());
		}
		sql="select isnull(sum(actualDays),0.0) hasnum from uf_leave m where reqStyle='402880982773f2390127743da22200a9' and reqMan='"+userCndID+"' and exists(select id from requestbase where isdelete=0 and id=m.requestid)";
		ls =ds.getValues(sql);
		if(ls.size()>0)
		{
			Map m = (Map)ls.get(0);
			hasnum = Double.valueOf(m.get("hasnum").toString());
		}

%>
<br>
  <fieldset width="100%"><legend><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000f")%></legend><!-- 调休信息 -->
	<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="50%" />
	<col width="50%" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c087390134c0873a750000")%>：</td><td colspan="1" align="center" rowspan="1" ><%=jbnum%></td><!-- 加班总天数 -->
   </tr>
   <tr ><td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c089070134c08907920000")%>：</td><td colspan="1" align="center" rowspan="1" ><%=hasnum%></td></tr><!-- 已请调休天数 -->
	 <tr >
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c089070134c08907920000")%>：</td><td colspan="1" align="center" rowspan="1" ><%=(jbnum-hasnum)%></td><!-- 已请调休天数 -->
  </tr></table></fieldset>
  <br>

    <fieldset width="100%"><legend><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000f")%></legend><!-- 加班记录 -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="50%" />
	<col width="35%" />
	<col width="15%" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;" height="25">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%></td><!-- 标题 -->
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0001")%></td><!-- 日期范围 -->
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0002")%></td><!-- 天数 -->
  </tr>
  <%out.println(buf3.toString());%>
  </table>
  
  </fieldset>
</td><td valign="top">
<fieldset width="100%"><legend><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0000")%></legend><!-- 请假记录 -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="35%" />
	<col width="15%" />
	<col width="35%" />
	<col width="15%" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;" height="25">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%></td><!-- 标题 -->
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c029810134c02981cf0000")%></td><!-- 请假类型 -->
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0001")%></td><!-- 日期范围 -->
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0002")%></td><!-- 天数 -->
  </tr>
  <%out.println(buf1.toString());%>
  </table>
  
  </fieldset>
  <fieldset width="100%"><legend><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50010")%></legend><!-- 出差记录 -->
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="35%" />
	<col width="15%" />
	<col width="35%" />
	<col width="15%" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;" height="25">
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%></td><!-- 标题 -->
	 <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50011")%></td><!-- 出差类型 -->
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0001")%></td><!-- 日期范围 -->
	  <td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0002")%></td><!-- 天数 -->
  </tr>
  <%out.println(buf2.toString());%>
  </table>
  
  </fieldset>
  </td></tr></table>
</form>
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
<script language=javascript>
function submitData() {
 frmMain.submit();
}
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	document.frmmain.submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	document.frmmain.submit() ;
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowMONTH() {
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowWeek() {
	document.frmmain.bywhat.value = "3" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowDay() {
	document.frmmain.bywhat.value = "4" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
</script>

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
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
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
			isweekend=true;
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         