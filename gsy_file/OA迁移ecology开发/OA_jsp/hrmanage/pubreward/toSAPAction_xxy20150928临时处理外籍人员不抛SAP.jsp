<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable"%>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	
	String sql = "select jcjxy,flowno,comtype from uf_hr_monthreward where requestid='"+requestid+"'";
	List tlist = baseJdbc.executeSqlForList(sql);
	JSONObject jo = new JSONObject();
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String theMonth = StringHelper.null2String(map.get("jcjxy"));//生效月份
        String flowno =  StringHelper.null2String(map.get("flowno"));//申请单号
		String comtype = StringHelper.null2String(map.get("comtype"));//厂区别
        //System.out.println("flowno="+flowno +" theMonth="+theMonth);
		theMonth = theMonth.replace("-", "");
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT9001_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("MONTH",theMonth);
		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT9001");
		sql = "select sapid,pubresult,tosap,classtype,id from uf_hr_monthrewardsub where requestid='"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
        
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map m = (Map)list.get(i);
				String sapid = StringHelper.null2String(m.get("sapid"));
				String pubid = StringHelper.null2String(m.get("pubresult"));  
				String tosap = StringHelper.null2String(m.get("tosap"));
				String classtype = StringHelper.null2String(m.get("classtype"));
				String id = StringHelper.null2String(m.get("id"));
				if(comtype.equals("4028804d2083a7ed012083ebb988005b") && (classtype.equals("40285a8f489c17ce0148f371f98a6740") || classtype.equals("40285a8f489c17ce0148f371f98a6741") ) ){
					tosap = "40288098276fc2120127704884290211";
					String tosapupsql = "update uf_hr_monthrewardsub set tosap='"+tosap+"' where id='"+id+"' and requestid='"+requestid+"'";
					System.out.println("upsql="+tosapupsql);		
					baseJdbc.update(tosapupsql);	
				}
				if(tosap.equals("40288098276fc2120127704884290210")){ //需要回写				   
				  if(!pubid.equals("")){
					retTable.appendRow();
					retTable.setValue("PERNR", sapid);
					retTable.setValue("ZETYP", pubid);
					retTable.setValue("ZENUM", flowno);
					System.out.println("PERNR="+sapid +" ZETYP="+pubid+" ZENUM="+flowno);
				  }
				}                
			}
		}
		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			//返回值
			String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
			String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
			String upsql="update uf_hr_monthreward set errmsg='"+MESSAGE+"',tohr='"+MSGTY+"',stateflag='3' where requestid='"+requestid+"'";
			System.out.println("upsql="+upsql);		
			baseJdbc.update(upsql);			
			jo.put("msg","true");
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			jo.put("msg","false");
			e.printStackTrace();
		} catch (Exception e) {
			jo.put("msg","false");
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();		
	}
%>
