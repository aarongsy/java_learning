<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%
String selectItemId = StringHelper.trimToNull(request.getParameter("selectItemId"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
Workflowinfo workflowinfo;
Selectitem selectitem;
String tagetUrl = StringHelper.trimToNull(request.getParameter("tagetUrl"));
String model = StringHelper.trimToNull(request.getParameter("model"));
if("Docbase".equalsIgnoreCase(model)){
	tagetUrl = request.getContextPath()+"/document/base/docbasecreate.jsp?doctypeid=";
	
}else
if("Product".equalsIgnoreCase(model)){
	tagetUrl = request.getContextPath()+"/product/base/productcreate.jsp?producttypeid=";
}else
if("Customer".equalsIgnoreCase(model)){
	tagetUrl = "";
}else
if("Project".equalsIgnoreCase(model)){
	tagetUrl = "";
}else{
	tagetUrl ="";
}
%>
<html>
  <head>
  </head> 
  <body>
<table height=100%>
	<tr>
		<td valign=top>
   <form action="" name="EweaverForm"  method="post">
   <input name="model" type="hidden" value="<%=model%>">

   <table style="border:0">
		<colgroup> 
			<col width="1%">
			<col width="20%">
			<col width="79%">			
		</colgroup>
	
<%	Iterator it= selectitemlist.iterator();
	while (it.hasNext()){
		selectitem =  (Selectitem)it.next();	
%>
		<tr><td class=Spacing colspan=3></td><tr>
	    <tr class=Title>
	    <th colspan=3>
	    	<img src=<%=request.getContextPath()%>/images/base/listtitle.gif border=0>
	        	<%=selectitem.getObjname()%>
	    </th>
      	</tr>
	    <tr><td class=Line colspan=3></td><tr>
<%
		ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
		List reportdeflist = reportdefService.getReportdefByObjtype(selectitem.getId());
		Reportdef reportdef = null;
		if (reportdeflist!=null && reportdeflist.size()!=0) {
			for (int i=0;i<reportdeflist.size();i++){
				reportdef = (Reportdef) reportdeflist.get(i);	
				
				if(selectitem.getObjname().equalsIgnoreCase("sql")){
					String opts = reportdef.getObjopts();
					if(opts != null && opts.contains(eweaveruser.getId())){
%>
	    <TR>
     		 <TD nowrap class=FieldName><span><a href="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportdef.getId()%>" target='HomePageIframe2'><img src=/images/base/search.gif border=0></a></span> </TD>
	         <TD nowrap class=FieldName>  
	    		<a href=javascript:onSearchByWorkflowid("<%=reportdef.getId()%>");><%=reportdef.getObjname()%></a>
	         </TD>	                    
	    </TR>       

<%					
					}
				
				}else{
%>
	    <TR>
     		 <TD nowrap class=FieldName><span><a href="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportdef.getId()%>" target='HomePageIframe2'><img src=/images/base/search.gif border=0></a></span> </TD>
	         <TD nowrap class=FieldName>  
	    		<a href=javascript:onSearchByWorkflowid("<%=reportdef.getId()%>");><%=reportdef.getObjname()%></a>
	         </TD>	                    
	    </TR>       

<%				}
		}// end for
	}// end if 
}//end while
%>
   </table> 

</form>   
		</td>
	</tr>
</table> 
<script language="javascript"> 
  function onSearchByWorkflowid(reportid){
	//parent.HomePageIframe2.location.href="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid="+reportid;
	window.open("<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid="+reportid);
  }
  
</script>
  </body>
</html>
