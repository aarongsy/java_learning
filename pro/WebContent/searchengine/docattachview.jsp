<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.log.service.LogService"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.document.base.servlet.DocbaseAction" %>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjlinkService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjlink"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.remark.service.*"%>
<%@ page import="com.eweaver.document.remark.model.*"%>
<%@ page import="com.eweaver.base.log.model.Log" %>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%
	String id = StringHelper.null2String(request.getParameter("docid"));
	String attachid = StringHelper.null2String(request.getParameter("attachid"));
	String model = StringHelper.null2String(request.getParameter("model"));
	
	PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext
			.getBean("permissiondetailService");
	DocborrowService docborrowService = (DocborrowService) BaseContext
			.getBean("docborrowService");
	CategoryService categoryService = (CategoryService) BaseContext
			.getBean("categoryService");
	DocbaseService docbaseService = (DocbaseService) BaseContext
			.getBean("docbaseService");
	OrgunitService orgunitService = (OrgunitService) BaseContext
			.getBean("orgunitService");
	AttachService attachService = (AttachService) BaseContext
			.getBean("attachService");
	HumresService humresService = (HumresService) BaseContext
			.getBean("humresService");
	RemarkService remarkService = (RemarkService) BaseContext
			.getBean("remarkService");
	LogService logService = (LogService) BaseContext
			.getBean("logService");
	SetitemService setitemService = (SetitemService) BaseContext
			.getBean("setitemService");
	
	if (!StringHelper.isEmpty(model)&&"del".equals(model)) {
	    response.sendRedirect(request.getContextPath()
					+ "/nopermit1.jsp");
	    return;
	}
	
	/*文档借阅功能(start)*/
	boolean opttype = permissiondetailService.checkOpttype(id,OptType.VIEW);
	if(!opttype){
		if(setitemService.enableDocBorrow()){//开始了文档借阅流程,执行文档借阅
			boolean inBorrowDateTime = docborrowService.hasPermit(id, currentuser.getId()); //是否在借阅的时间段内
			if(!inBorrowDateTime){	//不在借阅的时间段内(跳转到借阅页面,走借阅流程)
				response.sendRedirect("gotoworkflow.jsp?docid=" + id);
				return;
			}
		}else{	//到没有权限提示页面
			response.sendRedirect(request.getContextPath()
					+ "/nopermit.jsp");
			return;
		}
	}else{
		response.sendRedirect(request.getContextPath()
					+ "/ServiceAction/com.eweaver.document.file.FileDownload?docid="+id+"&attachid="+attachid);
	}
	/*文档借阅功能(end)*/
	
%>