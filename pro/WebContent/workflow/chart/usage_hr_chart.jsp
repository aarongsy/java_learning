<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%

String sql = SQLMap.getSQLString("workflow/chart/usage_hr_chart.jsp");

BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
List list = baseJdbcDao.executeSqlForList(sql);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3933002f") %><!-- 个人使用流程统计 --></title>
		<style type="text/css">
		td{padding:1px;}
		</style>
	</head>

	<body>
		<div style="float: left;padding:10px;">
			<table width="50%" border="1" cellpadding="0" cellspacing="0">
				<caption >
					<span style="font-weight: bold;padding:5px;"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3933002f") %><!-- 个人使用流程统计 --></span>
					<span><img alt="打印" src="/images/silk/printer.gif" align="top" style="cursor:pointer" onclick="javascript:print();"></span>
				</caption>
				<thead style="color:#fff;background-color:#666;font-weight: bold;">
					<tr>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320026") %><!-- 排名 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b") %><!-- 姓名 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d") %><!-- 部门 --></td>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3932002c") %><!-- 发起数量 --></td>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3933002e") %><!-- 归档 --></td>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3932002d") %><!-- 未归档 --></td>
					</tr>
				</thead>
				<tbody>
				<%for(int i=0;i<list.size();i++){
					Map map = (Map)list.get(i);
				%>
					<tr>
						<td><%=i+1%></td>
						<td><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=map.get("id")%>','<%=map.get("hr")%>','tab<%=map.get("id")%>')"><%=map.get("hr")%></a></td>
						<td><a href="#"><%=map.get("org")%></a></td>
						<td><%=map.get("s1")%></td>
						<td><%=map.get("s2")%></td>
						<td><%=map.get("s3")%></td>
					</tr>
					<%} %>
				</tbody>
			</table>
		</div>
	</body>
</html>
