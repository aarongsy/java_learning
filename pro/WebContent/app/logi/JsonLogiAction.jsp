<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%><%@ page import="org.json.simple.JSONObject"%><%@ page import="java.util.*" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.app.weight.service.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="com.eweaver.app.logi.LogiSendCarAction"%><%@ page import="java.util.List"%><%@ page import="java.util.Map"%><%@ page import="com.eweaver.base.BaseContext"%><%@ page import="com.eweaver.base.BaseJdbcDao"%><%@ page import="com.eweaver.base.DataService"%><%@ page import="com.eweaver.base.util.DateHelper"%><%@ page import="org.springframework.dao.DataAccessException"%><%@ page import="org.springframework.jdbc.core.JdbcTemplate"%><%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%><%@ page import="org.springframework.transaction.*"%><%@ page import="org.springframework.transaction.PlatformTransactionManager"%><%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%><%@ page import="org.springframework.transaction.TransactionStatus"%><%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("appr")){//派车需求		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String ckmode=StringHelper.null2String(request.getParameter("ckmode"));
		LogiSendCarAction lo = new LogiSendCarAction();
		String flag = "true";
		try {
/* 			lostr = lo.sendAppr(requestid, ckmode);
			if(lostr.equalsIgnoreCase("pass")){
				jo.put("msg","true");
			}else{
				jo.put("msg",lostr);
			} */
			String sqlr="select runningno,deliverdnum from uf_lo_dgcardetail where requestid='"+requestid+"'";
			String sqlt="select needtype,state from uf_lo_dgcar where requestid='"+requestid+"' ";//单据类型
			String currentuser = BaseContext.getRemoteUser().getId();
			String currenttime = DateHelper.getCurDateTime();
			List listt = baseJdbcDao.executeSqlForList(sqlt);
			String needtype = "";
			String state = "";
			if(listt.size()>0){
				needtype =((Map) listt.get(0)).get("needtype") == null?"":((Map)listt.get(0)).get("needtype").toString(); 
				state =((Map) listt.get(0)).get("state") == null?"":((Map)listt.get(0)).get("state").toString(); 
			}
			String  tablename="";
			if(needtype.equals("402864d14931fb79014932928fae0026")){//交运单
				tablename="uf_lo_delivery";
			}else if(needtype.equals("402864d14931fb79014932928fae0027")){//采购订单
				tablename="uf_lo_purchase";
			}else if(needtype.equals("402864d14931fb79014932928fae0028")){//销售订单
				tablename="uf_lo_salesorder";
			}else{//非SAP
//				ckmode="ck3";//直接跳开
				tablename="uf_lo_passdetail";
			}
			/**
			 * 判断是否超出可派车量
			 */
			String psql = "select a.runningno from uf_lo_dgcardetail a,"+tablename+" b where a.runningno=b.runningno and nvl(a.deliverdnum,0)>(nvl(b.quantity,0)-nvl(b.yetnum,0)) and a.requestid='"+requestid+"'";
			List plist = baseJdbcDao.executeSqlForList(psql);
			if(ckmode.equals("ck1")){
				if(state.equals("402864d14931fb790149328a92bd0016")){
					flag = "该派车需求已经审核，请不要重复选择审核！";
					jo.put("msg",flag);	
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();				
					//out.println(flag);
					return ;
				}			
				if(plist.size()>0){
					flag = "审核失败：";
					for(int m=0;m<plist.size();m++){
						flag = flag + ((Map) plist.get(m)).get("runningno")+",";
					}
					flag = flag+"流水号超出可派车量,请检查！";
					jo.put("msg",flag);	
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();							
					return ;
				}
			}		
			List list=baseJdbcDao.getJdbcTemplate().queryForList(sqlr); 
		    String upsqld ="";
		    String upsql = "";
		    String upflag  = "";	    
		    for(int i=0;i<list.size();i++){	    	
	    	   if(ckmode.equals("ck1")&&state.equals("402864d14931fb790149328a92bd0015")){//交运单回写需求数,单据状态为制单并审核
	    		   upsqld="update "+tablename+" set yetnum=(select nvl(yetnum,0)+?  yetnum from "+tablename+" where runningno=?) where runningno=?";
	    		   upsql = "update uf_lo_dgcar set state='402864d14931fb790149328a92bd0016',checkman='"+currentuser+"',checkdate='"+currenttime+"',unmkman='',unmkdate='' where requestid='"+requestid+"'";
	    		   upflag = "update "+tablename+" set yetmark='0',covermark='0' where nvl(quantity,0.0)-nvl(yetnum,0.0)<=0 and runningno=?";
		       }
	    	   if(ckmode.equals("ck2")&&state.equals("402864d14931fb790149328a92bd0016")){
	    		   /**
	    		   * 判断对应的派车单是否已经做装卸计划了，如果装卸计划是有效状态，则不可以反审核
	    		   */
	    		   String ck2sql = "select id from uf_lo_dgcardetail where requestid='"+requestid+"' and id in(select cardetailid from uf_lo_loaddetail where requestid in(select requestid from uf_lo_loadplan where requestid in(select id from requestbase where isdelete=0)))";
	    		   List listck2 = baseJdbcDao.executeSqlForList(ck2sql);
	    		   if(listck2.size()>0){
						flag = "该派车单已经做装卸计划了，不可以反审,请检查！";
						jo.put("msg",flag);	
						response.getWriter().write(jo.toString());
						response.getWriter().flush();
						response.getWriter().close();							
						return ;	    			   
	    		   }
	    		   upsqld="update "+tablename+" set yetnum=(select nvl(yetnum,0)-?  yetnum from "+tablename+" where runningno=?) where runningno=?";
	    		   upsql = "update uf_lo_dgcar set state='402864d14931fb790149328a92bd0015',unmkman='"+currentuser+"',unmkdate='"+currenttime+"',checkman='',checkdate='' where requestid='"+requestid+"'";
	    		   upflag = "update "+tablename+" set yetmark='1' where nvl(quantity,0.0)-nvl(yetnum,0.0)>0 and runningno=?";
	    	   }
		    	String runningno=((Map) list.get(i)).get("runningno") == null?"":((Map)list.get(i)).get("runningno").toString(); 
		       	Float deliverdnum=((Map) list.get(i)).get("deliverdnum") == null?0:Float.parseFloat(((Map)list.get(i)).get("deliverdnum").toString()); 
		       	upsqld=upsqld.replaceFirst("[?]",deliverdnum+"");
		       	upsqld=upsqld.replaceFirst("[?]", "'"+runningno+"'");
		       	upsqld=upsqld.replaceFirst("[?]", "'"+runningno+"'");
		       	upflag=upflag.replaceFirst("[?]", "'"+runningno+"'");
		       	//System.out.println(updatesql);
		       	if(upsqld.length()>10){
			       	baseJdbcDao.update(upsqld);
			       	baseJdbcDao.update(upflag);//判断是否完成派车
		       	}	       	
		    }		
			int up = 0;
			if(upsql.length()>10){
				up = baseJdbcDao.update(upsql);
				if(up<=0){
					flag = "状态更新失败！";
				}				
			}else{
				flag = "状态更新失败！";
			}	    
	
		} catch (Exception e) {
			//jo.put("msg",flag);
			e.printStackTrace();
		}
		jo.put("msg",flag);			
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();	
	}

	if (action.equals("fare")){//运费运算		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		LogiSendCarAction lo = new LogiSendCarAction();
		String lostr = "";
			String flag = "pass";
			/**
			 * 1、取得装卸主表数据；
			 * 考虑是价格优行还是信用优先
			 * 2、根据主路线、主表相关内容、派车原则选择该线路对应的承运商、承运商帐号、并从线路价格汇总中带出主路线价格；
			 * 3、根据线路明细得出线路价格之和；
			 * 4、回写以上信息，并将费用之和分摊至各产品明细分摊费用中
			 * 
			 */
			String sql = "select * from uf_lo_loadplan where requestid = '"+requestid+"'";
			try{
			List list = baseJdbcDao.executeSqlForList(sql);
			if(list.size()>0){
				String linetype = ((Map) list.get(0)).get("linetype") == null?"":((Map)list.get(0)).get("linetype").toString();//线路类型			
				String linecode =((Map) list.get(0)).get("linecode") == null?"":((Map)list.get(0)).get("linecode").toString();	//主线路编码		
				String transittype =((Map) list.get(0)).get("transittype") == null?"":((Map)list.get(0)).get("transittype").toString();//运输类型
				String cartype =((Map) list.get(0)).get("cartype") == null?"":((Map)list.get(0)).get("cartype").toString();//运输车型
				String pricetype =((Map) list.get(0)).get("pricetype") == null?"":((Map)list.get(0)).get("pricetype").toString();//价格类型
				String factory =((Map) list.get(0)).get("factory") == null?"":((Map)list.get(0)).get("factory").toString();//厂区别
				String transitton = ((Map) list.get(0)).get("transitton") == null?"":((Map)list.get(0)).get("transitton").toString();//运输吨位
				String sendtype = ((Map) list.get(0)).get("sendtype") == null?"":((Map)list.get(0)).get("sendtype").toString();//派车原则
				String arrivecity = ((Map) list.get(0)).get("arrivecity") == null?"":((Map)list.get(0)).get("arrivecity").toString();//主线路送达地址
				String currentdate = DateHelper.getCurrentDate();//得到当前日期用于匹配线路价格汇总表的有效线路价格
				String sql1 = "";
				if(pricetype !="" &&sendtype.equals("402864d14931fb790149324ec6de0006")){//价格优先
					if(pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0524")){//包车时需判断吨位
						sql1 = "and tstart= '"+transitton+"'";
					}else if(pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0525")){//配载
						sql1 = "and '"+transitton+"' between tstart and tend ";
					}
					String sqlc = "select concode,conname,userid from uf_lo_loginmatch where conname in(select consolidator from (select consolidator from uf_lo_trackprice where linecode='"+linecode+"' and linetype = '"+linetype+"' and cartype='"+cartype+"' and transittype='"+transittype+"' and company = '"+factory+"' and pricetype ='"+pricetype+"'" +sql1+" and '"+currentdate+"' between valid and validutil order by lineprice asc) where rownum=1)";				
					List listc = baseJdbcDao.executeSqlForList(sqlc);
					if(listc.size()>0){
						String concode = ((Map)listc.get(0)).get("concode").toString();
						String conname = ((Map)listc.get(0)).get("conname").toString();
						String userid = ((Map)listc.get(0)).get("userid").toString();
						String lineprice = "";
						double mcityprice = 0.0;
						
						String sqlstr = "";
						String sqlb = "select consolidator,lineprice,cityprice from (select consolidator,lineprice,cityprice from uf_lo_trackprice where linecode='"+linecode+"' and linetype = '"+linetype+"' and cartype = '"+cartype+"' and transittype='"+transittype+"' and company = '"+factory+"' and pricetype ='"+pricetype+"'" +sql1+" and '"+currentdate+"' between valid and validutil order by lineprice asc) where rownum=1";
						List listb = baseJdbcDao.executeSqlForList(sqlb);
						if(listb.size()>0){
							lineprice = ((Map) listb.get(0)).get("lineprice") == null?"":((Map)listb.get(0)).get("lineprice").toString();
							mcityprice = Double.parseDouble(((Map) listb.get(0)).get("cityprice") == null?"0.0":((Map)listb.get(0)).get("cityprice").toString());
							sqlstr = ",mainprice="+lineprice+" ";
						}
	//					arrivecity = arrivecity.substring(0, 4);//取得主到达城市邮编
						String sqln = "select nvl(count(id),0) num from uf_lo_loaddetail where requestid='"+requestid+"' and shiptoaddress !='"+arrivecity+"' and shiptoaddress like '"+arrivecity.substring(0, 4)+"%'";
						String num = ds.getValue(sqln);
						int mcitiesnums = 0;
						double mcitypricesum = 0.0;
						if(!num.equals("")){
							mcitiesnums = Integer.parseInt(num);//主线路同城个数
							mcitypricesum = mcitiesnums * mcityprice;
						}
	
						/*
						 * 找到承运商线路价格及账号信息，并更新
						 */
						int upnum = baseJdbcDao.update("update uf_lo_loadplan set rconcode='"+concode+"',rconname='"+conname+"',mcityprice="+mcityprice+",conaccount='"+userid+"'"+sqlstr+" where requestid='"+requestid+"'");
						if(upnum<=0){
							flag = "没有找到该线路的承运商价格信息及承运商帐号！";
							jo.put("msg",flag);	
							response.getWriter().write(jo.toString());
							response.getWriter().flush();
							response.getWriter().close();		
						}
						/*
						 * 1、判断辅线路是否选择完全，不完全则提示，控制流各不可提交。
						 *   a、主线路的同城；
						 *   b、辅助线路的同城；
						 *   c、(a+1)+(b+1)如果小于线路之和，则提示辅助线路选择不完全。
						 * 2、找辅助路线价格，并计算同城个数，同城个数价格，并更新装卸计划。
						 * 
						 */
	
						String sqlf = "select a.id,a.linecode,b.linecode as lcode,b.remark,a.arrivecity from uf_lo_assistline a,uf_lo_haulingtrack b where a.linecode = b.requestid and a.requestid='"+requestid+"'";
						List listf = baseJdbcDao.executeSqlForList(sqlf);
						String errline = "";
						int fcitiesnums = 0;
						double fcitypricesum = 0.0;
						if(listf.size()>0){
							for(int f = 0;f<listf.size();f++){
								String id = ((Map)listf.get(f)).get("id").toString();
								String linecodef = ((Map)listf.get(f)).get("linecode").toString();
								String farrivecity = ((Map)listf.get(f)).get("arrivecity").toString();//辅助线路6位编号
								String remark = ((Map)listf.get(f)).get("remark").toString();//线路名称
								String fzps = "select lineprice from (select lineprice from uf_lo_trackprice where consolidator='"+conname+"' and linecode='"+linecodef+"' and linetype = '40285a9048f924a70148fccf1a0c0270' and cartype = '"+cartype+"' and transittype='"+transittype+"' and company = '"+factory+"' and pricetype ='"+pricetype+"'" +sql1+" and '"+currentdate+"' between valid and validutil order by lineprice asc) where rownum=1";
								String lprice = ds.getValue(fzps);
								double fzlprice = 0.0;
								if(!lprice.equals("")){
									fzlprice = Double.parseDouble(lprice);
									baseJdbcDao.update("update uf_lo_assistline set lineprice = "+fzlprice+" where id='"+id+"'");
									String sqlcn = "select nvl(count(id),0) cnum from uf_lo_loaddetail where requestid='"+requestid+"' and shiptoaddress !='"+farrivecity+"' and shiptoaddress like '"+farrivecity.substring(0, 4)+"%'";
									String cnum =ds.getValue(sqlcn);
									int fcitiesnum = 0;
									double citypric = 0.0;										
									if(!cnum.equals("")){
										fcitiesnum = Integer.parseInt(cnum);//辅助线路同城个数
										citypric = fcitiesnum * fzlprice;
									}
	
									fcitiesnums += fcitiesnum;
									fcitypricesum += citypric;
								}else{
									errline = errline + ","+farrivecity;
								}
							}
							double citypricesum = mcitypricesum + fcitypricesum;//主线路同城价
							int allcitynums = fcitiesnums+mcitiesnums;
							baseJdbcDao.update("update uf_lo_loadplan set cities="+allcitynums+",cityprice="+citypricesum+" where requestid='"+requestid+"'");
							
						}
											
					}else{
						flag = "找不到对应的承运商，请检查必填字段信息是否正确！";
						jo.put("msg",flag);	
						response.getWriter().write(jo.toString());
						response.getWriter().flush();
						response.getWriter().close();		
					}
					
				}else if(pricetype !="" &&sendtype.equals("402864d14931fb790149324ec6de0007")){//信用优先
					//
					flag = "系统暂不支持信用优先运输，请先调整！";
					jo.put("msg",flag);	
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();		
					
					
				}else{
					flag = "请先完善装卸计划必填字段，再计算运费！";
					jo.put("msg",flag);	
					response.getWriter().write(jo.toString());
					response.getWriter().flush();
					response.getWriter().close();		
				}
				
			}else{
				flag = "该装卸计划尚未保存！";
				jo.put("msg",flag);	
				response.getWriter().write(jo.toString());
				response.getWriter().flush();
				response.getWriter().close();		
			}
			jo.put("msg",flag);
		}catch (Exception e) {
			e.printStackTrace();
			flag = "运算出错，请联系系统管理员！";
			jo.put("msg",flag);
	     }			
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();		
	}		

	if (action.equals("back")){//成品交运,重量证明
		String reqid=StringHelper.null2String(request.getParameter("requestid"));
		String custsign=StringHelper.null2String(request.getParameter("custsign"));
		String signdate=StringHelper.null2String(request.getParameter("signdate"));
			String flag = "true";
			String sql="select requestid,sendreqtime from uf_lo_provedoc where requestid='"+reqid+"'";
			List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);
			String sendreqtime="";
			if(list.size()>0){
				sendreqtime =((Map) list.get(0)).get("sendreqtime") == null?"":((Map)list.get(0)).get("sendreqtime").toString(); 
			}
			String upsqly="";	
			if(Double.parseDouble(sendreqtime.replace("-", ""))-Double.parseDouble(signdate.replace("-", ""))>=0){
				upsqly="update uf_lo_provedoc set custsign='"+custsign+"',signdate='"+signdate+"',ontime='40288098276fc2120127704884290210' where requestid='"+reqid+"'";
			}else{
				upsqly="update uf_lo_provedoc set custsign='"+custsign+"',signdate='"+signdate+"',ontime='40288098276fc2120127704884290211' where requestid='"+reqid+"'";
			}
			int unum = baseJdbcDao.update(upsqly);
			if(unum<=0){
				flag = "false";
			}
			jo.put("msg",flag);
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();	
	}
/*
*现场收发审核
*/

	if(action.equals("checkSpot")){
		List<String> sqlList =new ArrayList<String>();
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String flag = "true";
		String loadno = "";
		String ispond = "";
		String sql = "select a.deliverdnum,a.realnums,b.loadingno,b.ladingno,a.runningno,b.ispond from uf_lo_spotdetail a,uf_lo_spotmanager b where a.requestid=b.requestid and a.requestid ='"+requestid+"' and b.state='402881f34a566549014a5846f1ef085e' and (nvl(a.realnums,0)-nvl(a.deliverdnum,0))<>0";
		List list=baseJdbcDao.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				double deliverdnum =Double.parseDouble(((Map) list.get(i)).get("deliverdnum") == null?"0.0":((Map)list.get(i)).get("deliverdnum").toString());
				double realnum =Double.parseDouble(((Map) list.get(i)).get("realnums") == null?"0.0":((Map)list.get(i)).get("realnums").toString());
				String ladingno = ((Map) list.get(i)).get("ladingno") == null?"":((Map)list.get(i)).get("ladingno").toString();
				loadno = StringHelper.null2String(((Map) list.get(i)).get("loadingno")); 
				ispond = StringHelper.null2String(((Map) list.get(i)).get("ispond")); 
				String runningno = ((Map) list.get(i)).get("runningno") == null?"":((Map)list.get(i)).get("runningno").toString();
				//更新提入单明细qeaaa
				String upsql = "update uf_lo_ladingdetail set deliverdnum="+realnum+" where requestid = '"+ladingno+"' and runningno='"+runningno+"'";
				sqlList.add(upsql);
				//更新装卸计划明细
				String upsql2 = "update uf_lo_loaddetail set deliverdnum="+realnum+" where requestid = '"+ladingno+"' and runningno='"+runningno+"'";
				sqlList.add(upsql2);				
				/* baseJdbcDao.update(upsql); */
			}
		}else{
			jo.put("msg","该单据已经审核或作废，请勿重复操作！");
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
		String upmsql = "update uf_lo_spotmanager set state='402864d14940d265014941e9d82900da' where requestid='"+requestid+"'";
		sqlList.add(upmsql); 
		/* baseJdbcDao.update(upmsql); */
		if(sqlList.size()>0){
			JdbcTemplate jdbcTemp=baseJdbcDao.getJdbcTemplate();
			PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
			DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
			TransactionStatus status=tm.getTransaction(def); 
			try{ 
				jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
				tm.commit(status);
				if("40288098276fc2120127704884290211".equals(ispond)){
					Uf_lo_proveService ps = new Uf_lo_proveService();
					ps.createProveByPlan(loadno, "");
					Uf_lo_budgetService bs = new Uf_lo_budgetService();
					bs.createBudgetByPlan(bs.getRequestidByLadingno(loadno));
				}
				jo.put("msg",flag);
				response.getWriter().write(jo.toString());
				response.getWriter().flush();
				response.getWriter().close();					
			}catch(DataAccessException ex){
				tm.rollback(status);
				jo.put("msg","审核现场收发货单出错，请联系系统管理员！");
				response.getWriter().write(jo.toString());
				response.getWriter().flush();
				response.getWriter().close();				
				throw ex;
			}			
		}
	
	}
	if (action.equals("cancelbill")){//装缷计划撤销
		//DataService ds = new DataService();
		JSONObject jot = new JSONObject();
		String planid=StringHelper.null2String(request.getParameter("planid"));
		//取提入单号  402881f34a566549014a5846f1ef085e 制单  402864d14940d265014941e9d82900da 已审核  402864d14940d265014941e9d82900db   已过磅  402864d14940d265014941e9d82900dc 已撤销
		String sql="select ladingno,state from uf_lo_ladingmain a where  loadingno=(select reqno from uf_lo_loadplan  where requestid='"+planid+"') and  state not in ('402864d14940d265014941e9d82900dc') and exists(select id from formbase where id=a.requestid and isdelete=0)";
		List ls = ds.getValues(sql);
		String ladingnos = "";
		for(int i=0,sizei=ls.size();i<sizei;i++){
			Map mi = (Map) ls.get(i);
			String ladingno=StringHelper.null2String(mi.get("ladingno"));
			ladingnos=ladingnos+","+ladingno;
		}
		if(ladingnos.length()>1)ladingnos=ladingnos.substring(1);
		//取暂估单
		//invoicestatue 状态 402864d149e039b10149e080b01600c0  已审核 402864d149e039b10149e080b01600c1 已暂估 402864d149e039b10149e080b01600c2 已作废，isremark是否已对账
		sql="select invoicestatue,invoiceno,isremark from uf_lo_budget a where a.loadplanno=(select reqno from uf_lo_loadplan  where requestid='"+planid+"') and  invoicestatue not in ('402864d149e039b10149e080b01600c2') and exists(select id from formbase where id=a.requestid and isdelete=0)";
		ls = ds.getValues(sql);
		String tempnos = "";
		for(int i=0,sizei=ls.size();i<sizei;i++){
			Map mi = (Map) ls.get(i);
			String invoiceno=StringHelper.null2String(mi.get("invoiceno"));
			tempnos=tempnos+","+invoiceno;
		}
		if(tempnos.length()>1)tempnos=tempnos.substring(1);
		
		//
		//select a.reqno,b.loadplanno,b.invoiceno,b.voucherno uf_lo_checkaccount a,uf_lo_checkzxzgdetail b where a.requestid=b.requestid

		//对应清帐单，keepcode 记帐代码	 state 状态 402864d149e039b10149e080b01600c0  已审核 402864d149e039b10149e080b01600c1 已暂估 402864d149e039b10149e080b01600c2 已作废
		sql="select reqno,keepcode,state from uf_lo_freightclean a,uf_lo_loadclean  b where a.requestid=b.requestid and b.loadplanno=(select reqno from uf_lo_loadplan  where requestid='"+planid+"') and  state not in ('402864d149e039b10149e080b01600c2') and exists(select id from requestbase where id=a.requestid and isdelete=0)";
		ls = ds.getValues(sql);
		String clearnos = "";
		for(int i=0,sizei=ls.size();i<sizei;i++){
			Map mi = (Map) ls.get(i);
			String reqno=StringHelper.null2String(mi.get("reqno"));
			clearnos=clearnos+","+reqno;
		}
		if(clearnos.length()>1)clearnos=clearnos.substring(1);
		jot.put("ladingnos",ladingnos);
		jot.put("tempnos",tempnos);
		jot.put("clearnos",clearnos);
		//System.out.println(jot.toString());
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jot.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
	if (action.equals("checkcancel")){//装缷计划撤销提交检查
		StringBuffer buf = new StringBuffer();
		//DataService ds = new DataService();
		String planid=StringHelper.null2String(request.getParameter("planid"));
		//取暂估单是否有已抛sap的单据
		//invoicestatue 状态 402864d149e039b10149e080b01600c0  已审核 402864d149e039b10149e080b01600c1 已暂估 402864d149e039b10149e080b01600c2 已作废，isremark是否已对账
		String sql="select invoicestatue,invoiceno,isremark from uf_lo_budget a where a.loadplanno=(select reqno from uf_lo_loadplan  where requestid='"+planid+"') and  invoicestatue not in ('402864d149e039b10149e080b01600c2') and voucherno is not null and exists(select id from formbase where id=a.requestid and isdelete=0)";
		List ls = ds.getValues(sql);
		String ladingnos = "'0'";
		for(int i=0,sizei=ls.size();i<sizei;i++){
			Map mi = (Map) ls.get(i);
			String invoiceno=StringHelper.null2String(mi.get("invoiceno"));
			ladingnos=ladingnos+",'"+invoiceno+"'";
		}
		//查询单据是否有清账
		//对应清帐单，keepcode 记帐代码	 state 状态 402864d149e039b10149e080b01600c0  已审核 402864d149e039b10149e080b01600c1 已暂估 402864d149e039b10149e080b01600c2 已作废
		sql="select a.squareup,a.reqno,a.keepcode,a.state,b.invoiceno from uf_lo_freightclean a,uf_lo_loadclean  b where a.requestid=b.requestid and b.loadplanno=(select reqno from uf_lo_loadplan  where requestid='"+planid+"') and b.invoiceno in ("+ladingnos+") and  state not in ('402864d149e039b10149e080b01600c2') and squareup is not null and exists(select id from requestbase where id=a.requestid and isdelete=0)";
		ls = ds.getValues(sql);
		for(int i=0,sizei=ls.size();i<sizei;i++){
			Map mi = (Map) ls.get(i);
			String invoiceno=StringHelper.null2String(mi.get("invoiceno"));
			buf.append("throw=1,暂估单["+invoiceno+"]已记账，请先清账再执行装卸计划撤销！");
			response.getWriter().print(buf.toString());
			return;
		}
		buf.append("throw=0,");
		response.getWriter().print(buf.toString());
		return;

		
	}
%>
