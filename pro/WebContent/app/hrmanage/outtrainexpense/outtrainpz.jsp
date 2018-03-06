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
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("getData")){
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		//String requestid = this.requestid;//当前流程requestid 

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select t.pzdate,t.jzdate,t.pztype,t.pzcompcode,t.jzmonth,t.currneycode,t.hl,t.pznumber,t.pztitle,t.username from uf_hr_outtrainexpenses t where t.requestid='"+requestid+"'";
		//凭证日期，记帐日期，凭证类型，公司代码，币种，汇率，预付凭证号，凭证抬头文本，记帐期间，用户名
		List tlist = baseJdbc.executeSqlForList(sql);
		String getsql = "";
		List getlist;
		Map getmap;
		if(tlist.size()>0){
			Map map = (Map)tlist.get(0);
			String pzdate = StringHelper.null2String(map.get("pzdate"));//凭证日期
			
			String jzdate = StringHelper.null2String(map.get("jzdate"));//记帐日期
			String pztype = StringHelper.null2String(map.get("pztype"));//凭证类型

			String companycode = StringHelper.null2String(map.get("pzcompcode"));//公司代码
			String currencycode = StringHelper.null2String(map.get("currneycode"));//币种
			getsql = "select currencycode from uf_oa_currencymaintain where requestid = '"+currencycode+"'";
			getlist = baseJdbc.executeSqlForList(getsql);
			if(getlist.size() >0)
			{
				getmap = (Map)getlist.get(0);
				currencycode = StringHelper.null2String(getmap.get("currencycode"));//获取币种
			}

			String username = StringHelper.null2String(map.get("username"));//用户名
			getsql = "select objname from humres where id = '"+username+"'";
			getlist = baseJdbc.executeSqlForList(getsql);
			if(getlist.size() >0)
			{
				getmap = (Map)getlist.get(0);
				username = StringHelper.null2String(getmap.get("objname"));//获取用户名
			}
			String hl = StringHelper.null2String(map.get("hl"));//汇率
			String pznumber = StringHelper.null2String(map.get("pznumber"));//预付凭证号码
			String pztitle = StringHelper.null2String(map.get("pztitle"));//抬头文本
			String jzmonth = StringHelper.null2String(map.get("jzmonth"));//记帐期间



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
			//function.getImportParameterList().setValue("LGART","7030");

			function.getImportParameterList().setValue("DOC_DATE",pzdate);//凭证日期
			function.getImportParameterList().setValue("PSTNG_DATE",jzdate);//记帐日期
			function.getImportParameterList().setValue("DOC_TYPE",pztype);//凭证类型
			function.getImportParameterList().setValue("COMP_CODE",companycode);//公司代码
			function.getImportParameterList().setValue("PSTNG_PERIOD",jzmonth);//记帐期间
			function.getImportParameterList().setValue("CURRENCY",currencycode);//货币代码
			function.getImportParameterList().setValue("EXCHNG_RATE",hl);//汇率
			function.getImportParameterList().setValue("HEADER_TXT",pztitle);//抬头文本
			function.getImportParameterList().setValue("USER_NAME",username);//用户名
			function.getImportParameterList().setValue("REF_DOC_NO",pznumber);//参考凭证号
			function.getImportParameterList().setValue("NOTESID","");//NotesID
			function.getImportParameterList().setValue("RUN_MODE","A");//
			

			


			//建表
			JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
			sql = "select t.jzcode,t.pzledgerobj,t.pzamount,t.pztax,t.pzcostcenter,t.pzinnerorder,t.pzpaycondition,t.pzpaydate,t.pzpayway,t.pzblank,t.pztext from uf_wxcreditdetail t   where t.requestid='"+requestid+"'";
			//记帐码，总账科目，金额，税码,成本中心，内部订单号，付款条件，付款日期，付款方式，银行，文本
			List list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					 map = (Map)list.get(i);
					String jzcode = StringHelper.null2String(map.get("jzcode"));
					String pzledgerobj = StringHelper.null2String(map.get("pzledgerobj"));
					String pzamount = StringHelper.null2String(map.get("pzamount"));
					String pztax = StringHelper.null2String(map.get("pztax")); //税码
					String pzcostcenter = StringHelper.null2String(map.get("pzcostcenter"));
					String pzinnerorder = StringHelper.null2String(map.get("pzinnerorder"));
					String pzpaycondition = StringHelper.null2String(map.get("pzpaycondition"));
					String pzpaydate = StringHelper.null2String(map.get("pzpaydate"));
					String pzpayway = StringHelper.null2String(map.get("pzpayway"));//付款方式
					/*if(pzpayway == "40285a904931f62b0149413ed08e024a")
					{
						pzpayway = "现金";
					}
					else if(pzpayway == "40285a904931f62b0149413ed08e0249")
					{
						pzpayway = "电汇";
					}*/
					//if(jzcode.equals("31"))
					//{
					sql = "select objdesc from selectitem where id ='"+pzpayway+"'";
					list = baseJdbc.executeSqlForList(sql);
					if(list.size() >0)
					{
						map = (Map)list.get(0);
						pzpayway = StringHelper.null2String(map.get("objdesc"));//
					}
					sql = " select taxcode from uf_oa_taxcode where requestid ='"+pztax+"'";
					list = baseJdbc.executeSqlForList(sql);
					if(list.size() >0)
					{
						map = (Map)list.get(0);
						pztax = StringHelper.null2String(map.get("taxcode"));//
					}
					//}
					String pzblank = StringHelper.null2String(map.get("pzblank"));
					String pztext = StringHelper.null2String(map.get("pztext"));
					retTable.appendRow();
					retTable.setValue("PSTNG_CODE", jzcode); //记帐码
					retTable.setValue("GL_ACCOUNT", pzledgerobj);//总账科目
					retTable.setValue("MONEY", pzamount);//金额
					retTable.setValue("TAX_CODE", pztax);//税码
					retTable.setValue("COST_CENTER", pzcostcenter);//成本中心
					retTable.setValue("ORDER_ID", pzinnerorder);//内部订单号
					retTable.setValue("PAY_TERMS", pzpaycondition);//付款条件
					pzpaydate = pzpaydate.replace("-", "");//付款日期
					retTable.setValue("PAY_DATE", pzpaydate);//付款日期
					retTable.setValue("PAY_WAY", pzpayway);//付款方式
					retTable.setValue("BANK_TYPE", pzblank);//银行
					retTable.setValue("ITEM_TEXT", pztext);//文本
					System.out.println(jzcode);
					System.out.println(pzledgerobj);
					System.out.println(pzamount);
					System.out.println(pztax);
					System.out.println(pzcostcenter);
					System.out.println(pzinnerorder);
					System.out.println(pzpaycondition);
					System.out.println(pzpaydate);
					System.out.println(pzpayway);
					System.out.println(pzblank);

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
		
			JSONObject jo = new JSONObject();		
			jo.put("msg", ERR_MSG);
			jo.put("acdocno", AC_DOC_NO);
			jo.put("flag", FLAG);
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			//System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
	}
%>
