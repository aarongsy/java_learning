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

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String supply = StringHelper.null2String(request.getParameter("supply"));//
String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//噎榨讗謩薷酄氄杰狄犤?
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//噎榨讗謩战艿`褝

BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="60">
<COL width="120">
<COL width="60">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="80">
<COL width="80">
<COL width="120">
<COL width="120">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>记账码</TD>
<TD  noWrap class="td2"  align=center>科目</TD>
<TD  noWrap class="td2"  align=center>税码</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>采购订单</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>
<TD  noWrap class="td2"  align=center>文本</TD>
</tr>

<%
String delsql = "delete uf_tr_imfeedtitem where requestid = '"+requestid+"'";
baseJdbc.update(delsql);

String sql = "select sno,feetype,(select  costname from uf_tr_fymcwhd   where requestid = feetype) as costname,bkkpingcode,paycode,genledger,zgledger,closedate,currency,rate,estimatedmoney,amount,materialid,costcenter,assetid,innerorderid,purchaseid,purchaseitem,imgoodsid,imgoodsitem,taxcode,zgledger from uf_tr_imfeedtsub where requestid = '"+requestid+"'";
List sublist = baseJdbc.executeSqlForList(sql);
int sum = 0;
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		sum = sum +1;
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称(requestid)
		String costname=StringHelper.null2String(mk.get("costname"));//费用名称(显示名称)
		String jzcode = StringHelper.null2String(mk.get("bkkpingcode"));//记账码
		String payto=StringHelper.null2String(mk.get("paycode"));//支付对象()
		String ledaccount=StringHelper.null2String(mk.get("genledger"));//费用总账科目
		String zgledger=StringHelper.null2String(mk.get("zgledger"));//暂估总账科目
		String cur=StringHelper.null2String(mk.get("currency"));//币种
		String amount=StringHelper.null2String(mk.get("estimatedmoney"));//暂估金额
		String rmbamount=StringHelper.null2String(mk.get("amount"));//暂估本位币金额

		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心
		String orderid=StringHelper.null2String(mk.get("purchaseid"));//采购订单号
		String item=StringHelper.null2String(mk.get("purchaseitem"));//采购订单项次
		String imlistid=StringHelper.null2String(mk.get("imgoodsid"));//进口货物申请书
		String imlistno=StringHelper.null2String(mk.get("imgoodsitem"));//申请书序号
		String thedate =StringHelper.null2String(mk.get("closedate"));//报关日期
		String rate = StringHelper.null2String(mk.get("rate"));;//汇率

		String materialid=StringHelper.null2String(mk.get("materialid"));//物料号
		String taxcode = StringHelper.null2String(mk.get("taxcode"));//默认税码

		String assetsid= StringHelper.null2String(mk.get("assetid"));//资产号
		String innerorderid = StringHelper.null2String(mk.get("innerorderid"));//内部订单号
		String text = "";
		if(!materialid.equals(""))//物料号不为空
		{
			text = costname;
		}
		else
		{
			text = costname+"/"+assetsid;
		}
		String flag = cur+"_"+taxcode;//标识

		String insql = "insert into uf_tr_imfeedtitem (id,requestid,sno,accountcode,subject,taxcode,estamount,estcurrency,costcenter,purorder,purorderitem,text1,flag)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+sum+"','40','"+ledaccount+"','"+taxcode+"','"+amount+"','"+cur+"','"+costcenter+"','"+orderid+"','"+item+"','"+text+"','"+flag+"')";
		baseJdbc.update(insql);
		sum = sum+1;
		insql = "insert into uf_tr_imfeedtitem (id,requestid,sno,accountcode,subject,taxcode,estamount,estcurrency,costcenter,purorder,purorderitem,text1,flag)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+sum+"','50','"+zgledger+"','','"+amount+"','"+cur+"','"+costcenter+"','"+orderid+"','"+item+"','"+text+"','"+flag+"')";
		baseJdbc.update(insql);
		//System.out.println(insql);
	}
}

String sql2 = " select sno,accountcode,subject,taxcode,estamount,estcurrency,costcenter,purorder,purorderitem,text1,flag from uf_tr_imfeedtitem where requestid = '"+requestid+"' order by sno asc";
List sublist2 = baseJdbc.executeSqlForList(sql2);
if(sublist2.size()>0){
	for(int k=0,sizek=sublist2.size();k<sizek;k++){
		Map mk = (Map)sublist2.get(k);
		int m = k;
		int no=m+1;
		String accountcode = StringHelper.null2String(mk.get("accountcode"));//记账码
		String subject=StringHelper.null2String(mk.get("subject"));//总账科目
		String taxcode=StringHelper.null2String(mk.get("taxcode"));//税码
		String estamount=StringHelper.null2String(mk.get("estamount"));//暂估金额
		String estcurrency=StringHelper.null2String(mk.get("estcurrency"));//暂估币种

		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心

		String purorder=StringHelper.null2String(mk.get("purorder"));//采购订单号
		String purorderitem=StringHelper.null2String(mk.get("purorderitem"));//采购订单项次


		String text1=StringHelper.null2String(mk.get("text1"));//文本
		String flag=StringHelper.null2String(mk.get("flag"));//标识

	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>

		<TD  class="td2"   align=center ><%=accountcode %></TD>
		<TD  class="td2"   align=center ><%=subject %></TD>

		<TD   class="td2"  align=center><%=taxcode %></TD>

		<TD   class="td2"  align=center><%=estamount %></TD>
		<TD   class="td2"  align=center><%=estcurrency %></TD>
		<TD   class="td2"  align=center><%=costcenter %></TD>
		
		<TD   class="td2"  align=center><%=purorder %></TD>
		<TD   class="td2"  align=center><%=purorderitem %></TD>

		<TD   class="td2"  align=center><%=text1 %></TD>
		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>
