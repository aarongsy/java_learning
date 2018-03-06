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
String supply = StringHelper.null2String(request.getParameter("supply"));//支付对象
String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//发货通知书
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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp"  >
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
</COLGROUP>
<TR height="25"  class="title">

<TD   noWrap class="td2"  align=center>费用类型</TD>
<TD  noWrap class="td2"  align=center>记账码</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>预计结关日期</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>
<TD  noWrap class="td2"  align=center>暂估汇率</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  align=center>暂估本位币金额</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>销售凭证号</TD>
<TD  noWrap class="td2"  align=center>销售凭证项次</TD>
</tr>

<%

String delsql = "delete uf_tr_exfeedtdivvy  where requestid = '"+requestid+"'";//删除历史数据
baseJdbc.update(delsql);
delsql = "delete uf_tr_exfeedtpacking  where requestid = '"+requestid+"'";//删除历史数据
baseJdbc.update(delsql);
delsql = "delete uf_tr_exfeedtamount  where requestid = '"+requestid+"'";//删除历史数据
baseJdbc.update(delsql);
String noticeno="";
String sql ="";
if(imgoodsno.equals(""))
{
	sql= "select a.id,a.feetype,c.costname,a.ledaccount,a.leger,a.closedate,a.currency,a.rate,a.amount,a.rmbamount,t.noticeno,b.costctr,b.stockno,b.voucherno,b.vitem,a.taxcode,c.costname,c.sharebase,(select objname from selectitem where id = c.sharebase)as ftjs,(select shiptotal from uf_tr_expboxmain where requestid=b.requestid) as shiptotals,b.shipnum,(select netpricesum from uf_tr_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_tr_feedivvy a left join uf_tr_feetentative t on t.requestid = a.requestid  left join uf_tr_fymcwhd  c on a.feetype = c.requestid inner join uf_tr_shipment  b on b.requestid=t.noticeno where a.payto = '"+supply+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null)  and not exists(select e.requestid from uf_tr_exfeedtdivvy e left join uf_tr_exfeetentdtmain  m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null)) and 0=(select isdelete from formbase where id=t.requestid ) order by a.feetype asc,a.id asc";
}
else
{
	sql= "select a.id,a.feetype,c.costname,a.ledaccount,a.leger,a.closedate,a.currency,a.rate,a.amount,a.rmbamount,t.noticeno,b.costctr,b.stockno,b.voucherno,b.vitem,a.taxcode,c.costname,c.sharebase,(select objname from selectitem where id = c.sharebase)as ftjs,(select shiptotal from uf_tr_expboxmain where requestid=b.requestid) as shiptotals,b.shipnum,(select netpricesum from uf_tr_expboxmain where requestid=b.requestid)as netpricesums,b.netvalue from uf_tr_feedivvy a left join uf_tr_feetentative t on t.requestid = a.requestid  left join uf_tr_fymcwhd  c on a.feetype = c.requestid inner join uf_tr_shipment  b on b.requestid=t.noticeno where t.noticeno = '"+imgoodsno+"'  and a.payto = '"+supply+"' and (t.isvalid = '40288098276fc2120127704884290210' or t.isvalid is null)  and not exists(select e.requestid from uf_tr_exfeedtdivvy e left join uf_tr_exfeetentdtmain  m on e.requestid=m.requestid where  e.zgid =a.id and e.requestid <>'"+requestid+"'  and 1<>(select isdelete from requestbase where id = e.requestid) and (m.isvalid ='40288098276fc2120127704884290210' or m.isvalid is null) ) and 0=(select isdelete from formbase where id=t.requestid ) order by a.feetype asc,a.id asc";
}
System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		
		int m = k;
		int no=m+1;
		String flag = "";
		String theid=StringHelper.null2String(mk.get("id"));
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称
		String costname=StringHelper.null2String(mk.get("costname"));//费用名称
		String ledaccount=StringHelper.null2String(mk.get("ledaccount"));//费用总账科目
		String leger = StringHelper.null2String(mk.get("leger"));//暂估总账科目
		String closedate =StringHelper.null2String(mk.get("closedate"));//预计结关日期
		String currency=StringHelper.null2String(mk.get("currency"));//币种
		String rate = StringHelper.null2String(mk.get("rate"));;//汇率
		String amount=StringHelper.null2String(mk.get("amount"));//暂估金额
		String rmbamount=StringHelper.null2String(mk.get("rmbamount"));//暂估本位币金额
		noticeno = noticeno+","+StringHelper.null2String(mk.get("noticeno"));;//外销联络单
		String costctr=StringHelper.null2String(mk.get("costctr"));//成本中心
		String jzcode = "40";//记账码
		
		String materialid=StringHelper.null2String(mk.get("stockno"));;//物料号
		String taxcode = StringHelper.null2String(mk.get("taxcode"));;//税码
		String voucherno = StringHelper.null2String(mk.get("voucherno"));;//销售凭证号
		String vitem = StringHelper.null2String(mk.get("vitem"));;//凭证项次
		String sharebase = StringHelper.null2String(mk.get("sharebase"));;//分摊基数


		String shiptotals = StringHelper.null2String(mk.get("shiptotals"));;//发票总金额
		String shiptotal = StringHelper.null2String(mk.get("shipnum"));;//每个行项目对应的发票金额,本次出货数量

		String netpricesums = StringHelper.null2String(mk.get("netpricesums"));;//发票总数量
		String netpricesum = StringHelper.null2String(mk.get("netvalue"));;//每个行项目对应的发票数量，净价值

		Double zgmon = 0.00;//暂估金额
		Double zgrmbmon = 0.00;//暂估本位币金额
		Double amort = 0.00;//分摊比例
		if(no <sublist.size())//
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//费用名称2(requestid)
			String theid2=StringHelper.null2String(mk2.get("id"));//费用名称2(requestid)
			if(!theid2.equals(theid))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				//String sql2 = "select sum(amount) as zgmon,sum(rmbamount) as zgrmbmon from uf_tr_exfeedtdivvy   where requestid = '"+requestid+"' and feetype = '"+feetype+"'";
				String sql2 = "select sum(amount) as zgmon,sum(rmbamount) as zgrmbmon from uf_tr_exfeedtdivvy   where requestid = '"+requestid+"' and theid = '"+theid+"'";
				List sublist2 = baseJdbc.executeSqlForList(sql2);
				if(sublist2.size()>0)//
				{
					Map mk3 = (Map)sublist2.get(0);
					String mon1 = StringHelper.null2String(mk3.get("zgmon"));;//已被占用的暂估金额
					String mon2 = StringHelper.null2String(mk3.get("zgrmbmon"));;//已被占用的暂估本位币金额
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
				
				if(sharebase.equals("40285a90497a8f7801497d9670120069"))//按照发票金额进行分摊、（净价值/发票金额）
				{
					 
					 amort = (Double.valueOf(netpricesum)/Double.valueOf(netpricesums));
					zgmon= Double.valueOf(amount) *amort;//暂估金额
					zgrmbmon = Double.valueOf(rmbamount) *amort;//暂估本位币金额
				}
				else//按照发票数量进行分摊\（净价值/发票金额）（本次出货数量/发票数量）*暂估金额
				{
					
					amort = (Double.valueOf(shiptotal)/Double.valueOf(shiptotals));
					 zgmon= Double.valueOf(amount) *amort;//暂估金额
					 zgrmbmon = Double.valueOf(rmbamount) *amort;//暂估本位币金额
				}
			}
		}
		else//当前行为最后一行
		{

			//String sql3 = "select sum(amount) as zgmon,sum(rmbamount) as zgrmbmon from uf_tr_exfeedtdivvy where requestid = '"+requestid+"' and feetype = '"+feetype+"'";
			String sql3 = "select sum(amount) as zgmon,sum(rmbamount) as zgrmbmon from uf_tr_exfeedtdivvy where requestid = '"+requestid+"' and theid = '"+theid+"'";
			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("zgmon"));;//已被占用的暂估金额
				String mon2 = StringHelper.null2String(mk4.get("zgrmbmon"));;//已被占用的暂估本位币金额
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
		//分摊明细
		String insql = "insert into uf_tr_exfeedtdivvy(id,requestid,feetype,billcode,currency,rate,amount,rmbamount,ledaccount,closedate,materialid,custcenter,salesid,salesitem,payto,zgid,zgsubjects,taxcode,ftbase,ftamount,ftcount,theid)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+feetype+"','40','"+currency+"',"+rate+","+amount+","+rmbamount+",'"+ledaccount+"','"+closedate+"','"+materialid+"','"+costctr+"','"+voucherno+"','"+vitem+"','"+supply+"','"+theid+"','"+leger+"','"+taxcode+"','"+sharebase+"','"+shiptotals+"','"+netpricesums+"','"+theid+"')";

		baseJdbc.update(insql);


	%>
		<TR id="dataDetail" height="30">
		<TD noWrap  class="td2"  align=center ><%=costname %></TD>
		<TD noWrap  class="td2"  align=center>40</TD>
		<TD noWrap  class="td2"  align=center><%=ledaccount %></TD>
		<TD noWrap  class="td2"  align=center><%=closedate %></TD>
		<TD noWrap  class="td2"  align=center><%=currency %></TD>
		<TD noWrap  class="td2"  align=center><%=rate %></TD>
		<TD noWrap  class="td2"  align=center><%=amount %></TD>
		<TD noWrap  class="td2"  align=center><%=rmbamount %></TD>
	
		<TD  noWrap  class="td2"  align=center><%=materialid %></TD>
		<TD  noWrap  class="td2"  align=center><%=costctr %></TD>
		<TD  noWrap  class="td2"  align=center><%=voucherno %></TD>
		<TD  noWrap  class="td2"  align=center><%=vitem %></TD>
	
		</TR>
	<%
		}
		//装箱方式
		//System.out.println("noticeno:"+noticeno);
		String str=noticeno.substring(1);
		//System.out.println("str:"+str);
		delsql = "delete uf_tr_exfeedtpacking  where requestid = '"+requestid+"'";//删除历史数据
		baseJdbc.update(delsql);
		String zxsql="select a.cabtype,count(distinct(a.cabno)) as num from uf_tr_packtype a left join uf_tr_expboxmain  b on a.requestid=b.requestid left join requestbase c on c.id =b.requestid where instr ('"+str+"',a.requestid)>0 and 0=c.isdelete and 1=c.isfinished and (b.isvalid='40288098276fc2120127704884290210' or b.isvalid is null) group by a.cabtype";
		//System.out.println(zxsql);
		List sublist1 = baseJdbc.executeSqlForList(zxsql);
		if(sublist1.size()>0){
			for(int k=0,sizek=sublist1.size();k<sizek;k++)
			{
				Map mk1 = (Map)sublist1.get(k);
				String cabtype = StringHelper.null2String(mk1.get("cabtype"));//柜型
				String num = StringHelper.null2String(mk1.get("num"));//
				String insql ="insert into uf_tr_exfeedtpacking  (id,requestid,sno,cabtype,cabno) values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+(k+1)+"','"+cabtype+"','"+num+"')";
				baseJdbc.update(insql);

			}
		}
		//分摊汇总
		delsql = "delete uf_tr_exfeedtamount  where requestid = '"+requestid+"'";//删除历史数据
		baseJdbc.update(delsql);
		String hzsql="select a.feetype,a.currency,sum(a.amount) as amount ,sum(a.rmbamount) as rmbamount from uf_tr_exfeedtdivvy a where a.requestid='"+requestid+"' group by a.feetype ,a.currency";
		System.out.println(hzsql);
		List sublist2 = baseJdbc.executeSqlForList(hzsql);
		if(sublist2.size()>0){
			for(int k=0,sizek=sublist2.size();k<sizek;k++)
			{
				Map mk2 = (Map)sublist2.get(k);
				String feetype = StringHelper.null2String(mk2.get("feetype"));//
				String currency = StringHelper.null2String(mk2.get("currency"));//
				String amount = StringHelper.null2String(mk2.get("amount"));
				String rmbamount = StringHelper.null2String(mk2.get("rmbamount"));
				String insql ="insert into uf_tr_exfeedtamount  (id,requestid,sno,feename,currency,amount,rmbamount) values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+(k+1)+"','"+feetype+"','"+currency+"','"+amount+"','"+rmbamount+"')";
				baseJdbc.update(insql);

			}
		}
}else{%> 
	<TR><TD class="td2" colspan="12">没有信息</TD></TR>
<%} %>
</table>
</div>
