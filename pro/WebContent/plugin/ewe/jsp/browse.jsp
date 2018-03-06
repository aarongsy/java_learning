<%@ page contentType="text/html;charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%@ page import="java.util.*,java.util.regex.*,java.text.*,java.io.*,java.net.*,javax.imageio.*,java.awt.*,java.awt.image.*,java.awt.geom.*,javax.swing.*" %>
<jsp:useBean id="mySmartUpload" class="com.jspsmart.upload.SmartUpload" scope="page"/>
<%!
/*
*######################################
* eWebEditor v3.80 - Advanced online web based WYSIWYG HTML editor.
* Copyright (c) 2003-2006 eWebSoft.com
*
* For further information go to http://www.ewebsoft.com/
* This copyright notice MUST stay intact for use.
*######################################
*/


static String[] split(String source, String div) {
    int arynum = 0, intIdx = 0, intIdex = 0, div_length = div.length();
    if (source.compareTo("") != 0) {
      if (source.indexOf(div) != -1) {
        intIdx = source.indexOf(div);
        for (int intCount = 1; ; intCount++) {
          if (source.indexOf(div, intIdx + div_length) != -1) {
            intIdx = source.indexOf(div, intIdx + div_length);
            arynum = intCount;
          }
          else {
            arynum += 2;
            break;
          }
        }
      }
      else {
        arynum = 1;
      }
    }
    else {
      arynum = 0;

    }
    intIdx = 0;
    intIdex = 0;
    String[] returnStr = new String[arynum];

    if (source.compareTo("") != 0) {
      if (source.indexOf(div) != -1) {
        intIdx = (int) source.indexOf(div);
        returnStr[0] = (String) source.substring(0, intIdx);
        for (int intCount = 1; ; intCount++) {
          if (source.indexOf(div, intIdx + div_length) != -1) {
            intIdex = (int) source.indexOf(div, intIdx + div_length);
            returnStr[intCount] = (String) source.substring(intIdx + div_length,
                intIdex);
            intIdx = (int) source.indexOf(div, intIdx + div_length);
          }
          else {
            returnStr[intCount] = (String) source.substring(intIdx + div_length,
                source.length());
            break;
          }
        }
      }
      else {
        returnStr[0] = (String) source.substring(0, source.length());
        return returnStr;
      }
    }
    else {
      return returnStr;
    }
    return returnStr;
}

static String dealNull(String str) {
	String returnstr = null;
	if (str == null) {
		returnstr = "";
	} else {
		returnstr = str;
	}
	return returnstr;
}

static Object dealNull(Object obj) {
	Object returnstr = null;
	if (obj == null){
		returnstr = (Object) ("");
	}else{
		returnstr = obj;
    }
	return returnstr;
}

static String replace(String str, String substr, String restr) {
	String[] tmp = split(str, substr);
	String returnstr = null;
	if (tmp.length != 0) {
		returnstr = tmp[0];
		for (int i = 0; i < tmp.length - 1; i++) {
			returnstr = dealNull(returnstr) + restr + tmp[i + 1];
		}
	}
	return dealNull(returnstr);
}

static String getOutScript(String str){
	String html = "";
	html += "<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><TITLE>eWebEditor</TITLE></head><body>";
	html += "<script language=javascript>" + str + "</script>";
	html += "</body></html>";
	return html;
}

static boolean CheckValidExt(String s_AllowExt, String sExt){
	if(s_AllowExt.equals("")){
		return true;
	}
	String[] aExt = split(s_AllowExt, "|");
	for (int i = 0; i<aExt.length; i++){
		if (aExt[i].toLowerCase().equals(sExt)) {
			return true;
		}
	}
	return false;
}

static String RelativePath2RootPath(String url, String s_RequestURI){
	String sTempUrl = url;
	if (sTempUrl.substring(0, 1).equals("/")){
		return sTempUrl;
	}

	String sWebEditorPath = s_RequestURI;
	sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	while(sTempUrl.startsWith("../")){
		sTempUrl = sTempUrl.substring(3);
		sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	}
	return sWebEditorPath + "/" + sTempUrl;
}

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

static String RootPath2DomainPath(String url, String s_Protocol, String s_ServerName, String s_ServerPort){
	String sHost = split(s_Protocol, "/")[0] + "://" + s_ServerName;
	String sPort = s_ServerPort;
	if (!sPort.equals("80")){
		sHost = sHost + ":" + sPort;
	}
	return sHost + url;
}

static String ReadFile(String s_FileName){
	String s_Result = "";
	try {
		java.io.File objFile;
		java.io.FileReader objFileReader;
		char[] chrBuffer = new char[10];
		int intLength;

		objFile = new java.io.File(s_FileName);

		if(objFile.exists()){
			objFileReader = new java.io.FileReader(objFile);
			while((intLength=objFileReader.read(chrBuffer))!=-1){
				s_Result += String.valueOf(chrBuffer,0,intLength);
			}
			objFileReader.close();
		}
	} catch(IOException e) {
		System.out.println(e.getMessage());
	}
	return s_Result;
}

static ArrayList getConfigArray(String s_Key, String s_Config){
	ArrayList a_Result = new ArrayList();
	Pattern p = Pattern.compile(s_Key + " = \"(.*)\";");
	Matcher m = p.matcher(s_Config);
	while (m.find()) {
		a_Result.add(m.group(1));
	}
	return a_Result;
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
		unit = "M";
	}
	else if (size>= 1024){
		divisor = 1024;
		unit = "K";
	}
	if (divisor ==1) return size /divisor + " "+unit;
	String aftercomma = ""+100*(size % divisor)/divisor;
	if (aftercomma.length() == 1) aftercomma="0"+aftercomma;
	return size /divisor + "."+aftercomma+" "+unit;
}

static String HTML2JS(String s_HTML){
	String s_JS = "";
	s_JS = replace(s_HTML, "\r\n", "");
	s_JS = replace(s_JS, "\\", "\\\\");
	s_JS = replace(s_JS, "\"", "\\\"");
	return s_JS;
}

static String formatDate(Date myDate, int nFlag) {
	String strFormat = "";
	switch(nFlag){
	case 1:
		strFormat = "yyyy";
		break;
	case 2:
		strFormat = "yyyyMM";
		break;
	case 3:
		strFormat = "yyyyMMdd";
		break;
	case 4:
		strFormat = "yyyyMMddHHmmss";
		break;
	}
	SimpleDateFormat formatter = new SimpleDateFormat(strFormat);
	String strDate = formatter.format(myDate);
	return strDate;
}

%>
<%
String eWebEditorPath = request.getServletPath();
eWebEditorPath = eWebEditorPath.substring(0, eWebEditorPath.lastIndexOf("/"));
eWebEditorPath = eWebEditorPath.substring(0, eWebEditorPath.lastIndexOf("/"));
eWebEditorPath = application.getRealPath(eWebEditorPath);
String sConfig = "";
if (eWebEditorPath.indexOf("/") != -1) {
	eWebEditorPath += "/";
	sConfig = ReadFile(eWebEditorPath+"/jsp/config.jsp");
}else{
	eWebEditorPath += "\\";
	sConfig = ReadFile(eWebEditorPath+"\\jsp\\config.jsp");
}

ArrayList aStyle = getConfigArray("aStyle", sConfig);

String sAllowExt, sUploadDir, sBaseUrl, sContentPath, sAllowBrowse;
String sCurrDir, sDir;

// param
String sType = dealNull(request.getParameter("type")).toUpperCase();
String sStyleName = dealNull(request.getParameter("style"));
// InitUpload
String sRequestURI = request.getRequestURI();
String sServletPath = request.getServletPath();
String sProtocol = request.getProtocol();
String sServerName = request.getServerName();
String sServerPort = String.valueOf(request.getServerPort());

String[] aStyleConfig = new String[43];
boolean bValidStyle = false;

for (int i = 0; i < aStyle.size(); i++){
	aStyleConfig = split(aStyle.get(i).toString(), "|||");
	if (sStyleName.toLowerCase().equals(aStyleConfig[0].toLowerCase())) {
		bValidStyle = true;
		break;
	}
}

if (!bValidStyle) {
	out.print(getOutScript("alert('Invalid Style!')"));
	out.close();
}

sBaseUrl = aStyleConfig[19];
sAllowBrowse = aStyleConfig[43];

sUploadDir = aStyleConfig[3];
if (!sUploadDir.substring(0, 1).equals("/")) {
	sUploadDir = "../" + sUploadDir;
}

if (sBaseUrl.equals("1")){
	sContentPath = RelativePath2RootPath(sUploadDir, sRequestURI);
} else if (sBaseUrl.equals("2")){
	sContentPath = RootPath2DomainPath(RelativePath2RootPath(sUploadDir, sRequestURI), sProtocol, sServerName, sServerPort);
} else {
	sContentPath = aStyleConfig[23];
}

if (sType.equals("FILE")){
	sAllowExt = "";
} else if (sType.equals("MEDIA")){
	sAllowExt = "rm|mp3|wav|mid|midi|ra|avi|mpg|mpeg|asf|asx|wma|mov";
} else if (sType.equals("FLASH")){
	sAllowExt = "swf";
} else {
	sAllowExt = "bmp|jpg|jpeg|png|gif";
}

sCurrDir = sUploadDir;

sDir = dealNull(request.getParameter("dir"));
if (!sDir.equals("")) {
	if (CheckValidDir(application.getRealPath(RelativePath2RootPath2(sUploadDir+sDir, sServletPath)))){
		sCurrDir = sUploadDir + sDir + "/";
	}else{
		sDir = "";
	}
}



String s_List="", s_Url="";

if (!sDir.equals("")) {
	if (sDir.indexOf("/")>0){
		s_Url = sDir.substring(0, sDir.lastIndexOf("/"));
	}else{
		s_Url = "";
	}

	s_List += "<tr onclick='doRowClick(this)' onmouseover='doRowOver(this)' onmouseout='doRowOut(this)' isdir='true' path='" + s_Url + "'>" +
		"<td><img border=0 src='../sysimage/file/parentfolder.gif'></td>" +
		"<td>..</td>" +
		"<td>&nbsp;</td>" +
		"</tr>";
}


int nFileNum = 0;

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
	if (!sDir.equals("")) {
		s_Url = sDir + "/" + aSubFolders.get(i).toString();
	}else{
		s_Url = aSubFolders.get(i).toString();
	}

	s_List += "<tr onclick='doRowClick(this)' onmouseover='doRowOver(this)' onmouseout='doRowOut(this)' isdir='true' path='" + s_Url + "'>" +
		"<td><img border=0 src='../sysimage/file/closedfolder.gif'></td>" +
		"<td noWrap>" + aSubFolders.get(i).toString() + "</td>" +
		"<td>&nbsp;</td>" +
		"</tr>";
}

for (int i=0; i<aSubFiles.size(); i++){
	String s_FileName = aSubFiles.get(i).toString();
	String s_FileExt = s_FileName.substring(s_FileName.lastIndexOf(".")+1);
	s_FileExt = s_FileExt.toLowerCase();
	if (CheckValidExt(sAllowExt, s_FileExt)){
	
		if (sDir.equals("")){
			s_Url = sContentPath + s_FileName;
		}else{
			s_Url = sContentPath + sDir + "/" + s_FileName;
		}
		
		s_List += "<tr onclick='doRowClick(this)' onmouseover='doRowOver(this)' onmouseout='doRowOut(this)' url='" + s_Url + "'>" +
				"<td>" + FileName2Pic(s_FileName) + "</td>" +
				"<td noWrap>" + s_FileName + "</td>" +
				"<td align=right>" + aSubFiles_Len.get(i).toString() + "</td>" +
				"</tr>";		
	}
}


if (sDir.equals("")){
	s_Url = "/";
}else{
	s_Url = "/" + sDir + "/";
}

s_List += "</table>";
s_List =  HTML2JS(s_List);
s_List = "parent.setDirList(\"" + s_List + "\", \"" + s_Url + "\")";
s_List = getOutScript(s_List);

out.print(s_List);

%>