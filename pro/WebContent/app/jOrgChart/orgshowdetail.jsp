<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.app.jorgchart.jorgchart"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>组织结构图</title>
<link rel="stylesheet" href="/app/jOrgChart/css/bootstrap.min.css"/>
<link rel="stylesheet" href="/app/jOrgChart/css/jquery.jOrgChart.css"/>
<link rel="stylesheet" href="/app/jOrgChart/css/custom.css"/>
<link rel="stylesheet" href="/app/jOrgChart/css/prettify.css"/>

<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/app/jOrgChart/js/prettify.js"></script>
<script type="text/javascript" src="/app/jOrgChart/js/jquery.min.js"></script>
<script type="text/javascript" src="/app/jOrgChart/js/jquery-ui.min.js"></script>   
<script type="text/javascript" src="/app/jOrgChart/js/jquery.jOrgChart.js"></script>

<script>
jQuery(document).ready(function() {
        $("#org").jOrgChart({
            chartElement : '#chart',
            dragAndDrop  : false
        });
    });
</script>
</head>
<body onload="prettyPrint();">
	<div id="cinfo">
		<ul>
			<li id="qb">缺编：<span></span></li>
			<li id="cb">超编：<span></span></li>
			<li id="zc">正常：<span></span></li>
		</ul>
	</div>
	<div id="details"></div>
    <ul id="org" style="display:none">
    <% 
    jorgchart jch = new jorgchart();
    StringBuffer buf = jch.getBuf();
    out.println(buf.toString());
    %>
   </ul>            
    
    <div id="chart" class="orgChart"></div>
    
    <script>	    
		function mouseOver(id){				
			var orgid = id;
			Ext.Ajax.request({        
		        url: '/app/jOrgChart/detailJsonAction.jsp',              
		        params:{orgid:orgid},               
		        success: function(res) {               
		        	jsonResult = eval('('+res.responseText+')');
					if (jsonResult) {	
						document.getElementById('details').innerHTML = '<span>岗位数量：'+jsonResult.gws+'</br>定编：'+jsonResult.db+'</br>在编：'+jsonResult.zb+'</br>缺编：'+jsonResult.qb+'</span>';
					}
		        }               
		     });
			document.getElementById("details").style.left = event.x + document.body.scrollLeft-30;
            document.getElementById("details").style.top = event.y + document.body.scrollTop+10;
            document.getElementById("details").style.display = "block";
		}
		function mouseOut(){
			document.getElementById("details").style.display="none";
		}
		
    </script>
</body>
</html>