<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.text.ParseException"%>
<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String action = StringHelper.null2String(request.getParameter("action"));
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
initMap0();
if("search".equals(action)){
	JSONObject jsonObject = new JSONObject();
	String company = StringHelper.null2String(request.getParameter("gs"));//公司
	String conname = StringHelper.null2String(request.getParameter("cys"));//承运商
	String startdate = StringHelper.null2String(request.getParameter("ksrq"));//开始日期
	String enddate = StringHelper.null2String(request.getParameter("jsrq"));//结束日期
	String cartype = StringHelper.null2String(request.getParameter("yscx"));//运输车型
	jsonObject = search(company, conname, startdate, enddate, cartype);
	response.getWriter().write(jsonObject.toString());
	response.getWriter().flush();
	response.getWriter().close();							
	return ;
}else if("searchall".equals(action)){
	JSONObject jsonObject = new JSONObject();
	String startdate = StringHelper.null2String(request.getParameter("startdate"));
	String enddate = StringHelper.null2String(request.getParameter("enddate"));
	String cys = StringHelper.null2String(request.getParameter("conname"));
	String sqlwhere = "";
	if(!StringHelper.isEmpty(cys)){
		sqlwhere += " and requestid='"+cys+"' ";
	}
	String sql1 = "select requestid,company,concode,conname from uf_lo_consolidator t where exists(select 1 from formbase fb where fb.id=t.requestid and fb.isdelete=0) "+sqlwhere+" order by company asc";
	List list1 = baseJdbcDao.executeSqlForList(sql1);
	JSONArray jsonArray = new JSONArray();
	for(Object obj1:list1){
		Map map1 = (Map)obj1;
		String requestid = StringHelper.null2String(map1.get("requestid"));
		String plant = StringHelper.null2String(map1.get("company"));
		String conname = StringHelper.null2String(map1.get("conname"));
		String concode = StringHelper.null2String(map1.get("concode"));
		String sql2 = "select transittype from uf_lo_carrylimit where requestid='"+requestid+"' order by transittype asc";
		List list2 = baseJdbcDao.executeSqlForList(sql2);
		for(Object obj2:list2){
			Map map2 = (Map)obj2;
			String cartype = StringHelper.null2String(map2.get("transittype"));
			JSONObject jo = search(plant, requestid, startdate, enddate, cartype);
			jo.put("cartype", carMap.get(cartype));
			jo.put("plant", platMap.get(plant));
			jo.put("conname", conname);
			jo.put("concode", concode);
			jsonArray.add(jo);
		}
	}
	jsonObject.put("result", jsonArray);
	jsonObject.put("totalcount", jsonArray.size());
	response.getWriter().write(jsonObject.toString());
	response.getWriter().flush();
	response.getWriter().close();							
	return ;
}
%>
<%!
Map<String,String> carMap = new HashMap<String,String>();
Map<String,String> platMap = new HashMap<String,String>();
private double format(Object obj){
	double d = 0;
	try{
		BigDecimal bd = new BigDecimal(StringHelper.null2String(obj));   
		bd = bd.setScale(2,BigDecimal.ROUND_HALF_UP); 
		d = bd.doubleValue();
	}catch (Exception e) {
		d = 0;
	}
	return d;
}
private void initMap0(){
	String sql1 = "select id,objname from selectitem where typeid='402864d1491d17c001491d2ada1c000f'";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List list1 = baseJdbcDao.executeSqlForList(sql1);
	for(Object obj1:list1){
		Map map1 = (Map)obj1;
		String id = StringHelper.null2String(map1.get("id"));
		String objname = StringHelper.null2String(map1.get("objname"));
		carMap.put(id, objname);
	}
	String sql2 = "select id,objname from orgunittype";
	List list2 = baseJdbcDao.executeSqlForList(sql2);
	for(Object obj2:list2){
		Map map2 = (Map)obj2;
		String id = StringHelper.null2String(map2.get("id"));
		String objname = StringHelper.null2String(map2.get("objname"));
		platMap.put(id, objname);
	}
}
private JSONObject search(String plant,String conname,String startdate,String enddate,String cartype){
	JSONObject jsonObject = new JSONObject();
	String sql0 = "select * from v_z_cysxy t where (t.rconname='"+conname+"' or t.actname='"+conname+"') and t.cartype='"+cartype+"' and t.reqdate>='"+startdate+"' and t.reqdate<='"+enddate+"' and t.factory='"+plant+"'";
	System.out.println(sql0);
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List list0 = baseJdbcDao.executeSqlForList(sql0);
	double wtjds = 0,sjjds = 0,sjzqdhs = 0,sjzddcs = 0,jjcs = 0,yccs = 0;
	String jdl = "",dhl = "",zdl = "",ljjdjebl = "",jhjdjebl = "";
	double ljjdje = 0,zwtljje = 0,xyfs = 100;
	if(list0!=null&&list0.size()>0){
		for(Object obj0:list0){
			Map map0 = (Map)obj0;
			String rconname = StringHelper.null2String(map0.get("rconname"));
			String actname = StringHelper.null2String(map0.get("actname"));
			double money = NumberHelper.string2Double(StringHelper.null2String(map0.get("money")),0);
			if(rconname.equals(conname)){
				wtjds++;
				zwtljje += money;
				if(!actname.equals(conname)){
					jjcs++;
				}
			}
			if(actname.equals(conname)){
				sjjds++;
				ljjdje += money;
				String pickupdate = StringHelper.null2String(map0.get("pickupdate"));//提贷开始日期
				String pickuptime = StringHelper.null2String(map0.get("pickuptime"));//提贷开始时间
				String loadingno = StringHelper.null2String(map0.get("reqno"));
				String sql1 = "select printtime from uf_lo_ladingmain where loadingno='"+loadingno+"' and printtime is not null order by printtime asc";
				List list1 = baseJdbcDao.executeSqlForList(sql1);
				if(list1!=null&&list1.size()>0){
					Map map1 = (Map)list1.get(0);
					String print = StringHelper.null2String(map1.get("printtime"));
					String printdate = print.split(" ")[0];
					if(DateHelper.getDaysBetween(printdate, enddate)<=0){
						sjzqdhs ++;
						if(!StringHelper.isEmpty(pickupdate)){
							if(StringHelper.isEmpty(pickuptime)){
								long cz = DateHelper.getDaysBetween(printdate, pickupdate);
								if(cz>0){
									yccs ++;
								}
							}else{
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								try {
									Date date1 = sdf.parse(pickupdate+" "+pickuptime);
									Date date2 = sdf.parse(print);
									double cz = date2.getTime()-date1.getTime();
									if(cz>3*60*60*1000){
										yccs ++;
									}
								} catch (ParseException e) {
									e.printStackTrace();
								}
							}
						}
					}
				}
			}
		}
	}
	zwtljje = format(zwtljje);
	ljjdje = format(ljjdje);
	//sjzqdhs = sjjds;
	sjzddcs = sjzqdhs-yccs;
	try{
		jdl = format(sjjds/wtjds*100)+"%";
	}catch (Exception e) {
		jdl = "0.0%";
	}
	try{
		dhl = format(sjzqdhs/sjjds*100)+"%";
	}catch (Exception e) {
		dhl = "0.0%";
	}
	try{
		zdl = format(sjzddcs/sjzqdhs*100)+"%";
	}catch (Exception e) {
		zdl = "0.0%";
	}
	try{
		ljjdjebl = format(ljjdje/zwtljje*100)+"%";
	}catch (Exception e) {
		ljjdjebl = "0.0%";
	}
	xyfs-=yccs;
	if(yccs>3){
		xyfs-=5;
	}
	xyfs-=jjcs;
	if(jjcs>3){
		xyfs-=5;
	}
	jsonObject.put("wtjds", wtjds);
	jsonObject.put("sjjds", sjjds);
	jsonObject.put("jdl", jdl);
	jsonObject.put("sjzqdhs", sjzqdhs);
	jsonObject.put("dhl", dhl);
	jsonObject.put("sjzddcs", sjzddcs);
	jsonObject.put("zdl", zdl);
	jsonObject.put("ljjdje", ljjdje);
	jsonObject.put("zwtljje", zwtljje);
	jsonObject.put("ljjdjebl", ljjdjebl);
	jsonObject.put("jhjdjebl", jhjdjebl);
	jsonObject.put("xyfs", xyfs);
	String sql1 = "select planrate from uf_lo_carrylimit  where transittype='"+cartype+"' and requestid='"+conname+"'";
	List list1 = baseJdbcDao.executeSqlForList(sql1);
	if(list1!=null&&list1.size()>0){
		Map map1 = (Map)list1.get(0);
		jhjdjebl = StringHelper.null2String(map1.get("planrate"));
	}
	jsonObject.put("jhjdjebl", jhjdjebl);
	return jsonObject;
}
%>
