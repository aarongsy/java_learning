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
String supply = StringHelper.null2String(request.getParameter("supply"));//支付对象
String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//外销联络单编号
String xgroup = StringHelper.null2String(request.getParameter("xgroup"));//销售/文件小组
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
    height: 30px; 
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




<Div id="warpp">
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>Serial NO</TD><!--序号-->
<TD  noWrap class="td2"  align=center>Fee Type</TD><!--费用类型-->
<TD  noWrap class="td2"  align=center>Posting Key</TD><!--记账码-->
<TD  noWrap class="td2"  align=center>Subject</TD><!--总账科目-->
<TD  noWrap class="td2"  align=center>Closing Date</TD><!--预计结关日期-->
<TD  noWrap class="td2"  align=center>Payment Object</TD><!--支付对象-->
<TD  noWrap class="td2"  align=center>Estimation Currency</TD><!--暂估币种-->
<TD  noWrap class="td2"  align=center>Estimation Rate</TD><!--暂估汇率-->
<TD  noWrap class="td2"  align=center>Estimation Amount</TD><!--暂估金额-->
<TD  noWrap class="td2"  align=center>Estimation Amount(Local Currency)</TD><!--暂估本位币金额-->
<TD  noWrap class="td2"  align=center>Material</TD><!--物料号-->
<TD  noWrap class="td2"  align=center>Cost Centre</TD><!--成本中心-->
<TD  noWrap class="td2"  align=center>Sales Order NO</TD><!--销售凭证号-->
<TD  noWrap class="td2"  align=center>Sales Order Item</TD><!--销售凭证项次-->
</TR>

<%
String delsql = "delete uf_dmsd_exfeekjft where requestid = '"+requestid+"'";//删除历史数据(费用分摊) 
baseJdbc.update(delsql);
delsql = "delete uf_dmsd_exfeekjpag where requestid = '"+requestid+"'";//删除历史数据(装箱方式)
baseJdbc.update(delsql);
delsql = "delete uf_dmsd_exfeekjhz where requestid = '"+requestid+"'";//删除历史数据(费用汇总)
baseJdbc.update(delsql);
String noticeno="";
String sql ="";
String tmpsql = "";
if(supply.indexOf(",")!=-1)//存在多个支付对象
{
	System.out.println("存在多个支付对象");
	String[] array = supply.split("\\,");//分割字符串
	for(int i=0;i<array.length;i++)
	{
		if(i==0)
		{
			if(imgoodsno.equals(""))
			{
				sql= "select a.id,a.feename feetype,a.payto,c.feename costname,a.subject ledaccount,a.zgsub leger,a.bgdate closedate,a.curr currency,a.hl rate,a.jine amount,a.bwb rmbamount,t.cknos noticeno,b.costcenter costctr,b.stockno,b.saleorder voucherno,b.orderitem vitem,a.tax taxcode,c.sharetype sharebase,(select sum(shipnum) from uf_dmsd_shipment where requestid=b.requestid) as shiptotals,b.shipnum,(select tolnetval from uf_dmsd_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_dmsd_feedivvy a left join uf_dmsd_exfeezg t on t.requestid = a.requestid  left join uf_dmdb_feename c on a.feename = c.requestid inner join uf_dmsd_shipment b on b.requestid=t.cknos where  a.payto = '"+array[0]+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null) and t.spgroup='"+xgroup+"'  and not exists(select e.requestid from uf_dmsd_exfeekjft  e left join uf_dmsd_exfeekjmx m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid )";
			}
			else
			{
				sql= "select a.id,a.feename feetype,a.payto,c.feename costname,a.subject ledaccount,a.zgsub leger,a.bgdate closedate,a.curr currency,a.hl rate,a.jine amount,a.bwb rmbamount,t.cknos noticeno,b.costcenter costctr,b.stockno,b.saleorder voucherno,b.orderitem vitem,a.tax taxcode,c.sharetype sharebase,(select sum(shipnum) from uf_dmsd_shipment where requestid=b.requestid) as shiptotals,b.shipnum,(select tolnetval from uf_dmsd_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_dmsd_feedivvy a left join uf_dmsd_exfeezg t on t.requestid = a.requestid  left join uf_dmdb_feename c on a.feename = c.requestid inner join uf_dmsd_shipment b on b.requestid=t.cknos where t.cknos = '"+imgoodsno+"'  and a.payto = '"+array[0]+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null) and t.spgroup='"+xgroup+"' and not exists(select e.requestid from uf_dmsd_exfeekjft  e left join uf_dmsd_exfeekjmx m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid )";
			}
		}
		else
		{
			if(imgoodsno.equals(""))
			{
				tmpsql= "union all select a.id,a.feename feetype,a.payto,c.feename costname,a.subject ledaccount,a.zgsub leger,a.bgdate closedate,a.curr currency,a.hl rate,a.jine amount,a.bwb rmbamount,t.cknos noticeno,b.costcenter costctr,b.stockno,b.saleorder voucherno,b.orderitem vitem,a.tax taxcode,c.sharetype sharebase,(select sum(shipnum) from uf_dmsd_shipment where requestid=b.requestid) as shiptotals,b.shipnum,(select tolnetval from uf_dmsd_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_dmsd_feedivvy a left join uf_dmsd_exfeezg t on t.requestid = a.requestid  left join uf_dmdb_feename c on a.feename = c.requestid inner join uf_dmsd_shipment b on b.requestid=t.cknos where  a.payto = '"+array[i]+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null) and t.spgroup='"+xgroup+"'  and not exists(select e.requestid from uf_dmsd_exfeekjft  e left join uf_dmsd_exfeekjmx m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid )";
			}
			else
			{
				tmpsql= "union all select a.id,a.feename feetype,a.payto,c.feename costname,a.subject ledaccount,a.zgsub leger,a.bgdate closedate,a.curr currency,a.hl rate,a.jine amount,a.bwb rmbamount,t.cknos noticeno,b.costcenter costctr,b.stockno,b.saleorder voucherno,b.orderitem vitem,a.tax taxcode,c.sharetype sharebase,(select sum(shipnum) from uf_dmsd_shipment where requestid=b.requestid) as shiptotals,b.shipnum,(select tolnetval from uf_dmsd_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_dmsd_feedivvy a left join uf_dmsd_exfeezg t on t.requestid = a.requestid  left join uf_dmdb_feename c on a.feename = c.requestid inner join uf_dmsd_shipment b on b.requestid=t.cknos where t.cknos = '"+imgoodsno+"'  and a.payto = '"+array[i]+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null) and t.spgroup='"+xgroup+"' and not exists(select e.requestid from uf_dmsd_exfeekjft  e left join uf_dmsd_exfeekjmx m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid )";
			}
		}
		sql=sql+tmpsql;
	}
}
else//仅一个支付对象
{
	System.out.println("仅一个支付对象");
	if(imgoodsno.equals(""))
	{
		sql= "select a.id,a.feename feetype,a.payto,c.feename costname,a.subject ledaccount,a.zgsub leger,a.bgdate closedate,a.curr currency,a.hl rate,a.jine amount,a.bwb rmbamount,t.cknos noticeno,b.costcenter costctr,b.stockno,b.saleorder voucherno,b.orderitem vitem,a.tax taxcode,c.sharetype sharebase,(select sum(shipnum) from uf_dmsd_shipment where requestid=b.requestid) as shiptotals,b.shipnum,(select tolnetval from uf_dmsd_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_dmsd_feedivvy a left join uf_dmsd_exfeezg t on t.requestid = a.requestid  left join uf_dmdb_feename c on a.feename = c.requestid inner join uf_dmsd_shipment b on b.requestid=t.cknos where  a.payto = '"+supply+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null) and t.spgroup='"+xgroup+"'  and not exists(select e.requestid from uf_dmsd_exfeekjft  e left join uf_dmsd_exfeekjmx m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid ) order by a.feename asc,a.id asc";
	}
	else
	{
		sql= "select a.id,a.feename feetype,a.payto,c.feename costname,a.subject ledaccount,a.zgsub leger,a.bgdate closedate,a.curr currency,a.hl rate,a.jine amount,a.bwb rmbamount,t.cknos noticeno,b.costcenter costctr,b.stockno,b.saleorder voucherno,b.orderitem vitem,a.tax taxcode,c.sharetype sharebase,(select sum(shipnum) from uf_dmsd_shipment where requestid=b.requestid) as shiptotals,b.shipnum,(select tolnetval from uf_dmsd_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_dmsd_feedivvy a left join uf_dmsd_exfeezg t on t.requestid = a.requestid  left join uf_dmdb_feename c on a.feename = c.requestid inner join uf_dmsd_shipment b on b.requestid=t.cknos where t.cknos = '"+imgoodsno+"'  and a.payto = '"+supply+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null) and t.spgroup='"+xgroup+"' and not exists(select e.requestid from uf_dmsd_exfeekjft  e left join uf_dmsd_exfeekjmx m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid ) order by a.feename asc,a.id asc";
	}
}
//System.out.println(sql);


//double tolmyramount = 0.0;
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0)
{
	for(int k=0,sizek=sublist.size();k<sizek;k++)
	{
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String flag = "";
		String theid=StringHelper.null2String(mk.get("id"));//当前暂估分摊明细id
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称id
		String costname=StringHelper.null2String(mk.get("costname"));//费用名称txt
		String ledaccount=StringHelper.null2String(mk.get("ledaccount"));//费用总账科目
		String leger = StringHelper.null2String(mk.get("leger"));//暂估总账科目
		String closedate =StringHelper.null2String(mk.get("closedate"));//预计结关日期
		String currency=StringHelper.null2String(mk.get("currency"));//币种
		String rate = StringHelper.null2String(mk.get("rate"));//汇率
		String amount=StringHelper.null2String(mk.get("amount"));//暂估金额
		String rmbamount=StringHelper.null2String(mk.get("rmbamount"));//暂估本位币金额
		//System.out.println("rmbamount:"+rmbamount);
		//System.out.println("tolmyramount:"+tolmyramount);
		noticeno = noticeno+","+StringHelper.null2String(mk.get("noticeno"));//外销联络单
		String costctr=StringHelper.null2String(mk.get("costctr"));//成本中心
		String jzcode = "40";//记账码
		
		String materialid=StringHelper.null2String(mk.get("stockno"));//物料号
		String taxcode = StringHelper.null2String(mk.get("taxcode"));//税码
		String payobj = StringHelper.null2String(mk.get("payto"));//供应商简码
		String voucherno = StringHelper.null2String(mk.get("voucherno"));//销售凭证号
		String vitem = StringHelper.null2String(mk.get("vitem"));//凭证项次
		String sharebase = StringHelper.null2String(mk.get("sharebase"));//分摊基数
		String shiptotals = StringHelper.null2String(mk.get("shiptotals"));//发票总数量 ,本次出货数量合计
		String shiptotal = StringHelper.null2String(mk.get("shipnum"));//每个行项目对应的发票数量  本次出货数量
		String netpricesums = StringHelper.null2String(mk.get("netpricesums"));//发票总金额 ，净价值合计
		String netpricesum = StringHelper.null2String(mk.get("netvalue"));//每个行项目对应的发票金额 净价值

		Double zgmon = 0.00;//暂估金额
		Double zgrmbmon = 0.00;//暂估本位币金额
		Double amort = 0.00;//分摊比例
		if(no <sublist.size())
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//下一个费用名称
			String theid2=StringHelper.null2String(mk2.get("id"));//下一个费用暂估分摊明细id
			if(!theid2.equals(theid))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				String sql2 = "select sum(amount) as zgmon,sum(rmbamount) as zgrmbmon from uf_dmsd_exfeekjft where requestid = '"+requestid+"' and theid = '"+theid+"'";
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)
				{
					Map mk3 = (Map)sublist2.get(0);
					String mon1 = StringHelper.null2String(mk3.get("zgmon"));//已被占用的暂估金额
					String mon2 = StringHelper.null2String(mk3.get("zgrmbmon"));//已被占用的暂估本位币金额
					if(mon1.equals("") || mon1 == null )mon1 = "0";
					if(mon2.equals("") || mon2 == null )mon2 = "0";

					zgmon = Double.valueOf(amount)-Double.valueOf(mon1);//获取剩余暂估金额
					zgrmbmon = Double.valueOf(rmbamount)-Double.valueOf(mon2);//获取剩余暂估本位币金额
					//System.out.println("fentan-"+no+"金额为:"+zgmon);
				}
				else
				{
					zgmon = Double.valueOf(amount);//获取剩余暂估金额=总金额
					zgrmbmon = Double.valueOf(rmbamount);//获取剩余暂估本位币金额=总金额
				}
			}
			else //如果下一个费用名称与当前的费用名称一致，则说明当前的费用名称不是最后一个。
			{
				if(sharebase.equals("40285a8d56d542730156e97ce3183200")&&!(netpricesums.equals("")||netpricesums.equals("0")))//按照发票金额进行分摊（净价值/净价值合计）
				{
					amort = (Double.valueOf(netpricesum)/Double.valueOf(netpricesums));//分摊比例
					zgmon= Double.valueOf(amount) *amort;//暂估金额
					zgrmbmon = Double.valueOf(rmbamount) *amort;//暂估本位币金额
				}
				else//按照发票数量进行分摊（本次出货数量/本次出货数量合计）
				{
					amort = (Double.valueOf(shiptotal)/Double.valueOf(shiptotals));//分摊比例
					zgmon= Double.valueOf(amount) *amort;//暂估金额
					zgrmbmon = Double.valueOf(rmbamount) *amort;//暂估本位币金额
				}
			}
		}
		else//当前行为最后一行
		{
			String sql3 = "select sum(amount) as zgmon,sum(rmbamount) as zgrmbmon from uf_dmsd_exfeekjft where requestid = '"+requestid+"' and theid = '"+theid+"'";
			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("zgmon"));//已被占用的暂估金额
				String mon2 = StringHelper.null2String(mk4.get("zgrmbmon"));//已被占用的暂估本位币金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				zgmon = Double.valueOf(amount)-Double.valueOf(mon1);//获取剩余暂估金额
				zgrmbmon = Double.valueOf(rmbamount)-Double.valueOf(mon2);//获取剩余暂估本位币金额
				//System.out.println("fentan-"+no+"金额为:"+zgmon);
			}
			else
			{
				zgmon =Double.valueOf(amount);//获取剩余暂估金额=总金额
				zgrmbmon = Double.valueOf(rmbamount);//获取剩余暂估本位币金额=总金额
			}
		}
		
		DecimalFormat df = new DecimalFormat("#0.00");   
		amount = df.format(zgmon); 
		rmbamount = df.format(zgrmbmon);
		//tolmyramount = tolmyramount + Double.valueOf(rmbamount);//计算本位币合计
		//分摊明细
		String insql = "insert into uf_dmsd_exfeekjft(id,requestid,feetype,billcode,currency,rate,amount,rmbamount,ledaccount,closedate,materialid,custcenter,salesid,salesitem,payto,zgid,zgsubjects,taxcode,ftbase,ftamount,ftcount,theid)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+feetype+"','40','"+currency+"',"+rate+","+amount+","+rmbamount+",'"+ledaccount+"','"+closedate+"','"+materialid+"','"+costctr+"','"+voucherno+"','"+vitem+"','"+payobj+"','"+theid+"','"+leger+"','"+taxcode+"','"+sharebase+"','"+shiptotals+"','"+netpricesums+"','"+theid+"')";
		//System.out.println(insql);
		baseJdbc.update(insql);


		%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center ><%=no%></TD>
		<TD noWrap  class="td2"  align=center ><%=costname%></TD>
		<TD noWrap  class="td2"  align=center>40</TD>
		<TD noWrap  class="td2"  align=center><%=ledaccount%></TD>
		<TD noWrap  class="td2"  align=center><%=closedate%></TD>
		<TD noWrap  class="td2"  align=center><%=payobj%></TD>
		<TD noWrap  class="td2"  align=center><%=currency%></TD>
		<TD noWrap  class="td2"  align=center><%=rate%></TD>
		<TD noWrap  class="td2"  align=center><%=amount%></TD>
		<TD noWrap  class="td2"  align=center><%=rmbamount%></TD>
		<TD noWrap  class="td2"  align=center><%=materialid%></TD>
		<TD noWrap  class="td2"  align=center><%=costctr%></TD>
		<TD noWrap  class="td2"  align=center><%=voucherno%></TD>
		<TD noWrap  class="td2"  align=center><%=vitem%></TD>
		</TR>
		<%
	}
	//装箱方式
	//System.out.println("noticeno:"+noticeno);
	//String str=noticeno.substring(1);
	String str=imgoodsno;
	//System.out.println("str:"+str);
	//delsql = "delete uf_dmsd_exfeekjpag  where requestid = '"+requestid+"'";//删除历史数据
	//baseJdbc.update(delsql);
	//String zxsql="select (select cabtype from uf_dmdb_cabtype where requestid=a.cabtype) cabtype,count(distinct(a.sealno)) as num from uf_dmsd_loadtally a left join uf_dmsd_expboxmain b on a.requestid=b.requestid left join requestbase c on c.id =b.requestid where instr ('"+str+"',a.requestid)>0 and 0=c.isdelete  and (b.isvalid='40288098276fc2120127704884290210' or b.isvalid is null) group by a.cabtype";
	
	String zxsql = "select a.no,a.gx,a.hgh,a.amount from uf_dmsd_exzgpack a left join uf_dmsd_exfeezg b on a.requestid=b.requestid left join formbase fb on b.requestid=fb.id where b.cknos='"+str+"' and b.isvalid='40288098276fc2120127704884290210' and b.spgroup='"+xgroup+"' and fb.isdelete=0 order by a.no asc";
	//System.out.println(zxsql);
	List sublist1 = baseJdbc.executeSqlForList(zxsql);
	if(sublist1.size()>0)
	{
		for(int k=0,sizek=sublist1.size();k<sizek;k++)
		{
			Map mk1 = (Map)sublist1.get(k);
			//String cabtype = StringHelper.null2String(mk1.get("cabtype"));//柜型
			//String num = StringHelper.null2String(mk1.get("num"));//柜号
			String cabtype = StringHelper.null2String(mk1.get("gx"));//柜型
			String num = StringHelper.null2String(mk1.get("hgh"));//柜号
			String insql ="insert into uf_dmsd_exfeekjpag(id,requestid,sno,cabtype,cabno) values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+(k+1)+"','"+cabtype+"','"+num+"')";
			baseJdbc.update(insql);
		}
	}
	//分摊汇总
	//delsql = "delete uf_dmsd_exfeekjhz where requestid = '"+requestid+"'";//删除历史数据
	//baseJdbc.update(delsql);
	String hzsql="select a.feetype,a.currency,sum(a.amount) as amount ,sum(a.rmbamount) as rmbamount from uf_dmsd_exfeekjft a where a.requestid='"+requestid+"' group by a.feetype ,a.currency";
	//System.out.println(hzsql);
	List sublist2 = baseJdbc.executeSqlForList(hzsql);
	if(sublist2.size()>0)
	{
		for(int k=0,sizek=sublist2.size();k<sizek;k++)
		{
			Map mk2 = (Map)sublist2.get(k);
			String feetype = StringHelper.null2String(mk2.get("feetype"));
			String currency = StringHelper.null2String(mk2.get("currency"));
			String amount = StringHelper.null2String(mk2.get("amount"));
			String rmbamount = StringHelper.null2String(mk2.get("rmbamount"));
			String insql ="insert into uf_dmsd_exfeekjhz(id,requestid,sno,feename,currency,amount,rmbamount) values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+(k+1)+"','"+feetype+"','"+currency+"','"+amount+"','"+rmbamount+"')";
			baseJdbc.update(insql);

		}
	}
	//插入/更新暂估本位币合计
	//String tolmyr = String.valueOf(tolmyramount);
	//System.out.println("tolmyr:"+tolmyr);
	//String tsql = "update uf_dmsd_exfeekjmx set tolmyr='"+tolmyr+"' where requestid='"+requestid+"'";
	//baseJdbc.update(tsql);
}else{%> 
	<TR><TD class="td2" colspan="12">没有信息</TD></TR>
<%} %>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    