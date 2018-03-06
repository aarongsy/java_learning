<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase"%>
<%@ page import="com.eweaver.workflow.form.model.FormBase"%>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService"%>
<%@ page import="com.eweaver.base.security.util.PermissionTool"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.interfaces.form.Formdata"%>
<%@ page import="com.eweaver.interfaces.form.FormdataServiceImpl"%>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String idcard=StringHelper.null2String(request.getParameter("idcard"));//身份证号
	String laborname=StringHelper.null2String(request.getParameter("laborname"));//姓名
	String laborcompany=StringHelper.null2String(request.getParameter("laborcompany"));//劳务公司
	String isblacklist=StringHelper.null2String(request.getParameter("isblacklist"));//是否黑名单
	String blackreason=StringHelper.null2String(request.getParameter("blackreason"));//拉黑原因
	String employtype=StringHelper.null2String(request.getParameter("employtype"));//人员类型
	String blackdate=StringHelper.null2String(request.getParameter("blackdate"));//拉黑日期
	String humerid=StringHelper.null2String(request.getParameter("humerid"));//分类创建人id

	StringBuffer buffer = new StringBuffer(512);
	buffer.append("insert into uf_oa_blacklist")
	.append("(id,requestid,name,idcard,company,thetype,blackdate,blackreason,status) values").append("('").append(IDGernerator.getUnquieID()).
	append("',").append("'").append("$ewrequestid$").append("',");
	buffer.append("'").append(laborname).append("',");
	buffer.append("'").append(idcard).append("',");
	buffer.append("'").append(laborcompany).append("',");
	buffer.append("'").append(employtype).append("',");
	buffer.append("'").append(blackdate).append("',");
	buffer.append("'").append(blackreason).append("',");
	buffer.append("'").append(isblacklist).append("')");
	FormBase formBase = new FormBase();
	String categoryid = "40285a8d55c3ffed0155e22c0eaf56d0";
	//创建formbase
	formBase.setCreatedate(DateHelper.getCurrentDate());
	formBase.setCreatetime(DateHelper.getCurrentTime());
	formBase.setCreator(StringHelper.null2String(humerid));
	formBase.setCategoryid(categoryid);
	formBase.setIsdelete(0);
	FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
	formBaseService.createFormBase(formBase);
	String insertSql = buffer.toString();
	insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
	baseJdbc.update(insertSql);
	PermissionTool permissionTool = new PermissionTool();
	permissionTool.addPermission(categoryid,formBase.getId(), "uf_oa_blacklist");
%>
