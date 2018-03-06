<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<% 
	HumresService humresService = (HumresService) BaseContext.getBean("humresService");
%> 
<html> 
<script type="text/javascript" src="/app/js/jquery.js"></script>
<body onload="RtxSessionLogin();"> 
   <OBJECT id="RTXAX" style="display:none" data="data:application/x-oleobject;base64,fajuXg4WLUqEJ7bDM/7aTQADAAAaAAAAGgAAAA==" classid="clsid:5EEEA87D-160E-4A2D-8427-B6C333FEDA4D"></OBJECT>
</body> 
</html> 
<script anguage="javascript"> 
var RTXCRoot = null;
var strSessionKey = null;
function doRefresh(){
	location.reload(true);
}
function initrtx(){
	var obj=document.getElementById("RTXAX");
	RTXCRoot = obj.GetObject("KernalRoot");
	strSessionKey=getstrSessionKey()
}
function RtxSessionLogin(){
    var severip = "<%=humresService.getRtxServer()%>";//'改为您自己的RTX服务器IP地址");
    var serverport = <%=humresService.getRtxPort()%>;
	if(RTXCRoot==null){
	    initrtx();
	}//end.if
	try{
		//var ret = RTXCRoot.LoginSessionKey(severip,serverport,'<%=BaseContext.getRemoteUser().getUsername()%>', strSessionKey);
		var objProp = RTXAX.GetObject("Property");
		objProp.value("RTXUsername") = "<%=BaseContext.getRemoteUser().getUsername()%>";
		objProp.value("LoginSessionKey") =strSessionKey;
		objProp.value("ServerAddress") = severip; //RTX Server IP地址
		objProp.value("ServerPort") = serverport;
		RTXAX.Call(2,objProp);
	}catch (e)
	{
		alert(e.name + ": " + e.message);
		if(e.message=='远程服务器不存在或不可用'){
			window.location.reload(true);
		}
	}
	window.close();
}
function getstrSessionKey() {	
	var url = '/ServiceAction/com.eweaver.external.RTXAction?action=getstrSessionKey';
	jQuery.ajaxSetup({async: false});
	var params = {};
	var strSessionKey = "";
	jQuery.post(url,params,function(data){
		strSessionKey = data;
	});
	return strSessionKey;
}
</script> 