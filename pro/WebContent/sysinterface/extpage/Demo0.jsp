<%@ page contentType="text/html; charset=UTF-8"%> 
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
 
 
 <%  
     String requestid = request.getParameter("requestid");//当前流程requestid 
     String nodeid = request.getParameter("nodeid");//流程当前节点 
     String issave = request.getParameter("issave");//是否保存 
     String isundo = request.getParameter("isundo");//是否撤回 
     String formid = request.getParameter("formid");//流程关联表单ID 
     String editmode = request.getParameter("editmode");//编辑模式 
     String maintablename = request.getParameter("maintablename");//关联流程的主表 
     String args = request.getParameter("arg");//获取接口中传入的文本参数 
 
 	 System.out.println(args +":" + requestid);
 
 %>

