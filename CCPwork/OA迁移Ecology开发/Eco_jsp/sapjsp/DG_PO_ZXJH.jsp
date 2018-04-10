<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.general.Util"%>>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>>
<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl;"%>

<%
	String ponos = request.getParameter("ponos");
	String jkdhbh = request.getParameter("jkdhbh");
	try {
		RecordSet rs1 = new RecordSet();
		DataSource ds = (DataSource) StaticObj.getServiceByFullname(("datasource.eweaverTestOA"),
				weaver.interfaces.datasource.DataSource.class);
		Connection conn = ds.getConnection();
		String outcall = "";
		Statement st = conn.createStatement();
		String[] ponoses = ponos.split(",");
		for (int i = 0; i < ponoses.length; i++) {
			String sql = "select * from v_eco_importblpack " + " where ibolnum='" + jkdhbh
					+ "' and containerno ='" + ponoses[i] + "'";
			rs1.writeLog("查询e-weaver:" + sql);
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				outcall += "![]";
				outcall += Util.null2String(rs.getString("BILLOFLADNUM")) + "|";//提单号
				outcall += Util.null2String(rs.getString("PONO")) + "|";//订单号
				outcall += Util.null2String(rs.getString("POITEM")) + "|";//项次
				outcall += Util.null2String(rs.getString("QUANTITY")) + "|";//数量
				outcall += Util.null2String(rs.getString("CONTAINERNO")) + "|";//柜号
				outcall += Util.null2String(rs.getString("CABTYPE")) + "|";//柜型
			}
		}
		out.write("suceess：" + outcall);
	} catch (Exception e) {
		// TODO: handle exception
		out.write("fail" + e);
		e.printStackTrace();

	}
%>


