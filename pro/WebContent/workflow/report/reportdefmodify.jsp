<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<jsp:useBean id="forminfoService" class="com.eweaver.workflow.form.service.ForminfoService" />
<%
List reportfieldList = (List)request.getAttribute("reportfieldList");
String reportid = request.getParameter("reportid");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title><%=labelService.getLabelName("402881e50b8e316a010b8e6a55fb0008")%></title>
  </head>
  
  <body>
    <!-- 标题 -->
<!--页面菜单开始-->     
<%
pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",javascript:onPopup('"+request.getContextPath()+"/workflow/report/reportfieldcreate.jsp')}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 	
<a href="<%=request.getContextPath()%>/workflow/report/reportfieldcreate.jsp?reportid=<%=reportid%>"><%=labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")%></a>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=search" name="EweaverForm" method="post">
		<input type="hidden" name="id" value='' />
		<input type="hidden" name="forminfo_id" value='' />
		<input type="hidden" name="objtype" value='' />

		
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<!-- 列名行 -->	
				<tr class="Header">
					<td><%=labelService.getLabelName("402881eb0bcbfd19010bcc55f035001a")%>
					</td>
					<td>
					<%=labelService.getLabelName("402881e70c90eb3b010c910fc4a70007")%>
					</td>
					<td>
					  <%=labelService.getLabelName("402881e70c90eb3b010c91106f7d000a")%>
					</td>
					<td>
					  <%=labelService.getLabelName("402881e70c90eb3b010c91129376000d")%>
					</td>
					<td>
					  <%=labelService.getLabelName("402881e70c90eb3b010c911423ea0010")%>
					</td>
				</tr>
				<%
				
					boolean isLight=false;
					String trclassname="";

			        
				    for(int i=0;i<reportfieldList.size();i++)
				    {
				        Reportfield reportfield =(Reportfield)reportfieldList.get(i);
				        
						isLight=!isLight;
						if(isLight) trclassname="DataLight";
						else trclassname="DataDark";
				%>
				<tr class="<%=trclassname%>">
					<td nowrap>
						<%=StringHelper.null2String(reportfield.getShowname())%>
					</td>
					<td nowrap>
						<%=StringHelper.null2String(reportfield.getIsorderfield())%>
					</td>
					<td nowrap>
						<%=StringHelper.null2String(reportfield.getIssum())%>
					</td>
					<td nowrap>
						<%=StringHelper.null2String(reportfield.getHreflink())%>
					</td>
					<td nowrap>
						<%=StringHelper.null2String(reportfield.getAlertcond())%>
					</td>	
				</tr>
				<%
				  }
				
				%>
			</table>
			<br>

		</form>
  </body>
</html>


