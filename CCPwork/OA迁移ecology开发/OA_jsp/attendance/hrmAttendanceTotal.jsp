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
String begindatecnd = request.getParameter("bd");
String enddatecnd = request.getParameter("ed");
 //begindatecnd = "2010-04-01";
//enddatecnd = "2010-05-06";
String userCndID=request.getParameter("userCndID");
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
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid;
}
div, h1, h2, h3, h4, p, form,td, label, input, textarea, img, span{
	margin:0; padding:0;
}

tr{
text-align:center;
}
</style>
<BODY>
<FORM id=frmmain name=frmmain method=post action="">

	<%
	StringBuffer buf = new StringBuffer();
	DataService ds = new DataService();
	//当前用户相关信息：部门，姓名，状态
	String sql="select h.objname mc,h.orgid bm,h.hrstatus zt from humres h  where h.id='"+userCndID+"'";
	List mList = ds.getValues(sql);
	Map m1 = (Map)mList.get(0);
	String mc = StringHelper.null2String(m1.get("mc")) ;
	String bm = getBrowserDicValue("orgunit","id","objname",StringHelper.null2String(m1.get("bm"))) ;

	String zt = getSelectDicValue(StringHelper.null2String(m1.get("zt"))) ;
	
	//假日
	sql="select date1,isholiday,isworkday,daytype from holidaysinfo where convert(varchar(10),cast(date1 as datetime),120) between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
	List holidaysList = ds.getValues(sql);
	//请假记录
	sql ="select reqman,requestid,begindate,begintime,enddate,endtime,actualdays from uf_leave x where reqman='"+userCndID+"' and  begindate between '"+begindatecnd+"' and '"+enddatecnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by begindate";

	List leaveList = ds.getValues(sql);
	//出差记录
	sql ="select reqman,requestid,actualbegindate,actualenddate,actualdays from uf_workout x where reqman='"+userCndID+"' and actualbegindate between '"+begindatecnd+"' and '"+enddatecnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1)";
	List outList = ds.getValues(sql);
	//考勤异常
	sql ="select reqman,requestid,happendate,begintime,endtime,title from uf_specialattendance x where reqman='"+userCndID+"' and  happendate between '"+begindatecnd+"' and '"+enddatecnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by happendate";
	List bugList = ds.getValues(sql);
	//考勤记录
	sql ="select convert(varchar(10),date1,120) date1,hrmid,attendance,time1,convert(varchar,cast(date1 as datetime),108) time2 from  attendance  where hrmid='"+userCndID+"' and  date1 between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
	List attList = ds.getValues(sql);
	//加班记录
	sql ="select reqman,requestid,begindate,begintime,enddate,endtime,totalDays from uf_overtime x where reqman='"+userCndID+"' and  begindate between '"+begindatecnd+"' and '"+enddatecnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by begindate";
	List jbList = ds.getValues(sql);
	int cdtimes=0;
	int zttimes=0;
	int lqtimes=0;
	double qjtimes=0;
	double qctimes=0;
	int yctimes=0;
	int kgtimes=0;
	int size1=holidaysList.size();
	int size2=leaveList.size();
	int size3=outList.size();
	int size4=bugList.size();
	int size5=attList.size();
		
	yctimes=size4;
	buf.append("<tr height=25>");
	String thenowday=begindatecnd;
	while(thenowday.compareToIgnoreCase(enddatecnd)<=0)
	{
	
		//判断是否是节假日，是不明是周末
		if(isWeekEnd(thenowday,holidaysList))
		{
			thenowday=addDate(thenowday);
			continue;
		}
		
		boolean outbool=false;
		//判断是否外出
		for(int k=0 ; k<size3 ; k++) {
			Map m = (Map)outList.get(k);
			String tempdatefrom = StringHelper.null2String(m.get("actualbegindate"),"0") ;
			String tempdateto = StringHelper.null2String(m.get("actualenddate"),"0") ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) >= 0 && thenowday.compareToIgnoreCase(tempdateto)<=0 ) 
			{
				
				outbool=true;
				break;
			}
		}
		if(outbool)
		{
			thenowday=addDate(thenowday);
			continue;
		}
		boolean cdbool=false;
		boolean ztbool=false;
		boolean cdboolexist=false;
		boolean ztboolexist=false;
		//判断考勤
		for(int k=0 ; k<size5 ; k++) {
			Map m = (Map)attList.get(k);
			String date1 = StringHelper.null2String(m.get("date1"),"0") ;
			String time1 = StringHelper.null2String(m.get("time1"),"0") ;
			String time2 = StringHelper.null2String(m.get("time2"),"0") ;
			String attendance = StringHelper.null2String(m.get("attendance"),"0") ;
			if(thenowday.compareToIgnoreCase(date1) == 0) 
			{
				
				if(attendance.equals("1"))
				{
					cdboolexist=true;
					if(time1.compareToIgnoreCase(time2)<0)
					{
						if(isBug(bugList,thenowday,time1,attendance)&&isLeave(leaveList,thenowday,time1,attendance))
						{
							cdtimes=cdtimes+1;
						}				
					}
				}
				else if(attendance.equals("2"))
				{
					ztboolexist=true;
					if(time1.compareToIgnoreCase(time2)>0)
					{
						if(isBug(bugList,thenowday,time1,attendance)&&isLeave(leaveList,thenowday,time1,attendance))
						{
							zttimes=zttimes+1;
						}
					}

				}
				
			}
		}
		//矿工
		if(!cdboolexist)
		{
				if(isBug(bugList,thenowday,"08:00:00","1")&&isLeave(leaveList,thenowday,"08:00:00","1"))
				{
					kgtimes=kgtimes+1;
				}
			
		}
		//漏签
		if(cdboolexist&&!ztboolexist)
		{
			if(isBug(bugList,thenowday,"18:00:00","2")&&isLeave(leaveList,thenowday,"18:00:00","2"))
			{
				lqtimes=lqtimes+1;
			}
			
		}
		thenowday=addDate(thenowday);
	}
	//请假记录
	double txjtimes=0;//调休假
	double nxjtimes=0;//年休假
	double bjtimes=0;//病假
	double sjtimes=0;//事假
	double qtjtimes=0;//其他假

	sql ="select reqstyle,sum(actualdays) totald from uf_leave x where reqman='"+userCndID+"' and  begindate between '"+begindatecnd+"' and '"+enddatecnd+"' and  enddate between '"+begindatecnd+"' and '"+enddatecnd+"' and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) group by reqstyle";
	List leavetostyleList = ds.getValues(sql);
	
	for(int k=0 ; k<leavetostyleList.size(); k++) {
		Map m = (Map)leavetostyleList.get(k);
		String reqstyle=StringHelper.null2String(m.get("reqstyle"));
		if("402880982773f2390127743da22200a9".equals(reqstyle)){
		  txjtimes+=Double.valueOf(StringHelper.null2String(m.get("totald"),"0"));
		}else if("402880982773f2390127743da22200aa".equals(reqstyle)){
		  nxjtimes+=Double.valueOf(StringHelper.null2String(m.get("totald"),"0"));
		}else if("402880982773f2390127743da22200ab".equals(reqstyle)){
		  bjtimes+=Double.valueOf(StringHelper.null2String(m.get("totald"),"0"));
		}else if("402880982773f2390127743da22200ac".equals(reqstyle)){
		  sjtimes+=Double.valueOf(StringHelper.null2String(m.get("totald"),"0"));
		}else{
		   qtjtimes+=Double.valueOf(StringHelper.null2String(m.get("totald"),"0"));
		}
		qjtimes=qjtimes + Double.valueOf(StringHelper.null2String(m.get("actualdays"),"0")) ;
	}
	//统计出差数
	for(int k=0 ; k<size3 ; k++) {
		Map m = (Map)outList.get(k);
		qctimes=qctimes + Double.valueOf(StringHelper.null2String(m.get("actualdays"),"0")) ;
	}
	double jbtimes=0.0;
	//统计加班天数
	for(int k=0,size0=jbList.size() ; k<size0 ; k++) {
		Map m = (Map)jbList.get(k);
		jbtimes=jbtimes + Double.valueOf(StringHelper.null2String(m.get("totalDays"),"0")) ;
	}
%>
<table width="100%" border="0">
   <tr>
    <td align="center" height="40"><span class="STYLE2"><strong><%out.println(begindatecnd+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+enddatecnd+labelService.getLabelNameByKeyId("402883d934c0402b0134c0402bea0000")); %></strong></span></td><!-- 至  考勤情况统计 -->
  </tr>
    <tr>
    <td align="right"></td>
  </tr>
</table>
<table border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
  <tr>
    <td width="65" rowspan="3" height="25" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("4028834734b25a3d0134b25a3dd00000") %></td><!-- 部门名称 -->
    <td width="65" rowspan="3" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b") %></td><!-- 姓名 -->
    <td colspan="11" align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c044190134c04419d30000") %><!-- 考勤情况 --></td>
    <td width="90" rowspan="3" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %></td><!-- 备注 -->
  </tr>
  <tr>
    
    <td  width="60" rowspan="2" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c046320134c04633680000") %></td><!-- 迟到（次） -->
    <td  width="60" rowspan="2" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c047ee0134c047ef670000") %></td><!-- 早退（次） -->
    <td  width="60" colspan="5" align="center" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c04a450134c04a465d0000") %></td><!-- 请假 -->
  
    <td width="65"  rowspan="2" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c04c1a0134c04c1b0e0000") %></td><!-- 出差（天） -->
	<td width="65"  rowspan="2" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c04db50134c04db5f30000") %></td><!-- 加班（天） -->
    <td width="65"  rowspan="2" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c04f210134c04f22820000") %></td><!-- 旷工（次） -->
    <td width="65"  rowspan="2"  bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c0708f0134c070906c0000") %></td><!-- 漏签（次） -->
  </tr>
    <tr>
    <td width="60"  bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c050cf0134c050cfbd0000") %></td><!-- 病假（天） -->
    <td width="60"  bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c053510134c05352800000") %></td><!-- 事假（天） -->
    <td width="60"  bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c055230134c05524570000") %></td><!-- 调休假（天） -->
    <td width="60"  bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c056d40134c056d4c40000") %></td><!-- 年休假（天） -->
    <td width="60" bgcolor="#FFFFFF"><%=labelService.getLabelNameByKeyId("402883d934c0591f0134c0591f9d0000") %></td><!-- 其它假别（天） -->
  </tr>
  <tr>
     <td width="65" height="25" bgcolor="#FFFFFF"><%=bm%></td>
    <td bgcolor="#FFFFFF"><%=mc%></td>
    <td bgcolor="#FFFFFF"><%=cdtimes %></td>
    <td bgcolor="#FFFFFF"><%=zttimes %></td>
    <td bgcolor="#FFFFFF"><%=bjtimes%></td>
    <td bgcolor="#FFFFFF"><%=sjtimes%></td>
    <td bgcolor="#FFFFFF"><%=txjtimes%></td>
    <td bgcolor="#FFFFFF"><%=nxjtimes%></td>
    <td bgcolor="#FFFFFF"><%=qtjtimes%></td>
    <td bgcolor="#FFFFFF"><%=qctimes %></td>
	<td bgcolor="#FFFFFF"><%=jbtimes %></td>
    <td bgcolor="#FFFFFF"><%=kgtimes %></td>
    <td bgcolor="#FFFFFF"><%=lqtimes %></td>
    
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
</table>
<%@ include file="/app/attendance/include.jsp"%>
