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
		String requestid=StringHelper.null2String(request.getParameter("requestid"));

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select t.pzmonth,t.flowno,t.jzdate,(select currencycode from uf_oa_currencymaintain where requestid =t.currency) as currency,(select objname from humres where id= t.pzuser) as pzuser,t.text,t.company,t.pzdate,t.hl,t.pztype from uf_oa_procost  t where t.requestid='"+requestid+"'";
		List tlist = baseJdbc.executeSqlForList(sql);
		String getsql = "";
		List getlist;
		Map getmap;
		if(tlist.size()>0){
			Map map = (Map)tlist.get(0);
			String pzmonth=StringHelper.null2String(map.get("pzmonth"));//过账期间
			String flowno = StringHelper.null2String(map.get("flowno"));//流程单号
			
			String jzdate = StringHelper.null2String(map.get("jzdate"));//记帐日期
			String currency = StringHelper.null2String(map.get("currency"));//货币代码

			String pzuser = StringHelper.null2String(map.get("pzuser"));//制证人
			String text = StringHelper.null2String(map.get("text"));//参照
			String company = StringHelper.null2String(map.get("company"));//公司代码
			String pzdate = StringHelper.null2String(map.get("pzdate"));//凭证日期
			String hl = StringHelper.null2String(map.get("hl"));//汇率
			String pztype = StringHelper.null2String(map.get("pztype"));//凭证类型



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
			

			function.getImportParameterList().setValue("PSTNG_PERIOD",pzmonth);//记账期间
			function.getImportParameterList().setValue("NOTESID",flowno);//
			function.getImportParameterList().setValue("PSTNG_DATE",jzdate);//记账日期
			function.getImportParameterList().setValue("CURRENCY",currency);//货币代码
			function.getImportParameterList().setValue("USER_NAME",pzuser);//用户名
			function.getImportParameterList().setValue("HEADER_TXT",text);//凭证抬头
			function.getImportParameterList().setValue("COMP_CODE",company);//公司代码
			function.getImportParameterList().setValue("DOC_DATE",pzdate);//凭证日期
			function.getImportParameterList().setValue("EXCHNG_RATE",hl);//汇率
			function.getImportParameterList().setValue("DOC_TYPE",pztype);//凭证类型
			function.getImportParameterList().setValue("RUN_MODE","N");//


			//建表
			JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
			sql = "select costcenter,taxcode,innerorder,orderno,taxnum,jznumber,text,subject,saleoeder from uf_oa_zgfeekjrowdetail t where t.requestid='"+requestid+"' order by no asc";
			List list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					 map = (Map)list.get(i);
					String innerorder = StringHelper.null2String(map.get("innerorder"));//内部订单
					String jznumber = StringHelper.null2String(map.get("jznumber"));//记账码
					String orderno = StringHelper.null2String(map.get("orderno")); //项次
					String subject = StringHelper.null2String(map.get("subject"));//总账科目
					String text1 = StringHelper.null2String(map.get("text"));//文本
					String taxcode = StringHelper.null2String(map.get("taxcode"));//税码
					String taxnum = StringHelper.null2String(map.get("taxnum"));//金额
					String saleoeder = StringHelper.null2String(map.get("saleoeder"));//销售订单
					String costcenter = StringHelper.null2String(map.get("costcenter"));//成本中心
					
					retTable.appendRow();
					retTable.setValue("ORDER_ID", innerorder);
					retTable.setValue("PSTNG_CODE", jznumber);
					retTable.setValue("SO_ITEM", orderno);
					retTable.setValue("GL_ACCOUNT", subject);
					retTable.setValue("ITEM_TEXT", text1);
					retTable.setValue("TAX_CODE", taxcode);
					retTable.setValue("MONEY", taxnum);
					retTable.setValue("SO_NO", saleoeder);
					retTable.setValue("COST_CENTER", costcenter);


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
			String upsql="update uf_oa_procost  set pznumber='"+AC_DOC_NO+"',successflag='"+FLAG+"',errorflag='"+ERR_MSG+"' where requestid='"+requestid+"'";
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

%>
