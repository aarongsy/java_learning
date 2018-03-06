<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String objid1=StringHelper.null2String(request.getParameter("objid1"));//当modify和view需要传objid1
String modelname=StringHelper.null2String(request.getParameter("modelname"));//当modify和view和create都要传modelname
String createobj=StringHelper.null2String(request.getParameter("createobj"));
String objtypeid1="";
if(modelname.equals("customer")){//客户
	objtypeid1="402881ea0c19fcd5010c1a1b9bea000b";
}else if(modelname.equals("product")){//产品
	objtypeid1="402881e50bff706e010bffce0979000a";
}else if(modelname.equals("project")){//项目
	objtypeid1="402881ea0c689eeb010c68d13a94000d";
}else if(modelname.equals("humres")){//员工
	objtypeid1="402881e70bc70ed1010bc75e0361000f";
}else if(modelname.equals("assets")){//资源
	objtypeid1="402881c60db02032010db02e71b60006";
}else if(modelname.equals("document")){//文档
	objtypeid1="402881e70bc70ed1010bc710b74b000d";
}
%>
	
	<IFRAME name=HomePageIframe2 id=HomePageIframe2 src="<%= request.getContextPath()%>/base/refobj/refobjlink.jsp?createobj=<%=createobj%>&objtypeid1=<%=objtypeid1%>&objid1=<%=objid1%>" width="100%" height="100%" frameborder=no scrolling=yes>
	浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>