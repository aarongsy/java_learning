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
//模板分类ID
DataService dataService = new DataService();
String id =request.getParameter("docId");
String requestid =request.getParameter("requestid");
if(StringHelper.isEmpty(id)){
	String sql = "select mainbodyattach from uf_doc_ratifymain where requestid='"+requestid+"'";
	id = dataService.getValue(sql); 
}
if(StringHelper.isEmpty(id)){
	out.print(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160057"));//流程未提交，暂无正文信息
}
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
DocborrowService docborrowService = (DocborrowService) BaseContext.getBean("docborrowService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
RemarkService remarkService = (RemarkService) BaseContext.getBean("remarkService");
LogService logService = (LogService) BaseContext.getBean("logService");

Docbase docbase = docbaseService.getPermissionObjectById(id);
if(docbase == null){
	response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
	return;
}
boolean ishasPermit = true;

boolean useRTX=false;
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
Setitem rtxSet=setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");
if(rtxSet!=null&&"1".equals(rtxSet.getItemvalue())){
	useRTX=true;
}

if(docbase.getIsdelete().intValue() ==1){
	out.print(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160058"));//该文档已经删除
	return;
}
Log log=new Log();
log.setIsdelete(0);
log.setLogdesc(labelService.getLabelNameByKeyId("402881e70b65e2b3010b65e3435d0002"));//操作日志
log.setLogtype("402881e40b6093bf010b60a5849c0007");
log.setMid("");
log.setObjid(docbase.getId());
log.setObjname(docbase.getSubject());
log.setSubmitdate(DateHelper.getCurrentDate());
log.setSubmittime(DateHelper.getCurrentTime());
log.setSubmitor(eweaveruser.getId());
log.setSubmitip(eweaveruser.getRemoteIpAddress());
logService.createLog(log);

String attachid = StringHelper.trimToNull(request.getParameter("attachid"));
Attach attach =null;
if(attachid!=null){
	attach = attachService.getAttach(attachid);
}
if(attach==null){
	Docattach docattach = docbaseService.getDoccontentLastVerList(id);
	if(docattach!=null){
		attachid = docattach.getAttachid();
		attach = attachService.getAttach(attachid);
	}
}
int docType = docbase.getDoctype().intValue();
String attachstr=(attach==null?"":attach.getId());

String state =labelService.getLabelName(docbaseService.getLabelidByDocstatus(docbase.getDocstatus().intValue()));
Docbase maindocbase = docbaseService.getMainDocbase(id);
List docattachList = docbaseService.getAttachList(id);
String categoryid = null;
if (categoryService.getCategoryByObj(maindocbase.getId()) != null){
    categoryid = (categoryService.getCategoryidStrByObj(maindocbase.getId()));
}
Category category = categoryService.getCategoryById(categoryid);
String formcontent ="";
Map initparameters = new HashMap();
Map parameters = new HashMap();

parameters.put("bWorkflowform","0");
parameters.put("isview","1");
parameters.put("formid","402881e50bff706e010bff7fd5640006");
parameters.put("objid",id);
parameters.put("object",docbase);
parameters.put("layoutid",category.getPViewlayoutid());
parameters.put("initparameters",initparameters);

FormService fs = (FormService)BaseContext.getBean("formService");
parameters = fs.WorkflowView(parameters);

formcontent = StringHelper.null2String(parameters.get("formcontent"));
//附件操作权限
int righttype = permissiondetailService.getOpttype(docbase.getId());
if(righttype%15==0){
	//response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid="+attachid);
	//return;
}
%>
<script language="javascript">
function savelocalFile(pdf){
	window.location.href="/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid=<%=attachid%>";
	setTimeout("closetab()",10);
}
function closetab(){
	var tab=parent.contentPanel.getActiveTab();
	tab.removed=true;
	parent.contentPanel.remove(tab);
}
window.onload=savelocalFile;
</script>