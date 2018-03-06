<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.service.DocbaseService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ include file="/base/init.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%@ page import="java.net.URLEncoder"%>

<%
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
String docid = StringHelper.null2String(request.getParameter("id"));
String attachid = StringHelper.null2String(request.getParameter("attachid"));
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");

Attach attach = attachService.getAttach(attachid);

%>
<html>
<head>
<title><%=attach.getObjname()%></title>
<meta http-equiv="content-type" content="text/html; charset=gb2312">
<style type="text/css">

    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
       .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
      a { color:blue; cursor:pointer; }

</style>

</head>
<body >
<div>
	<img src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=attachid%>&download=1&nIndex=1" border=0>
</div>
</body>

</html>