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
	RecordSet rs1 = new RecordSet();
	rs.writeLog("VGM1");
	String shipping=request.getParameter("shipping");
	String lx = request.getParameter("lx");
	String ksrq = request.getParameter("ksrq");
	String jsrq = request.getParameter("jsrq");
	JSONArray jsonArr = new JSONArray();
	JSONObject jsonObject= new JSONObject();
	//billid= Util.null2String(request.getParameter("billid"));//billid
	String sql="";
	String message="";
	
	try {
		if(lx.equals("0")){
			if(!shipping.equals("")){
				sql+="SELECT a.shipping,b.code,a.cabtype,";
				sql+="(SELECT jz from uf_gbjl where gh = b.code  and jz is not null and ROWNUM = 1 ) as jz,";
				sql+=" (SELECT gbrq from uf_gbjl where gh = b.code  and jz is not null and ROWNUM = 1 ) as gbrq ";
				sql+=" from UF_GHLR a,UF_GHLR_DT1 b  where a.id = b.mainid and  ";
				sql+=" a.shipping = '"+shipping+"'";
				
				rs.writeLog("VGM1SQL="+sql);
				rs.execute(sql);
				while(rs.next()){
					JSONObject obj=new JSONObject();
					obj.put("shipping", Util.null2String(rs.getString("shipping")));
					obj.put("code", Util.null2String(rs.getString("code")));
					obj.put("cabtype", Util.null2String(rs.getString("cabtype")));
					obj.put("jz", Util.null2String(rs.getString("jz")));
					obj.put("gbrq", Util.null2String(rs.getString("gbrq")));

					jsonArr.add(obj);
				}
			}
		}else{
			if(!shipping.equals("0")){
				sql+="SELECT zxjhh,YGSHIPNO,ghcx,SJYSRQ,CRZ,ccz,cp,(SELECT CARTYPE from UF_CLCXGL where id = cx) cx from formtable_main_45 a where ";
				sql+=" SJYSRQ BETWEEN  '"+ksrq+"' and '"+jsrq+"' and SFZF = 0  and YGSHIPNO is not NULL ";
				
				
				rs.writeLog("VGM2SQL="+sql);
				rs.execute(sql);
				while(rs.next()){
					JSONObject obj=new JSONObject();
					obj.put("zxjhh", Util.null2String(rs.getString("zxjhh")));
					obj.put("YGSHIPNO", Util.null2String(rs.getString("YGSHIPNO")));
					obj.put("ghcx", Util.null2String(rs.getString("ghcx")));
					obj.put("SJYSRQ", Util.null2String(rs.getString("SJYSRQ")));
					obj.put("CRZ", Util.null2String(rs.getString("CRZ")));
					obj.put("ccz", Util.null2String(rs.getString("ccz")));
					obj.put("cp", Util.null2String(rs.getString("cp")));
					obj.put("cx", Util.null2String(rs.getString("cx")));
					jsonArr.add(obj);
				}
			}
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