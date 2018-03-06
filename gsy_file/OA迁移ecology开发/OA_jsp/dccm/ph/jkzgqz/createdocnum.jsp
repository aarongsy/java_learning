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
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String flowno = StringHelper.null2String(request.getParameter("flowno"));//流程单号
	String pzdate = StringHelper.null2String(request.getParameter("pzdate"));//凭证日期
	String jzdate = StringHelper.null2String(request.getParameter("jzdate"));//凭证日期
	String pztype = StringHelper.null2String(request.getParameter("pztype"));//凭证类型
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
	String jzdur = StringHelper.null2String(request.getParameter("jzdur"));//过账期间
	String user = StringHelper.null2String(request.getParameter("user"));//用户名
	String cur = StringHelper.null2String(request.getParameter("cur"));//货币代码
	String payto = StringHelper.null2String(request.getParameter("payto"));//支付对象
	String rate = StringHelper.null2String(request.getParameter("rate"));//汇率
	String pztitle = StringHelper.null2String(request.getParameter("pztitle"));//抬头文本
	String strflag = payto + "-" + cur;//区分上抛凭证信息标识

	pzdate = pzdate.replace("-", "");//凭证日期
	jzdate = jzdate.replace("-", "");//记帐日期

	//创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_FI_DOC_CREATE";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	//插入字段

	function.getImportParameterList().setValue("DOC_DATE",pzdate);//凭证日期
	function.getImportParameterList().setValue("PSTNG_DATE",jzdate);//记帐日期
	function.getImportParameterList().setValue("DOC_TYPE",pztype);//凭证类型
	function.getImportParameterList().setValue("COMP_CODE",comcode);//公司代码
	function.getImportParameterList().setValue("PSTNG_PERIOD",jzdur);//记帐期间
	function.getImportParameterList().setValue("CURRENCY",cur);//货币代码
	function.getImportParameterList().setValue("EXCHNG_RATE",rate);//汇率
	function.getImportParameterList().setValue("HEADER_TXT",pztitle);//抬头文本
	function.getImportParameterList().setValue("USER_NAME",user);//用户名
	function.getImportParameterList().setValue("REF_DOC_NO","");//参考凭证号
	function.getImportParameterList().setValue("NOTESID",flowno);//NotesID
	function.getImportParameterList().setValue("RUN_MODE","N");
	 

	//建表
	JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
	String sql = "select accountcode,subject,estamount,currency,ccenter,purchaseorder,orderlineitem,text from uf_dmph_icdocumentinfo   where requestid='"+requestid+"' and flag='"+strflag+"' ";
	//System.out.println("进口费用暂估会计明细："+sql);
	
	//记帐码，总账科目、税码,暂估金额，暂估币种，成本中心，采购订单号，采购订单行项目，文本
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String accountcode = StringHelper.null2String(map.get("accountcode"));
			String subject = StringHelper.null2String(map.get("subject"));
			String estamount = StringHelper.null2String(map.get("estamount"));
			String estcurrency = StringHelper.null2String(map.get("currency"));
			String costcenter = StringHelper.null2String(map.get("ccenter"));
			String purorder = StringHelper.null2String(map.get("purchaseorder"));
			String purorderitem = StringHelper.null2String(map.get("orderlineitem"));
			String text1 = StringHelper.null2String(map.get("text"));
			
			retTable.appendRow();
			retTable.setValue("PSTNG_CODE", accountcode); //记帐码
			retTable.setValue("GL_ACCOUNT", subject);//总账科目
			retTable.setValue("MONEY", estamount);//金额
			retTable.setValue("COST_CENTER", costcenter);//成本中心
			retTable.setValue("PO_NO", purorder);//内部订单号
			retTable.setValue("PO_ITEM", purorderitem);//内部订单行项次
			retTable.setValue("ITEM_TEXT", text1);//文本
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

	String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
	String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
	String FLAG = function.getExportParameterList().getValue("FLAG").toString();
	System.out.println(AC_DOC_NO);

	JSONObject jo = new JSONObject();		
	jo.put("msg", ERR_MSG);
	jo.put("acdocno", AC_DOC_NO);
	jo.put("flag", FLAG);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
