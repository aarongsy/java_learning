<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%


	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	
	//test：2014-08-13 //sysdate代替 评核日期提前15天创建评核申请单
	String sql = "select t.objname,t.id from v_uf_hr_contract a ,humres t where instr(t.station,(select b.mstationid from orgunit b where b.id in (select h.extmrefobjfield7   from humres h where h.id =a.objnum)))>0 group by t.id,t.objname ";	

	
	String err="";	

 	
	JSONObject jo = new JSONObject();
	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start SYPH......");
		for(int i = 0; i < list.size(); i++){
			Map map = (Map)list.get(i);

			String leaderid = StringHelper.null2String(map.get("id")); 

			if(leaderid.equals("")){
				err ="1";
				
			}else if(leaderid.equals("null")){
				err ="1";
				
			}else{
				WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
				RequestInfo rs=new RequestInfo();
				rs.setCreator(leaderid); 
				rs.setTypeid("40285a904a8073af014a8463b5b22c71");
				rs.setIssave("1"); 
				Dataset data=new Dataset();
				List<Cell> list1=new ArrayList<Cell>();
				Cell cell1=new Cell();
				cell1.setName("reqname");
				cell1.setValue(leaderid);
				list1.add(cell1);				
				
				cell1=new Cell();		
				cell1.setName("reqdate");
				cell1.setValue("123");
				list1.add(cell1);
				
				cell1=new Cell();		
				cell1.setName("reqdept");
				cell1.setValue("123");
				list1.add(cell1);

					data.setMaintable(list1);
					rs.setData(data);
					workflowServiceImpl.createRequest(rs);	
				}
			}
		}
		
		jo.put("msg",err);	
	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();		
%>
