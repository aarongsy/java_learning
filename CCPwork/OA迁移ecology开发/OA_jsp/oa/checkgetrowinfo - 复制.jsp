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
	if (action.equals("getData")){
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String orderno=StringHelper.null2String(request.getParameter("orderno")); 
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");


			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_MM_PO_INFO";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			//function.getImportParameterList().setValue("LGART","7030");

			function.getImportParameterList().setValue("EBELN",orderno);//订单号
			
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String WKURS = function.getExportParameterList().getValue("WKURS").toString();//税率
			//System.out.println("汇率:"+WKURS);
			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("MM_PO_ITEMS");
			//System.out.println(newretTable.getNumRows());
			newretTable.firstRow();//获取返回表格数据中的第一行
			String EBELP = newretTable.getString("EBELP");//项次
			//System.out.println("EBELP:   "+EBELP);
			String TXZ01 = newretTable.getString("TXZ01");//短文本
			//System.out.println("TXZ01:   "+TXZ01);
			String MEINS = newretTable.getString("MEINS");//采购单位
			//System.out.println("MEINS:   "+MEINS);
			String MENGE = newretTable.getString("MENGE");//采购数量
			//System.out.println("MENGE:   "+MENGE);
			String NETPR = newretTable.getString("NETPR").trim().replace(",", "") ;//单价
			//System.out.println("单价:"+NETPR);
			//String NXTRV = newretTable.getString("NXTRV");//税率
			//System.out.println("WKURS:"+WKURS);
			float money=Float.valueOf(NETPR)*Float.valueOf(WKURS);//完税金额=价格* 税率

			//System.out.println("money:   "+money);
			String WAERS = newretTable.getString("WAERS");//货币
			//System.out.println("WAERS:   "+WAERS);
			//System.out.println("orderno:   "+orderno);
			//更新数据库中对应的行项信息
			String upsql="delete uf_fn_acceptorder where requestid='"+requestid+"'";
			//System.out.println(upsql);
			baseJdbc.update(upsql);
			upsql = "insert into uf_fn_acceptorder (id,requestid,formnum,rowno,text,ordernuit,ordernum,money,currency,payrate,paytotal) values((select sys_guid() from dual),'"+requestid+"','"+orderno+"',"+EBELP+",'"+TXZ01+"','"+MEINS+"',"+MENGE+","+money+",'"+WAERS+"',0,0)";
			//System.out.println(upsql);
			baseJdbc.update(upsql);
			//System.out.println(orderno);
			do{
				newretTable.nextRow();//获取下一行数据
				EBELP = newretTable.getString("EBELP");//项次
				TXZ01 = newretTable.getString("TXZ01");//短文本
				MEINS = newretTable.getString("MEINS");//采购单位
				MENGE = newretTable.getString("MENGE");//采购数量
				NETPR = newretTable.getString("NETPR");//单价
				//NXTRV = newretTable.getString("NXTRV");//税率
				money=Float.parseFloat(NETPR)*Float.parseFloat(WKURS);//完税金额=价格* 税率
				WAERS = newretTable.getString("WAERS");//货币
				upsql = "insert into uf_fn_acceptorder (id,requestid,formnum,rowno,text,ordernuit,ordernum,money,currency,payrate,paytotal) values((select sys_guid() from dual),'"+requestid+"','"+orderno+"',"+EBELP+",'"+TXZ01+"','"+MEINS+"',"+MENGE+","+money+",'"+WAERS+"',0,0)";
				baseJdbc.update(upsql);
			}while(!newretTable.isLastRow());//如果不是最后一行
		
			JSONObject jo = new JSONObject();		
			//jo.put("msg", ERR_MSG);
			//jo.put("acdocno", AC_DOC_NO);
			//jo.put("flag", FLAG);
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			//System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();

	}
%>
