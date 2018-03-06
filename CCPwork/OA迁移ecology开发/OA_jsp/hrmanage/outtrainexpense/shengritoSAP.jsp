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



		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select xzjsmonth,salaryno from uf_hr_birthdaycash  where requestid='"+requestid+"'";
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
			 month = StringHelper.null2String(map.get("xzjsmonth"));
			 salarymenu = StringHelper.null2String(map.get("salaryno"));
			



			month = month.replace("-", "");//薪资月
			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZHR_IT0015_M1_CREATE";//ZHR_IT0015_M2_CREATE
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			//function.getImportParameterList().setValue("LGART","7030");

			function.getImportParameterList().setValue("MONTH",month);//薪资月
			function.getImportParameterList().setValue("LGART",salarymenu);//薪资项
			

			


			//建表
			JCoTable retTable = function.getTableParameterList().getTable("IT0015");
			getsql =  "select a.sapids,a.currencycode,a.money,b.msgty from uf_hr_birthdaycashsub a left join uf_hr_sapinfo b on a.requestid=b.requestid and a.sapids=b.sapid where a.requestid = '"+requestid+"' ";
			 getlist = baseJdbc.executeSqlForList(getsql);
			 System.out.println(getlist.size());
			if(getlist.size()>0){
				for(int i=0;i<getlist.size();i++){
					getmap = (Map)getlist.get(i);
					String sapid = StringHelper.null2String(getmap.get("sapids"));
					String Money = StringHelper.null2String(getmap.get("money"));
					String currencycode = StringHelper.null2String(getmap.get("currencycode"));
					String msgty = StringHelper.null2String(getmap.get("msgty"));
					if(msgty.equals("")||msgty.equals("E"))
					{
						retTable.appendRow();
						retTable.setValue("WAERS", currencycode);//总账科目
						retTable.setValue("PERNR", sapid); //记帐码
						retTable.setValue("BETRG", Money);//总账科目
					}
					
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
			String qsql="select * from uf_hr_sapinfo where requestid='"+requestid+"' and sapid='"+PERNR+"'";
			List qlist = baseJdbc.executeSqlForList(qsql);
			String upsql="";
			if(qlist.size()>0)
			{
				 upsql = "update uf_hr_sapinfo set msgtx='"+MSGTX+"',msgty='"+MSGTY+"' where requestid='"+requestid+"' and sapid='"+PERNR+"'";   
				baseJdbc.update(upsql);
				System.out.println(upsql);
			}
			else
			{
				upsql = "insert into uf_hr_sapinfo(id,requestid,msgtx,msgty,sapid)values((select sys_guid() from dual),'"+requestid+"','"+MSGTX+"','"+MSGTY+"','"+PERNR+"') ";   
				baseJdbc.update(upsql);
				System.out.println(upsql);
			}
			
			do{
				newretTable.nextRow();//获取下一行数据
				 PERNR = newretTable.getString("PERNR");
				 MSGTX = newretTable.getString("MSGTX");
				 MSGTY = newretTable.getString("MSGTY");
				 qsql="select * from uf_hr_sapinfo where requestid='"+requestid+"' and sapid='"+PERNR+"'";
				 qlist = baseJdbc.executeSqlForList(qsql);
				if(qlist.size()>0)
				{
					 upsql = "update uf_hr_sapinfo set msgtx='"+MSGTX+"',msgty='"+MSGTY+"' where requestid='"+requestid+"' and sapid='"+PERNR+"'";   
					baseJdbc.update(upsql);
					System.out.println(upsql);
				}
				else
				{
					upsql = "insert into uf_hr_sapinfo(id,requestid,msgtx,msgty,sapid)values((select sys_guid() from dual),'"+requestid+"','"+MSGTX+"','"+MSGTY+"','"+PERNR+"') ";   
					baseJdbc.update(upsql);
					System.out.println(upsql);
				}

			}while(!newretTable.isLastRow());//如果不是最后一行
			JSONObject jo = new JSONObject();		

			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		

		}

%>
