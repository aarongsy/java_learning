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

<script type='text/javascript' language="javascript" src='/js/main.js'></script>

<div id="warpp">

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">

<COLGROUP>
<COL width="60">
<COL width="80">
<COL width="160">
<COL width="120">
<COL width="100">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="100">
<COL width="100">
<COL width="100">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="160">
<COL width="120">
<COL width="80">
<COL width="160">
</COLGROUP>

<TR style="font-size:12px;font-weight:bold;height: 20px;background:#f8f8f0">
	<TD noWrap align=center>序号</TD>
	<TD noWrap align=center>状态</TD>
	<TD noWrap align=center>培训课题</TD>
	<TD noWrap align=center>课程类型</TD>
	<TD noWrap align=center>培训对象</TD>
	<TD noWrap align=center>预计课时</TD>
	<TD noWrap align=center>讲师类型</TD>
	<TD noWrap align=center>讲师工号</TD>
	<TD noWrap align=center>培训讲师</TD>
	<TD noWrap align=center>预计实施时间</TD>
	<TD noWrap align=center>预计培训人数</TD>
	<TD noWrap align=center>上课方式</TD>
	<TD noWrap align=center>其他上课方式</TD>
	<TD noWrap align=center>考核方式</TD>
	<TD noWrap align=center>其他考核方式</TD>
	<TD noWrap align=center>备注</TD>
	<TD noWrap align=center>培训实施反馈</TD>
	<TD noWrap align=center>是否有效</TD>
	<TD noWrap align=center>作废/新增原因</TD>

<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));

	String sql="select a.*,(select objname from selectitem where id=a.state) as state1,(select objname from selectitem where id=a.leixing) as leixing1,(select objname from selectitem where id=a.duixiang) as duixiang1,(select objname from selectitem where id=a.jsleixing) as jsleixing1,(select objname from selectitem where id=a.skfs) as skfs1,(select objname from selectitem where id=a.khfs) as khfs1,(select objname from selectitem where id=a.isvalid) as isvalid1,(select objno from humres where id=a.jsno) as jsno1,(select objname from selectitem where id=b.state2) as state3,(select flowno1 from uf_hr_deptimple where requestid=a.fankui) fkobjname from uf_hr_bmpxjhdetail a,uf_hr_bmpxjh b where a.requestid='"+requestid+"' and b.requestid=a.requestid order by a.no asc";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		for(int k=0;k<list.size();k++)
		{

			Map map = (Map)list.get(k);
			String no = StringHelper.null2String(map.get("no"));//序号
			String state =StringHelper.null2String(map.get("state1"));//状态
			String keti =StringHelper.null2String(map.get("keti"));//培训课题
			String leixing =StringHelper.null2String(map.get("leixing1"));//课程类型
			String duixiang =StringHelper.null2String(map.get("duixiang1"));//培训对象
			String keshi =StringHelper.null2String(map.get("keshi"));//预计课时
			String jsleixing =StringHelper.null2String(map.get("jsleixing1"));//讲师类型
			String jiangshi =StringHelper.null2String(map.get("jiangshi"));//培训讲师
			String jsno =StringHelper.null2String(map.get("jsno1"));//讲师工号
			String shijian =StringHelper.null2String(map.get("shijian"));//预计实施时间
			String renshu =StringHelper.null2String(map.get("renshu"));//预计培训人数
			String skfs =StringHelper.null2String(map.get("skfs1"));//上课方式
			String qtskfs =StringHelper.null2String(map.get("qtskfs"));//其他上课方式
			String khfs =StringHelper.null2String(map.get("khfs1"));//考核方式
			String qtkhfs =StringHelper.null2String(map.get("qtkhfs"));//其他考核方式
			String beizhu =StringHelper.null2String(map.get("beizhu"));//备注
			String fankui =StringHelper.null2String(map.get("fkobjname"));//培训实施反馈
			String isvalid =StringHelper.null2String(map.get("isvalid1"));//是否有效
			String reason =StringHelper.null2String(map.get("reason"));//作废/新增原因
			String fkid =StringHelper.null2String(map.get("fankui"));//培训实施反馈
			String state2 =StringHelper.null2String(map.get("state3"));//新增/修改
			
			if(state2.equals("新增")||(state2.equals("修改")&&state.equals("原始")&&isvalid.equals("是")))
			{
				%>
				<TR height="16px">
					<TD noWrap align=center><%=no%></TD>
					<TD noWrap align=center><%=state%></TD>
					<TD noWrap align=center><%=keti%></TD>
					<TD noWrap align=center><%=leixing%></TD>
					<TD noWrap align=center><%=duixiang%></TD>
					<TD noWrap align=center><%=keshi%></TD>
					<TD noWrap align=center><%=jsleixing%></TD>
					<TD noWrap align=center><%=jsno%></TD>
					<TD noWrap align=center><%=jiangshi%></TD>
					<TD noWrap align=center><%=shijian%></TD>
					<TD noWrap align=center><%=renshu%></TD>
					<TD noWrap align=center><%=skfs%></TD>
					<TD noWrap align=center><%=qtskfs%></TD>
					<TD noWrap align=center><%=khfs%></TD>
					<TD noWrap align=center><%=qtkhfs%></TD>
					<TD noWrap align=center><%=beizhu%></TD>
					<TD noWrap align=center ><a href="javascript:onUrl('<%="/workflow/request/workflow.jsp?requestid="+fkid%>','<%=fankui%>','<%="tab"+fkid%>');"><%=fankui%></a></TD>
					<TD noWrap align=center><%=isvalid%></TD>
					<TD noWrap align=center><%=reason%></TD>
				</TR>
				<%
			}
			if(state2.equals("修改")&&state.equals("原始")&&isvalid.equals("否"))
			{
				%>
				<TR height="16px">
					<TD noWrap align=center><%=no%></TD>
					<TD noWrap align=center><%=state%></TD>
					<TD noWrap align=center><%=keti%></TD>
					<TD noWrap align=center><%=leixing%></TD>
					<TD noWrap align=center><%=duixiang%></TD>
					<TD noWrap align=center><%=keshi%></TD>
					<TD noWrap align=center><%=jsleixing%></TD>
					<TD noWrap align=center><%=jsno%></TD>
					<TD noWrap align=center><%=jiangshi%></TD>
					<TD noWrap align=center><%=shijian%></TD>
					<TD noWrap align=center><%=renshu%></TD>
					<TD noWrap align=center><%=skfs%></TD>
					<TD noWrap align=center><%=qtskfs%></TD>
					<TD noWrap align=center><%=khfs%></TD>
					<TD noWrap align=center><%=qtkhfs%></TD>
					<TD noWrap align=center><%=beizhu%></TD>
					<TD noWrap align=center><%=""%></TD>
					<TD noWrap align=center><%=isvalid%></TD>
					<TD noWrap align=center><%=reason%></TD>
				</TR>
				<%
			}
			if(state2.equals("修改")&&state.equals("新增"))
			{
				%>
				<TR height="16px" bgcolor="#EAC100">
					<TD noWrap align=center><%=no%></TD>
					<TD noWrap align=center><%=state%></TD>
					<TD noWrap align=center><%=keti%></TD>
					<TD noWrap align=center><%=leixing%></TD>
					<TD noWrap align=center><%=duixiang%></TD>
					<TD noWrap align=center><%=keshi%></TD>
					<TD noWrap align=center><%=jsleixing%></TD>
					<TD noWrap align=center><%=jsno%></TD>
					<TD noWrap align=center><%=jiangshi%></TD>
					<TD noWrap align=center><%=shijian%></TD>
					<TD noWrap align=center><%=renshu%></TD>
					<TD noWrap align=center><%=skfs%></TD>
					<TD noWrap align=center><%=qtskfs%></TD>
					<TD noWrap align=center><%=khfs%></TD>
					<TD noWrap align=center><%=qtkhfs%></TD>
					<TD noWrap align=center><%=beizhu%></TD>
					<TD noWrap align=center ><a href="javascript:onUrl('<%="/workflow/request/workflow.jsp?requestid="+fkid%>','<%=fankui%>','<%="tab"+fkid%>');"><%=fankui%></a></TD>
					<TD noWrap align=center><%=isvalid%></TD>
					<TD noWrap align=center><%=reason%></TD>
				</TR>
				<%
			}
			if(state.equals("作废"))
			{
				%>
				<TR height="16px" bgcolor="#FF7575">
					<TD noWrap align=center><%=no%></TD>
					<TD noWrap align=center><%=state%></TD>
					<TD noWrap align=center><%=keti%></TD>
					<TD noWrap align=center><%=leixing%></TD>
					<TD noWrap align=center><%=duixiang%></TD>
					<TD noWrap align=center><%=keshi%></TD>
					<TD noWrap align=center><%=jsleixing%></TD>
					<TD noWrap align=center><%=jsno%></TD>
					<TD noWrap align=center><%=jiangshi%></TD>
					<TD noWrap align=center><%=shijian%></TD>
					<TD noWrap align=center><%=renshu%></TD>
					<TD noWrap align=center><%=skfs%></TD>
					<TD noWrap align=center><%=qtskfs%></TD>
					<TD noWrap align=center><%=khfs%></TD>
					<TD noWrap align=center><%=qtkhfs%></TD>
					<TD noWrap align=center><%=beizhu%></TD>
					<TD noWrap align=center><%=""%></TD>
					<TD noWrap align=center><%=isvalid%></TD>
					<TD noWrap align=center><%=reason%></TD>
				</TR>
				<%
			}
		}
	}
%>
</table>
</div>