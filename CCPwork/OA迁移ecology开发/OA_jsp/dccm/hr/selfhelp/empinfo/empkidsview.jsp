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
<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String empsapid = StringHelper.null2String(request.getParameter("empsapid"));
//String sql = "select * from uf_dmhr_empaddr where requestid='"+requestid+"'";

//Integer rowlen = 0;

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
<TABLE border=1 id="addinfoid5">
<CAPTION><STRONG>Employee Kids Info</STRONG></CAPTION>
<COLGROUP>
<COL width="20px">
<COL width="30px">
<COL width="30px">
<COL width="30px">
<COL width="120px">
<COL width="80px">
<COL width="80px">
<COL width="80px">
<COL width="100px">
<!--COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%"-->
<COL width="3%">
<COL width="20px">
<COL width="100px">
</COLGROUP>
<TBODY>
<TR>
<TD>Serial No.</TD>
<TD>Employee SAPID</TD>
<TD>Begin Date</TD>
<TD>End Date</TD>
<TD>Name</TD>
<TD>Date of Birth</TD>
<TD>Gender</TD>
<TD>Relationship</TD>
<TD>Educ/Training</TD>
<TD style="display:none">Key-Employee SAPID(O)</TD>
<TD style="display:none">Key-Subtype</TD>
<TD style="display:none">Key-Object</TD>
<TD style="display:none">Key-SAPLock</TD>
<TD style="display:none">Key-Start at</TD>
<TD style="display:none">Key-End at</TD>
<TD style="display:none">Key-SAP SEQ</TD>
<TD>Add/Modify</TD>
<TD>SAP Flag</TD>
<TD>SAP Message</TD></TR>
<%
			String str = "";
			Integer k = 0;
			  String functionName = "";
			  JCoFunction function = null;
			  String errorMessage = "";
			  
				functionName = "ZHR_PA002_KIDS_GET_MY"; //PA002:员工个人信息-Kids获取
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
				JCoTable jcotable = function.getTableParameterList().getTable("IT_KIDS");
						
				if ( jcotable != null && jcotable.getNumRows()>0 ) {
					for (int i = 0; i < jcotable.getNumRows(); i++) {
						k = k + 1;
						String PERNR = StringHelper.null2String(jcotable.getValue("PERNR"));
						//String EMPNO = StringHelper.null2String(jcotable.getValue("EMPNO"));
						String BEGDA = StringHelper.null2String(jcotable.getValue("BEGDA"));
						SimpleDateFormat sdf1 = new SimpleDateFormat ("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK); 
						Date date=sdf1.parse(BEGDA);
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
						BEGDA=sdf.format(date);
						String ENDDA = StringHelper.null2String(jcotable.getValue("ENDDA"));
						date=sdf1.parse(ENDDA);
						ENDDA=sdf.format(date);
						String FANAM = StringHelper.null2String(jcotable.getValue("FANAM"));
						String FGBDT = StringHelper.null2String(jcotable.getValue("FGBDT"));
						String FASEX = StringHelper.null2String(jcotable.getValue("FASEX"));
						String KDSVH = StringHelper.null2String(jcotable.getValue("KDSVH"));
						String FASAR = StringHelper.null2String(jcotable.getValue("FASAR"));
						String PAKEY_PERNR = StringHelper.null2String(jcotable.getValue("PAKEY_PERNR"));
						String PAKEY_SUBTY = StringHelper.null2String(jcotable.getValue("PAKEY_SUBTY"));
						String PAKEY_OBJPS = StringHelper.null2String(jcotable.getValue("PAKEY_OBJPS"));
						String PAKEY_SPRPS = StringHelper.null2String(jcotable.getValue("PAKEY_SPRPS"));
						String PAKEY_ENDDA = StringHelper.null2String(jcotable.getValue("PAKEY_ENDDA"));
						date=sdf1.parse(PAKEY_ENDDA);
						PAKEY_ENDDA=sdf.format(date);
						String PAKEY_BEGDA = StringHelper.null2String(jcotable.getValue("PAKEY_BEGDA"));
						date=sdf1.parse(PAKEY_BEGDA);
						PAKEY_BEGDA=sdf.format(date);
						String PAKEY_SEQNR = StringHelper.null2String(jcotable.getValue("PAKEY_SEQNR"));
						String addrstr = i+"@@"+PERNR +"@@"+BEGDA+"@@"+ENDDA+"@@"+FANAM+"@@"+FGBDT
								+"@@"+FASEX +"@@"+KDSVH +"@@"+ FASAR+"@@"+PAKEY_PERNR+"@@"+PAKEY_SUBTY
								+"@@"+PAKEY_OBJPS +"@@"+PAKEY_SPRPS+"@@"+PAKEY_ENDDA+"@@"+PAKEY_BEGDA+"@@"+PAKEY_SEQNR;
								
%>					
<TR>
<TD><input type="hidden" id="<%="field5_no_"+k %>" name="no5" value="<%=k %>"><%=k %></TD>
<TD><input type="hidden" name="<%="field5_empsapid_"+k%>" id="<%="field5_empsapid_"+k%>" value="<%=PERNR %>"><%=PERNR %></TD>
<TD><input style="width:100%" type="text" name="<%="field5_sdate_"+k%>" id="<%="field5_sdate_"+k%>" value="<%=BEGDA %>"></TD>
<TD><input style="width:100%" type="text" name="<%="field5_edate_"+k%>" id="<%="field5_edate_"+k%>" value="<%=ENDDA %>"></TD>
<TD><input style="width:100%" type="text" name="<%="field5_fname_"+k%>" id="<%="field5_fname_"+k%>" value="<%=FANAM %>"></TD>
<TD><input style="width:100%" type="text" name="<%="field5_birthday_"+k%>" id="<%="field5_birthday_"+k%>" value="<%=FGBDT %>"></TD>
<TD><select type="text" name="<%="field5_gender_"+k%>" id="<%="field5_gender_"+k%>" value="<%=FASEX %>"><option value="1" <% if("1".equals(FASEX)) {%>selected<%} %> >Male</option><option value="2" <% if("2".equals(FASEX)) {%>selected<%} %>>FeMale</option></select></TD>
<TD><select type="text" name="<%="field5_relaship_"+k%>" id="<%="field5_relaship_"+k%>" value="<%=KDSVH %>"><option value="01" <% if("01".equals(KDSVH)) {%>selected<%} %> >01 Legitimate</option><option value="02" <% if("02".equals(KDSVH)) {%>selected<%} %> >02 Adopted</option><option value="03" <% if("03".equals(KDSVH)) {%>selected<%} %> >03 Others</option></select></TD>
<TD><select type="text" name="<%="field5_school_"+k%>" id="<%="field5_school_"+k%>" value="<%=FASAR %>"><option value="" <% if("".equals(FASAR)) {%>selected<%} %> ></option><option value="L1" <% if("L1".equals(FASAR)) {%>selected<%} %> >L1 Primary School</option><option value="L2" <% if("L2".equals(FASAR)) {%>selected<%} %> >L2 Secondary School</option><option value="L3" <% if("L3".equals(FASAR)) {%>selected<%} %> >L3 Local University</option><option value="L4" <% if("L4".equals(FASAR)) {%>selected<%} %> >L4 Foreign University</option></select></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_oempsapid_"+k%>" id="<%="field5_oempsapid_"+k%>" value="<%=PAKEY_PERNR %>"><%=PAKEY_PERNR %></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_subtype_"+k%>" id="<%="field5_subtype_"+k%>" value="<%=PAKEY_SUBTY %>"><%=PAKEY_SUBTY %></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_objtype_"+k%>" id="<%="field5_objtype_"+k%>" value="<%=PAKEY_OBJPS %>"><%=PAKEY_OBJPS %></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_hrlock_"+k%>" id="<%="field5_hrlock_"+k%>" value="<%=PAKEY_SPRPS %>"><%=PAKEY_SPRPS %></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_osdate_"+k%>" id="<%="field5_osdate_"+k%>" value="<%=PAKEY_BEGDA %>"><%=PAKEY_BEGDA %></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_oedate_"+k%>" id="<%="field5_oedate_"+k%>" value="<%=PAKEY_ENDDA %>"><%=PAKEY_ENDDA %></TD>
<TD style="display:none"><input type="hidden" name="<%="field5_seqnr_"+k%>" id="<%="field5_seqnr_"+k%>" value="<%=PAKEY_SEQNR %>"><%=PAKEY_SEQNR %></TD>
<TD><select type="text" name="<%="field5_chgflag_"+k%>" id="<%="field5_chgflag_"+k%>" value="2"><option value="">DoNothing</option><option value="2" selected >Modify</option></select>
<input type="button" id="<%="field5_tosap_"+k%>" value="UpdateToSAP" onclick="toSAP5();"></TD>
<TD><input style="width:100%" type="text" name="<%="field5_sapflag_"+k%>" id="<%="field5_sapflag_"+k%>" value=""></TD>
<TD><input style="width:100%" type="text" name="<%="field5_sapmess_"+k%>" id="<%="field5_sapmess_"+k%>" value=""></TD>
<%						
						
						jcotable.nextRow();
						if(i==0){
							str = addrstr;
						} else {
							str = str + "~!~" +addrstr;
						}
					}
				}
%>	
</TR>	
<TR>
<TD><input type="hidden" id="<%="field5_no_"+(k+1) %>" name="no5" value="<%=(k+1) %>"><%=(k+1) %></TD>
<TD><input type="hidden" name="<%="field5_empsapid_"+(k+1)%>" id="<%="field5_empsapid_"+(k+1)%>" value="<%=empsapid %>"><%=empsapid %></TD>
<TD><input style="width:100%" type="text" name="<%="field5_sdate_"+(k+1)%>" id="<%="field5_sdate_"+(k+1)%>" value=""></TD>
<TD><input style="width:100%" type="text" name="<%="field5_edate_"+(k+1)%>" id="<%="field5_edate_"+(k+1)%>" value="9999-12-31"></TD>
<TD><input style="width:100%" type="text" name="<%="field5_fname_"+(k+1)%>" id="<%="field5_fname_"+(k+1)%>" value=""></TD>
<TD><input style="width:100%" type="text" name="<%="field5_birthday_"+(k+1)%>" id="<%="field5_birthday_"+(k+1)%>" value=""></TD>
<TD><select type="text" name="<%="field5_gender_"+(k+1)%>" id="<%="field5_gender_"+(k+1)%>" value=""><option value="1" >Male</option><option value="2">FeMale</option></select></TD>
<TD><select type="text" name="<%="field5_relaship_"+(k+1)%>" id="<%="field5_relaship_"+(k+1)%>" value=""><option value="01" >01 Legitimate</option><option value="02">02 Adopted</option><option value="03">03 Others</option></select></TD>
<TD><select type="text" name="<%="field5_school_"+(k+1)%>" id="<%="field5_school_"+(k+1)%>" value=""><option value="" ></option><option value="L1" >L1 Primary School</option><option value="L2" >L2 Secondary School</option><option value="L3" >L3 Local University</option><option value="L4" >L4 Foreign University</option></select></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_oempsapid_"+(k+1)%>" id="<%="field5_oempsapid_"+(k+1)%>" value=""></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_subtype_"+(k+1)%>" id="<%="field5_subtype_"+(k+1)%>" value=""></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_objtype_"+(k+1)%>" id="<%="field5_objtype_"+(k+1)%>" value=""></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_hrlock_"+(k+1)%>" id="<%="field5_hrlock_"+(k+1)%>" value=""></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_osdate_"+(k+1)%>" id="<%="field5_osdate_"+(k+1)%>" value=""></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_oedate_"+(k+1)%>" id="<%="field5_oedate_"+(k+1)%>" value=""></TD>
<TD style="display:none" ><input type="hidden" name="<%="field5_seqnr_"+(k+1)%>" id="<%="field5_seqnr_"+(k+1)%>" value=""></TD>
<TD><select type="text" name="<%="field5_chgflag_"+(k+1)%>" id="<%="field5_chgflag_"+(k+1)%>" value="1"><option value="">DoNothing</option><option value="1"  selected>Add</option></select>
<input type="button" id="<%="field5_tosap_"+(k+1)%>" value="UpdateToSAP" onclick="toSAP5();"></TD>
<TD><input style="width:100%" style="width:100%" type="text" name="<%="field5_sapflag_"+(k+1)%>" id="<%="field5_sapflag_"+(k+1)%>" value=""></TD>
<TD><input style="width:100%" style="width:100%" type="text" name="<%="field5_sapmess_"+(k+1)%>" id="<%="field5_sapmess_"+(k+1)%>" value=""></TD>
</TR>
</TBODY></TABLE>
</DIV> 