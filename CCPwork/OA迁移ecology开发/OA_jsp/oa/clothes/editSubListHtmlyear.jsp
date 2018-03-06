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
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String dept=StringHelper.null2String(request.getParameter("dept"));
		StringBuffer buf = new StringBuffer();
		String sql = "select no,entydate,seconddate,objname,objnum,dept,(select objname from orgunit where id=a.dept) as deptname,(select columnname from uf_oa_gensplcategory where requestid=a.cate) as cate,(select columnname from uf_oa_gensplcategory where requestid=a.subcate) as subcate,a.subcate as cateid,(select goodsname from uf_oa_goodsmaintain where requestid=a.goodsname) goodsname,num,(select goodsid from uf_oa_goodsmaintain where requestid=a.goodsid) goodsid,unit,specify from uf_oa_clothsecdetail a where a.requestid='"+requestid+"'";
		if(!dept.equals("")&&!dept.equals("null"))
		{
			sql=sql+" and a.dept='"+dept+"'";
		}
		sql=sql+" order by no asc";
		List list = baseJdbc.executeSqlForList(sql);
		System.out.println(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String no=StringHelper.null2String(map.get("no"));
				String entrydate1=StringHelper.null2String(map.get("entydate"));
				String nexttime=StringHelper.null2String(map.get("seconddate"));
				String objname=StringHelper.null2String(map.get("objname"));
				String objno=StringHelper.null2String(map.get("objnum"));
				String orgid=StringHelper.null2String(map.get("dept"));
				String deptname=StringHelper.null2String(map.get("deptname"));
				String cate=StringHelper.null2String(map.get("cate"));
				String subcate=StringHelper.null2String(map.get("subcate"));
				String goodsname=StringHelper.null2String(map.get("goodsname"));
				String num=StringHelper.null2String(map.get("num"));
				String goodsid=StringHelper.null2String(map.get("goodsid"));
				String unit=StringHelper.null2String(map.get("unit"));
				String specify=StringHelper.null2String(map.get("specify"));
				String cateid=StringHelper.null2String(map.get("cateid"));
				String sqlwhere="sqlwhere=1=1 and invalideflag=%2740285a8f489c17ce01489c56b69600b5%27 and subcate=%27"+cateid+"%27";
				System.out.println(sqlwhere);

				buf.append("<TR id=\"dataDetail_"+k+"\">");
				buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\"-1\" id=\"checkbox_"+k+"\" name=\"checkbox\"/></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"node_"+k+"\" name=\"node_"+k+"\" value=\""+no+"\"><span id=\"node_"+k+"span\" name=\"node_"+k+"span\">"+(k+1)+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"entrydate_"+k+"\" value=\""+entrydate1+"\" ><span id=\"entrydate_"+k+"span\" name=\"entrydate_"+k+"span\">&nbsp;"+entrydate1+"&nbsp;</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"nexttime_"+k+"\" value=\""+nexttime+"\"><span id=\"nexttime_"+k+"span\">"+nexttime+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"objname_"+k+"\" value=\""+objname+"\"><span id=\"objname_"+k+"span\" name=\"objname_"+k+"span\">&nbsp;"+objname +"&nbsp;</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"objno_"+k+"\" value=\""+objno+"\"><span id=\"objno_"+k+"span\">"+objno+"</span></TD>");
				buf.append("<TD noWrap  class=\"td2\"  align=center><input type=\"hidden\" id=\"orgid_"+k+"\" value=\""+orgid+"\"><span id=\"orgid_"+k+"span\">"+deptname+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"cate_"+k+"\" value=\""+cate+"\"><span id=\"cate_"+k+"span\">"+cate+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"subcate_"+k+"\" value=\""+cateid+"\"><span id=\"subcate_"+k+"span\">"+subcate+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><button type=button  class=Browser  id=\"button_name_"+k+"\" name=\"button_name_"+k+"\" onclick=\"javascript:getrefobj('name_"+k+"','name_"+k+"span','40285a8f489c17ce0148af816a9942f1','"+sqlwhere+"','','0');changname('"+k+"');\"></button><input type=\"hidden\" id=\"name_"+k+"\" name=\"name_"+k+"\" value=\""+goodsname+"\"><span id=\"name_"+k+"span\" name=\"name_"+k+"span\" >"+goodsname+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"goodsid_"+k+"\" value=\""+goodsid+"\"><span id=\"goodsid_"+k+"span\">"+goodsid+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"specify_"+k+"\" value=\""+specify+"\"><span id=\"specify_"+k+"span\">"+specify+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"unit_"+k+"\" value=\""+unit+"\"><span id=\"unit_"+k+"span\">"+unit+"</span></TD>");
				buf.append("<TD noWrap class=\"td2\"  align=center><input type=\"hidden\" id=\"numres_"+k+"\" value=\""+num+"\"><span id=\"numres_"+k+"span\">"+num+"</span></TD>");
				buf.append("</TR>");
			}
		}else{
			buf.append("<TR><TD colspan=14>无数据！</TD></TR>");
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
<COL width="5%" style="display:none">
<COL width="5%">
<COL width="5%">
<COL width="5%">
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
<TD  noWrap class="td2"  align=center>编码</TD>
<TD  noWrap class="td2"  align=center>规格</TD>
<TD  noWrap class="td2"  align=center>单位</TD>
<TD  noWrap class="td2"  align=center>数量</TD>
</tr>

<%
out.println(buf.toString());
%>
</table>
</div>
