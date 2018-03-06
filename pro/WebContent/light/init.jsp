<jsp:directive.page contentType="text/html; charset=UTF-8" isELIgnored ="true"/>
<jsp:directive.page import="java.util.*"/>
<jsp:directive.page import="com.eweaver.base.util.*"/>
<jsp:directive.page import="com.eweaver.base.*"/>
<jsp:directive.page import="com.eweaver.base.BaseContext"/>
<jsp:directive.page import="com.eweaver.base.label.service.LabelService"/>
<jsp:directive.page import="com.eweaver.base.security.service.acegi.EweaverUser"/>
<jsp:directive.page import="com.eweaver.humres.base.model.Humres"/>
<jsp:directive.page import="com.eweaver.humres.base.service.HumresService"/>
<jsp:directive.page import="org.light.portal.core.PortalUtil"/>
<jsp:scriptlet>
EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
</jsp:scriptlet>
<script language="javascript">
var obj = window;
if(window.opener != null && obj.opener != obj){
	obj.close();
	obj = window.opener;
}
while(obj.parent != null && obj.parent != obj)
	obj = obj.parent; 
	
obj.location = "<%=request.getContextPath()%>/main/login.jsp";

</script>
<jsp:scriptlet>
	return;
}

String titlename="WeaverSoft Eweaver";
String titleimage="/images/main/titlebar_bg.jpg";
String pagemenustr="";
String pagemenuorder="0";
HashMap paravaluehm = new HashMap();
String theuri = request.getRequestURI();	
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
</jsp:scriptlet>