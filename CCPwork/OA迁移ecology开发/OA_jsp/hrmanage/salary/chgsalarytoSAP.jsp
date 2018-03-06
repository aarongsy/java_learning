<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>

<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if (action.equals("toSap")){
		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//流程Id
		String failflag = "";
		String failinfo = "";
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		JSONObject jo = new JSONObject();
		String sql = "select b.id,b.sapid,a.month,(select objdesc from selectitem where id=b.salaryitem) salaryitem,b.money from uf_hr_salaryexception a,uf_hr_salaryexcepsub b where a.requestid=b.requestid and a.requestid='"+requestid+"' and (b.msgtype is null or b.msgtype!='I')";
		System.out.println(sql);		
		List sublist = baseJdbc.executeSqlForList(sql);
		if(sublist.size()>0){
			for(int i=0;i<sublist.size();i++){
				Map submap = (Map)sublist.get(i);
				String theid = StringHelper.null2String(submap.get("id"));//子表ID
				String sapid = StringHelper.null2String(submap.get("sapid"));//员工SAP编号
				String month = StringHelper.null2String(submap.get("month"));//薪资月
				String salaryitem = StringHelper.null2String(submap.get("salaryitem"));//薪资项
				String money = StringHelper.null2String(submap.get("money"));//调整金额
				
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT0015_S1_CREATE";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					jo.put("msg","false");
					jo.put("failinfo","连接SAP出错！");
				}
				//插入字段
				function.getImportParameterList().setValue("PERNR",sapid);
				function.getImportParameterList().setValue("MONTH",month);				
				function.getImportParameterList().setValue("LGART",salaryitem);
				function.getImportParameterList().setValue("BETRG",money);
				function.getImportParameterList().setValue("WAERS","");

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));					
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					jo.put("msg","false");
					jo.put("failinfo","执行ZHR_IT0015_S1_CREATE出错！");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					jo.put("msg","false");
					jo.put("failinfo","执行ZHR_IT0015_S1_CREATE出错Exception！");
					e.printStackTrace();
				}

				//返回值
				String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
				String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
				String upsql="update uf_hr_salaryexcepsub set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where id='"+theid+"'";
				baseJdbc.update(upsql);
				System.out.println(upsql);		
				if("E".equals(MSGTY)){
					failflag = "E";
					failinfo = failinfo +";"+sapid+" " +MESSAGE;					
				}
			}
			sql = "select * from uf_hr_salaryexcepsub where requestid='"+requestid+"' and (msgtype is null or msgtype!='I')";
			List list = baseJdbc.executeSqlForList(sql);
			String upsql2 = "";
			if(list.size()>0){
				upsql2 = "update uf_hr_salaryexception set message='',msgtype='' where requestid='"+requestid+"'";
				baseJdbc.update(upsql2);
				failflag = "E";
				jo.put("msg","false");
			}else{
				upsql2 = "update uf_hr_salaryexception set message='',msgtype='I' where requestid='"+requestid+"'";
				baseJdbc.update(upsql2);
				failflag = "I";
				jo.put("msg","true");
			}
			jo.put("failinfo",failinfo);
			System.out.println(upsql2);	
			String errsql = "insert into saperror(reqid,msgty) values('" + requestid + "','" + failflag+ "')";
			System.out.println(errsql);		
			baseJdbc.update(errsql);
		}
		else
		{
			jo.put("msg","false");
			jo.put("failinfo","没有需要抛SAP的薪资调整明细！");
		}
		
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
%>