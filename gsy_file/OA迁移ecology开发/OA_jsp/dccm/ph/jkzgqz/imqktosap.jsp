<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
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
	String pzdate = StringHelper.null2String(request.getParameter("pzdate"));//凭证日期
	String jzdate = StringHelper.null2String(request.getParameter("jzdate"));//记账日期
	String reportday = StringHelper.null2String(request.getParameter("reportday"));//Text Reporting Date
	String pztype = StringHelper.null2String(request.getParameter("pztype"));//凭证类型
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
	String jzdur = StringHelper.null2String(request.getParameter("jzdur"));//过账期间
	String user = StringHelper.null2String(request.getParameter("user"));//用户名
	String cur = StringHelper.null2String(request.getParameter("cur"));//货币代码
	String rate = StringHelper.null2String(request.getParameter("rate"));//汇率
	String ref = StringHelper.null2String(request.getParameter("ref"));//凭证参照
	String pztitle = StringHelper.null2String(request.getParameter("pztitle"));//抬头文本
	String flowno=StringHelper.null2String(request.getParameter("flowno"));//Notesid
	String taxtype = StringHelper.null2String(request.getParameter("taxtype"));//税种
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String flag = "Import-" + taxtype;//区分所抛凭证是Duties还是GST

	pzdate = pzdate.replace("-", "");//凭证日期
	jzdate = jzdate.replace("-", "");//记帐日期
	reportday = reportday.replace("-", "");//Text Reporting Date
	
	//创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_FI_DOC_CREATE_MY";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段
	//System.out.println("123...........................................................................................");
	function.getImportParameterList().setValue("DOC_DATE",pzdate);//凭证日期
	function.getImportParameterList().setValue("PSTNG_DATE",jzdate);//记帐日期
	function.getImportParameterList().setValue("VATDATE",reportday);//Text Reporting Date
	function.getImportParameterList().setValue("DOC_TYPE",pztype);//凭证类型
	function.getImportParameterList().setValue("COMP_CODE",comcode);//公司代码
	function.getImportParameterList().setValue("PSTNG_PERIOD",jzdur);//记帐期间
	function.getImportParameterList().setValue("CURRENCY",cur);//货币代码
	function.getImportParameterList().setValue("EXCHNG_RATE",rate);//汇率
	//System.out.println(rate);
	function.getImportParameterList().setValue("HEADER_TXT",pztitle);//抬头文本
	function.getImportParameterList().setValue("USER_NAME",user);//用户名
	//function.getImportParameterList().setValue("RUN_MODE","N");//调用模式
	function.getImportParameterList().setValue("REF_DOC_NO",ref);//凭证参照
	function.getImportParameterList().setValue("NOTESID",flowno);//Notesid

	
	

	//建表(凭证行项目)
	JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
	String sql = "select serialno,subject,amount,sjjs,payterm,paydate,paydj,payway,curr,taxcode,costcenter,text,qty,unit from uf_dmph_sjpzdet where requestid = '"+requestid+"' and flag='"+flag+"'";
	List list1 = baseJdbc.executeSqlForList(sql);
	if(list1.size()>0)
	{
		//System.out.println("456................................................................................................................................");
		for(int i=0;i<list1.size();i++)
		{
			Map map1 = (Map)list1.get(i);
			String subject = StringHelper.null2String(map1.get("subject"));//总账科目
			if(subject.indexOf("5506")!=-1||subject.indexOf("21710101")!=-1||subject.indexOf("11710020")!=-1||subject.indexOf("21910904")!=-1)
			{
				for(int ts=subject.length();ts<10;ts++)
				{
					subject = "0" + subject;//总账科目补足10位
				}
			}
			else
			{
			}
			//System.out.println("subject:"+subject);
			String money = StringHelper.null2String(map1.get("amount"));//金额
			String sjjs = StringHelper.null2String(map1.get("sjjs"));//税金基数
			String paydate = StringHelper.null2String(map1.get("paydate"));//付款基准日期
			paydate = paydate.replace("-", "");//凭证日期
			String payfreeze = StringHelper.null2String(map1.get("paydj"));//付款冻结
			String payitem = StringHelper.null2String(map1.get("payterm"));//付款条款
			String paytype = StringHelper.null2String(map1.get("payway"));//付款方式
			String taxcode = StringHelper.null2String(map1.get("taxcode"));//税码
			String costcenter = StringHelper.null2String(map1.get("costcenter"));//成本中心
			if(comcode.equals("7010")&&!costcenter.equals(""))
			{
				costcenter=costcenter.substring(2, costcenter.length());
			}
			//String receiptid = StringHelper.null2String(map1.get("receiptid"));//销售凭证
			//String receiptitem = StringHelper.null2String(map1.get("receiptitem"));//销售凭证项次
			//System.out.println("item:"+receiptitem);
			//receiptitem = receiptitem.replaceFirst("^0*", "");//去掉项次开头的0 
			//String banktype = StringHelper.null2String(map1.get("banktype"));//银行类型
			String text1 = StringHelper.null2String(map1.get("text"));//文本
			String qty = StringHelper.null2String(map1.get("qty"));//数量
			String unit = StringHelper.null2String(map1.get("unit"));//单位
			
			String mark = "";//标记
			if(subject.indexOf("21710101")==-1&&subject.indexOf("5506")==-1&&subject.indexOf("11710020")==-1&&subject.indexOf("21910904")==-1)
			{
				mark = "K";
			}
			if(subject.indexOf("21710101")!=-1)
			{
				mark = "T";
			}
			
			retTable1.appendRow();
			retTable1.setValue("GL_ACCOUNT", subject);//总账科目
			retTable1.setValue("MONEY", money);//金额
			retTable1.setValue("TAX_BASE", sjjs);//税金基数
			retTable1.setValue("PAY_TERMS", payitem);//付款条款
			retTable1.setValue("PAY_DATE", paydate);//付款基准日期
			retTable1.setValue("PAY_LOCK", payfreeze);//付款冻结
			retTable1.setValue("PAY_WAY", paytype);//付款方式
			retTable1.setValue("PAY_MONEY", money); //支付货币金额
			retTable1.setValue("TAX_CODE", taxcode);//税码
			retTable1.setValue("COST_CENTER", costcenter);//成本中心
			retTable1.setValue("SO_NO", "");//销售凭证
			retTable1.setValue("SO_ITEM", "");//销售凭证项次
			retTable1.setValue("BANK_TYPE", "");//合作银行
			retTable1.setValue("ITEM_TEXT", text1);//文本
			retTable1.setValue("BASE_UOM", unit);//单位
			retTable1.setValue("QUANTITY", qty);//数量
			retTable1.setValue("MARK", mark);//标识
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
	//System.out.println("ERR_MSG:"+ERR_MSG);
	String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
	//System.out.println("AC_DOC_NO:"+AC_DOC_NO);
	String FLAG = function.getExportParameterList().getValue("FLAG").toString();
	//System.out.println("FLAG:"+FLAG);
	
	JSONObject jo = new JSONObject();		
	jo.put("msg", ERR_MSG);
	jo.put("acdocno", AC_DOC_NO);
	jo.put("flag", FLAG);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
