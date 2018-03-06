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
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//发起节点
	String humres=StringHelper.null2String(request.getParameter("humres"));
	String beginDate=StringHelper.null2String(request.getParameter("begindate"));
	String endDate=StringHelper.null2String(request.getParameter("enddate"));
	String[] hnames = humres.split(",");
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	Date bd = null;
	try {
		bd = sf.parse(beginDate);
	} catch (ParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	Date ed = null;
	try {
		ed = sf.parse(endDate);
	} catch (ParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	int days = (int)((ed.getTime()-bd.getTime()) / 1000 / 60 / 60 / 24) + 1;
	int k = 0;
	StringBuffer buf = new StringBuffer();
	for(int i=0;i<hnames.length;i++){
		String sql = "select a.id hid,a.objname hname,a.objno,a.orgid oid,b.objname oname from humres a left join orgunit b on a.orgid=b.id where a.id='"+hnames[i]+"'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			Map map = (Map)list.get(0);
			String oid=StringHelper.null2String(map.get("oid"));
			String oname=StringHelper.null2String(map.get("oname"));
			String jobno=StringHelper.null2String(map.get("objno"));
			String hid=StringHelper.null2String(map.get("hid"));
			String hname=StringHelper.null2String(map.get("hname"));
			Calendar cd = Calendar.getInstance();
			for(int m=0;m<days;m++){
				cd.setTime(sf.parse(beginDate));
				cd.add(Calendar.DATE,m);
				Date d = cd.getTime();
				String thedate = sf.format(d);
				String sql2 = "select a.objname from uf_hr_unitfootsub a,uf_hr_unitfoot c where a.requestid=c.requestid and exists(select b.id from formbase b where c.requestid=b.id and b.isdelete=0) and a.objname='"+hid+"' and a.thedate='"+thedate+"'";
				List list2 = baseJdbc.executeSqlForList(sql2);
				if(list2.size()>0){
					buf.append("<TR style=\"background-color:red;\" id=\"dataDetail_"+k+"\">"); 
				}else buf.append("<TR id=\"dataDetail_"+k+"\">");
				buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\"-1\" id=\"checkbox_"+k+"\" name=\"checkbox\"/></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"node_"+k+"\" name=\"node_"+k+"\" value=\""+k+"\"><span id=\"node_"+k+"span\" name=\"node_"+k+"span\">"+(k+1)+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+k+"\" value=\""+oid+"\" ><span id=\"dept_"+k+"span\" name=\"dept_"+k+"span\"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id="+oid+"','"+oname+"','tab"+oid+"') >&nbsp;"+oname+"&nbsp;</a></span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"jobno_"+k+"\" value=\""+jobno+"\"><span id=\"jobno_"+k+"span\">"+jobno+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"reqman_"+k+"\" value=\""+hid+"\"><span id=\"reqman_"+k+"span\" name=\"reqman_"+k+"span\"><a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+hid+"','"+hname+"','tab"+hid+"') >&nbsp;"+hname +"&nbsp;</a></span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"thedate_"+k+"\" value=\""+thedate+"\"><span id=\"thedate_"+k+"span\">"+thedate+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"breakfast_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"breakfast_"+k+"\" id=\"breakfast_"+k+"\"><option value=\"\" ></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option></select></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"lunch_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"lunch_"+k+"\" id=\"lunch_"+k +"\"><option value=\"\"  ></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dinner_"+k+"check\" value=\"\" ><select class=\"InputStyle6\" name=\"dinner_"+k+"\" id=\"dinner_"+k+"\"><option value=\"\"></option><option value=\"40285a90495b4eb001496408814f5995\" >订餐</option><option value=\"40285a90495b4eb001496408814f5996\" >送餐</option></select></TD>");
				buf.append("</TR>");
				k = k + 1;
			}
		}else{
			buf.append("<TR><TD colspan=9>无数据！</TD></TR>");
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
<COL width="5%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>全选</TD>
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
