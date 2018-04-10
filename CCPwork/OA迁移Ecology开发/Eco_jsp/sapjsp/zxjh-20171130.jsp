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
<%
String[] strs=request.getParameterValues("ghs[]");
String type=request.getParameter("type");
RecordSet rs=new RecordSet();
rs.writeLog("进入zxjh.jsp");
rs.writeLog("获得的数组为："+strs.toString()+",类型为："+type);

JSONArray jsonArr = new JSONArray();

if(type.equals("yg")){
StringBuffer sql=new StringBuffer();
sql.append("SELECT c.gh,c.ph,c.sl,d.* from ")
	.append(" (SELECT a.gh gh,b.jydh jydh,b.xc xc,b.ph ph,b.bczxsl sl")
	.append(" from formtable_main_43 a,formtable_main_43_dt1 b where a.id=b.mainid)")
	.append(" c,uf_spghsr d where c.xc=d.DELIVERYITEM and c.JYDH=d.DELIVERYNO");
for(int i=0;i<strs.length;i++){
 if(i==0)
 sql.append(" and c.gh='").append(strs[i]+"'");
 else
 sql.append(" or c.gh='").append(strs[i]+"'");
}
//out.print(sql);
rs.executeSql(sql.toString());
rs.writeLog("装卸计划有柜执行sql："+sql.toString());


	
	while(rs.next()){
		Map<String,String> map = new HashMap<String,String>();
		 map.put("gh", rs.getString("gh"));//柜号
            map.put("ph", rs.getString("ph"));//批号
            map.put("jydh", rs.getString("DELIVERYNO"));//交运单号
            map.put("xc", rs.getString("DELIVERYITEM"));//项次
            map.put("sl", rs.getString("sl"));//数量
            map.put("cp", rs.getString("PROCATEGORY"));//产品
            
            jsonArr.add(map);
	}
}	
if(type.equals("wg")){
	StringBuffer sql=new StringBuffer();
	sql.append("SELECT * FROM UF_SPGHSR WHERE 1=1");
	
	for(int i=0;i<strs.length;i++){
		 if(i==0)
		 sql.append(" and SHIPADVICENO='").append(strs[i]+"'");
		 else
		 sql.append(" or SHIPADVICENO='").append(strs[i]+"'");
		}
	rs.executeSql(sql.toString());
	rs.writeLog("装卸计划无柜执行sql："+sql.toString());
		while(rs.next()){
			Map<String,String> map = new HashMap<String,String>();
			 map.put("SHIPADVICENO", Util.null2String(rs.getString("SHIPADVICENO")));//SHIPPING
	            map.put("DELIVERYNO", Util.null2String(rs.getString("DELIVERYNO")));//交运单号
	            map.put("DELIVERYITEM", Util.null2String(rs.getString("DELIVERYITEM")));//项次
	            map.put("PROCATEGORY", Util.null2String(rs.getString("PROCATEGORY")));//产品
	            map.put("SALEORDER", Util.null2String(rs.getString("SALEORDER")));//销售订单
	            map.put("ORDERITEM", Util.null2String(rs.getString("ORDERITEM")));//销售订单项次
	            map.put("STOCKNO", Util.null2String(rs.getString("STOCKNO")));//物料号码
	            map.put("STOCKDESC", Util.null2String(rs.getString("STOCKDESC")));//物料描述
	            map.put("LOCATION", Util.null2String(rs.getString("LOCATION")));//库存位置
	            map.put("SHIPNUM", Util.null2String(rs.getString("SHIPNUM")));//出货数量
	            map.put("SALEUNIT", Util.null2String(rs.getString("SALEUNIT")));//单位代码
	            map.put("SHIPTO", Util.null2String(rs.getString("SHIPTO")));//送达方名称
	            map.put("SHIPTOADDR", Util.null2String(rs.getString("SHIPTOADDR")));//送达方地址
	            map.put("REALSHIPNUM", Util.null2String(rs.getString("REALSHIPNUM")));//实际出货数量
	            map.put("COSTCENTER", Util.null2String(rs.getString("COSTCENTER")));//成本中心
	            map.put("LCEN", Util.null2String(rs.getString("LCEN")));//利润中心
	            map.put("MATERDES", Util.null2String(rs.getString("MATERDES")));//客户物料描述
	            map.put("CUSORDNO", Util.null2String(rs.getString("CUSORDNO")));//客户订单编号
	            map.put("ORDERADVICENO", Util.null2String(rs.getString("ORDERADVICENO")));//OrderAdvice编号
	            map.put("SOLDTO", Util.null2String(rs.getString("SOLDTO")));//售达方名称
	            map.put("SOLDTOADDR", Util.null2String(rs.getString("SOLDTOADDR")));//售达方地址
	   
	            
	            jsonArr.add(map);
		}
	

}

	PrintWriter pw = response.getWriter();
    rs.writeLog("装卸计划返回JSON:"+jsonArr.toString());
	pw.write(jsonArr.toString());
	pw.flush();
	pw.close();




%>