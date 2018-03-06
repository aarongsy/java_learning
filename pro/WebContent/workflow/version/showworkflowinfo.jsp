<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@ page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>

<%
		WorkflowVersionService workflowVersionService = (WorkflowVersionService) BaseContext.getBean("workflowVersionService");
		WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
		ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
		NodeinfoService nodeinfoService=(NodeinfoService)BaseContext.getBean("nodeinfoService");
		
		String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
		WorkflowVersion workflowVersion=workflowVersionService.getWorkflowVersionByWorkflowid(workflowid);
		Workflowinfo workflowinfo=workflowinfoService.get(workflowid);
		
		List<Nodeinfo> nodeinfos=nodeinfoService.getNodelistByworkflowid(workflowid);
%>

<html>
  <head>
  </head> 
  <body>
  		<div style="display:block;width:400px;">
		<table>	
			<tr class="Header">
				<td><%=workflowVersion.getVersion()%></td>
			</tr>
			<tr>
				<td>
					<table>
					<tr>
						<!--  流程名称 -->
						<td class="FieldName" nowrap width="100">
							<%=labelService.getLabelName("402881ee0c715de3010c72411ed60060")%><!-- 流程名称-->
						</td>
						<td class="FieldValue">
						<%=StringHelper.null2String(workflowinfo.getObjname())%>
						</td>
					</tr>
					<tr>
						<!--  流程表单 -->
						<td class="FieldName" nowrap width="100">
							<%=labelService.getLabelName("402881ee0c715de3010c7243a5fa0069")%><!-- 流程表单-->
						</td>
						<td class="FieldValue">
							<%String formname = "";
								if (!StringHelper.null2String(workflowinfo.getFormid()).equals("")) {
									Forminfo forminfo = forminfoService.getForminfoById(StringHelper
											.null2String(workflowinfo.getFormid()));
									if (forminfo != null)
										formname = forminfo.getObjname();
								}
							%><%=formname%>
						</td>
					</tr>
					<tr>
						<!-- 是否有效 -->
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402881e70c864b41010c867b2eb40010")%><!--流程状态--><!-- 是否有效-->
						</td>
						<td class="FieldValue">
	                           <% if (StringHelper.null2String(workflowinfo.getIsactive()).equals("1")){%><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%><%}%><!-- 显示 -->
	                           <% if (StringHelper.null2String(workflowinfo.getIsactive()).equals("2")){%><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%><%}%><!-- 隐藏 -->
	                           <% if (StringHelper.null2String(workflowinfo.getIsactive()).equals("0")){%><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0003")%><%}%><!-- 禁用 -->
						</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table>
					<%
					if(nodeinfos!=null&&nodeinfos.size()>0){
						for(int i=0;i<nodeinfos.size();i++){
							Nodeinfo nodeinfo=nodeinfos.get(i);
							%>
							<tr>
								<td class="FieldName" width="150">
									<!--  节点名称 -->
									<%=labelService.getLabelName("402881ee0c715de3010c7248aaad0072")%>：<%=StringHelper.null2String(nodeinfo.getObjname())%>
									<br>
									<!--  节点类型 -->
									<%=labelService.getLabelName("402881ee0c715de3010c724923d40075")%>：
									<%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("1")){%><%=labelService.getLabelName("402881ee0c765f9b010c76779a340007")%><%}%><!--  开始节点 -->
								    <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("2")){%><%=labelService.getLabelName("402881ee0c765f9b010c7679ec06000a")%><%}%><!--  活动节点 --> 
								    <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("3")){%><%=labelService.getLabelName("402881ee0c765f9b010c767a6e22000d")%><%}%><!--  子过程活动节点 --> 
								    <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("4")){%><%=labelService.getLabelName("402881ee0c765f9b010c767adf440010")%><%}%><!--  结束节点 -->
									<br>
								</td>
								<td class="FieldName" width="250"><iframe scrolling="auto" width="250" height="100" src="/base/security/viewrule.jsp?objtable=requestbase&istype=1&objid=<%=nodeinfo.getId()%>"></iframe></td>
							</tr>
							<%
						}
					}
					%>
					</table>
				</td>
			</tr>
		</table>
		</div>
  </body>
</html>