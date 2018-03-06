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
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector_EN" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<!--%@ page import="com.eweaver.app.configsap.SapSync"%-->
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/base/init.jsp"%>

<%
BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String action = StringHelper.null2String(request.getParameter("show"));
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String errmsg = "";

DataService ds = new DataService();
if ( "".equals(requestid)   ) {
	errmsg = "Please save this form at first!";
}
//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a9049f5c9900149f91201c0002a' or roleid='40285a904abeeb0e014ac37afe343d02')) or id='40285a9049ade1710149adea9ef20caf'"));

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
<script type='text/javascript' language="javascript" src='/js/main.js'>
</script>
<DIV id="warpp">
<TABLE border=1 id="otallowtotalid">
<CAPTION><STRONG>OT IT2010 Allowance Total</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('otallowtotalid','')"><FONT color=#ff0000>ExportToExcel</FONT></A> &nbsp;&nbsp;<input type="button" id="batchtosapid" value="BatchTOSAP" onclick="batchtoSAP();"> </SPAN></</CAPTION>
<COLGROUP>
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TBODY>
<TR>
<TD>SearialNo.</TD>
<TD>EmployeeName</TD>
<TD>EmployeeNo</TD>
<TD>EmployeeSAPID</TD>
<TD>Date</TD>
<TD>OTAllowanceCode</TD>
<TD>Number</TD>
<TD>TOSAP</TD>
<TD>SAPFlag</TD>
<TD>SAPMessage</TD>

</TR>
<%
	String sumsql = "select sno,jobnametxt,jobno,empsapid,otdate,sapcode,nums,msgty,message from uf_dmhr_allowtotal where requestid='"+requestid+"' order by sno asc";
	String detailsql = "select sno,jobnametxt,jobno,empsapid,otappno,otreason,actsdate,allowname,allowcode,nums,msgty,message from uf_dmhr_allowdetail where requestid='"+requestid+"' order by sno asc";
	List list = baseJdbcDao.executeSqlForList(sumsql);	
	if ( list.size() > 0 ) {
		for ( int i=0;i<list.size();i++) {
			
			Map map = (Map)list.get(i);
			String sno = StringHelper.null2String(map.get("sno"));
			String jobnametxt = StringHelper.null2String(map.get("jobnametxt"));
			String jobno = StringHelper.null2String(map.get("jobno"));
			String empsapid = StringHelper.null2String(map.get("empsapid"));
			String otdate = StringHelper.null2String(map.get("otdate"));
			String sapcode = StringHelper.null2String(map.get("sapcode"));
			String nums = StringHelper.null2String(map.get("nums"));
			String msgty = StringHelper.null2String(map.get("msgty"));
			String message = StringHelper.null2String(map.get("message"));
%>
<TR>
<TD><input type="hidden" id="<%="field_no_"+sno %>" name="no" value="<%=sno %>"><%=sno %></TD>
<TD><input type="hidden" name="<%="field_jobnametxt_"+sno%>" id="<%="field_jobnametxt_"+sno %>" value="<%=jobnametxt %>"><%=jobnametxt %></TD>
<TD><input type="hidden" name="<%="field_jobno_"+sno%>" id="<%="field_jobno_"+sno %>" value="<%=jobno %>"><%=jobno %></TD>
<TD><input type="hidden" name="<%="field_empsapid_"+sno%>" id="<%="field_empsapid_"+sno %>" value="<%=empsapid %>"><%=empsapid %></TD>
<TD><input type="hidden" name="<%="field_otdate_"+sno%>" id="<%="field_otdate_"+sno %>" value="<%=otdate %>"><%=otdate %></TD>
<TD><input type="hidden" name="<%="field_sapcode_"+sno%>" id="<%="field_sapcode_"+sno %>" value="<%=sapcode %>"><%=sapcode %></TD>
<TD><input type="hidden" name="<%="field_nums_"+sno%>" id="<%="field_nums_"+sno %>" value="<%=nums %>"><%=nums %></TD>
<!--TD><input type=<%=("I".equals(msgty))?"hidden":"button" %> id="<%="field_tosap_"+sno%>" value="TOSAP" onclick="sigletoSAP();"></TD-->
<TD><input type="button" id="<%="field_tosap_"+sno%>" value="TOSAP" onclick="sigletoSAP();"></TD>
<TD><input type="hidden" name="<%="field_msgty_"+sno%>" id="<%="field_msgty_"+sno %>" value="<%=msgty %>"><%=msgty %></TD>
<TD><input type="hidden" name="<%="field_message_"+sno%>" id="<%="field_message_"+sno %>" value="<%=message %>"><%=message %></TD>

</TR>
<%

		}
	}else{
%>

<TR>
<TD colspan=10>There is no data find, please tick getAllowanceDetail button to get data</TD>
</TR>	
<%
	}

%>
</TBODY></TABLE>
<TABLE border=1 id="otallowdetailid">
<CAPTION><STRONG>OT IT2010 Allowance Detail</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('otallowdetailid','')"><FONT color=#ff0000>ExportToExcel</FONT></A></SPAN></</CAPTION>
<COLGROUP>
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TBODY>
<TR>
<TD>SearialNo.</TD>
<TD>EmployeeName</TD>
<TD>EmployeeNo</TD>
<TD>EmployeeSAPID</TD>
<TD>OTNo.</TD>
<TD>OTReason</TD>
<TD>OTDate</TD>
<TD>OTAllowanceName</TD>
<TD>OTAllowanceCode</TD>
<TD>Number</TD>
<TD>SAP Flag</TD>
</TR>
<%	
	list = baseJdbcDao.executeSqlForList(detailsql);	
	if ( list.size() > 0 ) {
		for ( int i=0;i<list.size();i++) {
			Map map = (Map)list.get(i);
			String sno = StringHelper.null2String(map.get("sno"));
			String jobnametxt = StringHelper.null2String(map.get("jobnametxt"));
			String jobno = StringHelper.null2String(map.get("jobno"));
			String empsapid = StringHelper.null2String(map.get("empsapid"));
			String otappno = StringHelper.null2String(map.get("otappno"));
			String otreason = StringHelper.null2String(map.get("otreason"));
			String actsdate = StringHelper.null2String(map.get("actsdate"));
			String allowname = StringHelper.null2String(map.get("allowname"));
			String allowcode = StringHelper.null2String(map.get("allowcode"));
			String nums = StringHelper.null2String(map.get("nums"));
			String msgty = StringHelper.null2String(map.get("msgty"));
			String message = StringHelper.null2String(map.get("message"));					
%>
<TR>
<TD><input type="hidden" id="<%="field2_no_"+sno %>" name="no2" value="<%=sno %>"><%=sno %></TD>
<TD><input type="hidden" name="<%="field2_jobnametxt_"+sno%>" id="<%="field2_jobnametxt_"+sno %>" value="<%=jobnametxt %>"><%=jobnametxt %></TD>
<TD><input type="hidden" name="<%="field2_jobno_"+sno%>" id="<%="field2_jobno_"+sno %>" value="<%=jobno %>"><%=jobno %></TD>
<TD><input type="hidden" name="<%="field2_empsapid_"+sno%>" id="<%="field2_empsapid_"+sno %>" value="<%=empsapid %>"><%=empsapid %></TD>
<TD><input type="hidden" name="<%="field2_otappno_"+sno%>" id="<%="field2_otappno_"+sno %>" value="<%=otappno %>"><%=otappno %></TD>
<TD><input type="hidden" name="<%="field2_otreason_"+sno%>" id="<%="field2_otreason_"+sno %>" value="<%=otreason %>"><%=otreason %></TD>
<TD><input type="hidden" name="<%="field2_actsdate_"+sno%>" id="<%="field2_actsdate_"+sno %>" value="<%=actsdate %>"><%=actsdate %></TD>
<TD><input type="hidden" name="<%="field2_allowname_"+sno%>" id="<%="field2_allowname_"+sno %>" value="<%=allowname %>"><%=allowname %></TD>
<TD><input type="hidden" name="<%="field2_allowcode_"+sno%>" id="<%="field2_allowcode_"+sno %>" value="<%=allowcode %>"><%=allowcode %></TD>
<TD><input type="hidden" name="<%="field2_nums_"+sno%>" id="<%="field2_nums_"+sno %>" value="<%=nums %>"><%=nums %></TD>
<TD><input type="hidden" name="<%="field2_msgty_"+sno%>" id="<%="field2_msgty_"+sno %>" value="<%=msgty %>"><%=msgty %></TD>
</TR>
<%
		}
	}else{
%>
<TR>
<TD colspan=10>There is no data find, please tick getAllowanceDetail button to get data</TD>
</TR>	
<%
	}
	
%>
</TBODY></TABLE><DIV>