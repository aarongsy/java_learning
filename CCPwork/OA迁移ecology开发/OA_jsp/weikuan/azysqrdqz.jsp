<script>


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
        String suppliercode=StringHelper.null2String(request.getParameter("suppliercode"));
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
			

			//建表(凭证行项目)
			JCoTable retTable1 = function.getTableParameterList().getTable("FI_DOC_ITEMS");
			String sql = "select jznum,subject,money,payterm,paydate,payway,frozen,blank,text from uf_fn_acceptrowinfo  where requestid='"+requestid+"'";
			//sql = "select jznum,subject,money,payterm,paydate,payway,frozen,blank,text from uf_fn_acceptrowinfo where requestid='"+requestid+"'";
			List list = baseJdbc.executeSqlForList(sql);
			// list = baseJdbc.executeSqlForList(sql);
			for(int i = 0;i<list.size();i++)
			{
				Map map1 = (Map)list.get(i);
				String jznum = StringHelper.null2String(map1.get("jznum"));//记账码
				String subject = StringHelper.null2String(map1.get("subject"));//科目
				String money = StringHelper.null2String(map1.get("money"));//金额
				String payterm = StringHelper.null2String(map1.get("payterm"));//付款条件
				String paydate = StringHelper.null2String(map1.get("paydate"));//付款基准日期
			    String paydate1=paydate.split("-")[0]+paydate.split("-")[1]+paydate.split("-")[2];
				String payway = StringHelper.null2String(map1.get("payway"));//付款方式
				String frozen = StringHelper.null2String(map1.get("frozen"));//冻结付款
				String blank = StringHelper.null2String(map1.get("blank"));//合作银行
				String text = StringHelper.null2String(map1.get("text"));//文本

				retTable1.appendRow();//增加一行


				retTable1.setValue("PAY_TERMS",payterm);//付款条件

				System.out.println(payterm);
				retTable1.setValue("MONEY",money);//金额
				System.out.println(money);
				retTable1.setValue("GL_ACCOUNT",subject);//总账科目
				System.out.println(subject);
				retTable1.setValue("PSTNG_CODE",jznum);//记账码
				System.out.println(jznum);
                retTable1.setValue("PAY_LOCK","A");//
				System.out.println("-------------");
				retTable1.setValue("PAY_WAY",payway);//付款方式
				System.out.println(payway);
				retTable1.setValue("BANK_TYPE",blank);//合作银行
				System.out.println(blank);
				retTable1.setValue("ITEM_TEXT",text);//文本
				System.out.println(text);
				retTable1.setValue("PAY_DATE",paydate1);//付款基准日期
				System.out.println(paydate1);
			}
				//建表(未清项行项目)
			JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_CLEAR");
			String sql1 = "select jznum,subject,money,Specialid,pznum,year,unrepair,text from uf_oa_unrepair where requestid = '"+requestid+"'";
			List list1 = baseJdbc.executeSqlForList(sql1);
			//System.out.println("查询到的未清项的条数:"+list1.size()+"test");
			for(int i = 0;i<list1.size();i++)
			{
				Map map = (Map)list1.get(i);
				

				String money = StringHelper.null2String(map.get("money")); //金额

				String Generalledger = StringHelper.null2String(map.get("subject"));//客户/供应商简码
				//String chargecode = "27";//记账码
				String texttwo = StringHelper.null2String(map.get("text"));//文本
				String year = StringHelper.null2String(map.get("year")); //会计年度
				String num1 = StringHelper.null2String(map.get("unrepair")); //需清账凭证项次
				String expco = StringHelper.null2String(map.get("Specialid"));//特殊总账标识
				String need= StringHelper.null2String(map.get("pznum"));//需清账编码
				String jznum=StringHelper.null2String(map.get("suppliercode"));//客户/供应商标识

				retTable.appendRow();//增加一行
				retTable.setValue("VC_NO",jznum);//总帐科目
				//System.out.println("NJX003");
				retTable.setValue("VC_FLAG", "K"); //客户供应商标识
				System.out.println(jznum);
				retTable.setValue("SGL_FLAG","");//特殊总帐标识
				retTable.setValue("DOC_NO",need);//需清账凭证编号
				System.out.println(need);
				retTable.setValue("DOC_YEAR",year);//会计年度
				System.out.println(year);
				retTable.setValue("DOC_ITEM",num1);//行项目号
				System.out.println(num1);
				retTable.setValue("CL_MONEY",money);//清账金额
				System.out.println(money);
				System.out.println(texttwo);
				retTable.setValue("CL_TEXT",texttwo);//清账文本
              
				
			}

/*
				JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_CLEAR");
				sql = "select pznumber,year,paymoney,pzcurrency,subject,payterm,payway,jzdate,forzenpay,blank,text from uf_fn_acceptpayinfo where requestid = '"+requestid+"'";
			    List list = baseJdbc.executeSqlForList(sql);
				if(list.size()>0){
					for(int i=0;i<list.size();i++){
						Map map = (Map)list.get(i);
						//String custsuppflag = StringHelper.null2String(map.get("custsuppflag"));//客户供应商标识
						//String custsuppcode = StringHelper.null2String(map.get("custsuppcode"));//客户/供应商编码
						//String ledgerflag = StringHelper.null2String(map.get("ledgerflag"));//特殊总账标识

						String clearreceiptid = StringHelper.null2String(map.get("pznumber"));//需清帐凭证编号
						String fiscalyear = StringHelper.null2String(map.get("year"));//会计年度
						//String clearreceiptitem = StringHelper.null2String(map.get("clearreceiptitem"));//需清帐凭证项次
						String surplusmoney = StringHelper.null2String(map.get("paymoney"));//清帐剩余金额
						String cleartext = StringHelper.null2String(map.get("text"));//清帐文本

						retTable.appendRow();
						//retTable.setValue("VC_FLAG", custsuppflag); //客户供应商标识
						//retTable.setValue("VC_NO", custsuppcode);//客户/供应商编码
						//retTable.setValue("SGL_FLAG", "");//特殊总账标识
						retTable.setValue("DOC_NO", clearreceiptid);//需清帐凭证编号
						retTable.setValue("DOC_YEAR", fiscalyear);//会计年度
						retTable.setValue("DOC_ITEM", "27");//需清帐凭证项次
						retTable.setValue("CL_MONEY", surplusmoney);//清帐剩余金额
						retTable.setValue("CL_TEXT", cleartext);//清帐文本
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
			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
			String AC_DOC_NO = function.getExportParameterList().getValue("AC_DOC_NO").toString();
			System.out.println("DOCNUM:"+AC_DOC_NO);
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();
			String upsql = "update uf_fn_acceptconfirm   set pznumber='"+AC_DOC_NO+"',successflag='"+FLAG+"',error='"+ERR_MSG+"' where  requestid = '"+requestid+"'";
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










</script>