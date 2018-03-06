<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%
int isfinished = NumberHelper.string2Int(request.getParameter("isfinished"));
String selectItemId = StringHelper.trimToNull(request.getParameter("selectItemId"));
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);
DataService dbservice = new DataService();
//得到每个工作流中的流程数

StringBuffer workflowsql = new StringBuffer("select workflowid,count(*) counts from Requestbase rb where  rb.isdelete<>1 and ")
	.append(" rb.creater='").append(BaseContext.getRemoteUser().getId()).append("' and rb.isfinished=").append(isfinished)
	.append(" group by rb.workflowid");
//String workflowsql = "select workflowid,count(*) counts from requestbase group by workflowid ";
List workflowcountList = dbservice.getValues(workflowsql.toString());
Iterator workflowit = workflowcountList.iterator();
Map workflowcountMap = new HashMap();
while(workflowit.hasNext()){
	Map m = (Map)workflowit.next();
	
	String workflowid = (String)m.get("workflowid");
	Integer counts =  NumberHelper.getIntegerValue(m.get("counts"));
	workflowcountMap.put(workflowid,counts);
}
StringBuffer workflowtypesql = new StringBuffer("select pip.objtype workflowtype,count(*) counts from Requestbase rb,Workflowinfo pip where rb.isdelete<>1 and ")
	.append(" rb.creater='").append(BaseContext.getRemoteUser().getId()).append("' and rb.isfinished=").append(isfinished)
	.append(" and rb.workflowid=pip.id group by pip.objtype ");
List workflowtypecountList = dbservice.getValues(workflowtypesql.toString());
Iterator workflowtypeit = workflowtypecountList.iterator();
Map workflowtypecountMap = new HashMap();
while(workflowtypeit.hasNext()){
	Map m = (Map)workflowtypeit.next();
	
	String workflowid = (String)m.get("workflowtype");
	Integer counts =  NumberHelper.getIntegerValue(m.get("counts"));
	workflowtypecountMap.put(workflowid,counts);
}

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
  <body onload="javascript:onSearchAll()">
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
		<tr class=Title>
	    <th colspan=3>
	    	<img src=<%=request.getContextPath()%>/images/listtitle.gif border=0>
	        	<a href=javascript:onSearchAll();><%=labelService.getLabelName("402881ee0c715de3010c72432b110066")%></a>
	    </th>
      	</tr>		
<%	Iterator it= selectitemlist.iterator();
	while (it.hasNext()){
		selectitem =  (Selectitem)it.next();	
		
		Integer counts = (Integer)workflowtypecountMap.get(selectitem.getId());
		if(counts != null && !counts.toString().equals("0")){
%>
		<tr><td class=Spacing colspan=3></td><tr>
	    <tr class=Title>
	    <th colspan=3>
	    	<img src=<%=request.getContextPath()%>/images/listtitle.gif border=0>
	        	<a href=javascript:onSearchByWorkflowType("<%=selectitem.getId()%>");><%=selectitem.getObjname()%>(<FONT SIZE="2" COLOR="#FF0000"><B><%=counts %></B></FONT>)</a>
	    </th>
      	</tr>
	    <tr><td class=Line colspan=3></td><tr>
<%		
	
		List workflowinfolist = workflowinfoService.getAllWorkflowinfoByObjtype(selectitem.getId());
	
		if (workflowinfolist!=null && workflowinfolist.size()!=0) {
			for (int i=0;i<workflowinfolist.size();i++){
				workflowinfo = (Workflowinfo) workflowinfolist.get(i);	

	         	Integer cunt = new Integer(0);
	         	if(workflowcountMap.get(workflowinfo.getId())!=null){
	         		cunt = (Integer)workflowcountMap.get(workflowinfo.getId());
	         	}
	         	if(!cunt.toString().equals("0")){
	         %>
	     <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName>  
	    		<a href='javascript:onSearchByWorkflowid("<%=workflowinfo.getId()%>");'><%=workflowinfo.getObjname()%>(<FONT SIZE="2" COLOR="#FF0000"><B><%=cunt %></B></FONT>)</a>
	         </TD>	                    
	    </TR>        
<%}
		}// end for
	}// end if 
}}//end while
%>
   </table> 

</form>   
		</td>
	</tr>
</table> 
<script language="javascript"> 
  function onSearchByWorkflowid(workflowid){
	parent.HomePageIframe2.location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmybyworkflowid&workflowid="+workflowid + "&isfinished=" + <%=isfinished%>;
  }
  
  function onSearchByWorkflowType(workflowtype){
	parent.HomePageIframe2.location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmy2&workflowtype="+workflowtype + "&isfinished=" + <%=isfinished%>;
  }
  
  function onSearchAll(){
	parent.HomePageIframe2.location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall" + "&isfinished=" + <%=isfinished%>;
  }
</script>
  </body>
</html>
