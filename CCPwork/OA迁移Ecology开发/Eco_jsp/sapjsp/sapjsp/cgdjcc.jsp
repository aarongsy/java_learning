<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.interfaces.sap.SAPConn"%>
<%@page import="weaver.soa.workflow.request.RequestInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%@page import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>
<%@page import="com.weaver.integration.log.LogInfo"%>

<% 

String YSDDH=request.getParameter("YSDDH");
String workflowId = request.getParameter("workflowId");


JCO.Client sapconnection = null;
BaseBean log = new BaseBean();
log.writeLog("调用ZRFC_GTKPSQ_INFO开始");

RecordSet rs = new RecordSet();

String sources = "";
if(!workflowId.equals("")){
	rs.executeSql("select SAPSource from workflow_base where id="+workflowId);
	if(rs.next()) sources = rs.getString(1);
  }
  log.writeLog("sources="+sources);
				
	SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
	sapconnection = (JCO.Client)sapidsi.getConnection(sources, new LogInfo());
	log.writeLog("创建SAP连接");	
	String strFunc = "Z_CCP_PO_DG";
	JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
	IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
	JCO.Function function = ft.getFunction();
				
  function.getImportParameterList().setValue("DOWN","FLAG");
  JCO.Table tDateRange = function.getTableParameterList().getTable("IT_HEAD_DOWN");

tDateRange.appendRow(); 
tDateRange.setValue(YSDDH,"EBELN");
tDateRange.setValue(YSDDH,"EBELT");
tDateRange.setValue("1010","WERKS");

				
	sapconnection.execute(function);
	log.writeLog("Z_CCP_PO_DG");
				
	JCO.ParameterList output = 	function.getExportParameterList();	

	
	JCO.Table productTable1= function.getTableParameterList().getTable("IT_ZUJIAN_DOWN");
	
	JCO.Table productTable= function.getTableParameterList().getTable("IT_ITEM_DOWN");
	
	String callout="";
	
	 out.println(productTable.getNumRows());

	 if(productTable.getNumRows()>0){
		 for(int i=0;i<productTable.getNumRows();i++){
             productTable.setRow(i);
			 callout+="![]";
			 callout+=productTable.getString("BUKRS")+"!^!";
			 callout+=productTable.getString("EKORG")+"!^!";
			 callout+=productTable.getString("EBELN")+"!^!";
			 callout+=productTable.getString("EBELP")+"!^!";

		 }	 
	 }
	 out.print(callout+"--"+productTable);
%>