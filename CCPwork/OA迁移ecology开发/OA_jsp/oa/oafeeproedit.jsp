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
String text = StringHelper.null2String(request.getParameter("text"));//文本
String bussinesstype=StringHelper.null2String(request.getParameter("bussinesstype"));//事务类型
String notaxnum1=StringHelper.null2String(request.getParameter("notaxnum1"));//未税金额
String requestid = StringHelper.null2String(request.getParameter("requestid"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
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

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width:100%;font-size:12" bordercolor="#adae9d">
</COLGROUP>

	    <TR height="25"  class="title">
		<TD class="td2"  align=center>序号</TD>
		<TD class="td2"  align=center>记账码</TD>
		<TD class="td2"  align=center>总账科目</TD>
		<TD class="td2"  align=center>成本中心</TD>
		<TD class="td2"  align=center>内部订单</TD>
		<TD class="td2"  align=center>税码</TD>
		<TD class="td2"  align=center>金额</TD>
		<TD class="td2"  align=center>文本</TD>
		<TD class="td2"  align=center>事务类型</TD>
		<TD class="td2"  align=center>销售订单</TD>
		<TD class="td2"  align=center>订单项次</TD>
		
<%
String sql = "";
Map mk;
List sublist;
String sqlquery="";
Map map;
List list;
	String upsql="delete uf_oa_zgfeekjrowdetail where requestid='"+requestid+"'";
	baseJdbc.update(upsql);
	sql = "select a.no ,a.jznumber,a.subject,a.costcenter,a.innerorder,a.taxcode,a.notaxnum,a.saleoeder,a.orderno from uf_oa_zgfeepzdetail a  where a.requestid='"+requestid+"'  order by a.no asc ";
System.out.println(sql);
sublist = baseJdbc.executeSqlForList(sql);
int no=sublist.size();
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		mk = (Map)sublist.get(k);
		String number=StringHelper.null2String(mk.get("no"));
		String jznumber =StringHelper.null2String(mk.get("jznumber"));
		String subject =StringHelper.null2String(mk.get("subject"));
		String costcenter =StringHelper.null2String(mk.get("costcenter"));
		String innerorder =StringHelper.null2String(mk.get("innerorder"));
		String taxcode =StringHelper.null2String(mk.get("taxcode"));
		String notaxnum =StringHelper.null2String(mk.get("notaxnum"));
		String saleoeder =StringHelper.null2String(mk.get("saleoeder"));
		String orderno =StringHelper.null2String(mk.get("orderno"));
		if(innerorder.equals("null"))
		{
			innerorder="";
		}
	    upsql="insert into uf_oa_zgfeekjrowdetail (ID, REQUESTID,no, jznumber, subject, costcenter, innerorder, taxcode, taxnum,text, businesstype,saleoeder, orderno)values ((select sys_guid() from dual),'"+requestid+"',  "+number+",'"+jznumber+"', '"+subject+"', '"+costcenter+"', '"+innerorder+"', '"+taxcode+"', "+notaxnum+", '"+text+"', '"+bussinesstype+"', '"+saleoeder+"', '"+orderno+"')";
		System.out.println(upsql);
		baseJdbc.update(upsql);

	%>
	<TR>
		<TD   class="td2"  align=center><%=number %></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="jznumber_"+k%>" style="width:80%" value="<%=jznumber%>" onChange="changejzno('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="subject_"+k%>" style="width:80%" value="<%=subject%>">
		<span id="<%="subject_"+k+"span"%>"><%= subject%></span></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="costcenter_"+k%>" style="width:80%" value="<%=costcenter%>" onChange="changecostcenter('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="innerorder_"+k%>" style="width:80%" value="<%=innerorder%>" onChange="changeinnerorder('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="taxcode_"+k%>" style="width:80%" value="<%=taxcode%>" onChange="changetax('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="notaxnum_"+k%>" style="width:80%" value="<%=notaxnum%>">
		<span id="<%="notaxnum_"+k+"span"%>"><%=notaxnum%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="text_"+k%>" style="width:80%" value="<%=text%>">
		<span id="<%="text_"+k+"span"%>"><%=text%></span></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="bussinesstype_"+k%>" style="width:80%" value="<%=bussinesstype%>" onChange="changetype('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="saleoeder_"+k%>" style="width:80%" value="<%=saleoeder%>">
		<span id="<%="saleoeder_"+k+"span"%>"><%=saleoeder%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="orderno_"+k%>" style="width:80%" value="<%=orderno%>">
		<span id="<%="orderno_"+k+"span"%>"><%=orderno%></span></TD>

		</TR>
		

		

	<%

		}
		%>
		<TR>
		<TD   class="td2"  align=center><%=no+1 %></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="jznumber_"+no%>" style="width:80%" value="50" onChange="changejzno('<%=no+1%>','<%=no%>')"></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="subject_"+no%>" style="width:80%" value="21810999">
		<span id="<%="subject_"+no+"span"%>">21810999</span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="costcenter_"+no%>" style="width:80%" value="">
		<span id="<%="costcenter_"+no+"span"%>"></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="innerorder_"+no%>" style="width:80%" value="">
		<span id="<%="innerorder_"+no+"span"%>"></span></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="taxcode_"+no%>" style="width:80%" value="" onChange="changetax('<%=no+1%>','<%=no%>')"></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="notaxnum_"+no%>" style="width:80%" value="<%=notaxnum1%>">
		<span id="<%="notaxnum_"+no+"span"%>"><%=notaxnum1%></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="text_"+no%>" style="width:80%" value="">
		<span id="<%="text_"+no+"span"%>"><%=text%></span></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="bussinesstype_"+no%>" style="width:80%" value="<%=bussinesstype%>" onChange="changetype('<%=no+1%>','<%=no%>')"></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="saleoeder_"+no%>" style="width:80%" value="">
		<span id="<%="saleoeder_"+no+"span"%>"></span></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="orderno_"+no%>" style="width:80%" value="">
		<span id="<%="orderno_"+no+"span"%>"></span></TD>

		</TR>
		<%
		upsql="insert into uf_oa_zgfeekjrowdetail (ID, REQUESTID,no, jznumber, subject, costcenter, innerorder, taxcode, taxnum,text, businesstype,saleoeder, orderno)values ((select sys_guid() from dual),'"+requestid+"',  "+(no+1)+",'50', '21810999', '', '', '', "+notaxnum1+", '"+text+"', '"+bussinesstype+"', '', '')";
		System.out.println(upsql);
		baseJdbc.update(upsql);

}else{%> 
	<TR><TD class="td2" colspan="11">无数据导入</TD></TR>
<%} %>
</table>
</div>