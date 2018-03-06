<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.interfaces.util.SetEncoding"%>
<%@ include file="/base/init.jsp"%>
<%
	String sysPath=BaseContext.getRootPath();
    String filepath =sysPath+ "workflow" + File.separatorChar +"extpage"+ File.separatorChar;//文件目录
    SetEncoding.setEncodingByFilePath(filepath);
    out.println("设置成功！");
%>