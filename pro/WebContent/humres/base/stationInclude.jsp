<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.selectitem.service.*"%>
<%@ page import="java.util.*"%>
<%
SelectitemService selectitemService=(SelectitemService)BaseContext.getBean("selectitemService");
Map<String,String> stationStatusMap=new HashMap<String,String>();
stationStatusMap.put("402880d319eb81720119eba4e1e70004",selectitemService.getSelectitemNameById("402880d319eb81720119eba4e1e70004"));
stationStatusMap.put("402880d319eb81720119eba4e1e70005",selectitemService.getSelectitemNameById("402880d319eb81720119eba4e1e70005"));
%>
