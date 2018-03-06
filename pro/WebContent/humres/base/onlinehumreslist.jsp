<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.log.model.Log"%>
<%@page import="com.eweaver.base.log.service.LogService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%
boolean useRTX=false;
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
Setitem rtxSet=setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");
if(rtxSet!=null&&"1".equals(rtxSet.getItemvalue())){
	useRTX=true;
}
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
SysuserService sysuserService=(SysuserService)BaseContext.getBean("sysuserService");
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
Vector humresList=BaseContext.getOnlineuserids();
String humresCount=""+humresList.size();
%>
<html>
  <head>
  	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
  </head>
  <body>
    	<br>
	   <table>
	   	   	<tr>
	   			<td colspan=2><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a001f")%><%=humresCount%></td><!--  在线人数：-->
	   		</tr>
	   		<tr class="Header">
	   			<td><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0020")%></td><!-- 人员名称 -->
	   			<td><%=labelService.getLabelNameByKeyId("402881e50de7d974010de7f72658013a")%></td><!-- 所属部门 -->
	   			<td><%=labelService.getLabelNameByKeyId("402881fc3b64b308013b64b30b2901db")%></td><!-- 登陆日期-->
	   			<td><%=labelService.getLabelNameByKeyId("8ad9844f3b64b639013b64b639e10247")%></td><!-- 登陆时间-->
	   			<td><%=labelService.getLabelNameByKeyId("8ad9844f3b64b639013b64b639e00228")%></td><!-- 登陆IP-->
	   			<td><%=labelService.getLabelNameByKeyId("8ad9844f3b64b639013b64b639de01cb")%></td><!-- 上次登陆日期-->
	   			<td><%=labelService.getLabelNameByKeyId("8ad9844f3b64b639013b64b639db0170")%></td><!-- 上次登陆时间-->
	   			</td>
	   		</tr>
<%
  boolean isLight=false;
   String trclassname="";
   LogService logService = (LogService)BaseContext.getBean("logService");
  for (int i=0;i<humresList.size();i++){
     String id = (String)humresList.get(i);
	 List<Log> loglist = logService.getBestNewByObjid(id);
	 Log log = loglist.get(0);
	 Log beforelog = null;
	 if(loglist.size()>1){
	 	beforelog = loglist.get(1);
	 }
     Humres humres=humresService.getHumresById(id);
     Sysuser u=sysuserService.getSysuserByObjid(humres.getId());
     if(u!=null) humres.setRtxNo(u.getLongonname());
     isLight=!isLight;
    if(isLight) trclassname="DataLight";
    else trclassname="DataDark";
%>
				  	<tr class="<%=trclassname%>">
						<td nowrap>
						 	<%=humres.getObjname()%>&nbsp;<%if(useRTX){%><img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humres.getRtxNo()%>');"><%}%>
						</td>
		                <td nowrap>					    
								 <%
								   String orgunitName ="";
			 					    Orgunit orgunit = orgunitService.getOrgunit(humres.getOrgid()) ;
			 					    if (orgunit!=null)
			 					       orgunitName = orgunit.getObjname();
			 					    
			 					 %>  
								 <%=orgunitName%>
						</td>
						<td>
						   <%=log.getSubmitdate() %>
						</td>
						<td>
						   <%=log.getSubmittime() %>
						</td>
						<td>
						   <%=log.getSubmitip() %>
						</td>
						<td>
						   <%if(beforelog!=null){
						   	  %>
						   	  <%=beforelog.getSubmitdate() %>
						   	  <%
						   }%>
						</td>
						<td>
						   <%if(beforelog!=null){
						   	  %>
						   	  <%=beforelog.getSubmittime() %>
						   	  <%
						   }%>
						</td>
					</tr>
<%}%>
	   </table>
  </body>
</html>
