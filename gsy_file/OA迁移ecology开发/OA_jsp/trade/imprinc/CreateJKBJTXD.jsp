<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	//String cfdate=StringHelper.null2String(request.getParameter("date"));

	System.out.println(" action="+action);	
	
	String err="";	
    String passtdno="";
	String failtdno="";
 	
	JSONObject jo = new JSONObject();
	
	String sql = "select a.requestid tdreqid,a.imgoodsid tdflowno,a.arrtype,a.factory cqb,a.company,a.compancode comcode,a.reqman tduserid,a.reqdate tddate,a.currency  bz,a.suppliercode,a.suppliername,a.paymentcode,a.paymenttext,a.orderid orderno,a.imlistid jkhwflowno,a.cgyid,b.objname cgyname,b.extmrefobjfield8  onedept,b.extmrefobjfield7 twodept,to_char(sysdate,'yyyy-MM-dd hh:mm:ss') today from v_uf_tr_ladforimprincview a left join humres b on a.cgyid=b.id where a.cgyid is not null and a.requestid not in (select ladingreqid from uf_tr_imprincnotice a,requestbase b where a.requestid=b.id and b.isdelete=0 and b.isfinished=1 and a.isvalid ='40288098276fc2120127704884290210')";		
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start JKBJTXD......");
		for(int i = 0; i < list.size(); i++){
			if(i==1){
				break; //测试时使用
			}
			Map map = (Map)list.get(i);
			String tdreqid = StringHelper.null2String(map.get("tdreqid"));
			String tdflowno = StringHelper.null2String(map.get("tdflowno"));			
			String arrtype = StringHelper.null2String(map.get("arrtype"));
			String cqb = StringHelper.null2String(map.get("cqb"));
			String company = StringHelper.null2String(map.get("company"));
			String comcode = StringHelper.null2String(map.get("comcode"));
			String tduserid = StringHelper.null2String(map.get("tduserid"));
			String tddate = StringHelper.null2String(map.get("tddate"));
			String curr = StringHelper.null2String(map.get("bz"));
			String suppliercode = StringHelper.null2String(map.get("suppliercode"));
			String suppliername = StringHelper.null2String(map.get("suppliername"));
			String paymentcode = StringHelper.null2String(map.get("paymentcode"));
			String paymenttext = StringHelper.null2String(map.get("paymenttext"));
			String orderno = StringHelper.null2String(map.get("orderno"));
			String orderid = StringHelper.null2String(map.get("orderid"));
			String jkhwflowno = StringHelper.null2String(map.get("jkhwflowno"));
			String cgyid = StringHelper.null2String(map.get("cgyid"));
			String cgyname = StringHelper.null2String(map.get("cgyname"));
			String today = StringHelper.null2String(map.get("today"));
			String onedept = StringHelper.null2String(map.get("onedept"));
			String twodept = StringHelper.null2String(map.get("twodept"));
			
			// start    
			WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
			RequestInfo rs=new RequestInfo();
			rs.setCreator(tduserid); 
			rs.setTypeid("40285a8d4f1614a3014f1bb8cedb5f47");
			//rs.setIssave("0"); 	//1保存 0提交 注释代表提交？
			Dataset data=new Dataset();
			List<Cell> list1=new ArrayList<Cell>();
			Cell cell1=new Cell();
			cell1.setName("reqman");
			cell1.setValue(cgyid);
			list1.add(cell1);	

			cell1=new Cell();		
			cell1.setName("reqdate");
			cell1.setValue(today);
			list1.add(cell1);				
			
			cell1=new Cell();		
			cell1.setName("purchaser");
			cell1.setValue(cgyname);
			list1.add(cell1);
			
			cell1=new Cell();		
			cell1.setName("ladingreqid");
			cell1.setValue(tdreqid);
			list1.add(cell1);
			
			cell1=new Cell();		
			cell1.setName("ladingno");
			cell1.setValue(tdflowno);
			list1.add(cell1);	
			
			cell1=new Cell();		
			cell1.setName("orderno");
			cell1.setValue(orderno);
			list1.add(cell1);		

			cell1=new Cell();		
			cell1.setName("suppliercode");
			cell1.setValue(suppliercode);
			list1.add(cell1);	
			
			cell1=new Cell();		
			cell1.setName("suppliername");
			cell1.setValue(suppliername);
			list1.add(cell1);	

			cell1=new Cell();		
			cell1.setName("paymentcode");
			cell1.setValue(paymentcode);
			list1.add(cell1);	

			cell1=new Cell();		
			cell1.setName("paymenttext");
			cell1.setValue(paymenttext);
			list1.add(cell1);	

			cell1=new Cell();		
			cell1.setName("currency");
			cell1.setValue(curr);
			list1.add(cell1);				
			
			cell1=new Cell();		
			cell1.setName("ladingtype");
			cell1.setValue(arrtype);
			list1.add(cell1);
			
			cell1=new Cell();		
			cell1.setName("isvalid");
			cell1.setValue("40288098276fc2120127704884290210");
			list1.add(cell1);
			
			cell1=new Cell();		
			cell1.setName("comtype");
			cell1.setValue(cqb);
			list1.add(cell1);
			
			cell1=new Cell();		
			cell1.setName("comcode");
			cell1.setValue(comcode);
			list1.add(cell1);

			cell1=new Cell();		
			cell1.setName("company");
			cell1.setValue(company);
			list1.add(cell1);

			cell1=new Cell();		
			cell1.setName("onedept");
			cell1.setValue(onedept);
			list1.add(cell1);	

			cell1=new Cell();		
			cell1.setName("twodept");
			cell1.setValue(twodept);
			list1.add(cell1);			


			data.setMaintable(list1);
			rs.setData(data);
			String requestid = workflowServiceImpl.createRequest(rs);			
				
			System.out.println("auto end JKBJTXD......"+requestid);					
			passtdno = passtdno + ";"+tdflowno+"-"+orderno+"/"+cgyname;				
		}
	}else{
		err="0";
	}
	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("passtdno",passtdno);
		jo.put("failtdno",failtdno);		
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("passtdno",passtdno);
		jo.put("failtdno",failtdno);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
