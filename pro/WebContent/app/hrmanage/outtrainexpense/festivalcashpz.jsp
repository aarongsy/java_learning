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

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select t.flowno,t.pzdate,t.zzdate,t.pztype,t.comcode,t.jzmonth,t.hbcode,t.hl,t.pznumber,t.pztt,t.username from uf_hr_festivalcash t where t.requestid='"+requestid+"'";
		//凭证日期，记帐日期，凭证类型，公司代码，币种，汇率，预付凭证号，凭证抬头文本，记帐期间，用户名
		List tlist = baseJdbc.executeSqlForList(sql);
		String getsql = "";
		List getlist;
		Map getmap;
		if(tlist.size()>0){
			Map map = (Map)tlist.get(0);
			String flowno=StringHelper.null2String(map.get("flowno"));//流程单号
			String pzdate = StringHelper.null2String(map.get("pzdate"));//凭证日期
			
			String jzdate = StringHelper.null2String(map.get("zzdate"));//记帐日期
			String pztype = StringHelper.null2String(map.get("pztype"));//凭证类型

			String companycode = StringHelper.null2String(map.get("comcode"));//公司代码
			String currencycode = StringHelper.null2String(map.get("hbcode"));//币种
			getsql = "select currencycode from uf_oa_currencymaintain where requestid = '"+currencycode+"'";
			getlist = baseJdbc.executeSqlForList(getsql);
			if(getlist.size() >0)
			{
				getmap = (Map)getlist.get(0);
				currencycode = StringHelper.null2String(getmap.get("currencycode"));//获取币种
			}
			getsql = "select objno from getcompanyview where requestid= '"+companycode+"'";
			getlist = baseJdbc.executeSqlForList(getsql);
			if(getlist.size() >0)
			{
				getmap = (Map)getlist.get(0);
				companycode = StringHelper.null2String(getmap.get("objno"));//获取公司代码
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
			String pztitle = StringHelper.null2String(map.get("pztt"));//抬头文本
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
			function.getImportParameterList().setValue("RUN_MODE","N");//
			/*System.out.println("凭证日期"+pzdate);
			System.out.println("记账日期"+jzdate);
			System.out.println("凭证类型"+pztype);
			System.out.println("公司代码"+"1010");
			System.out.println("记账期间"+jzmonth);
			System.out.println("货币代码"+currencycode);	
			System.out.println("汇率"+hl);
			System.out.println("凭证抬头"+pztitle);
			System.out.println("用户名"+username);
			System.out.println("参考凭证号"+pznumber);
			System.out.println("NotesID"+flowno);
			System.out.println("模式"+"N");	*/	


			//建表
			JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
			sql = "select t.jzcode,t.genledger,t.num,t.rate,t.costcenter,t.innerorder,t.payterm,t.paydate,t.paymanner,t.bank,t.paytext from uf_hr_jrcreditdetails t where t.requestid='"+requestid+"'";
			//记帐码，总账科目，金额，税码,成本中心，内部订单号，付款条件，付款日期，付款方式，银行，文本
			List list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					 map = (Map)list.get(i);
					String jzcode = StringHelper.null2String(map.get("jzcode"));
					String pzledgerobj = StringHelper.null2String(map.get("genledger"));
					String pzamount = StringHelper.null2String(map.get("num"));
					String pztax = StringHelper.null2String(map.get("rate")); //税码
					String pzcostcenter = StringHelper.null2String(map.get("costcenter"));
					String pzinnerorder = StringHelper.null2String(map.get("innerorder"));
					String pzpaycondition = StringHelper.null2String(map.get("payterm"));
					String pzpaydate = StringHelper.null2String(map.get("paydate"));
					String pzpayway = StringHelper.null2String(map.get("paymanner"));//付款方式
					if(pzpayway.equals("40285a904931f62b0149413ed08e024a"))
					{
						pzpayway = "E";
					}
					else if(pzpayway.equals( "40285a904931f62b0149413ed08e0249"))
					{
						pzpayway = "I";
					}
      					else
					{
						pzpayway="";
					}
					String pzblank = StringHelper.null2String(map.get("bank"));
					String pztext = StringHelper.null2String(map.get("paytext"));
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
			/*System.out.println("记账码"+jzcode);
			System.out.println("总账科目"+pzledgerobj);
			System.out.println("金额"+pzamount);
			System.out.println("税码"+pztax);
			System.out.println("成本中心"+pzcostcenter);
			System.out.println("内部订单号"+pzinnerorder);	
			System.out.println("付款条件"+pzpaycondition);
			System.out.println("付款日期"+pzpaydate);
			System.out.println("付款方式"+pzpayway );
			System.out.println("银行"+pzblank);
			System.out.println("文本"+pztext);*/

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
			String upsql="update uf_hr_festivalcash set pznumber='"+AC_DOC_NO+"',succflag='"+FLAG+"',errorcode='"+ERR_MSG+"' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
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
