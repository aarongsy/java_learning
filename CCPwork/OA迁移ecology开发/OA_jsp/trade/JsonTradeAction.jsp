<%@ page language="java" contentType="application/json"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.app.logi.LogiSendCarAction"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="com.eweaver.interfaces.workflow.*"%>
<%@ page import="com.eweaver.interfaces.model.*"%>
<%!
private void doExecute (String requestid,String creator){
	String title = "商检联系单";//标题
	String workflowid = "40285a8d4acccf8c014ad16b11ab72eb";//提单触发商检联系单流程
	//往主表写入数据
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//判断提单是否之前已触发过商检联系单流程
	String sql="select * from uf_tr_cicappform where (imgoodno='"+requestid+"' and (sfzf = '40288098276fc2120127704884290211' or sfzf is null))"; 
	List<Map> counts = baseJdbc.executeSqlForList(sql);
	String isdelete = "0";
	if(counts.size() > 0){
		for(Map map:counts){
			String requestid1 = StringHelper.null2String(map.get("requestid"));
			sql="select * from requestbase where id = '"+requestid1+"' and isdelete = 1"; 
			List<Map> list = baseJdbc.executeSqlForList(sql);
			if(list.size() == 1){
				isdelete = "1";
			}
		}
	}
	if(counts.size() == 0 || isdelete.equals("1")){
		String sqlOA="select arrtype,imgoodsid,invoiceid,ladingid,factory,company from uf_tr_lading where requestid='"+requestid
		+"' and isinspection = '40285a904931f62b01493279d8ea057e'";
		List<Map> list = baseJdbc.executeSqlForList(sqlOA);
		if(list.size()>0){
			String arrtype="";
			String imgoodsid="";
			String invoiceid="";
			String ladingid="";
			String factory="";
			String company="";
			for(Map map:list){
				arrtype = StringHelper.null2String(map.get("arrtype"));
				imgoodsid = StringHelper.null2String(map.get("imgoodsid"));
				invoiceid = StringHelper.null2String(map.get("invoiceid"));
				ladingid = StringHelper.null2String(map.get("ladingid"));
				factory = StringHelper.null2String(map.get("factory"));
				company = StringHelper.null2String(map.get("company"));
			}
			RequestInfo req = new RequestInfo();
			req.setTypeid(workflowid);
			req.setCreator(creator);
			Dataset dataset = new Dataset();
			List<Cell> maintable = new ArrayList<Cell>();
			
			Cell cell1 = new Cell();
			cell1.setName("reqman");
			cell1.setValue(creator);

			Cell cell2 = new Cell();
			cell2.setName("goodstyle");
			cell2.setValue(arrtype);

			Cell cell3 = new Cell();
			cell3.setName("imgoodno");
			cell3.setValue(requestid);

			Cell cell4 = new Cell();
			cell4.setName("invoice");
			cell4.setValue(invoiceid);

			Cell cell5 = new Cell();
			cell5.setName("ladingno");
			cell5.setValue(ladingid);
			
			Cell cell6 = new Cell();
			cell6.setName("comtype");
			cell6.setValue(factory);

			Cell cell7 = new Cell();
			cell7.setName("company");
			cell7.setValue(company);

			maintable.add(cell1);
			maintable.add(cell2);
			maintable.add(cell3);
			maintable.add(cell4);
			maintable.add(cell5);
			maintable.add(cell6);
			maintable.add(cell7);

			dataset.setMaintable(maintable);
			req.setData(dataset);
			WorkflowServiceImpl ws = new WorkflowServiceImpl();
			String state =ws.createRequest(req);
			if(!"".equals(state)){
				if(arrtype.equals("40285a90492d5248014930386c190174")){
					//物料明细
					String sqlOA1="select * from uf_tr_materialdt where requestid='"+requestid+"'";
					List<Map> list1 = baseJdbc.executeSqlForList(sqlOA1);
					if(list1.size()>0){
						for(Map map:list1){
							String imlistid = StringHelper.null2String(map.get("imlistid"));
							String orderid = StringHelper.null2String(map.get("orderid"));
							String item = StringHelper.null2String(map.get("item"));
							String materialid = StringHelper.null2String(map.get("materialid"));
							String goodsid = StringHelper.null2String(map.get("goodsid"));
							String invoicenum = StringHelper.null2String(map.get("invoicenum"));
							String imlistno = StringHelper.null2String(map.get("imlistno"));
							if(!imlistid.equals("")){
								baseJdbc.update("insert into uf_tr_arrivinspectmater(id,requestid,imgoodappno,orderno,orderrow,materno,goodno,invoiceno,ingoodrow) values("
										+"'"+IDGernerator.getUnquieID()+"','"+state+"','"+imlistid+"','"+orderid+"','"+item+"','"+materialid+"','"+goodsid+"','"
										+invoicenum+"','"+imlistno+"')");
							}
						}
					}
				}else if(arrtype.equals("40285a90492d524801493038713c0179")){
					//设备明细
					String sqlOA1="select * from uf_tr_equipmentdt where requestid='"+requestid+"'";
					List<Map> list1 = baseJdbc.executeSqlForList(sqlOA1);
					if(list1.size()>0){
						for(Map map:list1){
							String imlistid = StringHelper.null2String(map.get("imlistid"));
							String reqnum = StringHelper.null2String(map.get("reqnum"));
							String orderid = StringHelper.null2String(map.get("orderid"));
							String orderitem = StringHelper.null2String(map.get("orderitem"));
							String goodsid = StringHelper.null2String(map.get("goodsid"));
							String article = StringHelper.null2String(map.get("article"));
							String assetsid = StringHelper.null2String(map.get("assetsid"));
							String goodsid1 = StringHelper.null2String(map.get("goodsid"));
							String invoicenum = StringHelper.null2String(map.get("invoicenum"));
							if(!imlistid.equals("")){
								baseJdbc.update("insert into uf_tr_arrivinspectequip(id,requestid,imgoodappno,imgoodroqno,orderno,orderrow,goodsname,assetno,goodcode,invoiceno) values("
								+"'"+IDGernerator.getUnquieID()+"','"+state+"','"+imlistid+"','"+reqnum+"','"+orderid+"','"+orderitem+"','"+article+"','"+assetsid+"','"+goodsid1+"','"+invoicenum+"')");
							}
						}
					}
				}
				//装箱方式明细
				String sqlOA1="select * from uf_tr_autoboxing where requestid='"+requestid+"'";
				List<Map> list1 = baseJdbc.executeSqlForList(sqlOA1);
				if(list1.size()>0){
					for(Map map:list1){
						String cabinet = StringHelper.null2String(map.get("cabinet"));
						String counterid = StringHelper.null2String(map.get("counterid"));
						String netwei = StringHelper.null2String(map.get("netwei"));
						String grosswei = StringHelper.null2String(map.get("grosswei"));
						String traynum = StringHelper.null2String(map.get("traynum"));
						String woodennum = StringHelper.null2String(map.get("woodennum"));
						String packagenum = StringHelper.null2String(map.get("packagenum"));
						baseJdbc.update("insert into uf_tr_packway(id,requestid,cabinet,containnum,netweight,grossweight,palletno,woodenno,packagenum) values("
						+"'"+IDGernerator.getUnquieID()+"','"+state+"','"+cabinet+"','"+counterid+"','"+netwei+"','"+grosswei+"','"+traynum+"','"+woodennum+"','"+packagenum+"')");
					}
				}
				baseJdbc.update("delete uf_tr_arrivinspectequip where rowindex = '000' and requestid = '"+state+"'");
				baseJdbc.update("delete uf_tr_arrivinspectmater where rowindex = '000' and requestid = '"+state+"'");
				baseJdbc.update("delete uf_tr_packway where rowindex = '000' and requestid = '"+state+"'");
			}
		}
	}
 }
%>
<%
	String action = StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();
	String flag = "true";
	String state = "";
	String arrtype = "";
	String url = "";
	if (action.equals("appr")) {//提单审核		
		String requestid = StringHelper.null2String(request.getParameter("requestid"));
		String userid = StringHelper.null2String(request.getParameter("userid"));
		String lkmode = StringHelper.null2String(request.getParameter("lkmode"));
		/* TradeLadingAction tl = new TradeLadingAction(); */
		try {
			String sql = "select m.requestid,d.arrtype,d.state "
					+ "from uf_tr_lading d,uf_tr_materialdt m where d.requestid=m.requestid and m.requestid='"
					+ requestid + "'";
			String sql1 = "select a.id from uf_tr_materialdt a where requestid = '"
					+ requestid + "'";
			List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
			List list1 = baseJdbcDao.executeSqlForList(sql1);	
			if (list.size() > 0) {
				state = ((Map) list.get(0)).get("state") == null ? "": ((Map) list.get(0)).get("state").toString();
				arrtype = ((Map) list.get(0)).get("arrtype") == null ? "": ((Map) list.get(0)).get("arrtype").toString();
			}
			/**
			 * 判断提单是否已审核
			 */
			if (lkmode.equals("lk1")) {
				if (state.equals("402821814b015fb1014b01718a6f0003")) {//单据审核状态：已审核
					flag = "该单据已经审核，请不要重复选择审核！";
					jo.put("msg", flag);
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();
					out.println(flag);
					return;
				}
			}
			if (lkmode.equals("lk2")) {
				if (state.equals("40285a8d4b33dd0d014b34bb2fbc27a5")) {
					flag = "该单据还没有被审核，不允许进行反审核操作！";
					jo.put("msg", flag);
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();
					out.println(flag);
					return;
				}
			}
			//判断提单是否可以发起税金暂估流程
/*  			if(lkmode.equals("lk3")){
				if(state.equals("")){//不可以发起税金暂估流程
					flag = "该提单还未审核，不允许发起税金暂估！";
					jo.put("msg", flag);
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();
					out.println(flag);
					return;
				}
				if(state.equals("402821814b015fb1014b01718a6f0003")){//可以发起税金暂估流程
					url = "/workflow/request/workflow.jsp?workflowid=402821814a9dc86d014a9df416e20349&requestid="+requestid;
 					url = request.getContextPath() + url; 
					response.sendRedirect(url);
				}
			}  */
			String upladsql = "";
			String uphbsql = "";
			/* String upfreesql = ""; */
			for (int i = 0; i < list1.size(); i++) {
				String m1 = ((Map) list1.get(0)).get("id") == null ? "": ((Map) list1.get(0)).get("id").toString();
				//物料明细审核、反审核
				if (lkmode.equals("lk1") && state.equals("40285a8d4b33dd0d014b34bb2fbc27a5") && arrtype.equals("40285a90492d5248014930386c190174")) {
					//更新保税手册进口货物备案信息,单据状态改为已审核
					upladsql = "update uf_tr_lading set state='402821814b015fb1014b01718a6f0003' where requestid='"
							+ requestid + "'";
					uphbsql = "update uf_tr_imrecordinfo"
							+ " set overnumtotal   = overnumtotal + "
							+ " (select sum(nvl(m.invoicemoney, 0)) "
							+ "   from uf_tr_materialdt m, uf_tr_bonded b "
							+ "  where m.handbookid = b.handbookno "
							+ "   and m.handbooknum = b.handbookid "
							+ " and m.id = " + " '"
							+ m1
							+ "' ), "
							+ " overmoneytotal = overmoneytotal + "
							+ " (select sum(nvl(m.invoicenum, 0)) "
							+ "  from uf_tr_materialdt m, uf_tr_bonded b "
							+ "  where m.handbookid = b.handbookno "
							+ "    and m.handbooknum = b.handbookid "
							+ "     and m.id = "
							+ "'"
							+ m1
							+ "'), "
							+ " receiptnum     = receiptnum + "
							+ " (select sum(nvl(m.receiptnum, 0)) "
							+ " from uf_tr_materialdt m, uf_tr_bonded b "
							+ " where m.handbookid = b.handbookno "
							+ " and m.handbooknum = b.handbookid "
							+ " and m.id = "
							+ " '"
							+ m1
							+ "') "
							+ " where handbooknum = "
							+ " (select m.item "
							+ " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
							+ " where m.item = d.handbooknum "
							+ " and m.id = '"
							+ m1
							+ "') "
							+ " and materialno = "
							+ " (select requestid "
							+ " from uf_tr_materialsp "
							+ " where materialno = "
							+ " (select m.materialid "
							+ " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
							+ " where m.materialid = get_namebyid(d.materialno,7) "
							+ " and m.id = '"
							+ m1
							+ "')) "
							+ " and requestid = "
							+ " (select requestid "
							+ " from uf_tr_bonded "
							+ " where handbookno = "
							+ " (select max(m.handbookid) "
							+ " from uf_tr_materialdt m, uf_tr_bonded d "
							+ " where m.handbookid = d.handbookno "
							+ " and m.id = '"
							+ m1
							+ "') "
							+ " and handbookid = "
							+ " (select max(m.handbooknum) "
							+ " from uf_tr_materialdt m, uf_tr_bonded d "
							+ " where m.handbooknum = d.handbookid "
							+ " and m.id = '" + m1 + "')) ";
					if (uphbsql.length() > 0) {
						baseJdbcDao.update(uphbsql);
						baseJdbcDao.update(upladsql);
						doExecute (requestid,userid);
					} else {
						flag = "提单审核失败！";
					}
				}
				if (lkmode.equals("lk2") && state.equals("402821814b015fb1014b01718a6f0003") && arrtype.equals("40285a90492d5248014930386c190174")) {
					upladsql = "update uf_tr_lading set state='40285a8d4b33dd0d014b34bb2fbc27a5' where requestid='"
							+ requestid + "'";
					uphbsql = "update uf_tr_imrecordinfo"
							+ " set overnumtotal   = overnumtotal - "
							+ " (select sum(nvl(m.invoicemoney, 0)) "
							+ "   from uf_tr_materialdt m, uf_tr_bonded b "
							+ "  where m.handbookid = b.handbookno "
							+ "   and m.handbooknum = b.handbookid "
							+ " and m.id = " + " '"
							+ m1
							+ "' ), "
							+ " overmoneytotal = overmoneytotal - "
							+ " (select sum(nvl(m.invoicenum, 0)) "
							+ "  from uf_tr_materialdt m, uf_tr_bonded b "
							+ "  where m.handbookid = b.handbookno "
							+ "    and m.handbooknum = b.handbookid "
							+ "     and m.id = "
							+ "'"
							+ m1
							+ "'), "
							+ " receiptnum     = receiptnum - "
							+ " (select sum(nvl(m.receiptnum, 0)) "
							+ " from uf_tr_materialdt m, uf_tr_bonded b "
							+ " where m.handbookid = b.handbookno "
							+ " and m.handbooknum = b.handbookid "
							+ " and m.id = "
							+ " '"
							+ m1
							+ "') "
							+ " where handbooknum = "
							+ " (select m.item "
							+ " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
							+ " where m.item = d.handbooknum "
							+ " and m.id = '"
							+ m1
							+ "') "
							+ " and materialno = "
							+ " (select requestid "
							+ " from uf_tr_materialsp "
							+ " where materialno = "
							+ " (select m.materialid "
							+ " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
							+ " where m.materialid = get_namebyid(d.materialno,7) "
							+ " and m.id = '"
							+ m1
							+ "')) "
							+ " and requestid = "
							+ " (select requestid "
							+ " from uf_tr_bonded "
							+ " where handbookno = "
							+ " (select max(m.handbookid) "
							+ " from uf_tr_materialdt m, uf_tr_bonded d "
							+ " where m.handbookid = d.handbookno "
							+ " and m.id = '"
							+ m1
							+ "') "
							+ " and handbookid = "
							+ " (select max(m.handbooknum) "
							+ " from uf_tr_materialdt m, uf_tr_bonded d "
							+ " where m.handbooknum = d.handbookid "
							+ " and m.id = '" + m1 + "')) ";
					if (uphbsql.length() > 0) {
						baseJdbcDao.update(uphbsql);
						baseJdbcDao.update(upladsql);
					} else {
						flag = "提单反审核失败！";
					}
				}

				 //设备明细审核
				 if(lkmode.equals("lk1")  && state.equals("40285a8d4b33dd0d014b34bb2fbc27a5") && arrtype.equals("40285a90492d524801493038713c0179")){
					 upladsql = "update uf_tr_lading set state='402821814b015fb1014b01718a6f0003' where requestid='"
					 + requestid + "'";
					 uphbsql = "update uf_tr_imrecordinfo"
					 + " set overnumtotal   = overnumtotal + "
					 + " (select sum(nvl(e1.invoicemoney, 0)) "
					 + "   from uf_tr_equipmentdt e1, uf_tr_bonded b1 "
					 + "  where e1.handbookid = b1.handbookno "
					 + "   and e1.handbooknum = b1.handbookid "
					 + " and e1.id = " + " '"
					 + m1
					 + "' ), "
					 + " overmoneytotal = overmoneytotal + "
					 + " (select sum(nvl(m.invoicenum, 0)) "
					 + "  from uf_tr_materialdt m, uf_tr_bonded b "
					 + "  where m.handbookid = b.handbookno "
					 + "    and m.handbooknum = b.handbookid "
					 + "     and m.id = "
					 + "'"
					 + m1
					 + "'), "
					 + " receiptnum     = receiptnum + "
					 + " (select sum(nvl(m.receiptnum, 0)) "
					 + " from uf_tr_materialdt m, uf_tr_bonded b "
					 + " where m.handbookid = b.handbookno "
					 + " and m.handbooknum = b.handbookid "
					 + " and m.id = "
					 + " '"
					 + m1
					 + "') "
					 + " where handbooknum = "
					 + " (select m.item "
					 + " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
					 + " where m.item = d.handbooknum "
					 + " and m.id = '"
					 + m1
					 + "') "
					 + " and materialno = "
					 + " (select requestid "
					 + " from uf_tr_materialsp "
					 + " where materialno = "
					 + " (select m.materialid "
					 + " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
					 + " where m.materialid = get_namebyid(d.materialno,7) "
					 + " and m.id = '"
					 + m1
					 + "')) "
					 + " and requestid = "
					 + " (select requestid "
					 + " from uf_tr_bonded "
					 + " where handbookno = "
					 + " (select max(m.handbookid) "
					 + " from uf_tr_materialdt m, uf_tr_bonded d "
					 + " where m.handbookid = d.handbookno "
					 + " and m.id = '"
					 + m1
					 + "') "
					 + " and handbookid = "
					 + " (select max(m.handbooknum) "
					 + " from uf_tr_materialdt m, uf_tr_bonded d "
					 + " where m.handbooknum = d.handbookid "
					 + " and m.id = '" + m1 + "')) ";
					 if (uphbsql.length() > 0) {
						 baseJdbcDao.update(uphbsql);
						 baseJdbcDao.update(upladsql);
						 doExecute (requestid,userid);
					 } else {
						flag = "提单审核失败！";
					 }
				 } 
				 //设备明细反审核	
				 if(lkmode.equals("lk2")  && state.equals("402821814b015fb1014b01718a6f0003") && arrtype.equals("40285a90492d524801493038713c0179")){
					 upladsql = "update uf_tr_lading set state='40285a8d4b33dd0d014b34bb2fbc27a5' where requestid='"
					 + requestid + "'";
					 uphbsql = "update uf_tr_imrecordinfo"
					 + " set overnumtotal   = overnumtotal + "
					 + " (select sum(nvl(e1.invoicemoney, 0)) "
					 + "   from uf_tr_equipmentdt e1, uf_tr_bonded b1 "
					 + "  where e1.handbookid = b1.handbookno "
					 + "   and e1.handbooknum = b1.handbookid "
					 + " and e1.id = " + " '"
					 + m1
					 + "' ), "
					 + " overmoneytotal = overmoneytotal + "
					 + " (select sum(nvl(m.invoicenum, 0)) "
					 + "  from uf_tr_materialdt m, uf_tr_bonded b "
					 + "  where m.handbookid = b.handbookno "
					 + "    and m.handbooknum = b.handbookid "
					 + "     and m.id = "
					 + "'"
					 + m1
					 + "'), "
					 + " receiptnum     = receiptnum + "
					 + " (select sum(nvl(m.receiptnum, 0)) "
					 + " from uf_tr_materialdt m, uf_tr_bonded b "
					 + " where m.handbookid = b.handbookno "
					 + " and m.handbooknum = b.handbookid "
					 + " and m.id = "
					 + " '"
					 + m1
					 + "') "
					 + " where handbooknum = "
					 + " (select m.item "
					 + " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
					 + " where m.item = d.handbooknum "
					 + " and m.id = '"
					 + m1
					 + "') "
					 + " and materialno = "
					 + " (select requestid "
					 + " from uf_tr_materialsp "
					 + " where materialno = "
					 + " (select m.materialid "
					 + " from uf_tr_materialdt m, uf_tr_imrecordinfo d "
					 + " where m.materialid = get_namebyid(d.materialno,7) "
					 + " and m.id = '"
					 + m1
					 + "')) "
					 + " and requestid = "
					 + " (select requestid "
					 + " from uf_tr_bonded "
					 + " where handbookno = "
					 + " (select max(m.handbookid) "
					 + " from uf_tr_materialdt m, uf_tr_bonded d "
					 + " where m.handbookid = d.handbookno "
					 + " and m.id = '"
					 + m1
					 + "') "
					 + " and handbookid = "
					 + " (select max(m.handbooknum) "
					 + " from uf_tr_materialdt m, uf_tr_bonded d "
					 + " where m.handbooknum = d.handbookid "
					 + " and m.id = '" + m1 + "')) ";
					 if (uphbsql.length() > 0) {
						 baseJdbcDao.update(uphbsql);
						 baseJdbcDao.update(upladsql);
					 } else {
						flag = "提单审核失败！";
					 }
				 } 
			}
			jo.put("msg", flag);
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            