<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPage"%>
<%
response.setHeader("cache-control", "no-cache"); 
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String workflowid=StringHelper.null2String(request.getParameter("workflowid"));
String url=request.getContextPath()+"/mobile/plugin/loadWfGraph.jsp?workflowid="+workflowid+"&requestid="+requestid;

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<script type="text/javascript" src="/js/main.js"></script>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/js/asyncbox/AsyncBox.v1.4.js"></script>
<link rel="stylesheet" href="/mobile/plugin/js/asyncbox/skins/ZCMS/asyncbox.css">
<script type="text/javascript">
var mxBasePath = '../src/';
function showOperators(nodeid){
			asyncbox.open({			    
      			url : '/mobile/plugin/1/nodeoperatorshow.jsp?requestid=<%=requestid%>&nodeid='+nodeid,
      			btnsbar : $.btn.OK,
      			title:"查看操作者"
  			});

		
            //asyncbox.open(,'查看操作者');
            //asyncbox.alert('暂不支持查看节点操作者','提示');
        }
function showRules(nodeid){
    openWin('/base/security/viewrule.jsp?objtable=requestbase&istype=1&objid='+nodeid);
}
function hideOperators(){
	var operatorsDiv = document.getElementById('operatorsDiv');
	var children = operatorsDiv.childNodes;
	for(var i=0;i<children.length;i++){
		node = children[i];
		if(!node.show){
			node.style.display='none';
		}
	}
}
</script>
<script type="text/javascript" src="../src/js/mxClient.js"></script>
<script type="text/javascript" src="js/GraphViewer.js"></script>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="css/graphviewer.css" />
<style type="text/css">
.nodeOperator{
	position:absolute;
	padding:8px;
	border: solid 1px #909090;
	background-color: #ffffe1;
}
.nodeOperator ul{
	list-style: none;
	padding: 0 0 2 0;
	margin: 0;
}
.nodeOperator ul a{
	padding: 0 4 0 0;
}
</style>
</head>
<body onload="loadGraph('<%=url%>');" onclick="hideOperators();" style="overflow: auto;">
<div id="header" style="border: solid 1px #909090;width: 100%;margin: 1px;">
	<div style="margin:0 20 0 10;padding: 2px;float:left;height: 20px;">
		<img align="middle" style="cursor: hand;" src="/wfdesigner/viewers/images/print.gif" title="打印" onclick="javascript:mxUtils.print(h);">
		<img align="middle" style="cursor: hand;" src="/wfdesigner/viewers/images/zoomactual.gif" title="实际大小" onclick="javascript:h.zoomActual();">
		<img align="middle" style="cursor: hand;" src="/wfdesigner/viewers/images/zoomin.gif" title="放大" onclick="javascript:h.zoomIn();">
		<img align="middle" style="cursor: hand;" src="/wfdesigner/viewers/images/zoomout.gif" title="缩小" onclick="javascript:h.zoomOut();">
	</div>
	<div style="float:left; padding: 5px;color: #666;height: 20px;">
		<span>图标含义：</span>
		<span><IMG align="absMiddle" src="/images/base/user_blue.gif"> 已查看者</span>
		<span style="padding: 0 0 0 5;"><IMG align="absMiddle" src="/images/base/user_red.gif"> 未操作者</span>
		<span style="padding: 0 0 0 5;"><IMG align="absMiddle" src="/images/base/user_green.gif"> 已操作者</span>
	</div>
</div>
<div id="graphDiv"></div>
<div id="operatorsDiv"></div>
</body>
</html>