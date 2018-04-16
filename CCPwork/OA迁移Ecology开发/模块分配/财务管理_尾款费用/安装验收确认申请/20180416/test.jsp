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
<%@page import="com.sap.mw.jco.*"%>
<%@page
        import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>

<%	
    String ponos = request.getParameter("ponos");
    String path = request.getParameter("");
    JCO.Client sapconnection = null;
    try {
		RecordSet rs = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
        String sources = "1";
        String outcall = "";
        rs1.writeLog("++++++++++++++++++++++++++++++");
		
	    SAPInterationDateSourceImpl sapidsi = new  SAPInterationDateSourceImpl();
	   
	    sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
	    rs1.writeLog("20180416__________创建SAP连接");
        out.write("20180416________________suceess："+"\r\n" + outcall);
        String strFunc="ZOA_MM_PO_INFO";
		JCO.Repository myRepository = new JCO.Repository("Repository",sapconnection);
		IFunctionTemplate ft=myRepository.getFunctionTemplate(strFunc.toUpperCase());
		JCO.Function function = ft.getFunction();
		
		function.getImportParameterList().setValue("EBELN");
		//JCO.Table inTableParams=function.getTableParameterList().getTable("MM_PO_ITEMS");
		//inTableParams.appendRow();
		//inTableParams.setValue(ponos,"EBELN");
		//sapconnection.execute(function);
		out.write("执行function获取sap数据\r\n");
		sapconnection.execute(function);
		JCO.Table output = function.getTableParameterList().getTable("MM_PO_ITEMS");
		out.write("output rows:"+"["+output.getNumRows()+"]"+"\r\n");
		for (int k=0;k<output.getNumRows();k++){
			output.setRow(k);
			out.write("明细表数据:{"+Util.null2String(output.getString("TXZ01"))+"|"+Util.null2String(output.getString("MENGE"))+"}");
			
		}
		
		
		
        rs1.writeLog(outcall);
        out.write("20180416________________suceess：" + outcall);
		out.write("\r\n");
		out.write("getAttributes\r\n"+sapconnection.getAttributes());
    } catch (Exception e) {
        // TODO: handle exception
        out.write("20180416_______________fail" + e);
        e.printStackTrace();

    }

%>