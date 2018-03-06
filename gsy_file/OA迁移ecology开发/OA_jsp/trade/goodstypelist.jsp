<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.Page" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="java.math.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	DataService ds = new DataService();
	String actionSt = StringHelper.null2String(request.getParameter("actionSt"));
	String userid = currentuser.getId();
	String detailids = StringHelper.null2String(request.getParameter("detailids"));
	String sql="";
	if(actionSt.equals("submitSt")){
		String sqlSt="";
		List<String> sqlList =new ArrayList<String>();
		String fromid = StringHelper.null2String(request.getParameter("fromid"));
		String disnum = StringHelper.null2String(request.getParameter("disnum"));
		String optype = StringHelper.null2String(request.getParameter("optype"));
		String detailid = StringHelper.null2String(request.getParameter("detailid"));
		if(optype.equals("distmain")){//主明细分拆
			//拆分为两条
			String newid=IDGernerator.getUnquieID();
	
			sqlSt = "insert into uf_tr_spequipmentdt(id,requestid,rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum,unitprice,currency,money,"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,"
				+"freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid)";
			sqlSt += " select '"+newid+"','"
				+requestid
				+"',rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum-"+disnum+",unitprice,currency,money-round(unitprice*"+disnum+",2),"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,'"+fromid+"'"
				+"from uf_tr_selequipmentdt where id='"+fromid+"' order by rowindex";
			sqlList.add(sqlSt);
			newid=IDGernerator.getUnquieID();
			sqlSt = "insert into uf_tr_spequipmentdt(id,requestid,rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum,unitprice,currency,money,"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,"
				+"freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid)";
			sqlSt += " select '"+newid+"','"
				+requestid
				+"',rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,"+disnum+",unitprice,currency,round(unitprice*"+disnum+",2),"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,'"+fromid+"'"
				+" from uf_tr_selequipmentdt where id='"+fromid+"' order by rowindex";
			sqlList.add(sqlSt);
		
		}
		if(optype.equals("dist")){//分拆明细
			//拆分为两条
			String newid=IDGernerator.getUnquieID();
			sqlSt = "update  uf_tr_spequipmentdt set purchasenum=purchasenum-"+disnum+",money=money-round(unitprice*"+disnum+",2) where id='"+fromid+"'";
			sqlList.add(sqlSt);
			sqlSt = "insert into uf_tr_spequipmentdt(id,requestid,rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum,unitprice,currency,money,"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,"
				+"freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid)";
			sqlSt += " select '"+newid+"','"
				+requestid
				+"',rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,"+disnum+",unitprice,currency,round(unitprice*"+disnum+",2),"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid"
				+" from uf_tr_spequipmentdt where id='"+fromid+"' order by rowindex";
			sqlList.add(sqlSt);
		}
		if(optype.equals("merge")){//主明细合并
			double purchasenum=0.0;
			double money=0.0;
			String newid=IDGernerator.getUnquieID();
			sql = "select * from uf_tr_selequipmentdt t where requestid = '"+requestid+"' and '"+detailids+"' like '%'||id||'%'  and meeid is null  order by rowindex" ;
			List equipment= baseJdbc.executeSqlForList(sql);
			for(int i=0,leni=equipment.size();i<leni;i++){
				Map eqmap = (Map)equipment.get(i);
				purchasenum=purchasenum+NumberHelper.string2Double(StringHelper.null2String(eqmap.get("purchasenum")));
				money=money+NumberHelper.string2Double(StringHelper.null2String(eqmap.get("money")));
				if(i==0){
					fromid = StringHelper.null2String(eqmap.get("id"));
				}
				String id = StringHelper.null2String(eqmap.get("id"));
				sqlSt="update  uf_tr_selequipmentdt set meeid='"+newid+"' where  id='"+id+"'";
				sqlList.add(sqlSt);
			}
			sqlSt = "insert into uf_tr_meequipmentdt(id,requestid,rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum,unitprice,currency,money,"
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,"
				+"freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid)";
			sqlSt += " select '"+newid+"','"
				+requestid
				+"',rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,"+purchasenum+",round("+money+"/"+purchasenum+",2),currency,"+money+","
				+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,'"+fromid+"' fromid"
				+" from uf_tr_selequipmentdt where id='"+fromid+"' order by rowindex";
			sqlList.add(sqlSt);

			
		}
		if(optype.equals("mergecancel")){//释放
		
			sqlSt="delete from uf_tr_meequipmentdt where id='"+fromid+"'";
			sqlList.add(sqlSt);
			sqlSt="update  uf_tr_selequipmentdt set meeid=null where meeid = '"+fromid+"' and  requestid = '"+requestid+"' ";
			sqlList.add(sqlSt);
		}
		if(optype.equals("distcancel")){//取消
			sqlSt="delete from uf_tr_spequipmentdt where fromid='"+fromid+"'";
			sqlList.add(sqlSt);
		}
		if(sqlList.size()>0)
		{
			JdbcTemplate jdbcTemp=baseJdbc.getJdbcTemplate();
			PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
			DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
			TransactionStatus status=tm.getTransaction(def); 
			try{ 
				jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
				tm.commit(status);
			}catch(DataAccessException ex){
				tm.rollback(status);
				throw ex;
			}
		}
		String urlSt = "/app/trade/goodstypelist.jsp?requestid="+requestid;
		urlSt = request.getContextPath() + urlSt;
		response.sendRedirect(urlSt);
	}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>单据处理</title>
<style type="text/css">
<!--
.STYLE1 {
	font-size: 18px;
	font-weight: bold;
}
table{ border:1 solid #24303C;}
select{width:100px}
tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 25px;  
} 
td.td2{ 
    font-size:12px; 
    PADDING-RIGHT: 2px; 
    PADDING-LEFT: 2px;     
    TEXT-DECORATION: none; 
    color:#000; 
-->
  .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}

</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>

</head>
<body>
<script type="text/javascript">

//明细表全选/取消全选
function selectAll(obj,itemcheck){
   var allCheckBoxes=document.getElementsByName(itemcheck);//取明细表name
   for (var i=0;i<allCheckBoxes.length;i++){
   		allCheckBoxes[i].checked=obj.checked;
   }
}
//合并处理
function merge(itemcheck){
	var allCheckBoxes = document.getElementsByName(itemcheck);
	var detailids= '';
	var nums=0;
	for (var i=0;i<allCheckBoxes.length;i++){
	  if(allCheckBoxes[i].checked){
		detailids=detailids+','+allCheckBoxes[i].value;
		nums=nums+1;
	  }
	}
	if(nums<2){
		alert('合并必须选择两条或两条以上明细！');
		return;
	}
	if(detailids.length>0){
		detailids=detailids.substring(1);
		
	}
	if(confirm('是否确定要合并?')){
		document.getElementById("detailids").value=detailids;
		document.getElementById('actionSt').value="submitSt";
		document.getElementById('optype').value="merge";
		document.EweaverForm.submit();
	}
	//var url='goodstypedeal.jsp?optype=merge&detailids='+detailids;
	//openchild(url)
}
//主数据拆分处理
function distmain(fromid,orgnum){
	var url='goodstypedeal.jsp?optype=distmain&requestid=<%=requestid%>&fromid='+fromid+'&orgnum='+orgnum;
	openchild(url)
}
//再次拆分处理
function dist(fromid,orgnum){
	var url='goodstypedeal.jsp?optype=dist&requestid=<%=requestid%>&fromid='+fromid+'&orgnum='+orgnum;
	openchild(url)
}
//解除合并处理
function MergeCancle(fromid){
	//var url='goodstypedeal.jsp?optype=mergecancel&fromid='+fromid;
	//openchild(url)
	if(confirm('是否确定要解除合并?')){
		document.getElementById("fromid").value=fromid;
		document.getElementById('actionSt').value="submitSt";
		document.getElementById('optype').value="mergecancel";
		document.EweaverForm.submit();
	}
}
//取消拆分处理
function DistCancle(fromid){
	//var url='goodstypedeal.jsp?optype=distcancel&fromid='+fromid;
	//openchild(url)
	if(confirm('是否确定要取消拆分?')){
		document.getElementById("fromid").value=fromid;
		document.getElementById('actionSt').value="submitSt";
		document.getElementById('optype').value="distcancel";
		document.EweaverForm.submit();
	}
}
function openchild(url)
{
	newWindow();
	this.dlg0.getComponent('dlgpanel').setSrc(""+url);
	this.dlg0.show();
}
var dlg0;
function newWindow(){
	dlg0 = new Ext.Window({
		layout:'border',
		closeAction:'hide',
		plain: true,
		modal :true,
		width:600,
		height:400,
		buttons: [{
			text     : '关闭',
			handler  : function(){
				dlg0.hide();
			}
		}],
		items:[{
			id:'dlgpanel',
			region:'center',
			xtype     :'iframepanel',
			frameConfig: {
				autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
				eventsFollowFrameLinks : false
			},
			autoScroll:true
		}]
	});
}
</script>
<form id="EweaverForm" name="EweaverForm" method="post" action="" width="100%" style="text-align:center">
  <input type="hidden" name="actionSt" id="actionSt" value="submitSt" />
  <input type="hidden" name="requestid" id="requestid" value="<%=requestid%>" />
  <input type="hidden" name="detailids" id="detailids" value="<%=detailids%>" />
  <input type="hidden" name="fromid" id="fromid" value="" />
  <input type="hidden" name="optype" id="optype" value="" />
  
  <table width="100%" cellspacing="0" cellpadding="0" border="1" >
  <tbody>
    <tr>
      <td colspan="3"><div align="center" class="STYLE1" >分拆合并处理</div></td>
    </tr>
    <tr>
      <td width="50%"><label>
        <button style="height:30;width:60" name="selectMaterial" id="selectMaterial" class=InputStyle2 onclick="javascript:merge('detailcheck')"><strong>合并<strong/></button>
		<input type=hidden id="materials" onpropertychange="changeMaterial();" name="materials" value=""> <span id="materialsspan" style="DISPLAY: none" name="materialsspan"></span>
        <!-- <button style="height:30" name="selectEquipment" id="selectEquipment" class=InputStyle2 onclick="javascript:getEquipment()">重置</button>
		<input type=hidden id="equipments" onpropertychange="changeEquipment();" name="equipments" value=""> <span id="equipmentsspan" style="DISPLAY: none" name="equipmentsspan"></span> -->
      </label>
	  <%
		sql = "select * from uf_tr_selequipmentdt t where requestid = '"+requestid+"' and not exists (select fromid from uf_tr_spequipmentdt where requestid=t.requestid and fromid=t.id) and  not exists (select id from uf_tr_meequipmentdt where requestid=t.requestid and id=t.meeid) order by rowindex" ;
		List equipment= baseJdbc.executeSqlForList(sql);
		sql = "select * from uf_tr_meequipmentdt  where requestid = '"+requestid+"' and purchasenum is not null  order by rowindex" ;
		List hbequipment= baseJdbc.executeSqlForList(sql);
		sql = "select * from uf_tr_spequipmentdt   where requestid = '"+requestid+"' and fromid is not null order by rowindex" ;
		List fcequipment= baseJdbc.executeSqlForList(sql);
		%>
	  	<table id='tablesbdt'  border=1 cellSpacing=0 cellPadding=0  style='width: 100%'    style="padding: 5px;margin:5px">
        <colgroup>
        <col width='2%'/><col width='4%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/>
		<col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/>
		<col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/>
		<col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/><col width='8%'/>
		
        </colgroup>
      <tr class=Header>
      
	  <td nowrap='nowrap'><INPUT onclick="javascript:selectAll(this,'detailcheck')" id='check_node_all' type='checkbox' value='-1' name='check_node_all'></td>
	  
	  <td nowrap='nowrap' align='center'>操作</td><!-- <td nowrap='nowrap'>提单项次</td> --><td nowrap='nowrap' align="center">进口货物申请书编号</td><td nowrap='nowrap' align="center">申请书序号</td>
	  <td nowrap='nowrap' align="center">订单编号</td><td nowrap='nowrap' align="center">订单项次</td><td nowrap='nowrap' align='center'>品名</td><td nowrap='nowrap' align="center">资产号</td>
	  <td nowrap='nowrap' align="center">内部订单号</td><td nowrap='nowrap' align="center">采购单位</td><td nowrap='nowrap' align="center">采购数量</td><td nowrap='nowrap' align="center">采购单价</td>
	  <td nowrap='nowrap' align="center">币种</td><td nowrap='nowrap' align="center">金额</td><td nowrap='nowrap' align="center">预定交货日</td><td nowrap='nowrap' align="center">原产地</td>
	  <td nowrap='nowrap' align="center">发票数量</td><!-- <td nowrap='nowrap'>关务确定数量</td> --><td nowrap='nowrap' align="center">发票单价</td><td nowrap='nowrap' align="center">发票金额</td>
	  <td nowrap='nowrap' align="center">免表号</td><td nowrap='nowrap' align="center">免表序号</td><td nowrap='nowrap' align="center">商品编码</td><!-- <td nowrap='nowrap'>报关单编号</td>
      <td nowrap='nowrap'>报关单项次</td><td nowrap='nowrap'>报关日期</td> --><td nowrap='nowrap' align="center">收货数量</td><!-- <td nowrap='nowrap'>贸易方式</td> -->
	  <td nowrap='nowrap' align="center">采购申请凭证类型</td><td nowrap='nowrap' align="center">成本中心</td><td nowrap='nowrap' align="center">成本中心名称</td>
	  </tr>
	  <tr><td colspan=32 style="background-color:#CEFEC9;height:30px">到货明细(设备)</td></tr>
	  <%
	  if(equipment.size()<1){%>
		  <tr><td colspan=32>没有可拆分或合并的到货明细！</td></tr>
	  <%}else{
        for(int i=0,leni=equipment.size();i<leni;i++){
			Map eqmap = (Map)equipment.get(i);
			String id = StringHelper.null2String(eqmap.get("id"));
			String ladingitem = StringHelper.null2String(eqmap.get("ladingitem"));
			String imlistid = StringHelper.null2String(eqmap.get("imlistid"));
			String reqnum = StringHelper.null2String(eqmap.get("reqnum"));
			String orderid = StringHelper.null2String(eqmap.get("orderid"));
			String orderitem = StringHelper.null2String(eqmap.get("orderitem"));
			String article = StringHelper.null2String(eqmap.get("article"));
			String assetsid = StringHelper.null2String(eqmap.get("assetsid"));
			String innerorderid = StringHelper.null2String(eqmap.get("innerorderid"));
			String purchaseunit = StringHelper.null2String(eqmap.get("purchaseunit"));
			String purchasenum = StringHelper.null2String(eqmap.get("purchasenum"));
			String unitpice = StringHelper.null2String(eqmap.get("unitpice"));
			String currency = StringHelper.null2String(eqmap.get("currency"));
			String money = StringHelper.null2String(eqmap.get("money"));
			String reservedate = StringHelper.null2String(eqmap.get("reservedate"));
			String origin = StringHelper.null2String(eqmap.get("origin"));
			String invoicenum = StringHelper.null2String(eqmap.get("invoicenum"));
			String certainnum = StringHelper.null2String(eqmap.get("certainnum"));
			String invoiceunitprice = StringHelper.null2String(eqmap.get("invoiceunitprice"));
			String invoicemoney = StringHelper.null2String(eqmap.get("invoicemoney"));
			String freeid = StringHelper.null2String(eqmap.get("freeid"));
			String freenum = StringHelper.null2String(eqmap.get("freenum"));
			String goodsid = StringHelper.null2String(eqmap.get("goodsid"));
 			String customsid = StringHelper.null2String(eqmap.get("customsid"));
			String customsitem = StringHelper.null2String(eqmap.get("customsitem"));
			String customsdate = StringHelper.null2String(eqmap.get("customsdate"));
			String receiptnum = StringHelper.null2String(eqmap.get("receiptnum"));
			String tradetype = StringHelper.null2String(eqmap.get("tradetype"));
			String purchasetype = StringHelper.null2String(eqmap.get("purchasetype"));
			String costcenter = StringHelper.null2String(eqmap.get("costcenter"));
			String costname = StringHelper.null2String(eqmap.get("costname"));
		%>
		  <tr class=tr1>
		  <td nowrap='nowrap'><input id='detailcheck'  type='checkbox'    value='<%=id %>'   ' name='detailcheck'></td>
		  <td nowrap='nowrap'><a href="javascript:distmain('<%=id%>',<%=purchasenum%>)">拆分</a></td>
<!-- 		  <td nowrap='nowrap'><%=ladingitem%></td> -->
		  <td nowrap='nowrap'><%=imlistid%></td>
		  <td nowrap='nowrap'><%=reqnum%></td>
		  <td nowrap='nowrap'><%=orderid%></td>
		  <td nowrap='nowrap'><%=orderitem%></td>
		  <td nowrap='nowrap'><%=article%></td>
		  <td nowrap='nowrap'><%=assetsid%></td>
		  <td nowrap='nowrap'><%=innerorderid%></td>
		  <td nowrap='nowrap'><%=purchaseunit%></td>
		  <td nowrap='nowrap'><%=purchasenum%></td>
		  <td nowrap='nowrap'><%=unitpice%></td>
		  <td nowrap='nowrap'><%=currency%></td>
		  <td nowrap='nowrap'><%=money%></td>
		  <td nowrap='nowrap'><%=reservedate%></td>
		  <td nowrap='nowrap'><%=origin%></td>
		  <td nowrap='nowrap'><%=invoicenum%></td>
		  <td nowrap='nowrap'><%=certainnum%></td>
		  <td nowrap='nowrap'><%=invoiceunitprice%></td>
		  <td nowrap='nowrap'><%=invoicemoney%></td>
		  <td nowrap='nowrap'><%=freeid%></td>
		  <td nowrap='nowrap'><%=goodsid%></td>
		  <td nowrap='nowrap'><%=freenum%></td>
		  <td nowrap='nowrap'><%=purchasetype%></td>
		  <td nowrap='nowrap'><%=costcenter%></td>
		  <td nowrap='nowrap'><%=costname%></td>


 		  <td nowrap='nowrap'><%=customsid%></td>
		  <td nowrap='nowrap'><%=customsitem%></td>
		  <td nowrap='nowrap'><%=customsdate%></td>
		  <td nowrap='nowrap'><%=receiptnum%></td>
		  <td nowrap='nowrap'><%=tradetype%></td>
		   
		  </tr>
		<%
		}
	  }
	  %>
	  <tr><td colspan=32 style="background-color:#CEFEC9;height:30px">合并后到货明细(设备)</td></tr>
  <%

	for(int i=0,leni=hbequipment.size();i<leni;i++){
		Map eqmap = (Map)hbequipment.get(i);
		String id = StringHelper.null2String(eqmap.get("id"));
		String ladingitem = StringHelper.null2String(eqmap.get("ladingitem"));
		String imlistid = StringHelper.null2String(eqmap.get("imlistid"));
		String reqnum = StringHelper.null2String(eqmap.get("reqnum"));
		String orderid = StringHelper.null2String(eqmap.get("orderid"));
		String orderitem = StringHelper.null2String(eqmap.get("orderitem"));
		String article = StringHelper.null2String(eqmap.get("article"));
		String assetsid = StringHelper.null2String(eqmap.get("assetsid"));
		String innerorderid = StringHelper.null2String(eqmap.get("innerorderid"));
		String purchaseunit = StringHelper.null2String(eqmap.get("purchaseunit"));
		String purchasenum = StringHelper.null2String(eqmap.get("purchasenum"));
		String unitpice = StringHelper.null2String(eqmap.get("unitprice"));
		String currency = StringHelper.null2String(eqmap.get("currency"));
		String money = StringHelper.null2String(eqmap.get("money"));
		String reservedate = StringHelper.null2String(eqmap.get("reservedate"));
		String origin = StringHelper.null2String(eqmap.get("origin"));
		String invoicenum = StringHelper.null2String(eqmap.get("invoicenum"));
		String certainnum = StringHelper.null2String(eqmap.get("certainnum"));
		String invoiceunitprice = StringHelper.null2String(eqmap.get("invoiceunitprice"));
		String invoicemoney = StringHelper.null2String(eqmap.get("invoicemoney"));
		String freeid = StringHelper.null2String(eqmap.get("freeid"));
		String freenum = StringHelper.null2String(eqmap.get("freenum"));
		String goodsid = StringHelper.null2String(eqmap.get("goodsid"));
 		String customsid = StringHelper.null2String(eqmap.get("customsid"));
		String customsitem = StringHelper.null2String(eqmap.get("customsitem"));
		String customsdate = StringHelper.null2String(eqmap.get("customsdate"));
		String receiptnum = StringHelper.null2String(eqmap.get("receiptnum"));
		String tradetype = StringHelper.null2String(eqmap.get("tradetype"));
		String purchasetype = StringHelper.null2String(eqmap.get("purchasetype"));
		String costcenter = StringHelper.null2String(eqmap.get("costcenter"));
		String costname = StringHelper.null2String(eqmap.get("costname"));
		String fromid = StringHelper.null2String(eqmap.get("fromid"));
			%>
		  <tr class=tr1>
		  <td nowrap='nowrap' colspan=2><a href="javascript:MergeCancle('<%=id%>')">解除</a></td>
  		  <td nowrap='nowrap'><%=imlistid%></td>
		  <td nowrap='nowrap'><%=reqnum%></td>
		  <td nowrap='nowrap'><%=orderid%></td>
		  <td nowrap='nowrap'><%=orderitem%></td>
		  <td nowrap='nowrap'><%=article%></td>
		  <td nowrap='nowrap'><%=assetsid%></td>
		  <td nowrap='nowrap'><%=innerorderid%></td>
		  <td nowrap='nowrap'><%=purchaseunit%></td>
		  <td nowrap='nowrap'><%=purchasenum%></td>
		  <td nowrap='nowrap'><%=unitpice%></td>
		  <td nowrap='nowrap'><%=currency%></td>
		  <td nowrap='nowrap'><%=money%></td>
		  <td nowrap='nowrap'><%=reservedate%></td>
		  <td nowrap='nowrap'><%=origin%></td>
		  <td nowrap='nowrap'><%=invoicenum%></td>
		  <td nowrap='nowrap'><%=certainnum%></td>
		  <td nowrap='nowrap'><%=invoiceunitprice%></td>
		  <td nowrap='nowrap'><%=invoicemoney%></td>
		  <td nowrap='nowrap'><%=freeid%></td>
		  <td nowrap='nowrap'><%=goodsid%></td>
		  <td nowrap='nowrap'><%=freenum%></td>
		  <td nowrap='nowrap'><%=purchasetype%></td>
		  <td nowrap='nowrap'><%=costcenter%></td>
		  <td nowrap='nowrap'><%=costname%></td>
		  
		  </tr>
	<%}%>	  
	<tr><td colspan=32 style="background-color:#CEFEC9;height:30px">分拆后到货明细(设备)</td></tr>
     <%

	for(int i=0,leni=fcequipment.size();i<leni;i++){
		Map eqmap = (Map)fcequipment.get(i);
		String id = StringHelper.null2String(eqmap.get("id"));
		String ladingitem = StringHelper.null2String(eqmap.get("ladingitem"));
		String imlistid = StringHelper.null2String(eqmap.get("imlistid"));
		String reqnum = StringHelper.null2String(eqmap.get("reqnum"));
		String orderid = StringHelper.null2String(eqmap.get("orderid"));
		String orderitem = StringHelper.null2String(eqmap.get("orderitem"));
		String article = StringHelper.null2String(eqmap.get("article"));
		String assetsid = StringHelper.null2String(eqmap.get("assetsid"));
		String innerorderid = StringHelper.null2String(eqmap.get("innerorderid"));
		String purchaseunit = StringHelper.null2String(eqmap.get("purchaseunit"));
		String purchasenum = StringHelper.null2String(eqmap.get("purchasenum"));
		String unitpice = StringHelper.null2String(eqmap.get("unitprice"));
		String currency = StringHelper.null2String(eqmap.get("currency"));
		String money = StringHelper.null2String(eqmap.get("money"));
		String reservedate = StringHelper.null2String(eqmap.get("reservedate"));
		String origin = StringHelper.null2String(eqmap.get("origin"));
		String invoicenum = StringHelper.null2String(eqmap.get("invoicenum"));
		String certainnum = StringHelper.null2String(eqmap.get("certainnum"));
		String invoiceunitprice = StringHelper.null2String(eqmap.get("invoiceunitprice"));
		String invoicemoney = StringHelper.null2String(eqmap.get("invoicemoney"));
		String freeid = StringHelper.null2String(eqmap.get("freeid"));
		String freenum = StringHelper.null2String(eqmap.get("freenum"));
		String goodsid = StringHelper.null2String(eqmap.get("goodsid"));
 		String customsid = StringHelper.null2String(eqmap.get("customsid"));
		String customsitem = StringHelper.null2String(eqmap.get("customsitem"));
		String customsdate = StringHelper.null2String(eqmap.get("customsdate")); 
		String receiptnum = StringHelper.null2String(eqmap.get("receiptnum"));
		String tradetype = StringHelper.null2String(eqmap.get("tradetype"));
		String purchasetype = StringHelper.null2String(eqmap.get("purchasetype"));
		String costcenter = StringHelper.null2String(eqmap.get("costcenter"));
		String costname = StringHelper.null2String(eqmap.get("costname"));
		String fromid = StringHelper.null2String(eqmap.get("fromid"));
		%>
		  <tr class=tr1>
		  <td nowrap='nowrap' colspan=2><a href="javascript:dist('<%=id%>',<%=purchasenum%>)">拆分</a>&nbsp;<a href="javascript:DistCancle('<%=fromid%>')">取消</a></td>
<!-- 		  <td nowrap='nowrap'><%=ladingitem%></td> -->
		  <td nowrap='nowrap'><%=imlistid%></td>
		  <td nowrap='nowrap'><%=reqnum%></td>
		  <td nowrap='nowrap'><%=orderid%></td>
		  <td nowrap='nowrap'><%=orderitem%></td>
		  <td nowrap='nowrap'><%=article%></td>
		  <td nowrap='nowrap'><%=assetsid%></td>
		  <td nowrap='nowrap'><%=innerorderid%></td>
		  <td nowrap='nowrap'><%=purchaseunit%></td>
		  <td nowrap='nowrap'><%=purchasenum%></td>
		  <td nowrap='nowrap'><%=unitpice%></td>
		  <td nowrap='nowrap'><%=currency%></td>
		  <td nowrap='nowrap'><%=money%></td>
		  <td nowrap='nowrap'><%=reservedate%></td>
		  <td nowrap='nowrap'><%=origin%></td>
		  <td nowrap='nowrap'><%=invoicenum%></td>
		  <td nowrap='nowrap'><%=certainnum%></td>
		  <td nowrap='nowrap'><%=invoiceunitprice%></td>
		  <td nowrap='nowrap'><%=invoicemoney%></td>
		  <td nowrap='nowrap'><%=freeid%></td>
		  <td nowrap='nowrap'><%=goodsid%></td>
		  <td nowrap='nowrap'><%=freenum%></td>
		  <td nowrap='nowrap'><%=purchasetype%></td>
		  <td nowrap='nowrap'><%=costcenter%></td>
		  <td nowrap='nowrap'><%=costname%></td>
		  
		  </tr>
	<%}%>
  </table>
  </div>
</form>
<script type="text/javascript">
window.onbeforeunload = function(){
	window.opener.location.href=window.opener.location.href;
}
</script>
</body>
</html>


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              