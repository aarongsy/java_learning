 <%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.lics.service.LicsService" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.lics.model.Lics" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.auth.service.SysAuthService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2009-2-10
  Time: 15:59:21
  To change this template use File | Settings | File Templates.
--%>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
  SysAuthService sysAuthService = (SysAuthService)BaseContext.getBean("sysAuthService");
  SysuserService sysuserService = (SysuserService)BaseContext.getBean("sysuserService");
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");    
  String sql="select * from versioninfo";
  List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);
  sysAuthService.loadAuth(request);
  int usernum = sysuserService.getUsernum(1,0);
  Map<String,String> authMap = (Map<String,String>)request.getAttribute("auth");
  if(authMap == null) {
	  authMap = new HashMap<String,String>();
  }
%>
<html>
  <head>
   <style type="text/css">
          a { color:blue; cursor:pointer; }
          TD.Fieldname { text-align:right;font-family: Microsoft YaHei }
          TD.FieldValue {background-color: #efefde;font-family: Microsoft YaHei}
          .twidth{text-align:center}
   </style>
  </head>
  <body>
  <table align="center">
      <tr>
         <table align="center">
            <tr align="center">
          		<td ><img src="<%=request.getContextPath()%>/images/base/tu44.gif" alt="" ></td>
      		</tr>
      		<tr align="center">
         		<td><h1><b>e-Weaver</b></h1></td>
      		</tr>
         </table>
      </tr>
      <tr>
       			<table class="twidth">
       				<tr>
       <td class="Fieldname"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7248a32000d")%>：<!-- 版本 --></td><td class="Fieldvalue"><%
               for (Object o : list) {
            %>
           <%=(String) ((Map) o).get("verno")%>
            <%}%></td>

      </tr>
      <tr >
          <td class="Fieldname">授权于：<!-- 授权用户 --></td><td class="Fieldvalue"><%=StringHelper.null2String(authMap.get("orgunit"))%></td>
      </tr>
      <tr >
          <td class="Fieldname">授权类型：<!-- 授权用户 --></td><td class="Fieldvalue"><%=StringHelper.null2String(authMap.get("licType"))%></td>
      </tr>
      <tr >
          <td class="Fieldname"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790022")%>：<!-- 授权用户数 --></td><td class="Fieldvalue"><%=StringHelper.null2String(authMap.get("maxLic"))%></td>
      </tr>
      </tr>
           <tr >
          <td class="Fieldname">当前用户数：<!-- 授权用户数 --></td><td class="Fieldvalue"><%=usernum%></td>
      </tr>
             <tr >
          <td class="Fieldname"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790023")%>：<!-- 到期日期 --></td><td class="Fieldvalue"><%=StringHelper.null2String(authMap.get("expDate"))%></td>
      <tr >
          <td class="Fieldname"><font color="red"><b>许可状态：</b></font><!-- 到期日期 --></td><td class="Fieldvalue"><font color="red"><b><%=StringHelper.null2String(authMap.get("licStatus"))%></b></font></td>
      
       <tr align="center">
          <td colspan=2><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790025")%><!-- 版权所有 --> © Shanghai Weaver Software Co.,Ltd</td>
      </tr>

      <tr align="center">
          <td colspan=2><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790026")%><!-- 泛微网站 -->：<a href="http://www.weaver.com.cn" target='_blank'>www.weaver.com.cn</a></td>
      </tr>
       </table>
      </tr>
  </table>
  </body>
</html>