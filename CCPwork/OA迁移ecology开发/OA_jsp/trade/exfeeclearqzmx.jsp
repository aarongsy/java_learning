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

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));

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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

 <DIV id="warpp">


<TABLE id=oTable40285a8d4aff85d1014b004272090dd8 class=detailtable border=1> 
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
<COL width="5%" style="display:none"> 
<COL width="5%" style="display:none"> 
<COL width="5%" style="display:none"> 
<COL width="5%" style="display:none"> 
<COL width="5%" style="display:none">
<COL width="5%">
</COLGROUP> 
<TBODY> 
<TR class=Header> 
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a8d4aff85d1014b004272090dd8')" value=-1 type=checkbox name=check_node_all>序号</TD> 
<TD noWrap>订单号</TD> 
<TD noWrap>外销联络单编号</TD> 
<TD noWrap>费用类型</TD> 
<TD noWrap>支付对象</TD> 
<TD noWrap>费用暂估币种</TD> 
<TD noWrap>暂估金额</TD> 
<TD noWrap>暂估汇率</TD> 
<TD noWrap>暂估本位币金额</TD> 
<TD noWrap>清帐金额</TD> 
<TD noWrap>清帐本位币金额</TD> 
<TD noWrap>业务货币差额</TD> 
<TD noWrap>本位币差额</TD> 
<TD noWrap>成本中心</TD> 
<TD noWrap>总账科目</TD> 
<TD noWrap>暂估总账科目</TD> 
<TD noWrap>分摊基数</TD> 
<TD noWrap>发票金额</TD> 
<TD noWrap>发票数量</TD> 
<TD noWrap>费用暂估文档ID</TD>
<TD noWrap>备注</TD>
</TR> 


<%

		String sql="select a.sno,a.orderid,a.exlistid,a.feetype,a.payobject,a.estcurrency,a.estmoney,a.estrate,a.estamount,a.clearmoney,a.clearamount,a.buscurrencydiff,a.currencydiff,a.costcenter,a.ledgersubject,a.estledgersubject,(select objname from selectitem where id=a.allocbase) as allocbasename,allocbase,a.invoicemoney,a.invoicenum,a.feeestid,a.ftid,a.remark from uf_tr_exfeeclearsub a where a.requestid='"+requestid+"' order by a.exlistid asc";
		//System.out.println(sql);
       List sublist = baseJdbc.executeSqlForList(sql);
	   int no1=0;
       if(sublist.size()>0){
	          for(int k=0,sizek=sublist.size();k<sizek;k++){
		      Map mk = (Map)sublist.get(k);
			  
			  String sno=StringHelper.null2String(mk.get("sno"));
			  String orderid=StringHelper.null2String(mk.get("orderid"));
			  String exlistid=StringHelper.null2String(mk.get("exlistid"));
			  String feetype=StringHelper.null2String(mk.get("feetype"));
			  String payobject=StringHelper.null2String(mk.get("payobject"));
			  String estcurrency=StringHelper.null2String(mk.get("estcurrency"));
			  String estmoney=StringHelper.null2String(mk.get("estmoney"));
			  String estrate=StringHelper.null2String(mk.get("estrate"));
			  String estamount=StringHelper.null2String(mk.get("estamount"));
			  String clearmoney=StringHelper.null2String(mk.get("clearmoney"));
			  String clearamount=StringHelper.null2String(mk.get("clearamount"));
			  String buscurrencydiff=StringHelper.null2String(mk.get("buscurrencydiff"));
			  String currencydiff=StringHelper.null2String(mk.get("currencydiff"));
			  String costcenter=StringHelper.null2String(mk.get("costcenter"));
			  String ledgersubject=StringHelper.null2String(mk.get("ledgersubject"));
			  String estledgersubject=StringHelper.null2String(mk.get("estledgersubject"));
			  String allocbase=StringHelper.null2String(mk.get("allocbase"));
			  String allocbasename=StringHelper.null2String(mk.get("allocbasename"));
			  String invoicemoney=StringHelper.null2String(mk.get("invoicemoney"));
			  String invoicenum=StringHelper.null2String(mk.get("invoicenum"));
			  String feeestid=StringHelper.null2String(mk.get("feeestid"));
			  String ftid=StringHelper.null2String(mk.get("ftid"));
			  String remark=StringHelper.null2String(mk.get("remark"));
			 
		                
                     
		%>
<TR id=oTR40285a8d4aff85d1014b004272090dd8 class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap><span ><input type="checkbox" name="check_node_40285a8d4aff85d1014b004272090dd8" value="<%=k%>"><input type=hidden name="detailid_40285a8d4aff85d1014b004272090dd8_0" value="<%=k%>"></span><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cecf0dd9_"+k%> name=<%="field_40285a8d4aff85d1014b0048cecf0dd9_"+k%> value="<%=sno%>" maxlength=24  ><span style='width: 60%' id=<%="field_40285a8d4aff85d1014b0048cecf0dd9_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cecf0dd9_"+k+"span"%> ><%=(k+1)%></span></TD>

<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cef40ddb_"+k%> name=<%="field_40285a8d4aff85d1014b0048cef40ddb_"+k%>  value="<%=orderid%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cef40ddb_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cef40ddb_"+k+"span"%> ><%=orderid%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cf1a0ddd_"+k%> name=<%="field_40285a8d4aff85d1014b0048cf1a0ddd_"+k%>  value="<%=exlistid%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cf1a0ddd_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cf1a0ddd_"+k+"span"%> ><%=exlistid%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cf3e0ddf_"+k%> name=<%="field_40285a8d4aff85d1014b0048cf3e0ddf_"+k%>  value="<%=feetype%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cf3e0ddf_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cf3e0ddf_"+k+"span"%> ><%=feetype%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cf630de1_"+k%> name=<%="field_40285a8d4aff85d1014b0048cf630de1_"+k%>  value="<%=payobject%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cf630de1_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cf630de1_"+k+"span"%> ><%=payobject%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cf880de3_"+k%> name=<%="field_40285a8d4aff85d1014b0048cf880de3_"+k%>  value="<%=estcurrency%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cf880de3_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cf880de3_"+k+"span"%> ><%=estcurrency%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cfae0de5_"+k%> name=<%="field_40285a8d4aff85d1014b0048cfae0de5_"+k%>  value="<%=estmoney%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cfae0de5_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cfae0de5_"+k+"span"%> ><%=estmoney%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048cfe00de7_"+k%> name=<%="field_40285a8d4aff85d1014b0048cfe00de7_"+k%>  value="<%=estrate%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048cfe00de7_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048cfe00de7_"+k+"span"%> ><%=estrate%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d0220de9_"+k%> name=<%="field_40285a8d4aff85d1014b0048d0220de9_"+k%>  value="<%=estamount%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d0220de9_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d0220de9_"+k+"span"%> ><%=estamount%></span></TD>
<TD noWrap><input type="text" class="InputStyle2" name=<%="field_40285a8d4aff85d1014b0048d0490deb_"+k%>  id=<%="field_40285a8d4aff85d1014b0048d0490deb_"+k%> value="<%=clearmoney%>"  style='width: 80%' onblur="changeqzje('<%=sno%>','<%=k%>')" ><span id=<%="field_40285a8d4aff85d1014b0048d0490deb_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d0490deb_"+k+"span"%> ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
<TD noWrap><input type="text" class="InputStyle2" name=<%="field_40285a8d4aff85d1014b0048d0700ded_"+k%>  id=<%="field_40285a8d4aff85d1014b0048d0700ded_"+k%> value="<%=clearamount%>"  style='width: 80%' onblur="changeqzbwb('<%=sno%>','<%=k%>')" ><span id=<%="field_40285a8d4aff85d1014b0048d0700ded_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d0700ded_"+k+"span"%> ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d0960def_"+k%> name=<%="field_40285a8d4aff85d1014b0048d0960def_"+k%>  value="<%=buscurrencydiff%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d0960def_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d0960def_"+k+"span"%> ><%=buscurrencydiff%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d0be0df1_"+k%> name=<%="field_40285a8d4aff85d1014b0048d0be0df1_"+k%>  value="<%=currencydiff%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d0be0df1_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d0be0df1_"+k+"span"%> ><%=currencydiff%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d0e40df3_"+k%> name=<%="field_40285a8d4aff85d1014b0048d0e40df3_"+k%>  value="<%=costcenter%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d0e40df3_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d0e40df3_"+k+"span"%> ><%=costcenter%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d1040df5_"+k%> name=<%="field_40285a8d4aff85d1014b0048d1040df5_"+k%>  value="<%=ledgersubject%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d1040df5_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d1040df5_"+k+"span"%> ><%=ledgersubject%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d1250df7_"+k%> name=<%="field_40285a8d4aff85d1014b0048d1250df7_"+k%>  value="<%=estledgersubject%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d1250df7_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d1250df7_"+k+"span"%> ><%=estledgersubject%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d1470df9_"+k%> name=<%="field_40285a8d4aff85d1014b0048d1470df9_"+k%>  value="<%=allocbase%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d1470df9_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d1470df9_"+k+"span"%> ><%=allocbasename%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d1670dfb_"+k%> name=<%="field_40285a8d4aff85d1014b0048d1670dfb_"+k%>  value="<%=invoicemoney%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d1670dfb_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d1670dfb_"+k+"span"%> ><%=invoicemoney%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d1880dfd_"+k%> name=<%="field_40285a8d4aff85d1014b0048d1880dfd_"+k%>  value="<%=invoicenum%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0048d1880dfd_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0048d1880dfd_"+k+"span"%> ><%=invoicenum%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0048d1b10dff_"+k%> name=<%="field_40285a8d4aff85d1014b0048d1b10dff_"+k%> value="<%=feeestid%>" >
<input type="hidden" id=<%="field_40285a8d4ec298f2014eddd6da41784e_"+k%> name=<%="field_40285a8d4ec298f2014eddd6da41784e_"+k%> value="<%=ftid%>" >
</TD>
<TD noWrap><input type="text"  class="InputStyle2" id=<%="field_40285a8d51c8aaea0151c8e5550e004c_"+k%> name=<%="field_40285a8d51c8aaea0151c8e5550e004c_"+k%> value="<%=remark%>" onblur="changeremark('<%=sno%>','<%=k%>')"></TD>
</TR>
		<%	

	}
}else{%> 
<TR id=oTR40285a8d4aff85d1014b004272090dd8 class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap><span ><input type="checkbox" name="check_node_40285a8d4aff85d1014b004272090dd8" value="0"><input type=hidden name="detailid_40285a8d4aff85d1014b004272090dd8_0" value=""></span><input type="hidden" id="field_40285a8d4aff85d1014b0048cecf0dd9_0" name="field_40285a8d4aff85d1014b0048cecf0dd9_0" value="" maxlength=24  ><span style='width: 60%' id="field_40285a8d4aff85d1014b0048cecf0dd9_0span" name="field_40285a8d4aff85d1014b0048cecf0dd9_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cef40ddb_0" name="field_40285a8d4aff85d1014b0048cef40ddb_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cef40ddb_0span" name="field_40285a8d4aff85d1014b0048cef40ddb_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cf1a0ddd_0" name="field_40285a8d4aff85d1014b0048cf1a0ddd_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cf1a0ddd_0span" name="field_40285a8d4aff85d1014b0048cf1a0ddd_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cf3e0ddf_0" name="field_40285a8d4aff85d1014b0048cf3e0ddf_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cf3e0ddf_0span" name="field_40285a8d4aff85d1014b0048cf3e0ddf_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cf630de1_0" name="field_40285a8d4aff85d1014b0048cf630de1_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cf630de1_0span" name="field_40285a8d4aff85d1014b0048cf630de1_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cf880de3_0" name="field_40285a8d4aff85d1014b0048cf880de3_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cf880de3_0span" name="field_40285a8d4aff85d1014b0048cf880de3_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cfae0de5_0" name="field_40285a8d4aff85d1014b0048cfae0de5_0"  value=""   ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cfae0de5_0span" name="field_40285a8d4aff85d1014b0048cfae0de5_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048cfe00de7_0" name="field_40285a8d4aff85d1014b0048cfe00de7_0"  value=""   ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048cfe00de7_0span" name="field_40285a8d4aff85d1014b0048cfe00de7_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d0220de9_0" name="field_40285a8d4aff85d1014b0048d0220de9_0"  value=""   ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d0220de9_0span" name="field_40285a8d4aff85d1014b0048d0220de9_0span" ></span></TD>
<TD noWrap><input type="text" class="InputStyle2" name="field_40285a8d4aff85d1014b0048d0490deb_0"  id="field_40285a8d4aff85d1014b0048d0490deb_0" value=""  style='width: 80%'  ><span id="field_40285a8d4aff85d1014b0048d0490deb_0span" name="field_40285a8d4aff85d1014b0048d0490deb_0span" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
<TD noWrap><input type="text" class="InputStyle2" name="field_40285a8d4aff85d1014b0048d0700ded_0"  id="field_40285a8d4aff85d1014b0048d0700ded_0" value=""  style='width: 80%'  ><span id="field_40285a8d4aff85d1014b0048d0700ded_0span" name="field_40285a8d4aff85d1014b0048d0700ded_0span" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d0960def_0" name="field_40285a8d4aff85d1014b0048d0960def_0"  value=""   ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d0960def_0span" name="field_40285a8d4aff85d1014b0048d0960def_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d0be0df1_0" name="field_40285a8d4aff85d1014b0048d0be0df1_0"  value=""   ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d0be0df1_0span" name="field_40285a8d4aff85d1014b0048d0be0df1_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d0e40df3_0" name="field_40285a8d4aff85d1014b0048d0e40df3_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d0e40df3_0span" name="field_40285a8d4aff85d1014b0048d0e40df3_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d1040df5_0" name="field_40285a8d4aff85d1014b0048d1040df5_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d1040df5_0span" name="field_40285a8d4aff85d1014b0048d1040df5_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d1250df7_0" name="field_40285a8d4aff85d1014b0048d1250df7_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d1250df7_0span" name="field_40285a8d4aff85d1014b0048d1250df7_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d1470df9_0" name="field_40285a8d4aff85d1014b0048d1470df9_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d1470df9_0span" name="field_40285a8d4aff85d1014b0048d1470df9_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d1670dfb_0" name="field_40285a8d4aff85d1014b0048d1670dfb_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d1670dfb_0span" name="field_40285a8d4aff85d1014b0048d1670dfb_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d1880dfd_0" name="field_40285a8d4aff85d1014b0048d1880dfd_0"  value=""  ><span style='width: 80%' id="field_40285a8d4aff85d1014b0048d1880dfd_0span" name="field_40285a8d4aff85d1014b0048d1880dfd_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4aff85d1014b0048d1b10dff_0" name="field_40285a8d4aff85d1014b0048d1b10dff_0" value="" ></TD>
<TD noWrap><input type="text"  class="InputStyle2" id="field_40285a8d51c8aaea0151c8e5550e004c_0" name="field_40285a8d51c8aaea0151c8e5550e004c_0" value="" ></TD>
</TR>
<%} %>
</TBODY>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          