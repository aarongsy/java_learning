<%@page import="java.math.BigDecimal"%>
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
<%

	String action = request.getParameter("action");
	RecordSet rs = new RecordSet();
	rs.writeLog("VGM1");
	String ksrq=request.getParameter("ksrq");
	String jsrq=request.getParameter("jsrq");
	String gh=request.getParameter("gh");
	JSONArray jsonArr = new JSONArray();
	JSONObject jsonObject= new JSONObject();
	String sql="";
	String message="";
	sql+="select a.id,a.jz,b.zgrq,a.gh from uf_gbjl a,(";
	try {
		sql+="SELECT code,zgrq FROM UF_GHLR a,UF_GHLR_DT1 b WHERE a.id=b.MAINID and 1=1";
		if(!ksrq.equals("")){
			if(jsrq.equals("")){
				Date date = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				jsrq+= sdf.format(date);
				
			}
			sql+=" and b.zgrq between '"+ksrq+"' and '"+jsrq+"'";
		}
			
			if(!gh.equals("")){
				sql+=" and b.code='"+gh+"'";
			}
			sql+=") b where a.gh=b.code and a.jz is not null order by a.gbrq desc,a.gbsj desc";
			//如果柜号、开始结束日期都为空，sql清空
			if(ksrq.equals("")&&jsrq.equals("")&&gh.equals("")){
				sql="";
			}
			
			rs.writeLog(sql);
			rs.execute(sql);
			while(rs.next()){
				JSONObject obj=new JSONObject();
				obj.put("gh", Util.null2String(rs.getString("gh")));
				obj.put("rq", Util.null2String(rs.getString("zgrq")));
				obj.put("jz", Util.null2String(rs.getString("jz")));
				obj.put("id", Util.null2String(rs.getString("id")));
				jsonArr.add(obj);
			}
			
		
		
	} catch (Exception e) {
		// TODO: handle exception
		//out.write("fail" + e);
		rs.writeLog("fail--" + e);
		message+="fail"+e;
		e.printStackTrace();
		

	}
	rs.writeLog("返回json："+jsonArr.toString());
	out.write(jsonArr.toString());
%>

<%!public Double calculateJZ(String rz,String cz){
	Util.getDoubleValue("0.00");
	if(rz.equals("")||rz==null){
		
		rz="0.00";
	}
	if(cz.equals("")||rz==null){
		
		cz="0.00";
	}
	//计算净重的绝对值
	BigDecimal b1=new BigDecimal(rz);
	BigDecimal b2=new BigDecimal(cz);
	Double b3=b1.subtract(b2).doubleValue();
	return Math.abs(b3);
	}%>

<%!public String null2Double(String str){
	String d1="0.00";
	if(str.equals("")||str==null){
		return d1;
	}
	return str;
	
	
	}%>

<%!public JSONObject addJsonJZ(String message) {

		return addJson(message, null, null, null);
	}%>
<%!public JSONObject addJson(String message, String newcp, String trdStatus, String ptStatus) {
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("message", message);
		jsonobj.put("cp", newcp);
		jsonobj.put("trdStatus", trdStatus);
		jsonobj.put("ptStatus", ptStatus);
		return jsonobj;
	}%>
<%!public RecordSet getGBZJ(String planNo) {
		RecordSet rs = new RecordSet();
		String sql = "select * from uf_gbjl where 1=1";
		if (planNo != null) {
			sql += "and zxjhh = " + planNo;
		}
		rs.executeSql(sql);
		return rs;
	}%>