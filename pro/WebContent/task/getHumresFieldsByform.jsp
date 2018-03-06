<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%
    String objtype = request.getParameter("objtype");
	String objid = request.getParameter("objid");
	String valueid = request.getParameter("valueid");
	ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
	FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
	WorkflowinfoService workflowService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");		
	CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");		
	String formid = objid;
	
	Forminfo forminfo1 = forminfoService.getForminfoById(formid);
	List forminfolists = new ArrayList();
    if(forminfo1.getObjtype() != null) {   
		if (forminfo1.getObjtype().toString().equals("0")) {//实际表单
			forminfolists.add(forminfo1);
		} else if (forminfo1.getObjtype().toString().equals("1")) {//抽象表单
			StringBuffer hql = new StringBuffer(
					"from Forminfo a  where a.id in (");
			hql.append("select b.pid from Formlink b where  b.typeid=1 and b.oid='").append(formid).append("')");
			forminfolists = forminfoService.getForminfoListByHql(hql.toString());
		}
	 }
	%>
	 <select id="warnedOperator" name="warnedOperator" onchange="myChange()">						  						   
	<%
	for (int k = 0; k < forminfolists.size(); k++) {
		Forminfo forminfo = (Forminfo) forminfolists.get(k);
		String tempformid = forminfo.getId();
		List formfieldlist = formfieldService.findFormfield("from Formfield where formid = '"+tempformid+"' and htmltype =  6 "
		+ "and fieldtype = '402881e70bc70ed1010bc75e0361000f' and (isdelete is null or isdelete = 0)");
		String formname = forminfo.getObjname();
		String objtablename = forminfo.getObjtablename();
		int fieldsSize = formfieldlist.size();
		for(int j = 0; j < fieldsSize; j ++) {
			Formfield ffield = (Formfield)formfieldlist.get(j);
			String fieldName = ffield.getFieldname();
			String fieldObjName = ffield.getLabelname(); 
			if(StringHelper.isEmpty(fieldObjName)) {
				continue;
			}
			String value = objtablename+"."+fieldName;
			%>
			<option value="<%=value %>" <%if(value.equals(valueid)) {%>selected<%} %>><%=formname+"."+fieldObjName %></option>
			<%
		}
	}	
%>
</select>