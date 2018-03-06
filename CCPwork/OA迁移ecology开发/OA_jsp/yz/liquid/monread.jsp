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
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@page import="com.eweaver.mobile.layout.convert.BrowserConvert"%>
<%@ include file="/app/base/init.jsp"%>
<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String isedit=StringHelper.null2String(request.getParameter("isedit"));

BrowserConvert browserConvert = new BrowserConvert();
browserConvert.setTypeid("40285a904a2e9985014a3899438a4824");

DataService ds = new DataService();
//int days =  Integer.parseInt(ds.getValue("select to_char(last_day(to_date('"+yearmon+"-01','yyyy-mm-dd')),'dd') from dual") ); //得到最后一天的日期
%>
<style type="text/css"> 
body{ font-size:12px; color:#EDF0F5;} 
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
<div id="warpp">
<TABLE id=oTable40285a904a2e9985014a38791222442e class=detailtable border=1>
<CAPTION>公用流体累计量登录明细表</CAPTION>
<COLGROUP>
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%"></COLGROUP>
<TR class=Header>
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a904a2e9985014a38791222442e')" value=-1 type=checkbox name=check_node_all><A id=MultiLanguageLabel_40285a904a2e9985014a387b19154458 name=MultiLanguageLabel>累计量项目编号</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387b1934445a name=MultiLanguageLabel>累计量项目</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387b1956445c name=MultiLanguageLabel>单位</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387bdc38448b name=MultiLanguageLabel>DAY01</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387bdc60448d name=MultiLanguageLabel>DAY02</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387df9624493 name=MultiLanguageLabel>DAY03</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387df9834495 name=MultiLanguageLabel>DAY04</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387df99c4497 name=MultiLanguageLabel>DAY05</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387df9bb4499 name=MultiLanguageLabel>DAY06</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387df9d4449b name=MultiLanguageLabel>DAY07</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387df9ee449d name=MultiLanguageLabel>DAY08</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387dfa0b449f name=MultiLanguageLabel>DAY09</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387dfa2444a1 name=MultiLanguageLabel>DAY10</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387dfa3f44a3 name=MultiLanguageLabel>DAY11</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fba8e44da name=MultiLanguageLabel>DAY12</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbab244dc name=MultiLanguageLabel>DAY13</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbacf44de name=MultiLanguageLabel>DAY14</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbaed44e0 name=MultiLanguageLabel>DAY15</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbb0744e2 name=MultiLanguageLabel>DAY16</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbb2144e4 name=MultiLanguageLabel>DAY17</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbb3d44e6 name=MultiLanguageLabel>DAY18</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a387fbb5744e8 name=MultiLanguageLabel>DAY19</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822c06456a name=MultiLanguageLabel>DAY20</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822c26456c name=MultiLanguageLabel>DAY21</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822c43456e name=MultiLanguageLabel>DAY22</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822c604570 name=MultiLanguageLabel>DAY23</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822c7d4572 name=MultiLanguageLabel>DAY24</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822c9b4574 name=MultiLanguageLabel>DAY25</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822cb94576 name=MultiLanguageLabel>DAY26</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822cd74578 name=MultiLanguageLabel>DAY27</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822cf5457a name=MultiLanguageLabel>DAY28</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822d14457c name=MultiLanguageLabel>DAY29</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822d32457e name=MultiLanguageLabel>DAY30</A></TD>
<TD noWrap><A id=MultiLanguageLabel_40285a904a2e9985014a38822d504580 name=MultiLanguageLabel>DAY31</A></TD></TR>
<%
	
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	
	String sql="select a.liqitemid liqitemid, a.liqitem liqitem,b.liqitem itemname,nvl(a.unit,'') unit,nvl(a.day01,'') day01,nvl(a.day02,'') day02,nvl(a.day03,'') day03,nvl(a.day04,'') day04,nvl(a.day05,'') day05,nvl(a.day06,'') day06,nvl(a.day07,'') day07,nvl(a.day08,'') day08,nvl(a.day09,'') day09,nvl(a.day10,'') day10,nvl(a.day11,'') day11,nvl(a.day12,'') day12,nvl(a.day13,'') day13,nvl(a.day14,'') day14,nvl(a.day15,'') day15,nvl(a.day16,'') day16,nvl(a.day17,'') day17,nvl(a.day18,'') day18,nvl(a.day19,'') day19,nvl(a.day20,'') day20,nvl(a.day21,'') day21,nvl(a.day22,'') day22,nvl(a.day23,'') day23,nvl(a.day24,'') day24,nvl(a.day25,'') day25,nvl(a.day26,'') day26,nvl(a.day27,'') day27,nvl(a.day28,'') day28,nvl(a.day29,'') day29,nvl(a.day30,'') day30,nvl(a.day31,'') day31 from uf_yz_liqmonreadsub a left join uf_yz_liquiditem b on a.liqitem=b.requestid where a.requestid='"+requestid+"' order by a.liqitemid asc";

	List datalist = baseJdbc.executeSqlForList(sql);
	StringBuffer burr1 = new StringBuffer();
	String btnhtml="";
	
	String liqitemid="";
	String liqitem="";
	String itemname="";
	String unit="";
	String day01="";
	String day02="";
	String day03="";
	String day04="";	
	String day05="";
	String day06="";
	String day07="";
	String day08="";
	String day09="";
	String day10="";
	String day11="";
	String day12="";	
	String day13="";
	String day14="";
	String day15="";
	String day16="";
	String day17="";
	String day18="";
	String day19="";
	String day20="";	
	String day21="";
	String day22="";
	String day23="";
	String day24="";
	String day25="";	
	String day26="";
	String day27="";
	String day28="";
	String day29="";
	String day30="";
	String day31="";		
	for(int i1=0,sizei1=datalist.size();i1<sizei1;i1++)
	{
		Map mi1 = (Map)datalist.get(i1); 
		liqitemid = StringHelper.null2String(mi1.get("liqitemid"));
		liqitem = StringHelper.null2String(mi1.get("liqitem"));
		itemname = StringHelper.null2String(mi1.get("itemname"));
		unit = StringHelper.null2String(mi1.get("unit"));
		day01 = StringHelper.null2String(mi1.get("day01"));
		day02 = StringHelper.null2String(mi1.get("day02"));
		day03 = StringHelper.null2String(mi1.get("day03"));
		day04 = StringHelper.null2String(mi1.get("day04"));
		day05 = StringHelper.null2String(mi1.get("day05"));
		day06 = StringHelper.null2String(mi1.get("day06"));
		day07 = StringHelper.null2String(mi1.get("day07"));
		day08 = StringHelper.null2String(mi1.get("day08"));
		day09 = StringHelper.null2String(mi1.get("day09"));
		day10 = StringHelper.null2String(mi1.get("day10"));
		day11 = StringHelper.null2String(mi1.get("day11"));
		day12 = StringHelper.null2String(mi1.get("day12"));
		day13 = StringHelper.null2String(mi1.get("day13"));
		day14 = StringHelper.null2String(mi1.get("day14"));
		day15 = StringHelper.null2String(mi1.get("day15"));
		day16 = StringHelper.null2String(mi1.get("day16"));
		day17 = StringHelper.null2String(mi1.get("day17"));
		day18 = StringHelper.null2String(mi1.get("day18"));
		day19 = StringHelper.null2String(mi1.get("day19"));
		day20 = StringHelper.null2String(mi1.get("day20"));
		day21 = StringHelper.null2String(mi1.get("day21"));
		day22 = StringHelper.null2String(mi1.get("day22"));
		day23 = StringHelper.null2String(mi1.get("day23"));
		day24 = StringHelper.null2String(mi1.get("day24"));
		day25 = StringHelper.null2String(mi1.get("day25"));
		day26 = StringHelper.null2String(mi1.get("day26"));
		day27 = StringHelper.null2String(mi1.get("day27"));
		day28 = StringHelper.null2String(mi1.get("day28"));
		day29 = StringHelper.null2String(mi1.get("day29"));
		day30 = StringHelper.null2String(mi1.get("day30"));		
		day31 = StringHelper.null2String(mi1.get("day31"));	

		if(isedit.equals("1")){
			burr1.append("<tr id=oTR40285a904a2e9985014a38791222442e class=DataLight>");
			burr1.append("<TD noWrap><span style=\"DISPLAY:none\"><input type=\"checkbox\" name=\"check_node_40285a904a2e9985014a38791222442e\" value=\""+i1+"\"><input type=hidden name=\"detailid_40285a904a2e9985014a38791222442e_"+i1+"\" value=\""+i1+"\"></span>");
			burr1.append("<input type=\"hidden\" id=\"field_40285a904a2e9985014a387b19154458_"+i1+"\" name=\"field_40285a904a2e9985014a387b19154458_"+i1+"\"  value=\""+liqitemid+"\"  >");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387b19154458_"+i1+"span\" name=\"field_40285a904a2e9985014a387b19154458_"+i1+"span\" >"+liqitemid+"</span>");
			burr1.append("</TD>");
			
			burr1.append("<TD noWrap><input type=\"hidden\" id=\"field_40285a904a2e9985014a387b1934445a_"+i1+"\" name=\"field_40285a904a2e9985014a387b1934445a_"+i1+"\" value=\""+liqitem+"\" >");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387b1934445a_"+i1+"span\" name=\"field_40285a904a2e9985014a387b1934445a_"+i1+"span\" >"+itemname+"</span>");
			burr1.append("</TD>");
			
			burr1.append("<TD noWrap><input type=\"hidden\" id=\"field_40285a904a2e9985014a387b1956445c_"+i1+"\" name=\"field_40285a904a2e9985014a387b1956445c_"+i1+"\" value=\""+unit+"\" >");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387b1956445c_"+i1+"span\" name=\"field_40285a904a2e9985014a387b1956445c_"+i1+"span\" >"+unit+"</span>");
			burr1.append("</TD>");

			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387bdc38448b_"+i1+"\"  id=\"field_40285a904a2e9985014a387bdc38448b_"+i1+"\" value=\""+day01+"\"  style='width: 80%'  onblur=\"javascript:fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY01');\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387bdc60448d_"+i1+"\"  id=\"field_40285a904a2e9985014a387bdc60448d_"+i1+"\" value=\""+day02+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY02')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9624493_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9624493_"+i1+"\" value=\""+day03+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY03')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9834495_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9834495_"+i1+"\" value=\""+day04+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY04')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df99c4497_"+i1+"\"  id=\"field_40285a904a2e9985014a387df99c4497_"+i1+"\" value=\""+day05+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY05')\" ></TD>");		
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9bb4499_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9bb4499_"+i1+"\" value=\""+day06+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY06')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9d4449b_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9d4449b_"+i1+"\" value=\""+day07+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY07')\" ></TD>");		
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9ee449d_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9ee449d_"+i1+"\" value=\""+day08+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY08')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387dfa0b449f_"+i1+"\"  id=\"field_40285a904a2e9985014a387dfa0b449f_"+i1+"\" value=\""+day09+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY09')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387dfa2444a1_"+i1+"\"  id=\"field_40285a904a2e9985014a387dfa2444a1_"+i1+"\" value=\""+day10+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY10')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387dfa3f44a3_"+i1+"\"  id=\"field_40285a904a2e9985014a387dfa3f44a3_"+i1+"\" value=\""+day11+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY11')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fba8e44da_"+i1+"\"  id=\"field_40285a904a2e9985014a387fba8e44da_"+i1+"\" value=\""+day12+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY12')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbab244dc_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbab244dc_"+i1+"\" value=\""+day13+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY13')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbacf44de_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbacf44de_"+i1+"\" value=\""+day14+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY14')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbaed44e0_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbaed44e0_"+i1+"\" value=\""+day15+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY15')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb0744e2_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb0744e2_"+i1+"\" value=\""+day16+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY16')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb2144e4_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb2144e4_"+i1+"\" value=\""+day17+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY17')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb3d44e6_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb3d44e6_"+i1+"\" value=\""+day18+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY18')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb5744e8_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb5744e8_"+i1+"\" value=\""+day19+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY19')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c06456a_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c06456a_"+i1+"\" value=\""+day20+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY20')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c26456c_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c26456c_"+i1+"\" value=\""+day21+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY21')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c43456e_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c43456e_"+i1+"\" value=\""+day22+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY22')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c604570_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c604570_"+i1+"\" value=\""+day23+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY23')\" ></TD>");
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c7d4572_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c7d4572_"+i1+"\" value=\""+day24+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY24')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c9b4574_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c9b4574_"+i1+"\" value=\""+day25+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY25')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822cb94576_"+i1+"\"  id=\"field_40285a904a2e9985014a38822cb94576_"+i1+"\" value=\""+day26+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY26')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822cd74578_"+i1+"\"  id=\"field_40285a904a2e9985014a38822cd74578_"+i1+"\" value=\""+day27+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY27')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822cf5457a_"+i1+"\"  id=\"field_40285a904a2e9985014a38822cf5457a_"+i1+"\" value=\""+day28+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY28')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822d14457c_"+i1+"\"  id=\"field_40285a904a2e9985014a38822d14457c_"+i1+"\" value=\""+day29+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY29')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822d32457e_"+i1+"\"  id=\"field_40285a904a2e9985014a38822d32457e_"+i1+"\" value=\""+day30+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY30')\" ></TD>");	
			burr1.append("<TD noWrap><input type=\"text\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822d504580_"+i1+"\"  id=\"field_40285a904a2e9985014a38822d504580_"+i1+"\" value=\""+day31+"\"  style='width: 80%'  onblur=\"fieldcheck(this,'^(-?[\\\\d+]{1,22})(\\\\.[\\\\d+]{1,2})?$','DAY31')\" ></TD>");	
			burr1.append("</tr>");
		}else if(isedit.equals("0")){
			burr1.append("<tr id=oTR40285a904a2e9985014a38791222442e class=DataLight>");
			burr1.append("<TD noWrap><span style=\"DISPLAY:none\"><input type=\"checkbox\" name=\"check_node_40285a904a2e9985014a38791222442e\" value=\""+i1+"\"><input type=hidden name=\"detailid_40285a904a2e9985014a38791222442e_"+i1+"\" value=\""+i1+"\"></span>");
			burr1.append("<input type=\"hidden\" id=\"field_40285a904a2e9985014a387b19154458_"+i1+"\" name=\"field_40285a904a2e9985014a387b19154458_"+i1+"\"  value=\""+liqitemid+"\"  >");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387b19154458_"+i1+"span\" name=\"field_40285a904a2e9985014a387b19154458_"+i1+"span\" >"+liqitemid+"</span>");
			burr1.append("</TD>");
			
			burr1.append("<TD noWrap><input type=\"hidden\" id=\"field_40285a904a2e9985014a387b1934445a_"+i1+"\" name=\"field_40285a904a2e9985014a387b1934445a_"+i1+"\" value=\""+liqitem+"\" >");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387b1934445a_"+i1+"span\" name=\"field_40285a904a2e9985014a387b1934445a_"+i1+"span\" >"+itemname+"</span>");
			burr1.append("</TD>");
			
			burr1.append("<TD noWrap><input type=\"hidden\" id=\"field_40285a904a2e9985014a387b1956445c_"+i1+"\" name=\"field_40285a904a2e9985014a387b1956445c_"+i1+"\" value=\""+unit+"\" >");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387b1956445c_"+i1+"span\" name=\"field_40285a904a2e9985014a387b1956445c_"+i1+"span\" >"+unit+"</span>");
			burr1.append("</TD>");

			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387bdc38448b_"+i1+"\"  id=\"field_40285a904a2e9985014a387bdc38448b_"+i1+"\" value=\""+day01+"\"  style='width: 80%'>");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387bdc38448b_"+i1+"span\" name=\"field_40285a904a2e9985014a387bdc38448b_"+i1+"span\" >"+day01+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387bdc60448d_"+i1+"\"  id=\"field_40285a904a2e9985014a387bdc60448d_"+i1+"\" value=\""+day02+"\"  style='width: 80%'>");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387bdc60448d_"+i1+"span\" name=\"field_40285a904a2e9985014a387bdc60448d_"+i1+"span\" >"+day02+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9624493_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9624493_"+i1+"\" value=\""+day03+"\"  style='width: 80%'>");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387df9624493_"+i1+"span\" name=\"field_40285a904a2e9985014a387df9624493_"+i1+"span\" >"+day03+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9834495_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9834495_"+i1+"\" value=\""+day04+"\"  style='width: 80%'>");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387df9834495_"+i1+"span\" name=\"field_40285a904a2e9985014a387df9834495_"+i1+"span\" >"+day04+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df99c4497_"+i1+"\"  id=\"field_40285a904a2e9985014a387df99c4497_"+i1+"\" value=\""+day05+"\"  style='width: 80%'>");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387df99c4497_"+i1+"span\" name=\"field_40285a904a2e9985014a387df99c4497_"+i1+"span\" >"+day05+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9bb4499_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9bb4499_"+i1+"\" value=\""+day06+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387df9bb4499_"+i1+"span\" name=\"field_40285a904a2e9985014a387df9bb4499_"+i1+"span\" >"+day06+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9d4449b_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9d4449b_"+i1+"\" value=\""+day07+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387df9d4449b_"+i1+"span\" name=\"field_40285a904a2e9985014a387df9d4449b_"+i1+"span\" >"+day07+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387df9ee449d_"+i1+"\"  id=\"field_40285a904a2e9985014a387df9ee449d_"+i1+"\" value=\""+day08+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387df9ee449d_"+i1+"span\" name=\"field_40285a904a2e9985014a387df9ee449d_"+i1+"span\" >"+day08+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387dfa0b449f_"+i1+"\"  id=\"field_40285a904a2e9985014a387dfa0b449f_"+i1+"\" value=\""+day09+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387dfa0b449f_"+i1+"span\" name=\"field_40285a904a2e9985014a387dfa0b449f_"+i1+"span\" >"+day09+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387dfa2444a1_"+i1+"\"  id=\"field_40285a904a2e9985014a387dfa2444a1_"+i1+"\" value=\""+day10+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387dfa2444a1_"+i1+"span\" name=\"field_40285a904a2e9985014a387dfa2444a1_"+i1+"span\" >"+day10+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387dfa3f44a3_"+i1+"\"  id=\"field_40285a904a2e9985014a387dfa3f44a3_"+i1+"\" value=\""+day11+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387dfa3f44a3_"+i1+"span\" name=\"field_40285a904a2e9985014a387dfa3f44a3_"+i1+"span\" >"+day11+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fba8e44da_"+i1+"\"  id=\"field_40285a904a2e9985014a387fba8e44da_"+i1+"\" value=\""+day12+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fba8e44da_"+i1+"span\" name=\"field_40285a904a2e9985014a387fba8e44da_"+i1+"span\" >"+day12+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbab244dc_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbab244dc_"+i1+"\" value=\""+day13+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbab244dc_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbab244dc_"+i1+"span\" >"+day13+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbacf44de_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbacf44de_"+i1+"\" value=\""+day14+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbacf44de_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbacf44de_"+i1+"span\" >"+day14+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbaed44e0_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbaed44e0_"+i1+"\" value=\""+day15+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbaed44e0_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbaed44e0_"+i1+"span\" >"+day15+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb0744e2_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb0744e2_"+i1+"\" value=\""+day16+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbb0744e2_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbb0744e2_"+i1+"span\" >"+day16+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb2144e4_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb2144e4_"+i1+"\" value=\""+day17+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbb2144e4_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbb2144e4_"+i1+"span\" >"+day17+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb3d44e6_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb3d44e6_"+i1+"\" value=\""+day18+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbb3d44e6_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbb3d44e6_"+i1+"span\" >"+day18+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a387fbb5744e8_"+i1+"\"  id=\"field_40285a904a2e9985014a387fbb5744e8_"+i1+"\" value=\""+day19+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a387fbb5744e8_"+i1+"span\" name=\"field_40285a904a2e9985014a387fbb5744e8_"+i1+"span\" >"+day19+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c06456a_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c06456a_"+i1+"\" value=\""+day20+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822c06456a_"+i1+"span\" name=\"field_40285a904a2e9985014a38822c06456a_"+i1+"span\" >"+day20+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c26456c_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c26456c_"+i1+"\" value=\""+day21+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822c26456c_"+i1+"span\" name=\"field_40285a904a2e9985014a38822c26456c_"+i1+"span\" >"+day21+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c43456e_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c43456e_"+i1+"\" value=\""+day22+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822c43456e_"+i1+"span\" name=\"field_40285a904a2e9985014a38822c43456e_"+i1+"span\" >"+day22+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c604570_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c604570_"+i1+"\" value=\""+day23+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822c604570_"+i1+"span\" name=\"field_40285a904a2e9985014a38822c604570_"+i1+"span\" >"+day23+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c7d4572_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c7d4572_"+i1+"\" value=\""+day24+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822c7d4572_"+i1+"span\" name=\"field_40285a904a2e9985014a38822c7d4572_"+i1+"span\" >"+day24+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822c9b4574_"+i1+"\"  id=\"field_40285a904a2e9985014a38822c9b4574_"+i1+"\" value=\""+day25+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822c9b4574_"+i1+"span\" name=\"field_40285a904a2e9985014a38822c9b4574_"+i1+"span\" >"+day25+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822cb94576_"+i1+"\"  id=\"field_40285a904a2e9985014a38822cb94576_"+i1+"\" value=\""+day26+"\"  style='width: 80'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822cb94576_"+i1+"span\" name=\"field_40285a904a2e9985014a38822cb94576_"+i1+"span\" >"+day26+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822cd74578_"+i1+"\"  id=\"field_40285a904a2e9985014a38822cd74578_"+i1+"\" value=\""+day27+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822cd74578_"+i1+"span\" name=\"field_40285a904a2e9985014a38822cd74578_"+i1+"span\" >"+day27+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822cf5457a_"+i1+"\"  id=\"field_40285a904a2e9985014a38822cf5457a_"+i1+"\" value=\""+day28+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822cf5457a_"+i1+"span\" name=\"field_40285a904a2e9985014a38822cf5457a_"+i1+"span\" >"+day28+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822d14457c_"+i1+"\"  id=\"field_40285a904a2e9985014a38822d14457c_"+i1+"\" value=\""+day29+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822d14457c_"+i1+"span\" name=\"field_40285a904a2e9985014a38822d14457c_"+i1+"span\" >"+day29+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822d32457e_"+i1+"\"  id=\"field_40285a904a2e9985014a38822d32457e_"+i1+"\" value=\""+day30+"\"  style='width: 80%'");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822d32457e_"+i1+"span\" name=\"field_40285a904a2e9985014a38822d32457e_"+i1+"span\" >"+day30+"</span>");
			burr1.append("</TD>");
			burr1.append("<TD noWrap><input type=\"hidden\" class=\"InputStyle2\" name=\"field_40285a904a2e9985014a38822d504580_"+i1+"\"  id=\"field_40285a904a2e9985014a38822d504580_"+i1+"\" value=\""+day31+"\"  style='width: 80%' ");
			burr1.append("<span style='width: 80%' id=\"field_40285a904a2e9985014a38822d504580_"+i1+"span\" name=\"field_40285a904a2e9985014a38822d504580_"+i1+"span\" >"+day31+"</span>");
			burr1.append("</TD>");
			burr1.append("</tr>");				
		}
	}
	burr1.append("</table>");
	out.println(burr1.toString());	
%> 
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               