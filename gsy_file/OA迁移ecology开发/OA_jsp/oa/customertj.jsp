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
String date1 = StringHelper.null2String(request.getParameter("date1"));
String date2 = StringHelper.null2String(request.getParameter("date2"));
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
<COL width="30%">
<COL width="14%">
<COL width="14%">
<COL width="14%">
<COL width="14%">
<COL width="14%"></COLGROUP>
<TBODY>

	    <TR height="25"  class="title">
		<TD class="td2"  align=center rowspan=2>部  门</TD>
		<TD class="td2"  align=center rowspan=2>月总人数</TD>
		<TD class="td2"  align=center colspan=4>人员类型</TD>

		</TR>
		<TR>
		<TD class="td2"  align=center>客户</TD>
		<TD class="td2"  align=center>供应商</TD>
		<TD class="td2"  align=center>关联公司</TD>
		<TD class="td2"  align=center>政府官员</TD>
		</TR>
<%
	String sql = "";
	sql = "select a.reqdept,(select objname from  orgunit where id=a.reqdept) as reqdept1,sum(a.arrivenumber) as arrivenumber from uf_oa_registration a where a.enterdate between '"+date1+"' and '"+date2+"' group by a.reqdept";



List sublist = baseJdbc.executeSqlForList(sql);
int count=0;
int no=sublist.size();
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String reqdept =StringHelper.null2String(mk.get("reqdept"));
		String reqdept1 =StringHelper.null2String(mk.get("reqdept1"));
		String arrivenumber =StringHelper.null2String(mk.get("arrivenumber"));
		String sql1="select a.fktype,(select objname from selectitem where id=a.fktype) as fktype1,sum(a.arrivenumber) as arrivenumber1 from uf_oa_registration a where a.enterdate between '"+date1+"' and '"+date2+"' and  a.reqdept='"+reqdept+"' group by a.fktype";
		List sublist1 = baseJdbc.executeSqlForList(sql1);
		String fktype="";
		String fktype1="";
		String arrivenumber1="";
		String kh="";
		String gys="";
		String glgs="";
		String zfry="";
		Map mk1=null;
		if(sublist1.size()>0)
		{
			for(int i=0;i<sublist1.size();i++)
			{
				mk1 = (Map)sublist1.get(i);
				fktype =StringHelper.null2String(mk1.get("fktype"));
				fktype1 =StringHelper.null2String(mk1.get("fktype1"));
				arrivenumber1 =StringHelper.null2String(mk1.get("arrivenumber1"));
				if(fktype.equals("40285a9049a3a72a0149ad3674df6d2d"))
				{
					kh=arrivenumber1;
				}
				else if(fktype.equals("40285a9049a3a72a0149ad3674df6d2e"))
				{
					gys=arrivenumber1;
				}
				else if(fktype.equals("40285a9049a3a72a0149ad3674df6d2f"))
				{
					zfry=arrivenumber1;
					
				}
				else
				{
					glgs=arrivenumber1;
				}
			}
		}

		
	%>
		
		<TR>

		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_"+count%>" style="width:80%" value="<%=reqdept1%>"> <span id="<%="count_"+count+"span"%>"><%=reqdept1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_"+count%>" style="width:80%" value="<%=arrivenumber%>"> <span id="<%="count_"+count+"span"%>"><%=arrivenumber%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_"+count%>" style="width:80%" value="<%=kh%>"><span id="<%="count_"+count+"span"%>"><%=kh%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_"+count%>" style="width:80%" value="<%=gys%>"><span id="<%="count_"+count+"span"%>"><%=gys%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_"+count%>" style="width:80%" value="<%=glgs%>"><span id="<%="count_"+count+"span"%>"><%=glgs%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count_"+count%>" style="width:80%" value="<%=zfry%>"><span id="<%="count_"+count+"span"%>"><%=zfry%></span></TD>

		</TR>

	
<%
	}
}else{%> 
	<TR><TD class="td2" colspan="6">无数据!</TD></TR>
<%} %>
</TBODY>
</table>
</div>
