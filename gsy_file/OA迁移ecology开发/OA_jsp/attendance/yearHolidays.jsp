<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@ include file="/base/init.jsp"%>
<%!
public static double parseDouble(Object obj) {
	return NumberHelper.fixDouble(NumberHelper.string2Double(StringHelper.null2String(obj),0),1);
}

 %>
<%
	String requestid= request.getParameter("requestid");
	String userid = request.getParameter("userid");
	String beginDate = request.getParameter("beginDate");
	String reqType= request.getParameter("reqType");
	String qjtype="402880982773f2390127743da22200aa";
	if(reqType.equals(qjtype))
	{
				String sql = "";
		String hlds="0.0";
		String leftnum="0.0";
		String hasnum="0.0";
		String hlds2="0.0";
		String leftnum2="0.0";
		String hasnum2="0.0";
		if(requestid==null)requestid="0";
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		List ls=null;
		//sql="select hlds,hlds-hasnum-hasnum1 leftnum,hasnum from (select hlds,isnull((select sum(theYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'"+requestid+"' and (convert(varchar(4),beginDate,120)= h.atyear) and beginDate  between h.begindate and h.enddate),0) hasnum,isnull((select sum(prevYearDays) from uf_leave m where reqStyle='402880982773f2390127743da22200aa' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (convert(varchar(4),beginDate,120)= convert(varchar(4),h.atyear+1)) and beginDate  between h.begindate and h.enddate),0) hasnum1 from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and t.objid='"+userid+"'  and  convert(varchar(4),h.atyear+1)=convert(varchar(4),'"+beginDate+"',120) and  '"+beginDate+"' between h.begindate and h.enddate) n ";
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
		StringBuffer buf=new StringBuffer();
		buf.append("<table width=\"400\">");
		buf.append("<tr>");
		buf.append("<td class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c08c700134c08c716e0000")+"：&nbsp;"+leftnum+"</td>");//上一年可请年假天数
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c08dcc0134c08dcd380000")+"：&nbsp;"+leftnum2+"</td>");//今年剩余年假天数
		buf.append("</tr>");
		buf.append("<tr><td  class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c08ef70134c08ef8340000")+"：&nbsp;"+(Double.valueOf(leftnum2)+Double.valueOf(leftnum))+"</td>");//当前可请年假天数
		buf.append("</tr>");
		buf.append("</table>");
		out.println(buf);
	}
	else if(reqType.equals("402880982773f2390127743da22200a9"))
	{
		String sql = "";
		double jbnum=0.0;
		double hasnum=0.0;
		if(requestid==null)requestid="0";
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		List ls=null;
		sql="select nvl(sum(totalDays),0.0) jbdays from uf_overtime m where reqMan='"+userid+"' and exists(select id from requestbase where isdelete=0 and id=m.requestid and isfinished=1)";
		ls = baseJdbc.executeSqlForList(sql);
		if(ls.size()>0)
		{
			Map m = (Map)ls.get(0);
			jbnum = Double.valueOf(m.get("jbdays").toString());
		}
		sql="select nvl(sum(actualDays),0.0) hasnum from uf_leave m where reqStyle='402880982773f2390127743da22200a9' and reqMan='"+userid+"' and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'"+requestid+"'";
		ls = baseJdbc.executeSqlForList(sql);
		if(ls.size()>0)
		{
			Map m = (Map)ls.get(0);
			hasnum = Double.valueOf(m.get("hasnum").toString());
		}
		StringBuffer buf=new StringBuffer();
		buf.append("<table width=\"400\">");
		buf.append("<tr>");
		buf.append("<td class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c087390134c0873a750000")+"：&nbsp;"+parseDouble(jbnum)+"</td>");//加班总天数
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c089070134c08907920000")+"&nbsp;"+parseDouble(hasnum)+"</td>");//已请调休天数
		buf.append("</tr>");
		buf.append("<tr><td  class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c08a6a0134c08a6b3b0000")+"：&nbsp;"+parseDouble((jbnum-hasnum))+"</td>");//当前剩余调休天数
		buf.append("</tr>");
		buf.append("</table>");
		out.println(buf);
	}
%>

