<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%
    SetitemService setitemService0 = (SetitemService) BaseContext.getBean("setitemService");
    EweaverUser eweaveruser = BaseContext.getRemoteUser();
    Humres currentuser = eweaveruser.getHumres();
    String style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
    if(StringHelper.isEmpty(style)){
    	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
            style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
    }
%>
<!-- HTTP 1.1 -->
<meta http-equiv="Cache-Control" content="no-store"/>
<!-- HTTP 1.0 -->
<meta http-equiv="Pragma" content="no-cache"/>
<!-- Prevents caching at the Proxy Server -->
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/main.js'></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
