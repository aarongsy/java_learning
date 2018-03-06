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
//String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select themonth from uf_hr_monthtotal where requestid='"+requestid+"'";
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String theMonth = StringHelper.null2String(map.get("themonth"));//所属薪资月
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
		function.getImportParameterList().setValue("LGART","7020");
		function.getImportParameterList().setValue("MONTH",theMonth);
		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT0015");
		sql = "select sapid,total from uf_hr_monthtotalsub where requestid='"+requestid+"' and (msgty is null or msgty='E')";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			System.out.println("开始手工重抛月度就餐扣款：list.size()=" + list.size() +" sql="+sql);
			for(int i=0;i<list.size();i++){
				Map m = (Map)list.get(i);
				String sapid = StringHelper.null2String(m.get("sapid"));
				String total = StringHelper.null2String(m.get("total"));
				retTable.appendRow();
				retTable.setValue("PERNR", sapid);
				retTable.setValue("BETRG", total);
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
		JCoTable retTable2 = function.getTableParameterList().getTable("MESSAGE");
		System.out.println(retTable2.getNumRows());
		for(int i=0;i<retTable2.getNumRows();i++){
          //System.out.println();
			String rsapid = retTable2.getValue("PERNR").toString();
			String message = retTable2.getValue("MSGTX").toString();
			String msgty = retTable2.getValue("MSGTY").toString();
			String upsql="update uf_hr_monthtotalsub set message='"+message+"',msgty='"+msgty+"' where requestid='"+requestid+"' and sapid='"+rsapid+"'";
			System.out.println(upsql);
          	baseJdbc.update(upsql);
			retTable2.nextRow();
		}		

			JSONObject jo = new JSONObject();		
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			//System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
	
%>
