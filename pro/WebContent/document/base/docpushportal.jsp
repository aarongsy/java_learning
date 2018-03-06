<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isThreadSafe="true"%>
<%@ include file="/base/init.jsp"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>

<%
	DataService dataService = new DataService();
	BaseJdbcDao hsqldbDao = (BaseJdbcDao) BaseContext.getBean("hsqldbDao");

	EweaverUser user = BaseContext.getRemoteUser();
	String userid = user.getId();
	String stationid = user.getMainstation();
	String orgid = user.getOrgid();
	int seclevel = user.getSeclevel();
	
	String sql = "";
	
	Connection connection = null;
	try {
		connection = hsqldbDao.getDataSource().getConnection();
		ResultSet resultSet = connection.getMetaData().getTables(null, null, "docbasepush".toUpperCase(), null);
		if (!resultSet.next()) {
			hsqldbDao.update("create table docbasepush(id char(32), subject varchar(256), category varchar(256), creator varchar(256), creatorname varchar(256), createdate varchar(256), createtime varchar(256), createdt varchar(256), modifydate varchar(256), modifytime varchar(256), docabstract varchar(256), attachnum int, docstatus varchar(256), categoryids varchar(256), pusher varchar(256), pushername varchar(256), reason varchar(256), pushdate varchar(256), pushtime varchar(256), pushdt varchar(256), userids varchar(256), stationids varchar(256), orgids varchar(256), minseclevel int, maxseclevel int)");
		} 
	}  catch (SQLException e) {
		e.printStackTrace();
	}
	
	sql = "select count(distinct id) cnt from docbasepush where ((userids is not null and userids like '%" + userid + "%') or (stationids is not null and stationids like '%" + stationid + "%') or (orgids is not null and orgids like '%" + orgid + "%') or (minseclevel <= " + seclevel + " and (maxseclevel is null or (maxseclevel is not null and maxseclevel >= " + seclevel + "))))";
	int cnt = (Integer) hsqldbDao.executeForMap(sql).get("cnt");
	
	int top = NumberHelper.string2Int(request.getParameter("top"), 5);
	
	sql = "select limit " + top + " id, subject, creatorname, pushdate from docbasepush where ((userids is not null and userids like '%" + userid + "%') or (stationids is not null and stationids like '%" + stationid + "%') or (orgids is not null and orgids like '%" + orgid + "%') or (minseclevel <= " + seclevel + " and (maxseclevel is null or (maxseclevel is not null and maxseclevel >= " + seclevel + ")))) order by createdt desc";
	List<Map<String, Object>> list = hsqldbDao.executeSqlForList(sql);
	
	hsqldbDao.update("delete from docbasepush");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980019")%></title><!-- 知识推送 -->
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<style type="text/css">
	.x-toolbar table {
		width: 0
	}
	a {
		color: blue;
		cursor: pointer;
	}
	#pagemenubar table {
		width: 0
	}
	.x-panel-btns-ct {
		padding: 0px;
	}
	.x-panel-btns-ct table {
		width: 0
	}
	.more {
		float: right;
		padding-right: 20px;
	}
</style>

</head>
<body>
	<div id="divSearch">
	<div id="pagemenubar"></div>
		<table>	
			<thead>
				<tr>
					<th width="*"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%></th><!-- 标题 -->
					<th width="30%"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980023")%></th><!--推送人  -->
					<th width="30%"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980024")%></th><!--推送日期  -->
				</tr>
			</thead>
			<tbody>
			<%
				for (Map<String, Object> map : list) {
					String id = (String) map.get("id");
					String subject = (String) map.get("subject");
			%>
				<tr>
					<td>
						<a href="javascript:onUrl('/document/base/docbaseview.jsp?id=<%=id%>','<%=subject%>','tab<%=id%>')"><%=subject%></a>
					</td>
					<td><%=map.get("creatorname")%></td>
					<td><%=map.get("pushdate")%></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<div >
			<a class="more" href="/document/base/docpushlist.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015")%>(<%=list.size()%>/<%=cnt%>)...</a>
		</div>
	</div>
</body>
</html>