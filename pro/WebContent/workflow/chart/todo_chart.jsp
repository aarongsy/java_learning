<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%

String sql = SQLMap.getSQLString("workflow/chart/todo_chart.jsp");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
List list = baseJdbcDao.executeSqlForList(sql);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320028") %><!-- 代办事宜排名 --></title>
		<style type="text/css">
		td{padding:1px;}
		</style>
	</head>

	<body>
		<div style="float: left;padding:10px;">
			<table width="50%" border="1" cellpadding="0" cellspacing="0">
				<caption >
					<span style="font-weight: bold;padding:5px;"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320029") %><!-- 代办事宜最多排名 --></span>
					<span><img alt="打印" src="/images/silk/printer.gif" align="top" style="cursor:pointer" onclick="javascript:print();"></span>
				</caption>
				<thead style="color:#fff;background-color:#666;font-weight: bold;">
					<tr>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320026") %><!-- 排名 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b") %><!-- 姓名 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d") %><!-- 部门 --></td>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3932002a") %><!-- 数量 --></td>
					</tr>
				</thead>
				<tbody>
				<%for(int i=0;i<list.size();i++){
					Map map = (Map)list.get(i);
				%>
					<tr>
						<td><%=i+1%></td>
						<td><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=map.get("id")%>','<%=map.get("name")%>','tab<%=map.get("id")%>')"><%=map.get("name")%></a></td>
						<td><%=map.get("org")%></td>
						<td><%=map.get("sum")%></td>
					</tr>
					<%} %>
				</tbody>
			</table>
		</div>
	</body>
</html>
