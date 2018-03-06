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
String startdate = StringHelper.null2String(request.getParameter("startdate"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String enddate = StringHelper.null2String(request.getParameter("enddate"));
String comptype=StringHelper.null2String(request.getParameter("comptype"));
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

<div id="warpp" style="overflow-y:auto">

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width:2000px;font-size:12" bordercolor="#adae9d">

	    <TR height="25"  class="title">
		<TD class="td2"  align=center>标题</TD>
		<TD class="td2"  align=center>当前节点</TD>
		<TD class="td2"  align=center>填单日期</TD>
		<TD class="td2"  align=center>所属公司</TD>
		<TD class="td2"  align=center>成本中心</TD>
		<TD class="td2"  align=center>订餐开始日期</TD>
		<TD class="td2"  align=center>订餐结束日期</TD>
		<TD class="td2"  align=center>客人姓名</TD>
		<TD class="td2"  align=center>客人单位</TD>
		<TD class="td2"  align=center>客人人数</TD>
		<TD class="td2"  align=center>外送份数（早）</TD>
		<TD class="td2"  align=center>外送份数（中）</TD>
		<TD class="td2"  align=center>外送份数（晚）</TD>
		<TD class="td2"  align=center>餐厅就餐份数（早）</TD>
		<TD class="td2"  align=center>餐厅就餐份数（中）</TD>
		<TD class="td2"  align=center>餐厅就餐份数（晚）</TD>
		</TR>
<%
String  str="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid=40285a90495b4eb0014974ab9470536f&sqlwhere=((substr(startdate,0,10) between '"+startdate+"' and '"+enddate+"') or (substr(enddate,0,10) between '"+startdate+"' and '"+enddate+"') or (substr(startdate,0,10) <='"+startdate+"' and substr(enddate ,0,10)>='"+enddate+"')) and comtype='"+comptype+"' ";
String sql = "";
	sql = "select a.title,c.objname,a.reqdate,d.objname as reqcom,a.comtype,a.costcenter,a.startdate,a.enddate,a.name,a.customer,a.nums,a.out1,a.out2,a.out3,a.resta1,a.resta2,a.resta3 from uf_hr_customfood a, REQUESTINFO b,nodeinfo c,orgunit d where b.CURRENTNODEID=c.id and b.requestid=a.requestid and d.id=a.reqcom  and  ((substr(a.startdate,0,10) between '"+startdate+"' and '"+enddate+"') or (substr(a.enddate ,0,10) between '"+startdate+"' and '"+enddate+"') or (substr(a.startdate,0,10) <='"+startdate+"' and substr(a.enddate ,0,10)>='"+enddate+"')) and a.requestid in( select rb.id from requestbase rb where rb.isdelete<>1 ) and exists (select   rb.id from requestbase rb  where rb.isdelete=0) and a.comtype='"+comptype+"' ";

List sublist = baseJdbc.executeSqlForList(sql);
Map mk=null;
int no=sublist.size();
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		mk = (Map)sublist.get(k);
		String title =StringHelper.null2String(mk.get("title"));
		String objname =StringHelper.null2String(mk.get("objname"));
		String reqdate =StringHelper.null2String(mk.get("reqdate"));
		String reqcom =StringHelper.null2String(mk.get("reqcom"));
		String costcenter =StringHelper.null2String(mk.get("costcenter"));
		String startdate1 =StringHelper.null2String(mk.get("startdate"));
		String enddate1 =StringHelper.null2String(mk.get("enddate"));
		String name =StringHelper.null2String(mk.get("name"));
		String customer =StringHelper.null2String(mk.get("customer"));
		String nums =StringHelper.null2String(mk.get("nums"));
		String out1 =StringHelper.null2String(mk.get("out1"));
		String out2 =StringHelper.null2String(mk.get("out2"));
		String out3 =StringHelper.null2String(mk.get("out3"));
		String resta1 =StringHelper.null2String(mk.get("resta1"));
		String resta2 =StringHelper.null2String(mk.get("resta2"));
		String resta3 =StringHelper.null2String(mk.get("resta3"));
	%>

		<TR>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count0_"+k%>" style="width:80%" value="<%=title%>"> <span id="<%="count0_"+k+"span"%>"><%=title%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count1_"+k%>" style="width:80%" value="<%=objname%>"><span id="<%="count1_"+k+"span"%>"><%=objname%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count2_"+k%>" style="width:80%" value="<%=reqdate%>"><span id="<%="count2_"+k+"span"%>"><%=reqdate%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count12_"+k%>" style="width:80%" value="<%=reqcom%>"><span id="<%="count12_"+k+"span"%>"><%=reqcom%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count3_"+k%>" style="width:80%" value="<%=costcenter%>"><span id="<%="count3_"+k+"span"%>"><%=costcenter%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count4_"+k%>" style="width:80%" value="<%=startdate1%>"><span id="<%="count4_"+k+"span"%>"><%=startdate1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count5_"+k%>" style="width:80%" value="<%=enddate1%>"><span id="<%="count5_"+k+"span"%>"><%=enddate1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count6_"+k%>" style="width:80%" value="<%=name%>"><span id="<%="count6_"+k+"span"%>"><%=name%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count7_"+k%>" style="width:80%" value="<%=customer%>"><span id="<%="count7_"+k+"span"%>"><%=customer%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count8_"+k%>" style="width:80%" value="<%=nums%>"><span id="<%="count8_"+k+"span"%>"><%=nums%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count9_"+k%>" style="width:80%" value="<%=out1%>"><span id="<%="count9_"+k+"span"%>"><%=out1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count10_"+k%>" style="width:80%" value="<%=out2%>"><span id="<%="count10_"+k+"span"%>"><%=out2%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count11_"+k%>" style="width:80%" value="<%=out3%>"><span id="<%="count11_"+k+"span"%>"><%=out3%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count9_"+k%>" style="width:80%" value="<%=resta1%>"><span id="<%="count9_"+k+"span"%>"><%=resta1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count10_"+k%>" style="width:80%" value="<%=resta2%>"><span id="<%="count10_"+k+"span"%>"><%=resta2%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="count11_"+k%>" style="width:80%" value="<%=resta3%>"><span id="<%="count11_"+k+"span"%>"><%=resta3%></span></TD>
		</TR>
	
<%
	}
	sql = "select sum(a.out1) out1,sum(a.out2) out2, sum(a.out3) out3 ,sum(a.resta1) resta1,sum(a.resta2) resta2,sum(a.resta3) resta3 from uf_hr_customfood a, REQUESTINFO b,nodeinfo c,orgunit d where b.CURRENTNODEID=c.id and b.requestid=a.requestid and d.id=a.reqcom  and  ((substr(a.startdate,0,10) between '"+startdate+"' and '"+enddate+"') or (substr(a.enddate ,0,10) between '"+startdate+"' and '"+enddate+"') or (substr(a.startdate,0,10) <='"+startdate+"' and substr(a.enddate ,0,10)>='"+enddate+"')) and a.requestid in( select rb.id from requestbase rb where rb.isdelete<>1 ) and exists (select   rb.id from requestbase rb  where rb.isdelete=0) and a.comtype='"+comptype+"' ";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size()>0){
		for(int k=0,sizek=sublist.size();k<sizek;k++){
			mk = (Map)sublist.get(k);
			String out1 =StringHelper.null2String(mk.get("out1"));
			String out2 =StringHelper.null2String(mk.get("out2"));
			String out3 =StringHelper.null2String(mk.get("out3"));
			String resta1 =StringHelper.null2String(mk.get("resta1"));
			String resta2 =StringHelper.null2String(mk.get("resta2"));
			String resta3 =StringHelper.null2String(mk.get("resta3"));
			%>
		<TR>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center>&nbsp;</TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=out1%></font></TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=out2%></font></TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=out3%></font></TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=resta1%></font></TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=resta2%></font></TD>
		<TD   class="td2"  align=center><font style="color:#ff0000"><%=resta3%></font></TD>
		</TR>
			<%
		}
	}

}else{%> 
	<TR><TD class="td2" colspan="16">无数据!</TD></TR>
<%} %>
<TR style="display:none">
<TD colspan="16" class="td2">
<IFRAME id="splitIframe" height=280 src="<%=str%>" frameBorder=0 width="100%" name=splitIframe scrolling=no></IFRAME>
</TD>
</TR>
</table>
</div>

