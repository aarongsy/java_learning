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

	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	//System.oiut.println(requestid);
	String pztitle = StringHelper.null2String(request.getParameter("pztitle"));//凭证抬头
	String gzdate = StringHelper.null2String(request.getParameter("gzdate"));//过账日期
	gzdate = gzdate.replace("-","");
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
	String flowno = StringHelper.null2String(request.getParameter("flowno"));//流程单号
	String fact = StringHelper.null2String(request.getParameter("fact"));//工厂
	String ref = StringHelper.null2String(request.getParameter("ref"));//参照
	String area = StringHelper.null2String(request.getParameter("area"));//厂区别
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//创建SAP对象		
	//System.out.println("测试数据是否正确及合理");
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_MM_DOC_POST";
	if(area.equals("40285a8d54cce9860154f15fccb5627d"))//长龙
	{
		functionName = "ZOA_MM_DOC_POST_CL";
	}
/*	
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段

	function.getImportParameterList().setValue("BKTXT",pztitle);//凭证抬头

	function.getImportParameterList().setValue("BUDAT",gzdate);//过账日期

	function.getImportParameterList().setValue("BUKRS",comcode);//公司代码

	
	function.getImportParameterList().setValue("RUN_MODE","N");//调用方式
	function.getImportParameterList().setValue("WERKS",fact);//工厂
	function.getImportParameterList().setValue("XBLNR",ref);//参照
*/
	String sql = "select sno,materialid,money,notesid,orderno,item from uf_tr_feemareceiptsub where requestid = '"+requestid+"' order by sno asc";
	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{	System.out.println("jkfyqz wlpzh start："+requestid);
		for(int i = 0;i<list.size();i++)
		{
			JCoFunction function = null;
			System.out.println(functionName);
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			function.getImportParameterList().setValue("BKTXT",pztitle);//凭证抬头
			function.getImportParameterList().setValue("BUDAT",gzdate);//过账日期
			function.getImportParameterList().setValue("BUKRS",comcode);//公司代码			
			function.getImportParameterList().setValue("RUN_MODE","N");//调用方式
			function.getImportParameterList().setValue("WERKS",fact);//工厂
			function.getImportParameterList().setValue("XBLNR",ref);//参照	
			
			
			Map map = (Map)list.get(i);
			
			String materialid = StringHelper.null2String(map.get("materialid"));//物料号
			String money = StringHelper.null2String(map.get("money"));//金额
			String sno = StringHelper.null2String(map.get("sno"));//序号
			String notesid = StringHelper.null2String(map.get("notesid"));//NotesID
			String orderno = StringHelper.null2String(map.get("orderno"));//订单
			String item = StringHelper.null2String(map.get("item"));//项次
			System.out.println(notesid);
			function.getImportParameterList().setValue("NOTESID",notesid);//NotesID
			JCoTable retTable = function.getTableParameterList().getTable("MM_DOC_ITEM");//物料凭证表格
			retTable.appendRow();
			retTable.setValue("MATNR",materialid);//物料号
			System.out.println("materialid="+materialid);
			retTable.setValue("ZUUMB",money);//金额
			System.out.println("money="+money);
			if(area.equals("40285a8d54cce9860154f15fccb5627d"))//长龙
			{
				retTable.setValue("EBELN",orderno);//订单
				System.out.println("orderno="+orderno);
				retTable.setValue("EBELP",item);//项次
				System.out.println("item="+item);
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
			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();//错误消息
			System.out.println(ERR_MSG);
			String AC_DOC_NO = function.getExportParameterList().getValue("MBLNR").toString();//凭证号
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();//消息类型
			String insql = "update uf_tr_feemareceiptsub  set sapreceiptid = '"+AC_DOC_NO+"',msgtype='"+FLAG+"',msg='"+ERR_MSG+"' where requestid = '"+requestid+"' and sno = '"+sno+"'";
			System.out.println("lalala"+insql+"lalla");
			baseJdbc.update(insql);
		}
		System.out.println("jkfyqz wlpzh end："+requestid);
	}
	
	//返回值
	sql = "select sno,materialid,money,sapreceiptid from uf_tr_feemareceiptsub where requestid = '"+requestid+"' order by sno asc";
	List list1 = baseJdbc.executeSqlForList(sql);
	JSONArray jsonArray = new JSONArray();
	if(list1.size()>0)
	{
		for(int m = 0;m<list1.size();m++)
		{
			Map map1 = (Map)list1.get(m);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("sno", StringHelper.null2String(map1.get("sno")));//序号
			jsonObject.put("sapreceiptid", StringHelper.null2String(map1.get("sapreceiptid")));//SAP凭证号
			jsonArray.add(jsonObject);
		}
	}	
	JSONObject jo = new JSONObject();		
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jsonArray.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
