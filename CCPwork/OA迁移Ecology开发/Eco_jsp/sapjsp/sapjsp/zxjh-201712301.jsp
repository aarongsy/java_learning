<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%
	String[] strs;
	String type = request.getParameter("type");
	RecordSet rs = new RecordSet();
	rs.writeLog("进入zxjh.jsp");

	JSONArray jsonArr = new JSONArray();

	if (type.equals("yg")) {
		strs = request.getParameterValues("ghs[]");
		rs.writeLog("获得的数组为：" + strs.toString() + ",类型为：" + type);
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT c.gh,c.ph,c.sl,d.* from ")
				.append(" (SELECT a.gh gh,b.jydh jydh,b.xc xc,b.ph ph,b.bczxsl sl")
				.append(" from formtable_main_43 a,formtable_main_43_dt1 b where a.SFZF='0'and a.id=b.mainid");
                if(strs.length>1){
                        sql.append(" and a.gh in (");
                    for (int i = 0; i <strs.length ; i++) {
                        sql.append("'"+strs[i]+"'");
                        if(i!=strs.length-1){
                            sql.append(",");
                        }else{
                            sql.append(")");
                        }
                    }
                }else{
                    sql.append(" and a.gh='"+strs[0]+"'");
                }
				sql.append(") c,uf_spghsr d where c.xc=d.DELIVERYITEM and c.JYDH=d.DELIVERYNO");

		//out.print(sql);
		rs.executeSql(sql.toString());
		rs.writeLog("装卸计划有柜执行sql：" + sql.toString());

		while (rs.next()) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("gh", rs.getString("gh"));//柜号
			map.put("ph", rs.getString("ph"));//批号
			map.put("jydh", rs.getString("DELIVERYNO"));//交运单号
			map.put("xc", rs.getString("DELIVERYITEM"));//项次
			map.put("sl", rs.getString("sl"));//数量
			map.put("cp", rs.getString("PROCATEGORY"));//产品

			map.put("SALEORDER", Util.null2String(rs.getString("SALEORDER")));//销售订单
			map.put("ORDERITEM", Util.null2String(rs.getString("ORDERITEM")));//销售订单项次
			map.put("STOCKNO", Util.null2String(rs.getString("STOCKNO")));//物料号码
			map.put("STOCKDESC", Util.null2String(rs.getString("STOCKDESC")));//物料描述
			map.put("LOCATION", Util.null2String(rs.getString("LOCATION")));//库存位置
			map.put("SHIPNUM", Util.null2String(rs.getString("LFIMG")));//出货数量
			map.put("SALEUNIT", Util.null2String(rs.getString("SALEUNIT")));//单位代码
			map.put("SHIPTO", Util.null2String(rs.getString("SHIPTO")));//送达方名称
			map.put("SHIPTOADDR", Util.null2String(rs.getString("SHIPTOADDR")));//送达方地址
			map.put("REALSHIPNUM", Util.null2String(rs.getString("YCHL")));//实际出货数量
			map.put("COSTCENTER", Util.null2String(rs.getString("COSTCENTER")));//成本中心
			map.put("LCEN", Util.null2String(rs.getString("LCEN")));//利润中心
			map.put("MATERDES", Util.null2String(rs.getString("MATERDES")));//客户物料描述
			map.put("CUSORDNO", Util.null2String(rs.getString("CUSORDNO")));//客户订单编号
			map.put("ORDERADVICENO", Util.null2String(rs.getString("ORDERADVICENO")));//OrderAdvice编号
			map.put("SOLDTO", Util.null2String(rs.getString("SOLDTO")));//售达方名称
			map.put("SOLDTOADDR", Util.null2String(rs.getString("SOLDTOADDR")));//售达方地址
			map.put("ZWEIGHT", Util.null2String(rs.getString("ZWEIGHT")));//包材重量
			map.put("NTGEW", Util.null2String(rs.getString("NTGEW")));//净重量
			map.put("LOCATION", Util.null2String(rs.getString("LOCATION")));//库位代码
			map.put("PACK", Util.null2String(rs.getString("PACK")));//包装性质
			map.put("SHIPTOADDR", Util.null2String(rs.getString("SHIPTOADDR")));//送达方
			map.put("CLOSEDATE",Util.null2String(rs.getString("CLOSEDATE")));//预计结关日期


			jsonArr.add(map);
		}
	}
	if (type.equals("wg")) {
		strs = request.getParameterValues("ghs[]");
		rs.writeLog("获得的数组为：" + strs.toString() + ",类型为：" + type);
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM UF_SPGHSR WHERE 1=1");

		for (int i = 0; i < strs.length; i++) {
			if (i == 0)
				sql.append(" and SHIPADVICENO='").append(strs[i] + "'");
			else
				sql.append(" or SHIPADVICENO='").append(strs[i] + "'");
		}
		rs.executeSql(sql.toString());
		rs.writeLog("装卸计划无柜执行sql：" + sql.toString());
		while (rs.next()) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("SHIPADVICENO", Util.null2String(rs.getString("SHIPADVICENO")));//SHIPPING
			map.put("DELIVERYNO", Util.null2String(rs.getString("DELIVERYNO")));//交运单号
			map.put("DELIVERYITEM", Util.null2String(rs.getString("DELIVERYITEM")));//项次
			map.put("PROCATEGORY", Util.null2String(rs.getString("PROCATEGORY")));//产品
			map.put("SALEORDER", Util.null2String(rs.getString("SALEORDER")));//销售订单
			map.put("ORDERITEM", Util.null2String(rs.getString("ORDERITEM")));//销售订单项次
			map.put("STOCKNO", Util.null2String(rs.getString("STOCKNO")));//物料号码
			map.put("STOCKDESC", Util.null2String(rs.getString("STOCKDESC")));//物料描述
			map.put("LOCATION", Util.null2String(rs.getString("LOCATION")));//库存位置
			map.put("SHIPNUM", Util.null2String(rs.getString("YCHL")));//出货数量
			map.put("SALEUNIT", Util.null2String(rs.getString("SALEUNIT")));//单位代码
			map.put("SHIPTO", Util.null2String(rs.getString("SHIPTO")));//送达方名称
			map.put("SHIPTOADDR", Util.null2String(rs.getString("SHIPTOADDR")));//送达方地址
			map.put("LFIMG", Util.null2String(rs.getString("LFIMG")));//数量
			map.put("COSTCENTER", Util.null2String(rs.getString("COSTCENTER")));//成本中心
			map.put("LCEN", Util.null2String(rs.getString("LCEN")));//利润中心
			map.put("MATERDES", Util.null2String(rs.getString("MATERDES")));//客户物料描述
			map.put("CUSORDNO", Util.null2String(rs.getString("CUSORDNO")));//客户订单编号
			map.put("ORDERADVICENO", Util.null2String(rs.getString("ORDERADVICENO")));//OrderAdvice编号
			map.put("SOLDTO", Util.null2String(rs.getString("SOLDTO")));//售达方名称
			map.put("SOLDTOADDR", Util.null2String(rs.getString("SOLDTOADDR")));//售达方地址
			map.put("ZWEIGHT", Util.null2String(rs.getString("ZWEIGHT")));//包材重量
			map.put("NTGEW", Util.null2String(rs.getString("NTGEW")));//净数量
			map.put("CLOSEDATE",Util.null2String(rs.getString("CLOSEDATE")));//预计结关日期
			jsonArr.add(map);
		}

	}

	//无柜--校验运输数量
	if (type.equals("checkCount")) {
		try {
			rs.writeLog("checkCount");
			String mxdata = request.getParameter("dtdata");
			String sfzf=request.getParameter("sfzf");
			rs.writeLog("获得参数：是否作废="+sfzf);
			if(sfzf.equals("1")){
				out.write("success");
				return;
			}


			if (mxdata.equals("") || mxdata == null) {
				out.write("获得数据为空！");
				return;
			}
			String sql = "";
			JSONArray jsonArray = new JSONArray();
			jsonArray = JSONArray.fromObject(mxdata);
			rs.writeLog("获得的数组为：" + jsonArray.toString());

			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject jsObject = jsonArray.getJSONObject(i);
				String sono = jsObject.getString("sono");
				String soitem = jsObject.getString("soitem");
				sql = "select lfimg,ychl from uf_spghsr where DELIVERYNO='" + sono + "' and DELIVERYITEM='"
						+ soitem + "'";
				rs.writeLog(sql);
				rs.execute(sql);
				while (rs.next()) {
					String LFIMG = rs.getString("lfimg");//总量
					String ychl = rs.getString("ychl");//已出货量
					Double nowCounts = calCulate(LFIMG, ychl, "sub");
					rs.writeLog("总量为：" + LFIMG + ",已出货量为：" + ychl + ",剩余数量为：" + nowCounts);
					Double insertSL = Double.valueOf(jsObject.getString("plannum")).doubleValue();
					if (nowCounts < insertSL) {
						out.write("插入数据库中时发现 订单号为：" + sono + ",项次为：" + soitem + ",本次插入数量为:" + insertSL
								+ ",超过了系统实际剩余量:" + nowCounts);
						return;
					}
					//Double insertSL2=calCulate(LFIMG, jsObject.getString("plannum"),"add");
					//sql="UPDATE uf_spghsr SET SHIPNUM='"+insertSL2+"' WHERE DELIVERYNO='"+sono+"' and DELIVERYITEM='"+soitem+"'";
					//rs.writeLog(sql);
					//rs.execute(sql);

				}
			}
			out.write("success");
			return;

		} catch (Exception e) {
			rs.writeLog("fail--" + e);
			out.write("fail--" + e);
		}
	}

	//有柜---校验封签号
	if (type.equals("updateFqh")) {
		try {
			String mxdata = request.getParameter("dtdata");
			String shipno = request.getParameter("shipno");
			rs.writeLog("进入updateFqh");

			if (mxdata.equals("") || mxdata == null) {
				out.write("获得数据为空！");
				return;
			}
			String sql = "";
			JSONArray jsonArray = new JSONArray();
			jsonArray = JSONArray.fromObject(mxdata);
			rs.writeLog("获得的数组为：" + jsonArray.toString());
			rs.writeLog("获得shipno:" + shipno);
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject jsObject = jsonArray.getJSONObject(i);
				String gh = jsObject.getString("gh");
				String fqh = jsObject.getString("fqh");
				sql = "SELECT a.SHIPPING,b.code,b.fqh,b.id FROM UF_GHLR a,UF_GHLR_DT1 b where a.id=b.MAINID and a.SHIPPING='"
						+ shipno + "' and b.code='" + gh + "'";
				rs.writeLog(sql);
				rs.execute(sql);
				String fqh2 = "";
				String ghid = "";
				while (rs.next()) {
					fqh2 = Util.null2String(rs.getString("fqh"));
					ghid = Util.null2String(rs.getString("id"));
					break;
				}
				rs.writeLog("获得封签号：" + fqh2 + ",柜号id" + ghid);
				if (!fqh2.equals("")) {
					out.write("提示！柜号为：" + gh + "的柜子已有封签号：" + fqh2);
					return;
				}
				if (ghid.equals("")) {
					out.write("提示！柜号为：" + gh + "的柜子查询不到");
					return;

				}
				//sql="update UF_GHLR_DT1 set fqh='"+fqh+"' where id="+ghid;
				//rs.writeLog(sql);
				//rs.execute(sql);

			}
			out.write("success");
			return;

		} catch (Exception e) {
			rs.writeLog("fail--" + e);
			out.write("fail--" + e);
			return;
		}
	}

	PrintWriter pw = response.getWriter();
	rs.writeLog("装卸计划返回JSON:" + jsonArr.toString());
	pw.write(jsonArr.toString());
	pw.flush();
	pw.close();
%>

<%!public Double calCulate(String str1, String str2, String action) {
	if (str1.equals("") || str1 == null) {

		str1 = "0.00";
	}
	if (str2.equals("") || str2 == null) {

		str2 = "0.00";
	}
	//计算净重的绝对值
	BigDecimal b1 = new BigDecimal(str1);
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