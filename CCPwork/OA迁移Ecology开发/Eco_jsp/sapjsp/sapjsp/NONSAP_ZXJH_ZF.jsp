<%@ page import="weaver.soa.workflow.request.RequestInfo" %>
<%@ page import="weaver.soa.workflow.request.RequestService" %>
<%@ page import="weaver.interfaces.workflow.action.Z_CCP_NON_SAP_ZXJH_ZF" %>
<%@page language="java" contentType="text/html; UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="log" class="weaver.general.BaseBean"/>
<%
    log.writeLog("进入非SAP装卸计划作废，NONSAP_ZXJH_ZF.jsp");
    try {
        String requestid=request.getParameter("reqid");
        log.writeLog(">>>reqid>>>"+requestid);
        RequestInfo requestInfo=new RequestService().getRequest(Integer.valueOf(requestid));
        out.write(new Z_CCP_NON_SAP_ZXJH_ZF().execute(requestInfo));
    }catch (Exception e){
        e.printStackTrace();
    }

%>