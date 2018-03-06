<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.util.*"%>
<%
	String reportid = StringHelper.null2String(request.getParameter("reportid"));
	String sql = "select id,objname from contemplate where reportid='" + reportid + "'";
	DataService dataService = new DataService();
	List list = dataService.getValues(sql);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title><%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000a")%></title><!-- 模板 -->

</head>
<body style="font-size:x-small" scroll="auto">
<div class="HdrTitle">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="55px" align="left"></td>
	<td align="left"><span id="BacoTitle" style="font-size:medium; font-weight:bold"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003c")%></span></td><!-- 另存为: 模板 -->
	<td align="right">&nbsp;</td>
	<td width="5px"></td>

</tr>
</table>
</div>


<table style="font-size:x-small">
<tr>
	<td><input type="radio" id="rNew" name="rNew" checked>
		<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")%></td><!-- 新建 -->
	<td><input type="text" size="30" maxlength="60" id="NewTemplate" style="width:220px"></td>
</tr>
<tr>
	<td><input type="radio" id="rNew" name="rNew">
		<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003d")%></td><!-- 现有 -->
	<td>
		<select id="ExistingTemplate" style="width:220px">
		<%
			int listsize = list.size();
			for(int i=0;i<listsize; i++){
				Map tempmap = (Map)list.get(i);
				String contempid = (String)tempmap.get("id");
				String contempname = (String)tempmap.get("objname");
		%>
			<option value="{<%=StringHelper.null2String(contempid)%>}"><%=StringHelper.null2String(contempname)%></option>
		<%		
			}
		%>
			
		</select>
	</td>
</tr>
<tr>
	<td></td>
	<td>
		<input type="radio" id="rPublic" name="rPublic" checked>
			<%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff679c1026e")%><!-- 私人 -->
		<input type="radio" id="rPublic" name="rPublic">
			Public
	</td>
</tr>
<tr>
	<td colspan="2" align="center" height="30px">
		<table border="0" cellpadding="2" cellspacing="0">
		<tr>	
			<td align="center">
						<button  type="button" accessKey="S" onclick="OK_onclick();">
							<U>S</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%><!-- 确定 -->
						</button>	
			</td>
			<td align="center">
						<button  type="button" accessKey="C" onclick="Cancel_onclick();">
							<U>C</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%><!-- 取消 -->
						</button>	
			</td>
		</tr>
		</table>
	</td>
</tr>
</table>
<script language="VBS">
Sub OK_onclick
	Dim retval
	If rNew(0).Checked Then

		getArray NewTemplate.Value, rpublic(1).checked
	Else
		getArray ExistingTemplate.Value, rpublic(1).checked
	End If

End Sub
Sub Cancel_onclick
	window.close
End Sub
</script>
<script>
    function getArray(id,value){
        window.returnValue = [id,value];
        window.close();
    }
</script>
</body>
</html>

