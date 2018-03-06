<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="/base/initnoscript.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="java.net.URLEncoder"%>


<%

	String formid = StringHelper.null2String(request.getParameter("formid"));
	String id = StringHelper.null2String(request.getParameter("id"));
	String layoutid = StringHelper.null2String(request.getParameter("layoutid"));
	String isview = StringHelper.null2String(request.getParameter("isview"));

	//新建文档的ｔａｒｇｅｔｕｒｌ
	String targeturlfordoc = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=";
	
	Map initparameters = new HashMap();
	for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
		String pName = e.nextElement().toString().trim();
		String pValue = StringHelper.trimToNull(request.getParameter(pName));
		if(!StringHelper.isEmpty(pName))
			initparameters.put(pName,pValue);
	}
	FormService fs = (FormService)BaseContext.getBean("formService");
	
	String formcontent ="";
	Map parameters = new HashMap();
	
	parameters.put("bWorkflowform","0");
	parameters.put("isview",isview);
	parameters.put("formid",formid);
	parameters.put("objid",id);
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);
	
	parameters = fs.WorkflowView(parameters);		

	formcontent = StringHelper.null2String(parameters.get("formcontent"));
	
%>
<%=formcontent%>
