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
//礼品-礼品出库-出库明细	ID:40288182309608260130960e2b0a0005
//礼品出库明细表:uf_gift_storeout_dt
//	礼品名称:	giftname
//	礼品类型:	gifttype
//	规格:	norms
//	所属部门:	belongdept
//	单价:	unitprice
//	小计:	subtotal
//	关联:	relations
//	仓库名称:	whname
//	备注:	remarks
//	出库数量:	applyno
//	原因:	reason
//	库存:	safeline
//礼品-礼品出库-主表	ID:40288182309608260130960debde0004
//礼品出库主表:uf_gift_storeout
//	出库单号:	flowno
//	领取方式:	getway
//	申请人:	req
//	申请部门:	reqdept
//	事由:	reason
//	真实事由:	realreason
//	处理日期:	dealtime
//	处理人员:	dealer
//---------------------------------------

//---------------------------------------
//需要更新库存表单:uf_gift_store 
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
//出库累计:  numout
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
String gift="";


if(operatemode.equals("submit")){

    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    String sql="select  giftname,whname,belongdept,applyno,subtotal  from uf_gift_storeout_dt   where requestid='"+requestid+"'";
    List list = baseJdbc.executeSqlForList(sql);
    for(int i=0;i<list.size();i++){
	    Map map = new HashMap();
	    map = (Map)list.get(i);
	    String giftname=StringHelper.null2String(map.get("giftname"));
               String sqlselect="select giftname as gift from outstore where requestid='"+giftname+"'";
               List listname = baseJdbc.executeSqlForList(sqlselect);
               if(listname.size()>0)
               {
               Map mapname = new HashMap();
	    mapname = (Map)listname.get(0);
	    gift=StringHelper.null2String(mapname.get("gift"));
               }



               String txtitle=gift+"礼品库存提醒";
               String whname=StringHelper.null2String(map.get("whname"));
	    String belongdept=StringHelper.null2String(map.get("belongdept"));	    
	    Integer applyno=Integer.parseInt(StringHelper.null2String(map.get("applyno")));
	    Double subtotal=Double.parseDouble(StringHelper.null2String(map.get("subtotal")));

	    String SqlUpdate="update uf_gift_store set storeno=(storeno-"+applyno+"),total=(total-"+subtotal+"),rnumber=(rnumber-"+applyno+"),numout=(nvl(numout,0)+"+applyno+") where id='"+giftname+"' and  whname='"+whname+"' and bdept='"+belongdept+"'";
	    baseJdbc.update(SqlUpdate);   


    String selectstore="select a.bdept,a.giftname,sum(storeno) as sumstoreno,b.safeline as sumsafeline from uf_gift_store a,uf_gift_safe_dt b where a.bdept=b.belongdept and a.giftname=b.giftname and a.id='"+giftname+"' and a.bdept='"+belongdept+"' group by a.bdept,a.giftname,b.safeline";   
    List list1 = baseJdbc.executeSqlForList(selectstore);
    if(list1.size()>0)
    {
    Map map1 = new HashMap();
    map1 = (Map)list1.get(0);
    int sumstoreno=NumberHelper.string2Int(map1.get("sumstoreno"),0);
    int sumsafeline=NumberHelper.string2Int(map1.get("sumsafeline"),0);
    String txnr="您好，"+gift+"礼品库存量为"+StringHelper.null2String(sumstoreno)+"，已低于其安全库存量"+StringHelper.null2String(sumsafeline)+"，请及时补充库存，谢谢！"; 
    String txURL="/app/bom/bomredirect.jsp?type=lp"; 
    if(sumstoreno<sumsafeline)
    {

     if(belongdept.equals("4028818231402b05013141f634690cdc"))
     {
     String selectman="select a.id,a.objname from humres a,sysuser b, sysuserrolelink c,sysrole d where a.id=b.objid and b.id=c.userid and c.roleid=d.id and c.roleid='4028818230929f5701309325531b0123' and c.rolelevel='HRMDEPARTMENTECOLOGYAA0000000004'";
     List list2 = baseJdbc.executeSqlForList(selectman);
     for(int j=0;j<list2.size();j++){
     	    Map map2 = new HashMap();
	    map2 = (Map)list2.get(j);
	    String humresid=StringHelper.null2String(map2.get("id"));
	    String SqlInsert = "insert into uf_configuration_xx(id,requestid,txtitle,txnr,txopera,txDate,txURL,txrequestid,txifoper,txremindtype,txtop,txtodo)  values('"+IDGernerator.getUnquieID()+"','"+IDGernerator.getUnquieID()+"','"+txtitle+"','"+txnr+"','"+humresid+"','"+gdate+"','"+txURL+"','"+requestid+"','0','礼品库存预警','0','0')";
    baseJdbc.update(SqlInsert);
}
}
     else
     {
      String selectman="select a.id,a.objname from humres a,sysuser b, sysuserrolelink c,sysrole d where a.id=b.objid and b.id=c.userid and c.roleid=d.id and c.roleid='4028818230929f5701309325531b0123' and c.rolelevel!='HRMDEPARTMENTECOLOGYAA0000000004'";
     List list2 = baseJdbc.executeSqlForList(selectman);
     for(int j=0;j<list2.size();j++){
     	    Map map2 = new HashMap();
	    map2 = (Map)list2.get(j);
	    String humresid=StringHelper.null2String(map2.get("id"));
	    String SqlInsert = "insert into uf_configuration_xx(id,requestid,txtitle,txnr,txopera,txDate,txURL,txrequestid,txifoper,txremindtype,txtop,txtodo)  values('"+IDGernerator.getUnquieID()+"','"+IDGernerator.getUnquieID()+"','"+txtitle+"','"+txnr+"','"+humresid+"','"+gdate+"','"+txURL+"','"+requestid+"','0','礼品库存预警','0','0')";
    baseJdbc.update(SqlInsert);
    }
     
    }
    

    }


    }

       
    }


}



if(!StringHelper.isEmpty(otherextpages)){
		if(otherextpages.indexOf("/workflow/extpage/")<0)
			otherextpages = "/workflow/extpage/"+otherextpages;
		otherextpages += "?requestid="+StringHelper.null2String(requestid)

+"&operatemode="+operatemode+"&directnodeid="+directnodeid+"&targeturl="+URLEncoder.encode

(targeturl);
		response.sendRedirect(otherextpages);
		return;
	}
targeturl="/workflow/request/close.jsp?mode=submit&requestname="+StringHelper.getEncodeStr("礼品出库")+"&requestid="+requestid;
%>

<script>
 window.location.href="<%=targeturl%>";
</script>


