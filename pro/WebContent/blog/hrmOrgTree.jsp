<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.eweaver.blog.HrmOrgTree"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%
HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
String root = StringHelper.null2String(request.getParameter("root"));
response.setContentType("application/x-json; charset=UTF-8");
PrintWriter outPrint = response.getWriter();
outPrint.println(hrmOrg.getTreeData(root));
%>

