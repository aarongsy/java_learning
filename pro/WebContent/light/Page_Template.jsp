<jsp:directive.page contentType="text/html; charset=UTF-8"/>
<jsp:directive.include file="/common/taglibs.jsp"/>
<jsp:directive.include file="/light/init.jsp"/>
<jsp:declaration><![CDATA[
private void main(HttpServletRequest request){
	List<String> list1=new ArrayList<String>();
	for(int i=0;i<20;i++){
		list1.add("PortletConfig_"+i);
	}

	request.setAttribute("list1",list1);
}//end main;
]]>
</jsp:declaration>
<jsp:scriptlet>this.main(request);</jsp:scriptlet>
<html>
<head>
<jsp:include flush="true" page="/common/meta.jsp"/>
<title>PortletConfig</title>
</head>
	<body>	
	<h3>PortletConfig。。。</h3>
	<ol>
	<c:forEach items="${list1}" var="i">
	<li><c:out value="${i}"/></li>
	</c:forEach>
	<ol>
	</body>
</html>