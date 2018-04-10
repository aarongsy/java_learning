<%@page import="com.weaver.general.BaseBean"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.sap.mw.jco.*"%>
<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>

<%
	BaseBean bs = new BaseBean();
	String billids = request.getParameter("billids");
	JSONArray jsonArr = new JSONArray();
	JSONObject objectresult = new JSONObject();
	RecordSet rs = new RecordSet();
	bs.writeLog("进入SOSAPUPLOAD");
	String sql = "";
	String sql2 = "";
	String message = "";
	bs.writeLog("获得bills：" + billids);

	try {
		String[] bills = billids.split(",");

		for (int i = 0; i < bills.length; i++) {
			sql = "SELECT SAPUPLOAD,SALEUNIT,DELIVERYNO,DELIVERYITEM,LFIMG,YCHL,(LFIMG-YCHL) as syl FROM uf_spghsr WHERE ID="
					+ bills[i];
			bs.writeLog(sql);
			rs.execute(sql);

			String DELIVERYNO = "";//交运单号
			String DELIVERYITEM = "";//交运项次
			String containquan = "";//柜数
			String syl = "";//剩余量
			String VKAUS = "";//散装固定包装(包装别)
			String SAPUPLOAD = "";//SAP是否上抛 0-未上抛 1-已上抛
			int gs = 0;//INT型柜数

			
			String zxjhh = "";//装卸计划号
			String xc = "";//项次

			String cysmc = "";//车行名称
			String cp = "";//车号
			String GEWEI = "";//重量单位
			String CHARG = "";//批号
			String ZNETWEI = "";//出货净重数量(地磅磅值)
			String ZPACK = "";//包装性质
			String ZDATE_1 = "2017-12-15";//打印单据日期
			String ZDATE_2 = "2017-12-15";//进厂过磅日期
			String ZHB = "1";//合并过磅类型
			if (rs.next()) {
				DELIVERYNO = Util.null2String(rs.getString("DELIVERYNO"));//交运单号
				

			}
			JSONArray jsArray=new JSONArray();
			sql = "SELECT SAPUPLOAD,ID,VKAUS,containquan,DELIVERYNO,DELIVERYITEM,LFIMG,YCHL,SALEUNIT,(LFIMG-YCHL) as syl FROM uf_spghsr WHERE DELIVERYNO='"
					+ DELIVERYNO + "'";
			bs.writeLog(sql);
			rs.execute(sql);
			while (rs.next()) {
				
				Double jhyzlTotal = 0.00;//计划运载量总量
				Double LFIMG = 0.00;//SAP交运单对应项次的实际交货数量
				JSONObject jsObject=new JSONObject();
				
				DELIVERYNO = Util.null2String(rs.getString("DELIVERYNO"));//交运单号
				DELIVERYITEM = Util.null2String(rs.getString("DELIVERYITEM"));//交运项次
				containquan = Util.null2String(rs.getString("containquan"));//柜数
				if(containquan.equals("")){
					gs=0;
				}else{
				gs = Integer.parseInt(containquan);//INT型柜数
				}
				String LFIMG2 = Util.null2String(rs.getString("LFIMG"));//该项次的总量
				syl = Util.null2String(rs.getString("syl"));//剩余量
				VKAUS = Util.null2String(rs.getString("VKAUS"));//散装固定包装(包装别)
				SAPUPLOAD = Util.null2String(rs.getString("SAPUPLOAD"));//SAP是否上抛 0-未上抛 1-已上抛
				GEWEI = Util.null2String(rs.getString("SALEUNIT"));
				
				jsObject.put("DELIVERYNO", DELIVERYNO);
				jsObject.put("DELIVERYITEM", DELIVERYITEM);
				jsObject.put("LFIMG", LFIMG2);
				jsObject.put("GEWEI", GEWEI);
				ZPACK = VKAUS;
				if (ZPACK.equals("Z01")) {
					ZPACK = "BULK";
				}
				if (ZPACK.equals("Z02")) {
					ZPACK = "FIXED";
				}
				
				jsObject.put("ZPACK", ZPACK);
				jsObject.put("ZDATE_1", ZDATE_1);

				LFIMG=Double.parseDouble(LFIMG2);
				Double totalDouble2=0.00;//该项次的装卸计划运载总量
				
				//1、判断该交运单号是否已经上抛过SAP.
				if (SAPUPLOAD.equals("1")) {
					message = "交运单为" + DELIVERYNO + ",项次号为：" + DELIVERYITEM + "，该交运单已上抛过SAP， 不可重复上抛！";
					objectresult = returnErrMsg(message);
					out.write(objectresult.toString());
					bs.writeLog(objectresult.toString());
					return;
				}
				//2、包装类型≠Z02并且≠Z01，则提示“交运单号XXXX项次XX包装类别无法识别，无法上抛”（Z02：固定包装 Z01 ：散装 ）
				else if (!VKAUS.equals("Z01") && !VKAUS.equals("Z02")) {
					message = "交运单" + DELIVERYNO + "项次号" + DELIVERYITEM + "包装类别无法识别，无法上抛";
					objectresult = returnErrMsg(message);
					out.write(objectresult.toString());
					bs.writeLog(objectresult.toString());
					return;

				}
				//3、如果货物剩余数量大于0,则不能SAP上抛
				else if (Double.parseDouble(syl) > 0) {
					message = "交运单为" + DELIVERYNO + ",项次号为：" + DELIVERYITEM + "，仍有货物尚未装卸，无法上抛！";
					objectresult = returnErrMsg(message);
					out.write(objectresult.toString());
					bs.writeLog(objectresult.toString());
					return;
				} else {
					//无柜及有柜情况下的sql 根据交运单号及项次查找装卸计划--sql  ,根据交运单号及项次查找理货申请--sql2
					if (gs > 0) {
						sql = "SELECT a.cp,a.sfgb,a.zxjhh,a.cysmc,a.requestid,b.jhyzl,a.gbrq,b.sjftjz FROM formtable_main_45 a,FORMTABLE_MAIN_45_DT2 b WHERE a.id=b.MAINID and b.JYDH='"
								+ DELIVERYNO + "' and b.DDXC='" + DELIVERYITEM + "' AND a.sfzf='0'";
						sql2 = "SELECT b.sapph,b.BCZXSL,b.sapph FROM formtable_main_43 a,FORMTABLE_MAIN_43_DT1 b where a.id=b.MAINID and b.jydh='"
								+ DELIVERYNO + "' and b.xc='"+DELIVERYITEM+"' AND a.sfzf='0'";
					} else {
						sql = "SELECT a.sfgb,a.zxjhh,a.requestid,b.jhyzl,a.cp,a.sfgb,a.gbrq,b.sjftjz FROM formtable_main_45 a,FORMTABLE_MAIN_45_DT3 b WHERE a.id=b.MAINID and b.JYDH='"
								+ DELIVERYNO + "' and b.XC='" + DELIVERYITEM + "' AND a.sfzf='0'";
						sql2 = "SELECT a.zxjhh,b.sapph,b.BPCZXSL as BCZXSL,b.sapph FROM formtable_main_43 a,FORMTABLE_MAIN_43_DT2 b where a.id=b.MAINID and b.jydh='"
								+ DELIVERYNO + "' AND a.sfzf='0'";
					}
					bs.writeLog(sql);
					RecordSet rs3 = new RecordSet();
					rs3.execute(sql);
					JSONArray jsArray2=new JSONArray();
					
					while (rs3.next()) {
						
						String sfgb = Util.null2String(rs3.getString("sfgb"));//是否过磅  ---判断是否需要过磅的依据
						String lcid = Util.null2String(rs3.getString("requestid"));//装卸计划requestid
						zxjhh = Util.null2String(rs3.getString("zxjhh"));//装卸计划号
						String jhyzl = Util.null2String(rs3.getString("jhyzl"));//计划运载量
						bs.writeLog("获得计划装卸量：" + jhyzl);
						cp = Util.null2String(rs3.getString("cp"));//车牌
						cysmc = Util.null2String(rs3.getString("cysmc"));
						
						jsObject.put("cysmc", cysmc);
						jsObject.put("cp", cp);
						jsObject.put("zxjhh",zxjhh);
						jsObject.put("jz",Util.null2String(rs.getString("sjftjz")));
						
						//sql2+=" and b.bczxsl='"+jhyzl+"'";
						/*如果是过磅的：要判断该装卸计划的所有产品已经全部过磅了，如果有部分还没有过磅的，则不计入实际装卸数量的合计值，并有提示“装卸计划XXXX,
						需要过磅的装卸计划存在未过磅的产品明细不计入总量! ”*/
						if (sfgb.equals("1")) {
							String gbrq = Util.null2String(rs3.getString("gbrq"));//过磅日期
							if (gbrq.equals("")) {
								message = "装卸计划" + zxjhh + ",需要过磅的装卸计划存在未过磅的产品明细不计入总量!";
								objectresult = returnErrMsg(message);
								out.write(objectresult.toString());
								bs.writeLog(objectresult.toString());
								return;
							}
							jsObject.put("ZDATE_2", gbrq);

						}

						/*
						如果是不过磅的：要判断该装卸计划是否全部出货，如果有部分还没有装车出货的，则不计入实际装卸数量的合计值，并有提示“装卸计划XXXX, 
						不需要过磅的装卸计划存在未实际出货的产品明细不计入总量! ”
						*/
						else if (sfgb.equals("0")) {
							RecordSet rs2 = new RecordSet();
							sql = "SELECT trdh,SFDY FROM UF_TRDPLDY WHERE LCID=" + lcid;
							rs2.writeLog(sql);
							rs2.execute(sql);
							while (rs2.next()) {
								String sfdy = Util.null2String(rs2.getString("SFDY"));//是否打印
								String trdh = Util.null2String(rs2.getString("trdh"));//提入单号
								//判断提入单是否打印
								if (sfdy.equals("0")) {
									message = "装卸计划" + zxjhh + "提入单" + trdh + ", 不需要过磅的装卸计划存在未实际出货的产品明细不计入总量!";
									objectresult = returnErrMsg(message);
									out.write(objectresult.toString());
									bs.writeLog(objectresult.toString());
									return;
								}
							}

						} else {
							message = "装卸计划" + zxjhh + "的是否过磅为空！";
							objectresult = returnErrMsg(message);
							out.write(objectresult.toString());
							bs.writeLog(objectresult.toString());
							return;

						}
						totalDouble2 = calCulate(totalDouble2, jhyzl, "add");
						
						
						//jhyzlTotal = 10.0;
						
						
						bs.writeLog("获得单号："+DELIVERYNO+",项次："+DELIVERYITEM+"的数据：" + jsObject);
						//bs.writeLog("获得计划装卸量总量:" + jhyzlTotal);
						jsArray2.add(jsObject);
					}
					rs.writeLog("获得jsArray2:"+jsArray2);
					//查询批号
					RecordSet rs4=new RecordSet();

					bs.writeLog(sql2);
					rs4.execute(sql2);


					int jsarr=0;
					int jsArrCounts=jsArray2.size();
					JSONArray jsonArray=new JSONArray();
					while (rs4.next()) {
					    String zxjhh2=Util.null2String(rs4.getString("zxjhh"));
					    JSONObject jsonObject=new JSONObject();
						for (int j = 0; j < jsArray2.size(); j++) {
							JSONObject jsonObject1=jsArray2.getJSONObject(j);

							if(jsonObject1.get("zxjhh").equals(zxjhh2)){
							    jsonObject=jsonObject1;
							    bs.writeLog(jsonObject);
							    break;
							}
						}
						jsonObject.put("sapph", Util.null2String(rs4.getString("sapph")));
						jsonObject.put("LFIMG2", Util.null2String(rs4.getString("bczxsl")));//
						jsonArray.add(jsonObject);
					}
					jsArray2=jsonArray;
					rs.writeLog("增加数据后的jsArray2:"+jsArray2);
					for(int l=0;l<jsArray2.size();l++){
						JSONObject jsObject2=jsArray2.getJSONObject(l);
						jsArray.add(jsObject2);
					}
					
					
				}
				/*
				该交运单项次的实际装卸数量的合计值，如果<SAP交运单对应项次的实际交货数量, 则提示“交运单号XXXX项次XX, 实际装卸数量XXX未达到上
				抛标准xxxx，该交运单XXXX不可上抛”。 固定包装需要判断合计值与计划值如果有差异，不允许上抛。散装需要按照允差量计算差异，如果在最低允差之外，
				不允许上抛。*/
				if (totalDouble2<LFIMG) {
					message = "交运单号" + DELIVERYNO + "项次" + DELIVERYITEM + ", 实际装卸数量" + totalDouble2 + "未达到上抛标准"
							+ LFIMG + "，该交运单" + DELIVERYNO + "不可上抛";
					objectresult = returnErrMsg(message);
					out.write(objectresult.toString());
					bs.writeLog(objectresult.toString());
					return;
				}
				
				
			}
			bs.writeLog("获得单号"+DELIVERYNO+"的数据："+jsArray);
		
				
				//SAP上抛
				

				bs.writeLog("获得ZPACK值为：" + ZPACK);
				JCO.Client sapconnection = null;
				SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
				sapconnection = (JCO.Client) sapidsi.getConnection("1", new LogInfo());
				bs.writeLog("创建SAP连接");
				String strFunc = "Z_DELIVERY_TRAN_OA";

				JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
				IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
				JCO.Function function = ft.getFunction();
				bs.writeLog("SAP已连接，开始设定值...");
				function.getImportParameterList().setValue("UP", "FLAG");
				JCO.Table table1 = function.getTableParameterList().getTable("IT_ITEM_I");
				//测试数据
/*
				JSONArray jsArray2=new JSONArray();
				JSONObject jsonObject1=new JSONObject();
				jsonObject1.put("DELIVERYNO", "0008000138");
				jsonObject1.put("DELIVERYITEM", "000010");
				jsonObject1.put("GEWEI", "M01");
				jsonObject1.put("sapph", "M17090703");
				jsonObject1.put("jz", "880.000");
				jsonObject1.put("ZPACK", "BULK");
				jsonObject1.put("cp", "");
				jsonObject1.put("LFIMG", "3.000");
				jsonObject1.put("ZDATE_1", "");
				jsonObject1.put("ZDATE_2", "");
				jsonObject1.put("ZHB", "");
				jsonObject1.put("cysmc", "");
				
				JSONObject jsonObject2=new JSONObject();
				jsonObject2.put("DELIVERYNO", "0008000138");
				jsonObject2.put("DELIVERYITEM", "000010");
				jsonObject2.put("GEWEI", "M01");
				jsonObject2.put("sapph", "M17070303");
				jsonObject2.put("jz", "1300.000");
				jsonObject2.put("ZPACK", "BULK");
				jsonObject2.put("cp", "");
				jsonObject2.put("LFIMG", "5.000");
				jsonObject2.put("ZDATE_1", "");
				jsonObject2.put("ZDATE_2", "");
				jsonObject2.put("ZHB", "");
				jsonObject2.put("cysmc", "");
				jsArray2.add(jsonObject1);
				jsArray2.add(jsonObject2);
*/

				for (int k = 0; k < jsArray.size(); k++) {
					JSONObject jsonObject = jsArray.getJSONObject(k);
					table1.appendRow();
					bs.writeLog("第"+(k+1)+"行开始录入值...");
					rs.writeLog(jsonObject.toString());
					table1.setValue(jsonObject.get("DELIVERYNO"), "VBELN_VL");//单号
					table1.setValue(jsonObject.get("DELIVERYITEM"), "POSNR_VL");//项次
					table1.setValue(jsonObject.get("cysmc"), "GARAGE_N");//车行
					table1.setValue(jsonObject.get("cp"), "CAR_NO");//车号
					table1.setValue(jsonObject.get("LFIMG2"), "LFIMG");//本次装卸数量
					table1.setValue(jsonObject.get("GEWEI"), "GEWEI");//重量单位
					table1.setValue(jsonObject.get("sapph"), "CHARG");//批号
					table1.setValue(jsonObject.get("jz"), "NETWEI");//出货净重数量(地磅磅值)
					table1.setValue(jsonObject.get("ZPACK"), "PACK");//包装性质
					table1.setValue(jsonObject.get("ZDATE_1"), "ZDATE_1");//打印单据日期
					table1.setValue(jsonObject.get("ZDATE_2"), "ZDATE_2");//进厂过磅日期
					table1.setValue(jsonObject.get("ZHB"), "ZHB");//合并过磅（1,2.3）单独过磅1，合并过磅2，未过磅3。
				}

				bs.writeLog("设值完成，开始插入表...");
				sapconnection.execute(function);
				bs.writeLog("插表完成，开始获取IT_HEAD_LOG...");
				JCO.Table retable = function.getTableParameterList().getTable("IT_HEAD_LOG");
				bs.writeLog("返回表行数：" + retable.getNumRows());
				String result="";
				if(retable.getNumRows()>0){
				bs.writeLog("开始读取返回数据>>>>>>>>>>>>");

				for (int j = 0; j < retable.getNumRows(); j++) {
					retable.setRow(j);
					bs.writeLog("MANDT返回：" + retable.getString("MANDT"));
					bs.writeLog("VBELN_VL返回：" + retable.getString("VBELN_VL"));
					bs.writeLog("POSNR_VL返回：" + retable.getString("POSNR_VL"));
					bs.writeLog("ZMARK返回：" + retable.getString("ZMARK"));
					bs.writeLog("ZMESS返回：" + retable.getString("ZMESS"));
					if("S".equals(retable.getString("ZMARK"))){
						result="SOUPLOAD SUCCESS!";
					};
					if("E".equals(retable.getString("ZMARK"))){
						result="SOUPLOAD FAILED!";
					};
				}
				bs.writeLog("数据读取结束<<<<<<<<<<<<<");
				if(sapconnection!=null){
					JCO.releaseClient(sapconnection);
				}
				}
				updateSapUploadStatusByBills(bills);
				out.write(result);
			}
		

	} catch (Exception e) {
		e.printStackTrace();
		bs.writeLog("报错了！错误详情：" + e);
		out.write("报错了！错误详情：" + e);

	}
%>
<%!public JSONObject returnErrMsg(String message) {
		JSONObject jsObject = new JSONObject();
		jsObject.put("error", message);
		return jsObject;

	}%>

<%!public Double calCulate(Double d1, String str2, String action) {
		if (str2.equals("") || str2 == null) {

			str2 = "0.00";
		}
		//计算净重的绝对值
		BigDecimal b1 = new BigDecimal(d1);
		BigDecimal b2 = new BigDecimal(str2);
		Double b3 = 0.00;
		if (action.equals("add")) {
			b3 = b1.add(b2).doubleValue();
		}
		if (action.equals("sub")) {
			b3 = b1.subtract(b2).doubleValue();
		}
		return b3;
	}%>
<%!public void updateSapUploadStatusByBills(String[] bills){
    RecordSet recordSet=new RecordSet();

	for (int i = 0; i < bills.length; i++) {
	    String bill=bills[i];
	    String sql="update uf_spghsr set sapupload=1 where id="+bill;
	    recordSet.writeLog(sql);
	    recordSet.execute(sql);


	}
}

%>

