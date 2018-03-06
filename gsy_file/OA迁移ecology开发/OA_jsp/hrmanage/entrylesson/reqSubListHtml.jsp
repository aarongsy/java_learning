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
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//发起节点，隐藏字段。
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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="5%">
<COL width="20%">
<COL width="15%">
<COL width="30%">
<COL width="15%">
<COL width="15%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>姓名</TD>
<TD  noWrap class="td2"  align=center>工号</TD>
<TD  noWrap class="td2"  align=center>培训课程</TD>
<TD  noWrap class="td2"  align=center>出勤</TD>
<TD  noWrap class="td2"  align=center>考分</TD>
</tr>

<%
String sql = "select a.id,a.no,a.objname,a.jobno,a.lessonid,a.lessonname,a.come,a.test from uf_hr_entrylessonsub2 a where a.requestid='"+requestid+"' order by a.no";
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String theid=StringHelper.null2String(mk.get("id"));
		int no=k+1;
		String objname=StringHelper.null2String(mk.get("objname"));
		String jobno=StringHelper.null2String(mk.get("jobno"));
		String lessonid=StringHelper.null2String(mk.get("lessonid"));
		String lessonname=StringHelper.null2String(mk.get("lessonname"));
		String come=StringHelper.null2String(mk.get("come"));
		String test=StringHelper.null2String(mk.get("test"));
	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="hidden" name="no"><%=no %></TD>
		<TD   style="display:none"><input type="text" id="<%="theid_"+no%>" value="<%=theid%>"></TD>
		<TD   class="td2"  align=center><%=objname %></TD>
		<TD   class="td2"  align=center><%=jobno %></TD>
		<TD   class="td2"  align=center><input type="hidden" id="<%="field_lesson_"+no%>" name="<%="field_lesson_"+no%>" value="<%=lessonid%>"  style='width: 80%'><span id="<%="field_lesson_"+no+"span"%>" name="<%="field_lesson_"+no+"span"%>" ><A id=ext-gen123 href="javascript:if(top.frames[1])onUrl('/workflow/request/formbase.jsp?requestid=<%=lessonid %>','<%=lessonname %>','tab<%=lessonid %>')"><%=lessonname%></A></span></TD>
		<%if(nodeshow.equals("show")){ %>
		<TD   class="td2"  align=center><%=come %></TD>
		<TD   class="td2"  align=center><%=test %></TD>
		<%}else{ %>
		<TD   class="td2"  align=center><input type="hidden" name="<%="field_come_"+no+"fieldcheck"%>" id="<%="field_come_"+no+"fieldcheck"%>" value="<%=come %>"><select  class="InputStyle6"  name="<%="field_come_"+no%>"  id="<%="field_come_"+no%>" style="width: 80%" onChange="checkInput('<%="field_come_"+no %>','<%="field_come_"+no+"span" %>');"><option value=""  selected  ></option><option value="是" <%if(come.equals("是")) {%>selected<%} %> >是</option><option value="否" <%if(come.equals("否")) {%>selected<%} %>>否</option><option value="请假" <%if(come.equals("请假")) {%>selected<%} %>>请假</option></select><span id="<%="field_come_"+no+"span" %>"><%if(come.equals("")){%><img src="/images/base/checkinput.gif" align=absMiddle><%}%></span></TD>
		<TD   class="td2"  align=center><input type="text" id="<%="test_"+no%>"></TD>
		<%} %>
		</tr>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="6">人才库中无对应员工！</TD></TR>
<%} %>
</table>
</div>
