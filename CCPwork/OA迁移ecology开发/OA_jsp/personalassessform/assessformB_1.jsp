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
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String employno=StringHelper.null2String(request.getParameter("employno"));
String planname=StringHelper.null2String(request.getParameter("planname"));
String assessyear=StringHelper.null2String(request.getParameter("assessyear"));//考核年度
String startreday=StringHelper.null2String(request.getParameter("startreday"));//奖惩开始日期
String endreday=StringHelper.null2String(request.getParameter("endreday"));//奖惩结束日期
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>


<%
//初始化的时候初评分数先置为3
String selsql="select * from uf_hr_checkperformance where requestid='"+requestid+"'";
List sellist = baseJdbc.executeSqlForList(selsql);
if(sellist.size()>0)
{
	 Map selmk = (Map)sellist.get(0);
	 String initscore1=StringHelper.null2String(selmk.get("firstreview1"));
	 String initscore2=StringHelper.null2String(selmk.get("firstreview2"));
	 String initscore3=StringHelper.null2String(selmk.get("firstreview3"));
	 String initscore4=StringHelper.null2String(selmk.get("firstreview4"));
	 String initscore5=StringHelper.null2String(selmk.get("firstreview5"));
	 String initscore6=StringHelper.null2String(selmk.get("firstreview6"));
	 String initscore7=StringHelper.null2String(selmk.get("firstreview7"));
	 String initscore8=StringHelper.null2String(selmk.get("firstreview8"));
	 String initscore9=StringHelper.null2String(selmk.get("firstreview9"));
	 String initscore10=StringHelper.null2String(selmk.get("firstreview10"));
	 String initscore11=StringHelper.null2String(selmk.get("totalfirst"));
	 String initscore12=StringHelper.null2String(selmk.get("firstreview11"));

	 if(initscore1.equals("")||initscore2.equals("")||initscore3.equals("")||initscore4.equals("")||initscore5.equals("")||initscore6.equals("")||initscore7.equals("")||initscore8.equals("")||initscore9.equals("")||initscore10.equals("")||initscore11.equals("")||initscore12.equals(""))
	 {
		String scoresql="update uf_hr_checkperformance set firstreview1=3,firstreview2=3,firstreview3=3,firstreview4=3,firstreview5=3,firstreview6=3,firstreview7=3,firstreview8=3,firstreview9=3,firstreview10=3,totalfirst=3,firstreview11=3 where requestid='"+requestid+"'";
		baseJdbc.update(scoresql);//执行SQL
	 }
}


String sqll="select  v.jobno,sum(usedquo) as SumUsedquo from (select c.jobno,-b.usedquo as usedquo from v_hr_monthreward c left join uf_hr_punrewquocor b on c.rewtype= b.rewtype left join formbase d on d.id=b.requestid where c.jobno=(select id from humres where objno='"+employno+"') and d.isdelete=0 and b.comtype=(select extrefobjfield5 from humres where objno='"+employno+"')and c.tomonth>='"+startreday+"' and c.tomonth<='"+endreday+"') v group by v.jobno";

String RewPunScore="0";//初始化奖惩相抵分数
List sublistl = baseJdbc.executeSqlForList(sqll);
if(sublistl.size()>0)
{
   Map mkl = (Map)sublistl.get(0);
   RewPunScore=StringHelper.null2String(mkl.get("SumUsedquo"));
   if(RewPunScore.equals(""))
   {
	   RewPunScore="0";
   }
}

//将所得的奖惩分数插入员工绩效考核表中对应的字段，以方便后续计算
String sqll2="update uf_hr_checkperformance set Rewardbalance='"+RewPunScore+"' where employno='"+employno+"' and checkyear='"+assessyear+"'";
baseJdbc.update(sqll2);
%>


<%
String sql="select checkscore from uf_hr_checkimplechild where employnum='"+employno+"' and planname='"+planname+"'";
List sublist = baseJdbc.executeSqlForList(sql);
String checkscore="0";//考勤分数
if(sublist.size()>0)
{
	Map mk = (Map)sublist.get(0);
	checkscore=StringHelper.null2String(mk.get("checkscore"));
}
System.out.println("执行personalformB_1---------------------------------------------员工工号："+employno);
String rewardbalance=RewPunScore;//奖惩相抵分数
System.out.println("personalformB_1从数据库取出来的奖惩分数"+rewardbalance);
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
System.out.println("personalformB_1根据奖惩规则取得最终奖惩考分："+rpScore);
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
System.out.println("personalformB_1最终系统评分："+SumScore);

//将系统等评分更新至数据库uf_hr_checkperformance表
String systemsql="update uf_hr_checkperformance set attendscore='"+checkscore+"',repunscore='"+rpScore+"',systemscore='"+SumScore+"' where employno='"+employno+"' and checkyear='"+assessyear+"'";
baseJdbc.update(systemsql);


//查询员工绩效考核中的初评总分在复评中给予显示
sql="select * from uf_hr_checkperformance where requestid='"+requestid+"'";
sublist = baseJdbc.executeSqlForList(sql);
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
String totalfirst="0";
String totalreview="";
String firstreview11="";

String selected1="";
String selected2="";
String selected3="";
String selected4="";
String selected5="";
String selected6="";
String selected7="";
String selected8="";
String selected9="";
String selected10="";
String selected11="";
String selected12="";
String FirstEval="";//初评主管评语及记事
String ExamEval="";//审批人评语及记事
String SafeLevel="";//安全级别
String IsorNo="";//部门主管和分管领导是否为同一人
String WilldoIsorNo="";//是否会办
String Factorydiff="";//厂区别
String Rank="";//职级
//String Totalfirst="";//初评总分
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

		 ExamEval=StringHelper.null2String(mk.get("ExamEval"));//审批人评语及记事
		 FirstEval=StringHelper.null2String(mk.get("FirstEval"));//初评主管评语及记事
		 SafeLevel=StringHelper.null2String(mk.get("SafeLevel"));//安全级别
		 IsorNo=StringHelper.null2String(mk.get("IsorNo"));//部门主管和分管领导是否为同一人
		 WilldoIsorNo=StringHelper.null2String(mk.get("WilldoIsorNo"));//是否会办
		 Factorydiff=StringHelper.null2String(mk.get("Factorydiff"));//厂区别
		 Rank=StringHelper.null2String(mk.get("Rank"));//职级
		 //Totalfirst=StringHelper.null2String(mk.get("Totalfirst"));//初评总分
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
<TD noWrap class="td2" align=center colspan="4"><span><%=checkscore%></span></TD>
<TD noWrap class="td2" align=center colspan="4"><span><%=rpScore%></span></TD>
<TD noWrap class="td2" align=center colspan="4"><span><%=SumScore%></span></TD>
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
<COL width="5%" style="display:none">
<COL width="5%" style="display:none">
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
<TD  noWrap class="td2"  align=center>
      <%
		 if(firstreview1.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview1.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview1.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview1.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview1.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview1.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview1.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview1.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview1.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview1.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview1.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select1" onchange="getFirstValueB1('1')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview2.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview2.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview2.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview2.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview2.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview2.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview2.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview2.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview2.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview2.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview2.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select2" onchange="getFirstValueB1('2')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
	     selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview3.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview3.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview3.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview3.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview3.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview3.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview3.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview3.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview3.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview3.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview3.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select3" onchange="getFirstValueB1('3')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview4.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview4.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview4.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview4.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview4.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview4.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview4.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview4.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview4.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview4.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview4.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select4" onchange="getFirstValueB1('4')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview5.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview5.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview5.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview5.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview5.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview5.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview5.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview5.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview5.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview5.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview5.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select5" onchange="getFirstValueB1('5')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>

<TR>
<TD  noWrap class="td2"  align=center rowspan="5">素质</TD>
<TD  noWrap class="td2"  align=center>诚信</TD>
<TD  noWrap class="td2"  align=center>5</TD>
<TD  noWrap class="td2"  align=center>为人诚实<br/>正直守信</TD>
<TD  noWrap class="td2"  align=center>遵守承诺<br/>言行一致</TD>
<TD  noWrap class="td2"  align=center>为人诚实<br/>信用佳</TD>
<TD  noWrap class="td2"  align=center>诚实信用度低</TD>
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview6.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview6.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview6.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview6.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview6.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview6.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview6.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview6.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview6.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview6.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview6.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select6" onchange="getFirstValueB1('6')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview7.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview7.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview7.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview7.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview7.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview7.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview7.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview7.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview7.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview7.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview7.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select7" onchange="getFirstValueB1('7')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview8.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview8.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview8.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview8.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview8.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview8.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview8.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview8.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview8.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview8.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview8.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select8" onchange="getFirstValueB1('8')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview9.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview9.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview9.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview9.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview9.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview9.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview9.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview9.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview9.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview9.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview9.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select9" onchange="getFirstValueB1('9')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview10.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview10.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview10.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview10.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview10.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview10.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview10.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview10.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview10.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview10.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview10.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select10" onchange="getFirstValueB1('10')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
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
<TD  noWrap class="td2"  align=center>
      <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(firstreview11.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(firstreview11.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(firstreview11.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(firstreview11.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(firstreview11.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(firstreview11.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(firstreview11.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(firstreview11.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(firstreview11.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(firstreview11.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(firstreview11.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select12" onchange="getFirstValueB1('11')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>
<select disabled>
<option value="0">--请选择--</option>
</select>
</TD>
<TD  noWrap class="td2"  align=center>奖惩</TD>
<TD  noWrap class="td2"  align=center>5</TD>
</TR>







<TR>
<TD  noWrap class="td2"  align=center colspan="7">考核总分</TD>
<TD  noWrap class="td2"  align=center>
     <%
		 selected1="";
		 selected2="";
		 selected3="";
		 selected4="";
		 selected5="";
		 selected6="";
		 selected7="";
		 selected8="";
		 selected9="";
		 selected10="";
		 selected11="";
		 selected12="";
		 if(totalfirst.equals("0"))
		 {
			 selected1="selected";
		 }
		 /*else if(totalfirst.equals("0.5"))
		 {
			 selected2="selected";
		 }*/
		 else if(totalfirst.equals("1"))
		 {
			 selected3="selected";
		 }
		 /*else if(totalfirst.equals("1.5"))
		 {
			 selected4="selected";
		 }*/
		 else if(totalfirst.equals("2"))
		 {
			 selected5="selected";
		 }
		 else if(totalfirst.equals("2.5"))
		 {
			 selected6="selected";
		 }
		 else if(totalfirst.equals("3"))
		 {
			 selected7="selected";
		 }
		 else if(totalfirst.equals("3.5"))
		 {
			 selected8="selected";
		 }
		 else if(totalfirst.equals("4"))
		 {
			 selected9="selected";
		 }
		 /*else if(totalfirst.equals("4.5"))
		 {
			 selected10="selected";
		 }*/
		 else if(totalfirst.equals("5"))
		 {
			 selected11="selected";
		 }
         else
		 {
			 selected12="selected";
		 }
	 %>
	 <select id="select11" onchange="getTotalFirstB1('11')" >
		<option value="0" <%=selected12%>>--请选择--</option>
		<option value="1" <%=selected1%>>0</option>
		<!-- <option value="2" <%=selected2%>>0.5</option> -->
		<option value="3" <%=selected3%>>1</option>
		<!-- <option value="4" <%=selected4%>>1.5</option> -->
		<option value="5" <%=selected5%>>2</option>
		<option value="6" <%=selected6%>>2.5</option>
		<option value="7" <%=selected7%>>3</option>
		<option value="8" <%=selected8%>>3.5</option>
		<option value="9" <%=selected9%>>4</option>
		<!-- <option value="10" <%=selected10%>>4.5</option> -->
		<option value="11" <%=selected11%>>5</option>
	</select>
</TD>
<TD  noWrap class="td2"  align=center></TD>
<TD  noWrap class="td2"  align=center></TD>
<TD  noWrap class="td2"  align=center></TD>
<TD  noWrap class="td2"  align=center></TD>
</TR>

<TR height=25  class="title">
<TD noWrap class="td1" align=left colspan="12">2.奖惩特别事迹</TD>
</TR>

<%
if(ExamEval.equals(""))
{%>
	<TR class="tr1" style="display:none">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(审批人员)：<span><%=ExamEval%></span></TD>
    </TR>
<%}
else
{%>
	<TR class="tr1">
    <TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(审批人员)：<span><%=ExamEval%></span></TD>
    </TR>
<%}
%>

<TR class="tr1">
<TD noWrap class="td2" align=left colspan="12">评语及记事、奖惩考评(初评主管)：<input type="text" id="text1" style="width:70%;height:20px;text-align:left" onchange="CommentRemember('text1')" value="<%=FirstEval%>"><span id="text1span"><img src=/images/base/checkinput.gif align=absMiddle></span></TD>
</TR>
</table>
</div>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             