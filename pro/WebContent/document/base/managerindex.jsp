<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<html>
  <head>
  </head> 
<frameset cols="280,*" frameborder="no" border="0" framespacing="0">
  <frame src="categorylist.jsp" name="categoryleftframe" scrolling="auto">
  <frame name="categorymainframe">
</frameset>
<noframes><body><%=labelService.getLabelNameByKeyId("402881eb0bd6394d010bd653340c0002")%><!-- 浏览器不支持框架 -->
</body></noframes>
</html>

