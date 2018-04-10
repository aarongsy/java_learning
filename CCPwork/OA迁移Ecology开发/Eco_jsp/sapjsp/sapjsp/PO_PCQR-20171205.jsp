<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
rs.writeLog("进入PO_PCQR.jsp");
String trdh=request.getParameter("trdh");
rs.writeLog("获得提入单号为："+trdh);
JSONArray jsonArr = new JSONArray();
JSONArray jsonArr2=new JSONArray();
StringBuffer sql=new StringBuffer();
sql.append("SELECT b.jydh,b.ddxc,a.lcid from UF_TRDPLDY a,UF_TRDPLDY_DT1 b where a.id=b.MAINID and a.TRDH='")
	.append(trdh+"'");
//out.print(sql);
rs.executeSql(sql.toString());
rs.writeLog(sql.toString());
String dh="";
String xc="";
String lcid="";
while(rs.next()){
	dh=Util.null2String(rs.getString("jydh"));
	xc=Util.null2String(rs.getString("ddxc"));
	lcid=Util.null2String(rs.getString("lcid"));
	break;
}
StringBuffer sql1=new StringBuffer();
sql1.append("SELECT cp from formtable_main_61 where requestid='")
	.append(lcid+"'");
rs.writeLog(sql1);
rs.execute(sql1.toString());
String cp="";
while(rs.next()){
	cp=Util.null2String(rs.getString("cp"));
	break;
}


StringBuffer sql2=new StringBuffer();
sql2.append("select * from uf_jmclxq where PONO='"+dh+"' AND"+" POITEM='"+xc+"'");
rs.writeLog(sql2);
rs.execute(sql2.toString());
	while(rs.next()){
		Map<String,String> map = new HashMap<String,String>();
		String bs=Util.null2String(rs.getString("ZCHARG"));
		 map.put("gc",Util.null2String(rs.getString("WERKS")));//工厂
            map.put("wlh", Util.null2String(rs.getString("wlh")));//物料号
            map.put("wlms", Util.null2String(rs.getString("wlname")));//物料描述
            map.put("wlqypc", bs);//物料启用批次
            map.put("bz1", Util.null2String(rs.getString("BEIZHU1")));//备注1
            map.put("bz2", Util.null2String(rs.getString("BEIZHU2")));//备注2
            map.put("bz3", Util.null2String(rs.getString("BEIZHU3")));//备注2
            map.put("cp", cp);//车牌
            if(!bs.equals("X")){
            	jsonArr.add(map);
            	
            }else{
            	
            	jsonArr.add(map);
            }
            
	
}	
	JSONObject jnobj=new JSONObject();
	jnobj.put("dt0", jsonArr);
	jnobj.put("dt1", jsonArr2);
	PrintWriter pw = response.getWriter();
    rs.writeLog("装卸计划返回JSON:"+jnobj.toString());
	pw.write(jnobj.toString());
	pw.flush();
	pw.close();




%>