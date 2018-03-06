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
String yearmon = StringHelper.null2String(request.getParameter("yearmon"));
String errmsg = "";

DataService ds = new DataService();
if ( !"".equals(empsapid) ) {
	//判断工号是否有效？
} else if (  !"".equals(jobno) ) {
	empsapid = ds.getValue("select exttextfield15 from humres where objno='"+jobno+"'");
} 

if ( "".equals(empsapid) || "".equals(yearmon)  ) {
	errmsg = "No parameters: empsapid=" + empsapid + " yearmon="+yearmon;
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
<%
		if ( "".equals(errmsg) ) {
			String str = "";

			  String functionName = "";
			  JCoFunction function = null;
			  String errorMessage = "";
			  
				functionName = "ZHR_ABNOR_ATT_GET_MY"; //PT003 考勤异常数据获取
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
				//System.out.println("self\empinfo\empaddressview.jsp PERNR="+empsapid);
				function.getImportParameterList().setValue("PERNR", empsapid);
				function.getImportParameterList().setValue("MONTH", yearmon);
				
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
				String sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
				String sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();
				JCoTable jcotable = function.getTableParameterList().getTable("ABATT");
				JCoTable jcotable2 = function.getTableParameterList().getTable("PDPCT");
				//System.out.println("jcotable.getNumRows()="+jcotable.getNumRows());	
%>

<TABLE border=1 id="attinfoid">
<CAPTION><STRONG>Abnormal Attendance Infomation</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('attinfoid','abnclockinfoid')"><FONT color=#ff0000>ExportToExcel</FONT></A></SPAN></</CAPTION>
<COLGROUP>
<COL width="10px">
<COL width="20px">
<COL width="20px">
<COL width="100px">
<COL width="20px">
<COL width="30px">
<COL width="50px">
<COL width="20px">
<COL width="20px">
<COL width="80px">
</COLGROUP>
<TBODY>
<TR>
<TD>Serial No.</TD>
<TD>Employee SAPID</TD>
<TD>Employee No</TD>
<TD>Employee Name</TD>
<TD>Dept</TD>
<TD>Date</TD>
<TD>Schedule</TD>
<TD>Time 1</TD>
<TD>Time 2</TD>
<TD>Long Message</TD></TR>
<%	
				k = 0;
				if ( jcotable != null && jcotable.getNumRows()>0 ) {
					for (int i = 0; i < jcotable.getNumRows(); i++) {
						k = k + 1;
						String PERNR = StringHelper.null2String(jcotable.getValue("PERNR"));
						String USRID = StringHelper.null2String(jcotable.getValue("USRID"));
						String ENAME = StringHelper.null2String(jcotable.getValue("ENAME"));
						String DEPTX = StringHelper.null2String(jcotable.getValue("DEPTX"));
						String LDATE = StringHelper.null2String(jcotable.getValue("LDATE"));
						SimpleDateFormat sdf1 = new SimpleDateFormat ("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK); 
						Date date=sdf1.parse(LDATE);
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
						LDATE=sdf.format(date);
						//System.out.println(LDATE);
						String SCHKZ = StringHelper.null2String(jcotable.getValue("SCHKZ"));
						String BEGTM = StringHelper.null2String(jcotable.getValue("BEGTM"));
						String ENDTM = StringHelper.null2String(jcotable.getValue("ENDTM"));
						String ETEXT = StringHelper.null2String(jcotable.getValue("ETEXT"));
						String tmpstr = i+"@@"+PERNR +"@@"+USRID+"@@"+ENAME+"@@"+DEPTX+"@@"+LDATE
								+"@@"+SCHKZ +"@@"+BEGTM+"@@"+ENDTM+"@@"+ETEXT;							
								
%>
<TR>
<TD><%=k %></TD>
<TD><%=PERNR %></TD>
<TD><%=USRID %></TD>
<TD><%=ENAME %></TD>
<TD><%=DEPTX %></TD>
<TD><%=LDATE %></TD>
<TD><%=SCHKZ %></TD>
<TD><%=BEGTM %></TD>
<TD><%=ENDTM %></TD>
<TD><%=ETEXT %></TD>
</TR>
<%						
						
						jcotable.nextRow();
						if(i==0){
							str = tmpstr;
						} else {
							str = str + "~!~" +tmpstr;
						}
					}
				}
				
%>	

</TBODY></TABLE>
<TABLE border=1 id="abnclockinfoid">
<CAPTION><STRONG>Abnormal Clock Infomation</STRONG></CAPTION>
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
<TD>Serial No.</TD>
<TD>Date</TD>
<TD>Time</TD>
<TD>Time Type</TD>
<TD>Short Description</TD>
<TD>Attendace/Absence Reason</TD>
<TD>Clock Machine ID</TD>
<TD>Employee SAPID</TD></TR>

<%	
				k = 0;
				if ( jcotable2 != null && jcotable2.getNumRows()>0 ) {
					for (int i = 0; i < jcotable2.getNumRows(); i++) {
						k = k + 1;
						String LDATE = StringHelper.null2String(jcotable2.getValue("LDATE"));
						SimpleDateFormat sdf1 = new SimpleDateFormat ("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK); 
						Date date=sdf1.parse(LDATE);
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
						LDATE=sdf.format(date);
						String BEGTM = StringHelper.null2String(jcotable2.getValue("BEGTM"));
						//SimpleDateFormat sdf2 = new SimpleDateFormat ("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK); 
						date=sdf1.parse(BEGTM);
						SimpleDateFormat sdf3=new SimpleDateFormat("HH:mm:ss");
						BEGTM=sdf3.format(date);
						String SATZA = StringHelper.null2String(jcotable2.getValue("SATZA"));						
						String STEXT = StringHelper.null2String(jcotable2.getValue("STEXT"));
						String BGCOD = StringHelper.null2String(jcotable2.getValue("BGCOD"));
						String ETERM = StringHelper.null2String(jcotable2.getValue("ETERM"));
						String PERNR = StringHelper.null2String(jcotable2.getValue("PERNR"));
						String tmpstr = i+"@@"+LDATE +"@@"+BEGTM+"@@"+SATZA+"@@"+STEXT+"@@"+BGCOD
								+"@@"+ETERM +"@@"+PERNR;							
							
%>
<TR>
<TD><%=k %></TD>
<TD><%=LDATE %></TD>
<TD><%=BEGTM %></TD>
<TD><%=SATZA %></TD>
<TD><%=STEXT %></TD>
<TD><%=BGCOD %></TD>
<TD><%=ETERM %></TD>
<TD><%=PERNR %></TD>
</TR>
<%						
						
						jcotable2.nextRow();
						if(i==0){
							str = tmpstr;
						} else {
							str = str + "~!~" +tmpstr;
						}
					}
				}
%>	

</TBODY></TABLE>
<TABLE border=1>
<CAPTION><STRONG>SAP Infomation</STRONG></CAPTION>
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
<TD id="sapmsgtypeid"><%=sapmsgtype %></TD>
<TD id="sapmsgid"><%=sapmsg %></TD>
</TR>
</TBODY>
</TABLE>
<%	
		} else {
%>	
		
<TABLE border=1 id="errorinfoid">
<CAPTION>Search Error Infomation</</CAPTION>
<TBODY>
<TR>
<TD><%=errmsg %></TD>
</TR>
</TBODY></TABLE>
<%	
		}
%>
</DIV> 