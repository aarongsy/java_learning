<%@page import="com.caucho.quercus.program.TryStatement.Catch"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%
	BaseBean log = new BaseBean();

	log.writeLog("调用CheckRecords_JGD开始");
	try {

		String tablename = "formtable_main_45";
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMM");
		String currdate1 = format.format(d);
		// 定义字段
		String gys = "";// 供应商
		String hgc = "";// DEPOH（货柜厂）
		String ksrq = "";// 开始日期
		String jsrq = "";// 结束日期
		String wrongError = "";
		
		String sql = "select t1.* from " + tablename + " t1 ";
		sql += " left join " + tablename + "_dt2 t2 on t1.id = t2.mainid";
		sql += " where t1.requestid= '" + 123 + "'";

		log.writeLog("查询明细的sql:" + sql);
		rs.execute(sql);
		while (rs.next()) {
			String lcbh = "1010C" + currdate1;
			log.writeLog("调用存储过程fn_no_make");
			rs1.executeProc("fn_no_make", "");
			rs1.next();
			lcbh += formatString(rs1.getInt(1));
			log.writeLog("流程编号:" + lcbh);

		}
	} catch (Exception e) {
		e.printStackTrace();
		log.writeLog(e);

	}

%>
<%!public String formatString(int input) {
	String result;
	// 大于1000时直接转换成字符串返回
	if (input > 1000) {
		result = input + "";
	} else {// 根据位数的不同前边补不同的0
		int length = (input + "").length();

		if (length == 1) {
			result = "000" + input;
		} else if (length == 2) {
			result = "00" + input;
		} else {
			result = "0" + input;
		}
	}
	return result;
}%>