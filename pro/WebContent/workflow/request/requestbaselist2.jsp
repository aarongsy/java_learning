<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.Page"%>

<%
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem;
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
RequestbaseService requestbaseService = (RequestbaseService) BaseContext.getBean("requestbaseService");
RequestlogService requestlogService = (RequestlogService) BaseContext.getBean("requestlogService");
NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
String action = request.getParameter("action");
String userid = request.getParameter("userid");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
Page pageObject = (Page) request.getAttribute("pageObject");
StringBuffer hql = new StringBuffer(
		"from Requestbase rb where rb.id in ");
hql
		.append(
				"(select wo.requestid from Requeststatus wi , Requestoperators wo where wi.curstepid=wo.stepid ")
		.append("and  (wi.isreceived=0 or wi.issubmited=0) ").append(
				"and wi.ispaused=0 and  wo.userid='").append(
				userid).append("')");
if (pageObject == null) {
	pageObject = requestbaseService.getPagedByQuery(hql.toString(),1,20);
}

%>
<html>
  <head>
  </head> 
  <body>
<!--页面菜单开始-->     
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=<%=action%>&from=list" name="EweaverForm" method="post">
        <table>
          <tr class=Header> 
         	<th><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></th><!--流程名称-->
            <th>流程节点</th><!--流程节点-->         	
         	<th><%=labelService.getLabelName("402881ef0c820942010c821bf6be000b")%></th><!--工作流名称-->
            <th><%=labelService.getLabelName("402881eb0bd74dcf010bd753e2b50008")%></th><!--创建时间-->    
            <th><%=labelService.getLabelName("402881eb0bd74dcf010bd752d0860006")%></th><!--创建者-->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76a9f4cf002e")%></th><!--级别-->
            <th><%=labelService.getLabelName("402881ec0cbb8cc8010cbbf030f8002d")%></th><!--流程状态-->
          </tr>
				<%				
				Requestbase requestbase =null;
				if(pageObject.getTotalSize()!=0){
					List list = (List) pageObject.getResult();		
					for (int i = 0; i < list.size(); i++) {
						requestbase = (Requestbase) list.get(i);
		
				%>		

          <tr  class=datadark  > 
            <td><a href="<%=request.getContextPath()%>/workflow/request/workflow.jsp?requestid=<%=requestbase.getId()%>" target="_blank"><%=requestbase.getRequestname()%></a></td>
            <td>
	            <%
	            	List nodelist = requestlogService.getCurrentNodeIds(requestbase.getId());
					Nodeinfo nodeinfo = new Nodeinfo();
					if (nodelist.size() > 0)
						nodeinfo = nodeinfoService.get((String) nodelist.get(0));
	            %>
	            <%=StringHelper.null2String(nodeinfo.getObjname())%>
            </td>

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
				}
				%>	
	   </table>
       <br>
			<table border="0">
				<tr>
					<td>&nbsp;</td>
					<td nowrap align=center>						
						<%=labelService.getLabelName("402881e60aabb6f6010aabba742d0001")%>[<%=pageObject.getTotalPageCount()%>]
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbb07a30002")%>[<%=pageObject.getTotalSize()%>]
						&nbsp;
					</td>

					<td nowrap align=center>
						<button  type="button" accessKey="F" onclick="onSearch(1)">
					     <U>F</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbb63210003")%>
				        </button>&nbsp;
						<button  type="button" accessKey="P" onclick="onSearch(<%=pageObject.getCurrentPageNo()==1?1:pageObject.getCurrentPageNo()-1%>)">
					     <U>P</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbba5b80004")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="N" onclick="onSearch(<%=pageObject.getCurrentPageNo()==pageObject.getTotalPageCount()? pageObject.getTotalPageCount():pageObject.getCurrentPageNo()+1%>)">
					     <U>N</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbbdc0a0005")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="L" onclick="onSearch(<%=pageObject.getTotalPageCount()%>)">
					     <U>L</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbc0c900006")%>
				        </button>
					</td>
					<td nowrap align=center>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:document.EweaverForm.submit();">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:document.EweaverForm.submit();">
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>       
    </form>
<script language="javascript" type="text/javascript">
    function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
	document.EweaverForm.submit();
   }    
    
</script>
  </body>
</html>

