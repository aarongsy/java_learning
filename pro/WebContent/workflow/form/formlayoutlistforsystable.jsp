<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.util.FormLayoutTranslate"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");



String id=request.getParameter("forminfoid");
String strDefHql="from Formlayout where formid='"+id+"'";
List list = ((FormlayoutService)BaseContext.getBean("formlayoutService")).findFormlayout(strDefHql);

%>

<html>
  <head>
  </head> 
  <body>
		<div id="menubar">
		<!-- 新增按钮 -->
		    <button type="button" class='btn' accessKey="E" onclick="javascript:oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=2&forminfoid=<%=id%>');">
				<U>E</U>--<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001f") %><!--默认编辑布局 -->
		    </button>
		    <button type="button" class='btn' accessKey="V" onclick="javascript:oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=1&forminfoid=<%=id%>');">
				<U>V</U>--<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0020") %><!--默认显示布局 -->
		    </button>
		</div>	
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="50%">
					<col width="30%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr class="Header">
					<td><%=labelService.getLabelName("402881ec0bdbf198010bdbf3138d0002")%></td><!--应用对象 -->
					<td><%=labelService.getLabelName("402881ec0bdbf198010bdbf3ae300003")%></td><!--布局类型 -->
					<td>
					  
					</td>
					<td>
					  
					</td>
				</tr>
				<%
			
					
					boolean isLight=false;
					String trclassname="";
				    for(int i=0;i<list.size();i++)
				    {
				        Formlayout formlayout=(Formlayout)list.get(i);
				        
						isLight=!isLight;
						if(isLight) trclassname="DataLight";
						else trclassname="DataDark";
				%>
				<tr class="<%=trclassname%>">
					<td  nowrap>
						<%if(formlayout.getLayoutname()!=null){%>
                            <%=formlayout.getLayoutname()%>
                        <%}%>
                    </td>
					<td nowrap>
						<%=FormLayoutTranslate.getLayoutById(formlayout.getTypeid().intValue())%>
					</td>
					<td nowrap><a href="javascript:oncreateformlayout('/workflow/form/formlayoutinfo.jsp?forminfoid=<%=id%>&layoutid=<%=formlayout.getId()%>&nodeid=<%=formlayout.getNodeid()%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa85f6f3d0002")%></a></td>
					<td nowrap>
				       <a href="javascript:onDeleteFormlayout('<%=formlayout.getId()%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%></a>
					</td>
				</tr>
				<%
				}
				%>
			</table>
	</form>
  </body>
</html>

