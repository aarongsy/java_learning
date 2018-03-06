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
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//到货类型

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
<DIV id="warpp"> 
<TABLE id="otherfeeinfos" class=detailtable border=1> 

<COLGROUP> 
<COL width=80> 
<COL width=140> 
<COL width=80> 
<COL width=120> 
<COL width=100> 
<COL width=80> 
<COL width=80> 
<COL width=80> 
<COL width=100> 
<COL width=100> 
<COL width=140> 
<COL width=160> 
<COL width=80> 
<COL width=60> 
<COL width=100> 
<COL width=100></COLGROUP> 
<TR class=Header> 
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a8d4ae75b38014aeb964f391e57')" value=-1 type=checkbox name=check_node_all>序号</TD> 
<TD noWrap>进口到货编号</TD> 
<TD noWrap>到货类型</TD> 
<TD noWrap>费用类型</TD> 
<TD noWrap>分摊基数</TD> 
<TD noWrap>币种</TD> 
<TD noWrap>清帐含税金额</TD> 
<TD noWrap>清帐未税金额</TD> 
<TD noWrap>清帐本位币金额</TD> 
<TD noWrap>总账科目</TD> 
<TD noWrap>备注</TD> 
<TD noWrap>发票类型</TD> 
<TD noWrap>税别</TD> 
<TD noWrap>税率</TD> 
<TD noWrap>发票总数量</TD> 
<TD noWrap>发票总金额</TD></TR> 


<%
	//查询数据并显示
	String selsql = "select sno,a.imgoodsid,(select imgoodsid from uf_tr_lading where requestid = a.imgoodsid) as imgoodflow,(select objname from selectitem where id = imgoodstype) as typename,imgoodstype,(select costname from uf_tr_fymcwhd where requestid=feetype) as feename,feetype,(select objname from selectitem where id=allobase) as ftjs,allobase,currency,cleartaxmoney,clearnotaxmoney,clearcurrmoney,ledgersubject,remarks,(select b.invoicetype from uf_tr_fplxwhd b where b.requestid=a.invoicetype) as invoicename,invoicetype,(select objname from selectitem where id=taxtype) as taxtypename,taxtype,taxrate,invoicetotal,invoiceamount from uf_tr_feeothersub a where requestid = '"+requestid+"' order by sno asc";
	//System.out.println(selsql);
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	//System.out.println("查询到的行数为："+sublist4.size());
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String sno = StringHelper.null2String(m4.get("sno"));//序号
			String imgoodflow = StringHelper.null2String(m4.get("imgoodflow"));//进口到货编号
			//System.out.println(imgoodflow);
			String typename = StringHelper.null2String(m4.get("typename"));//进口货物类别
			String feename = StringHelper.null2String(m4.get("feename"));//费用名称
			String ftjs = StringHelper.null2String(m4.get("ftjs"));//分摊基数
			String currency = StringHelper.null2String(m4.get("currency"));//币种
			String cleartaxmoney = StringHelper.null2String(m4.get("cleartaxmoney"));//清帐含税金额
			String clearnotaxmoney = StringHelper.null2String(m4.get("clearnotaxmoney"));//清帐未税金额
			String clearcurrmoney = StringHelper.null2String(m4.get("clearcurrmoney"));//清帐本位币金额
			String ledgersubject = StringHelper.null2String(m4.get("ledgersubject"));//总账科目
			String remarks = StringHelper.null2String(m4.get("remarks"));//备注

			String invoicename = StringHelper.null2String(m4.get("invoicename"));//发票类型

			String taxtypename = StringHelper.null2String(m4.get("taxtypename"));//税别
			String taxrate = StringHelper.null2String(m4.get("taxrate"));//税率
			String invoicetotal = StringHelper.null2String(m4.get("invoicetotal"));//发票总数量
			String invoiceamount = StringHelper.null2String(m4.get("invoiceamount"));//发票总金额

%>
	<TR id="<%="dataDetail_"+sno %>">
		<TD   class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+sno %>" name="sno"><%=sno %></TD>

		<TD  class="td2"   align=center ><%=imgoodflow %></TD>
		<TD  class="td2"   align=center ><%=typename %></TD>

		<TD   class="td2"  align=center><%=feename %></TD>

		<TD   class="td2"  align=center><%=ftjs %></TD>
		
		<TD   class="td2"  align=center><%=currency %></TD>
		<TD   class="td2"  align=center><%=cleartaxmoney %></TD>

		<TD   class="td2"  align=center><%=clearnotaxmoney %></TD>

		<TD  class="td2"   align=center ><%=clearcurrmoney %></TD>
		<TD  class="td2"   align=center ><%=ledgersubject %></TD>

		<TD   class="td2"  align=center><%=remarks %></TD>

		<TD   class="td2"  align=center><%=invoicename %></TD>

		<TD   class="td2"  align=center><%=taxtypename %></TD>

		<TD   class="td2"  align=center><%=taxrate %></TD>
		
		<TD   class="td2"  align=center><%=invoicetotal %></TD>
		<TD   class="td2"  align=center><%=invoiceamount %></TD>

		</TR>
	<%
	}
}else{%> 
<%} %>
</table>
</div>
