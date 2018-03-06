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
	if (action.equals("ZgSAP"))
	{	
		System.out.println("------------------------------------税金暂估上抛凭证");
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");		
		JSONObject jo = new JSONObject();		
		//获取税金暂估预付主表中关于暂估的凭证信息
		String sql = "select a.pzdate,a.jzdate,a.pztype,a.pzcomcode,a.pzperiod,a.pzcurrency,a.pzrate,a.pzrefer,a.pzhead,e.objname,a.notesid from uf_dmph_sjzgyfmain a left join getcompanyview b on a.pzcomcode=b.objno left join uf_dmdb_curr c  on a.pzcurrency=c.currcode left join humres e on a.username=e.id where a.requestid='"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				Map map = (Map)list.get(i);
				String receiptdate = StringHelper.null2String(map.get("pzdate"));//凭证日期
				receiptdate = receiptdate.replace("-", "");
				String bkkpingdate = StringHelper.null2String(map.get("jzdate"));//记帐日期
				bkkpingdate = bkkpingdate.replace("-", "");
				String receipttype = StringHelper.null2String(map.get("pztype"));//凭证类型
				String objno = StringHelper.null2String(map.get("pzcomcode"));//公司代码
				String bkkpingperiod = StringHelper.null2String(map.get("pzperiod"));//记账期间
				int a = Integer.parseInt(bkkpingperiod);
				//System.out.println("a-------------"+a);
				if(a < 10 && (bkkpingperiod.indexOf("0") == -1))
				{
					//System.out.println("*********");
					bkkpingperiod = "0" + bkkpingperiod;
				}
				//System.out.println("过账代码"+bkkpingperiod);
				String currencycode = StringHelper.null2String(map.get("pzcurrency"));//货币代码
				String rate = StringHelper.null2String(map.get("pzrate"));//汇率
				String referreceipt = StringHelper.null2String(map.get("pzrefer"));//参考凭证号
				if(referreceipt.equals("null")||referreceipt.equals(null))
				{
					referreceipt = "";
				}
				String receipthead = StringHelper.null2String(map.get("pzhead"));//凭证抬头
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
				//System.out.println(sql);
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
				//获取暂估凭证行项目信息
				sql = "select a.accountcode,a.subject,a.money,a.taxcode,a.costcenter,a.purchaseorder,a.purorderitem,a.text from uf_dmph_zgpzdetail a where a.requestid='"+requestid+"' order by sno asc";
				List list2 = baseJdbc.executeSqlForList(sql);
				if(list2.size()>0)
				{
					for(int m=0;m<list2.size();m++)
					{
						Map map2 = (Map)list2.get(m);
						String accountcode = StringHelper.null2String(map2.get("accountcode"));//记账码
						String subject = StringHelper.null2String(map2.get("subject"));//科目
						String money = StringHelper.null2String(map2.get("money"));//金额
						String taxcode = StringHelper.null2String(map2.get("taxcode"));//税码
						String costcenter = StringHelper.null2String(map2.get("costcenter"));//成本中心
						String purchaseorder = StringHelper.null2String(map2.get("purchaseorder"));//采购订单
						String purorderitem = StringHelper.null2String(map2.get("purorderitem"));//采购订单行项目
						String text = StringHelper.null2String(map2.get("text"));//文本
						retTable.appendRow();
						retTable.setValue("PSTNG_CODE", accountcode);
						retTable.setValue("GL_ACCOUNT", subject);
						retTable.setValue("MONEY", money);
						retTable.setValue("TAX_CODE", taxcode);
						retTable.setValue("COST_CENTER", costcenter);
						retTable.setValue("PO_NO", purchaseorder);
						retTable.setValue("PO_ITEM", purorderitem);
						retTable.setValue("ITEM_TEXT", text);
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
				//System.out.println("cwpz:"+cwpz);
				//System.out.println("succflag:"+succflag);
				//System.out.println("errorid:"+errorid);
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