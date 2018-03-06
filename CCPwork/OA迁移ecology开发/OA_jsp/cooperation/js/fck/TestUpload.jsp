<%@ page contentType="text/html; charset=GBK" language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.IEditorExt,java.util.*" %>
<%@ page import="weaver.file.EditorExt" %>
	
<!--% @ include file="/systeminfo/init.jsp" %
  if(!HrmUserVarify.checkUserRight(":",user)) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
-->
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript" language="javascript" src="FCKEditor/checkFlashVideo.jsp"></script>
<script language="javascript" type="text/javascript" src="FCKEditor/fckeditor.js"></script>
<script language="javascript" type="text/javascript" src="FCKEditor/FCKEditorExt.js"></script>
<script language="javascript" type="text/javascript" src="/FCKEditor/swfobject.js"></script>
<script language="javascript" type="text/javascript">
window.onload=function(){
	//FCKEditorExt.flvBrowserUrl="/UploadFlv.jsp";
	//FCKEditorExt.flvBrowserUrl="/uploadflv/UploadFlv.jsp";
	FCKEditorExt.initEditor("txt1");

}

function chk(){
	return true;
}
</script>
</head>
<!--jsp:useBean id="abc" scope="request" class="weaver.datacenter.InputReportModuleFile" /-->

<body>

<%
String text="";
if(request.getMethod().toLowerCase().equalsIgnoreCase("post")){

	IEditorExt ext=EditorExt.uploadFile(request);
/*
	Map m=ext.getParameterValues();
	
	Iterator it=m.keySet().iterator();
	Object obj=null;
	out.print("<ul>");
	while(it.hasNext()){
		obj=it.next();
		out.println("<li>"+obj+":"+m.get(obj)+"</li>");
	}
	out.print("</ul>");	
*/
//////////////////////////////////////////////
//	String fname=ext.saveFile("file1","");
//	out.println("savePath:"+fname);
	out.print("<ul>");
	List list1=ext.getFileNames();
	Map m=new HashMap();
	for(int i=0;i<list1.size();i++){
		String name=list1.get(i).toString();
		if(!ext.isValidFile(name))continue;
		ext.saveFile(name,"e:/yeriwei/project/"+name+".jpg");
		m.put(name,"http://localhost:8080/"+name+".jpg");
	}
	out.print("<li>Title:"+ext.getParameter("title"));
	text=ext.getReplacedContent("txt1",m);
	out.print("<li>text:"+text);
	out.print("<li>chkValues:"+ext.getParameter("chk1"));
	
	out.print("</ul>");	
}
%>

<!--%@ include file="/systeminfo/TopTitle.jsp" %-->
<!--%@ include file="/systeminfo/RightClickMenuConent.jsp" %-->
<!--%@ include file="/systeminfo/RightClickMenu.jsp" %-->
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<table class=Shadow>
<tr>
<td valign="top">

<form name="form1" id="form1" method="post" target="_blank" action="#" enctype="multipart/form-data" onsubmit="return chk()">
Title:<input name="title" type="text" size="60" />
<br />
File:<input type="file" name="file1" /><br />
Text:<textarea name="txt1" id="txt1" cols="80" rows="8">Fidtyhdtjfjfgjjh<br /><p><%=text%></p></textarea>
<br />
<span>
<input type="checkbox" name="chk1" value="1" />1<br />
<input type="checkbox" name="chk1" value="2" />2<br />
<input type="checkbox" name="chk1" value="3" />3<br />
<input type="checkbox" name="chk1" value="4" />4</span><br />

<input type="submit" name="btnUpload" value="upload..." />
</form> 

</td>
</tr>
</table>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

<input type="button" name="visible" value="visible..." onclick="document.getElementById('txt1').style.display='';" />

</body></html>
