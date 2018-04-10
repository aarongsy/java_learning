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
RecordSet rs=new RecordSet();
rs.writeLog("进入zxjh.jsp");
rs.writeLog("获得的数组为："+strs.toString());

for(int i=0;i<strs.length;i++){
	String sql="select "+strs[i];

}


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
rs.writeLog("装卸计划执行sql："+sql.toString());


	JSONArray jsonArr = new JSONArray();
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
	PrintWriter pw = response.getWriter();
    rs.writeLog("装卸计划返回JSON:"+jsonArr.toString());
	pw.write(jsonArr.toString());
	pw.flush();
	pw.close();




%>