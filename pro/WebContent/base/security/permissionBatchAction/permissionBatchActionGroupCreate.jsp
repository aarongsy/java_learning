<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2009-10-26
  Time: 12:27:21
  To change this template use File | Settings | File Templates.
--%>
<html>
  <head><title>权限转移组</title>

   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <%
          String permissionBatchActionIds = StringHelper.trimToNull(request.getParameter("permissionBatchActionIds"));
      pagemenustr +="addBtn(tb,'提交','A','add',function(){createGroup()});";
      %>
   <script language="javascript">
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
  <body>
<div id="divSearch">
<div id="pagemenubar"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=createGroup" method="post">
    <input type="hidden" id="permissionBatchActionIds" name="permissionBatchActionIds" value="<%=permissionBatchActionIds%>"/>
  <table align="center">
      <tr><td>&nbsp;</td></tr>
      <tr align="center">
          <td>名称：&nbsp;&nbsp;&nbsp;<input type="text" id="objname" name="objname" style="width:340" value=""/></td>
      </tr>
      <tr align="center" width="300">
          <td>描叙：&nbsp;&nbsp;&nbsp;<textarea rows="5" cols="40" id="objdesc" name="objdesc"></textarea></td>
      </tr>
      <tr align="center">
          <td>排序：&nbsp;&nbsp;&nbsp;<input type="text" id="objorder" name="objorder" style="width:340" value=""/></td>
      </tr>
  </table>
</form>
</div>
  </body>
<script type="text/javascript">
    function createGroup(){
        document.forms[0].submit();

        if(top.frames[1] && typeof(top.frames[1].pop)=='function')
            top.frames[1].pop('权限转移组创建成功！');
        else
            alert('权限转移组创建成功！');

        var tabpanel=top.frames[1].contentPanel;
        tabpanel.remove(tabpanel.getActiveTab());
    }
</script>
</html>