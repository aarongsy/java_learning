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
	String userid = StringHelper.null2String(request.getParameter("userid"));
	String oldpass = StringHelper.null2String(request.getParameter("xzoldpass"));
	String newpass = StringHelper.null2String(request.getParameter("xznewpass"));


    String msg = "";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DigestUtils digest = new DigestUtils();
	String insqls = "insert into uf_hr_xzlog  (id,optime,pas,text)values('"+IDGernerator.getUnquieID()+"',(select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual),'"+userid+"','密码修改')";
	baseJdbc.update(insqls);
   // System.out.println("管理员密码：------------" + DigestUtils.md5Hex("123456"));
    String sql = "select passw from  uf_hr_ygxzpass where humid='" + userid + "'";
    List list = baseJdbc.executeSqlForList(sql);
    int size = list.size();
    if (size <= 0)
    {
      msg = "不存在该用户的初始密码";
      System.out.println(msg);
    }
    else
    {
      Map map = (Map)list.get(0);
      String passw = StringHelper.null2String(map.get("passw"));

      String passm = DigestUtils.md5Hex(oldpass);
      //System.out.println("数据库：" + passw);
      //System.out.println("输入原始密码：" + passm);
      if (!passw.equals(passm))
      {
        msg = "原始密码不正确";
      }
      else {
        String passnew = DigestUtils.md5Hex(newpass);
        String insql = "update uf_hr_ygxzpass set passw='" + passnew + "' where humid='" + userid + "'";
        System.out.println(insql);
        baseJdbc.update(insql);
        msg = "密码修改成功";
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
