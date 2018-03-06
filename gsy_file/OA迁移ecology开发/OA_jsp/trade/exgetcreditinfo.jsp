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


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->
<%
String delsql = "delete uf_tr_exfeedtitem   where requestid = '"+requestid+"'";
baseJdbc.update(delsql);
int no=0;
String sql = "select (select costname from uf_tr_fymcwhd  where requestid=a.feetype) as feetype,a.ledaccount,a.taxcode,a.amount,a.currency,a.custcenter,a.salesid,a.salesitem,a.zgsubjects  from uf_tr_exfeedtdivvy a  where requestid = '"+requestid+"'";
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		String feetype=StringHelper.null2String(mk.get("feetype"));//费用名称
		String ledaccount=StringHelper.null2String(mk.get("ledaccount"));//费用总账科目
		String zgsubjects=StringHelper.null2String(mk.get("zgsubjects"));//暂估总账科目
		String cur=StringHelper.null2String(mk.get("currency"));//币种
		String amount=StringHelper.null2String(mk.get("amount"));//暂估金额

		String custcenter=StringHelper.null2String(mk.get("custcenter"));//成本中心
		String salesid=StringHelper.null2String(mk.get("salesid"));//销售凭证号
		String salesitem=StringHelper.null2String(mk.get("salesitem"));//销售凭证项次
		String rate = StringHelper.null2String(mk.get("rate"));;//汇率
		String taxcode = StringHelper.null2String(mk.get("taxcode"));//默认税码

		String text = feetype+"-"+salesid;
		String flag=cur+"-"+taxcode;
		no++;
		String insql = "insert into uf_tr_exfeedtitem (id,requestid,sid,accountcode,subject,taxcode,estamount,estcurrency,costcenter,receiptid,receiptitem,text1,flag)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','40','"+ledaccount+"','"+taxcode+"','"+amount+"','"+cur+"','"+custcenter+"','"+salesid+"','"+salesitem+"','"+text+"','"+flag+"')";
		baseJdbc.update(insql);
		no++;
		insql = "insert into uf_tr_exfeedtitem (id,requestid,sid,accountcode,subject,taxcode,estamount,estcurrency,costcenter,receiptid,receiptitem,text1,flag)values ('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+no+"','50','"+zgsubjects+"','','"+amount+"','"+cur+"','','"+salesid+"','"+salesitem+"','"+text+"','"+flag+"')";
		baseJdbc.update(insql);
		//System.out.println(insql);
	}
}



%>

