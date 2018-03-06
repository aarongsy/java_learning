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
String begindatecnd = request.getParameter("begindatecnd");
String enddatecnd = request.getParameter("enddatecnd");
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
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}
</style>
<BODY>
<FORM id=frmmain name=frmmain method=post action="HrmResourceAbsense.jsp">
<input class=inputstyle type=hidden name=movedate value="">
  <TABLE  style="width:100%;" class="TI" >
    <col width=20%> <col width=30%>  <col width=10%> <col width=40%>
    <TR > 
      <Td colspan=4 align="center"><% if(userCndID.equals(eweaveruser1.getId()))out.println(labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0000"));//我的考勤视图
	  else{out.println(getBrowserDicValue("humres","id","objname",userCndID)+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000b")); }//的考勤视图
	  
	  %></Td>

	</tr></table>
  <br>
	<%
	StringBuffer buf = new StringBuffer();
	DataService ds = new DataService();
	String sql="select date1,isholiday,isworkday,daytype from holidaysinfo where convert(varchar(10),cast(date1 as datetime),120) between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
	List holidaysList = ds.getValues(sql);
	//请假记录
	sql ="select reqman,requestid,begindate,begintime,enddate,endtime,actualdays from uf_leave x where begindate between '"+begindatecnd+"' and '"+enddatecnd+"' and  enddate between '"+begindatecnd+"' and '"+enddatecnd+"' and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by begindate";
	List leaveList = ds.getValues(sql);
	//出差记录
	sql ="select reqman,requestid,actualbegindate,actualenddate,actualdays from uf_workout x where actualbegindate between '"+begindatecnd+"' and '"+enddatecnd+"' and  actualenddate between '"+begindatecnd+"' and '"+enddatecnd+"' and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1)";
	List outList = ds.getValues(sql);
	//考勤异常
	sql ="select reqman,requestid,happendate,begintime,endtime,title from uf_specialattendance x where happendate between '"+begindatecnd+"' and '"+enddatecnd+"'  and   exists(select id from requestbase where id=x.requestid and isdelete=0 and isfinished=1) order by happendate";
	List bugList = ds.getValues(sql);
	//考勤记录
	sql ="select convert(varchar(10),date1,120) date1,hrmid,attendance,time1,convert(varchar,cast(date1 as datetime),108) time2 from  attendance  where date1 between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
	List attList = ds.getValues(sql);
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
					if(time1.compareToIgnoreCase(time2)>0)
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
					if(time1.compareToIgnoreCase(time2)<0)
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
	//统计请假天数
	for(int k=0 ; k<size2 ; k++) {
		Map m = (Map)leaveList.get(k);
		qjtimes=qjtimes + Double.valueOf(StringHelper.null2String(m.get("actualdays"),"0")) ;
	}
	//统计出差数
	for(int k=0 ; k<size3 ; k++) {
		Map m = (Map)outList.get(k);
		qctimes=qctimes + Double.valueOf(StringHelper.null2String(m.get("actualdays"),"0")) ;
	}
	buf.append(cdtimes+","+zttimes+","+lqtimes+","+qjtimes+","+qctimes+","+yctimes+","+kgtimes);
	out.println(buf.toString());
%>
  <br>
  <br>
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

	private boolean isBug(List bugList,String thenowday,String time1,String type)
	{
		boolean flag=true;
		int size4=bugList.size();
		//判断是否异常
		for(int k=0 ; k<size4 ; k++) {
			Map m = (Map)bugList.get(k);
			String tempdatefrom = StringHelper.null2String(m.get("begindate"),"0") ;
			String temptimefrom = StringHelper.null2String(m.get("begintime"),"0") ;
			String temptimeto = StringHelper.null2String(m.get("endtime"),"0") ;
			if(thenowday.compareToIgnoreCase(tempdatefrom)== 0) 
			{
				if(type.equals("1"))
				{
					if(time1.compareToIgnoreCase(temptimefrom)>=0)
					{
						flag=false;
						break;
					}
				}
				if(type.equals("2"))
				{
					if(time1.compareToIgnoreCase(temptimeto)<=0)
					{
						flag=false;
						break;
					}
				}
				break;
			}
		}
		return flag;
	}
	private boolean isLeave(List leaveList,String thenowday,String time1,String type)
	{
		boolean flag=true;
		int size2=leaveList.size();
		//判断是否请假
		for(int k=0 ; k<size2 ; k++) {
			Map m = (Map)leaveList.get(k);
			String tempdatefrom = StringHelper.null2String(m.get("begindate"),"0") ;
			String tempdateto = StringHelper.null2String(m.get("enddate"),"0") ;
			String temptimefrom = StringHelper.null2String(m.get("begintime"),"0") ;
			String temptimeto = StringHelper.null2String(m.get("endtime"),"0") ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) >=0 && thenowday.compareToIgnoreCase(tempdateto)<=0 ) 
			{
				if(type.equals("1")&&thenowday.compareToIgnoreCase(tempdatefrom)==0)
				{
					if(time1.compareToIgnoreCase(temptimefrom)>0)
					{
						flag=false;
						break;
					}
				}
				if(type.equals("2")&&thenowday.compareToIgnoreCase(tempdateto)==0)
				{
					if(time1.compareToIgnoreCase(temptimeto)<=0)
					{
						flag=false;
						break;
					}
				}
				flag=false;
				break;
			}
		}
		return flag;
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
