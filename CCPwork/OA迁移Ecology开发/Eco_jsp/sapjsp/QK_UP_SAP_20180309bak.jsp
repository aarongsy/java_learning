<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>
<%@ page import="java.net.URI" %>
<%@ page import="weaver.interfaces.workflow.action.CCPUtil.CalUtil" %>
<%@ page import="weaver.interfaces.workflow.action.CCPUtil.DCCMUtil" %>
<%@ page import="com.sun.org.apache.bcel.internal.generic.Select" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.util.JSONUtils" %>

<%
	RecordSet rs = new RecordSet();
	BaseBean log = new BaseBean();
	log.writeLog("进入QK_UP_SAP.jsp");
	JCO.Client sapconnection = null;
	JSONObject jsonResult = new JSONObject();
	JSONArray jsonArr = new JSONArray();
	try {
		String yddzd = request.getParameter("yddzd");//月度对账单
		String sqbh = request.getParameter("sqbh");//申请编号

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

		String sql = "select COMCODE,T1.pzrq,PZLX,T1.JZRQ,HBDM,CZ,PZTT from uf_qkqz t1 left join uf_qkqz_dt2 t2 on t1.id = t2.mainid where t1.yddzd = '"
				+ yddzd + "'";
		log.writeLog(sql);
		rs.executeSql(sql);
		if (rs.next()) {
			COMP_CODE = Util.null2String(rs.getString("comcode"));//公司代码
			DOC_DATE = Util.null2String(rs.getString("pzrq"));//凭证日期
			DOC_TYPE = Util.null2String(rs.getString("pzlx"));//凭证类型
			PSTNG_DATE = Util.null2String(rs.getString("jzrq"));//记账日期
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
				+ yddzd + "' group by t2.fph" + " order by t2.fph";
		String checkSql2 = "select sum(t2.je) as je,t2.fph from uf_qkqz t1 left join uf_qkqz_dt2 t2 on t1.id = t2.mainid where t2. jzdm != '40' and t1.yddzd = '"
				+ yddzd + "' group by t2.fph" + " order by t2.fph";

		int k;
		rs1.writeLog(checkSql1);
		rs1.execute(checkSql1);
		while (rs1.next()) {
			Map<String, String> map = new HashMap<String, String>();
			for (k = 0; k < columns.length; k++) {
				map.put(columns[k], rs1.getString(columns[k]));
			}
			list1.add(map);
		}
		rs2.writeLog(checkSql2);
		rs2.execute(checkSql2);
		while (rs2.next()) {
			Map<String, String> map = new HashMap<String, String>();
			for (k = 0; k < columns.length; k++) {
				map.put(columns[k], rs2.getString(columns[k]));
			}
			list2.add(map);
		}
		//打印list
		DCCMUtil dccmUtil=new DCCMUtil();
		log.writeLog("打印list1：");
		dccmUtil.printMapList(list1);
		log.writeLog("打印list2：");
		dccmUtil.printMapList(list2);

		StringBuffer sqllist=new StringBuffer()
				.append("select t2.* from uf_qkqz t1,uf_qkqz_dt2 t2 ")
				.append("where t1.id=t2.mainid and t1.zt!='5' and t1.yddzd='"+yddzd+"'");
		StringBuffer headerSql = new StringBuffer().append("select * from uf_qkqz where zt!='5' and yddzd='" + yddzd + "'");

		//String DOC_DATE="";//凭证日期
		//String PSTNG_DATE="";//记帐日期
		//String VATDATE="";//Tax Reporting Date
		//String DOC_TYPE="";//凭证类型
		//String COMP_CODE="";//公司代码
		//String CURRENCY="";//货币代码
		//String EXCHNG_RATE="";//汇率
		//String REF_DOC_NO="";//参考凭证号
		//String HEADER_TXT="";//凭证抬头文本
		//String PSTNG_PERIOD="";//记账期间
		//String USER_NAME="";//用户名
		//String NOTESID="";//NOTESID
		//String OA_TYPE="";//EX代表出口，IM代表进口
		//IF_DOC_ITEMS;
		//String DOC_DATE="";//凭证日期
		//String PSTNG_DATE="";//记帐日期
		//String VATDATE="";//Tax Reporting Date
		//String ZOANO="";//装卸计划号码
		String ZOA_DOC_NO="";//暂估号码
		//String REF_DOC_NO="";//发票号
		//String HEADER_TXT="";//凭证抬头文本
		String PSTNG_CODE="";//记账码
		String GL_ACCOUNT="";//总账科目
		String MONEY="";//金额
		String TAX_CODE="";//税码
		String TAX_BASE="";//税金基值
		String COST_CENTER="";//成本中心
		String PO_NO="";//采购订单编号
		String PO_ITEM="";//采购订单行项目号
		String SO_NO="";//销售订单编号
		String SO_ITEM="";//销售订单行项目号
		String ITEM_TEXT="";//行项目文本
		String BANK_TYPE="";//合作银行类型
		String BANK_NAME="";//开户银行的简要键
		String PAY_LOCK="";//冻结付款
		String ORDER_ID="";//内部订单
		String PAY_DATE="";//基准日期
		String PAY_TERMS="";//付款条款
		String PAY_WAY="";//付款方式
		String PAY_REF="";//付款参考
		String ASSGN_NUM="";//分配
		String TRANS_TYPE="";//事务类型
		String SGL_FLAG="";//特殊总账标记
		String PAY_CUR="";//支付货币
		String PAY_MONEY="";//支付货币金额
		String PLAN_DATE="";//计划日期
		String PROFIT_CENTER="";//利润中心
		String MATERIAL="";//物料
		String MARK="";//K表示供应商行，T表示税金行
		String QUANTITY="";//数量
		String BASE_UOM="";//基本计量单位
		//ITEMS_LOG;
		//String REF_DOC_NO="";//发票号
		String ZOANO="";//装卸计划号码
		//String ZOA_DOC_NO="";//暂估号码
		//String HEADER_TXT="";//凭证抬头文本
		//String FLAG="";//成功标志
		String AC_DOC_NO="";//财务凭证编号
		//String ERR_MSG="";//错误信息
		JSONObject headers=new JSONObject();
		rs.writeLog(headerSql.toString());
		rs.execute(headerSql.toString());
		if (rs.next()){
			//DOC_DATE=Util.null2String(rs.getString("pzrq"));//凭证日期
			//PSTNG_DATE=Util.null2String(rs.getString("jzrq"));//记帐日期
			VATDATE=Util.null2String(rs.getString("qzrq"));//Tax Reporting Date
			//DOC_TYPE=Util.null2String(rs.getString(""));//凭证类型
			//COMP_CODE=Util.null2String(rs.getString(""));//公司代码
			CURRENCY=Util.null2String(rs.getString("hbdm"));//货币代码
			EXCHNG_RATE=Util.null2String(rs.getString("hl"));//汇率
			REF_DOC_NO=Util.null2String(rs.getString("cz"));//参考凭证号
			HEADER_TXT=Util.null2String(rs.getString("pztt"));//凭证抬头文本
			PSTNG_PERIOD=Util.null2String(rs.getString("jzm"));//计账码
			USER_NAME=Util.null2String(rs.getString("fhm"));//用户名
			NOTESID=Util.null2String(rs.getString(""));//NOTESID
			OA_TYPE=Util.null2String(rs.getString(""));//EX代表出口，IM代表进口

			headers.put("DOC_DATE",getSapChange(DOC_DATE));//凭证日期
			headers.put("PSTNG_DATE",getSapChange(PSTNG_DATE));//记帐日期
			headers.put("VATDATE",getSapChange(PSTNG_DATE));//Tax Reporting Date
			headers.put("DOC_TYPE",DOC_TYPE);//凭证类型
			headers.put("COMP_CODE",COMP_CODE);//公司代码
			headers.put("CURRENCY",CURRENCY);//货币代码
			headers.put("EXCHNG_RATE",EXCHNG_RATE);//汇率
			headers.put("REF_DOC_NO",REF_DOC_NO);//参考凭证号
			headers.put("HEADER_TXT",HEADER_TXT);//凭证抬头文本
			headers.put("PSTNG_PERIOD",getSapChange(PSTNG_PERIOD));//记账期间
			headers.put("USER_NAME",USER_NAME);//用户名
			headers.put("NOTESID",NOTESID);//NOTESID
			headers.put("OA_TYPE",OA_TYPE);//EX代表出口，IM代表进口
		}
		rs.writeLog("获得header："+headers.toString());

		rs.writeLog(sqllist.toString());
		rs.execute(sqllist.toString());
		JSONArray items=new JSONArray();
		while (rs.next()){
			JSONObject item=new JSONObject();

			//DOC_DATE=Util.null2String(rs.getString(""));//凭证日期
			//PSTNG_DATE=Util.null2String(rs.getString(""));//记帐日期
			//VATDATE=Util.null2String(rs.getString(""));//Tax Reporting Date
			ZOANO=Util.null2String(rs.getString("zxjhh"));//装卸计划号码
			ZOA_DOC_NO=Util.null2String(rs.getString(""));//暂估号码
			REF_DOC_NO=Util.null2String(rs.getString("fph"));//发票号
			//HEADER_TXT=Util.null2String(rs.getString(""));//凭证抬头文本
			PSTNG_CODE=Util.null2String(rs.getString("jzdm"));//记账码
			GL_ACCOUNT=Util.null2String(rs.getString("zzkm"));//总账科目
			MONEY=Util.null2String(rs.getString("je"));//金额
			TAX_CODE=Util.null2String(rs.getString("sm"));//税码
			TAX_BASE=Util.null2String(rs.getString("sjjz"));//税金基值
			COST_CENTER=Util.null2String(rs.getString("cczx"));//成本中心
			PO_NO=Util.null2String(rs.getString("cgddbh"));//采购订单编号
			PO_ITEM=Util.null2String(rs.getString("cgddhxm"));//采购订单行项目号
			SO_NO=Util.null2String(rs.getString("xsddbh"));//销售订单编号
			SO_ITEM=Util.null2String(rs.getString("xsddhxh"));//销售订单行项目号
			ITEM_TEXT=Util.null2String(rs.getString("hxmwb"));//行项目文本
			BANK_TYPE=Util.null2String(rs.getString("hzxhlx"));//合作银行类型
			BANK_NAME=Util.null2String(rs.getString("khtjy"));//开户银行的简要键
			PAY_LOCK=Util.null2String(rs.getString("djfk"));//冻结付款
			ORDER_ID=Util.null2String(rs.getString("lbdd"));//内部订单
			PAY_DATE=Util.null2String(rs.getString("jzrq"));//基准日期
			PAY_TERMS=Util.null2String(rs.getString("fktk"));//付款条款
			PAY_WAY=Util.null2String(rs.getString("fkfs"));//付款方式
			PAY_REF=Util.null2String(rs.getString("fkch"));//付款参考
			ASSGN_NUM=Util.null2String(rs.getString("fp"));//分配
			TRANS_TYPE=Util.null2String(rs.getString("swlx"));//事务类型
			SGL_FLAG=Util.null2String(rs.getString("tszzbj"));//特殊总账标记
			PAY_CUR=Util.null2String(rs.getString("zfhb"));//支付货币
			PAY_MONEY=Util.null2String(rs.getString("zfhbje"));//支付货币金额
			PLAN_DATE=Util.null2String(rs.getString("jhrq"));//计划日期
			PROFIT_CENTER=Util.null2String(rs.getString("lrzx"));//利润中心
			MATERIAL=Util.null2String(rs.getString("wl"));//物料
			MARK=Util.null2String(rs.getString("shsh"));//K表示供应商行，T表示税金行
			QUANTITY=Util.null2String(rs.getString("sl"));//数量
			BASE_UOM=Util.null2String(rs.getString("jbjldw"));//基本计量单位

			item.put("DOC_DATE",getSapChange(DOC_DATE));//凭证日期
			item.put("PSTNG_DATE",getSapChange(PSTNG_DATE));//记帐日期
			item.put("VATDATE",getSapChange(PSTNG_DATE));//Tax Reporting Date
			item.put("ZOANO",ZOANO);//装卸计划号码
			item.put("ZOA_DOC_NO",ZOA_DOC_NO);//暂估号码
			item.put("REF_DOC_NO",REF_DOC_NO);//发票号
			item.put("HEADER_TXT",HEADER_TXT);//凭证抬头文本
			item.put("PSTNG_CODE",PSTNG_CODE);//记账码
			item.put("GL_ACCOUNT",GL_ACCOUNT);//总账科目
			item.put("MONEY",MONEY);//金额
			item.put("TAX_CODE",TAX_CODE);//税码
			item.put("TAX_BASE",TAX_BASE);//税金基值
			item.put("COST_CENTER",COST_CENTER);//成本中心
			item.put("PO_NO",PO_NO);//采购订单编号
			item.put("PO_ITEM",PO_ITEM);//采购订单行项目号
			item.put("SO_NO",SO_NO);//销售订单编号
			item.put("SO_ITEM",SO_ITEM);//销售订单行项目号
			item.put("ITEM_TEXT",ITEM_TEXT);//行项目文本
			item.put("BANK_TYPE",BANK_TYPE);//合作银行类型
			item.put("BANK_NAME",BANK_NAME);//开户银行的简要键
			item.put("PAY_LOCK",PAY_LOCK);//冻结付款
			item.put("ORDER_ID",ORDER_ID);//内部订单
			item.put("PAY_DATE",getSapChange(PAY_DATE));//基准日期
			item.put("PAY_TERMS",PAY_TERMS);//付款条款
			item.put("PAY_WAY",PAY_WAY);//付款方式
			item.put("PAY_REF",PAY_REF);//付款参考
			item.put("ASSGN_NUM",ASSGN_NUM);//分配
			item.put("TRANS_TYPE",TRANS_TYPE);//事务类型
			item.put("SGL_FLAG",SGL_FLAG);//特殊总账标记
			item.put("PAY_CUR",PAY_CUR);//支付货币
			item.put("PAY_MONEY",PAY_MONEY);//支付货币金额
			item.put("PLAN_DATE",getSapChange(PLAN_DATE));//计划日期
			item.put("PROFIT_CENTER",PROFIT_CENTER);//利润中心
			item.put("MATERIAL",MATERIAL);//物料
			item.put("MARK",MARK);//K表示供应商行，T表示税金行
			item.put("QUANTITY",QUANTITY);//数量
			item.put("BASE_UOM",BASE_UOM);//基本计量单位
			items.add(item);

		}
		rs.writeLog("获得items："+items);





		//TODO
		//SAP链接


 		String sources = "1";
 		SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
 		sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
 		log.writeLog("创建SAP连接");
 		String strFunc = "ZOA_FI_DOC_CREATE_MY1";
 		JCO.Function function = null;
 		JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
 		IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
 		function = ft.getFunction();

 		if (function == null) {
 			log.writeLog("链接SAP失败");
 			return;
 		}

 		if (headers.size()>0){
		log.writeLog("开始设置HEADER值>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		Iterator keys=headers.keys();
		while (keys.hasNext()){
			String key = keys.next().toString();
			String value=headers.getString(key);
			function.getImportParameterList().setValue(value, key);
			log.writeLog("设置值："+key+"="+value);

		}
 		}
		log.writeLog("HEADER值设置结束<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
		log.writeLog("开始设置表IF_DOC_ITEMS值>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
 		JCO.Table inTableParams1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
 		for (int i = 0; i < items.size(); i++) {
			JSONObject item=items.getJSONObject(i);
			inTableParams1.appendRow();
			Iterator keys=item.keys();
			while (keys.hasNext()){
				String key = keys.next().toString();
				String value=item.getString(key);
				inTableParams1.setValue(value, key);
				log.writeLog("设置值:"+key+"="+value);

			}
 		}



 		log.writeLog("执行function上传sap数据");
 		sapconnection.execute(function);

		// 获取数据
		log.writeLog("读取返回数据>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		JCO.Table retable=function.getTableParameterList().getTable("ITEMS_LOG");

		rs.writeLog("返回表行数："+retable.getNumRows());

		JSONArray jsonArray=new JSONArray();

		for (int i = 0; i < retable.getNumRows(); i++) {
			JSONObject jsonObject=new JSONObject();
			retable.setRow(i);
			REF_DOC_NO=retable.getString("REF_DOC_NO");
			ZOANO=retable.getString("ZOANO");
			ZOA_DOC_NO=retable.getString("ZOA_DOC_NO");
			HEADER_TXT=retable.getString("HEADER_TXT");
			FLAG=retable.getString("FLAG");
			AC_DOC_NO=retable.getString("AC_DOC_NO");
			ERR_MSG=retable.getString("ERR_MSG");

			rs.writeLog("REF_DOC_NO返回："+retable.getString("REF_DOC_NO"));
			rs.writeLog("ZOANO返回："+retable.getString("ZOANO"));
			rs.writeLog("ZOA_DOC_NO返回："+retable.getString("ZOA_DOC_NO"));
			rs.writeLog("HEADER_TXT返回："+retable.getString("HEADER_TXT"));
			rs.writeLog("FLAG返回："+retable.getString("FLAG"));
			rs.writeLog("AC_DOC_NO返回："+retable.getString("AC_DOC_NO"));
			rs.writeLog("ERR_MSG返回："+retable.getString("ERR_MSG"));

			jsonObject.put("REF_DOC_NO",REF_DOC_NO);
			jsonObject.put("ZOANO",ZOANO);
			jsonObject.put("ZOA_DOC_NO",ZOA_DOC_NO);
			jsonObject.put("HEADER_TXT",HEADER_TXT);
			jsonObject.put("FLAG",FLAG);
			jsonObject.put("AC_DOC_NO",AC_DOC_NO);
			jsonObject.put("ERR_MSG",ERR_MSG);

			jsonArr.add(jsonObject);


			    String id="";
			    if ("X".equals(FLAG)) {
					//更新状态为 4--完成
					StringBuffer upDateZtSql = new StringBuffer().append("UPDATE uf_qkqz SET ZT='3' WHERE ")
							.append("SQBH='" + sqbh + "'");
					rs.writeLog(upDateZtSql.toString());
					rs.execute(upDateZtSql.toString());
				}

			    //查询id
			    StringBuffer queryIdSql=new StringBuffer().append("SELECT ID FROM UF_QKQZ WHERE SQBH='"+sqbh+"'");
				rs.writeLog(queryIdSql.toString());
				rs.execute(queryIdSql.toString());
				if (rs.next()){
				    id=Util.null2String(rs.getString("id"));
				}
			    //更新明细表2
				StringBuffer updateDetail2=new StringBuffer().append("UPDATE uf_qkqz_dt2 SET  sapqzpzh='"+HEADER_TXT+"'")
						.append(",sapfhfph='"+AC_DOC_NO+"',sapfhbs='"+FLAG+"' ")
						.append("WHERE MAINID="+id+" AND zxjhh='"+ZOANO+"' AND FPH='"+REF_DOC_NO+"'");
				rs.writeLog(updateDetail2.toString());
				rs.execute(updateDetail2.toString());
			    //更新明细表1
				StringBuffer updateDetail1=new StringBuffer().append("UPDATE uf_qkqz_dt1 SET ")
						.append("sapfh='"+AC_DOC_NO+"' ")
						.append("WHERE MAINID="+id+" AND FPHM='"+REF_DOC_NO+"'");
				rs.writeLog(updateDetail1.toString());
				rs.execute(updateDetail1.toString());
			//更新明细表3
			SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat simpleDateFormat2=new SimpleDateFormat("mm:ss");
			String updateDate=simpleDateFormat.format(new Date());
			String updateTime=simpleDateFormat2.format(new Date());

			StringBuffer updateDetail3=new StringBuffer().append("insert into uf_qkqz_dt3 (REF_DOC_NO,ZOANO,ZOA_DOC_NO,HEADER_TXT,FLAG,AC_DOC_NO,ERR_MSG,updateDate,updateTime,MAINID) " )
					.append("values('"+REF_DOC_NO+"','"+ZOANO+"','"+ZOA_DOC_NO+"','"+HEADER_TXT+"','"+FLAG+"','"+AC_DOC_NO+"','"+ERR_MSG+"','"+updateDate+"','"+updateTime+"',"+id+")");

			rs.writeLog(updateDetail3.toString());
			rs.execute(updateDetail3.toString());



		}
		//if (sapconnection!=null){
		//	sapconnection.disconnect();
		//}

		jsonResult.put("flag","X");
		jsonResult.put("result",jsonArr);
		out.clear();
		out.write(jsonResult.toString());
		out.flush();
		out.close();

	} catch (Exception e) {
		// TODO: handle exception
		jsonResult.put("flag", "E");
		jsonResult.put("err",e);
		log.writeLog("fail:"+e);
		out.clear();
		out.write(jsonResult.toString());
		out.flush();
		out.close();
		e.printStackTrace();
	}

%>
<%!public  String getSapChange(String oldDate){
    String newDate="";
    String[] strings=oldDate.split("-");
	for (int i = 0; i <strings.length; i++) {
	    newDate+=strings[i];

	}
	return newDate;

}

%>