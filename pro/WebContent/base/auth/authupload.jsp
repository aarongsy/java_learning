<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.auth.service.SysAuthService" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.lics.service.LicsService" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
SysAuthService sysAuthService = (SysAuthService)BaseContext.getBean("sysAuthService"); 
Map<String,String> dataMap = sysAuthService.uploadAuth(request);
String uploaded=StringHelper.null2String(dataMap.get("uploaded"));
String sid = StringHelper.null2String(dataMap.get("sid"));
String status = StringHelper.null2String(dataMap.get("status"));
String updatedesc = StringHelper.null2String(dataMap.get("updatedesc"));;
String _titlename=labelService.getLabelName("402881e50c7d5585010c7d69d5a0000a");
String _titleimage=request.getContextPath()+"/images/main/titlebar_bg.jpg";
if(!StringHelper.isEmpty(updatedesc)) {
	request.getRequestDispatcher("/version/version.jsp").forward(request,response);
	return;
}
%>
<html>
  <head>
     <style type="text/css">
          a { color:blue; cursor:pointer; }
          TD.Fieldname { text-align:right;font-family: Microsoft YaHei }
          TD.FieldHead { text-align:center;font-family: Microsoft YaHei;font-size:16 }
          TD.FieldValue {background-color: #efefde;font-family: Microsoft YaHei}
          .twidth{text-align:center}
   </style>
  </head>
  <body>
<table height=50>                     
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.auth.servlet.SysAuthAction?action=authupload" name="EweaverForm" enctype="multipart/form-data" method="post">
	<tr height=10>
		<td class="FieldHead" colspan=2>
				授权文件上传
		</td>
	</tr>		
	<tr>
		<td class="FieldName"><%=labelService.getLabelName("402881e70c8099d8010c80bc353f000c")%> </td>
		<td class="FieldValue"><%=sid%></td>
	</tr>		
	<tr>
		<td class="FieldName"><font color="red"><b>许可状态</b></font></td>
		<td class="FieldValue"><font color="red"><b><%=status%></b></font></td>
	</tr>
	<tr>
		<td class="FieldName">授权文件
		</td>
		<td class="FieldValue" valign=top>
			<br><input type="file" name="file" size="40" />
		</td>
	</tr>	
	<tr>
		<td align="center" colspan = 2><button type="submit"  name="更新">更新</button></td>
	</tr>																							        

 </form> 
</table>   
  </body>
</html>
