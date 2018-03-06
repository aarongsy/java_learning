<%@ include file="/common/taglibs.jsp"%>
<%@ page import="com.eweaver.base.util.*" %>
<%
String responseId = StringHelper.null2String(request.getAttribute("responseId"));
String portletId = StringHelper.null2String(request.getAttribute("portletId"));
String iframeUrl = StringHelper.null2String(request.getAttribute("iframeurl"));
iframeUrl += iframeUrl.indexOf("?")!=-1 ? "&responseId="+responseId : "?responseId="+responseId; 
%>
<table width="<%= request.getAttribute("iframewidth") %>" style="overflow: hidden;">    
    <tr>
        <td>
        	<c:if test='${requestScope.state == "normal"}'>
            <iframe id="<%=responseId%>_iframe" src="<%=iframeUrl %>" width="<%= request.getAttribute("iframewidth") %>" height="<%= request.getAttribute("iframeheight") %>" frameborder="0">
	            Your browser does not support iframes
            </iframe>
            </c:if>
            <c:if test='${requestScope.state == "maximized"}'>
            <iframe id="<%=responseId%>_iframe" src="<%=iframeUrl %>" width="<%= request.getAttribute("iframewidth") %>" height="<%= request.getAttribute("iframemaxheight") %>" border="0">
	            Your browser does not support iframes
            </iframe>
            </c:if>
        </td>
    </tr>
</table>