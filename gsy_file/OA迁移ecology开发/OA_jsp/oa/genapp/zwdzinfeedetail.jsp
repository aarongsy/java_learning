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
String sql = StringHelper.null2String(request.getParameter("sql"));//
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
System.out.println(sql);

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
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String no=StringHelper.null2String(mk.get("no"));
		String ucstcen=StringHelper.null2String(mk.get("ucstcen"));
		String exttextfield9=StringHelper.null2String(mk.get("exttextfield9"));
		String applyer=StringHelper.null2String(mk.get("applyer"));
		String dept=StringHelper.null2String(mk.get("dept"));
		String subcate=StringHelper.null2String(mk.get("subcate"));
		String sepcify=StringHelper.null2String(mk.get("sepcify"));
		String unit=StringHelper.null2String(mk.get("unit"));
		String excptdate = StringHelper.null2String(mk.get("excptdate"));
		String receivenum = StringHelper.null2String(mk.get("receivenum"));
		String currency = StringHelper.null2String(mk.get("currency"));
		String price = StringHelper.null2String(mk.get("price"));
		String taxcode = StringHelper.null2String(mk.get("taxcode"));
		String taxrate = StringHelper.null2String(mk.get("taxrate"));
		String ledgersubj = StringHelper.null2String(mk.get("ledgersubj"));
		String id = StringHelper.null2String(mk.get("requestid"));
		String goodsname = StringHelper.null2String(mk.get("goodsname"));
		String goods = StringHelper.null2String(mk.get("goods"));
		String taxstyle = StringHelper.null2String(mk.get("taxstyle"));
		String isfinish = StringHelper.null2String(mk.get("isfinish"));
		String inorder = StringHelper.null2String(mk.get("inorder"));
		Double amount=0.00;
		Double ratenum=0.00;

     
		if(price.equals("null")||price.equals("")||price==null)  
		{  
			price="0";   
		}  
  
		if(inorder ==null||inorder.equals("null")||inorder.equals(""))  
		{  
			inorder="";
		}  
        amount=Double.valueOf(price)*Double.valueOf(receivenum);
		ratenum=amount/(Double.valueOf(taxrate)/100+1);
		String insql="";   
		if(ucstcen==null||ucstcen.equals("null")||ucstcen.equals(""))  
		{  
			insql ="insert into uf_oa_gensupcheckdetail (ID, REQUESTID, NO, COLNO, COSTCENTER, REQNAME, REQDEPT, SUBCATEGORY, SPECIFY, UNIT, SENDDATE, ACCEPTNUM, CURRENCY, TAXPRICE, TAXAMOUNT, TAXCODE, TAX, NOTAXAMOUNT, INNERORDER, LEGDERSUBJ, REQAPPFLOWNO, GOODSID, GOODSNAME,taxstyle,jzcode,isfinished) values ((select sys_guid() from dual), '"+requestid+"',  "+(k+1)+","+no+", '"+exttextfield9+"', '"+applyer+"', '"+dept+"', '"+subcate+"', '"+sepcify+"', '"+unit+"', '"+excptdate+"', "+receivenum+", '"+currency+"', "+price+", "+amount+",'"+taxcode+"', '"+taxrate+"', "+ ratenum+", '"+inorder+"', '"+ledgersubj+"', '"+id+"', '"+goodsname+"', '"+goods+"','"+taxstyle+"','40','"+isfinish+"')";  

		}  
		else  
		{  
			insql ="insert into uf_oa_gensupcheckdetail (ID, REQUESTID, NO, COLNO, COSTCENTER, REQNAME, REQDEPT, SUBCATEGORY, SPECIFY, UNIT, SENDDATE, ACCEPTNUM, CURRENCY, TAXPRICE, TAXAMOUNT, TAXCODE, TAX, NOTAXAMOUNT, INNERORDER, LEGDERSUBJ, REQAPPFLOWNO, GOODSID, GOODSNAME,taxstyle,jzcode,isfinished) values ((select sys_guid() from dual), '"+requestid+"',  "+(k+1)+","+no+", '"+ucstcen+"', '"+applyer+"', '"+dept+"', '"+subcate+"', '"+sepcify+"', '"+unit+"', '"+excptdate+"', "+receivenum+", '"+currency+"', "+price+", "+amount+",'"+taxcode+"', '"+taxrate+"', "+ ratenum+", '"+inorder+"', '"+ledgersubj+"', '"+id+"', '"+goodsname+"', '"+goods+"','"+taxstyle+"','40','"+isfinish+"')";  
		}  
		baseJdbc.update(insql);
		//System.out.println(insql);
	}
}



%>

