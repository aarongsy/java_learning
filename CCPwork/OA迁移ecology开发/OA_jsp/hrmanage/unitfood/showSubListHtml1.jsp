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

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String nodeshow = StringHelper.null2String(request.getParameter("nodeshow"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");

	String nowday =StringHelper.null2String(request.getParameter("days"));
	String zcshow1=StringHelper.null2String(request.getParameter("zcshow"));
	String wucshow1=StringHelper.null2String(request.getParameter("wucshow"));
	String wancshow1=StringHelper.null2String(request.getParameter("wancshow"));
	String zcshow=StringHelper.null2String(request.getParameter("zcshow"));
	String wucshow=StringHelper.null2String(request.getParameter("wucshow"));
	String wancshow=StringHelper.null2String(request.getParameter("wancshow"));
	String flag=StringHelper.null2String(request.getParameter("flag"));
	String yesterdaystr=StringHelper.null2String(request.getParameter("yesterdaystr"));
	String beforeyesterdaystr=StringHelper.null2String(request.getParameter("beforeyesterdaystr"));
	String comparea=StringHelper.null2String(request.getParameter("comparea"));

	String strhour=StringHelper.null2String(request.getParameter("strhour"));
	String nextdaystr=StringHelper.null2String(request.getParameter("nextdaystr"));
SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
StringBuffer fbuf = new StringBuffer();
String sql = "select breakbook,breaksend,lunchbook,lunchsend,dinnerbook,dinnersend from uf_hr_unitfoot where requestid='"+requestid+"'";
List list = baseJdbc.executeSqlForList(sql);
if(list.size()>0){
	Map m = (Map)list.get(0);
	String breakbook = StringHelper.null2String(m.get("breakbook"));
	String breaksend = StringHelper.null2String(m.get("breaksend"));
	String lunchbook = StringHelper.null2String(m.get("lunchbook"));
	String lunchsend = StringHelper.null2String(m.get("lunchsend"));
	String dinnerbook = StringHelper.null2String(m.get("dinnerbook"));
	String dinnersend = StringHelper.null2String(m.get("dinnersend"));
	fbuf.append("<TR><TD class=\"td2\"  align=center colspan=9>");
	fbuf.append("<TABLE width=\"100%\">");
	fbuf.append("<COLGROUP>");
	fbuf.append("<COL width=\"10%\">");
	fbuf.append("<COL width=\"5%\">");
	fbuf.append("<COL width=\"10%\">");
	fbuf.append("<COL width=\"5%\">");
	fbuf.append("<COL width=\"10%\">");
	fbuf.append("<COL width=\"5%\">");
	fbuf.append("<COL width=\"10%\">");
	fbuf.append("<COL width=\"5%\">");
	fbuf.append("<COL width=\"10%\">");
	fbuf.append("<COL width=\"5%\">");
	fbuf.append("<COL width=\"10%\">");
	fbuf.append("<COL width=\"5%\"></COLGROUP>");
	fbuf.append("<TBODY>");
	fbuf.append("<TR>");
	fbuf.append("<TD align=center>早餐订餐份数</TD>");
	fbuf.append("<TD align=center>"+breakbook+"</TD>");
	fbuf.append("<TD align=center>早餐送餐份数</TD>");
	fbuf.append("<TD align=center>"+breaksend+"</TD>");
	fbuf.append("<TD align=center>午餐订餐份数</TD>");
	fbuf.append("<TD align=center>"+lunchbook+"</TD>");
	fbuf.append("<TD align=center>午餐送餐份数</TD>");
	fbuf.append("<TD align=center>"+lunchsend+"</TD>");
	fbuf.append("<TD align=center>晚餐订餐餐份数</TD>");
	fbuf.append("<TD align=center>"+dinnerbook+"</TD>");
	fbuf.append("<TD align=center>晚餐送餐餐份数</TD>");
	fbuf.append("<TD align=center>"+dinnersend+"</TD>");
	fbuf.append("</TR>");
	fbuf.append("</TBODY>");
	fbuf.append("</TABLE>");
	fbuf.append("</TD></TR>");
}
StringBuffer buf = new StringBuffer();
//sql = "select a.id,a.reqdept oid,b.objname oname,a.jobno,a.objname hid,c.objname hname,a.thedate,a.breakfast,a.lunch,a.dinner from uf_hr_unitfootsub a left join orgunit b on a.reqdept=b.id left join humres c on a.objname=c.id where a.requestid='"+requestid+"' and a.thedate is not null order by a.jobno asc,a.thedate";
sql = "select a.id,a.reqdept oid,b.objname oname,a.jobno,a.objname hid,c.objname hname,a.thedate,a.breakfast,a.lunch,a.dinner from uf_hr_unitfootsub a left join orgunit b on a.reqdept=b.id left join humres c on a.objname=c.id where a.requestid='"+requestid+"' and a.thedate is not null order by a.num asc,a.jobno asc,a.thedate";
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String theid=StringHelper.null2String(mk.get("id"));
		String oid=StringHelper.null2String(mk.get("oid"));
		String oname=StringHelper.null2String(mk.get("oname"));
		String jobno=StringHelper.null2String(mk.get("jobno"));
		String hid=StringHelper.null2String(mk.get("hid"));
		String hname=StringHelper.null2String(mk.get("hname"));
		String thedate=StringHelper.null2String(mk.get("thedate"));
		String breakfast=StringHelper.null2String(mk.get("breakfast"));
		Date day = sf.parse(thedate);
		Date dd=null;
		Date ddd=null;
		try {
				dd = sf.parse(thedate);
				ddd=sf.parse(nowday);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(dd.before(ddd))
		{
			 zcshow="disabled";
			 wucshow="disabled";
			 wancshow="disabled";
		}
		else if(dd.after(ddd))
		{

			 if(thedate.equals(nextdaystr)&&Integer.parseInt(strhour)>=15)
			{
				zcshow="disabled";
				wucshow="";
				wancshow="";
			}
			else
			{
				 zcshow="";
				 wucshow="";
				 wancshow="";
			}
		}
		else
		{
			zcshow=zcshow1;
			 wucshow=wucshow1;
			 wancshow=wancshow1;
		}
		/*if(flag.equals("1"))//星期一标示
		{
			if(thedate.equals(yesterdaystr)||thedate.equals(beforeyesterdaystr))
			{
				 zcshow="";
				 wucshow="";
				 wancshow="";
			}
		}*/
		if(flag.equals("5"))//星期五标示
		{
			if(thedate.equals(yesterdaystr)||thedate.equals(beforeyesterdaystr))
			{
				zcshow="disabled";
				wucshow="disabled";
				wancshow="disabled";
			}
		}
		if(flag.equals("6")||flag.equals("0"))
		{
			if(thedate.equals(yesterdaystr)||thedate.equals(beforeyesterdaystr))
			{
				zcshow="disabled";
				wucshow="disabled";
				wancshow="disabled";
			}
		}
		/*if(nowday.equals("2017-4-27")&&Integer.parseInt(strhour)>=16)
		{
			
			if("2017-05-28,2017-05-29,2017-05-30".indexOf(thedate)!=-1)
			{
				zcshow="disabled";
				wucshow="disabled";
				wancshow="disabled";
			}
		}
		if("2017-5-28,2017-5-29,2017-5-30".indexOf(nowday)!=-1)
		{
			
			if("2017-05-28,2017-05-29,2017-05-30".indexOf(thedate)!=-1)
			{
				zcshow="disabled";
				wucshow="disabled";
				wancshow="disabled";
			}
		}
	 	if(nowday.equals("2017-2-3"))
		{
			
			if("2017-01-27,2017-01-28,2017-01-29,2017-01-30,2017-01-31,2017-02-01,2017-02-02".indexOf(thedate)!=-1)
			{
				zcshow="";
				wucshow="";
				wancshow="";
			}
		
		}*/
		
		Date today = new Date();
		today = sf.parse(sf.format(today));
		String b = "";
		String l = "";
		String d = "";
		if(breakfast.equals("40285a90495b4eb001496408814f5995")){
			b = "订餐";
		}
		else if(breakfast.equals("40285a90495b4eb001496408814f5996"))
		{
			b="送餐";
		}
		else b = "";
		String lunch=StringHelper.null2String(mk.get("lunch"));
		if(lunch.equals("40285a90495b4eb001496408814f5995")){
			l = "订餐";
		}else if(lunch.equals("40285a90495b4eb001496408814f5996")){
			l = "送餐";
		}else l = "";
		String dinner=StringHelper.null2String(mk.get("dinner"));
		if(dinner.equals("40285a90495b4eb001496408814f5995")){
			d = "订餐";
		}else if(dinner.equals("40285a90495b4eb001496408814f5996")){
			d = "送餐";
		}else d = "";
		buf.append("<TR>");
		if(nodeshow.equals("edit")){
			//if(day.getTime()>=today.getTime())
				buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\"-1\" id=\"checkbox_"+k+"\" name=\"checkbox\"/></TD>");
			//else
				//buf.append("<TD class=\"td2\"  align=center><span style=\"display:none\"><input type=\"checkbox\" value=\"1\" id=\"checkbox_"+k+"\" name=\"checkbox\"/></span></TD>");
		}
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"node_"+k+"\" name=\"node\" value=\""+theid+"\"><span id=\"node_"+k+"span\" name=\"node_"+k+"span\">"+(k+1)+"</span></TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+k+"\" value=\""+oid+"\" ><span id=\"dept_"+k+"span\" name=\"dept_"+k+"span\"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id="+oid+"','"+oname+"','tab"+oid+"') >&nbsp;"+oname+"&nbsp;</a></span></TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"jobno_"+k+"\" value=\""+jobno+"\"><span id=\"jobno_"+k+"span\">"+jobno+"</span></TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"reqman_"+k+"\" value=\""+hid+"\"><span id=\"reqman_"+k+"span\" name=\"reqman_"+k+"span\"><a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+hid+"','"+hname+"','tab"+hid+"') >&nbsp;"+hname +"&nbsp;</a></span></TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"thedate_"+k+"\" value=\""+thedate+"\"><span id=\"thedate_"+k+"span\">"+thedate+"</span></TD>");
		if(nodeshow.equals("edit")){
			//if(day.getTime()>=today.getTime()){
				if(comparea.equals("40285a90488ba9d101488bbd09100007"))//盘锦厂 
			{
				if(breakfast.equals("")){
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"breakfast_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"breakfast_"+k+"\" id=\"breakfast_"+k+"\""+zcshow+"><option value=\"\" selected></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></select></TD>");
					}
					else if(breakfast.equals("40285a90495b4eb001496408814f5996"))
				{
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"breakfast_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"breakfast_"+k+"\" id=\"breakfast_"+k+"\""+zcshow+"><option value=\"\" ></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" selected>送餐</option></select></select></TD>");
						
				}
					else
				{
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"breakfast_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"breakfast_"+k+"\" id=\"breakfast_"+k+"\""+zcshow+"><option value=\"\" ></option><option value=\"40285a90495b4eb001496408814f5995\" selected>订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></select></TD>");
				}
			}
			else
			{
				if(breakfast.equals("")){
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"breakfast_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"breakfast_"+k+"\" id=\"breakfast_"+k+"\""+zcshow+"><option value=\"\" selected></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option></select></TD>");
				}

				else
				{
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"breakfast_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"breakfast_"+k+"\" id=\"breakfast_"+k+"\""+zcshow+"><option value=\"\" ></option><option value=\"40285a90495b4eb001496408814f5995\" selected>订餐</option></select></TD>");
				}
			}
			//}else 
				//buf.append("<TD class=\"td2\"  align=center>"+b+"</TD>");
		}else buf.append("<TD class=\"td2\"  align=center>"+b+"</TD>");
		if(nodeshow.equals("edit")){
			//if(day.getTime()>=today.getTime()){
				if(lunch.equals("")){
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"lunch_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"lunch_"+k+"\" id=\"lunch_"+k +"\""+wucshow+"><option value=\"\" selected ></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></TD>");
				}else if(lunch.equals("40285a90495b4eb001496408814f5995")){
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"lunch_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"lunch_"+k+"\" id=\"lunch_"+k +"\""+wucshow+"><option value=\"\"  ></option><option value=\"40285a90495b4eb001496408814f5995\" selected>订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></TD>");
				}else buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"lunch_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"lunch_"+k+"\" id=\"lunch_"+k +"\""+wucshow+"><option value=\"\"  ></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" selected>送餐</option></select></TD>");
			//}else buf.append("<TD class=\"td2\"  align=center>"+l+"</TD>");
		}else buf.append("<TD class=\"td2\"  align=center>"+l+"</TD>");
		if(nodeshow.equals("edit")){
			//if(day.getTime()>=today.getTime()){
				if(dinner.equals("")){
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dinner_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"dinner_"+k+"\" id=\"dinner_"+k+"\""+wancshow+"><option value=\"\" selected></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></TD>");
				}else if(dinner.equals("40285a90495b4eb001496408814f5995")){
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dinner_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"dinner_"+k+"\" id=\"dinner_"+k+"\""+wancshow+"><option value=\"\"></option><option value=\"40285a90495b4eb001496408814f5995\" selected>订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></TD>");
				}else buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dinner_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"dinner_"+k+"\" id=\"dinner_"+k+"\""+wancshow+"><option value=\"\"></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" selected>送餐</option></select></TD>");
			//}else buf.append("<TD class=\"td2\"  align=center>"+d+"</TD>");
		}else buf.append("<TD class=\"td2\"  align=center>"+d+"</TD>");
		buf.append("</TR>");
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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="5%">
<%if(nodeshow.equals("edit")){%>
<COL width="5%">
<%} %>
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
</COLGROUP>
<%
out.println(fbuf.toString());
%>
<TR height="25"  class="title">
<%if(nodeshow.equals("edit")){%>
<TD  noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>全选</TD>
<%} %>
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>部门</TD>
<TD  noWrap class="td2"  align=center>工号</TD>
<TD  noWrap class="td2"  align=center>姓名</TD>
<TD  noWrap class="td2"  align=center>订餐日期</TD>
<TD  noWrap class="td2"  align=center>早餐</TD>
<TD  noWrap class="td2"  align=center>午餐</TD>
<TD  noWrap class="td2"  align=center>晚餐</TD>
</tr>

<%
out.println(buf.toString());
%>

</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  