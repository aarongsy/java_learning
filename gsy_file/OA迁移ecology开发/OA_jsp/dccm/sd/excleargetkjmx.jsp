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
String zgcurren = StringHelper.null2String(request.getParameter("zgcurren"));//暂估币种
String fpcurren = StringHelper.null2String(request.getParameter("fpcurren"));//发票币种
String fphlz ="1"; //StringHelper.null2String(request.getParameter("fphl"));//发票汇率
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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->
<%
String delsql="delete uf_dmsd_exfeeqzkj where requestid='"+requestid+"'";
baseJdbc.update(delsql);
//清账明细
String sql = "select a.ledgersubject,a.feetype,c.stockno,c.costcenter costctr,c.saleorder voucherno,c.orderitem vitem,c.shipnum,c.netvalue,a.allocbase,a.invoicemoney,a.invoicenum,a.buscurrencydiff,a.currencydiff,a.qzrate,a.taxcode from  uf_dmsd_exfeeqzmx a inner join uf_dmsd_expboxmain b on a.exlistid=b.expno inner join uf_dmsd_shipment c on b.requestid =c.requestid where a.requestid='"+requestid+"' and a.buscurrencydiff is not null and a.buscurrencydiff<>0 order by a.feetype desc";
List sublist = baseJdbc.executeSqlForList(sql);
System.out.println("-------------------------------------------");
int count=0;
if(sublist.size()>0)
{
	for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String ledgersubject=StringHelper.null2String(mk.get("ledgersubject"));//总账科目
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用类型
		String stockno=StringHelper.null2String(mk.get("stockno"));//物料号
		String costctr=StringHelper.null2String(mk.get("costctr"));//成本中心
		String voucherno=StringHelper.null2String(mk.get("voucherno"));//销售凭证号
		String vitem=StringHelper.null2String(mk.get("vitem"));//销售凭证项次
		String shipnum=StringHelper.null2String(mk.get("shipnum"));//本次发货数量
		String fphl=StringHelper.null2String(mk.get("qzrate"));//清帐汇率(发票汇率)
		String taxcode=StringHelper.null2String(mk.get("taxcode"));
		if(shipnum.equals("") || shipnum == null )shipnum = "0";

		String netvalue=StringHelper.null2String(mk.get("netvalue"));//净价值
		if(netvalue.equals("") || netvalue == null )netvalue = "0";

		String allocbase = StringHelper.null2String(mk.get("allocbase"));//分摊基数
		String invoicemoney = StringHelper.null2String(mk.get("invoicemoney"));//发票数量
		if(invoicemoney.equals("") || invoicemoney == null )invoicemoney = "0";

		String invoicenum = StringHelper.null2String(mk.get("invoicenum"));//发票金额
		if(invoicenum.equals("") || invoicenum == null )invoicenum = "0";

		String amount = StringHelper.null2String(mk.get("buscurrencydiff"));//业务货币差额
		String rmbamount = StringHelper.null2String(mk.get("currencydiff"));//本位币货币差额
		if(amount.equals("") || amount == null )amount = "0";
		if(rmbamount.equals("") || rmbamount == null )rmbamount = "0";

		String jzm="";
		Double zgmon = 0.00;//业务货币差额
		Double zgrmbmon = 0.00;//本位币货币差额
		Double amort = 0.00;//分摊比例
		String mon1 ="";
		String mon2="";
     	if(no <sublist.size())//
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//费用名称2
			if(!feetype2.equals(feetype))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				String sql6="select sum(a.buscurrencydiff) buscurrencydiff,sum(a.currencydiff) currencydiff from  uf_dmsd_exfeeqzmx  a where a.requestid='"+requestid+"' and a.feetype = '"+feetype+"' and a.buscurrencydiff is not null and a.buscurrencydiff<>0";
				List sublist6 = baseJdbc.executeSqlForList(sql6);
				if(sublist6.size()>0)
				{
					Map mk6 = (Map)sublist6.get(0);
					amount = StringHelper.null2String(mk6.get("buscurrencydiff"));//业务货币差额
					rmbamount = StringHelper.null2String(mk6.get("currencydiff"));//本位币货币差额
					if(amount.equals("") || amount == null )amount = "0";
					if(rmbamount.equals("") || rmbamount == null )rmbamount = "0";
				}
				String sql2 = "select sum(buscurrencydiff) as zgmon,sum(currencydiff) as zgrmbmon from uf_dmsd_exfeeqzkj where requestid = '"+requestid+"' and feetype = '"+feetype+"'";
				//System.out.println(sql2);
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)//
				{
					Map mk3 = (Map)sublist2.get(0);
					 mon1 = StringHelper.null2String(mk3.get("zgmon"));;//已被占用的业务货币差额
					 mon2 = StringHelper.null2String(mk3.get("zgrmbmon"));;//已被占用的本位币货币差额
					if(mon1.equals("") || mon1 == null )mon1 = "0";
					if(mon2.equals("") || mon2 == null )mon2 = "0";

					zgmon = Double.valueOf(amount)-Double.valueOf(mon1);//获取剩余业务货币差额
					//zgrmbmon = Double.valueOf(rmbamount)-Double.valueOf(mon2);//获取剩余本位币货币差额
					//zgrmbmon = Double.valueOf(amount)*Double.valueOf(qzrate)-Double.valueOf(mon1)*Double.valueOf(qzrate);
					DecimalFormat df = new DecimalFormat("#0.00");
					zgrmbmon = Double.valueOf(amount)*Double.valueOf(fphl)-Double.valueOf(mon2);

				}
				else
				{
					
					zgmon = Double.valueOf(amount);//获取剩余业务货币金额=总金额
					//zgrmbmon = Double.valueOf(rmbamount);//获取剩余本位币货币金额=总金额
					DecimalFormat df = new DecimalFormat("#0.00");
					zgrmbmon = Double.valueOf(amount)*Double.valueOf(fphl);
				}
				//System.out.println("fyzuihou");
				//System.out.println(feetype+"::::::"+feetype2);
				//System.out.println(Double.valueOf(amount)*Double.valueOf(fphl));

				//System.out.println(Double.valueOf(mon1)*Double.valueOf(fphl));
				//System.out.println(mon2);
			}
			else //如果下一个费用名称与当前的费用名称一致，则说明当前的费用名称不是最后一个。
			{
				//按照发票数量进行分摊或者（发票金额分摊并且发票金额为0）

				//会计明细的业务货币差额 = （外销联络单出货明细的本次发货数量/本申请单清帐明细的行项发票总数量）* 本申请单清帐明细的行项业务货币差额
				//会计明细的本位币差额：
				//如暂估币种和发票币种一致，则= （外销联络单出货明细的本次发货数量/本申请单清帐明细的行项发票总数量）* （本申请单清帐明细的行项本位币差额）
				//如暂估币种和发票币种不一致，则=（外销联络单出货明细的本次发货数量/本申请单清帐明细的行项发票总数量）* （本申请单清帐明细的行项业务货币差额*申请单的发票汇率）

				if(allocbase.equals("40285a8d56d542730156e97ce31831ff")||(allocbase.equals("40285a8d56d542730156e97ce3183200")&&invoicenum.equals("0")))
				{
					 amort = (Double.valueOf(shipnum)/Double.valueOf(invoicemoney));
					 zgmon= Double.valueOf(amount) *amort;//业务货币差额
					 if(fpcurren.equals(zgcurren))//币种一致
					{
						zgrmbmon = Double.valueOf(rmbamount) *amort;//本位币差额
					}
					else
					{
						DecimalFormat df1 = new DecimalFormat("#0.00");   
						// df1.format(zgmon); 
						zgrmbmon = Double.valueOf(amount) *amort*Double.valueOf(fphl);//本位币差额
						//zgrmbmon = Double.valueOf(df1.format(zgmon))*Double.valueOf(fphl);//本位币差额
					}
					/*System.out.println("**");
					System.out.println(zgmon+"*"+fphl);
					System.out.println(fphl);*/
				}
				else//按照发票金额进行分摊
				//（外销联络单出货明细的净价值/本申请单清帐明细的行项发票总金额）*本申请单其他费用的行项清帐未税金额

				{
					 amort = (Double.valueOf(netvalue)/Double.valueOf(invoicenum));
					 zgmon= Double.valueOf(amount) *amort;//业务货币差额
					 if(fpcurren.equals(zgcurren))//币种一致
					{
						zgrmbmon = Double.valueOf(rmbamount) *amort;//本位币差额
					}
					else
					{
						DecimalFormat df2 = new DecimalFormat("#0.00"); 
						zgrmbmon = Double.valueOf(amount) *amort*Double.valueOf(fphl);//本位币差额
						//zgrmbmon = Double.valueOf(df2.format(zgmon)) *Double.valueOf(fphl);//本位币差额
					}

					/*System.out.println("***-");
					System.out.println(zgmon+"*"+fphl);
					System.out.println(fphl);*/
				}
			}
		}
		else//当前行为最后一行
		{
			String sql4="select sum(a.buscurrencydiff) buscurrencydiff,sum(a.currencydiff) currencydiff from uf_dmsd_exfeeqzmx  a  where a.requestid='"+requestid+"'  and a.buscurrencydiff is not null and a.buscurrencydiff<>0";
			List sublist4 = baseJdbc.executeSqlForList(sql4);
			if(sublist4.size()>0)
			{
				Map mk5 = (Map)sublist4.get(0);
				amount = StringHelper.null2String(mk5.get("buscurrencydiff"));//业务货币差额
				rmbamount = StringHelper.null2String(mk5.get("currencydiff"));//本位币货币差额
				if(amount.equals("") || amount == null )amount = "0";
				if(rmbamount.equals("") || rmbamount == null )rmbamount = "0";
				//System.out.println(amount);
			}
			String sql3 = "select sum(buscurrencydiff) as zgmon,sum(currencydiff) as zgrmbmon from uf_dmsd_exfeeqzkj where requestid = '"+requestid+"'";
			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				 mon1 = StringHelper.null2String(mk4.get("zgmon"));;//已被占用的业务货币金额
				 mon2 = StringHelper.null2String(mk4.get("zgrmbmon"));;//已被占用的本位币金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				zgmon = Double.valueOf(amount)-Double.valueOf(mon1);//
				//zgrmbmon = Double.valueOf(rmbamount)-Double.valueOf(mon2);//
				//zgrmbmon = Double.valueOf(amount)*Double.valueOf(fphl)-Double.valueOf(mon1)*Double.valueOf(fphl);
				zgrmbmon = Double.valueOf(amount)*Double.valueOf(fphl)-Double.valueOf(mon2);
				//System.out.println("no:"+no);
				if(sublist.size()>1)
				{
					Map mk21 = (Map)sublist.get(no-2);
					String feetype21=StringHelper.null2String(mk21.get("feetype"));//费用名称2
					if(!feetype21.equals(feetype))//如果上一个费用名称与当前的费用名称不一致，则说明最后一行费用只有一行。
					{
						zgrmbmon = Double.valueOf(zgmon)*Double.valueOf(fphl);
					}
					else
					{
						System.out.println("11111111111111111");
						DecimalFormat df = new DecimalFormat("#0.00");   
						zgrmbmon = Double.valueOf(df.format(Double.valueOf(amount)*Double.valueOf(fphl)))-Double.valueOf(mon2);
	
					}
				}
				else//只有一行
				{
					System.out.println("222222222222222");
					DecimalFormat df = new DecimalFormat("#0.00"); 
					//System.out.println(df.format(Double.valueOf(amount)*Double.valueOf(fphl)));
					//zgrmbmon = Double.valueOf(df.format(Double.valueOf(amount)*Double.valueOf(fphl)))-Double.valueOf(mon2);
					zgrmbmon = Double.valueOf(amount)*Double.valueOf(fphl)-Double.valueOf(mon2);

				}
				/*System.out.println("zuihouyihang");
				System.out.println(feetype);
				System.out.println(mon1);
				System.out.println(Double.valueOf(amount)*Double.valueOf(fphl));
				System.out.println(Double.valueOf(mon1)*Double.valueOf(fphl));
				System.out.println(mon2);
				System.out.println(zgrmbmon);*/
			}
			else
			{
				zgmon =Double.valueOf(amount);//
				//zgrmbmon = Double.valueOf(rmbamount);//
				zgrmbmon = Double.valueOf(amount)*Double.valueOf(fphl);
			}
		}
		//记账码
		if(zgrmbmon>0||zgmon>0)
		{
			jzm="40";
		}
		else if(zgrmbmon<0||zgmon<0)
		{
			jzm="50";
		}
		else
		{
			jzm="";
		}
		DecimalFormat df = new DecimalFormat("#0.00");   
		//amount = df.format(zgmon); 
		//rmbamount = df.format(zgrmbmon); 
		amount = Double.toString(zgmon); 
		rmbamount = Double.toString(zgrmbmon); 

		//分摊明细
		if(!jzm.equals(""))
		{
			count++;
			String insql = "insert into uf_dmsd_exfeeqzkj (id,requestid,sno,ledgersubject,feetype,currency,rate,buscurrencydiff,currencydiff,addfeetotal,addfeecurrtotal,materialid,costcenter,receiptid,receiptitem,accountcode,taxcode)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+ledgersubject+"','"+feetype+"','"+fpcurren+"',"+fphl+","+amount+","+rmbamount+","+amount+","+rmbamount+",'"+stockno+"','"+costctr+"','"+voucherno+"','"+vitem+"','"+jzm+"','"+taxcode+"')";
			baseJdbc.update(insql);
			//System.out.println("insql1:"+insql);
		}
	}
}




//其他费用明细
sql = "select a.ledgersubject,a.feetype,(select feename from uf_dmdb_feename where requestid=a.feetype) as feetype1,b.stockno,b.costcenter costctr,b.saleorder voucherno, b.orderitem vitem,b.shipnum,b.netvalue,a.allocbase,a.invociemoney,a.invoicenum,a.clearnotaxamount,a.clearamount,a.tax,(select tax from uf_dmsd_taxwh where requestid=a.tax)taxcode,a.taxrate,a.cleartaxamount from  uf_dmsd_exfeegzqtmx  a inner join uf_dmsd_shipment b on a.exlistid=b.requestid where a.requestid='"+requestid+"' and a.clearnotaxamount is not null and a.clearnotaxamount<>0 order by a.feetype asc";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String ledgersubject=StringHelper.null2String(mk.get("ledgersubject"));//总账科目
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用类型
		String feetype1=StringHelper.null2String(mk.get("feetype1"));//费用类型(文本)
		String stockno=StringHelper.null2String(mk.get("stockno"));//物料号
		String costctr=StringHelper.null2String(mk.get("costctr"));//成本中心
		String voucherno=StringHelper.null2String(mk.get("voucherno"));//销售凭证号
		String vitem=StringHelper.null2String(mk.get("vitem"));//销售凭证项次
		String shipnum=StringHelper.null2String(mk.get("shipnum"));//本次发货数量
		if(shipnum.equals("") || shipnum == null )shipnum = "0";
		String netvalue=StringHelper.null2String(mk.get("netvalue"));//净价值
		if(netvalue.equals("") || netvalue == null )netvalue = "0";
		String allocbase = StringHelper.null2String(mk.get("allocbase"));//分摊基数
		String invoicemoney = StringHelper.null2String(mk.get("invoicemoney"));//发票金额
		if(invoicemoney.equals("") || invoicemoney == null )invoicemoney = "0";
		String invoicenum = StringHelper.null2String(mk.get("invoicenum"));//发票数量
		if(invoicenum.equals("") || invoicenum == null )invoicenum = "0";
   
   
   

		String amount = StringHelper.null2String(mk.get("clearnotaxamount"));//清账未税金额
		String rmbamount = StringHelper.null2String(mk.get("clearamount"));//清账本位币金额
		String taxamount = StringHelper.null2String(mk.get("cleartaxamount"));//清账含税金额
		
		
		
		//String fphl = StringHelper.null2String(mk.get("qzhl"));//清帐汇率
		if(amount.equals("") || amount == null )amount = "0";
		if(rmbamount.equals("") || rmbamount == null )rmbamount = "0";
		if(taxamount.equals("") || taxamount == null )taxamount = "0";
		String taxcode=StringHelper.null2String(mk.get("taxcode"));//税码(文本)
		String taxrate=StringHelper.null2String(mk.get("taxrate"));//税率

		Double zgtaxmon = 0.00;//清账含税金额
		Double zgmon = 0.00;//清账未税金额
		Double zgrmbmon = 0.00;//清账本位币金额
		Double amort = 0.00;//分摊比例

     	if(no <sublist.size())//
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype1"));//费用名称2
			if(!feetype2.equals(feetype1))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				String sql6="select sum(a.clearnotaxamount) clearnotaxamount,sum(a.clearamount) clearamount,sum(cleartaxamount)cleartaxamount from  uf_dmsd_exfeegzqtmx  a where a.requestid='"+requestid+"' and a.feetype = '"+feetype+"' and a.clearnotaxamount is not null and a.clearnotaxamount<>0";
				//System.out.println("111111111111111"+sql6);
				List sublist6 = baseJdbc.executeSqlForList(sql6);
				if(sublist6.size()>0)
				{
					Map mk6 = (Map)sublist6.get(0);
					amount = StringHelper.null2String(mk6.get("clearnotaxamount"));//清账未税金额
					rmbamount = StringHelper.null2String(mk6.get("clearamount"));//清账本位币金额
					taxamount = StringHelper.null2String(mk6.get("cleartaxamount"));//清账含税金额
					if(amount.equals("") || amount == null )amount = "0";
					if(rmbamount.equals("") || rmbamount == null )rmbamount = "0";
					if(taxamount.equals("") || taxamount == null )taxamount = "0";
				}

				String sql2 = "select sum(abnfeemoney) as zgmon,sum(abncurrmoney) as zgrmbmon,sum(qztaxamount) as zgtaxmon from uf_dmsd_exfeeqzkj where requestid = '"+requestid+"' and feetype = '"+feetype1+"'";
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)
				{
					Map mk3 = (Map)sublist2.get(0);
					String mon1 = StringHelper.null2String(mk3.get("zgmon"));;//已被占用的异常费用金额
					String mon2 = StringHelper.null2String(mk3.get("zgrmbmon"));;//已被占用的异常费用本位币金额
					String mon3 = StringHelper.null2String(mk3.get("zgtaxmon"));;//已被占用的清帐含税金额
					if(mon1.equals("") || mon1 == null )mon1 = "0";
					if(mon2.equals("") || mon2 == null )mon2 = "0";
					if(mon3.equals("") || mon3 == null )mon3 = "0";
					zgmon = Double.valueOf(amount)-Double.valueOf(mon1);//获取剩余异常费用金额
					zgrmbmon = Double.valueOf(rmbamount)-Double.valueOf(mon2);//获取剩余异常费用本位币金额
					zgtaxmon = Double.valueOf(taxamount)-Double.valueOf(mon3);//获取剩余清帐含税金额
				}
				else
				{
					zgmon = Double.valueOf(amount);//获取剩余异常费用金额=总金额
					zgrmbmon = Double.valueOf(rmbamount);//获取剩余异常费用本位币金额=总金额
					zgtaxmon = Double.valueOf(taxamount);//获取剩余清帐含税金额=总金额
				}
			}
			else //如果下一个费用名称与当前的费用名称一致，则说明当前的费用名称不是最后一个。
			{
				//按照发票数量进行分摊
				//会计明细的异常费用金额= （外销联络单出货明细的本次发货数量/本申请单其他费用的行项发票总数量）* 本申请单其他费用的行项清帐未税金额
				//会计明细的异常费用本位币差额 = （外销联络单出货明细的本次发货数量/本申请单其他费用的行项发票总数量）* 本申请单其他费用的行项清帐本位币金额
				//if(allocbase.equals("40285a90497a8f7801497d967012006a"))
				if(allocbase.equals("40285a8d56d542730156e97ce31831ff")||(allocbase.equals("40285a8d56d542730156e97ce3183200")&&invoicemoney.equals("0")))
				{
					amort = (Double.valueOf(shipnum)/Double.valueOf(invoicenum));
					zgmon= Double.valueOf(amount) *amort;//业务货币差额
					zgrmbmon = Double.valueOf(rmbamount) *amort;//本位币差额
					zgtaxmon = Double.valueOf(taxamount) *amort;
				}
				else//按照发票金额进行分摊
				{
					amort = (Double.valueOf(netvalue)/Double.valueOf(invoicemoney));
					zgmon= Double.valueOf(amount) *amort;//业务货币差额
					zgrmbmon = Double.valueOf(rmbamount) *amort;//本位币差额
					zgtaxmon = Double.valueOf(taxamount) *amort;
				}
			}
		}
		else//当前行为最后一行
		{
			String sql4="select sum(a.clearnotaxamount) clearnotaxamount,sum(a.clearamount) clearamount,sum(cleartaxamount)cleartaxamount from  uf_dmsd_exfeegzqtmx a  where a.requestid='"+requestid+"' and a.feetype = '"+feetype+"' and a.clearnotaxamount is not null and a.clearnotaxamount<>0";
			//System.out.println("22222222222"+sql4);
			List sublist4 = baseJdbc.executeSqlForList(sql4);
			if(sublist4.size()>0)
			{
				Map mk5 = (Map)sublist4.get(0);
				amount = StringHelper.null2String(mk5.get("clearnotaxamount"));//清账未税金额
				rmbamount = StringHelper.null2String(mk5.get("clearamount"));//清账本位币金额
				taxamount = StringHelper.null2String(mk5.get("cleartaxamount"));//清帐含税金额
				if(amount.equals("") || amount == null )amount = "0";
				if(rmbamount.equals("") || rmbamount == null )rmbamount = "0";
				if(taxamount.equals("") || taxamount == null )taxamount = "0";
			}

			String sql3 = "select sum(abnfeemoney) as zgmon,sum(abncurrmoney) as zgrmbmon,sum(qztaxamount) as zgtaxmon  from uf_dmsd_exfeeqzkj  where requestid = '"+requestid+"' and feetype = '"+feetype1+"'";

			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("zgmon"));//已被占用的异常费用金额
				String mon2 = StringHelper.null2String(mk4.get("zgrmbmon"));//已被占用的异常费用本位币金额
				String mon3 = StringHelper.null2String(mk4.get("zgtaxmon"));//已被占用的清帐含税金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				if(mon3.equals("") || mon3 == null )mon3 = "0";
				zgmon = Double.valueOf(amount)-Double.valueOf(mon1);
				zgrmbmon = Double.valueOf(rmbamount)-Double.valueOf(mon2);
				zgtaxmon = Double.valueOf(taxamount)-Double.valueOf(mon3);
			}
			else
			{
				zgmon =Double.valueOf(amount);
				zgrmbmon = Double.valueOf(rmbamount);
				zgtaxmon = Double.valueOf(taxamount);
			}
		}

		DecimalFormat df = new DecimalFormat("#0.00");   
		amount = df.format(zgmon); 
		rmbamount = df.format(zgrmbmon); 
		taxamount = df.format(zgtaxmon); 
		//分摊明细
		//System.out.println(amount);
		//System.out.println(rmbamount);
		count++;
		String insql = "insert into uf_dmsd_exfeeqzkj (id,requestid,sno,ledgersubject,feetype,currency,rate,abnfeemoney,abncurrmoney,addfeetotal,addfeecurrtotal,materialid,costcenter,receiptid,receiptitem,accountcode,taxcode,taxrate,qztaxamount)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+ledgersubject+"','"+feetype1+"','"+fpcurren+"',"+fphlz+","+amount+","+rmbamount+","+amount+","+rmbamount+",'"+stockno+"','"+costctr+"','"+voucherno+"','"+vitem+"','40','"+taxcode+"','"+taxrate+"','"+taxamount+"')";
		baseJdbc.update(insql);
		//System.out.println("insql2:+"+insql);
	}
}


%>

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          