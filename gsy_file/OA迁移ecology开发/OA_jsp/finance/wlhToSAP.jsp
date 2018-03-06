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
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>




<%
	String action=StringHelper.null2String(request.getParameter("action"));

	if (action.equals("WLtoSap"))
	{	
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		String proofhead = StringHelper.null2String(request.getParameter("proofhead"));//凭证抬头
		String markdate = StringHelper.null2String(request.getParameter("markdate"));//过账日期
		markdate = markdate.replace("-", "");
		String objno = StringHelper.null2String(request.getParameter("objno"));//公司代码
		objno = objno.trim();
		String factory = StringHelper.null2String(request.getParameter("factory"));//工厂
		factory = factory.trim();
		String referto = StringHelper.null2String(request.getParameter("referto"));//参照

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");		
		JSONObject jo = new JSONObject();		

		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_MM_DOC_POST_CL";

		String sql = "select no,wlno,jine,cgddh,cgddxc,notesid from uf_clwlpzhxmxx where requestid='"+requestid+"' order by no";
		List list2 = baseJdbc.executeSqlForList(sql);
		if(list2.size()>0)
		{
			for(int m=0;m<list2.size();m++)
			{
				JCoFunction function = null;
				System.out.println(functionName);
				try 
				{
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) 
				{
					e.printStackTrace();
				}
				
				//插入字段
				function.getImportParameterList().setValue("BKTXT",proofhead);
				function.getImportParameterList().setValue("BUDAT",markdate);
				function.getImportParameterList().setValue("BUKRS",objno);
				function.getImportParameterList().setValue("RUN_MODE","N");
				function.getImportParameterList().setValue("WERKS",factory);
				function.getImportParameterList().setValue("XBLNR",referto);

				Map map2 = (Map)list2.get(m);
				String sno = StringHelper.null2String(map2.get("no"));//序号
				String materialno = StringHelper.null2String(map2.get("wlno"));
				String money = StringHelper.null2String(map2.get("jine"));
				String orderno = StringHelper.null2String(map2.get("cgddh"));
				String item = StringHelper.null2String(map2.get("cgddxc"));
				String notesid = StringHelper.null2String(map2.get("notesid"));//NotesID
				function.getImportParameterList().setValue("NOTESID",notesid);//NotesID
				
				JCoTable retTable = function.getTableParameterList().getTable("MM_DOC_ITEM");
				retTable.appendRow();
				retTable.setValue("MATNR", materialno);
				retTable.setValue("ZUUMB", money);
				retTable.setValue("EBELN",orderno);//订单
				System.out.println("orderno="+orderno);
				retTable.setValue("EBELP",item);//项次
				System.out.println("item="+item);

				try 
				{
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) 
				{
					// TODO Auto-generated catch block  
					e.printStackTrace();
				} catch (Exception e) 
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				//返回值
				String message = function.getExportParameterList().getValue("ERR_MSG").toString();
				String msgty = function.getExportParameterList().getValue("FLAG").toString();
				String cwpz = function.getExportParameterList().getValue("MBLNR").toString();
				String insql = "update uf_clwlpzhxmxx  set sappzh = '"+cwpz+"',xxlx='"+msgty+"',cwxx='"+message+"' where requestid = '"+requestid+"' and no = '"+sno+"'";
				System.out.println("lalala"+insql+"lalla");
				baseJdbc.update(insql);
			}
		}
		

		//返回值
		sql = "select no,sappzh from uf_clwlpzhxmxx where requestid = '"+requestid+"' order by no asc";
		List list1 = baseJdbc.executeSqlForList(sql);
		JSONArray jsonArray = new JSONArray();
		if(list1.size()>0)
		{
			for(int m = 0;m<list1.size();m++)
			{
				Map map1 = (Map)list1.get(m);
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("sno", StringHelper.null2String(map1.get("no")));//序号
				jsonObject.put("sappzh", StringHelper.null2String(map1.get("sappzh")));//SAP凭证号
				jsonArray.add(jsonObject);
			}
		}	
		//JSONObject jo = new JSONObject();
	

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jsonArray.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
%>