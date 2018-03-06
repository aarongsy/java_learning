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
	String flowno = StringHelper.null2String(request.getParameter("flowno"));//流程单号
	String pzdate = StringHelper.null2String(request.getParameter("pzdate"));//凭证日期
	String jzdate = StringHelper.null2String(request.getParameter("jzdate"));//记账日期

	String pztype = StringHelper.null2String(request.getParameter("pztype"));//凭证类型
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
	String jzdur = StringHelper.null2String(request.getParameter("jzdur"));//过账期间
	String user = StringHelper.null2String(request.getParameter("user"));//用户名
	String cur = StringHelper.null2String(request.getParameter("cur"));//货币代码
	String ref = StringHelper.null2String(request.getParameter("refno"));//凭证参照
	String pztitle = StringHelper.null2String(request.getParameter("pztitle"));//抬头文本

	String arr = StringHelper.null2String(request.getParameter("arr"));//凭证行项目信息

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");


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
	function.getImportParameterList().setValue("HEADER_TXT",pztitle);//抬头文本
	function.getImportParameterList().setValue("USER_NAME",user);//用户名
	function.getImportParameterList().setValue("RUN_MODE","N");//调用模式
	function.getImportParameterList().setValue("REF_DOC_NO",ref);//参考凭证号
	function.getImportParameterList().setValue("NOTESID",flowno);//Notesid


	//建表(凭证行项目)
	JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
	String aa[] = arr.split(",");
	for(int i = 0;i<aa.length;i++)
	{
		String bb[] = aa[i].split(";");
		//System.out.println("传入的字符串为:"+aa[i]);
		//System.out.println("传入的数组的长度为:"+bb.length);
		//System.out.println(bb[7]);
		
		retTable1.appendRow();
		if(bb[0].equals("#"))
		{
			retTable1.setValue("PSTNG_CODE", ""); //记账码
		}
		else
		{
			retTable1.setValue("PSTNG_CODE", bb[0]); //记账码
		}
		if(bb[1].equals("#"))
		{
			retTable1.setValue("GL_ACCOUNT", "");//总账科目
		}
		else
		{
			retTable1.setValue("GL_ACCOUNT", bb[1]);//总账科目
		}

		if(bb[2].equals("#"))
		{
			retTable1.setValue("PAY_DATE", "");//付款基准日期
		}
		else
		{
			 bb[2] =  bb[2].replace("-", "");//凭证日期
			retTable1.setValue("PAY_DATE", bb[2]);//付款基准日期
		}

		if(bb[3].equals("#"))
		{
			retTable1.setValue("MONEY","");//金额
		}
		else
		{
			retTable1.setValue("MONEY", bb[3]);//金额
		}
		if(bb[4].equals("#"))
		{
			retTable1.setValue("ASSGN_NUM","");//分配
		}
		else
		{
			retTable1.setValue("ASSGN_NUM", bb[4]);//分配
		}
		if(bb[5].equals("#"))
		{
			retTable1.setValue("SGL_FLAG","");//SQL标识
		}
		else
		{
			retTable1.setValue("SGL_FLAG", bb[5]);//SQL标识
		}
		if(bb[6].equals("#"))
		{
			retTable1.setValue("PAY_REF","");//付款参考
		}
		else
		{
			retTable1.setValue("PAY_REF", bb[6]);//付款参考
		}
		if(bb[7].equals("#"))
		{
			retTable1.setValue("ITEM_TEXT", "");//文本
		}
		else
		{
			retTable1.setValue("ITEM_TEXT", bb[7]);//文本
		}
		if(bb[8].equals("#"))
		{
			retTable1.setValue("BANK_NAME", ""); //开户银行
		}
		else
		{
			retTable1.setValue("BANK_NAME", bb[8]); //开户银行
		}
		if(bb[9].equals("#"))
		{
			retTable1.setValue("PAY_WAY","");//付款方式
		}
		else
		{
			retTable1.setValue("PAY_WAY", bb[9]);//付款方式
			//System.out.println("333"+bb[9]);
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

	String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
	String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
	String FLAG = function.getExportParameterList().getValue("FLAG").toString();

	String insql = "update uf_tr_billmanage set acdocnum = '"+AC_DOC_NO+"',flag = '"+FLAG+"',msg = '"+ERR_MSG+"' where requestid = '"+requestid+"'";
	baseJdbc.update(insql);
	JSONObject jo = new JSONObject();		
	jo.put("msg", ERR_MSG);
	jo.put("acdocno", AC_DOC_NO);
	jo.put("flag", FLAG);
	//System.out.println(AC_DOC_NO);
	//System.out.println(ERR_MSG);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
