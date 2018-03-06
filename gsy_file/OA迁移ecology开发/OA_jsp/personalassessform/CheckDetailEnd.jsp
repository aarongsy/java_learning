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
String requestid=StringHelper.null2String(request.getParameter("requestid"));
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
<script type='text/javascript' language="javascript"></script>

<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0  style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width=150>
<COL width=120>
<COL width=120>
<COL width=80>
<COL width=80>
<COL width=80>
<COL width=120>
<COL width=120>
<COL width=140>
<COL width=140>
<COL width=120>
<COL width=120>
<COL width=50>
</COLGROUP>

<TR  class="tr1">
<TD  noWrap class="td2"  align=center>考核计划</TD>
<TD  noWrap class="td2"  align=center>主管</TD>
<TD  noWrap class="td2"  align=center>部门</TD>
<TD  noWrap class="td2"  align=center>工号</TD>
<TD  noWrap class="td2"  align=center>被考核人</TD>
<TD  noWrap class="td2"  align=center>评分</TD>
<TD  noWrap class="td2"  align=center>人事主管修改评分</TD>
<TD  noWrap class="td2"  align=center>人事主管修改评语</TD>
<TD  noWrap class="td2"  align=center>人事分管领导修改评分</TD>
<TD  noWrap class="td2"  align=center>人事分管领导修改评语</TD>
<TD  noWrap class="td2"  align=center>总经理修改评分</TD>
<TD  noWrap class="td2"  align=center>总经理修改评语</TD>
<TD  noWrap class="td2"  align=center>最终评分</TD>
</tr>

<%
  //考核计划、主管、部门、工号、被考核人
  /*String sql ="select (select a.planname from uf_hr_checkplan a where a.requestid=(select b.checkplan from uf_hr_checkperformance b where b.checkyear='"+Year+"'))as checkplan,(select h.firstdirector from uf_hr_checkperformance h where h.checkyear='"+Year+"' ) as director,(select d.objname from orgunit d,uf_hr_checkperformance i where i.employdepart=d.id)as employdepart,(select g.employno from uf_hr_checkperformance g where g.checkyear='"+Year+"' ) as employno,(select c.objname from humres c,uf_hr_checkperformance j where c.objno=j.employno) as employname from uf_hr_checkperformance f where f.checkyear='"+Year+"'";*/

  //查询绩效考核汇总子表中的明细
  String sql="select checkprocess,checkplan,director,(select objname from orgunit where id=firstdepart) as dept,employno,employname,score,leadermodifyscore,leadermodifycomment,dirmodifyscore,dirmodifycomment,manmodifyscore,manmodifycomment,lastscore from uf_checkcollectchild where requestid='"+requestid+"' order by employno";
System.out.println("************************************************************8"+sql);
  List sublist = baseJdbc.executeSqlForList(sql);
  if(sublist.size()>0){
	 for(int k=0,sizek=sublist.size();k<sizek;k++){
		 Map mk = (Map)sublist.get(k);
		 String checkprocess=StringHelper.null2String(mk.get("checkprocess"));//考核流程
		 String checkplan=StringHelper.null2String(mk.get("checkplan"));//考核计划
		 String director=StringHelper.null2String(mk.get("director"));//主管
		 String department=StringHelper.null2String(mk.get("dept"));//部门
		 String employno=StringHelper.null2String(mk.get("employno"));//工号
		 String employname=StringHelper.null2String(mk.get("employname"));//被考核人
		 String score=StringHelper.null2String(mk.get("score"));//评分
		 String leadermodifyscore=StringHelper.null2String(mk.get("leadermodifyscore"));//人事分管领导修改评分
		 String leadermodifycomment=StringHelper.null2String(mk.get("leadermodifycomment"));//人事分管领导修改评语
		 String dirmodifyscore=StringHelper.null2String(mk.get("dirmodifyscore"));//人事主管修改评分
		 String dirmodifycomment=StringHelper.null2String(mk.get("dirmodifycomment"));//人事主管修改评语
		 String manmodifyscore=StringHelper.null2String(mk.get("manmodifyscore"));//总经理修改评分
		 String manmodifycomment=StringHelper.null2String(mk.get("manmodifycomment"));//总经理修改评语
		 String lastscore=StringHelper.null2String(mk.get("lastscore"));//最终评分
%>
<TR class="tr1">
<TD  class="td2"  align=center><%=checkplan%></TD><!--考核计划 -->
<TD  class="td2"  align=center><%=director%></TD><!--主管 -->
<TD  class="td2"  align=center><%=department%></TD><!--部门-->
<TD  class="td2"  align=center><%=employno%></TD><!--工号-->
<TD  class="td2"  align=center><%=employname%></TD><!--被考核人-->
<TD  class="td2"  align=center><%=score%></TD><!--评分-->

<%
if(dirmodifyscore.equals(score))
{%>
<TD  class="td2"  align=center></TD><!--人事主管修改评分 -->
<TD  class="td2"  align=center></TD><!--人事主管修改评语 -->
<%}
else
{%>
<TD  class="td2"  align=center><%=dirmodifyscore%></TD><!--人事主管修改评分 -->
<TD  class="td2"  align=center><%=dirmodifycomment%></TD><!--人事主管修改评语 -->
<%}
%>

<%
if(leadermodifyscore.equals(dirmodifyscore))
{%>
<TD  class="td2"  align=center></TD><!--人事分管领导修改评分 -->
<TD  class="td2"  align=center></TD><!--人事分管领导修改评语 -->
<%}
else
{%>
<TD  class="td2"  align=center><%=leadermodifyscore%></TD><!--人事分管领导修改评分 -->
<TD  class="td2"  align=center><%=leadermodifycomment%></TD><!--人事分管领导修改评语 -->
<%}
%>

<%
if(manmodifyscore.equals(leadermodifyscore))
{%>
<TD  class="td2"  align=center></TD><!--总经理修改评分 -->
<TD  class="td2"  align=center></TD><!--总经理修改评语 -->
<%}
else
{%>
<TD  class="td2"  align=center><%=manmodifyscore%></TD><!--总经理修改评分 -->
<TD  class="td2"  align=center><%=manmodifycomment%></TD><!--总经理修改评语 -->
<%}
%>

<TD  class="td2"  align=center><%=lastscore%></TD><!-- 最终评分-->
</tr>
<%		
	}
}else{%> 
	<TR class="tr1">
	<TD class="td2" colspan="14">无对应员工信息!</TD>
	</TR>
<%} 
%>
</table>
</div>
