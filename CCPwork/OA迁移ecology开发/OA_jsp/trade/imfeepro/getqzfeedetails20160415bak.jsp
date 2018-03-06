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


<%@ page import="java.math.RoundingMode"%>
<%@ page import="java.text.DecimalFormat;"%>






<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String sdate = StringHelper.null2String(request.getParameter("sdate"));//报关起始日期
String edate = StringHelper.null2String(request.getParameter("edate"));//报关结束日期
String supply = StringHelper.null2String(request.getParameter("supply"));//供应商简码

String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码

String currency = StringHelper.null2String(request.getParameter("currency"));//暂估币种

String arrtype = StringHelper.null2String(request.getParameter("arrtype"));//货物类型

String thepsn = StringHelper.null2String(request.getParameter("thepsn"));//暂估经办人

String taxcode = StringHelper.null2String(request.getParameter("taxcode"));//税码

String feetype = StringHelper.null2String(request.getParameter("feetype"));//费用类型

String imgoodnos = StringHelper.null2String(request.getParameter("imgoodnos"));//进口到货编号

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
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="160">
<COL width="120">
<COL width="120">
<COL width="80">
<COL width="120">
<COL width="60">
<COL width="120">
<COL width="60">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>进口到货编号</TD>
<TD  noWrap class="td2"  align=center>进口到货项次</TD>
<TD  noWrap class="td2"  align=center>费用名称</TD>
<TD  noWrap class="td2"  align=center>支付对象</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  align=center>暂估汇率</TD>
<TD  noWrap class="td2"  align=center>暂估本位币金额</TD>
<TD  noWrap class="td2"  align=center>清帐金额</TD>
<TD  noWrap class="td2"  align=center>清帐本位币金额</TD>
<TD  noWrap class="td2"  align=center>业务货币差额</TD>
<TD  noWrap class="td2"  align=center>本位币差额</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>资产号</TD>
<TD  noWrap class="td2"  align=center>内部订单号</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>

</tr>

<%

String sql = "";
String delsql = "delete uf_tr_feeclearsub where requestid = '"+requestid+"'";//删除历史数据
baseJdbc.update(delsql);
/* 2016-04-13 12:21 xxy注释 如会计明细有2种币种则一种币种会选不到
sql = "select b.bkkpingdate,a.requestid as kjrequest,a.imgoodsid,a.imgoodsitem,b.rate as kjmxrate,a.feetype,(select costname from uf_tr_fymcwhd where requestid = a.feetype) as feename,a.paycode,a.currency,a.estimatedmoney,a.rate,a.amount,a.materialid,a.costcenter,a.assetid,a.innerorderid,a.genledger,a.purchaseid,a.purchaseitem from uf_tr_imfeedtsub a  inner join uf_tr_imfeedtmain  b on b.requestid = a.requestid  where a.closedate between '"+sdate+"' and '"+edate+"' and a.paycode = '"+supply+"' and b.comcode = '"+comcode+"' and a.currency = '"+currency+"' and b.arrtype = '"+arrtype+"' and 1=(select isfinished from requestbase where id = b.requestid) and 1<>(select isdelete from requestbase where id = b.requestid ) and (b.isvalid = '40288098276fc2120127704884290210' or b.isvalid is null ) and a.requestid not in(select kjrequest from uf_tr_feeclearsub c where requestid <>'"+requestid+"' and 1<>(select isdelete from requestbase where id = c.requestid) )";
if(!thepsn.equals(""))//如果经办人不为空
{
	sql = sql +" and b.reqman = '"+thepsn+"'";
}
if(!taxcode.equals(""))//如果税码不为空
{
	sql = sql +" and a.taxcode = '"+taxcode+"'";
}
if(!feetype.equals(""))//如果费用类型不为空
{
	sql = sql +" and a.feetype = '"+feetype+"'";
}
if(!imgoodnos.equals(""))//如果进口到货编号的值不为空
{
	sql = sql +" and instr('"+imgoodnos+"',b.imgoodsid)>0";
}
sql = sql +" order by a.imgoodsid asc,a.feetype asc ,a.imgoodsitem asc";

*/

sql = "select * from (select b.bkkpingdate,a.requestid as kjrequest,a.imgoodsid,a.imgoodsitem,b.rate as kjmxrate,a.feetype,(select costname from uf_tr_fymcwhd where requestid = a.feetype) as feename,a.paycode,a.currency,a.estimatedmoney,a.rate,a.amount,a.materialid,a.costcenter,a.assetid,a.innerorderid,a.genledger,a.purchaseid,a.purchaseitem from uf_tr_imfeedtsub a  inner join uf_tr_imfeedtmain  b on b.requestid = a.requestid  where a.closedate between '"+sdate+"' and '"+edate+"' and a.paycode = '"+supply+"' and b.comcode = '"+comcode+"' and a.currency = '"+currency+"' and b.arrtype = '"+arrtype+"' and 1=(select isfinished from requestbase where id = b.requestid) and 1<>(select isdelete from requestbase where id = b.requestid ) and (b.isvalid = '40288098276fc2120127704884290210' or b.isvalid is null ) ";
if(!thepsn.equals(""))//如果经办人不为空
{
	sql = sql +" and b.reqman = '"+thepsn+"'";
}
if(!taxcode.equals(""))//如果税码不为空
{
	sql = sql +" and a.taxcode = '"+taxcode+"'";
}
if(!feetype.equals(""))//如果费用类型不为空
{
	sql = sql +" and a.feetype = '"+feetype+"'";
}
if(!imgoodnos.equals(""))//如果进口到货编号的值不为空
{
	sql = sql +" and instr('"+imgoodnos+"',b.imgoodsid)>0";
}
sql = sql +") v where (select count(*) from uf_tr_feeclearsub c where c.kjrequest=v.kjrequest and c.imgoodsid=v.imgoodsid and c.imgoodsitem=v.imgoodsitem and c.feetype=v.feetype and c.payobject=v.paycode and c.estcurrency=v.currency and c.requestid <>'"+requestid+"' and 1<>(select isdelete from requestbase where id = c.requestid) ) =0 order by v.imgoodsid asc,v.feetype asc ,v.imgoodsitem asc";

System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
//System.out.println("size 为:"+sublist.size());
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		//String theid=StringHelper.null2String(mk.get("id"));
		int m = k;
		int no=m+1;
		String flag = "";
		String kjrequest=StringHelper.null2String(mk.get("kjrequest"));//会计明细对应的requestid
		String imgoodsid=StringHelper.null2String(mk.get("imgoodsid"));//进口货物申请书
		String imgoodsitem=StringHelper.null2String(mk.get("imgoodsitem"));//申请书序号
		String feetypes=StringHelper.null2String(mk.get("feetype"));//费用名称(id)
		String feename=StringHelper.null2String(mk.get("feename"));//费用名称(中文)
		String paycode=StringHelper.null2String(mk.get("paycode"));//支付对象
		String cur=StringHelper.null2String(mk.get("currency"));//币种
		String amount=StringHelper.null2String(mk.get("estimatedmoney"));//暂估金额
		String rate = StringHelper.null2String(mk.get("kjmxrate"));;//汇率
		String bkkpingdate = StringHelper.null2String(mk.get("bkkpingdate"));//记账日期
		if(!cur.equals("RMB"))
		{
		//System.out.println("非RMB抓取汇率");
			//从SAP获取资产分类号
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_FI_EX_RATE";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			function.getImportParameterList().setValue("EXCH_DATE",bkkpingdate);
			function.getImportParameterList().setValue("FROM_CURR",cur);
			function.getImportParameterList().setValue("TO_CURRNCY","RMB");

			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//返回值
			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
			String EXCH_RATE = function.getExportParameterList().getValue("EXCH_RATE").toString();
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();
			rate = EXCH_RATE.replace(" ", "");
			//System.out.println("非RMB对应的汇率为："+rate);
			
		}
		else{
			rate = "1";
		}
		String rmbamount=StringHelper.null2String(mk.get("amount"));//暂估本位币金额
		DecimalFormat    df   = new DecimalFormat("######0.00"); 
		df.setRoundingMode(RoundingMode.HALF_UP);		
		Double qzmon = Double.parseDouble(amount);
		Double qzrmbmon = qzmon*Double.parseDouble(rate);//清帐本位币金额

		rmbamount = Double.toString(qzrmbmon);//暂估本位币金额 

		Double ywhbce = qzmon-Double.parseDouble(amount);//业务货币差额
		Double bwbce = qzrmbmon-Double.parseDouble(rmbamount);//本位币差额

		String materialid=StringHelper.null2String(mk.get("materialid"));//物料号
		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心
		String assetid=StringHelper.null2String(mk.get("assetid"));//资产号
		String innerorderid=StringHelper.null2String(mk.get("innerorderid"));//内部订单号
		String genledger=StringHelper.null2String(mk.get("genledger"));//费用总账科目
		String purchaseid=StringHelper.null2String(mk.get("purchaseid"));//采购订单号
		String purchaseitem=StringHelper.null2String(mk.get("purchaseitem"));//采购订单项次

		String insql = "insert into uf_tr_feeclearsub  (id,requestid,sno,imgoodsid,imgoodsitem,feetype,payobject,estcurrency,estmoney,estrate,estamount,clearmoney,clearamount,buscurrencydiff,currencydiff,materialid,costcenter,assetid,innerorderid,ledgersubject,purorderid,purorderitem,kjrequest)values(";
		//insql = insql +"'"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+imgoodsid+"','"+imgoodsitem+"','"+feetypes+"','"+paycode+"','"+cur+"','"+amount+"','"+rate+"','"+df.format(rmbamount)+"',";
		insql = insql +"'"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+imgoodsid+"','"+imgoodsitem+"','"+feetypes+"','"+paycode+"','"+cur+"','"+amount+"','"+rate+"','"+rmbamount+"',";
		
		insql = insql +"'"+qzmon+"','"+df.format(qzrmbmon)+"','"+df.format(ywhbce)+"','"+df.format(bwbce)+"','"+materialid+"','"+costcenter+"','"+assetid+"','"+innerorderid+"','"+genledger+"','"+purchaseid+"','"+purchaseitem+"','"+kjrequest+"')";
		baseJdbc.update(insql);
		System.out.println(df.format(qzrmbmon));
		//System.out.println(insql);

	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>

		<TD  class="td2"   align=center ><%=imgoodsid %></TD>
		<TD  class="td2"   align=center ><%=imgoodsitem %></TD>

		<TD   class="td2"  align=center><%=feename %></TD>

		<TD   class="td2"  align=center><%=paycode %></TD>
		<TD   class="td2"  align=center><%=currency %></TD>
		<TD   class="td2"  align=center><%=amount %></TD>
		
		<TD   class="td2"  align=center><%=rate %></TD>
		<TD   class="td2"  align=center><%=rmbamount %></TD>

		<TD   class="td2"  align=center><%=qzmon %></TD>
		<TD   class="td2"  align=center><%=df.format(qzrmbmon) %></TD>

		<TD   class="td2"  align=center><%=df.format(ywhbce) %></TD>
		<TD   class="td2"  align=center><%=df.format(bwbce) %></TD>
		
		<TD   class="td2"  align=center><%=materialid %></TD>
		<TD   class="td2"  align=center><%=costcenter %></TD>
		<TD   class="td2"  align=center><%=assetid %></TD>
		<TD   class="td2"  align=center><%=innerorderid %></TD>
		<TD   class="td2"  align=center><%=genledger %></TD>
		<TD   class="td2"  align=center><%=purchaseid %></TD>
		<TD   class="td2"  align=center><%=purchaseitem %></TD>

		</TR>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>