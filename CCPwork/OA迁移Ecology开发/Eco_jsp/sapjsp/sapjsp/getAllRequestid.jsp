<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<jsp:useBean id="log" class="weaver.general.BaseBean"></jsp:useBean>

<%
	log.writeLog("进入打印更新");
	String billids = request.getParameter("billids");

	JSONArray jsonArr = new JSONArray();
	JSONObject objectresult = new JSONObject();
	String sfdy = "";//是否打印
	int dycs;//打印次数
	String lx="";//类型
	try {
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		String[] billid = billids.split(",");
		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currdate = format.format(d);
		for (int i = 0; i < billid.length; i++) {
			String sql = "select * from uf_trdpldy " + " where id= '" + billid[i] + "'";
			rs.writeLog("查询的sql:" + sql);
			rs.executeSql(sql);
			while (rs.next()) {
				JSONObject object = new JSONObject();
				sfdy = rs.getString("sfdy");
				dycs = Integer.parseInt(rs.getString("dycs")) + 1;
				lx=rs.getString("lx");
				String otherUrl="";
				if ("1".equals(lx)){
				    String id=rs.getString("id");
				    RecordSet recordSet=new RecordSet();
				    sql="select wlhm from uf_trdpldy_dt1 where mainid="+id;
				    recordSet.writeLog(sql);
				    recordSet.execute(sql);
				    while (recordSet.next()){
				        String wlhm=recordSet.getString("wlhm");
				        if ("VA000004".equals(wlhm)||"R0000125".equals(wlhm)){
				            otherUrl="1";
				            break;
						}
					}
				}
				object.put("sfdy", sfdy);
				object.put("dycs", dycs);
				object.put("trdh", rs.getString("trdh"));
				object.put("id", rs.getString("id"));
				object.put("sfzf", rs.getString("sfzf"));
				object.put("otherUrl",otherUrl);

				//更新sql
				String updateSql = "update uf_trdpldy set sfdy = '1', dycs = '" + dycs + "',dyrq = '"
						+ currdate.substring(0, 10) + "',dysj = '" + currdate.substring(11, 16) + "' where id = '"
						+ billid[i] + "'";
				rs1.writeLog("更新sql：" + updateSql);
				rs1.executeSql(updateSql);
				jsonArr.add(object);
			}
		}
		objectresult.put("result", jsonArr);
		PrintWriter pw = response.getWriter();
		pw.write(objectresult.toString());
		rs.writeLog("返回json：" + objectresult.toString());
		pw.flush();
		pw.close();
	} catch (Exception e) {
		// TODO: handle exception
		out.write("fail" + e);
		e.printStackTrace();

	}
%>


