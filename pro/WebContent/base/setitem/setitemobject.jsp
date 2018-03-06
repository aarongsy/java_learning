<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr =  "addBtn(tb,'确定','S','accept',function(){OnConfirm()});";
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    
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
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=object" name="EweaverForm" method="post">
    <table>
          <colgroup>
                <col width="40%">
                <col width="">
            </colgroup>
        <tr>
            <td class="FieldName" nowrap >对象权限重构模块(只有在些定义的模块在权限定义页面上才会出现权限重构按钮 ) </td>
            <td class="FieldValue">
                 <%
                 Setitem setitem1=setitemService.getSetitem("402881e20fa7d3a8010fa7efe8d80054");
                %>
                 <input type="text" name="402881e20fa7d3a8010fa7efe8d80054" id="402881e20fa7d3a8010fa7efe8d80054" style="width:90%;" value="<%=setitem1.getItemvalue()%>">
            </td>
        </tr>
          <tr>
            <td class="FieldName" nowrap>资源对象权限是否重构 </td>
            <td class="FieldValue">
                 <%
                       Setitem setitem2=setitemService.getSetitem("402881e20f9956a5010f997ee3e40087");
                        String selected2no="";
                          String selected2yes="";
                        if(setitem2.getItemvalue().equals("1")) {
                            selected2yes="selected";
                        } else{
                            selected2no="selected";
                        }
                    %>
              <select style="width:40%;" name="402881e20f9956a5010f997ee3e40087" id="402881e20f9956a5010f997ee3e40087">
                    <option value="1" <%=selected2yes%>>是</option>
                      <option value="0" <%=selected2no%>>否</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap>产品对象权限是否自动重构 </td>
            <td class="FieldValue">
                 <%
                       Setitem setitem3=setitemService.getSetitem("402881e20f9956a5010f9980303a008b");
                        String selected3no="";
                          String selected3yes="";
                        if(setitem3.getItemvalue().equals("1")) {
                            selected3yes="selected";
                        } else{
                            selected3no="selected";
                        }
                    %>
              <select style="width:40%;" name="402881e20f9956a5010f9980303a008b" id="402881e20f9956a5010f9980303a008b">
                    <option value="1" <%=selected3yes%>>是</option>
                      <option value="0" <%=selected3no%>>否</option>
                </select>
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap>项目对象权限是否自动重构 </td>
            <td class="FieldValue">
                 <%
                       Setitem setitem4=setitemService.getSetitem("402881e20f9956a5010f99809c62008d");
                        String selected4no="";
                          String selected4yes="";
                        if(setitem4.getItemvalue().equals("1")) {
                            selected4yes="selected";
                        } else{
                            selected4no="selected";
                        }
                    %>
                <select style="width:40%;" name="402881e20f9956a5010f99809c62008d" id="402881e20f9956a5010f99809c62008d">
                    <option value="1" <%=selected4yes%>>是</option>
                      <option value="0" <%=selected4no%>>否</option>
                </select>
            </td>
        </tr>
          <tr>
            <td class="FieldName" nowrap>文档对象权限是否自动重构  </td>
            <td class="FieldValue">
                   <%
                       Setitem setitem5=setitemService.getSetitem("402881e20f9956a5010f997e37970085");
                        String selected5no="";
                          String selected5yes="";
                        if(setitem5.getItemvalue().equals("1")) {
                            selected5yes="selected";
                        } else{
                            selected5no="selected";
                        }
                    %>
                <select style="width:40%;" name="402881e20f9956a5010f997e37970085" id="402881e20f9956a5010f997e37970085">
                    <option value="1" <%=selected5yes%>>是</option>
                      <option value="0" <%=selected5no%>>否</option>
                </select>
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap>客户对象权限是否自动重构 </td>
            <td class="FieldValue">
                 <%
                       Setitem setitem6=setitemService.getSetitem("402881e20f9956a5010f997fb4d10089");
                        String selected6no="";
                          String selected6yes="";
                        if(setitem6.getItemvalue().equals("1")) {
                            selected6yes="selected";
                        } else{
                            selected6no="selected";
                        }
                    %>
                <select style="width:40%;" id="402881e20f9956a5010f997fb4d10089" name="402881e20f9956a5010f997fb4d10089">
                    <option value="1" <%=selected6yes%>>是</option>
                      <option value="0" <%=selected6no%>>否</option>
                </select>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    function OnConfirm(){
        document.EweaverForm.submit();
    }
</script>
</body>
</html>