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
String supply = StringHelper.null2String(request.getParameter("supply"));//
String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//噎榨讗謩薷酄氄杰狄犤?
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//噎榨讗謩战艿`褝

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
<COL width="120">
<COL width="80">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="160">
<COL width="120">
<COL style = "display:none1" width="120">
<COL style = "display:none1" width="80">
<COL width="120">
<COL width="60">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>费用名称</TD>
<TD  noWrap class="td2"  align=center>记账码</TD>
<TD  noWrap class="td2"  align=center>支付对象</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>

<TD  noWrap class="td2"  align=center>报关日期</TD>
<TD  noWrap class="td2"  align=center>暂估币种</TD>

<TD  noWrap class="td2"  align=center>报关汇率</TD>
<TD  noWrap class="td2"  align=center>暂估金额</TD>
<TD  noWrap class="td2"  style = "display:none1" align=center>本位币金额</TD>
<TD  noWrap class="td2"  style = "display:none1" align=center>物料号</TD>
<TD  noWrap class="td2"  style = "display:none1" align=center>成本中心</TD>
<TD  noWrap class="td2"  style = "display:none1" align=center>资产号</TD>
<TD  noWrap class="td2"  align=center>内部订单号</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>采购订单行项目</TD>
<TD  noWrap class="td2"  align=center>进口到货编号</TD>
<TD  noWrap class="td2"  align=center>进口到货项次</TD>
</tr>

<%


String sql = "";
String delsql = "delete uf_tr_imfeedtsub  where requestid = '"+requestid+"'";//删除历史数据
baseJdbc.update(delsql);
if(goodtype.equals("40285a90492d5248014930386c190174"))//如果是物料
{
	sql ="select a.id as ids,t.closedate,a.fptype,a.rate,a.requestid,a.feetype,c.costname,c.sharebase,(select objname from selectitem where id = c.sharebase)as ftjs,a.payto,a.ledaccount,c.zgsubjects,a.currency , a.amount,a.rmbamount,b.materialid,b.costcenter,b.orderid,b.item,b.imlistid,b.imlistno,b.ladingid as ladingitem,(select invoicetotal from uf_tr_lading where requestid =b.requestid)as allfpmon,b.invoicemoney,(select sum(invoicenum) from uf_tr_materialdt where requestid = b.requestid )as allfpsum,b.invoicenum from uf_tr_imfeetentative t inner join uf_tr_imfeedivvy a on t.requestid = a.requestid inner join  uf_tr_materialdt b on t.noticeno= b.requestid inner join uf_tr_fymcwhd  c on a.feetype = c.requestid where t.noticeno = '"+imgoodsno+"' and a.payto = '"+supply+"' and t.isvalid = '40288098276fc2120127704884290210' and not exists(select requestid from uf_tr_imfeedtmain  m where paycode = '"+supply+"' and imgoodsid = '"+imgoodsno+"'  and requestid <>'"+requestid+"' and (isvalid ='40288098276fc2120127704884290210' or isvalid is null)  and 1<>(select isdelete from requestbase where id = requestid) and  exists(select id from uf_tr_imfeedtsub where requestid = m.requestid)) order by a.feetype desc,a.id desc";
	//System.out.println(sql);
}
else if(goodtype.equals("40285a90492d524801493038713c0179")){//如果是设备
	sql = "select a.id as ids,t.closedate,a.fptype,a.rate,a.requestid,a.feetype,c.costname,c.sharebase,(select objname from selectitem where id = c.sharebase)as ftjs,a.payto,a.ledaccount,c.zgsubjects,a.currency, a.amount,a.rmbamount,b.assetsid,b.costcenter,b.innerorderid,b.orderid,b.orderitem as item,b.imlistid,b.reqnum as imlistno,b.ladingitem,(select invoicetotal from uf_tr_lading where requestid =b.requestid)as allfpmon,b.invoicemoney,(select sum(invoicenum) from uf_tr_equipmentdt where requestid = b.requestid ) as allfpsum,b.invoicenum from uf_tr_imfeetentative  t inner join uf_tr_imfeedivvy a on t.requestid = a.requestid inner join  uf_tr_equipmentdt b on t.noticeno= b.requestid inner join uf_tr_fymcwhd  c on a.feetype = c.requestid where t.noticeno = '"+imgoodsno+"'  and a.payto = '"+supply+"' and t.isvalid = '40288098276fc2120127704884290210' and not exists(select requestid from uf_tr_imfeedtmain m  where paycode = '"+supply+"' and imgoodsid = '"+imgoodsno+"' and requestid <>'"+requestid+"' and (isvalid ='40288098276fc2120127704884290210' or isvalid is null) and 1<>(select isdelete from requestbase where id = requestid) and exists(select id from uf_tr_imfeedtsub where requestid = m.requestid)) order by a.feetype desc,a.id desc";
}
else if(goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2"))//如果是物料设备类
{
	sql = "select v.ids,v.reqid,v.closedate,v.fptype,v.rate,v.feetype,v.costname,v.sharebase,v.ftjs,v.payto,v.ledaccount,v.zgsubjects,v.currency,v.amount,v.rmbamount,v.materialid,v.costcenter,v.innerorderid,v.orderid,v.item,v.imlistid,v.imlistno,v.ladingitem,v.allfpmon,v.invoicemoney,v.allfpsum,v.invoicenum,v.noticeno from v_uf_tr_ladmatrequnion v where noticeno = '"+imgoodsno+"' and payto = '"+supply+"' and isvalid = '40288098276fc2120127704884290210' and  not exists(select requestid from uf_tr_imfeedtmain m  where paycode = '"+supply+"' and imgoodsid = '"+imgoodsno+"' and requestid <>'"+requestid+"' and (isvalid ='40288098276fc2120127704884290210' or isvalid is null) and 1<>(select isdelete from requestbase where id = requestid) and exists(select id from uf_tr_imfeedtsub where requestid = m.requestid)) order by v.feetype desc,v.ids desc";
	//System.out.println(sql);
}
System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		//String theid=StringHelper.null2String(mk.get("id"));
		int m = k;
		int no=m+1;
		String flag = "";
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称(requestid)
		String ids=StringHelper.null2String(mk.get("ids"));//费用名称对应的行的id
		String costname=StringHelper.null2String(mk.get("costname"));//费用名称(中文)
		String sharebase=StringHelper.null2String(mk.get("sharebase"));//分摊基数(id)
		String ftjs=StringHelper.null2String(mk.get("ftjs"));//分摊基数(中文)
		String payto=StringHelper.null2String(mk.get("payto"));//支付对象()
		String ledaccount=StringHelper.null2String(mk.get("ledaccount"));//费用总账科目
		String zgsubjects = StringHelper.null2String(mk.get("zgsubjects"));//暂估总账科目
		String cur=StringHelper.null2String(mk.get("currency"));//币种
		String amount=StringHelper.null2String(mk.get("amount"));//暂估金额
		String rmbamount=StringHelper.null2String(mk.get("rmbamount"));//暂估本位币金额

		String costcenter=StringHelper.null2String(mk.get("costcenter"));//成本中心
		String orderid=StringHelper.null2String(mk.get("orderid"));//采购订单号
		String item=StringHelper.null2String(mk.get("item"));//采购订单项次
	
		String imlistid=StringHelper.null2String(mk.get("imlistid"));//进口货物申请书
		String sqls2 = "select imgoodsid from uf_tr_lading where requestid = '"+imgoodsno+"'";
		List sublists2 = baseJdbc.executeSqlForList(sqls2);
		if(sublists2.size()>0)
		{
			Map mk2 = (Map)sublists2.get(0);
			imlistid = StringHelper.null2String(mk2.get("imgoodsid"));//进口到货编号
		}

		//String imlistno=StringHelper.null2String(mk.get("imlistno"));//申请书序号
		String imlistno=StringHelper.null2String(mk.get("ladingitem"));//申请书序号
		String jzcode = "40";//记账码
		String thedate =StringHelper.null2String(mk.get("closedate"));//报关日期
		String rate = StringHelper.null2String(mk.get("rate"));;//汇率

		String fptype = StringHelper.null2String(mk.get("fptype"));;//发票类型

		String materialid="";//物料号
		String assetsid= "";//资产号
		String innerorderid = "";//内部订单号
		String taxcode = "";//税码
		
		if(goodtype.equals("40285a90492d5248014930386c190174") || goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2") )
		{
			materialid=StringHelper.null2String(mk.get("materialid"));//物料号
			String taxsql = "select objname as taxs from selectitem where id = (select taxcode from uf_tr_import  where material = '"+materialid+"' and costcenter = '"+costcenter+"' and ddlb= '40285a8d4db6e16b014db87153f317ca' and category = '40285a90492d5248014930386c190174' )";
			List taxlist = baseJdbc.executeSqlForList(taxsql);
			if(taxlist.size()>0)
			{
				Map taxm = (Map)taxlist.get(0);
				taxcode = StringHelper.null2String(taxm.get("taxs"));//默认税码
			}
			else
			{
				taxcode = "Y";
			}
		}
		else if(goodtype.equals("40285a90492d524801493038713c0179") || goodtype.equals("40285a8d4ff26ae9014ff2f8028d01b2") ){
			assetsid=StringHelper.null2String(mk.get("assetsid"));//资产号
			innerorderid=StringHelper.null2String(mk.get("innerorderid"));//内部订单号

			//从SAP获取资产分类号
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_MM_ASSET_TYPE";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			function.getImportParameterList().setValue("ANLN1",assetsid);

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
			String ANLKL = function.getExportParameterList().getValue("ANLKL").toString();//资产分类
			if(ANLKL.equals("Z001"))
			{
				taxcode = "Y";
			}
			else
			{
				String taxsql = "select objname as taxs from selectitem where id =(select taxcode from uf_tr_import  where costcenter = '"+costcenter+"' and ddlb= '40285a8d4db6e16b014db87153f317ca' and category = '40285a90497a8f7801497e7945d91149' and 1<>(select isdelete from formbase where id = requestid) and category = '40285a90492d524801493038713c0179')";
				List taxlist = baseJdbc.executeSqlForList(taxsql);
				if(taxlist.size()>0)
				{
					Map taxm = (Map)taxlist.get(0);
					taxcode = StringHelper.null2String(taxm.get("taxs"));//默认税码
					if(taxcode.equals(""))
					{
						taxcode = "Y";
					}
				}
				else
				{
					taxcode = "Y";
				}
			}
		}
		//Y/T/Z,根据获取到的税码类型，从发票类型维护单中带出税码
		String fpsql = "select nxtaxcode,bstaxcode,bmstaxcode from uf_tr_fplxwhd  where requestid = '"+fptype+"'";
		//System.out.println(fpsql);
		List fplist = baseJdbc.executeSqlForList(fpsql);
		if(fplist.size()>0)
		{
			//System.out.println();
			Map fpm = (Map)fplist.get(0);
			String nxtaxcode = StringHelper.null2String(fpm.get("nxtaxcode"));//内销税码Y
			String bstaxcode = StringHelper.null2String(fpm.get("bstaxcode"));//保税税码T
			String bmstaxcode = StringHelper.null2String(fpm.get("bmstaxcode"));//不免税税码Z
			if(taxcode.equals("Y")) taxcode = nxtaxcode;
			if(taxcode.equals("T")) taxcode = bstaxcode;
			if(taxcode.equals("Z")) taxcode = bmstaxcode;
		}

		String allfpmon = StringHelper.null2String(mk.get("allfpmon"));;//发票总金额
		String invoicemoney = StringHelper.null2String(mk.get("invoicemoney"));;//每个行项目对应的发票金额

		String allfpsum = StringHelper.null2String(mk.get("allfpsum"));;//发票总数量
		String invoicenum = StringHelper.null2String(mk.get("invoicenum"));;//每个行项目对应的发票数量

		Double zgmon = 0.00;//暂估金额
		Double zgrmbmon = 0.00;//暂估本位币金额
		Double amort = 0.00;//分摊比例
		if(no <sublist.size())//
		{
			//System.out.println("no:"+no);
			Map mk2 = (Map)sublist.get(no);
			String feetype2=StringHelper.null2String(mk2.get("feetype"));//费用名称2(requestid)
			String ids2=StringHelper.null2String(mk2.get("ids"));//费用名称2(requestid)
			//if(!feetype2.equals(feetype))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			if(!ids2.equals(ids))//如果下一个费用名称与当前的费用名称不一致，则说明当前的费用名称是最后一个。
			{
				String sql2 = "select sum(estimatedmoney) as zgmon,sum(amount) as zgrmbmon from uf_tr_imfeedtsub where requestid = '"+requestid+"' and feetype = '"+feetype+"' and ids='"+ids+"'";
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
				
				if(sharebase.equals("40285a90497a8f7801497d9670120069"))//按照发票金额进行分摊
				{
					
					 amort =(Double.valueOf(invoicemoney)/Double.valueOf(allfpmon));
					 Double d= Double.valueOf(amount) *amort;//暂估金额
					 Integer a=(int)(d*100);
					 zgmon=Double.valueOf(a.toString())/100;

					// System.out.println("fentan*"+no+"金额为:"+zgmon);
					  d= Double.valueOf(rmbamount) *amort;//暂估本位币金额
					  a=(int)(d*100);
					  zgrmbmon=Double.valueOf(a.toString())/100;
				}
				else//按照发票数量进行分摊
				{
					amort =(Double.valueOf(invoicenum)/Double.valueOf(allfpsum));
					Double d1= Double.valueOf(amount) *amort;//暂估金额
					Integer a1=(int)(d1*100);
					zgmon=Double.valueOf(a1.toString())/100;
					d1 = Double.valueOf(rmbamount) *amort;//暂估本位币金额
					a1=(int)(d1*100);
					zgrmbmon=Double.valueOf(a1.toString())/100;
					//System.out.println("fentan*"+no+"金额为:"+zgmon);
				}
			}
		}
		else//当前行为最后一行
		{
			//System.out.println("last row");
			String summoney="0";
			String sumrmbmoney="0";
			String sql3 ="select  sum(a.amount) as summoney,sum(a.rmbamount) as sumrmbmoney from uf_tr_imfeetentative t inner join uf_tr_imfeedivvy a on t.requestid = a.requestid where t.noticeno = '"+imgoodsno+"' and a.payto = '"+supply+"' and t.isvalid = '40288098276fc2120127704884290210'";
			List sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mks = (Map)sublist3.get(0);
				summoney = StringHelper.null2String(mks.get("summoney"));
				sumrmbmoney = StringHelper.null2String(mks.get("sumrmbmoney"));
			}
			sql3 = "select sum(estimatedmoney) as zgmon,sum(amount) as zgrmbmon from uf_tr_imfeedtsub where requestid = '"+requestid+"'";

			sublist3 = baseJdbc.executeSqlForList(sql3);
			if(sublist3.size()>0)
			{
				Map mk4 = (Map)sublist3.get(0);
				String mon1 = StringHelper.null2String(mk4.get("zgmon"));;//已被占用的暂估金额
				String mon2 = StringHelper.null2String(mk4.get("zgrmbmon"));;//已被占用的暂估本位币金额
				if(mon1.equals("") || mon1 == null )mon1 = "0";
				if(mon2.equals("") || mon2 == null )mon2 = "0";
				zgmon = Double.valueOf(summoney)-Double.valueOf(mon1);//获取剩余暂估金额
				zgrmbmon = Double.valueOf(sumrmbmoney)-Double.valueOf(mon2);//获取剩余暂估本位币金额
				System.out.println("fentan-"+summoney+"金额为:"+mon1);
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
		//System.out.println(cur);

		String insql = "insert into uf_tr_imfeedtsub(id,requestid,sno,feetype,bkkpingcode,paycode,genledger,closedate,currency,rate,estimatedmoney,amount,";
		insql = insql +"materialid,costcenter,assetid,innerorderid,purchaseid,purchaseitem,imgoodsid,imgoodsitem,taxcode,zgledger,ids)values(";
		insql = insql +"'"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','"+feetype+"','"+jzcode+"','"+payto+"','"+ledaccount+"','"+thedate+"','"+cur+"','"+rate+"','"+amount+"',";
		insql = insql +"'"+rmbamount+"','"+materialid+"','"+costcenter+"','"+assetsid+"','"+innerorderid+"','"+orderid+"','"+item+"','"+imlistid+"','"+imlistno+"','"+taxcode+"','"+zgsubjects+"','"+ids+"')";

		//System.out.println(insql);

		baseJdbc.update(insql);
	%>
		<TR id="<%="dataDetail_"+no %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+no %>" name="no"><%=no %></TD>

		<TD  class="td2"   align=center ><%=costname %></TD>
		<TD  class="td2"   align=center ><%=jzcode %></TD>

		<TD   class="td2"  align=center><%=payto %></TD>

		<TD   class="td2"  align=center><%=ledaccount %></TD>
		<TD   class="td2"  align=center><%=thedate %></TD>
		<TD   class="td2"  align=center><%=cur %></TD>
		
		<TD   class="td2"  align=center><%=rate %></TD>
		<TD   class="td2"  align=center><%=amount %></TD>

		<TD   class="td2"  align=center><%=rmbamount %></TD>
		<TD   class="td2"  align=center><%=materialid %></TD>
		<TD   class="td2"  align=center><%=costcenter %></TD>
		<TD   class="td2"  align=center><%=assetsid %></TD>
		
		<TD   class="td2"  align=center><%=innerorderid %></TD>
		<TD   class="td2"  align=center><%=orderid %></TD>
		<TD   class="td2"  align=center><%=item %></TD>
		<TD   class="td2"  align=center><%=imlistid %></TD>
		<TD   class="td2"  align=center><%=imlistno %></TD>
		

		</TR>
	<%
		}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    