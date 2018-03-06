<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="com.eweaver.humres.base.dao.HumresDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%
//当前工作流包含表单是抽象表单
//礼品-领用明细 uf_gift_receive_dt
//礼品-礼品领用-领用明细	ID:4028818230935a7d0130960250300003
//	礼品类型:	gifttype
//	规格:	norms
//	所属部门:	belongdept
//	单价:	unitprice
//	小计:	subtotal
//	仓库名称:	whname
//	关联:	relations
//	申领数量:	applyno
//	相关市场活动:	relmarket
//	礼品名称:	giftname
//	库存:	stock
//礼品-领用主表 uf_gift_receive
//礼品-礼品领用-主表	ID:4028818230935a7d013095fe4c0d0002
//	申请日期:	reqtime
//	申请人:	reqman
//	申请部门:	reqdept
//	总价:	sumprice
//	真实事由:	realreason
//	领取方式:	getway
//	签报编号:	relsign
//	申请单号:	flowno
//	标题:	title
//	领用事由:	reasonfor
//	是否总经理审批:	ismanager
//---------------------------------------
//库存表:uf_gift_store 
//礼品名称:  giftname
//礼品类型:  gifttype
//规格:  norms
//仓库名称:  whname
//所属部门:  bdept
//库存数量:  storeno
////单价:  price
//是否公司制定:  isxxx
//库存金额:  total
//入库累计:  numin
//可申领数量:  rnumber

String targeturl = StringHelper.null2String(request.getParameter("targeturl"));
String operatemode = StringHelper.null2String(request.getParameter("operatemode"));
String otherextpages = StringHelper.null2String(request.getParameter("otherextpages"));
String requestid= StringHelper.null2String(request.getParameter("requestid"));
String directnodeid = StringHelper.null2String(request.getParameter("directnodeid"));
EweaverUser newUser = BaseContext.getRemoteUser();
String newuserid = newUser.getId();
DataService dataService = new DataService();
String gdate=DateHelper.getCurrentDate();
String gtime=DateHelper.getCurrentTime();


if(operatemode.equals("submit")){

    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql="select  giftname,whname,belongdept,applyno from uf_gift_receive_dt  where  requestid='"+requestid+"'";
    List list = baseJdbc.executeSqlForList(sql);
    for(int i=0;i<list.size();i++){
	    Map map = new HashMap();
	    map = (Map)list.get(i);
	    String giftname=StringHelper.null2String(map.get("giftname"));
	    String whname=StringHelper.null2String(map.get("whname"));
	    String belongdept=StringHelper.null2String(map.get("belongdept"));
	    Integer applyno=Integer.parseInt(StringHelper.null2String(map.get("applyno")));

	    String SqlUpdate="update uf_gift_store set rnumber=(rnumber-"+applyno+") where id='"+giftname+"'and  whname='"+whname+"' and bdept='"+belongdept+"' ";
	    baseJdbc.update(SqlUpdate);
           
    }


}



if(!StringHelper.isEmpty(otherextpages)){
		if(otherextpages.indexOf("/workflow/extpage/")<0)
			otherextpages = "/workflow/extpage/"+otherextpages;
		otherextpages += "?requestid="+StringHelper.null2String(requestid)

+"&operatemode="+operatemode+"&directnodeid="+directnodeid+"&targeturl="+URLEncoder.encode(targeturl);
		response.sendRedirect(otherextpages);
		return;
	}
targeturl="/workflow/request/close.jsp?mode=submit&requestname="+StringHelper.getEncodeStr("礼品申领")+"&requestid="+requestid;
%>

<script>
 window.location.href="<%=targeturl%>";
</script>

