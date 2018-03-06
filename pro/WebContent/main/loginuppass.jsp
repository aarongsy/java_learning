<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%
DataService dateservice1 = new DataService();
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
if(eweaveruser1!=null){
String sql1 = "select isupdatepass from loginuppass where isdelete =0 and objid ='"+eweaveruser1.getHumres().getId()+"'";
List<Map<String,Object>> list1 = dateservice1.getValues(sql1);
String str = dateservice1.getValue("select itemvalue from setitem where id='297e930d347445a101347445ca4e0000'");
if(list1 == null  && str!=null && "1".equals(str)){
%>
<script language="javascript">
var obj = window;
if(window.opener != null && obj.opener != obj){
	obj.close();
	obj = window.opener;
}
while(obj.parent != null && obj.parent != obj)
	obj = obj.parent; 
obj.location = "/main/updatepassword.jsp?objid=<%=eweaveruser1.getHumres().getId()%>";
</script>
<%
}else if ( str!=null && "1".equals(str) && list1.size()== 0 ){
	%>
	<script language="javascript">
	var obj = window;
	if(window.opener != null && obj.opener != obj){
		obj.close();
		obj = window.opener;
	}
	while(obj.parent != null && obj.parent != obj)
		obj = obj.parent; 
	obj.location = "/main/updatepassword.jsp?objid=<%=eweaveruser1.getHumres().getId()%>";
	</script>
	<%
}else if ( str!=null && "1".equals(str) && (list1.size()> 0 && !"1".equals(list1.get(0).get("isupdatepass").toString()))){
	%>
	<script language="javascript">
	var obj = window;
	if(window.opener != null && obj.opener != obj){
		obj.close();
		obj = window.opener;
	}
	while(obj.parent != null && obj.parent != obj)
		obj = obj.parent; 
	obj.location = "/main/updatepassword.jsp?objid=<%=eweaveruser1.getHumres().getId()%>";
	</script>
	<%
}
else{
%>
	<script language="javascript">
	var obj = window;
	if(window.opener != null && obj.opener != obj){
		obj.close();
		obj = window.opener;
	}
	while(obj.parent != null && obj.parent != obj)
		obj = obj.parent; 
	obj.location = "/main/main.jsp";
	</script>
<%
}
}else{
	%>
	<script language="javascript">
	var obj = window;
	if(window.opener != null && obj.opener != obj){
		obj.close();
		obj = window.opener;
	}
	while(obj.parent != null && obj.parent != obj)
		obj = obj.parent; 
	obj.location = "/main/login.jsp";
	</script>
	<%	
}
%>