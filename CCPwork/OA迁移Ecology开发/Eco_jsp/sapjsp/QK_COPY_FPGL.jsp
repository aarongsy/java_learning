<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.interfaces.workflow.action.CCPUtil.CalUtil" %>
<%@ page import="weaver.interfaces.workflow.action.CCPUtil.DCCMUtil" %>

<%
	RecordSet rs = new RecordSet();
	BaseBean log = new BaseBean();
	log.writeLog("QK_COPY_FPGL");
	JSONObject jsonResult = new JSONObject();
	JSONArray jsonArr = new JSONArray();
	CalUtil calUtil=new CalUtil();
	try {
		String yddzddh = request.getParameter("yddzddh");

		String fqhJson=request.getParameter("fphJson");
		//log.writeLog("获得fqhjson："+fqhJson);
		JSONObject jsonObject=JSONObject.fromObject(fqhJson);
		log.writeLog("获得fphjson数据："+jsonObject);

		String fqhJson2=request.getParameter("fphJson2");
		//log.writeLog("获得fqhjson："+fqhJson);
		JSONObject jsonObject2=JSONObject.fromObject(fqhJson2);
		log.writeLog("获得fphjson2数据："+jsonObject2);

		String fkJson=request.getParameter("fkJson");
		log.writeLog("获得fkjson："+fkJson);
		JSONObject jsonObject1=JSONObject.fromObject(fkJson);
		log.writeLog("获得fkjson数据："+jsonObject1);



		//主表字段
		String fkfs=jsonObject1.getString("fkfs");//付款方式
		String fktkdm=jsonObject1.getString("fktkdm");//付款条款代码
		String hzyhlx=jsonObject1.getString("hzyhlx");//合作银行类型
		String fkjzrq=jsonObject1.getString("fkjzrq");//付款基准日期

		//String zfbh=jsonObject2.getString("sjzfhb");//实际支付货币

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
		String zzkm = "";//供应商简码
		String fpse = "";//税金
		Double zje = 0.00;//总金额
		String MARK = "";//MARK标识符
		
		String ERR_MSG = "";
		String FLAG = "";

		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String currdate = format.format(d);

		String sql = "select DISTINCT(HANDINGPLANCODE),(SELECT concode from uf_dmlo_consolidat where id = T.cysbh) as zzkm,t1.fpse,t.*,t2.* from uf_invocemag t left join uf_invocemag_dt2 t2 on t.id = t2.mainid LEFT JOIN uf_invocemag_dt1 t1 on t1.fphm=t2.fph where t.yddzddh ='"
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
				zzkm = Util.null2String(rs.getString("zzkm"));//供应商简码
				fpse = Util.null2String(rs.getString("fpse"));//税金
				zje =Util.getDoubleValue(rs.getString("plannotaxacount"));//暂估不含税金额

				//打印log
				log.writeLog("handingplancode:" + handingplancode);//装卸计划号
				log.writeLog("zzkm:" + zzkm);//供应商简码
				log.writeLog("fpse:" + fpse);//税金
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
				jsonObj1.put("zzkm", "0021810999");//总账科目
				jsonObj1.put("sm", sm);//税码
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
				jsonObj1.put("fpse", "");//税金
				jsonObj1.put("MARK", "");//MARK标识符
				jsonObj1.put("zfhbje","");//支付货币金额
				jsonArr.add(jsonObj1);

				//判断是否有税金
				if(!"".equals(fpse)&&(Double.parseDouble(fpse)>0)) {
					JSONObject jsonObj2 = new JSONObject();
					jsonObj2.put("jzm", "40");//记账码
					jsonObj2.put("zzkm", "0021710101");//总账科目
					jsonObj2.put("sm", sm);//税码
					jsonObj2.put("handingplancode", handingplancode);//装卸计划号
					jsonObj2.put("costtype", costtype);//费用类型
					jsonObj2.put("carriername", carriername);//承运商名称
					jsonObj2.put("transdate", transdate);//运输日期
					jsonObj2.put("cartype", cartype);//车型
					jsonObj2.put("platenum", platenum);//车牌
					jsonObj2.put("weight", weight);//重量
					jsonObj2.put("location", location);//客户地址
					jsonObj2.put("plannotaxacount", fpse);//暂估不含税金额
					jsonObj2.put("billingmode", billingmode);//计费模式
					jsonObj2.put("itemtype", itemtype);//单据类型
					jsonObj2.put("zfdx", zfdx);//支付对象（承运商编号）
					jsonObj2.put("fyzgbz", fyzgbz);//费用暂估币种
					jsonObj2.put("hl", hl);//汇率
					jsonObj2.put("djbh", djbh);//单据编号
					jsonObj2.put("sappzbh", sappzbh);//SAP凭证编号
					jsonObj2.put("fph", fph);//发票号
					jsonObj2.put("cbzx", cbzx);//成本中心
					jsonObj2.put("fpse", plannotaxacount);//税金
					jsonObj2.put("MARK", "T");//MARK标识符
					jsonObj2.put("zfhbje","");//支付货币金额

					//zje = parseFloat(plannotaxacount) + parseFloat(fpse);
					zje = calUtil.add(Double.parseDouble(plannotaxacount),Double.parseDouble(fpse));
					jsonArr.add(jsonObj2);
				}
				

				//生成一个40记账码，也需要生成一个31记账码，借贷平衡
				JSONObject jsonObj3 = new JSONObject();
				jsonObj3.put("jzm", "31");
				jsonObj3.put("zzkm", zzkm);//总账科目
				jsonObj3.put("sm", sm);//税码
				jsonObj3.put("handingplancode", handingplancode);//装卸计划号
				jsonObj3.put("costtype", costtype);//费用类型
				jsonObj3.put("carriername", carriername);//承运商名称
				jsonObj3.put("transdate", transdate);//运输日期
				jsonObj3.put("cartype", cartype);//车型
				jsonObj3.put("platenum", platenum);//车牌
				jsonObj3.put("weight", weight);//重量
				jsonObj3.put("location", location);//客户地址
				jsonObj3.put("plannotaxacount", zje);//暂估含税金额
				jsonObj3.put("billingmode", billingmode);//计费模式
				jsonObj3.put("itemtype", itemtype);//单据类型
				jsonObj3.put("zfdx", zfdx);//支付对象（承运商编号）
				jsonObj3.put("fyzgbz", fyzgbz);//费用暂估币种
				jsonObj3.put("hl", hl);//汇率
				jsonObj3.put("djbh", djbh);//单据编号
				jsonObj3.put("sappzbh", sappzbh);//SAP凭证编号
				jsonObj3.put("fph", fph);//发票号
				jsonObj3.put("cbzx", cbzx);//成本中心
				jsonObj3.put("fpse", "");//税金
				jsonObj3.put("MARK", "K");//MARK标识符
				log.writeLog("支付货币金额："+jsonObject.get(fph));
				jsonObj3.put("zfhbje",jsonObject.get(fph));//支付货币金额

				jsonObj3.put("fkfs", fkfs);//付款方式
				jsonObj3.put("fktkdm", fktkdm);//付款条款代码
				jsonObj3.put("hzyhlx", hzyhlx);//合作银行类型
				jsonObj3.put("fkjzrq", fkjzrq);//付款基准日期

				jsonObj3.put("zfhb", jsonObject2.get(fph));//支付货币


				jsonArr.add(jsonObj3);
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
	log.writeLog(jsonResult.toString());
	response.getWriter().write(jsonResult.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>