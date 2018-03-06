<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.util.*" %>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>

<%
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
FormBaseService formbaseService = (FormBaseService)BaseContext.getBean("formbaseService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
WorkflowService workflowService = (WorkflowService) BaseContext.getBean("workflowService");
DataService dataService = new DataService();

String requestid = StringHelper.null2String(request.getParameter("projectid"));

//System.out.println(requestid);

String requestID = dataService.getValue("select id from requestbase where id='"+requestid+"'");
if(!StringHelper.isEmpty(requestID)){
	response.sendRedirect("/workflow/request/workflow.jsp?requestid="+requestid);
	return;
}

//如果当前用户不是项目经理、登记人或客户经理，无权限
String sqlman = "select manager||Subscriber from cpms_project where requestid='"+requestid+"'";
String managers = dataService.getValue(sqlman);
String customermansql = "select a.customersale from uf_customer a,cpms_project b"+
				" where a.requestid=b.customers and b.requestid='"+requestid+"'  ";
String cusman = dataService.getValue(customermansql);
if((managers+cusman).indexOf(eweaveruser.getId()) == -1){
	response.sendRedirect("/nopermit.jsp");
    return;	
}


//String id = IDGernerator.getUnquieID();
String requestname = StringHelper.null2String(dataService.getValue("select objname from cpms_project where requestid='"+requestid+"'"));

String currentdate = DateHelper.getCurrentDate();
String currenttime = DateHelper.getCurrentTime();
String objno = WorkflowNumber.getWorkflowNo(7);
String insertsql = "insert into requestbase (id,workflowid,requestname,createtype,creater,createdate,createtime,isfinished,isdelete,objno) values "+
				" ('"+requestid+"','402882882ed5f68c012ed638bea602a5','项目立项-"+requestname+"','1','"+eweaveruser.getId()+"','"+currentdate+"',"+
				" '"+currenttime+"',0,0,'"+objno+"')";
dataService.executeSql(insertsql);

String updateSql3 = "update cpms_project set nodeid='402882882ed5f68c012ed63d3cf502a6' where requestid='"+requestid+"'";
dataService.executeSql(updateSql3);

//复制子表内容
//uf_childregisterplan 项目实施计划
//
String sql1 = "select a.requestid from uf_projectregister a,cpms_project b where a.projectno=b.projno and b.requestid='"+requestid+"'";
String therequestid = dataService.getValue(sql1);
String sql = "insert into uf_childregisterplan_p select * from uf_childregisterplan where requestid ='"+therequestid+"'";
dataService.executeSql(sql);
String updateSql = "update uf_childregisterplan_p set nodeid='402882882ed5f68c012ed63d3cf502a6',requestid='"+requestid+"' where requestid ='"+therequestid+"'";
dataService.executeSql(updateSql);

String updateSql2 = "update uf_sampleorder set nodeid='402882882ed5f68c012ed63d3cf502a6',requestid='"+requestid+
				"' where projectId in (select projectno from uf_projectregister where requestid='"+therequestid+"')";
dataService.executeSql(updateSql2);

Map workflowparameters = new HashMap();

workflowparameters.put("requestid", requestid);
workflowparameters.put("workflowid", "402882882ed5f68c012ed638bea602a5");
workflowparameters.put("nodeid", "402882882ed5f68c012ed63d3cf502a6");
workflowparameters.put("curnodeid", "");
workflowparameters.put("isundo", "0");
workflowparameters.put("objno", objno);
workflowparameters.put("editmode", "0");
workflowparameters.put("isreject", "0");
workflowparameters.put("rejectednode", "");
workflowparameters.put("optlevel", "0");
workflowparameters.put("issave", "1");

workflowService.WorkflowActionSpec(workflowparameters);
//System.out.println("-------------------");
response.sendRedirect("/workflow/request/workflow.jsp?requestid="+requestid);
return;



%>