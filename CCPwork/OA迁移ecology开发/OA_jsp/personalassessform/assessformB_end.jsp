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
String sql1="select checkscore from uf_hr_checkimplechild where employnum='"+employno+"' and planname='"+planname+"'";
List sublist1 = baseJdbc.executeSqlForList(sql1);
String checkscore="0";//考勤分数
if(sublist1.size()>0)
{
	Map mk1 = (Map)sublist1.get(0);
	checkscore=StringHelper.null2String(mk1.get("checkscore"));
}
System.out.println("执行personalformB_end---------------------------------------------员工工号："+employno);
String sql2="select rewardbalance from uf_hr_checkperformance where employno='"+employno+"' and checkyear='"+assessyear+"'";
List sublist2=baseJdbc.executeSqlForList(sql2);
String rewardbalance="0";//奖惩相抵分数
if(sublist2.size()>0)
{
	Map mk2=(Map)sublist2.get(0);
	rewardbalance=StringHelper.null2String(mk2.get("rewardbalance"));
}
System.out.println("personalformB_end从数据库取出来的奖惩分数"+rewardbalance);
String rpScore="3";//初始化根据奖惩规则强制后的分数
//记小过1次：2.5分
if(Float.parseFloat(rewardbalance)>=-5 && Float.parseFloat(rewardbalance)<=-3)
{
	rpScore="2.5";
}
//记小过2次：2分
else if(Float.parseFloat(rewardbalance)>=-8 && Float.parseFloat(rewardbalance)<=-6)
{
	rpScore="2";
}
//记大过1次：1分
else if(Float.parseFloat(rewardbalance)>=-17 && Float.parseFloat(rewardbalance)<=-9)
{
	rpScore="1";
}
//记大过2次：0分
else if(Float.parseFloat(rewardbalance)>=-9999 && Float.parseFloat(rewardbalance)<=-18)
{
	rpScore="0";
}
System.out.println("personalformB_end根据奖惩规则取得最终奖惩考分："+rpScore);

//"考勤分"和"奖惩分"综合判断的依据(取其较小值作为系统评分)
String SumScore="3";//初始化系统评分
if(Float.parseFloat(checkscore)<=Float.parseFloat(rpScore))
{
	SumScore=checkscore;
}
else
{
	SumScore=rpScore;
}
System.out.println("personalformB_end最终系统评分："+SumScore);
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
String firstreview11="";

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
String againreview11="";

String review1="";
String review2="";
String review3="";
String review4="";
String review5="";
String review6="";
String review7="";
String review8="";
String review9="";
String review10="";
String totalreview="";
String review11="";

String FirstEval="";//被考核人评语及记事
String ReviewEval="";//上级主管评语及记事
String ExamEval="";//审批人评语及记事
String AgainEval="";//复评领导评语及记事
String LastEval="";//主管审定
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
		 firstreview11=StringHelper.null2String(mk.get("firstreview11"));

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
		 againreview11=StringHelper.null2String(mk.get("againreview11"));

		 review1=StringHelper.null2String(mk.get("review1"));
		 review2=StringHelper.null2String(mk.get("review2"));
		 review3=StringHelper.null2String(mk.get("review3"));
		 review4=StringHelper.null2String(mk.get("review4"));
		 review5=StringHelper.null2String(mk.get("review5"));
		 review6=StringHelper.null2String(mk.get("review6"));
		 review7=StringHelper.null2String(mk.get("review7"));
		 review8=StringHelper.null2String(mk.get("review8"));
		 review9=StringHelper.null2String(mk.get("review9"));
		 review10=StringHelper.null2String(mk.get("review10"));
		 totalreview=StringHelper.null2String(mk.get("totalreview"));
		 review11=StringHelper.null2String(mk.get("review11"));

		 FirstEval=StringHelper.null2String(mk.get("FirstEval"));
		 ReviewEval=StringHelper.null2String(mk.get("ReviewEval"));
		 ExamEval=StringHelper.null2String(mk.get("ExamEval"));
		 AgainEval=StringHelper.null2String(mk.get("AgainEval"));
		 LastEval=StringHelper.null2String(mk.get("LastEval"));
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
<script type='text/javascript' language="javascript">
</script>


<div id="warpp" >
<table id="" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<TR noWrap class="tr1">
<TD noWrap class="td2" align=center colspan="4">考核项目</TD>
<TD noWrap class="td2" align=center colspan="4">评核依据</TD>
<TD noWrap class="td2" align=center colspan="4">考勤分数</TD>
<TD noWrap class="td2" align=center colspan="4">奖惩分数</TD>
<TD noWrap class="td2" align=center colspan="4">系统评分</TD>
</TR>
<TR noWrap class="tr1">
<TD noWrap class="td2" align=center colspan="4">敬业精神</TD>
<TD noWrap class="td2" align=center colspan="4">考勤</TD>
<TD noWrap class="td2" align=center colspan="4"><%=checkscore%></TD>
<TD noWrap class="td2" align=center colspan="4"><%=rpScore%></TD>
<TD noWrap class="td2" align=center colspan="4"><%=SumScore%></TD>
</TR>
</table>

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="3%">
<COL width="9%">
<COL width="5%" style="display:none">
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

<%
//评审一栏
if(review2.equals(""))
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
<COL width="5%" style="display:none">
<COL width="3%" style="display:none">
</COLGROUP>

<TR height="25"  class="title">
<TD noWrap class="td1" align=left colspan="12">1.一般考绩</TD>
</TR>
<TR>
<TD  noWrap class="td2"  align=center rowspan="2">区分</TD>
<TD  noWrap class="td2"  align=center rowspan="2">考核项目</TD>
<TD  noWrap class="td2"  align=center rowspan="2">权数</TD>
<TD  noWrap class="td2"  align=center  colspan="4">分项签订及核定分数</TD>
<TD  noWrap class="td2"  align=center rowspan="2">初评</TD>
<TD  noWrap class="td2"  align=center rowspan="2">复评</TD>
<TD  noWrap class="td2"  align=center rowspan="2">评审</TD>
<TD  noWrap class="td2"  align=center rowspan="2">参数</TD>
<TD  noWrap class="td2"  align=center rowspan="2">配分</TD>
</TR>

<TR >
<TD  noWrap class="td2"  align=center>5</TD>
<TD  noWrap class="td2"  align=center>4, 3.5</TD>
<TD  noWrap class="td2"  align=center>3</TD>
<TD  noWrap class="td2"  align=center>2.5, 2, 1, 0</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center rowspan="5">工作</TD>
<TD  noWrap class="td2"  align=center>专业知识</TD>
<TD  noWrap class="td2"  align=center>15</TD>
<TD  noWrap class="td2"  align=center>具有丰富的专业知识<br/>圆满完成工作任务</TD>
<TD  noWrap class="td2"  align=center>具有相当的专业知识<br/>顺利完成工作</TD>
<TD  noWrap class="td2"  align=center>具有一定的专业知识<br/>符合职责需要</TD>
<TD  noWrap class="td2"  align=center>专业知识不足<br/>影响工作开展</TD>
<TD noWrap class="td2"  align=center >
<span id="id1"><%=firstreview1%></span>
</TD>
<TD noWrap class="td2"  align=center>
<span><%=againreview1%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review1%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>速度与效率</TD>
<TD  noWrap class="td2"  align=center>15</TD>
<TD  noWrap class="td2"  align=center>出色高效完成工作<br/>并有效指导他人工作</TD>
<TD  noWrap class="td2"  align=center>出色高效完成工作</TD>
<TD  noWrap class="td2"  align=center>保质保量完成工作</TD>
<TD  noWrap class="td2"  align=center>速度与效率欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id2"><%=firstreview2%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview2%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review2%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>总结归纳能力</TD>
<TD  noWrap class="td2"  align=center>15</TD>
<TD  noWrap class="td2"  align=center>善于总结归纳并能据此<br/>提出合理的改进建议</TD>
<TD  noWrap class="td2"  align=center>善于总结归纳</TD>
<TD  noWrap class="td2"  align=center>具备总结归纳能力</TD>
<TD  noWrap class="td2"  align=center>总结归纳时<br/>总是强调理由</TD>
<TD noWrap class="td2"  align=center >
<span id="id3"><%=firstreview3%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview3%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review3%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>学习创新能力</TD>
<TD  noWrap class="td2"  align=center>15</TD>
<TD  noWrap class="td2"  align=center>刻苦学习专业知识<br/>能不断创新为公司所用</TD>
<TD  noWrap class="td2"  align=center>积极学习<br/>创新偶为公司所用</TD>
<TD  noWrap class="td2"  align=center>积极学习<br/>不断创新</TD>
<TD  noWrap class="td2"  align=center>学习创新<br/>意识欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id4"><%=firstreview4%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview4%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review4%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>发现问题解<br/>决问题能力</TD>
<TD  noWrap class="td2"  align=center>15</TD>
<TD  noWrap class="td2"  align=center>善于发现<br/>及时解决</TD>
<TD  noWrap class="td2"  align=center>善于发现<br/>并能解决</TD>
<TD  noWrap class="td2"  align=center>能发现、<br/>解决问题</TD>
<TD  noWrap class="td2"  align=center>发现、解决问题<br/>的能力欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id5"><%=firstreview5%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview5%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review5%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center rowspan="5">素质</TD>
<TD  noWrap class="td2"  align=center>诚信</TD>
<TD  noWrap class="td2"  align=center>15</TD>
<TD  noWrap class="td2"  align=center>为人诚实<br/>正直守信</TD>
<TD  noWrap class="td2"  align=center>遵守承诺<br/>言行一致</TD>
<TD  noWrap class="td2"  align=center>为人诚实<br/>信用佳</TD>
<TD  noWrap class="td2"  align=center>诚实信用度低</TD>
<TD noWrap class="td2"  align=center >
<span id="id6"><%=firstreview6%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview6%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review6%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>敬业精神</TD>
<TD  noWrap class="td2"  align=center>5</TD>
<TD  noWrap class="td2"  align=center>敬业爱岗<br/>锐意进取</TD>
<TD  noWrap class="td2"  align=center>敬业爱岗<br/>诚恳服务</TD>
<TD  noWrap class="td2"  align=center>尽忠职守<br/>守规守时</TD>
<TD  noWrap class="td2"  align=center>岗位工作要在<br/>监督下方可完成</TD>
<TD noWrap class="td2"  align=center >
<span id="id7"><%=firstreview7%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview7%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review7%></span>
</TD>
<TD  noWrap class="td2"  align=center>考勤</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>责任心</TD>
<TD  noWrap class="td2"  align=center>5</TD>
<TD  noWrap class="td2"  align=center>工作认真积极<br/>敢于承担责任</TD>
<TD  noWrap class="td2"  align=center>工作积极<br/>责任心强</TD>
<TD  noWrap class="td2"  align=center>工作积极<br/>认真负责</TD>
<TD  noWrap class="td2"  align=center>责任心欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id8"><%=firstreview8%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview8%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review8%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>遵章守纪</TD>
<TD  noWrap class="td2"  align=center>5</TD>
<TD  noWrap class="td2"  align=center>严守制度<br/>纪律严明</TD>
<TD  noWrap class="td2"  align=center>遵守制度<br/>纪律性强</TD>
<TD  noWrap class="td2"  align=center>遵守规章制度</TD>
<TD  noWrap class="td2"  align=center>无视制度<br/>纪律性差</TD>
<TD noWrap class="td2"  align=center >
<span id="id9"><%=firstreview9%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview9%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review9%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center>服从</TD>
<TD  noWrap class="td2"  align=center>5</TD>
<TD  noWrap class="td2"  align=center>服从指令<br/>听从指挥</TD>
<TD  noWrap class="td2"  align=center>服从性佳<br/>中规中矩</TD>
<TD  noWrap class="td2"  align=center>服从性一般</TD>
<TD  noWrap class="td2"  align=center>服从性欠佳</TD>
<TD noWrap class="td2"  align=center >
<span id="id10"><%=firstreview10%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview10%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review10%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>










<TR>
<TD noWrap class="td2"  align=center >安全生产责任制</TD>
<TD noWrap class="td2"  align=center ><input type=button value="查看" id=btnb onclick="displayB()"></TD>
<TD noWrap class="td2"  align=center >5</TD>
<TD noWrap class="td2"  align=center >落实安全生产责任制彻底<br/>零事故</TD>
<TD noWrap class="td2"  align=center >落实安全生产责任制良好<br/>零事故</TD>
<TD noWrap class="td2"  align=center >落实安全生产责任制一般<br/>零事故</TD>
<TD noWrap class="td2"  align=center >落实安全生产责任制欠佳<br/>发生事故</TD>
<TD noWrap class="td2"  align=center >
<span id="id10"><%=firstreview11%><span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=againreview11%></span>
</TD>
<TD noWrap class="td2"  align=center >
<span><%=review11%></span>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>











<TR>
<TD  noWrap class="td2"  align=center colspan="7">考核总分</TD>
<TD noWrap class="td2"  align=center ><%=totalfirst%></TD>
<TD noWrap class="td2"  align=center ><%=totalagain%></TD>
<TD noWrap class="td2"  align=center ><%=totalreview%></TD>
<TD  noWrap class="td2"  align=center></TD>
<TD  noWrap class="td2"  align=center></TD>
</TR>

<TR height=25  class="title">
<TD noWrap class="td1" align=left colspan="12">2.奖惩特别事迹</TD>
</TR>

<%
if(!FirstEval.equals(""))//初评主管有填写评语及记事
{%>
	<TR class="tr1">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(初评主管)：<span><%=FirstEval%></span></TD>
    </TR>
<%}
else//初评主管未填写评语及记事
{%>
	<TR class="tr1" style="display:none">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(初评主管)：<span><%=FirstEval%></span></TD>
    </TR>
<%}

if(!ExamEval.equals(""))//审批人员有填写评语及记事
{%>
	<TR class="tr1">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(审批人员)：<span><%=ExamEval%></span></TD>
    </TR>
<%}
else//审批人员未填写评语及记事
{%>
	<TR class="tr1" style="display:none">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(审批人员)：<span><%=ExamEval%></span></TD>
    </TR>
<%}

if(!AgainEval.equals(""))//复评领导有填写评语及记事
{%>
	<TR class="tr1">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(复评领导)：<span><%=AgainEval%></span></TD>
    </TR>
<%}
else//复评领导未填写评语及记事
{%>
	<TR class="tr1" style="display:none">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(复评领导)：<span><%=AgainEval%></span></TD>
    </TR>
<%}
%>

</table>
</div>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 