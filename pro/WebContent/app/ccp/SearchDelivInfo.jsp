<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="org.json.simple.JSONObject"%>
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
<%@ page import="com.eweaver.app.configsap.SapSync"%> 
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if(action.equals("getData"))
	{
		EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		String requestid = StringHelper.null2String(request.getParameter("requestid"));//表单的requestid
		String delsql = "delete uf_oa_reconformdetail where requestid = '"+requestid+"'";
		baseJdbc.update(delsql);
		String companycode = StringHelper.null2String(request.getParameter("companycode"));//公司代码
		String supplycode = StringHelper.null2String(request.getParameter("supplycode"));//快递公司简码
		String startdate = StringHelper.null2String(request.getParameter("startdate"));//收发件日期(起)
		String enddate = StringHelper.null2String(request.getParameter("enddate"));//收发件日期(止)
		
		String sql = "select a.requestid as kdrequestid,a.sendcomname as sendcomname,a.consigdate as consigdate,a.costowncenter as costowncenter,";
		sql = sql +"a.delivno as delivno,a.costownpan as costownpan,a.costowndept as costowndept,";
		sql = sql +"a.speed as speed,a.delivtype as delivtype,a.goodclass as goodclass,a.area as area,";
		sql = sql +"a.actgross as actgross,a.abnormcost as abnormcost,a.allmon as allmon,a.tax as tax,";
		sql = sql +"a.notaxamount as notaxamount,a.generledger as generledger,b.orderrow as orderrow,";

		sql = sql +"b.orderno as orderno,b.netpriceall as netpriceall from uf_oa_deliveryapp a left join uf_oa_delivsaleorder b ";  

		sql = sql +"on a.requestid = b.requestid where 1=(select isfinished from requestbase where id =a.requestid) "; 
		sql = sql +" and a.sendcomname ='"+supplycode+"'";
		sql = sql +" and a.costcomcode ='"+companycode+"'"; 
		sql = sql +" and a.ifdz is null";
		if(startdate != "")  
		{  
			sql = sql + " and a.consigdate >='"+startdate+"'";  
		}  
		if(enddate != "")  
		{  
			sql = sql +" and a.consigdate <='"+enddate+"'";  
		}  
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		Float allfees = 0.0f;
		Float notaxfees = 0.0f;
		if(list.size()>0){
		for(int s=0;s<list.size();s++){
			Map map = (Map)list.get(s);
			String kdrequestid = StringHelper.null2String(map.get("kdrequestid"));//快递申请单的requestid
			
			String sendcomname = StringHelper.null2String(map.get("sendcomname"));//快递公司
			String consigdate = StringHelper.null2String(map.get("consigdate"));//收发件日期
			String costowncenter = StringHelper.null2String(map.get("costowncenter"));//成本中心
			String delivno = StringHelper.null2String(map.get("delivno"));//快递单号
			String costownpan = StringHelper.null2String(map.get("costownpan"));//费用归属人		
			String costowndept = StringHelper.null2String(map.get("costowndept"));//费用归属部门
			
			String speed = StringHelper.null2String(map.get("speed"));//速度
			String delivtype = StringHelper.null2String(map.get("delivtype"));//快递业务类型
			String goodclass = StringHelper.null2String(map.get("goodclass"));//快递物品类别
			String area = StringHelper.null2String(map.get("area"));//区域
			String actgross = StringHelper.null2String(map.get("actgross"));//实际毛重
			String abnormcost = StringHelper.null2String(map.get("abnormcost"));//异常费用
			String allmon = StringHelper.null2String(map.get("allmon"));//费用小计
			
			//allfees = allfees + Float.parseFloat(allmon);//计算累计金额
			
			String tax = StringHelper.null2String(map.get("tax"));//税码
			String notaxamount = StringHelper.null2String(map.get("notaxamount"));//未税金额
			//notaxfees = notaxfees + Float.parseFloat(notaxamount);//计算累计未税金额
			
			String generledger = StringHelper.null2String(map.get("generledger"));//总账科目
			String orderno = StringHelper.null2String(map.get("orderno"));//采购订单号
			String orderrow = StringHelper.null2String(map.get("orderrow"));//采购订单项次
			String upsql = "insert into uf_oa_reconformdetail (delivcompany,style,thedate,costcenter,delivno,";
			upsql = upsql +"belongpsn,belongdept,speed,ywstyle,goodclass,area,actualgross,specialfee,sumfee,";
			upsql = upsql +"tax,notaxfee,genledger,saleorder,saleorderrow,requestid,id,no,reqno)";
			upsql = upsql +"values('"+sendcomname+"','快递发送','"+consigdate+"','"+costowncenter+"','"+delivno+"',";
			upsql = upsql +"'"+costownpan+"','"+costowndept+"','"+speed+"','"+delivtype+"','"+goodclass+"',";
			upsql = upsql +"'"+area+"','"+actgross+"','"+abnormcost+"','"+allmon+"','"+tax+"','"+notaxamount+"',";
			upsql = upsql+"'"+generledger+"','"+orderno+"','"+orderrow+"',";
			upsql = upsql +"'"+requestid+"','"+IDGernerator.getUnquieID()+"',(select count(no)+1 from uf_oa_reconformdetail where requestid = '"+requestid+"')";
			upsql = upsql +",'"+kdrequestid+"')";
			baseJdbc.update(upsql);
		}//end for
		}//end if
		String updatesql = "update uf_oa_reconform set allfees = '"+allfees+"',notaxfees = '"+notaxfees+"' where requestid = '"+requestid+"'";
		baseJdbc.update(updatesql);
		String MSG = "You have successfully searched "+list.size()+" records";
		JSONObject jo = new JSONObject();		
		jo.put("msg", MSG);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}//end if
%>
