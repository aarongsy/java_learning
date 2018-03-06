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
//String supply = StringHelper.null2String(request.getParameter("supply"));//
//String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//噎榨讗謩薷酄氄杰狄犤?
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//到货类型
String rate = StringHelper.null2String(request.getParameter("rate"));//汇率
String currency = StringHelper.null2String(request.getParameter("currency"));//币种

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
<table id="dataTables3" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
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
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>费用类型</TD>
<TD  noWrap class="td2"  align=center>清帐币种</TD>
<TD  noWrap class="td2"  align=center>清帐汇率</TD>
<TD  noWrap class="td2"  align=center>业务货币差额</TD>
<TD  noWrap class="td2"  align=center>本位币差额</TD>
<TD  noWrap class="td2"  align=center>异常费用金额</TD>
<TD  noWrap class="td2"  align=center>异常费用本位币金额</TD>
<TD  noWrap class="td2"  align=center>增额费用小计</TD>
<TD  noWrap class="td2"  align=center>增额费用本位币小计</TD>

<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>资产号</TD>
<TD  noWrap class="td2"  align=center>内部订单</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>采购订单行项次</TD>
<TD  noWrap class="td2"  align=center>进口到货编号</TD>
<TD  noWrap class="td2"  align=center>进口到货项次</TD>
</tr>

<%
int count=0;
String delsql = "delete uf_tr_feeotherclearsub where requestid = '"+requestid+"'";
baseJdbc.update(delsql);
String sql = "";
if(goodtype.equals("40285a90492d5248014930386c190174"))//如果是物料类
{
	sql = "select a.feetype,(select zzsubjects from uf_tr_fymcwhd where requestid = a.feetype) as subject,(select costname from uf_tr_fymcwhd where requestid = a.feetype) as feename,a.allobase,(select objname from selectitem where id = a.allobase) as ftjs,a.clearnotaxmoney,a.clearcurrmoney,a.invoicetotal,a.invoiceamount,b.materialid,b.costcenter,b.orderid,b.item,(select imgoodsid from uf_tr_lading where requestid = b.requestid) as imgoodsid,b.ladingid ,b.invoicenum,b.invoicemoney  from uf_tr_feeothersub  a inner join uf_tr_materialdt b on b.requestid = a.imgoodsid where a.requestid = '"+requestid+"' order by imgoodsid asc, a.feetype asc ";
}
else if(goodtype.equals("40285a90492d524801493038713c0179"))//如果是设备类
{
	sql = "select a.feetype,(select zzsubjects from uf_tr_fymcwhd where requestid = a.feetype) as subject,(select costname from uf_tr_fymcwhd where requestid = a.feetype) as feename,a.allobase,(select objname from selectitem where id = a.allobase) as ftjs,a.clearnotaxmoney,a.clearcurrmoney,a.invoicetotal,a.invoiceamount,b.assetsid,b.innerorderid,b.costcenter,b.orderid,b.orderitem as item,(select imgoodsid from uf_tr_lading where requestid = b.requestid) as imgoodsid,b.ladingitem as ladingid ,b.invoicenum,b.invoicemoney from uf_tr_feeothersub  a inner join uf_tr_equipmentdt b on b.requestid = a.imgoodsid  where a.requestid = '"+requestid+"' order by imgoodsid asc,a.feetype asc ";
}
else if(goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2"))//如果是物料设备类
{
	sql = "select v.reqid,v.feetype,(select zzsubjects from uf_tr_fymcwhd where requestid = v.feetype) as subject,v.feename,v.allobase,v.ftjs,v.clearnotaxmoney,v.clearcurrmoney,v.invoicetotal,v.invoiceamount,v.materialid,v.assetsid,v.innerorderid,v.costcenter,v.orderid,v.item,v.imgoodsid,v.ladingid,v.invoicenum,v.invoicemoney from v_uf_tr_clearmatrequnion v where v.reqid = '"+requestid+"' order by imgoodsid asc,feetype asc";
}
//System.out.println(sql);
DecimalFormat df=new DecimalFormat(".##");
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称(requestid)

		String feename=StringHelper.null2String(mk.get("feename"));//费用名称(显示名称)

		String allobase = StringHelper.null2String(mk.get("allobase"));//分摊基数
		String ftjs=StringHelper.null2String(mk.get("ftjs"));//分摊基数(中文名称)

		String clearnotaxmoney=StringHelper.null2String(mk.get("clearnotaxmoney"));//清帐未税金额

		String clearcurrmoney=StringHelper.null2String(mk.get("clearcurrmoney"));//清帐本位币金额
		String materialid = "";//物料号
		String assetsid = "";//资产号
		String innerorderid = "";//内部订单号
		if(goodtype.equals("40285a90492d5248014930386c190174") || goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2"))//如果是物料类
		{
			materialid = StringHelper.null2String(mk.get("materialid"));//物料号
		}
		if(goodtype.equals("40285a90492d524801493038713c0179") || goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2"))//如果是设备类
		{
			assetsid = StringHelper.null2String(mk.get("assetsid"));//资产号
			innerorderid = StringHelper.null2String(mk.get("innerorderid"));//内部订单号
		}

		String invoicenum=StringHelper.null2String(mk.get("invoicenum"));//发票数量

		String invoicemoney=StringHelper.null2String(mk.get("invoicemoney"));//发票金额

		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心

		String orderid=StringHelper.null2String(mk.get("orderid"));//采购订单号

		String item=StringHelper.null2String(mk.get("item"));//采购订单行项目

		String imgoodsid=StringHelper.null2String(mk.get("imgoodsid"));//进口到货编号

		String ladingid=StringHelper.null2String(mk.get("ladingid"));//进口到货编号项次
		String invoicetotal=StringHelper.null2String(mk.get("invoicetotal"));//发票总数量

		String invoiceamount=StringHelper.null2String(mk.get("invoiceamount"));//发票总金额

		Double leftmon = 0.00;//剩余异常费用金额
		Double leftrmbmon = 0.00;//剩余异常费用本位币金额
		Double amort = 0.00;//分摊比例
		if(no <sublist.size())//
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//费用名称2(requestid)
			//String imgoodsid2=StringHelper.null2String(mk.get("imgoodsid"));//进口到货编号2

			if(!feetype2.equals(feetype))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				System.out.println("当前行的费用名称与下一行的费用名称不一致");
				String sql2 = "select sum(abnfeemoney) as abnfeemoney,sum(abncurrmoney) as abncurrmoney from uf_tr_feeotherclearsub where requestid = '"+requestid+"' and feetype = '"+feetype+"' and imgoodsid = '"+imgoodsid+"'";
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)//
				{
					Map mk3 = (Map)sublist2.get(0);
					String mon1 = StringHelper.null2String(mk3.get("abnfeemoney"));//已被占用的异常费用金额
					String mon2 = StringHelper.null2String(mk3.get("abncurrmoney"));//已被占用的异常费用本位币金额
					if(mon1.equals("") || mon1 == null )mon1 = "0";
					if(mon2.equals("") || mon2 == null )mon2 = "0";

					leftmon = Double.valueOf(df.format(Double.valueOf(clearnotaxmoney)-Double.valueOf(mon1)));//获取剩余异常费用金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney)-Double.valueOf(mon2)));//获取剩余异常费用本位币金额
					//System.out.println("fentan-"+no+"金额为:"+leftmon);
				}
				else
				{
					
					leftmon = Double.valueOf(clearnotaxmoney);//获取剩余异常费用金额=总金额
					leftrmbmon = Double.valueOf(clearcurrmoney);//获取剩余异常费用本位币金额=总金额
				}
			}
			else //如果下一个费用名称与当前的费用名称一致，则说明当前的费用名称不是最后一个。
			{
				System.out.println("当前行的费用名称与下一行的费用名称一致");
				if(allobase.equals("40285a90497a8f7801497d9670120069"))//按照发票金额进行分摊
				{
					
					 amort = (Double.valueOf(invoicemoney)/Double.valueOf(invoiceamount));
					 System.out.println(amort);
					// leftmon= Double.valueOf(clearnotaxmoney) *amort;//异常费用金额
					leftmon = Double.valueOf(df.format( Double.valueOf(clearnotaxmoney) *amort));//异常费用金额
					 //System.out.println("fentan*"+no+"金额为:"+leftmon);
					 //leftrmbmon = Double.valueOf(clearcurrmoney) *amort;//异常费用本位币金额
					 leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney) *amort));//异常费用本位币金额
				}
				else//按照发票数量进行分摊
				{
					amort = (Double.valueOf(invoicenum)/Double.valueOf(invoicetotal));
					leftmon=Double.valueOf(df.format( Double.valueOf(clearnotaxmoney) *amort));//异常费用金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney) *amort));//暂估本位币金额
					//System.out.println("fentan*"+no+"金额为:"+leftmon);
				}
			}
		}
		else//当前行为最后一行
		{
			String summoney="0";
			String sql3 ="select sum(clearnotaxmoney) clearnotaxmoney from uf_tr_feeothersub where requestid='"+requestid+"'";
			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mks = (Map)sublist3.get(0);
				summoney = StringHelper.null2String(mks.get("clearnotaxmoney"));
			}
			//sql3="select sum(abnfeemoney) as abnfeemoney,sum(abncurrmoney) as abncurrmoney from uf_tr_feeotherclearsub where requestid = '"+requestid+"' and feetype = '"+feetype+"' and imgoodsid = '"+imgoodsid+"'";
			sql3="select sum(abnfeemoney) as abnfeemoney,sum(abncurrmoney) as abncurrmoney from uf_tr_feeotherclearsub where requestid = '"+requestid+"'";

			sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("abnfeemoney"));//已被占用的异常费用金额
				String mon2 = StringHelper.null2String(mk4.get("abncurrmoney"));//已被占用的异常费用本位币金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				leftmon = Double.valueOf(df.format(Double.valueOf(summoney)-Double.valueOf(mon1)));//获取剩余异常费用金额
				leftrmbmon = Double.valueOf(df.format(Double.valueOf(summoney)-Double.valueOf(mon2)));//获取剩余异常费用本位币金额
				//System.out.println("fentan-"+no+"金额为:"+leftmon);
			}
			else
			{
				leftmon =Double.valueOf(clearnotaxmoney);//获取剩余异常费用金额=总金额
				leftrmbmon = Double.valueOf(clearcurrmoney);//获取剩余异常费用本位币金额=总金额
				//System.out.println("fentan-"+no+"金额为:"+leftmon);
			}
		}
		String subject =StringHelper.null2String(mk.get("subject"));//发票数量;//总账科目默认值
count++;
		String insql = "insert into uf_tr_feeotherclearsub (id,requestid,sno,ledgersubject,feetype,currency,rate,buscurrencydiff,currencydiff,abnfeemoney,abncurrmoney,addfeetotal,addfeecurrtotal,materialid,costcenter,assetid,innerorderid,purorderid,purorderitem,imgoodsid,imgoodsitem)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+count+"','"+subject+"','"+feetype+"','"+currency+"','"+rate+"','','','"+leftmon+"','"+leftrmbmon+"','"+leftmon+"','"+leftrmbmon+"','"+materialid+"','"+costcenter+"','"+assetsid+"','"+innerorderid+"','"+orderid+"','"+item+"','"+imgoodsid+"','"+ladingid+"')";
		baseJdbc.update(insql);
		System.out.println(insql);
%>
		<TR id="<%="dataDetail_"+count %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+count %>" name="no"><%=count %></TD>

		<TD  class="td2"   align=center ><%=subject %></TD>
		<TD  class="td2"   align=center ><%=feename %></TD>

		<TD   class="td2"  align=center><%=currency %></TD>

		<TD   class="td2"  align=center><%=rate %></TD>
		<TD   class="td2"  align=center></TD>
		<TD   class="td2"  align=center></TD>
		
		<TD   class="td2"  align=center><%=leftmon %></TD>
		<TD   class="td2"  align=center><%=leftrmbmon %></TD>

		<TD   class="td2"  align=center><%=leftmon %></TD>

		<TD  class="td2"   align=center ><%=leftrmbmon %></TD>
		<TD  class="td2"   align=center ><%=materialid %></TD>

		<TD   class="td2"  align=center><%=costcenter %></TD>

		<TD   class="td2"  align=center><%=assetsid %></TD>

		<TD   class="td2"  align=center><%=innerorderid %></TD>

		<TD   class="td2"  align=center><%=orderid %></TD>
		
		<TD   class="td2"  align=center><%=item %></TD>
		<TD   class="td2"  align=center><%=imgoodsid %></TD>

		<TD   class="td2"  align=center><%=ladingid %></TD>
		</TR>
	<%
	}
}
//清账明细
	sql = "select e.requestid,a.ledgersubject,a.feetype,(select costname from uf_tr_fymcwhd where requestid = a.feetype) as feename,(select sharebase from  uf_tr_fymcwhd where requestid=a.feetype) allobase,a.buscurrencydiff,a.currencydiff,b.materialid,b.costcenter,b.orderid,b.item,(select imgoodsid from uf_tr_lading where requestid = b.requestid) as imgoodsid,b.ladingid ,b.invoicenum,b.invoicemoney  from uf_tr_feeclearsub a inner join uf_tr_lading e on a.imgoodsid=e.imgoodsid inner join (select c.requestid,c.assetsid,c.innerorderid,'' as materialid,c.costcenter,c.orderid,c.orderitem as item,c.ladingitem as ladingid ,c.invoicenum,c.invoicemoney from uf_tr_equipmentdt c  union all select d.requestid,'' assetsid,'' innerorderid,d.materialid,d.costcenter,d.orderid,d.item,d.ladingid ,d.invoicenum,d.invoicemoney from uf_tr_materialdt d ) b on b.requestid = e.requestid  where a.requestid = '"+requestid+"' and a.buscurrencydiff is not null and a.buscurrencydiff<>0 order by a.imgoodsid asc, a.feetype asc ";

System.out.println(sql);
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String ledgersubject=StringHelper.null2String(mk.get("ledgersubject"));//总账科目
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称(requestid)
		String tdrequestid=StringHelper.null2String(mk.get("requestid"));

		String feename=StringHelper.null2String(mk.get("feename"));//费用名称(显示名称)

		String allobase = StringHelper.null2String(mk.get("allobase"));//分摊基数
		//String ftjs=StringHelper.null2String(mk.get("ftjs"));//分摊基数(中文名称)

		String clearnotaxmoney=StringHelper.null2String(mk.get("buscurrencydiff"));//业务货币差额

		String clearcurrmoney=StringHelper.null2String(mk.get("currencydiff"));//本位币差额
		String materialid = "";//物料号
		String assetsid = "";//资产号
		String innerorderid = "";//内部订单号
		if(goodtype.equals("40285a90492d5248014930386c190174") || goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2"))//如果是物料类
		{
			materialid = StringHelper.null2String(mk.get("materialid"));//物料号
		}
		if(goodtype.equals("40285a90492d524801493038713c0179") || goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2"))//如果是设备类
		{
			assetsid = StringHelper.null2String(mk.get("assetsid"));//资产号
			innerorderid = StringHelper.null2String(mk.get("innerorderid"));//内部订单号
		}

		String invoicenum=StringHelper.null2String(mk.get("invoicenum"));//发票数量

		String invoicemoney=StringHelper.null2String(mk.get("invoicemoney"));//发票金额

		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心

		String orderid=StringHelper.null2String(mk.get("orderid"));//采购订单号

		String item=StringHelper.null2String(mk.get("item"));//采购订单行项目

		String imgoodsid=StringHelper.null2String(mk.get("imgoodsid"));//进口到货编号

		String ladingid=StringHelper.null2String(mk.get("ladingid"));//进口到货编号项次
		String invoicetotal="0";//发票总数量

		String invoiceamount="0";//发票总金额
		String sql1="select sum (invoicenum) invoicenum,sum(invoicemoney) invoicemoney from (select c.invoicenum,c.invoicemoney from uf_tr_equipmentdt c where c.requestid='"+tdrequestid+"' union all select d.invoicenum,d.invoicemoney from uf_tr_materialdt d where d.requestid='"+tdrequestid+"') b";
		List list = baseJdbc.executeSqlForList(sql1);
		if(list.size()>0){
			Map map = (Map)list.get(0);
			invoicetotal=StringHelper.null2String(map.get("invoicenum"));
			invoiceamount=StringHelper.null2String(map.get("invoicemoney"));
		}

		Double leftmon = 0.00;//剩余异常费用金额
		Double leftrmbmon = 0.00;//剩余异常费用本位币金额
		Double amort = 0.00;//分摊比例
		String amount="0";
		if(no <sublist.size())//
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//费用名称2(requestid)
			//String imgoodsid2=StringHelper.null2String(mk.get("imgoodsid"));//进口到货编号2
			String sql6="select sum(a.buscurrencydiff) buscurrencydiff,sum(a.currencydiff) currencydiff from  uf_tr_feeclearsub a where a.requestid='"+requestid+"' and a.feetype = '"+feetype+"' and a.buscurrencydiff is not null and a.buscurrencydiff<>0";
			List sublist6 = baseJdbc.executeSqlForList(sql6);
			if(sublist6.size()>0)
			{
				Map mk6 = (Map)sublist6.get(0);
				amount = StringHelper.null2String(mk6.get("buscurrencydiff"));//业务货币差额
				if(amount.equals("") || amount == null )amount = "0";
			}
			if(!feetype2.equals(feetype))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{

				System.out.println("当前行的费用名称与下一行的费用名称不一致");

				String sql2 = "select sum(buscurrencydiff) as abnfeemoney,sum(currencydiff) as abncurrmoney from uf_tr_feeotherclearsub where requestid = '"+requestid+"' and feetype = '"+feetype+"' ";
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)//
				{
					Map mk3 = (Map)sublist2.get(0);
					String mon1 = StringHelper.null2String(mk3.get("abnfeemoney"));//已被占用的异常费用金额
					String mon2 = StringHelper.null2String(mk3.get("abncurrmoney"));//已被占用的异常费用本位币金额
					if(mon1.equals("") || mon1 == null )mon1 = "0";
					if(mon2.equals("") || mon2 == null )mon2 = "0";

					leftmon = Double.valueOf(df.format(Double.valueOf(amount)-Double.valueOf(mon1)));//获取剩余异常费用金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(amount)*Double.valueOf(rate)-Double.valueOf(mon2)));//获取剩余异常费用本位币金额
					//System.out.println("fentan-"+no+"金额为:"+leftmon);
				}
				else
				{
					
					leftmon = Double.valueOf(amount);//获取剩余异常费用金额=总金额
					leftrmbmon =Double.valueOf(amount)*Double.valueOf(rate);//获取剩余异常费用本位币金额=总金额
				}
			}
			else //如果下一个费用名称与当前的费用名称一致，则说明当前的费用名称不是最后一个。
			{
				System.out.println("当前行的费用名称与下一行的费用名称一致");

				if(allobase.equals("40285a90497a8f7801497d9670120069"))//按照发票金额进行分摊
				{
					
					 amort = (Double.valueOf(invoicemoney)/Double.valueOf(invoiceamount));
					 System.out.println(amort);
					// leftmon= Double.valueOf(clearnotaxmoney) *amort;//异常费用金额
					leftmon = Double.valueOf(df.format( Double.valueOf(clearnotaxmoney) *amort));//异常费用金额
					 //System.out.println("fentan*"+no+"金额为:"+leftmon);
					 //leftrmbmon = Double.valueOf(clearcurrmoney) *amort;//异常费用本位币金额
					 leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney) *amort));//异常费用本位币金额
				}
				else//按照发票数量进行分摊
				{
					amort = (Double.valueOf(invoicenum)/Double.valueOf(invoicetotal));
					leftmon=Double.valueOf(df.format( Double.valueOf(clearnotaxmoney) *amort));//异常费用金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney) *amort));//暂估本位币金额
					//System.out.println("fentan*"+no+"金额为:"+leftmon);
				}
			}
		}
		else//当前行为最后一行
		{
			String sql6="select sum(a.buscurrencydiff) buscurrencydiff,sum(a.currencydiff) currencydiff from  uf_tr_feeclearsub a where a.requestid='"+requestid+"' and a.feetype = '"+feetype+"' and a.buscurrencydiff is not null and a.buscurrencydiff<>0";
			List sublist6 = baseJdbc.executeSqlForList(sql6);
			if(sublist6.size()>0)
			{
				Map mk6 = (Map)sublist6.get(0);
				amount = StringHelper.null2String(mk6.get("buscurrencydiff"));//业务货币差额
				if(amount.equals("") || amount == null )amount = "0";
			}
			String sql3 = "select sum(buscurrencydiff) as abnfeemoney,sum(currencydiff) as abncurrmoney from uf_tr_feeotherclearsub where requestid = '"+requestid+"' and feetype = '"+feetype+"'";

			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("abnfeemoney"));//已被占用的异常费用金额
				String mon2 = StringHelper.null2String(mk4.get("abncurrmoney"));//已被占用的异常费用本位币金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				leftmon = Double.valueOf(df.format(Double.valueOf(amount)-Double.valueOf(mon1)));//获取剩余异常费用金额
				leftrmbmon = Double.valueOf(df.format(Double.valueOf(amount)*Double.valueOf(rate)-Double.valueOf(mon2)));//获取剩余异常费用本位币金额
				//System.out.println("fentan-"+no+"金额为:"+leftmon);
			}
			else
			{
				leftmon =Double.valueOf(amount);//获取剩余异常费用金额=总金额
				leftrmbmon = Double.valueOf(amount)*Double.valueOf(rate);//获取剩余异常费用本位币金额=总金额
				//System.out.println("fentan-"+no+"金额为:"+leftmon);
			}
		}

		count++;
		String insql = "insert into uf_tr_feeotherclearsub (id,requestid,sno,ledgersubject,feetype,currency,rate,buscurrencydiff,currencydiff,abnfeemoney,abncurrmoney,addfeetotal,addfeecurrtotal,materialid,costcenter,assetid,innerorderid,purorderid,purorderitem,imgoodsid,imgoodsitem)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+count+"','"+ledgersubject+"','"+feetype+"','"+currency+"','"+rate+"','"+leftmon+"','"+leftrmbmon+"','','','"+leftmon+"','"+leftrmbmon+"','"+materialid+"','"+costcenter+"','"+assetsid+"','"+innerorderid+"','"+orderid+"','"+item+"','"+imgoodsid+"','"+ladingid+"')";
		baseJdbc.update(insql);
		System.out.println(insql);
%>
		<TR id="<%="dataDetail_"+count %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+count %>" name="no"><%=count %></TD>

		<TD  class="td2"   align=center ><%=ledgersubject %></TD>
		<TD  class="td2"   align=center ><%=feename %></TD>

		<TD   class="td2"  align=center><%=currency %></TD>

		<TD   class="td2"  align=center><%=rate %></TD>
		
		<TD   class="td2"  align=center><%=leftmon %></TD>
		<TD   class="td2"  align=center><%=leftrmbmon %></TD>

		<TD   class="td2"  align=center></TD>
		<TD   class="td2"  align=center></TD>

		<TD   class="td2"  align=center><%=leftmon %></TD>

		<TD  class="td2"   align=center ><%=leftrmbmon %></TD>
		<TD  class="td2"   align=center ><%=materialid %></TD>

		<TD   class="td2"  align=center><%=costcenter %></TD>

		<TD   class="td2"  align=center><%=assetsid %></TD>

		<TD   class="td2"  align=center><%=innerorderid %></TD>

		<TD   class="td2"  align=center><%=orderid %></TD>
		
		<TD   class="td2"  align=center><%=item %></TD>
		<TD   class="td2"  align=center><%=imgoodsid %></TD>

		<TD   class="td2"  align=center><%=ladingid %></TD>
		</TR>
	<%
	}
}
%>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  