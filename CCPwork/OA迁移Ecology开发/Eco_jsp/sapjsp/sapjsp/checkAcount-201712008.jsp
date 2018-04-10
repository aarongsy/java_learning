
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.Util"%>
<%
RecordSet rs=new RecordSet();
rs.writeLog("进入checkAcount");
String strs=request.getParameter("js");
JSONObject jsObject=JSONObject.fromObject(strs);
rs.writeLog("获得JSON:"+jsObject);

String sql="";
String compcode=(jsObject.getString("compcode"));
String startdate=Util.null2String(jsObject.getString("startdate"));
String enddate=Util.null2String(jsObject.getString("enddate"));
String costtype=Util.null2String(jsObject.getString("costtype"));
String kpyz=Util.null2String(jsObject.getString("kpyz"));
String carriercode=Util.null2String(jsObject.getString("carriercode"));

StringBuffer sb=new StringBuffer();
sb.append("SELECT * FROM uf_zgfy WHERE 1=1");
if(!compcode.equals(""))
	   sb.append(" and comcode='"+compcode+"'");
if(!costtype.equals(""))
	   sb.append(" and fylx='"+costtype+"'");
if(!kpyz.equals(""))
	   sb.append(" and hbkpyz='"+kpyz+"'");
if(!carriercode.equals(""))
	   sb.append(" and cyscode='"+carriercode+"'");
if(!startdate.equals("")&&!enddate.equals(""))
	   sb.append(" and credate between '"+startdate+"' and '"+enddate+"'");
if(startdate.equals("")&&!enddate.equals(""))
	   sb.append(" and credate<'"+enddate+"'");
if(!startdate.equals("")&&enddate.equals(""))
	   sb.append(" and credate>'"+startdate+"'s");

sql=sb.toString();
try{
	   rs.writeLog(sql);
	   rs.execute(sql);
	   JSONArray jsArray=new JSONArray();
	   
	   
while(rs.next()){
	   String zxplanno=Util.null2String(rs.getString("zxplanno"));//装卸计划号
	   String fylx=Util.null2String(rs.getString("fylx"));//费用类型
	   String cysname=Util.null2String(rs.getString("cysname"));//承运商名称
	   //String zxplanno=Util.null2String(rs.getString("zxplanno"));运输时间
	   //String zxplanno=Util.null2String(rs.getString("zxplanno"));车型
	   // String zxplanno=Util.null2String(rs.getString("zxplanno"));吨位
	   String carno=Util.null2String(rs.getString("carno"));//车牌
	   // String zxplanno=Util.null2String(rs.getString("zxplanno"));重量
	   //String zxplanno=Util.null2String(rs.getString("zxplanno"));客户地址
	   String amount=Util.null2String(rs.getString("amount"));//暂估含税金额
	   String notaxamt=Util.null2String(rs.getString("notaxamt"));//暂估未税金额
	  // String zxplanno=Util.null2String(rs.getString("zxplanno"));费用模式
	  String xc=Util.null2String(rs.getString("notaxamt"));//暂估未税金额
	  //String notaxamt=Util.null2String(rs.getString("notaxamt"));//项次
	  //String notaxamt=Util.null2String(rs.getString("notaxamt"));//物料号码
	  //String notaxamt=Util.null2String(rs.getString("notaxamt"));//内部订单号
	  String djlx=Util.null2String(rs.getString("djlx"));//单据类型
	   JSONObject jsObject2=new JSONObject();
	  jsObject2.put("zxplanno", zxplanno);
	  jsObject2.put("fylx",fylx );
	  jsObject2.put("cysname",cysname );
	  jsObject2.put("carno",carno);
	  jsObject2.put("amount",amount );
	  jsObject2.put("notaxamt",notaxamt );
	  jsObject2.put("xc",xc );
	  jsObject2.put("djlx",djlx );
	  jsArray.add(jsObject2);
}
rs.writeLog(jsArray.toString());
if(jsArray.size()>0){
	   out.write(jsArray.toString());
}else{
	out.write("查询不到数据");
	return;
}
}catch(Exception e){
	   e.printStackTrace();
	   rs.writeLog("fail--"+e);
	   out.write("fail--"+e);
}%>