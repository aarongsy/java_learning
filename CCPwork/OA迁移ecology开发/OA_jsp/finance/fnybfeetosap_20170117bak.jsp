<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	String pzdate = "";//凭证日期
	String jzdate = "";//记账日期

	String pztype = "";//凭证类型
	String comcode = "";//公司代码
	String jzdur ="";//过账期间
	String user = "";//用户名
	String cur = "";//货币代码
	String rate ="";//汇率
	String pztitle = "";//抬头文本
	String ref="";//参照
	//String sql="select postingdate,changerate,certificatetype,(select objno from getcompanyview where requestid=firmcode) as firmcode,(select objname from humres where id=systemwitness) as systemwitness,currencycode,postingmonth,certificatedate,invoicenumber,(select objname  from selectitem where id=feetype) as pztitle  from uf_fn_mainfeeapp  where requestid='"+requestid+"'";
	String sql="select postingdate,changerate,certificatetype,(select objno from getcompanyview where requestid=firmcode) as firmcode,(select objname from humres where id=systemwitness) as systemwitness,currencycode,postingmonth,certificatedate,invoicenumber,proofrise from uf_fn_mainfeeapp  where requestid='"+requestid+"'";
	List list1 = baseJdbc.executeSqlForList(sql);
	if(list1.size()>0){
		for(int i=0;i<list1.size();i++){
			Map map1 = (Map)list1.get(i);
			jzdate = StringHelper.null2String(map1.get("postingdate"));//记账日期——过账日期
			rate = StringHelper.null2String(map1.get("changerate"));//汇率——汇率(凭证)
			pztype = StringHelper.null2String(map1.get("certificatetype"));//凭证类型——凭证类型
			comcode = StringHelper.null2String(map1.get("firmcode"));//公司代码——公司代码(凭证)
			user = StringHelper.null2String(map1.get("systemwitness"));//用户名——制证人
			cur = StringHelper.null2String(map1.get("currencycode"));//货币代码——币别(凭证)
			jzdur = StringHelper.null2String(map1.get("postingmonth"));//记账期间——过账期间(月份)
			pzdate = StringHelper.null2String(map1.get("certificatedate"));//凭证日期——凭证日期
			ref=StringHelper.null2String(map1.get("invoicenumber"));//参考凭证号——发票号码
			//pztitle=StringHelper.null2String(map1.get("pztitle"));//凭证抬头文本——费用名称
			pztitle=StringHelper.null2String(map1.get("proofrise"));//凭证抬头文本——发票类别
		}
	}




	pzdate = pzdate.replace("-", "");//凭证日期
	jzdate = jzdate.replace("-", "");//记帐日期
    //创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_FI_DOC_CREATE";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段

	function.getImportParameterList().setValue("DOC_DATE",pzdate);//凭证日期
	function.getImportParameterList().setValue("PSTNG_DATE",jzdate);//记帐日期
	function.getImportParameterList().setValue("DOC_TYPE",pztype);//凭证类型
	function.getImportParameterList().setValue("COMP_CODE",comcode);//公司代码
	function.getImportParameterList().setValue("PSTNG_PERIOD",jzdur);//记帐期间
	function.getImportParameterList().setValue("CURRENCY",cur);//货币代码
	function.getImportParameterList().setValue("EXCHNG_RATE",rate);//汇率
	//System.out.println(rate);
	function.getImportParameterList().setValue("HEADER_TXT",pztitle);//抬头文本
	function.getImportParameterList().setValue("USER_NAME",user);//用户名
	function.getImportParameterList().setValue("RUN_MODE","N");//调用模式
	function.getImportParameterList().setValue("REF_DOC_NO",ref);//凭证参照
	function.getImportParameterList().setValue("NOTESID",requestid);//Notesid


    System.out.println("NOTESID------------------"+requestid);
	//建表(凭证行项目)
	JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
	//sql = "select chargecode,subject,amount,paydate,freezpay,payterms,paytype,paycurrency,paycurrencyamount,taxcode,costcenter,internalorder,salesorder,salesorderitem,purchaseorder,purchaseorderitem,cooperativebanktype,text from uf_fn_certificateitems  where requestid = '"+requestid+"' order by ordernumber asc ";
	sql = "select a.chargecode,a.subject,a.amount,a.paydate,a.freezpay,a.payterms,a.paytype,a.paycurrency,a.paycurrencyamount,a.taxcode,a.costcenter,a.internalorder,a.salesorder,a.salesorderitem,a.purchaseorder,a.purchaseorderitem,a.cooperativebanktype,a.text,a.sgl from uf_fn_certificateitems a  where a.requestid = '"+requestid+"' order by to_number(a.ordernumber) asc ";
	list1 = baseJdbc.executeSqlForList(sql);
	System.out.println(sql);
	if(list1.size()>0){
		for(int i=0;i<list1.size();i++){
			Map map1 = (Map)list1.get(i);
			String accountcode = StringHelper.null2String(map1.get("chargecode"));//记账码
			String subject = StringHelper.null2String(map1.get("subject"));//总账科目
			String money = StringHelper.null2String(map1.get("amount"));//金额
			if(money.indexOf(".")!=-1)
			{
				if(money.split("\\.")[1].equals("00")||money.split("\\.")[1].equals("0")||money.split("\\.")[1].equals("000"))
				{
					money=money.split("\\.")[0];
				}
			}


			String paydate = StringHelper.null2String(map1.get("paydate"));//付款基准日期
			paydate = paydate.replace("-", "");//凭证日期
			String payfreeze = StringHelper.null2String(map1.get("freezpay"));//付款冻结

			String payitem = StringHelper.null2String(map1.get("payterms"));//付款条款
			String paytype = StringHelper.null2String(map1.get("paytype"));//付款方式

			String currency = StringHelper.null2String(map1.get("paycurrency"));//实际货币(支付货币)
			String paymoney = StringHelper.null2String(map1.get("paycurrencyamount"));//实际货币金额(支付货币金额)

			String taxcaode = StringHelper.null2String(map1.get("taxcode"));//税码
			String costcenter = StringHelper.null2String(map1.get("costcenter"));//成本中心
			String internalorder = StringHelper.null2String(map1.get("internalorder"));//内部订单
			String receiptid = StringHelper.null2String(map1.get("salesorder"));//销售凭证
			String receiptitem = StringHelper.null2String(map1.get("salesorderitem"));//销售凭证项次
			String purchaseorder = StringHelper.null2String(map1.get("purchaseorder"));//采购订单
			String purchaseorderitem = StringHelper.null2String(map1.get("purchaseorderitem"));//采购订单项次
			String banktype = StringHelper.null2String(map1.get("cooperativebanktype"));//银行类型
			String text1 = StringHelper.null2String(map1.get("text"));//文本
			String sgl = StringHelper.null2String(map1.get("sgl"));//文本

			retTable1.appendRow();

			retTable1.setValue("PSTNG_CODE", accountcode); //记账码
			retTable1.setValue("GL_ACCOUNT", subject);//总账科目

			retTable1.setValue("MONEY", money);//金额
			retTable1.setValue("PAY_TERMS", payitem);//付款条款

			retTable1.setValue("PAY_DATE", paydate);//付款基准日期
			retTable1.setValue("PAY_LOCK", payfreeze);//付款冻结

			retTable1.setValue("PAY_WAY", paytype);//付款方式
			retTable1.setValue("PAY_CUR", currency);//支付货币

			retTable1.setValue("PAY_MONEY", paymoney); //支付货币金额
			retTable1.setValue("TAX_CODE", taxcaode);//税码

			retTable1.setValue("COST_CENTER", costcenter);//成本中心
			retTable1.setValue("ORDER_ID", internalorder);//内部订单

			retTable1.setValue("SO_NO", receiptid);//销售凭证
			retTable1.setValue("SO_ITEM", receiptitem);//销售凭证项次

			retTable1.setValue("PO_NO", purchaseorder);//采购订单
			retTable1.setValue("PO_ITEM", purchaseorderitem);//采购订单项次

			retTable1.setValue("BANK_TYPE", banktype);//合作银行
			retTable1.setValue("ITEM_TEXT", text1);//文本
			retTable1.setValue("SGL_FLAG", sgl);//文本

		}
	}

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

	String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
	String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
	String FLAG = function.getExportParameterList().getValue("FLAG").toString();
	String upsql="update uf_fn_mainfeeapp  set documentnumber='"+AC_DOC_NO+"',successfulident='"+FLAG+"',errorcode='"+ERR_MSG+"' where requestid='"+requestid+"'";
	baseJdbc.update(upsql);
	JSONObject jo = new JSONObject();		
	jo.put("msg", ERR_MSG);
	jo.put("res", "true");
	jo.put("acdocno", AC_DOC_NO);
	jo.put("flag", FLAG);
	System.out.println("AC_DOC_NO:"+AC_DOC_NO);
	System.out.println("ERR_MSG:"+ERR_MSG);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
