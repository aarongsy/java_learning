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
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));
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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="16%">
<COL width="16%">
<COL width="16%">
<COL width="16%">
<COL width="16%">
<COL width="16%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>原当班日期</TD>
<TD  noWrap class="td2"  align=center>原班别</TD>
<TD style="display:none"  noWrap class="td2"  align=center>原班别名称</TD>
<TD  noWrap class="td2"  align=center>原班别时数</TD>
<TD  noWrap class="td2"  align=center>改后班别</TD>
<TD style="display:none"  noWrap class="td2"  align=center>改后班别名称</TD>
<TD  noWrap class="td2"  align=center>改后班别时数</TD>
<TD  noWrap class="td2"  align=center>差异时数</TD>
</tr>

<%

//String sql = "select a.*,b.classno newnotext from (select a.id,a.olddate,a.oldno noid,b.classno notext,a.oldname,a.oldnums,a.newno,a.newname,a.newnums,a.nums from uf_hr_alterclasssub a,uf_hr_classinfo b where a.oldno=b.requestid and a.requestid='"+requestid+"' order by a.olddate asc) a left join uf_hr_classinfo b on a.newno=b.requestid";
String sql = "select a.*,b.classno newnotext,case when (b.pstime is not null) then ( a.olddate || ' ' || b.pstime) else '' end newstime,case when (b.petime is not null and b.petime<b.pstime) then (to_char(to_date(a.olddate,'yyyy-mm-dd')+1,'yyyy-mm-dd') || ' ' || b.petime)  when  (b.petime is not null and b.petime>=b.pstime) then (a.olddate ||' ' || b.petime) else '' end newetime from (select a.id,a.olddate,a.oldno noid,b.classno notext,a.oldname,a.oldnums,(a.olddate ||' ' ||b.pstime) oldstime,case when b.petime<b.pstime then  (to_char(to_date(a.olddate,'yyyy-mm-dd')+1,'yyyy-mm-dd') || ' ' || b.petime) else (a.olddate ||' ' || b.petime) end oldetime,a.newno,a.newname,a.newnums,a.nums from uf_hr_alterclasssub a,uf_hr_classinfo b where a.oldno=b.requestid and a.requestid='"+requestid+"' order by a.olddate asc) a left join uf_hr_classinfo b on a.newno=b.requestid";

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String theid=StringHelper.null2String(mk.get("id"));
		String olddate=StringHelper.null2String(mk.get("olddate"));
		String noid=StringHelper.null2String(mk.get("noid"));
		String notext=StringHelper.null2String(mk.get("notext"));
		String oldname=StringHelper.null2String(mk.get("oldname"));
		String oldnums=StringHelper.null2String(mk.get("oldnums"));
		String newno=StringHelper.null2String(mk.get("newno"));
		String newnotext=StringHelper.null2String(mk.get("newnotext"));
		String newname=StringHelper.null2String(mk.get("newname"));
		String newnums=StringHelper.null2String(mk.get("newnums"));
		String nums=StringHelper.null2String(mk.get("nums"));
		
		String oldstime=StringHelper.null2String(mk.get("oldstime"));
		String oldetime=StringHelper.null2String(mk.get("oldetime"));
		String newstime=StringHelper.null2String(mk.get("newstime"));
		String newetime=StringHelper.null2String(mk.get("newetime"));		
	%>
		<TR id="<%="dataDetail_"+k %>">
		<TD   style="display:none"><input type="text" id="<%="theid_"+k%>" name="theid" value="<%=theid%>"></TD>
		<TD   class="td2"  align=center><span id="<%=("olddate_"+k+"span")%>"><%=olddate %></span></TD>
		<TD   class="td2"  align=center><input type="hidden" id="<%=("oldno_"+k) %>" value="<%=noid%>"><span id="<%=("oldno_"+k+"span") %>"><a href=javascript:onUrl('/workflow/request/formbase.jsp?requestid=<%=noid %>','<%=oldname %>','tab<%=noid %>') >&nbsp;<%=oldname %>&nbsp;</a></span></TD>
		<TD style="display:none"   class="td2"  align=center><%=oldname %></TD>
		<TD style="display:none"><span id="<%=("oldstime_"+k+"span")%>"><%=oldstime%></span></TD>
		<TD style="display:none"><span id="<%=("oldetime_"+k+"span")%>"><%=oldetime%></span></TD>
		<TD   class="td2"  align=center><span id="<%=("oldnums_"+k+"span")%>"><%=oldnums %></span></TD>
		<% 
			if(nodeshow.equals("req")){%>
				<TD   class="td2"  align=center><button type=button  class=Browser id="<%="button_newno_"+k %>" name="<%="button_newno_"+k %>"  onclick="javascript:getrefobj('<%="field_newno_"+k %>','<%="field_newno_"+k+"span" %>','40285a904931f62b014936b227402108','sqlwhere=comtype like %27%$40285a904931f62b0149516f9d9a3783$%%27','/workflow/request/formbase.jsp?requestid=','0');"></button><input type="hidden" id="<%="field_newno_"+k %>" name="<%="field_newno_"+k %>" value="<%=newno %>"  style="width: 80%" onpropertychange="setField('<%=k %>',this.value);"><span id="<%="field_newno_"+k+"span" %>" name="<%="field_newno_"+k+"span" %>" ><%if(newno.equals("")){%><img src="/images/base/checkinput.gif" align=absMiddle><%}else%><%=newname %></span></TD>
				<TD style="display:none"   class="td2"  align=center><span id="<%=("newname_"+k+"span")%>"><%=newname %></span></TD>
				<TD style="display:none"><span id="<%=("newstime_"+k+"span")%>"><%=newstime%></span></TD>
				<TD style="display:none"><span id="<%=("newetime_"+k+"span")%>"><%=newetime%></span></TD>	
				<TD   class="td2"  align=center><span id="<%=("newnums_"+k+"span")%>"><%=newnums %></span></TD>
				<TD   class="td2"  align=center><span id="<%=("nums_"+k+"span")%>"><%=nums %></span></TD>
			<% }else{%>
				<TD   class="td2"  align=center><input type="hidden" id="<%=("newno_"+k) %>" value="<%=newno%>"><span id="<%=("newno_"+k+"span") %>"><a href=javascript:onUrl('/workflow/request/formbase.jsp?requestid=<%=newno %>','<%=newname %>','tab<%=newno %>') >&nbsp;<%=newname %>&nbsp;</a></span></TD>
				<TD style="display:none"   class="td2"  align=center><%=newname %></TD>
				<TD style="display:none"><span id="<%=("newstime_"+k+"span")%>"><%=newstime%></span></TD>
				<TD style="display:none"><span id="<%=("newetime_"+k+"span")%>"><%=newetime%></span></TD>				
				<TD   class="td2"  align=center><%=newnums %></TD>
				<TD   class="td2"  align=center><%=nums %></TD>
			<%}
		%>
		</tr>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="11">无对应排班信息！</TD></TR>
<%} %>
</table>
</div>
