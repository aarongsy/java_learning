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
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.app.configsap.SapSync"%>
<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
//String comtype = StringHelper.null2String(request.getParameter("comtype"));//厂区别
//String taxcode = StringHelper.null2String(request.getParameter("taxcode"));//税码
//String fpcurren = StringHelper.null2String(request.getParameter("fpcurren"));//发票币种
//String zgcurren = StringHelper.null2String(request.getParameter("zgcurren"));//暂估币种
//String qzhl=StringHelper.null2String(request.getParameter("qzhl"));//清账汇率
//String comcode=StringHelper.null2String(request.getParameter("comcode"));
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
String delsql = "delete uf_dmsd_exfeeqzpz  where requestid = '"+requestid+"'";
baseJdbc.update(delsql);
//第一部分(供应商对应发票总金额)
//System.out.println("第一部分");
int count=0;
String insql="";
String sql = "select b.suppliercode,(select tax from uf_dmsd_taxwh where requestid=a.invoicetype)fpsm,sum(a.invoicemoney)invoicemoney,b.patitemcode,b.paybenchdate,b.payfreeze,(select objdesc from selectitem where id=b.paytype) as paytype,b.paycurrency,sum(a.paymoney)paymoney,b.banktype from uf_dmsd_exfeeqzfp a left join uf_dmsd_exfeeqz b on a.requestid = b.requestid where  a.requestid = '"+requestid+"' and a.invoicemoney is not null and a.invoicemoney>0 group by b.suppliercode,b.patitemcode,b.paybenchdate,b.payfreeze,b.paytype,b.paycurrency,b.banktype,a.invoicetype";
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int a=0;a<sublist.size();a++)
	{
		Map am = (Map)sublist.get(a);
		String fpsm = StringHelper.null2String(am.get("fpsm"));//发票税码
		String suppliercode = StringHelper.null2String(am.get("suppliercode"));//供应商简码
		String invoicemoney = StringHelper.null2String(am.get("invoicemoney"));//发票总金额
		String patitemcode = StringHelper.null2String(am.get("patitemcode"));//付款条款
		String paybenchdate = StringHelper.null2String(am.get("paybenchdate"));//付款基准日期
		String payfreeze = StringHelper.null2String(am.get("payfreeze"));//付款冻结
		String paytype = StringHelper.null2String(am.get("paytype"));//付款方式
		String paycurrency = StringHelper.null2String(am.get("paycurrency"));//支付货币
		String paymoney = StringHelper.null2String(am.get("paymoney"));//支付货币总金额
		if(paymoney.equals("")||paymoney.equals("0"))
		{
			paycurrency="";
		}
		String banktype = StringHelper.null2String(am.get("banktype"));//合作银行类型
		count++;
		insql = "insert into uf_dmsd_exfeeqzpz  (id,requestid,sno,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,receiptid,receiptitem,banktype,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+suppliercode+"',"+invoicemoney+",'"+patitemcode+"','"+paybenchdate+"','"+payfreeze+"','"+paytype+"','"+paycurrency+"','"+paymoney+"','"+fpsm+"','','','','"+banktype+"','Export Fee Invoice','40285a8d5763da3c0157646db1b4053a')";
		baseJdbc.update(insql);
	}
}


//第二部分(暂估科目对应费用明细)
//System.out.println("第二部分");
sql = "select (select tax from uf_dmsd_taxwh where requestid=a.qzsm)feetax,a.orderid,a.orditem,a.feetype,a.clearmoney,a.qzsl,a.costcenter,(select tmpaccount from uf_dmdb_feename where feename=a.feetype and imextype='40285a8d56d542730156e95e821c3061')subject from uf_dmsd_exfeeqzmx a where a.requestid='"+requestid+"'";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int b=0;b<sublist.size();b++)
	{
		Map bm = (Map)sublist.get(b);
		String feetax = StringHelper.null2String(bm.get("feetax"));//税码
		String taxrate = StringHelper.null2String(bm.get("qzsl"));//税率
		String subject = StringHelper.null2String(bm.get("subject"));//暂估科目
		String feetype = StringHelper.null2String(bm.get("feetype"));//费用类型
		String clearmoney = StringHelper.null2String(bm.get("clearmoney"));//清帐金额(含税金额)
		DecimalFormat df = new DecimalFormat("#.00");  
		double notaxamount = Double.valueOf(clearmoney)*(100-Double.valueOf(taxrate))/100;
		String ordno = "";
		String orditem = "";
		String costcenter = "";

		if(subject.indexOf("21810999")!=-1||subject.indexOf("2191")!=-1)
		{
			ordno = StringHelper.null2String(bm.get("orderid"));//销售订单号
			orditem = StringHelper.null2String(bm.get("orditem"));//销售订单项次
			costcenter = StringHelper.null2String(bm.get("costcenter"));//成本中心
			if(costcenter.equals(""))
			{
				/costcenter = "M0163110";
			}
		}
		count++;
		insql = "insert into uf_dmsd_exfeeqzpz  (id,requestid,sno,subject,money,taxcaode,costcenter,receiptid,receiptitem,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"','"+String.valueOf(df.format(notaxamount))+"','"+feetax+"','"+costcenter+"','"+ordno+"','"+orditem+"','"+feetype+"','40285a8d5763da3c0157646db1b4053b')";
		baseJdbc.update(insql);
	}
}



//31行项目 发票明细
/*sql = "select b.suppliercode,a.invoicemoney,b.patitemcode,b.paybenchdate,b.payfreeze,(select objdesc from selectitem where id=b.paytype) as paytype,b.paycurrency,a.paymoney,b.banktype  from uf_dmsd_exfeeqzfp a left join uf_dmsd_exfeeqz b on a.requestid = b.requestid where  a.requestid = '"+requestid+"' and a.invoicemoney is not null and a.invoicemoney>0 ";
List sublist = baseJdbc.executeSqlForList(sql);
String insql="";
if(sublist.size()>0)
{
	for(int k=0;k<sublist.size();k++)
	{
		Map mk = (Map)sublist.get(k);
		String suppliercode = StringHelper.null2String(mk.get("suppliercode"));//供应商简码
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
		String banktype = StringHelper.null2String(mk.get("banktype"));//合作银行类型
		count++;

		insql = "insert into uf_dmsd_exfeeqzpz  (id,requestid,sno,accountcode,subject,money,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,receiptid,receiptitem,banktype,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'31','"+suppliercode+"',"+invoicemoney+",'"+patitemcode+"','"+paybenchdate+"','"+payfreeze+"','"+paytype+"','"+paycurrency+"',"+paymoney+",'','','','','"+banktype+"','出口费用')";
		baseJdbc.update(insql);
		System.out.println(insql);
	}
}*/





/*sql = "select  estdiff, edledgersubject,edcostcenter from uf_dmsd_exfeeqz b  where  b.requestid = '"+requestid+"'";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	Map mk1 = (Map)sublist.get(0);
	String estdiff = StringHelper.null2String(mk1.get("estdiff"));//暂估差异
	String edledgersubject = StringHelper.null2String(mk1.get("edledgersubject"));//暂估差异总账科目
	String edcostcenter = StringHelper.null2String(mk1.get("edcostcenter"));//暂估差异成本中心
	String receiptid="";//销售凭证号
	String exlistid="";//外销联络单编号
	String receiptitem="";//销售凭证项次
	Double val = 0.00;
	//String jzm="";
	if(estdiff.equals("")||estdiff.equals("null")||estdiff==null)
	{
		estdiff="0";
	}
	if(Double.valueOf(estdiff) >0)//暂估差异>0
	{
		//jzm="40";
		val = Double.valueOf(estdiff);
	}
	else if(Double.valueOf(estdiff) <0)
	{
		//jzm="50";
		val = Math.abs(Double.valueOf(estdiff));//暂估差异的绝对值
	}
	if(val >0)//添加暂估差异不为0行
	{
		String sql1="select orderid,exlistid from uf_dmsd_exfeeqzmx where requestid='"+requestid+"' and sno=1";
		List sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0)
		{
			Map mk2 = (Map)sublist1.get(0);
			receiptid=StringHelper.null2String(mk2.get("orderid")).split(",")[0];//订单号文本
			exlistid=StringHelper.null2String(mk2.get("exlistid"));//外销联络单编号文本
		}
		
		
		//sql1="select orderitem  from uf_tr_saleslist  where orderno='"+receiptid+"' ORDER BY orderitem ASC";
		//System.out.println(sql1);
		//sublist1 = baseJdbc.executeSqlForList(sql1);
		//if(sublist1.size()>0){
			//Map mk3 = (Map)sublist1.get(0);
			//receiptitem=StringHelper.null2String(mk3.get("orderitem"));
		//}
		
		
		sql1="select costcenter from uf_dmsd_shipment where requestid=(select requestid from uf_dmsd_expboxmain where expno='"+exlistid+"') and saleorder='"+receiptid+"'";
		System.out.println("=========================================="+sql1);
		sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0){
			Map mk4 = (Map)sublist1.get(0);
			edcostcenter=StringHelper.null2String(mk4.get("costcenter"));//成本中心
		}
		sql1="select orderitem from uf_dmsd_shipment where requestid=(select requestid from uf_dmsd_expboxmain where expno='"+exlistid+"')  and saleorder='"+receiptid+"' ORDER BY orderitem ASC";
		System.out.println(sql1);
		sublist1 = baseJdbc.executeSqlForList(sql1);
		if(sublist1.size()>0){
			Map mk3 = (Map)sublist1.get(0);
			receiptitem=StringHelper.null2String(mk3.get("orderitem"));
		}
		count++;
		insql = "insert into uf_dmsd_exfeeqzpz  (id,requestid,sno,subject,money,taxcaode,costcenter,receiptid,receiptitem,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+edledgersubject+"',"+val+",'"+taxcode+"','"+edcostcenter+"','"+receiptid+"','"+receiptitem+"','jiao fen cha')";
		baseJdbc.update(insql);
		//System.out.println(insql);
	}
}*/





//第三部分(暂估总账科目对应暂估差异)
//System.out.println("第三部分");
//清帐明细表
sql = "select a.clearmoney,a.currencydiff,a.feetype,(select requestid from uf_dmdb_feename where feename=a.feetype)feeid,a.qzsm,(select tax from uf_dmsd_taxwh where requestid=a.qzsm)smtxt,a.orderid,a.orditem,a.estcurrency,a.qzcurr,a.costcenter,(select subject from uf_dmdb_feename where feename=a.feetype and imextype='40285a8d56d542730156e95e821c3061')subject from uf_dmsd_exfeeqzmx a where a.requestid='"+requestid+"'";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	//System.out.println("哈1");
	for(int p1=0;p1<sublist.size();p1++)
	{
		Map mp1 = (Map)sublist.get(p1);
		String ordno = StringHelper.null2String(mp1.get("orderid"));//销售单号
		String orditem = StringHelper.null2String(mp1.get("orditem"));//订单项次
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
			costcenter = "M0163110";
		}
		//未清项明细
		//System.out.println("哈2");
		String wqxbwb = "0.00";
		sql = "select rmbamount from uf_dmsd_exfeeqzno where requestid='"+requestid+"' and ordno='"+ordno+"' and orditem='"+orditem+"'";
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
		//其他费用
		//System.out.println("哈3");
		String qtbwb = "0.00";
		String qtws = "0.00";
		sql = "select abncurrmoney,abnfeemoney from uf_dmsd_exfeeqzkj where requestid='"+requestid+"' and receiptid='"+ordno+"' and receiptitem='"+orditem+"' and feetype='"+feename+"' and taxcode='"+taxtxt+"'";
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
		System.out.println("哈4");
		String sqje = "0.00";
		sql = "select beftaxmoney from uf_dmsd_exfeeqzfp where requestid='"+requestid+"' and ordno='"+ordno+"'and orditem='"+orditem+"' and feetype='"+feename+"' and invoicetype='"+taxid+"'";
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
		System.out.println("sqje:"+sqje);
		double zgwsje = 0.00;//暂估未税金额
		double zgdiff = 0.00;//暂估差异
		if(!zgcurr.equals("")&&!qzcurr.equals(""))
		{
			if(qzcurr.equals(zgcurr))//清帐币种=暂估币种
			{
				System.out.println("1......");
				System.out.println("qzje:"+qzje);
				System.out.println("qtws:"+qtws);
				
				zgwsje = Double.valueOf(qzje)+Double.valueOf(qtws);//清帐金额+其他费用清帐未税金额
			}
			else
			{
				System.out.println("2......");
				zgwsje = Double.valueOf(bwbdiff)+Double.valueOf(wqxbwb)+Double.valueOf(qtbwb);//清帐明细本位币差额+未清项本位币金额+其他费用清帐本位币金额
			}
			System.out.println("zgwsje:"+zgwsje);
			//暂估差异
			//System.out.println("哈5");
			zgdiff = Double.valueOf(sqje)-Double.valueOf(zgwsje);//税前金额-暂估未税金额
		}
		System.out.println("zgdiff:"+zgdiff);
		if(zgdiff>0)
		{
			count++;
			insql = "insert into uf_dmsd_exfeeqzpz (id,requestid,sno,subject,money,taxcaode,costcenter,receiptid,receiptitem,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"',"+zgdiff+",'"+taxtxt+"','"+costcenter+"','"+ordno+"','"+orditem+"','角分差','40285a8d5763da3c0157646db1b4053b')";
			//System.out.println(insql);
			baseJdbc.update(insql);
		}
	}
}



//发票增值税金额>0，固定为“40”；发票增值税=0，不显示
/*sql = "select a.invoiceno,a.tax,(select tax from uf_dmsd_taxwh where requestid=a.invoicetype)taxname from uf_dmsd_exfeeqzfp a where a.requestid = '"+requestid+"'";//查询发票信息
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size() >0)
{
	for(int i = 0;i<sublist.size();i++)
	{
		Map m2 = (Map)sublist.get(i);
		String invoiceno = StringHelper.null2String(m2.get("invoiceno"));//发票号码
		String tax = StringHelper.null2String(m2.get("tax"));//税额
		String taxname= StringHelper.null2String(m2.get("taxname"));//税码
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
			insql = "insert into uf_dmsd_exfeeqzpz(id,requestid,sno,accountcode,subject,money,taxcaode,text1)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'40','"+subject+"',"+tax+",'"+taxname+"','增值税-"+invoiceno+"')";
			baseJdbc.update(insql);
			System.out.println(insql);
		}
	}
}*/




//第四部分(默认总账科目对应发票税金)
//System.out.println("第四部分");
//查询发票信息
sql = "select sum(a.tax)tax,(select tax from uf_dmsd_taxwh where requestid=a.invoicetype)taxname,a.taxrate from uf_dmsd_exfeeqzfp a where a.requestid = '"+requestid+"' group by a.invoicetype,a.taxrate";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size() >0)
{
	for(int c = 0;c<sublist.size();c++)
	{
		Map mc = (Map)sublist.get(c);
		String tax = StringHelper.null2String(mc.get("tax"));//税金合计
		String taxname = StringHelper.null2String(mc.get("taxname"));//发票税码
		String taxrate = StringHelper.null2String(mc.get("taxrate"));//税率
		if(Double.valueOf(tax) >0)//发票税金>0，显示；发票税金=0，不显示
		{
			String subject = "21710101";//默认总账科目
			double sjjs = Double.valueOf(tax)/(Double.valueOf(taxrate)/100);//税金基数
			String strsjjs = String.format("%.2f",sjjs);//四舍五入保留两位小数
			
			count++;
			insql = "insert into uf_dmsd_exfeeqzpz(id,requestid,sno,subject,money,sjjs,taxcaode,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"',"+tax+",'"+strsjjs+"','"+taxname+"','Export Invoice Tax','40285a8d5763da3c0157646db1b4053b')";
			baseJdbc.update(insql);
			//System.out.println(insql);
		}
	}
}





//第五部分(固定总账科目对应汇兑差)
//System.out.println("第五部分");
//计算汇兑差
//如果业务货币差额为0 ，汇兑差=本位币差额
//否则：汇兑差=本位币差额-（业务货币差额*清账汇率）
sql = "select a.buscurrencydiff,a.currencydiff,a.qzrate,a.estcurrency,a.qzcurr,a.costcenter,(select subject from uf_dmdb_feename where feename=a.feetype and imextype='40285a8d56d542730156e95e821c3061')subject from uf_dmsd_exfeeqzmx a where a.requestid = '"+requestid+"'";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size() >0)
{
	Double hdc = 0.00;//汇兑差
	for(int m = 0;m<sublist.size();m++)
	{
		Map m4 = (Map)sublist.get(m);
		String qzhl = StringHelper.null2String(m4.get("qzrate"));//清帐汇率
		String zgcurr = StringHelper.null2String(m4.get("estcurrency"));//暂估币种
		String qzcurr = StringHelper.null2String(m4.get("qzcurr"));//清帐币种
		String buscurrencydiff = StringHelper.null2String(m4.get("buscurrencydiff"));//业务货币差额
		String currencydiff = StringHelper.null2String(m4.get("currencydiff"));//本位币差额
		String cscen = StringHelper.null2String(m4.get("costcenter"));//成本中心
		if(cscen.equals(""))
		{
			cscen = "M0163110";
		}
		String subject = StringHelper.null2String(m4.get("subject"));//汇兑差总账科目
		if(!zgcurr.equals("")&&!qzcurr.equals(""))
		{
			if(!zgcurr.equals(qzcurr))//币种不同存在汇兑差
			{
				hdc = Double.valueOf(currencydiff)-(Double.valueOf(buscurrencydiff)*Double.valueOf(qzhl));
			}
		}
		DecimalFormat df2 = new DecimalFormat("###.00");//保留两位小数
		hdc = Double.valueOf(df2.format(hdc));
		if(hdc!=0)
		{
			count++;
			insql = "insert into uf_dmsd_exfeeqzpz(id,requestid,sno,subject,money,taxcaode,costcenter,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+subject+"',"+Math.abs(Double.valueOf(hdc))+",'','"+cscen+"','汇兑差','40285a8d5763da3c0157646db1b4053b')";
			baseJdbc.update(insql);
			//System.out.println(insql);
		}	
	}
}






//第六部分(总账科目对应其他费用会计明细)
System.out.println("第六部分");
sql = "select ledgersubject,accountcode,feetype,addfeetotal,addfeecurrtotal,costcenter,receiptid,receiptitem,taxcode from uf_dmsd_exfeeqzkj where requestid = '"+requestid+"' order by sno asc";
//System.out.println(sql);
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
		if(costcenter.equals(""))
		{
			costcenter = "M0163110";
		}
		String receiptid = StringHelper.null2String(m3.get("receiptid"));//销售订单号
		String receiptitem = StringHelper.null2String(m3.get("receiptitem"));//销售订单项次
		Double abnfee = 0.00;//增额费用本位币小计
		String taxcode11= StringHelper.null2String(m3.get("taxcode"));//税码
		abnfee = Math.abs(Double.valueOf(addfeecurrtotal));//增额费用本位币小计
		//System.out.println("增额费用本位币小计:"+abnfee);
		if(abnfee >0)
		{
			count++;
			insql = "insert into uf_dmsd_exfeeqzpz(id,requestid,sno,subject,money,taxcaode,costcenter,receiptid,receiptitem,text1,iskmsupplier)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+ledgersubject+"',"+abnfee+",'"+taxcode11+"','"+costcenter+"','"+receiptid+"','"+receiptitem+"','"+feename+"','40285a8d5763da3c0157646db1b4053b')";
			baseJdbc.update(insql);
			//System.out.println(insql);
		}
	}
}



%>



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               