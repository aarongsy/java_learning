<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ include file="/base/init.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head><title><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98002b")%></title><!-- PDF查看 -->
<%
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
String attachid = StringHelper.null2String(request.getParameter("attachid"));
Attach attach = attachService.getAttach(attachid);
String src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+attachid+"&isdownload=1&inline=1";
%>
<script type="text/javascript">
function detectedPDF(){
	if(!isAcrobatPluginInstall()){
		document.getElementById("IfNoAcrobat").style.display="";
		document.getElementById("pdf").style.display="none";
	}else{
		 pdf.setShowToolbar(0);
	}
}
function isAcrobatPluginInstall(){
 if(navigator.plugins && navigator.plugins.length){
	  for (x=0; x<navigator.plugins.length;x++ ){
	   if(navigator.plugins[x].name== 'Adobe Acrobat')
	   return true;
	  }
 }
 else if(window.ActiveXObject){
	  for (x=2; x<10; x++ ){
		   try{
			oAcro=eval("new ActiveXObject('PDF.PdfCtrl."+ x +"')");
			 if (oAcro){
			  return true;
			 }
		   }catch(e){}
	  }
	  try{
	   oAcro4=new ActiveXObject('PDF.PdfCtrl.1');
	   if (oAcro4)
	   return true;
	  }catch(e){}
	  try{
	   oAcro7=new ActiveXObject('AcroPDF.PDF.1');
	   if (oAcro7)
	   return true;
	  }catch(e){}
 }
 return false;
}
 </script>
 </head>
 <body onload="detectedPDF();">
 <object id="pdf" type="application/pdf" name="pdf"  width="100%"  height="100%"  border="0"> 
<param  name="src"  value="<%=src%>">
<param name="toolbar" value="false">
</object> 
<DIV id="IfNoAcrobat" style="display:none"><!-- 你需要先安装Adobe Reader才能正常浏览文件，请点击这里 -->
	<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98002c")%><a><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98002d")%></a>.<!-- 下载Adobe Reader -->
</DIV>
</html>