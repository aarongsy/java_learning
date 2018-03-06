<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
	String sql = request.getParameter("sql");
	DataService dataService = new DataService();
	if(StringHelper.isEmpty(sql)) return;
	try{
		dataService.executeSql(sql);
		System.out.println(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001c"));//执行成功！
		out.println("true");
	}catch(Exception e){
		System.out.println(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001d"));//执行失败！
		out.println("false");
	}
%>

