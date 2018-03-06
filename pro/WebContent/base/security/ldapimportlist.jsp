<%@ page import="com.eweaver.base.security.service.logic.LdapService" %>
<%@ page contentType="text/html; charset=UTF-8"%>


<%@ include file="/base/init.jsp"%>

<html>
  <head>
  </head>
  <body>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    LdapService ldapService = (LdapService)BaseContext.getBean("ldapService");
    List l=ldapService.exportUserByTime();
    titlename="Ldap数据同步:"+l.size();
%>
<!--页面菜单开始-->     
<%
//pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",javascript:history.back()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

<table style="border:0">
	<tr class="Header">
		<td nowrap>姓名</td>
		<td nowrap>账号</td>
		<td nowrap>同步类型</td>
	</tr>
<%

if (l.size() != 0){
	boolean isLight=false;
	String trclassname="";
	for (int i = 0; i < l.size(); i++){
		Map ldapImportMap = (Map) l.get(i);
        Humres hr=(Humres)ldapImportMap.get("humres");
        String actionType=(String)ldapImportMap.get("actionType");
        String logonname=(String)ldapImportMap.get("account");
        if(actionType.equals("create"))
        actionType="新建";
        else if(actionType.equals("modify"))
        actionType="更新";
        isLight=!isLight;
		if(isLight) trclassname="DataLight";
			else trclassname="DataDark";		
%>
		<tr class="<%=trclassname%>">     
			<td nowrap><A href="javascript:onPopup('/humres/base/humresview.jsp?id=<%=hr.getId()%>')"><%=StringHelper.null2String(hr.getObjname())%></a></td>
			<td ><%=StringHelper.null2String(logonname)%></td>
			<td ><%=StringHelper.null2String(actionType)%></td>

		</tr> 
	        
<%
	}
}
%>
</table>
  </body>
</html>
