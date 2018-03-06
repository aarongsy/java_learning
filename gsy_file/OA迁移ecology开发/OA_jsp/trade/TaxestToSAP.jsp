<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("taxesttoSap")){	
		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");		
		JSONObject jo = new JSONObject();		
		String sql = "select a.receiptdate,a.bkkpingdate,a.receipttype,a.comcaode,a.bkkpingperiod,a.receiptcurrency,a.rate,a.referreceipt,a.receipthead,e.objname,a.notesid from uf_tr_taxestimated a left join getcompanyview b on a.comcaode=b.requestid left join uf_oa_currencymaintain c  on a.currency=c.requestid left join humres e on a.userman=e.id where a.requestid='"+requestid+"'";
		
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String receiptdate = StringHelper.null2String(map.get("receiptdate"));//凭证日期
				receiptdate = receiptdate.replace("-", "");
				String bkkpingdate = StringHelper.null2String(map.get("bkkpingdate"));//记帐日期
				bkkpingdate = bkkpingdate.replace("-", "");
				String receipttype = StringHelper.null2String(map.get("receipttype"));//凭证类型
				String objno = StringHelper.null2String(map.get("comcaode"));//公司代码
				String bkkpingperiod = StringHelper.null2String(map.get("bkkpingperiod"));//记账期间
				int a = Integer.parseInt(bkkpingperiod);
				if(a < 10 && (bkkpingperiod.indexOf("0") == -1)){
					bkkpingperiod = "0" + bkkpingperiod;
				}
				System.out.println("过账代码"+bkkpingperiod);

				String currencycode = StringHelper.null2String(map.get("receiptcurrency"));//货币代码
				String rate = StringHelper.null2String(map.get("rate"));//汇率
				String referreceipt = StringHelper.null2String(map.get("referreceipt"));//参考凭证号
				String receipthead = StringHelper.null2String(map.get("receipthead"));//凭证抬头
				String objname = StringHelper.null2String(map.get("objname"));//用户名
				String notesid = StringHelper.null2String(map.get("notesid"));//NOTES文档ID
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
				System.out.println(sql);
				//System.out.println("PERNR:"+sapid+",BEGDA:"+theMonth+",ENDDA:99991231,LGART:7060,BETRG:"+money+",WAERS：RMB");
				//插入字段
				function.getImportParameterList().setValue("DOC_DATE",receiptdate);
				function.getImportParameterList().setValue("PSTNG_DATE",bkkpingdate);
				function.getImportParameterList().setValue("DOC_TYPE",receipttype);
				function.getImportParameterList().setValue("COMP_CODE",objno);
				function.getImportParameterList().setValue("PSTNG_PERIOD",bkkpingperiod);
				function.getImportParameterList().setValue("CURRENCY",currencycode);
				function.getImportParameterList().setValue("EXCHNG_RATE",rate);
				function.getImportParameterList().setValue("REF_DOC_NO",referreceipt);
				function.getImportParameterList().setValue("HEADER_TXT",receipthead);
				function.getImportParameterList().setValue("USER_NAME",objname);
				function.getImportParameterList().setValue("NOTESID",notesid);
				function.getImportParameterList().setValue("RUN_MODE","N");
				
				JCoTable retTable = function.getTableParameterList().getTable("FI_DOC_ITEMS");
				sql = "select a.accountcode,a.subject,a.money,a.taxcode,a.costcenter,a.purchaseorder,a.purorderitem,a.text1 from uf_tr_taxestimatedsub a where a.requestid='"+requestid+"' order by sno asc";
				List list2 = baseJdbc.executeSqlForList(sql);
				if(list2.size()>0){
					for(int m=0;m<list2.size();m++){
						Map map2 = (Map)list2.get(m);
						String accountcode = StringHelper.null2String(map2.get("accountcode"));//记账码
						String subject = StringHelper.null2String(map2.get("subject"));//科目
						String money = StringHelper.null2String(map2.get("money"));//金额
						String taxcode = StringHelper.null2String(map2.get("taxcode"));//税码
						String costcenter = StringHelper.null2String(map2.get("costcenter"));//成本中心
						String purchaseorder = StringHelper.null2String(map2.get("purchaseorder"));//采购订单
						String purorderitem = StringHelper.null2String(map2.get("purorderitem"));//采购订单行项目
						String text1 = StringHelper.null2String(map2.get("text1"));//文本
						retTable.appendRow();
						retTable.setValue("PSTNG_CODE", accountcode);
						retTable.setValue("GL_ACCOUNT", subject);
						retTable.setValue("MONEY", money);
						retTable.setValue("TAX_CODE", taxcode);
						retTable.setValue("COST_CENTER", costcenter);
						retTable.setValue("PO_NO", purchaseorder);
						retTable.setValue("PO_ITEM", purorderitem);
						retTable.setValue("ITEM_TEXT", text1);
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
				String errorid = function.getExportParameterList().getValue("ERR_MSG").toString();
				String succflag = function.getExportParameterList().getValue("FLAG").toString();
				String cwpz = function.getExportParameterList().getValue("AC_DOC_NO").toString();
				System.out.println("errorid:"+errorid);
				jo.put("cwpz", cwpz);
				jo.put("succflag", succflag);
				jo.put("errorid", errorid);
			}		
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>