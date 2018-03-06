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
	String sql = "select t.objname,t.id,a.contacttype,a.conenddate,a.objnum,c.orgid,c.objname as  name ,d.objname as deptname ,c.extmrefobjfield9 ,c.extrefobjfield4 ,c.extdatefield0,c.extmrefobjfield8  from v_uf_hr_contract a ,humres t,humres c,orgunit d where c.id=a.objnum and d.id=c.orgid and instr(t.station,(select b.mstationid from orgunit b where b.id in (select h.extmrefobjfield7  from humres h where h.id =a.objnum)))>0 ";	
	String err="";	
	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start HTXQ......");
		for(int i = 0; i < list.size(); i++){
			Map map = (Map)list.get(i);

			String leaderid = StringHelper.null2String(map.get("id")); 
			String objnum=StringHelper.null2String(map.get("objnum"));
			String contacttype=StringHelper.null2String(map.get("contacttype"));
			String conenddate=StringHelper.null2String(map.get("conenddate"));
			String orgid = StringHelper.null2String(map.get("orgid")); 
			String objname=StringHelper.null2String(map.get("objnum"));
			String extmrefobjfield9=StringHelper.null2String(map.get("extmrefobjfield9"));
			String extrefobjfield4=StringHelper.null2String(map.get("extrefobjfield4"));
			String extdatefield0=StringHelper.null2String(map.get("extdatefield0"));
			String extmrefobjfield8=StringHelper.null2String(map.get("extmrefobjfield8"));
			String name=StringHelper.null2String(map.get("name"));
			String deptname=StringHelper.null2String(map.get("deptname"));
			String formula="HTGLYYYYMM";
			 Date newdate = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
            SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
            SimpleDateFormat sdf2 = new SimpleDateFormat("dd");

            formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
            formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
            formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
            formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));

           String o = NumberHelper.getSequenceNo("40285a9049d58e9e0149e4649f043ef0", 5);
                 
       	   String flowno= formula+o;
			//String flowno = getNo("HTGLYYYYMM","40285a9049d58e9e0149e4649f043ef0",5);
			if(!leaderid.equals("")){
					WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
					RequestInfo rs=new RequestInfo();
					rs.setCreator(leaderid); 
					rs.setTypeid("40285a90490d16a301492bad27f74f8d");
					rs.setIssave("1"); 
					Dataset data=new Dataset();
					List<Cell> list1=new ArrayList<Cell>();
					Cell cell1=new Cell();
					cell1.setName("reqman");
					cell1.setValue(leaderid);
					list1.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("title");
					cell1.setValue(flowno+"-"+name+"-"+deptname);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("flowno");
					cell1.setValue(flowno);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("objnum");
					cell1.setValue(objnum);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("defaultcontract");
					cell1.setValue(contacttype);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("defaultdate");
					cell1.setValue(conenddate);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("objname");
					cell1.setValue(objname);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("Objdept");
					cell1.setValue(orgid);
					list1.add(cell1);
					cell1=new Cell();
					
					cell1.setName("Objcom");
					cell1.setValue(extmrefobjfield9);
					list1.add(cell1);
					cell1=new Cell();	
					
					cell1.setName("Objunit");
					cell1.setValue(extrefobjfield4);
					list1.add(cell1);
					cell1=new Cell();
					
					cell1.setName("Entrydate");
					cell1.setValue(extdatefield0);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("twpdept");
					cell1.setValue(extmrefobjfield8);
					list1.add(cell1);

					data.setMaintable(list1);
					rs.setData(data);
					workflowServiceImpl.createRequest(rs);	
				}
			}
		}	
			
        System.out.println("auto END HTQX......");
		System.out.println(list.size());
	JSONObject jo=new JSONObject();
	jo.put("msg","true");
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();		
%>
