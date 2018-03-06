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
<%@ page import="com.eweaver.workflow.report.service.*"%>
<%@ page import="com.eweaver.workflow.report.model.*"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%
String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");
ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
WorkflowdoctypeService workflowdoctypeService = (WorkflowdoctypeService) BaseContext.getBean("workflowdoctypeService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
String formid=workflowinfo.getFormid();
List formlinkList=formlinkService.getRelaFormById(formid);//取得所有关联表单


//当前表单与文档相关的字段列表
List doctypelist=formfieldService.getFieldByForm(formid,6,"402881e70bc70ed1010bc710b74b000d");
for(int i=0;i<formlinkList.size();i++){
	Formlink formlink=(Formlink)formlinkList.get(i);
	String tFormid=formlink.getPid();
	//关联表单与文档相关的字段列表
	List tList=formfieldService.getFieldByForm(tFormid,6,"402881e70bc70ed1010bc710b74b000d");
	doctypelist.addAll(tList);
}

List listObj=formfieldService.getFieldByForm(formid,6,null);
for(int i=0;i<formlinkList.size();i++){
	Formlink formlink=(Formlink)formlinkList.get(i);
	String tFormid=formlink.getPid();
	//关联表单与文档相关的字段列表
	List tList=formfieldService.getFieldByForm(tFormid,6,null);
	listObj.addAll(tList);
}
List browsertypelist = new ArrayList();
for(int i=0;i<listObj.size();i++){
    Formfield formfield = (Formfield) listObj.get(i);
    Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
    String table = StringHelper.null2String(refobj.getReftable());
    if(table.startsWith("cpms")||table.indexOf("uf_")!=-1||table.indexOf("docbase")!=-1||table.indexOf("requestbase")!=-1){
        browsertypelist.add(formfield);
    }
}
Formfield formfield;
Workflowdoctype workflowdoctype;


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
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowdoctypeAction?action=save" name="EweaverForm" method="post">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="size" value="<%=doctypelist.size()+browsertypelist.size()%>">

<%

String id;
String doctypeid;
String doctypename;
Integer opttype=0;
String layoutid;
int priority = 0;
%>
<table>
<COLGROUP>
<COL width="10%">
<COL width="10%">
<COL width="15%">
<COL width="65%">
<tr class=Header>
	<td><%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96212bc80009")%></td><!--字段名称 -->
	<td><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0000")%></td><!--是否给予权限 -->
	<td><%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa8999a3001b")%></td><!--操作类型 -->
	<td><%=labelService.getLabelNameByKeyId("402881d50dae6b9d010daf1ec0c90020")%></td><!--布局 -->	
	<td><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a9f4cf002e")%></td><!-- 级别 -->
</tr>
<%

for(int i=0;i<browsertypelist.size();i++){
id="";
doctypeid="";
doctypename="";
layoutid = "";
priority = 0;
opttype=3;
formfield=(Formfield)browsertypelist.get(i);
workflowdoctype=workflowdoctypeService.getWorkflowBrowsertypeByfield(workflowid,formfield.getId());
if(workflowdoctype!=null){
	id=workflowdoctype.getId();
	doctypeid=workflowdoctype.getDoctypeid();
	opttype=NumberHelper.string2Int(workflowdoctype.getOpttype(),3);
	layoutid=workflowdoctype.getLayoutid();
	priority = workflowdoctype.getPriority();
}
Refobj refobj = refobjService.getRefobj(formfield.getFieldtype());
String table = StringHelper.null2String(refobj.getReftable());

//根据关联选择REFURL中的REPORTID查找是否对应的是抽象表单。
String refurl = refobj.getRefurl();
String reportid = "";
int reportidPos = refurl.indexOf("reportid=");
if(reportidPos!=-1){
	reportid = refurl.substring(reportidPos+9, reportidPos+9+32);
}
Forminfo forminfo = table.startsWith("uf") ? reportdefService.getForminfoByReportid(reportid) : null;

List<Map> formList = baseJdbcDao.executeSqlForList("select id from forminfo where objtablename='"+table+"' and objtype=0  order by objtype desc");
String fid="";
if(formList.size()>0)
 fid= StringHelper.null2String(formList.get(0).get("id"));
%>
<tr>
	<td class="FieldName">
	<%=formfield.getLabelname()%>
	</td>
	<td class="FieldValue">
		<input type="checkbox" id="checkbox_<%=i%>" name="checkbox_<%=i%>" value="1" <%if("givenpermission".equals(doctypeid)){%>checked<%}%>/>
		<input type="hidden" name="doctypeid<%=i%>" value="givenpermission">
		<input type="hidden" name="fieldid<%=i%>" value="<%=formfield.getId()%>">
		<input type="hidden" name="id<%=i%>" value="<%=id%>">
	</td>
    <td>
    <select id="operatetype<%=i%>" name="operatetype<%=i%>">
        <%
            List selectitemlist = selectitemService.getSelectitemList2("402880371fb07b8d011fb0889c890002","");
            Iterator it = selectitemlist.iterator();
            while(it.hasNext()){
                Selectitem selectitem = (Selectitem) it.next();
                if("4028803520218a250120218c03510002".equals(selectitem.getId())||"402880371fb0bc8f011fb133b62c0015".equals(selectitem.getId())||"E9792B824616469B9F2E107CD0708456".equals(selectitem.getId())||"402880371fb0bc8f011fb17555db0019".equals(selectitem.getId())){
                	continue;
                }
        %>
        <option value="<%=selectitem.getObjdesc()%>" <%if(opttype.equals(NumberHelper.getIntegerValue(selectitem.getObjdesc(),0))){%>selected="selected" <%}%>><%=selectitem.getObjname()%></option>
        <%
            }
        %>
    </select>
    </td>
    <td>
    <select id="layoutidobj<%=i%>" name="layoutidobj<%=i%>">
        <option value=""></option>
        <%
        if(forminfo!=null && 1==forminfo.getObjtype()){//关联对象用的是抽象表单，找抽象表单对应的布局。
        	fid = forminfo.getId();
        }
          if(!StringHelper.isEmpty(fid)){
            List list = formlayoutService.findFormlayout("from Formlayout where formid='"+fid+"' and isdelete=0");
            Iterator itObj = list.iterator();
            while(itObj.hasNext()){
                Formlayout formlayout = (Formlayout) itObj.next();
				
        %>
        <option value="<%=formlayout.getId()%>" <%if(formlayout.getId().equals(layoutid)){%>selected="selected"<%}%>><%=formlayout.getLayoutname()%></option>
        <%
            }}
        %>
    </select>
    </td>
    <td><input id="priority<%=i%>" name="priority<%=i%>" value="<%="".equals(layoutid)?"":priority %>"></td>
</tr>
<%
}
%>
</table>

</form>
</body>
</html>