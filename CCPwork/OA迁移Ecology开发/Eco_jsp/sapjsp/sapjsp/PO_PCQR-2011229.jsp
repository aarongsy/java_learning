<%@page import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>

<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.sap.mw.jco.*" %>
<%@page import="com.weaver.integration.log.LogInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    rs.writeLog("进入PO_PCQR.jsp");
    String trdh=request.getParameter("trdh");
    String type=request.getParameter("type");
    rs.writeLog("获得提入单号为："+trdh+",请求类型为："+type);
    String sql0="";

//查询明细表
    if(type.equals("search")){


        JSONArray jsonArr = new JSONArray();
        JSONArray jsonArr2=new JSONArray();
        StringBuffer sql=new StringBuffer();
        sql.append("SELECT b.jydh,b.ddxc,a.lcid from UF_TRDPLDY a,UF_TRDPLDY_DT1 b where a.id=b.MAINID and a.TRDH='")
                .append(trdh+"'");
//out.print(sql);
        rs.executeSql(sql.toString());
        rs.writeLog(sql.toString());
        String dh="";
        String xc="";
        String lcid="";
        while(rs.next()){
            dh=Util.null2String(rs.getString("jydh"));
            xc=Util.null2String(rs.getString("ddxc"));
            lcid=Util.null2String(rs.getString("lcid"));
            break;
        }
        String LSMNG="";
        String LSMEH="";
        sql0="SELECT JZ,TRDH FROM UF_GBJL WHERE JZ IS NOT NULL AND TRDH='"+trdh+"'";
        rs.writeLog(sql0);
        rs.execute(sql0);
        if(rs.next()){
            LSMNG=Util.null2String(rs.getString("JZ"));
        }
        if(!LSMNG.equals("")){
            LSMEH="KG";
        }

        StringBuffer sql1=new StringBuffer();
        sql1.append("SELECT cp from formtable_main_61 where requestid='")
                .append(lcid+"'");
        rs.writeLog(sql1);
        rs.execute(sql1.toString());
        String cp="";
        while(rs.next()){
            cp=Util.null2String(rs.getString("cp"));
            break;
        }


        StringBuffer sql2=new StringBuffer();
        sql2.append("select * from uf_jmclxq where PONO='"+dh+"' AND"+" POITEM='"+xc+"'");
        rs.writeLog(sql2);
        rs.execute(sql2.toString());
        while(rs.next()){
            Map<String,String> map = new HashMap<String,String>();
            String bs=Util.null2String(rs.getString("ZCHARG"));
            map.put("dh",dh);
            map.put("xc",xc);
            map.put("gc",Util.null2String(rs.getString("WERKS")));//工厂
            map.put("wlh", Util.null2String(rs.getString("wlh")));//物料号
            map.put("wlms", Util.null2String(rs.getString("wlname")));//物料描述

            map.put("BSART1", Util.null2String(rs.getString("BSART1")));//订单类型

            map.put("packxz", Util.null2String(rs.getString("packxz")));//包装性质
            map.put("wlqypc", bs);//物料启用批次
            map.put("bz1", Util.null2String(rs.getString("BEIZHU1")));//备注1
            map.put("bz2", Util.null2String(rs.getString("BEIZHU2")));//备注2
            map.put("bz3", Util.null2String(rs.getString("BEIZHU3")));//备注2
            map.put("LSMNG",LSMNG);//交货单的计量单位数量
            map.put("LSMEH",LSMEH);//计量单位
            map.put("cp", cp);//车牌
            if(!bs.equals("X")){
                jsonArr.add(map);

            }else{

                jsonArr2.add(map);
            }


        }

        JSONObject jnobj=new JSONObject();
        if(jsonArr.size()==0&&jsonArr2.size()==0){
            jnobj.put("err","同步表中未查询到匹配的单号及项次");
        }
        jnobj.put("dt0", jsonArr);
        jnobj.put("dt1", jsonArr2);
        PrintWriter pw = response.getWriter();
        rs.writeLog("装卸计划返回JSON:"+jnobj.toString());
        pw.write(jnobj.toString());
        pw.flush();
        pw.close();
        return;
    }

//SAP数据上抛
    if(type.equals("sapupload")){
        rs.writeLog("进入sapupload");



        String mx0=Util.null2String(request.getParameter("mx0"));
        String mx1=Util.null2String(request.getParameter("mx1"));
        JSONArray mx0Jsons=new JSONArray();
        JSONArray mx1Jsons=new JSONArray();
        if(!mx0.equals("")&&mx0!=null){
            mx0Jsons=JSONArray.fromObject(mx0);
            rs.writeLog("获得明细0的数据为："+mx0Jsons.toString());
        }
        if(!mx1.equals("")&&mx1!=null){
            mx1Jsons=JSONArray.fromObject(mx1);
            rs.writeLog("获得明细1的数据为："+mx1Jsons);
        }

        try{
            rs.writeLog("开始连接SAP...");
            JCO.Client sapconnection = null;
            SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
            sapconnection = (JCO.Client)sapidsi.getConnection("1", new LogInfo());
            rs.writeLog("创建SAP连接成功...");
            String strFunc = "Z_PO_TRAN_OA";

            JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
            IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
            JCO.Function function = ft.getFunction();
            function.getImportParameterList().setValue("UP", "FLAG");
            //101：无估计 107 转储：541  委外组件：351 测试先用107
            function.getImportParameterList().setValue("107", "ZTYPE");
            JCO.Table table1=function.getTableParameterList().getTable("IT_HEAD_UP");

            //明细表0上抛字段
            if(mx0Jsons.size()>0){
                for(int i=0;i<mx0Jsons.size();i++){
                    rs.writeLog("遍历mx0Jsons");
                    table1.appendRow();
                    JSONObject mx0JObject=mx0Jsons.getJSONObject(i);
                    table1.setValue(Util.null2String(mx0JObject.get("EBELN")), "EBELN");	 //采购凭证号
                    table1.setValue(Util.null2String(mx0JObject.get("EBELP")), "EBELP");	 //采购凭证的项目编号
                    table1.setValue(Util.null2String(mx0JObject.get("WERKS")), "WERKS");	 //工厂
                    //table1.setValue(Util.null2String(mx0JObject.get("LFIMG")), "LFIMG");	 //以录入项单位表示的数量
                    table1.setValue(Util.null2String(mx0JObject.get("CAR_NO")), "CAR_NO");	 //车号
                    //table1.setValue(Util.null2String(mx0JObject.get("GEWEI")), "GEWEI");	 //重量
                    table1.setValue(Util.null2String(mx0JObject.get("PACK")), "PACK");	 	 //包装性质
                    table1.setValue(Util.null2String(mx0JObject.get("BSART")), "BSART");	 //订单类型（采购）
                    table1.setValue(Util.null2String(mx0JObject.get("BEIZHU1")), "BEIZHU1");
                    table1.setValue(Util.null2String(mx0JObject.get("BEIZHU2")), "BEIZHU2");
                    table1.setValue(Util.null2String(mx0JObject.get("BEIZHU3")), "BEIZHU3");
                    table1.setValue(Util.null2String(mx0JObject.get("MANDT")),"MANDT");//集团
                    table1.setValue(Util.null2String(mx0JObject.get("LGORT")),"LGORT");//存储位置
                    table1.setValue(Util.null2String(mx0JObject.get("BUDAT")),"BUDAT");//凭证中的过帐日期
                    // table1.setValue(Util.null2String(mx0JObject.get("LSMNG")),"LSMNG");//交货单的计量单位数量
                    table1.setValue(Util.null2String(mx0JObject.get("MATNR")),"MATNR");//物料号
                    table1.setValue(Util.null2String(mx0JObject.get("ERFMG")),"ERFMG");//以录入项单位表示的数量
                    table1.setValue(Util.null2String(mx0JObject.get("ERFME")),"ERFME");//条目单位
                    table1.setValue(Util.null2String(mx0JObject.get("LSMNG")),"LSMNG");//交货单的计量单位数量
                    table1.setValue(Util.null2String(mx0JObject.get("LSMEH")),"LSMEH");//交货单的计量单位


                }


            }
            if(mx1Jsons.size()>0){
                for(int i=0;i<mx1Jsons.size();i++){
                    rs.writeLog("遍历mx1Jsons");
                    table1.appendRow();
                    JSONObject mx1JObject=mx1Jsons.getJSONObject(i);
                    table1.setValue(Util.null2String(mx1JObject.get("EBELN")), "EBELN");	 //采购凭证号
                    table1.setValue(Util.null2String(mx1JObject.get("EBELP")), "EBELP");	 //采购凭证的项目编号
                    table1.setValue(Util.null2String(mx1JObject.get("WERKS")), "WERKS");	 //工厂
                    table1.setValue(Util.null2String(mx1JObject.get("LFIMG")), "LFIMG");	 //以录入项单位表示的数量
                    table1.setValue(Util.null2String(mx1JObject.get("CAR_NO")), "CAR_NO");	 //车号
                    table1.setValue(Util.null2String(mx1JObject.get("GEWEI")), "GEWEI");	 //重量
                    table1.setValue(Util.null2String(mx1JObject.get("PACK")), "PACK");	 	 //包装性质
                    table1.setValue(Util.null2String(mx1JObject.get("BSART")), "BSART");	 //订单类型（采购）
                    table1.setValue(Util.null2String(mx1JObject.get("BEIZHU1")), "BEIZHU1");
                    table1.setValue(Util.null2String(mx1JObject.get("BEIZHU2")), "BEIZHU2");
                    table1.setValue(Util.null2String(mx1JObject.get("BEIZHU3")), "BEIZHU3");
                    table1.setValue(Util.null2String(mx1JObject.get("MANDT")),"MANDT");//集团
                    table1.setValue(Util.null2String(mx1JObject.get("LGORT")),"LGORT");//存储位置
                    table1.setValue(Util.null2String(mx1JObject.get("BUDAT")),"BUDAT");//凭证中的过帐日期
                    table1.setValue(Util.null2String(mx1JObject.get("LSMNG")),"LSMNG");//交货单的计量单位数量
                }
            }



            //
            sapconnection.execute(function);
            rs.writeLog("获取IT_HEAD_LOG");
            // JCO.Structure ret = function.getExportParameterList().getStructure("RETURN");
            // rs.writeLog("RETURN: " + ret.getString("MESSAGE"));

            JCO.Table retable=function.getTableParameterList().getTable("IT_HEAD_LOG");
            rs.writeLog("返回表行数："+retable.getNumRows());

            JSONArray jsonArray=new JSONArray();
            for (int i = 0; i < retable.getNumRows(); i++) {
                JSONObject jsonObject=new JSONObject();
                retable.setRow(i);
                rs.writeLog("EBELN返回："+retable.getString("EBELN"));
                rs.writeLog("EBELP返回："+retable.getString("EBELP"));
                rs.writeLog("ZMARK返回："+retable.getString("ZMARK"));
                rs.writeLog("ZMESS返回："+retable.getString("ZMESS"));
                if((retable.getString("ZMARK")).equals("E")){
                    out.write("PO上抛失败，错误信息:"+retable.getString("ZMESS"));
                    return;
                }
                if((retable.getString("ZMARK")).equals("S")){
                    out.write("PO上抛成功，返回信息:"+retable.getString("ZMESS"));
                    return;
                }

            }



        }catch(Exception e){
            out.write("fail--"+e);
            rs.writeLog("fail----"+e);

        }

    }


%>