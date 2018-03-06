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
String taxcode = StringHelper.null2String(request.getParameter("taxcode"));//税码
String fpcurren = StringHelper.null2String(request.getParameter("fpcurren"));//发票币种
String zgcurren = StringHelper.null2String(request.getParameter("zgcurren"));//暂估币种
String qzhl=StringHelper.null2String(request.getParameter("qzhl"));//清账汇率
String comcode=StringHelper.null2String(request.getParameter("comcode"));
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
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>



<%
String delsql = "delete uf_tr_exfeeclearitem  where requestid = '"+requestid+"'";
baseJdbc.update(delsql);

//31行项目 发票明细
int count=0;
String sql = "select b.bgsupcode,a.invoicemoney,b.patitemcode,b.paybenchdate,b.payfreeze,(select objdesc from selectitem where id=b.paytype) as paytype,b.paycurrency,a.paymoney,b.bgbanktype  from uf_tr_exfeeinvoiceinfo  a left join uf_tr_exfeeclearmain b on a.requestid = b.requestid where  a.requestid = '"+requestid+"' and a.invoicemoney is not null and a.invoicemoney>0 ";
List sublist = baseJdbc.executeSqlForList(sql);
String insql="";
if(sublist.size()>0){
	for(int k=0;k<sublist.size();k++)
	{
		Map mk = (Map)sublist.get(k);
		String suppliercode = StringHelper.null2String(mk.get("bgsupcode"));//供应商简码
		String invoicemoney = StringHelper.null2String(mk.get("invoicemoney"));//发票金额
		String patitemcode = StringHelper.null2String(mk.get("patitemcode"));//付款条款
		String paybenchdate = StringHelper.null2String(mk.get("paybenchdate"));//付款基准日期
		String payfreeze = StringHelper.null2String(mk.get("payfreeze"));//付款冻结
		String paytype = StringHelper.null2String(mk.get("paytype"));//付款方式
		String paycurrency = StringHelper.null2String(mk.get("paycurrency"));//支付货币
		String paymoney = StringHelper.null2String(mk.get("paymoney"));//支付货币金额
		if(paymoney.equals("")||paymoney.equals("0"))
		{
			paymoney="null";
			paycurrency="";
		}
		String banktype = StringHelper.null2String(mk.get("bgbanktype"));//合作银行类型
		count++;

		insql = "insert into uf_tr_exfeeclearitem  (id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,receiptid,receiptitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'31','"+suppliercode+"',"+invoicemoney+",'"+patitemcode+"','"+paybenchdate+"','"+payfreeze+"','"+paytype+"','"+paycurrency+"',"+paymoney+",'','','','','"+banktype+"','出口费用')";
		baseJdbc.update(insql);
		System.out.println(insql);
	}
}
//暂估差异

 sql = "select  estdiff, edledgersubject,edcostcenter from uf_tr_exfeeclearmain b  where  b.requestid = '"+requestid+"'";
 sublist = baseJdbc.executeSqlForList(sql);
 if(sublist.size()>0){
	Map mk1 = (Map)sublist.get(0);
	String estdiff = StringHelper.null2String(mk1.get("estdiff"));//暂估差异
	String edledgersubject = StringHelper.null2String(mk1.get("edledgersubject"));//暂估差异总账科目
	String edcostcenter = StringHelper.null2String(mk1.get("edcostcenter"));//暂估差异成本中心
	String receiptid="";//销售凭证号
	String exlistid="";//外销联络单编号
	String receiptitem="";//销售凭证项次
	Double val = 0.00;
	String jzm="";
	if(estdiff.equals("")||estdiff.equals("null")||estdiff==null)
	{
		estdiff="0";
	}
	if(Double.valueOf(estdiff) >0)//暂估差异>0
	{
		jzm="40";
		val = Double.valueOf(estdiff);
	}
	else if(Double.valueOf(estdiff) <0)
	{
		jzm="50";
		val = Math.abs(Double.valueOf(estdiff));//暂估差异的绝对值
	}
	if(val >0)//添加暂估差异不为0行
	{
		String sql1="select orderid,exlistid from uf_tr_exfeeclearsub where requestid='"+requestid+"' order by sno";
		List sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0){
			Map mk2 = (Map)sublist1.get(0);
			receiptid=StringHelper.null2String(mk2.get("orderid")).split("/")[0];
			exlistid=StringHelper.null2String(mk2.get("exlistid"));
		}
		/*
		sql1="select orderitem  from uf_tr_saleslist  where orderno='"+receiptid+"' ORDER BY orderitem ASC";
		System.out.println(sql1);
		sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0){
			Map mk3 = (Map)sublist1.get(0);
			receiptitem=StringHelper.null2String(mk3.get("orderitem"));
		}
	*/
		sql1="select costno from uf_tr_delnotes where requestid=( select noticeno from uf_tr_expboxmain  where expno='"+exlistid+"')";
		System.out.println(sql1);
		sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0){
			Map mk4 = (Map)sublist1.get(0);
			edcostcenter=StringHelper.null2String(mk4.get("costno"));
		}
		sql1="select vitem  from uf_tr_shipment  where requestid=( select requestid from uf_tr_expboxmain  where expno='"+exlistid+"')  and voucherno='"+receiptid+"' ORDER BY vitem ASC";
		System.out.println(sql1);
		sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0){
			Map mk3 = (Map)sublist1.get(0);
			receiptitem=StringHelper.null2String(mk3.get("vitem"));
		}


		count++;
		insql = "insert into uf_tr_exfeeclearitem  (id,requestid,sno,accountcode,subject,money,taxcaode,costcenter,receiptid,receiptitem,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+jzm+"','"+edledgersubject+"',"+val+",'"+taxcode+"','"+edcostcenter+"','"+receiptid+"','"+receiptitem+"','角分差')";
		baseJdbc.update(insql);
		System.out.println(insql);
	}
}

	//发票增值税金额>0，固定为“40”；发票增值税=0，不显示
	sql = "select invoiceno,tax from uf_tr_exfeeinvoiceinfo where requestid = '"+requestid+"'";//查询发票信息
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size() >0)
	{
		for(int i = 0;i<sublist.size();i++)
		{
			Map m2 = (Map)sublist.get(i);
			String invoiceno = StringHelper.null2String(m2.get("invoiceno"));//发票号码
			String tax = StringHelper.null2String(m2.get("tax"));//税额
			if(Double.valueOf(tax) >0)
			{
				count++;
				String subject = "21710101";//默认总账科目
				String subsql = "select zzsubjects from uf_tr_fymcwhd   where factype = '"+comtype+"' and importandexport = '40285a90497a8f7801497d7b4cbd0032'  and costname = '增值税'";
				List sublist1 = baseJdbc.executeSqlForList(subsql);

				if(sublist1.size()>0)
				{
					Map m1 = (Map)sublist1.get(0);
					subject = StringHelper.null2String(m1.get("zzsubjects"));//费用科目
				}
				insql = "insert into uf_tr_exfeeclearitem(id,requestid,sno,accountcode,subject,money,taxcaode,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'40','"+subject+"',"+tax+",'"+taxcode+"','增值税-"+invoiceno+"')";
				baseJdbc.update(insql);
				System.out.println(insql);

			}
		}
	}

//如暂估币种与发票币种不一致，并且申请单清帐明细的行项汇兑差额累计>0，为40；<0，为50,; =0不显示
//计算汇兑差
//如果业务货币差额为0 ，汇兑差=本位币差额
//否则：Number(parseFloat(PFAmount)).sub(DF_forDight(parseFloat(BDAmount)*parseFloat(cRate),2));
//汇兑差=本位币差额-（业务货币差额*清账汇率） //qzhl

	sql = "select buscurrencydiff,currencydiff from uf_tr_exfeeclearsub where requestid = '"+requestid+"'";
	sublist = baseJdbc.executeSqlForList(sql);
	if(sublist.size() >0)
	{
		Double hdc = 0.00;//汇兑差
		String jzcode="";//记账码
		for(int m = 0;m<sublist.size();m++)
		{
			Map m4 = (Map)sublist.get(m);

			String buscurrencydiff = StringHelper.null2String(m4.get("buscurrencydiff"));//业务货币差额
			String currencydiff = StringHelper.null2String(m4.get("currencydiff"));//本位币差额
			hdc=hdc+Double.valueOf(currencydiff)-(Double.valueOf(buscurrencydiff)*Double.valueOf(qzhl));
			System.out.println(Double.valueOf(currencydiff)-(Double.valueOf(buscurrencydiff)*Double.valueOf(qzhl)));
			
			
		}
		DecimalFormat df2 = new DecimalFormat("###.00");
		System.out.println("汇兑差："+df2.format(hdc));
		hdc=Double.valueOf(df2.format(hdc));
		if(!fpcurren.equals(zgcurren))
		{
			System.out.println(hdc);
			if(hdc>0)
			{
				jzcode="40";
			}
			else if(hdc<0)
			{
				jzcode="50";
			}
			if(!jzcode.equals(""))
			{
				count++;
				//1010：10101400；1020：20101400；1030：30101400；1050：50101400；1060：60101400；
				String  cscen="10101400";
				if(comcode.equals("1010"))
				{
					cscen="10101400";
				}
				else if(comcode.equals("1020"))
				{
					cscen="20101400";
				}
				else if(comcode.equals("1030"))
				{
					cscen="30101400";
				}
				else if(comcode.equals("1050"))
				{
					cscen="50101400";
				}
				else if(comcode.equals("1060"))
				{
					cscen="60101400";
				}
				else if(comcode.equals("7010"))
				{
					cscen="J0101400";
				}


				insql = "insert into uf_tr_exfeeclearitem(id,requestid,sno,accountcode,subject,money,taxcaode,costcenter,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+jzcode+"','55030300',"+Math.abs(Double.valueOf(hdc))+",'','"+cscen+"','汇兑差')";
				baseJdbc.update(insql);
				System.out.println(insql);
			}

		}	
		
	}


//会计明细

	sql = "select ledgersubject,accountcode,feetype,addfeetotal,addfeecurrtotal,costcenter,receiptid,receiptitem from uf_tr_exfeeotherclearsub where requestid = '"+requestid+"' order by sno asc";
	System.out.println(sql);
	sublist = baseJdbc.executeSqlForList(sql);

	if(sublist.size() >0)
	{
		for(int m = 0;m<sublist.size();m++)
		{
			Map m3 = (Map)sublist.get(m);

			String ledgersubject = StringHelper.null2String(m3.get("ledgersubject"));//总账科目
			String feename = StringHelper.null2String(m3.get("feetype"));//费用名称
			String addfeetotal = StringHelper.null2String(m3.get("addfeetotal"));//增额费用小计
			String addfeecurrtotal = StringHelper.null2String(m3.get("addfeecurrtotal"));//增额费用本位币小计
			String costcenter = StringHelper.null2String(m3.get("costcenter"));//成本中心
			String receiptid = StringHelper.null2String(m3.get("receiptid"));//采购订单号
			String receiptitem = StringHelper.null2String(m3.get("receiptitem"));//采购订单项次
			Double abnfee = 0.00;
			Double abnfee1 = 0.00;
			String jzcode=StringHelper.null2String(m3.get("accountcode"));//记账码
			if(fpcurren.equals(zgcurren))
			{
				abnfee = Math.abs(Double.valueOf(addfeetotal));//增额费用小计
				//abnfee1=Math.abs(Double.valueOf(addfeecurrtotal));
				if(Double.valueOf(addfeetotal)>0)
				{
					jzcode="40";
				}
				else
				{
					jzcode="50";
				}
			}
			else
			{
				abnfee = Math.abs(Double.valueOf(addfeecurrtotal));//增额费用本位币小计
				if(Double.valueOf(addfeecurrtotal)>0)
				{
					jzcode="40";
				}
				else
				{
					jzcode="50";
				}

			}
			//System.out.println(abnfee);
			if(abnfee >0)
			{
				count++;
				insql = "insert into uf_tr_exfeeclearitem(id,requestid,sno,accountcode,subject,money,taxcaode,costcenter,receiptid,receiptitem,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+jzcode+"','"+ledgersubject+"',"+abnfee+",'"+taxcode+"','"+costcenter+"','"+receiptid+"','"+receiptitem+"','"+feename+"')";
				baseJdbc.update(insql);
				System.out.println(insql);
			}
			
		}
	}



%>



