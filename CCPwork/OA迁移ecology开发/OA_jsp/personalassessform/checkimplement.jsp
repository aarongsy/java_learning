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
String str = StringHelper.null2String(request.getParameter("str"));
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
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0 >
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
   //清空考核实施子表中的历史数据 
   //System.out.println("stsrt1");
   String sql1="delete from uf_hr_checkimplechild where requestid='"+requestid+"'";  
   baseJdbc.update(sql1);
   //查询考核计划主表中的所有信息
   sql1="select c.jobno,c.objname,c.objdept from uf_hr_checkplansub c where c.requestid='"+str+"'";   
   List sublist1 = baseJdbc.executeSqlForList(sql1);
   if(sublist1.size()>0)
   {
	        for(int k=0,sizek=sublist1.size();k<sizek;k++){
   		    Map mk1 = (Map)sublist1.get(k);
			String jobno=StringHelper.null2String(mk1.get("jobno"));
			String objname=StringHelper.null2String(mk1.get("objname"));
			String objdept=StringHelper.null2String(mk1.get("objdept"));
			String objscore="3";
			String ssql="select min(b.score) as objscore from uf_hr_scrcheck b where b.leavetype in(select a.reqtype from v_uf_hr_vacationsick a where a.objname='"+objname+"' group by a.reqtype) and b.little <=(select sum(a.hours) from v_uf_hr_vacationsick a where a.reqtype=b.leavetype and a.objname ='"+objname+"') and b.themax >(select sum(a.hours) from v_uf_hr_vacationsick a where a.reqtype=b.leavetype and a.objname ='"+objname+"')";
			List sublist2 = baseJdbc.executeSqlForList(ssql);
			if(sublist2.size()>0){
				   Map mk2 = (Map)sublist2.get(0);
				   objscore=StringHelper.null2String(mk2.get("objscore"));//初始化最小的考勤分数
			 }
			 if(objscore.equals("")||objscore.equals("null")||objscore.equals(" "))
			 {
				 objscore="3";
			 }
			String insql="insert into uf_hr_checkimplechild (id,requestid,ordernum,employnum,employname,belongdepartment,checkscore,teachscore,trainscore) values((select sys_guid() from dual),'"+requestid+"',"+(k+1)+",'"+jobno+"','"+objname+"','"+objdept+"',"+objscore+",0,0)";      
			 baseJdbc.update(insql);
	         }
         }
	   //System.out.println("end1");
       String sql = "select ordernum,employnum,(select objname from humres where id=a.employname) as employname,(select objname from orgunit where id=a.belongdepartment) as belongdepartment ,checkscore,teachscore,trainscore from  uf_hr_checkimplechild a where  a.requestid='"+requestid+"' order by ordernum";
       //System.out.println(sql);
       List sublists = baseJdbc.executeSqlForList(sql);
       if(sublists.size()>0){
	          for(int ks=0,sizeks=sublists.size();ks<sizeks;ks++){
		      Map mks = (Map)sublists.get(ks);
			  String ordernum=StringHelper.null2String(mks.get("ordernum"));
			  String employnum=StringHelper.null2String(mks.get("employnum"));
			  String employname=StringHelper.null2String(mks.get("employname"));
			  String belongdepartment=StringHelper.null2String(mks.get("belongdepartment"));
			  String checkscore=StringHelper.null2String(mks.get("checkscore"));
			  String teachscore=StringHelper.null2String(mks.get("teachscore"));
			  String trainscore=StringHelper.null2String(mks.get("trainscore"));
		%>
			<TR >
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
	<TR><TD class="td2" colspan="7">无对应员工！</TD></TR>
<%} 
System.out.println("end1");

%>
</table>
</div>
