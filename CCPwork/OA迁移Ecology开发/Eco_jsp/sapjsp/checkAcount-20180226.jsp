
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
rs.writeLog("费用类型："+costtype);

StringBuffer sb=new StringBuffer();
sb.append("SELECT a.zxplanno,a.lgbh,a.fylx,a.cysname,a.cx,a.dw,a.carno,a.amount,b.pono,b.notaxamt,b.ddlx,b.zl,b.khdz,b.orderitem,b.wlh")  
		.append(",a.HL,a.cyscode,b.costcenter,b.account,a.currency,a.sappzh,a.djbh,b.JZDM")
		.append(" from uf_zgfy a,UF_ZGFY_DT1 b  where a.id=b.MAINID and b.jzdm='40'");
if(!compcode.equals(""))
	   sb.append(" and a.comcode='"+compcode+"'");
if(!costtype.equals("")){
	   String[] fylxs=costtype.split(",");
	   if(fylxs.length==1){
	   		   sb.append(" and a.fylx='"+costtype+"'");
	   }
	   else{
		   sb.append(" and a.fylx in (");
		   for(int i=0;i<fylxs.length;i++){
			   sb.append("'"+fylxs[i]+"'");
			   if(i!=fylxs.length-1)
				   sb.append(",");
		   }
		   sb.append(")");
	   }

}
if(!kpyz.equals(""))
	   sb.append(" and a.hbkpyz='"+kpyz+"'");
if(!carriercode.equals(""))
	   sb.append(" and a.cysname='"+carriercode+"'");
if(!startdate.equals("")&&!enddate.equals(""))
	   sb.append(" and a.credate between '"+startdate+"' and '"+enddate+"'");
if(startdate.equals("")&&!enddate.equals(""))
	   sb.append(" and a.credate<'"+enddate+"'");
if(!startdate.equals("")&&enddate.equals(""))
	   sb.append(" and a.credate>'"+startdate+"'s");

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
	   String cx=Util.null2String(rs.getString("cx"));//车型
	   String dw=Util.null2String(rs.getString("dw"));//吨位
	   String carno=Util.null2String(rs.getString("carno"));//车牌
	    String zl=Util.null2String(rs.getString("zl"));//重量
	   String khdz=Util.null2String(rs.getString("khdz"));//客户地址
	   String amount=Util.null2String(rs.getString("amount"));//暂估含税金额
	   String notaxamt=Util.null2String(rs.getString("notaxamt"));//暂估未税金额
	  // String zxplanno=Util.null2String(rs.getString("zxplanno"));费用模式
	   String orderitem=Util.null2String(rs.getString("orderitem"));//项次
	   String pono=Util.null2String(rs.getString("pono"));//内部订单号
	  String djlx=Util.null2String(rs.getString("ddlx"));//单据类型
	  //新增5个
	  String hl=Util.null2String(rs.getString("hl"));//汇率
	  String zfdx=Util.null2String(rs.getString("cyscode"));//支付对象
	  String costcenter=Util.null2String(rs.getString("costcenter"));//成本中心
	  String account=Util.null2String(rs.getString("account"));//总账科目
	  String currency=Util.null2String(rs.getString("currency"));//暂估币种
	  
	  String djbh=Util.null2String(rs.getString("djbh"));//单据编号
	  String sappzh=Util.null2String(rs.getString("sappzh"));//SAP凭证号
	  String lgbh=Util.null2String(rs.getString("lgbh"));//理柜编号
	   JSONObject jsObject2=new JSONObject();
	  jsObject2.put("zxplanno", zxplanno);
	  jsObject2.put("fylx",fylx );
	  jsObject2.put("cysname",cysname );
	  jsObject2.put("carno",carno);
	  jsObject2.put("amount",amount );
	  jsObject2.put("notaxamt",notaxamt );
	  jsObject2.put("djlx",djlx );
	  jsObject2.put("cx", cx);
	  jsObject2.put("dw", dw);
	  jsObject2.put("zl", zl);
	  jsObject2.put("khdz", khdz);
	  jsObject2.put("orderitem", orderitem);
	  jsObject2.put("pono", pono);
	  //新增五个
	  jsObject2.put("hl", hl);
	  jsObject2.put("zfdx", zfdx);
	  jsObject2.put("costcenter", costcenter);
	  jsObject2.put("account", account);
	  jsObject2.put("currency", currency);
	  
	  jsObject2.put("djbh", djbh);
	  jsObject2.put("sappzh", sappzh);
	  jsObject2.put("lgbh", lgbh);
	  
	  //根据承运商id查询名称
	  RecordSet rs2=new RecordSet();
	  sql="SELECT conname from uf_dmlo_consolidat where id="+cysname;
	  rs2.writeLog(sql);
	  rs2.execute(sql);
	  String cysname2="";
	  if(rs2.next()){
		  cysname2=rs2.getString("conname");
	  }
	  jsObject2.put("cysname2",cysname2 );
	  //根据车型id查询车型名称
	  sql="SELECT cartype from uf_clcxgl where id="+cx;
	  rs2.writeLog(sql);
	  rs2.execute(sql);
	  String cx2="";
	  if(rs2.next()){
		  cx2=rs2.getString("cartype");
	  }
	  jsObject2.put("cx2",cx2 );
	  
	  
	  //根据费用类型id查询费用类型名称
	  sql="select fyms from uf_fylx where id="+fylx;
	  rs2.writeLog(sql);
	  rs2.execute(sql);
	  String fylx2="";
	  if(rs2.next()){
		  fylx2=rs2.getString("fyms");
	  }
	  jsObject2.put("fylx2",fylx2 );
	  
	  
	//根据装卸计划号查询计费模式
	 if(fylx.equals("0")){
		sql="SELECT JFMS FROM formtable_main_45 where ZXJHH='"+zxplanno+"'";
	 }
	 if(fylx.equals("1")){
			sql="SELECT JFMS from formtable_main_61 where zxjhh='"+zxplanno+"'";
		 }
	 rs2.writeLog(sql);
	 rs2.execute(sql);
	 String jfms="";
	 if(rs2.next()){
		 jfms=Util.null2String(rs.getString("jfms"));
	 }
	 jsObject2.put("jfms", jfms);
	
	 //根据订单号及项次查询物料号及客户地址
	 if(fylx.equals("0")){
	 sql="SELECT STOCKNO as wlh,SOLDTOADDR FROM UF_SPGHSR where DELIVERYNO='"+pono+"' and DELIVERYITEM='"+orderitem+"'";
	 }
	 if(fylx.equals("1")){
	 sql="SELECT wlh,shiptoaddr from uf_jmclxq where PONO='"+pono+"' and POITEM='"+orderitem+"'";
	 }
	 rs2.writeLog(sql);
	  rs2.execute(sql);
	  String wlh="";
	  String shiptoaddr="";
	  if(rs2.next()){
		  wlh=rs2.getString("wlh");
		  shiptoaddr=rs2.getString("shiptoaddr");
	  }
	  jsObject2.put("wlh",wlh );
	  jsObject2.put("shiptoaddr", shiptoaddr);
	  
	  
	  jsArray.add(jsObject2);
}
rs.writeLog(jsArray.toString());
if(jsArray.size()>0){
	   out.write(jsArray.toString());
	   return;
}else{
	out.write("查询不到数据");
	return;
}
}catch(Exception e){
	   e.printStackTrace();
	   rs.writeLog("fail--"+e);
	   out.write("fail--"+e);
}%>