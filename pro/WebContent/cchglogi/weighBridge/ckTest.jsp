<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.sap.conn.jco.JCoStructure" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	
	String sql = "select v.requestid,v.flowno,v.objanme,v.jobno,v.inorder,v.dept,v.onedept,v.twodept,v.company,v.comtype,v.acdocno,v.comcode,v.fiscalyear,v.currency,v.mon,v.paydate,v.titletext,v.itemtext from v_uf_fn_paynotice v";
	
	String err="";	
    String passpsn="";
	String failpsn="";
	
	JSONObject jo = new JSONObject();	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start PayNotice.....");
		for(int i = 0; i < list.size(); i++){
		    if(i==1){
				break;
			}
			Map map = (Map)list.get(i);
			String requestid = StringHelper.null2String(map.get("requestid"));
			String flowno = StringHelper.null2String(map.get("flowno"));
			String objanme = StringHelper.null2String(map.get("objanme"));
			String jobno = StringHelper.null2String(map.get("jobno"));
			String inorder = StringHelper.null2String(map.get("inorder"));
			String dept = StringHelper.null2String(map.get("dept"));
			String onedept = StringHelper.null2String(map.get("onedept"));
			String twodept = StringHelper.null2String(map.get("twodept"));
			String company = StringHelper.null2String(map.get("company"));
			String comtype = StringHelper.null2String(map.get("comtype"));
			String acdocno = StringHelper.null2String(map.get("acdocno"));
			String comcode = StringHelper.null2String(map.get("comcode"));
			String fiscalyear = StringHelper.null2String(map.get("fiscalyear"));
			String currenc = StringHelper.null2String(map.get("currency"));
			String mon = StringHelper.null2String(map.get("mon"));
			String paydate = StringHelper.null2String(map.get("paydate"));
			String titletext = StringHelper.null2String(map.get("titletext"));
			String itemtext = StringHelper.null2String(map.get("itemtext"));
			

			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_FI_INORDER_PAY";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			//function.getImportParameterList().setValue("BUKRS",comcode);
			//function.getImportParameterList().setValue("AUFNR",inorder);
			//function.getImportParameterList().setValue("BELNR",acdocno);
			//function.getImportParameterList().setValue("GJAHR",fiscalyear);
			function.getImportParameterList().setValue("BUKRS","1010");
			function.getImportParameterList().setValue("AUFNR","SC1162");
			function.getImportParameterList().setValue("BELNR","1100001401");
			function.getImportParameterList().setValue("GJAHR","2014");

			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				
				JCoTable tab = function.getTableParameterList().getTable("FI_INORDER_PAY");

				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				String paycurrency = StringHelper.null2String(tab.getValue("WAERS")); 
				String paymon = StringHelper.null2String(tab.getString("PYAMT"));  				
				String comcode2 = StringHelper.null2String(tab.getString("BUKRS")); 
				String mon2 = StringHelper.null2String(tab.getString("WRBTR"));				
				String inorder2 = StringHelper.null2String(tab.getString("AUFNR"));  
				String itemtext2 = StringHelper.null2String(tab.getString("SGTXT")); 
				String acdocno2 = StringHelper.null2String(tab.getString("BELNR"));
				String titletext2 = StringHelper.null2String(tab.getString("BKTXT")); 
				String paycreditno = StringHelper.null2String(tab.getString("VBLNR")); 
				String hs = StringHelper.null2String(tab.getString("BUZEI"));
				String fiscalyear2 = StringHelper.null2String(tab.getString("GJAHR"));
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
				//System.out.println("i="+i+ " LAUFD="+ret.getString("LAUFD")+" WAERS="+ret.getString("WAERS")+" PYAMT="+ret.getString("PYAMT") + " BUKRS="+ret.getString("BUKRS") +"  WRBTR="+ret.getString("WRBTR") +" AUFNR="+ret.getString("AUFNR") + " SGTXT="+ret.getString("SGTXT") + " BELNR="+ret.getString("BELNR")+" BKTXT="+ret.getString("BKTXT") + "  VBLNR="+ret.getString("VBLNR") +" BUZEI="+ret.getString("BUZEI") + " GJAHR="+ret.getString("GJAHR"));
				//}
		}
		System.out.println("auto end PayNotice.....");
	}else{
		err="0";
	}
	if(err.equals("")){			
		jo.put("msg","true");
	}else{
		jo.put("msg","false");
		jo.put("err",err);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
