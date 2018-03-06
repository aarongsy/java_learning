<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>

<%@ page import="com.eweaver.app.configsap.SapConnector_EN" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	String chgflag=StringHelper.null2String(request.getParameter("chgflag"));
	
	String communitype=StringHelper.null2String(request.getParameter("communitype"));
	String communication=StringHelper.null2String(request.getParameter("communication"));
	
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("toSAP")){	//修改Address抛SAP
		JSONObject jsonObject = new JSONObject();		
		if( "1".equals(chgflag) ) { //add
			String empsapid=StringHelper.null2String(request.getParameter("empsapid"));
			String sdate=StringHelper.null2String(request.getParameter("sdate"));
			sdate = ds.getSQLValue("select to_char(to_date('"+sdate+"','YYYY-MM-DD'),'YYYYMMDD') sdate from dual");
			try {
				String functionName = "";
				JCoFunction function = null;
				String errorMessage = "";
			  
				functionName = "ZHR_PA002_COMMUNICATION_INS_MY"; //PA002:员工个人信息-Emergency Contact新增
				function = null;
				try {
					function = SapConnector_EN.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				if (function == null) {
					System.out.println(functionName + " not found in SAP.");
					System.out.println("SAP_RFC中没有此函数!");
					errorMessage = functionName + " not found in SAP.";
				}
				JCoTable jcotable = function.getTableParameterList().getTable("IT_COMMUNICATION");
				jcotable.appendRow();
				jcotable.setValue("PERNR", empsapid);
				jcotable.setValue("BEGDA", sdate);
				jcotable.setValue("USRTY", communitype);
				jcotable.setValue("USRID", communication);
				

				try {
					function.execute(SapConnector_EN.getDestination("sanpowersapen"));
					//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}	
		
				//返回值
				String sapmsg = StringHelper.null2String(jcotable.getValue("MESSAGE").toString());
				String sapmsgtype = jcotable.getValue("MSGTY").toString();
				if ( "I".equals(sapmsgtype) ){
					jsonObject.put("info",sapmsg);
					jsonObject.put("sapflag",sapmsgtype);	
					jsonObject.put("msg","true");
				} else {
					jsonObject.put("info",sapmsg);
					jsonObject.put("sapflag",sapmsgtype);	
					jsonObject.put("msg","false");
				}
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("info",e.getMessage());
				jsonObject.put("sapflag","");
				jsonObject.put("msg","false");				
			}	
		} 

		if( "2".equals(chgflag) ) {	
			String oempsapid=StringHelper.null2String(request.getParameter("oempsapid"));
			String subtype=StringHelper.null2String(request.getParameter("subtype"));
			String objtype=StringHelper.null2String(request.getParameter("objtype"));	
			String hrlock=StringHelper.null2String(request.getParameter("hrlock"));
			String osdate=StringHelper.null2String(request.getParameter("osdate"));
			osdate = ds.getSQLValue("select to_char(to_date('"+osdate+"','YYYY-MM-DD'),'YYYYMMDD') osdate from dual");
			String oedate=StringHelper.null2String(request.getParameter("oedate"));
			oedate = ds.getSQLValue("select to_char(to_date('"+oedate+"','YYYY-MM-DD'),'YYYYMMDD') oedate from dual");
			String seqnr=StringHelper.null2String(request.getParameter("seqnr"));
			try {
				String functionName = "";
				JCoFunction function = null;
				String errorMessage = "";
			  
				functionName = "ZHR_PA002_COMMUNICATION_MOD_MY"; //PA002:员工个人信息-Communication修改
				function = null;
				try {
					function = SapConnector_EN.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				if (function == null) {
					System.out.println(functionName + " not found in SAP.");
					System.out.println("SAP_RFC中没有此函数!");
					errorMessage = functionName + " not found in SAP.";
				}
				JCoTable jcotable = function.getTableParameterList().getTable("IT_COMMUNICATION");
				jcotable.appendRow();
				jcotable.setValue("PAKEY_PERNR", oempsapid);
				jcotable.setValue("PAKEY_SUBTY", subtype);
				jcotable.setValue("PAKEY_OBJPS", objtype);
				jcotable.setValue("PAKEY_SPRPS", hrlock);
				jcotable.setValue("PAKEY_BEGDA", osdate);
				jcotable.setValue("PAKEY_ENDDA", oedate);
				jcotable.setValue("PAKEY_SEQNR", seqnr);
				jcotable.setValue("USRID", communication);
				
				try {
					function.execute(SapConnector_EN.getDestination("sanpowersapen"));
					//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}	
		
				//返回值
				//String sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
				//String sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();
				String sapmsg = StringHelper.null2String(jcotable.getValue("MESSAGE").toString());
				String sapmsgtype = jcotable.getValue("MSGTY").toString();
				if ( "I".equals(sapmsgtype) ){
					jsonObject.put("info",sapmsg);
					jsonObject.put("sapflag",sapmsgtype);	
					jsonObject.put("msg","true");
				} else {
					jsonObject.put("info",sapmsg);
					jsonObject.put("sapflag",sapmsgtype);	
					jsonObject.put("msg","false");
				}
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("info",e.getMessage());
				jsonObject.put("sapflag","");
				jsonObject.put("msg","false");				
			}	
		} 		
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
%>