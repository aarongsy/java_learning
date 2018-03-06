<%@page import="java.math.BigDecimal"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.eweaver.app.logi.UpService"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
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
<%@ page import="com.eweaver.app.sap.product.Upsaplogdetail"%>
<%@page import="javax.sound.midi.SysexMessage"%>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();
	String object = "0";
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	String userId = BaseContext.getRemoteUser().getId();
	if (action.equals("updelivery")){//交运单	
		String ids=StringHelper.null2String(request.getParameter("ids"));
		//UpService upService = new UpService();
		String jsonString = upDelivery(ids);
		response.getWriter().print(jsonString);
		return;
	}
	if (action.equals("upproduct")){//采购订单	
		String ids=StringHelper.null2String(request.getParameter("ids"));
		//UpService upService = new UpService();
		String jsonString = upProduct(ids);
		response.getWriter().print(jsonString);
		return;
	}
	if (action.equals("forceupdelivery")){//强制上抛交运单	
		String ids=StringHelper.null2String(request.getParameter("ids"));
		//UpService upService = new UpService();
		String jsonString = upDelivery(ids,true);
		response.getWriter().print(jsonString);
		return;
	}

%>
<%!
	String state_yes = "40288098276fc2120127704884290210";
	String state_no = "40288098276fc2120127704884290211";
	Logger logger = Logger.getLogger("上抛sap日志");
	/**
	 * 交运单上抛
	 * @param requestid
	 */
	private String upDelivery(String ids){
		return upDelivery(ids,false);
	}
	private String upDelivery(String ids,boolean force){
		if(force){
			System.out.println("------------------- 强制上抛   ------------------");
		}
		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService dataService = new DataService();
		JSONObject jsonObject = new JSONObject();
		
		String sql = "select distinct orderno from uf_lo_provecastlogz where instr('"+ids+"',requestid)>0";
		List list = baseJdbcDao.executeSqlForList(sql);
		for(int i=0;i<list.size();i++){
			Map<String,String> resultMap = new HashMap<String, String>();
			resultMap.put("success", "0");
			Map map = (Map)list.get(i);
			String orderno = StringHelper.null2String(map.get("orderno"));//单号
			//String items = StringHelper.null2String(map.get("items"));
			//String runningno = orderno+items;
			try {
				String detailsql = "select wm_concat(orderno || items) runningnos from uf_lo_provecastlogz where orderno='"+orderno+"' and instr('"+ids+"',requestid)>0 and state='"+state_yes+"'";
				List detaillist = baseJdbcDao.executeSqlForList(detailsql);
				if ( detaillist.size() >0) {
					Map detailmap = (Map)detaillist.get(0);
					String runningnos = StringHelper.null2String(detailmap.get("runningnos"));
					if( !"".equals(runningnos) ) {
						map.put("info", runningnos+"该单已上抛");
						jsonObject.put(orderno, map);
						continue;
					}
				}
				/*
				String requestid = StringHelper.null2String(map.get("requestid"));
				String upStatus = StringHelper.null2String(map.get("state"));//是否(已)上抛
				if(state_yes.equals(upStatus)){//是
					map.put("info", runningno+"该单已上抛");
					jsonObject.put(runningno, map);
					continue;
				}else{//否//40288098276fc2120127704884290211
					
				}
				*/
				//Map canMap = canUp(orderno,items);
				Map canMap = canUp(orderno);
				String success = StringHelper.null2String(canMap.get("success"));
				//double jhyzl_all = 0;
				if(!"1".equals(success)&&!force){
					map.put("info", StringHelper.null2String(canMap.get("info")));
					//jsonObject.put(runningno, map);
					jsonObject.put(orderno, map);
					continue;
				}
				/*jhyzl_all = NumberHelper.string2Double(canMap.get("jhyzl_all"), 0);
				if(jhyzl_all==0){
					System.out.println("------------------- 上抛实际交货数为0 ------------------");
					map.put("info", runningno+"上抛实际交货数为0");
					jsonObject.put(runningno, map);
					continue;
				}
				*/
				String runningnostr = StringHelper.null2String(canMap.get("runningnostr"));
				String orderstr = StringHelper.null2String(canMap.get("orderstr"));
				String itemstr = StringHelper.null2String(canMap.get("itemstr"));
				String huixieslstr = StringHelper.null2String(canMap.get("huixieslstr"));

				String[] arrrunningno =  runningnostr.split("/");
				String[] arrorderstr =  orderstr.split("/");
				String[] arritemstr =  itemstr.split("/");
				String[] arrhuixieslstr =  huixieslstr.split("/");

				boolean iflag = true;
				Map<String,Double> newMap = new HashMap<String, Double>();
				for(int k=0;k<arrrunningno.length;k++){					
					double jhyzl_all = 0;
					jhyzl_all = NumberHelper.string2Double(arrhuixieslstr[k], 0);					
					String tmprunningno = StringHelper.null2String(arrrunningno[k]);
					if(jhyzl_all==0){
						System.out.println("------------------- 上抛实际交货数为0 ------------------");
						map.put("info", tmprunningno+"上抛实际交货数为0");
						jsonObject.put(tmprunningno, map);
						iflag = false;
						continue;
					}
					newMap.put(tmprunningno,jhyzl_all);	
				}
				if(!iflag){
					continue;
				}
				//Map<String,String> inMap = new HashMap<String,String>();				
				if(true){//可以上抛或手动强制上抛
					System.out.println("------------------- 可以上抛   ------------------");
					String jydsql = "select * from uf_lo_provecastlogz where orderno = '"+orderno+"'";
					List jydlist = baseJdbcDao.executeSqlForList(jydsql);
					List<Map<String, String>> inMapList = new ArrayList<Map<String, String>>(); 
					for( int k=0; k<jydlist.size(); k++ ){
						Map<String,String> inMap = new HashMap<String,String>();
						Map jydmap = (Map)jydlist.get(k);
						String jydorder = StringHelper.null2String(jydmap.get("orderno"));
						String jyditem = StringHelper.null2String(jydmap.get("items"));
						String tmprunningno = jydorder + jyditem;
						System.out.println("--交运单上抛记录---jydorder="+jydorder +"  jyditem="+jyditem +" tmprunningno="+tmprunningno + " newMap.get("+tmprunningno+")="+newMap.get(tmprunningno));
						inMap.put("VBELN_VL",StringHelper.null2String(jydmap.get("orderno")));	//单号
						inMap.put("POSNR_VL",StringHelper.null2String(jydmap.get("items")));	//项次
						inMap.put("GARAGE_N",StringHelper.null2String(jydmap.get("carname")));	//车行
						inMap.put("CAR_NO",StringHelper.null2String(jydmap.get("carno")));		//车号
						inMap.put("LFIMG",StringHelper.null2String(newMap.get(tmprunningno)));	//实际交货数
						inMap.put("GEWEI",StringHelper.null2String(jydmap.get("unit")));		//单位
						inMap.put("NETWEI",StringHelper.null2String(jydmap.get("nw")));//净重
						inMap.put("PACK",StringHelper.null2String(jydmap.get("pack")));		//包代			
						//print(inMap);	
						inMapList.add(inMap);						
					}					
					System.out.println( "--交运单SAP upload start：orderno="+orderno+" inMapList.size()="+inMapList.size() );					
					Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG("Z_CCP_DELIVERY_DG");
					System.out.println( "--交运单SAP upload end orderno="+orderno );
					//List<Upsaplogdetail> upSaplogs=app.upData(inMap);
					List<Upsaplogdetail> upSaplogs=app.upData(inMapList);
					boolean ok = true;
					String info = "";
					if(upSaplogs!=null&&!upSaplogs.isEmpty()){
						for (int j = 0; j < upSaplogs.size(); j++) {
							if(!"S".equals(upSaplogs.get(j).getZmark())){
								ok = false;
								info = upSaplogs.get(j).getZmessage();
							}
							String orno = StringHelper.null2String(upSaplogs.get(j).getZorderno());
							String oritem = StringHelper.null2String(upSaplogs.get(j).getZitems());
							String reqid = dataService.getValue("select requestid from uf_lo_provecastlogz where orderno = '"+orno+"' and items='"+oritem+"'");
							StringBuffer sbf = new StringBuffer();
							sbf.append("insert into uf_lo_upsaplogdetail");
							sbf.append("(id,requestid,zorderno,zitems,zmark,zmessage) values");
							sbf.append("('").append(IDGernerator.getUnquieID()).append("',");
							//sbf.append("'").append(StringHelper.null2String(map.get("requestid"))).append("',");
							sbf.append("'").append(reqid).append("',");
							sbf.append("'").append(upSaplogs.get(j).getZorderno()).append("',");
							sbf.append("'").append(upSaplogs.get(j).getZitems()).append("',");
							sbf.append("'").append(upSaplogs.get(j).getZmark()).append("',");
							sbf.append("'").append(upSaplogs.get(j).getZmessage()).append("')");
							baseJdbcDao.update(sbf.toString());
						}						
					}else{
						ok = false;
						info = "sap返回为空!";						
					}
					if(ok){
						String currentDateTime = DateHelper.getCurDateTime();
						//String resSql = "update uf_lo_provecastlogz set state='"+state_yes+"',upcasttime='"+currentDateTime+"' where requestid='"+requestid+"'";
						String resSql = "update uf_lo_provecastlogz set state='"+state_yes+"',upcasttime='"+currentDateTime+"' where orderno='"+orderno+"'";
						baseJdbcDao.update(resSql);
						resultMap.put("success", "1");						
					}else{
						resultMap.put("info", info);						
					}
				}				
			} catch (Exception e) {
				resultMap.put("info", e.getMessage());
			}
			//jsonObject.put(runningno, resultMap);
			jsonObject.put(orderno, resultMap);
		}
		logger.error("交运单上抛:"+jsonObject.toString());
		return jsonObject.toString();
	}
	
	/**
	 * 采购订单上抛
	 * @param requestid
	 */
	private String upProduct(String ids){
		JSONObject jsonObject = new JSONObject();
		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select uf_lo_provecastlogz.*, uf_lo_purchase.materialno,uf_lo_purchase.purchasetype,uf_lo_purchase.memo2 "+
				  "from uf_lo_provecastlogz left join uf_lo_purchase "+
				  "on uf_lo_provecastlogz.orderno = uf_lo_purchase.purchaseorder "+
				  "and uf_lo_provecastlogz.items = uf_lo_purchase.purchaseitem "+
				  "where instr('"+ids+"', uf_lo_provecastlogz.requestid) > 0";
		List list = baseJdbcDao.executeSqlForList(sql);
		for(int i=0;i<list.size();i++){
			Map<String,String> resultMap = new HashMap<String, String>();
			resultMap.put("success", "0");
			Map map = (Map)list.get(i);
			String orderno = StringHelper.null2String(map.get("orderno"));
			String items = StringHelper.null2String(map.get("items"));
			String runningno = orderno+items;
			String memo2 = StringHelper.null2String(map.get("memo2"));			
			try {
				if( "X".equals(memo2) ) {
					resultMap.put("info", runningno+"该单需做请购单位批次确认单");
					jsonObject.put(runningno, resultMap);
					continue;
				}
				String requestid = StringHelper.null2String(map.get("requestid"));
				Map<String,String> inMap = new HashMap<String,String>();
				String upStatus = StringHelper.null2String(map.get("state"));//是否(已)上抛
				if(state_yes.equals(upStatus)){//是
					resultMap.put("info", runningno+"该单已上抛");
					jsonObject.put(runningno, resultMap);
					continue;
				}else{//否//40288098276fc2120127704884290211
					
				}
				String bangmark = "";	//过磅标识
				String gongchang = "";
				String ckb = "";//仓库别
				String ph = "";//批号
				List listdtail = baseJdbcDao.executeSqlForList("select bangmark,plant,storageloc,batchnum,requestid,iscomp from uf_lo_purchase where purchaseorder = '"+ StringHelper.null2String(map.get("orderno")) +"' and purchaseitem='"+items+"'");
				String purchaseid = "";
				String iscomp = "";
				if(listdtail.size()>0){
					Map mapdtail = (Map)listdtail.get(0);
					bangmark = StringHelper.null2String(mapdtail.get("bangmark"));
					gongchang = StringHelper.null2String(mapdtail.get("plant"));
					ckb = StringHelper.null2String(mapdtail.get("storageloc"));
					ph = StringHelper.null2String(mapdtail.get("batchnum"));
					purchaseid = StringHelper.null2String(mapdtail.get("requestid"));
					iscomp = StringHelper.null2String(mapdtail.get("iscomp"));
				}
				//if("0".equals(bangmark)){
				if(true){//过不过磅都上抛
					//ZC14,ZC16,ZP14,ZP16,ZY14,ZY16
					boolean ok = true;
					String info = "";
					/*if("ZC14".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZC16".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZP14".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZP16".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZY14".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZY16".equals(StringHelper.null2String(map.get("purchasetype")))){*/
					if("ZC14".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZP14".equals(StringHelper.null2String(map.get("purchasetype")))
							||"ZY14".equals(StringHelper.null2String(map.get("purchasetype")))
							||"40288098276fc2120127704884290210".equals(iscomp)){//转储的或者委外组件
						if("ZC14".equals(StringHelper.null2String(map.get("purchasetype")))
								||"ZP14".equals(StringHelper.null2String(map.get("purchasetype")))
								||"ZY14".equals(StringHelper.null2String(map.get("purchasetype")))){//转储
							inMap.put("FLAG", "A");
							inMap.put("PO_ITEM",items);		//	采购凭证的项次
						}else{
							inMap.put("FLAG", "B");
							inMap.put("PO_ITEM",items.substring(3,items.length()));		//	采购凭证的项次
						}
						inMap.put("MATERIAL",StringHelper.null2String(map.get("materialno")));	//	物料号？？？
						inMap.put("BATCH",ph);			//	批号 ？？？
						inMap.put("PLANT",gongchang);			//	工厂
						inMap.put("STGE_LOC",ckb);	//	库存地点
						inMap.put("PO_NUMBER",StringHelper.null2String(map.get("orderno")));	//	采购订单编号
						inMap.put("ENTRY_QNT",StringHelper.null2String(map.get("yetloadnum")));	//	数量
						inMap.put("ENTRY_UOM",StringHelper.null2String(map.get("unit")));		//	单位
						Purchase_Z_CCP_MVT_DG app = new Purchase_Z_CCP_MVT_DG("Z_CCP_MVT_DG");
	
						print(inMap);
						List<Upsaplogdetail> upSaplogs = app.upData(inMap);
						if(upSaplogs!=null&&!upSaplogs.isEmpty()){
							for (int j = 0; j < upSaplogs.size(); j++) {
								if(!"S".equals(upSaplogs.get(j).getZmark())){
									ok = false;
									info = upSaplogs.get(j).getZmessage();
								}
								StringBuffer sbf = new StringBuffer();
								sbf.append("insert into uf_lo_upsaplogdetail");
								sbf.append("(id,requestid,zorderno,zmark,zmessage) values");
								sbf.append("('").append(IDGernerator.getUnquieID()).append("',");
								sbf.append("'").append(StringHelper.null2String(map.get("requestid"))).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZorderno()).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZmark()).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZmessage()).append("')");
								baseJdbcDao.update(sbf.toString());
							}
						}else{
							ok = false;
							info = "sap返回为空!";
						}
					}else{
						inMap.put("EBELN",StringHelper.null2String(map.get("orderno")));
						inMap.put("EBELP",items);
						inMap.put("LGORT",StringHelper.null2String(map.get("storageloc")));
						inMap.put("WERKS",gongchang);
						inMap.put("LFIMG",StringHelper.null2String(map.get("yetloadnum")));
						inMap.put("CAR_NO",StringHelper.null2String(map.get("carno")));
						String currentdate = DateHelper.getCurrentDate();
						inMap.put("BUDAT",StringHelper.replaceString(StringHelper.null2String(currentdate),"-",""));
						inMap.put("GEWEI",StringHelper.null2String(map.get("unit")));
						inMap.put("PACK",StringHelper.null2String(map.get("pack")));
						inMap.put("LSMNG",StringHelper.null2String(map.get("nw"))); //过磅净重
						Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
						print(inMap);
						List<Upsaplogdetail> upSaplogs = app.upData(inMap);
						if(upSaplogs!=null&&!upSaplogs.isEmpty()){
							for (int j = 0; j < upSaplogs.size(); j++) {
								if(!"S".equals(upSaplogs.get(j).getZmark())){
									ok = false;
									info = upSaplogs.get(j).getZmessage();
								}
								StringBuffer sbf = new StringBuffer();
								sbf.append("insert into uf_lo_upsaplogdetail");
								sbf.append("(id,requestid,zorderno,zitems,zmark,zmessage) values");
								sbf.append("('").append(IDGernerator.getUnquieID()).append("',");
								sbf.append("'").append(StringHelper.null2String(map.get("requestid"))).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZorderno()).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZitems()).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZmark()).append("',");
								sbf.append("'").append(upSaplogs.get(j).getZmessage()).append("')");
								baseJdbcDao.update(sbf.toString());
							}
						}else{
							ok = false;
							info = "sap返回为空!";
						}
					}
					if(ok){
						String currentDateTime = DateHelper.getCurDateTime();
						String resSql = "update uf_lo_provecastlogz set state='"+state_yes+"',upcasttime='"+currentDateTime+"' where requestid='"+requestid+"'";
						baseJdbcDao.update(resSql);
						resultMap.put("success", "1");
					}else{
						resultMap.put("info", info);
					}
				}else{
					resultMap.put("info", "未过磅");
				}
			} catch (Exception e) {
				resultMap.put("info", e.getMessage());
			}
			jsonObject.put(runningno, resultMap);
		}
		logger.error("采购单上抛:"+jsonObject.toString());
		return jsonObject.toString();
	}
	
	private double format(double d,int len){
		BigDecimal b = new BigDecimal(d);  
		double f = b.setScale(len,BigDecimal.ROUND_HALF_UP).doubleValue();
		return f;
	}
	
	private void print(Map map){
		logger.error("------------sap上抛参数记录开始------------");
		if(map!=null){
			Iterator it = map.keySet().iterator();
			while(it.hasNext()){
				String key = it.next()+"";
				String value = map.get(key)+"";
				logger.error("key:"+key+";value:"+value);
			}
		}
		logger.error("------------sap上抛参数记录结束------------");
	}
	
	/**
	 * 判断交运单是否可以上抛
	 * @param orderno
	 * @return
	 */
	//private Map canUp(String orderno,String items){
	private Map canUp(String orderno){
		Map<String,String> resultMap = new HashMap<String, String>();
		resultMap.put("success", "1");
		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		List listdtail = baseJdbcDao.executeSqlForList("select * from uf_lo_delivery where deliveryno = '"+ orderno +"'");
		String runningnostr = "";
		String orderstr = "";
		String itemstr = "";
		String huixieslstr = "";
		String errinfo = "";
		for(Object object:listdtail){
			Map mapdtail = (Map)object;
			String runningno = StringHelper.null2String(mapdtail.get("runningno"));
			String materialtype = StringHelper.null2String(mapdtail.get("materialtype"));
			String thisitems = StringHelper.null2String(mapdtail.get("deliveryitem"));
			double sjjhs = NumberHelper.string2Double(mapdtail.get("quantity"), 0);
			double jhyzl_all = 0;
			double huixiesl = 0;
			if("Z02".equals(materialtype)||"Z01".equals(materialtype)){//固定包装//散装
				String runningSql = "select deliverdnum,plannum,ispond,reqno from v_uf_lo_loalplan where RUNNINGNO='"+runningno+"' and exists(select 1 from requestbase rb where rb.isfinished=1 and rb.id=requestid and rb.isdelete=0) and nvl(state,0)!='402864d1493b112a01493bfaf09b000c'";
				List runningList = baseJdbcDao.executeSqlForList(runningSql);
				for(Object obj:runningList){
					Map runningMap = (Map)obj;
					String ispond = StringHelper.null2String(runningMap.get("ispond"));//是否过磅
					String reqno = StringHelper.null2String(runningMap.get("reqno"));//装卸计划编号
					if("40288098276fc2120127704884290210".equals(ispond)){//是
						String ladSql = "select 1 from uf_lo_ladingmain where loadingno='"+reqno+"' and nvl(status,0)!='40285a8d4d5b981f014d6a12a9ec0009' and nvl(state,0)!='402864d14940d265014941e9d82900db'";
						List ladList = baseJdbcDao.executeSqlForList(ladSql);
						if(ladList!=null&&ladList.size()>0){
							System.out.println(reqno+"需要过磅的装卸计划存在未过磅的提入单不计入总量!");
							continue;//需要过磅的装卸计划存在未过磅的提入单不计入总量
						}
					}else if("40288098276fc2120127704884290211".equals(ispond)){//否
						String ladSql = "select requestid from uf_lo_ladingmain where loadingno='"+reqno+"'";
						List ladList = baseJdbcDao.executeSqlForList(ladSql);
						boolean b = true;
						for(Object ladObj:ladList){
							Map ladMap = (Map)ladObj;							
							String ladRequestid = StringHelper.null2String(ladMap.get("requestid"));
							String spotSql = "select 1 from uf_lo_spotmanager where ladingno='"+ladRequestid+"' and state='402864d14940d265014941e9d82900da'";
							List spotList = baseJdbcDao.executeSqlForList(spotSql);
							if(spotList==null||spotList.isEmpty()){
								b = false;
								break;
							}
						}
						if(!b){
							System.out.println(reqno+"不需要过磅的装卸计划存在未收发货审核通过的提入单不计入总量!");
							continue;//不需要过磅的装卸计划存在未收发货审核通过的提入单不计入总量
						}
					}else{
						System.out.println(reqno+"是否过磅标识错误!");
						continue;
					}
					double jhyzl = NumberHelper.string2Double(runningMap.get("plannum"), 0);//原计划运载量
					double jhyzlhx = NumberHelper.string2Double(runningMap.get("deliverdnum"), 0);//计划运载量(回写)
					jhyzl_all += jhyzl;
					if("Z02".equals(materialtype)){//固定包装
						huixiesl += jhyzl;
					}else if("Z01".equals(materialtype)){//散装
						huixiesl += jhyzlhx;
					}
				}
				jhyzl_all = format(jhyzl_all, 4);
				if(jhyzl_all<sjjhs){
					resultMap.put("success", "0");
					//resultMap.put("info", runningno+"装货量未达到上抛标准:"+jhyzl_all+"/"+sjjhs);
					//resultMap.put("jhyzl_all", huixiesl+"");
					if ( "".equals(runningnostr) ){
						runningnostr = orderno + thisitems;
						orderstr = orderno;
						itemstr = thisitems;
						huixieslstr = huixiesl+"";
						errinfo = runningno+"装货量未达到上抛标准:"+jhyzl_all+"/"+sjjhs;
					} else {
						if(runningnostr.indexOf(( orderno + thisitems))==-1){
							runningnostr = runningnostr + "/" +( orderno + thisitems);
							orderstr = orderstr + "/" + orderno;
							itemstr = itemstr + "/" + thisitems;
							huixieslstr = huixieslstr + "/" + huixiesl+"";
							errinfo = errinfo + ";" +runningno+"装货量未达到上抛标准:"+jhyzl_all+"/"+sjjhs;
						}
					}
					resultMap.put("info", errinfo);
					resultMap.put("runningnostr",runningnostr);
					resultMap.put("orderstr",orderstr);
					resultMap.put("itemstr",itemstr);
					resultMap.put("huixieslstr",huixieslstr);					
					//break;
				}
			}else{
				resultMap.put("success", "0");
				resultMap.put("info", "包装类别无法识别:"+materialtype);
				break;
			}
			/*
			if(thisitems.equals(items)){
				resultMap.put("jhyzl_all", huixiesl+"");
			}
			*/
			if ( "".equals(runningnostr) ){
				runningnostr = orderno + thisitems;
				orderstr = orderno;
				itemstr = thisitems;
				huixieslstr = huixiesl+"";
			} else {
				if(runningnostr.indexOf(( orderno + thisitems))==-1){
					runningnostr = runningnostr + "/" +( orderno + thisitems);
					orderstr = orderstr + "/" + orderno;
					itemstr = itemstr + "/" + thisitems;
					huixieslstr = huixieslstr + "/" + huixiesl+"";
				}
			}
			resultMap.put("runningnostr",runningnostr);
			resultMap.put("orderstr",orderstr);
			resultMap.put("itemstr",itemstr);
			resultMap.put("huixieslstr",huixieslstr);
		}
		resultMap.put("runningnostr",runningnostr);
		resultMap.put("orderstr",orderstr);
		resultMap.put("itemstr",itemstr);
		resultMap.put("huixieslstr",huixieslstr);
		//System.out.println("--交运单是否可以上抛-canUp---runningnostr="+runningnostr+" orderstr="+orderstr +"  itemstr="+itemstr+"  huixieslstr="+huixieslstr );
		return resultMap;
	}

%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  