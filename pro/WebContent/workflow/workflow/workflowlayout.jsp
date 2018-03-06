<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>

<%
    String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
// WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");

    String serverName = request.getServerName();
	String serverPort = "" + request.getServerPort();

			//if (workflowid == null)
			//	workflowid = "402881e90c5e2666010c5e2ecc18000b";
			//  String remoteAddr = request.getRemoteAddr();
			//  String remoteHost = request.getRemoteHost();
			//  String localAddr = request.getLocalAddr();
			//  String localName = request.getLocalName();

			%>

<html>
	<head>
	</head>
	<body>
		<form name="EweaverForm" method="post" action="<%=request.getContextPath()%>/workflow/workflow/workflowlayout.jsp">
			<!-- div style="position:absolute;left:0;top:0;width:250;height:1024">
				<select class=inputstyle name="workflowinfo" id="workflowinfo" ondblclick="show()" size="27" style="position:absolute;left:0;top:0;width:250;height:1024">

			    </select>
			</div-->
			<!-- div style="position:absolute;left:252;top:0;width:1024;height:1024"-->
				<object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" width=1280 height=1024 codebase="">

					<param name=CODE value=com.eweaver.workflow.layout.WorkflowEditor.class>
					<param name=CODEBASE value=<%=request.getContextPath()%>/applet>
					<param name="type" value="application/x-java-applet;jpi-version=1.5.0">
					<param name="scriptable" value="false">
					<param name="MAYSCRIPT" value="true">
					<param name=serverName value="<%=serverName%>">
					<param name=serverPort value="<%=serverPort%>">
					<param name=workflowid value="<%=workflowid%>">
                    <param name=contextPath value="<%=request.getContextPath()%>">
				</object>
			<!-- /div-->
		</form> 

<script language="javascript">		
function show() {
    var workflowinfoSelect = document.getElementById("workflowinfo");
    for (i=0;i<workflowinfoSelect.size;i++) {
        if (workflowinfoSelect.options[i].selected) {
            EweaverForm.action = "<%=request.getContextPath()%>/workflow/workflow/workflowlayout.jsp?workflowid="+workflowinfoSelect.options[i].value;
            EweaverForm.submit();
            break;
        }
    }
}


</script>	
	</body>
</html>
