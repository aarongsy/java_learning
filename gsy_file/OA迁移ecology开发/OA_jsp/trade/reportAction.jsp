<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.base.sequence.SequenceService"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>

<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	String action = request.getParameter("action").trim();
	
	BaseJdbcDao	baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
   if(action.endsWith("getList")){
		int start = NumberHelper.string2Int(request.getParameter("start"), 0);
		int limit = NumberHelper.string2Int(request.getParameter("limit"), 20)+start;
		String requestid = request.getParameter("requestid");
		String sql = "select * from (select A.*,rownum r from (select * from uf_tr_purchaselist  where  requestid='"+requestid+"'  order by rowindex ) A where rownum<="+limit+") B where r>"+start+" ";
	    List<Map> list = baseJdbcDao.executeSqlForList(sql);
	    int total =NumberHelper.string2Int( baseJdbcDao.executeForMap("select count(id) as total from uf_tr_purchaselist  where requestid='"+requestid+"'").get("total")+"");
		JSONArray jsonArray = new JSONArray();
	    for(Map map : list){
	    	JSONObject o = new JSONObject();
	    	o.put("orderitem",StringHelper.null2String(map.get("orderitem")));
	    	o.put("materialno",StringHelper.null2String(map.get("materialno")));
	    	o.put("ordershort",StringHelper.null2String(map.get("ordershort")));
	    	o.put("quantity",StringHelper.null2String(map.get("quantity")));
	    	o.put("unit",StringHelper.null2String(map.get("unit")));
	    	o.put("delidate",StringHelper.null2String(map.get("delidate")));
	    	o.put("unitprice",StringHelper.null2String(map.get("unitprice")));
	    	o.put("currency",StringHelper.null2String(map.get("currency")));
	    	o.put("total",StringHelper.null2String(map.get("total")));
	    	o.put("buynum",StringHelper.null2String(map.get("buynum")));
	    	o.put("buyunit",StringHelper.null2String(map.get("buyunit")));
	    	o.put("innerorder",StringHelper.null2String(map.get("innerorder")));
	    	o.put("assetsno",StringHelper.null2String(map.get("assetsno")));
	    	o.put("kmfp",StringHelper.null2String(map.get("kmfp")));
	    	o.put("runningno",StringHelper.null2String(map.get("runningno")));
	    	o.put("orderno",StringHelper.null2String(map.get("orderno")));
	    	o.put("ordertype",StringHelper.null2String(map.get("ordertype")));
	    	o.put("ordertypedes",StringHelper.null2String(map.get("ordertypedes")));
	    	o.put("companyname",StringHelper.null2String(map.get("companyname")));
	    	o.put("company",StringHelper.null2String(map.get("company")));
	    	o.put("paymentcode",StringHelper.null2String(map.get("paymentcode")));
	    	o.put("paymentnode",StringHelper.null2String(map.get("paymentnode")));
	    	o.put("condition1",StringHelper.null2String(map.get("condition1")));
	    	o.put("condition2",StringHelper.null2String(map.get("condition2")));
	    	o.put("suppliercode",StringHelper.null2String(map.get("suppliercode")));
	    	o.put("suppliername",StringHelper.null2String(map.get("suppliername")));
	    	o.put("applytype",StringHelper.null2String(map.get("applytype")));
	    	o.put("applyno",StringHelper.null2String(map.get("applyno")));
	    	o.put("applyitem",StringHelper.null2String(map.get("applyitem")));
	    	o.put("comtype",StringHelper.null2String(map.get("comtype")));
	    	o.put("reqcom",StringHelper.null2String(map.get("reqcom")));
	    	o.put("stateflag",StringHelper.null2String(map.get("stateflag")));
	    	
	    	jsonArray.add(o);
		}
		
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("totalProperty", total);
		jsonObject.put("root", jsonArray);

		out.print(jsonObject);
		return;
	}else if(action.equals("getFreigthList")){//运费清帐暂估记帐明细
		int start = NumberHelper.string2Int(request.getParameter("start"), 0);
		int limit = NumberHelper.string2Int(request.getParameter("limit"), 20)+start;
		String requestid = request.getParameter("requestid");
		String flagid = request.getParameter("flagid");
		String flagsql = "";
		if(!StringHelper.isEmpty(flagid)){
			flagsql = " and flagid='"+flagid+"' ";
		}
		String sql = "select * from (select A.*,rownum r from (select * from uf_lo_zgkeepclean   where  requestid='"+requestid+"'"+flagsql+" order by rowindex ) A where rownum<="+limit+") B where r>"+start+" ";
	    List<Map> list = baseJdbcDao.executeSqlForList(sql);
	    int total =NumberHelper.string2Int( baseJdbcDao.executeForMap("select count(id) as total from uf_lo_zgkeepclean   where requestid='"+requestid+"'"+flagsql+"").get("total")+"");
		JSONArray jsonArray = new JSONArray();
	    for(Map map : list){
	    	JSONObject o = new JSONObject();
	    	o.put("subject",StringHelper.null2String(map.get("subject")));
	    	o.put("amount",StringHelper.null2String(map.get("amount")));
	    	o.put("chargecode",StringHelper.null2String(map.get("chargecode")));
	    	o.put("notaxamount",StringHelper.null2String(map.get("notaxamount")));
	    	o.put("saletax",StringHelper.null2String(map.get("saletax")));
	    	o.put("costcentre",StringHelper.null2String(map.get("costcentre")));
	    	o.put("purchorder",StringHelper.null2String(map.get("purchorder")));
	    	o.put("saleorder",StringHelper.null2String(map.get("saleorder")));
	    	o.put("itemno",StringHelper.null2String(map.get("itemno")));
	    	o.put("projecttext",StringHelper.null2String(map.get("projecttext")));
	    	o.put("isflag",StringHelper.null2String(map.get("isflag")));
	    	jsonArray.add(o);
		}
		
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("totalProperty", total);
		jsonObject.put("root", jsonArray);

		out.print(jsonObject);
		return;
	}else if(action.equals("getunlodingList")){//运费清帐装卸暂估明细
		int start = NumberHelper.string2Int(request.getParameter("start"), 0);
		int limit = NumberHelper.string2Int(request.getParameter("limit"), 20)+start;
		String requestid = request.getParameter("requestid");
		String sql = "select * from (select A.*,rownum r from (select * from uf_lo_loadclean   where  requestid='"+requestid+"'  order by rowindex ) A where rownum<="+limit+") B where r>"+start+" ";
	    List<Map> list = baseJdbcDao.executeSqlForList(sql);
	    int total =NumberHelper.string2Int( baseJdbcDao.executeForMap("select count(id) as total from uf_lo_loadclean   where requestid='"+requestid+"'").get("total")+"");
		JSONArray jsonArray = new JSONArray();
	    for(Map map : list){
	    	JSONObject o = new JSONObject();
	    	o.put("loadplanno",StringHelper.null2String(map.get("loadplanno")));
	    	o.put("invoiceno",StringHelper.null2String(map.get("invoiceno")));
	    	o.put("principle",StringHelper.null2String(map.get("principle")));
	    	o.put("amount",StringHelper.null2String(map.get("amount")));
	    	o.put("notaxamount",StringHelper.null2String(map.get("notaxamount")));
	    	o.put("feetype",StringHelper.null2String(map.get("feetype")));
	    	o.put("voucherno",StringHelper.null2String(map.get("voucherno")));
	    	o.put("createdate",StringHelper.null2String(map.get("createdate")));
	    	o.put("linecode",StringHelper.null2String(map.get("linecode")));
	    	o.put("flagid", StringHelper.null2String(map.get("flagid")));
	    	jsonArray.add(o);
	    }	
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("totalProperty", total);
		jsonObject.put("root", jsonArray);

		out.print(jsonObject);
		return;
	}else if("getChargeCode".equals(action)){
		String invoiceno = StringHelper.null2String(request.getParameter("invoiceno")).trim();//暂估单号
		String sql = "select t1.* from uf_lo_budgetdetail t1 left join uf_lo_budget t2 on t1.requestid=t2.requestid where t2.invoiceno='"+invoiceno+"'"
			+" and exists(select 1 from formbase fb where fb.id=t2.requestid and fb.isdelete=0) order by chargecode asc";
		JSONArray jsonArray = new JSONArray();
		List<Map> list = baseJdbcDao.executeSqlForList(sql);
	    for(Map map : list){
	    	JSONObject o = new JSONObject();
	    	o.put("subject",StringHelper.null2String(map.get("subject")));
	    	o.put("amount",StringHelper.null2String(map.get("amount")));
	    	o.put("chargecode",StringHelper.null2String(map.get("chargecode")));
	    	o.put("notaxamount",StringHelper.null2String(map.get("notaxamount")));
	    	o.put("saletax",StringHelper.null2String(map.get("saletax")));
	    	o.put("costcentre",StringHelper.null2String(map.get("costcentre")));
	    	o.put("purchorder",StringHelper.null2String(map.get("purchorder")));
	    	o.put("saleorder",StringHelper.null2String(map.get("saleorder")));
	    	o.put("itemno",StringHelper.null2String(map.get("itemno")));
	    	o.put("projecttext",StringHelper.null2String(map.get("projecttext")));
	    	o.put("isflag",StringHelper.null2String(map.get("isflag")));
	    	o.put("wlh",StringHelper.null2String(map.get("wlh")));
	    	jsonArray.add(o);
	    }	
	    int total = 0;
	    if(list!=null){
	    	total = list.size();
	    }
	    JSONObject jsonObject = new JSONObject();
		jsonObject.put("totalProperty", total);
		jsonObject.put("root", jsonArray);
		out.print(jsonObject);
		return;
	}else if("getCleanWlh".equals(action)){
		String requestid = StringHelper.null2String(request.getParameter("requestid"));//清账requestid
		String sql = "select * from uf_lo_cleanwlh where requestid='"+requestid+"'";
		List<Map> list = baseJdbcDao.executeSqlForList(sql);
		JSONArray jsonArray = new JSONArray();
	    for(Map map : list){
	    	JSONObject o = new JSONObject();
	    	o.put("wlh",StringHelper.null2String(map.get("wlh")));
	    	o.put("wlje",StringHelper.null2String(map.get("wlje")));
	    	o.put("wlpz",StringHelper.null2String(map.get("wlpz")));
	    	jsonArray.add(o);
	    }	
	    int total = 0;
	    if(list!=null){
	    	total = list.size();
	    }
	    JSONObject jsonObject = new JSONObject();
		jsonObject.put("totalProperty", total);
		jsonObject.put("root", jsonArray);
		out.print(jsonObject);
		return;
	}
%>
