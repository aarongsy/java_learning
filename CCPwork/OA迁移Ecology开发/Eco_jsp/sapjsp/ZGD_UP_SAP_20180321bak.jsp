<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.sap.mw.jco.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.JSONObject"%>

<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>

<%
	String djbh = request.getParameter("djbh");//单据编号	
	String zxjhh = Util.null2String(request.getParameter("zxjhh"));//装卸计划号	
	BaseBean log = new BaseBean();
	log.writeLog("进入ZGD_UP_SAP.jsp");
	JCO.Client sapconnection = null;
	JSONObject objectresult = new JSONObject();
	try {

		if ("".equals(djbh) || djbh == null) {
			log.writeLog("没有获取到单据编号，上传失败");
			return;
		}
		log.writeLog("单据编号:" + djbh);

		RecordSet rs = new RecordSet();
		String djlx = "";//单据类型 SO/PO/非sap

		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String currdate = format.format(d);
		
		String nowDate = currdate.substring(0, 4) + "-" + currdate.substring(4, 6) + "-"
				+ currdate.substring(6, 8);
		int index = 0;
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> mainMap = new HashMap<String, String>();
		String sql = " select t1.*,t2.*,t2.notaxamt as money,to_char(sysdate,'yyyyMMdd') today,to_char(sysdate,'MM') curmon from uf_zgfy t1  left join uf_zgfy_dt1 t2 on t1.id = t2.mainid ";
		sql += " where t1.djbh = '" + djbh + "'";
		rs.writeLog("查询sql:" + sql);
		if (rs.execute(sql)) {
			while (rs.next()) {
				if (index == 0) {
					//测试日期只能为20170701~20170831之间
					//mainMap.put("DOC_DATE", "20171201");//凭证日期
					//mainMap.put("PSTNG_DATE", "20171201");//记账日期
					String pzdate=  Util.null2String(rs.getString("creditdate"));
					pzdate = pzdate.replace("-","");
					String today = Util.null2String(rs.getString("today"));
					String curmon = Util.null2String(rs.getString("curmon"));
					mainMap.put("DOC_DATE", pzdate);//凭证日期
					mainMap.put("PSTNG_DATE",today);//记账日期
					
					//测试可先用1010
					mainMap.put("COMP_CODE", Util.null2String(rs.getString("comcode")));//公司代码 
					//mainMap.put("COMP_CODE", "1010");//公司代码 
					//测试可先用RMB	
					mainMap.put("CURRENCY", Util.null2String(rs.getString("currency")));//货币马
					//mainMap.put("CURRENCY", "RMB");//货币马
					//测试可以默认为1
					mainMap.put("EXCHNG_RATE", Util.null2String(rs.getString("hl")));//汇率
					djlx = Util.null2String(rs.getString("djlx"));//单据类型
					mainMap.put("DOC_TYPE", "SA");//凭证类型
					mainMap.put("REF_DOC_NO", "");//参考凭证号
					mainMap.put("HEADER_TXT", "测试上抛");//凭证抬头文本
					//mainMap.put("PSTNG_PERIOD", "12");//记账期间
					mainMap.put("PSTNG_PERIOD", curmon);//记账期间
					mainMap.put("USER_NAME", "USERS");//用户名
					mainMap.put("RUN_MODE", "N");//调试模式	默认N		A为调试模式
					//每次不同返回的凭证号就会不同,测试使用时间戳
					String time = System.currentTimeMillis() + "";
					//mainMap.put("NOTESID", time);//NOTESID 
					mainMap.put("NOTESID", djbh);//NOTESID

				}
				Map<String, String> map = new HashMap<String, String>();
				map.put("PSTNG_CODE", Util.null2String(rs.getString("jzdm")));//记帐代码
				map.put("GL_ACCOUNT", Util.null2String(rs.getString("account")));//科目
				map.put("MONEY", Util.null2String(rs.getString("money")));//未税金额
				map.put("TAX_CODE", Util.null2String(rs.getString("taxcode")));//销售税代码
				map.put("COST_CENTER", Util.null2String(rs.getString("costcenter")));//成本中心
				String orderno = Util.null2String(rs.getString("pono"));
				String orderitem = Util.null2String(rs.getString("orderitem"));
				
				if ("0".equals(djlx)) {//so 上传销售
					//map.put("SO_NO", Util.null2String(rs.getString("pono")));//采购订单号
					//map.put("SO_ITEM", Util.null2String(rs.getString("orderitem")));//采购订单项次
					
					map.put("SO_NO", orderno);//销售订单号
					//map.put("SO_ITEM", Util.null2String(rs.getString("orderitem")));//销售订单项次	
					if ( !"".equals(orderitem) ) {
						orderitem = orderitem.substring(orderitem.length()-5);
					}
					log.writeLog("orderno="+ orderno +"  orderitem="+orderitem);					
					map.put("SO_ITEM", orderitem);//销售订单项次
					map.put("PO_NO", "");//采购订单号
					map.put("PO_ITEM", "");//采购项次
				} else if ("1".equals(djlx)) {//po 上传采购
					map.put("PO_NO", Util.null2String(rs.getString("pono")));//采购订单号
					map.put("PO_ITEM", Util.null2String(rs.getString("orderitem")));//采购订单项次
					map.put("SO_NO", "");//销售订单号
					map.put("SO_ITEM", "");//销售订单项次
				} else {
					//TODO
				}
				
				map.put("ITEM_TEXT", Util.null2String(rs.getString("itemtext")));//项目文本				
				//map.put("MATERIAL", Util.null2String(rs.getString("wlh")));//物料号 2017-12-17 xxy 注释
				//map.put("PLAN_DATE", Util.null2String(rs.getString("ysrq")));//运输日期	

				//TODO
				map.put("BANK_TYPE", "");//合作银行类型
				map.put("BANK_NAME", "");//开户银行的简要键
				map.put("PAY_LOCK", "");//冻结付款
				map.put("ORDER_ID", "");//内部订单
				map.put("PAY_DATE", "");//到期日
				map.put("PAY_TERMS", "");//付款条款
				map.put("PAY_WAY", "");//付款方式
				map.put("PAY_REF", "");//付款参考
				map.put("ASSGN_NUM", "");//分配
				map.put("TRANS_TYPE", "");//事务类型
				map.put("SGL_FLAG", "");//特殊总账标记
				map.put("PAY_CUR", "");//支付货币
				map.put("PAY_MONEY", "");//支付货币金额
				map.put("PLAN_DATE", "");//计划日期
				map.put("PROFIT_CENTER", "");//利润中心

				list.add(map);
				index++;				
			}			
		} else {
			log.writeLog("查询数据失败！");
			return;
		}		
		//打印log
		log.writeLog("遍历主表");
		for (String k : mainMap.keySet()) {
			log.writeLog(k + " = " + mainMap.get(k));
		}

		//打印log
		log.writeLog("遍历明细");
		for (Map<String, String> m : list) {
			log.writeLog("--------------");
			for (String k : m.keySet()) {
				log.writeLog(k + " = " + m.get(k));
			}
		}

		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		String sources = "1";//默认值



		SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
		sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
		rs2.writeLog("创建SAP连接");
		String strFunc = "ZOA_FI_DOC_CREATE";
		JCO.Function function = null;
		try {
			JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
			IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
			function = ft.getFunction();
		} catch (Exception e) {
			log.writeLog(e);
			e.printStackTrace();
		}

		log.writeLog("测试");
		if (function == null) {
			log.writeLog("链接SAP失败");
			return;
		}

		function.getImportParameterList().setValue(mainMap.get("DOC_DATE"), "DOC_DATE");//记账日期
		log.writeLog("DOC_DATE="+mainMap.get("DOC_DATE"));
		function.getImportParameterList().setValue(mainMap.get("PSTNG_DATE"), "PSTNG_DATE");//凭证日期
		log.writeLog("PSTNG_DATE="+mainMap.get("PSTNG_DATE"));
		function.getImportParameterList().setValue(mainMap.get("DOC_TYPE"), "DOC_TYPE");//凭证类型
		log.writeLog("DOC_TYPE="+mainMap.get("DOC_TYPE"));
		function.getImportParameterList().setValue(mainMap.get("COMP_CODE"), "COMP_CODE");//公司代码
		log.writeLog("COMP_CODE="+mainMap.get("COMP_CODE"));
		function.getImportParameterList().setValue(mainMap.get("CURRENCY"), "CURRENCY");//货币码	
		log.writeLog("CURRENCY="+mainMap.get("CURRENCY"));
		function.getImportParameterList().setValue(mainMap.get("EXCHNG_RATE"), "EXCHNG_RATE");//汇率
		log.writeLog("EXCHNG_RATE="+mainMap.get("EXCHNG_RATE"));
		function.getImportParameterList().setValue(mainMap.get("PSTNG_PERIOD"), "PSTNG_PERIOD");//记账期间 
		log.writeLog("PSTNG_PERIOD="+mainMap.get("PSTNG_PERIOD"));		
		function.getImportParameterList().setValue(mainMap.get("USER_NAME"), "USER_NAME");
		log.writeLog("USER_NAME="+mainMap.get("USER_NAME"));
		function.getImportParameterList().setValue(mainMap.get("RUN_MODE"), "RUN_MODE");//调试模式	默认N		A为调试模式
		log.writeLog("RUN_MODE="+mainMap.get("RUN_MODE"));
		function.getImportParameterList().setValue(mainMap.get("NOTESID"), "NOTESID");
		log.writeLog("NOTESID="+mainMap.get("NOTESID"));

		log.writeLog("上传参数结束");

		log.writeLog(function.getName().toString());
		JCO.Table inTableParams = function.getTableParameterList().getTable("FI_DOC_ITEMS");
		for (int i = 0; i < list.size(); i++) {
			rs.writeLog("遍历上抛参数");
			inTableParams.appendRow();
			//inTableParams.setValue("123412312", "ORDER_ID");//内部订单
			inTableParams.setValue(list.get(i).get("PSTNG_CODE"), "PSTNG_CODE");
			log.writeLog("PSTNG_CODE="+list.get(i).get("PSTNG_CODE"));
			inTableParams.setValue(list.get(i).get("GL_ACCOUNT"), "GL_ACCOUNT");
			log.writeLog("GL_ACCOUNT="+list.get(i).get("GL_ACCOUNT"));
			inTableParams.setValue(list.get(i).get("MONEY"), "MONEY");
			log.writeLog("MONEY="+list.get(i).get("MONEY"));
			inTableParams.setValue(list.get(i).get("TAX_CODE"), "TAX_CODE");
			log.writeLog("TAX_CODE="+list.get(i).get("TAX_CODE"));
			inTableParams.setValue(list.get(i).get("COST_CENTER"), "COST_CENTER");
			log.writeLog("COST_CENTER="+list.get(i).get("COST_CENTER"));
			inTableParams.setValue(list.get(i).get("SO_NO"), "SO_NO");
			log.writeLog("SO_NO="+list.get(i).get("SO_NO"));
			inTableParams.setValue(list.get(i).get("SO_ITEM"), "SO_ITEM");
			log.writeLog("SO_ITEM="+list.get(i).get("SO_ITEM"));
			inTableParams.setValue(list.get(i).get("PO_NO"), "PO_NO");
			log.writeLog("PO_NO="+list.get(i).get("PO_NO"));
			inTableParams.setValue(list.get(i).get("PO_ITEM"), "PO_ITEM");
			log.writeLog("PO_ITEM="+list.get(i).get("PO_ITEM"));
			inTableParams.setValue(list.get(i).get("ITEM_TEXT"), "ITEM_TEXT");
			log.writeLog("ITEM_TEXT="+list.get(i).get("ITEM_TEXT"));
			inTableParams.setValue(list.get(i).get("MATERIAL"), "MATERIAL");
			log.writeLog("MATERIAL="+list.get(i).get("MATERIAL"));

			// 			//inTableParams.setValue("123412312", "ORDER_ID");//内部订单
			// 			inTableParams.setValue("40", "PSTNG_CODE");
			// 			inTableParams.setValue("55060600", "GL_ACCOUNT");
			// 			inTableParams.setValue("100", "MONEY");
			// 			//inTableParams.setValue(list.get(i).get("TAX_CODE"), "TAX_CODE");
			// 			inTableParams.setValue("0010101100", "COST_CENTER");
			// 			//inTableParams.setValue(list.get(i).get("SO_NO"), "SO_NO");
			// 			//inTableParams.setValue(list.get(i).get("SO_ITEM"), "SO_ITEM");
			// 			//inTableParams.setValue(list.get(i).get("PO_NO"), "PO_NO");
			// 			//inTableParams.setValue(list.get(i).get("SO_ITEM"), "SO_ITEM");
			// 			//inTableParams.setValue(list.get(i).get("ITEM_TEXT"), "ITEM_TEXT");
			// 			//inTableParams.setValue(list.get(i).get("MATERIAL"), "MATERIAL");
			// 			if(i  == list.size() - 1) {
			// 				//inTableParams.setValue("123412312", "ORDER_ID");//内部订单
			// 				inTableParams.setValue("50", "PSTNG_CODE");
			// 				//inTableParams.setValue("55060600", "GL_ACCOUNT");
			// 				inTableParams.setValue("400", "MONEY");
			// 				//inTableParams.setValue(list.get(i).get("TAX_CODE"), "TAX_CODE");
			// 				inTableParams.setValue("0010101100", "COST_CENTER");
			// 			}
		}

		sapconnection.execute(function);
		log.writeLog("执行function上传sap数据");
		String FLAG = function.getExportParameterList().getValue("FLAG").toString().trim();
		String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		if ("X".equals(FLAG) && !"".equals(zxjhh)) {
			String updateSql = "";
			if ("0".equals(djlx)) {
				updateSql = "update formtable_main_45 set sfsp = '1' where zxjhh ='" + zxjhh + "'";
			} else if ("1".equals(djlx)) {
				updateSql = "update formtable_main_61 set sfsp = '1' where zxjhh ='" + zxjhh + "'";
			}
			log.writeLog(updateSql);
			rs.execute(updateSql);
		}
		// 获取数据
		log.writeLog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		log.writeLog("FLAG: " + FLAG);
		log.writeLog("AC_DOC_NO: " + AC_DOC_NO);
		log.writeLog("ERR_MSG: " + ERR_MSG);
		log.writeLog("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
		String updateSql = "update uf_zgfy set sappzh = '" + AC_DOC_NO + "',message = '" + ERR_MSG
				+ "',msgty = '" + FLAG + "',gzrq='" + nowDate + "', creditmonth='"
				+ currdate.substring(4, 6)+"'";
		if ("X".equals(FLAG) && !"".equals(AC_DOC_NO)) {
			updateSql = updateSql + ",djstatus = '1'";
        }
		updateSql= updateSql+ " where djbh = '" + djbh + "'";
		if (!rs.execute(updateSql)) {
			log.writeLog("更新sap凭证号错误!updateSql="+updateSql);
		}
		objectresult.put("msg", ERR_MSG);
		objectresult.put("acdocno", AC_DOC_NO);
		objectresult.put("flag", FLAG);
	} catch (Exception e) {
		// TODO: handle exception
		objectresult.put("flag", "E");
		out.write("fail" + e);
		e.printStackTrace();

	}
	
	response.getWriter().write(objectresult.toString());
	//System.out.println(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>


