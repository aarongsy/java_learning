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
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/base/init.jsp"%>

<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String jobnos = StringHelper.null2String(request.getParameter("jobnos"));
if ( !"".equals(jobnos) ) {
	jobnos = jobnos.replaceAll("/","','" );
	System.out.println("jobnos="+jobnos);
}
String jobnames = StringHelper.null2String(request.getParameter("jobnames"));
if(  !"".equals(jobnames) ) {
	jobnos = "";
}
String sdate = StringHelper.null2String(request.getParameter("sdate"));
String edate = StringHelper.null2String(request.getParameter("edate"));
String curdate = StringHelper.null2String(request.getParameter("curdate"));
if ( !"".equals(sdate) &&  "".equals(edate)) {
	edate = sdate;
} else if ( "".equals(sdate) &&  !"".equals(edate) ) {
	sdate = edate;
} else if ( "".equals(sdate) &&  "".equals(edate)  )  {
	sdate = curdate;
	edate = curdate;
}

String schname = StringHelper.null2String(request.getParameter("schname"));
String comtype = StringHelper.null2String(request.getParameter("comtype"));
//"select requestid from uf_oa_inoutfreight where flowno='"++"' and loadingno='"+loadingno+"'";
String errmsg = "";
DataService ds = new DataService();


//int existflag = Integer.parseInt(ds.getValue("select count(extrefobjfield5) from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select distinct userid from sysuserrolelink where (roleid='40285a9049f5c9900149f91201c0002a' or roleid='40285a904abeeb0e014ac37afe343d02')) or id='40285a9049ade1710149adea9ef20caf'"));

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
<TABLE border=1 id="pjpsntblid">
<CAPTION><STRONG>盘锦厂驾驶证倒班人员排班表清单</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('pjpsntblid','')"><FONT color=#ff0000>Excel导出</FONT></A></SPAN></CAPTION>
<COLGROUP>
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TBODY>
<TR>
<TD>序号</TD>
<TD>工号</TD>
<TD>姓名</TD>
<TD>SAPID</TD>
<TD>日期</TD>
<TD>班别</TD>
</TR>
<%
try {
	if ( "".equals(jobnos) && "".equals(jobnames)   ) {
		errmsg = "查询条件：工号、姓名 至少输入一个条件！";	
	} else{
		String sql = "select a.jobno,b.objname jobname,a.sapjobno sapid,a.thedate,a.classname,a.hours from v_uf_hr_classplan a, humres b where b.id=a.objname ";
		if ( !"".equals(comtype) ) {	
			sql = sql + " and a.comtype='"+comtype+"'";
		}				
		if ( !"".equals(jobnos) ) {	
			if ( jobnos.indexOf("/")!=-1 ) {
				sql = sql + " and a.jobno= '"+jobnos+"'";
			} else {
				sql = sql + " and a.jobno in ('"+jobnos+"')";
			}
		}	
		if ( !"".equals(jobnames) ) {			
			sql = sql + " and b.objname= '"+jobnames+"'";			
		}
		if ( !"".equals(sdate) ) {
			sql = sql +" and a.thedate>= '"+sdate+"'";
		}	
		if ( !"".equals(edate) ) {
			sql = sql +" and a.thedate<= '"+edate+"'";
		}	
		if ( !"".equals(schname) ) {
			sql = sql +" and a.classname= '"+schname+"'";
		}
		sql = sql + " order by a.thedate asc,a.jobno asc";
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		if ( list.size()>0 ) {	
			for ( int i=0; i<list.size(); i++ ){
				k++;
				Map map = (Map)list.get(i);					
				String jobno = StringHelper.null2String(map.get("jobno"));
				String jobname = StringHelper.null2String(map.get("jobname"));
				String sapid = StringHelper.null2String(map.get("sapid"));
				String thedate = StringHelper.null2String(map.get("thedate"));
				String classname = StringHelper.null2String(map.get("classname"));
				String hours = StringHelper.null2String(map.get("hours"));
%>
<TR>
<TD><%=k %></TD>
<TD><%=jobno %></TD>
<TD><%=jobname %></TD>
<TD><%=sapid %></TD>
<TD><%=thedate %></TD>
<TD><%=classname %></TD>
</TR>
<%				
		}
%>
</TBODY></TABLE>
<%				
		} else {
			errmsg = "没有数据，请重新输入正确的查询条件";
		}
	}
} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		errmsg = e.toString();
}
%>
<TABLE border=1 id="errorinfoid">
<CAPTION>查询结果</CAPTION>
<TBODY>
<TR>
<TD><%=errmsg %></TD>
</TR>
</TBODY></TABLE>
</DIV> 