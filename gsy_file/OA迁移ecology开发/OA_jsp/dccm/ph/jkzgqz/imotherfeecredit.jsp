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
//String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//到货类型
//String rate = StringHelper.null2String(request.getParameter("rate"));//汇率
//String currency = StringHelper.null2String(request.getParameter("currency"));//发票币种
//String zgcurr = StringHelper.null2String(request.getParameter("zgcurr"));//暂估币种
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



<Div id="warpp"  >
<table id="dataTables3" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%" style="display:none">
<COL width="5%" style="display:none">
<COL width="5%">
<COL width="5%">
<COL width="5%" style="display:none">
<COL width="5%" style="display:none">
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
//清空其他费用清帐会计明细
String delsql = "delete uf_dmph_ecicoecadetails where requestid = '"+requestid+"'";
baseJdbc.update(delsql);

//到货明细(进口提单)uf_dmph_arrivaldetail
//其他费用明细uf_dmph_icoexpendetail
String sql = "";

sql = "select (select tax from uf_dmsd_taxwh where requestid=a.gst)taxcode,(select rate from uf_dmsd_taxwh where requestid=a.gst)taxrate,a.feetype,a.ledgersubject,(select feename from uf_dmdb_feename where requestid = a.feetype)feename,a.allobase,(select objname from selectitem where id = a.allobase)ftjs,a.clearnotaxmoney,a.clearcurrmoney,a.cleartaxmoney,a.invoicetotal,a.currency,a.bzrate,a.invoiceamount,b.itemnum,b.costcenter,b.ordernum,b.orderlineitem,(select ibolnum from uf_dmph_importbilllad  where requestid = b.requestid) as imgoodsid,b.iboltimes ,b.invoicenum,b.invoiceamount  from uf_dmph_icoexpendetail a inner join uf_dmph_arrivaldetail b on b.requestid = a.imgoodsid where a.requestid = '"+requestid+"' order by imgoodsid asc, a.feetype asc ";


System.out.println(sql);
DecimalFormat df=new DecimalFormat(".##");//保留两位小数
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String taxcode = StringHelper.null2String(mk.get("taxcode"));//税码
		String taxrate = StringHelper.null2String(mk.get("taxrate"));//税率
		String subject = StringHelper.null2String(mk.get("ledgersubject"));//总账科目
		String curr = StringHelper.null2String(mk.get("currency"));//清帐币别
		String rate = StringHelper.null2String(mk.get("bzrate"));//清帐汇率
		
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称(id)
		String feename=StringHelper.null2String(mk.get("feename"));//费用名称(txt)

		String allobase = StringHelper.null2String(mk.get("allobase"));//分摊基数(id)
		String ftjs=StringHelper.null2String(mk.get("ftjs"));//分摊基数(txt)

		String clearnotaxmoney=StringHelper.null2String(mk.get("clearnotaxmoney"));//清帐未税金额
		if(clearnotaxmoney.equals(""))
		{
			clearnotaxmoney="0.00";
		}
		String clearcurrmoney=StringHelper.null2String(mk.get("clearcurrmoney"));//清帐本位币金额
		if(clearcurrmoney.equals(""))
		{
			clearcurrmoney="0.00";
		}
		String cleartaxmoney = StringHelper.null2String(mk.get("cleartaxmoney"));//清账含税金额
		if(cleartaxmoney.equals(""))
		{
			cleartaxmoney="0.00";
		}
		
		//String materialid = "";//物料号
		//String assetsid = "";//资产号
		///String innerorderid = "";//内部订单号
		//if(goodtype.equals("40285a90492d5248014930386c190174"))//如果是物料类
		//{
			//materialid = StringHelper.null2String(mk.get("itemnum"));//物料号
		//}

		String invoicenum=StringHelper.null2String(mk.get("invoicenum"));//发票数量
		String invoicemoney=StringHelper.null2String(mk.get("invoiceamount"));//发票金额
		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心
		String orderid=StringHelper.null2String(mk.get("ordernum"));//采购订单号
		String item=StringHelper.null2String(mk.get("orderlineitem"));//采购订单行项目
		String imgoodsid=StringHelper.null2String(mk.get("imgoodsid"));//进口提单编号
		String ladingid=StringHelper.null2String(mk.get("iboltimes"));//进口提单编号项次
		String invoicetotal=StringHelper.null2String(mk.get("invoicetotal"));//发票总数量
		String invoiceamount=StringHelper.null2String(mk.get("invoiceamount"));//发票总金额


		Double leftmon = 0.00;//剩余异常费用金额
		Double leftrmbmon = 0.00;//剩余异常费用本位币金额
		Double lefttaxmon = 0.00;//剩余清帐含税金额
		Double amort = 0.00;//分摊比例
		
		if(no <sublist.size())
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//费用名称2(id)
			//String imgoodsid2=StringHelper.null2String(mk.get("imgoodsid"));//进口到货编号2
			if(!feetype2.equals(feetype))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				//System.out.println("当前行的费用名称与下一行的费用名称不一致");
				String sql2 = "select sum(abnfeemoney) as abnfeemoney,sum(abncurrmoney) as abncurrmoney,sum(qztaxamount)qztaxamount from uf_dmph_ecicoecadetails where requestid = '"+requestid+"' and feetype = '"+feename+"' and imgoodsid = '"+imgoodsid+"'";
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)
				{
					Map mk3 = (Map)sublist2.get(0);
					String mon1 = StringHelper.null2String(mk3.get("abnfeemoney"));//已被占用的异常费用金额
					String mon2 = StringHelper.null2String(mk3.get("abncurrmoney"));//已被占用的异常费用本位币金额
					String mon3 = StringHelper.null2String(mk3.get("qztaxamount"));//已被占用的清帐含税金额
					if(mon1.equals("") || mon1 == null )mon1 = "0";
					if(mon2.equals("") || mon2 == null )mon2 = "0";
					if(mon3.equals("") || mon3 == null )mon3 = "0";

					leftmon = Double.valueOf(df.format(Double.valueOf(clearnotaxmoney)-Double.valueOf(mon1)));//获取剩余异常费用金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney)-Double.valueOf(mon2)));//获取剩余异常费用本位币金额
					lefttaxmon = Double.valueOf(df.format(Double.valueOf(cleartaxmoney)-Double.valueOf(mon3)));//获取剩余的清帐含税金额
					//System.out.println("fentan-"+no+"金额为:"+leftmon);
				}
				else
				{
					leftmon = Double.valueOf(clearnotaxmoney);//获取剩余异常费用金额=总金额
					leftrmbmon = Double.valueOf(clearcurrmoney);//获取剩余异常费用本位币金额=总金额
					lefttaxmon = Double.valueOf(cleartaxmoney);//获取剩余的清帐含税金额=总金额
				}
			}
			else //如果下一个费用名称与当前的费用名称一致，则说明当前的费用名称不是最后一个。
			{
				//System.out.println("当前行的费用名称与下一行的费用名称一致");
				if(allobase.equals("40285a8d56d542730156e97ce3183200"))//按照发票金额进行分摊
				{
					amort = (Double.valueOf(invoicemoney)/Double.valueOf(invoiceamount));
					//System.out.println(amort);
					//leftmon= Double.valueOf(clearnotaxmoney) *amort;//异常费用金额
					leftmon = Double.valueOf(df.format( Double.valueOf(clearnotaxmoney) *amort));//异常费用金额
					//System.out.println("fentan*"+no+"金额为:"+leftmon);
					//leftrmbmon = Double.valueOf(clearcurrmoney) *amort;//异常费用本位币金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney) *amort));//异常费用本位币金额
					lefttaxmon = Double.valueOf(df.format(Double.valueOf(cleartaxmoney) *amort));//清帐含税金额
				}
				else//按照发票数量进行分摊(马来厂按发票数量进行分摊)
				{
					amort = (Double.valueOf(invoicenum)/Double.valueOf(invoicetotal));
					leftmon=Double.valueOf(df.format( Double.valueOf(clearnotaxmoney) *amort));//异常费用金额
					leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney) *amort));//暂估本位币金额
					//System.out.println("fentan*"+no+"金额为:"+leftmon);
					lefttaxmon = Double.valueOf(df.format(Double.valueOf(cleartaxmoney) *amort));//清帐含税金额
				}
			}
		}
		else//当前行为最后一行
		{
			String sql3 = "select sum(abnfeemoney) as abnfeemoney,sum(abncurrmoney) as abncurrmoney,sum(qztaxamount)qztaxamount from uf_dmph_ecicoecadetails where requestid = '"+requestid+"' and feetype = '"+feename+"' and imgoodsid = '"+imgoodsid+"'";
			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("abnfeemoney"));//已被占用的异常费用金额
				String mon2 = StringHelper.null2String(mk4.get("abncurrmoney"));//已被占用的异常费用本位币金额
				String mon3 = StringHelper.null2String(mk4.get("qztaxamount"));//已被占用的清帐含税金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				if(mon3.equals("") || mon3 == null )mon3 = "0";
				//System.out.println("多行最后一行"+mon1);
				//System.out.println("测试!!!!!!!!!!!!"+mon2);
				leftmon = Double.valueOf(df.format(Double.valueOf(clearnotaxmoney)-Double.valueOf(mon1)));//获取剩余异常费用金额
				leftrmbmon = Double.valueOf(df.format(Double.valueOf(clearcurrmoney)-Double.valueOf(mon2)));//获取剩余异常费用本位币金额
				lefttaxmon = Double.valueOf(df.format(Double.valueOf(cleartaxmoney)-Double.valueOf(mon3)));//获取剩清帐含税金额
				//System.out.println("fentan-"+no+"金额为:"+leftmon);
			}
			else
			{
				leftmon =Double.valueOf(clearnotaxmoney);//获取剩余异常费用金额=总金额
				leftrmbmon = Double.valueOf(clearcurrmoney);//获取剩余异常费用本位币金额=总金额
				lefttaxmon = Double.valueOf(cleartaxmoney);//获取剩清帐含税金额=总金额
				//System.out.println("只有一行");
				//System.out.println("fentan-"+no+"金额为:"+leftmon);
			}
		}
		
		//String subject = "55063800";//总账科目默认值
		//String insql = "insert into uf_dmph_ecicoecadetails (id,requestid,sno,ledgersubject,feetype,currency,rate,buscurrencydiff,currencydiff,abnfeemoney,abncurrmoney,addfeetotal,addfeecurrtotal,materialid,costcenter,assetid,innerorderid,purorderid,purorderitem,imgoodsid,imgoodsitem)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+k+"','55063800','"+feetype+"','"+currency+"','"+rate+"','','','"+leftmon+"','"+leftrmbmon+"','"+leftmon+"','"+leftrmbmon+"','"+materialid+"','"+costcenter+"','"+assetsid+"','"+innerorderid+"','"+orderid+"','"+item+"','"+imgoodsid+"','"+ladingid+"')";
		
		String insql = "insert into uf_dmph_ecicoecadetails (id,requestid,sno,ledgersubject,feetype,currency,rate,buscurrencydiff,currencydiff,abnfeemoney,abncurrmoney,addfeetotal,addfeecurrtotal,qztaxamount,costcenter,purorderid,purorderitem,imgoodsid,imgoodsitem,taxcode,taxrate)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+k+"','"+subject+"','"+feename+"','"+curr+"','"+rate+"','','','"+leftmon+"','"+leftrmbmon+"','"+leftmon+"','"+leftrmbmon+"','"+lefttaxmon+"','"+costcenter+"','"+orderid+"','"+item+"','"+imgoodsid+"','"+ladingid+"','"+taxcode+"','"+taxrate+"')";
		baseJdbc.update(insql);
		//System.out.println(insql);
%>
		<TR id="<%="dataDetail_"+no %>">
		<TD  class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>
		<TD  class="td2"   align=center ><%=subject %></TD>
		<TD  class="td2"   align=center ><%=feename %></TD>
		<TD  class="td2"  align=center><%=curr %></TD>
		<TD  class="td2"  align=center><%=rate %></TD>
		<TD  class="td2"  align=center></TD><!--业务货币差额-->
		<TD  class="td2"  align=center></TD><!--本位币差额-->
		<TD  class="td2"  align=center><%=leftmon %></TD>
		<TD  class="td2"  align=center><%=leftrmbmon %></TD>
		<TD  class="td2"  align=center><%=leftmon %></TD>
		<TD  class="td2"   align=center ><%=leftrmbmon %></TD>
		<TD  class="td2"   align=center ></TD><!--物料号-->
		<TD  class="td2"  align=center><%=costcenter %></TD>
		<TD  class="td2"  align=center></TD><!--资产号-->
		<TD  class="td2"  align=center></TD><!--内部订单号-->
		<TD  class="td2"  align=center><%=orderid %></TD>
		<TD  class="td2"  align=center><%=item %></TD>
		<TD  class="td2"  align=center><%=imgoodsid %></TD>
		<TD  class="td2"  align=center><%=ladingid %></TD>
		</TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">NO Message!</TD></TR>
<%} %>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                