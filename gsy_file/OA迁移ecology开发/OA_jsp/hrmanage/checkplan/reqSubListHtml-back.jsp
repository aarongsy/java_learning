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
<%if(nodeshow.equals("edit")){%>
<COL width="5%">
<%}%>
<COL width="5%">
<COL width="18%">
<COL width="18%">
<COL width="18%">
<COL width="18%">
<COL width="18%">
</COLGROUP>
<TR height="25"  class="title">
<%if(nodeshow.equals("edit")){%>
<TD  noWrap class="td2"  align=center>操作</TD>
<%}%>
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>员工工号</TD>
<TD  noWrap class="td2"  align=center>员工姓名</TD>
<TD  noWrap class="td2"  align=center>所属部门</TD>
<TD  noWrap class="td2"  align=center>职称</TD>
<TD  noWrap class="td2"  align=center>入职日期</TD>
</tr>

<%

String sql = "select a.*,b.objname hname,c.objname oname,d.nametext profename from (select id,jobno,objname,objdept,objprofe,indate from uf_hr_checkplansub where requestid='"+requestid+"' order by jobno asc) a left join humres b on a.objname=b.id left join orgunit c on a.objdept=c.id left join uf_profe d on a.objprofe=d.requestid";

List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		StringBuffer burr1 = new StringBuffer();
		Map mk = (Map)sublist.get(k);
		String theid=StringHelper.null2String(mk.get("id"));
		String jobno=StringHelper.null2String(mk.get("jobno"));
		String objname=StringHelper.null2String(mk.get("objname"));
		String hname=StringHelper.null2String(mk.get("hname"));
		String objdept=StringHelper.null2String(mk.get("objdept"));
		String oname=StringHelper.null2String(mk.get("oname"));
		String objprofe=StringHelper.null2String(mk.get("objprofe"));
		String profename=StringHelper.null2String(mk.get("profename"));
		String indate=StringHelper.null2String(mk.get("indate"));
	%>
		<TR id="<%="dataDetail_"+k %>">
		<%
			if(nodeshow.equals("edit")){
				burr1.append("<TD class=td2 align=center>");
				burr1.append("<a href=\"javascript:deleteData('"+requestid+"','"+theid+"')\"><img src='/images/base/BacoDelete.gif' alt='删除'></a>");
				burr1.append("</TD>");
			}
			out.println(burr1.toString());
		%>
		<TD   style="display:none"><input type="text" id="<%="theid_"+k%>" name="theid" value="<%=theid%>"></TD>
		<TD   class="td2"  align=center><%=(k+1) %></TD>
		<TD   class="td2"  align=center><%=jobno %></TD>
		<TD   class="td2"  align=center><input type="hidden" id="<%=("objname_"+k) %>" value="<%=objname%>"><span id="<%=("objname_"+k+"span") %>"><a href=javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=objname %>','<%=hname %>','tab<%=objname %>') >&nbsp;<%=hname %>&nbsp;</a></span></TD>
		<TD   class="td2"  align=center><input type="hidden" id="<%=("objdept_"+k) %>" value="<%=objdept%>"><span id="<%=("objdept_"+k+"span") %>"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id=<%=objdept %>','<%=oname %>','tab<%=objdept %>') >&nbsp;<%=oname %>&nbsp;</a></span></TD>
		<TD   class="td2"  align=center><input type="hidden" id="<%=("objprofe_"+k)%>" value="<%=objprofe%>" ><span id="<%=("objprofe_"+k+"span")%>"><a href=javascript:onUrl('/workflow/request/formbase.jsp?requestid=<%=objprofe%>','<%=profename%>','tab<%=objprofe%>')>&nbsp;<%=profename %>&nbsp;</a></span></TD>
		<TD   class="td2"  align=center><%=indate %></TD>
		</tr>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="11">无数据！</TD></TR>
<%} %>
</table>
</div>
