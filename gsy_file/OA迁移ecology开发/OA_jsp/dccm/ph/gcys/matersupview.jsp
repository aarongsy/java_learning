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
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
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
td.td11{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td12{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

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

<DIV id="warpp">
<TABLE border=1 id="evltblid">
<COLGROUP>
<COL width="10%">
<COL width="10%">
<COL width="20%">
<COL width="5%">
<COL width="5%">
<COL width="7%">
<COL width="5%">
<COL width="5%">
<COL width="8%">
<COL width="5%">
<COL width="5%">
<COL width="15%"></COLGROUP>
<TBODY>
<TR>
<TD>Material ID</TD>
<TD>Material Name</TD>
<TD>Supplier</TD>
<TD>Del.Qualified</TD>
<TD>Del.Delayed</TD>
<TD>Reject Freq</TD>
<TD>Capability</TD>
<TD>Cooperation</TD>
<TD>Pricing Rate</TD>
<TD>Grade</TD>
<TD>Rank</TD>
<TD>Remark</TD></TR>

<%
	String[] arr = {"a","b","c", "d", "e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"};   
	String[] arrfield = {"evlval","evlrat","evlact","evlmark"};  
	Double defaultscore = 0.00;
	DecimalFormat df2  = new DecimalFormat("###.00");
    DecimalFormat df3  = new DecimalFormat("##.000");

	//NumberFormat percent = NumberFormat.getPercentInstance();  
	//percent.setMaximumFractionDigits(3);
	//获取评估项目
	String sql1 = "select materid,matrename,supplier,qualified,delayed,reject,capability,cooperation,rate,grade,rank,remark from uf_dmph_supapplistc where requestid='"+requestid+"' ";

	List list1 = baseJdbc.executeSqlForList(sql1);
	System.out.println("----------222----------"+list1.size());
	if ( list1.size() >0 ) {
		Integer k = 0;
		for ( int i = 0;i<list1.size();i++ ) {
			Map m1= (Map)list1.get(i);
			String materialid = StringHelper.null2String(m1.get("materid"));			//物料id
			String material = StringHelper.null2String(m1.get("matrename"));	// 物料名称
			String suppliername = StringHelper.null2String(m1.get("supplier"));	//供应商名称
			String qualified = StringHelper.null2String(m1.get("qualified"));			//物料id
			String delayed = StringHelper.null2String(m1.get("delayed"));	// 物料名称
			String reject = StringHelper.null2String(m1.get("reject"));	//供应商名称
			String capability = StringHelper.null2String(m1.get("capability"));			//物料id
			String cooperation = StringHelper.null2String(m1.get("cooperation"));	// 物料名称
			String rate = StringHelper.null2String(m1.get("rate"));	//供应商名称
			String grade = StringHelper.null2String(m1.get("grade"));			//物料id
			String rank = StringHelper.null2String(m1.get("rank"));	// 物料名称
			String remark = StringHelper.null2String(m1.get("remark"));	//供应商名称
			System.out.println("----------222----------"+material);
            



%>					
<TR>
<TD><%=materialid%></TD>
<TD><%=material%></TD> 	
<TD><%=suppliername%></TD> 
<TD><%=qualified%></TD>
<TD><%=delayed%></TD> 	
<TD><%=reject%></TD> 
<TD><%=capability%></TD>
<TD><%=cooperation%></TD> 	
<TD><%=rate%></TD> 
<TD><%=grade%></TD>
<TD><%=rank%></TD> 	
<TD><%=remark%></TD> 
</TR>	
<%				

		}	
%>		
<TR>
<TD></TD>
<TD></TD>
<TD></TD>
<TD></TD>-
<TD></TD></TR>		
<%			
	}
%>

</TBODY></TABLE>
</DIV> 