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
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>//获取登陆用户
<%@page import="com.eweaver.base.util.DateHelper"%>//获取登陆日期时间
<%@page import="com.eweaver.base.DataService"%>//用于SQL执行
<%@page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%
//当前工作流包含表单是抽象表单
//礼品-礼品入库-主表	ID:4028818230929f570130932e83e40138
//	入库单号:	flowno
//	入库部门:	reqdept (无)
//	入库人:	reqman
//	入库时间:	reqtime
//	入库标题:	title
//礼品-礼品入库-入库明细	ID:4028818230929f570130932f337d0139
//	礼品名称:	giftname
//	规格:	norms
//	当前市价:	currentprice
//	入库数量:	amount
//	是否公司定制:	iscustomize
//	礼品用途:	usefor
//	备注:	remarks
//	关联:	relations
//	价格合计:	price
//	仓库名称:	whname
//         所属部门: bdept 
//	礼品类型:	gifttype
//	入库类型:	import
//	价格:	oprice
//---------------------------------------
//	申领单号:	reqno
//	总部门/分公司:	orgid
//	是否会签:	iscsign
//	申请人:	reqman
//	会签部门:	csigndept
//	合计:	sumup
//	申请日期2:	reqtime2
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
double  aveprice=0;



if(operatemode.equals("submit")){

   BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

        String sql="select a.reqdept,b.giftname,b.gifttype,b.norms,b.whname,b.bdept,b.iscustomize,b.amount,b.price  from uf_gift_storein a,uf_gift_storein_dt b where  a.requestid=b.requestid and a.requestid='"+requestid+"'";
    List list = baseJdbc.executeSqlForList(sql);
    for(int i=0;i<list.size();i++){
	    Map map = new HashMap();
	    map = (Map)list.get(i);
	    String a_reqdept=StringHelper.null2String(map.get("reqdept"));
	    String b_giftname=StringHelper.null2String(map.get("giftname"));
	    String b_gifttype=StringHelper.null2String(map.get("gifttype"));
	    String b_norms=StringHelper.null2String(map.get("norms"));
	    String b_whname=StringHelper.null2String(map.get("whname"));
            String b_belongdept=StringHelper.null2String(map.get("bdept"));
	    String b_iscustomize=StringHelper.null2String(map.get("iscustomize"));
	    Integer b_amount=Integer.parseInt(StringHelper.null2String(map.get("amount")));
	    Double b_price=Double.parseDouble(StringHelper.null2String(map.get("price")));


	    String Sqlcount="select bdept,sum(total) as sumtotal,sum(storeno) as sumstoreno from uf_gift_store where giftname='"+b_giftname+"'and bdept='"+b_belongdept+"' group by bdept";
            List list_b=baseJdbc.executeSqlForList(Sqlcount);
	    if(list_b.size()>0)
              {
	    Map map_b = new HashMap();
	    map_b = (Map)list_b.get(0);
               int sumstoreno=NumberHelper.string2Int(map_b.get("sumstoreno"),0);
	       double sumtotal=NumberHelper.string2Double(map_b.get("sumtotal"),0);
               aveprice=(sumtotal+b_price)/(sumstoreno+b_amount);
               }
               else
               {
               aveprice=b_price/b_amount;
               }
                       
	    String SqlUpda="update uf_gift_info  set price="+aveprice+" where requestid='"+b_giftname+"'";
	    baseJdbc.update(SqlUpda);



	    String SqlSelect="select count(*) as a from uf_gift_store where giftname='"+b_giftname+"' and  whname='"+b_whname+"' and bdept='"+b_belongdept+"'";

	    List list_a=baseJdbc.executeSqlForList(SqlSelect);

	    Map map_a=new HashMap();
            map_a=(Map)list_a.get(0);
            int aa=NumberHelper.string2Int(map_a.get("a"),0);
	    if(aa!=0){
	    String SqlUpdate="update uf_gift_store set storeno=(storeno+"+b_amount+"),total=(total+"+b_price+"),rnumber=(rnumber+"+b_amount+"),numin=(numin+"+b_amount+") where giftname='"+b_giftname+"' ";
	    baseJdbc.update(SqlUpdate);
	    }
	    else{
	    String SqlInsert="insert into uf_gift_store(id,requestid,giftname,gifttype,norms,whname,bdept,storeno,isxxx,total,numin,rnumber)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+b_giftname+"','"+b_gifttype+"','"+b_norms+"','"+b_whname+"','"+b_belongdept+"',"+b_amount+",'"+b_iscustomize+"',"+b_price+","+b_amount+","+b_amount+")";
	    baseJdbc.update(SqlInsert);
String formbasesql = "insert into formbase(id,creator,createdate,createtime,modifier,modifydate,modifytime,isdelete,categoryid,col1,col2,col3)  values('"+requestid+"','"+newuserid+"','"+gdate+"','"+gtime+"','','','',0,'','','','')";
dataService.executeSql(formbasesql);

	    
	    }

	    String SqlUpstore="update uf_gift_store  set price="+aveprice+",isawoke='0'  where giftname='"+b_giftname+"'  and bdept='"+b_belongdept+"'";
	    baseJdbc.update(SqlUpstore);

           
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
targeturl="/workflow/request/close.jsp?mode=submit&requestname="+StringHelper.getEncodeStr("礼品入库")+"&requestid="+requestid;
%>

<script>
 window.location.href="<%=targeturl%>";
</script>


