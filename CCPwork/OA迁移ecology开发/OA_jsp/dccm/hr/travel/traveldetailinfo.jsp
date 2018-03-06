<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
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
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.eweaver.app.dccm.timediff.DM_TimeDiffAction"%>
<%@ page import="java.math.*"%>


<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
//String empid = StringHelper.null2String(request.getParameter("empid"));//empid
//String comtype = StringHelper.null2String(request.getParameter("comtype"));//comtype
//String sdate = StringHelper.null2String(request.getParameter("sdate"));//sdate
//String s1 = StringHelper.null2String(request.getParameter("s1"));//s1
//String edate = StringHelper.null2String(request.getParameter("edate"));//edate
//String s2 = StringHelper.null2String(request.getParameter("s2"));//s2
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
//DataService ds = new DataService();
//DM_TimeDiffAction app = new DM_TimeDiffAction();

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
    height: 30px; 
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
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
<table id="TravelTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TBODY>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Serial No.&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Departure Date&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Depart From&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Arrival Date&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Arrival Venue&nbsp;&nbsp;</TD>
<TD  noWrap class="td2"  align=center>&nbsp;&nbsp;Visit Unit&nbsp;&nbsp;</TD>
</TR>
<%
	String sql = "select a.sno,a.sdate,a.scity,a.edate,a.ecity,a.visitunit from uf_dmhr_travelappsub a where a.requestid='"+requestid+"' order by a.sno asc";	
	List list = baseJdbc.executeSqlForList(sql);	
	if(list.size()>0){
		for(int k=0,sizek=list.size();k<sizek;k++){
			Map mk = (Map)list.get(k);		
			String sno=StringHelper.null2String(mk.get("sno"));
			String sdate=StringHelper.null2String(mk.get("sdate"));
			String scity=StringHelper.null2String(mk.get("scity"));
			//String scitytxt=StringHelper.null2String(mk.get("scitytxt"));
			String edate=StringHelper.null2String(mk.get("edate"));
			String ecity=StringHelper.null2String(mk.get("ecity"));
			//String ecitytxt=StringHelper.null2String(mk.get("ecitytxt"));
			String visitunit=StringHelper.null2String(mk.get("visitunit"));
			//String custype=StringHelper.null2String(mk.get("custype"));
			//String custypetxt=StringHelper.null2String(mk.get("custypetxt"));
			//String cusaddress=StringHelper.null2String(mk.get("cusaddress"));
			%>
			<TR id="dataDetail" height="30">
			<TD noWrap  class="td2"  align=center >&nbsp;&nbsp;<%=sno %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=sdate %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=scity %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=edate %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=ecity %>&nbsp;&nbsp;</TD>
			<TD noWrap  class="td2"  align=center>&nbsp;&nbsp;<%=visitunit %>&nbsp;&nbsp;</TD>			
			</TR>
			<%
		}
	} else {
		%>
		<TR><TD class="td2" colspan="34"><span id="travelinfoerr"><font color="red">No Travel Detail infomation, please check!</font></span></TD></TR>
		<%
	}

%>
</TBODY></TABLE>
</div>
