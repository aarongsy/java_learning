<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.app.weight.service.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.logi.LogiSendCarAction"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.app.sap.product.*"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	if (action.equals("updelivery")){//交运单	
		String ids=StringHelper.null2String(request.getParameter("ids"));
		try {
			Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG("Z_CCP_DELIVERY_DG");
			String sql = "select * from uf_lo_provecastlog where instr('"+ids+"',requestid)>0";
			List list = dataService.getValues(sql);
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				Map<String,String> inMap = new HashMap<String,String>();
				inMap.put("VBELN_VL",StringHelper.null2String(map.get("orderno")));
				inMap.put("POSNR_VL",StringHelper.null2String(map.get("items")));
				inMap.put("GARAGE_N",StringHelper.null2String(map.get("carname")));
				inMap.put("CAR_NO",StringHelper.null2String(map.get("carno")));
				inMap.put("LFIMG",StringHelper.null2String(map.get("realnum")));
				inMap.put("GEWEI",StringHelper.null2String(map.get("unit")));
				inMap.put("NETWEI",StringHelper.null2String(map.get("yetloadnum")));
				inMap.put("PACK",StringHelper.null2String(map.get("pack")));
				
				Map remap = app.upData(inMap);
				if(remap != null){
//					pcl.setZorderno(StringHelper.null2String(remap.get("EBELN")));	 //回写单号
//					pcl.setZitems(StringHelper.null2String(remap.get("EBELP")));	 //回写项次
//					pcl.setZmark(StringHelper.null2String(remap.get("ZMARK")));	 //回写标示
//					pcl.setZmessage(StringHelper.null2String(remap.get("ZMESS")));	 //	回写消息
					
					String upsql = "update uf_lo_provecastlog set "+
								"zorderno = '"+StringHelper.null2String(remap.get("EBELN"))+"',"+
								"zitems = '"+StringHelper.null2String(remap.get("EBELP"))+"',"+
								"zmark = '"+StringHelper.null2String(remap.get("ZMARK"))+"',"+
								"zmessage = '"+StringHelper.null2String(remap.get("ZMESS"))+"' "+
								"where requestid = '"+StringHelper.null2String(map.get("requestid"))+"'";
					dataService.executeSql(upsql);
				}
			}
		} catch (Exception e) {
			//jo.put("msg",flag);
			e.printStackTrace();
		}
	}
	if (action.equals("upproduct")){//采购订单	
		String ids=StringHelper.null2String(request.getParameter("ids"));
		try {
			Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
			String sql = "select * from uf_lo_provecastlog where instr('"+ids+"',requestid)>0";
			List list = dataService.getValues(sql);
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				Map<String,String> inMap = new HashMap<String,String>();
				
				inMap.put("EBELN",StringHelper.null2String(map.get("orderno")));
				inMap.put("EBELP",StringHelper.null2String(map.get("items")));
				inMap.put("LGORT",StringHelper.null2String(map.get("storageloc")));
				inMap.put("WERKS",StringHelper.null2String(map.get("plant")));
				inMap.put("LFIMG",StringHelper.null2String(map.get("yetloadnum")));
				inMap.put("CAR_NO",StringHelper.null2String(map.get("carno")));
				inMap.put("BUDAT",StringHelper.null2String(map.get("deliverydate")).replace("-", ""));
				inMap.put("GEWEI",StringHelper.null2String(map.get("unit")));
				inMap.put("PACK",StringHelper.null2String(map.get("pack")));
				
				Map remap = app.upData(inMap);
				if(remap != null){
//					pcl.setZorderno(StringHelper.null2String(remap.get("VBELN_VL")));	 //回写单号
//					pcl.setZitems(StringHelper.null2String(remap.get("POSNR_VL")));	 //回写项次
//					pcl.setZmark(StringHelper.null2String(remap.get("ZMARK")));	 //回写标示
//					pcl.setZmessage(StringHelper.null2String(remap.get("ZMESS")));	 //	回写消息
					
					String upsql = "update uf_lo_provecastlog set "+
								"zorderno = '"+StringHelper.null2String(remap.get("VBELN_VL"))+"',"+
								"zitems = '"+StringHelper.null2String(remap.get("POSNR_VL"))+"',"+
								"zmark = '"+StringHelper.null2String(remap.get("ZMARK"))+"',"+
								"zmessage = '"+StringHelper.null2String(remap.get("ZMESS"))+"' "+
								"where requestid = '"+StringHelper.null2String(map.get("requestid"))+"'";
					dataService.executeSql(upsql);
				}
			}
		} catch (Exception e) {
			//jo.put("msg",flag);
			e.printStackTrace();
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write("11");
		response.getWriter().flush();
		response.getWriter().close();
	}

%>
