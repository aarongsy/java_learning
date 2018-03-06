
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
	response.setHeader("Expires", "-1") ; // '将当前页面置为唯一活动的页面,必须关闭这个页面以后,其他的页面才能被激活
	
%>
<HTML xmlns:IE>
<HEAD>
	<TITLE>Clock</TITLE>
	<STYLE>
	@media all 
	{
	  IE\:Clock 
	  {
	    behavior: url(<%=request.getContextPath()%>/plugin/clock.htc) ;
	  }
	}
	</STYLE>
<script>
function getTheTime() {
	thehour =cal.hour;
	theminute = cal.minute;
	if(thehour<10) thehour ="0"+thehour;
	if(theminute<10) theminute ="0"+theminute;
	window.returnValue =thehour+':'+theminute ;
	window.close();
}
</script>	
</HEAD>

<BODY scroll="no">

<TABLE width=100% height=100% border=0 cellpadding=0 cellspacing=0>
<TR>
	<TD>
		<IE:Clock id=cal style="height:100%;width:100%;border:1px solid black;">
		</IE:Clock>
	</TD>
</TR>
<TR>
	<TD align=center height=30px>
		<TABLE border=0 cellpadding=2 cellspacing=0>
		<TR>
			<TD align="center"><input type="BUTTON" value="S-确定" ACCESSKEY=S onclick="getTheTime()"></TD>
			<TD align="center"><input type="BUTTON" value="D-清除" ACCESSKEY=D onclick="window.returnValue = '';window.close()"></TD>
			<TD align="center"><input type="BUTTON" value="C-取消" ACCESSKEY=C onclick="window.close()"></td>                     
		</TR>
		</TABLE>
	</TD>
</TR>
</TABLE>
</BODY>
</HTML>


