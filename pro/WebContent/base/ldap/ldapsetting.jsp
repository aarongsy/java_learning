<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.ldap.config.*" %>
<% 
Properties props = LdapConfig.getProperties();
String ssl=StringHelper.null2String(props.get("ldap.ssl"));
%>
<html>
<head>    
<title><%=labelService.getLabelName("4028835c395798cb01395798d23e0000")%></title>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
     Ext.onReady(function() {
         Ext.QuickTips.init();
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         addBtn(tb,'<%=labelService.getLabelName("保存")%>','S','accept',function(){onSubmit()});
     });
</script>
</head>
<div id="pagemenubar"></div> 
<body>
<form name="LdapForm" action="" method="post">
<fieldset style="margin: 10px;">
	<legend style="font-weight:bold;color:blue;"><%=labelService.getLabelName("4028835c395798cb01395798d23e0000")%></legend>
	<table>
		<colgroup>
			<col width="130px"></col>
			<col width="*"></col>
		</colgroup>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2400002")%></td>
			<td class="fieldvalue">
				<select name="ldap.connector" onchange="javascript:changeType(this);">
					<option value="com.eweaver.ldap.connector.MicrosoftADConnector" <%if("com.eweaver.ldap.connector.MicrosoftADConnector".equals(props.get("ldap.connector"))){%>selected="selected"<%}%>>Microsoft Active Directory</option>
					<option value="com.eweaver.ldap.connector.ApacheDSConnector" <%if("com.eweaver.ldap.connector.ApacheDSConnector".equals(props.get("ldap.connector"))){%>selected="selected"<%}%>>Apache Directory Server</option>
					<option value="com.eweaver.ldap.connector.OpenLDAPConnector" <%if("com.eweaver.ldap.connector.OpenLDAPConnector".equals(props.get("ldap.connector"))){%>selected="selected"<%}%>>OpenLDAP</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2400004")%></td>
			<td class="fieldvalue">
				<input type="text" name="ldap.host" value="<%=props.get("ldap.host")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2400006")%></td>
			<td class="fieldvalue">
				<input type="text" id="ldap.port" name="ldap.port" value="<%=props.get("ldap.port")%>">
				<input type="checkbox" name="ldap.ssl" <%if("true".equals(ssl)){%>checked="checked"<%}%> onclick="javascript:changePort(this);">
				<%=labelService.getLabelName("4028835c395798cb01395798d24a0040")%>
			</td>
		</tr>
		<tr id="keystorerow" <%if(!"true".equals(ssl)){%>style="display:none;"<%}%>>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2400008")%></td>
			<td class="fieldvalue">
				<input type="text" name="ldap.keystore" value="<%=props.get("ldap.keystore")%>">
				<label style="color:#666">SSL链接方式下需提供java证书，证书存放至WEB-INF/classes目录</label>
			</td>
		</tr>
		<tr id="keypaswdrow" <%if(!"true".equals(ssl)){%>style="display:none;"<%}%>>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d241000a")%></td>
			<td class="fieldvalue">
				<input type="password" name="ldap.keypaswd" value="<%=props.get("ldap.keypaswd")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d241000c")%></td>
			<td class="fieldvalue">
				<input type="text" name="ldap.adminName" value="<%=props.get("ldap.adminName")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d241000e")%></td>
			<td class="fieldvalue">
				<input type="password" name="ldap.adminPaswd" value="<%=props.get("ldap.adminPaswd")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2420010")%></td>
			<td class="fieldvalue">
				<input type="text" style="width:400px;" name="ldap.baseDN" value="<%=props.get("ldap.baseDN")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2430012")%></td>
			<td class="fieldvalue">
				<input type="text" style="width:400px;" name="ldap.domain" value="<%=props.get("ldap.domain")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2430014")%></td>
			<td class="fieldvalue">
				<input type="text" style="width:400px;" name="ldap.searchFilter" value="<%=props.get("ldap.searchFilter")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2440016")%></td>
			<td class="fieldvalue">
				<input type="text" style="width:400px;" name="user.objectclass" value="<%=props.get("user.objectclass")%>">
			</td>
		</tr>
		<tr id="userAccountControl">
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2440018")%></td>
			<td class="fieldvalue">
				<input type="text" style="width:400px;" name="user.userAccountControl" value="<%=props.get("user.userAccountControl")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"></td>
			<td class="fieldvalue">
				<button type="button" onclick="javascript:testConnect();"><%=labelService.getLabelName("4028835c395798cb01395798d245001a")%></button>
				<div id="messageDiv" style="padding: 5px;font-weight: bold;"></div>
			</td>
		</tr>
	</table>
</fieldset>
<fieldset style="margin: 10px;">
	<legend style="font-weight:bold;color:blue;"><%=labelService.getLabelName("4028835c395798cb01395798d245001c")%></legend>
	<table>
		<colgroup>
			<col width="130px"></col>
			<col width="*"></col>
		</colgroup>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d245001e")%></td>
			<td class="fieldvalue">
				<input type="text" name="attribute.accountName" value="<%=props.get("attribute.accountName")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2460020")%></td>
			<td class="fieldvalue">
				<input type="text" name="attribute.passWord" value="<%=props.get("attribute.passWord")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2460022")%>(objno)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.no" value="<%=props.get("attribute.no")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2460024")%>(email)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.mail" value="<%=props.get("attribute.mail")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2460026")%>(tel1)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.telephone" value="<%=props.get("attribute.telephone")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2470028")%>(tel2)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.mobile" value="<%=props.get("attribute.mobile")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d247002a")%>(exttextfield17)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.office" value="<%=props.get("attribute.office")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d247002c")%>(objname)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.name" value="<%=props.get("attribute.name")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d247002e")%></td>
			<td class="fieldvalue">
				<input type="text" name="attribute.company" value="<%=props.get("attribute.company")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2480030")%></td>
			<td class="fieldvalue">
				<input type="text" name="attribute.firstName" value="<%=props.get("attribute.firstName")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2480032")%></td>
			<td class="fieldvalue">
				<input type="text" name="attribute.lastName" value="<%=props.get("attribute.lastName")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2480034")%>(orgid对应中文)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.orgunit" value="<%=props.get("attribute.orgunit")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2490036")%>(mainstation对应中文)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.station" value="<%=props.get("attribute.station")%>">
			</td>
		</tr>
		<tr>
			<td class="fieldname"><%=labelService.getLabelName("4028835c395798cb01395798d2490038")%>(hrstatus对应中文)</td>
			<td class="fieldvalue">
				<input type="text" name="attribute.description" value="<%=props.get("attribute.description")%>">
			</td>
		</tr>
	</table>
</fieldset>
</form>	
<script type="text/javascript">
function changePort(box){
	if(box.checked){
		document.getElementById("ldap.port").value="636";
		document.getElementById("keystorerow").style.display="";
		document.getElementById("keypaswdrow").style.display="";
	}else{
		document.getElementById("ldap.port").value="389";
		document.getElementById("keystorerow").style.display="none";
		document.getElementById("keypaswdrow").style.display="none";
	}
}
function changeType(select){
	var value = select.value;
	if(value=='com.eweaver.ldap.connector.MicrosoftADConnector'){
		document.getElementById("userAccountControl").style.display="";
	}else{
		document.getElementById("userAccountControl").style.display="none";
	}
}
function testConnect(){
	var ssl=$("input[name=ldap.ssl]").attr("checked");
	var myMask = new Ext.LoadMask(Ext.getBody(), {
	    msg: '正在处理，请稍后...',
	    removeMask: true //完成后移除
	});
	myMask.show();
	Ext.Ajax.request({
		url:"/ServiceAction/com.eweaver.ldap.action.LdapAction?action=test",
		method:"POST",
		params:{
			connector:Ext.get("ldap.connector").dom.value,
			host:Ext.get("ldap.host").dom.value,
			port:Ext.get("ldap.port").dom.value,
			ssl:ssl,
			keystore:Ext.get("ldap.keystore").dom.value,
			keypaswd:Ext.get("ldap.keypaswd").dom.value,
			adminName:Ext.get("ldap.adminName").dom.value,
			adminPaswd:Ext.get("ldap.adminPaswd").dom.value
		},
		success: function (result,request) {
			var message = result.responseText;
			var div = document.getElementById("messageDiv");
			if(message=='OK'){
				div.style.color='green';
				div.innerText="<%=labelService.getLabelName("4028835c395798cb01395798d24b0048")%>";
			}else{
				div.style.color='red';
				div.innerText="<%=labelService.getLabelName("4028835c395798cb01395798d24b0046")%>"+message;
			}
			myMask.hide();
		},
		failure: function (result,request) {alert(result.responseText);myMask.hide();}
	});
}

function onSubmit(){
	var ssl=$("input[name=ldap.ssl]").attr("checked");
	var myMask = new Ext.LoadMask(Ext.getBody(), {
	    msg: '正在处理，请稍后...',
	    removeMask: true //完成后移除
	});
	myMask.show();
	Ext.Ajax.request({
		url:"/ServiceAction/com.eweaver.ldap.action.LdapAction?action=save",
		method:"POST",
		params:{
			connector:Ext.get("ldap.connector").dom.value,
			host:Ext.get("ldap.host").dom.value,
			port:Ext.get("ldap.port").dom.value,
			ssl:ssl,
			keystore:Ext.get("ldap.keystore").dom.value,
			keypaswd:Ext.get("ldap.keypaswd").dom.value,
			adminName:Ext.get("ldap.adminName").dom.value,
			adminPaswd:Ext.get("ldap.adminPaswd").dom.value,
			baseDN:Ext.get("ldap.baseDN").dom.value,
			domain:Ext.get("ldap.domain").dom.value,
			searchFilter:Ext.get("ldap.searchFilter").dom.value,
			objectclass:Ext.get("user.objectclass").dom.value,
			userAccountControl:Ext.get("user.userAccountControl").dom.value,
			accountName:Ext.get("attribute.accountName").dom.value,
			passWord:Ext.get("attribute.passWord").dom.value,
			mail:Ext.get("attribute.mail").dom.value,
			telephone:Ext.get("attribute.telephone").dom.value,
			mobile:Ext.get("attribute.mobile").dom.value,
			office:Ext.get("attribute.office").dom.value,
			name:Ext.get("attribute.name").dom.value,
			company:Ext.get("attribute.company").dom.value,
			firstName:Ext.get("attribute.firstName").dom.value,
			lastName:Ext.get("attribute.lastName").dom.value,
			orgunit:Ext.get("attribute.orgunit").dom.value,
			station:Ext.get("attribute.station").dom.value,
			description:Ext.get("attribute.description").dom.value,
			no:Ext.get("attribute.no").dom.value
		},
		success: function (result,request) {
			alert(result.responseText);
			myMask.hide();
		},
		failure: function (result,request) {alert(result.responseText);myMask.hide();}
	});
}
</script>
</body>
</html>
