<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<html>
  <head>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/doc/book.gif'); margin-bottom: 4}
</Style>
  </head> 
  <body>
  <!--页面菜单开始-->     
<%
String objid = request.getParameter("objid");
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
String desc = docbaseService.getDocbaseAbstract(objid);

pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  
  
<TEXTAREA NAME="desc" id="desc" ROWS="25" COLS="59" readonly>
<%=desc %>
</TEXTAREA>
  </body>
</html>
<script language=javascript>
   function onSubmit(){
    var value =document.all("desc").value;
    window.returnValue=id;
    window.close()
   }
</script>