<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String orderno = "";//销售单号
	String item = "";//订单项次
	String isvalid = "";//是否有效
	String status;


	//System.out.println("yyyyyyy!");
	String sql="select a.salno,a.num,b.isvalid from uf_dmsd_deldetail a left join uf_dmsd_delnotes b on a.requestid=b.requestid left join requestbase req on b.requestid=req.id where area='40285a8d56d542730156e9932c4d32e4' and req.isdelete=0 and isvalid='40288098276fc2120127704884290211' group by a.salno,a.num,b.isvalid";
	List list = baseJdbc.executeSqlForList(sql);
	System.out.println("list.size():"+list.size());
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			orderno=StringHelper.null2String(map.get("salno"));
			item=StringHelper.null2String(map.get("num"));
			status="";
			System.out.println("orderno:"+orderno);
			System.out.println("item:"+item);
			System.out.println("status:"+status);

			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_SD_STATUS";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			//字段插入SAP
			function.getImportParameterList().setValue("VBELN",orderno);//销售单号
			function.getImportParameterList().setValue("POSNR",item);//项次
			function.getImportParameterList().setValue("STATUS",status);//状态

			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}

	//返回值
	//System.out.println("xxxxxxxx!");
	JSONObject jo = new JSONObject();		
	jo.put("res", "true");

	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
