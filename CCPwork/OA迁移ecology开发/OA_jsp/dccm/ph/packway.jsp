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
String applyorder=StringHelper.null2String(request.getParameter("requestid"));
//String applyorder=StringHelper.null2String(request.getParameter("storageorder"));
System.out.println(applyorder);
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
<COL width=120>
<COL width=120>
<COL width=120>
</COLGROUP>

<TR  class="tr1">
<TD  noWrap class="td2"  align=center>NO</TD>
<TD  noWrap class="td2"  align=center>Cabinet type</TD>
<TD  noWrap class="td2"  align=center>Container No.</TD>

</tr>

<%

  String sql="select no,cabinettype,containerno from uf_dmph_packingway    where requestid='"+applyorder+"' order by no";

  System.out.println(sql);

  String cabinettype="";
  String containerno="";


  List sublist = baseJdbc.executeSqlForList(sql);
  if(sublist.size()>0){
	 for(int k=0,sizek=sublist.size();k<sizek;k++){
		 Map mk = (Map)sublist.get(k);
		 cabinettype=StringHelper.null2String(mk.get("cabinettype"));//柜型
		 containerno=StringHelper.null2String(mk.get("containerno"));//货柜号

		  //子表中的明细
  //String upsql="update uf_oa_solidapply set dirmodifyscore=score,lastscore=score where requestid='"+requestid+"'";
  //baseJdbc.update(upsql);

%>

<TR   id="dataDetail" class="tr1">
<TD   class="td2"  align=center><%=k+1%></TD><!--序号 -->
<TD   class="td2"  align=center><%=cabinettype%></TD><!--柜型 -->
<TD   class="td2"  align=center><%=containerno%></TD><!--货柜号 -->

</tr>
<%		
	}
}else{%> 
	<TR class="tr1">
	<TD class="td2" colspan="14">No correspondence information!</TD>
	</TR>
<%} 
%>
</table>
</div>
