<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*" %>
<%@ include file="/base/init.jsp"%>
<table width="925" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td align="right"><%=labelService.getLabelNameByKeyId("402883d934c0846f0134c0846fb40000") %>：<%=DateHelper.getCurrentDate() %></td>
  </tr>
 <tr>
</tr>

  <tr>
    <td align="center">
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancein.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[签到明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendanceout.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[签退明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancecd.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[迟到明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancezt.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[早退明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancekg.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[旷工明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancelq.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[漏签明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendanceqj.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[请假明细]</a>&nbsp;
    	<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancecc.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[出差明细]</a>&nbsp;
		<a href="<%=request.getContextPath()%>/app/attendance/hrmAttendancejb.jsp?bd=<%=begindatecnd%>&ed=<%=enddatecnd%>&mc=<%=URLEncoder.encode(URLEncoder.encode(mc))%>&bm=<%=URLEncoder.encode(URLEncoder.encode(bm))%>&zt=<%=URLEncoder.encode(URLEncoder.encode(zt))%>&userCndID=<%=userCndID%>">[加班明细]</a>&nbsp;
     </td>
  </tr>
</table>
 
</form>


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