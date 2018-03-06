<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.document.file.*"%>
<%@ page import="com.eweaver.base.security.service.acegi.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
response.sendRedirect(request.getContextPath()+"/main/login.jsp");
}
String dirt=request.getParameter("dir");
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
Setitem setitem=setitemService.getSetitem("40288183121d455601121d5c78640053");
if(setitem==null){setitem=new Setitem();}
String RESTRICT_PATH=setitem.getItemvalue();

//Get the current browsing directory
request.setAttribute("dir", request.getParameter("dir"));
// The browser_name variable is used to keep track of the URI
// of the jsp file itself.  It is used in all link-backs.
final String browser_name = request.getRequestURI();
final String FOL_IMG = "";
boolean nohtml = false;
boolean dir_view = true;
//Get Javascript
if (request.getParameter("Javascript") != null) {
	dir_view = false;
	nohtml = true;
	//Tell the browser that it should cache the javascript
	response.setHeader("Cache-Control", "public");
	Date now = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z", Locale.US);
	response.setHeader("Expires", sdf.format(new Date(now.getTime() + 1000 * 60 * 60 * 24*2)));
	response.setHeader("Content-Type", "text/javascript");
	%>
<%// This section contains the Javascript used for interface elements %>
var check = false;
<%// Disables the checkbox feature %>
function dis(){check = true;}

var DOM = 0, MS = 0, OP = 0, b = 0;
<%// Determine the browser type %>
function CheckBrowser(){
	if (b == 0){
		if (window.opera) OP = 1;
		// Moz or Netscape
		if(document.getElementById) DOM = 1;
		// Micro$oft
		if(document.all && !OP) MS = 1;
		b = 1;
	}
}
<%// Allows the whole row to be selected %>
function selrow (element, i){
	var erst;
	CheckBrowser();
	if ((OP==1)||(MS==1)) erst = element.firstChild.firstChild;
	else if (DOM==1) erst = element.firstChild.nextSibling.firstChild;
	<%// MouseIn %>
if (i==0){
	if (erst.checked == true) element.className='mousechecked';
	else element.className='mousein';
}
<%// MouseOut %>
else if (i==1){
	if (erst.checked == true) element.className='checked';
	else element.className='mouseout';
}
<%    // MouseClick %>
	else if ((i==2)&&(!check)){
		if (erst.checked==true) element.className='mousein';
		else element.className='mousechecked';
		erst.click();
	}
	else check=false;
}
<%// Filter files and dirs in FileList%>
function filter (begriff){
	var suche = begriff.value.toLowerCase();
	var table = document.getElementById("filetable");
	var ele;
	for (var r = 1; r < table.rows.length; r++){
		ele = table.rows[r].cells[1].innerHTML.replace(/<[^>]+>/g,"");
		if (ele.toLowerCase().indexOf(suche)>=0 )
			table.rows[r].style.display = '';
		else table.rows[r].style.display = 'none';
     	}
}
<%//(De)select all checkboxes%>	
function AllFiles(){
	for(var x=0;x < document.FileList.elements.length;x++){
		var y = document.FileList.elements[x];
		var ytr = y.parentNode.parentNode;
		var check = document.FileList.selall.checked;
		if(y.name == 'selfile' && ytr.style.display != 'none'){
			if (y.disabled != true){
				y.checked = check;
				if (y.checked == true) ytr.className = 'checked';
				else ytr.className = 'mouseout';
			}
		}
	}
}

function shortKeyHandler(_event){
	if (!_event) _event = window.event;
	if (_event.which) {
		keycode = _event.which;
	} else if (_event.keyCode) {
		keycode = _event.keyCode;
	}
	var t = document.getElementById("text_Dir");
	//z
	if (keycode == 122){
		document.getElementById("but_Zip").click();
	}
	//r, F2
	else if (keycode == 113 || keycode == 114){
		var path = prompt("Please enter new filename", "");
		if (path == null) return;
		t.value = path;
		document.getElementById("but_Ren").click();
	}
	//c
	else if (keycode == 99){
		var path = prompt("Please enter filename", "");
		if (path == null) return;
		t.value = path;
		document.getElementById("but_NFi").click();
	}
	//d
	else if (keycode == 100){
		var path = prompt("Please enter directory name", "");
		if (path == null) return;
		t.value = path;
		document.getElementById("but_NDi").click();
	}
	//m
	else if (keycode == 109){
		var path = prompt("Please enter move destination", "");
		if (path == null) return;
		t.value = path;
		document.getElementById("but_Mov").click();
	}
	//y
	else if (keycode == 121){
		var path = prompt("Please enter copy destination", "");
		if (path == null) return;
		t.value = path;
		document.getElementById("but_Cop").click();
	}
	//l
	else if (keycode == 108){
		document.getElementById("but_Lau").click();
	}
	//Del
	else if (keycode == 46){
		document.getElementById("but_Del").click();
	}
}

function popUp(URL){
	fname = document.getElementsByName("myFile")[0].value;
	if (fname != "")
		window.open("<%=request.getContextPath()%>"+URL+"?first&uplMonitor="+encodeURIComponent(fname),"","width=400,height=150,resizable=yes,depend=yes")
}

document.onkeypress = shortKeyHandler;
<% 		}
// View file
else if (request.getParameter("file") != null) {
   File f = new File(request.getParameter("file"));
   if (!FileBrowser.isAllowed(f, false,RESTRICT_PATH)) {
       request.setAttribute("dir", f.getParent());
       request.setAttribute("error", "You are not allowed to access "+f.getAbsolutePath());
   }
   else if (f.exists() && f.canRead()) {
       if (FileBrowser.isPacked(f.getName(), false)) {
           //If zipFile, do nothing here
       }
       else{
           String mimeType = FileHelper.getMimeType(f.getName());
           response.setContentType(mimeType);
           if (mimeType.equals("text/plain")) response.setHeader(
                   "Content-Disposition", "inline;filename=\"temp.txt\"");
           else response.setHeader("Content-Disposition", "inline;filename=\""
                   + f.getName() + "\"");
           BufferedInputStream fileInput = new BufferedInputStream(new FileInputStream(f));
           byte buffer[] = new byte[8 * 1024];
           out.clearBuffer();
           OutputStream out_s = new Writer2Stream(out);
           FileBrowser.copyStreamsWithoutClose(fileInput, out_s, buffer);
           fileInput.close();
           out_s.flush();
           nohtml = true;
           dir_view = false;
       }
   }
   else {
       request.setAttribute("dir", f.getParent());
       request.setAttribute("error", "File " + f.getAbsolutePath()
               + " does not exist or is not readable on the server");
   }
}
// Download selected files as zip file
else if ((request.getParameter("Submit") != null)
		&& (request.getParameter("Submit").equals(FileBrowser.SAVE_AS_ZIP))) {
	Vector v = FileBrowser.expandFileList(request.getParameterValues("selfile"), false);
	//Check if all files in vector are allowed
	String notAllowedFile = null;
	for (int i = 0;i < v.size(); i++){
		File f = (File) v.get(i);
		if (!FileBrowser.isAllowed(f, false,RESTRICT_PATH)){
			notAllowedFile = f.getAbsolutePath();
			break;
		}
	}
	if (notAllowedFile != null){
		request.setAttribute("error", "You are not allowed to access " + notAllowedFile);
	}
	else if (v.size() == 0) {
		request.setAttribute("error", "No files selected");
	}
	else {
		File dir_file = new File("" + request.getAttribute("dir"));
		int dir_l = dir_file.getAbsolutePath().length();
		response.setContentType("application/zip");
		response.setHeader("Content-Disposition", "attachment;filename=\"rename_me.zip\"");
		out.clearBuffer();
		ZipOutputStream zipout = new ZipOutputStream(new Writer2Stream(out));
		zipout.setComment("Created by jsp File Browser v. " + FileBrowser.VERSION_NR);
		zipout.setLevel(FileBrowser.COMPRESSION_LEVEL);
		for (int i = 0; i < v.size(); i++) {
			File f = (File) v.get(i);
			if (f.canRead()) {
				zipout.putNextEntry(new ZipEntry(f.getAbsolutePath().substring(dir_l + 1)));
				BufferedInputStream fr = new BufferedInputStream(new FileInputStream(f));
				byte buffer[] = new byte[0xffff];
				FileBrowser.copyStreamsWithoutClose(fr, zipout, buffer);
				/*					int b;
				 while ((b=fr.read())!=-1) zipout.write(b);*/
				fr.close();
				zipout.closeEntry();
			}
		}
		zipout.finish();
		out.flush();
		nohtml = true;
		dir_view = false;
	}
}
// Download file
else if (request.getParameter("downfile") != null) {
	String filePath = request.getParameter("downfile");
	File f = new File(filePath);
	if (!FileBrowser.isAllowed(f, false,RESTRICT_PATH)){
		request.setAttribute("dir", f.getParent());
		request.setAttribute("error", "You are not allowed to access " + f.getAbsoluteFile());
	}
	else if (f.exists() && f.canRead()) {
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=\"" + f.getName()
				+ "\"");
		response.setContentLength((int) f.length());
		BufferedInputStream fileInput = new BufferedInputStream(new FileInputStream(f));
		byte buffer[] = new byte[8 * 1024];
		out.clearBuffer();
		OutputStream out_s = new Writer2Stream(out);
		FileBrowser.copyStreamsWithoutClose(fileInput, out_s, buffer);
		fileInput.close();
		out_s.flush();
		nohtml = true;
		dir_view = false;
	}
	else {
		request.setAttribute("dir", f.getParent());
		request.setAttribute("error", "File " + f.getAbsolutePath()
				+ " does not exist or is not readable on the server");
	}
}
if (nohtml) return;
//else
	// If no parameter is submitted, it will take the path from jsp file browser
if (request.getAttribute("dir") == null) {
	String path = null;
	if (application.getRealPath(request.getRequestURI()) != null) {
		File f = new File(application.getRealPath(request.getRequestURI())).getParentFile();
		//This is a hack needed for tomcat
		while (f != null && !f.exists())
			f = f.getParentFile();
		if (f != null)
			path = f.getAbsolutePath();
	}
	if (path == null) { // handle the case where we are not in a directory (ex: war file)
		path = new File(".").getAbsolutePath();
	}
	//Check path
             if (!FileBrowser.isAllowed(new File(path), false,RESTRICT_PATH)){
             	//TODO Blacklist
                 if (RESTRICT_PATH.indexOf(";")<0) path = RESTRICT_PATH;
                 else path = RESTRICT_PATH.substring(0, RESTRICT_PATH.indexOf(";"));
             }
	request.setAttribute("dir", path);
}%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
<meta name="robots" content="noindex">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<%
			//If a cssfile exists, it will take it
			String cssPath = null;
			if (application.getRealPath(request.getRequestURI()) != null) cssPath = new File(
					application.getRealPath(request.getRequestURI())).getParent()
					+ File.separator + FileBrowser.CSS_NAME;
			if (cssPath == null) cssPath = application.getResource(FileBrowser.CSS_NAME).toString();
			if (new File(cssPath).exists()) {
%>
<link rel="stylesheet" type="text/css" href="<%=FileBrowser.CSS_NAME%>">
      <%}
			else if (request.getParameter("uplMonitor") == null) {%>
	<style type="text/css">
		input.button {background-color: #c0c0c0; color: #666666;
		border: 1px solid #999999; margin: 5px 1px 5px 1px;}
		input.textfield {margin: 5px 1px 5px 1px;}
		input.button:Hover { color: #444444 }
		table.filelist {background-color:#666666; width:100%; border:0px none #ffffff}
		.formular {margin: 1px; background-color:#ffffff; padding: 1em; border:1px solid #000000;}
		.formular2 {margin: 1px;}
		th { background-color:#c0c0c0 }
		tr.mouseout { background-color:#ffffff; }
		tr.mousein  { background-color:#eeeeee; }
		tr.checked  { background-color:#cccccc }
		tr.mousechecked { background-color:#c0c0c0 }
		td { font-family:Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; color: #666666;hieght:25px;}
		td.message { background-color: #FFFF00; color: #000000; text-align:center; font-weight:bold}
		td.error { color: #000000; text-align:center; font-weight:bold;font-size:18px}
		A { text-decoration: none; }
		A:Hover { color : Red; text-decoration : underline; }
		BODY { font-family:Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; color: #666666;}
	</style>
	<%}
		
        //Check path
        String dirPath=(String)request.getAttribute("dir");
        if (!FileBrowser.isAllowed(new File(dirPath), false,RESTRICT_PATH)){
            request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003a") + request.getAttribute("dir"));//对不起，你没有权限访问
        }
		//Upload monitor
		else if (request.getParameter("uplMonitor") != null) {%>
	<style type="text/css">
		BODY { font-family:Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; color: #666666;}
	</style><%
			String fname = request.getParameter("uplMonitor");
			//First opening
			boolean first = false;
			if (request.getParameter("first") != null) first = true;
			UplInfo info = new UplInfo();
			if (!first) {
				info = UploadMonitor.getInfo(fname);
				if (info == null) {
					//Windows
					int posi = fname.lastIndexOf("\\");
					if (posi != -1) info = UploadMonitor.getInfo(fname.substring(posi + 1));
				}
				if (info == null) {
					//Unix
					int posi = fname.lastIndexOf("/");
					if (posi != -1) info = UploadMonitor.getInfo(fname.substring(posi + 1));
				}
			}
			dir_view = false;
			request.setAttribute("dir", null);
			if (info.aborted) {
				UploadMonitor.remove(fname);
				%>
</head>
<body>
<b>Upload of <%=fname%></b><br><br>
Upload aborted.</body>
</html><%
			}
			else if (info.totalSize != info.currSize || info.currSize == 0) {
				%>
<META HTTP-EQUIV="Refresh" CONTENT="<%=FileBrowser.UPLOAD_MONITOR_REFRESH%>;URL=<%=browser_name %>?uplMonitor=<%=java.net.URLEncoder.encode(fname)%>">
</head>
<body>
<b>Upload of <%=fname%></b><br><br>
<center>
<table height="20px" width="90%" bgcolor="#eeeeee" style="border:1px solid #cccccc"><tr>
<td bgcolor="blue" width="<%=info.getPercent()%>%"></td><td width="<%=100-info.getPercent()%>%"></td>
</tr></table></center>
<%=FileHelper.convertFileSize(info.currSize)%> from <%=FileHelper.convertFileSize(info.totalSize)%>
(<%=info.getPercent()%> %) uploaded (Speed: <%=info.getUprate()%>).<br>
Time: <%=info.getTimeElapsed()%> from <%=info.getTimeEstimated()%>
</body>
</html><%
			}
			else {
				UploadMonitor.remove(fname);
				%>
</head>
<body onload="javascript:window.close()">
<b>Upload of <%=fname%></b><br><br>
Upload finished.
</body>
</html><%
			}
		}
		//Comandwindow
		else if (request.getParameter("command") != null) {
            if (!FileBrowser.NATIVE_COMMANDS){
                request.setAttribute("error", "Execution of native commands is not allowed!");
            }
			else if (!"Cancel".equalsIgnoreCase(request.getParameter("Submit"))) {
%>
<title>Launch commands in <%=request.getAttribute("dir")%></title>
</head>
<body><center>
<h2><%=FileBrowser.LAUNCH_COMMAND %></h2><br />
<%
				out.println("<form action=\"" + browser_name + "\" method=\"Post\">\n"
						+ "<textarea name=\"text\" wrap=\"off\" cols=\"" + FileBrowser.EDITFIELD_COLS
						+ "\" rows=\"" + FileBrowser.EDITFIELD_ROWS + "\" readonly>");
				String ret = "";
				if (!request.getParameter("command").equalsIgnoreCase(""))
                    ret = FileBrowser.startProcess(
						request.getParameter("command"), (String) request.getAttribute("dir"));
				out.println(ret);
%></textarea>
	<input type="hidden" name="dir" value="<%= request.getAttribute("dir")%>">
	<br /><br />
	<table class="formular">
	<tr><td title="Enter your command">
	Command: <input size="<%=FileBrowser.EDITFIELD_COLS-5%>" type="text" name="command" value="">
	</td></tr>
	<tr><td><input class="button" type="Submit" name="Submit" value="Launch">
	<input type="hidden" name="sort" value="<%=request.getParameter("sort")%>">
	<input type="Submit" class="button" name="Submit" value="Cancel"></td></tr>
	</table>
	</form>
	<br />
	<hr>
	<center>
		<small>jsp File Browser version <%= FileBrowser.VERSION_NR%> by <a href="http://www.vonloesch.de">www.vonloesch.de</a></small>
	</center>
	</center>
</body>
</html>
<%
				dir_view = false;
				request.setAttribute("dir", null);
			}
		}

		//Click on a filename, special viewer (zip+jar file)
		else if (request.getParameter("file") != null) {
			File f = new File(request.getParameter("file"));
            if (!FileBrowser.isAllowed(f, false,RESTRICT_PATH)){
                request.setAttribute("error", "You are not allowed to access " + f.getAbsolutePath());
            }
			else if (FileBrowser.isPacked(f.getName(), false)) {
				//ZipFile
				try {
					ZipFile zf = new ZipFile(f);
					Enumeration entries = zf.entries();
%>
<title><%= f.getAbsolutePath()%></title>
</head>
<body>
	<h2>Content of <%=StringHelper.conv2Html(f.getName())%></h2><br />
	<table class="filelist" cellspacing="1px" cellpadding="0px">
	<th>Name</th><th>Uncompressed size</th><th>Compressed size</th><th>Compr. ratio</th><th>Date</th>
<%
	long size = 0;
	int fileCount = 0;
	while (entries.hasMoreElements()) {
		ZipEntry entry = (ZipEntry) entries.nextElement();
		if (!entry.isDirectory()) {
			fileCount++;
			size += entry.getSize();
			long ratio = 0;
			if (entry.getSize() != 0) ratio = (entry.getCompressedSize() * 100)
					/ entry.getSize();
			out.println("<tr class=\"mouseout\"><td>" + StringHelper.conv2Html(entry.getName())
					+ "</td><td>" + FileHelper.convertFileSize(entry.getSize()) + "</td><td>"
					+ FileHelper.convertFileSize(entry.getCompressedSize()) + "</td><td>"
					+ ratio + "%" + "</td><td>"
					+ FileBrowser.dateFormat.format(new Date(entry.getTime())) + "</td></tr>");

		}
	}
	zf.close();
	//No directory view
	dir_view = false;
	request.setAttribute("dir", null);
%>
	</table>
	<p align=center>
	<b><%=FileHelper.convertFileSize(size)%> in <%=fileCount%> files in <%=f.getName()%>. Compression ratio: <%=(f.length() * 100) / size%>%
	</b></p>
</body></html>
<%
				}
				catch (ZipException ex) {
					request.setAttribute("error", "Cannot read " + f.getName()
							+ ", no valid zip file");
				}
				catch (IOException ex) {
					request.setAttribute("error", "Reading of " + f.getName() + " aborted. Error: "
							+ ex);
				}
			}
		}
		// Upload
		else if ((request.getContentType() != null)
				&& (request.getContentType().toLowerCase().startsWith("multipart"))) {
			if (!FileBrowser.ALLOW_UPLOAD){
                request.setAttribute("error", "Upload is forbidden!");
            }
			response.setContentType("text/html");
			HttpMultiPartParser parser = new HttpMultiPartParser();
			boolean error = false;
			try {
				int bstart = request.getContentType().lastIndexOf("oundary=");
				String bound = request.getContentType().substring(bstart + 8);
				int clength = request.getContentLength();
				Hashtable ht = parser
						.processData(request.getInputStream(), bound, FileBrowser.tempdir, clength);
                if (!FileBrowser.isAllowed(new File((String)ht.get("dir")), false,RESTRICT_PATH)){
                    //This is a hack, cos we are writing to this directory
                	request.setAttribute("error", "You are not allowed to access " + ht.get("dir"));
                    error = true;
                }
				else if (ht.get("myFile") != null) {
					FileInfo fi = (FileInfo) ht.get("myFile");
					File f = fi.file;
					UplInfo info = UploadMonitor.getInfo(fi.clientFileName);
					if (info != null && info.aborted) {
						f.delete();
						request.setAttribute("error", "Upload aborted");
					}
					else {
						// Move file from temp to the right dir
						String path = (String) ht.get("dir");
						if (!path.endsWith(File.separator)) path = path + File.separator;
						if (!f.renameTo(new File(path + f.getName()))) {
							request.setAttribute("error", "Cannot upload file.");
							error = true;
							f.delete();
						}
					}
				}
				else {
					request.setAttribute("error", "No file selected for upload");
					error = true;
				}
				request.setAttribute("dir", (String) ht.get("dir"));
			}
			catch (Exception e) {
				request.setAttribute("error", "Error " + e + ". Upload aborted");
				error = true;
			}
			if (!error) request.setAttribute("message", "File upload correctly finished.");
		}
		// The form to edit a text file
		else if (request.getParameter("editfile") != null) {
			File ef = new File(request.getParameter("editfile"));
            if (!FileBrowser.isAllowed(ef, true,RESTRICT_PATH)){
                request.setAttribute("error", "You are not allowed to access " + ef.getAbsolutePath());
            }
            else{
%>
<title>Edit <%=StringHelper.conv2Html(request.getParameter("editfile"))%></title>
</head>
<body>
<center>
<h2>Edit <%=StringHelper.conv2Html(request.getParameter("editfile"))%></h2><br />
<%
                BufferedReader reader = new BufferedReader(new FileReader(ef));
                String disable = "";
                if (!ef.canWrite()) disable = " readonly";
                out.println("<form action=\"" + browser_name + "\" method=\"Post\">\n"
                        + "<textarea name=\"text\" wrap=\"off\" cols=\"" + FileBrowser.EDITFIELD_COLS
                        + "\" rows=\"" + FileBrowser.EDITFIELD_ROWS + "\"" + disable + ">");
                String c;
                // Write out the file and check if it is a win or unix file
                int i;
                boolean dos = false;
                boolean cr = false;
                while ((i = reader.read()) >= 0) {
                    out.print(StringHelper.conv2Html(i));
                    if (i == '\r') cr = true;
                    else if (cr && (i == '\n')) dos = true;
                    else cr = false;
                }
                reader.close();
                //No File directory is shown
                request.setAttribute("dir", null);
                dir_view = false;

%></textarea><br /><br />
<table class="formular">
	<input type="hidden" name="nfile" value="<%= request.getParameter("editfile")%>">
	<input type="hidden" name="sort" value="<%=request.getParameter("sort")%>">
		<tr><td colspan="2"><input type="radio" name="lineformat" value="dos" <%= dos?"checked":""%>>Ms-Dos/Windows
		<input type="radio" name="lineformat" value="unix" <%= dos?"":"checked"%>>Unix
		<input type="checkbox" name="Backup" checked>Write backup</td></tr>
		<tr><td title="Enter the new filename"><input type="text" name="new_name" value="<%=ef.getName()%>">
		<input type="Submit" name="Submit" value="Save"></td>
	</form>
	<form action="<%=browser_name%>" method="Post">
	<td align="left">
	<input type="Submit" name="Submit" value="Cancel">
	<input type="hidden" name="nfile" value="<%= request.getParameter("editfile")%>">
	<input type="hidden" name="sort" value="<%=request.getParameter("sort")%>">
	</td>
	</form>
	</tr>
	</table>
	</center>
	<br />
	<hr>
	<center>
		<small>jsp File Browser version <%= FileBrowser.VERSION_NR%> by <a href="http://www.vonloesch.de">www.vonloesch.de</a></small>
	</center>
</body>
</html>
<%
            }
		}
		// Save or cancel the edited file
		else if (request.getParameter("nfile") != null) {
			File f = new File(request.getParameter("nfile"));
			if (request.getParameter("Submit").equals("Save")) {
				File new_f = new File(FileBrowser.getDir(f.getParent(), request.getParameter("new_name")));
	            if (!FileBrowser.isAllowed(new_f, true,RESTRICT_PATH)){
	                request.setAttribute("error", "You are not allowed to access " + new_f.getAbsolutePath());
	            }
				if (new_f.exists() && new_f.canWrite() && request.getParameter("Backup") != null) {
					File bak = new File(new_f.getAbsolutePath() + ".bak");
					bak.delete();
					new_f.renameTo(bak);
				}
				if (new_f.exists() && !new_f.canWrite()) request.setAttribute("error",
						"Cannot write to " + new_f.getName() + ", file is write protected.");
				else {
					BufferedWriter outs = new BufferedWriter(new FileWriter(new_f));
					StringReader text = new StringReader(request.getParameter("text"));
					int i;
					boolean cr = false;
					String lineend = "\n";
					if (request.getParameter("lineformat").equals("dos")) lineend = "\r\n";
					while ((i = text.read()) >= 0) {
						if (i == '\r') cr = true;
						else if (i == '\n') {
							outs.write(lineend);
							cr = false;
						}
						else if (cr) {
							outs.write(lineend);
							cr = false;
						}
						else {
							outs.write(i);
							cr = false;
						}
					}
					outs.flush();
					outs.close();
				}
			}
			request.setAttribute("dir", f.getParent());
		}
		//Unpack file to the current directory without overwriting
		else if (request.getParameter("unpackfile") != null) {
			File f = new File(request.getParameter("unpackfile"));
			String root = f.getParent();
			request.setAttribute("dir", root);
            if (!FileBrowser.isAllowed(new File(root), true,RESTRICT_PATH)){
                request.setAttribute("error", "You are not allowed to access " + root);
            }
			//Check if file exists
			else if (!f.exists()) {
				request.setAttribute("error", "Cannot unpack " + f.getName()
						+ ", file does not exist");
			}
			//Check if directory is readonly
			else if (!f.getParentFile().canWrite()) {
				request.setAttribute("error", "Cannot unpack " + f.getName()
						+ ", directory is write protected.");
			}
			//GZip
			else if (f.getName().toLowerCase().endsWith(".gz")) {
				//New name is old Name without .gz
				String newName = f.getAbsolutePath().substring(0, f.getAbsolutePath().length() - 3);
				try {
					byte buffer[] = new byte[0xffff];
					FileBrowser.copyStreams(new GZIPInputStream(new FileInputStream(f)), new FileOutputStream(
							newName), buffer);
				}
				catch (IOException ex) {
					request.setAttribute("error", "Unpacking of " + f.getName()
							+ " aborted. Error: " + ex);
				}
			}
			//Else try Zip
			else {
				try {
					ZipFile zf = new ZipFile(f);
					Enumeration entries = zf.entries();
					//First check whether a file already exist
					boolean error = false;
					while (entries.hasMoreElements()) {
						ZipEntry entry = (ZipEntry) entries.nextElement();
						if (!entry.isDirectory()
								&& new File(root + File.separator + entry.getName()).exists()) {
							request.setAttribute("error", "Cannot unpack " + f.getName()
									+ ", File " + entry.getName() + " already exists.");
							error = true;
							break;
						}
					}
					if (!error) {
						//Unpack File
						entries = zf.entries();
						byte buffer[] = new byte[0xffff];
						while (entries.hasMoreElements()) {
							ZipEntry entry = (ZipEntry) entries.nextElement();
							File n = new File(root + File.separator + entry.getName());
							if (entry.isDirectory()) n.mkdirs();
							else {
								n.getParentFile().mkdirs();
								n.createNewFile();
								FileBrowser.copyStreams(zf.getInputStream(entry), new FileOutputStream(n),
										buffer);
							}
						}
						zf.close();
						request.setAttribute("message", "Unpack of " + f.getName()
								+ " was successful.");
					}
				}
				catch (ZipException ex) {
					request.setAttribute("error", "Cannot unpack " + f.getName()
							+ ", no valid zip file");
				}
				catch (IOException ex) {
					request.setAttribute("error", "Unpacking of " + f.getName()
							+ " aborted. Error: " + ex);
				}
			}
		}
		// Delete Files
		else if ((request.getParameter("Submit") != null)
				&& (request.getParameter("Submit").equals(FileBrowser.DELETE_FILES))) {
			Vector v = FileBrowser.expandFileList(request.getParameterValues("selfile"), true);
			boolean error = false;
			//delete backwards
			for (int i = v.size() - 1; i >= 0; i--) {
				File f = (File) v.get(i);
                if (!FileBrowser.isAllowed(f, true,RESTRICT_PATH)){
                    request.setAttribute("error", "You are not allowed to access " + f.getAbsolutePath());
                    error = true;
                    break;
                }
				if (!f.canWrite() || !f.delete()) {
					request.setAttribute("error", "Cannot delete " + f.getAbsolutePath()
							+ ". Deletion aborted");
					error = true;
					break;
				}
			}
			if ((!error) && (v.size() > 1)) request.setAttribute("message", "All files deleted");
			else if ((!error) && (v.size() > 0)) request.setAttribute("message", "File deleted");
			else if (!error) request.setAttribute("error", "No files selected");
		}
		// Create Directory
		else if ((request.getParameter("Submit") != null)
				&& (request.getParameter("Submit").equals(FileBrowser.CREATE_DIR))) {
			String dir = "" + request.getAttribute("dir");
			String dir_name = request.getParameter("cr_dir");
			String new_dir = FileBrowser.getDir(dir, dir_name);
            if (!FileBrowser.isAllowed(new File(new_dir), true,RESTRICT_PATH)){
                request.setAttribute("error", "You are not allowed to access " + new_dir);
            }
			else if (new File(new_dir).mkdirs()) {
				request.setAttribute("message", "Directory created");
			}
			else request.setAttribute("error", "Creation of directory " + new_dir + " failed");
		}
		// Create a new empty file
		else if ((request.getParameter("Submit") != null)
				&& (request.getParameter("Submit").equals(FileBrowser.CREATE_FILE))) {
			String dir = "" + request.getAttribute("dir");
			String file_name = request.getParameter("cr_dir");
			String new_file = FileBrowser.getDir(dir, file_name);
            if (!FileBrowser.isAllowed(new File(new_file), true,RESTRICT_PATH)){//对不起，你没有权限访问该目录      返回
                request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>" + new_file);
            }
			// Test, if file_name is empty
			else if (!"".equals(file_name.trim()) && !file_name.endsWith(File.separator)) {
				if (new File(new_file).createNewFile()) request.setAttribute("message",
						"File created");
				else request.setAttribute("error", "Creation of file " + new_file + " failed");
			}
			else request.setAttribute("error", "Error: " + file_name + " is not a valid filename");
		}
		// Rename a file
		else if ((request.getParameter("Submit") != null)
				&& (request.getParameter("Submit").equals(FileBrowser.RENAME_FILE))) {
			Vector v = FileBrowser.expandFileList(request.getParameterValues("selfile"), true);
			String dir = "" + request.getAttribute("dir");
			String new_file_name = request.getParameter("cr_dir");
			String new_file = FileBrowser.getDir(dir, new_file_name);
            if (!FileBrowser.isAllowed(new File(new_file), true,RESTRICT_PATH)){//对不起，你没有权限访问该目录   返回
                request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>" + new_file);
            }
			// The error conditions:
			// 1) Zero Files selected
			else if (v.size() <= 0) request.setAttribute("error",
					"Select exactly one file or folder. Rename failed");
			// 2a) Multiple files selected and the first isn't a dir
			//     Here we assume that expandFileList builds v from top-bottom, starting with the dirs
			else if ((v.size() > 1) && !(((File) v.get(0)).isDirectory())) request.setAttribute(
					"error", "Select exactly one file or folder. Rename failed");
			// 2b) If there are multiple files from the same directory, rename fails
			else if ((v.size() > 1) && ((File) v.get(0)).isDirectory()
					&& !(((File) v.get(0)).getPath().equals(((File) v.get(1)).getParent()))) {
				request.setAttribute("error", "Select exactly one file or folder. Rename failed");
			}
			else {
				File f = (File) v.get(0);
                if (!FileBrowser.isAllowed(f, true,RESTRICT_PATH)){// 对不起，你没有权限访问该目录   返回
                    request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>");
                }
				// Test, if file_name is empty
				else if ((new_file.trim() != "") && !new_file.endsWith(File.separator)) {
					if (!f.canWrite() || !f.renameTo(new File(new_file.trim()))) {
						request.setAttribute("error", "Creation of file " + new_file + " failed");
					}
					else request.setAttribute("message", "Renamed file "
							+ ((File) v.get(0)).getName() + " to " + new_file);
				}
				else request.setAttribute("error", "Error: \"" + new_file_name
						+ "\" is not a valid filename");
			}
		}
		// Move selected file(s)
		else if ((request.getParameter("Submit") != null)
				&& (request.getParameter("Submit").equals(FileBrowser.MOVE_FILES))) {
			Vector v = FileBrowser.expandFileList(request.getParameterValues("selfile"), true);
			String dir = "" + request.getAttribute("dir");
			String dir_name = request.getParameter("cr_dir");
			String new_dir = FileBrowser.getDir(dir, dir_name);
            if (!FileBrowser.isAllowed(new File(new_dir), false,RESTRICT_PATH)){//对不起，你没有权限访问该目录   返回
                request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>" + new_dir);
            }
            else{
    			boolean error = false;
                // This ensures that new_dir is a directory
                if (!new_dir.endsWith(File.separator)) new_dir += File.separator;
                for (int i = v.size() - 1; i >= 0; i--) {
                    File f = (File) v.get(i);
                    if (!FileBrowser.isAllowed(f, true,RESTRICT_PATH)){//对不起，你没有权限访问该目录   返回
                        request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>");
                        error = true;
                        break;
                    }
                    else if (!f.canWrite() || !f.renameTo(new File(new_dir
                            + f.getAbsolutePath().substring(dir.length())))) {
                        request.setAttribute("error", "Cannot move " + f.getAbsolutePath()
                                + ". Move aborted");
                        error = true;
                        break;
                    }
                }
                if ((!error) && (v.size() > 1)) request.setAttribute("message", "All files moved");
                else if ((!error) && (v.size() > 0)) request.setAttribute("message", "File moved");
                else if (!error) request.setAttribute("error", "No files selected");
            }
		}
		// Copy Files
		else if ((request.getParameter("Submit") != null)
				&& (request.getParameter("Submit").equals(FileBrowser.COPY_FILES))) {
			Vector v = FileBrowser.expandFileList(request.getParameterValues("selfile"), true);
			String dir = (String) request.getAttribute("dir");
			if (!dir.endsWith(File.separator)) dir += File.separator;
			String dir_name = request.getParameter("cr_dir");
			String new_dir = FileBrowser.getDir(dir, dir_name);
            if (!FileBrowser.isAllowed(new File(new_dir), true,RESTRICT_PATH)){//对不起，你没有权限访问该目录   返回
                request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>");
            }
            else{
    			boolean error = false;
                if (!new_dir.endsWith(File.separator)) new_dir += File.separator;
                try {
                    byte buffer[] = new byte[0xffff];
                    for (int i = 0; i < v.size(); i++) {
                        File f_old = (File) v.get(i);
                        File f_new = new File(new_dir + f_old.getAbsolutePath().substring(dir.length()));
                        if (!FileBrowser.isAllowed(f_old, false,RESTRICT_PATH)|| !FileBrowser.isAllowed(f_new, true,RESTRICT_PATH)){//对不起，你没有权限访问该目录   返回
                            request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>");
                            error = true;
                        }
                        else if (f_old.isDirectory()) f_new.mkdirs();
                        // Overwriting is forbidden
                        else if (!f_new.exists()) {
                        	FileBrowser.copyStreams(new FileInputStream(f_old), new FileOutputStream(f_new), buffer);
                        }
                        else {
                            // File exists
                            request.setAttribute("error", "Cannot copy " + f_old.getAbsolutePath()
                                    + ", file already exists. Copying aborted");
                            error = true;
                            break;
                        }
                    }
                }
                catch (IOException e) {
                    request.setAttribute("error", "Error " + e + ". Copying aborted");
                    error = true;
                }
                if ((!error) && (v.size() > 1)) request.setAttribute("message", "All files copied");
                else if ((!error) && (v.size() > 0)) request.setAttribute("message", "File copied");
                else if (!error) request.setAttribute("error", "No files selected");
            }
		}
		// Directory viewer
		if (dir_view && request.getAttribute("dir") != null) {
			File f = new File("" + request.getAttribute("dir"));
			//Check, whether the dir exists
			if (!f.exists() || !FileBrowser.isAllowed(f, false,RESTRICT_PATH)) {
				if (!f.exists()){
                    request.setAttribute("error", "Directory " + f.getAbsolutePath() + " does not exist.");
                }
                else{//对不起，你没有权限访问该目录   返回
                    request.setAttribute("error", labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003b")+",<a href='javascript:history.go(-1);'>"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"</a>");
                }
				//if attribute olddir exists, it will change to olddir
				if (request.getAttribute("olddir") != null && FileBrowser.isAllowed(new File((String) request.getAttribute("olddir")), false,RESTRICT_PATH)) {
					f = new File("" + request.getAttribute("olddir"));
				}
				//try to go to the parent dir
				else {
					if (f.getParent() != null && FileBrowser.isAllowed(f, false,RESTRICT_PATH)) f = new File(f.getParent());
				}
				//If this dir also do also not exist, go back to browser.jsp root path
				if (!f.exists()) {
					String path = null;
					if (application.getRealPath(request.getRequestURI()) != null) path = new File(
							application.getRealPath(request.getRequestURI())).getParent();

					if (path == null) // handle the case were we are not in a directory (ex: war file)
					path = new File(".").getAbsolutePath();
					f = new File(path);
				}
				if (FileBrowser.isAllowed(f, false,RESTRICT_PATH)) request.setAttribute("dir", f.getAbsolutePath());
                else request.setAttribute("dir", null);
			}
%>
<script type="text/javascript" src="<%=browser_name %>?Javascript">
</script>
<title><%=request.getAttribute("dir")%></title>
</head>
<body>
<%
//Output message
if (request.getAttribute("message") != null) {
	out.println("<table border=\"0\" width=\"100%\"><tr><td class=\"message\">");
	out.println(request.getAttribute("message"));
	out.println("</td></tr></table>");
}
//Output error
if (request.getAttribute("error") != null) {
	out.println("<table border=\"0\" width=\"100%\"><tr><td class=\"error\">");
	out.println(request.getAttribute("error"));
	out.println("</td></tr></table>");
}
         if (request.getAttribute("dir") != null){
%>

	<form class="formular" action="<%= browser_name %>" method="Post" name="FileList">
    按文件名查找: <input name="filt" onKeypress="event.cancelBubble=true;" onkeyup="filter(this)" type="text">
    <br /><br />
	<table id="filetable" class="filelist" cellspacing="1px" cellpadding="0px">
<%
			// Output the table, starting with the headers.
			String dir = java.net.URLEncoder.encode("" + request.getAttribute("dir"),"UTF-8");
			String cmd = browser_name + "?dir=" + dir;
			int sortMode = 1;
			if (request.getParameter("sort") != null) sortMode = Integer.parseInt(request
					.getParameter("sort"));
			int[] sort = new int[] {1, 2, 3, 4};
			for (int i = 0; i < sort.length; i++)
				if (sort[i] == sortMode) sort[i] = -sort[i];
			out.print("<tr><th></th><th title=\"Sort files by name\" align=left><a style='font-size:12px;' href=\""
					+ cmd + "&amp;sort=" + sort[0] + "\">"+labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003c")+"</a></th>"
					+ "<th title=\"Sort files by size\" align=\"right\"><a style='font-size:12px;' href=\"" + cmd
					+ "&amp;sort=" + sort[1] + "\">"+labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003d")+"</a></th>"
					+ "<th title=\"Sort files by type\" align=\"center\"><a style='font-size:12px;' href=\"" + cmd
					+ "&amp;sort=" + sort[3] + "\">"+labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026")+"</a></th>"
					+ "<th title=\"Sort files by date\" align=\"left\"><a style='font-size:12px;' href=\"" + cmd
					+ "&amp;sort=" + sort[2] + "\">"+labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")+"</a></th>");//文件名   大小  类型    日期
					//+ "<th>&nbsp;</th>");
			if (!FileBrowser.READ_ONLY) out.print ("<th>&nbsp;</th>");
			out.println("</tr>");
			char trenner = File.separatorChar;
			// Output the Root-Dirs, without FORBIDDEN_DRIVES
			File[] entry = File.listRoots();
			//for (int i = 0; i < entry.length; i++) {
			for (int i = 0; i < 0; i++) {//隐藏盘符现实
				boolean forbidden = false;
				for (int i2 = 0; i2 < FileBrowser.FORBIDDEN_DRIVES.length; i2++) {
					if (entry[i].getAbsolutePath().toLowerCase().equals(FileBrowser.FORBIDDEN_DRIVES[i2])) forbidden = true;
				}
				if (!forbidden) {
					out.println("<tr class=\"mouseout\" onmouseover=\"this.className='mousein'\""
							+ "onmouseout=\"this.className='mouseout'\">");
					out.println("<td>&nbsp;</td><td align=left >");
					String name = java.net.URLEncoder.encode(entry[i].getAbsolutePath(),"UTF-8");
					String buf = entry[i].getAbsolutePath();
					out.println(" &nbsp;<a href=\"" + browser_name + "?sort=" + sortMode
							+ "&amp;dir=" + name + "\">[" + buf + "]</a>");
					out.print("</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td></td></tr>");
				}
			}
			// Output the parent directory link ".."
			if (f.getParent() != null) {
				out.println("<tr class=\"mouseout\" onmouseover=\"this.className='mousein'\""
						+ "onmouseout=\"this.className='mouseout'\">");
				out.println("<td style='height:22px;'></td><td align=left>");
				out.println(" &nbsp;<a title='"+labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003e")+"' href=\"" + browser_name + "?sort=" + sortMode + "&amp;dir="
						+ java.net.URLEncoder.encode(f.getParent(),"UTF-8") + "\">" + FOL_IMG + "[...]</a>");//上级目录
				out.print("</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
			}
			// Output all files and dirs and calculate the number of files and total size
			entry = f.listFiles();
			if (entry == null) entry = new File[] {};
			long totalSize = 0; // The total size of the files in the current directory
			long fileCount = 0; // The count of files in the current working directory
			if (entry != null && entry.length > 0) {
				Arrays.sort(entry, new FileComp(sortMode));
				for (int i = 0; i < entry.length; i++) {
					String name = java.net.URLEncoder.encode(entry[i].getAbsolutePath(),"UTF-8");
					String type = "File"; // This String will tell the extension of the file
					if (entry[i].isDirectory()) type = labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98003f"); // It's a DIR  文件夹
					else {
						String tempName = entry[i].getName().replace(' ', '_');
						if (tempName.lastIndexOf('.') != -1) type = tempName.substring(
								tempName.lastIndexOf('.')).toLowerCase();
					}
					String ahref = "<a onmousedown=\"dis()\" href=\"" + browser_name + "?sort="
							+ sortMode + "&amp;";
					String dlink = "&nbsp;"; // The "Download" link
					String elink = "&nbsp;"; // The "Edit" link
					String buf = StringHelper.conv2Html(entry[i].getName());
					if (!entry[i].canWrite()) buf = "<i>" + buf + "</i>";
					String link = buf; // The standard view link, uses Mime-type
					if (entry[i].isDirectory()) {
						if (entry[i].canRead() && FileBrowser.USE_DIR_PREVIEW) {
							//Show the first DIR_PREVIEW_NUMBER directory entries in a tooltip
							File[] fs = entry[i].listFiles();
							if (fs == null) fs = new File[] {};
							Arrays.sort(fs, new FileComp());
							StringBuffer filenames = new StringBuffer();
							for (int i2 = 0; (i2 < fs.length) && (i2 < 10); i2++) {
								String fname = StringHelper.conv2Html(fs[i2].getName());
								if (fs[i2].isDirectory()) filenames.append("[" + fname + "];");
								else filenames.append(fname + ";");
							}
							if (fs.length > FileBrowser.DIR_PREVIEW_NUMBER) filenames.append("...");
							else if (filenames.length() > 0) filenames
									.setLength(filenames.length() - 1);
							link = ahref + "dir=" + name + "\" title=\"" + filenames + "\" target='self'>"
									+ FOL_IMG + "[" + buf + "]</a>";
						}
						else if (entry[i].canRead()) {
							link = ahref + "dir=" + name + "\">" + FOL_IMG + "[" + buf + "]</a>";
						}
						else link = FOL_IMG + "[" + buf + "]";
					}
					else if (entry[i].isFile()) { //Entry is file
						totalSize = totalSize + entry[i].length();
						fileCount = fileCount + 1;
						if (entry[i].canRead()) {
							dlink = ahref + "downfile=" + name + "\">"+labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd74fe5650002")+"</a>";//下载
							//If you click at the filename
							link = "<a style='cursor:hand' onClick=\"javascript:selectIt('"+buf+"');\">" + buf +"</a>";
							//if (USE_POPUP) link = ahref + "file=" + name + "\" target=\"_blank\">"
									//+ buf + "</a>";
							//else link = ahref + "file=" + name + "\">" + buf + "</a>";
							if (entry[i].canWrite()) { // The file can be edited
								//If it is a zip or jar File you can unpack it
								if (FileBrowser.isPacked(name, true)) elink = ahref + "unpackfile=" + name
										+ "\">Unpack</a>";
								else elink = ahref + "editfile=" + name + "\">Edit</a>";
							}
							else { // If the file cannot be edited
								//If it is a zip or jar File you can unpack it
								if (FileBrowser.isPacked(name, true)) elink = ahref + "unpackfile=" + name
										+ "\">Unpack</a>";
								else elink = ahref + "editfile=" + name + "\">View</a>";
							}
						}
						else {
							link = buf;
						}
					}
					String date = FileBrowser.dateFormat.format(new Date(entry[i].lastModified()));
					out.println("<tr class=\"mouseout\" onmouseup=\"selrow(this, 2)\" "
							+ "onmouseover=\"selrow(this, 0);\" onmouseout=\"selrow(this, 1)\">");
					if (entry[i].canRead()) {
						if(entry[i].isFile()){
							out.println("<td style='height:22px' align='center'>&nbsp;</td>");
							//out.println("<td style='height:22px;' align=center><input type=\"checkbox\" name=\"selfile\" value=\"" + name + "\" onmousedown=\"dis()\"></td>");
						}else{
							out.println("<td style='height:22px;' align=center>&nbsp;</td>");
						}

					}
					else {
						out.println("<td align=center><input type=\"checkbox\" name=\"selfile\" disabled></td>");
					}
					out.print("<td align=left> &nbsp;" + link + "</td>");
					if (entry[i].isDirectory()) out.print("<td>&nbsp;</td>");
					else {
						out.print("<td align=right title=\"" + entry[i].length() + " bytes\">"
								+ FileHelper.convertFileSize(entry[i].length()) + "</td>");
					}
					out.println("<td align=\"center\">" + type + "</td>"// The file type (extension)
							+"<td align=left> &nbsp;"+date + "</td>"); // The date the file was created
							//+"<td>"+dlink + "</td>"); // The download link							
					if (!FileBrowser.READ_ONLY)
						out.print ("<td>" + elink + "</td>"); // The edit link (or view, depending)
					out.println("</tr>");
				}
			}%>
	</table>
	<!--  
	<input type="checkbox" name="selall" onClick="AllFiles(this.form)">全选

	-->
	<p align=center>
		<b title="<%=totalSize%> bytes">
		<%=FileHelper.convertFileSize(totalSize)%></b><b> in <%=fileCount%> files in <%= FileBrowser.dir2linkdir((String) request.getAttribute("dir"), browser_name, sortMode)%>
		</b><span style="display:none" id="forderPath"><%= FileBrowser.dir2linkdir((String) request.getAttribute("dir"), browser_name, sortMode)%></span>
	</p>
		<input type="hidden" name="dir" value="<%=request.getAttribute("dir")%>">
		<input type="hidden" name="sort" value="<%=sortMode%>">
		<!-- input title="添加选中的文件" class="button" id="but_Zip" type="Submit" name="Submit" value=""-->
		<% if (!FileBrowser.READ_ONLY) {%>
			<input title="Delete all selected files and directories incl. subdirs" class="button"  id="but_Del" type="Submit" name="Submit" value="<%=FileBrowser.DELETE_FILES%>"
			onclick="return confirm('Do you really want to delete the entries?')">
		<% } %>
	<% if (!FileBrowser.READ_ONLY) {%>
	<br />
		<input title="Enter new dir or filename or the relative or absolute path" class="textfield" type="text" onKeypress="event.cancelBubble=true;" id="text_Dir" name="cr_dir">
		<input title="Create a new directory with the given name" class="button" id="but_NDi" type="Submit" name="Submit" value="<%=FileBrowser.CREATE_DIR%>">
		<input title="Create a new empty file with the given name" class="button" id="but_NFi" type="Submit" name="Submit" value="<%=FileBrowser.CREATE_FILE%>">
		<input title="Move selected files and directories to the entered path" id="but_Mov" class="button" type="Submit" name="Submit" value="<%=FileBrowser.MOVE_FILES%>">
		<input title="Copy selected files and directories to the entered path" id="but_Cop" class="button" type="Submit" name="Submit" value="<%=FileBrowser.COPY_FILES%>">
		<input title="Rename selected file or directory to the entered name" id="but_Ren" class="button" type="Submit" name="Submit" value="<%=FileBrowser.RENAME_FILE%>">
	<% } %>
	</form>
    <%}%>
</body>
<script language="javascript" type="text/javascript">
function selectIt(path){
	var forderPath=document.getElementById("forderPath");
	var returnValue=forderPath.innerText+path;
	window.opener.document.getElementById("addedFile").value=returnValue;
	window.close();
}
</script>
</html>
<%
    }
%>