<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.document.file.FileUpload"%>
<%@page import="com.eweaver.document.base.model.Attach"%>
<%@page import="com.eweaver.document.base.service.AttachService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%--
   FileUpload fu = new FileUpload(request,"GBK");
   String ename = Util.null2String(request.getParameter("ename"));
   if("".equals(ename)){
	   ename="imgFile";
   }else{
	   ename="imgFile_"+ename;
   }
   String docid=fu.uploadFiles(ename);
   String docname = fu.getFileName();
   JSONObject obj = new JSONObject();
   obj.put("error", new Integer(0));
   obj.put("url", "/weaver/weaver.file.FileDownload?fileid="+docid);
   obj.put("name", docname);
   
   response.setContentType("text/html;charset=GBK");
   PrintWriter outer = response.getWriter();
   outer.println(obj.toString());
--%>
<%
	FileUpload fileUpload = new FileUpload(request);
	request = fileUpload.resolveMultipart();
   String ename = StringHelper.null2String(request.getParameter("ename"));
   if("".equals(ename)){
	   ename="imgFile";
   }else{
	   ename="imgFile_"+ename;
   }
   
   ArrayList fileinputs = fileUpload.getFileInputNameList();
   ArrayList attachids = fileUpload.getAttachList();
   Attach attach = null;
   for(int i=0;i<fileinputs.size();i++){
	   //System.out.println(fileinputs.get(i));
	   attach = (Attach)attachids.get(i);
	   AttachService attachService = (AttachService)BaseContext.getBean("attachService");
	   attachService.createAttach(attach);
   }
   if(attach!=null){
	   String docid=attach.getId();
	   String docname = attach.getObjname();
	   JSONObject obj = new JSONObject();
	   obj.put("error", new Integer(0));
	   obj.put("url", "/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+docid);
	   obj.put("name", docname);
	   
	   response.setContentType("text/html;charset=UTF-8");
	   PrintWriter outer = response.getWriter();
	   outer.println(obj.toString());
   }
%>