<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>


<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.base.util.StringFilter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintStream" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>


<%
	String action = StringHelper.null2String(request.getParameter("action"));
	String comtype = StringHelper.null2String(request.getParameter("comtype"));
	String jobno = StringHelper.null2String(request.getParameter("jobno"));


    String msg = "";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String insqls = "insert into uf_hr_xzlog  (id,optime,pas,text)values('"+IDGernerator.getUnquieID()+"',(select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual),'"+jobno+"','密码重置')";
	baseJdbc.update(insqls);
    DigestUtils digest = new DigestUtils();
    String sql = "";
	if(action.equals("update"))
	{
		sql="select humid from uf_hr_ygxzpass where area='"+comtype+"'";
	}
	else
	{
		sql="select humid from uf_hr_ygxzpass where jobno='"+jobno+"'";
	}
	System.out.println(sql);
    List list = baseJdbc.executeSqlForList(sql);
    int size = list.size();
    if (size <= 0)
    {
      msg = "不存在该用户的初始密码";
      System.out.println(msg);
    }
    else
    {
		String humid="";
		String ssql="";
		String usql="";
		for(int i=0;i<size;i++)
		{
		  Map map = (Map)list.get(i);
		  humid = StringHelper.null2String(map.get("humid"));
		  /*ssql="select col1 from humres where id='"+humid+"'";
		  String col1="";
		  List lists = baseJdbc.executeSqlForList(ssql);
		  if(lists.size()>0)
			{
			  Map maps = (Map)lists.get(0);
			  col1=StringHelper.null2String(maps.get("col1"));
			  System.out.println(col1);
			}*/
			//if(!col1.equals(""))
			//{	
				String passnew = DigestUtils.md5Hex("123456");
				String insql = "update uf_hr_ygxzpass set passw='" + passnew + "' where humid='" + humid + "'";
				System.out.println(insql);
				baseJdbc.update(insql);
				msg = "密码修改成功";
				
			//}
		}
    }
    JSONObject objectresult = new JSONObject();
    objectresult.put("msg", msg);
    try {
      response.setContentType("application/json; charset=utf-8");

      response.getWriter().write(objectresult.toString());
      response.getWriter().flush();
      response.getWriter().close();


    } catch (IOException e) {
      e.printStackTrace();
    }
%>
