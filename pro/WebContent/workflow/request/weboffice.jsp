<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.document.goldgrid.WebOffice"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%
EweaverUser eweaverUser=BaseContext.getRemoteUser();
Humres currentuser=eweaverUser.getHumres();
%>
<html>
  <head>
  </head>
  
  <body>
  	<div>
	    <object id="WebOffice" style="left:0px;height:300px" width="100%" classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
		<param name="WebUrl" value="<%=WebOffice.mServerName%>"/>
		<param name="FileName" value="docs"/>
		<param name="FileType" value=".doc"/>
		<param name="UserName" value="<%=currentuser.getObjname()%>"/>
		<param name="ShowMenu" value="1"/>
		<param name="ShowToolbar" value="0"/>
	</object>
	</div>
  </body>
</html>
