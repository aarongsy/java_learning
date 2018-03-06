<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.eweaver.app.dccm.timediff.DM_TimeDiffAction"%>
<%@ page import="java.math.*"%>


<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String empid = StringHelper.null2String(request.getParameter("empid"));//empid
String comtype = StringHelper.null2String(request.getParameter("comtype"));//comtype
String sdate = StringHelper.null2String(request.getParameter("sdate"));//sdate
String s1 = StringHelper.null2String(request.getParameter("s1"));//s1
String edate = StringHelper.null2String(request.getParameter("edate"));//edate
String s2 = StringHelper.null2String(request.getParameter("s2"));//s2
String action = StringHelper.null2String(request.getParameter("action"));//action: search show
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
DM_TimeDiffAction app = new DM_TimeDiffAction();

%>
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 30px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
<table id="ShiftTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Serial No.&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Date&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Schedule No&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Working Time Start At&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Working Time End At&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Break Time Start At&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Break Time End At&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>Working Duration(H)</TD>
<TD  noWrap class="td2"  align=center>Is Public Rest</TD>
<TD  noWrap class="td2"  align=center>Friday</TD>
<TD  noWrap class="td2"  align=center>Travel Working Days</TD>
<TD  noWrap class="td2"  align=center>Travel Working Hours</TD>
</TR>

<%
if (  "".equals(requestid) ) {
	action = "search";
}
if ( "show".equals(action) ) {
	String sql ="";
	sql = "select sno,thedate,schno,wstime,wetime,wrstime,wretime,workrhours,isrstd,friday,wdays,wdayhours from uf_dmhr_travelshift where requestid='"+requestid+"' order by sno asc";
	List list = baseJdbc.executeSqlForList(sql);
	String firstschdate = "";
	String firstschtime = "";
	String endschdate = "";
	String endschtime = "";
	String message = "";
	
	if(list.size()>0){	
		BigDecimal totalwdays = new BigDecimal(0);
		BigDecimal totalwhours = new BigDecimal(0);
		BigDecimal totalworkrhours = new BigDecimal(0);
		

		for(int k=0,sizek=list.size();k<sizek;k++){			
			Map mk = (Map)list.get(k);		
			String sno=StringHelper.null2String(mk.get("sno"));
			String thedate=StringHelper.null2String(mk.get("thedate"));
			String schno=StringHelper.null2String(mk.get("schno"));
			String wstime=StringHelper.null2String(mk.get("wstime"));
			String wetime=StringHelper.null2String(mk.get("wetime"));
			String wrstime=StringHelper.null2String(mk.get("wrstime"));
			String wretime=StringHelper.null2String(mk.get("wretime"));
			String workrhours = StringHelper.null2String(mk.get("workrhours"));			
			String isrstd=StringHelper.null2String(mk.get("isrstdtxt"));
			String friday=StringHelper.null2String(mk.get("friday"));
			String wdays = StringHelper.null2String(mk.get("wdays"));
			String wdayhours = StringHelper.null2String(mk.get("wdayhours"));
			if( k==0) {
				firstschdate = wstime.split(" ")[0];
				firstschtime = wstime;
			}
			endschdate = wetime.split(" ")[0];;
			endschtime = wetime;
			totalworkrhours = totalworkrhours.add(new BigDecimal(workrhours));
			totalwhours = totalwhours.add(new BigDecimal(wdayhours));
			totalwdays = totalwdays.add(new BigDecimal(wdays));	
			%>
				<TR id="dataDetail" height="30">
				<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=sno %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=thedate %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=schno %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wstime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wetime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wrstime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wretime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=workrhours %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=isrstd %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=friday %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wdays %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wdayhours %>&nbsp;&nbsp;</TD>			
				</TR>
			<%
		}
		if ( !firstschdate.equals(endschdate) && (app.diffmin(s1,firstschtime,"datetime",0).intValue()<0 || app.diffmin(s2,endschtime,"datetime",0).intValue()>0) ) {
				message = "Employee Schedule Plan is lacked, please check! ";
		}
		%>
		
		<TR  id="dataDetail" height="30">
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Total&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center><input type="hidden" id="field_firstschdate" name="field_firstschdate"  value="<%=firstschdate %>"  ><input type="hidden" id="field_firstschtime" name="field_firstschtime"  value="<%=firstschtime %>"  ></TD>
		<TD  noWrap class="td2"  align=center><input type="hidden" id="field_endschdate" name="field_endschdate"  value="<%=endschdate %>"  ><input type="hidden" id="field_endschtime" name="field_endschtime"  value="<%=endschtime %>"  ></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<%=totalworkrhours %>&nbsp;H&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totalwdays" name="field_totalwdays"  value="<%=totalwdays %>"  ><span  id="field_totalwdaysspan" name="field_totalwdaysspan" ><%=totalwdays %></span>&nbsp;Days&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totalwhours" name="field_totalwhours"  value="<%=totalwhours %>"  ><span  id="field_totalwhoursspan" name="field_totalwhoursbspan" ><%=totalwhours %></span>&nbsp;H&nbsp;&nbsp;</TD>
		</TR>
		<TR id="dataDetail" style=<%=("".equals(message)?"display:none":"display:block") %> >
		<TD noWrap class="td2"  align=left colspan="12"><span id="shifinfoerr"><font color="red"><%=message %></font></span></TD>
		</TR>	
		<%	
	}else{%> 
		<TR><TD class="td2" colspan="34"><span id="shifinfoerr"><font color="red">No shift infomation, please check!</font></span></TD></TR>
		<TR style="display:none"><TD class="td2" colspan="34"><input type="hidden" id="field_firstschdate" name="field_firstschdate"  value="<%=firstschdate %>"  ><input type="hidden" id="field_firstschtime" name="field_firstschtime"  value="<%=firstschtime %>"  ><input type="hidden" id="field_endschdate" name="field_endschdate"  value="<%=endschdate %>"  ><input type="hidden" id="field_endschtime" name="field_endschtime"  value="<%=endschtime %>"  ></TD></TR>		
		<TR style="display:none"><TD class="td2" colspan="34"><input type="hidden" id="field_totalwdays" name="field_totalwdays"  value=""><input type="hidden" id="field_totalwhours" name="field_totalwhours"  value=""></TD></TR>	
	<%} 
}
if ( "search".equals(action) ) {
	if ( !"".equals(requestid) ) {
		String delsql = "delete from uf_dmhr_travelshift where requestid='"+requestid+"'";	
		baseJdbc.update(delsql);
	}
	String sql ="";
	if ( "".equals(edate) ) {
		sql = "select a.requestid,a.schno,a.schname,a.schnametxt,a.friday,a.isrstd,(select labelname from LABELCUSTOM where language='en_US' and keyword=a.isrstd )  isrstdtxt,b.stime,b.etime,b.whours,b.rstime,b.retime,b.rhours,b.fstime,b.fetime,b.fwhours,b.frstime,b.fretime,b.frhours,a.thedate,to_char(to_date(a.thedate,'yyyy-MM-dd')-1,'yyyy-MM-dd') yestoday,to_char(to_date(a.thedate,'yyyy-MM-dd')+1,'yyyy-MM-dd') tomorrow from uf_dmhr_classplan a left join uf_dmhr_classinfo b on a.schname=b.requestid and b.isvalid='40288098276fc2120127704884290210' and exists(select 1 from formbase where id=b.requestid and isdelete=0) where a.jobname='"+empid+"' and a.comtype like '%"+comtype+"%' and to_date(a.thedate,'yyyy-MM-dd') between to_date('"+sdate+"','yyyy-MM-dd')-1 and to_date('"+sdate+"','yyyy-MM-dd')+1 order by a.thedate asc"; 
	} else {
		sql = "select a.requestid,a.schno,a.schname,a.schnametxt,a.whours,a.friday,a.isrstd,(select labelname from LABELCUSTOM where language='en_US' and keyword=a.isrstd )  isrstdtxt,b.stime,b.etime,b.rstime,b.retime,b.rhours,b.fstime,b.fetime,b.fwhours,b.frstime,b.fretime,b.frhours,a.thedate,to_char(to_date(a.thedate,'yyyy-MM-dd')-1,'yyyy-MM-dd') yestoday,to_char(to_date(a.thedate,'yyyy-MM-dd')+1,'yyyy-MM-dd') tomorrow from uf_dmhr_classplan a left join uf_dmhr_classinfo b on a.schname=b.requestid and b.isvalid='40288098276fc2120127704884290210' and exists(select 1 from formbase where id=b.requestid and isdelete=0) where a.jobname='"+empid+"' and a.comtype like '%"+comtype+"%' and to_date(a.thedate,'yyyy-MM-dd') between to_date('"+sdate+"','yyyy-MM-dd')-1 and to_date('"+edate+"','yyyy-MM-dd')+1 order by a.thedate asc";  
	}

	String schsdate = "";
	String schedate = "";

	String firstschdate = "";
	String firstschtime = "";
	String endschdate = "";
	String endschtime = "";
	String message = "";

	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		int i=0;

		BigDecimal totalwdays = new BigDecimal(0);
		BigDecimal totalwhours = new BigDecimal(0);
		BigDecimal totalworkrhours = new BigDecimal(0);
		for(int k=0,sizek=list.size();k<sizek;k++){
			if ( !"".equals(schedate) ) {
				break;
			}
			Map mk = (Map)list.get(k);		
			String schreqid=StringHelper.null2String(mk.get("requestid"));
			String schno=StringHelper.null2String(mk.get("schno"));
			String schname=StringHelper.null2String(mk.get("schname"));
			String thedate=StringHelper.null2String(mk.get("thedate"));
			String isrstd=StringHelper.null2String(mk.get("isrstdtxt"));
			String friday=StringHelper.null2String(mk.get("friday"));
			String yestoday=StringHelper.null2String(mk.get("yestoday"));
			String tomorrow=StringHelper.null2String(mk.get("tomorrow"));
			String whours=StringHelper.null2String(mk.get("whours"));
			
			String stime = StringHelper.null2String(mk.get("stime"));
			String etime = StringHelper.null2String(mk.get("etime"));
			String rstime = StringHelper.null2String(mk.get("rstime"));
			String retime = StringHelper.null2String(mk.get("retime"));
			String rhours = StringHelper.null2String(mk.get("rhours"));
			
			String fstime = StringHelper.null2String(mk.get("fstime"));
			String fetime = StringHelper.null2String(mk.get("fetime"));
			String frstime = StringHelper.null2String(mk.get("frstime"));
			String fretime = StringHelper.null2String(mk.get("fretime"));
			String frhours = StringHelper.null2String(mk.get("frhours"));
			
			String wstime = "";
			String wetime = "";
			String wrstime = "";
			String wretime = "";
			String workrhours = "";
			String restrhours = "";
			Boolean schflag = false;
			BigDecimal wdays = new BigDecimal(0);	//实际出差工作天数
			BigDecimal wdayhours = new BigDecimal(0);	//实际出差工作时数
			
			if ( !"OFFD".equals(schno) && !"RSTD".equals(schno) ){	//isrstd!='40288098276fc2120127704884290210' 法定休假日的话，要如何处理？  
				if ( "A".equals(friday) && !"".equals(fstime) ) {
					wstime = fstime;
					wetime = fetime;				
					wrstime = frstime;
					wretime = fretime;
					workrhours = whours;
					restrhours = rhours;
				} else {
					wstime = stime;
					wetime = etime;				
					wrstime = rstime;
					wretime = retime;
					workrhours = whours;
					restrhours = frhours;
				}
				
				if ( app.diffmin(wstime,wetime,"time",0).intValue() >0 ) {//.doubleValue()
					wstime = thedate + " "+ wstime;
					wetime = tomorrow + " "+ wetime;
				} else {
					wstime = thedate + " "+ wstime;
					wetime = thedate + " "+ wetime;
				}
				if( !"".equals(wrstime) && !"".equals(wretime)) {
					if ( app.diffmin(wrstime,wretime,"time",0).intValue() >0 ) {
						wrstime = thedate + " "+ wrstime;
						wretime = tomorrow + " "+ wretime;
					} else {
						wrstime = thedate + " "+ wrstime;
						wretime = thedate + " "+ wretime;
					}
				}
			} else {
				wstime = thedate +" 00:00:00";     
				wetime = tomorrow + " 00:00:00";
				workrhours = "0";
			}
			
			if ( !"".equals(s1) ) {
				if ( app.diffmin(s1,wstime,"datetime",0).intValue()>=0 && app.diffmin(s1,wetime,"datetime",0).intValue()<0 ) { //有效的班次
					if ( "".equals(schsdate) ) {	//获取第一个班次开始日期
						schsdate = thedate;
						schflag = true;
					}
					if ( "".equals(edate) || "".equals(s2) ) { 
						schedate = "";
						break; 
					}
					//计算第一个工作日的时数
					if ( schflag && !"OFFD".equals(schno) && !"RSTD".equals(schno) && !"".equals(workrhours)  && !"0".equals(workrhours)){	//isrstd!='40288098276fc2120127704884290210' 法定休假日的话，要如何处理？
						if( !"".equals(wrstime) && !"".equals(wretime)) {	//含休息时间
							if ( app.diffmin(s1,wrstime,"datetime",0).intValue()<0  ) { //开始时间为上半天
								if ( app.diffmin(s2,wetime,"datetime",0).intValue()>0 ) {	//结束时间大于第一个班次的结束时间
									wdayhours = app.diffhour(wetime,s1,"datetime",3);								
									wdayhours = wdayhours.subtract(new BigDecimal(restrhours));
									//System.out.println("1 wdayhours=" +wdayhours);
								} else if ( app.diffmin(s2,wretime,"datetime",0).intValue() >0 ){ //结束时间在下半天
									wdayhours = app.diffhour(s2,s1,"datetime",3);							
									wdayhours = wdayhours.subtract(new BigDecimal(restrhours));
									//System.out.println("2 wdayhours=" +wdayhours);
								} else if ( app.diffmin(s2,wrstime,"datetime",0).intValue() <=0 ){ //结束时间在上半天
									wdayhours = app.diffhour(s2,s1,"datetime",3);								
									//System.out.println(3);
								} else {	//结束时间在休息
									wdayhours= app.diffhour(wrstime,s1,"datetime",3);								
									//System.out.println(4);
								}
							} else if ( app.diffmin(s1,wretime,"datetime",0).intValue()<=0  ) {  //位于休息时间
								if ( app.diffmin(s2,wetime,"datetime",0).intValue()>0 ) {	//结束时间大于第一个班次的结束时间
									wdayhours = new BigDecimal(workrhours);
									wdayhours = wdayhours.divide(new BigDecimal(2),2, BigDecimal.ROUND_HALF_UP);
									//System.out.println(5);								
								} else  if ( app.diffmin(s2,wretime,"datetime",0).intValue() >0 ){ //结束时间在下半天
									wdayhours= app.diffhour(s2,wretime,"datetime",3);								
									//System.out.println(6);	
								} 
							} else { //下半天
								if ( app.diffmin(s2,wetime,"datetime",0).intValue()>0 ) {	//结束时间大于第一个班次的结束时间
									wdayhours= app.diffhour(wetime,s1,"datetime",3);								
									System.out.println(7);
								} else {
									wdayhours= app.diffhour(s2,s1,"datetime",3);								
									//System.out.println(8);
								}
							}
						} else {	//不含休息时间
							if ( app.diffmin(s2,wetime,"datetime",0).intValue()>0 ) {	//结束时间大于第一个班次的结束时间
								wdayhours= app.diffhour(wetime,s1,"datetime",3);							
								//System.out.println(9);
							} else {
								wdayhours= app.diffhour(s2,s1,"datetime",3);							
								//System.out.println(10);
							}
						}
						wdays = wdayhours.divide(new BigDecimal(workrhours),2, BigDecimal.ROUND_HALF_UP);
						totalwhours = totalwhours.add(wdayhours);
						totalwdays = totalwdays.add(wdays);					
					} 

				} else {
					if ( "".equals(edate) || "".equals(s2) ) { 
						schedate = "";
						break;     
					}
					if ( app.diffmin(s1,wstime,"datetime",0).intValue()<0 && app.diffmin(s2,wstime,"datetime",0).intValue()>0 ) {
						schflag = true;
					}
					if ( app.diffmin(s2,wstime,"datetime",0).intValue()>=0 && app.diffmin(s2,wetime,"datetime",0).intValue()<=0 ) { //有效的班次
						schflag = true;
						schedate = thedate; //班次结束日期
					}
									
					//计算工作日的时数
					if (  schflag && !"OFFD".equals(schno) && !"RSTD".equals(schno) && !"".equals(workrhours) && !"0".equals(workrhours) ){	//isrstd!='40288098276fc2120127704884290210' 法定休假日的话，要如何处理？
						if( !"".equals(wrstime) && !"".equals(wretime)) {	//含休息时间
							if ( app.diffmin(s2,wetime,"datetime",0).intValue()>=0  ) { //含整天
								wdayhours = new BigDecimal(workrhours);
								wdays = new BigDecimal(1);
								//System.out.println(11);
							} else if (  app.diffmin(s2,wrstime,"datetime",0).intValue()<=0 ) { //上半天
								wdayhours= app.diffhour(s2,wstime,"datetime",3);							
								wdays = wdayhours.divide(new BigDecimal(workrhours),2, BigDecimal.ROUND_HALF_UP);
								//System.out.println(12);
							} else if ( app.diffmin(s2,wretime,"datetime",0).intValue()<=0 ) { //位于休息时间段
								wdayhours = new BigDecimal(workrhours);							
								wdayhours = wdayhours.divide(new BigDecimal(2),2, BigDecimal.ROUND_HALF_UP);
								wdays = new BigDecimal(0.5);
								//System.out.println(13);
							} else {	//位于下半天
								wdayhours= app.diffhour(s2,wstime,"datetime",3);							
								wdayhours = wdayhours.subtract(new BigDecimal(restrhours));
								wdays = wdayhours.divide(new BigDecimal(workrhours),2, BigDecimal.ROUND_HALF_UP);
								//System.out.println(14);
							}
						} else {	//不含休息时间
							if ( app.diffmin(s2,wetime,"datetime",0).intValue()>=0 ) {	//含整天
								wdayhours = new BigDecimal(workrhours);
								wdays = new BigDecimal(1);
								//System.out.println(15);
							} else {	//结束时间小于工作日结束时间
								wdayhours= app.diffhour(s2,wstime,"datetime",3);							
								wdays = wdayhours.divide(new BigDecimal(workrhours),2, BigDecimal.ROUND_HALF_UP);
								//System.out.println(16);
							}
						}					
						totalwhours = totalwhours.add(wdayhours);
						totalwdays = totalwdays.add(wdays);					
					} 
					
				}
			}
			if ( schflag ) {
				i++;
				if( i==1) {
					firstschdate = wstime.split(" ")[0];
					firstschtime = wstime;
				}
				endschdate = wetime.split(" ")[0];;
				endschtime = wetime;
				totalworkrhours = totalworkrhours.add(new BigDecimal(workrhours));
				%>
				<TR id="dataDetail" height="30">
				<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=i %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=thedate %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=schno %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wstime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wetime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wrstime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wretime %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=workrhours %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=isrstd %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=friday %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wdays %>&nbsp;&nbsp;</TD>
				<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wdayhours %>&nbsp;&nbsp;</TD>			
				</TR>
				<%
				if ( !"".equals(requestid) ) {
					String isql = "insert into uf_dmhr_travelshift  (id,requestid,sno,thedate,schno,wstime,wetime,wrstime,wretime,workrhours,isrstd,friday,wdays,wdayhours) values (sys_guid(),'"+requestid+"','"+i+"','"+thedate+"','"+schno+"','"+wstime+"','"+wetime+"','"+wrstime+"','"+wretime+"','"+workrhours+"','"+isrstd+"','"+friday+"','"+wdays+"','"+wdayhours+"')";
					baseJdbc.update(isql);
					
				}
			}
		}
		if ( !"".equals(requestid) ) {
			String ss1 = s1.split(" ")[0];
			String es1 = s1.split(" ")[1];
			String ss2 = s2.split(" ")[0];
			String es2 = s2.split(" ")[1];
			String upsql = " update uf_dmhr_travelapp set sdate='"+ss1+"',stime='"+es1+"',edate='"+ss2+"',etime='"+es2+"' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
		}
		if ( !firstschdate.equals(endschdate) && (app.diffmin(s1,firstschtime,"datetime",0).intValue()<0 || app.diffmin(s2,endschtime,"datetime",0).intValue()>0) ) {
			message = "Employee Schedule Plan is lacked, please check! ";
		}
		%>
		<TR  id="dataDetail" height="30">
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Total&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center><input type="hidden" id="field_firstschdate" name="field_firstschdate"  value="<%=firstschdate %>"  ><input type="hidden" id="field_firstschtime" name="field_firstschtime"  value="<%=firstschtime %>"  ></TD>
		<TD  noWrap class="td2"  align=center><input type="hidden" id="field_endschdate" name="field_endschdate"  value="<%=endschdate %>"  ><input type="hidden" id="field_endschtime" name="field_endschtime"  value="<%=endschtime %>"  ></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<%=totalworkrhours %>&nbsp;H&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totalwdays" name="field_totalwdays"  value="<%=totalwdays %>"  ><span  id="field_totalwdaysspan" name="field_totalwdaysspan" ><%=totalwdays %></span>&nbsp;Days&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totalwhours" name="field_totalwhours"  value="<%=totalwhours %>"  ><span  id="field_totalwhoursspan" name="field_totalwhoursbspan" ><%=totalwhours %></span>&nbsp;H&nbsp;&nbsp;</TD>
		</TR>
		<TR id="dataDetail" style=<%=("".equals(message)?"display:none":"display:block") %> >
		<TD noWrap class="td2"  align=left colspan="12"><span id="shifinfoerr"><font color="red"><%=message %></font></span></TD>
		</TR>
		<%
	}else{%> 
		<TR><TD class="td2" colspan="34"><span id="shifinfoerr"><font color="red">No shift infomation, please check!</font></span></TD></TR>
		<TR style="display:none"><TD class="td2" colspan="34"><input type="hidden" id="field_firstschdate" name="field_firstschdate"  value="<%=firstschdate %>"  ><input type="hidden" id="field_firstschtime" name="field_firstschtime"  value="<%=firstschtime %>"  ><input type="hidden" id="field_endschdate" name="field_endschdate"  value="<%=endschdate %>"  ><input type="hidden" id="field_endschtime" name="field_endschtime"  value="<%=endschtime %>"  ></TD></TR>		
		<TR style="display:none"><TD class="td2" colspan="34"><input type="hidden" id="field_totalwdays" name="field_totalwdays"  value=""><input type="hidden" id="field_totalwhours" name="field_totalwhours"  value=""></TD></TR>	
	<%} 
}%>
</table>
</div>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    