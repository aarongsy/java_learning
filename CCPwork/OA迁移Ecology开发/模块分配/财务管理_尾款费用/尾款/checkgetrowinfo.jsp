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
			String functionName = "ZOA_MM_PAYMENT01";
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
			System.out.println("*********************************************************"+orderno);
			function.getImportParameterList().setValue("ZTYPE","A");
			
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			//String WKURS = function.getExportParameterList().getValue("NETWR").toString();//税率
			//System.out.println("汇率:"+WKURS);
			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("ZMM_PAY01");
			System.out.println("行数:"+newretTable.getNumRows());
			if(newretTable.getNumRows() >0)
			{
				for(int j = 0;j<newretTable.getNumRows();j++)
				{
					if(j == 0)
					{
						newretTable.firstRow();//获取返回表格数据中的第一行
						String EBELP = newretTable.getString("EBELP");//项次
						System.out.println("EBELP:   "+EBELP);
						String TXZ01 = newretTable.getString("TXZ01");//短文本
						System.out.println("TXZ01:   "+TXZ01);
						String MEINS = newretTable.getString("MEINS");//采购单位

						//String MENGE ="0.000"; //
						String MENGE =newretTable.getString("MENGE");//采购数量

						System.out.println("MENGE:   "+MENGE);
						//String NETPR = newretTable.getString("NETPR").trim().replace(",", "") ;单价
						//System.out.println("单价:"+NETPR);
						String WRBTR = newretTable.getString("WRBTR");//完税金额
					System.out.println("WRBTR:"+WRBTR);
					Float money=Float.parseFloat(MENGE)*Float.parseFloat(WRBTR);//完税金额=价格* 税率
					String moneys=money+"";
					System.out.println("money:   "+moneys);
						String WAERS = newretTable.getString("WAERS");//货币
						String RATPZ =  newretTable.getString("RATPZ");//比例
						System.out.println("RATPZ:   "+RATPZ);
						String ZNETWR = newretTable.getString("ZNETWR");//付款金额
						System.out.println("ZNETWR:   "+ZNETWR);
					Float tmoney=Float.parseFloat(ZNETWR)*Float.parseFloat(RATPZ);//完税金额=价格* 税率
					String tmoneys=tmoney*0.01+"";
					System.out.println("tmoneys:   "+tmoneys);
						//string EBELP = newretTable.getString("ZTERM");//代码
						//System.out.println("WAERS:   "+WAERS);
						//System.out.println("orderno:   "+orderno);
						//更新数据库中对应的行项信息
									//获取信息
						String ZTERM = newretTable.getString("ZTERM");//分期代码	
						System.out.println(ZTERM);
						String upsql1="update uf_fn_acceptconfirm set ='' where requestid='"+requestid+"'";
						//baseJdbc.update(upsql1);
						upsql1="update uf_fn_acceptconfirm set payterm='"+ZTERM+"' where requestid='"+requestid+"'";
						System.out.println(upsql1);
						baseJdbc.update(upsql1);
					   // JSONObject jo = new JSONObject();

						String upsql="delete uf_fn_acceptorder where requestid='"+requestid+"'";
						//System.out.println(upsql);
						baseJdbc.update(upsql);
						upsql = "insert into uf_fn_acceptorder (id,requestid,formnum,rowno,text,ordernuit,ordernum,money,currency,payrate,paytotal) values((select sys_guid() from dual),'"+requestid+"','"+orderno+"',"+EBELP+",'"+TXZ01+"','"+MEINS+"',"+MENGE+",'"+WRBTR+"','"+WAERS+"','"+RATPZ+"','"+ZNETWR+"')";
						System.out.println(upsql);
						baseJdbc.update(upsql);
						String upsql3="select * from uf_fn_acceptorder order by rowno asc";
						System.out.println(upsql3);
						baseJdbc.update(upsql3);

					

					}
					else
					{
						newretTable.nextRow();//获取下一行数据
						String EBELP = newretTable.getString("EBELP");//项次
						String TXZ01 = newretTable.getString("TXZ01");//短文本
						String MEINS = newretTable.getString("MEINS");//采购单位
						String MENGE = newretTable.getString("MENGE");//采购数量
						//NETPR = newretTable.getString("NETPR");//单价
						//NXTRV = newretTable.getString("NXTRV");//税率
						String WRBTR = newretTable.getString("WRBTR");//完税金额
					Float money=Float.parseFloat(MENGE)*Float.parseFloat(WRBTR);//完税金额=价格* 税率
                    String moneys=money+"";
						String WAERS = newretTable.getString("WAERS");//货币
						//ZTERM = newretTable.getString("ZTERM");//代码
						String RATPZ = newretTable.getString("RATPZ");//比例
						String ZNETWR = newretTable.getString("ZNETWR");//付款金额
					Float tmoney=Float.parseFloat(ZNETWR)*Float.parseFloat(RATPZ);//完税金额=价格* 税率
					String tmoneys=tmoney*0.01+"";
					System.out.println("tmoneys:   "+tmoneys);
						String upsql = "insert into uf_fn_acceptorder (id,requestid,formnum,rowno,text,ordernuit,ordernum,money,currency,payrate,paytotal) values((select sys_guid() from dual),'"+requestid+"','"+orderno+"',"+EBELP+",'"+TXZ01+"','"+MEINS+"',"+MENGE+",'"+WRBTR+"','"+WAERS+"','"+RATPZ+"','"+ZNETWR+"')";
						baseJdbc.update(upsql);
						System.out.println(upsql);
						String upsql3="select * from uf_fn_acceptorder order by rowno asc";
						System.out.println(upsql3);
						baseJdbc.update(upsql3);
					}


				}

			}

			JSONObject jo = new JSONObject();		
			//jo.put("LIFNR", ERR_MSG);
			//jo.put("NAME1", AC_DOC_NO);
			//jo.put("BSART", FLAG);
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			//System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();

	}
%>
