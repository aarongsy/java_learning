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
	log.writeLog("QK_COPY_FPGL");
	JSONObject jsonResult = new JSONObject();
	JSONArray jsonArr = new JSONArray();
	try {
		String yddzddh = request.getParameter("yddzddh");
		
		//主表字段
		String cysbh = "";//承运商编号
		String sm = "";//税码

		//明细表2的字段
		String handingplancode = "";//装卸计划号
		String costtype = "";//费用类型
		String carriername = "";//承运商名称
		String transdate = "";//运输日期
		String cartype = "";//车型
		String platenum = "";//车牌
		String weight = "";//重量
		String location = "";//客户地址
		String plannotaxacount = "";//暂估不含税金额
		String billingmode = "";//计费模式
		String itemtype = "";//单据类型
		String zfdx = "";//支付对象（承运商编号）
		String fyzgbz = "";//费用暂估币种
		String hl = "";//汇率
		String djbh = "";//单据编号
		String sappzbh = "";//SAP凭证编号
		String fph = "";//发票号
		String cbzx = "";//成本中心
		
		String ERR_MSG = "";
		String FLAG = "";

		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String currdate = format.format(d);

		String sql = "select t1.*,t2.* from uf_invocemag t1 left join uf_invocemag_dt2 t2 on t1.id = t2.mainid where t1.yddzddh = '"
				+ yddzddh + "'";
		log.writeLog("查询发票表单的sql：" + sql);
		if (rs.executeSql(sql)) {
			while (rs.next()) {
				//获取数据
				handingplancode = Util.null2String(rs.getString("handingplancode"));//装卸计划号
				costtype = Util.null2String(rs.getString("costtype"));//费用类型
				carriername = Util.null2String(rs.getString("carriername"));//承运商名称
				transdate = Util.null2String(rs.getString("transdate"));//运输日期
				cartype = Util.null2String(rs.getString("cartype"));//车型
				platenum = Util.null2String(rs.getString("platenum"));//车牌
				weight = Util.null2String(rs.getString("weight"));//重量
				location = Util.null2String(rs.getString("location"));//客户地址
				plannotaxacount = Util.null2String(rs.getString("plannotaxacount"));//暂估不含税金额
				billingmode = Util.null2String(rs.getString("billingmode"));//计费模式
				itemtype = Util.null2String(rs.getString("itemtype"));//单据类型
				zfdx = Util.null2String(rs.getString("zfdx"));//支付对象（承运商编号）
				fyzgbz = Util.null2String(rs.getString("fyzgbz"));//费用暂估币种
				hl = Util.null2String(rs.getString("hl"));//汇率
				djbh = Util.null2String(rs.getString("djbh"));//单据编号
				sappzbh = Util.null2String(rs.getString("sappzbh"));//SAP凭证编号
				fph = Util.null2String(rs.getString("fph"));//发票号
				cbzx = Util.null2String(rs.getString("cbzx"));//成本中心
				
				cysbh = Util.null2String(rs.getString("cysbh"));//承运商编号
				sm = Util.null2String(rs.getString("sm"));//税码

				//打印log
				log.writeLog("handingplancode:" + handingplancode);//装卸计划号
				log.writeLog("costtype:" + costtype);//费用类型
				log.writeLog("carriername:" + carriername);//承运商名称
				log.writeLog("transdate:" + transdate);//运输日期
				log.writeLog("cartype:" + cartype);//车型
				log.writeLog("platenum:" + platenum);//车牌
				log.writeLog("weight:" + weight);//重量
				log.writeLog("location:" + location);//客户地址
				log.writeLog("plannotaxacount:" + plannotaxacount);//暂估不含税金额
				log.writeLog("billingmode:" + billingmode);//计费模式
				log.writeLog("itemtype:" + itemtype);//单据类型
				log.writeLog("zfdx:" + zfdx);//支付对象（承运商编号）
				log.writeLog("fyzgbz:" + fyzgbz);//费用暂估币种
				log.writeLog("hl:" + hl);//汇率
				log.writeLog("djbh:" + djbh);//单据编号
				log.writeLog("sappzbh:" + sappzbh);//SAP凭证编号
				log.writeLog("fph:" + fph);//发票号

				JSONObject jsonObj1 = new JSONObject();
				jsonObj1.put("jzm", "40");//记账码
				jsonObj1.put("zzkm", "21010999");//总账科目
				jsonObj1.put("sm", "sm");//税码
				jsonObj1.put("handingplancode", handingplancode);//装卸计划号
				jsonObj1.put("costtype", costtype);//费用类型
				jsonObj1.put("carriername", carriername);//承运商名称
				jsonObj1.put("transdate", transdate);//运输日期
				jsonObj1.put("cartype", cartype);//车型
				jsonObj1.put("platenum", platenum);//车牌
				jsonObj1.put("weight", weight);//重量
				jsonObj1.put("location", location);//客户地址
				jsonObj1.put("plannotaxacount", plannotaxacount);//暂估不含税金额
				jsonObj1.put("billingmode", billingmode);//计费模式
				jsonObj1.put("itemtype", itemtype);//单据类型
				jsonObj1.put("zfdx", zfdx);//支付对象（承运商编号）
				jsonObj1.put("fyzgbz", fyzgbz);//费用暂估币种
				jsonObj1.put("hl", hl);//汇率
				jsonObj1.put("djbh", djbh);//单据编号
				jsonObj1.put("sappzbh", sappzbh);//SAP凭证编号
				jsonObj1.put("fph", fph);//发票号
				jsonObj1.put("cbzx", cbzx);//成本中心
				jsonArr.add(jsonObj1);

				//生成一个40记账码，也需要生成一个31记账码，借贷平衡
				JSONObject jsonObj2 = new JSONObject();
				jsonObj2.put("jzm", "31");
				jsonObj2.put("zzkm", cysbh);//总账科目
				jsonObj2.put("sm", "sm");//税码
				jsonObj2.put("handingplancode", handingplancode);//装卸计划号
				jsonObj2.put("costtype", costtype);//费用类型
				jsonObj2.put("carriername", carriername);//承运商名称
				jsonObj2.put("transdate", transdate);//运输日期
				jsonObj2.put("cartype", cartype);//车型
				jsonObj2.put("platenum", platenum);//车牌
				jsonObj2.put("weight", weight);//重量
				jsonObj2.put("location", location);//客户地址
				jsonObj2.put("plannotaxacount", plannotaxacount);//暂估不含税金额
				jsonObj2.put("billingmode", billingmode);//计费模式
				jsonObj2.put("itemtype", itemtype);//单据类型
				jsonObj2.put("zfdx", zfdx);//支付对象（承运商编号）
				jsonObj2.put("fyzgbz", fyzgbz);//费用暂估币种
				jsonObj2.put("hl", hl);//汇率
				jsonObj2.put("djbh", djbh);//单据编号
				jsonObj2.put("sappzbh", sappzbh);//SAP凭证编号
				jsonObj2.put("fph", fph);//发票号
				jsonObj2.put("cbzx", cbzx);//成本中心
				jsonArr.add(jsonObj2);
			}
			FLAG = "X";
		} else {
			ERR_MSG = "复制凭证内容失败！";
			FLAG = "E";
		}
		jsonResult.put("msg", ERR_MSG);
		jsonResult.put("flag", FLAG);
		jsonResult.put("result", jsonArr);
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