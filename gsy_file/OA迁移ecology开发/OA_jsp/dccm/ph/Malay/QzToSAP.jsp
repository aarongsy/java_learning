<%@ page language="java" contentType="application/json"
	pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.app.configsap.SapConnector"%>
<%@ page import="com.sap.conn.jco.JCoException"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
	String action = StringHelper.null2String(request.getParameter("action"));
	if (action.equals("ClearToSAP"))//凭证行项目信息(税金清帐) 
	{
		String requestid = StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		JSONObject jo = new JSONObject();
		String sql = "select a.proofdate,a.jzdate,a.prooftype,b.objno,a.jzperiod,a.currcode,a.exrate,a.referproof,a.proofhead,a.subject,a.notesid,e.objname from uf_dmph_sjyfqzmain a left join getcompanyview b on a.comcode=b.objno left join humres e on a.username=e.id where a.requestid='"+ requestid + "'";
		List list = baseJdbc.executeSqlForList(sql);
		if (list.size() > 0) 
		{
			for (int i = 0; i < list.size(); i++) 
			{
				Map map = (Map) list.get(i);
				String receiptdate = StringHelper.null2String(map.get("proofdate"));//凭证日期
				receiptdate = receiptdate.replace("-", "");
				String accdate = StringHelper.null2String(map.get("jzdate"));//记账日期
				accdate = accdate.replace("-", "");
				String receipttype = StringHelper.null2String(map.get("prooftype"));//凭证类型
				String objno = StringHelper.null2String(map.get("objno"));//公司代码
				String accperiod = StringHelper.null2String(map.get("jzperiod"));//记账期间
				String currencycode = StringHelper.null2String(map.get("currcode"));//货币代码
				String cwrate = StringHelper.null2String(map.get("exrate"));//汇率
				String referreceipt = StringHelper.null2String(map.get("referproof"));//参考凭证号
				String receipthead = StringHelper.null2String(map.get("proofhead"));//凭证抬头	
				//String notesid = StringHelper.null2String(map.get("notesid"));//NOTES文档ID
				String objname = StringHelper.null2String(map.get("objname"));//用户名
				//String subject = StringHelper.null2String(map.get("subject"));//科目
				//String estreceiptid = StringHelper.null2String(map.get("estreceiptid"));//暂估凭证编号
				//String payreceiptid = StringHelper.null2String(map.get("payreceiptid"));//预付凭证编号 */
				//创建SAP对象		
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZOA_FI_CDOC_CREATE";
				JCoFunction function = null;
				try {
					function = SapConnector
							.getRfcFunction(functionName);
				} catch (Exception e) {
					e.printStackTrace();
				}
				//插入字段
				function.getImportParameterList().setValue("DOC_DATE",receiptdate);
				function.getImportParameterList().setValue("PSTNG_DATE", accdate);
				function.getImportParameterList().setValue("DOC_TYPE",receipttype);
				function.getImportParameterList().setValue("COMP_CODE",objno);
				function.getImportParameterList().setValue("PSTNG_PERIOD", accperiod);
				function.getImportParameterList().setValue("CURRENCY",currencycode);
				function.getImportParameterList().setValue("EXCHNG_RATE", cwrate);
				function.getImportParameterList().setValue("REF_DOC_NO", referreceipt);
				function.getImportParameterList().setValue("HEADER_TXT", receipthead);
				function.getImportParameterList().setValue("NOTESID","");
				function.getImportParameterList().setValue("USER_NAME",objname);
				function.getImportParameterList().setValue("RUN_MODE","N");

				System.out.println("币别"+currencycode);
				System.out.println("汇率"+cwrate);

				JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
				sql = "select a.jzcode,a.subject,a.amount,b.code,a.paydate,a.paydj,a.payway,a.taxcode,a.costcenter,a.purorder,a.orderitem,a.text from uf_dmph_qzpzdetail a left join uf_dmdb_payterm b on a.payterm = b.requestid where a.requestid='"
				+ requestid + "'";
				List list2 = baseJdbc.executeSqlForList(sql);
				if (list2.size() > 0) 
				{
					for (int m = 0; m < list2.size(); m++)
					{
						Map map2 = (Map) list2.get(m);
						retTable.appendRow();
						retTable.setValue("PSTNG_CODE", StringHelper.null2String(map2.get("jzcode")));//记账码
						retTable.setValue("GL_ACCOUNT", StringHelper.null2String(map2.get("subject")));//总账科目
						retTable.setValue("MONEY", StringHelper.null2String(map2.get("amount")));//金额
						retTable.setValue("PAY_TERMS", StringHelper.null2String(map2.get("code")));//付款条款---------
						retTable.setValue("PAY_DATE", StringHelper.null2String(map2.get("paydate")).replace("-", ""));//收付基准日期（到期日）
						retTable.setValue("PAY_REF", StringHelper.null2String(map2.get("paydj")));//付款参考
						retTable.setValue("PAY_WAY", StringHelper.null2String(map2.get("payway")));//付款方式--------------
						retTable.setValue("TAX_CODE", StringHelper.null2String(map2.get("taxcode")));//税码
						retTable.setValue("COST_CENTER", StringHelper.null2String(map2.get("costcenter")));//成本中心
						retTable.setValue("PO_NO", StringHelper.null2String(map2.get("purorder")));//采购订单号
						retTable.setValue("PO_ITEM", StringHelper.null2String(map2.get("orderitem")));//采购订单行号
						retTable.setValue("ITEM_TEXT", StringHelper.null2String(map2.get("text")));//文本

					}
				}
				//建表(未清项行项目)
				JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_CLEAR");
				sql = "select serialno,suppmark,subject,tbzzmark,qzproofno,kjyear,qzproofitem,qzlavesum,qztxt from uf_dmph_wqxdetail  where requestid = '"+requestid+"' order by serialno asc";
				List list1 = baseJdbc.executeSqlForList(sql);
				if(list1.size()>0)
				{
					for(int j=0;j<list1.size();j++)
					{
						Map map1 = (Map)list1.get(j);
						String custsuppflag = StringHelper.null2String(map1.get("suppmark"));//客户供应商标识
						String custsuppcode = StringHelper.null2String(map1.get("subject"));//客户/供应商编码
						String ledgerflag = StringHelper.null2String(map1.get("tbzzmark"));//特殊总账标识
						String clearreceiptid = StringHelper.null2String(map1.get("qzproofno"));//需清帐凭证编号
						String fiscalyear = StringHelper.null2String(map1.get("kjyear"));//会计年度
						String clearreceiptitem = StringHelper.null2String(map1.get("qzproofitem"));//需清帐凭证项次
						String surplusmoney = StringHelper.null2String(map1.get("qzlavesum"));//清帐剩余金额
						String cleartext = StringHelper.null2String(map1.get("qztxt"));//清帐文本

						retTable1.appendRow();
						retTable1.setValue("VC_FLAG", custsuppflag); //客户供应商标识
						retTable1.setValue("VC_NO", custsuppcode);//客户/供应商编码
						retTable1.setValue("SGL_FLAG", ledgerflag);//特殊总账标识
						retTable1.setValue("DOC_NO", clearreceiptid);//需清帐凭证编号
						retTable1.setValue("DOC_YEAR", fiscalyear);//会计年度
						retTable1.setValue("DOC_ITEM", clearreceiptitem);//需清帐凭证项次
						retTable1.setValue("CL_MONEY", surplusmoney);//清帐剩余金额
						retTable1.setValue("CL_TEXT", cleartext);//清帐文本
					}
				}
				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}

				//返回值
				String errorid = function.getExportParameterList().getValue("ERR_MSG").toString();
				String succflag = function.getExportParameterList().getValue("FLAG").toString();
				String receiptid = function.getExportParameterList().getValue("AC_DOC_NO").toString();
				System.out.println("凭证号"+receiptid);
				System.out.println("成功标识"+succflag);
				System.out.println("错误代码"+errorid);
				jo.put("receiptid", receiptid);
				jo.put("succflag", succflag);
				jo.put("errorid", errorid);
			}
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	} 
	else if (action.equals("NoClearRead"))//读取未清项信息(税金清帐) 
    {
		String str = request.getParameter("str");
		System.out.println(str);
		String comcode = request.getParameter("comcode");//公司代码
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction("ZOA_FI_CLEAR_READ");
		} catch (Exception e) {
			e.printStackTrace();
		}
		function.getImportParameterList().setValue("BUKRS",comcode);//公司代码
		//function.getImportParameterList().setValue("LIFNR",supply);//供应商简码
		String [] aa = str.split("@");
		//建表
		JCoTable retTable = function.getTableParameterList().getTable("FI_OA_LIST");
		for(int i = 0;i<aa.length;i++)
		{
			String pzh = aa[i];//凭证号
			String year = aa[i+2];//会计年度
			String type = aa[i+3];//会计年度
			retTable.appendRow();
			retTable.setValue("BELNR",pzh);//凭证编号2200005404
			retTable.setValue("BUKRS",comcode);//公司代码
			retTable.setValue("GJAHR",year);//会计年度
			retTable.setValue("DTYPE",type);//凭证类型
			i = i+3;
		}
		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//抓取抛SAP的返回值
		JCoTable newretTable = function.getTableParameterList().getTable("FI_CLEAR_LIST");
		JSONArray jsonArray = new JSONArray();
		if (newretTable.getNumRows() > 0) 
		{
			for (int i = 0; i < newretTable.getNumRows(); i++) 
			{
				newretTable.setRow(i);
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("BUDAT", newretTable.getString("BUDAT"));//过账日期
				jsonObject.put("BUKRS", newretTable.getString("BUKRS"));//公司代码
				jsonObject.put("GJAHR", newretTable.getString("GJAHR"));//会计年度
				jsonObject.put("BELNR", newretTable.getString("BELNR"));//凭证编号
				jsonObject.put("BUZEI", newretTable.getString("BUZEI"));//行项目号
				jsonObject.put("WRBTR", newretTable.getString("WRBTR"));//金额
				jsonObject.put("DMBTR", newretTable.getString("DMBTR"));//本位币
				jsonObject.put("FDTAG", newretTable.getString("FDTAG"));//到期日
				jsonObject.put("ZUONR", newretTable.getString("ZUONR"));//分配
				jsonObject.put("SGTXT", newretTable.getString("SGTXT"));//文本
				jsonObject.put("HKONT", newretTable.getString("HKONT"));//供应商/总账科目
				jsonObject.put("KOART", newretTable.getString("KOART"));//科目类型
				jsonObject.put("UMSKZ", newretTable.getString("UMSKZ"));//特殊总账标识
				jsonArray.add(jsonObject);
			}
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jsonArray.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
	else if(action.equals("mateClearToSap"))//物料凭证上抛
	{
	    String requestid = StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		JSONObject jo = new JSONObject();
		String sql = "select a.postdate,b.objno from uf_tr_taxadvclear a left join getcompanyview b on a.comcode=b.requestid  where a.requestid='"+ requestid + "'";
		List list = baseJdbc.executeSqlForList(sql);
		if (list.size() > 0) 
		{
			for (int i = 0; i < list.size(); i++) 
			{
				Map map = (Map) list.get(i);
				String postdate = StringHelper.null2String(map.get("postdate"));//过账日期
				postdate = postdate.replace("-", "");
				String objno = StringHelper.null2String(map.get("objno"));//公司代码
				//创建SAP对象		
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZOA_FI_CDOC_CREATE";
				JCoFunction function = null;
				try {
					function = SapConnector
							.getRfcFunction(functionName);
				} catch (Exception e) {
					e.printStackTrace();
				}
				//插入字段
				function.getImportParameterList().setValue("BUDAT",postdate);
				function.getImportParameterList().setValue("BUKRS", objno);
				function.getImportParameterList().setValue("WERKS",objno);
				function.getImportParameterList().setValue("XBLNR","");
				function.getImportParameterList().setValue("BKTXT","");
				JCoTable retTable = function.getTableParameterList().getTable("ZMM_DOC_ITEM");
				sql = "select money,materialid from uf_tr_taxclearmainfo where a.requestid='"+ requestid + "'";
				List list2 = baseJdbc.executeSqlForList(sql);
				if (list2.size() > 0)
				{
					for (int m = 0; m < list2.size(); m++)
					{
						Map map2 = (Map) list2.get(m);
						retTable.appendRow();
						retTable.setValue("MATNR", StringHelper.null2String(map2.get("materialid")));//物料号
						retTable.setValue("ZUUMB", StringHelper.null2String(map2.get("money")));//金额
					}
				}
				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
				//返回值
				String errorid = function.getExportParameterList().getValue("ERR_MSG").toString();
				String succflag = function.getExportParameterList().getValue("FLAG").toString();
				String pzh = function.getExportParameterList().getValue("MBLNR").toString();//物料凭证号
				jo.put("wlh", pzh);
				jo.put("succflag", succflag);
				jo.put("errorid", errorid);
			}
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
%>
