<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.WorkflowpreService"%>
<%@ page import="java.net.URLEncoder"%>

<%

	String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
	String formid = StringHelper.null2String(request.getParameter("formid"));
	String viewmode = StringHelper.null2String(request.getParameter("viewmode"));
	String isapprove = StringHelper.null2String(request.getParameter("isapprove"));
	String snames = StringHelper.null2String(request.getParameter("snames"));
	String svalues = StringHelper.null2String(request.getParameter("svalues"));
	String paranames = StringHelper.null2String(request.getParameter("pnames"));
	String paravalues = StringHelper.null2String(request.getParameter("pvalues"));
	String targeturl = StringHelper.null2String(request.getParameter("targeturl"));
	
	if(!StringHelper.isID(workflowid))
		return;
	
	ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
	WorkflowpreService workflowpreService = (WorkflowpreService) BaseContext.getBean("workflowpreService");
	
	WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
	Workflowinfo workflowinfo = (Workflowinfo)workflowinfoService.get(workflowid);
		
	if(StringHelper.isEmpty(formid)){
		formid = workflowinfo.getFormid();
	}
	
	Forminfo forminfo = (Forminfo)forminfoService.getForminfoById(formid);
	
	String objtablename = StringHelper.null2String(forminfo.getObjtablename());
	
	ArrayList paranamelist = StringHelper.string2ArrayList2(paranames,",");
	ArrayList paravaluelist = StringHelper.string2ArrayList2(paravalues,",");
	String urlstr = "";
	for(int i=0;i<paranamelist.size();i++){
		String paraname = StringHelper.null2String((String)paranamelist.get(i)).trim();
		String paravalue = StringHelper.null2String((String)paravaluelist.get(i)).trim();
		
		if(!StringHelper.isEmpty(paraname) && !StringHelper.isEmpty(paravalue)){
			urlstr += "&"+paraname+"="+URLEncoder.encode(paravalue,"UTF-8");
		}
	}
	
	String approveobjid = "";
	String approveobjvalue= "";
	
	
	
	ArrayList snamelist = StringHelper.string2ArrayList2(snames,",");
	ArrayList svaluelist = StringHelper.string2ArrayList2(svalues,",");
	
	for(int i=0;i<snamelist.size();i++){
		String paraname = StringHelper.null2String((String)snamelist.get(i)).trim();
		String paravalue = StringHelper.null2String((String)svaluelist.get(i)).trim();
		
		if(!StringHelper.isEmpty(paraname) && !StringHelper.isEmpty(paravalue)){
			urlstr += "&"+paraname+"="+URLEncoder.encode(paravalue,"UTF-8");
			
			if(isapprove.equals("1")&&paraname.equals("objid")){
				approveobjid = StringHelper.null2String(workflowinfo.getApproveobj());
				approveobjvalue = paravalue;
			}
		}
	}
	
	String requestid = "";
	if(isapprove.equals("1")){
		if(StringHelper.isID(approveobjid)){
			FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
			Formfield formfield = formfieldService.getFormfieldById(approveobjid);
			String fieldname = StringHelper.null2String(formfield.getFieldname());
	
			requestid = workflowpreService.getRequestbaseIDByParas(objtablename,fieldname,approveobjvalue);	
		}	
	}else if(!StringHelper.isEmpty(snames)){
	    
		requestid = workflowpreService.getRequestbaseIDByParas(objtablename,snames,svalues);	
	}   
	
	
	response.sendRedirect(request.getContextPath()+"/workflow/request/workflow.jsp?workflowid="+workflowid+"&requestid="+requestid+"&viewmode="+viewmode+"&isapprove="+isapprove+urlstr+"&targeturl="+targeturl);
	return;

%>