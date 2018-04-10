<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.general.Util"%>>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>>
<%@page
        import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>

<%
    String ponos = request.getParameter("ponos");//field9881
    String path = request.getParameter("");
    JCO.Client sapconnection = null;
    try {
        String pono = "";//采购订单号
        String poitem = "";//采购订单项次
        String prno = "";//请购申请单号
        String pritem = "";//请购申请项次
        String goodgroup = "";//产品组
        String wlh = "";//物料号码
        String wlname = "";//物料描述
        String jhyzl = "";//计划运载量
        String yyzl = "";//已运载量
        String syyzl = "";//剩余运载量
        String unitcode = "";//单位代码（T/桶）
        String kwcode = "";//库位代码
        String unitdesc = "";//单位描述
        String kwdesc = "";//库存地址
        String packxz = "";//包装性质
        String shipto = "";//送达方
        String shiptoname = "";//送达方名称
        String shiptoaddr = "";//送达地址描述
        String shipcity = "";//送达城市点
        String soldto = "";//售达方
        String soldtoname = "";//售达方名称
        String sfgf = "";//是否固废
        String isdanger = "";//危险品标识
        String hbkpyz = "";//合并开票原则
        String costcenter = "";//成本中心
        String gyscode = "";//供应商代码
        String gysname = "";//供应商名称
        String packcode = "";//包装代码
        String zweight = "";//包材重量
        String workflowId = "981";
        RecordSet rs = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
        String sources = "";
        if (!workflowId.equals("")) {
            rs2.executeSql("select SAPSource from workflow_base where id=" + workflowId);
            if (rs2.next())
                sources = rs2.getString(1);
        }
        rs2.writeLog("sources=" + sources);

        SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
        sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
        rs2.writeLog("创建SAP连接");
        String strFunc = "Z_PO_TRAN_OA";



        String outcall = "";
        String[] ponoses = ponos.split(",");
        int index = 0;
        rs1.writeLog("length:" + ponoses.length);
        for (int i = 0; i < ponoses.length; i++) {
            // 			String countSql = "select count(*) as count from uf_jmclxq where pono = '" + ponoses[i] + "'";
            // 			//String sql = "select * from uf_jmclxq where pono = '" + ponoses[i] + "'";
            // 			rs1.writeLog(countSql);
            // 			rs1.execute(countSql);
            // 			if(rs1.next()){
            // 				int count = Integer.parseInt(rs1.getString("count"));
            // 				rs1.writeLog(count);
            // 				if(count < 1){
            // 					rs1.writeLog("进入获取sap方法");
            // 填写参数
            rs1.writeLog(ponoses[i]);
            JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
            IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
            JCO.Function function = ft.getFunction();
            function.getImportParameterList().setValue("DOWN", "FLAG");
            JCO.Table inTableParams = function.getTableParameterList().getTable("IT_HEAD_DOWN");
            inTableParams.appendRow();
            inTableParams.setValue(ponoses[i], "EBELN");// 采购凭证号
            inTableParams.setValue(ponoses[i], "EBELT");// 采购凭证号
            inTableParams.setValue("7020", "WERKS");// 公司代码
            sapconnection.execute(function);
            rs1.writeLog("执行function获取sap数据");
            // 获取数据
            JCO.Table output = function.getTableParameterList().getTable("IT_ITEM_DOWN");

            for (int k = 0; k < output.getNumRows(); k++) {
                output.setRow(k);
                index++;
                rs2.writeLog("index=" + index);
                outcall += "![]";
                outcall += Util.null2String(output.getString("EBELN")) + "|";//采购订单号
                outcall += Util.null2String(output.getString("EBELP")) + "|";//采购订单项次
                outcall += Util.null2String(output.getString("BANFN")) + "|";//采购申请单号
                outcall += Util.null2String(output.getString("BNFPO")) + "|";//采购申请项次
                outcall += Util.null2String(output.getString("SPART")) + "|";//产品组
                outcall += Util.null2String(output.getString("MATNR")) + "|";//物料号码
                outcall += Util.null2String(output.getString("MAKTX")) + "|";//物料描述
                outcall += Util.null2String(output.getString("LFIMG")) + "|";//计划运载量
                outcall += Util.null2String("0") + "|";//已运载量
                outcall += Util.null2String("0") + "|";//剩余运载量
                outcall += Util.null2String(output.getString("BPRME")) + "|";//单位代码
                outcall += Util.null2String(output.getString("LGORT")) + "|";//库位代码
                outcall += Util.null2String(output.getString("MSEHT")) + "|";//单位描述
                outcall += Util.null2String(output.getString("LGOBE")) + "|";//库存地址
                outcall += Util.null2String(output.getString("SCHGT")) + "|";//包装性质
                outcall += Util.null2String("") + "|";//送大方
                outcall += Util.null2String("") + "|";//送达方名称
                outcall += Util.null2String("") + "|";//送达方描述地址
                outcall += Util.null2String("") + "|";//送达城市
                outcall += Util.null2String("") + "|";//售达方
                outcall += Util.null2String("") + "|";//售达方名称
                outcall += Util.null2String("") + "|";//是否固费
                outcall += Util.null2String("") + "|";//危险品表示
                outcall += Util.null2String("") + "|";//合并开票原则
                outcall += Util.null2String(output.getString("KOSTL")) + "|";//成本中心
                outcall += Util.null2String(output.getString("LIFNR")) + "|";//供应商代码
                outcall += Util.null2String(output.getString("NAME1")) + "|";//供应商名称
                outcall += Util.null2String("0") + "|";//包装代码

                outcall += Util.null2String(output.getString("BUKRS")) + "|";//公司代码
                outcall += Util.null2String(output.getString("EKORG")) + "|";//采购组织
                outcall += Util.null2String(output.getString("BSART")) + "|";//采购凭证类型
                outcall += Util.null2String(output.getString("WERKS")) + "|";//工厂
                outcall += Util.null2String(output.getString("MENGE")) + "|";//采购订单数量
                outcall += Util.null2String(output.getString("LFIMG")) + "|";//LFIMG
                outcall += Util.null2String(output.getString("EINDT")) + "|";//项目交货日期
                outcall += Util.null2String(output.getString("EKGRP")) + "|";//采购组
                outcall += Util.null2String(output.getString("MTART")) + "|";//物料类型
                outcall += Util.null2String(output.getString("LOEKZ")) + "|";//采购凭证删除标识
                outcall += Util.null2String(output.getString("UEBTO")) + "|";//过量交货限度
                outcall += Util.null2String(output.getString("UEBTK")) + "|";//标识：允许未限制的过量交货
                outcall += Util.null2String(output.getString("UNTTO")) + "|";//交货不足限度
                outcall += Util.null2String(output.getString("BSART1")) + "|";//订单类型（采购）
                outcall += Util.null2String(output.getString("AFNAM")) + "|";//需求者/要求者名称
                outcall += Util.null2String(output.getString("NAME2")) + "|";//名称2
                outcall += Util.null2String(output.getString("CHARG")) + "|";//批号
                outcall += Util.null2String(output.getString("ANLN1")) + "|";//主资产号
                outcall += Util.null2String(output.getString("ZYUP")) + "|";//是否上传sap
                outcall += Util.null2String(output.getString("ZGMZBH")) + "|";//购买证编号
                outcall += Util.null2String(output.getString("ZMATNR")) + "|";//物料编号
                outcall += Util.null2String(output.getString("ZMENGE1")) + "|";//采购订单数量
                outcall += Util.null2String(output.getString("ZMEINS1")) + "|";//采购订单计量单位
                outcall += Util.null2String(output.getString("ZDATELOW2")) + "|";//可用（可供货的）开始日期
                outcall += Util.null2String(output.getString("ZDATEHIGH2")) + "|";//可用(可供货的)截至日期
                outcall += Util.null2String(output.getString("ZCHARG")) + "|";//ZCHARG
                outcall += Util.null2String(output.getString("RETPO")) + "|";//退货项目
                outcall += Util.null2String(output.getString("UMSON")) + "|";//免费项目
                outcall += Util.null2String(output.getString("BEIZHU1")) + "|";//BEIZHU1
                outcall += Util.null2String(output.getString("BEIZHU2")) + "|";//BEIZHU2
                outcall += Util.null2String(output.getString("BEIZHU3")) + "|";//BEIZHU3
                outcall += Util.null2String(output.getString("ZWEIGHT")) + "|";//包材重量
                outcall += Util.null2String(output.getString("SCHGT")) + "|";//包装性质
                rs2.writeLog("SCHGT:"+ Util.null2String(output.getString("SCHGT")));
                rs2.writeLog(outcall);

            }
            //}
            //}
        }
        rs1.writeLog(outcall);
        out.write("suceess：" + outcall);
    } catch (Exception e) {
        // TODO: handle exception
        out.write("fail" + e);
        e.printStackTrace();

    }
%>


