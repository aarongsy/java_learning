<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %>
<%
	String requestid= request.getParameter("id");
	String userid = request.getParameter("userid");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String reqtype = request.getParameter("reqtype");
	String deptid = request.getParameter("deptid");
	String type = request.getParameter("type");
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List ls=null;
	if(type.equals("planmonth"))
	{
		
		
		//公司 4028807327d62d810127d63cdb5f0008
		//部门 4028807327d62d810127d63cdb5f0009
		//个人 4028807327d62d810127d63cdb5f000a
		if(reqtype.equals("4028807327d62d810127d63cdb5f0008"))
		{
			sql="select requestid from uf_plan_planmain where requestid in (select id from requestbase where isdelete=0) and plantype='"+reqtype+"' and reqyear='"+year+"' and reqmonth='"+month+"' and requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本月公司计划已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f0009"))
		{
			sql="select requestid from uf_plan_planmain where requestid in (select id from requestbase where isdelete=0) and plantype='"+reqtype+"' and reqyear='"+year+"' and reqmonth='"+month+"' and reqdept='"+deptid+"' and requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本月部门计划已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f000a"))
		{
			sql="select requestid from uf_plan_planmain where requestid in (select id from requestbase where isdelete=0) and plantype='"+reqtype+"' and reqyear='"+year+"' and reqmonth='"+month+"' and reqman='"+userid+"' and requestid<>'"+requestid+"'";
			System.out.println(sql);
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本月计划已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
	}
	else if(type.equals("planyear"))
	{
		if(reqtype.equals("4028807327d62d810127d63cdb5f0008"))
		{
			sql="select requestid from uf_plan_planmain where requestid in (select id from requestbase where isdelete=0) and plantype='"+reqtype+"' and reqyear='"+year+"'  and requestid<>'"+requestid+"' and reqarea='4028807327d62d810127d63c54ce0006'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本年公司计划已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f0009"))
		{
			sql="select requestid from uf_plan_planmain where requestid in (select id from requestbase where isdelete=0) and plantype='"+reqtype+"' and reqyear='"+year+"' and reqdept='"+deptid+"' and requestid<>'"+requestid+"' and reqarea='4028807327d62d810127d63c54ce0006'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本年部门计划已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f000a"))
		{
			sql="select requestid from uf_plan_planmain where  requestid in (select id from requestbase where isdelete=0) and plantype='"+reqtype+"' and reqyear='"+year+"' and reqman='"+userid+"' and requestid<>'"+requestid+"' and reqarea='4028807327d62d810127d63c54ce0006'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本年计划已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
	}
	else if(type.equals("sumyear"))
	{
		if(reqtype.equals("4028807327d62d810127d63cdb5f0008"))
		{
			sql="select requestid from uf_plan_summarymain where requestid in (select id from requestbase where isdelete=0) and sumtype='"+reqtype+"' and reqyear='"+year+"' and sumarea='4028807327d62d810127d63c54ce0006'  and requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本年公司总结已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f0009"))
		{
			sql="select requestid from uf_plan_summarymain where  requestid in (select id from requestbase where isdelete=0) and sumtype='"+reqtype+"' and reqyear='"+year+"' and sumarea='4028807327d62d810127d63c54ce0006' and reqdept='"+deptid+"' and requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本年部门总结已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f000a"))
		{
			sql="select requestid from uf_plan_summarymain where  requestid in (select id from requestbase where isdelete=0) and sumtype='"+reqtype+"' and reqyear='"+year+"' and reqman='"+userid+"' and sumarea='4028807327d62d810127d63c54ce0006' and requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本年总结已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
	}
	else if(type.equals("summonth"))
	{
		//公司 4028807327d62d810127d63cdb5f0008
		//部门 4028807327d62d810127d63cdb5f0009
		//个人 4028807327d62d810127d63cdb5f000a
		if(reqtype.equals("4028807327d62d810127d63cdb5f0008"))
		{
			sql="select requestid from uf_plan_summarymain where  requestid in (select id from requestbase where isdelete=0) and sumtype='"+reqtype+"' and reqyear='"+year+"' and reqmonth='"+month+"' and sumarea='4028807327d62d810127d63c54ce0007' and  requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本月公司总结已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f0009"))
		{
			sql="select requestid from uf_plan_summarymain where requestid in (select id from requestbase where isdelete=0) and sumtype='"+reqtype+"' and reqyear='"+year+"' and reqmonth='"+month+"' and reqdept='"+deptid+"'  and sumarea='4028807327d62d810127d63c54ce0007' and requestid<>'"+requestid+"'";
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本月部门总结已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
		else if(reqtype.equals("4028807327d62d810127d63cdb5f000a"))
		{
			sql="select requestid from uf_plan_summarymain where requestid in (select id from requestbase where isdelete=0) and sumtype='"+reqtype+"'  and sumarea='4028807327d62d810127d63c54ce0007' and reqyear='"+year+"' and reqmonth='"+month+"' and reqman='"+userid+"' and requestid<>'"+requestid+"'";
			System.out.println(sql);
			ls = baseJdbc.executeSqlForList(sql);
			if(ls.size()>0)
			{
				out.println("本月总结已提交！");
				return;
			}
			else 
			{
				out.println("yes");
				return;
			}
		}
	}
%>