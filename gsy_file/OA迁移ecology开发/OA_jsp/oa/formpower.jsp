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
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.workflow.form.model.FormBase"%>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService"%>
<%@ page import="com.eweaver.base.security.util.PermissionTool"%>
<%@ page import="com.eweaver.app.configsap.SapSync"%>


<%
    //System.out.println("哈哈哈哈哈哈哈哈哈哈哈哈哈哈!");
	String driverid=StringHelper.null2String(request.getParameter("driverid"));//司机(证件号)
	String id1=StringHelper.null2String(request.getParameter("id1"));//证件号一  
	String id2=StringHelper.null2String(request.getParameter("id2"));//证件号二
	String id3=StringHelper.null2String(request.getParameter("id3"));//证件号三
	String id4=StringHelper.null2String(request.getParameter("id4"));//证件号四
	String driver=StringHelper.null2String(request.getParameter("driver"));//司机
	String person1=StringHelper.null2String(request.getParameter("person1"));//随行人员(一)
	String person2=StringHelper.null2String(request.getParameter("person2"));//随行人员(二)
	String person3=StringHelper.null2String(request.getParameter("person3"));//随行人员(三)
	String person4=StringHelper.null2String(request.getParameter("person4"));//随行人员(四)
	String driverstate=StringHelper.null2String(request.getParameter("driverstate"));//司机(状态)
	if(driverstate.equals(""))
	{
		driverstate="40285a8d54317ae00154363d18652fb6";
	}
	String state1=StringHelper.null2String(request.getParameter("state1"));//状态(一)
	if(state1.equals(""))
	{
		state1="40285a8d54317ae00154363d18652fb6";
	}
	String state2=StringHelper.null2String(request.getParameter("state2"));//状态(二)
	if(state2.equals(""))
	{
		state2="40285a8d54317ae00154363d18652fb6";
	}
	String state3=StringHelper.null2String(request.getParameter("state3"));//状态(三)
	if(state3.equals(""))
	{
		state3="40285a8d54317ae00154363d18652fb6";
	}
	String state4=StringHelper.null2String(request.getParameter("state4"));//状态(四)
	if(state4.equals(""))
	{
		state4="40285a8d54317ae00154363d18652fb6";
	}
	String infac=StringHelper.null2String(request.getParameter("infac"));//进厂人数
	String atfac=StringHelper.null2String(request.getParameter("atfac"));//在厂人数
	String outfac=StringHelper.null2String(request.getParameter("outfac"));//离厂人数
	String facintime=StringHelper.null2String(request.getParameter("facintime"));//入厂登记时间  
	String facouttime=StringHelper.null2String(request.getParameter("facouttime"));//离厂登记时间  
	String man1=StringHelper.null2String(request.getParameter("man1"));//登记人员 
	String man2=StringHelper.null2String(request.getParameter("man2"));//修改人员
	String company=StringHelper.null2String(request.getParameter("company"));//所属公司(承运商)  
	String comtype=StringHelper.null2String(request.getParameter("comtype"));//公司别 
	String createtime=StringHelper.null2String(request.getParameter("createtime"));//创建提入单日期参数
	String carno=StringHelper.null2String(request.getParameter("carno"));//车牌号参数
	String loadno=StringHelper.null2String(request.getParameter("loadno"));//装卸计划号参数
	//String ladno=StringHelper.null2String(request.getParameter("ladno"));//提单号
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");


	//同一天、同一车牌、不同装卸计划号来过滤  
	String xsql="select * from v_oa_inoutfactory where createtime='"+createtime+"' and carno='"+carno+"' and loadingno<>'"+loadno+"'";
	List xlist = baseJdbc.executeSqlForList(xsql);
	if(xlist.size()>0)
	{
		//System.out.println("X2");
		for(int i=0;i<xlist.size();i++)
		{
			//System.out.println("X3");
			Map mp = (Map)xlist.get(i);
			String tmp1=StringHelper.null2String(mp.get("loadingno"));//装卸计划号
			String tmp2=StringHelper.null2String(mp.get("descofloc"));//仓库名称
			String tmp3=StringHelper.null2String(mp.get("printtime"));//提入单打印时间
			String tmp4=StringHelper.null2String(mp.get("factory"));//厂区别
			String tmp5=StringHelper.null2String(mp.get("ladingno"));//提入单号
			String tmp6=StringHelper.null2String(mp.get("carno"));//车牌号码 
			String tmp7=StringHelper.null2String(mp.get("createtime"));//提入单创建时间
			String sinstate=StringHelper.null2String(mp.get("sinstate"));

			//以下为向指定表及formbase中插入数据的代码(同时 解决权限重构问题)
			StringBuffer buffer = new StringBuffer(512);
			buffer.append("insert into uf_oa_inoutfreight").append("(id,requestid,handplanno,depotname,printime,factype,singleno,carno,idcard1,idcard2,idcard3,idcard4,inregistime,outregistime,registerman,modifyman,company,comtype,attendant1,attendant2,attendant3,attendant4,licensenum,driver,createtime,parmcarno,parmno,infactorynum,atfactorynum,outfactorynum,driverstate,state1,state2,state3,state4,sinstate) values").append("('").append(IDGernerator.getUnquieID()).
			append("',").append("'").append("$ewrequestid$").append("',");

			buffer.append("'").append(tmp1).append("',");
			buffer.append("'").append(tmp2).append("',");
			buffer.append("'").append(tmp3).append("',");
			buffer.append("'").append(tmp4).append("',");
			buffer.append("'").append(tmp5).append("',");
			buffer.append("'").append(tmp6).append("',");
			buffer.append("'").append(id1).append("',");
			buffer.append("'").append(id2).append("',");
			buffer.append("'").append(id3).append("',");
			buffer.append("'").append(id4).append("',");
			buffer.append("'").append(facintime).append("',");
			buffer.append("'").append(facouttime).append("',");
			buffer.append("'").append(man1).append("',");
			buffer.append("'").append(man2).append("',");
			buffer.append("'").append(company).append("',");
			buffer.append("'").append(comtype).append("',");
			buffer.append("'").append(person1).append("',");
			buffer.append("'").append(person2).append("',");
			buffer.append("'").append(person3).append("',");
			buffer.append("'").append(person4).append("',");
			buffer.append("'").append(driverid).append("',");
			buffer.append("'").append(driver).append("',");
			buffer.append("'").append(tmp7).append("',");
			buffer.append("'").append(tmp6).append("',");
			buffer.append("'").append(tmp1).append("',");
			buffer.append("'").append(infac).append("',");
			buffer.append("'").append(atfac).append("',");
			buffer.append("'").append(outfac).append("',");
			buffer.append("'").append(driverstate).append("',");
			buffer.append("'").append(state1).append("',");
			buffer.append("'").append(state2).append("',");
			buffer.append("'").append(state3).append("',");
			buffer.append("'").append(state4).append("',");
			buffer.append("'").append(sinstate).append("')");

			FormBase formBase = new FormBase();
			//分类属性中的id
			String categoryid = "40285a8d53ca0f480153d107196b0355";
			//创建formbase
			formBase.setCreatedate(DateHelper.getCurrentDate());
			formBase.setCreatetime(DateHelper.getCurrentTime());
			formBase.setCreator("402881e70be6d209010be75668750014");
			formBase.setCategoryid(categoryid);
			formBase.setIsdelete(0);
			FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
			formBaseService.createFormBase(formBase);
			String insertSql = buffer.toString();
			insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
			System.out.println(insertSql);
			baseJdbc.update(insertSql);
			PermissionTool permissionTool = new PermissionTool();
			permissionTool.addPermission(categoryid,formBase.getId(),"uf_oa_inoutfreight");
		}
	}
	  JSONObject jo = new JSONObject();		
	  response.setContentType("application/json; charset=utf-8");
	  response.getWriter().write(jo.toString());
	  response.getWriter().flush();
	  response.getWriter().close();
%>
