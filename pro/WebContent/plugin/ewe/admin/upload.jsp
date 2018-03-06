<%@ page contentType="text/html;charset=gb2312" pageEncoding="GB2312" session="true"%>
<%request.setCharacterEncoding("GB2312");%>
<%@ include file="private.jsp"%>
<%
/*
*######################################
* eWebEditor v3.80 - Advanced online web based WYSIWYG HTML editor.
* Copyright (c) 2003-2006 eWebSoft.com
*
* For further information go to http://www.ewebsoft.com/
* This copyright notice MUST stay intact for use.
*######################################
*/


String sStyleID = "", sUploadDir = "", sCurrDir = "", sDir = "";
int nStyleID = 0;
sPosition = sPosition + "上传文件管理";

out.print(Header());

sStyleID = dealNull(request.getParameter("id"));
if (isNumber(sStyleID)) {
	nStyleID = Integer.valueOf(sStyleID).intValue();
	if (nStyleID < aStyle.size()) {
		sUploadDir = split(aStyle.get(nStyleID).toString(), "|||")[3];
	}
}
if (sUploadDir.equals("")) {
	sStyleID = "";
}else{
	sUploadDir = replace(sUploadDir, "\\", "/");

	if (!sUploadDir.substring(sUploadDir.length()-1, sUploadDir.length()).equals("/")){
		sUploadDir += "/";
	}
	if (!sUploadDir.substring(0, 1).equals("/")){
		sUploadDir = "../" + sUploadDir;
	}
}

String sServletPath = request.getServletPath();

sCurrDir = sUploadDir;

sDir = dealNull(request.getParameter("dir"));
if (!sDir.equals("")) {
	if (CheckValidDir(application.getRealPath(RelativePath2RootPath2(sUploadDir+sDir, sServletPath)))){
		sCurrDir = sUploadDir + sDir + "/";
	}else{
		sDir = "";
	}
}




if (sAction.equals("DELALL")){

	File oFile = new File(application.getRealPath(RelativePath2RootPath2(sCurrDir, sServletPath)));
	String[] oFileList = oFile.list();
	if (oFileList != null) {
		for (int i = 0; i < oFileList.length; i++) {
			File f = new File(oFile, oFileList[i]);			
			if (f.isFile()) {
				f.delete();
			}
		}
	}

}else if (sAction.equals("DEL")){

	String[] s_DelFiles = new String[]{};
	if (request.getParameterValues("delfilename")!=null){
		s_DelFiles = request.getParameterValues("delfilename");
	}
	if (s_DelFiles != null){
		for (int i=0; i<s_DelFiles.length; i++){
			String s_DelFile = s_DelFiles[i];
			File f = new File(application.getRealPath(RelativePath2RootPath2(sCurrDir+s_DelFile, sServletPath)));
			if (f.exists()){
				f.delete();
			}
		}
	}

}else if (sAction.equals("DELFOLDER")){


	String s_FolderName = dealNull(request.getParameter("foldername"));
	File f = new File(application.getRealPath(RelativePath2RootPath2(sCurrDir+s_FolderName, sServletPath)));
	if (f.exists()){
		f.delete();
	}

}



// Show List
out.print("<table border=0 cellspacing=1 align=center class=navi>" +
	"<form action='?' method=post name=queryform>" +
	"<tr><th>" + sPosition + "</th></tr>" +
	"<tr><td align=right><b>选择样式目录：</b><select name='id' size=1 onchange=\"location.href='?id='+this.options[this.selectedIndex].value\">" + InitSelect(aStyle, sStyleID, "选择...") + "</select></td></tr>" +
	"</form></table><br>");

if (!sCurrDir.equals("")){

	out.print("<table border=0 cellspacing=1 class=list align=center>" +
		"<form action='?id=" + sStyleID + "&dir=" + sDir + "&action=del' method=post name=myform>" +
		"<tr align=center>" +
			"<th width='10%'>类型</th>" +
			"<th width='50%'>文件地址</th>" +
			"<th width='10%'>大小</th>" +
			"<th width='20%'>最后访问</th>" +
			"<th width='10%'>删除</th>" +
		"</tr>");

	if (!sDir.equals("")) {
		out.print("<tr align=center>" +
			"<td><img border=0 src='../sysimage/file/folderback.gif'></td>" +
			"<td align=left colspan=4><a href=\"?id=" + sStyleID + "&dir=");
		if (sDir.indexOf("/")>0){
			out.print(sDir.substring(0, sDir.lastIndexOf("/")));
		}
		out.print("\">返回上一级目录</a></td></tr>");
	}


	String sCurrPage = "";
	int nCurrPage = 0, nFileNum = 0, nPageNum = 0, nPageSize = 0;
	sCurrPage = dealNull(request.getParameter("page"));
	nPageSize = 20;
	if (sCurrPage.equals("") || !isNumber(sCurrPage)) {
		nCurrPage = 1;
	}else{
		nCurrPage = Integer.valueOf(sCurrPage).intValue();
	}


	ArrayList aSubFolders = new ArrayList();
	ArrayList aSubFiles = new ArrayList();
	ArrayList aSubFiles_Len = new ArrayList();
	ArrayList aSubFiles_Time = new ArrayList();

	File file = new File(application.getRealPath(RelativePath2RootPath2(sCurrDir, sServletPath)));
	//String[] fileList = file.list();
	File[] filelist = File.listRoots();
	filelist = file.listFiles();
	if (filelist == null) filelist = new File[]{};
	if (filelist != null && filelist.length > 0){
		for (int i = 0; i < filelist.length; i++) {
			if (filelist[i].isDirectory()) {
				aSubFolders.add(filelist[i].getName());
			}
			if (filelist[i].isFile()) {
				nFileNum++;
				aSubFiles.add(filelist[i].getName());
				aSubFiles_Len.add(convertFileSize(filelist[i].length()));
				aSubFiles_Time.add(formatDate(new Date(filelist[i].lastModified()), 5));
			}
		}
	}

	for (int i=0; i<aSubFolders.size(); i++){
		out.print("<tr align=center>" +
			"<td><img border=0 src='../sysimage/file/folder.gif'></td>" +
			"<td align=left colspan=3><a href=\"?id=" + sStyleID + "&dir=");
		if (!sDir.equals("")) {
			out.print(sDir + "/");
		}
		out.print(aSubFolders.get(i).toString() + "\">" + aSubFolders.get(i).toString() + "</a></td>" +
			"<td><a href='?id=" + sStyleID + "&dir=" + sDir + "&action=delfolder&foldername=" + aSubFolders.get(i).toString() + "'>删除</a></td></tr>");
	}


	nPageNum = Int2(String.valueOf(nFileNum / nPageSize));
	if (nFileNum % nPageSize > 0) {
		nPageNum = nPageNum + 1;
	}
	if (nCurrPage > nPageNum) {
		nCurrPage = 1;
	}

	int nBeginPos = 0, nEndPos = 0;
	nBeginPos = (nCurrPage - 1) * nPageSize;
	nEndPos = nCurrPage * nPageSize;
	if (nEndPos > aSubFiles.size()) {
		nEndPos = aSubFiles.size();
	}

	for (int i=nBeginPos; i<nEndPos; i++){
		String s_FileName = aSubFiles.get(i).toString();
		out.print("<tr align=center>" +
			"<td>" + FileName2Pic(s_FileName) + "</td>" +
			"<td align=left><a href=\"" + sCurrDir + s_FileName + "\" target=_blank>" + s_FileName + "</a></td>" +
			"<td>" + aSubFiles_Len.get(i).toString() + "</td>" +
			"<td>" + aSubFiles_Time.get(i).toString() + "</td>" +
			"<td><input type=checkbox name=delfilename value=\"" + s_FileName + "\"></td></tr>");
	}

	if (nFileNum <= 0) {
		out.print("<tr><td colspan=5>指定目录下现在还没有文件！</td></tr>");
	}


	if (nFileNum > 0) {
		out.print("<tr><td colspan=6><table border=0 cellpadding=3 cellspacing=0 width='100%'><tr><td>");
		if (nCurrPage > 1) {
			out.print("<a href='?id=" + sStyleID + "&dir=" + sDir + "&page=1'>首页</a>&nbsp;&nbsp;<a href='?id=" + sStyleID + "&dir=" + sDir + "&page=" + String.valueOf(nCurrPage - 1) + "'>上一页</a>&nbsp;&nbsp;");
		}else{
			out.print("首页&nbsp;&nbsp;上一页&nbsp;&nbsp;");
		}
		if (nCurrPage < nPageNum) {
			out.print("<a href='?id=" + sStyleID + "&dir=" + sDir + "&page=" + String.valueOf(nCurrPage + 1) + "'>下一页</a>&nbsp;&nbsp;<a href='?id=" + sStyleID + "&dir=" + sDir + "&page=" + String.valueOf(nPageNum) + "'>尾页</a>");
		}else{
			out.print("下一页&nbsp;&nbsp;尾页");
		}
		out.print("&nbsp;&nbsp;&nbsp;&nbsp;共<b>" + String.valueOf(nFileNum) + "</b>个&nbsp;&nbsp;页次:<b><span class=highlight2>" + String.valueOf(nCurrPage) + "</span>/" + String.valueOf(nPageNum) + "</b>&nbsp;&nbsp;<b>" + String.valueOf(nPageSize) + "</b>个文件/页");
		out.print("</td><td align=right><input type=submit name=b value=' 删除选定的文件 '> <input type=button name=b1 value=' 清空所有文件 ' onclick=\"javascript:if (confirm('你确定要清空所有文件吗？')) {location.href='?id=" + sStyleID + "&dir=" + sDir + "&action=delall';}\"></td></tr></table></td></tr>");
	}

	out.print("</form></table>");

}


out.print(Footer());


%>

<%!

static String RelativePath2RootPath2(String url, String s_ServletPath){
	String sTempUrl = url;
	if (sTempUrl.substring(0, 1).equals("/")){
		return sTempUrl;
	}

	String sWebEditorPath = s_ServletPath;
	sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	while(sTempUrl.startsWith("../")){
		sTempUrl = sTempUrl.substring(3);
		sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	}
	return sWebEditorPath + "/" + sTempUrl;
}

static boolean CheckValidDir(String path){
	java.io.File dir = new java.io.File(path);
	if (dir == null){
		return false;
	}
	if (dir.isFile()){
		return false;
	}
	if (!dir.exists()){
		return false;
	}
	return true;
}

static String InitSelect(ArrayList a_Style, String s_InitValue, String s_AllName){
	String s_Result = "";
	if (!s_AllName.equals("")) {
		s_Result = s_Result + "<option value=''>" + s_AllName + "</option>";
	}
	for (int i=0; i<a_Style.size(); i++){
		String[] aTemp = split(a_Style.get(i).toString(), "|||");
		s_Result = s_Result + "<option value='" + i + "'";
		if (String.valueOf(i).equals(s_InitValue)) {
			s_Result = s_Result + " selected";
		}
		s_Result = s_Result + ">样式：" + htmlEncode(aTemp[0]) + "---目录：" + htmlEncode(aTemp[3]) + "</option>";
	}
	return s_Result;
}

static String FileName2Pic(String sFileName){
	String sPicName = "";
	String sExt = sFileName.substring(sFileName.lastIndexOf(".")+1).toUpperCase();
	if (sExt.equals("TXT")){
		sPicName = "txt.gif";
	}else if (sExt.equals("CHM") || sExt.equals("HLP")){
		sPicName = "hlp.gif";
	}else if (sExt.equals("DOC")){
		sPicName = "doc.gif";
	}else if (sExt.equals("PDF")){
		sPicName = "pdf.gif";
	}else if (sExt.equals("MDB")){
		sPicName = "mdb.gif";
	}else if (sExt.equals("GIF")){
		sPicName = "gif.gif";
	}else if (sExt.equals("JPG")){
		sPicName = "jpg.gif";
	}else if (sExt.equals("BMP")){
		sPicName = "bmp.gif";
	}else if (sExt.equals("PNG")){
		sPicName = "pic.gif";
	}else if (sExt.equals("ASP") || sExt.equals("JSP") || sExt.equals("JS") || sExt.equals("PHP") || sExt.equals("PHP3") || sExt.equals("ASPX")){
		sPicName = "code.gif";
	}else if (sExt.equals("HTM") || sExt.equals("HTML") || sExt.equals("SHTML")){
		sPicName = "htm.gif";
	}else if (sExt.equals("ZIP")){
		sPicName = "zip.gif";
	}else if (sExt.equals("RAR")){
		sPicName = "rar.gif";
	}else if (sExt.equals("EXE")){
		sPicName = "exe.gif";
	}else if (sExt.equals("AVI")){
		sPicName = "avi.gif";
	}else if (sExt.equals("MPG") || sExt.equals("MPEG") || sExt.equals("ASF")){
		sPicName = "mp.gif";
	}else if (sExt.equals("RA") || sExt.equals("RM")){
		sPicName = "rm.gif";
	}else if (sExt.equals("MP3")){
		sPicName = "mp3.gif";
	}else if (sExt.equals("MID") || sExt.equals("MIDI")){
		sPicName = "mid.gif";
	}else if (sExt.equals("WAV")){
		sPicName = "audio.gif";
	}else if (sExt.equals("XLS")){
		sPicName = "xls.gif";
	}else if (sExt.equals("PPT") || sExt.equals("PPS")){
		sPicName = "ppt.gif";
	}else if (sExt.equals("SWF")){
		sPicName = "swf.gif";
	}else{
		sPicName = "unknow.gif";
	}
	return "<img border=0 src='../sysimage/file/" + sPicName + "'>";
}

static String convertFileSize (long size){
	int divisor = 1;
	String unit = "bytes";
	if (size>= 1024*1024){
		divisor = 1024*1024;
		unit = "MB";
	}
	else if (size>= 1024){
		divisor = 1024;
		unit = "KB";
	}
	if (divisor ==1) return size /divisor + " "+unit;
	String aftercomma = ""+100*(size % divisor)/divisor;
	if (aftercomma.length() == 1) aftercomma="0"+aftercomma;
	return size /divisor + "."+aftercomma+" "+unit;
}

static int Int2(String str){
	if (str.indexOf(".")>0){
		str = str.substring(0, str.indexOf("."));
	}
	return Integer.valueOf(str).intValue();
}

%>