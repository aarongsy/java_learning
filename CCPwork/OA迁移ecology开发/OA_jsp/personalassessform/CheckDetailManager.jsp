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
<script type='text/javascript' language="javascript" ></script>


<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width=50>
<COL width=60>
<COL width=120>
<COL width=120>
<COL width=160>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=140>
<COL width=140>
<COL width=120>
<COL width=120>
</COLGROUP>

<TR class="tr1">
<TD  noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>序号</TD>
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
</tr>

<%
  //清空绩效考核汇总子表中的明细
  //String del="delete  uf_checkcollectchild where requestid='"+requestid+"'";
  //baseJdbc.update(del);
  //考核计划、主管、部门、工号、被考核人
  //String sql ="select (select a.planname from uf_hr_checkplan a where a.requestid=(select b.checkplan from uf_hr_checkperformance b where b.checkyear='"+Year+"'))as checkplan,(select h.firstdirector from uf_hr_checkperformance h where h.checkyear='"+Year+"' ) as director,(select d.objname from orgunit d,uf_hr_checkperformance i where i.employdepart=d.id)as employdepart,(select g.employno from uf_hr_checkperformance g where g.checkyear='"+Year+"' ) as employno,(select c.objname from humres c,uf_hr_checkperformance j where c.objno=j.employno) as employname from uf_hr_checkperformance f where f.checkyear='"+Year+"'";

  //查询绩效考核汇总子表中的明细
  String sql="select checkprocess,checkplan,director,department,(select objname from orgunit where id=firstdepart) as dept,employno,employname,score,dirmodifyscore,dirmodifycomment,leadermodifyscore,leadermodifycomment,manmodifyscore,manmodifycomment from uf_checkcollectchild where requestid='"+requestid+"' order by employno";

  List sublist = baseJdbc.executeSqlForList(sql);
  String selected1="";
  String selected2="";
  String selected3="";
  String selected4="";
  String selected5="";
  String selected6="";
  String selected7="";
  String selected8="";
  String selected9="";
  String selected10="";
  String selected11="";
  String selected12="";
  if(sublist.size()>0){
	 for(int k=0,sizek=sublist.size();k<sizek;k++){
		 Map mk = (Map)sublist.get(k);
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 String checkprocess=StringHelper.null2String(mk.get("checkprocess"));//考核流程
		 String checkplan=StringHelper.null2String(mk.get("checkplan"));//考核计划
		 String director=StringHelper.null2String(mk.get("director"));//主管
		 String department=StringHelper.null2String(mk.get("dept"));//部门(一级)
		 String employno=StringHelper.null2String(mk.get("employno"));//工号
		 String employname=StringHelper.null2String(mk.get("employname"));//被考核人
		 String score=StringHelper.null2String(mk.get("score"));//评分
		 String dirmodifyscore=StringHelper.null2String(mk.get("dirmodifyscore"));//人事主管评分
		 String dirmodifycomment=StringHelper.null2String(mk.get("dirmodifycomment"));//人事主管评语
		 String leadermodifyscore=StringHelper.null2String(mk.get("leadermodifyscore"));//人事分管领导评分
		 String leadermodifycomment=StringHelper.null2String(mk.get("leadermodifycomment"));//人事分管领导评语
		 String manmodifyscore=StringHelper.null2String(mk.get("manmodifyscore"));//总经理修改评语
		 String manmodifycomment=StringHelper.null2String(mk.get("manmodifycomment"));//总经理修改评语
         //将考核明细插入绩效考核汇总子表
		 //String insql="insert into uf_checkcollectchild(id,requestid,checkprocess,checkplan,director,department,employno,employname,score,leadermodifyscore,leadermodifycomment,dirmodifyscore,dirmodifycomment,manmodifyscore,manmodifycomment,lastscore,ordernum)values((select sys_guid() from dual),'"+requestid+"','','"+checkplan+"','"+director+"','"+employdepart+"','"+employno+"','"+employname+"',null,null,'',null,'',null,'',null,"+(k+1)+")";
		 //baseJdbc.update(insql);

		 String jxsql="update uf_checkcollectchild set initscore='"+leadermodifyscore+"', manmodifyscore="+leadermodifyscore+",lastscore="+leadermodifyscore+" where requestid='"+requestid+"' and employno='"+employno+"'";
		 //System.out.println(jxsql);
		 baseJdbc.update(jxsql);
%>
<TR   id="dataDetail" class="tr1">
<!--<TD   class="td2"  align=center><input type="checkbox" id="" name="che"></TD>--><!--序号 -->
<TD   class="td2"  align=center><input id=<%="che"+k%> name="che" type="checkbox"></TD>
<TD   class="td2"  align=center><%=checkplan%></TD><!--考核计划 -->
<TD   class="td2"  align=center><%=director%></TD><!--主管 -->
<TD   class="td2"  align=center><%=department%></TD><!--部门-->
<TD   class="td2"  align=center><input id="<%="jobno"+k%>" type="hidden" value="<%=employno%>"><%=employno%></TD><!--工号-->
<TD   class="td2"  align=center><%=employname%></TD><!--被考核人-->
<TD   class="td2"  align=center><%=score%></TD><!--评分-->
<TD   class="td2"  align=center><%=dirmodifyscore%></TD><!--人事主管评分-->
<TD   class="td2"  align=center><%=dirmodifycomment%></TD><!--人事主管评语-->
<TD   class="td2"  align=center><%=leadermodifyscore%></TD><!--人事分管领导评分-->
<TD   class="td2"  align=center><%=leadermodifycomment%></TD><!--人事分管领导评语-->
<%
if(manmodifyscore.equals(leadermodifyscore))
{%>
<TD   class="td2"  align=center>
<select id="<%="select_"+k%>" style="width:120px" onchange="ChangeScore('<%="id1"+k%>','<%=employno%>','<%=k%>')">
<option value="<%=leadermodifyscore%>"></option>
<option value="0">0</option>
<option value="0.5">0.5</option>
<option value="1">1</option>
<option value="1.5">1.5</option>
<option value="2">2</option>
<option value="2.5">2.5</option>
<option value="3">3</option>
<option value="3.5">3.5</option>
<option value="4">4</option>
<option value="4.5">4.5</option>
<option value="5">5</option>
</select>
</TD><!--总经理修改评分 -->
<%}
else
{
	if(dirmodifyscore.equals("0"))
		 {
			 selected1="selected";
		 }
		 else if(dirmodifyscore.equals("0.5"))
		 {
			 selected2="selected";
		 }
		 else if(dirmodifyscore.equals("1"))
		 {
			 selected3="selected";
		 }
		 else if(dirmodifyscore.equals("1.5"))
		 {
			 selected4="selected";
		 }
		 else if(dirmodifyscore.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(dirmodifyscore.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(dirmodifyscore.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(dirmodifyscore.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(dirmodifyscore.equals("4"))
		 {
			 selected9="selected";
		 }
		 else if(dirmodifyscore.equals("4.5"))
		 {
			 selected10="selected";
		 }
		 else if(dirmodifyscore.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
		 %>
		<TD   class="td2"  align=center>
		<select id="<%="select_"+k%>" style="width:120px" onchange="ChangeScore('<%="id1"+k%>','<%=employno%>','<%=k%>')">
		<option value="<%=leadermodifyscore%>" <%=selected12%>></option>
		<option value="0" <%=selected1%>>0</option>
		<option value="0.5" <%=selected2%>>0.5</option>
		<option value="1" <%=selected3%>>1</option>
		<option value="1.5" <%=selected4%>>1.5</option>
		<option value="2" <%=selected5%>>2</option>
		<option value="2.5" <%=selected6%>>2.5</option>
		<option value="3" <%=selected7%>>3</option>
		<option value="3.5" <%=selected8%>>3.5</option>
		<option value="4" <%=selected9%>>4</option>
		<option value="4.5" <%=selected10%>>4.5</option>
		<option value="5" <%=selected11%>>5</option>
		</select>
		</TD><!--总经理修改评分 -->
<%}
%>
<TD   class="td2"  align=center><input id=<%="id2"+k%> type="text" style="width:120px;" onchange="ChangeComment('<%="id2"+k%>','<%=employno%>')" value="<%=manmodifycomment%>"></TD><!--总经理修改评语 -->
</tr>
<%		
	}
}else{%> 
<TR class="tr1"><TD class="td2" colspan="13">无对应员工信息!</TD></TR>
<%} 
%>
</table>
</div>
