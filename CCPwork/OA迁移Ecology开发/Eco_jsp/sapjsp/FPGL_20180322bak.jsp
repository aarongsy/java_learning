<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:useBean id="log" class="weaver.general.BaseBean" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" />
<%
    log.writeLog("进入FPGL.JSP");
    String yddzdh="";
    yddzdh=request.getParameter("yddzdh");
    log.writeLog(yddzdh);
    StringBuffer stringBuffer=new StringBuffer();
    if (!"".equals(yddzdh)){
        stringBuffer
                .append("SELECT")
                .append(" SUM (T2.plannotaxacount) AS plannotaxacount,")
                .append("SUM(T2.WEIGHT) AS WEIGHT,")
                .append(" t2.DJBH,")
                .append(" T2.handingplancode,")
                .append(" T2.SAPPZBH,")
                .append(" T2.COSTTYPE,")
                .append(" T2.CARRIERNAME,")
                .append(" t2.TRANSDATE,")
                .append(" T2.CARTYPE,")
                .append(" T2.PLATENUM,")
                .append(" T2.LOCATION,")
                .append(" t2.BILLINGMODE,")
                .append(" t2.ITEMTYPE,")
                .append(" T2.ZFDX,")
                .append(" T2.FYZGBZ,")
                .append(" T2.hl,")
                .append(" t2.DJBH,")
                .append(" T2.SAPPZBH ")
                .append("FROM ")
                .append(" uf_checkCount t1,")
                .append(" uf_checkCount_dt1 t2 ")
                .append("WHERE ")
                .append(" T1. ID = T2.mainid")
                .append(" and t1.applyCode='").append(yddzdh).append("'")
                .append("GROUP BY ")
                .append(" t2.DJBH,")
                .append(" T2.handingplancode,")
                .append(" T2.SAPPZBH,")
                .append(" T2.COSTTYPE,")
                .append(" T2.CARRIERNAME,")
                .append(" t2.TRANSDATE,")
                .append(" T2.CARTYPE,")
                .append(" T2.PLATENUM,")
                .append(" T2.LOCATION,")
                .append(" t2.BILLINGMODE,")
                .append(" t2.ITEMTYPE,")
                .append(" T2.ZFDX,")
                .append(" T2.FYZGBZ,")
                .append(" T2.hl,")
                .append(" t2.DJBH,")
                .append(" T2.SAPPZBH");


        log.writeLog(stringBuffer);
        rs.execute(stringBuffer.toString());
        JSONArray jsonArray=new JSONArray();
        while (rs.next()){
            JSONObject jsonObject=new JSONObject();
            String zxjhh= Util.null2String(rs.getString("handingplancode"));//装卸计划号
            String costtype= Util.null2String(rs.getString("costtype"));//费用类型
            String carriername= Util.null2String(rs.getString("carriername"));//承运商名称
            String transdate= Util.null2String(rs.getString("transdate"));//运输日期
            String cartype= Util.null2String(rs.getString("cartype"));//车型
            String platenum= Util.null2String(rs.getString("platenum"));//车牌
            String weight= Util.null2String(rs.getString("weight"));//重量
            String location= Util.null2String(rs.getString("location"));//客户地址
            String plannotaxacount= Util.null2String(rs.getString("plannotaxacount"));//暂估不含税金额
            String billingmode= Util.null2String(rs.getString("billingmode"));//计费模式
            String itemtype= Util.null2String(rs.getString("itemtype"));//单据类型
            String zfdx= Util.null2String(rs.getString("zfdx"));//装卸计划号
            String fyzgbz= Util.null2String(rs.getString("fyzgbz"));//费用暂估币种
            String hl= Util.null2String(rs.getString("hl"));//汇率
            String djbh= Util.null2String(rs.getString("djbh"));//单据编号
            String sappzbh= Util.null2String(rs.getString("sappzbh"));//sap凭证号

            jsonObject.put("zxjhh",zxjhh);
            jsonObject.put("costtype",costtype);
            jsonObject.put("carriername",carriername);
            jsonObject.put("transdate",transdate);
            jsonObject.put("cartype",cartype);
            jsonObject.put("platenum",platenum);
            jsonObject.put("weight",weight);
            jsonObject.put("location",location);
            jsonObject.put("plannotaxacount",plannotaxacount);
            jsonObject.put("billingmode",billingmode);
            jsonObject.put("itemtype",itemtype);
            jsonObject.put("zfdx",zfdx);
            jsonObject.put("fyzgbz",fyzgbz);
            jsonObject.put("hl",hl);
            jsonObject.put("djbh",djbh);
            jsonObject.put("sappzbh",sappzbh);

            jsonArray.add(jsonObject);
        }
        log.writeLog("获得jsonArr："+jsonArray);
        out.clear();
        out.write(jsonArray.toString());
        out.flush();
        out.close();

    }
%>