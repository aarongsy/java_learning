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
String parcarno = StringHelper.null2String(request.getParameter("carno"));
String parladingno = StringHelper.null2String(request.getParameter("ladingno"));
String parloadingno = StringHelper.null2String(request.getParameter("loadingno"));
String parinoutno = StringHelper.null2String(request.getParameter("inoutno"));
String parsdate = StringHelper.null2String(request.getParameter("sdate"));
String paredate = StringHelper.null2String(request.getParameter("edate"));
String parisself = StringHelper.null2String(request.getParameter("isself"));
String parprinttype = StringHelper.null2String(request.getParameter("printtype"));
String searchtype = StringHelper.null2String(request.getParameter("searchtype"));
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
<TABLE border=1 id="hypsntblid">
<CAPTION><STRONG>出入厂货运人员登记报表清单</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('hypsntblid','')"><FONT color=#ff0000>Excel导出</FONT></A></SPAN></CAPTION>
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
</COLGROUP>
<TBODY>
<TR>
<TD>序号</TD>
<TD>车牌号</TD>
<TD>提入单号</TD>
<TD>装卸计划号</TD>
<TD>仓库名称</TD>
<TD>提入单打印时间</TD>
<TD>司机姓名</TD>
<TD>出入厂货运人员登记单号</TD>
<TD>登记单号创建日期</TD>
</TR>
<%
try {
	if ( "".equals(parcarno) && "".equals(parladingno)  && "".equals(parloadingno) ) {
		errmsg = "查询条件：车牌号、提入单号、装卸计划号 至少输入一个条件！";	
	} else{
		String sql = "select distinct c.carno,c.ladingno,c.loadingno,c.descofloc,c.printtime,c.drivername,load.inoutno,substr(c.printtime,0,10) createtime from (select a.state,a.reqno,a.inoutno,b.pondno,a.isself from uf_lo_loadplan a , uf_lo_loaddetail  b where a.requestid=b.requestid and a.state='402864d1493b112a01493bfaf09a0008'";
		if ( !"".equals(comtype) ) {	
			sql = sql + " and a.factory='"+comtype+"'";
		}
		sql = sql + ") load ,  uf_lo_ladingmain c where load.pondno=c.ladingno and load.reqno=c.loadingno and c.state='402864d14940d265014941e9d82900da' ";
		
		if ( !"".equals(parcarno) ) {	
			if ( "0".equals(searchtype) ) {
				sql = sql + " and c.carno= '"+parcarno+"'";
			} else {
				sql = sql + " and c.carno like '%"+parcarno+"%'";
			}
		}	
		if ( !"".equals(parladingno) ) {			
			if ( "0".equals(searchtype) ) {
				sql = sql + " and c.ladingno= '"+parladingno+"'";
			} else {
				sql = sql + " and c.ladingno like '%"+parladingno+"%'";
			}
		}
		if ( !"".equals(parloadingno) ) {			
			if ( "0".equals(searchtype) ) {
				sql = sql + " and c.loadingno= '"+parloadingno+"'";
			} else {
				sql = sql + " and c.loadingno like '%"+parloadingno+"%'";
			}
		}
		if ( !"".equals(parisself) ) {
			sql = sql +" and load.isself = '"+parisself+"'";
		}	
		if ( !"".equals(parprinttype) ) {
			sql = sql +" and c.printtype = '"+parprinttype+"'";
		}	
		sql = sql + " order by c.ladingno desc";
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		if ( list.size()>0 ) {	
			for ( int i=0; i<list.size(); i++ ){
				k++;
				Map map = (Map)list.get(i);			
				String carno = StringHelper.null2String(map.get("carno"));
				String ladingno = StringHelper.null2String(map.get("ladingno"));
				String loadingno = StringHelper.null2String(map.get("loadingno"));
				String descofloc = StringHelper.null2String(map.get("descofloc"));
				String printtime = StringHelper.null2String(map.get("printtime"));
				String drivername = StringHelper.null2String(map.get("drivername"));
				String inoutid = StringHelper.null2String(map.get("inoutno"));
				String inoutno = "";
				if ( !"".equals(inoutid) )  {
					//inoutno = ds.getValue("select a.requestid from uf_oa_inoutfreight a,formbase b where a.requestid=b.id and b.isdelete=0 and a.handplanno='"+loadingno+"' ");
					inoutno = inoutid;
					if ( "".equals(drivername) ) {
						drivername = ds.getValue("select a.driver from uf_oa_inoutfreight a where a.requestid='"+inoutid+"' ");
					}
				
				}
				String createtime = StringHelper.null2String(map.get("createtime"));

%>
<TR>
<TD><%=k %></TD>
<TD><%=carno %><input type=<%=("".equals(printtime) ?"hidden":"button") %> onclick="openfrom('<%=carno %>','<%=loadingno %>','<%=createtime %>','<%=inoutid %>')"  value="<%=("".equals(inoutno) ?"创建":"显示") %> " /></TD>
<TD><%=ladingno %></TD>
<TD><%=loadingno %></TD>
<TD><%=descofloc %></TD>
<TD><%=printtime %></TD>
<TD><%=drivername %></TD>
<TD><%=inoutno %></TD>
<TD><%=createtime %></TD>
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