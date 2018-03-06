<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>

<%

PagemenuService _pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");

if(pagemenuorder.equals("0")) {
	pagemenustr = _pagemenuService.getPagemenuStr(theuri,paravaluehm) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService.getPagemenuStr(theuri,paravaluehm);
}

String pagemenubarstr = _pagemenuService.getPagemenuBarstr(pagemenustr);

%>

<script language="JavaScript">
	window.document.getElementById("pagemenubar").innerHTML = "<%=pagemenubarstr%>";
</script>
