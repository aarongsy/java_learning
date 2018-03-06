package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.app.logi.LoadPlanService;
import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.util.DateHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 

 public class Ewv20150113200714 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
     String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
     String issave = params.getParamValueStr("issave");//是否保存 
     String isundo = params.getParamValueStr("isundo");//是否撤回 
     String formid = params.getParamValueStr("formid");//流程关联表单ID 
     String editmode = params.getParamValueStr("editmode");//编辑模式 
     String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
     String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 
     String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写 
 		BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
 		DataService dataService = new DataService();
 		DataService ds = new DataService();	     
 		    String lostr = "";
 			String flag = "OK";
 			/**
 			 * 1、取得装卸主表数据；
 			 * 考虑是价格优行还是信用优先
 			 * 2、根据主路线、主表相关内容、派车原则选择该线路对应的承运商、承运商帐号、并从线路价格汇总中带出主路线价格；
 			 * 3、根据线路明细得出线路价格之和；
 			 * 4、回写以上信息，并将费用之和分摊至各产品明细分摊费用中
 			 * 
 			 */
 			String sql = "select * from uf_lo_loadplan where requestid = '"+requestid+"'";
 			double citypricesum = 0.0;
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
 				String arrivecity = ((Map) list.get(0)).get("arrivecity") == null?"":((Map)list.get(0)).get("arrivecity").toString();//主线路送达地址rconname
 				String rconcode = ((Map) list.get(0)).get("rconcode") == null?"":((Map)list.get(0)).get("rconcode").toString();//推荐承运商编号
 				String rconname = ((Map) list.get(0)).get("rconname") == null?"":((Map)list.get(0)).get("rconname").toString();//推荐承运商名称
 				String currentdate = DateHelper.getCurrentDate();//得到当前日期用于匹配线路价格汇总表的有效线路价格
 				String sql1 = "";
 				if(!rconname.equals("")&&!pricetype.equals("")&&sendtype.equals("402864d14931fb790149324ec6de0006")){//价格优先
					double lineprice = 0.0;//主线路价格
					double mcityprice = 0.0;//主线路同城价格
					int mcitiesnums = 0;//主线路同城个数
					double mcitypricesum = 0.0;//主线路同城价之和			 					
 					if(pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0524")||pricetype.equalsIgnoreCase("40285a904a055ae2014a09c8de0d1e9a")||pricetype.equalsIgnoreCase("40285a904a055ae2014a09c9007e1e9e")){//包车、单拖、双拖时需判断吨位
 						sql1 = "and a.tstart= '"+transitton+"'";
 						String sqlb = "select a.consolidator,a.lineprice,a.cityprice from (select a.consolidator,a.lineprice,a.cityprice from uf_lo_trackprice a where a.consolidator='"+rconname+"' and a.linecode='"+linecode+"' and a.linetype = '"+linetype+"' and a.cartype = '"+cartype+"' and a.transittype='"+transittype+"' and a.company = '"+factory+"' and a.pricetype ='"+pricetype+"'" +sql1+" and '"+currentdate+"' between a.valid and a.validutil and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) order by a.lineprice asc) where rownum=1";//取得主线路价
 						List listb = baseJdbcDao.executeSqlForList(sqlb);
 						if(listb.size()>0){
 							lineprice = Double.parseDouble(((Map) listb.get(0)).get("lineprice") == null?"0.0":((Map)listb.get(0)).get("lineprice").toString());
 							mcityprice = Double.parseDouble(((Map) listb.get(0)).get("cityprice") == null?"0.0":((Map)listb.get(0)).get("cityprice").toString());
 						}
 						String sqln = "select nvl(count(distinct(shiptoaddress)),0) num from uf_lo_loaddetail where requestid='"+requestid+"' and shiptoaddress !='"+arrivecity+"' and shiptoaddress like '"+arrivecity.substring(0, 4)+"%'";
 						String num = ds.getValue(sqln);
 						if(!num.equals("")){
 							mcitiesnums = Integer.parseInt(num);
 							mcitypricesum = mcitiesnums * mcityprice;
 						}
 						/*
 						 * 1、判断辅线路是否选择完全，不完全则提示，控制流程不可提交。
 						 *   a、主线路的同城；
 						 *   b、辅助线路的同城；
 						 *   c、(a+1)+(b+1)如果小于线路之和，则提示辅助线路选择不完全。
 						 * 2、找辅助路线价格，并计算同城个数，同城个数价格，并更新装卸计划。
 						 * 3、如果是配载的则无辅助线路
 						 */
 						int fcitiesnums = 0;//辅助线路城市点总数
 						double fcitypricesum = 0.0;//辅助线路同城价之和总数
 						double fxlpricesum = 0.0;//辅助线路价之和
 						String sqlf = "select a.id,a.linecode,b.linecode as lcode,b.remark,a.arrivecity from uf_lo_assistline a,uf_lo_haulingtrack b where a.linecode = b.requestid and a.requestid='"+requestid+"' and exists(select c.id from formbase c where b.requestid=c.id and c.isdelete=0)";
 						List listf = baseJdbcDao.executeSqlForList(sqlf);
 						if(listf.size()>0){
 							for(int f = 0;f<listf.size();f++){
 								String id = ((Map)listf.get(f)).get("id").toString();
 								String linecodef = ((Map)listf.get(f)).get("linecode").toString();
 								String farrivecity = ((Map)listf.get(f)).get("arrivecity").toString();//辅助线路6位编号
 								String remark = ((Map)listf.get(f)).get("remark").toString();//线路名称
 								String fzps = "select lineprice from (select a.lineprice from uf_lo_trackprice a where a.consolidator='"+rconname+"' and a.linecode='"+linecodef+"' and a.linetype = '40285a9048f924a70148fccf1a0c0270' and a.cartype = '"+cartype+"' and a.transittype='"+transittype+"' and a.company = '"+factory+"' and a.pricetype ='"+pricetype+"' " +sql1+" and '"+currentdate+"' between a.valid and a.validutil and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) order by a.lineprice asc) where rownum=1";
 								String lprice = ds.getValue(fzps);
 								double fzlprice = 0.0;//辅助路线价格
 								if(!lprice.equals("")){
 									fzlprice = Double.parseDouble(lprice);
 									baseJdbcDao.update("update uf_lo_assistline set lineprice = "+fzlprice+" where id='"+id+"'");
 									String sqlcn = "select nvl(count(distinct(shiptoaddress)),0) cnum from uf_lo_loaddetail where requestid='"+requestid+"' and shiptoaddress !='"+farrivecity+"' and shiptoaddress like '"+farrivecity.substring(0, 4)+"%'";
 									String cnum =ds.getValue(sqlcn);
 									int fcitiesnum = 0;//辅助线路同城个数
 									double citypric = 0.0;//辅助线路同城价之和	
 									fxlpricesum += fzlprice;
 									if(!cnum.equals("")){
 										fcitiesnum = Integer.parseInt(cnum);//辅助线路同城个数
 										citypric = fcitiesnum * fzlprice;
 									}
 									fcitiesnums += fcitiesnum;
 									fcitypricesum += citypric;
 								}
 							}					
 						}
 						citypricesum = mcitypricesum + fcitypricesum;//同城价格之和
 						int allcitynums = fcitiesnums+mcitiesnums;//同城个数合
 						double fare = lineprice+citypricesum+fxlpricesum;
 						if(fare<=0){
 							flag ="价格计算有错，请检查！";
 						} 			
 		 				double tonnum = Double.parseDouble(ds.getValue("select nvl(b.objdesc,0) tonnum from uf_lo_loadplan a,selectitem b where a.transitton=b.id and a.transitton='"+transitton+"'"));
 		 				double tonsum = Double.parseDouble(ds.getValue("select nvl(sum(deliverdnum)/1000,0.00) dsum from uf_lo_loaddetail where requestid='"+requestid+"'"));
 		 				if(tonsum>tonnum){
 		 					flag=flag+"吨数超出";
 		 				} 						
 						baseJdbcDao.update("update uf_lo_loadplan set flag='"+flag+"',mainprice="+lineprice+",assistprice="+fcitypricesum+",cities="+allcitynums+",cityprice="+citypricesum+",fare="+fare+" where requestid='"+requestid+"'");
 						//运费分摊
 						LoadPlanService ft = new LoadPlanService();
 						ft.planningFreightExes(fare, requestid); 				 						
 					}
 					if(pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0525")||pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0526")||pricetype.equalsIgnoreCase("40285a904a9639b6014a98ec072b0acb")){//配载、计件、散装时
 						sql1 = "and tend= '"+transitton+"'";
 						String sqlb = "select consolidator,lineprice,cityprice from (select a.consolidator,a.lineprice,a.cityprice from uf_lo_trackprice a where a.consolidator='"+rconname+"' and a.linecode='"+linecode+"' and a.linetype = '"+linetype+"' and a.cartype = '"+cartype+"' and a.transittype='"+transittype+"' and a.company = '"+factory+"' and a.pricetype ='"+pricetype+"'" +sql1+" and '"+currentdate+"' between a.valid and a.validutil and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) order by a.lineprice asc) where rownum=1";//取得主线路价
 						List listb = baseJdbcDao.executeSqlForList(sqlb);
 						if(listb.size()>0){
 							lineprice = Double.parseDouble(((Map) listb.get(0)).get("lineprice") == null?"0.0":((Map)listb.get(0)).get("lineprice").toString());
 							mcityprice = Double.parseDouble(((Map) listb.get(0)).get("cityprice") == null?"0.0":((Map)listb.get(0)).get("cityprice").toString());
 						}
/* 						String sqln = "select nvl(count(id),0) num from uf_lo_loaddetail where requestid='"+requestid+"' and shiptoaddress !='"+arrivecity+"' and shiptoaddress like '"+arrivecity.substring(0, 4)+"%'";
 						String num = ds.getValue(sqln);
 						if(!num.equals("")){
 							mcitiesnums = Integer.parseInt(num);
 							mcitypricesum = mcitiesnums * mcityprice;
 						}*/
 						/*
 						 * 1、配载则把明细总重加起来*单价得出总运费，无同城等。
 						 * 
 						 */
 						int fcitiesnums = 0;//辅助线路城市点总数
 						double fcitypricesum = 0.0;//辅助线路同城价之和总数
 						double fxlpricesum = 0.0;//辅助线路价之和
 						String sqlcn = "select nvl(sum(deliverdnum)/1000,0.00) dsum from uf_lo_loaddetail where requestid='"+requestid+"'";
 						Double dsum = Double.parseDouble(ds.getValue(sqlcn));
 						lineprice = lineprice*dsum;//配置算出运费总价
 						citypricesum = mcitypricesum + fcitypricesum;//同城价格之和
 						int allcitynums = fcitiesnums+mcitiesnums;//同城个数合
 						double fare = lineprice+citypricesum+fxlpricesum;
 						if(fare<=0){
 							flag ="配载价格计算有错，请检查！";
 						}
 		 				double tonnum = Double.parseDouble(ds.getValue("select nvl(b.objdesc,0) tonnum from uf_lo_loadplan a,selectitem b where a.transitton=b.id and a.transitton='"+transitton+"'"));
 		 				double tonsum = Double.parseDouble(ds.getValue("select nvl(sum(deliverdnum)/1000,0.00) dsum from uf_lo_loaddetail where requestid='"+requestid+"'"));
 		 				if(tonsum>tonnum){
 		 					flag=flag+"吨数超出";
 		 				} 	 						
 						baseJdbcDao.update("update uf_lo_loadplan set flag='"+flag+"',mainprice="+lineprice+",assistprice="+fcitypricesum+",cities="+allcitynums+",cityprice="+citypricesum+",fare="+fare+" where requestid='"+requestid+"'");
 						//运费分摊
 						LoadPlanService ft = new LoadPlanService();
 						ft.planningFreightExes(fare, requestid); 	 						
 					}	
 				}else if(!rconname.equals("")&&!pricetype.equals("")&&sendtype.equals("402864d14931fb790149324ec6de0007")){//信用优先
 					flag = "系统暂不支持信用优先运输，请先调整！";
 					baseJdbcDao.update("update uf_lo_loadplan set flag='"+flag+"' where requestid='"+requestid+"'"); 
 					return;	
 				}else{
 					flag = "请先完善装卸计划必填字段，再计算运费！";
 					baseJdbcDao.update("update uf_lo_loadplan set flag='"+flag+"' where requestid='"+requestid+"'"); 					
 					return ;
 				}
 				
 			}else{
 				flag = "该装卸计划尚未保存！";
 				return;
 			}
			//运费分摊
//			LoadPlanService ft = new LoadPlanService();
//			ft.planningFreightExes(citypricesum, requestid); 			
 			//更新
// 			baseJdbcDao.update("update uf_lo_loadplan set flag='OK' where requestid='"+requestid+"'");
 		}catch (Exception e) {
 			e.printStackTrace();
 	     }				
 	}		 
 }
