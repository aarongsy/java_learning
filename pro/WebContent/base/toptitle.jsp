
<HTML><HEAD>
</HEAD>
<%
String _titlename=StringHelper.null2String(titlename);
String _titleimage=StringHelper.null2String(titleimage);
String _thepara="";
String _favtitle=_titlename;
for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
	String tmpname=(String) En.nextElement();
	String tmpvalue=StringHelper.null2String(request.getParameter(tmpname));
	_thepara+="&"+tmpname+"="+tmpvalue;
}

int start = _favtitle.indexOf("<a");
int end = _favtitle.indexOf("/a>");
while(start!=-1){
	_favtitle = _favtitle.substring(0,start)+_favtitle.substring(end+3,_favtitle.length());
	start = _favtitle.indexOf("<a");
	end = _favtitle.indexOf("/a>");
}
session.setAttribute("favtitle" , _favtitle ) ;
session.setAttribute("favurl" , theuri ) ;
session.setAttribute("favpara" , _thepara ) ;
%>
<BODY>
<table class="toptitle" style="display:">
<!--
<tr>
<td width="10px" style="background:url(/images/main/titlebar_bg.jpg)">
</td>
<td style="background:url(/images/main/titlebar_bg.jpg)">
	<%=_titlename%>
</td>
</tr>
-->
</table>
<script language="javascript" type="text/javascript">
 <!--
	function addFav(){	//?????

		var id=window.showModalDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/favlist/favlistcreate.jsp");
	} 	
 -->
 </script>
</BODY>