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

<script type="text/javascript" src="/app/jOrgChart/js/prettify.js"></script>
<script type="text/javascript" src="/app/jOrgChart/js/jquery.min.js"></script>
<script type="text/javascript" src="/app/jOrgChart/js/jquery-ui.min.js"></script>   
<script type="text/javascript" src="/app/jOrgChart/js/jquery.jOrgChart.js"></script>
<script>
jQuery(document).ready(function() {
        $("#org").jOrgChart({
            chartElement : '#chart',
            dragAndDrop  : true
        });
    });
</script>
</head>
<body onload="prettyPrint();">
    <ul id="org" style="display:none">
    <% 
    jorgchart jch = new jorgchart();
    jch.setBuf();
    StringBuffer buf = jch.getBuf();
    out.println(buf.toString());
    %>
   </ul>            
    
    <div id="chart" class="orgChart"></div>
</body>
</html>