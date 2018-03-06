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
String editmode = StringHelper.null2String(request.getParameter("editmode"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
StringBuffer buf = new StringBuffer();
String sql = "select a.id,a.objdept oid,b.objname oname,a.jobno,a.sapid,a.objname hid,c.objname hname,a.objcom comid,d.objname comname,a.total,a.message,a.msgty from uf_hr_monthtotalsub a left join orgunit b on a.objdept=b.id left join humres c on a.objname=c.id left join orgunit d on a.objcom=d.id where a.requestid='"+requestid+"' order by a.objdept asc,a.jobno asc";
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String theid=StringHelper.null2String(mk.get("id"));
		String oid=StringHelper.null2String(mk.get("oid"));
		String oname=StringHelper.null2String(mk.get("oname"));
		String jobno=StringHelper.null2String(mk.get("jobno"));
		String sapid=StringHelper.null2String(mk.get("sapid"));
		String hid=StringHelper.null2String(mk.get("hid"));
		String hname=StringHelper.null2String(mk.get("hname"));
		String comid=StringHelper.null2String(mk.get("comid"));
		String comname=StringHelper.null2String(mk.get("comname"));
		String total=StringHelper.null2String(mk.get("total"));
		String message=StringHelper.null2String(mk.get("message"));
		String msgty=StringHelper.null2String(mk.get("msgty"));
		buf.append("<TR>");
		buf.append("<TD style=\"display:"+editmode+"\" class=\"td2\"  align=center><input  type=\"checkbox\" value=\""+k+"\" id=\"checkbox_"+k+"\" name=\"checkbox\"/></TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"node_"+k+"\" name=\"node_"+k+"\" value=\""+theid+"\"><span id=\"node_"+k+"span\" name=\"node_"+k+"span\">"+(k+1)+"</span></TD>");		
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"jobno_"+k+"\" value=\""+jobno+"\"><span id=\"jobno_"+k+"span\">"+jobno+"</span></TD>");
		buf.append("<TD class=\"td2\"  align=center>"+sapid+"</TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"reqman_"+k+"\" value=\""+hid+"\"><span id=\"reqman_"+k+"span\" name=\"reqman_"+k+"span\"><a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+hid+"','"+hname+"','tab"+hid+"') >&nbsp;"+hname +"&nbsp;</a></span></TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+k+"\" value=\""+oid+"\" ><span id=\"dept_"+k+"span\" name=\"dept_"+k+"span\"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id="+oid+"','"+oname+"','tab"+oid+"') >&nbsp;"+oname+"&nbsp;</a></span></TD>");
		buf.append("<TD class=\"td2\"  align=center>"+comname+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+total+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+message+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+msgty+"</TD>");
		buf.append("</TR>");
	}
}
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
<COL width="5%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="15%">
<COL width="15%">
<COL width="10%">
<COL width="15%">
<COL width="10%">
</COLGROUP>
<TR height="25"  class="title">
<TD style="display:<%=editmode %>" noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>全选</TD>
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>员工工号</TD>
<TD  noWrap class="td2"  align=center>SAP编号</TD>
<TD  noWrap class="td2"  align=center>员工姓名</TD>
<TD  noWrap class="td2"  align=center>所属部门</TD>
<TD  noWrap class="td2"  align=center>所属公司</TD>
<TD  noWrap class="td2"  align=center>扣款合计</TD>
<TD  noWrap class="td2"  align=center>抛SAP返回消息</TD>
<TD  noWrap class="td2"  align=center>抛SAP返回标识</TD>
</tr>

<%
out.println(buf.toString());
%>

</table>
</div>
