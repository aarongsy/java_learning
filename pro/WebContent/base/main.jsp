<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="/base/init.jsp"%>


<style>
#idDiv{width:100%;height:40px;background-color:#FFFFFF;color:#FFFFFF;padding:6px;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#FF50A2DE, endColorstr=#BB0C1E27);}
</style>

<html>
  <head>
  		<title>e-weaver appconf console</title>
  </head>

  <body>

<table height=100%>
	<tr height="30" id="topmenu" name="topmenu" style="DISPLAY:''">
		<td align=center>
            <div id=idDiv>e-weaver appconf console</div>
        </td>
	</tr>

	<tr>
		<td>
			<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0" id="maintable" name="maintable">
			    <tr>
			   	<td width="200" valign="top" style="DISPLAY:''">
					<iframe id="leftframe" name="leftframe" BORDER=0 FRAMEBORDER=0  height="100%" width="100%" scrolling="auto" src="<%= request.getContextPath()%>/base/menu/menusystem.jsp" target="mainframe">
					</iframe>&nbsp;
				</td>
				<td>
					<iframe id="mainframe" name="mainframe" BORDER=0 FRAMEBORDER=0  height="100%" width="100%" SCROLLING=auto SRC=""></iframe>&nbsp;
				</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>

  </body>
<script language="javascript">
	function onSubmit(){
		alert("dfdfdfdf");
	}
</script>

</html>