<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.file.FileUpload" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    AttachService attachService = (AttachService) BaseContext.getBean("attachService");
	FileUpload fileUpload = new FileUpload(request);
		request = fileUpload.resolveMultipart();
		ArrayList fileinputs = fileUpload.getFileInputNameList();
		ArrayList attachids = fileUpload.getAttachList();
		Attach attach = null;
		//for (int i = 0; i < fileinputs.size(); i++) {
			String pName = (String) fileinputs.get(0);
			if (!StringHelper.isEmpty(pName)) {
			    attach = (Attach) attachids.get(0);
			    //attach.setId(IDGernerator.getUnquieID());
				attachService.createAttach(attach);
			}
		//}

	
	response.sendRedirect("GetUserIconSub.jsp?imagefileid="+attach.getId());	
	
%>