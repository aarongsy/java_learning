<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%@page
        import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>

<%
	String ponos = request.getParameter("ponos");//fieldXXX
	String path = request.getParameter("");
	JCO.Client sapconnection = null;
	try 
	{
		String pono = "" ;//采购订单号
		String poitem = "";//采购订单项次
		String gyscode = "";//供应商代码
		String gysname = "";/供应商名称
		String bsart="";
		String zterm="";
		String workflowId ="981";
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		String sources ="";
		if (!workflowId.equals("")){
			rs2.executeSql("select SAPSource from workflow_base where id=" + workflowId);
			if (rs2.next()){
				sources = rs2.getString(1);
			}
		}
		rs2.writeLog("sources="+sources);
			
		SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
		sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
		rs2.writeLog("2018_03_29!!!!!!!!!!!!!!!创建SAP连接");
		System.out.println("*******************");
		String strFunc = "ZOA_MM_PO_INFO";
			
		String outcall ="";
		String[] ponoses=ponos.split(",");
		int index = 0;
		rs1.writeLog("2018_03_29!!!!!!!!!!!length:" + ponoses.length);
		for(int i = 0; i < ponoses.length; i++){
			rs1.writeLog(ponoses[i]);
			JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
			IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
			JCO.Function function = ft.getFunction();				function.getImportParameterList().setValue("DOWN","FLAG");
			JCO.Table inTableParams = function.getTableParameterList().getTable("IT_HEAD_DOWN");
			inTableParams.appendRow();
			inTableParams.setValue(ponoses[i],"EBELN");
				
			sapconnection.execute(function);
			rs1.writeLog("2018_03_29!!!!!!!!!!!执行function获取sap数据");				
			JCO.Table output = function.getTableParameterList().getTable("IT_ITEM_DOWN");
				
			for (int k=0;k<output.getNumRows();k++){
					output.setRow(k);
					index++;
					rs2.writeLog("index="+index);
					
					
					outcall +="![]";
					outcall += Util.null2String(output.getString("LIFNR")) + "|";
					outcall += Util.null2String(output.getString("NAME1")) + "|";
					outcall += Util.null2String(output.getString("BSART")) + "|";
					outcall += Util.null2String(output.getString("ZTERM")) + "|";
					
					rs2.writeLog(outcall);
				}
			}
			rs1.writeLog(outcall);
			out.write("2018_03_29!!!!!!!!!!!success: " + outcall);
		}catch (Exception e){
			//todo
			out.write("2018_03_29?????????fail"+e);
			e.printStackTrace();
		}
%>
   
