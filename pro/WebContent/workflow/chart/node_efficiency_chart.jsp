<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
//Oracle语句，暂不支持SQLServer，
String sql = "select wid,workflow,node,hid,humres,receive, submit,ROUND(TO_NUMBER(submit - receive) * 24 * 60) as mm from("
			+"select r.id as wid,r.requestname as workflow, n.objname as node,h.id as hid,h.objname as humres,"
			+"to_date(concat(s.receivedate||' ',s.receivetime),'yyyy-MM-dd HH24:mi:ss') as receive,"
			+"to_date(concat(s.submitdate||' ',s.submittime),'yyyy-MM-dd HH24:mi:ss') as submit "
			+"from requeststep s,requestbase r,nodeinfo n,humres h "
			+"where receivedate is not null  "
			+"and receivetime is not null "
			+"and submitdate is not null "
			+"and submittime is not null "
			+"and s.requestid=r.id "
			+"and s.nodeid=n.id "
			+"and n.nodetype<>1 "
			+"and n.isdelete<>1 "
			+"and s.receiver=h.id "
			+"and r.isdelete=0 "
			+")where rownum<=20 "
			+"order by mm desc";

BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
List list = baseJdbcDao.executeSqlForList(sql);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320025") %><!-- 流程节点效率统计 --></title>
		<style type="text/css">
		td{padding:1px;}
		</style>
	</head>

	<body>
		<div style="float: left;padding:10px;">
			<table width="50%" border="1" cellpadding="0" cellspacing="0">
				<caption >
					<span style="font-weight: bold;padding:5px;"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320025") %><!-- 流程节点效率统计 --></span>
					<span><img alt="打印" src="/images/silk/printer.gif" align="top" style="cursor:pointer" onclick="javascript:print();"></span>
				</caption>
				<thead style="color:#fff;background-color:#666;font-weight: bold;">
					<tr>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320026") %><!-- 排名 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a942a9002b") %><!-- 流程名称 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c7248aaad0072") %><!-- 节点名称 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76b1476b0034") %><!-- 操作者 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c7693133e0007") %><!-- 接收时间 --></td>
						<td><%=labelService.getLabelNameByKeyId("402881e70b65e2b3010b65e5e5fc0006") %><!-- 提交时间 --></td>
						<td><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320027") %><!-- 耗时（分钟） --></td>
					</tr>
				</thead>
				<tbody>
				<%for(int i=0;i<list.size();i++){
					Map map = (Map)list.get(i);
				%>
					<tr>
						<td><%=i+1%></td>
						<td><a href="javascript:onUrl('/workflow/request/workflow.jsp?targeturl=/base/blank.jsp?isclose=1&requestid=<%=map.get("wid")%>','<%=map.get("workflow")%>','tabff8080812979404701297d2d41730193')"><%=map.get("workflow")%></a></td>
						<td><%=map.get("node")%></td>
						<td><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=map.get("hid")%>','<%=map.get("humres")%>','tab<%=map.get("hid")%>')"><%=map.get("humres")%></a></td>
						<td><%=map.get("receive")%></td>
						<td><%=map.get("submit")%></td>
						<td><%=map.get("mm")%></td>
					</tr>
					<%} %>
				</tbody>
			</table>
		</div>
	</body>
</html>
