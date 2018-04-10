<%@page import="bsh.util.Util"%>
<%@page import="java.util.Iterator"%>
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
<%@page import="java.math.BigDecimal"%>
<%
String mxdata=request.getParameter("mxdata");

RecordSet rs=new RecordSet();
rs.writeLog("进入lhsq.jsp");
try{
if(mxdata.equals("")||mxdata==null){
	out.write("获得数据为空！");
	return;
}
String sql="";
JSONArray jsonArray=new JSONArray();
jsonArray=JSONArray.fromObject(mxdata);
rs.writeLog("获得的数组为："+jsonArray.toString());

Map<String,String> hp=new HashMap<String,String>();
for(int i=0;i<jsonArray.size();i++){
	JSONObject jsonObject=jsonArray.getJSONObject(i);
	String ddh=jsonObject.getString("ddh");
	String xc=jsonObject.getString("xc");
	String bczxsl=jsonObject.getString("bczxsl");
	if(hp.containsKey(ddh+"-"+xc)){
		String oldSl=hp.get(ddh+"-"+xc);
		String newSl=(calCulate(oldSl,bczxsl,"add")).toString();
		hp.put(ddh+"-"+xc, newSl);
		
	}else{
		
		hp.put(ddh+"-"+xc, bczxsl);
	}
}
JSONArray jsonArray2=new JSONArray();
Iterator iterator=hp.entrySet().iterator();
while(iterator.hasNext()){
	JSONObject jsonObject=new JSONObject();
	Map.Entry entry = (Map.Entry) iterator.next();
	String key = entry.getKey().toString();
	String val = entry.getValue().toString();
	String[] strs2=key.split("-");
	jsonObject.put("ddh", strs2[0]);
	jsonObject.put("xc",strs2[1]);
	jsonObject.put("bczxsl",val);
	jsonArray2.add(jsonObject);}
	rs.writeLog("获得jsonArray2："+jsonArray2.toString());
	for(int i=0;i<jsonArray2.size();i++){
		JSONObject jsObject=jsonArray2.getJSONObject(i);
		sql="select LFIMG,YCHL from uf_spghsr where DELIVERYNO='"+jsObject.getString("ddh")+"' and DELIVERYITEM='"+jsObject.getString("xc")+"'";
		rs.writeLog(sql);
		rs.execute(sql);
		while(rs.next()){
			RecordSet rs2=new RecordSet();
			String YCHL=rs.getString("YCHL");//已出货量
			String LFIMG=rs.getString("LFIMG");//总数量
			Double nowCounts=calCulate(LFIMG, YCHL,"sub");
			rs2.writeLog("已出货为："+YCHL+",总数量为："+LFIMG+",剩余数量为："+nowCounts);
			Double insertSL=Double.valueOf(jsObject.getString("bczxsl")).doubleValue();
			if(nowCounts<insertSL){
				out.write("插入数据库中时发现 订单号为："+jsObject.getString("ddh")+",项次为："+jsObject.getString("ddh")+",本次插入数量为:"+insertSL+",超过了系统实际剩余量:"+nowCounts);
				return;
			}else{
			Double insertSL2=calCulate(YCHL, jsObject.getString("bczxsl"),"add");
			
			//sql="UPDATE uf_spghsr SET YCHL='"+insertSL2+"' WHERE DELIVERYNO='"+jsObject.getString("ddh")+"' and DELIVERYITEM='"+jsObject.getString("xc")+"'";
			//rs2.writeLog(sql);
			//rs2.execute(sql);
                response.setContentType("text/html;charset=UTF-8");
				PrintWriter pw=response.getWriter();
				pw.write("success");
				pw.flush();
				pw.close();
			rs.writeLog("返回success");
			return;
			}
			
		}
		
	}
	
}catch(Exception e){
	out.write("fail--"+e);
	rs.writeLog("fail---"+e);
}
	%>

<%!public Double calCulate(String str1,String str2,String action){
	if(str1.equals("")||str1==null){
		
		str1="0.00";
	}
	if(str2.equals("")||str2==null){
		
		str2="0.00";
	}
	//计算净重的绝对值
	BigDecimal b1=new BigDecimal(str1);
	BigDecimal b2=new BigDecimal(str2);
	Double b3=0.00;
	if(action.equals("add")){
		b3=	b1.add(b2).doubleValue();
	}
	if(action.equals("sub")){
		b3=b1.subtract(b2).doubleValue();
}
	return b3;
	}%>