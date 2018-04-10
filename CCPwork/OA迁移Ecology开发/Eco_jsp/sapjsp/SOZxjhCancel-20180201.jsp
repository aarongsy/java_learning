<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    BaseBean log=new BaseBean();
    RecordSet rs = new RecordSet();
    log.writeLog("进入SOZxjhCancel");
    String sql = "";
    String message = "";// 错误返回消息
    String id=request.getParameter("id");
    String action=request.getParameter("action");

        String sfyyf="";//是否有运费
        String tablename="formtable_main_45";//装卸计划表名字
        String zxjhh="";//装卸计划号
        String sfyg="";//是否有柜
        String sfzf="";//是否作废
        try {
                sql = "select sfzf,sfyyf,sfyg,zxjhh from " + tablename + " where id="+id;
                rs.writeLog(sql);
                rs.execute(sql);
                if (rs.next()){
                    sfyyf=Util.null2String(rs.getString("sfyyf"));
                    sfyg=Util.null2String(rs.getString("sfyg"));
                    zxjhh=Util.null2String(rs.getString("zxjhh"));
                    sfzf=Util.null2String(rs.getString("sfzf"));

                }
                if ("1".equals(sfzf)){
                    JSONObject jsonObject=getMessageJson("已经作废过了，无需重复作废！");
                    rs.writeLog(jsonObject.toString());
                    out.write(jsonObject.toString());
                    return;
                }


                // 根据装卸计划号查询运费暂估单是否上抛，没上抛可直接作废装卸计划和暂估单(暂估单作废方式: 暂估表单状态（是否作废）改为YES)；
                if (sfyyf.equals("1")) {
                    sql = "select DJSTATUS,djbh from uf_zgfy where zxplanno='" + zxjhh + "'";
                    rs.writeLog(sql);
                    rs.execute(sql);
                    String DJSTATUS = "";
                    String djbh = "";
                    while (rs.next()) {
                        DJSTATUS = Util.null2String(rs.getString("DJSTATUS"));
                        djbh = Util.null2String(rs.getString("djbh"));
                        RecordSet rs2 = new RecordSet();
                        if (DJSTATUS.equals("0")) {
                            sql = "update uf_zgfy set DJSTATUS='4' where zxplanno='" + zxjhh + "'";
                            rs2.writeLog(sql);
                            rs2.execute(sql);
                        }

                        if (DJSTATUS.equals("2") || DJSTATUS.equals("1") || DJSTATUS.equals("3")) {
                            message = "报错：装卸计划号" + zxjhh + "的关联运费暂估单" + djbh + "已上抛SAP,请先作废该运费暂估单";
                        }
                        JSONObject jsonObject=getMessageJson(message);
                        out.write(jsonObject.toString());
                        rs2.writeLog(jsonObject.toString());
                        return;
                    }
                    sql = "select DJSTATUS,djbh from uf_zgfy where zxplanno='" + zxjhh + "'";
                    rs.writeLog(sql);
                    rs.execute(sql);
                    while (rs.next()) {
                        DJSTATUS = Util.null2String(rs.getString("DJSTATUS"));
                        djbh = Util.null2String(rs.getString("djbh"));
                        RecordSet rs2 = new RecordSet();
                        if (DJSTATUS.equals("0")) {
                            sql = "update uf_zgfy set DJSTATUS='4' where zxplanno='" + zxjhh + "'";
                            rs2.writeLog(sql);
                            rs2.execute(sql);
                        }
                    }


                }
                //还原封签号为空
                String detailtname="";
                if ("0".equals(sfyg)){
                    detailtname="UF_GHLR_DT2";
                }
                if ("1".equals(sfyg)){
                    detailtname="UF_GHLR_DT1";
                }


                    sql = "select gbh,shipping from formtable_main_45_DT1 where mainid=" + id;
                    rs.writeLog(sql);
                    rs.execute(sql);

                    String gbh = "";
                    if (rs.next()) {
                        gbh = Util.null2String(rs.getString("gbh"));
                        String shipno=Util.null2String(rs.getString("shipping"));

                        if (!gbh.equals("")) {
                            sql = "SELECT b.id FROM UF_GHLR a,"+detailtname+" b where a.id=b.MAINID and a.SHIPPING='" + shipno
                                    + "' and b.code='" + gbh + "'";
                            RecordSet rs2 = new RecordSet();
                            rs2.writeLog(sql);
                            rs2.execute(sql);
                            String ghid = "";
                            if (rs2.next()) {
                                ghid = Util.null2String(rs2.getString("id"));
                            }
                            sql = "update "+detailtname+" set fqh=null where id=" + ghid;
                            rs2.writeLog(sql);
                            rs2.execute(sql);
                        }
                    }
            /**
             * 最后将装卸计划流程及建模的是否作废字段改为是--sfzf='1'
             */
            sql="update formtable_main_45 set sfzf='1' where zxjhh='"+zxjhh+"'";
            rs.writeLog(sql);
            rs.execute(sql);
            sql="update UF_TRDPLDY set sfzf='1' where zxjhh='"+zxjhh+"'";
            rs.writeLog(sql);
            rs.execute(sql);
            message="作废成功！";
            JSONObject jsonObject=getMessageJson(message);
            rs.writeLog(jsonObject.toString());
            out.write(jsonObject.toString());
            return;


        } catch (Exception e) {
            e.printStackTrace();
            rs.writeLog("fail--" + e);
        }

%>
<%!public JSONObject getMessageJson(String message){
    JSONObject jsonObject=new JSONObject();
    jsonObject.put("message",message);
    return jsonObject;
}

%>