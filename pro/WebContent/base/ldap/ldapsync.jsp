<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>    
<title><%=labelService.getLabelName("4028835c395798cb01395798d23e0000")%></title>
<script type="text/javascript">
function syncOA(){
	var fields = document.all("fields1");
	var fieldValues="";
	for(var i=0;i<fields.length;i++){
		if(fields[i].checked){
			fieldValues+=","+fields[i].value;
		}
	}
	document.getElementById("button1").disabled=true;
	document.getElementById("loading1").style.display="";
	document.getElementById("success1").innerText="";
	document.getElementById("failed1").innerText="";
	Ext.Ajax.request({
		url:"/ServiceAction/com.eweaver.ldap.action.LdapAction?action=syncOA",
		method:"POST",
		params:{fields:fieldValues},
		success: function (result,request){
			var responseText = result.responseText;
			var jsonData =  Ext.util.JSON.decode(responseText);
			var success = jsonData.success;
			var failed = jsonData.failed;
			document.getElementById("button1").disabled=false;
			document.getElementById("loading1").style.display="none";
			document.getElementById("success1").innerText=success;
			document.getElementById("failed1").innerText=failed;
		},
		failure: function (result,request) {
			alert(result.responseText);
		}
	});
}

function syncLDAP(){
	var fields = document.all("fields2");
	var fieldValues="";
	for(var i=0;i<fields.length;i++){
		if(fields[i].checked){
			fieldValues+=","+fields[i].value;
		}
	}
	document.getElementById("button2").disabled=true;
	document.getElementById("loading2").style.display="";
	document.getElementById("success2").innerText="";
	document.getElementById("failed2").innerText="";
	Ext.Ajax.request({
		url:"/ServiceAction/com.eweaver.ldap.action.LdapAction?action=syncLDAP",
		method:"POST",
		params:{fields:fieldValues},
		success: function (result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var success = jsonData.success;
			var failed = jsonData.failed;
			document.getElementById("button2").disabled=false;
			document.getElementById("loading2").style.display="none";
			document.getElementById("success2").innerText=success;
			document.getElementById("failed2").innerText=failed;
		},
		failure: function (result,request) {
			alert(result.responseText);
		}
	});
}
</script>
</head>
<body>
<fieldset style="margin: 10px;">
	<legend style="font-weight:bold;color:blue;margin:4px;">LDAP信息同步至OA [LDAP-->OA]</legend>
	<table>
		<colgroup>
			<col width="100px"></col>
			<col width="*"></col>
		</colgroup>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d24a003a")%></td>
			<td class="fieldvalue">
				<input type="checkbox" name="fields1" value="account" checked>
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d245001e")%></label>
				<input type="checkbox" name="fields1" value="mail">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2460024")%></label>
				<input type="checkbox" name="fields1" value="mobile">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2470028")%></label>
				<input type="checkbox" name="fields1" value="phone">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2460026")%></label>
				<input type="checkbox" name="fields1" value="office">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d247002a")%></label>
				<input type="checkbox" name="fields1" value="no">
				<label><%=labelService.getLabelName("4028835c395798cb01395798d2460022")%></label>
			</td>
		</tr>
		<tr>
			<td class="fieldname"></td>
			<td class="fieldvalue">
				<button type="button" id="button1" onclick="javascript:syncOA();"><%=labelService.getLabelName("4028835c395798cb01395798d24a003c")%></button>
				<div>
					<div id="loading1" style="display:none"><img src="/images/base/loading.gif"/><%=labelService.getLabelName("4028835c395798cb01395798d24a003e")%></div>
					<div id="success1" style="color:green;"></div>
					<div id="failed1" style="color: red;"></div>
				</div>
			</td>
		</tr>
	</table>
</fieldset>
<fieldset style="margin: 10px;">
	<legend style="font-weight:bold;color:blue;margin:4px;">OA信息同步至LDAP [OA-->LDAP]</legend>
	<table>
		<colgroup>
			<col width="100px"></col>
			<col width="*"></col>
		</colgroup>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d24a003a")%></td>
			<td class="fieldvalue">
				<input type="checkbox" name="fields2" value="password">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2460020")%></label>
				<input type="checkbox" name="fields2" value="mail">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2460024")%></label>
				<input type="checkbox" name="fields2" value="mobile">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2470028")%></label>
				<input type="checkbox" name="fields2" value="phone">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2460026")%></label>
				<input type="checkbox" name="fields2" value="orgunit">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2480034")%></label>
				<input type="checkbox" name="fields2" value="station">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2490036")%></label>
				<input type="checkbox" name="fields2" value="office">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d247002a")%></label>
				<input type="checkbox" name="fields2" value="company">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d247002e")%></label>
				<input type="checkbox" name="fields2" value="description">
				<label style="margin-right: 15px"><%=labelService.getLabelName("4028835c395798cb01395798d2490038")%></label>
				<input type="checkbox" name="fields2" value="no">
				<label><%=labelService.getLabelName("4028835c395798cb01395798d2460022")%></label>
			</td>
		</tr>
		<tr>
			<td class="fieldname"></td>
			<td class="fieldvalue">
				<button type="button" id="button2" onclick="javascript:syncLDAP();"><%=labelService.getLabelName("4028835c395798cb01395798d24a003c")%></button>
				<div>
					<div id="loading2" style="display:none"><img src="/images/base/loading.gif" align="middle" /><%=labelService.getLabelName("4028835c395798cb01395798d24a003e")%></div>
					<div id="success2" style="color:green;"></div>
					<div id="failed2" style="color: red;"></div>
				</div>
			</td>
		</tr>
	</table>
</fieldset>
</body>
</html>