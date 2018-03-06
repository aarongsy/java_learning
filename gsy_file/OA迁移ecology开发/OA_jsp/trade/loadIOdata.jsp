<%@page import="com.ibm.db2.jcc.t4.ac"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
response.setHeader("Cache-Control", "no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String action = StringHelper.null2String(request.getParameter("action"));
BaseJdbcDao	baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
if("zgxx".equals(action)){
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String selectSql = "select * from v_uf_tr_packforlo where requestid = '"+requestid+"' and zxplanid is null";
	System.out.println(selectSql);
	String countSql = "select count(*) total from v_uf_tr_packforlo where requestid = '"+requestid+"' and zxplanid is null";
    List<Map> list = baseJdbcDao.executeSqlForList(selectSql);
    int total =NumberHelper.string2Int(baseJdbcDao.executeForMap(countSql).get("total")+"",0);
	JSONArray jsonArray = new JSONArray();
    for(Map map : list){
    	String col1 = StringHelper.null2String(map.get("gx"));
    	String col2 = StringHelper.null2String(map.get("wpqftxt"));
    	String col3 = StringHelper.null2String(map.get("xnhgh"));
    	String col4 = StringHelper.null2String(map.get("flowno"));
    	String col5 = StringHelper.null2String(map.get("id"));
    	String col6 = StringHelper.null2String(map.get("orderno"));
    	String col7 = StringHelper.null2String(map.get("orderitem"));
    	String col8 = StringHelper.null2String(map.get("wlh"));
    	String col9 = StringHelper.null2String(map.get("wlhdes"));
    	String col10 = StringHelper.null2String(map.get("orderitemnum"));
    	String col11 = StringHelper.null2String(map.get("deliverdnum"));
    	JSONObject jsonObject = new JSONObject();
    	jsonObject.put("col1", col1);
    	jsonObject.put("col2", col2);
    	jsonObject.put("col3", col3);
    	jsonObject.put("col4", col4);
    	jsonObject.put("col5", col5);
    	jsonObject.put("col6", col6);
    	jsonObject.put("col7", col7);
    	jsonObject.put("col8", col8);
    	jsonObject.put("col9", col9);
    	jsonObject.put("col10", col10);
    	jsonObject.put("col11", col11);
    	jsonArray.add(jsonObject);
    }
    JSONObject jo = new JSONObject();
    jo.put("totalProperty", total);
    jo.put("root", jsonArray);
	out.print(jo);
	return;
}else if("zxmx".equals(action)){
	String detailid = StringHelper.null2String(request.getParameter("detailid"));
	String param1 = StringHelper.null2String(request.getParameter("param1"));//运入运出
	String param2 = StringHelper.null2String(request.getParameter("param2"));//单据类型
	String param3 = StringHelper.null2String(request.getParameter("param3"));//制单类型
	int total = 0;
	JSONArray jsonArray = new JSONArray();
	if(!StringHelper.isEmpty(detailid)){
		List detailList = baseJdbcDao.executeSqlForList("select * from v_uf_tr_packforlo where id='"+detailid+"'");
		if(detailList!=null&&detailList.size()>0){
			String ordersql = "";
			String selectsql = "select a.*,'"+detailid+"' detailid from v_uf_lo_dgcardetail a where isself='40288098276fc2120127704884290211' and shipout='"+param1+"' and needtype='"+param2+"' and createtype='"+param3+"' ";
			String countsql = "select count(*) total from v_uf_lo_dgcardetail a where isself='40288098276fc2120127704884290211' and shipout='"+param1+"' and needtype='"+param2+"' and createtype='"+param3+"' ";
			//String existsql = " and exists(select 1 from formbase c where b.requestid=c.id and c.isdelete=0 and b.state='402864d14931fb790149328a92bd0016') ";
			Map detailMap = (Map)detailList.get(0);
			String orderno = StringHelper.null2String(detailMap.get("orderno"));
			String orderitem = StringHelper.null2String(detailMap.get("orderitem"));
			String wlh = StringHelper.null2String(detailMap.get("wlh"));
			if(!StringHelper.isEmpty(orderno)){
				if(StringHelper.isEmpty(orderitem)){
					ordersql += " and a.orderno ='"+orderno+"' ";
				}else{
					List orderList = baseJdbcDao.executeSqlForList("select 1 from uf_lo_purchase where purchaseorder='"+orderno+"'");
					if(orderList!=null&&orderList.size()>0){//如果是采购单补0
						orderitem = StringHelper.fillLeftString(orderitem, 5, '0');
					}
					ordersql += " and a.orderno ='"+orderno+"' and a.orderitem='"+orderitem+"' ";
				}
				if(!StringHelper.isEmpty(wlh)){
					ordersql += " and materialno='"+wlh+"' ";
				}
				selectsql += ordersql;
				countsql += ordersql;
				List<Map> list = baseJdbcDao.executeSqlForList(selectsql);
			    total =NumberHelper.string2Int(baseJdbcDao.executeForMap(countsql).get("total")+"",0);
			    for(Map map : list){
			    	String col1 = StringHelper.null2String(map.get("shiptoname"));
			    	String col2 = StringHelper.null2String(map.get("materialno"));
			    	String col3 = StringHelper.null2String(map.get("runningno"));
			    	String col4 = StringHelper.null2String(map.get("materialdesc"));
			    	String col5 = StringHelper.null2String(map.get("descofloc"));
			    	String col6 = StringHelper.null2String(map.get("deliverdnum"));
			    	String col7 = StringHelper.null2String(map.get("yetloadnum"));
			    	String col8 = StringHelper.null2String(map.get("ordertype"));
			    	String col9 = StringHelper.null2String(map.get("goodsgroup"));
			    	String col10 = StringHelper.null2String(map.get("factory"));
			    	String col11 = StringHelper.null2String(map.get("id"));
			    	String col12 = StringHelper.null2String(map.get("detailid"));
			    	JSONObject jsonObject = new JSONObject();
			    	jsonObject.put("col1", col1);
			    	jsonObject.put("col2", col2);
			    	jsonObject.put("col3", col3);
			    	jsonObject.put("col4", col4);
			    	jsonObject.put("col5", col5);
			    	jsonObject.put("col6", col6);
			    	jsonObject.put("col7", col7);
			    	jsonObject.put("col8", col8);
			    	jsonObject.put("col9", col9);
			    	jsonObject.put("col10", col10);
			    	jsonObject.put("col11", col11);
			    	jsonObject.put("col12", col12);
			    	jsonArray.add(jsonObject);
			    }
			}
		}
	}
    JSONObject jo = new JSONObject();
    jo.put("totalProperty", total);
    jo.put("root", jsonArray);
	out.print(jo);
	return;
}
%>

