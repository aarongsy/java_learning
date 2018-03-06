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

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	String  form = "";
	if (action.equals("getData")){
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
		String orderno = StringHelper.null2String(request.getParameter("orderno"));//公司代码
		//String igntypeid = StringHelper.null2String(request.getParameter("igntypeid"));//保证票种类ID
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

		String delsql = "delete uf_yz_engindetail where requestid = '"+requestid+"'";
		baseJdbc.update(delsql);//将工程类验收明细表中的数据删除
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_MM_MSEG_READ";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		function.getImportParameterList().setValue("P_MBLNR","orderno");
		//建表
		//JCoTable retTable = function.getTableParameterList().getTable("Z_PO_DOWN");

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
		System.out.println(ERR_MSG);
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		//抓取抛SAP的返回值
		JCoTable newretTable = function.getTableParameterList().getTable("Z_PO_DOWN");
			
			
		if(FLAG.equals("X"))
		{
			newretTable.firstRow();//获取返回表格数据中的第一行
			String EBELN = newretTable.getString("EBELN");//采购订单号
			String EBELP = newretTable.getString("EBELP");//采购订单行项次
			String TXZ01 = newretTable.getString("TXZ01");//短文本
			String MATNR = newretTable.getString("MATNR");//物料号
			String BSART = newretTable.getString("BSART");//请购单位
			String BAMNG = newretTable.getString("BAMNG");//请购数量
			String MEINS = newretTable.getString("MEINS");//采购单位
			String MENGE = newretTable.getString("MENGE");//采购数量
			String ERFMG = newretTable.getString("ERFMG");//验收数量


			String insql = "insert into uf_yz_engindetail(orderno,orderrow,ordertxt,materno,needdept,neednum,purchdept,purchnum,acceptnum,requestid,id,no)";
			insql = insql +"values('"+EBELN+"','"+EBELP+"','"+TXZ01+"','"+MATNR+"','"+BSART+"','"+BAMNG+"','"+MEINS+"','"+MENGE+"','"+ERFMG+"','"+requestid+"','"+IDGernerator.getUnquieID()+"',max(no)+1)";
			System.out.println(insql);
			baseJdbc.update(insql);
			while(!newretTable.isLastRow())
			{//如果不是最后一行
				newretTable.nextRow();
				if(!newretTable.isLastRow())
				{
					EBELN = newretTable.getString("EBELN");//采购订单号
					EBELP = newretTable.getString("EBELP");//采购订单行项次
					TXZ01 = newretTable.getString("TXZ01");//短文本
					MATNR = newretTable.getString("MATNR");//物料号
					BSART = newretTable.getString("BSART");//请购单位
					BAMNG = newretTable.getString("BAMNG");//请购数量
					MEINS = newretTable.getString("MEINS");//采购单位
					MENGE = newretTable.getString("MENGE");//采购数量
					ERFMG = newretTable.getString("ERFMG");//验收数量
					insql = "insert into uf_yz_engindetail(orderno,orderrow,ordertxt,materno,needdept,neednum,purchdept,purchnum,acceptnum,requestid,id,no)";
					insql = insql +"values('"+EBELN+"','"+EBELP+"','"+TXZ01+"','"+MATNR+"','"+BSART+"','"+BAMNG+"','"+MEINS+"','"+MENGE+"','"+ERFMG+"','"+requestid+"','"+IDGernerator.getUnquieID()+"',max(no)+1)";
					baseJdbc.update(insql);
				}
			}
		}
		JSONObject jo = new JSONObject();	
		jo.put("msg", ERR_MSG);
		jo.put("flag", FLAG);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		//System.out.println(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}

%>
