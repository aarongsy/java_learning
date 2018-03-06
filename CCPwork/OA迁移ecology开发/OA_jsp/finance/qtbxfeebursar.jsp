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

<div id="warpp">
<TABLE id=oTable40285a8d4d560a2a014d8e58e00147c4 class=detailtable border=1>
<CAPTION>费用明细表（一般费用）<SPAN id=div40285a8d4d560a2a014d8e58e00147c4button name="div40285a8d4d560a2a014d8e58e00147c4button"><A href="javascript:addrow('40285a8d4d560a2a014d8e58e00147c4');"><IMG title=New border=0 src="/images/plus.gif" width=11 height=11></A> <A href="javascript:delrow('40285a8d4d560a2a014d8e58e00147c4');"><IMG title=Delete border=0 src="/images/minus.gif" width=11 height=11></A> <A href="javascript:addrowbyexcel('40285a8d4d560a2a014d8e58e00147c4');"><IMG title=Excel border=0 src="/images/excel.gif" width=11 height=11></A></SPAN></CAPTION>
<COLGROUP>
<COL width="12%"><!--序号-->
<COL width="12%"><!--费用名称-->
<COL width="12%"><!--会计科目-->
<COL width="12%"><!--成本中心-->
<COL width="12%"><!--内部订单-->
<COL width="12%" style="display:none"><!--含税金额-->
<COL width="12%" style="display:none"><!--发票税率-->
<COL width="12%"><!--未税金额-->
<COL width="12%"><!--本币金额--></COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a8d4d560a2a014d8e58e00147c4')" value=-1 type=checkbox name=check_node_all>序号</TD>
<TD style="DISPLAY: none" noWrap>费用名称</TD>
<TD noWrap>会计科目</TD>
<TD noWrap>成本中心</TD>
<TD noWrap>内部订单</TD>
<TD noWrap>含税金额</TD>
<TD noWrap>发票税率</TD>
<TD noWrap>未税金额</TD>
<TD noWrap>本币金额</TD></TR>





<%
	//查询数据并显示
	String selsql = "select ordernumber,accountsubject,costcenter,internalorder,taxamount,invoicerate,notaxamount,localamount from uf_fn_feedetail  where requestid = '"+requestid+"' order by to_number(ordernumber) asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String ordernumber = StringHelper.null2String(m4.get("ordernumber"));//序号
			String accountsubject = StringHelper.null2String(m4.get("accountsubject"));//会计科目
			String costcenter = StringHelper.null2String(m4.get("costcenter"));//成本中心
			String internalorder = StringHelper.null2String(m4.get("internalorder"));//内部订单
			String taxamount = StringHelper.null2String(m4.get("taxamount"));//含税金额
			String invoicerate = StringHelper.null2String(m4.get("invoicerate"));//发票税率
			String notaxamount = StringHelper.null2String(m4.get("notaxamount"));//未税金额
			String localamount = StringHelper.null2String(m4.get("localamount"));//本币金额
%>
<TR id=oTR40285a8d4d560a2a014d8e58e00147c4 class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap><span ><input type="checkbox" name="check_node_40285a8d4d560a2a014d8e58e00147c4" value="<%=j%>"><input type=hidden name="<%="detailid_40285a8d4d560a2a014d8e58e00147c4_"+j%>" value="40285a8d557ada7a0155947487630292"></span><input type="hidden" id="<%="field_40285a8d4d560a2a014d8eade89547c7_"+j%>" name="<%="field_40285a8d4d560a2a014d8eade89547c7_"+j%>"  value="<%=ordernumber%>"  ><span style='width: 50%' id="<%="field_40285a8d4d560a2a014d8eade89547c7_"+j+"span"%>" name="<%="field_40285a8d4d560a2a014d8eade89547c7_"+j+"span"%>" ><%=ordernumber%></span></TD>

<TD style="DISPLAY: none" noWrap><button type=button  class=Browser  id="button_40285a8d4d560a2a014d8eade8bb47c9_0" name="button_40285a8d4d560a2a014d8eade8bb47c9_0" onclick="javascript:getrefobj('field_40285a8d4d560a2a014d8eade8bb47c9_0','field_40285a8d4d560a2a014d8eade8bb47c9_0span','40285a8d5088faa701508d4a831b1dfe','','','0');"></button><input type="hidden" id="field_40285a8d4d560a2a014d8eade8bb47c9_0" name="field_40285a8d4d560a2a014d8eade8bb47c9_0" value=""  style='width: 80%'  ><span id="field_40285a8d4d560a2a014d8eade8bb47c9_0span" name="field_40285a8d4d560a2a014d8eade8bb47c9_0span" ></span></TD>

<TD noWrap><input type="text" class="InputStyle2"  MAXLENGTH=256 name="field_40285a8d4d560a2a014d8eade8e347cb_0"  id="field_40285a8d4d560a2a014d8eade8e347cb_0" style='width: 80%' value="55060400"  ><span id="field_40285a8d4d560a2a014d8eade8e347cb_0span" name="field_40285a8d4d560a2a014d8eade8e347cb_0span" ></span></TD>

<TD noWrap><input type="hidden" id="field_40285a8d4d560a2a014d8eade95a47d1_0" name="field_40285a8d4d560a2a014d8eade95a47d1_0" value="0010101100" ><span   style='width: 80%' id="field_40285a8d4d560a2a014d8eade95a47d1_0span" name="field_40285a8d4d560a2a014d8eade95a47d1_0span" >0010101100</span></TD>

<TD noWrap><input type="text" class="InputStyle2" MAXLENGTH=256 name="field_40285a8d4d560a2a014d8eade9ce47d7_0"  id="field_40285a8d4d560a2a014d8eade9ce47d7_0" style='width: 80%' value="SC1015"  ></TD>

<TD noWrap><input type="text" class="InputStyle2" name="field_40285a8d4d560a2a014d8eadea4647dd_0"  id="field_40285a8d4d560a2a014d8eadea4647dd_0" value="19.65"  style='width: 80%'  ></TD>

<TD noWrap><input type="hidden" id="field_40285a8d4d560a2a014d8eadea6d47df_0" name="field_40285a8d4d560a2a014d8eadea6d47df_0"  value="价外税/0"  ><span style='width: 80%' id="field_40285a8d4d560a2a014d8eadea6d47df_0span" name="field_40285a8d4d560a2a014d8eadea6d47df_0span" >价外税/0</span></TD>

<TD noWrap><input type="text" class="InputStyle2" name="field_40285a8d4d560a2a014d8eadea9547e1_0"  id="field_40285a8d4d560a2a014d8eadea9547e1_0" value="19.65"  style='width: 80%' ></TD>

<TD noWrap><input type="hidden" id="field_40285a8d4d560a2a014d8eadeabf47e3_0" name="field_40285a8d4d560a2a014d8eadeabf47e3_0"  value="19.65"   ><span style='width: 80%' id="field_40285a8d4d560a2a014d8eadeabf47e3_0span" name="field_40285a8d4d560a2a014d8eadeabf47e3_0span" >19.65</span></TD></TR>
	<%
	}
}else{%> 
	<TR><TD class="td2" colspan="11">没有信息</TD></TR>
<%} %>

</TBODY></TABLE></DIV>
