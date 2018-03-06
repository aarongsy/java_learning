<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/base/init.jsp"%>

<%
	String requestid= request.getParameter("requestid");
	String userid = request.getParameter("userid");
	String type = request.getParameter("type");
	String beginDate = request.getParameter("beginDate");
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List ls=null;
	if(type.equals("checkdays"))
	{
		String reqType = request.getParameter("reqType");
		if(requestid==null||requestid.length()<1)requestid="0";
		//年假 402880982773f2390127743da22200aa
		//调体 402880982773f2390127743da22200a9
		if(reqType.equals("402880982773f2390127743da22200aa"))
		{
			String hlds="0.0";
			String leftnum="0.0";
			String hasnum="0.0";
			String hlds2="0.0";
			String leftnum2="0.0";
			String hasnum2="0.0";
			if(requestid==null)requestid="0";
			sql="select hlds,hlds-hasnum-hasnum1 leftnum,hasnum from (select hlds,nvl((select sum(theYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'"+requestid+"' and (to_char(to_date(beginDate,'yyyy-mm-dd'),'yyyy')= h.atyear) and beginDate  between h.begindate and h.enddate),0) hasnum,nvl((select sum(prevYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (to_char(to_date(beginDate,'yyyy-mm-dd'),'yyyy')= to_char(h.atyear+1)) and beginDate  between h.begindate and h.enddate),0) hasnum1 from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and t.objid='"+userid+"'  and  to_char(h.atyear+1)=to_char(to_date('"+beginDate+"','yyyy-mm-dd'),'yyyy') and  '"+beginDate+"' between h.begindate and h.enddate) n ";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				Map m = (Map)ls.get(0);
				leftnum = m.get("leftnum").toString();
			}
			//sql="select hlds,hlds-hasnum leftnum,hasnum from (select hlds,isnull((select sum(theYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (convert(varchar(4),beginDate,120)=convert(varchar(4), h.atyear)) and beginDate  between h.begindate and h.enddate and requestid<>'"+requestid+"'),0) hasnum from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and convert(varchar(4),t.hyear)=convert(varchar(4),'"+beginDate+"',120) and t.objid='"+userid+"'  and  '"+beginDate+"' between h.begindate and h.enddate) n   ";
			sql="select hlds,hlds-hasnum leftnum,hasnum from (select hlds,nvl((select sum(theYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (to_char(to_date(beginDate,'yyyy-mm-dd'),'yyyy')= h.atyear) and beginDate  between h.begindate and h.enddate and requestid<>'"+requestid+"'),0) hasnum from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and to_char(t.hyear)=to_char(to_date('"+beginDate+"','yyyy-mm-dd'),'yyyy') and t.objid='"+userid+"'  and  '"+beginDate+"' between h.begindate and h.enddate) n   ";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				Map m = (Map)ls.get(0);
				hlds2 = m.get("hlds").toString();
				leftnum2 = m.get("leftnum").toString();
				hasnum2 = m.get("hasnum").toString();
			}
			double nums=(Double.valueOf(leftnum2)+Double.valueOf(leftnum));
			double reqDays = Double.valueOf(request.getParameter("reqDays"));
			if(reqDays>nums)
			{
					
				out.println(labelService.getLabelNameByKeyId("4028834734b245c10134b245c19f0000"));//请假天数不得大于可请年假天数！
				return;
			}
			else 
			{
				String returnstr="";
				double dleftnum=Double.valueOf(leftnum);
				double dleftnum2=Double.valueOf(leftnum2);
				double prenums=0.0;
				double thenums=0.0;
				if(reqDays<=dleftnum)
				{
					prenums=reqDays;
				}
				else
				{
					prenums=dleftnum;
					thenums=reqDays-dleftnum;
				}
				returnstr="yes,"+thenums+","+prenums;
				out.println(returnstr);
				return;
			}
		}
	}
%>