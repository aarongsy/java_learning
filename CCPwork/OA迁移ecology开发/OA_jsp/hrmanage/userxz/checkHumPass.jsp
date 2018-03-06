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
	 String userid =  StringHelper.null2String(request.getParameter("userid"));
    String pass =  StringHelper.null2String(request.getParameter("pass"));

    String msg = "";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String insql = "insert into uf_hr_xzlog  (id,optime,pas,text)values('"+IDGernerator.getUnquieID()+"',(select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual),'"+userid+"','薪资查询')";
	baseJdbc.update(insql);
	//System.out.println(insql);
    DigestUtils digest = new DigestUtils();
   // System.out.println("查询密码未编译：" + pass);
    String sql = "select passw from  uf_hr_ygxzpass where humid='" + userid + "'";
    List list = baseJdbc.executeSqlForList(sql);
    int size = list.size();
    if (size <= 0)
    {
      msg = "不存在该用户的初始密码，无法查询";
      System.out.println(msg);
    }
    else
    {
      Map map = (Map)list.get(0);
      String passw = StringHelper.null2String(map.get("passw"));

      String passm = DigestUtils.md5Hex(pass);
      System.out.println("设定密码：" + passw);
      System.out.println("查询密码：" + passm);
      if (!passw.equals(passm))
      {
        msg = "密码不正确";
      }
      else {
        msg = "查询成功";
      }
      System.out.println(msg);
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
