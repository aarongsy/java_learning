
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.Util"%>
<%
RecordSet rs=new RecordSet();
rs.writeLog("进入checkAcount");
String strs=request.getParameter("js");
JSONObject jsObject=JSONObject.fromObject(strs);
rs.writeLog("获得JSON:"+jsObject);

String sql="";
String compcode=(jsObject.getString("compcode"));
String startdate=Util.null2String(jsObject.getString("startdate"));
String enddate=Util.null2String(jsObject.getString("enddate"));
String costtype=Util.null2String(jsObject.getString("costtype"));
String kpyz=Util.null2String(jsObject.getString("kpyz"));
String carriercode=Util.null2String(jsObject.getString("carriercode")); //供应商id
String cyscode=Util.null2String(jsObject.getString("cyscode"));
rs.writeLog("费用类型："+costtype);

StringBuffer sb=new StringBuffer();
//sb.append("SELECT a.zxplanno,a.lgbh,a.fylx,a.cysname,a.cx,a.dw,a.carno,a.amount,b.pono,b.notaxamt,b.ddlx,b.zl,b.khdz,b.orderitem,b.wlh")  
//		.append(",a.HL,a.cyscode,b.costcenter,b.account,a.currency,a.sappzh,a.djbh,b.JZDM")
//		.append(" from uf_zgfy a,UF_ZGFY_DT1 b  where a.id=b.MAINID and b.jzdm='40' AND a.DJSTATUS='1'");
		
		
	sb.append("SELECT a.zxplanno,a.lgbh,a.djlx,a.fylx,(select fylx from uf_fylx where id=a.fylx) fylxname,a.cysname,(select conname from uf_dmlo_consolidat where id=a.cysname) cysnametxt,a.cx,(select cartype from uf_clcxgl where id=a.cx) cxtxt,a.dw,a.carno,a.amount,b.notaxamt")
	.append(",(select x.ddlx from UF_ZGFY_DT1 x where x.mainid=a.id and x.jzdm='40' and rownum=1 ) ddlx")
    .append(",a.HL,a.cyscode,b.pono,b.zl,b.khdz,b.orderitem,b.wlh,b.costcenter,b.account,a.currency,a.sappzh,a.djbh,b.JZDM")
     .append(" from uf_zgfy a,UF_ZGFY_DT1 b  where a.id=b.MAINID  AND a.DJSTATUS='1' and b.jzdm='50'");
if(!compcode.equals("")) {
	sb.append(" and a.comcode='" + compcode + "'");
}
if(!costtype.equals("")) {
	String[] fylxs = costtype.split(",");
	if (fylxs.length == 1) {
		sb.append(" and a.fylx='" + costtype + "'");
	} else {
		sb.append(" and a.fylx in (");
		for (int i = 0; i < fylxs.length; i++) {
			sb.append("'" + fylxs[i] + "'");
			if (i != fylxs.length - 1) {
				sb.append(",");
			}else {
				sb.append(")");
			}
		}

	}
	if (!kpyz.equals("")) {
		sb.append(" and a.hbkpyz='" + kpyz + "'");
	}
//	if (!carriercode.equals("")) {
//		sb.append(" and a.cysname='" + carriercode + "'");
//	}
	if (!cyscode.equals("")) {
		sb.append(" and a.cyscode='" + cyscode + "'");
	}	
	if (!startdate.equals("") && !enddate.equals("")) {
		sb.append(" and a.credate between '" + startdate + "' and '" + enddate + "'");
	}
	if (startdate.equals("") && !enddate.equals("")) {
		sb.append(" and a.credate<'" + enddate + "'");
	}
	if (!startdate.equals("") && enddate.equals("")) {
		sb.append(" and a.credate>'" + startdate + "'s");
	}

	sql = sb.toString();
	try {
		rs.writeLog(sql);
		rs.execute(sql);
		JSONArray jsArray = new JSONArray();


		while (rs.next()) {
			String zxplanno = Util.null2String(rs.getString("zxplanno"));//装卸计划号
			String fylx = Util.null2String(rs.getString("fylx"));//费用类型
			String fylxname = Util.null2String(rs.getString("fylxname"));//费用类型文本
			String cysname = Util.null2String(rs.getString("cysname"));//承运商名称
			String cysnametxt = Util.null2String(rs.getString("cysnametxt"));//承运商名称文本
			
			//String zxplanno=Util.null2String(rs.getString("zxplanno"));运输时间
			String cx = Util.null2String(rs.getString("cx"));//车型
			String cxtxt = Util.null2String(rs.getString("cxtxt"));//车型文本			
			String dw = Util.null2String(rs.getString("dw"));//吨位（作废）
			String carno = Util.null2String(rs.getString("carno"));//车牌
			String zl = Util.null2String(rs.getString("zl"));//重量
			String khdz = Util.null2String(rs.getString("khdz"));//客户地址
			String amount = Util.null2String(rs.getString("amount"));//暂估含税金额（作废）
			String notaxamt = Util.null2String(rs.getString("notaxamt"));//暂估未税金额
			// String zxplanno=Util.null2String(rs.getString("zxplanno"));费用模式
			String orderitem = Util.null2String(rs.getString("orderitem"));//项次（不用了对账单）
			String pono = Util.null2String(rs.getString("pono"));//内部订单号（不用了对账单）
			String djlx = Util.null2String(rs.getString("djlx"));//单据类型
			//新增5个
			String hl = Util.null2String(rs.getString("hl"));//汇率
			String zfdx = Util.null2String(rs.getString("cyscode"));//支付对象
			String costcenter = Util.null2String(rs.getString("costcenter"));//成本中心
			String account = Util.null2String(rs.getString("account"));//总账科目
			String currency = Util.null2String(rs.getString("currency"));//暂估币种

			String djbh = Util.null2String(rs.getString("djbh"));//单据编号
			String sappzh = Util.null2String(rs.getString("sappzh"));//SAP凭证号
			String lgbh = Util.null2String(rs.getString("lgbh"));//理柜编号
			JSONObject jsObject2 = new JSONObject();
			jsObject2.put("zxplanno", zxplanno);
			jsObject2.put("fylx", fylx);
			jsObject2.put("fylx2", fylxname);
			jsObject2.put("cysname", cysname);
			jsObject2.put("cysname2", cysnametxt);
			jsObject2.put("carno", carno);
			jsObject2.put("amount", amount);
			jsObject2.put("notaxamt", notaxamt);
			jsObject2.put("djlx", djlx);
			jsObject2.put("cx", cx);
			jsObject2.put("cx2", cxtxt);
			jsObject2.put("dw", dw);
			//jsObject2.put("zl", zl);	//取消
			jsObject2.put("khdz", khdz);
			//jsObject2.put("orderitem", orderitem); //取消
			//jsObject2.put("pono", pono); //取消
			//新增五个
			jsObject2.put("hl", hl);
			jsObject2.put("zfdx", zfdx);
			jsObject2.put("costcenter", costcenter);
			jsObject2.put("account", account);
			jsObject2.put("currency", currency);

			jsObject2.put("djbh", djbh);
			jsObject2.put("sappzh", sappzh);
			jsObject2.put("lgbh", lgbh);

			RecordSet rs2 = new RecordSet();
			String cysname2 = "";

			/* xxy 2018-03-21 取消
			//根据承运商id查询名称 
			if (!"".equals(cysname)) {
				sql = "SELECT conname from uf_dmlo_consolidat where id=" + cysname;
				rs2.writeLog(sql);
				rs2.execute(sql);

				if (rs2.next()) {
					cysname2 = rs2.getString("conname");
				}
			}
			jsObject2.put("cysname2", cysname2);
			//根据车型id查询车型名称
			String cx2 = "";

			if (!"".equals(cx)) {
				sql = "SELECT cartype from uf_clcxgl where id=" + cx;

				rs2.writeLog(sql);
				rs2.execute(sql);
				if (rs2.next()) {
					cx2 = rs2.getString("cartype");
				}
			}
			jsObject2.put("cx2", cx2);
			

			//根据费用类型id查询费用类型名称
			String fylx2 = "";

			if (!"".equals(fylx)) {
				sql = "select fyms from uf_fylx where id=" + fylx;
				rs2.writeLog(sql);
				rs2.execute(sql);
				if (rs2.next()) {
					fylx2 = rs2.getString("fyms");
				}
			}
			jsObject2.put("fylx2", fylx2);
			*/

			//根据装卸计划号查询计费模式 xxy 改为单据类型djlx   SO /PO 判断
			if (djlx.equals("0") && !"".equals(zxplanno)) { //SO建模表
				//sql = "SELECT jfms,(select selectname from workflow_selectItem where fieldid=9686 and cancel=0 and selectvalue=JFMS) jfmstxt FROM formtable_main_45 where ZXJHH='" + zxplanno + "' and NVL(requestid,-1)=-1";
				sql = " SELECT distinct a.zxjhh,a.gbrq,a.gbzl,a.jfms,(select selectname from workflow_selectItem where fieldid=9686 and cancel=0 and selectvalue=a.JFMS) jfmstxt, b.shipping,(select to_char(wm_concat(distinct x.xsddh)) from formtable_main_45_dt3 x where x.mainid=a.id and b.shipping=x.shipno  ) saporderno FROM formtable_main_45 a,formtable_main_45_dt1 b  where  b.mainid=a.id and NVL(requestid,-1)=-1 and a.sfzf=0 and a.sfyyf=1 and a.zxjhh='" + zxplanno + "'";
			}
			if (djlx.equals("1") && !"".equals(zxplanno)) { //PO流程表
				sql = "SELECT distinct a.zxjhh,a.gbrq,a.gbzl,a.jfms,(select selectname from workflow_selectItem where fieldid=9686 and cancel=0 and selectvalue=JFMS) jfmstxt,'' shipping,b.pono saporderno from formtable_main_61 a,formtable_main_61_dt1 b where a.id=b.mainid and a.sfzf=0 and a.jfyyf=1 and a.sfyg=1 and a.zxjhh='" + zxplanno + "' "; //有柜明细
				sql = sql +" union all ";
				sql = sql +"SELECT distinct a.zxjhh,a.gbrq,a.gbzl,a.jfms,(select selectname from workflow_selectItem where fieldid=9686 and cancel=0 and selectvalue=JFMS) jfmstxt,'' shipping,b.pono saporderno from formtable_main_61 a,formtable_main_61_dt2 b where a.id=b.mainid and a.sfzf=0 and a.jfyyf=1 and a.sfyg=0 and a.zxjhh='" + zxplanno + "' "; //无柜明细
			}
			if (djlx.equals("2")) { //非SAP
			}
			rs2.writeLog(sql);
			rs2.execute(sql);
			String jfms = "";
			String jfms2 = "";
			String shipping = "";
			String gbrq = "";
			String gbzl = "";
			String saporderno = "";
			if (rs2.next()) {
				jfms = Util.null2String(rs2.getString("jfms"));
				jfms2= Util.null2String(rs2.getString("jfmstxt"));
				shipping = Util.null2String(rs2.getString("shipping"));
				gbrq = Util.null2String(rs2.getString("gbrq"));
				gbzl = Util.null2String(rs2.getString("gbzl"));
				saporderno = Util.null2String(rs2.getString("saporderno"));

			}
			jsObject2.put("jfms", jfms);
			jsObject2.put("jfms2", jfms2);
			jsObject2.put("shipping", shipping);
			jsObject2.put("gbrq", gbrq);
			jsObject2.put("saporderno", saporderno);
			jsObject2.put("zl", gbzl);			

			//根据订单号及项次查询物料号及客户地址 xxy修改为 改为单据类型djlx   SO /PO 判断  按装卸计划号获取shipping, 按shipping 获取送达方地址
			if (djlx.equals("0") && !"".equals(shipping) ) { //SO
				sql = "SELECT STOCKNO as wlh,KUNAG,SOLDTO,SOLDTOADDR,KUNNR,SHIPTO,shiptoaddr FROM UF_SPGHSR where shipadviceno='" + shipping + "' and rownum=1 ";
			}
			if (djlx.equals("1")) { //PO
				//sql = "SELECT wlh,'' shiptoaddr from uf_jmclxq where PONO='" + pono + "' and POITEM='" + orderitem + "'";
				sql = "select wlh,''KUNAG ,'' SOLDTO,'' SOLDTOADDR,gyscode KUNNR, gysname SHIPTO,'' shiptoaddr from uf_jmclxq where instr('"+saporderno+"',pono)>0 and rownum=1";
			}
			if (djlx.equals("3")) { //非SAP
			
			}
			rs2.writeLog(sql);
			rs2.execute(sql);
			String wlh = "";
			String shiptoaddr = "";
			if (rs2.next()) {
				wlh = rs2.getString("wlh");
				shiptoaddr = rs2.getString("shiptoaddr");
			}
			jsObject2.put("wlh", wlh);
			jsObject2.put("shiptoaddr", shiptoaddr);


			jsArray.add(jsObject2);
		}
		rs.writeLog(jsArray.toString());
		if (jsArray.size() > 0) {
			out.write(jsArray.toString());
			return;
		} else {
			out.write("查询不到数据");
			return;
		}
	} catch (Exception e) {
		e.printStackTrace();
		rs.writeLog("fail--" + e);
		out.write("fail--" + e);
	}
}
%>