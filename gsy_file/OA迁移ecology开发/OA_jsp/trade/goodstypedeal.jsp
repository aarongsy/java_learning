<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="com.eweaver.cpms.project.task.*"%>
<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	DataService ds = new DataService();
	String actionSt = StringHelper.null2String(request.getParameter("submitaction"));
	String userid = currentuser.getId();
	String detailids = StringHelper.null2String(request.getParameter("detailids"));
	String optype = StringHelper.null2String(request.getParameter("optype"));
	String orgnum = StringHelper.null2String(request.getParameter("orgnum"));
	String sql="";
	String fromid = StringHelper.null2String(request.getParameter("fromid"));
	if(actionSt.equals("submit")){
		String sqlSt="";
		List<String> sqlList =new ArrayList<String>();
		
		String disnum = StringHelper.null2String(request.getParameter("disnum"));
		
		String detailid = StringHelper.null2String(request.getParameter("detailid"));

		if(optype.equals("distmain")){//主明细分拆
			sql = "select * from uf_tr_selequipmentdt t where requestid = '"+requestid+"' and id='"+fromid+"' and not exists (select fromid from uf_tr_spequipmentdt where requestid=t.requestid and fromid=t.id) and  not exists (select id from uf_tr_meequipmentdt where requestid=t.requestid and id=t.meeid) order by rowindex" ;
			List equipment= baseJdbc.executeSqlForList(sql);
			if(equipment.size()>0){
				//拆分为两条
				String newid=IDGernerator.getUnquieID();
				
				sqlSt = "insert into uf_tr_spequipmentdt(id,requestid,rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum,unitprice,currency,money,"
					+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,"
					+"freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid)";
				sqlSt += " select '"+newid+"','"
					+requestid
					+"',rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum-"+disnum+",unitpice,currency,money-round(unitpice*"+disnum+",2),"
					+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,'"+fromid+"'"
					+"from uf_tr_selequipmentdt where id='"+fromid+"' order by rowindex";
				sqlList.add(sqlSt);
				newid=IDGernerator.getUnquieID();
				sqlSt = "insert into uf_tr_spequipmentdt(id,requestid,rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,purchasenum,unitprice,currency,money,"
					+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,"
					+"freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,fromid)";
				sqlSt += " select '"+newid+"','"
					+requestid
					+"',rowindex,ladingitem,imlistid,reqnum,orderid,orderitem,article,assetsid,innerorderid,purchaseunit,"+disnum+",unitpice,currency,round(unitpice*"+disnum+",2),"
					+"reservedate,origin,invoicenum,certainnum,invoiceunitprice,invoicemoney,freeid,freenum,goodsid,customsid,customsitem,customsdate,receiptnum,tradetype,purchasetype,costcenter,costname,detinfo,'"+fromid+"'"
					+" from uf_tr_selequipmentdt where id='"+fromid+"' order by rowindex";
				sqlList.add(sqlSt);
			}
		}
		if(optype.equals("dist")){//分拆明细分折
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
		out.println("<script>");
		out.println("alert('提交成功！');");
		out.println("var pwin=self.parent;");
		out.println("if(pwin){");
			out.println("pwin.location.reload();");
		out.println("}");
		out.println("</script>");
		return;
		
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/js/formbase.js"></script>

<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
         .x-panel-body {
        border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
        border-right:#99bbe8 0px solid
     }
    .x-panel-body-noheader{
        border-top:#99bbe8 0px solid
    }
	input{ border-left:0px;border-top:0px;border-right:0px;border-bottom:1px solid #0D0000 } span{ vertical-align:top; }
</style>
<script type="text/javascript">
function onSubmit(){
	var orgnum=<%=orgnum%>;
	var disnum=document.getElementById("disnum").value;
	if(disnum.length<1||parseFloat(disnum)<1||parseFloat(disnum)>=parseFloat(orgnum)){
		alert('拆分数据必须大于 0 且小于明细总数量！');
		return;
	}
	document.getElementById('submitaction').value="submit";
	document.EweaverForm.submit();
			
}
</script>
<body>
<br>
<div id="contentDiv">
<div id="pagemenubar"></div> 
<form id="EweaverForm" name="EweaverForm" action="" target="" method="post">
<input type="hidden" name="submitaction" value="search"/>
<fieldset>
<DIV id=layoutDiv>
<input type="hidden" name="detailids" value="<%=detailids%>"  style='width: 80%'  >
<input type="hidden" name="fromid" value="<%=fromid%>"  style='width: 80%'  >
<input type="hidden" name="optype" value="<%=optype%>"  style='width: 80%'  >
<TABLE class=layouttable border=0>
<CAPTION></CAPTION>
<COLGROUP>
<COL width="15%">
<COL width="35%">
<COL width="15%">
<COL width="35%">
</COLGROUP>
<TBODY>


	<%if(optype.equals("distmain")||optype.equals("dist")){%>

		<TR height="30"><TD class=Spacing colspan=4 align="left">拆分处理，请在下面输入拆分数量:<br></TD><TR>
		
		<tr>
		<TD class=FieldName noWrap>当前数量</TD>
		<TD class=FieldValue >
		<input type="text" name="orgnum"  id="orgnum" style="width:100px;height:18px;font-size: 11px;text-align:center;background-color:#FFFF33" value="<%=orgnum%>" readOnly>	</TD>
		<TD class=FieldName noWrap>拆分数量</TD>
		<TD class=FieldValue >
			<input type="text" name="disnum"  id="disnum" style="width:100px;height:18px;font-size: 11px;text-align:center" value="">
		</TD></TR>
	<%}%>
</TBODY></TABLE>
<br>
 <div id="throwstr" style='color:red;font-weight:bold;text-align:center' >
    
</div>
<input type="button" name="close" value="拆分" style="height:25px" onclick="javascript:onSubmit();">&nbsp;&nbsp;
<input type="button" name="close" value="关闭并刷新" style="height:25px" onclick="javascript:closeandrefresh();">
</DIV></CENTER>
</form>
</fieldset>
 </center>
</div>
</body>
</html>
<script>
function closeandrefresh(){
	pwin=self.parent;
	if(pwin){
		pwin.location.reload();
		//pwin.splitIframe3.store.reload();
		//pwin.Window.css('display', 'none');;
	}
}
</script>
