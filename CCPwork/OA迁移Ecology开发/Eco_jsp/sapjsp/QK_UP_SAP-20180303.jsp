<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl;"%>

<%
	RecordSet rs = new RecordSet();
	BaseBean log = new BaseBean();
	log.writeLog("进入QK_UP_SAP.jsp");
	JCO.Client sapconnection = null;
	JSONObject jsonResult = new JSONObject();
	JSONArray jsonArr = new JSONArray();
	try {
		String yddzd = request.getParameter("yddzd");//月度对账单	
		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String currdate = format.format(d);

		//sap清帐主表数据
		String DOC_DATE = "";//凭证日期
		String PSTNG_DATE = currdate;//记账日期 当前日期
		String VATDATE = currdate;//TAX REPORTING DATE
		String DOC_TYPE = "";//凭证类型
		String COMP_CODE = "";//公司代码		
		String CURRENCY = "";//货币代码
		String EXCHNG_RATE = "";//汇率
		//String NOTESID = Util.null2String(request.getParameter("NOTESID"));//NOTESID
		String REF_DOC_NO = "";//参考凭证号
		String HEADER_TXT = "";//凭证抬头文本
		String PSTNG_PERIOD = currdate.substring(4, 6);//记账期间
		String USER_NAME = "";//用户名
		String NOTESID = System.currentTimeMillis() + "";
		String OA_TYPE = "";//EX代表出口，IM代表进口

		String RUN_MODE = "N";//调试模式	默认N		调试模式A

		String ERR_MSG = "";
		String FLAG = "";

		String sql = "select t1.*,t2.* from uf_qkqz t1 left join uf_qkqz_dt2 on t1.id = t2.mainid where t1.yddzd = '"
				+ yddzd + "'";
		rs.executeSql(sql);
		if (rs.next()) {
			COMP_CODE = Util.null2String(rs.getString("comcode"));//公司代码
			DOC_DATE = Util.null2String(rs.getString("pzrq"));//凭证日期
			DOC_TYPE = Util.null2String(rs.getString("pzlx"));//凭证类型
			PSTNG_DATE = Util.null2String(rs.getString("jzrq"));//凭证类型
			VATDATE = PSTNG_DATE;
			CURRENCY = Util.null2String(rs.getString("hbdm"));//货币代码
			REF_DOC_NO = Util.null2String(rs.getString("cz"));//参考凭证号
			HEADER_TXT = Util.null2String(rs.getString("pztt"));//凭证抬头文本
		}
		String[] columns = { "je", "fph" };
		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		List<Map<String, String>> list1 = new ArrayList<Map<String, String>>();
		List<Map<String, String>> list2 = new ArrayList<Map<String, String>>();

		String checkSql1 = "select sum(t2.je) as je,t2.fph from uf_qkqz t1 left join uf_qkqz_dt2 t2 on t1.id = t2.mainid where t2. jzdm = '40' and t1.yddzd = '"
				+ yddzd + "' group by t2.fph" + "order by t2.fph";
		String checkSql2 = "select sum(t2.je) as je,t2.fph from uf_qkqz t1 left join uf_qkqz_dt2 t2 on t1.id = t2.mainid where t2. jzdm != '40' and t1.yddzd = '"
				+ yddzd + "' group by t2.fph" + "order by t2.fph";

		int k;
		while (rs1.next()) {
			Map<String, String> map = new HashMap<String, String>();
			for (k = 0; k < columns.length; k++) {
				map.put(columns[k], rs1.getString(columns[k]));
			}
			list1.add(map);
		}

		while (rs2.next()) {
			Map<String, String> map = new HashMap<String, String>();
			for (k = 0; k < columns.length; k++) {
				map.put(columns[k], rs2.getString(columns[k]));
			}
			list2.add(map);
		}
		if (list1.size() == list2.size()) {
			boolean flag = true;
			for (int index = 0; index < list1.size(); index++) {
				if (list1.get(index).get("fph") == list2.get(index).get("fph")
						&& list1.get(index).get("je") == list2.get(index).get("je")) {
					continue;
				} else {
					flag = false;
				}
				if (!flag) {
					jsonResult.put("FLAG", "E");
					jsonResult.put("ERR_MSG", "发票号：" + list1.get(index).get("fph") + "借贷不平，请重新填写提交");
					response.getWriter().write(jsonResult.toString());
					response.getWriter().flush();
					response.getWriter().close();
					return;
				}

			}
		}

		String sources = "1";
		SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
		sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
		log.writeLog("创建SAP连接");
		String strFunc = "ZOA_FI_CDOC_CREATE";
		JCO.Function function = null;
		JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
		IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
		function = ft.getFunction();

		if (function == null) {
			log.writeLog("链接SAP失败");
			return;
		}

		log.writeLog("打印主表log");

		function.getImportParameterList().setValue(COMP_CODE, "COMP_CODE");//公司代码		
		log.writeLog("COMP_CODE=" + COMP_CODE);
		function.getImportParameterList().setValue(PSTNG_DATE, "PSTNG_DATE");//记账日期
		log.writeLog("PSTNG_DATE=" + PSTNG_DATE);
		function.getImportParameterList().setValue(DOC_TYPE, "DOC_TYPE");//凭证类型
		log.writeLog("DOC_TYPE=" + DOC_TYPE);
		function.getImportParameterList().setValue(DOC_DATE, "DOC_DATE");//凭证日期
		log.writeLog("DOC_DATE=" + DOC_DATE);
		function.getImportParameterList().setValue(CURRENCY, "CURRENCY");//货币代码
		log.writeLog("CURRENCY=" + CURRENCY);
		function.getImportParameterList().setValue(EXCHNG_RATE, "EXCHNG_RATE");//汇率
		log.writeLog("EXCHNG_RATE=" + EXCHNG_RATE);
		function.getImportParameterList().setValue(REF_DOC_NO, "REF_DOC_NO");//参考凭证号		
		log.writeLog("REF_DOC_NO=" + REF_DOC_NO);
		function.getImportParameterList().setValue(HEADER_TXT, "HEADER_TXT");//凭证抬头文本
		log.writeLog("HEADER_TXT=" + HEADER_TXT);
		function.getImportParameterList().setValue(PSTNG_PERIOD, "PSTNG_PERIOD");//记账期间
		log.writeLog("PSTNG_PERIOD=" + PSTNG_PERIOD);
		function.getImportParameterList().setValue(USER_NAME, "USER_NAME");//用户名
		log.writeLog("USER_NAME=" + USER_NAME);
		function.getImportParameterList().setValue(RUN_MODE, "RUN_MODE");//调试模式
		log.writeLog("RUN_MODE=" + RUN_MODE);
		function.getImportParameterList().setValue(NOTESID, "NOTESID");//NOTESID\
		log.writeLog("NOTESID=" + NOTESID);

		log.writeLog("参数表1打印log");
		for (Map<String, String> m : list1) {
			for (String t : m.keySet()) {
				log.writeLog(t + " = " + m.get(t));
			}
		}
		JCO.Table inTableParams1 = function.getTableParameterList().getTable("FI_DOC_CLEAR");
		for (int i = 0; i < list1.size(); i++) {

			inTableParams1.appendRow();
			inTableParams1.setValue(list1.get(i).get("VC_FLAG"), "VC_FLAG");//供应商客户标识
			inTableParams1.setValue(list1.get(i).get("VC_NO"), "VC_NO");//供应商或客户编号
			inTableParams1.setValue(list1.get(i).get("SGL_FLAG"), "SGL_FLAG");//特殊总账标识
			inTableParams1.setValue(list1.get(i).get("DOC_NO"), "DOC_NO");//需清帐凭证编号

			inTableParams1.setValue(list1.get(i).get("DOC_YEAR"), "DOC_YEAR");//会计年度
			inTableParams1.setValue(list1.get(i).get("DOC_ITEM"), "DOC_ITEM");//行项目号
			inTableParams1.setValue(list1.get(i).get("CL_MONEY"), "CL_MONEY");//清帐金额
			inTableParams1.setValue(list1.get(i).get("CL_TEXT"), "CL_TEXT");//清障文本
		}

		// 		log.writeLog("参数表2打印log");
		// 		for (Map<String, String> m : list2) {
		// 			for (String k : m.keySet()) {
		// 				rs.writeLog(k + " = " + m.get(k));
		// 			}
		// 		}
		JCO.Table inTableParams2 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
		for (int i = 0; i < list2.size(); i++) {
			log.writeLog("参数表2打印log");
			inTableParams2.appendRow();
			inTableParams2.setValue(list2.get(i).get("PSTNG_CODE"), "PSTNG_CODE");//记账码
			log.writeLog("PSTNG_CODE=" + list2.get(i).get("PSTNG_CODE"));
			inTableParams2.setValue(list2.get(i).get("GL_ACCOUNT"), "GL_ACCOUNT");//总账科目
			log.writeLog("GL_ACCOUNT=" + list2.get(i).get("GL_ACCOUNT"));
			inTableParams2.setValue(list2.get(i).get("MONEY"), "MONEY");//金额
			log.writeLog("MONEY=" + list2.get(i).get("MONEY"));
			inTableParams2.setValue(list2.get(i).get("TAX_CODE"), "TAX_CODE");//税码		
			log.writeLog("TAX_CODE=" + list2.get(i).get("TAX_CODE"));
			inTableParams2.setValue(list2.get(i).get("COST_CENTER"), "COST_CENTER");//成本中心
			log.writeLog("COST_CENTER=" + list2.get(i).get("COST_CENTER"));
			inTableParams2.setValue(list2.get(i).get("NO"), "PO_NO");//订单号  
			log.writeLog("PO_NO=" + list2.get(i).get("NO"));
			inTableParams2.setValue(list2.get(i).get("ITEM"), "PO_ITEM");//订单项次
			log.writeLog("PO_ITEM=" + list2.get(i).get("ITEM"));
			inTableParams2.setValue(list2.get(i).get("ITEM_TEXT"), "ITEM_TEXT");//行项目文本		
			log.writeLog("ITEM_TEXT=" + list2.get(i).get("ITEM_TEXT"));
			inTableParams2.setValue(list2.get(i).get("BANK_TYPE"), "BANK_TYPE");//合作银行类型
			log.writeLog("BANK_TYPE=" + list2.get(i).get("BANK_TYPE"));
			inTableParams2.setValue(list2.get(i).get("PAY_LOCK"), "PAY_LOCK");//冻结付款
			log.writeLog("PAY_LOCK=" + list2.get(i).get("PAY_LOCK"));
			inTableParams2.setValue(list2.get(i).get("PAY_TERMS"), "PAY_TERMS");//付款条款   
			log.writeLog("PAY_TERMS=" + list2.get(i).get("PAY_TERMS"));
			inTableParams2.setValue(list2.get(i).get("PAY_WAY"), "PAY_WAY");//付款方式		
			log.writeLog("PAY_WAY=" + list2.get(i).get("PAY_WAY"));
			inTableParams2.setValue(list2.get(i).get("PAY_DATE"), "PAY_DATE");//到期日
			log.writeLog("PAY_DATE=" + list2.get(i).get("PAY_DATE"));
			inTableParams2.setValue(list2.get(i).get("PAY_CUR"), "PAY_CUR");//支付货币
			log.writeLog("PAY_CUR=" + list2.get(i).get("PAY_CUR"));
			inTableParams2.setValue(list2.get(i).get("PAY_MONEY"), "PAY_MONEY");//支付金额
			log.writeLog("PAY_MONEY=" + list2.get(i).get("PAY_MONEY"));
			inTableParams2.setValue(list2.get(i).get("MATERIAL"), "MATERIAL");//物理号
			log.writeLog("MATERIAL=" + list2.get(i).get("MATERIAL"));
		}

		log.writeLog("执行function上传sap数据");
		sapconnection.execute(function);

		// 获取数据
		log.writeLog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		log.writeLog("FLAG: " + FLAG);
		log.writeLog("ERR_MSG: " + ERR_MSG);

		log.writeLog("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
		jsonResult.put("FLAG", FLAG);
		jsonResult.put("ERR_MSG", ERR_MSG);
	} catch (Exception e) {
		// TODO: handle exception
		jsonResult.put("flag", "E");
		out.write("fail" + e);
		e.printStackTrace();
	}

	response.getWriter().write(jsonResult.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>