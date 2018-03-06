<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<HTML><HEAD>
</HEAD>
<%
String noteid=StringHelper.null2String(request.getParameter("noteid"));
String notedesc=labelService.getLabelName("402881e50b766b08010b76d334480008");
if(!noteid.equals("")){
	notedesc=labelService.getLabelName(noteid);
}
%>
<BODY>
  <table>
	  <tr>
		  <td align=center valign=middle>
				<%=notedesc%>			  
		  </td>
	  </tr>
  </table>
</BODY>