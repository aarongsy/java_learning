<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>


<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
 
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		//创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZHR_IT2003_CREATE";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段

	//建表
	JCoTable retTable = function.getTableParameterList().getTable("IT2003");
	String sql = "select olddate,(select classno from uf_hr_classinfo where requestid =a.newno) as classnum,(select exttextfield15 from humres where id = a.objname) as objno from uf_hr_alterclasssub a  where requestid='"+requestid+"' order by olddate asc ";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		for(int i=0;i<list.size();i++){
			Map m = (Map)list.get(i);
			String olddate = StringHelper.null2String(m.get("olddate"));
			String classnum = StringHelper.null2String(m.get("classnum"));
			String objno = StringHelper.null2String(m.get("objno"));

			retTable.appendRow();
			retTable.setValue("BEGDA", olddate); //日期
			retTable.setValue("VTART", "01");//类型
			retTable.setValue("PERNR", objno);//员工编号
			retTable.setValue("TPROG", classnum);//班别
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

	String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
	String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();

		
	JSONObject jo = new JSONObject();		
	jo.put("MESSAGE", MESSAGE);
	jo.put("MSGTY", MSGTY);
	
	System.out.println(MESSAGE);
	System.out.println(MSGTY);

	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
