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
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
	//	String  num= StringHelper.null2String(request.getParameter("num"));//次数


		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select month,salarymenu from uf_hr_festivalcash  where requestid='"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		String month="";
		String salarymenu="";
		String getsql = "";
		List getlist;
		Map getmap;
		//String sapid = "";
		//String Money="";
		if(list.size()>0){
			 map = (Map)list.get(0);
			 month = StringHelper.null2String(map.get("month"));
			 salarymenu = StringHelper.null2String(map.get("salarymenu"));
			



			month = month.replace("-", "");//凭证日期
			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZHR_IT0015_M2_CREATE";//ZHR_IT0015_M2_CREATE
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			//function.getImportParameterList().setValue("LGART","7030");

			function.getImportParameterList().setValue("MONTH",month);//凭证日期
			function.getImportParameterList().setValue("LGART",salarymenu);//记帐日期
			

			


			//建表
			JCoTable retTable = function.getTableParameterList().getTable("IT0015");
			getsql =  "select sapid,Money from uf_hr_festivalcashsub  where requestid = '"+requestid+"' and no>1300 and no<=2000 and  money >0";
			//记帐码，总账科目，金额，税码,成本中心，内部订单号，付款条件，付款日期，付款方式，银行，文本
			 getlist = baseJdbc.executeSqlForList(getsql);
			 System.out.println(getsql);
			if(getlist.size()>0){
				for(int i=0;i<getlist.size();i++){
					 getmap = (Map)getlist.get(i);
					 String sapid = StringHelper.null2String(getmap.get("sapid"));
					 String Money = StringHelper.null2String(getmap.get("Money"));

					retTable.appendRow();
					retTable.setValue("WAERS", "RMB");//总账科目
					retTable.setValue("PERNR", sapid); //记帐码
					retTable.setValue("BETRG", Money);//总账科目



				}
			}
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			

			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("MESSAGE");
			System.out.println(newretTable.getNumRows());
			newretTable.firstRow();//获取返回表格数据中的第一行
			String PERNR = newretTable.getString("PERNR");
			String MSGTX = newretTable.getString("MSGTX");
			String MSGTY = newretTable.getString("MSGTY");
			//更新数据库中对应的行项信息
			String upsql = "insert into uf_hr_festivalsapinfo (ID, REQUESTID,  sapid, msgtx, msgty)  values ((select sys_guid() from dual), '"+requestid+"','"+PERNR+"','"+MSGTX+"','"+MSGTY+"')";   
			baseJdbc.update(upsql);
			System.out.println(upsql);
			do{
				newretTable.nextRow();//获取下一行数据
				 PERNR = newretTable.getString("PERNR");
				 MSGTX = newretTable.getString("MSGTX");
				 MSGTY = newretTable.getString("MSGTY");
				upsql= "insert into uf_hr_festivalsapinfo (ID, REQUESTID,  sapid, msgtx, msgty)  values ((select sys_guid() from dual), '"+requestid+"','"+PERNR+"','"+MSGTX+"','"+MSGTY+"')";  
				baseJdbc.update(upsql);
				System.out.println(upsql);
			}while(!newretTable.isLastRow());//如果不是最后一行
			JSONObject jo = new JSONObject();		

			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		

		}

%>
