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
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//发起节点，隐藏字段。
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
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<%if(nodeshow.equals("req") || nodeshow.equals("rszx")){ %>
<COL width="8%">
<COL width="8%">
<%} %>
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>员工工号</TD>
<TD  noWrap class="td2"  align=center>员工部门</TD>
<TD  noWrap class="td2"  align=center>员工姓名</TD>
<TD  noWrap class="td2"  align=center>性别</TD>
<TD  noWrap class="td2"  align=center>出生年月</TD>
<TD  noWrap class="td2"  align=center>身份证号码</TD>
<TD  noWrap class="td2"  align=center>入职时间</TD>
<%if(nodeshow.equals("req") || nodeshow.equals("rszx")){ %>
<TD  noWrap class="td2"  align=center>打折天数</TD>
<TD  noWrap class="td2"  align=center>试用期不打折时间</TD>
<%} %>
<TD  noWrap class="td2"  align=center>SAP职位名称</TD>
</tr>

<%
String sql = "select a.id,a.no,a.entryno,a.objdept,b.objname objdeptname,b.col1 objdeptno,a.objname,a.sex,c.objname sexname,a.birthday,a.cardid,a.entrydate,a.discount,a.discountdate,a.stationid,a.stationname,a.twodept from uf_hr_entrysub a,orgunit b,selectitem c where a.objdept=b.id and a.sex=c.id and a.requestid='"+requestid+"' order by no";;
/**
if(nodeshow.equals("zgsp") || nodeshow.equals("zgshow"))
{
	
	sql = "select a.id,a.no,a.entryno,a.objdept,b.objname objdeptname,a.objname,a.sex,c.objname sexname,a.birthday,a.cardid,a.entrydate,a.discount,a.discountdate,a.stationid,a.stationname from uf_hr_entrysub a,orgunit b,selectitem c where a.objdept=b.id and a.sex=c.id and a.requestid='"+requestid+"' and a.twodept='"+orgid+"' order by no";
}else{	
	sql = "select a.id,a.no,a.entryno,a.objdept,b.objname objdeptname,a.objname,a.sex,c.objname sexname,a.birthday,a.cardid,a.entrydate,a.discount,a.discountdate,a.stationid,a.stationname,a.twodept from uf_hr_entrysub a,orgunit b,selectitem c where a.objdept=b.id and a.sex=c.id and a.requestid='"+requestid+"' order by no";
}
**/
List sublist = baseJdbc.executeSqlForList(sql);
int no = 0;
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		boolean flag = true;
		EweaverUser eweaveruser = BaseContext.getRemoteUser();
		Humres currentuser = eweaveruser.getHumres();
		if(nodeshow.equals("zgsp") || nodeshow.equals("zgshow")){
			String twodept=StringHelper.null2String(mk.get("twodept"));	//二级部门
			String sql2 = "select a.id from humres a,orgunit b,stationinfo c where b.mstationid=c.id and a.station like '%'||c.id||'%' and b.id='"+twodept+"'";
			List list2 = baseJdbc.executeSqlForList(sql2);
			if(list2.size()>0){
				Map map = (Map)list2.get(0);
				String theobjid = StringHelper.null2String(map.get("id"));				
				String userid = currentuser.getId();
				if(!theobjid.equals(userid)){
					flag = false;
				}
			}
		}
		if(nodeshow.equals("zlsp") || nodeshow.equals("zlshow")){
			String reqdept = StringHelper.null2String(mk.get("objdept"));//所属部门
			String oid = eweaveruser.getOrgid();
			if(!reqdept.equals(oid)) flag = false;
		}
		if(flag){
			String theid=StringHelper.null2String(mk.get("id"));
			no=no+1;
			String entryno=StringHelper.null2String(mk.get("entryno"));
			String objdept=StringHelper.null2String(mk.get("objdept"));
			String objdeptname=StringHelper.null2String(mk.get("objdeptname"));
			String objdeptno=StringHelper.null2String(mk.get("objdeptno"));
			String objname=StringHelper.null2String(mk.get("objname"));
			String sex=StringHelper.null2String(mk.get("sex"));
			String sexname=StringHelper.null2String(mk.get("sexname"));
			String birthday=StringHelper.null2String(mk.get("birthday"));
			String cardid=StringHelper.null2String(mk.get("cardid"));
			String entrydate=StringHelper.null2String(mk.get("entrydate"));
			String discount=StringHelper.null2String(mk.get("discount"));
			String discountdate=StringHelper.null2String(mk.get("discountdate"));
			String stationid=StringHelper.null2String(mk.get("stationid"));
			String stationname=StringHelper.null2String(mk.get("stationname"));
		%>
			<TR id="<%="dataDetail_"+no %>">
			<TD   class="td2"  align=center><input type="hidden" name="no"><%=no %></TD>
			<TD   style="display:none"><input type="text" id="<%="theid_"+no%>" value="<%=theid%>"></TD>
			<%if(nodeshow.equals("req")){ %>
			<TD   class="td2"  align=center><input type="text" class="InputStyle" maxlength=15 name="entryno" id="<%="entryno_"+no%>" style="width:80%;text-align:center;" value="<%=entryno %>" onchange="checkInput('<%="entryno_"+no %>','<%="entryno_"+no+"span" %>');"><span id="<%="entryno_"+no+"span"%>"><%if(entryno.equals("")){%><img src="/images/base/checkinput.gif" align=absMiddle><%}%></span></TD>
			<%}else{ %>
			<TD   class="td2"  align=center><%=entryno %></TD>
			<%} %>
			<TD   class="td2"  align=center><input type="hidden" id="<%=("objdept_"+no) %>" value="<%=objdept%>"><span id="<%=(no+"_"+objdept+"span") %>"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id=<%=objdept %>','<%=objdeptname %>','tab<%=objdept %>')>&nbsp;<%=objdeptname %>&nbsp;</a></span></TD>
			<TD   class="td2"  align=center><%=objname %></TD>
			<TD   class="td2"  align=center><%=sexname %></TD>
			<TD   class="td2"  align=center><%=birthday %></TD>
			<TD   class="td2"  align=center><%=cardid %></TD>
			<TD   class="td2"  align=center><input type="hidden" class="InputStyle" maxlength=15 name="entrydate" id="<%="entrydate_"+no%>" style="width:80%;text-align:center" value="<%=entrydate%>"><span id="<%="entrydate_"+no+"span"%>"><%=entrydate %></span></TD>
			<%if(nodeshow.equals("req")){ %>
			<TD   class="td2"  align=center><input type="text" class="InputStyle" maxlength=15 name="discount" id="<%="discount_"+no%>" style="width:80%;text-align:center" value="<%=discount%>" onchange="fieldcheck(this,'^(-?[\\d+]{0,22})(\\.[\\d+]{0,2})?$','数量');setBdzsj('<%=no %>',this.value);checkInput('<%="discount_"+no %>','<%="discount_"+no+"span" %>');"><span id="<%="discount_"+no+"span"%>"></span></TD>
			<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="discountdate_"+no%>" style="width:80%" value="<%=discountdate%>"><span id="<%="discountdate_"+no+"span"%>"><%=discountdate%></span></TD>
			<%}else if (nodeshow.equals("rszx")){%>
			<TD   class="td2"  align=center><%=discount %></TD>
			<TD   class="td2"  align=center><%=discountdate %></TD>
			<%} %>
			<%if(nodeshow.equals("zgsp")){ %>
			<TD   style="display:none"><input type="hidden" id="<%="field_40285a9049bb5ef30149bb8fe1fb02cf_"+no %>" name="<%="field_40285a9049bb5ef30149bb8fe1fb02cf_"+no %>"  value="<%=objdeptno %>"  ></TD>
			<TD   class="td2"  align=center><button type=button  sapflag=1  class=Browser id="<%="button_40285a8f489c17ce0148a1a102881711_"+no %>" name="<%="button_40285a8f489c17ce0148a1a102881711_"+no %>" onclick="javascript:getrefobj('<%="field_40285a8f489c17ce0148a1a102881711_"+no %>','<%="field_40285a8f489c17ce0148a1a102881711_"+no+"span" %>','40285a9048a213b50148a55e560b000b','','','0');"></button><input type="hidden" id="<%="field_40285a8f489c17ce0148a1a102881711_"+no %>" name="<%="field_40285a8f489c17ce0148a1a102881711_"+no %>" value="<%=stationid %>"  style="width: 80%"><span id="<%="field_40285a8f489c17ce0148a1a102881711_"+no+"span" %>" name="<%="field_40285a8f489c17ce0148a1a102881711_"+no+"span" %>" ><%if(stationname.equals("")){%><img src="/images/base/checkinput.gif" align=absMiddle><%}else%><%=stationname %></span></TD>
			<TD   style="display:none"><input type="hidden" id="<%="field_40285a8f489c17ce0148a1a102a01713_"+no %>" name="<%="field_40285a8f489c17ce0148a1a102a01713_"+no %>"  value=""  ><span  id="<%="field_40285a8f489c17ce0148a1a102a01713_"+no+"span" %>" name="<%="field_40285a8f489c17ce0148a1a102a01713_"+no+"span" %>" ></span></TD>
			<%}else{ %>
			<TD   class="td2"  align=center><%=stationname %>&nbsp;&nbsp;<%=stationid %></TD>
			<%} %>
			</tr>
		<%
		}			
	}
}else{%> 
	<TR><TD class="td2" colspan="11">人才库中无对应员工！</TD></TR>
<%} %>
</table>
</div>
