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
	String requestid=StringHelper.null2String(request.getParameter("requestid"));//requestid
	String k2form=StringHelper.null2String(request.getParameter("k2form"));//K2 Form
	String cordate=StringHelper.null2String(request.getParameter("cordate"));//Cor Date
	String tmpdate=cordate.replaceAll("-","");

 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select wm_concat(x.deliveryno)deliveryno from uf_dmsd_shipment x left join uf_dmsd_expboxmain y on x.requestid=y.requestid left join requestbase req on y.requestid=req.id where req.isdelete=0 and y.isvalid='40288098276fc2120127704884290210' and y.requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		Map map = (Map)list.get(0);
		String deliveryno = StringHelper.null2String(map.get("deliveryno"));//deliveryno
		//System.out.println("deliveryno:"+deliveryno);
		if(deliveryno.indexOf(",")!=-1)//同一张外销联络单存在多个交运单
		{
			//System.out.println("1..........");
			String [] array1 = deliveryno.split("\\,");
			for(int j=0;j<array1.length;j++)
			{
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZMY_SAVE_COR_K2FORM";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					e.printStackTrace();
				}

				//输入字段
				function.getImportParameterList().setValue("DELIVERYNO",array1[j]);//交运单号
				function.getImportParameterList().setValue("CORDATE",tmpdate);//Cor Date
				function.getImportParameterList().setValue("K2FORM",k2form);//K2 Form

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} 
				catch (JCoException e) {
					e.printStackTrace();
				} 
				catch (Exception e) {
					e.printStackTrace();
				}
				//无SAP返回值
			}
		}
		else
		{
			//System.out.println("2..........");
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZMY_SAVE_COR_K2FORM";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				e.printStackTrace();
			}

			//输入字段
			function.getImportParameterList().setValue("DELIVERYNO",deliveryno);//交运单号
			function.getImportParameterList().setValue("CORDATE",tmpdate);//Cor Date
			function.getImportParameterList().setValue("K2FORM",k2form);//K2 Form

			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} 
			catch (JCoException e) {
				e.printStackTrace();
			} 
			catch (Exception e) {
				e.printStackTrace();
			}
			//获取SAP返回值
		}
	}

	//JSONObject jo = new JSONObject();		
	//jo.put("res", "true");
	//response.setContentType("application/json; charset=utf-8");
	//response.getWriter().write(jo.toString());
	//response.getWriter().flush();
	//response.getWriter().close();
%>
