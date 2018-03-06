<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>




<%
	String action=StringHelper.null2String(request.getParameter("action"));

	if (action.equals("CWtoSap")){	
		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		String reqdate = StringHelper.null2String(request.getParameter("reqdate"));//凭证日期
		reqdate = reqdate.replace("-", "");
		String markdate = StringHelper.null2String(request.getParameter("markdate"));//记帐日期
		markdate = markdate.replace("-", "");
		String prooftype = StringHelper.null2String(request.getParameter("prooftype"));//凭证类型
		String objno = StringHelper.null2String(request.getParameter("objno"));//公司代码
		objno = objno.trim();
		String marktime = StringHelper.null2String(request.getParameter("marktime"));//记账期间
		String currencycode = StringHelper.null2String(request.getParameter("currencycode"));//货币代码
		currencycode = currencycode.trim();
		String rate = StringHelper.null2String(request.getParameter("rate"));//汇率
		String proof = StringHelper.null2String(request.getParameter("proof"));//参考凭证号
		String proofhead = StringHelper.null2String(request.getParameter("proofhead"));//凭证抬头
		String km = StringHelper.null2String(request.getParameter("km"));//科目
		String objname = StringHelper.null2String(request.getParameter("objname"));//用户名
		objname = objname.trim();
		String notesid = StringHelper.null2String(request.getParameter("notesid"));//NOTES文档ID
		
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");		
		JSONObject jo = new JSONObject();		

		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_FI_ADOC_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println("DOC_DATE:"+reqdate+" PSTNG_DATE:"+markdate+" DOC_TYPE:"+prooftype+" COMP_CODE:"+objno+" PSTNG_PERIOD:"+marktime+" CURRENCY:"+currencycode+
				//" EXCHNG_RATE:"+rate+" REF_DOC_NO:"+proof+" HEADER_TXT:"+proofhead+" USER_NAME:"+objname+" NOTESID:"+notesid+" RUN_MODE:N");
		//插入字段
		function.getImportParameterList().setValue("DOC_DATE",reqdate);
		function.getImportParameterList().setValue("PSTNG_DATE",markdate);
		function.getImportParameterList().setValue("DOC_TYPE",prooftype);
		function.getImportParameterList().setValue("COMP_CODE",objno);
		function.getImportParameterList().setValue("PSTNG_PERIOD",marktime);
		function.getImportParameterList().setValue("CURRENCY",currencycode);
		function.getImportParameterList().setValue("EXCHNG_RATE",rate);
		function.getImportParameterList().setValue("REF_DOC_NO",proof);
		function.getImportParameterList().setValue("HEADER_TXT",proofhead);
		function.getImportParameterList().setValue("USER_NAME",objname);
		function.getImportParameterList().setValue("NOTESID",notesid);
		function.getImportParameterList().setValue("RUN_MODE","N");
		
		JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
		String sql = "select a.money,a.payment,a.todate,b.paycode,a.conno,a.therow,a.thetext,a.banktype from uf_tr_taxadvanceinfo a left join uf_tr_paydetail b on a.payment=b.id where a.requestid='"+requestid+"' order by no asc";
		List list2 = baseJdbc.executeSqlForList(sql);
		if(list2.size()>0){
			for(int m=0;m<list2.size();m++){
				Map map2 = (Map)list2.get(m);
				String money = StringHelper.null2String(map2.get("money"));
				String payment = StringHelper.null2String(map2.get("payment"));
				String todate = StringHelper.null2String(map2.get("todate"));
				todate = todate.replace("-", "");
				String paycode = StringHelper.null2String(map2.get("paycode"));
				String therow = StringHelper.null2String(map2.get("therow"));
				String conno = StringHelper.null2String(map2.get("conno"));
				String thetext = StringHelper.null2String(map2.get("thetext"));
				String banktype = StringHelper.null2String(map2.get("banktype"));
				
				//System.out.println("MONEY:"+money+" PAY_DATE:"+todate+" PAY_WAY:"+paycode+" PO_ITEM:"+therow+" PO_NO:"+conno+" ITEM_TEXT:"+thetext+" BANK_TYPE:"+banktype);
				if(money.equals(""))
				{
					money = "0";
				}
				retTable.appendRow();
				retTable.setValue("GL_ACCOUNT", km);
				retTable.setValue("MONEY", money);
				retTable.setValue("PAY_WAY", payment);
				retTable.setValue("PAY_DATE", todate);
				//retTable.setValue("PAY_WAY", paycode);
				retTable.setValue("PO_ITEM", therow);
				retTable.setValue("PO_NO", conno);
				retTable.setValue("ITEM_TEXT", thetext);
				retTable.setValue("BANK_TYPE", banktype);
				retTable.setValue("SGL_FLAG", "B");
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
		String message = function.getExportParameterList().getValue("ERR_MSG").toString();
		String msgty = function.getExportParameterList().getValue("FLAG").toString();
		String cwpz = function.getExportParameterList().getValue("AC_DOC_NO").toString();
		jo.put("cwpz", cwpz);
		jo.put("msgty", msgty);
		jo.put("message", message);	

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
	if (action.equals("WLtoSap")){	
		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		String proofhead = StringHelper.null2String(request.getParameter("proofhead"));//凭证抬头
		String markdate = StringHelper.null2String(request.getParameter("markdate"));//过账日期
		markdate = markdate.replace("-", "");
		String objno = StringHelper.null2String(request.getParameter("objno"));//公司代码
		objno = objno.trim();
		String notesid = StringHelper.null2String(request.getParameter("notesid"));//NOTES文档ID
		String factory = StringHelper.null2String(request.getParameter("factory"));//工厂
		factory = factory.trim();
		String referto = StringHelper.null2String(request.getParameter("referto"));//参照
		
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");		
		JSONObject jo = new JSONObject();		

		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_MM_DOC_POST";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//插入字段
		function.getImportParameterList().setValue("BKTXT",proofhead);
		function.getImportParameterList().setValue("BUDAT",markdate);
		function.getImportParameterList().setValue("BUKRS",objno);
		function.getImportParameterList().setValue("NOTESID",notesid);
		function.getImportParameterList().setValue("RUN_MODE","N");
		function.getImportParameterList().setValue("WERKS",factory);
		function.getImportParameterList().setValue("XBLNR",referto);
		
		JCoTable retTable = function.getTableParameterList().getTable("MM_DOC_ITEM");
		String sql = "select materialno,money from uf_tr_taxsub where requestid='"+requestid+"' order by no";
		List list2 = baseJdbc.executeSqlForList(sql);
		if(list2.size()>0){
			for(int m=0;m<list2.size();m++){
				Map map2 = (Map)list2.get(m);
				String materialno = StringHelper.null2String(map2.get("materialno"));
				String money = StringHelper.null2String(map2.get("money"));
				
				retTable.appendRow();
				retTable.setValue("MATNR", materialno);
				retTable.setValue("ZUUMB", money);
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
		String message = function.getExportParameterList().getValue("ERR_MSG").toString();
		String msgty = function.getExportParameterList().getValue("FLAG").toString();
		String cwpz = function.getExportParameterList().getValue("MBLNR").toString();
		jo.put("cwpz", cwpz);
		jo.put("msgty", msgty);
		jo.put("message", message);	

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>