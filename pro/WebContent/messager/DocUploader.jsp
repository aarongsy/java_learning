<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.file.FileUpload" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="org.springframework.web.multipart.MultipartException"%>
<%@ page import="org.springframework.web.multipart.MaxUploadSizeExceededException"%>

<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	DataService dataService = new DataService();
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	Humres currentuser = eweaveruser.getHumres();
	int filesize = NumberHelper.string2Int(request.getParameter("filesize"));
	String filetype = StringHelper.null2String(request.getParameter("filetype"));
	AttachService attachService = (AttachService) BaseContext.getBean("attachService");
	if(currentuser == null)  return ;
	//int imagefileid = NumberHelper.string2Int(fu.uploadFiles("Filedata"));
	FileUpload fileUpload = new FileUpload(request);
	fileUpload = new FileUpload(request);
	try {
		request = fileUpload.resolveMultipart(1,filesize);
		ArrayList fileinputs = fileUpload.getFileInputNameList();
		ArrayList attachids = fileUpload.getAttachList();
		Attach attach = null;
		//for (int i = 0; i < fileinputs.size(); i++) {
			String pName = (String) fileinputs.get(0);
			if (!StringHelper.isEmpty(pName)) {
			    attach = (Attach) attachids.get(0);
			    if (!StringHelper.isEmpty(attach.getObjname())) {
				    String suffix = attach.getObjname().substring(attach.getObjname().lastIndexOf(".")+1);
				    if (filetype.indexOf(suffix) > 0) {
				        throw new SecurityException(); 
				    }
				}
				attachService.createAttach(attach);
			}
		//}
		String imagefileid = StringHelper.null2String(fileUpload.getFileName());
		if (!StringHelper.isEmpty(imagefileid)) {
		   imagefileid = StringHelper.null2String(imagefileid.substring(imagefileid.lastIndexOf("\\"))).trim();
		}
	    String currentdate = DateHelper.getCurrentDate();
	    String currenttime = DateHelper.getCurrentTime();
	    String sql = "insert into imagefiletemp(id,imagefileid,docid,createid,createdate,createtime) values('"+IDGernerator.getUnquieID()+"','"+attach.getId()+"','0','"+currentuser.getId()+"','"+currentdate+"','"+currenttime+"')";
		dataService.executeSql(sql);
		out.println("{type:'imagefileid',value:'"+attach.getId()+"'}");
    } catch (MaxUploadSizeExceededException e) {
		out.println("{type:'imagefileid',value:'0'}");
	} catch (SecurityException e) {
        out.println("{type:'imagefileid',value:'1'}");
    }   catch (MultipartException me) {
		out.println("{type:'imagefileid',value:'0'}");
	}

%>



