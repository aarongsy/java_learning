<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.file.Prop"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageIdConst" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>


<HTML>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <script type="text/javascript" language="javascript">
            jQuery(document).ready(function() {
                var bodyHeight = jQuery(document.body).height();
                //alert(<%=user.getUID() %>);
                $("#main").height(bodyHeight  - 100);
                //$("#iframewf").attr("src", "main.jsp?_fromURL=0");
            });
        </script>
    </head>

    <body style="overflow: hidden;">
        <div id="main" style="margin-left: -1px; margin-top: -1px;margin-bottom:10px;margin-right:-1px;border:solid 1px rgb(215, 215, 215);" cellpadding="0" cellspacing="0" width="98%" border="0">
            <iframe id="iframewf" src="" width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" frameborder="0"></iframe>
        </div>
        
        <div>main主页面;UserId:<%=user.getUID() %></div>
    </body>
</html>