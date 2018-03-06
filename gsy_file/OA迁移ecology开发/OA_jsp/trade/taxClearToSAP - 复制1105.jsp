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
	if (action.equals("taxcleartoSap")) {

		String requestid = StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		JSONObject jo = new JSONObject();
		String sql = "select a.receiptdate,a.accdate,a.receipttype,b.objno,a.accperiod,a.cwcurrency,a.cwrate,a.referreceipt,a.receipthead,e.objname from uf_tr_taxadvclear a left join getcompanyview b on a.comcode=b.requestid  left join humres e on a.username=e.id where a.requestid='"+ requestid + "'";
		List list = baseJdbc.executeSqlForList(sql);
		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {

				Map map = (Map) list.get(i);
				String receiptdate = StringHelper.null2String(map.get("receiptdate"));//凭证日期
				receiptdate = receiptdate.replace("-", "");
				String accdate = StringHelper.null2String(map.get("accdate"));//记账日期
				accdate = accdate.replace("-", "");
				String receipttype = StringHelper.null2String(map.get("receipttype"));//凭证类型
				
				String objno = StringHelper.null2String(map.get("objno"));//公司代码
				String accperiod = StringHelper.null2String(map.get("accperiod"));//记账期间
				String currencycode = StringHelper.null2String(map.get("cwcurrency"));//货币代码
				String cwrate = StringHelper.null2String(map.get("cwrate"));//汇率
				String referreceipt = StringHelper.null2String(map.get("referreceipt"));//参考凭证号
				String receipthead = StringHelper.null2String(map.get("receipthead"));//凭证抬头		
				String notesid = StringHelper.null2String(map.get("notesid"));//NOTES文档ID
				String objname = StringHelper.null2String(map.get("objname"));//用户名
				String subject = StringHelper.null2String(map.get("subject"));//科目
				String estreceiptid = StringHelper.null2String(map.get("estreceiptid"));//暂估凭证编号
				String payreceiptid = StringHelper.null2String(map.get("payreceiptid"));//预付凭证编号 */
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
				function.getImportParameterList().setValue("NOTESID",requestid);
				function.getImportParameterList().setValue("USER_NAME",objname);
				function.getImportParameterList().setValue("RUN_MODE","N");

				JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
				sql = "select a.acccode,a.subject,a.money,b.terms,a.paydate,a.payfreeze,c.paycode,a.taxcode,a.costcenter,a.purorder,a.purorderitem,a.text1 from uf_tr_taxclearcwinfo a left join uf_tr_payment b on a.payitem = b.requestid left join uf_tr_paydetail c on a.paytype = c.id where a.requestid='"
						+ requestid + "'";
				List list2 = baseJdbc.executeSqlForList(sql);
				if (list2.size() > 0) {
					for (int m = 0; m < list2.size(); m++) {
						Map map2 = (Map) list2.get(m);
						retTable.appendRow();
						retTable.setValue("PSTNG_CODE", StringHelper.null2String(map2.get("acccode")));//记账码
						retTable.setValue("GL_ACCOUNT", StringHelper.null2String(map2.get("subject")));//总账科目
						retTable.setValue("MONEY", StringHelper.null2String(map2.get("money")));//金额
						retTable.setValue("PAY_TERMS", StringHelper.null2String(map2.get("terms")));//付款条款---------
						retTable.setValue("PAY_DATE", StringHelper.null2String(map2.get("paydate")).replace("-", ""));//收付基准日期（到期日）
						retTable.setValue("PAY_REF", StringHelper.null2String(map2.get("payfreeze")));//付款参考
						retTable.setValue("PAY_WAY", StringHelper.null2String(map2.get("paycode")));//付款方式--------------
						retTable.setValue("TAX_CODE", StringHelper.null2String(map2.get("taxcode")));//税码
						retTable.setValue("COST_CENTER", StringHelper.null2String(map2.get("costcenter")));//成本中心
						retTable.setValue("PO_NO", StringHelper.null2String(map2.get("purorder")));//采购订单号
						retTable.setValue("PO_ITEM", StringHelper.null2String(map2.get("purorderitem")));//采购订单行号
						retTable.setValue("ITEM_TEXT", StringHelper.null2String(map2.get("text1")));//文本

					}
				}
				//建表(未清项行项目)
				JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_CLEAR");
				sql = "select sno,custsuppflag,custsuppcode,ledgerflag,receiptid,accyear,receiptitem,clearmoney,cleartext from uf_tr_taxclearnoinfo  where requestid = '"+requestid+"' order by sno asc";
				List list1 = baseJdbc.executeSqlForList(sql);
				if(list1.size()>0){
					for(int j=0;j<list1.size();j++){
						Map map1 = (Map)list1.get(j);
						String custsuppflag = StringHelper.null2String(map1.get("custsuppflag"));//客户供应商标识
						//String custsuppflag = StringHelper.null2String(map1.get("K"));
						String custsuppcode = StringHelper.null2String(map1.get("custsuppcode"));//客户/供应商编码
						String ledgerflag = StringHelper.null2String(map1.get("ledgerflag"));//特殊总账标识

						String clearreceiptid = StringHelper.null2String(map1.get("receiptid"));//需清帐凭证编号
						String fiscalyear = StringHelper.null2String(map1.get("accyear"));//会计年度
						String clearreceiptitem = StringHelper.null2String(map1.get("receiptitem"));//需清帐凭证项次
						String surplusmoney = StringHelper.null2String(map1.get("clearmoney"));//清帐剩余金额
						String cleartext = StringHelper.null2String(map1.get("cleartext"));//清帐文本

						retTable1.appendRow();
						//System.out.println(ledgerflag);
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
				jo.put("receiptid", receiptid);
				jo.put("succflag", succflag);
				jo.put("errorid", errorid);
			}
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();

	} else if (action.equals("noClearRead")) {

		String comcode = request.getParameter("comcode");
		String yfpzh = request.getParameter("pzh");
		String year = request.getParameter("year");
		String type = request.getParameter("type");
		String state = request.getParameter("state");
		if (year != null && !year.equals("")) {
			year = year.substring(0, 4);
		}
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
		
		
		
		JCoTable retTable = function.getTableParameterList().getTable("FI_OA_LIST");//预付
		retTable.appendRow();
		retTable.setValue("BELNR",yfpzh);//凭证编号2200005404
		retTable.setValue("BUKRS",comcode);//公司代码
		retTable.setValue("GJAHR",year);//会计年度
		retTable.setValue("DTYPE",type);//凭证类型
		
		/* retTable.setValue("BELNR", yfpzh);//凭证编号
		retTable.setValue("BUKRS", comcode);//公司代码
		retTable.setValue("GJAHR", year);//会计年度
		retTable.setValue("DTYPE", state);//凭证类型 */

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		//抓取抛SAP的返回值
		JCoTable newretTable = function.getTableParameterList().getTable("FI_CLEAR_LIST");
		System.out.println("123123123" + newretTable.getNumRows());
		JSONArray jsonArray = new JSONArray();
		if (newretTable.getNumRows() > 0) {
			for (int i = 0; i < newretTable.getNumRows(); i++) {
				newretTable.setRow(i);
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("BUDAT", newretTable.getString("BUDAT"));//过账日期
				jsonObject.put("BUKRS", newretTable.getString("BUKRS"));//公司代码
				jsonObject.put("GJAHR", newretTable.getString("GJAHR"));//会计年度
				jsonObject.put("BELNR", newretTable.getString("BELNR"));//凭证编号
				jsonObject.put("BUZEI", newretTable.getString("BUZEI"));//行项目号
				jsonObject.put("WRBTR", newretTable.getString("WRBTR"));//金额
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
		System.out.println(jsonArray.toString());
		response.getWriter().write(jsonArray.toString());
		response.getWriter().flush();
		response.getWriter().close();

	}else if(action.equals("mateClearToSap")){//物料凭证上抛
	    String requestid = StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		JSONObject jo = new JSONObject();
		String sql = "select a.postdate,b.objno from uf_tr_taxadvclear a left join getcompanyview b on a.comcode=b.requestid  where a.requestid='"+ requestid + "'";
		List list = baseJdbc.executeSqlForList(sql);
		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {

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
				if (list2.size() > 0) {
					for (int m = 0; m < list2.size(); m++) {
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
