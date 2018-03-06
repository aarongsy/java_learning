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

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
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


<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>员工工号</TD>
<TD  noWrap class="td2"  align=center>员工姓名</TD>
<TD  noWrap class="td2"  align=center>员工部门</TD>
<TD  noWrap class="td2"  align=center>考勤分数</TD>
<TD  noWrap class="td2"  align=center>授课分数</TD>
<TD  noWrap class="td2"  align=center>培训分数</TD>
</tr>

<%
  //显示考核实施子表里面的数据
  String sql = "select ordernum,employnum,(select objname from humres where id=a.employname) as employname,(select objname from orgunit where id=a.belongdepartment) as belongdepartment ,checkscore,teachscore,trainscore from  uf_hr_checkimplechild a where  a.requestid='"+requestid+"' order by ordernum";
  //System.out.println(sql);
  List sublist = baseJdbc.executeSqlForList(sql);


  if(sublist.size()>0){
	 for(int k=0,sizek=sublist.size();k<sizek;k++){
		 Map mk = (Map)sublist.get(k);
		 String ordernum=StringHelper.null2String(mk.get("ordernum"));
		 String employnum=StringHelper.null2String(mk.get("employnum"));
		 String employname=StringHelper.null2String(mk.get("employname"));
		 String belongdepartment=StringHelper.null2String(mk.get("belongdepartment"));
		 String checkscore=StringHelper.null2String(mk.get("checkscore"));
		 String teachscore=StringHelper.null2String(mk.get("teachscore"));
		 String trainscore=StringHelper.null2String(mk.get("trainscore"));
%>
<TR id="dataDetail">
<TD   class="td2"  align=center><%=ordernum %></TD>
<TD   class="td2"  align=center><%=employnum %></TD>
<TD   class="td2"  align=center><%=employname %></TD>
<TD   class="td2"  align=center><%=belongdepartment %></TD>
<TD   class="td2"  align=center><%=checkscore %></TD>
<TD   class="td2"  align=center><%=teachscore %></TD>
<TD   class="td2"  align=center><%=trainscore %></TD>
</tr>
<%		
	}
}else{%> 
	<TR><TD class="td2" colspan="7">无对应员工!</TD></TR>
<%} 
%>
</table>
</div>
