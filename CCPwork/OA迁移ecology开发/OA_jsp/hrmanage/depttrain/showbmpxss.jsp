<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String requestid = StringHelper.null2String(request.getParameter("requestid"));
%>
<style type="text/css"> 
tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 
} 
</style>

<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<DIV id="warpp">

<TABLE id=oTable40285a90490d16a301491ca30dd12ad6 class=detailtable border=1>
<COLGROUP>
<COL width="40">
<COL width="60">
<COL width="80">
<COL width="160">
<COL width="80">
<COL width="80">
<COL width="120">
<COL width="80">
<COL width="80">
<COL width="100">
<COL width="120">
<COL width="100">
<COL width="120">
<COL width="120">
</COLGROUP>
<TBODY>
<TR class=Header>
	<TD noWrap align=center>序号</TD>
	<TD noWrap align=center>工号</TD>
	<TD noWrap align=center>姓名</TD>
	<TD noWrap align=center>部门</TD>
	<TD noWrap align=center>培训对象</TD>
	<TD noWrap align=center>人员类型</TD>
	<TD noWrap align=center>培训课题</TD>
	<TD noWrap align=center>培训课时</TD>
	<TD noWrap align=center>培训成绩</TD>
	<TD noWrap align=center>上课方式</TD>
	<TD noWrap align=center>其他上课方式</TD>
	<TD noWrap align=center>考核方式</TD>
	<TD noWrap align=center>其他考核方式</TD>
	<TD noWrap align=center>备注</TD>
</TR>
<%
	String sql="select a.*,(select objname from humres where id=a.objname) name,(select objname from orgunit where id=a.reqdept) bumen,(select objname from selectitem where id=b.duixiang1) duixiang,(select objname from selectitem where id=a.humtype) leixing,(select objname from selectitem where id=a.skfs1) skfs,(select objname from selectitem where id=a.khfs1) khfs from uf_hr_deptimplesub a,uf_hr_deptimple b where b.requestid=a.requestid and a.requestid='"+requestid+"' order by a.no asc";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		for(int k=0;k<list.size();k++)
		{
			Map map = (Map)list.get(k);
			String no = StringHelper.null2String(map.get("no"));
			String jobno = StringHelper.null2String(map.get("jobno"));
			String objname = StringHelper.null2String(map.get("name"));
			String reqdept = StringHelper.null2String(map.get("bumen"));
			String duixiang = StringHelper.null2String(map.get("duixiang"));
			String humtype = StringHelper.null2String(map.get("leixing"));
			String title = StringHelper.null2String(map.get("title"));
			String hours = StringHelper.null2String(map.get("hours"));
			String score = StringHelper.null2String(map.get("score"));
			String skfs1 = StringHelper.null2String(map.get("skfs"));
			String qtskfs1 = StringHelper.null2String(map.get("qtskfs1"));
			String khfs1 = StringHelper.null2String(map.get("khfs"));
			String qtkhfs1 = StringHelper.null2String(map.get("qtkhfs1"));
			String beizhu1 = StringHelper.null2String(map.get("beizhu1"));
%>
			<TR height="16px">
				<TD noWrap align=center><%=no%></TD>
				<TD noWrap align=center><%=jobno%></TD>
				<TD noWrap align=center><%=objname%></TD>
				<TD noWrap align=center><%=reqdept%></TD>
				<TD noWrap align=center><%=duixiang%></TD>
				<TD noWrap align=center><%=humtype%></TD>
				<TD noWrap align=center><%=title%></TD>
				<TD noWrap align=center><%=hours%></TD>
				<TD noWrap align=center><%=score%></TD>
				<TD noWrap align=center><%=skfs1%></TD>
				<TD noWrap align=center><%=qtskfs1%></TD>
				<TD noWrap align=center><%=khfs1%></TD>
				<TD noWrap align=center><%=qtkhfs1%></TD>
				<TD noWrap align=center><%=beizhu1%></TD>
			</TR>
<%
		}
	}
%>
</TBODY>
</TABLE>
</DIV>