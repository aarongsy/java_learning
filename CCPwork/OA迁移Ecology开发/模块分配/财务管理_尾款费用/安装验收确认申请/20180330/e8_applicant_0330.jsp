<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.interfaces.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="net.sf.json.JSONArray"%>

<%@page import="com.sap.mw.jco.IFunctionTemplate"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%@page
        import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>

<%
    BaseBean log = new BaseBean();
	String ponos = request.getParameter("ponos");
	String path = request.getParameter("");
	JCO.Client sapconnection = null;
	try 
	{	
			SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
			sapconnection = (JCO.Client) sapidsi.getConnection(sources, new LogInfo());
			rs2.writeLog("2018_03_30!!!!!!!!!!!!!!!创建SAP连接");
			String strFunc = "ZOA_MM_PO_INFO";
				
			JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
			IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
			JCO.Function function = ft.getFunction();	
			
			log.writeLog("采购订单号"+ponos);
			
			String sources ="1";
		
			function.getImportParameterList().setValue(ponoses[i],"EBELN");
				
			sapconnection.execute(function);
			rs1.writeLog("2018_03_29!!!!!!!!!!!执行function获取sap数据");
			
			String re1=function.getExportParameterList().getValue("LIFNR").toString();
			String re2=function.getExportParameterList().getValue("NAME1").toString();
			String re3=function.getExportParameterList().getValue("BSART").toString();
			String re4=function.getExportParameterList().getValue("ZTERM").toString();
			
			log.writeLog("***************");
			
			JSONObject jo = new JSONObject();
			jo.put("re1",re1);
			jo.put("re2",re2);
			jo.put("re3",re3);
			jo.put("re4",re4);
			
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
				
		}catch (Exception e){
			//todo
			
			e.printStackTrace();
		}
%>
   
