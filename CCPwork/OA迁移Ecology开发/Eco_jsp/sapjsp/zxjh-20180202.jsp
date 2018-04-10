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
<%@ page import="weaver.conn.EncodingUtils" %>
<%@ page import="weaver.general.Escape" %>
<%@ page import="org.apache.poi.hssf.record.Record" %>
<%
	String[] strs;
	String type = request.getParameter("type");
	RecordSet rs = new RecordSet();
	rs.writeLog("进入zxjh.jsp");

	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr2=new JSONArray();
	JSONObject jsonObject=new JSONObject();
	strs = request.getParameterValues("ghs[]");
	String tablename="uf_solhsq";
	/**有柜情况 根据理货申请流程的id 查询 理货申请有柜的明细-放在jsonarry1，以及有柜ship及柜号返回--放在--jsonarray2
	 */
	if (type.equals("yg")) {
		rs.writeLog("获得的理货编号id为：" + strs.toString() + ",类型为：" + type);
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT c.gh,c.ph,c.sl,d.* from ")
				.append(" (SELECT a.gh gh,b.jydh jydh,b.xc xc,b.sapph ph,b.bczxsl sl")
				.append(" from uf_solhsq a,uf_solhsq_dt1 b where a.SFZF='0'and a.id=b.mainid");
		if(strs.length>0){
		    if (strs.length==1) {
				sql.append(" and a.id=" + strs[0]);
			}
		    if (strs.length>1) {
				sql.append(" and a.id in(" );
				for (int i = 0; i <strs.length ; i++) {
				    String str=strs[i];
				    if (i!=strs.length-1) {
						sql.append(str + ",");
					}else {
						sql.append(str);

					}

				}
				sql.append(")");
			}

		}
		sql.append(") c,uf_spghsr d where c.xc=d.DELIVERYITEM and c.JYDH=d.DELIVERYNO");

		//out.print(sql);
		rs.executeSql(sql.toString());
		rs.writeLog("装卸计划有柜执行sql：" + sql.toString());

		while (rs.next()) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("gh", rs.getString("gh"));//柜号
			map.put("ph", rs.getString("ph"));//批号
			map.put("DELIVERYNO", rs.getString("DELIVERYNO"));//交运单号
			map.put("DELIVERYITEM", rs.getString("DELIVERYITEM"));//项次
			map.put("LFIMG", Util.null2String(rs.getString("LFIMG")));//数量

			map.put("sl", rs.getString("sl"));//本次计划装卸数量
			map.put("PROCATEGORY", rs.getString("PROCATEGORY"));//产品

			map.put("SALEORDER", Util.null2String(rs.getString("SALEORDER")));//销售订单
			map.put("SHIPADVICENO", Util.null2String(rs.getString("SHIPADVICENO")));//SHIPPING


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
//			map.put("NTGEW", Util.null2String(rs.getString("lljz")));//净重量
			map.put("LOCATION", Util.null2String(rs.getString("LOCATION")));//库位代码
			map.put("PACK", Util.null2String(rs.getString("PACK")));//包装性质
			map.put("SHIPTOADDR", Util.null2String(rs.getString("SHIPTOADDR")));//送达方地址
			map.put("CLOSEDATE",Util.null2String(rs.getString("CLOSEDATE")));//预计结关日期

			map.put("ORDERITEM", Util.null2String(rs.getString("ORDERITEM")));//销售订单项次
			map.put("AUART",Util.null2String(rs.getString("AUART")));//销售订单类型
			map.put("SPART",Util.null2String(rs.getString("SPART")));//产品组
			map.put("LGOBE",Util.null2String(rs.getString("LGOBE")));//库位地址
			map.put("REMARK1",Util.null2String(rs.getString("REMARK1")));//单位描述
			map.put("VKAUS",Util.null2String(rs.getString("VKAUS")));//包装性质
			map.put("KUNNR",Util.null2String(rs.getString("KUNNR")));//运达方简码
			map.put("KUNAG",Util.null2String(rs.getString("KUNAG")));//售达方简码
			map.put("sl",Util.null2String(rs.getString("sl")));//计划运载量
			map.put("gbm",Util.null2String(rs.getString("gh")));//柜编码
			map.put("ph",Util.null2String(rs.getString("ph")));//批号



			jsonArr.add(map);
		}

		StringBuffer sql2=new StringBuffer();
		sql2.append("select SHIPPING,GH from uf_solhsq where 1=1");
		if(strs.length>0){
			if (strs.length==1) {
				sql2.append(" and id=" + strs[0]);
			}
			if (strs.length>1) {
				sql2.append(" and id in(" );
				for (int i = 0; i <strs.length ; i++) {
					String str=strs[i];
					if (i!=strs.length-1) {
						sql2.append(str + ",");
					}else {
						sql2.append(str);

					}

				}
				sql2.append(")");
			}

		}
		rs.writeLog(sql2.toString());
		rs.execute(sql2.toString());
		while (rs.next()){
			String shipno=Util.null2String(rs.getString("shipping"));
			String gh=Util.null2String(rs.getString("gh"));

            String xh=getXH(shipno,gh,"1");
            JSONObject jsonObject1=new JSONObject();
			jsonObject1.put("shipping",shipno);
			jsonObject1.put("gh",gh);
			jsonObject1.put("gh2",gh);
			jsonObject1.put("xh",xh);
			jsonArr2.add(jsonObject1);
		}

	}

	/**有无情况 根据理货申请流程的id 查询 理货申请无柜的明细-放在jsonarry1，以及有柜ship及柜号返回--放在--jsonarray2
	 */

	if (type.equals("wg")) {
		rs.writeLog("获得的流程id为：" + strs.toString() + ",类型为：" + type);
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT c.xngh,c.ph,c.sl,d.* from ")
				.append(" (SELECT a.gh gh,b.jydh jydh,b.xc xc,b.sapph ph,b.BPCZXSL sl,a.xngh")
				.append(" from uf_solhsq a,uf_solhsq_dt2 b where a.SFZF='0'and a.id=b.mainid");
		if(strs.length>0){
			if (strs.length==1) {
				sql.append(" and a.id=" + strs[0]);
			}
			if (strs.length>1) {
				sql.append(" and a.id in(" );
				for (int i = 0; i <strs.length ; i++) {
					String str=strs[i];
					if (i!=strs.length-1) {
						sql.append(str + ",");
					}else {
						sql.append(str);

					}

				}
				sql.append(")");
			}

		}
		sql.append(") c,uf_spghsr d where c.xc=d.DELIVERYITEM and c.JYDH=d.DELIVERYNO");


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
//			map.put("NTGEW", Util.null2String(rs.getString("lljz")));//净数量
			map.put("CLOSEDATE",Util.null2String(rs.getString("CLOSEDATE")));//预计结关日期

			map.put("ORDERITEM", Util.null2String(rs.getString("ORDERITEM")));//销售订单项次
			map.put("AUART",Util.null2String(rs.getString("AUART")));//销售订单类型
			map.put("SPART",Util.null2String(rs.getString("SPART")));//产品组
			map.put("LGOBE",Util.null2String(rs.getString("LGOBE")));//库位地址
			map.put("REMARK1",Util.null2String(rs.getString("REMARK1")));//单位描述
			map.put("VKAUS",Util.null2String(rs.getString("VKAUS")));//包装性质
			map.put("KUNNR",Util.null2String(rs.getString("KUNNR")));//运达方简码
			map.put("KUNAG",Util.null2String(rs.getString("KUNAG")));//售达方简码
			map.put("sl",Util.null2String(rs.getString("sl")));//计划运载量
			map.put("gbm",Util.null2String(rs.getString("xngh")));//柜编码
			map.put("ph",Util.null2String(rs.getString("ph")));//批号

			jsonArr.add(map);
		}

		StringBuffer sql2=new StringBuffer();
		sql2.append("select DISTINCT wgshipping,xngh from uf_solhsq where 1=1");
		if(strs.length>0){
			if (strs.length==1) {
				sql2.append(" and id=" + strs[0]);
			}
			if (strs.length>1) {
				sql2.append(" and id in(" );
				for (int i = 0; i <strs.length ; i++) {
					String str=strs[i];
					if (i!=strs.length-1) {
						sql2.append(str + ",");
					}else {
						sql2.append(str);

					}

				}
				sql2.append(")");
			}

		}
		rs.writeLog(sql2.toString());
		rs.execute(sql2.toString());
		while (rs.next()){
			String shipno=Util.null2String(rs.getString("wgshipping"));
			String gh=Util.null2String(rs.getString("xngh"));
            String xh=getXH(shipno,gh,"0");

			JSONObject jsonObject1=new JSONObject();
			jsonObject1.put("shipping",shipno);
			jsonObject1.put("gh",gh);
			jsonObject1.put("gh2",gh);
			jsonObject1.put("xh",xh);
			jsonArr2.add(jsonObject1);
		}
	}



	//---校验封签号
	if (type.equals("updateFqh")) {
		try {
		    request.setCharacterEncoding("UTF-8");
			String mxdata = request.getParameter("dtdata");
			String sfyg=request.getParameter("sfyg");//是否有柜
            rs.writeLog("sfyg:"+sfyg+",mxdata:"+mxdata);
			String detailtname="";
			if ("0".equals(sfyg)){
			    detailtname="UF_GHLR_DT2";
			}
			if ("1".equals(sfyg)){
			    detailtname="UF_GHLR_DT1";
			}
			rs.writeLog("进入updateFqh");

			if (mxdata.equals("") || mxdata == null) {
				out.write("获得数据为空！");
				return;
			}

			String sql = "";
			JSONArray jsonArray = new JSONArray();
			jsonArray = JSONArray.fromObject(mxdata);
			rs.writeLog("获得的数组为：" + jsonArray.toString());
			//rs.writeLog("获得shipno:" + shipno);
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject jsObject = jsonArray.getJSONObject(i);
				String gh1 = jsObject.getString("gh");
				String shipno=jsObject.getString("shipno");
//				String gh2=new String(gh1.getBytes("ISO-8859-1"),"GB2312");
				byte bytes[] = {(byte) 0xC2,(byte) 0xA0};
				String UTFSpace = new String(bytes,"utf-8");
				String gh= gh1.replaceAll(UTFSpace, " ");
				rs.writeLog("gh:"+gh);
				//String fqh = jsObject.getString("fqh");
				sql = "SELECT a.SHIPPING,b.code,b.fqh,b.id FROM UF_GHLR a,"+detailtname+" b where a.id=b.MAINID and a.SHIPPING='"
						+ shipno + "' and b.code='" + gh + "'";
				rs.writeLog(sql);
				rs.execute(sql);
				String fqh2 = "";
				String ghid = "";
				if (rs.next()) {
					fqh2 = Util.null2String(rs.getString("fqh"));
					ghid = Util.null2String(rs.getString("id"));
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
	jsonObject.put("arr1",jsonArr);
	jsonObject.put("arr2",jsonArr2);
	PrintWriter pw = response.getWriter();
	rs.writeLog("装卸计划返回JSON:" + jsonObject.toString());
	pw.write(jsonObject.toString());
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
<%!public  String getXH(String shipno,String gh,String sfyg){
    String detailtname="";
    String xh="";
    if ("0".equals(sfyg)){
        detailtname="UF_GHLR_Dt2";
    }
    if ("1".equals(sfyg)){
        detailtname="UF_GHLR_Dt1";
    }
    RecordSet recordSet=new RecordSet();
    String sql = "SELECT a.cabtype FROM UF_GHLR a,"+detailtname+" b where a.id=b.MAINID and a.SHIPPING='"
            + shipno + "' and b.code='" + gh + "'";
    recordSet.writeLog(sql);
    recordSet.execute(sql);
    if (recordSet.next()){
        xh=Util.null2String(recordSet.getString("cabtype"));
    }
    return xh;
}

%>