<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.base.selectitem.service.*" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Properties" %>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr =  "addBtn(tb,'加密','E','accept',function(){encrypt()});";
    pagemenustr +=  "addBtn(tb,'解密','D','accept',function(){decrypt()});";
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");


%>
<html>
<head>
    <style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
 </style>

 <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
  <script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js" ></script>
   <script type="text/javascript">
     Ext.onReady(function() {
         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
     });
 </script>
</head>
<div id="pagemenubar"> </div>
<body>
<form action="" name="EweaverForm" method="post">
    <table>
          <colgroup>
                <col width="30%">
                <col width="">
            </colgroup>
        <tr>
            <td class="FieldName" nowrap >加密字段所在的表名</td>
            <td class="FieldValue">
                <input name="formname" maxlength="60" />
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap >加密/解密字段（多个以“,”隔开）</td>
            <td class="FieldValue">
                <input name="fieldnames" maxlength="400" size="100"/>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap >where条件</td>
            <td class="FieldValue">
                <textarea rows="5" cols="100" name="sqlwhere">where 1=1</textarea>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    function encrypt(){
    	EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.encryption.servlet.EncryptAction?action=encrypt";
    	document.EweaverForm.submit();
    	
    }
    
    function decrypt(){
    	EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.encryption.servlet.EncryptAction?action=decrypt";
    	document.EweaverForm.submit();
    }
</script>
</body>
</html>