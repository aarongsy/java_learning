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
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");


	pzdate = pzdate.replace("-", "");//凭证日期
	jzdate = jzdate.replace("-", "");//记帐日期
	reportday = reportday.replace("-", "");//Text Reporting Date
	
	//创建SAP对象		
	SapConnector sapConnector = new SapConnector();
	//String functionName = "ZOA_FI_CDOC_CREATE";
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
	function.getImportParameterList().setValue("HEADER_TXT",pztitle);//抬头文本
	function.getImportParameterList().setValue("USER_NAME",user);//用户名
	//function.getImportParameterList().setValue("RUN_MODE","N");//调用模式
	function.getImportParameterList().setValue("REF_DOC_NO",ref);//凭证参照
	function.getImportParameterList().setValue("NOTESID",flowno);//Notesid

	
	

	//建表(凭证行项目)
	JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
	String sql = "select sno,subject,money,sjjs,payitem,paydate,payfreeze,paytype,currency,paymoney,taxcaode,costcenter,receiptid,receiptitem,banktype,text1,iskmsupplier from uf_dmsd_exfeeqzpz where requestid = '"+requestid+"' order by sno asc ";
	List list1 = baseJdbc.executeSqlForList(sql);
	if(list1.size()>0)
	{
		//System.out.println("456................................................................................................................................");
		for(int i=0;i<list1.size();i++)
		{
			Map map1 = (Map)list1.get(i);
			String subject = StringHelper.null2String(map1.get("subject"));//总账科目
			String iskmsupplier = StringHelper.null2String(map1.get("iskmsupplier"));//总账科目是否为供应商
			if(iskmsupplier.equals("40285a8d5763da3c0157646db1b4053b"))//NO
			{
				for(int ts=subject.length();ts<10;ts++)
				{
					subject = "0" + subject;//总账科目补足10位
				}
			}
			//临时所用
			/*if(subject.equals("21710101"))
			{
				subject = "0021710101";
			}
			if(subject.equals("55061600"))
			{
				subject = "0055061600";
			}
			if(subject.equals("55063800"))
			{
				subject = "0055063800";
			}*/
			
			String money = StringHelper.null2String(map1.get("money"));//金额
			String sjjs = StringHelper.null2String(map1.get("sjjs"));//税金基数
			String paydate = StringHelper.null2String(map1.get("paydate"));//付款基准日期
			paydate = paydate.replace("-", "");//凭证日期
			String payfreeze = StringHelper.null2String(map1.get("payfreeze"));//付款冻结
			String payitem = StringHelper.null2String(map1.get("payitem"));//付款条款
			String paytype = StringHelper.null2String(map1.get("paytype"));//付款方式
			String paymoney = StringHelper.null2String(map1.get("paymoney"));//实际货币金额
			String taxcaode = StringHelper.null2String(map1.get("taxcaode"));//税码
			String costcenter = StringHelper.null2String(map1.get("costcenter"));//成本中心
			String receiptid = StringHelper.null2String(map1.get("receiptid"));//销售凭证
			
			String receiptitem = StringHelper.null2String(map1.get("receiptitem"));//销售凭证项次
			receiptitem = receiptitem.replaceFirst("^0*", "");//去掉项次开头的0 
			
			String banktype = StringHelper.null2String(map1.get("banktype"));//银行类型
			String text1 = StringHelper.null2String(map1.get("text1"));//文本
			
			String mark = "";//标记
			//临时所用
			/*if(subject.indexOf("DCM")!=-1)
			{
				mark = "K";
			}*/
			
			if(iskmsupplier.equals("40285a8d5763da3c0157646db1b4053a"))//YES
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
			retTable1.setValue("PAY_MONEY", paymoney); //支付货币金额
			retTable1.setValue("TAX_CODE", taxcaode);//税码
			retTable1.setValue("COST_CENTER", costcenter);//成本中心
			retTable1.setValue("SO_NO", receiptid);//销售凭证
			retTable1.setValue("SO_ITEM", receiptitem);//销售凭证项次
			retTable1.setValue("BANK_TYPE", banktype);//合作银行
			retTable1.setValue("ITEM_TEXT", text1);//文本
			retTable1.setValue("MARK", mark);//文本
		}
	}
	
	
	//建表(未清项行项目)
	/*JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_CLEAR");
	sql = "select sno,custsuppcode,custsuppflag,ledgerflag,rmbamount,fiscalyear,clearreceiptitem,clearreceiptid,surplusmoney,cleartext from uf_dmsd_exfeeqzno a  where a.requestid = '"+requestid+"' order by sno asc";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			String custsuppflag = StringHelper.null2String(map.get("custsuppflag"));//客户供应商标识
			String custsuppcode = StringHelper.null2String(map.get("custsuppcode"));//客户/供应商编码
			String ledgerflag = StringHelper.null2String(map.get("ledgerflag"));//特殊总账标识

			String clearreceiptid = StringHelper.null2String(map.get("clearreceiptid"));//需清帐凭证编号
			String fiscalyear = StringHelper.null2String(map.get("fiscalyear"));//会计年度
			String clearreceiptitem = StringHelper.null2String(map.get("clearreceiptitem"));//需清帐凭证项次
			String surplusmoney = StringHelper.null2String(map.get("surplusmoney"));//清帐剩余金额
			String cleartext = StringHelper.null2String(map.get("cleartext"));//清帐文本

			retTable.appendRow();
			retTable.setValue("VC_FLAG", custsuppflag); //客户供应商标识
			retTable.setValue("VC_NO", custsuppcode);//客户/供应商编码
			retTable.setValue("SGL_FLAG", "");//特殊总账标识
			retTable.setValue("DOC_NO", clearreceiptid);//需清帐凭证编号
			retTable.setValue("DOC_YEAR", fiscalyear);//会计年度
			retTable.setValue("DOC_ITEM", clearreceiptitem);//需清帐凭证项次
			retTable.setValue("CL_MONEY", surplusmoney);//清帐剩余金额
			retTable.setValue("CL_TEXT", cleartext);//清帐文本
		}
	}*/
	
	
	
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
	
	String upsql="update uf_dmsd_exfeeqz set receiptid='"+AC_DOC_NO+"',succflag='"+FLAG+"',errorid='"+ERR_MSG+"' where requestid='"+requestid+"'";
	baseJdbc.update(upsql);
	JSONObject jo = new JSONObject();		
	jo.put("msg", ERR_MSG);
	jo.put("acdocno", AC_DOC_NO);
	jo.put("flag", FLAG);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
