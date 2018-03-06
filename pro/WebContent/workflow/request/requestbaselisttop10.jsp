<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.Page"%>

<%
String workflowid =StringHelper.null2String(request.getParameter("workflowid"));
String sql="";
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem;
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
RequestbaseService requestbaseService = (RequestbaseService) BaseContext.getBean("requestbaseService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
String action = request.getParameter("action");
String userid = request.getParameter("userid");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
 sql="from Requestbase rb where  rb.isdelete<>1 and rb.creater='"+BaseContext.getRemoteUser().getId()+"' and rb.workflowid='"+workflowid+"' and rb.isfinished=0 order by createdate desc,createtime desc";
Page pageObject = null;
if (pageObject == null) {
	 pageObject = requestbaseService.getPagedByQuery(sql, 1, 10);
}

%>
        <table>
          <tr class=Header> 
         	<th><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></th><!--流程名称-->
         	<th><%=labelService.getLabelName("402881ef0c820942010c821bf6be000b")%></th><!--工作流名称-->
            <th><%=labelService.getLabelName("402881eb0bd74dcf010bd753e2b50008")%></th><!--创建时间-->    
            <th><%=labelService.getLabelName("402881eb0bd74dcf010bd752d0860006")%></th><!--创建者-->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76a9f4cf002e")%></th><!--级别-->
            <th><%=labelService.getLabelName("402881ec0cbb8cc8010cbbf030f8002d")%></th><!--流程状态-->
          </tr>
				<%				
				Requestbase requestbase =null;
				if(!(pageObject==null)){
				if(pageObject.getTotalSize()!=0){
					List list = (List) pageObject.getResult();		
					for (int i = 0; i < list.size(); i++) {
						requestbase = (Requestbase) list.get(i);
		
				%>		

          <tr  class=datadark  > 
            <td><a href="<%=request.getContextPath()%>/workflow/request/workflow.jsp?requestid=<%=requestbase.getId()%>" target="_blank"><%=requestbase.getRequestname()%></a></td>
            <%
            Workflowinfo workflowinfo = workflowinfoService.get(requestbase.getWorkflowid());
            String workflowinfoname = "";
            if(workflowinfo != null){
            	workflowinfoname = workflowinfo.getObjname();
            }
            %>
            <td><%=workflowinfoname%></td>            
            <td><%=requestbase.getCreatedate()%>  <%=requestbase.getCreatetime()%></td>
            <td><a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=requestbase.getCreater()%>"><%=humresService.getHumresById(requestbase.getCreater()).getObjname()%></a></td>
            <%
            selectitem = selectitemService.getSelectitemById(requestbase.getRequestlevel());
            %>
            <td><%=selectitem.getObjname()%></td>
            <%	
            	String isfinish =labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c");//是
            	if(requestbase.getIsfinished().toString().equals("0")){
            		isfinish = labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d");//否
            	}
            %>
            <td><%=isfinish%></td>
          </tr>
				

				<%	
				   }
				}}
				%>	
	   </table>   

