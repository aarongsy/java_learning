﻿<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%
WorkflowService ws = (WorkflowService)BaseContext.getBean("workflowService");
RequestbaseService requestbaseService = (RequestbaseService)BaseContext.getBean("requestbaseService");
FormService fs = (FormService)BaseContext.getBean("formService");
NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
ExportService exportService = (ExportService)BaseContext.getBean("exportService");
ImginfoService imginfoService = (ImginfoService) BaseContext.getBean("imginfoService");

String pstyle = StringHelper.null2String(request.getParameter("style"));
String printLayout = StringHelper.null2String(request.getParameter("printLayout"));
String workflowid = StringHelper.null2String(request.getParameter("workflowid")).trim();
String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
String requestname = requestbaseService.getRequestbaseById(requestid).getRequestname();
String sign = StringHelper.null2String(request.getParameter("sign")).trim();
//response.addHeader("Content-Disposition", "attachment;filename="+requestname+".xls");

String nodeid = StringHelper.null2String(request.getParameter("nodeid")).trim();
String[] show = StringHelper.null2String(request.getParameter("show")).trim().split(",");
boolean isstamp=false;
List listmove=new ArrayList();

Map workflowparameters = new HashMap();

workflowparameters.put("bNewworkflow","0");
workflowparameters.put("workflowid",workflowid);
workflowparameters.put("requestid",requestid);
workflowparameters.put("printLayout",printLayout);
workflowparameters.put("nodeid",nodeid);
workflowparameters.put("requesthost", " http://" + StringHelper.getRequestHost(request));
workflowparameters.put("contextpath", request.getContextPath());
//处理输入参数
Map initparameters = new HashMap();
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String pName = e.nextElement().toString().trim();
	String pValue = StringHelper.trimToNull(request.getParameter(pName));
	if(!StringHelper.isEmpty(pName))
		initparameters.put(pName,pValue);
}
//处理输入参数完成
workflowparameters.put("initparameters",initparameters);
workflowparameters = ws.WorkflowView(workflowparameters);	

//处理创建权限
nodeid = StringHelper.null2String(workflowparameters.get("nodeid"));
workflowid = StringHelper.null2String(workflowparameters.get("workflowid"));

workflowparameters.put("bviewmode","1");
workflowparameters.put("bWorkflowform","1");
workflowparameters.put("isExportExcel", "1");

workflowparameters = fs.WorkflowView(workflowparameters);

String formcontent = StringHelper.null2String(workflowparameters.get("formcontent"));
String resetdetailformtablescript = StringHelper.null2String(workflowparameters.get("resetdetailformtablescript"));
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
RequestlogService requestlogService = (RequestlogService)BaseContext.getBean("requestlogService");

StringBuffer hql = new StringBuffer("select wl.operatedate,wl.operatortime, wl.remark, ni.objname ,h.objname,s.objname, rb.requestname,wl.operator");
hql.append(" from Requestlog wl, Requeststep ws ,Nodeinfo ni,Humres h ,Selectitem s ,Requestbase rb ")
	.append(" where wl.stepid=ws.id and ws.nodeid = ni.id and h.id=wl.operator and s.id = wl.logtype and rb.id=wl.requestid and wl.logtype<>'402881e50c5b4646010c5b5afd170009'")
	.append(" and wl.requestid='").append(requestid).append("' order by wl.operatedate desc,wl.operatortime desc");
//不打印接收节点logtype=s'402881e50c5b4646010c5b5afd170009'
List requestlogList = (List) request.getAttribute("requestlogList");
if (requestlogList == null) {
	requestlogList = requestlogService.getAllRequestlog(hql.toString());
}
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<style type="text/css">
#layoutDiv{
	padding: 0px;margin: 0;
}
table.layouttable,table.detailtable{
	margin:2 0 0 2;
}
table.layouttable caption
	height: 30px;
}
table.detailtable caption{
	height: 22px;
}
table.layouttable td,table.detailtable td,table.detailtable th{
	line-height: 22px;
	height: 22px;
}
table.detailtable table td{
	line-height: 22px;
	height: 22px;
}
@media print{
	a{font-size: 9px;}
	table.layouttable td,table.detailtable td,table.detailtable th,table.layouttable caption,table.detailtable caption{
		line-height: 16px;
		height: 16px;
		font-size: 9px;
	}
	table.detailtable table td{
		line-height: 16px;
		height: 16px;
		font-size: 9px;
	}
	table.layouttable span,table.detailtable span{
		font-size: 9px;
	}
    .nextPage{
        page-break-after:always;
    }     
}
</style>
</head>
<body style="margin:5 2 5 0;padding:0;" onload="expExcel();">
<%=formcontent%>
<%if (sign == "1" || "1".equals(sign)) { %>
<div id="layoutDiv">		
<table class=detailtable border=1>
<caption>流转信息</caption>
       <colgroup>
        <col width="15%">
         <col width="15%"> 
         <col width="15%"> 
         <col width="15%"> 
         <col width="40%"> 
       </colgroup>
       <tbody> 
       <tr class=Header> 
         <th><%=labelService.getLabelName("402881f00c7690cf010c76b074410031")%></th><!--日期时间 -->
     <th><%=labelService.getLabelName("402881f00c7690cf010c76b1476b0034")%></th><!--操作者 -->
     <th><%=labelService.getLabelName("402881f00c7690cf010c76b1f3260037")%></th><!--节点 -->
     <th><%=labelService.getLabelName("402881ea0bfa7679010bfa8999a3001b")%></th><!--操作类型 -->
     <th>流转意见</th>
   </tr>
	<%				
	Iterator it = requestlogList.iterator();		
	while(it.hasNext()) {
		Object[] results = (Object[])it.next();
		List isList = imginfoService.getUserImginfos(results[7].toString());
	%>
   <tr class=DataLight>
     <td><%=results[0]%><%=results[1]%></td> 
     <td><%=results[4]%><!--有电子签章的人，导出excel也只显示名称，不显示图片
	   <%
		if (isList != null && isList.size() > 0) {
		 Imginfo imginfo = (Imginfo)isList.get(0);
		%>
		<img alt=<%=results[4]%> src=/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imginfo.getAttachid()%>&amp;download=1>
		<%
		} else {
		%>
		<%=results[4]%>
		<% } %>
     --></td>
     <td><%=results[3]%></td>
     <td><%=results[5]%></td>
        <td colspan="4"><%=StringHelper.null2String(results[2])%></td>
 </tr>
<%}%>	
</table>
<%} %>
</div>
</body>
<script language=javascript>
function expExcel() { 
	var cells = document.getElementsByTagName("TD");
	for(var i=0;i<cells.length;i++){
		var cellHtml = cells[i].innerHTML.toLowerCase();
		if(cellHtml.indexOf("<td")>-1||cellHtml.indexOf("<img")>-1)	continue;
		cells[i].innerHTML = cells[i].innerText;
	}
	
	var tables1 = Ext.query("*[class=layouttable]");
	var tables2 = Ext.query("*[class=detailtable]");
	var tables =tables1.concat(tables2);
	var html='';
	for(var i=0;i<tables.length;i++){
		html+=tables[i].outerHTML;
	}
	
	window.clipboardData.setData("Text",html);
	try{
		var ExApp = new ActiveXObject("Excel.Application");
		var ExWBk = ExApp.workbooks.add();
		var ExWSh = ExWBk.worksheets(1);
		ExApp.DisplayAlerts = false;
		ExApp.visible = true;
	}  
	catch(e){
		alert("您的电脑没有安装Microsoft Excel软件！")
		return false
	}
	ExWBk.worksheets(1).Paste;	
}
</script>
</html>