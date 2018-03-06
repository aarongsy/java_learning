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
String requestid=StringHelper.null2String(request.getParameter("requestid"));
BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
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
</style>

<script style="text/javascript" language="javascript">
</script>


<DIV id="warpp" >
<TABLE id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
</COLGROUP>

<!--<TR height=25 class="title">
<TD class="td1" colspan="16" align=left>对账单</TD>
</TR>-->

<TR class="tr1">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>使用日期</TD>
<TD  noWrap class="td2"  align=center>申请人</TD>
<TD  noWrap class="td2"  align=center>部门</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>税码</TD>
<TD  noWrap class="td2"  align=center>税率</TD>
<TD  noWrap class="td2"  align=center>税别</TD>
<TD  noWrap class="td2"  align=center>申请单号(包厢、会议)</TD>
<TD  noWrap class="td2"  align=center>品名</TD>
<TD  noWrap class="td2"  align=center>单价(元/斤)</TD>
<TD  noWrap class="td2"  align=center>重量(斤)</TD>
<TD  noWrap class="td2"  align=center>金额(元)</TD>
<TD  noWrap class="td2"  align=center>未税金额(元)</TD>
<TD  noWrap class="td2"  align=center>税金(元)</TD>

</TR>

<%
//从水果对账单子表中获得数据来显示
/*String sql="select a.ordernum,a.applidate,(select objname from humres where id=a.applicant) as applicant,(select objname from orgunit where id=a.department) as Department,a.costcenter,a.accountsubject,(select taxcode from uf_oa_taxcode where requestid=a.taxcode) as taxcode,a.taxrate,a.taxtype,a.appliflow,a.productname,a.price,a.quantity,a.amountmoney,a.notaxmoney,a.taxmoney from uf_oa_fruitaccountchild a where a.requestid='"+requestid+"' order by a.ordernum asc ";*/

String sql="select a.Accountres,a.ordernum,substr(a.applidate,0,10) as applidate,(select objname from humres where id=a.applicant) as applicant,(select objname from orgunit where id=a.department) as Department,a.costcenter,a.accountsubject,(select taxcode from uf_oa_taxcode where requestid=a.taxcode) as taxcode,a.taxrate,a.taxtype,a.appliflow,a.productname,a.price,a.quantity,a.amountmoney,a.notaxmoney,a.taxmoney from uf_oa_fruitaccountchild a where a.requestid='"+requestid+"' order by a.appliflow,a.applidate asc";
 List sublist = baseJdbc.executeSqlForList(sql);
 if(sublist.size()>0)
 {
	 for(int i=0;i<sublist.size();i++)
	 {
		 Map map=(Map)sublist.get(i);
		 String Ordernum=StringHelper.null2String(map.get("ordernum"));//序号
		 String AppliDate=StringHelper.null2String(map.get("applidate"));//使用日期
		 String Applicant=StringHelper.null2String(map.get("applicant"));//申请人
		 String Department=StringHelper.null2String(map.get("department"));//部门
		 String Costcenter=StringHelper.null2String(map.get("costcenter"));//成本中心
		 String Accountsubject=StringHelper.null2String(map.get("accountsubject"));//总账科目
		 String Taxcode=StringHelper.null2String(map.get("taxcode"));//税码
		 String Taxrate=StringHelper.null2String(map.get("taxrate"));//税率
		 String Taxtype=StringHelper.null2String(map.get("taxtype"));//税别
		 String Appliflow=StringHelper.null2String(map.get("appliflow"));//申请单号（包厢、会议）
		 String Productname=StringHelper.null2String(map.get("productname"));//品名
		 String Price=StringHelper.null2String(map.get("price"));//单价
		 String Quantity=StringHelper.null2String(map.get("quantity"));//重量
		 String Amountmoney=StringHelper.null2String(map.get("amountmoney"));//金额
		 String Notaxmoney=StringHelper.null2String(map.get("notaxmoney"));//未税金额
		 String Taxmoney=StringHelper.null2String(map.get("taxmoney"));//税金
		 String Accountres=StringHelper.null2String(map.get("Accountres"));//关联requestid
		 String str="/workflow/request/workflow.jsp?requestid="+Accountres;//配置下面onUrl中的str
         //onUrl(str,'发起考核','tab'+rn) ;
		 //ondblclick="window.open('/workflow/request/workflow.jsp?requestid=')"
		 if(("").equals(Costcenter)){
			String workflowid = ds.getValue("select workflowid from requestbase where id ='"+Accountres+"'");
			if(("2828a86427ace2b50127ad65e2940193").equals(workflowid)){	//会议申请无成本中心
				//System.out.println("Appliflow="+Appliflow +" Costcenter="+Costcenter+" workflowid="+workflowid);
				String newcc = ds.getValue("select h.exttextfield9 from uf_meeting a,humres h where a.creater = h.id and a.requestid='"+Accountres+"'");
				//System.out.println("Appliflow="+Appliflow +" Costcenter="+Costcenter+" workflowid="+workflowid + " newcc="+newcc);
				String upsql = "update uf_oa_fruitaccountchild set costcenter='"+newcc+"' where requestid='"+requestid+"' and Accountres='"+Accountres+"'";
				System.out.println("upsql="+upsql +" Costcenter="+Costcenter+" workflowid="+workflowid + " newcc="+newcc);
				baseJdbc.update(upsql);
			}
		 }
         %>

          <TR id="dataDetail">
		  <TD class="td2" align=center><%=i+1%></TD>
          <TD class="td2" align=center><%=AppliDate%></TD>
          <TD class="td2" align=center><%=Applicant%></TD>
          <TD class="td2" align=center><%=Department%></TD>
          <TD class="td2" align=center><%=Costcenter%></TD>
          <TD class="td2" align=center><%=Accountsubject%></TD>
          <TD class="td2" align=center><%=Taxcode%></TD>
          <TD class="td2" align=center><%=Taxrate%></TD>
          <TD class="td2" align=center><%=Taxtype%></TD>
          <TD class="td2" align=center><a href="javascript:onUrl('<%=str%>','<%=Appliflow%>','<%="tab"+Accountres%>')"><%=Appliflow%></a></TD>
          <TD class="td2" align=center><%=Productname%></TD>
          <TD class="td2" align=center><%=Price%></TD>
          <TD class="td2" align=center><%=Quantity%></TD>
          <TD class="td2" align=center><%=Amountmoney%></TD>
		  <TD class="td2" align=center><%=Notaxmoney%></TD>
		  <TD class="td2" align=center><%=Taxmoney%></TD>
          </TR>
<%	   }
    }
	else{%>
	       <TR class="tr1">
		   <TD class="td1" colspan="16">无对应相关明细！</TD>
		   </TR>
	<%}%>
</TABLE>
</DIV>