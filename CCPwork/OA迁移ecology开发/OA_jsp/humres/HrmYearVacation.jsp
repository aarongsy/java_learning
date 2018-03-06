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
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "test";
String needfav ="1";
String needhelp ="";
boolean isfromtab =  false;
String leavetype = "";
String otherleavetype = "";
String leavesqlwhere = "";
String currentdate =  "2010-03-26";
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);
int currentmonth=today.get(Calendar.MONTH)+1;  
int currentday=today.get(Calendar.DATE);  
int yearcnd=currentyear;
String yearcnd1 = request.getParameter("yearcnd");
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
String color4="#CC00FF";//培训
String color5="#33FF66";//年假
String color6="#CCFF00";//调休
String color7="#669999";//其他请假
String htmlstr="";
%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
</head>
<style type=text/css>.TH {
	CURSOR: auto; BACKGROUND-COLOR: beige
}
.PARENT {
	CURSOR: auto
}
.TH1 {
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
    <TR class=Title> 
      <TH colspan=4><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0000")%></TH><!-- 我的考勤视图 -->
    </TR>
    <TR class=Spacing> 
      <TD CLASS=Sep1 colspan=4></TD>
    </TR>
	<tr style="height:15">
	<td colspan=1 align=right style="height:15;text-align:left">
	<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001")%><!-- 年度 -->:&nbsp;&nbsp;<select name="yearcnd" style="height:10;width:60;font-size:11" >
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
			<tr><td bgcolor="<%=color4%>" width="15" style="border-width:1;height:15"></td></tr>
			</table>
			</td><td>
			&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0005")%><!-- 培训 -->
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
	String sql="select date1,isholiday,isworkday,daytype from holidaysinfo";
	List holidaysList = ds.getValues(sql);
	int size2=holidaysList.size();
	for(j=1;j<13;j++){
		String where="";
		sql="select t.requestid,t.objname,t.teacher,t.starttime,t.endtime,t.cource courseid,t.startdatea,t.enddatea from (select x.requestid,x.objname,x.cource,y.teacher,x.status,x.startdate startdatea,x.datetime enddatea,y.startdate starttime,y.enddate endtime from uf_training x,uf_trainingteacher y where x.requestid=y.requestid "+where+" and exists(select id from requestbase where id=x.requestid and isdelete=0) and x.status in ('40288148264c135a01264c31cbc00026','40288148264c135a01264c31cbc00028','4028803d27564fde012756b0b95f00c6')  ) t order by starttime";
		List meetList = ds.getValues(sql);
		int size1=meetList.size();
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
				innertext="&nbsp;";
				tempday.clear();
				tempday.set(Integer.valueOf(currentdate.substring(0,4)),j-1,i);
				if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)&&i>0) {bgcolor=color1;}
				if((tempday.getTime().getMonth()!=(j-1))&&i>0) 
				{ 
					bgcolor=color2;canlink=1;
				}
				if(!bgcolor.equals(color2)){
					thenowday=add0(tempday.get(Calendar.YEAR), 4) +"-"+add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
					for(int k=0 ; k<size2 ; k++) {
						Map m = (Map)holidaysList.get(k);
						String tempdatefrom = StringHelper.null2String(m.get("date1"),"0") ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) !=0 ) continue ;
						innertext="<div style=\"background-color:"+color3+";width:100%;height:12\">&nbsp;</div>";
						thenowday+="&#13;"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0004");//节假日
					}
					for(int k=0 ; k<size1 ; k++) {
						Map m = (Map)meetList.get(k);
						String tempdatefrom = StringHelper.null2String(m.get("starttime"),"0") ;
						String tempdateto = StringHelper.null2String(m.get("endtime"),"9") ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
						innertext="<div style=\"background-color:"+color4+";width:100%;height:12\">&nbsp;</div>";
						String startdatea = StringHelper.null2String(m.get("startdatea"),"0") ;
						String enddatea = StringHelper.null2String(m.get("enddatea"),"0") ;
						String objname = StringHelper.null2String(m.get("objname")) ;
						String course = getBrowserDicValues("uf_course","requestid","objname",StringHelper.null2String(m.get("courseid"),"0")) ;
						thenowday+="&#13;"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0005")+"："+objname+"&#13;"+""+labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")+"："+startdatea+""+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000e")+""+enddatea+"&#13;"+labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0009")+"："+course;//培训//日期//至//课程
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
Calendar annualtoday = Calendar.getInstance(); 
String nowdate = "2010" + "-" + "03" + "-" + "26";
%>

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

%>
