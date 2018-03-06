<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:appSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem.gif";
String titlename ="微博应用设置"; //微博应用设置
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=StringHelper.null2String(request.getParameter("operation"));

String sqlstr="select * from blog_app where appType is not null order by sort";
RecordSet.execute(sqlstr);

%>
<html>
  <head>
    <link href="/ecology/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  <body>
 <%@ include file="/systeminfo/TopTitle.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
 <% 
	 RCMenu += "{保存,javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="editApp" name="operation"/> 
    <TABLE class=ViewForm style="width: 98%" align="center">
		<COLGROUP>
		<COL width="30%">
		<COL width="20%">
		<COL width="50%">
		<TBODY>
			<TR class=Title>
				<TH>应用名称</TH> <!-- 应用名称 -->
				<TH colSpan=2>启用</TH><!-- 启用 -->
			</TR>
			
			<TR class=Spacing style="height: 1px;">
			<TD class=Line1 colSpan=3></TD>
			</TR>
		  <%
		   while(RecordSet.next()){
			  String appid=RecordSet.getString("id");
		      String appName=RecordSet.getString("name");
		      String appType=RecordSet.getString("appType");
		      String isActive=RecordSet.getString("isActive");
		      appName=!appType.equals("custom")?SystemEnv.getHtmlLabelName(Integer.parseInt(appName),user.getLanguage()):appName;
		  %>
		     <tr>
			  <td><%=appName%></td>
			  <td class=Field>  
			    <input type="hidden" value="<%=appid%>" name="appid">
				<input type="checkbox" name="isActive_<%=appid%>" <%=isActive.equals("1")?"checked=checked":""%>  value="1" />
			  </td>
			  <td class="Field">
			    &nbsp;
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=3></TD></TR>
		  <%} %>
		</TBODY>
	</TABLE>
	</form>  
  </body>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
  
  function doEdit(){
    window.location.href="BlogAppSetting.jsp?operation=editApp";
  }
  
 </script>
</html>
