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
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String flag = StringHelper.null2String(request.getParameter("flag"));//空表示新增,不为空表示复制行项目,save表示保存数据 

String delsql = "delete uf_tr_feeothersub where requestid = '"+requestid+"'";
baseJdbc.update(delsql);

String [] snos = StringHelper.null2String(request.getParameter("sno")).split(";");//序号
String [] imgoodnos = StringHelper.null2String(request.getParameter("imgoodno")).split(";");//进口到货编号

String [] imtypes = StringHelper.null2String(request.getParameter("imtype")).split(";");//进口到货类型
String [] feenames = StringHelper.null2String(request.getParameter("feename")).split(";");//费用类型
String [] ftjss = StringHelper.null2String(request.getParameter("ftjs")).split(";");//分摊基数
String [] curs = StringHelper.null2String(request.getParameter("cur")).split(";");//币种
String [] qztaxvalues = StringHelper.null2String(request.getParameter("qztaxvalue")).split(";");//清帐含税金额
String [] qznotaxvalues = StringHelper.null2String(request.getParameter("qznotaxvalue")).split(";");//清帐未税金额
String [] qzcurvalues = StringHelper.null2String(request.getParameter("qzcurvalue")).split(";");//清帐本位币金额
String [] subjects = StringHelper.null2String(request.getParameter("subject")).split(";");//总账科目
String [] remarkss = StringHelper.null2String(request.getParameter("remarks")).split(";");//备注
String [] invoicetypes = StringHelper.null2String(request.getParameter("invoicetype")).split(";");//发票类型
String [] taxtypes = StringHelper.null2String(request.getParameter("taxtype")).split(";");//税别
String [] taxrates = StringHelper.null2String(request.getParameter("taxrate")).split(";");//税率
String [] alinvonums = StringHelper.null2String(request.getParameter("alinvonum")).split(";");//发票总数量
String [] allinvomons = StringHelper.null2String(request.getParameter("allinvomon")).split(";");//发票总金额
String [] flagarr = flag.split(";");

String goodtypes = StringHelper.null2String(request.getParameter("goodtype"));//到货类型



String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c
String str = "";
//System.out.println(snos.length);
//System.out.println(flag);
String tblen=StringHelper.null2String(request.getParameter("len"));
if(tblen.equals(""))
{
	tblen="0";
}
int len =Integer.parseInt(tblen);// snos.length;//得到数据的长度

//需要先将目前表单中的数据存放在数据库中
for(int j = 0;j<snos.length;j++)
{
	if(!snos[j].equals("#"))
	{
		if(imgoodnos[j].equals("#"))
		{
			imgoodnos[j] = "";
		}

		if(imtypes[j].equals("#"))
		{
			imtypes[j] = "";
		}
		if(feenames[j].equals("#"))
		{
			feenames[j] = "";
		}
		if(ftjss[j].equals("#"))
		{
			ftjss[j] = "";
		}
		if(curs[j].equals("#"))
		{
			curs[j] = "";
		}
		if(qztaxvalues[j].equals("#"))
		{
			qztaxvalues[j] = "";
		}
		if(qznotaxvalues[j].equals("#"))
		{
			qznotaxvalues[j] = "";
		}
		if(qzcurvalues[j].equals("#"))
		{
			qzcurvalues[j] = "";
		}
		if(subjects[j].equals("#"))
		{
			subjects[j] = "";
		}
		if(remarkss[j].equals("#"))
		{
			remarkss[j] = "";
		}
		if(invoicetypes[j].equals("#"))
		{
			invoicetypes[j] = "";
		}
		if(taxtypes[j].equals("#"))
		{
			taxtypes[j] = "";
		}
		if(taxrates[j].equals("#"))
		{
			taxrates[j] = "";
		}
		if(alinvonums[j].equals("#"))
		{
			alinvonums[j] = "";
		}
		if(allinvomons[j].equals("#"))
		{
			allinvomons[j] = "";
		}
		
		String insql = "insert into uf_tr_feeothersub(id,requestid,sno,imgoodsid,imgoodstype,feetype,allobase,currency,cleartaxmoney,clearnotaxmoney,clearcurrmoney,ledgersubject,remarks,invoicetype,taxtype,taxrate,invoicetotal,invoiceamount)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+snos[j]+"','"+imgoodnos[j]+"','"+imtypes[j]+"','"+feenames[j]+"','"+ftjss[j]+"','"+curs[j]+"','"+qztaxvalues[j]+"','"+qznotaxvalues[j]+"','"+qzcurvalues[j]+"','"+subjects[j]+"','"+remarkss[j]+"','"+invoicetypes[j]+"','"+taxtypes[j]+"','"+taxrates[j]+"','"+alinvonums[j]+"','"+allinvomons[j]+"')";
		//System.out.println(insql);
		baseJdbc.update(insql);
		if(!flag.equals("") && !flag.equals("save"))//如果不是空值
		{//System.out.println(snos[j]);
			for(int i = 0;i<flagarr.length;i++)
			{
				if(flagarr[i].equals(snos[j]))
				{
					//System.out.println(flag);
					//System.out.println("复制一行数据"+snos[j]);
					len = len+1;
					insql = "insert into uf_tr_feeothersub(id,requestid,sno,imgoodsid,imgoodstype,feetype,allobase,currency,cleartaxmoney,clearnotaxmoney,clearcurrmoney,ledgersubject,remarks,invoicetype,taxtype,taxrate,invoicetotal,invoiceamount)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+len+"','"+imgoodnos[j]+"','"+imtypes[j]+"','"+feenames[j]+"','"+ftjss[j]+"','"+curs[j]+"','"+qztaxvalues[j]+"','"+qznotaxvalues[j]+"','"+qzcurvalues[j]+"','"+subjects[j]+"','"+remarkss[j]+"','"+invoicetypes[j]+"','"+taxtypes[j]+"','"+taxrates[j]+"','"+alinvonums[j]+"','"+allinvomons[j]+"')";
					//System.out.println(insql);
					baseJdbc.update(insql);
				}
			}
		}
	}
	
}
	str = "OK";
	JSONObject jo = new JSONObject();		
	jo.put("str", str);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

