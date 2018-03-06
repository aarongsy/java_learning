<%@ page contentType="text/html; charset=UTF-8"%>
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

<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.BaseContext"%>

<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>


<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户

	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	//String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String action=StringHelper.null2String(request.getParameter("action"));
	String roleid=StringHelper.null2String(request.getParameter("roleid"));

	String err="";	
	JSONObject jo = new JSONObject();	
	
	if ( "audit".equals(action) ) {
		int existflag = Integer.parseInt(ds.getValue("select count(userid) num from sysuserrolelink where roleid='"+roleid+"' and userid=(select id from sysuser where objid='"+userid+"')"));
		if ( existflag==0 ) {	//当前登录人没有出口委托书审核权限
			err = "1";
		} else {
			String sql=StringHelper.null2String(request.getParameter("sql"));
			System.out.println(" sql="+sql);
			baseJdbcDao.update(sql);	
		}	
		
		if(err.equals("")){			
			jo.put("msg","true");
			//jo.put("existflag",existflag);
		}else{
			jo.put("msg","false");
			jo.put("err",err);
			//jo.put("existflag",existflag);
		}			
	}
	
	if ( "update".equals(action) ) {
		String sql=StringHelper.null2String(request.getParameter("sql"));
		System.out.println(" sql="+sql);
		baseJdbcDao.update(sql);
	}	

	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
