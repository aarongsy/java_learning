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
		String sql = "select tomonth from uf_hr_dormmoney where requestid='"+requestid+"'";
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String theMonth = StringHelper.null2String(map.get("tomonth"));//生效月份
		theMonth = theMonth.replace("-", "");
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT0015_M1_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("LGART","7030");
		function.getImportParameterList().setValue("MONTH",theMonth);
		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT0015");
		sql = "select sapid,total from uf_hr_dormmoneysub where requestid='"+requestid+"' and (msgty='E' or msgty is null) order by sapid";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map m = (Map)list.get(i);
				String sapid = StringHelper.null2String(m.get("sapid"));
				String total = StringHelper.null2String(m.get("total"));
				retTable.appendRow();
				retTable.setValue("PERNR", sapid);
				retTable.setValue("BETRG", total);
				retTable.setValue("WAERS", "RMB");
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
		//返回值
		//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("MESSAGE");
			System.out.println(newretTable.getNumRows());
			newretTable.firstRow();//获取返回表格数据中的第一行
			String PERNR = newretTable.getString("PERNR");
			String MSGTX = newretTable.getString("MSGTX");
			String MSGTY = newretTable.getString("MSGTY");
			//更新数据库中对应的行项信息
			String upsql = "update uf_hr_dormmoneysub   set msgtx='"+MSGTX+"',msgty='"+MSGTY+"' where requestid='"+requestid+"' and sapid='"+PERNR+"'";   
			baseJdbc.update(upsql);
			System.out.println(upsql);
			do{
				newretTable.nextRow();//获取下一行数据
				 PERNR = newretTable.getString("PERNR");
				 MSGTX = newretTable.getString("MSGTX");
				 MSGTY = newretTable.getString("MSGTY");
				 upsql = "update uf_hr_dormmoneysub   set msgtx='"+MSGTX+"',msgty='"+MSGTY+"' where requestid='"+requestid+"' and sapid='"+PERNR+"'";   
				baseJdbc.update(upsql);
				System.out.println(upsql);
			}while(!newretTable.isLastRow());//如果不是最后一行
				

		//String upsql="update uf_hr_dormmoney set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where requestid='"+requestid+"'";
		//baseJdbc.update(upsql);
	}

%>
