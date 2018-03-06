<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
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
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.app.configsap.SapSync"%>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>


<%
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String soldparty = StringHelper.null2String(request.getParameter("soldparty"));//售达方
	String sendparty = StringHelper.null2String(request.getParameter("sendparty"));//送达方
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
	//System.out.println("soldparty:"+soldparty);
	//System.out.println("sendparty:"+sendparty);
	//System.out.println("comcode:"+comcode);
	String delsql="delete from uf_dmsd_cusmaterdes where soldparty='"+soldparty+"' and sendparty='"+sendparty+"' and comcode='"+comcode+"'";
	baseJdbc.update(delsql);

    //创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	//ZOA_SD_CUSTOMER_REMARK
	String functionName = "ZOA_SD_CUSTOMER_REMARK";
	JCoFunction function = null;
	try 
	{
		function = sapConnector.getRfcFunction(functionName);
	} 
	catch (Exception e) 
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段至SAP(作为查询条件)
	function.getImportParameterList().setValue("KUNNR",soldparty);//售达方
	function.getImportParameterList().setValue("KUNNR1",sendparty);//送达方
	function.getImportParameterList().setValue("BUKRS",comcode);//公司代码

	try 
	{
		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
	} 
	catch (JCoException e) 
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	} 
	catch (Exception e) 
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	//获取SAP子表返回值
	JCoTable newretTable = function.getTableParameterList().getTable("ZSD_REMARK");
	System.out.println("len:"+newretTable.getNumRows());
	if(newretTable.getNumRows() >0)
	{
			System.out.println("len:"+newretTable.getNumRows());
			for(int i= 0;i<newretTable.getNumRows();i++)
			{
					if(i == 0)
					{
						newretTable.firstRow();//获取返回表格数据中的第一行
					}
					else
					{
						newretTable.nextRow();//获取下一行数据
					}

					String longtxt = newretTable.getString("REMARK");//特殊客户长文本
					//System.out.println("longtxt:"+longtxt);
					//将从SAP中取到的数据插入OA
					String insql="insert into uf_dmsd_cusmaterdes(id,requestid,soldparty,sendparty,comcode,specneeds)values((select sys_guid() from dual),'"+IDGernerator.getUnquieID()+"','"+soldparty+"','"+sendparty+"','"+comcode+"','"+longtxt+"')";
					//System.out.println("insql:"+insql);
					baseJdbc.update(insql);
			}
	}

	JSONObject jo = new JSONObject();		
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
