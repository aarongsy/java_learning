<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.app.configsap.SapConnector"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>

<%
String EmployName = StringHelper.null2String(request.getParameter("employname"));//员工姓名
String EmployNo=StringHelper.null2String(request.getParameter("employno"));//员工工号
String AssessYear=StringHelper.null2String(request.getParameter("assessyear"));//当前考核年度
String Sdate=StringHelper.null2String(request.getParameter("sdate"));//奖惩开始日期
String Edate=StringHelper.null2String(request.getParameter("edate"));//奖惩结束日期
String Factype=StringHelper.null2String(request.getParameter("factype"));//厂区别
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>

<%
String sql="";
if(Factype.equals("4028804d2083a7ed012083ebb988005b")||Factype.equals("40285a90488ba9d101488bbdeeb30008"))//常熟或长沙
{
	 sql="select * from v_hr_ccjs_monthrewardsub where jobname='"+EmployName+"'";
}
else if(Factype.equals("40285a90488ba9d101488bbd09100007"))//盘锦
{
	 sql="select * from v_hr_ccpj_monthrewardsub where jobname='"+EmployName+"'";

}


//String objname="";//奖惩类型
int nums1=0;//大功次数
int nums2=0;//小功次数
int nums3=0;//嘉奖次数
int nums4=0;//大过次数
int nums5=0;//小过次数
int nums6=0;//申诫次数
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		String objname=StringHelper.null2String(mk.get("objname"));//奖惩类型
		String objnum=StringHelper.null2String(mk.get("nums"));//次数
		if(objname.indexOf("大功")!=-1)
		{
			if(objnum!=""&&objnum!=" "&&objnum!=null)
			{
				nums1=nums1+Integer.parseInt(objnum);
			}
			else
			{
				nums1=0;
			}
		}
		if(objname.indexOf("小功")!=-1)
		{
			if(objnum!=""&&objnum!=" "&&objnum!=null)
			{
				nums2=nums2+Integer.parseInt(objnum);
			}
			else
			{
			    nums2=0;
			}
		}
		if(objname.indexOf("嘉奖")!=-1)
		{
			if(objnum!=""&&objnum!=" "&&objnum!=null)
			{
				nums3=nums3+Integer.parseInt(objnum);
			}
			else
			{
				nums3=0;
			}
		}
		if(objname.indexOf("大过")!=-1)
		{
			if(objnum!=""&&objnum!=" "&&objnum!=null)
			{
				nums4=nums4+Integer.parseInt(objnum);
			}
			else
			{
				nums4=0;
			}
		}
		if(objname.indexOf("小过")!=-1)
		{
			if(objnum!=""&&objnum!=" "&&objnum!=null)
			{
				nums5=nums5+Integer.parseInt(objnum);
			}
			else
			{
				nums5=0;
			}
		}
		if(objname.indexOf("申诫")!=-1)
		{
			if(objnum!=""&&objnum!=" "&&objnum!=null)
			{
				nums6=nums6+Integer.parseInt(objnum);
			}
			else
			{
				nums6=0;
			}
		}
	}
}
//System.out.println(nums1);
//System.out.println(nums2);
//System.out.println(nums3);
//System.out.println(nums1);
//System.out.println(nums1);
//System.out.println(nums1);
%>

<%
String sql1="select  v.jobno,sum(usedquo) as SumUsedquo from (select c.jobno,-b.usedquo as usedquo from v_hr_monthreward c left join uf_hr_punrewquocor b on c.rewtype= b.rewtype left join formbase d on d.id=b.requestid where c.jobno=(select id from humres where objno='"+EmployNo+"') and d.isdelete=0 and b.comtype=(select extrefobjfield5 from humres where objno='"+EmployNo+"')and c.tomonth>='"+Sdate+"' and c.tomonth<='"+Edate+"') v group by v.jobno";

String RewPunScore="0";//初始化奖惩相抵分数
List sublist1 = baseJdbc.executeSqlForList(sql1);
if(sublist1.size()>0)
{
   Map mk1 = (Map)sublist1.get(0);
   RewPunScore=StringHelper.null2String(mk1.get("SumUsedquo"));
}
System.out.println("即将插入数据库的奖惩分数："+RewPunScore);
System.out.println("执行rewardpunish---------------------------------------------A");
//将奖惩信息更新至数据库uf_hr_checkperformance表，以方便后续计算
String sql2="update uf_hr_checkperformance set largepower="+nums1+",smallpower="+nums2+",awardtimes="+nums3+",largefault="+nums4+",smallfault="+nums5+",admontimes="+nums6+",Rewardbalance='"+RewPunScore+"' where employno='"+EmployNo+"' and checkyear='"+AssessYear+"'";
baseJdbc.update(sql2);
System.out.println("执行rewardpunish---------------------------------------------B");
//System.out.println("更新奖惩："+sql2);

//将奖惩信息更新至数据库


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

<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="14%">
<COL width="14%">
<COL width="14%">
<COL width="14%">
<COL width="14%">
<COL width="14%">
<COL width="14%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>大功次数</TD>
<TD  noWrap class="td2"  align=center>小功次数</TD>
<TD  noWrap class="td2"  align=center>嘉奖次数</TD>
<TD  noWrap class="td2"  align=center>大过次数</TD>
<TD  noWrap class="td2"  align=center>小过次数</TD>
<TD  noWrap class="td2"  align=center>申诫次数</TD>
<TD  noWrap class="td2"  align=center>奖惩相抵</TD>
</TR>

<TR>
<TD  class="td2"  align=center><%=nums1%></TD>
<TD  class="td2"  align=center><%=nums2%></TD>
<TD  class="td2"  align=center><%=nums3%></TD>
<TD  class="td2"  align=center><%=nums4%></TD>
<TD  class="td2"  align=center><%=nums5%></TD>
<TD  class="td2"  align=center><%=nums6%></TD>
<TD  class="td2"  align=center><%=RewPunScore%></TD>
</tr>
</table>
</div>
