<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>

<%@ page import="com.eweaver.app.configsap.SapConnector_EN" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	//batchtoSAP   singletoSAP
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	
	response.setContentType("application/json; charset=utf-8");
	JSONObject jsonObject = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	if (action.equals("batchtoSAP")) {	//批量抛SAP
		try {			

			
			//String allowsql = "select * from uf_dmhr_allowdetail where requestid='"+requestid+"' and empsapid='"+empsapid+"' and NVL(msgty,'0')!='I' order by sno asc";
			String allowsql = "select * from uf_dmhr_allowtotal where requestid='"+requestid+"' and NVL(msgty,'0')!='I' order by empsapid asc,sno asc";
			//String allsapcode = "";
			List allowlist = baseJdbcDao.executeSqlForList(allowsql);
			if ( allowlist.size()>0 )  {
				try {
					String functionName = "";
					JCoFunction function = null;
					String errorMessage = "";
				  
					functionName = "ZHR_IT2010_CREATE_MULTI_MY"; //IT2010: 2010 多人
					function = null;
					try {
						function = SapConnector_EN.getRfcFunction(functionName);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					if (function == null) {
						System.out.println(functionName + " not found in SAP.");
						System.out.println("SAP_RFC中没有此函数!");
						errorMessage = functionName + " not found in SAP.";
					}
					
					//function.getImportParameterList().setValue("PERNR", empsapid);
					
					JCoTable jcotable = function.getTableParameterList().getTable("IT_2010");


					
					for ( int j=0;j<allowlist.size();j++ ) {
						Map allowmap = (Map)allowlist.get(j);
						String empsapid = StringHelper.null2String(allowmap.get("empsapid"));
						String otdate = StringHelper.null2String(allowmap.get("otdate"));
						String sapcode = StringHelper.null2String(allowmap.get("sapcode"));
						String nums = StringHelper.null2String(allowmap.get("nums"));
						/*String otapp = StringHelper.null2String(allowmap.get("otapp"));
						if (j==0) {
							allsapcode = "'"+sapcode+"'";
						} else {
							allsapcode = allsapcode + ",'"+sapcode+"'";
						}*/
						jcotable.appendRow();
						jcotable.setValue("DATUM", otdate);
						jcotable.setValue("PERNR", empsapid);
						jcotable.setValue("LGART", sapcode);
						jcotable.setValue("ANZHL", nums);
					}

					try {
						function.execute(SapConnector_EN.getDestination("sanpowersapen"));
						//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
					} catch (JCoException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}	
					JCoTable rejcotable = function.getTableParameterList().getTable("IT_RTNMSG");
					for ( int i = 0; i < rejcotable.getNumRows(); i++ ) {
						rejcotable.setRow(i);
						String reempsapid = rejcotable.getString("PERNR");
						String resapmsg = rejcotable.getString("MESSAGE");
						String resapmsgtype = rejcotable.getString("MSGTY");
						String upsql = "update uf_dmhr_allowtotal  set msgty='"+resapmsgtype+"',message='"+resapmsg+"' where requestid='"+requestid+"' and empsapid='"+reempsapid+"'  and NVL(msgty,'0')!='I'";
						baseJdbcDao.update(upsql);
						upsql = "update uf_dmhr_allowdetail set msgty='"+resapmsgtype+"',message='"+resapmsg+"' where requestid='"+requestid+"' and empsapid='"+reempsapid+"' and NVL(msgty,'0')!='I'";
						baseJdbcDao.update(upsql);
						//errorMessages.add("TYPE:"+jcoTable1.getString("TYPE")+" MESSAGE:"+jcoTable1.getString("MESSAGE")); 
					}
					String subsql = "select * from uf_dmhr_allowdetail where requestid='"+requestid+"'";
					List sublist = baseJdbcDao.executeSqlForList(subsql);
					if ( sublist.size()>0 ) {
						for ( int k=0;k<sublist.size();k++ ) {
							Map submap = (Map)sublist.get(k);
							String otapp = StringHelper.null2String(submap.get("otapp"));
							String msgty = StringHelper.null2String(submap.get("msgty"));
							String message = StringHelper.null2String(submap.get("message"));
							String allowcode = StringHelper.null2String(submap.get("allowcode"));
							String subupsql = "update uf_dmhr_otappsub set msgty='"+msgty+"',message='"+message+"' where requestid='"+otapp+"' and sapcode='"+allowcode+"'";
							baseJdbcDao.update(subupsql);
						}
					}	
					jsonObject.put("info","");
					jsonObject.put("sapflag","");
					jsonObject.put("msg","true");
				} catch (Exception e) {
					e.printStackTrace();
					jsonObject.put("info",e.getMessage());
					jsonObject.put("sapflag","");
					jsonObject.put("msg","false");				
				}
			}else{
				jsonObject.put("info","\'OT IT2010 Allowance Total\' tosap success already, no need to tosap! ");
				jsonObject.put("sapflag","");
				jsonObject.put("msg","false");
			}
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
			jsonObject.put("info",e.getMessage());
			jsonObject.put("sapflag","");
			jsonObject.put("msg","false");				
		}

		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
	
	if (action.equals("singletoSAP")) { //单个抛SAP
		//String requestid = StringHelper.null2String(request.getParameter("requestid"));
		String empsapid = StringHelper.null2String(request.getParameter("empsapid"));
		String sapcode = StringHelper.null2String(request.getParameter("sapcode"));
		String otdate = StringHelper.null2String(request.getParameter("otdate"));
		String nums = StringHelper.null2String(request.getParameter("nums"));
		try {
			String functionName = "";
			JCoFunction function = null;
			String errorMessage = "";
		  
			functionName = "ZHR_IT2010_CREATE_MY"; //IT2010: 2010 Create-Malaysia
			function = null;
			try {
				function = SapConnector_EN.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if (function == null) {
				System.out.println(functionName + " not found in SAP.");
				System.out.println("SAP_RFC中没有此函数!");
				errorMessage = functionName + " not found in SAP.";
			}
			
			function.getImportParameterList().setValue("PERNR", empsapid);
			
			JCoTable jcotable = function.getTableParameterList().getTable("IT_2010");
			jcotable.appendRow();
			jcotable.setValue("DATUM", otdate);
			jcotable.setValue("PERNR", empsapid);
			jcotable.setValue("LGART", sapcode);
			jcotable.setValue("ANZHL", nums);
			
			try {
				function.execute(SapConnector_EN.getDestination("sanpowersapen"));
				//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
	
			//返回值
			String sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
			String sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();
			if ( "I".equals(sapmsgtype) ){
				String upsql = "update uf_dmhr_allowtotal  set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"' and empsapid='"+empsapid+"'  and NVL(msgty,'0')!='I' and sapcode='"+sapcode+"'";
				baseJdbcDao.update(upsql);
				//upsql = "update uf_dmhr_otappsub set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where  requestid in (select otapp from  uf_dmhr_allowdetail where  requestid='"+requestid+"' and empsapid='"+empsapid+"'  and NVL(msgty,'0')!='I' and allowcode='"+sapcode+"' and NVL(msgty,'0')!='I' ";
				//baseJdbcDao.update(upsql);
				upsql = "update uf_dmhr_allowdetail  set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"' and empsapid='"+empsapid+"'  and NVL(msgty,'0')!='I' and allowcode='"+sapcode+"'";
				baseJdbcDao.update(upsql);	
				String subsql = "select * from uf_dmhr_allowdetail where requestid='"+requestid+"' and empsapid='"+empsapid+"'";
				List sublist = baseJdbcDao.executeSqlForList(subsql);
				if ( sublist.size()>0 ) {
					for ( int k=0;k<sublist.size();k++ ) {
						Map submap = (Map)sublist.get(k);
						String otapp = StringHelper.null2String(submap.get("otapp"));
						String msgty = StringHelper.null2String(submap.get("msgty"));
						String message = StringHelper.null2String(submap.get("message"));
						String allowcode = StringHelper.null2String(submap.get("allowcode"));
						String subupsql = "update uf_dmhr_otappsub set msgty='"+msgty+"',message='"+message+"' where requestid='"+otapp+"' and sapcode='"+allowcode+"'";
						baseJdbcDao.update(subupsql);
					}
				}
				jsonObject.put("info",sapmsg);
				jsonObject.put("sapflag",sapmsgtype);	
				jsonObject.put("msg","true");
			} else {
				String upsql = "update uf_dmhr_allowtotal  set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"' and empsapid='"+empsapid+"'  and NVL(msgty,'0')!='I' and sapcode='"+sapcode+"'";
				baseJdbcDao.update(upsql);
				//upsql = "update uf_dmhr_otappsub set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where  requestid in (select otapp from  uf_dmhr_allowdetail where  requestid='"+requestid+"' and empsapid='"+empsapid+"'  and NVL(msgty,'0')!='I' and allowcode='"+sapcode+"' and NVL(msgty,'0')!='I'";
				//baseJdbcDao.update(upsql);
				upsql = "update uf_dmhr_allowdetail  set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"' and empsapid='"+empsapid+"'  and NVL(msgty,'0')!='I' and allowcode='"+sapcode+"'";
				baseJdbcDao.update(upsql);	
				String subsql = "select * from uf_dmhr_allowdetail where requestid='"+requestid+"' and empsapid='"+empsapid+"'";
				List sublist = baseJdbcDao.executeSqlForList(subsql);
				if ( sublist.size()>0 ) {
					for ( int k=0;k<sublist.size();k++ ) {
						Map submap = (Map)sublist.get(k);
						String otapp = StringHelper.null2String(submap.get("otapp"));
						String msgty = StringHelper.null2String(submap.get("msgty"));
						String message = StringHelper.null2String(submap.get("message"));
						String allowcode = StringHelper.null2String(submap.get("allowcode"));
						String subupsql = "update uf_dmhr_otappsub set msgty='"+msgty+"',message='"+message+"' where requestid='"+otapp+"' and sapcode='"+allowcode+"'";
						baseJdbcDao.update(subupsql);
					}
				}				
				jsonObject.put("info",sapmsg);
				jsonObject.put("sapflag",sapmsgtype);	
				jsonObject.put("msg","false");
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("info",e.getMessage());
			jsonObject.put("sapflag","");
			jsonObject.put("msg","false");				
		}	
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();	
		
	}
%>