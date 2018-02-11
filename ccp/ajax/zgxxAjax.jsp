<%@page import="weaver.general.StaticObj"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.json.*"%>
<%@page import="weaver.general.*"%>
<%@page import="weaver.conn.*"%>
<%@page import="weaver.interfaces.xiyf.util.*"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	BaseBean bb = new BaseBean();
    BigDecimalCalculate bd = new BigDecimalCalculate();
    String wf23FormId = bb.getPropValue("cwlcxx2q", "wf23FormId");//资产暂估
    JSONObject ret = new JSONObject();
	String dtid = Util.null2String(request.getParameter("dtid"));
	System.out.println("dtid-----"+dtid);
	String hdje = "";
	String zg_requestid = "";
	RecordSet rs_cxmx = new  RecordSet();
	String sum_cxje = "";
	String zgwqje = "";
	String zcmc = "";
	//取入库流程核定金额
	rs.execute("select t2.requestid,t1.hdje,t1.zcmc from formtable_main_"+wf23FormId+"_dt1 t1,formtable_main_"+wf23FormId+" t2 ,workflow_requestbase t3"
			+" where t1.id = "+ dtid + " and t1.mainid = t2.id and t2.requestid = t3.requestid " );
	System.out.println("取暂估流程核定金额"+weaver.general.TimeUtil.getCurrentTimeString()+"select t2.requestid,t1.hdje,t1.zcmc  from formtable_main_"+wf23FormId+"_dt1 t1,formtable_main_"+wf23FormId+" t2 ,workflow_requestbase t3"
			+" where t1.id = "+ dtid + " and t1.mainid = t2.id and t2.requestid = t3.requestid " );
	
	while(rs.next()){
		hdje = Util.null2String(rs.getString("hdje"));
		zg_requestid = Util.null2String(rs.getString("requestid"));
		zcmc = Util.null2String(rs.getString("zcmc"));
		//取冲销明细表(hzjj_cx_mx)中的cxje合计，
		rs_cxmx.execute("select sum(cxje) as sum_cxje from hzjj_cx_mx where dtid = "+dtid+" and requestid = "+zg_requestid);
		System.out.println("取冲销明细表(hzjj_cx_mx)中的cxje合计"+weaver.general.TimeUtil.getCurrentTimeString()+"select sum(cxje) as sum_cxje from hzjj_cx_mx where dtid = "+dtid+" and requestid = "+zg_requestid);
		if(rs_cxmx.next()){
			sum_cxje = Util.getDoubleValue(rs_cxmx.getString("sum_cxje"),0)+"";
		}
	}
    System.out.println("sum_cxje=="+sum_cxje);
    zgwqje = bd.floatSubtract(hdje, sum_cxje);
    System.out.println("sum_cxje=="+sum_cxje);
    System.out.println("zgwqje=="+zgwqje);
	ret.put("status", "error");
	ret.put("status", "succ");
	ret.put("hdje", hdje);
	ret.put("zgwqje", zgwqje);
	ret.put("zcmc", zcmc);
	 
%>
<%=ret.toString()%>