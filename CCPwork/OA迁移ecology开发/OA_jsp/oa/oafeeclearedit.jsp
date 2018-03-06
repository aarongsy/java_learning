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
String kddzid = StringHelper.null2String(request.getParameter("kddzid"));//快递对账单号
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String count = StringHelper.null2String(request.getParameter("count"));//序号
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
<COLGROUP>
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL width="7%">
<COL  id=innerno width="7%"></COLGROUP>

<TR height="25"  class="title">
<TD noWrap>序号</A></TD>
<TD noWrap>记账码</A></TD>
<TD noWrap>总账科目</A></TD>
<TD noWrap>金额</A></TD>
<TD noWrap>文本</A></TD>
<TD noWrap>税码</A></TD>
<TD noWrap>成本中心</A></TD>
<TD noWrap>付款条件</A></TD>
<TD noWrap>付款基准日期</A></TD>
<TD noWrap>结冻付款</A></TD>
<TD noWrap>付款方式</A></TD>
<TD noWrap>合作银行</A></TD>
<TD id=ordername noWrap>内部订单</A></TD>
<TD noWrap>销售订单</A></TD>
<TD noWrap>项次</A></TD></TR>
		
<%
String sql = "";
Map mk;
List sublist;
String sqlquery="";
Map map;
List list;
String upsql="";
int count1=Integer.parseInt(count);
if(kddzid.equals("40285a904f3b02ec014f7cb7ca2861d9")||kddzid.equals("40285a904f3b02ec014f4e5d01311a24")||kddzid.equals("40285a904f3b02ec014f4ed17bbf0be4")||kddzid.equals("40285a904f3b02ec014f4f38907f2bff")||kddzid.equals("40285a904ee36b81014f39513470509c")||kddzid.equals("40285a904ee36b81014f393868ac2ad9")||kddzid.equals("40285a904ee36b81014f3944112a3ea6")||kddzid.equals("40285a904ee36b81014f39553be655c6")||kddzid.equals("40285a904ee36b81014f397275b871ba")||kddzid.equals("40285a904f3b02ec014f3f6cec5507a2")||kddzid.equals("40285a904f3b02ec014f3ef4e0a942d3")||kddzid.equals("40285a904f3b02ec014f3eee226d4021")||kddzid.equals("40285a904f3b02ec014f3f447c396fe1")||kddzid.equals("40285a904f3b02ec014f48dff37b5f05")||kddzid.equals("40285a904f3b02ec014f44d3995e3446")||kddzid.equals("40285a904f3b02ec014f48fd5413740e")||kddzid.equals("40285a904f3b02ec014f6e31d66f11e6")||kddzid.equals("40285a904f3b02ec014f48fd5413740e"))
{
	sql = "select a.no ,a.jznumber,a.subject,a.costcenter,a.innerorder,a.taxcode,a.notaxnum,a.saleoeder,a.orderno from uf_oa_zgfeepzdetail a  where a.requestid=(select b.requestid from uf_oa_procost b left join requestbase c on c.id =b.requestid where b.appcode='"+kddzid+"' and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and 0=c.isdelete and 1=c.isfinished)  order by a.no asc ";
	System.out.println(sql);
	sublist = baseJdbc.executeSqlForList(sql);
	int no=sublist.size();
	if(sublist.size()>0){
		for(int k=0,sizek=sublist.size();k<sizek;k++){
			count1++;
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
			String sub1=StringHelper.null2String(mk.get("subject"));
			if(innerorder.equals("null"))
			{
				innerorder="";
			}
			if(sub1.equals("55060600"))
			{
				sub1="55060700";
			}
			else if(sub1.equals("55060700"))
			{
				sub1="55060600";
			}

			upsql="insert into uf_oa_feeclearpzdetail (ID, REQUESTID,no,jznumber,subject,num,text,taxcode,costcenter,payterm,paydate,jdpay,payway,blank,inneroeder,saleorder,innerno)values ((select sys_guid() from dual),'"+requestid+"',  '"+count1+"','50', '"+subject+"', "+notaxnum+", '调201509快递费', '"+taxcode+"', '"+costcenter+"', '', '', '','','','','"+saleoeder+"', '"+orderno+"')";
			System.out.println(upsql);
			baseJdbc.update(upsql);
			count1++;
			upsql="insert into uf_oa_feeclearpzdetail (ID, REQUESTID,no,jznumber,subject,num,text,taxcode,costcenter,payterm,paydate,jdpay,payway,blank,inneroeder,saleorder,innerno)values ((select sys_guid() from dual),'"+requestid+"','"+count1+"','40', '"+sub1+"', "+notaxnum+", '调201509快递费', '"+taxcode+"', '"+costcenter+"', '', '', '','','','','"+saleoeder+"', '"+orderno+"')";
			System.out.println(upsql);
			baseJdbc.update(upsql);
		}
	}
}
     sql = "select no,jznumber,subject,num,text,taxcode,costcenter,payterm,paydate,jdpay,payway,blank,inneroeder,saleorder,innerno from uf_oa_feeclearpzdetail a  where a.requestid='"+requestid+"'  order by to_number(a.no) asc ";
	System.out.println(sql);
	sublist = baseJdbc.executeSqlForList(sql);
	int no=sublist.size();
	if(sublist.size()>0){
		for(int k=0,sizek=sublist.size();k<sizek;k++){
			mk = (Map)sublist.get(k);
			String number=StringHelper.null2String(mk.get("no"));
			String jznumber =StringHelper.null2String(mk.get("jznumber"));
			String subject =StringHelper.null2String(mk.get("subject"));
			String num =StringHelper.null2String(mk.get("num"));
			String text =StringHelper.null2String(mk.get("text"));
			String taxcode =StringHelper.null2String(mk.get("taxcode"));
			String costcenter =StringHelper.null2String(mk.get("costcenter"));
			String payterm =StringHelper.null2String(mk.get("payterm"));
			String paydate =StringHelper.null2String(mk.get("paydate"));
			String jdpay=StringHelper.null2String(mk.get("jdpay"));
			String payway=StringHelper.null2String(mk.get("payway"));
			String blank=StringHelper.null2String(mk.get("blank"));
			String inneroeder=StringHelper.null2String(mk.get("inneroeder"));
			String saleorder=StringHelper.null2String(mk.get("saleorder"));
			String innerno=StringHelper.null2String(mk.get("innerno"));
	%>
	<TR>
		<TD   class="td2"  align=center><%=number %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="jznumber_"+k%>" style="width:80%" value="<%=jznumber%>"><span id="<%="jznumber_"+k+"span"%>"><%= jznumber%></span></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="subject_"+k%>" style="width:80%" value="<%=subject%>" onChange="changesub('<%=number%>','<%=k%>')">
		</TD>
		<TD   class="td2"  align=center><%=num %></TD>
		<TD   class="td2"  align=center><%=text %></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="taxcode_"+k%>" style="width:80%" value="<%=taxcode%>" onChange="changetax('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><input type="text" class="InputStyle" id="<%="costcenter_"+k%>" style="width:80%" value="<%=costcenter%>" onChange="changecostcenter('<%=number%>','<%=k%>')"></TD>
		<TD   class="td2"  align=center><%=payterm %></TD>
		<TD   class="td2"  align=center><%=paydate %></TD>
		<TD   class="td2"  align=center><%=jdpay %></TD>
		<TD   class="td2"  align=center><%=payway %></TD>
		<TD   class="td2"  align=center><%=blank %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="saleoeder_"+k%>" style="width:80%" value="<%=inneroeder%>">
		<span id="<%="saleoeder_"+k+"span"%>"><%=inneroeder%></span></TD>
		<TD   class="td2"  align=center><%=saleorder %></TD>
		<TD   class="td2"  align=center><input type="hidden" class="InputStyle" id="<%="orderno_"+k%>" style="width:80%" value="<%=innerno%>">
		<span id="<%="orderno_"+k+"span"%>"><%=innerno%></span></TD>

		</TR>
		<%
		}
	}
		%>
</table>
</div>