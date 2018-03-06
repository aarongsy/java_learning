package com.eweaver.app.trade.service;

import java.util.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.ParameterList;

public class PurchaseOrder_ZOA_MM_PO_INFO {

	public String functionname;

	public PurchaseOrder_ZOA_MM_PO_INFO(String functionname) {
		setFunctionname(functionname);
	}

	public Map<String,String> findData(String ebeln) {
		try {
			String errorMessage = "";
			SapConnector sapConnector = new SapConnector();
			Map<String,String> retMap = new HashMap<String,String>();
			String functionName = "ZOA_MM_PO_INFO";
			JCoFunction function = SapConnector.getRfcFunction(functionName);
			if (function == null) {
				System.out.println(functionName + " not found in SAP.");
				System.out.println("SAP_RFC中没有此函数!");
				errorMessage = functionName + " not found in SAP.";
			}
			function.getImportParameterList().setValue("EBELN", ebeln);//采购订单号
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			//System.out.println(function);
			if(!"X".equals(function.getExportParameterList().getValue("FLAG"))){
				return null;
			} 
			retMap.put("ebeln", ebeln);	//订单编号
			retMap.put("bsart", StringHelper.null2String(function.getExportParameterList().getValue("BSART")));	//	订单类型
			retMap.put("batxt", StringHelper.null2String(function.getExportParameterList().getValue("BATXT")));	//	订单类型描述
			retMap.put("lifnr", StringHelper.null2String(function.getExportParameterList().getValue("LIFNR")));	//	供应商编码
			retMap.put("name1", StringHelper.null2String(function.getExportParameterList().getValue("NAME1")));	//	供应商名称
			retMap.put("zterm", StringHelper.null2String(function.getExportParameterList().getValue("ZTERM")));	//	付款条款代码
			retMap.put("text1", StringHelper.null2String(function.getExportParameterList().getValue("TEXT1")));	//	付款条款文本
			retMap.put("inco1", StringHelper.null2String(function.getExportParameterList().getValue("INCO1")));	//	国贸条件1
			retMap.put("bezei", StringHelper.null2String(function.getExportParameterList().getValue("BEZEI")));	//	国贸条件描述
			retMap.put("inco2", StringHelper.null2String(function.getExportParameterList().getValue("INCO2")));	//	国贸条件2
			retMap.put("waers", StringHelper.null2String(function.getExportParameterList().getValue("WAERS")));	//	币种
			retMap.put("wkurs", StringHelper.null2String(function.getExportParameterList().getValue("WKURS")));	//	汇率
			retMap.put("bedat", StringHelper.null2String(function.getExportParameterList().getValue("BEDAT")));	//	采购订单日期
			retMap.put("ebele", StringHelper.null2String(function.getExportParameterList().getValue("EBELE")));	//	采购订单号
			retMap.put("rlwrt", StringHelper.null2String(function.getExportParameterList().getValue("RLWRT")));	//	订单总金额
			retMap.put("taxes", StringHelper.null2String(function.getExportParameterList().getValue("TAXES")));	//	含税总金额
			retMap.put("bbsrt", StringHelper.null2String(function.getExportParameterList().getValue("BBSRT")));	//	申请凭证编号
			retMap.put("bukrs", StringHelper.null2String(function.getExportParameterList().getValue("BUKRS")));	//	公司代码
			retMap.put("butxt", StringHelper.null2String(function.getExportParameterList().getValue("BUTXT")));	//	公司别
			return retMap;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return null;
	}
	public Map<String,String> findData_tscg(String ebeln) {
		try {
			String errorMessage = "";
			SapConnector sapConnector = new SapConnector();
			Map<String,String> retMap = new HashMap<String,String>();
			String functionName = "ZOA_MM_PO_INFO";
			JCoFunction function = SapConnector.getRfcFunction(functionName);
			if (function == null) {
				System.out.println(functionName + " not found in SAP.");
				System.out.println("SAP_RFC中没有此函数!");
				errorMessage = functionName + " not found in SAP.";
			}
			function.getImportParameterList().setValue("EBELN", ebeln);//采购订单号
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			retMap.put("ebeln", ebeln);	//订单编号
			retMap.put("bsart", StringHelper.null2String(function.getExportParameterList().getValue("BSART")));	//	订单类型
			retMap.put("batxt", StringHelper.null2String(function.getExportParameterList().getValue("BATXT")));	//	订单类型描述
			retMap.put("lifnr", StringHelper.null2String(function.getExportParameterList().getValue("LIFNR")));	//	供应商编码
			retMap.put("name1", StringHelper.null2String(function.getExportParameterList().getValue("NAME1")));	//	供应商名称
			retMap.put("zterm", StringHelper.null2String(function.getExportParameterList().getValue("ZTERM")));	//	付款条款代码
			retMap.put("text1", StringHelper.null2String(function.getExportParameterList().getValue("TEXT1")));	//	付款条款文本
			retMap.put("inco1", StringHelper.null2String(function.getExportParameterList().getValue("INCO1")));	//	国贸条件1
			retMap.put("bezei", StringHelper.null2String(function.getExportParameterList().getValue("BEZEI")));	//	国贸条件描述
			retMap.put("inco2", StringHelper.null2String(function.getExportParameterList().getValue("INCO2")));	//	国贸条件2
			retMap.put("waers", StringHelper.null2String(function.getExportParameterList().getValue("WAERS")));	//	币种
			retMap.put("wkurs", StringHelper.null2String(function.getExportParameterList().getValue("WKURS")));	//	汇率
			retMap.put("bedat", StringHelper.null2String(function.getExportParameterList().getValue("BEDAT")));	//	采购订单日期
			retMap.put("ebele", StringHelper.null2String(function.getExportParameterList().getValue("EBELE")));	//	采购订单号
			retMap.put("rlwrt", StringHelper.null2String(function.getExportParameterList().getValue("RLWRT")));	//	订单总金额
			retMap.put("taxes", StringHelper.null2String(function.getExportParameterList().getValue("TAXES")));	//	含税总金额
			retMap.put("bbsrt", StringHelper.null2String(function.getExportParameterList().getValue("BBSRT")));	//	申请凭证编号
			retMap.put("bukrs", StringHelper.null2String(function.getExportParameterList().getValue("BUKRS")));	//	公司代码
			retMap.put("butxt", StringHelper.null2String(function.getExportParameterList().getValue("BUTXT")));	//	公司别
			return retMap;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return null;
	}
	public JCoTable findDetail(String ebeln) {
		try {
			String errorMessage = "";
			SapConnector sapConnector = new SapConnector();
			Map<String,String> retMap = new HashMap<String,String>();
			String functionName = "ZOA_MM_PO_INFO";
			JCoFunction function = SapConnector.getRfcFunction(functionName);
			if (function == null) {
				System.out.println(functionName + " not found in SAP.");
				System.out.println("SAP_RFC中没有此函数!");
				errorMessage = functionName + " not found in SAP.";
			}
			function.getImportParameterList().setValue("EBELN", ebeln);//销售订单号
			//function.getImportParameterList().setValue("OTYPE", "WL");
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			//JCoParameterList returnStructure = function.getTableParameterList();
			JCoTable phTable = function.getTableParameterList().getTable("MM_PO_ITEMS");
			return phTable;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return null;
	}
	public void savePurchaseOrder(String ebeln) {
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		String userId = BaseContext.getRemoteUser().getId();
		PurchaseOrder_ZOA_MM_PO_INFO app = new PurchaseOrder_ZOA_MM_PO_INFO(
				"ZOA_MM_PO_INFO");
		Map<String,String> phMap = app.findData(ebeln);
		JCoTable phTable = app.findDetail(ebeln);
		//System.out.println(phTable);
		//System.out.println(phTable);
		StringBuffer buffer = new StringBuffer(4096);
		if (phMap != null) {
			List list = baseJdbc.executeSqlForList("select * from uf_tr_purchaseorder where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and porderno = '"
							+ ebeln + "'");
			// 判断是否已经存在数据 不存在才做 insert 如存在 另处理
			if (list.size() < 1) {
				buffer.append("insert into uf_tr_purchaseorder");
				buffer.append("(id,requestid,ordertype,orderdesc,purchno,purchname,paycode," +
						"paydesc,intrade1,intradedesc,intrade2,currency,wkurs,purchdate," +
						"porderno,total,taxtotal,applytype,company,factory,covermark,downloadtime) values");
				buffer.append("('").append(IDGernerator.getUnquieID())
						.append("',");
				buffer.append("'").append("$ewrequestid$").append("',");
				buffer.append("'").append(phMap.get("bsart")).append("',");
				buffer.append("'").append(phMap.get("batxt")).append("',");
				buffer.append("'").append(phMap.get("lifnr")).append("',");
				buffer.append("'").append(phMap.get("name1")).append("',");
				buffer.append("'").append(phMap.get("zterm")).append("',");
				buffer.append("'").append(phMap.get("text1")).append("',");
				buffer.append("'").append(phMap.get("inco1")).append("',");
				buffer.append("'").append(phMap.get("bezei")).append("',");
				buffer.append("'").append(phMap.get("inco2")).append("',");
				buffer.append("'").append(phMap.get("waers")).append("',");
				buffer.append("'").append(phMap.get("wkurs")).append("',");
				buffer.append("'").append(phMap.get("bedat")).append("',");
				buffer.append("'").append(phMap.get("ebele")).append("',");
				buffer.append("'").append(phMap.get("rlwrt")).append("',");
				buffer.append("'").append(phMap.get("taxes")).append("',");
				buffer.append("'").append(phMap.get("bbsrt")).append("',");
				buffer.append("(select id from orgunit where isdelete = 0 and objno='")
				  .append(phMap.get("bukrs"))
				  .append("'),");
				buffer.append("(select id from orgunittype where id=(select typeid from orgunit where isdelete = 0 and objno='")
				  .append(phMap.get("bukrs"))
				  .append("')),");
				
				buffer.append("'0',");
				buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");
				
				FormBase formBase = new FormBase();
				String categoryid = "40285a904931f62b01493bb5cdc05003";
				// 创建formbase
				formBase.setCreatedate(DateHelper.getCurrentDate());
				formBase.setCreatetime(DateHelper.getCurrentTime());
				formBase.setCreator(StringHelper.null2String(userId));
				formBase.setCategoryid(categoryid);
				formBase.setIsdelete(0);
				FormBaseService formBaseService = (FormBaseService) BaseContext
						.getBean("formbaseService");
				formBaseService.createFormBase(formBase);
				String insertSql = buffer.toString();
				insertSql = insertSql.replace("$ewrequestid$",
						formBase.getId());
				baseJdbc.update(insertSql);
				PermissionTool permissionTool = new PermissionTool();
				permissionTool.addPermission(categoryid, formBase.getId(),
						"uf_tr_purchaseorder");

				for (int j = 0; j < phTable.getNumRows(); j++) {
					
					
					ebeln = StringHelper.null2String(phTable.getString("EBELN"));
					String ebelp = StringHelper.null2String(phTable.getString("EBELP"));
					String matnr = StringHelper.null2String(phTable.getString("MATNR"));
					String txzo1 = StringHelper.null2String(phTable.getString("TXZ01"));
					String menge = StringHelper.null2String(phTable.getString("MENGE"));
					String meins = StringHelper.null2String(phTable.getString("MEINS"));
					String eindt = StringHelper.null2String(phTable.getString("EINDT"));
					String netpr = StringHelper.null2String(phTable.getString("NETPR"));
					String waers = StringHelper.null2String(phTable.getString("WAERS"));
					String netwr = StringHelper.null2String(phTable.getString("NETWR"));
					String rmenge = StringHelper.null2String(phTable.getString("RMENGE"));
					String rmeins = StringHelper.null2String(phTable.getString("RMEINS"));
					String aufnr = StringHelper.null2String(phTable.getString("AUFNR"));
					String anln1	= StringHelper.null2String(phTable.getString("ANLN"));
					String banfn = StringHelper.null2String(phTable.getString("BANFN"));
					String bnfpo = StringHelper.null2String(phTable.getString("BNFPO"));

					
					
					buffer = new StringBuffer(4096);
					buffer.append("insert into uf_tr_purchaselist");
					buffer.append("(id,requestid,rowindex,orderno,orderitem,materialno,ordershort,quantity,unit," +
							"delidate,unitprice,currency,total,applyno,applyitem,buynum,buyunit,innerorder," +
							"company,paymentcode,paymentnode,condition1,condition2,suppliercode,suppliername,applytype," +
							"assetsno,runningno,sno) values");
					buffer.append("('").append(IDGernerator.getUnquieID())
							.append("',");
					buffer.append("'").append("$ewrequestid$").append("',");
					buffer.append("'").append(StringHelper.specifiedLengthForInt(j, 3)).append("',");
					buffer.append("'").append(ebeln).append("',");
					buffer.append("'").append(ebelp).append("',");
					buffer.append("'").append(matnr).append("',");
					buffer.append("'").append(txzo1).append("',");
					buffer.append("'").append(menge).append("',");
					buffer.append("'").append(meins).append("',");
					buffer.append("'").append(eindt).append("',");
					buffer.append("'").append(String.format("%.2f", NumberHelper.string2Double(netpr.replace(",", ""),0))).append("',");
					buffer.append("'").append(waers).append("',");
					buffer.append("'").append(netwr).append("',");
					buffer.append("'").append(banfn).append("',");
					buffer.append("'").append(bnfpo).append("',");
					buffer.append("'").append(rmenge).append("',");
					buffer.append("'").append(rmeins).append("',");
					buffer.append("'").append(aufnr).append("',");
					
					buffer.append("'").append(phMap.get("bukrs")).append("',");
					buffer.append("'").append(phMap.get("zterm")).append("',");
					buffer.append("'").append(phMap.get("text1")).append("',");
					buffer.append("'").append(phMap.get("inco1")).append("',");
					buffer.append("'").append(phMap.get("inco2")).append("',");
					buffer.append("'").append(phMap.get("lifnr")).append("',");
					buffer.append("'").append(phMap.get("name1")).append("',");
					buffer.append("'").append(phMap.get("bbsrt")).append("',");
					
					
					buffer.append("'").append(anln1).append("',");
					buffer.append("'").append(ebeln+ebelp).append("',");
					buffer.append("'").append(j).append("')");
					
					insertSql = buffer.toString();
					insertSql = insertSql.replace("$ewrequestid$",
							formBase.getId());
					baseJdbc.update(insertSql);
					
					phTable.nextRow();
				}
			}else{
				buffer.append("update uf_tr_purchaseorder set ");
				buffer.append("ordertype='").append(phMap.get("bsart")).append("',");
				buffer.append("orderdesc='").append(phMap.get("batxt")).append("',");
				buffer.append("purchno='").append(phMap.get("lifnr")).append("',");
				buffer.append("purchname='").append(phMap.get("name1")).append("',");
				buffer.append("paycode='").append(phMap.get("zterm")).append("',");
				buffer.append("paydesc='").append(phMap.get("text1")).append("',");
				buffer.append("intrade1='").append(phMap.get("inco1")).append("',");
				buffer.append("intradedesc='").append(phMap.get("bezei")).append("',");
				buffer.append("intrade2='").append(phMap.get("inco2")).append("',");
				buffer.append("currency='").append(phMap.get("waers")).append("',");
				buffer.append("wkurs='").append(phMap.get("wkurs")).append("',");
				buffer.append("purchdate='").append(phMap.get("bedat")).append("',");
				buffer.append("total='").append(phMap.get("rlwrt")).append("',");
				buffer.append("taxtotal='").append(phMap.get("taxes")).append("',");
				buffer.append("company=(select id from orgunit where isdelete = 0 and objno='")
			  	  .append(phMap.get("bukrs"))
			  	  .append("'),");
				buffer.append("factory=(select id from orgunittype where id=(select typeid from orgunit where isdelete = 0 and objno='")
			  	  .append(phMap.get("bukrs"))
			  	  .append("')),");
				buffer.append("downloadtime=to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
				buffer.append("where covermark = '1' and porderno = '").append(ebeln).append("'");
			
				String insertSql = buffer.toString();
				int isup = baseJdbc.update(insertSql);
				if(isup == 1){
					String reqid = ds.getValue("select requestid from uf_tr_purchaseorder a where porderno = '"+ebeln+"' and exists(select 1 from formbase where a.requestid = id and isdelete <> 1)");
					baseJdbc.update("delete uf_tr_purchaselist where requestid = '"+reqid+"'");
					
					for (int j = 0; j < phTable.getNumRows(); j++) {
						ebeln = StringHelper.null2String(phTable.getString("EBELN"));
						String ebelp = StringHelper.null2String(phTable.getString("EBELP"));
						String matnr = StringHelper.null2String(phTable.getString("MATNR"));
						String txzo1 = StringHelper.null2String(phTable.getString("TXZ01"));
						String menge = StringHelper.null2String(phTable.getString("MENGE"));
						String meins = StringHelper.null2String(phTable.getString("MEINS"));
						String eindt = StringHelper.null2String(phTable.getString("EINDT"));
						String netpr = StringHelper.null2String(phTable.getString("NETPR"));
						String waers = StringHelper.null2String(phTable.getString("WAERS"));
						String netwr = StringHelper.null2String(phTable.getString("NETWR"));
						String rmenge = StringHelper.null2String(phTable.getString("RMENGE"));
						String rmeins = StringHelper.null2String(phTable.getString("RMEINS"));
						String aufnr = StringHelper.null2String(phTable.getString("AUFNR"));
						String anln1	= StringHelper.null2String(phTable.getString("ANLN"));
						String banfn = StringHelper.null2String(phTable.getString("BANFN"));
						String bnfpo = StringHelper.null2String(phTable.getString("BNFPO"));

						
						buffer = new StringBuffer(4096);
						buffer.append("insert into uf_tr_purchaselist");
						buffer.append("(id,requestid,rowindex,orderno,orderitem,materialno,ordershort,quantity,unit," +
								"delidate,unitprice,currency,total,applyno,applyitem,buynum,buyunit,innerorder," +
								"company,paymentcode,paymentnode,condition1,condition2,suppliercode,suppliername,applytype," + 
								"assetsno,runningno,sno) values");
						buffer.append("('").append(IDGernerator.getUnquieID())
								.append("',");
						buffer.append("'").append(reqid).append("',");
						buffer.append("'").append(StringHelper.specifiedLengthForInt(j, 3)).append("',");
						buffer.append("'").append(ebeln).append("',");
						buffer.append("'").append(ebelp).append("',");
						buffer.append("'").append(matnr).append("',");
						buffer.append("'").append(txzo1).append("',");
						buffer.append("'").append(menge).append("',");
						buffer.append("'").append(meins).append("',");
						buffer.append("'").append(eindt).append("',");
						buffer.append("'").append(String.format("%.2f", NumberHelper.string2Double(netpr.replace(",", ""),0))).append("',");
						buffer.append("'").append(waers).append("',");
						buffer.append("'").append(netwr).append("',");
						buffer.append("'").append(banfn).append("',");
						buffer.append("'").append(bnfpo).append("',");
						buffer.append("'").append(rmenge).append("',");
						buffer.append("'").append(rmeins).append("',");
						buffer.append("'").append(aufnr).append("',");
						
						buffer.append("'").append(phMap.get("bukrs")).append("',");
						buffer.append("'").append(phMap.get("zterm")).append("',");
						buffer.append("'").append(phMap.get("text1")).append("',");
						buffer.append("'").append(phMap.get("inco1")).append("',");
						buffer.append("'").append(phMap.get("inco2")).append("',");
						buffer.append("'").append(phMap.get("lifnr")).append("',");
						buffer.append("'").append(phMap.get("name1")).append("',");
						buffer.append("'").append(phMap.get("bbsrt")).append("',");
						
						buffer.append("'").append(anln1).append("',");
						buffer.append("'").append(ebeln+ebelp).append("',");
						buffer.append("'").append(j).append("')");
						
						insertSql = buffer.toString();
						baseJdbc.update(insertSql);
						
						phTable.nextRow();
					}
				}
			}
		}
	}
	public void savePurchaseOrder_tscg(String ebeln) {
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		String userId = BaseContext.getRemoteUser().getId();
		PurchaseOrder_ZOA_MM_PO_INFO app = new PurchaseOrder_ZOA_MM_PO_INFO(
				"ZOA_MM_PO_INFO");
		Map<String,String> phMap = app.findData_tscg(ebeln);
		JCoTable phTable = app.findDetail(ebeln);
		//System.out.println(phTable);
		//System.out.println(phTable);
		StringBuffer buffer = new StringBuffer(4096);
		if (phMap != null) {
			List list = baseJdbc.executeSqlForList("select * from uf_tr_purchaseorder where exists(select 1 from formbase f where requestid = f.id and isdelete <> 1) and porderno = '"
							+ ebeln + "'");
			// 判断是否已经存在数据 不存在才做 insert 如存在 另处理
			if (list.size() < 1) {
				buffer.append("insert into uf_tr_purchaseorder");
				buffer.append("(id,requestid,ordertype,orderdesc,purchno,purchname,paycode," +
						"paydesc,intrade1,intradedesc,intrade2,currency,wkurs,purchdate," +
						"porderno,total,taxtotal,applytype,company,factory,covermark,downloadtime) values");
				buffer.append("('").append(IDGernerator.getUnquieID())
						.append("',");
				buffer.append("'").append("$ewrequestid$").append("',");
				buffer.append("'").append(phMap.get("bsart")).append("',");
				buffer.append("'").append(phMap.get("batxt")).append("',");
				buffer.append("'").append(phMap.get("lifnr")).append("',");
				buffer.append("'").append(phMap.get("name1")).append("',");
				buffer.append("'").append(phMap.get("zterm")).append("',");
				buffer.append("'").append(phMap.get("text1")).append("',");
				buffer.append("'").append(phMap.get("inco1")).append("',");
				buffer.append("'").append(phMap.get("bezei")).append("',");
				buffer.append("'").append(phMap.get("inco2")).append("',");
				buffer.append("'").append(phMap.get("waers")).append("',");
				buffer.append("'").append(phMap.get("wkurs")).append("',");
				buffer.append("'").append(phMap.get("bedat")).append("',");
				buffer.append("'").append(phMap.get("ebele")).append("',");
				buffer.append("'").append(phMap.get("rlwrt")).append("',");
				buffer.append("'").append(phMap.get("taxes")).append("',");
				buffer.append("'").append(phMap.get("bbsrt")).append("',");
				buffer.append("(select id from orgunit where isdelete = 0 and objno='")
				  .append(phMap.get("bukrs"))
				  .append("'),");
				buffer.append("(select id from orgunittype where id=(select typeid from orgunit where isdelete = 0 and objno='")
				  .append(phMap.get("bukrs"))
				  .append("')),");
				
				buffer.append("'0',");
				buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'))");
				
				FormBase formBase = new FormBase();
				String categoryid = "40285a904931f62b01493bb5cdc05003";
				// 创建formbase
				formBase.setCreatedate(DateHelper.getCurrentDate());
				formBase.setCreatetime(DateHelper.getCurrentTime());
				formBase.setCreator(StringHelper.null2String(userId));
				formBase.setCategoryid(categoryid);
				formBase.setIsdelete(0);
				FormBaseService formBaseService = (FormBaseService) BaseContext
						.getBean("formbaseService");
				formBaseService.createFormBase(formBase);
				String insertSql = buffer.toString();
				insertSql = insertSql.replace("$ewrequestid$",
						formBase.getId());
				baseJdbc.update(insertSql);
				PermissionTool permissionTool = new PermissionTool();
				permissionTool.addPermission(categoryid, formBase.getId(),
						"uf_tr_purchaseorder");

				for (int j = 0; j < phTable.getNumRows(); j++) {
					
					
					ebeln = StringHelper.null2String(phTable.getString("EBELN"));
					String ebelp = StringHelper.null2String(phTable.getString("EBELP"));
					String matnr = StringHelper.null2String(phTable.getString("MATNR"));
					String txzo1 = StringHelper.null2String(phTable.getString("TXZ01"));
					String menge = StringHelper.null2String(phTable.getString("MENGE"));
					String meins = StringHelper.null2String(phTable.getString("MEINS"));
					String eindt = StringHelper.null2String(phTable.getString("EINDT"));
					String netpr = StringHelper.null2String(phTable.getString("NETPR"));
					String waers = StringHelper.null2String(phTable.getString("WAERS"));
					String netwr = StringHelper.null2String(phTable.getString("NETWR"));
					String rmenge = StringHelper.null2String(phTable.getString("RMENGE"));
					String rmeins = StringHelper.null2String(phTable.getString("RMEINS"));
					String aufnr = StringHelper.null2String(phTable.getString("AUFNR"));
					String anln1	= StringHelper.null2String(phTable.getString("ANLN"));
					String banfn = StringHelper.null2String(phTable.getString("BANFN"));
					String bnfpo = StringHelper.null2String(phTable.getString("BNFPO"));

					
					
					buffer = new StringBuffer(4096);
					buffer.append("insert into uf_tr_purchaselist");
					buffer.append("(id,requestid,rowindex,orderno,orderitem,materialno,ordershort,quantity,unit," +
							"delidate,unitprice,currency,total,applyno,applyitem,buynum,buyunit,innerorder," +
							"company,paymentcode,paymentnode,condition1,condition2,suppliercode,suppliername,applytype," +
							"assetsno,runningno,sno) values");
					buffer.append("('").append(IDGernerator.getUnquieID())
							.append("',");
					buffer.append("'").append("$ewrequestid$").append("',");
					buffer.append("'").append(StringHelper.specifiedLengthForInt(j, 3)).append("',");
					buffer.append("'").append(ebeln).append("',");
					buffer.append("'").append(ebelp).append("',");
					buffer.append("'").append(matnr).append("',");
					buffer.append("'").append(txzo1).append("',");
					buffer.append("'").append(menge).append("',");
					buffer.append("'").append(meins).append("',");
					buffer.append("'").append(eindt).append("',");
					buffer.append("'").append(String.format("%.2f", NumberHelper.string2Double(netpr.replace(",", ""),0))).append("',");
					buffer.append("'").append(waers).append("',");
					buffer.append("'").append(netwr).append("',");
					buffer.append("'").append(banfn).append("',");
					buffer.append("'").append(bnfpo).append("',");
					buffer.append("'").append(rmenge).append("',");
					buffer.append("'").append(rmeins).append("',");
					buffer.append("'").append(aufnr).append("',");
					
					buffer.append("'").append(phMap.get("bukrs")).append("',");
					buffer.append("'").append(phMap.get("zterm")).append("',");
					buffer.append("'").append(phMap.get("text1")).append("',");
					buffer.append("'").append(phMap.get("inco1")).append("',");
					buffer.append("'").append(phMap.get("inco2")).append("',");
					buffer.append("'").append(phMap.get("lifnr")).append("',");
					buffer.append("'").append(phMap.get("name1")).append("',");
					buffer.append("'").append(phMap.get("bbsrt")).append("',");
					
					
					buffer.append("'").append(anln1).append("',");
					buffer.append("'").append(ebeln+ebelp).append("',");
					buffer.append("'").append(j).append("')");
					
					insertSql = buffer.toString();
					insertSql = insertSql.replace("$ewrequestid$",
							formBase.getId());
					baseJdbc.update(insertSql);
					
					phTable.nextRow();
				}
			}else{
				buffer.append("update uf_tr_purchaseorder set ");
				buffer.append("ordertype='").append(phMap.get("bsart")).append("',");
				buffer.append("orderdesc='").append(phMap.get("batxt")).append("',");
				buffer.append("purchno='").append(phMap.get("lifnr")).append("',");
				buffer.append("purchname='").append(phMap.get("name1")).append("',");
				buffer.append("paycode='").append(phMap.get("zterm")).append("',");
				buffer.append("paydesc='").append(phMap.get("text1")).append("',");
				buffer.append("intrade1='").append(phMap.get("inco1")).append("',");
				buffer.append("intradedesc='").append(phMap.get("bezei")).append("',");
				buffer.append("intrade2='").append(phMap.get("inco2")).append("',");
				buffer.append("currency='").append(phMap.get("waers")).append("',");
				buffer.append("wkurs='").append(phMap.get("wkurs")).append("',");
				buffer.append("purchdate='").append(phMap.get("bedat")).append("',");
				buffer.append("total='").append(phMap.get("rlwrt")).append("',");
				buffer.append("taxtotal='").append(phMap.get("taxes")).append("',");
				buffer.append("company=(select id from orgunit where isdelete = 0 and objno='")
			  	  .append(phMap.get("bukrs"))
			  	  .append("'),");
				buffer.append("factory=(select id from orgunittype where id=(select typeid from orgunit where isdelete = 0 and objno='")
			  	  .append(phMap.get("bukrs"))
			  	  .append("')),");
				buffer.append("downloadtime=to_char(sysdate,'yyyy-MM-dd hh24:mm:ss') ");
				buffer.append("where covermark = '1' and porderno = '").append(ebeln).append("'");
			
				String insertSql = buffer.toString();
				int isup = baseJdbc.update(insertSql);
				if(isup == 1){
					String reqid = ds.getValue("select requestid from uf_tr_purchaseorder a where porderno = '"+ebeln+"' and exists(select 1 from formbase where a.requestid = id and isdelete <> 1)");
					baseJdbc.update("delete uf_tr_purchaselist where requestid = '"+reqid+"'");
					
					for (int j = 0; j < phTable.getNumRows(); j++) {
						ebeln = StringHelper.null2String(phTable.getString("EBELN"));
						String ebelp = StringHelper.null2String(phTable.getString("EBELP"));
						String matnr = StringHelper.null2String(phTable.getString("MATNR"));
						String txzo1 = StringHelper.null2String(phTable.getString("TXZ01"));
						String menge = StringHelper.null2String(phTable.getString("MENGE"));
						String meins = StringHelper.null2String(phTable.getString("MEINS"));
						String eindt = StringHelper.null2String(phTable.getString("EINDT"));
						String netpr = StringHelper.null2String(phTable.getString("NETPR"));
						String waers = StringHelper.null2String(phTable.getString("WAERS"));
						String netwr = StringHelper.null2String(phTable.getString("NETWR"));
						String rmenge = StringHelper.null2String(phTable.getString("RMENGE"));
						String rmeins = StringHelper.null2String(phTable.getString("RMEINS"));
						String aufnr = StringHelper.null2String(phTable.getString("AUFNR"));
						String anln1	= StringHelper.null2String(phTable.getString("ANLN"));
						String banfn = StringHelper.null2String(phTable.getString("BANFN"));
						String bnfpo = StringHelper.null2String(phTable.getString("BNFPO"));

						
						buffer = new StringBuffer(4096);
						buffer.append("insert into uf_tr_purchaselist");
						buffer.append("(id,requestid,rowindex,orderno,orderitem,materialno,ordershort,quantity,unit," +
								"delidate,unitprice,currency,total,applyno,applyitem,buynum,buyunit,innerorder," +
								"company,paymentcode,paymentnode,condition1,condition2,suppliercode,suppliername,applytype," + 
								"assetsno,runningno,sno) values");
						buffer.append("('").append(IDGernerator.getUnquieID())
								.append("',");
						buffer.append("'").append(reqid).append("',");
						buffer.append("'").append(StringHelper.specifiedLengthForInt(j, 3)).append("',");
						buffer.append("'").append(ebeln).append("',");
						buffer.append("'").append(ebelp).append("',");
						buffer.append("'").append(matnr).append("',");
						buffer.append("'").append(txzo1).append("',");
						buffer.append("'").append(menge).append("',");
						buffer.append("'").append(meins).append("',");
						buffer.append("'").append(eindt).append("',");
						buffer.append("'").append(String.format("%.2f", NumberHelper.string2Double(netpr.replace(",", ""),0))).append("',");
						buffer.append("'").append(waers).append("',");
						buffer.append("'").append(netwr).append("',");
						buffer.append("'").append(banfn).append("',");
						buffer.append("'").append(bnfpo).append("',");
						buffer.append("'").append(rmenge).append("',");
						buffer.append("'").append(rmeins).append("',");
						buffer.append("'").append(aufnr).append("',");
						
						buffer.append("'").append(phMap.get("bukrs")).append("',");
						buffer.append("'").append(phMap.get("zterm")).append("',");
						buffer.append("'").append(phMap.get("text1")).append("',");
						buffer.append("'").append(phMap.get("inco1")).append("',");
						buffer.append("'").append(phMap.get("inco2")).append("',");
						buffer.append("'").append(phMap.get("lifnr")).append("',");
						buffer.append("'").append(phMap.get("name1")).append("',");
						buffer.append("'").append(phMap.get("bbsrt")).append("',");
						
						buffer.append("'").append(anln1).append("',");
						buffer.append("'").append(ebeln+ebelp).append("',");
						buffer.append("'").append(j).append("')");
						
						insertSql = buffer.toString();
						baseJdbc.update(insertSql);
						
						phTable.nextRow();
					}
				
				}
				
			}
			
		}
		
		
	}
	public void getSAPData(String functionname) {

	}

	public String getFunctionname() {
		return functionname;
	}

	public void setFunctionname(String functionname) {
		this.functionname = functionname;
	}

}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      