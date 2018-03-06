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
		String Pztt = StringHelper.null2String(request.getParameter("Pztt"));//凭证抬头
		String jzmonth = StringHelper.null2String(request.getParameter("jzmonth"));//记账期间
		String pztype = StringHelper.null2String(request.getParameter("pztype"));//凭证类型
		String Zzdate = StringHelper.null2String(request.getParameter("Zzdate"));//记账日期
		String Hl = StringHelper.null2String(request.getParameter("Hl"));//汇率
		String Pzdate = StringHelper.null2String(request.getParameter("Pzdate"));//凭证日期
		String username = StringHelper.null2String(request.getParameter("username"));//用户名
		String pznumber = StringHelper.null2String(request.getParameter("pznumber"));//凭证号码
		String hbcode = StringHelper.null2String(request.getParameter("hbcode"));//货币代码
		String Comcode = StringHelper.null2String(request.getParameter("Comcode"));//公司代码
		String fpno = StringHelper.null2String(request.getParameter("fpno"));//发票号码

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_FI_CDOC_CREATE";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			//插入字段
			//function.getImportParameterList().setValue("LGART","7030");
            Pzdate = Pzdate.replace("-","");
			Zzdate = Zzdate.replace("-","");
			function.getImportParameterList().setValue("DOC_DATE",Pzdate);//凭证日期
			function.getImportParameterList().setValue("PSTNG_DATE",Zzdate);//记帐日期

			function.getImportParameterList().setValue("DOC_TYPE",pztype);//凭证类型
			function.getImportParameterList().setValue("COMP_CODE",Comcode);//公司代码
			function.getImportParameterList().setValue("PSTNG_PERIOD",jzmonth);//记帐期间


			function.getImportParameterList().setValue("CURRENCY",hbcode);//货币代码
			function.getImportParameterList().setValue("EXCHNG_RATE",Hl);//汇率
			function.getImportParameterList().setValue("HEADER_TXT",Pztt);//抬头文本
			function.getImportParameterList().setValue("USER_NAME",username);//用户名
			function.getImportParameterList().setValue("REF_DOC_NO",fpno);//参考凭证号
			function.getImportParameterList().setValue("NOTESID",requestid);//NotesID
			function.getImportParameterList().setValue("RUN_MODE","N");//
			

			
			//建表(未清项)
			JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_CLEAR");
			String sql = "select money,Generalledger,year,num1,chargecode,texttwo,expco,need from uf_hr_tbclearcurtains  where requestid='"+requestid+"'";
			List list = baseJdbc.executeSqlForList(sql);
			for(int i = 0;i<list.size();i++)
			{
				Map map = (Map)list.get(i);
				

				String money = StringHelper.null2String(map.get("money")); //金额

				String Generalledger = StringHelper.null2String(map.get("Generalledger"));//总账科目
				String chargecode = StringHelper.null2String(map.get("chargecode"));//记账码
				String texttwo = StringHelper.null2String(map.get("texttwo"));//文本
				String year = StringHelper.null2String(map.get("year")); //会计年度
				String num1 = StringHelper.null2String(map.get("num1")); //需清账凭证项次
				String expco = StringHelper.null2String(map.get("expco"));//特殊总账标识
				String need= StringHelper.null2String(map.get("need"));//需清账编码

				retTable.appendRow();//增加一行
				retTable.setValue("SGL_FLAG",expco);//特殊总帐标识
				retTable.setValue("DOC_NO",need);//需清账凭证编号
				retTable.setValue("DOC_YEAR",year);//会计年度
				retTable.setValue("DOC_ITEM",num1);//行项目号
				retTable.setValue("CL_MONEY",money);//清账金额
				System.out.println(money);
				System.out.println(texttwo);
				retTable.setValue("CL_TEXT",texttwo);//清账文本
              
				retTable.setValue("VC_NO",Generalledger);//总帐科目				
			}
			//建表(凭证行项目)
			JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
			sql = "select serialn,salesorder,internalorder,costcentre,a.taxcode as taxname,curramount,money,transtype,(select objdesc from selectitem where id=paymethod and typeid='40285a8d50650e29015065278ef505ae' ) as paymethod,sgl,subj,chargecode,salesorderitem,assets,subasset,textthree,paymentterms,serialno,cbank from uf_hr_tlainformation a where requestid='"+requestid+"'order by serialn asc";
			 list = baseJdbc.executeSqlForList(sql);
			for(int i = 0;i<list.size();i++)
			{
				Map map1 = (Map)list.get(i);
				String salesorder = StringHelper.null2String(map1.get("salesorder"));//销售订单号
				String Internalorder = StringHelper.null2String(map1.get("internalorder"));//内部订单号
				String costcentre = StringHelper.null2String(map1.get("costcentre"));//成本中心
				String taxcode = StringHelper.null2String(map1.get("taxname"));//税码
				String curramount = StringHelper.null2String(map1.get("curramount"));//本位币金额
				String money = StringHelper.null2String(map1.get("money"));//金额
				String Transtype = StringHelper.null2String(map1.get("transtype"));//事务类型
				String SGL = StringHelper.null2String(map1.get("sgl"));//SGL标识
				String subj = StringHelper.null2String(map1.get("subj"));//科目
				String chargecode = StringHelper.null2String(map1.get("chargecode"));//记账码
				String Salesorderitem = StringHelper.null2String(map1.get("salesorderitem"));//销售订单项次
				String assets = StringHelper.null2String(map1.get("assets"));//资产
				String Subasset = StringHelper.null2String(map1.get("subasset"));//子资产号
				String textthree = StringHelper.null2String(map1.get("textthree"));//文本
				System.out.println(textthree);
				String paymentterms = StringHelper.null2String(map1.get("paymentterms"));//付款条件
				String Serialno = StringHelper.null2String(map1.get("serialno"));//付款基准日期
				Serialno=Serialno.replace("-","");
				String Paymethod = StringHelper.null2String(map1.get("paymethod"));//付款方式
				String Cbank = StringHelper.null2String(map1.get("cbank"));//合作银行

				retTable1.appendRow();//增加一行


				retTable1.setValue("PAY_TERMS",paymentterms);//付款条件
				retTable1.setValue("MONEY",money);//金额
				System.out.println(money);
				retTable1.setValue("GL_ACCOUNT",subj);//总账科目
				retTable1.setValue("PSTNG_CODE",chargecode);//记账码

				retTable1.setValue("PAY_WAY",Paymethod);//付款方式
				System.out.println("付款方式"+Paymethod);
				retTable1.setValue("BANK_TYPE",Cbank);//合作银行
				retTable1.setValue("ITEM_TEXT",textthree);//文本
				retTable1.setValue("PAY_DATE",Serialno);//付款基准日期
				System.out.println("付款日期"+Serialno);
                retTable1.setValue("TRANS_TYPE",Transtype);//事务类型

				retTable1.setValue("TAX_CODE",taxcode);//税码
				retTable1.setValue("COST_CENTER",costcentre);//成本中心

				retTable1.setValue("ORDER_ID",Internalorder);//内部订单号
			}
			System.out.println("执行SAP 接口");
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("test");

			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
			String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();
			System.out.println(AC_DOC_NO);
			String upsql = "update uf_hr_cleartable   set acdocnum ='"+AC_DOC_NO+"',flag='"+FLAG+"',errmessage='"+ERR_MSG+"' where  requestid = '"+requestid+"'";
			System.out.println(upsql);
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


%>
