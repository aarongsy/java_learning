<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
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

<%
String startdate = StringHelper.null2String(request.getParameter("startdate"));
String enddate = StringHelper.null2String(request.getParameter("enddate"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String foodtype = StringHelper.null2String(request.getParameter("foodtype"));
String comptype=StringHelper.null2String(request.getParameter("comptype"));//
String type1=StringHelper.null2String(request.getParameter("type1"));//1外籍查询
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
    height: 22px; 
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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" style="overflow-y:auto">

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width:100%;font-size:12" bordercolor="#adae9d">

	    <TR height="25"  class="title">
		<TD class="td2"  align=center>订餐日期</TD>
		<TD class="td2"  align=center>工号</TD>
		<TD class="td2"  align=center>姓名</TD>
		<%
		String sql="";
		String countsqld="";//订餐数量
		String countsqls="";//送餐数量
			if(foodtype.equals("0"))//早餐
			{
				if(type1.equals("1"))
					{
				sql="select a.thedate,a.jobno,b.objname,a.breakfast as ordertype from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"'  and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.breakfast is not null and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqld="select count(a.id) as dtotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.breakfast='40285a90495b4eb001496408814f5995' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqls="select count(a.id) as stotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.breakfast='40285a90495b4eb001496408814f5996' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				}
				else
				{
				sql="select a.thedate,a.jobno,b.objname,a.breakfast as ordertype from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"'  and b.extrefobjfield5='"+comptype+"' and a.breakfast is not null and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqld="select count(a.id) as dtotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.breakfast='40285a90495b4eb001496408814f5995' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqls="select count(a.id) as stotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.breakfast='40285a90495b4eb001496408814f5996' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				}
				%>
		<TD class="td2"  align=center>早餐订餐</TD>
		<TD class="td2"  align=center>早餐送餐</TD>
				<%
			}
			else if(foodtype.equals("1"))//午餐
			{
				if(type1.equals("1"))
				{
				sql="select a.thedate,a.jobno,b.objname,a.lunch as ordertype from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.lunch is not null and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqld="select count(a.id) as dtotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.lunch='40285a90495b4eb001496408814f5995' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqls="select count(a.id) as stotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.lunch='40285a90495b4eb001496408814f5996' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				}
				else
				{sql="select a.thedate,a.jobno,b.objname,a.lunch as ordertype from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.lunch is not null and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqld="select count(a.id) as dtotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.lunch='40285a90495b4eb001496408814f5995' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqls="select count(a.id) as stotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.lunch='40285a90495b4eb001496408814f5996' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				}
				%>
		<TD class="td2"  align=center>午餐订餐</TD>
		<TD class="td2"  align=center>午餐送餐</TD>
				<%
			}
			else  //晚餐
			{
				if(type1.equals("1"))
				{
				sql="select a.thedate,a.jobno,b.objname,a.dinner as ordertype from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.dinner is not null and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqld="select count(a.id) as dtotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.dinner='40285a90495b4eb001496408814f5995' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqls="select count(a.id) as stotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate between '"+startdate+"' and '"+enddate+"' and b.extrefobjfield5='"+comptype+"' and (b.extselectitemfield11='40285a8f489c17ce0148f371f98a6741' or b.extselectitemfield11='40285a8f489c17ce0148f371f98a6740') and a.dinner='40285a90495b4eb001496408814f5996' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				}
				else
				{
				sql="select a.thedate,a.jobno,b.objname,a.dinner as ordertype from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.dinner is not null and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqld="select count(a.id) as dtotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.dinner='40285a90495b4eb001496408814f5995' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				countsqls="select count(a.id) as stotal from uf_hr_unitfootsub a,humres b  where a.objname=b.id and a.thedate='"+startdate+"' and b.extrefobjfield5='"+comptype+"' and a.dinner='40285a90495b4eb001496408814f5996' and 0=(select t.isdelete from formbase t where t.id=a.requestid)";
				}
				%>
		<TD class="td2"  align=center>晚餐订餐</TD>
		<TD class="td2"  align=center>晚餐送餐</TD>
				<%
			}
		%>
		</TR>
<%
List sublist = baseJdbc.executeSqlForList(sql);
Map mk=null;
int no=sublist.size();
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		mk = (Map)sublist.get(k);
		String thedate =StringHelper.null2String(mk.get("thedate"));
		String jobno =StringHelper.null2String(mk.get("jobno"));
		String objname =StringHelper.null2String(mk.get("objname"));
		String ordertype =StringHelper.null2String(mk.get("ordertype"));
	%>

		<TR>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" style="width:80%" value="<%=thedate%>"> <span><%=thedate%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" style="width:80%" value="<%=jobno%>"><span><%=jobno%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle"  style="width:80%" value="<%=objname%>"><span><%=objname%></span></TD>
		<%
		if(ordertype.equals("40285a90495b4eb001496408814f5995"))//订餐
		{
			%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle"  style="width:80%" value="1"><span>1</span></TD>	
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle"  style="width:80%" value=""><span>&nbsp;</span></TD>
			<%
		}
		else if(ordertype.equals("40285a90495b4eb001496408814f5996"))//送餐
		{
			%>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle"  style="width:80%" value=""><span>&nbsp;</span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" style="width:80%" value="1"><span>1</span></TD>
			<%
		}
		%>
		</TR>
<%
	}

	sublist = baseJdbc.executeSqlForList(countsqld);
	if(sublist.size()>0){
			mk = (Map)sublist.get(0);
			String dtotal =StringHelper.null2String(mk.get("dtotal"));
			%>
		<TR>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=dtotal%></font></TD>

		<%
	}
	sublist = baseJdbc.executeSqlForList(countsqls);
	if(sublist.size()>0){
			mk = (Map)sublist.get(0);
			String stotal =StringHelper.null2String(mk.get("stotal"));
			%>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=stotal%></font></TD>
		</TR>
		<%
	}

}

%>

</table>
</div>

