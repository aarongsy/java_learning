<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 request.setCharacterEncoding("UTF-8");
 //当前工作流包含表单是抽象表单
//装卸计划主表	ID:402864d1493f92fa01494014edcd0003
//	申请编号:	reqno
//	前置计划:	preplan
//	车牌号:	carno
//	计价日期:	figuredate
//	辅路线价格:	assistprice
//	是否回单:	returnbill
//	线路终点:	arrivecity
//	无SAP单据:	nosap
//	运输吨位:	transitton
//	承运商编码:	concode
//	计划总量:	totalnum
//	主线路编码:	linecode
//	里程:	miles
//	申请人:	reqman
//	分段运输:	subsection
//	挂车号:	trailerno
//	离港日期:	offdate
//	同城个数:	cities
//	线路名称:	remark
//	制单类型:	createtype
//	承运商名称:	conname
//	推荐承运商编码:	rconcode
//	变更原因:	chgreason
//	提贷开始:	pickupdate
//	线路起点:	startcity
//	申请部门:	reqdept
//	运出标记:	shipout
//	货柜号:	loanno
//	公司:	company
//	同城价格:	cityprice
//	线路类型:	linetype
//	业务类型:	servicetype
//	运输类型:	transittype
//	计划毛重:	grosswt
//	流水号:	runingno
//	申请日期:	reqdate
//	是否过磅:	ispond
//	封签号:	signno
//	厂区别:	factory
//	总运费:	fare
//	司机姓名:	drivername
//	到港日期:	arrivedate
//	是否计入委托:	isacceptflag
//	状态:	state
//	车辆车型:	cartype
//	异常运费:	expfare
//	标题:	title
//	联系电话:	cellphone
//	委托截止:	rcolddate
//	主路线价格:	mainprice
//	是否准点:	isontime
//	承运商系统账号:	conaccount
//	接受委托:	isaccept
//	推荐承运商名称:	rconname
//	过磅完成时间:	finishpond
//装卸计划辅线路明细	ID:402864d14940d265014940f3aa830031
//	线路类型:	linetype
//	线路编码:	linecode
//	线路起点:	startcity
//	线路名称:	remark
//	序号:	pid
//	里程:	miles
//	线路终点:	arrivecity
//装卸计划装卸产品明细	ID:402864d14940d265014940e898b80004
//	分摊费用:	divvyfee
//	分摊异常费用:	divvyexpfee
//	关联字段:	pid
//	流水号:	runningno
//	单据类型:	ordertype
//	产品组:	goodsgroup
//	是否自提:	isself
//	物料号码:	materialno
//	物料描述:	materialdesc
//	交运需求数量:	deliverdnum
//	已排车数:	yetloadnum
//	剩余排车数:	leftloadnum
//	暂无需求数:	notdelinum
//	暂无剩余排车量:	notloadnum
//	单位:	salesunit
//	售达方:	soldto
//	售达方名称:	soldtoname
//	送达方:	shipto
//	送达方名称:	shiptoname
//	送达地址:	shiptoaddress
//	提入单:	pondno
//	成品交运/重量证明单:	proveno
//---------------------------------------
%>
<%@ page import="java.util.List"%>
 <%@ page import="com.eweaver.base.BaseJdbcDao"%>
 <%@ page import="com.eweaver.base.BaseContext"%>
 <%@ page import="java.util.Map" %>
  <% 
  String targeturl = request.getParameter("targeturl");
  String requestid = request.getParameter("requestid");
  targeturl=BaseContext.getContextpath()+"/workflow/request/close.jsp?mode=submit";
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  
  String operatemode=request.getParameter("operatemode");
  if(operatemode.equals("submit")){	  
	   String linecode="";
	   String transittype="";
	   String tstart="";
	   String sqlload="select linecode,transittype from uf_lo_loadplan   where requestid='"+requestid+"'";
       System.out.println(sqlload);
	    List listload=baseJdbcDao.getJdbcTemplate().queryForList(sqlload);
		for(int i=0;i<listload.size();i++){
		  linecode=((Map) listload.get(i)).get("linecode") == null ? "" : ((Map)  listload.get(i)).get("linecode").toString(); 
		  transittype=((Map) listload.get(i)).get("transittype") == null ? "" : ((Map)  listload.get(i)).get("transittype").toString(); 
          tstart=((Map) listload.get(i)).get("tstart") == null ? "" : ((Map)  listload.get(i)).get("tstart").toString(); 
		  String sqlloginmathch="update uf_lo_loadplan set conaccount=(select userid from uf_lo_loginmatch where requestid in ( select consolidator from (select  consolidator from uf_lo_trackprice where linecode='"+linecode+"' and transittype='"+transittype+"'  and tstart='"+tstart+"' order by lineprice asc ) where rownum=1 ) where requestid='"+requestid+"'"; 
		  System.out.println("aaaaaaaaaaaaaluo : "+sqlloginmathch);
	     baseJdbcDao.update(sqlloginmathch);
		}
response.sendRedirect(targeturl);
	  }
%>
