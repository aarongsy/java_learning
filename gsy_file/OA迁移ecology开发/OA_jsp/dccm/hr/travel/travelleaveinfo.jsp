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
String istw = StringHelper.null2String(request.getParameter("istw"));//istw
String empid = StringHelper.null2String(request.getParameter("empid"));//empid
String s1 = StringHelper.null2String(request.getParameter("s1"));//s1
String s2 = StringHelper.null2String(request.getParameter("s2"));//s2
String action = StringHelper.null2String(request.getParameter("action"));//action: search show delete
//System.out.println("1 requestid="+requestid+" istw="+istw +" empid="+empid+" s1="+s1+" s2="+s2+  " action="+action);
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");

if( "".equals(requestid) ) {
	action = "search";
} else {
	String deletesql = "";
	if( !"40288098276fc2120127704884290210".equals(istw) ) {
		action = "delete";
		deletesql = "delete from uf_dmhr_travelleave where requestid='"+requestid+"'";	
		baseJdbc.update(deletesql);
		return;
	}
	if ( "delete".equals(action) ) {
		deletesql = "delete from uf_dmhr_travelleave where requestid='"+requestid+"'";	
		baseJdbc.update(deletesql);
		return;
	}
}
if ( !"40288098276fc2120127704884290210".equals(istw)  ) {
	return;
}

//System.out.println("2 requestid="+requestid+" istw="+istw +" empid="+empid+" s1="+s1+" s2="+s2+  " action="+action);

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
<table id="LeaveTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
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
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Serial No.&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;LeaveApp Flow No.&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Employee No.&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Leave Type&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Leave Start At&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Leave End At&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Leave Total Hour&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Leave Total Days&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>Travel Working Hours</TD>
<TD  noWrap class="td2"  align=center>Travel Working Days</TD>
</TR>

<%

if ( "show".equals(action) ) {
	String message = "";
	String sql = "select sno,leaappno,jobno,leavetype,stime,etime,hours,days,whours,wdays from uf_dmhr_travelleave where requestid='"+requestid+"' order by sno asc";
	List list = baseJdbc.executeSqlForList(sql);	
	if(list.size()>0){
		BigDecimal totalhours = new BigDecimal(0);
		BigDecimal totaldays = new BigDecimal(0);
		BigDecimal totaltravelhours = new BigDecimal(0);
		BigDecimal totaltraveldays = new BigDecimal(0);
		for(int k=0,sizek=list.size();k<sizek;k++){
			Map mk = (Map)list.get(k);		
			String sno=StringHelper.null2String(mk.get("sno"));
			String leaappno=StringHelper.null2String(mk.get("leaappno"));
			String jobno=StringHelper.null2String(mk.get("jobno"));
			String leavetype=StringHelper.null2String(mk.get("leavetype"));
			String stime=StringHelper.null2String(mk.get("stime"));
			String etime=StringHelper.null2String(mk.get("etime"));
			String hours=StringHelper.null2String(mk.get("hours"));
			String days=StringHelper.null2String(mk.get("days"));
			String whours=StringHelper.null2String(mk.get("whours"));
			String wdays=StringHelper.null2String(mk.get("wdays"));
			totalhours = totalhours.add(new BigDecimal(hours));
			totaldays = totalhours.add(new BigDecimal(days));
			totaltravelhours  = totaltravelhours.add(new BigDecimal(whours));
			totaltraveldays  = totaltraveldays.add(new BigDecimal(wdays));			
			%>
			<TR id="dataDetail" height="30">
			<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=sno %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=leaappno %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=jobno %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=leavetype %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=stime %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=etime %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=hours %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=days %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=whours %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=wdays %>&nbsp;&nbsp;</TD>			
			</TR>
			<%
		}
		%>
		<TR  id="dataDetail" height="30">
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Total&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<%=totalhours %>&nbsp;H&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<%=totaldays %>&nbsp;Days&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totaltravelhours" name="field_totaltravelhours"  value="<%=totaltravelhours %>"  ><span  id="field_totaltravelhoursspan" name="field_totaltravelhoursspan" ><%=totaltravelhours %></span>&nbsp;H&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totaltraveldays" name="field_totaltraveldays"  value="<%=totaltraveldays %>"  ><span  id="field_totaltraveldaysspan" name="field_totaltraveldaysspan" ><%=totaltraveldays %></span>&nbsp;Days&nbsp;&nbsp;</TD>
		</TR>
		<TR id="dataDetail" style=<%=("".equals(message)?"display:none":"display:block") %> >
		<TD noWrap class="td2"  align=left colspan="12"><span id="leaveinfoerr"><font color="red"><%=message %></font></span></TD>
		</TR>
		<%
	}else{%> 
		<TR><TD class="td2" colspan="34"><span id="leaveinfoerr"><font color="red">No Leave Application infomation, please check!</font></span></TD></TR>
		<TR style="display:none"><TD class="td2" colspan="34"><input type="hidden" id="field_totaltravelhours" name="field_totaltravelhours"  value=""><input type="hidden" id="field_totaltraveldays" name="field_totaltraveldays"  value=""></TD></TR>	
	<%} 
}

if ( "search".equals(action) ) {
	if ( !"".equals(requestid) ) {
		String updatesql = "update uf_dmhr_travelapp set ifretw='"+istw+"' where requestid='"+requestid+"'";	
		baseJdbc.update(updatesql);
		String delsql = "delete from uf_dmhr_travelleave where requestid='"+requestid+"'";	
		baseJdbc.update(delsql);
	}
	String sql ="select a.flowno,a.jobno,a.abtypetxt,(a.sdate || ' ' || a.stime) starttime, (a.edate || ' ' || a.etime) endtime,a.thehours,a.thedays from uf_dmhr_leapp a where a.valid='40288098276fc2120127704884290210' and a.currentnode!='40285a8d58b965900158be3adeb42e6d' and exists(select 1 from requestbase where id=a.requestid and isdelete=0) and jobname='"+empid+"' and ( (to_date('"+s1+"','yyyy-MM-dd HH24:MI:SS') between to_date(a.sdate || ' ' || a.stime,'yyyy-MM-dd HH24:MI:SS') and to_date(a.edate || ' ' || a.etime,'yyyy-MM-dd HH24:MI:SS')) or  (to_date('"+s2+"','yyyy-MM-dd HH24:MI:SS') between to_date(a.sdate || ' ' || a.stime,'yyyy-MM-dd HH24:MI:SS') and to_date(a.edate || ' ' || a.etime,'yyyy-MM-dd HH24:MI:SS')) or (to_date('"+s1+"','yyyy-MM-dd HH24:MI:SS')<=to_date(a.sdate || ' ' || a.stime,'yyyy-MM-dd HH24:MI:SS') and to_date('"+s2+"','yyyy-MM-dd HH24:MI:SS')>=to_date(a.edate || ' ' || a.etime,'yyyy-MM-dd HH24:MI:SS')) ) order by a.sdate asc, a.stime asc";
	//System.out.println(sql);
	String message = "";

	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		int i=0;
		BigDecimal totalhours = new BigDecimal(0);
		BigDecimal totaldays = new BigDecimal(0);
		BigDecimal totaltravelhours = new BigDecimal(0);
		BigDecimal totaltraveldays = new BigDecimal(0);
		for(int k=0,sizek=list.size();k<sizek;k++){
			Map mk = (Map)list.get(k);		
			//String schreqid=StringHelper.null2String(mk.get("requestid"));
			String flowno=StringHelper.null2String(mk.get("flowno"));
			String jobno=StringHelper.null2String(mk.get("jobno"));
			String abtypetxt=StringHelper.null2String(mk.get("abtypetxt"));
			String starttime=StringHelper.null2String(mk.get("starttime"));
			String endtime=StringHelper.null2String(mk.get("endtime"));
			String thehours=StringHelper.null2String(mk.get("thehours"));
			String thedays=StringHelper.null2String(mk.get("thedays"));
			
			BigDecimal travelhours = new BigDecimal(0);	//实际出差工作时数占请假单的小时数
			BigDecimal traveldays = new BigDecimal(0);	//实际出差工作天数		
			i++;
			totalhours = totalhours.add(new BigDecimal(thehours));
			totaldays = totalhours.add(new BigDecimal(thedays));
			if ( app.diffmin(s1,starttime,"datetime",0).intValue()>=0 && app.diffmin(s1,endtime,"datetime",0).intValue()<=0 ) {
				if (  app.diffmin(s2,starttime,"datetime",0).intValue()>=0 && app.diffmin(s2,endtime,"datetime",0).intValue()<=0  ) {
					travelhours = app.diffhour(s2,s1,"datetime",3);
					traveldays = travelhours.divide(new BigDecimal(24),2, BigDecimal.ROUND_HALF_UP);
				} else {
					travelhours = app.diffhour(endtime,s1,"datetime",3);
					traveldays = travelhours.divide(new BigDecimal(24),2, BigDecimal.ROUND_HALF_UP);
				}
			} else if ( app.diffmin(s1,starttime,"datetime",0).intValue()<0 && app.diffmin(s2,endtime,"datetime",0).intValue() >0 ) {
				travelhours = new BigDecimal(thehours);	
				traveldays = new BigDecimal(thedays);	
			} else if ( app.diffmin(s2,starttime,"datetime",0).intValue()>=0 && app.diffmin(s2,endtime,"datetime",0).intValue()<=0  ) {
				travelhours = app.diffhour(s2,starttime,"datetime",3);
				traveldays = travelhours.divide(new BigDecimal(24),2, BigDecimal.ROUND_HALF_UP);
			}
			totaltraveldays  = totaltraveldays.add(traveldays);
			totaltravelhours  = totaltravelhours.add(travelhours);
			%>
			<TR id="dataDetail" height="30">
			<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=i %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=flowno %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=jobno %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=abtypetxt %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=starttime %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=endtime %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=thehours %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=thedays %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=travelhours %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=traveldays %>&nbsp;&nbsp;</TD>			
			</TR>
			<%
			if ( !"".equals(requestid) ) {
					String isql = "insert into uf_dmhr_travelleave  (id,requestid,sno,leaappno,jobno,leavetype,stime,etime,hours,days,whours,wdays) values (sys_guid(),'"+requestid+"','"+i+"','"+flowno+"','"+jobno+"','"+abtypetxt+"','"+starttime+"','"+endtime+"','"+thehours+"','"+thedays+"','"+travelhours+"','"+traveldays+"')";
					baseJdbc.update(isql);
			}
		}
		%>
		<TR  id="dataDetail" height="30">
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Total&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center></TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<%=totalhours %>&nbsp;H&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<%=totaldays %>&nbsp;Days&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totaltravelhours" name="field_totaltravelhours"  value="<%=totaltravelhours %>"  ><span  id="field_totaltravelhoursspan" name="field_totaltravelhoursspan" ><%=totaltravelhours %></span>&nbsp;H&nbsp;&nbsp;</TD>
		<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;<input type="hidden" id="field_totaltraveldays" name="field_totaltraveldays"  value="<%=totaltraveldays %>"  ><span  id="field_totaltraveldaysspan" name="field_totaltraveldaysspan" ><%=totaltraveldays %></span>&nbsp;Days&nbsp;&nbsp;</TD>
		</TR>
		<TR id="dataDetail" style=<%=("".equals(message)?"display:none":"display:block") %> >
		<TD noWrap class="td2"  align=left colspan="12"><span id="leaveinfoerr"><font color="red"><%=message %></font></span></TD>
		</TR>
		<%
	}else{%> 
		<TR><TD class="td2" colspan="34"><span id="leaveinfoerr"><font color="red">No Leave Application infomation, please check!</font></span></TD></TR>
		<TR style="display:none"><TD class="td2" colspan="34"><input type="hidden" id="field_totaltravelhours" name="field_totaltravelhours"  value=""><input type="hidden" id="field_totaltraveldays" name="field_totaltraveldays"  value=""></TD></TR>	
	<%} 
}%>
</table>
</div>
