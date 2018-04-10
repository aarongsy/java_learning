<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>
<%@ page import="weaver.soa.workflow.request.RequestService" %>
<%@ page import="weaver.soa.workflow.request.* " %>
<%@ page import="weaver.interfaces.workflow.action.Z_CPP_SO_LHSQ_ZF" %>

<%
        BaseBean bean = new BaseBean();
        bean.writeLog("Z_CPP_SO_LHSQ_ZF_jsp");
        try {
                String requestid=request.getParameter("reqid");
                RequestInfo info = new RequestService().getRequest(Integer.valueOf(requestid));
                bean.writeLog(">>>reqid>>>"+requestid);
                out.print(new Z_CPP_SO_LHSQ_ZF().execute(info));

        }catch (Exception e){
                e.printStackTrace();
                bean.writeLog(e);
                out.print(e);
        }
%>