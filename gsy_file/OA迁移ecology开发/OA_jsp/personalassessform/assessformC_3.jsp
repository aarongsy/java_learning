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
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String employno=StringHelper.null2String(request.getParameter("employno"));
String planname=StringHelper.null2String(request.getParameter("planname"));
String assessyear=StringHelper.null2String(request.getParameter("assessyear"));//考核年度
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>



<%
String SumScore="";//"考勤分数"与"奖惩相抵分数"综合考虑后的分数

String sql1="select checkscore from uf_hr_checkimplechild where employnum='"+employno+"' and planname='"+planname+"'";
List sublist1 = baseJdbc.executeSqlForList(sql1);
String checkscore="";//考勤分数
if(sublist1.size()>0)
{
	Map mk1 = (Map)sublist1.get(0);
	checkscore=StringHelper.null2String(mk1.get("checkscore"));
}

String sql2="select Rewardbalance from uf_hr_checkperformance where employno='"+employno+"' and checkyear='"+assessyear+"'";
List sublist2=baseJdbc.executeSqlForList(sql2);
String rewardbalance="";//奖惩相抵分数
if(sublist2.size()>0)
{
	Map mk2=(Map)sublist2.get(0);
	rewardbalance=StringHelper.null2String(mk2.get("rewardbalance"));
}

//"考勤"和"奖惩"综合判断的依据
if(Integer.parseInt(rewardbalance)>=-5 && Integer.parseInt(rewardbalance)<=-3)
{
	SumScore="2.5";
}
else if(Integer.parseInt(rewardbalance)>=-8 && Integer.parseInt(rewardbalance)<=-6)
{
	SumScore="2";
}
else if(Integer.parseInt(rewardbalance)>=-17 && Integer.parseInt(rewardbalance)<=-9)
{
	SumScore="1";
}
else if(Integer.parseInt(rewardbalance)>=-9999 && Integer.parseInt(rewardbalance)<=-18)
{
	SumScore="0";
}
else
{
	SumScore=checkscore;
}
%>


<%
//查询员工绩效考核中的初评总分在复评中给予显示
String sql="select * from uf_hr_checkperformance where requestid='"+requestid+"'";
List sublist = baseJdbc.executeSqlForList(sql);
String firstreview1="";
String firstreview2="";
String firstreview3="";
String firstreview4="";
String firstreview5="";
String firstreview6="";
String firstreview7="";
String firstreview8="";
String firstreview9="";
String firstreview10="";
String totalfirst="";
String againreview1="";
String againreview2="";
String againreview3="";
String againreview4="";
String againreview5="";
String againreview6="";
String againreview7="";
String againreview8="";
String againreview9="";
String againreview10="";
String totalagain="";
String examineperson="";//审批人
String Factorydiff="";//厂区别
String Rank="";//职级
String Totalreview="";//分数
String FirstEval="";//被考核的评语及记事
String ExamEval="";//审批人的评语及记事
if(sublist.size()>0)
{
    for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		 firstreview1=StringHelper.null2String(mk.get("firstreview1"));
		 firstreview2=StringHelper.null2String(mk.get("firstreview2"));
		 firstreview3=StringHelper.null2String(mk.get("firstreview3"));
		 firstreview4=StringHelper.null2String(mk.get("firstreview4"));
		 firstreview5=StringHelper.null2String(mk.get("firstreview5"));
		 firstreview6=StringHelper.null2String(mk.get("firstreview6"));
		 firstreview7=StringHelper.null2String(mk.get("firstreview7"));
		 firstreview8=StringHelper.null2String(mk.get("firstreview8"));
		 firstreview9=StringHelper.null2String(mk.get("firstreview9"));
		 firstreview10=StringHelper.null2String(mk.get("firstreview10"));
		 totalfirst=StringHelper.null2String(mk.get("totalfirst"));
		 againreview1=StringHelper.null2String(mk.get("againreview1"));
		 againreview2=StringHelper.null2String(mk.get("againreview2"));
		 againreview3=StringHelper.null2String(mk.get("againreview3"));
		 againreview4=StringHelper.null2String(mk.get("againreview4"));
		 againreview5=StringHelper.null2String(mk.get("againreview5"));
	     againreview6=StringHelper.null2String(mk.get("againreview6"));
		 againreview7=StringHelper.null2String(mk.get("againreview7"));
		 againreview8=StringHelper.null2String(mk.get("againreview8"));
		 againreview9=StringHelper.null2String(mk.get("againreview9"));
		 againreview10=StringHelper.null2String(mk.get("againreview10"));
		 totalagain=StringHelper.null2String(mk.get("totalagain"));
		 examineperson=StringHelper.null2String(mk.get("examineperson"));
		 Factorydiff=StringHelper.null2String(mk.get("Factorydiff"));
		 Rank=StringHelper.null2String(mk.get("Rank"));
		 Totalreview=StringHelper.null2String(mk.get("Totalreview"));
		 FirstEval=StringHelper.null2String(mk.get("FirstEval"));
		 ExamEval=StringHelper.null2String(mk.get("ExamEval"));
	}
}
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

<script type='text/javascript' language="javascript">
//js代码
</script>

<DIV id="warpp">
<table id="" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<TR noWrap class="tr1">
<TD noWrap class="td2" align=center colspan="4">考核项目</TD>
<TD noWrap class="td2" align=center colspan="4">评核依据</TD>
<TD noWrap class="td2" align=center colspan="4">系统评分</TD>
</TR>
<TR noWrap class="tr1">
<TD noWrap class="td2" align=center colspan="4">敬业精神</TD>
<TD noWrap class="td2" align=center colspan="4">考勤</TD>
<TD noWrap class="td2" align=center colspan="4"><%=SumScore%></TD>
</TR>
<!--<TR noWrap class="tr1">
<TD noWrap class="td2" align=center colspan="4">专业知识</TD>
<TD noWrap class="td2" align=center colspan="4">受训</TD>
<TD noWrap class="td2" align=center colspan="4"><input type="hidden" id="b" style="width40px;height:20px;text-align:center"/></TD>
</TR>
<TR noWrap class="tr1">
<TD noWrap class="td2" align=center colspan="4">沟通能力</TD>
<TD noWrap class="td2" align=center colspan="4">授课</TD>
<TD noWrap class="td2" align=center colspan="4"><input type="hidden" id="c" style="width40px;height:20px;text-align:center"/></TD>
</TR>-->
</table>
<TABLE id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="9%">
<COL width="3%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="5%">
<%
//复评一栏
    if(againreview2.equals(""))
	{
		%>
		<COL width="5%" style="display:none">
		<%
	}
	else
	{
		%>
		<COL width="5%">
		<%
	}
%>
<COL width="5%">
<COL width="5%" style="display:none">
<COL width="5%" style="display:none">
</COLGROUP>

<TR height="25"  class="title">
<TD noWrap class="td1" align=left colspan="12">1.一般考绩</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center rowspan="2">区分</TD>
<TD noWrap class="td2"  align=center rowspan="2">考核项目</TD>
<TD noWrap class="td2"  align=center rowspan="2">配分</TD>
<TD noWrap class="td2"  align=center colspan="4">分项签定及核定分数</TD>
<TD noWrap class="td2"  align=center rowspan="2">初评</TD>
<TD noWrap class="td2"  align=center rowspan="2">复评</TD>
<TD noWrap class="td2"  align=center rowspan="2">评审</TD>
<TD noWrap class="td2"  align=center rowspan="2">参数</TD>
<TD noWrap class="td2"  align=center rowspan="2">权数</TD>
</TR>


<TR class="tr1">
<TD noWrap class="td2"  align=center>5</TD>
<TD noWrap class="td2"  align=center >4，3.5</TD>
<TD noWrap class="td2"  align=center >3</TD>
<TD noWrap class="td2"  align=center >2.5 ，2 ，1 ，0</TD>
</TR>


<TR class="tr1">
<TD noWrap class="td2"  align=center rowspan="5">工作</TD>
<TD noWrap class="td2"  align=center >执行力</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >能够彻底并有<br/>创意的执行</TD>
<TD noWrap class="td2"  align=center>能够彻底执行</TD>
<TD noWrap class="td2"  align=center >能够执行</TD>
<TD noWrap class="td2"  align=center >执行力欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id1"><%=firstreview1%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview1%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select1" onchange="getFirstValueC3('1','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >15</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >速度与效率</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >出色带领部属<br/>高效完成工作<br/>并能激发部属活力</TD>
<TD noWrap class="td2"  align=center >出色带领部属<br/>完成工作</TD>
<TD noWrap class="td2"  align=center >带领部属保质<br/>保量完成工作</TD>
<TD noWrap class="td2"  align=center >速度与效率欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id2"><%=firstreview2%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview2%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select2" onchange="getFirstValueC3('2','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >15</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >主动沟通</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >善于沟通<br/>合作双赢</TD>
<TD noWrap class="td2"  align=center>沟通意识强<br/>效果佳</TD>
<TD noWrap class="td2"  align=center >善于沟通<br/>并解决问题</TD>
<TD noWrap class="td2"  align=center >主动沟通能力欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id3"><%=firstreview3%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview3%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select3" onchange="getFirstValueC3('3','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >15</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >学习创新能力</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >刻苦学习专业知识能<br/>不断创新为公司所用</TD>
<TD noWrap class="td2"  align=center >积极学习<br/>创新偶为公司所用</TD>
<TD noWrap class="td2"  align=center>积极学习<br/>不断创新</TD>
<TD noWrap class="td2"  align=center >学习创新意识欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id4"><%=firstreview4%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview4%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select4" onchange="getFirstValueC3('4','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >15</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >发现问题<br/>解决问题能力</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >善于发现<br/>及时解决</TD>
<TD noWrap class="td2"  align=center>善于发现、<br/>解决</TD>
<TD noWrap class="td2"  align=center >能发现、<br/>解决</TD>
<TD noWrap class="td2"  align=center >发现、解决问题<br/>的能力欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id5"><%=firstreview5%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview5%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select5" onchange="getFirstValueC3('5','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >15</TD>
</TR>


<TR class="tr1">
<TD noWrap class="td2"  align=center rowspan="5">素质</TD>
<TD noWrap class="td2"  align=center >诚信</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >为人诚实<br/>正直守信</TD>
<TD noWrap class="td2"  align=center>遵守承诺<br/>言行一致</TD>
<TD noWrap class="td2"  align=center >为人诚实<br/>信用佳</TD>
<TD noWrap class="td2"  align=center >诚实信用度低</TD>
<TD noWrap class="td2"  align=center >
<span id="id6"><%=firstreview6%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview6%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select6" onchange="getFirstValueC3('6','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >5</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >敬业精神</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >敬业爱岗<br/>锐意进取</TD>
<TD noWrap class="td2"  align=center >敬业爱岗<br/>诚恳服务</TD>
<TD noWrap class="td2"  align=center >尽忠职守<br/>守规守时</TD>
<TD noWrap class="td2"  align=center >岗位工作要在监督<br/>下方可完成</TD>
<TD noWrap class="td2"  align=center >
<span id="id7"><%=firstreview7%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview7%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select7" onchange="getFirstValueC3('7','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >考勤</TD>
<TD noWrap class="td2"  align=center >5</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >责任心</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >工作认真积极<br/>敢于承担责任</TD>
<TD noWrap class="td2"  align=center>工作积极<br/>责任心强</TD>
<TD noWrap class="td2"  align=center >工作积极<br/>认真负责</TD>
<TD noWrap class="td2"  align=center >责任心欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id8"><%=firstreview8%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview8%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select8" onchange="getFirstValueC3('8','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >5</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >遵章守纪</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >严守制度<br/>纪律严明</TD>
<TD noWrap class="td2"  align=center >遵守制度<br/>纪律性强</TD>
<TD noWrap class="td2"  align=center >遵守规章制度</TD>
<TD noWrap class="td2"  align=center >无视制度<br/>纪律性差</TD>
<TD noWrap class="td2"  align=center >
<span id="id9"><%=firstreview9%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview9%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select9" onchange="getFirstValueC3('9','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >5</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center >服从</TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >服从指令<br/>听从指挥</TD>
<TD noWrap class="td2"  align=center >服从性佳<br/>中规中矩</TD>
<TD noWrap class="td2"  align=center >服从性一般</TD>
<TD noWrap class="td2"  align=center >服从性欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id10"><%=firstreview10%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview10%></span>
</TD>
<TD noWrap class="td2"  align=center >
<select id="select10" onchange="getFirstValueC3('10','totalreview')" >
<option value="0">--请选择--</option>
<option value="1">0</option>
<option value="2">1</option>
<option value="3">2</option>
<option value="4">2.5</option>
<option value="5">3</option>
<option value="6">3.5</option>
<option value="7">4</option>
<option value="8">5</option>
</select>
</TD>
<TD noWrap class="td2"  align=center >奖惩</TD>
<TD noWrap class="td2"  align=center >5</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=center colspan="7">考核总分</TD>
<TD noWrap class="td2"  align=center ><%=totalfirst%></TD>
<TD noWrap class="td2"  align=center ><%=totalagain%></TD>
<TD noWrap class="td2"  align=center ><span id="totalreview"></span></TD>
<TD noWrap class="td2"  align=center></TD>
<TD noWrap class="td2"  align=center></TD>
</TR>

<TR height=25 class="title">
<TD noWrap class="td1" align=left  colspan="12">2.奖惩特别事迹</TD>
</TR>

<%
if(!FirstEval.equals(""))//被考核人填写了评语及记事
{%>
	<TR class="tr1">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(被考核人)：<span><%=FirstEval%></span></TD>
    </TR>
<%}
else//被考核人未填写评语及记事
{%>
	<TR class="tr1" style="display:none">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(被考核人)：<span><%=FirstEval%></span></TD>
    </TR>
<%}
%>

<TR class="tr1">
<TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(上级主管)：<input type="text" id="text1" style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text1')"></TD>
</TR>

<%
if(!examineperson.equals(""))//有审批人
{
	if(!ExamEval.equals(""))//审批人填写了评语及记事
	{%>
		<TR class="tr1">
        <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(审批人员)：<span><%=ExamEval%></span></TD>
        </TR>
		<%if(Factorydiff.equals("常熟厂") && Integer.parseInt(Rank)<=18 && Totalreview.equals("3"))//常熟厂、职级<=18、分数=3
		{%>
			<TR class="tr1">
            <TD noWrap class="td2" align=left colspan="12">主管审定：<input type="text2" id=""style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text2')"></TD>
            </TR>
		<%}
		else
		{%>
			<TR class="tr1" style="display:none">
            <TD noWrap class="td2" align=left colspan="12">主管审定：<input type="text2" id=""style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text2')"></TD>
            </TR>
		<%}
	}
	else//审批人未填写评语及记事
	{%>
		<TR class="tr1" style="display:none">
        <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(审批人员)：<span><%=ExamEval%></span></TD>
        </TR>
		<%if(Factorydiff.equals("常熟厂") && Integer.parseInt(Rank)<=18 && Totalreview.equals("3"))//常熟厂、职级<=18、分数=3
		{%>
			<TR class="tr1">
            <TD noWrap class="td2" align=left colspan="12">主管审定：<input type="text2" id=""style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text2')"></TD>
            </TR>
		<%}
		else
		{%>
			<TR class="tr1" style="display:none">
            <TD noWrap class="td2" align=left colspan="12">主管审定：<input type="text2" id=""style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text2')"></TD>
            </TR>
		<%}
	}
}
else//无审批人
{
	if(Factorydiff.equals("常熟厂") && Integer.parseInt(Rank)<=18 && Totalreview.equals("3"))//常熟厂、职级<=18、分数=3
	{%>
		<TR class="tr1">
        <TD noWrap class="td2" align=left colspan="12">主管审定：<input type="text2" id=""style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text2')"></TD>
        </TR>
	<%}
	else
	{%>
		<TR class="tr1" style="display:none">
        <TD noWrap class="td2" align=left colspan="12">主管审定：<input type="text2" id=""style="width:100%;height:20px;text-align:left" onchange="CommentRemember('text2')"></TD>
        </TR>
	<%}
}
%>

</TABLE>
</DIV>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   