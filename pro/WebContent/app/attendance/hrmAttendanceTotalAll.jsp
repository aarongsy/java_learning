<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%
//LabelService labelService = (LabelService)BaseContext.getBean("labelService");

String imagefilename = "/images/hdMaintenance.gif";
String begindatecnd = request.getParameter("bd");
String enddatecnd = request.getParameter("ed");
 //begindatecnd = "2010-04-01";
//enddatecnd = "2010-05-06";
String deptid=request.getParameter("bm");
String userid=request.getParameter("yg");
String excel=StringHelper.null2String(request.getParameter("exportType"));
boolean isExcel=excel.equalsIgnoreCase("excel");
if(request.getMethod().equalsIgnoreCase("post")){
	
	
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="考勤统计表.xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}

%>
<%if(!isExcel){%>
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
<script>
function Save2Excel(){
	document.all('EweaverForm').target='_blank';
	document.all('EweaverForm').action=location.href+'&exportType=excel';
	document.all('EweaverForm').submit();
}
</script>
<BODY>
<FORM id=frmmain name=frmmain method=post action="">
<table width="100%" border="0">
    <tr>
    <td align="right"><span><a href="javascript:Save2Excel()"><%=labelService.getLabelNameByKeyId("402883d934c05ea90134c05ea9a60000") %><!-- 导出 --></a></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
</table>
<%}%>
<table border="<%=isExcel?1:0%>" cellpadding="0" cellspacing="1" bgcolor="#000000">
   <tr>
    <td align="center" height="40" colspan=14 bgcolor="#FFFFFF"><span class="STYLE2"><strong><%out.println(begindatecnd+labelService.getLabelNameByKeyId("4028834734b2525e0134b2525f120000")+enddatecnd+labelService.getLabelNameByKeyId("402883d934c0402b0134c0402bea0000")); %></strong></span></td><!-- 至  考勤情况统计 -->
  </tr>
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


	<%
		DataService ds = new DataService();
	String where =" where 1=1 ";
	if(deptid!=null&&!deptid.equals(""))
		where = where + " and orgid='"+deptid+"'";
	if(userid!=null&&!userid.equals(""))
		where = where + " and id='"+userid+"'";
	//当前用户相关信息：部门，姓名，状态
	String sqlall="select h.objname mc,h.orgid bm,h.hrstatus zt,id from humres h "+where+"  and isdelete=0 and seclevel<35  order by objno";
	List mList = ds.getValues(sqlall);
	StringBuffer buf = new StringBuffer();
	for(int x=0,size=mList.size();x<size;x++)
	{
		
		Map m1 = (Map)mList.get(x);
		
		String mc = StringHelper.null2String(m1.get("mc")) ;
		String bm = getBrowserDicValue("orgunit","id","objname",StringHelper.null2String(m1.get("bm"))) ;

		String zt = getSelectDicValue(StringHelper.null2String(m1.get("zt"))) ;
		String userCndID=StringHelper.null2String(m1.get("id"));
		//假日
		String sql="select date1,isholiday,isworkday,daytype from holidaysinfo where convert(varchar(10),cast(date1 as datetime),120) between '"+begindatecnd+"' and '"+enddatecnd+"' order by date1";
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
<%
	}
%>
</table>
<%if(!isExcel){%>
</form>
<FORM id=EweaverForm name=EweaverForm method=post action="">
</Form>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
<%}%>
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
