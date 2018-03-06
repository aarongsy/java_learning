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
	String nextyear1=StringHelper.null2String(request.getParameter("nextyear"));
	String cate=StringHelper.null2String(request.getParameter("cate"));
	String comp=StringHelper.null2String(request.getParameter("comp"));
	String dept=StringHelper.null2String(request.getParameter("dept"));
	StringBuffer buf = new StringBuffer();
		String sql = "select a.entrydate,a.nextyear,a.objname,(select objno from humres where id=a.objnum)as objno,(select objname from orgunit where id=a.reqdept)as orgid,b.subcate,b.category,b.goodname,b.specify,b.num from uf_oa_clothdetail b left join uf_oa_clothnexttime a on b.requestid=a.requestid where a.nextyear like '%"+nextyear1+"%'  and b.subcate='"+cate+"' and b.cate='40285a8d4d1ce05e014d4221da565b7b' and a.isleave='40288098276fc2120127704884290211'";
		if(!comp.equals(""))
		{
			sql=sql+" and a.reqcomp='"+comp+"'";
		}
		if(!dept.equals(""))
		{
			sql=sql+" and a.reqdept='"+dept+"'";
		}
		List list = baseJdbc.executeSqlForList(sql);
		System.out.println(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String entrydate1=StringHelper.null2String(map.get("entrydate"));
				String nextyear=StringHelper.null2String(map.get("nextyear"));
				String objname=StringHelper.null2String(map.get("objname"));
				String objno=StringHelper.null2String(map.get("objno"));
				String orgid=StringHelper.null2String(map.get("orgid"));
				String goodname=StringHelper.null2String(map.get("goodname"));
				String category=StringHelper.null2String(map.get("category"));			
				String num=StringHelper.null2String(map.get("num"));
				String subcate1=StringHelper.null2String(map.get("subcate"));
				String specify=StringHelper.null2String(map.get("specify"));


				String sql2="select columnname from uf_oa_gensplcategory where requestid='"+cate+"'";
				List list2= baseJdbc.executeSqlForList(sql2);
				Map map1=null;
				String subcate="";
				if(list2.size()>0){
					map1 = (Map)list2.get(0);
					subcate=StringHelper.null2String(map1.get("columnname"));
				}
				sql2="select requestid,goodsname from uf_oa_goodsmaintain  where requestid ='"+goodname+"'";
				list2 = baseJdbc.executeSqlForList(sql2);
				//System.out.println(sql2);
				String name="";
				if(list2.size()>0){
					map1 = (Map)list2.get(0);
					name=StringHelper.null2String(map1.get("goodsname"));
				}

				buf.append("<TR id=\"dataDetail_"+k+"\">");
				buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\"-1\" id=\"checkbox_"+k+"\" name=\"checkbox\"/></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"node_"+k+"\" name=\"node_"+k+"\" value=\""+k+"\"><span id=\"node_"+k+"span\" name=\"node_"+k+"span\">"+(k+1)+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"entrydate_"+k+"\" value=\""+entrydate1+"\" ><span id=\"entrydate_"+k+"span\" name=\"entrydate_"+k+"span\">&nbsp;"+entrydate1+"&nbsp;</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"nextyear_"+k+"\" value=\""+nextyear+"\"><span id=\"nextyear_"+k+"span\">"+nextyear+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"objname_"+k+"\" value=\""+objname+"\"><span id=\"objname_"+k+"span\" name=\"objname_"+k+"span\">&nbsp;"+objname +"&nbsp;</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"objno_"+k+"\" value=\""+objno+"\"><span id=\"objno_"+k+"span\">"+objno+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"orgid_"+k+"\" value=\""+orgid+"\"><span id=\"orgid_"+k+"span\">"+orgid+"</span></TD>");
				if(cate.equals("40285a8d4b05b955014b067ab14f3bf1"))
				{
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"cate_"+k+"\" value=\"冬季工作服\"><span id=\"cate_"+k+"span\">冬季工作服</span></TD>");
				}
				else
				{
					buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"cate_"+k+"\" value=\"夏季工作服\"><span id=\"cate_"+k+"span\">夏季工作服</span></TD>");
				}
				
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"subcate_"+k+"\" value=\""+subcate+"\"><span id=\"subcate_"+k+"span\">"+subcate+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"name_"+k+"\" value=\""+name+"\"><span id=\"name_"+k+"span\">"+name+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"specify_"+k+"\" value=\""+specify+"\"><span id=\"specify_"+k+"span\">"+specify+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"numres_"+k+"\" value=\""+num+"\"><span id=\"numres_"+k+"span\">"+num+"</span></TD>");
				buf.append("</TR>");
			}
		}else{
			buf.append("<TR><TD colspan=12>无数据！</TD></TR>");
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
<COL width="3%">
<COL width="3%">
<COL width="8%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="8%">
<COL width="20%">
<COL width="20%">
<COL width="10%">
<COL width="10%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>全选</TD>
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>入厂日期</TD>
<TD  noWrap class="td2"  align=center>年度发放日期</TD>
<TD  noWrap class="td2"  align=center>姓名</TD>
<TD  noWrap class="td2"  align=center>工号</TD>
<TD  noWrap class="td2"  align=center>部门</TD>
<TD  noWrap class="td2"  align=center>总务类别</TD>
<TD  noWrap class="td2"  align=center>次类别</TD>
<TD  noWrap class="td2"  align=center>品名</TD>
<TD  noWrap class="td2"  align=center>规格</TD>
<TD  noWrap class="td2"  align=center>数量</TD>
</tr>

<%
out.println(buf.toString());
%>
</table>
</div>
