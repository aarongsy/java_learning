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
	System.out.println("TEST");
	
	if (action.equals("getDa")){
		System.out.println("777");
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String orderno=StringHelper.null2String(request.getParameter("orderno")); 
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");


			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_MM_PAYMENT02";
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
			function.getImportParameterList().setValue("ZTYPE","B");
			
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
			//String WKURS = function.getExportParameterList().getValue("NETWR").toString();//税率
			//System.out.println("汇率:"+WKURS);
			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("ZMM_PAY02");
			System.out.println("line:"+newretTable.getNumRows());
			if(newretTable.getNumRows()>0){
				for(int j = 0;j<newretTable.getNumRows();j++)
				{
					if(j == 0)
					{
			newretTable.firstRow();//获取返回表格数据中的第一行
			String BUKRS = newretTable.getString("BUKRS");//公司代码
			//System.out.println("EBELP:   "+EBELP);
			String BELNR = newretTable.getString("BELNR");//凭证号码
			String GJAHR = newretTable.getString("GJAHR");//年度
			String WRBTR = newretTable.getString("WRBTR");//付款金额
			String PSWSL = newretTable.getString("PSWSL");//凭证货币
            String HKONT = newretTable.getString("HKONT");//科目
			String ZTERM = newretTable.getString("ZTERM");//付款条件
			String ZLSCH = newretTable.getString("ZLSCH");//付款方式
			String ZFBDT = newretTable.getString("ZFBDT");//付款基准日
			String ZLSPR = newretTable.getString("ZLSPR");//冻结付款
			String BVTYP = newretTable.getString("BVTYP");//合作银行
			String SGTXT = newretTable.getString("SGTXT");//文本
			//System.out.println("orderno:   "+orderno);
			//更新数据库中对应的行项信息
			String upsql="delete uf_fn_wkpayinfo  where requestid='"+requestid+"'";
			System.out.println(upsql);
			baseJdbc.update(upsql);
			upsql = "insert into uf_fn_wkpayinfo   (id,requestid,comcode,creditno,finyear,payamt,currency,feeaccount,payterm,paytype,paydate,frozen,bank,text) values((select sys_guid() from dual),'"+requestid+"','"+BUKRS+"','"+BELNR+"','"+GJAHR+"','"+WRBTR+"','"+PSWSL+"','"+HKONT+"','"+ZTERM+"','"+ZLSCH+"','"+ZFBDT+"','"+ZLSPR+"','"+BVTYP+"','"+SGTXT+"')";
			baseJdbc.update(upsql);
			System.out.println(upsql);
			System.out.println(orderno);
					}
			else
			{
				newretTable.nextRow();//获取下一行数据
				//HKNT = newretTable.getString("HKONT");//科目
				String BUKRS = newretTable.getString("BUKRS");//项次
				String BELNR = newretTable.getString("BELNR");//短文本
				String GJAHR = newretTable.getString("GJAHR");//采购单位
				String WRBTR = newretTable.getString("WRBTR");//采购数量
				String PSWSL = newretTable.getString("PSWSL");//单价
				String ZLSCH = newretTable.getString("ZLSCH");//税率
				String HKONT = newretTable.getString("HKONT");//科目
				String ZTERM = newretTable.getString("ZTERM");//付款条件
				//money=Float.parseFloat(NETPR)*Float.parseFloat(WKURS);//完税金额=价格* 税率
				String ZFBDT = newretTable.getString("ZFBDT");//完税金额
				String ZLSPR = newretTable.getString("ZLSPR");//货币
				String BVTYP = newretTable.getString("BVTYP");//货币
				String SGTXT = newretTable.getString("SGTXT");//货币
			String upsql1 = "insert into uf_fn_wkpayinfo   (id,requestid,comcode,creditno,finyear,payamt,currency,feeaccount,payterm,paytype,paydate,frozen,bank,text) values((select sys_guid() from dual),'"+requestid+"','"+BUKRS+"','"+BELNR+"','"+GJAHR+"','"+WRBTR+"','"+PSWSL+"','"+HKONT+"','"+ZTERM+"','"+ZLSCH+"','"+ZFBDT+"','"+ZLSPR+"','"+BVTYP+"','"+SGTXT+"')";
				baseJdbc.update(upsql1);
				//System.out.println("fqwfwefuweuf");
				System.out.println(upsql1);
			}
			/*
			while(newretTable.isLastRow());//如果是最后一行
			{
				//newretTable.nextRow();//获取下一行数据
				//HKNT = newretTable.getString("HKONT");//科目
				BUKRS = newretTable.getString("BUKRS");//项次
				BELNR = newretTable.getString("BELNR");//短文本
				GJAHR = newretTable.getString("GJAHR");//采购单位
				WRBTR = newretTable.getString("WRBTR");//采购数量
				PSWSL = newretTable.getString("PSWSL");//单价
				ZLSCH = newretTable.getString("ZLSCH");//税率
				//money=Float.parseFloat(NETPR)*Float.parseFloat(WKURS);//完税金额=价格* 税率
				ZFBDT = newretTable.getString("ZFBDT");//完税金额
				ZLSPR = newretTable.getString("ZLSPR");//货币
				BVTYP = newretTable.getString("BVTYP");//货币
				SGTXT = newretTable.getString("SGTXT");//货币
			upsql = "insert into uf_fn_wkpayinfo   (id,requestid,comcode,creditno,finyear,payamt,currency,feeaccount,payterm,paytype,paydate,frozen,bank,text) values((select sys_guid() from dual),'"+requestid+"','"+BUKRS+"','"+BELNR+"','"+GJAHR+"','"+WRBTR+"','"+PSWSL+"','"+HKONT+"','"+ZTERM+"','"+ZLSCH+"','"+ZFBDT+"','"+ZLSPR+"','"+BVTYP+"','"+SGTXT+"')";
				baseJdbc.update(upsql);
				//System.out.println("fqwfwefuweuf");
				System.out.println(upsql);
			}*/
					}
			}
			JSONObject jo = new JSONObject();		
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
			

	}
%>




