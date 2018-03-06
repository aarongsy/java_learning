<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>


<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>

<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>


<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if(action.equals("getData"))
	{
		String year =StringHelper.null2String(request.getParameter("year"));//所属年份
		String dept =StringHelper.null2String(request.getParameter("dept"));//部门
		String companys =StringHelper.null2String(request.getParameter("company"));//公司
		String psnno =StringHelper.null2String(request.getParameter("psnno"));//员工
		//String requestid = this.requestid;//当前流程requestid 
		EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	 
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		String userId = currentuser.getId();
	//String sql = "select num,type1,type2,buydate,fixname,fixname2,amountTax,amount,spec,fixstyle,supply,yearlife,equipment,buyman,manager,flows from  uf_admin_storage where requestid ='"+requestid+"'";

		String sql = "select a.id,a.objno,a.objname,a.orgid ,a.extmrefobjfield9 from humres a  where  ";  
		//sql = sql +"  (a.objno like 'C0%' or length(translate(a.objno,'0123456789'||a.objno,'0123456789'))=length(a.objno))"; 
		sql = sql +"(a.extselectitemfield11 = '40285a8f489c17ce0148f371f98a6740' or a.extselectitemfield11 = '40285a8f489c17ce0148f371f98a6741')";
		
		if(dept != ""  && companys != "")  
		{  
			sql = sql + "  and ( a.orgid = '"+dept+"' or a.extmrefobjfield9 = '"+companys+"')";  
		}  
		else if(companys != "")  
		{  
			sql = sql +" and a.extmrefobjfield9 = '"+companys+"' ";  
		}  
		else if( dept != "")  
		{  
			sql = sql + " and a.orgid = '"+dept+"'";  
		}  
		if(psnno != "")  
		{  
			sql = sql + " and instr('"+psnno+"',a.id)>0 ";  
		}  
		List list = baseJdbc.executeSqlForList(sql);

		  //循环数据
		if(list.size()>0){
		for(int s=0;s<list.size();s++){
			Map map = (Map)list.get(s);

			String objno = StringHelper.null2String(map.get("id"));//员工工号
			String objname = StringHelper.null2String(map.get("id"));//员工姓名
			String depts = StringHelper.null2String(map.get("orgid"));//员工所属部门
			String company = StringHelper.null2String(map.get("extmrefobjfield9"));//员工所属公司

			String searsql = "select requestid from uf_hr_backstatic where reqno='"+objno+"' and year ='"+year+"'";
			List searlist = baseJdbc.executeSqlForList(searsql);
			if(searlist.size() == 0)
			{
				
				StringBuffer buffer = new StringBuffer(512);
				//String newrequestid = IDGernerator.getUnquieID();
				buffer.append("insert into uf_hr_backstatic   ").append("(id,requestid,reqno,reqname,year,dept,com) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

				buffer.append("'").append(objno).append("',");//员工工号
				buffer.append("'").append(objname).append("',");//员工姓名
				
				buffer.append("'").append(year).append("',");//所属年份
				buffer.append("'").append(depts).append("',");//所属部门
				buffer.append("'").append(company).append("')");//所属公司


				FormBase formBase = new FormBase();
				String categoryid = "40285a90495b4eb0014974bcf6855592";
				//创建formbase
				//formBase.setCreatedate(DateHelper.getCurrentDate());
				//formBase.setCreatetime(DateHelper.getCurrentTime());
				//formBase.setCreator(StringHelper.null2String(userId));
				formBase.setCategoryid(categoryid);
				formBase.setIsdelete(0);
				FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
				formBaseService.createFormBase(formBase);
				String insertSql = buffer.toString();
				insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
				baseJdbc.update(insertSql);
				PermissionTool permissionTool = new PermissionTool();
				permissionTool.addPermission(categoryid,formBase.getId(), "uf_hr_backstatic");	
			}
	       
		}//for end
		}//if end
		//返回值
		String ERR_MSG = "You have successfully generated "+list.size()+" records";
		//String EXCH_RATE = function.getExportParameterList().getValue("EXCH_RATE").toString();
		//String FLAG = function.getExportParameterList().getValue("FLAG").toString();
		
		JSONObject jo = new JSONObject();		
		jo.put("msg", ERR_MSG);
		//jo.put("rate", EXCH_RATE);
		//jo.put("flag", FLAG);

		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}
%>
