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
    String billid=request.getParameter("billid");
    rs.writeLog("获得提入单号为："+trdh+",请求类型为："+type+",billid:"+billid);
    String sql0="";

//查询明细表
    if(type.equals("search")){


        JSONArray jsonArr2=new JSONArray();
        StringBuffer sql=new StringBuffer();
        String dh="";
        String xc="";
        String lcid="";
        String tmdw="";
        String sl="";
        sql.append("SELECT DISTINCT b.jydh,b.ddxc,a.lcid,b.sl from UF_TRDPLDY a,UF_TRDPLDY_DT1 b where a.id=b.MAINID and a.TRDH='")
                .append(trdh+"'");
//out.print(sql);
        rs.executeSql(sql.toString());
        rs.writeLog(sql.toString());
        JSONArray jsonArray=new JSONArray();
        JSONArray jsonArr = new JSONArray();

        while(rs.next()){
            JSONObject jsonObject=new JSONObject();


            dh=Util.null2String(rs.getString("jydh"));
            xc=Util.null2String(rs.getString("ddxc"));
            lcid=Util.null2String(rs.getString("lcid"));
            sl=Util.null2String(rs.getString("sl"));

            jsonObject.put("dh",dh);
            jsonObject.put("xc",xc);
            jsonObject.put("lcid",lcid);
            jsonObject.put("sl",sl);
            jsonArray.add(jsonObject);
        }
        String LSMNG="";
        String LSMEH="";
        sql0="SELECT JZ,TRDH FROM UF_GBJL WHERE JZ IS NOT NULL AND TRDH='"+trdh+"' AND SFZF='0'";
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

        for (int i = 0; i <jsonArray.size(); i++) {
            JSONObject jsonObject=jsonArray.getJSONObject(i);
            dh=jsonObject.getString("dh");
            xc=jsonObject.getString("xc");
            sl=jsonObject.getString("sl");


            StringBuffer sql2 = new StringBuffer();
            sql2.append("select * from uf_jmclxq where PONO='" + dh + "' AND" + " POITEM='" + xc + "'");
            rs.writeLog(sql2);
            rs.execute(sql2.toString());
            if (rs.next()) {
                Map<String, String> map = new HashMap<String, String>();
                String bs = Util.null2String(rs.getString("ZCHARG"));
                map.put("dh", dh);
                map.put("xc", xc);
                map.put("gc", Util.null2String(rs.getString("WERKS")));//工厂
                map.put("wlh", Util.null2String(rs.getString("wlh")));//物料号
                map.put("wlms", Util.null2String(rs.getString("wlname")));//物料描述

                map.put("BSART1", Util.null2String(rs.getString("BSART1")));//订单类型

                map.put("packxz", Util.null2String(rs.getString("packxz")));//包装性质
                map.put("wlqypc", bs);//物料启用批次
                map.put("bz1", Util.null2String(rs.getString("BEIZHU1")));//备注1
                map.put("bz2", Util.null2String(rs.getString("BEIZHU2")));//备注2
                map.put("bz3", Util.null2String(rs.getString("BEIZHU3")));//备注2
                map.put("tmdw", Util.null2String(rs.getString("unitcode")));//条目单位
                map.put("kwcode", Util.null2String(rs.getString("kwcode")));//存储位置

                map.put("LSMNG", LSMNG);//交货单的计量单位数量
                map.put("LSMEH", LSMEH);//计量单位
                map.put("cp", cp);//车牌
                if ("X".equals(Util.null2String(rs.getString("packxz")))) {
                    map.put("ychl", Util.null2String(sl));//已出货量
                }else{
                    map.put("ychl", "");//已出货量

                }


                if (!bs.equals("X")) {
                    jsonArr.add(map);

                } else {

                    jsonArr2.add(map);
                }


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
        rs.writeLog("读取mx0："+mx0);
        String mx1=Util.null2String(request.getParameter("mx1"));
        JSONArray mx0Jsons=new JSONArray();
        JSONArray mx1Jsons=new JSONArray();


        JSONArray mx0Jsons0=new JSONArray();
        JSONArray mx1Jsons0=new JSONArray();



        if(!mx0.equals("")&&mx0!=null){
            mx0Jsons0=JSONArray.fromObject(mx0);
            rs.writeLog("获得明细0的数据为："+mx0Jsons0);
            rs.writeLog("mx0Jsons0 size:"+mx0Jsons0.size());
        }
        if(!mx1.equals("")&&mx1!=null){
            mx1Jsons0=JSONArray.fromObject(mx1);
            rs.writeLog("获得明细1的数据为："+mx1Jsons0);
        }
        mx0Jsons=checkJsonArrByWlpzh(mx0Jsons0,billid);
        mx1Jsons=checkJsonArrByWlpzh(mx1Jsons0,billid);
        //mx0Jsons=mx0Jsons0;
        //mx1Jsons=mx1Jsons0;

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
            JSONArray jsonArray=new JSONArray();
            JSONArray jsonArray2=new JSONArray();

            if(mx0Jsons.size()>0){
                String mxtype="mx0";
                rs.writeLog("mx0Jsons:"+mx0Jsons);
                for(int i=0;i<mx0Jsons.size();i++){
                    rs.writeLog("遍历mx0Jsons");
                    table1.appendRow();
                    JSONObject mx0JObject=mx0Jsons.getJSONObject(i);
                    table1.setValue(Util.null2String(mx0JObject.get("EBELN")), "EBELN");	 //采购凭证号
                    table1.setValue(Util.null2String(mx0JObject.get("EBELP")), "EBELP");	 //采购凭证的项目编号
                    table1.setValue(Util.null2String(mx0JObject.get("WERKS")), "WERKS");	 //工厂
                    table1.setValue(Util.null2String(mx0JObject.get("LGORT")),"LGORT");//存储位置

                    table1.setValue(Util.null2String(mx0JObject.get("MATNR")), "MATNR");	 //物料编号
                    table1.setValue(Util.null2String(mx0JObject.get("LFIMG")), "ERFMG");	 //以录入项单位表示的数量
                    table1.setValue(Util.null2String(mx0JObject.get("ERFME")), "ERFME");	 //条目单位
                    table1.setValue(Util.null2String(mx0JObject.get("LSMNG")), "LSMNG");	 //交货单的计量单位数量
                    table1.setValue(Util.null2String(mx0JObject.get("LSMEH")), "LSMEH");	 //交货单的计量单位
                    //table1.setValue(Util.null2String(mx0JObject.get("BUDAT")),"BUDAT");//凭证中的过帐日期
                    table1.setValue("20180207","BUDAT");//凭证中的过帐日期

                    table1.setValue("20180207", "BLDAT");	 //凭证中的凭证日期
                    //table1.setValue(Util.null2String(mx0JObject.get("BLDAT")), "BLDAT");	 //凭证中的凭证日期


                    table1.setValue(Util.null2String(mx0JObject.get("CAR_NO")), "CAR_NO");	 //车号
                    table1.setValue(Util.null2String(mx0JObject.get("PACK")), "PACK");	 	 //包装性质
                    table1.setValue(Util.null2String(mx0JObject.get("BSART")), "BSART");	 //订单类型（采购）
                    table1.setValue(Util.null2String(mx0JObject.get("ZNO")), "ZNO");	 //批次确认单号
                    table1.setValue(Util.null2String(mx0JObject.get("ZNO_ITEM")), "ZNO_ITEM");	 //批次确认单号项目号
                    table1.setValue(Util.null2String(mx0JObject.get("BEIZHU1")), "BEIZHU1");
                    table1.setValue(Util.null2String(mx0JObject.get("BEIZHU2")), "BEIZHU2");
                    table1.setValue(Util.null2String(mx0JObject.get("BEIZHU3")), "BEIZHU3");

                }
                //
                sapconnection.execute(function);
                rs.writeLog("获取IT_HEAD_LOG");
                // JCO.Structure ret = function.getExportParameterList().getStructure("RETURN");
                // rs.writeLog("RETURN: " + ret.getString("MESSAGE"));

                JCO.Table retable=function.getTableParameterList().getTable("IT_HEAD_LOG");
                rs.writeLog("返回表行数："+retable.getNumRows());


                for (int i = 0; i < retable.getNumRows(); i++) {
                    JSONObject jsonObject=new JSONObject();
                    retable.setRow(i);
                    String EBELN=retable.getString("EBELN");//采购凭证号
                    String EBELP=retable.getString("EBELP");//采购凭证的项目编号
                    String ZMARK=retable.getString("ZMARK");//Delivery download flag
                    String ZMESS=retable.getString("ZMESS");//Download information
                    String MBLNR=retable.getString("MBLNR");//物料凭证编号
                    String ZNO=retable.getString("ZNO");//批次确认单号
                    String ZNO_ITEM=retable.getString("ZNO_ITEM");//批次确认单号项目号
                    //去除字符开头的0
                    String ZNO_ITEM1=ZNO_ITEM.replaceAll("^(0+)", ""); ;//批次确认单号项目号

                    jsonObject.put("MBLNR",MBLNR);
                    jsonObject.put("mxtype",mxtype);
                    jsonObject.put("ZNO_ITEM",ZNO_ITEM1);
                    jsonObject.put("mxtype","MX0");
                    if("E".equals(ZMARK)){
                        jsonObject.put("ZMESS",ZMESS);
                        jsonArray.add(jsonObject);
                    }else {
                        jsonArray2.add(jsonObject);

                    }


                    rs.writeLog("EBELN返回："+retable.getString("EBELN"));
                    rs.writeLog("EBELP返回："+retable.getString("EBELP"));
                    rs.writeLog("ZMARK返回："+retable.getString("ZMARK"));
                    rs.writeLog("ZMESS返回："+retable.getString("ZMESS"));
                    rs.writeLog("MBLNR返回："+retable.getString("MBLNR"));
                    rs.writeLog("ZNO返回："+retable.getString("ZNO"));
                    rs.writeLog("ZNO_ITEM返回："+retable.getString("ZNO_ITEM"));


                }

            }


            if(mx1Jsons.size()>0){
                String mxtype="mx1";
                for(int i=0;i<mx1Jsons.size();i++){
                    rs.writeLog("遍历mx1Jsons");
                    table1.appendRow();
                    JSONObject mx1JObject=mx1Jsons.getJSONObject(i);
                    table1.setValue(Util.null2String(mx1JObject.get("EBELN")), "EBELN");	 //采购凭证号
                    table1.setValue(Util.null2String(mx1JObject.get("EBELP")), "EBELP");	 //采购凭证的项目编号
                    table1.setValue(Util.null2String(mx1JObject.get("WERKS")), "WERKS");	 //工厂
                    table1.setValue(Util.null2String(mx1JObject.get("LGORT")),"LGORT");//存储位置

                    table1.setValue(Util.null2String(mx1JObject.get("MATNR")), "MATNR");	 //物料编号
                    table1.setValue(Util.null2String(mx1JObject.get("LFIMG")), "ERFMG");	 //以录入项单位表示的数量
                    table1.setValue(Util.null2String(mx1JObject.get("ERFME")), "ERFME");	 //条目单位
                    table1.setValue(Util.null2String(mx1JObject.get("LSMNG")), "LSMNG");	 //交货单的计量单位数量
                    table1.setValue(Util.null2String(mx1JObject.get("LSMEH")), "LSMEH");	 //交货单的计量单位
                    table1.setValue(Util.null2String(mx1JObject.get("CHARG")), "CHARG");	 //批号
                    table1.setValue(Util.null2String(mx1JObject.get("LICHA")), "LICHA");	 //供应商的批次
                    table1.setValue(Util.null2String(mx1JObject.get("HSDAT")), "HSDAT");	 //生产日期
                    //table1.setValue(Util.null2String(mx1JObject.get("VFDAT")), "VFDAT");	 //货架寿命到期日
                    table1.setValue("20180217", "VFDAT");	 //货架寿命到期日
                    table1.setValue(Util.null2String(mx1JObject.get("HSDAT")), "HSDAT");	 //生产日期
                    //table1.setValue(Util.null2String(mx1JObject.get("BUDAT")),"BUDAT");//凭证中的过帐日期
                    table1.setValue("20180207","BUDAT");//凭证中的过帐日期

                    //table1.setValue(Util.null2String(mx1JObject.get("BLDAT")), "BLDAT");	 //凭证中的凭证日期
                    table1.setValue("20180207", "BLDAT");	 //凭证中的凭证日期


                    table1.setValue(Util.null2String(mx1JObject.get("CAR_NO")), "CAR_NO");	 //车号
                    table1.setValue(Util.null2String(mx1JObject.get("PACK")), "PACK");	 	 //包装性质
                    table1.setValue(Util.null2String(mx1JObject.get("BSART")), "BSART");	 //订单类型（采购）
                    table1.setValue(Util.null2String(mx1JObject.get("ZNO")), "ZNO");	 //批次确认单号
                    table1.setValue(Util.null2String(mx1JObject.get("ZNO_ITEM")), "ZNO_ITEM");	 //批次确认单号项目号
                    table1.setValue(Util.null2String(mx1JObject.get("BEIZHU1")), "BEIZHU1");
                    table1.setValue(Util.null2String(mx1JObject.get("BEIZHU2")), "BEIZHU2");
                    table1.setValue(Util.null2String(mx1JObject.get("BEIZHU3")), "BEIZHU3");

                }
                //
                sapconnection.execute(function);
                rs.writeLog("获取IT_HEAD_LOG");
                // JCO.Structure ret = function.getExportParameterList().getStructure("RETURN");
                // rs.writeLog("RETURN: " + ret.getString("MESSAGE"));

                JCO.Table retable=function.getTableParameterList().getTable("IT_HEAD_LOG");
                rs.writeLog("返回表行数："+retable.getNumRows());


                for (int i = 0; i < retable.getNumRows(); i++) {
                    JSONObject jsonObject=new JSONObject();
                    retable.setRow(i);
                    String EBELN=retable.getString("EBELN");//采购凭证号
                    String EBELP=retable.getString("EBELP");//采购凭证的项目编号
                    String ZMARK=retable.getString("ZMARK");//Delivery download flag
                    String ZMESS=retable.getString("ZMESS");//Download information
                    String MBLNR=retable.getString("MBLNR");//物料凭证编号
                    String ZNO=retable.getString("ZNO");//批次确认单号
                    String ZNO_ITEM=retable.getString("ZNO_ITEM");//批次确认单号项目号
                    //去除字符开头的0
                    String ZNO_ITEM1=ZNO_ITEM.replaceAll("^(0+)", ""); ;//批次确认单号项目号

                    jsonObject.put("MBLNR",MBLNR);
                    jsonObject.put("mxtype",mxtype);
                    jsonObject.put("ZNO_ITEM",ZNO_ITEM1);
                    jsonObject.put("mxtype","MX1");
                    
                    if("E".equals(ZMARK)){
                        jsonObject.put("ZMESS",ZMESS);
                        jsonArray.add(jsonObject);
                    }else {
                        jsonArray2.add(jsonObject);

                    }


                    rs.writeLog("EBELN返回："+retable.getString("EBELN"));
                    rs.writeLog("EBELP返回："+retable.getString("EBELP"));
                    rs.writeLog("ZMARK返回："+retable.getString("ZMARK"));
                    rs.writeLog("ZMESS返回："+retable.getString("ZMESS"));
                    rs.writeLog("MBLNR返回："+retable.getString("MBLNR"));
                    rs.writeLog("ZNO返回："+retable.getString("ZNO"));
                    rs.writeLog("ZNO_ITEM返回："+retable.getString("ZNO_ITEM"));

                }
            }




            JSONObject jsonObject=new JSONObject();
            jsonObject.put("success",jsonArray2);
            jsonObject.put("failure",jsonArray);

            if(sapconnection!=null){
                JCO.releaseClient(sapconnection);
            }

            //更新成功的
            updateSuccessByJson(jsonObject,billid);
            updateAllUploadStatus(billid);

            rs.writeLog(jsonObject.toString());
            out.write(jsonObject.toString());
            return;

        }catch(Exception e){
            out.write("fail--"+e);
            rs.writeLog("fail----"+e);

        }

    }


%>
<%!public String getSfygByTrdh(String trdh){
    String sfyg="";
    String sql="select DISTINCT sfyg from UF_TRDPLDY where trdh='"+trdh+"'";
    RecordSet recordSet=new RecordSet();
    recordSet.writeLog(sql);
    recordSet.execute(sql);
    if (recordSet.next()){
        sfyg=Util.null2String(recordSet.getString("sfyg"));
    }
    return sfyg;

}
%><%!public String getTableNameByFfyg(String sfyg){
    String tablename="";
    if("0".equals(sfyg)){
        tablename="formtable_main_61_dt2";
    }
    if("1".equals(sfyg)){
        tablename="formtable_main_61_dt1";
    }
    return tablename;

}
%>
<%!public String getTableNameByTrdh(String trdh){
    String tablename="";
    String sfyg=getSfygByTrdh(trdh);
    tablename=getTableNameByFfyg(sfyg);
    return tablename;
}
%>
<%!public void updateSuccessByJson(JSONObject jsonObject,String billid){
    JSONArray jsonArray=jsonObject.getJSONArray("success");
    RecordSet recordSet=new RecordSet();
    recordSet.writeLog("获得SUCCESS:"+jsonArray.toString());

    for (int i = 0; i < jsonArray.size(); i++) {
        JSONObject jsonObject1=jsonArray.getJSONObject(i);
        String ZNO=jsonObject1.getString("mxtype");
        String ZNO_ITEM=jsonObject1.getString("ZNO_ITEM");

        String MBLNR=jsonObject1.getString("MBLNR");

        JSONObject zd=getTableNameByZNO(ZNO);
        String tablename=zd.get("tablename").toString();
        String tj=zd.get("tj").toString();
//        Boolean check0=checkWlpzh(tablename,billid,tj,ZNO_ITEM);

            String sql = "update " + tablename + " set wlpzh='" + MBLNR + "' where " + tj + "='" + ZNO_ITEM + "'" +
                    " and mainid=" + billid;
            recordSet.writeLog(sql);
            recordSet.execute(sql);

    }


}
%>
<%!public JSONObject getTableNameByZNO(String ZNO){
    JSONObject jsonObject=new JSONObject();
    String tablename="";
    String tj="";
    if("MX0".equals(ZNO)){
        tablename="uf_popcqr_DT1";
        tj="pcqdhxmh";
    }
    if("MX1".equals(ZNO)){
        tablename="uf_popcqr_DT2";
        tj="pcqrdhxmh";
    }
    jsonObject.put("tablename",tablename);
    jsonObject.put("tj",tj);



    return jsonObject;
}
%>
<%!public Boolean checkWlpzh(String tablename,String billid,String tj,String ZNO_ITEM){
    Boolean result=false;
    RecordSet recordSet=new RecordSet();
    String sql="";
    String wlpzh="";
    sql="SELECT wlpzh from "+tablename+" where mainid="+billid+" and "+tj+"='"+ZNO_ITEM+"'";
    recordSet.writeLog(sql);
    recordSet.execute(sql);

    if (recordSet.next()){
        wlpzh=Util.null2String(recordSet.getString("wlpzh"));
    }
    recordSet.writeLog("获得物料凭证号为:"+wlpzh);
    if("".equals(wlpzh)){
        result=true;
    }
    return  result;
}
%>
<%!
    //校验如果所有明细的物料凭证号都不为空，则更新 alluplooad状态为yes
    private void updateAllUploadStatus(String billid) {
        RecordSet rs=new RecordSet();
        String sql="";
        Boolean checkMX1=false;
        String checkMX1Counts="";
        Boolean checkMX2=false;
        String checkMX2Counts="";

        sql="SELECT COUNT(*) AS COUNTS FROM uf_popcqr_DT2 WHERE WLPZH IS  NULL AND MAINID="+billid;
        rs.writeLog(sql);
        rs.execute(sql);
        while (rs.next()){
            checkMX1Counts=rs.getString("counts");
        }

        sql="SELECT COUNT(*) AS COUNTS FROM uf_popcqr_DT1 WHERE WLPZH IS  NULL AND MAINID="+billid;
        rs.writeLog(sql);
        rs.execute(sql);
        while (rs.next()){
            checkMX2Counts=rs.getString("counts");
        }
        checkMX1=("0".equals(checkMX1Counts));
        checkMX2=("0".equals(checkMX2Counts));

        if (checkMX1&&checkMX2){
         sql="update uf_popcqr set allupload='1' where id="+billid;
         rs.writeLog(sql);
         rs.execute(sql);

        }
    }
    //校验每条明细是否上抛，如果已经上抛（有物料凭证号）则不能上抛

    public JSONArray checkJsonArrByWlpzh(JSONArray jsonArray, String billid){
    JSONArray jsonArray1=new JSONArray();
    String ZNO="";//明细表 MX0 MX1
    String tablename="";//表面
    String tj="";//查询条件
    String ZNO_ITEM="";//项目号
    if (jsonArray.size()>0){
        for (int i = 0; i <jsonArray.size() ; i++) {
            Boolean check = false;
            JSONObject jsonObject =jsonArray.getJSONObject(i);
            ZNO=jsonObject.getString("mxtype");
            ZNO_ITEM=jsonObject.getString("ZNO_ITEM");
            JSONObject jsonTable=getTableNameByZNO(ZNO);
            tablename=jsonTable.getString("tablename");
            tj=jsonTable.getString("tj");
            check = checkWlpzh(tablename,billid,tj,ZNO_ITEM);
            if (check){
                jsonArray1.add(jsonObject);
            }
        }
    }
    return jsonArray1;
}
%>



