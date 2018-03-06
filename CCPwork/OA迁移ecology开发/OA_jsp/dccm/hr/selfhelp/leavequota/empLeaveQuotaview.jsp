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
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String jobno = StringHelper.null2String(request.getParameter("jobno"));
String empsapid = StringHelper.null2String(request.getParameter("empsapid"));
String quotadate = StringHelper.null2String(request.getParameter("quotadate"));
String quotaids = StringHelper.null2String(request.getParameter("quotaids"));
String mode = StringHelper.null2String(request.getParameter("mode"));
String errmsg = "";

DataService ds = new DataService();
if ( !"".equals(empsapid) ) {
	//判断工号是否有效？
} else if (  !"".equals(jobno) ) {
	empsapid = ds.getValue("select exttextfield15 from humres where objno='"+jobno+"'");
} 

if ( "".equals(empsapid) || "".equals(quotaids)  ) {
	errmsg = "No parameters: empsapid=" + empsapid + " quotaids="+quotaids;
}
//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a9049f5c9900149f91201c0002a' or roleid='40285a904abeeb0e014ac37afe343d02')) or id='40285a9049ade1710149adea9ef20caf'"));

//Integer rowlen = 0;
Integer k = 0;
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
<TABLE border=1 id="leftquotainfoid">
<CAPTION><STRONG>Leave Quota Infomation</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('leftquotainfoid','')"><FONT color=#ff0000>ExportToExcel</FONT></A></SPAN></</CAPTION>
<COLGROUP>
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
<TD>Searial No.</TD>
<TD>Employee SAPID</TD>
<TD>Leave Quota SAPID</TD>
<TD>Leave Quota Name</TD>
<TD>Left Quota</TD>
<TD>Time/Measurement Unit</TD>
<TD>Start Date for Quota Deduction</TD>
<TD>Quota Deduction to</TD>
</TR>
<%
		String allsapmsg = "";
		String allsapmsgtype = "";
		String sapmsg = "";		
		String sapmsgtype = "";
		if ( "".equals(errmsg) ) {
			String[] quoarr = quotaids.split(","); 
			BigDecimal total = new BigDecimal("0");
			for( int i=0;i <quoarr.length; i++ ) {				
				String str = "";

				String functionName = "";
				JCoFunction function = null;
				String errorMessage = "";
			  
				functionName = "ZHR_IT2006_DETAIL_GET_MY"; //PT015：员工缺勤定额明细获取-马来西亚
				function = null;
				try {
					function = SapConnector_EN.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				if (function == null) {
					System.out.println(functionName + " not found in SAP.");
					System.out.println("SAP_RFC中没有此函数!");
					errorMessage = functionName + " not found in SAP.";			
				}
				
				function.getImportParameterList().setValue("PERNR", empsapid);
				function.getImportParameterList().setValue("DEBEG", "18000101");
				function.getImportParameterList().setValue("DEEND", quotadate);
				function.getImportParameterList().setValue("KTART", quoarr[i]);
				function.getImportParameterList().setValue("MODE", mode);  //A:以输入的有效截止日期时间点限制  B:以输入的有效开始和结束日期的交叉
				 //System.out.println(mode);
				try {
					function.execute(SapConnector_EN.getDestination("sanpowersapen"));
					//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}	
		
				//返回值
				sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
				sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();
				JCoTable jcotable = function.getTableParameterList().getTable("IT2006DETAIL");
				//System.out.println("sapmsgtype="+ sapmsgtype + "sapmsg="+sapmsg+" jcotable.getNumRows()="+jcotable.getNumRows());
				if ( "I".equals(sapmsgtype) &&  jcotable != null && jcotable.getNumRows()>0 ) {
					//Double total = 0.0;
					
					for (int m = 0; m < jcotable.getNumRows(); m++) {
						k = k + 1;
						String PERNR = StringHelper.null2String(jcotable.getValue("PERNR"));
						String KTART = StringHelper.null2String(jcotable.getValue("KTART"));
						String KTEXT = StringHelper.null2String(jcotable.getValue("KTEXT"));
						String ANZHL = StringHelper.null2String(jcotable.getValue("ANZHL"));						
						total = total.add(new BigDecimal(ANZHL)); 
						String ZEINH = StringHelper.null2String(jcotable.getValue("ZEINH"));
						String DESTA = StringHelper.null2String(jcotable.getValue("DESTA"));
						SimpleDateFormat sdf1 = new SimpleDateFormat ("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK); 
						Date date=sdf1.parse(DESTA);
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
						DESTA=sdf.format(date);
						String DEEND = StringHelper.null2String(jcotable.getValue("DEEND"));
						date=sdf1.parse(DEEND);
						DEEND=sdf.format(date);
						String tmpstr = m+"@@"+PERNR +"@@"+KTART+"@@"+KTEXT+"@@"+ANZHL+"@@"+ZEINH
								+"@@"+DESTA +"@@"+DEEND;
						//System.out.println(tmpstr);
%>
<TR>
<TD><%=k %></TD>
<TD><%=PERNR %></TD>
<TD><%=KTART %></TD>
<TD><%=KTEXT %></TD>
<TD><%=ANZHL %></TD>
<TD><% if("010".equals(ZEINH)) {%>Day<%} else if ("001".equals(ZEINH)) { %>Hour<%} else { } %></TD>
<TD><%=DESTA %></TD>
<TD><%=DEEND %></TD></TR>
<%					
						jcotable.nextRow();								
					}
				}else{
					allsapmsgtype = sapmsgtype;
					if ( "".equals(allsapmsg) ) {
						allsapmsg = sapmsg +"  empsapid:"+empsapid+" quotaid:"+quoarr[i];
					} else {
						allsapmsg = allsapmsg +";" + sapmsg +"  empsapid:"+empsapid+" quotaid:"+quoarr[i];
					}					
				}
			
			}
%>
<TR>
<TD>Total</TD>
<TD></TD>
<TD></TD>
<TD></TD>
<TD><%=total %></TD>
<TD></TD>
<TD></TD>
<TD></TD>
</TR>
</TBODY></TABLE>
<TABLE border=1>
<CAPTION><STRONG>SAP Search Infomation</STRONG></CAPTION>
<COLGROUP>
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TBODY>
<TR>
<TD>SAP Flag</TD>
<TD>SAP Message</TD>
</TR>
<TR>
<TD id="sapmsgtypeid"><%if( !"".equals(allsapmsgtype)) {%><%=allsapmsgtype %><% } else { %><%=sapmsgtype %><%} %></TD>
<TD id="sapmsgid"><%if( !"".equals(allsapmsg)) {%><%=allsapmsg %><% } else { %><%=sapmsg %><%} %></TD>
</TR>
</TBODY>
</TABLE>
<%			
			
		} else {
%>	
		
<TABLE border=1 id="errorinfoid">
<CAPTION>Search Error Infomation</CAPTION>
<TBODY>
<TR>
<TD><%=errmsg %></TD>
</TR>
</TBODY></TABLE>
<%	
		}
%>
</DIV> 