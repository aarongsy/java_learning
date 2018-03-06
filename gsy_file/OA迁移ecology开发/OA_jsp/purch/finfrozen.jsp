<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.sap.conn.jco.JCoStructure" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	String requestid=StringHepler.null2String(request.getParameter("requestid"));
	String tmpflower=StringHelper.null2String(request.getParameter("tmpflower"));//采购抱怨编号
	String tmpsuocode=StringHelper.null2String(request.getParameter("tmpsuocode"));//供应商简码
	String tmpscene=StringHelper.null2String(request.getParameter("tmpscene"));//现场端
	String tmpfinan=StringHelper.null2String(request.getParameter("tmpfinan"));//财务端
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String scenemark=" ";//初始化现场端上传标识
	String finanmark=" ";//初始化财务端上传标识

	if(tmpscene.equals("40285a8d4fbaabf8014fbf03219615cc"))
	{
		scenemark="X";
	}
	if(tmpfinan.equals("40285a8d4fbaabf8014fbf03219615cc"))
	{
		finanmark="X";
	}

	if(!tmpfinan.equals(""))
	{
		if(tmpfinan.equals("40285a8d4fbaabf8014fbf03219615cd"))
		{
		  SapConnector sapConnector = new SapConnector();
		  String functionName = "ZOA_MM_COMPLAIN_IN";//抱怨写入(执行财务端冻结操作)
		  JCoFunction function = null;
		  try
		  {
			 function = SapConnector.getRfcFunction(functionName);
			 //插入字段
			 function.getImportParameterList().setValue("KEY_IN",tmpflower);
			 function.getImportParameterList().setValue("ZLIFNR",tmpsuocode);
			 function.getImportParameterList().setValue("ZFLAG1","X");//财务端
			 function.getImportParameterList().setValue("ZFLAG2",scenemark);//现场端
			 try
			 {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			 }
			 catch(JCoException e)
			 {
				// TODO Auto-generated catch block
				e.printStackTrace();
			 }
			 catch(Exception e )
			 {
				// TODO Auto-generated catch block
				e.printStackTrace();
			 }
			 //抓取抛SAP的返回值
			String backmark = function.getExportParameterList().getValue("RETURN").toString();
			String message = function.getExportParameterList().getValue("MESSAGE").toString();
			if(!backmark.equals(""))
			{
				if(backmark.equals("S"))//成功
				{
					//更新数据库
					String sql="update uf_oa_purcomplain set finanfrozen='40285a8d4fbaabf8014fbf03219615cc' where requestid='"+requestid+"'";
					baseJdbc.update(sql);//执行SQL
				}
				else{}//失败
			}
		  }
		  catch(JCoException e)
		  {
			 e.printStackTrace();
		  }
		  catch(Exception e)
		  {
			 e.printStackTrace();
		  }
		}
	}
	JSONObject jo = new JSONObject();		
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
