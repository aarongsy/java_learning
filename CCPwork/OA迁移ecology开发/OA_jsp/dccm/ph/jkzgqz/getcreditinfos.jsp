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
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
//String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

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


<div id="warpp"  >
<table id="dataTables4" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=100>
<COL width=140>
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>Serial Number</TD>
<TD  noWrap class="td2"  align=center>Subject</TD>
<TD  noWrap class="td2"  align=center>Amount</TD>
<TD  noWrap class="td2"  align=center>Payment Term</TD>
<TD  noWrap class="td2"  align=center>Payment Date</TD>
<TD  noWrap class="td2"  align=center>Payment Frozen</TD>
<TD  noWrap class="td2"  align=center>Payment Method</TD>
<TD  noWrap class="td2"  align=center>Payment Currency</TD>
<TD  noWrap class="td2"  align=center>Payment Amount</TD>
<TD  noWrap class="td2"  align=center>TaxBase</TD>
<TD  noWrap class="td2"  align=center>Tax Code</TD>
<TD  noWrap class="td2"  align=center>Cost Center</TD>
<TD  noWrap class="td2"  align=center>Purchase Order</TD>
<TD  noWrap class="td2"  align=center>Order Item</TD>
<TD  noWrap class="td2"  align=center>Cooperative Bank</TD>
<TD  noWrap class="td2"  align=center>Text</TD>
</TR>

<%
//清空凭证行项目信息
String delsql = "delete uf_dmph_dlineiteminfo where requestid = '"+requestid+"'";
baseJdbc.update(delsql);


/*String sql = "select (select payobject from v_dmph_payobj where requestid=a.suppliercode)suppliercode,a.invoicemoney,a.taxamount,a.estdiff,a.estdiffledgersubject,a.estdiffcostcenter,(select code from uf_dmdb_payterm where requestid=a.payitem) as payterm,a.paybasedate,a.freezeup,a.paytype,(select objdesc from selectitem where id = a.paytype) as payment,a.paycurrency,a.payamount,a.banktype,a.cleartaxcode,(select tax from uf_dmsd_taxwh where requestid=taxcode)taxname,b.materialid,b.assetid,b.purorderid,b.purorderitem  from uf_dmph_importchargemain a ,uf_dmph_iccdetail b  where a.requestid = b.requestid and a.requestid = '"+requestid+"' and b.sno = '1'";

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
	String materialid = StringHelper.null2String(mk.get("purorderid"));//物料号
	String assetid = StringHelper.null2String(mk.get("purorderitem"));//资产号
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
	String fpsql = "select invoiceno,invoicemoney,paymoney from uf_dmph_iciinfo where requestid = '"+requestid+"'";
	System.out.println("xxxxxxxxxxxxxxxxxxxxxx3");
	List fplist = baseJdbc.executeSqlForList(fpsql);
	if(fplist.size()>0)
	{
		for(int f=0;f<fplist.size();f++)
		{
			Map fpmap = (Map)fplist.get(f);
			String fpno = StringHelper.null2String(fpmap.get("invoiceno"));//发票号码
			String fpmon = StringHelper.null2String(fpmap.get("invoicemoney"));//发票金额
			String fpcurmon = StringHelper.null2String(fpmap.get("paymoney"));//实际支付货币金额
			//if(fpcurmon.equals("0")||fpcurmon.equals("0.00")||fpcurmon.equals(""))
			//{
				//fpcurmon="null";
			//}
			if(fpcurmon.equals("")||fpcurmon.equals("null")||fpcurmon.equals(null))
			{
				fpcurmon="0";
			}
			no = no+1;
			jzcode = "31";
			//添加31行项目
			String insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+suppliercode+"','"+fpmon+"','"+payterm+"','"+paybasedate+"','"+freezeup+"','"+payment+"','"+paycurrency+"',"+fpcurmon+",'','','','','"+banktype+"','"+text+"')";
			System.out.println("xxxxxxxxxxxxxxxxxxxxxx4");
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
		//String sqlquery="select * from where requestid='"+requestid+"'";
		String insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+estdiffledgersubject+"','"+val+"','','','','','','','"+taxcode+"','"+estdiffcostcenter+"','"+materialid+"','"+assetid+"','','"+text+"')";
		System.out.println("xxxxxxxxxxxxxxxxxxxxxx5");
		baseJdbc.update(insql);
	}

	
	
	
	String invsql = "select invoiceno,tax from uf_dmph_iciinfo   where requestid = '"+requestid+"'";//查询发票信息
	System.out.println("xxxxxxxxxxxxxxxxxxxxxx6");
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
				//String subsql = "select general from uf_dmph_maintenance where factory = '"+comtype+"'";//(uf_dmph_maintenance此表不存在)
				//List sublist1 = baseJdbc.executeSqlForList(subsql);
				//if(sublist1.size()>0)
				//{
					//Map m1 = (Map)sublist1.get(0);
					//subject = StringHelper.null2String(m1.get("general"));//费用科目
				//}
				text = "增值税"+invoiceno;
				jzcode = "40";
				String insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+subject+"','"+tax+"','','','','','','','"+taxcode+"','','','','','"+text+"')";
				baseJdbc.update(insql);

			}
		}
	}

	
	
	String osql = "select ledgersubject,currency,feetype,(select feename from uf_dmdb_feename where requestid = feetype) as feename,addfeetotal,addfeecurrtotal,costcenter,purorderid,purorderitem from uf_dmph_ecicoecadetails  where requestid = '"+requestid+"'";
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
			//String currency = StringHelper.null2String(m3.get("currency"));//币种
			Double abnfee = 0.00;
			if(currency.equals(zgcurr))
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
				String insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+jzcode+"','"+ledgersubject+"','"+abnfee+"','','','','','','','"+taxcode+"','"+costcenter+"','"+purorderid+"','"+purorderitem+"','','"+text+"')";
				baseJdbc.update(insql);
			}
			
		}
	}
}*/





	//第一部分(供应商对应发票总金额)
	System.out.println("第一部分");
	int count=0;
	String insql="";
	String sql = "select b.suppliercode,(select tax from uf_dmsd_taxwh where requestid=a.gst)fpsm,sum(a.invoicemoney)invoicemoney,b.payitem,b.paybasedate,b.freezeup,b.paytype,b.paycurrency,sum(a.paymoney)paymoney,b.banktype from uf_dmph_iciinfo a left join uf_dmph_importchargemain b on a.requestid = b.requestid where  a.requestid = '"+requestid+"' and a.invoicemoney is not null and a.invoicemoney>0 group by b.suppliercode,b.payitem,b.paybasedate,b.freezeup,b.paytype,b.paycurrency,b.banktype,a.gst";
	List sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size()>0)
	{
		for(int a=0;a<sublist.size();a++)
		{
			Map am = (Map)sublist.get(a);
			String fpsm = StringHelper.null2String(am.get("fpsm"));//发票税码
			String suppliercode = StringHelper.null2String(am.get("suppliercode"));//供应商简码
			String invoicemoney = StringHelper.null2String(am.get("invoicemoney"));//发票总金额
			String patitemcode = StringHelper.null2String(am.get("payitem"));//付款条款
			String paybenchdate = StringHelper.null2String(am.get("paybasedate"));//付款基准日期
			String payfreeze = StringHelper.null2String(am.get("freezeup"));//付款冻结
			String paytype = StringHelper.null2String(am.get("paytype"));//付款方式
			String paycurrency = StringHelper.null2String(am.get("paycurrency"));//支付货币
			String paymoney = StringHelper.null2String(am.get("paymoney"));//支付货币总金额
			if(paymoney.equals("")||paymoney.equals("0"))
			{
				//paymoney="null";
				paycurrency="";
			}
			String banktype = StringHelper.null2String(am.get("banktype"));//合作银行类型
			count++;
			insql = "insert into uf_dmph_dlineiteminfo  (id,requestid,sno,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+suppliercode+"',"+invoicemoney+",'"+patitemcode+"','"+paybenchdate+"','"+payfreeze+"','"+paytype+"','"+paycurrency+"','"+paymoney+"','"+fpsm+"','','','','"+banktype+"','Import Fee Invoice','40285a8d5763da3c0157646db1b4053a')";
			baseJdbc.update(insql);
		}
	}




	//第二部分(暂估科目对应费用明细)
	System.out.println("第二部分");
	sql = "select (select tax from uf_dmsd_taxwh where requestid=a.qzsm)feetax,a.purorderid,a.purorderitem,a.feetype,a.costcenter,a.clearamount,(select tmpaccount from uf_dmdb_feename where feename=a.feetype and imextype='40285a8d56d542730156e95e821c3060')subject from uf_dmph_iccdetail a where a.requestid='"+requestid+"'";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size()>0)
	{
		for(int b=0;b<sublist.size();b++)
		{
			Map bm = (Map)sublist.get(b);
			String feetax = StringHelper.null2String(bm.get("feetax"));//费用税码
			String subject = StringHelper.null2String(bm.get("subject"));//总账科目
			String feetype = StringHelper.null2String(bm.get("feetype"));//费用类型
			String clearamount = StringHelper.null2String(bm.get("clearamount"));//清帐本位币金额
			String ordno = "";
			String orditem = "";
			String costcenter = "";
			if(subject.indexOf("21810999")!=-1||subject.indexOf("2191")!=-1)
			{
				ordno = StringHelper.null2String(bm.get("purorderid"));//采购订单号
				orditem = StringHelper.null2String(bm.get("purorderitem"));//采购订单项次
				costcenter = StringHelper.null2String(bm.get("costcenter"));//成本中心
				if(costcenter.equals(""))
				{
					costcenter = "M0101500";//成本中心
				}
			}
			count++;
			insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,subject,money,taxcaode,costcenter,purorderid,purorderitem,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"','"+clearamount+"','"+feetax+"','"+costcenter+"','"+ordno+"','"+orditem+"','"+feetype+"','40285a8d5763da3c0157646db1b4053b')";
			baseJdbc.update(insql);
		}
	}




	//第三部分(暂估总账科目对应暂估差异)
	System.out.println("第三部分");
	sql = "select a.clearmoney,a.currencydiff,a.feetype,(select requestid from uf_dmdb_feename where feename=a.feetype)feeid,a.qzsm,(select tax from uf_dmsd_taxwh where requestid=a.qzsm)smtxt,a.purorderid,a.purorderitem,a.estcurrency,a.qzcurr,a.costcenter,(select subject from uf_dmdb_feename where feename=a.feetype and imextype='40285a8d56d542730156e95e821c3060')subject from uf_dmph_iccdetail a where a.requestid='"+requestid+"'";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size()>0)
	{
		//System.out.println("哈1");
		for(int p1=0;p1<sublist.size();p1++)
		{
			Map mp1 = (Map)sublist.get(p1);
			String ordno = StringHelper.null2String(mp1.get("purorderid"));//采购订单号
			String orditem = StringHelper.null2String(mp1.get("purorderitem"));//采购订单项次
			String feename = StringHelper.null2String(mp1.get("feetype"));//费用类型(文本)
			String feeid = StringHelper.null2String(mp1.get("feeid"));//费用类型(id)
			String taxtxt = StringHelper.null2String(mp1.get("smtxt"));//税码(文本)
			String taxid = StringHelper.null2String(mp1.get("qzsm"));//税码(id)
			String qzje = StringHelper.null2String(mp1.get("clearmoney"));//清帐金额
			if(qzje.equals(""))
			{
				qzje = "0.00";
			}
			String bwbdiff = StringHelper.null2String(mp1.get("currencydiff"));//清帐本位币差额
			if(bwbdiff.equals(""))
			{
				bwbdiff = "0";
			}
			String zgcurr = StringHelper.null2String(mp1.get("estcurrency"));//暂估币种
			String qzcurr = StringHelper.null2String(mp1.get("qzcurr"));//清帐币种
			String subject = StringHelper.null2String(mp1.get("subject"));//暂估差异科目
			String costcenter = StringHelper.null2String(mp1.get("costcenter"));//暂估差异成本中心
			if(costcenter.equals(""))
			{
				costcenter = "M0101500";//成本中心
			}
			//未清项明细
			//System.out.println("哈2");
			String wqxbwb = "0.00";
			sql = "select rmbamount from uf_dmph_uncleariinfo where requestid='"+requestid+"' and pono='"+ordno+"' and poitem='"+orditem+"'";
			sublist = baseJdbc.executeSqlForList(sql);
			if(sublist.size()>0)
			{
				Map mp2 = (Map)sublist.get(0);
				wqxbwb = StringHelper.null2String(mp2.get("rmbamount"));//未清项本位币
				if(wqxbwb.equals(""))
				{
					wqxbwb = "0.00";
				}
			}
			//其他费用会计明细
			//System.out.println("哈3");
			String qtbwb = "0.00";
			String qtws = "0.00";
			sql = "select abncurrmoney,abnfeemoney from uf_dmph_ecicoecadetails where requestid='"+requestid+"' and purorderid='"+ordno+"' and purorderitem='"+orditem+"' and feetype='"+feename+"' and taxcode='"+taxtxt+"'";
			sublist = baseJdbc.executeSqlForList(sql);
			if(sublist.size()>0)
			{
				Map mp3 = (Map)sublist.get(0);
				qtbwb = StringHelper.null2String(mp3.get("abncurrmoney"));//其他费用清帐本位币
				if(qtbwb.equals(""))
				{
					qtbwb = "0.00";
				}
				qtws = StringHelper.null2String(mp3.get("abnfeemoney"));//其他费用清帐未税金额
				if(qtws.equals(""))
				{
					qtws = "0.00";
				}
			}
			//发票明细
			//System.out.println("哈4");
			String sqje = "0.00";
			sql = "select beftaxmoney from uf_dmph_iciinfo where requestid='"+requestid+"' and pono='"+ordno+"'and poitem='"+orditem+"' and feetype='"+feename+"' and gst='"+taxid+"'";
			sublist = baseJdbc.executeSqlForList(sql);
			if(sublist.size()>0)
			{
				Map mp4 = (Map)sublist.get(0);
				sqje = StringHelper.null2String(mp4.get("beftaxmoney"));//税前金额
				if(sqje.equals(""))
				{
					sqje = "0.00";
				}
			}
			double zgwsje = 0.00;//暂估未税金额
			double zgdiff = 0.00;//暂估差异
			//System.out.println("qzcurr++++++++++++++++:"+qzcurr);
			//System.out.println("zgcurr++++++++++++++++:"+zgcurr);
			if(!qzcurr.equals("")&&!zgcurr.equals(""))
			{
				if(qzcurr.equals(zgcurr))//清帐币种=暂估币种
				{
					zgwsje = Double.valueOf(qzje)+Double.valueOf(qtws);//清帐金额+其他费用清帐未税金额
				}
				else
				{
					zgwsje = Double.valueOf(bwbdiff)+Double.valueOf(wqxbwb)+Double.valueOf(qtbwb);//清帐明细本位币差额+未清项本位币金额+其他费用清帐本位币金额
				}
				//暂估差异
				//System.out.println("哈5");
				zgdiff = Double.valueOf(sqje)-Double.valueOf(zgwsje);//税前金额-暂估未税金额
			}
			if(zgdiff>0)
			{
				count++;
				insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,subject,money,taxcaode,costcenter,purorderid,purorderitem,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"',"+zgdiff+",'"+taxtxt+"','"+costcenter+"','"+ordno+"','"+orditem+"','角分差','40285a8d5763da3c0157646db1b4053b')";
				//System.out.println(insql);
				//Angle Points Difference(角分差)
				baseJdbc.update(insql);
			}
		}
	}




	//第四部分(默认总账科目对应发票税金)
	System.out.println("第四部分");
	sql = "select sum(a.tax)tax,(select tax from uf_dmsd_taxwh where requestid=a.gst)taxname,a.taxrate from uf_dmph_iciinfo a where a.requestid = '"+requestid+"' group by a.gst,a.taxrate";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size() >0)
	{
		for(int c = 0;c<sublist.size();c++)
		{
			Map mc = (Map)sublist.get(c);
			String tax = StringHelper.null2String(mc.get("tax"));//税金合计
			String taxname = StringHelper.null2String(mc.get("taxname"));//发票税码
			String taxrate = StringHelper.null2String(mc.get("taxrate"));//税率
			if(Double.valueOf(tax) >0)//发票税金合计>0,显示;发票税金合计=0,不显示
			{
				String subject = "21710101";//默认总账科目
				double sjjs = Double.valueOf(tax)/(Double.valueOf(taxrate)/100);//税金基数
				String strsjjs = String.format("%.2f",sjjs);//四舍五入保留两位小数
				
				count++;
				insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,subject,money,sjjs,taxcaode,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"',"+tax+",'"+strsjjs+"','"+taxname+"','Import Invoice Tax','40285a8d5763da3c0157646db1b4053b')";
				baseJdbc.update(insql);
				//System.out.println(insql);
			}
		}
	}




	//第五部分(固定总账科目对应汇兑差)
	System.out.println("第五部分");
	//计算汇兑差
	//如果业务货币差额为0,汇兑差=本位币差额
	//否则：汇兑差=本位币差额-（业务货币差额*清账汇率）
	sql = "select a.buscurrencydiff,a.currencydiff,a.qzrate,a.estcurrency,a.qzcurr,a.costcenter,(select subject from uf_dmdb_feename where feename=a.feetype and imextype='40285a8d56d542730156e95e821c3060')subject,(select tax from uf_dmsd_taxwh where requestid=a.qzsm)taxcode from uf_dmph_iccdetail a where a.requestid = '"+requestid+"'";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size() >0)
	{
		Double hdc = 0.00;//汇兑差
		String cscen = "";//汇兑差成本中心
		String subject = "";//汇兑差总账科目
		for(int m = 0;m<sublist.size();m++)
		{
			Map m4 = (Map)sublist.get(m);
			String taxcode = StringHelper.null2String(m4.get("taxcode"));//税码
			String qzhl = StringHelper.null2String(m4.get("qzrate"));//清帐汇率
			String zgcurr = StringHelper.null2String(m4.get("estcurrency"));//暂估币种
			String qzcurr = StringHelper.null2String(m4.get("qzcurr"));//清帐币种
			String buscurrencydiff = StringHelper.null2String(m4.get("buscurrencydiff"));//业务货币差额
			String currencydiff = StringHelper.null2String(m4.get("currencydiff"));//本位币差额
			cscen = StringHelper.null2String(m4.get("costcenter"));//汇兑差成本中心
			if(cscen.equals(""))
			{
				cscen = "M0101500";//成本中心
			}
			subject = StringHelper.null2String(m4.get("subject"));//汇兑差总账科目
			if(!zgcurr.equals("")&&!qzcurr.equals(""))
			{
				if(!zgcurr.equals(qzcurr))
				{
					hdc = Double.valueOf(currencydiff)-(Double.valueOf(buscurrencydiff)*Double.valueOf(qzhl));
				}
			}
			DecimalFormat df2 = new DecimalFormat("###.00");//保留两位小数
			hdc = Double.valueOf(df2.format(hdc));
			if(hdc!=0)//若汇兑差不为0则显示
			{
				count++;
				insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,subject,money,taxcaode,costcenter,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"',"+Math.abs(Double.valueOf(hdc))+",'"+taxcode+"','"+cscen+"','汇兑差','40285a8d5763da3c0157646db1b4053b')";
				baseJdbc.update(insql);
				//System.out.println(insql);
				//Exchange Poor(汇兑差')
			}	
		}
	}




	//第六部分(总账科目对应其他费用会计明细)
	System.out.println("第六部分");
	sql = "select ledgersubject,feetype,addfeetotal,addfeecurrtotal,costcenter,purorderid,purorderitem,taxcode from uf_dmph_ecicoecadetails where requestid = '"+requestid+"' order by sno asc";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size() >0)
	{
		for(int m = 0;m<sublist.size();m++)
		{
			Map m3 = (Map)sublist.get(m);
			String sm= StringHelper.null2String(m3.get("taxcode"));//税码
			String ledgersubject = StringHelper.null2String(m3.get("ledgersubject"));//总账科目
			String feename = StringHelper.null2String(m3.get("feetype"));//费用名称
			String addfeetotal = StringHelper.null2String(m3.get("addfeetotal"));//增额费用小计
			String addfeecurrtotal = StringHelper.null2String(m3.get("addfeecurrtotal"));//增额费用本位币小计
			String costcenter = StringHelper.null2String(m3.get("costcenter"));//成本中心
			if(costcenter.equals(""))
			{
				costcenter = "M0101500";//成本中心
			}
			String pono = StringHelper.null2String(m3.get("purorderid"));//采购订单号
			String poitem = StringHelper.null2String(m3.get("purorderitem"));//采购订单项次
			Double abnfee = 0.00;
			
			//无论暂估币种与清帐币种是否一样均取增额费用本位币小计
			abnfee = Math.abs(Double.valueOf(addfeecurrtotal));//增额费用本位币小计
			if(abnfee >0)
			{
				count++;
				insql = "insert into uf_dmph_dlineiteminfo(id,requestid,sno,subject,money,taxcaode,costcenter,purorderid,purorderitem,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+ledgersubject+"',"+abnfee+",'"+sm+"','"+costcenter+"','"+pono+"','"+poitem+"','"+feename+"','40285a8d5763da3c0157646db1b4053b')";
				baseJdbc.update(insql);
				//System.out.println(insql);
			}
		}
	}




	//查询数据并显示
	String selsql = "select sno,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,purorderid,purorderitem,banktype,text1,sjjs from uf_dmph_dlineiteminfo where requestid = '"+requestid+"' order by sno asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String sno = StringHelper.null2String(m4.get("sno"));
			String subject = StringHelper.null2String(m4.get("subject"));
			String money = StringHelper.null2String(m4.get("money"));
			String payitem = StringHelper.null2String(m4.get("payitem"));
			String paydate = StringHelper.null2String(m4.get("paydate"));
			String payfreeze = StringHelper.null2String(m4.get("payfreeze"));
			String paytype = StringHelper.null2String(m4.get("paytype"));
			String currencys = StringHelper.null2String(m4.get("currency"));
			String paymoney = StringHelper.null2String(m4.get("paymoney"));
			String sjjs = StringHelper.null2String(m4.get("sjjs"));
			String taxcaode = StringHelper.null2String(m4.get("taxcaode"));
			String costcenter = StringHelper.null2String(m4.get("costcenter"));
			String purorderid = StringHelper.null2String(m4.get("purorderid"));
			String purorderitem = StringHelper.null2String(m4.get("purorderitem"));
			String banktype = StringHelper.null2String(m4.get("banktype"));
			String text1 = StringHelper.null2String(m4.get("text1"));

	%>
			<TR id="<%="dataDetail_"+sno %>">
			<TD  class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+sno %>" name="sno"><%=sno %></TD><!--序号-->
			<TD  class="td2"  align=center><%=subject %></TD><!--科目-->
			<TD  class="td2"  align=center><%=money %></TD><!--金额-->
			<TD  class="td2"  align=center><%=payitem %></TD><!--付款条款-->
			<TD  class="td2"  align=center><%=paydate %></TD><!--付款基准日-->
			<TD  class="td2"  align=center><%=payfreeze %></TD><!--付款冻结-->
			<TD  class="td2"  align=center><%=paytype %></TD><!--付款方式-->
			<TD  class="td2"  align=center><%=currencys %></TD><!--支付货币-->
			<TD  class="td2"  align=center><%=paymoney %></TD><!--支付货币金额-->
			<TD  class="td2"  align=center><%=sjjs %></TD><!--税金基数-->
			<TD  class="td2"  align=center><%=taxcaode %></TD><!--税码-->
			<TD  class="td2"  align=center><%=costcenter %></TD><!--成本-->
			<TD  class="td2"  align=center><%=purorderid %></TD><!--采购订单号-->
			<TD  class="td2"  align=center><%=purorderitem %></TD><!--采购订单项次-->
			<TD  class="td2"  align=center><%=banktype %></TD><!--合作银行-->
			<TD  class="td2"  align=center><%=text1%></TD><!--文本-->
			<!--<input type="text" value="<%=text1 %>" id="<%="input_"+sno %>" onblur="changetext('<%=sno%>')">-->
			</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">NO Message!</TD></TR>
<%} %>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    