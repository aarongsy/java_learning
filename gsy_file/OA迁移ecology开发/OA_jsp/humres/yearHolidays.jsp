<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
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
	String qjtype="402881823107a0b9013107ce328400a5";
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
		sql="select hlds,hlds-hasnum-hasnum1 leftnum,hasnum from (select hlds,nvl((select sum(theYearDays) from uf_hm_dayoff  m where othertype='"+qjtype+"' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'"+requestid+"' and (to_number(substr(reqtime,0,4))= h.atyear) and beginDate  between h.begindate and h.enddate),0) hasnum,nvl((select sum(prevYearDays) from uf_hm_dayoff m where othertype='"+qjtype+"' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (to_number(substr(reqtime,0,4))= h.atyear+1) and reqtime  between h.begindate and h.enddate),0) hasnum1 from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and t.objid='"+userid+"'  and  h.atyear+1=to_number(substr('"+beginDate+"',0,4)) and  '"+beginDate+"' between h.begindate and h.enddate) n ";
		ls = baseJdbc.executeSqlForList(sql);
		if(ls.size()>0)
		{
			Map m = (Map)ls.get(0);
			leftnum = m.get("leftnum").toString();
		}
		sql="select hlds,hlds-hasnum leftnum,hasnum from (select hlds,nvl((select sum(theYearDays) from uf_hm_dayoff m where othertype='"+qjtype+"' and reqMan=t.objid and exists(select id from requestbase where isdelete=0 and id=m.requestid) and requestid<>'0' and (to_number(substr(reqtime,0,4))= h.atyear) and beginDate  between h.begindate and h.enddate and requestid<>'"+requestid+"'),0) hasnum from uf_attendance_yuserhlds t, uf_attendance_yearhld h  where h.atyear=t.hyear and t.hyear=to_number(substr('"+beginDate+"',0,4)) and t.objid='"+userid+"'  and  '"+beginDate+"' between h.begindate and h.enddate) n   ";

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
		buf.append("<td class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150053")+"：&nbsp;"+parseDouble(leftnum) +"</td>");//上年可请年假天数
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c08dcc0134c08dcd380000")+"：&nbsp;"+parseDouble(leftnum2)+"</td>");//今年剩余年假天数
		buf.append("</tr>");
		buf.append("<tr><td  class=\"FieldValue\">"+labelService.getLabelNameByKeyId("402883d934c08ef70134c08ef8340000")+"：&nbsp;"+parseDouble((Double.valueOf(leftnum2)+Double.valueOf(leftnum)))+"</td>");//当前可请年假天数
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

