<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
 <select id="warnedOperator" name="warnedOperator" onchange="myChange()">
<%
    String objtype = request.getParameter("objtype");
	String objid = request.getParameter("objid");
	String valueid = request.getParameter("valueid");
	ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
	FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
	WorkflowinfoService workflowService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");		
	CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");		
	NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");		
	String formid = "";
	 
	if("1".equals(objtype) && !StringHelper.isEmpty(objid)){
		Workflowinfo winfo = workflowService.get(objid);
		List nodeList = nodeinfoService.getNodelistByworkflowid(winfo.getId());
		int nodeSize= nodeList.size();
		for(int j = 0; j < nodeSize; j ++){
			Nodeinfo ninfo = (Nodeinfo)nodeList.get(j);
		%>
		<option value="<%=ninfo.getId() %>" <%if(ninfo.getId().equals(valueid)){ %>selected<%} %>><%=ninfo.getObjname() %></option>
		<%
		}
		%>
		<option value="0" <%if("0".equals(valueid)){ %>selected<%} %>><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60068") %><!-- 下个节点操作者 --></option>
		<%
	}
	if("0".equals(objtype) && !StringHelper.isEmpty(objid)){
		Category category = categoryService.getCategoryById(objid);
		formid = category.getFormid();
		%>
		<option value="-1"  <%if("-1".equals(valueid)){ %>selected<%} %>><%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006") %><!-- 创建者 --></option>
		<%
	}
	
	%>
						  						   
	
</select>