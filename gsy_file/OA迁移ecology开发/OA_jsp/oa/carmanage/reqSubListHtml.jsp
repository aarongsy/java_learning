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

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String cartype = StringHelper.null2String(request.getParameter("cartype"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
StringBuffer buf = new StringBuffer();
//40285a8f489c17ce0149070983113560 	外叫车
//40285a8f489c17ce0149070983113561 	长租车
//40285a8f489c17ce0149070983113562	公司车
String sql = "";
String flag = "";
String wjcstyle = "";
String czcstyle = "";
if(cartype.equals("40285a8f489c17ce0149070983113560")){
	flag = "wjc";
	wjcstyle = "block";
	czcstyle = "none";
	sql = "select a.id,a.no,a.comcode,cararrno cararrid,(select flowno from uf_oa_cararrange where requestid=a.cararrno) cararrno,a.arrsdate,b.objname costdeptname ,a.costdept,a.costcenter,a.appuser,a.feeaccount,a.innerorder,a.approute,a.actroute,(select objname from selectitem where id=a.isreturn) isreturn,(select objname from selectitem where id=a.isbaoche) isbaoche,(select objname from selectitem where id=a.carmodel) carmodel,a.mile,a.gpsmile,a.actmile,a.bcf,a.jbf,a.dbf,a.glf,a.tcf,a.yf,a.fjf,a.zcf,a.amount,a.notax,a.tax,a.fjfyy,a.appstime,a.appetime,a.arrstime,a.arretime,a.gotonum,a.backnum,a.totalpsn,a.ratio,(select carno from uf_oa_carinfo where requestid=a.carno) carno,a.driver,a.drivertel,(select supplyname from uf_oa_supplyinfo where requestid=a.supplyname) supplyname,(select flowno from uf_oa_carapp where requestid=a.carappno) carappno,a.detailno,a.reason from uf_oa_carreconsub a left join orgunit b on a.costdept=b.id  where requestid='"+requestid+"' order by no asc";
}
if(cartype.equals("40285a8f489c17ce0149070983113561")){
	flag = "czc";
	wjcstyle = "none";
	czcstyle = "block";
	sql = "select a.id,a.no,a.comcode,cararrno cararrid,(select flowno from uf_oa_cararrange where requestid=a.cararrno) cararrno,a.arrsdate,b.objname costdeptname ,a.costdept,a.costcenter,a.appuser,a.feeaccount,a.innerorder,a.approute,a.actroute,(select objname from selectitem where id=a.isreturn) isreturn,(select objname from selectitem where id=a.isbaoche) isbaoche,(select objname from selectitem where id=a.carmodel) carmodel,a.mile,a.gpsmile,a.actmile,a.bcf,a.jbf,a.dbf,a.glf,a.tcf,a.yf,a.fjf,a.zcf,a.amount,a.notax,a.tax,a.fjfyy,a.appstime,a.appetime,a.arrstime,a.arretime,a.gotonum,a.backnum,a.totalpsn,a.ratio,(select carno from uf_oa_carinfo where requestid=a.carno) carno,a.driver,a.drivertel,(select supplyname from uf_oa_supplyinfo where requestid=a.supplyname) supplyname,(select flowno from uf_oa_carapp where requestid=a.carappno) carappno,a.detailno,a.reason from uf_oa_carreconsub a left join orgunit b on a.costdept=b.id  where requestid='"+requestid+"' order by no asc";
}
if(cartype.equals("")){
	wjcstyle = "block";
	czcstyle = "block";
	sql = "select a.id,a.no,a.comcode,cararrno cararrid,(select flowno from uf_oa_cararrange where requestid=a.cararrno) cararrno,a.arrsdate,b.objname costdeptname ,a.costdept,a.costcenter,a.appuser,a.feeaccount,a.innerorder,a.approute,a.actroute,(select objname from selectitem where id=a.isreturn) isreturn,(select objname from selectitem where id=a.isbaoche) isbaoche,(select objname from selectitem where id=a.carmodel) carmodel,a.mile,a.gpsmile,a.actmile,a.bcf,a.jbf,a.dbf,a.glf,a.tcf,a.yf,a.fjf,a.zcf,a.amount,a.notax,a.tax,a.fjfyy,a.appstime,a.appetime,a.arrstime,a.arretime,a.gotonum,a.backnum,a.totalpsn,a.ratio,(select carno from uf_oa_carinfo where requestid=a.carno) carno,a.driver,a.drivertel,(select supplyname from uf_oa_supplyinfo where requestid=a.supplyname) supplyname,(select flowno from uf_oa_carapp where requestid=a.carappno) carappno,a.detailno,a.reason from uf_oa_carreconsub a left join orgunit b on a.costdept=b.id  where requestid='"+requestid+"' order by no asc";
}
List sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		String no=StringHelper.null2String(mk.get("no"));
		String comcode=StringHelper.null2String(mk.get("comcode"));
		String cararrid=StringHelper.null2String(mk.get("cararrid")); 
		String cararrno=StringHelper.null2String(mk.get("cararrno"));
		String arrsdate=StringHelper.null2String(mk.get("arrsdate"));
		String costdeptname=StringHelper.null2String(mk.get("costdeptname"));
		String costdept=StringHelper.null2String(mk.get("costdept"));
		String costcenter=StringHelper.null2String(mk.get("costcenter"));
		String appuser=StringHelper.null2String(mk.get("appuser"));
		String feeaccount=StringHelper.null2String(mk.get("feeaccount"));
		String innerorder=StringHelper.null2String(mk.get("innerorder"));
		String approute=StringHelper.null2String(mk.get("approute"));
		String actroute=StringHelper.null2String(mk.get("actroute"));
		String isreturn=StringHelper.null2String(mk.get("isreturn"));
		
		String isbaoche=StringHelper.null2String(mk.get("isbaoche"));
		String carmodel=StringHelper.null2String(mk.get("carmodel"));
		
		String mile=StringHelper.null2String(mk.get("mile"));
		String gpsmile=StringHelper.null2String(mk.get("gpsmile"));
		String actmile=StringHelper.null2String(mk.get("actmile"));
		String bcf=StringHelper.null2String(mk.get("bcf"));
		String jbf=StringHelper.null2String(mk.get("jbf"));
		String dbf=StringHelper.null2String(mk.get("dbf"));
		String glf=StringHelper.null2String(mk.get("glf"));
		String tcf=StringHelper.null2String(mk.get("tcf"));
		String yf=StringHelper.null2String(mk.get("yf"));
		String fjf=StringHelper.null2String(mk.get("fjf"));
		String zcf=StringHelper.null2String(mk.get("zcf"));
		String amount=StringHelper.null2String(mk.get("amount"));
		String notax=StringHelper.null2String(mk.get("notax"));
		String tax=StringHelper.null2String(mk.get("tax"));
		String fjfyy=StringHelper.null2String(mk.get("fjfyy"));
		String appstime=StringHelper.null2String(mk.get("appstime"));
		String appetime=StringHelper.null2String(mk.get("appetime"));
		String arrstime=StringHelper.null2String(mk.get("arrstime"));
		String arretime=StringHelper.null2String(mk.get("arretime"));
		String gotonum=StringHelper.null2String(mk.get("gotonum"));
		String backnum=StringHelper.null2String(mk.get("backnum"));
		String totalpsn=StringHelper.null2String(mk.get("totalpsn"));
		String ratio=StringHelper.null2String(mk.get("ratio"));
		String carno=StringHelper.null2String(mk.get("carno"));
		String driver=StringHelper.null2String(mk.get("driver"));
		String drivertel=StringHelper.null2String(mk.get("drivertel"));
		String supplyname=StringHelper.null2String(mk.get("supplyname"));
		String carappno=StringHelper.null2String(mk.get("carappno"));
		String detailno=StringHelper.null2String(mk.get("detailno"));
		String reason=StringHelper.null2String(mk.get("reason"));
		
		buf.append("<TR ondblclick=window.open(\"/workflow/request/formbase.jsp?categoryid=40285a904a6fdaa1014a70d5b81521fe&requestid="+cararrid+"\")>");
		buf.append("<TD class=\"td2\"  align=center>"+no+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+comcode+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+cararrno+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+arrsdate+"</TD>");
		buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+k+"\" value=\""+costdept+"\" ><span id=\"dept_"+k+"span\" name=\"dept_"+k+"span\"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id="+costdept+"','"+costdeptname+"','tab"+costdept+"') >&nbsp;"+costdeptname+"&nbsp;</a></span></TD>");
		
		buf.append("<TD class=\"td2\"  align=center>"+costcenter+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+appuser+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+feeaccount+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+innerorder+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+reason+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+approute+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+actroute+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+isreturn+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+isbaoche+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+carmodel+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\">"+mile+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\">"+gpsmile+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\">"+actmile+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+bcf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+jbf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+dbf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+glf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+tcf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+yf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+fjf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\">"+zcf+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+amount+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+notax+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+tax+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+fjfyy+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+appstime+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+appetime+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+arrstime+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+arretime+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+gotonum+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+backnum+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+totalpsn+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+ratio+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+carno+"</TD>");
		buf.append("<TD class=\"td2\"  align=center>"+driver+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+drivertel+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+supplyname+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+carappno+"</TD>");
		buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+detailno+"</TD>");
		buf.append("</TR>");
		
	}
	buf.append("</table></div>");
}
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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="4%">
<COL width="5%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="1%">
<COL width="1%">
<COL width="2%">
<COL width="2%">
<COL width="4%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%"></COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>公司代码</TD>
<TD  noWrap class="td2"  align=center>排车单号</TD>
<TD  noWrap class="td2"  align=center>出 发 日 期</TD>
<TD  noWrap class="td2"  align=center>费 用 部 门</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>乘  车  人</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>内部订单</TD>
<TD  noWrap class="td2"  align=center>用车事由</TD>
<TD  noWrap class="td2"  align=center style="display:none">申请行程</TD>
<TD  noWrap class="td2"  align=center style="display:none">实际行程</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">是否往返</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">是否包车</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">   车 型    </TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">登记里程数</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">GPS里程数</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">实际核算里程数</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">包车费</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">基本费</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">短驳费</TD>
<TD  noWrap class="td2"  align=center>过路费</TD>
<TD  noWrap class="td2"  align=center>停车费</TD>
<TD  noWrap class="td2"  align=center>油费</TD>
<TD  noWrap class="td2"  align=center>附加费</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">租车费</TD>
<TD  noWrap class="td2"  align=center>费用小计</TD>
<TD  noWrap class="td2"  align=center>未税金额</TD>
<TD  noWrap class="td2"  align=center>税  金</TD>
<TD  noWrap class="td2"  align=center>附加费说明</TD>
<TD  noWrap class="td2"  align=center style="display:none">申请出发时间</TD>
<TD  noWrap class="td2"  align=center style="display:none">申请返回时间</TD>
<TD  noWrap class="td2"  align=center>出发时间</TD>
<TD  noWrap class="td2"  align=center>返回时间</TD>
<TD  noWrap class="td2"  align=center>去程人数</TD>
<TD  noWrap class="td2"  align=center>返程人数</TD>
<TD  noWrap class="td2"  align=center>排车单总人数</TD>
<TD  noWrap class="td2"  align=center>分摊比例</TD>
<TD  noWrap class="td2"  align=center>车  牌  号</TD>
<TD  noWrap class="td2"  align=center>司机姓名</TD>
<TD  noWrap class="td2"  align=center style="display:none">司机电话</TD>
<TD  noWrap class="td2"  align=center style="display:none">租赁公司</TD>
<TD  noWrap class="td2"  align=center style="display:none">用车单号</TD>
<TD  noWrap class="td2"  align=center style="display:none">用车明细单号</TD>

</tr>

<%
out.println(buf.toString());
%>

</table>
</div>
