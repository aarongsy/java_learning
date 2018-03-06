<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.document.file.*"%>
<%@ page import="com.eweaver.base.security.service.acegi.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<%
String PATH=BaseContext.getRootPath();
String dir = request.getParameter("dir");
if(dir==null){
	dir = PATH;
}
File file = new File(dir);
File parent = null;
File[] fs=null;
if(file!=null){
	fs = file.listFiles();
	parent=file.getParentFile();
}
%>
<html>
<head>
<title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980049")%></title><!-- 选择目录 -->
</head>
<body>
<table border="1" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="20px">
		<col width="100%">
	</colgroup>
	<caption><%=file.getAbsolutePath()%></caption>
<tr>
	<td>&nbsp;</td>
	<td>
	<%if(parent!=null){
		String parentPath = URLEncoder.encode(parent.getAbsolutePath(),"UTF-8");
	%>
	<a href="filebrowser.jsp?dir=<%=parentPath%>">[...]</a>
	<%}%>
	</td>
</tr>
<%for(File f:fs){
	if(f.isDirectory()){
	String fileName = f.getName();
	String absPath = URLEncoder.encode(f.getAbsolutePath(),"UTF-8");
%>
<tr>
	<td> <input type="radio" name="dir" value="<%=absPath%>" onclick="selectIt(this);" dir="<%=f.getAbsolutePath()%>"></td>
	<td><a href="filebrowser.jsp?dir=<%=absPath%>"><%=fileName%></a></td>
</tr>
<%
	}
}%>
</table>
</body>
<script type="text/javascript">
function selectIt(radio){
	var dir = radio.getAttribute("dir");
	window.opener.document.getElementById("addedFile").value= dir;
	window.opener.document.getElementById("addfileCheck").style.display= "none";
	window.close();
}
</script>
</html>