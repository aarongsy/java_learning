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
String comtype = StringHelper.null2String(request.getParameter("comtype"));//厂区别
//String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//噎榨讗謩薷酄氄杰狄犤?
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//到货类型
String zgdiff = StringHelper.null2String(request.getParameter("zgdiff"));//暂估差异
String zgsubject = StringHelper.null2String(request.getParameter("zgsubject"));//暂估差异总帐科目
String TaxName = StringHelper.null2String(request.getParameter("taxcode"));//税码

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
<table id="dataTables4" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
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
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>记帐码</TD>
<TD  noWrap class="td2"  align=center>科目</TD>
<TD  noWrap class="td2"  align=center>金额</TD>
<TD  noWrap class="td2"  align=center>付款条件</TD>
<TD  noWrap class="td2"  align=center>付款基准日期</TD>
<TD  noWrap class="td2"  align=center>付款冻结</TD>
<TD  noWrap class="td2"  align=center>付款方式</TD>
<TD  noWrap class="td2"  align=center>支付货币</TD>
<TD  noWrap class="td2"  align=center>支付货币金额</TD>
<TD  noWrap class="td2"  align=center>税码</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>

<TD  noWrap class="td2"  align=center>采购订单</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>
<TD  noWrap class="td2"  align=center>合作银行类型</TD>
<TD  noWrap class="td2"  align=center>文本</TD>

</tr>

<%
String delsql = "delete uf_tr_feereceiptinfo where requestid = '"+requestid+"'";
baseJdbc.update(delsql);
String sql = "select a.suppliercode,a.invoicemoney,a.taxamount,a.estdiff,a.estdiffledgersubject,a.estdiffcostcenter,(select terms from uf_tr_payment where requestid=a.payitem) as payterm,a.paybasedate,a.freezeup,a.paytype,(select objdesc from selectitem where id = a.paytype) as payment,a.paycurrency,a.payamount,a.banktype,a.cleartaxcode,(select taxcode from uf_oa_taxcode where requestid =a.taxcode) as taxname,b.materialid,b.assetid  from uf_tr_feeclearmain a ,uf_tr_feeclearsub b  where a.requestid = b.requestid and a.requestid = '"+requestid+"' and b.sno = '1'";
List sublist = baseJdbc.executeSqlForList(sql);
System.out.println(sublist.size());
if(sublist.size()>0){
	Map mk = (Map)sublist.get(0);
	String suppliercode = StringHelper.null2String(mk.get("suppliercode"));//供应商简码
	String invoicemoney = StringHelper.null2String(mk.get("invoicemoney"));//发票金额
	String payterm = StringHelper.null2String(mk.get("payterm"));//付款条款
	String paybasedate = StringHelper.null2String(mk.get("paybasedate"));//付款基准日期
	String freezeup = StringHelper.null2String(mk.get("freezeup"));//付款冻结
	String payment = StringHelper.null2String(mk.get("payment"));//付款方式
	String paycurrency = StringHelper.null2String(mk.get("paycurrency"));//支付货币
	String payamount = StringHelper.null2String(mk.get("payamount"));//支付货币金额
	if(payamount.equals("0")||payamount.equals("0.00")||payamount.equals(""))
	{
		payamount="null";
	}
	String banktype = StringHelper.null2String(mk.get("banktype"));//合作银行类型
	String materialid = StringHelper.null2String(mk.get("materialid"));//物料号
	String assetid = StringHelper.null2String(mk.get("assetid"));//资产号
	String taxcode = StringHelper.null2String(mk.get("taxname"));//税码
	String cleartaxcode = StringHelper.null2String(mk.get("cleartaxcode"));//清帐明细税码
	String text = "";
	int no = 0;
	String jzcode = "";
	if(goodtype.equals("40285a90492d5248014930386c190174"))//如果是物料类
	{
		text = materialid+"进口费用";
	}
	else
	{
		text = assetid+"进口费用";
	}
	if(freezeup.equals(""))
	{
		freezeup = "A";
	}
	String fpsql = "select invoiceno,invoicemoney,paymoney from uf_tr_feeinvoiceinfo where requestid = '"+requestid+"'";
	List fplist = baseJdbc.executeSqlForList(fpsql);
	if(fplist.size()>0)
	{
		for(int f=0;f<fplist.size();f++)
		{
			Map fpmap = (Map)fplist.get(f);
			String fpno = StringHelper.null2String(fpmap.get("invoiceno"));//发票号码
			String fpmon = StringHelper.null2String(fpmap.get("invoicemoney"));//发票金额
			String fpcurmon = StringHelper.null2String(fpmap.get("paymoney"));//实际支付货币金额
			if(fpcurmon.equals("0")||fpcurmon.equals("0.00")||fpcurmon.equals(""))
			{
				fpcurmon="null";
			}
			no = no+1;
			jzcode = "31";
			//添加31行项目
			String insql = "insert into uf_tr_feereceiptinfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+suppliercode+"','"+fpmon+"','"+payterm+"','"+paybasedate+"','"+freezeup+"','"+payment+"','"+paycurrency+"',"+fpcurmon+",'','','','','"+banktype+"','"+text+"')";
			baseJdbc.update(insql);
		}
	}
	String estdiff = StringHelper.null2String(mk.get("estdiff"));//暂估差异
	String estdiffledgersubject = StringHelper.null2String(mk.get("estdiffledgersubject"));//暂估差异总账科目
	String estdiffcostcenter = StringHelper.null2String(mk.get("estdiffcostcenter"));//暂估差异成本中心
	Double val = 0.00;
	
	if(Double.valueOf(zgdiff) >0)//如果暂估差异大于0
	{
		val = Double.valueOf(zgdiff);
		jzcode = "40";
	}
	else if(Double.valueOf(zgdiff) <0)
	{
		val = Math.abs(Double.valueOf(zgdiff));//暂估差异的绝对值
		jzcode = "50";
	}
	if(val >0)//添加暂估差异不为0行
	{
		no = no+1;
		text = "角分差";
		estdiffledgersubject = zgsubject;//暂估差异总帐科目
		String insql = "insert into uf_tr_feereceiptinfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+estdiffledgersubject+"','"+val+"','','','','','','','"+TaxName+"','"+estdiffcostcenter+"','','','','"+text+"')";
		baseJdbc.update(insql);
	}

	String invsql = "select invoiceno,tax from uf_tr_feeinvoiceinfo   where requestid = '"+requestid+"'";//查询发票信息
	List sublist2 = baseJdbc.executeSqlForList(invsql);
	if(sublist2.size() >0)
	{
		for(int i = 0;i<sublist2.size();i++)
		{
			Map m2 = (Map)sublist2.get(i);
			String invoiceno = StringHelper.null2String(m2.get("invoiceno"));//发票号码
			String tax = StringHelper.null2String(m2.get("tax"));//税额
			if(Double.valueOf(tax) >0)
			{
				no = no+1;
				String subject = "21710101";//默认总账科目
				String subsql = "select zzsubjects from uf_tr_fymcwhd   where factype = '"+comtype+"' and importandexport = '40285a90497a8f7801497d7b4cbd0031' and cargo = '"+goodtype+"' and costname = '增值税'";
				List sublist1 = baseJdbc.executeSqlForList(subsql);

				if(sublist1.size()>0)
				{
					Map m1 = (Map)sublist1.get(0);
					subject = StringHelper.null2String(m1.get("zzsubjects"));//费用科目
				}
				text = "增值税"+invoiceno;
				jzcode = "40";
				String insql = "insert into uf_tr_feereceiptinfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+subject+"','"+tax+"','','','','','','','"+TaxName+"','','','','','"+text+"')";
				baseJdbc.update(insql);

			}
		}
	}

	String osql = "select ledgersubject,currency,feetype,(select costname from uf_tr_fymcwhd where requestid = feetype) as feename,addfeetotal,addfeecurrtotal,costcenter,purorderid,purorderitem from uf_tr_feeotherclearsub  where requestid = '"+requestid+"'";
	System.out.println(osql);
	List sublist3 = baseJdbc.executeSqlForList(osql);
	if(sublist3.size() >0)
	{
		//System.out.println(sublist3.size());
		for(int m = 0;m<sublist3.size();m++)
		{
			Map m3 = (Map)sublist3.get(m);

			String ledgersubject = StringHelper.null2String(m3.get("ledgersubject"));//总账科目
			String feename = StringHelper.null2String(m3.get("feename"));//费用名称
			String addfeetotal = StringHelper.null2String(m3.get("addfeetotal"));//增额费用小计
			String addfeecurrtotal = StringHelper.null2String(m3.get("addfeecurrtotal"));//增额费用本位币小计
			String costcenter = StringHelper.null2String(m3.get("costcenter"));//成本中心
			String purorderid = StringHelper.null2String(m3.get("purorderid"));//采购订单号
			String purorderitem = StringHelper.null2String(m3.get("purorderitem"));//采购订单项次
			String currency = StringHelper.null2String(m3.get("currency"));//币种
			Double abnfee = 0.00;
			if(currency.equals("RMB"))
			{
				abnfee = Math.abs(Double.valueOf(addfeetotal));//增额费用小计
			}
			else
			{
				abnfee = Math.abs(Double.valueOf(addfeecurrtotal));//增额费用本位币小计
			}
			if(Double.valueOf(addfeetotal) >0)
			{
				jzcode = "40";
			}
			if(Double.valueOf(addfeetotal) <0)
			{
				jzcode = "50";
			}
			if(abnfee >0)
			{
				no = no+1;//序号
				text = feename;
				String insql = "insert into uf_tr_feereceiptinfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+ledgersubject+"','"+abnfee+"','','','','','','','"+TaxName+"','"+costcenter+"','"+purorderid+"','"+purorderitem+"','','"+text+"')";
				baseJdbc.update(insql);
			}
			
		}
	}
}

	//查询数据并显示
	String selsql = "select sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1 from uf_tr_feereceiptinfo where requestid = '"+requestid+"' order by sno asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String sno = StringHelper.null2String(m4.get("sno"));
			String accountcode = StringHelper.null2String(m4.get("accountcode"));
			String subject = StringHelper.null2String(m4.get("subject"));
			String money = StringHelper.null2String(m4.get("money"));
			String payitem = StringHelper.null2String(m4.get("payitem"));
			String paydate = StringHelper.null2String(m4.get("paydate"));
			String payfreeze = StringHelper.null2String(m4.get("payfreeze"));
			String paytype = StringHelper.null2String(m4.get("paytype"));
			String currency = StringHelper.null2String(m4.get("currency"));
			String paymoney = StringHelper.null2String(m4.get("paymoney"));
			String taxcaode = StringHelper.null2String(m4.get("taxcaode"));
			String costcenter = StringHelper.null2String(m4.get("costcenter"));
			String purorderid = StringHelper.null2String(m4.get("purorderid"));
			String purorderitem = StringHelper.null2String(m4.get("purorderitem"));
			String banktype = StringHelper.null2String(m4.get("banktype"));
			String text1 = StringHelper.null2String(m4.get("text1"));

%>
		<TR id="<%="dataDetail_"+sno %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+sno %>" name="sno"><%=sno %></TD>

		<TD  class="td2"   align=center ><%=accountcode %></TD>
		<TD  class="td2"   align=center ><%=subject %></TD>

		<TD   class="td2"  align=center><%=money %></TD>

		<TD   class="td2"  align=center><%=payitem %></TD>
		
		<TD   class="td2"  align=center><%=paydate %></TD>
		<TD   class="td2"  align=center><%=payfreeze %></TD>

		<TD   class="td2"  align=center><%=paytype %></TD>

		<TD  class="td2"   align=center ><%=currency %></TD>
		<TD  class="td2"   align=center ><%=paymoney %></TD>

		<TD   class="td2"  align=center><%=taxcaode %></TD>

		<TD   class="td2"  align=center><%=costcenter %></TD>

		<TD   class="td2"  align=center><%=purorderid %></TD>

		<TD   class="td2"  align=center><%=purorderitem %></TD>
		
		<TD   class="td2"  align=center><%=banktype %></TD>
		<TD   class="td2"  align=center><input type="text" value="<%=text1 %>" id="<%="input_"+sno %>" onblur="changetext('<%=sno%>')"></TD>

		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>
