<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.base.refobj.model.*"%>
<%@ page import="com.eweaver.base.refobj.service.*"%>
<%
String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
WorkflowaccreditService workflowaccreditService = (WorkflowaccreditService) BaseContext.getBean("workflowaccreditService");
Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
String formid=workflowinfo.getFormid();
List formlinkList=formlinkService.getRelaFormById(formid);//取得所有关联表单


//当前表单的关联字段列表

List list=formfieldService.getFieldByForm(formid,6,null);
for(int i=0;i<formlinkList.size();i++){
	Formlink formlink=(Formlink)formlinkList.get(i);
	String tFormid=formlink.getPid();
	//关联表单的关联字段列表

	List tList=formfieldService.getFieldByForm(tFormid,6,null);
	list.addAll(tList);
}
%>

<html>
<head>
</head>
<body>

<div id="pagemenubar" style="z-index:100;"></div>
<div id="menubar">
<button type="button" class='btn' accessKey="C" onclick="javascript:onSubmit();">
<U>S</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")%>
</button>		
</div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowaccreditAction?action=save" name="EweaverForm" method="post">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="size" value="<%=list.size()%>">
<table>
<COLGROUP>
<COL width="10%">
<COL width="90%">
<tr class=Header>
	<td><%=labelService.getLabelName("402881e60b95cc1b010b96212bc80009 ")%></td><!--字段名称 -->
	<td><%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0006")%><!-- 是否授权 --></td><!--文档类型 -->
</tr>
<%
for(int i=0;i<list.size();i++){
String id=null;
int isaccredit=0;
Formfield formfield =(Formfield)list.get(i);
Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
Workflowaccredit workflowaccredit = workflowaccreditService.getWorkflowaccredit(workflowid,formfield.getId());
if(workflowaccredit!=null){
	id=workflowaccredit.getId();
	if(workflowaccredit.getIsaccredit()!=null){
		isaccredit=workflowaccredit.getIsaccredit().intValue();
	}
}
String expStr="'402881e70bc70ed1010bc75e0361000f','402881e60bfee880010bff17101a000c','402881e510efab3d0110efba0e820008','402881eb0bd30911010bd321d8600015','402881e510efab3d0110efba0e820008','40288041120a675e01120a7ce31a0019'";

if(formfield!=null && formfield.getFieldtype()!=null && expStr.indexOf(formfield.getFieldtype())==-1 && formfield.getLabelname()!=null){
%>
<tr>	
	<td class="FieldName">
	<%=formfield.getLabelname()%>
	</td>
	<td class="FieldValue">
		<input type="hidden" name="has<%=i%>" value="<%=i%>">
		<input type=checkbox name="isaccredit<%=i%>" value=1 <%if(isaccredit==1){%>checked<%}%>>
		<input type="hidden" name="fieldid<%=i%>" value="<%=formfield.getId()%>">
		<input type="hidden" name="id<%=i%>" value="<%=id%>">
	</td>
</tr>
<%
}
}
%>
</table>
			
</form>
</body>
</html>