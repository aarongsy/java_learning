<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/base/init.jsp"%>

<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String planno = StringHelper.null2String(request.getParameter("planno"));
String errmsg = "";
DataService ds = new DataService();

Integer k = 0;
%>
<style type="text/css"> 
tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 

</style>
<script type='text/javascript' language="javascript" src='/js/main.js'>
</script>
<DIV id="warpp">
<TABLE border=1 id="tblid">
<CAPTION><STRONG>未生成暂估单的清单</STRONG>&nbsp;&nbsp; <SPAN id=divaddinfoidbutton name="divattinfoidbutton"><A id=cz2 href="javascript:exportExcel1('tblid','')"><FONT color=#ff0000>Excel导出</FONT></A></SPAN></CAPTION>
<COLGROUP>
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
<COL width="3%">
</COLGROUP>
<TBODY>
<TR>
<TD>序号</TD>
<TD style="display:none">装卸计划requestid</TD>
<TD>装卸计划号</TD>
<TD>价格类型</TD>
<TD>装卸计划填单人</TD>
<TD>提入单号</TD>
<TD>是否过磅</TD>
<TD>过磅完成时间</TD>
<TD>主表上的总运费</TD>
<TD>暂估单号</TD>
<TD>操作按钮</TD>
</TR>
<%
try {
	String sql = "select a.reqdate,a.requestid,a.reqno,a.fare fare2,NVL(fare,0) fare ,a.pricetype,(select objname from selectitem where id=a.pricetype) pricetypetxt,a.ispond,(select objname from selectitem where id=a.ispond) ispondtxt,a.isself ,(select objname from humres where id=a.reqman) reqman,a.finishpond from uf_lo_loadplan a ";
	//sql = sql+"	where a.reqdate>='2017-11-17' and ";
	sql = sql+"	where a.reqdate>='2017-11-01' and ";
	//sql = sql+"	where a.reqdate>='2017-08-01' and";
	//sql = sql+" a.isself='40288098276fc2120127704884290211' and a.pricetype='40285a9048f924a70148fd0d027f0524' and a.ispond='40288098276fc2120127704884290210' and a.state='402864d1493b112a01493bfaf09a0008' and a.finishpond is not null and fare=0 ";
	sql = sql+" a.isself='40288098276fc2120127704884290211' and (a.pricetype='40285a9048f924a70148fd0d027f0524' or a.pricetype='40285a904a055ae2014a09c8de0d1e9a') and a.ispond='40288098276fc2120127704884290210' and a.state='402864d1493b112a01493bfaf09a0008' and a.finishpond is not null and fare=0 ";
	if ( !"".equals(planno) ) {	
		sql = sql + " and a.reqno='"+planno+"'";
	}
	sql = sql + " order by a.reqdate asc";
	System.out.println(sql);
	List list = baseJdbc.executeSqlForList(sql);
	if ( list.size()>0 ) {	
		for ( int i=0; i<list.size(); i++ ){
			k++;
			Map map = (Map)list.get(i);					
			planno = StringHelper.null2String(map.get("reqno"));
			String planreqid = StringHelper.null2String(map.get("requestid"));			
			String pricetypetxt = StringHelper.null2String(map.get("pricetypetxt"));
			String reqman = StringHelper.null2String(map.get("reqman"));
			String finishpond = StringHelper.null2String(map.get("finishpond"));
			String ispondtxt = StringHelper.null2String(map.get("ispondtxt"));
			String fare = StringHelper.null2String(map.get("fare"));
			String ladno  = "";
			String invoiceno = "";
			
			/*String sql2 = "select wm_concat(distinct pondno) ladno from uf_lo_loaddetail where requestid='"+planreqid+"'";
			String sql2 = "select pondno ladno from uf_lo_loaddetail where requestid='"+planreqid+"'";
			List list2 = baseJdbc.executeSqlForList(sql2);
			if ( list2.size()>0 ) {	
				Map map2 = (Map)list2.get(0);	
				ladno = StringHelper.null2String(map2.get("ladno"));
			}*/
			String sql3 = "select invoiceno,invoicestatue,feetype from uf_lo_budget where loadplanno='"+planno+"' and feetype='40285a8d4d6fab42014d742812381730'";
			List list3 = baseJdbc.executeSqlForList(sql3);
			if ( list3.size()>0 ) {	
				Map map3 = (Map)list3.get(0);	
				invoiceno = StringHelper.null2String(map3.get("invoiceno"));
			}
%>
<TR>
<TD><input type="hidden" id="<%="field_no_"+k %>" name="no" value="<%=k %>"><%=k %></TD>
<TD style="display:none"><input type="hidden" id="<%="field_planreqid_"+k %>" name="planreqid" value="<%=planreqid %>"><%=planreqid %></TD>
<TD><input type="hidden" id="<%="field_planno_"+k %>" name="planno" value="<%=planno %>"><%=planno %></TD>
<TD><input type="hidden" id="<%="field_pricetypetxt_"+k %>" name="pricetypetxt" value="<%=pricetypetxt %>"><%=pricetypetxt %></TD>
<TD><input type="hidden" id="<%="field_reqman_"+k %>" name="reqman" value="<%=reqman %>"><%=reqman %></TD>
<TD><input type="hidden" id="<%="field_ladno_"+k %>" name="ladno" value="<%=ladno %>"><%=ladno %></TD>
<TD><input type="hidden" id="<%="field_ispondtxt_"+k %>" name="ispondtxt" value="<%=ispondtxt %>"><%=ispondtxt %></TD>
<TD><input type="hidden" id="<%="field_finishpond_"+k %>" name="finishpond" value="<%=finishpond %>"><%=finishpond %></TD>
<TD><input type="hidden" id="<%="field_fare_"+k %>" name="fare" value="<%=fare %>"><%=fare %></TD>
<TD><input type="hidden" id="<%="field_invoiceno_"+k %>" name="invoiceno" value="<%=invoiceno %>"><%=invoiceno %></TD>
<TD><input type=<%=(( ("包车".equals(pricetypetxt) || "单拖".equals(pricetypetxt) ) &&  "是".equals(ispondtxt) && !"".equals(finishpond) && "".equals(invoiceno) )?"button":"hidden") %> id="<%="field_crebudget_"+k%>" value="手工生成暂估单" onclick="singlecrebudget('<%=planno %>');"></TD>
</TR>
<%				
		}		
	} else {
		errmsg = "没有数据，请重新输入正确的查询条件";
	}

} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		errmsg = e.toString();
}
%>
</TBODY></TABLE>
<TABLE border=1 id="errorinfoid">
<CAPTION>查询结果</CAPTION>
<TBODY>
<TR>
<TD><%=errmsg %></TD>
</TR>
</TBODY></TABLE>
</DIV> 