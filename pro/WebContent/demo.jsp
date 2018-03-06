<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%
	String action = StringHelper.null2String(request.getParameter("action"));
	if(action.equals("doIt")){
		String v = StringHelper.null2String(request.getParameter("textarea1"));
		session.setAttribute("textarea1Value", v);
		v = StringHelper.filterSqlChar(v);
		session.setAttribute("textarea2Value", v);
		response.sendRedirect("/demo.jsp?action=showResult");
		return;
	}else if(!action.equals("showResult")){
		session.removeAttribute("textarea1Value");
		session.removeAttribute("textarea2Value");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript">
		function doIt(){
			document.getElementById("form1").submit();
			/*
			var v = document.getElementById("textarea1").value;
			jQuery.ajax({
				type: "POST",
				url: "/demo.jsp?action=doIt&value="+v,
				success: function(msg){
			      document.getElementById("textarea2").value = msg;
				}
			});*/
		}
	</script>
  </head>
  <body>
  	<form id="form1" method="post" action="/demo.jsp?action=doIt">
  		<textarea id="textarea1" name="textarea1" rows="10" cols="30%"><%=StringHelper.null2String(session.getAttribute("textarea1Value")) %></textarea>
  		<input type="button" value="doIt" onclick="doIt();"/>
  	</form>
  	<textarea id="textarea2" rows="10" cols="30%"><%=StringHelper.null2String(session.getAttribute("textarea2Value")) %></textarea>
  </body>
</html>







































