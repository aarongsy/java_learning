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
//String requestid = StringHelper.null2String(request.getParameter("requestid"));
String EmployNo=StringHelper.null2String(request.getParameter("employno"));//员工工号
String EmployName=StringHelper.null2String(request.getParameter("employname"));//员工姓名
String EmployAge=StringHelper.null2String(request.getParameter("employage"));//年龄
String Workyear=StringHelper.null2String(request.getParameter("workyear"));//年资
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
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=80>
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>工号</TD>
<TD  noWrap class="td2"  align=center>姓名</TD>
<TD  noWrap class="td2"  align=center>性别</TD>
<TD  noWrap class="td2"  align=center>生日</TD>
<TD  noWrap class="td2"  align=center>年龄</TD>
<TD  noWrap class="td2"  align=center>入职日期</TD>
<TD  noWrap class="td2"  align=center>年资</TD>
<TD  noWrap class="td2"  align=center>学历</TD>
<TD  noWrap class="td2"  align=center>职称</TD>
<TD  noWrap class="td2"  align=center>现职日期</TD>
</tr>

<%
  //显示考核实施子表里面的数据
  //String sql = "select ordernum,employnum,(select objname from humres where id=a.employname) as employname,(select objname from orgunit where id=a.belongdepartment) as belongdepartment ,checkscore,teachscore,trainscore from  uf_hr_checkimplechild a where  a.requestid='"+requestid+"' order by ordernum";
String sql="select objname,(select b.objname from selectitem b where h.gender=b.id ) as employsex,exttimefield9,extdatefield0,(select b.objname from selectitem b where b.id=h.extselectitemfield4 ) as education,(select b.nametext from uf_profe b where h.extrefobjfield4=b.requestid ) as position,(select max(currectdate) from uf_hr_curemploydate t where  t.employno=h.id) as currectdate  from humres h where id='"+EmployName+"'";

System.out.println(sql);
  List sublist = baseJdbc.executeSqlForList(sql);
  if(sublist.size()>0){
		 Map mk = (Map)sublist.get(0);
		 String EmployNameText=StringHelper.null2String(mk.get("objname"));//姓名
		 String EmploySex=StringHelper.null2String(mk.get("employsex"));//性别
		 String EmployBirth=StringHelper.null2String(mk.get("exttimefield9"));//出生日期
		 String EmployEntryDate=StringHelper.null2String(mk.get("extdatefield0"));//入职日期
		 String EmployEducation=StringHelper.null2String(mk.get("education"));//学历
		 String EmployPosition=StringHelper.null2String(mk.get("position"));//职称
		String currectdate=StringHelper.null2String(mk.get("currectdate"));//现职日期
		if(currectdate.equals("")||currectdate.equals("null"))
	  {
			currectdate=EmployEntryDate;
	  }
%>
<TR id="dataDetail">
<TD   class="td2"  align=center><%=EmployNo%></TD><!-- 员工工号-->
<TD   class="td2"  align=center><%=EmployNameText%></TD><!-- 员工姓名-->
<TD   class="td2"  align=center><%=EmploySex %></TD><!-- 员工性别-->
<TD   class="td2"  align=center><%=EmployBirth %></TD><!-- 出生日期-->
<TD   class="td2"  align=center><%=EmployAge%></TD><!-- 年龄-->
<TD   class="td2"  align=center><%=EmployEntryDate %></TD><!-- 入职日期-->
<TD   class="td2"  align=center><%=Workyear%></TD><!-- 年资-->
<TD   class="td2"  align=center><%=EmployEducation %></TD><!-- 学历-->
<TD   class="td2"  align=center><%=EmployPosition %></TD><!-- 职称-->
<TD   class="td2"  align=center><%=currectdate%></TD><!-- 现职日期-->
</tr>
<%		
}else{%> 
	<TR><TD class="td2" colspan="7">无对应员工信息!</TD></TR>
<%} 
%>
</table>
</div>
