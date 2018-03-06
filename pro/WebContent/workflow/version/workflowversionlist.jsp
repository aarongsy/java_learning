<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>


<%//mjb********************************
		WorkflowVersionService workflowVersionService = (WorkflowVersionService) BaseContext.getBean("workflowVersionService");
		WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
		String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
		WorkflowVersion workflowVersion=workflowVersionService.getWorkflowVersionByWorkflowid(workflowid);
		List list = new ArrayList();
		if(workflowVersion!=null){
			String groupid=StringHelper.null2String(workflowVersion.getGroupid());
			String hql="from WorkflowVersion where groupid='"+groupid+"' order by version asc";
			list=workflowVersionService.getWorkflowVersions(hql);
		}
%>

<html>
  <head>
  </head> 
  <body>
  <div id="pagemenubar" style="z-index: 100;"></div>
		<div id="menubar">
			<button type="button" class='btn' accessKey="C" onclick="javascript:onComparewf();">
				<U>C</U>--<%=labelService
					.getLabelName("402881e50c3b7110010c3b9778e10039")%>比较 
			</button>
			<button type="button" class='btn' accessKey="C" onclick="javascript:onComparenode();">
				<U>D</U>--<%=labelService
					.getLabelName("402881f00c7690cf010c76b1f3260037")%>比较
			</button>
		</div>
		<%@ include file="/base/pagemenu.jsp"%>
  <form action="" target="_self" name="layoutform"  method="post">
			<table id="layoutTb">	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="40">
					<col width="30%">
					<col width="20%">
                    <col width="20%">
                    <col width="30%">
				</colgroup>
				<tr class="Header">
					<td style="text-align: center"><input type="checkbox" id="workflowidall" onclick="onWorkflowidall()"/></td>
					<td>流程名称</td>
                    <td>流程版本号</td>
					<td>创建日期时间</td>
					<td style="text-align: center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380074") %><!-- 动作 --></td>
				</tr>
				<%
					boolean isLight=false;
					String trclassname="";
				    for(int i=0;i<list.size();i++){
				        WorkflowVersion workflowVersion2=(WorkflowVersion)list.get(i);
						isLight=!isLight;
						if(isLight) trclassname="DataLight";
						else trclassname="DataDark";
				%>
				<tr class="<%=trclassname%>">
					<td nowrap align="center">
						<input type="checkbox" value="<%=workflowVersion2.getWorkflowid()%>" name="workflowid"/>
					</td>
					<td  nowrap>
						<%
						String objname=workflowinfoService.getWorkflowName(workflowVersion2.getWorkflowid());
						%>
						<a href="javascript:onModify('<%=workflowVersion2.getWorkflowid()%>')">
						<%=StringHelper.null2String(objname)%>
						</a>
                    </td>
					<td nowrap>
						<%=StringHelper.null2String(workflowVersion2.getVersion())%>
					</td>
                    <td nowrap>
                        <%=StringHelper.null2String(workflowVersion2.getCreatedate())%>
                    </td>
					<td nowrap>
						<%
							int isactive=NumberHelper.string2Int(workflowVersion2.getIsactive(),0);
							if(isactive==1){
								%>
								已启用
								<%
							}else{
								%>
								<a href="javascript:onActiveWorkflowVersion('<%=workflowVersion2.getWorkflowid()%>');">启用</a>
								<%
							}
						%>
						&nbsp;&nbsp;
						<a href="javascript:onVersionactivepolicy('<%=workflowVersion2.getWorkflowid()%>');">启用策略</a>
					</td>
				</tr>
				<%
				}
				%>
			</table>
	</form>
  </body>
</html>