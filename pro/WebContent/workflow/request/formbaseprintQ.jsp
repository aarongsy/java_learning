<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.layout.ShowFlow" %>
<%@ page import="com.eweaver.workflow.stamp.model.Stampinfo" %>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.StampinfoService" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%
	FormService fs = (FormService)BaseContext.getBean("formService");
    ImginfoService imginfoService = (ImginfoService) BaseContext.getBean("imginfoService");

    String pstyle = StringHelper.null2String(request.getParameter("style"));
    String printLayout = StringHelper.null2String(request.getParameter("printLayout"));
	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
	String categoryid = StringHelper.null2String(request.getParameter("categoryid")).trim();
	String show = StringHelper.null2String(request.getParameter("show")).trim();
	String printdirection = StringHelper.null2String(request.getParameter("printdirection"));
    String zoom = StringHelper.null2String(request.getParameter("zoom"));
    String printType = StringHelper.null2String(request.getParameter("printType"));
	String leftsize = StringHelper.null2String(request.getParameter("leftsize")).trim();
	String rightsize = StringHelper.null2String(request.getParameter("rightsize")).trim();
	String header = StringHelper.null2String(request.getParameter("header")).trim();
	String footer = StringHelper.null2String(request.getParameter("footer"));
    String pagedialog = StringHelper.null2String(request.getParameter("pagedialog"));
	String printdialog = StringHelper.null2String(request.getParameter("printdialog")).trim();
	String checkbox2 = StringHelper.null2String(request.getParameter("checkbox2"));
	String checkbox1 = StringHelper.null2String(request.getParameter("checkbox1"));	
%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>打印</title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
var topBar=null;
WeaverUtil.load(function(){
	setTimeout("printPrv()","1000");
});
function printPrv ()
{  
  document.getElementById("repContainer").innerHTML=printContent.document.body.innerHTML;
  var url="/workflow/request/formbaseprintview.jsp";
  document.EweaverPrint.target="printpage";
  document.EweaverPrint.submit();
  //setTimeout("closeDlg()","2000");
}
function closeDlg()
{
  //	parent.dlg1.hide();
	//parent.dlg1.getComponent('dlgpanel').setSrc('about:blank');

}
</script>
<body onload="//loadEvent()">
<form action="workflowprintview.jsp" name="EweaverPrint"  method="post" target="">
<input type="hidden" name="printLayout" value="<%=printLayout%>">
<input type="hidden" name="opType" value="preview">
<input type="hidden" name="printdirection" value="<%=printdirection%>">
<input type="hidden" name="zoom" value="<%=zoom%>">
<input type="hidden" name="printType" value="<%=printType %>">
<input type="hidden" name="leftsize" value="<%=leftsize%>">
<input type="hidden" name="rightsize" value="<%=rightsize%>">
<input type="hidden" name="header" value="<%=header%>">
<input type="hidden" name="footer" value="<%=footer%>">
<input type="hidden" name="pagedialog" value="<%=pagedialog%>">
<input type="hidden" name="printdialog" value="<%=printdialog%>">
<div style="display:none" id="repContainer">
</div>
</form>
<iframe id="printContent" name="printContent" src="formbaseprint.jsp?pstyle=<%=pstyle%>&printLayout=<%=printLayout%>&requestid=<%=requestid%>&printType=<%=printType%>&show=<%=show%>&checkbox1=<%=checkbox1%>&checkbox2=<%=checkbox2%>&categoryid=<%=categoryid %>" style="display:none">
</iframe>
</body>
</html> 


			