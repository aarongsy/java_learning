<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<html>
  <head>
   <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>
      <style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
      .x-panel-btns-ct {
        padding: 0px;
    }
    .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
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
<script language="javascript">
function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){

           //alert(document.EweaverForm.action);
           document.EweaverForm.submit();
   	}
}
   function onReturn(){
        document.location.href="<%=request.getContextPath()%>/interfaces/outter/outtersyslist.jsp";

    }
</script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=create" name="EweaverForm" method="post">
<table>
    <colgroup>
        <col width="50%">
        <col width="50%">
    </colgroup>
    <tr>
        <td valign=top>
            <table class=noborder>
                <colgroup>
                    <col width="20%">
                    <col width="80%">
                </colgroup>
                 <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790012")%><!-- 标识 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="sysid" value="" onblur="validate(this)"/>
                        <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
                </tr>
                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%><!-- 名称 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="objname" value=""/>
                        <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
                </tr>

                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000e")%><!-- 内网地址 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="inneradd" value=""/>
                        <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
                </tr>
                <tr>
                    <td class="FieldName" nowrap>
                       <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7378000f")%><!-- 外网地址 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="outteradd" value=""/>
                        <img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
                </tr>

                 <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790013")%><!-- 账号登入方式 -->
                    </td>
                    <td class="FieldValue">
                        <select name="usernametype" id="usernametype" onchange="usernamechange(this)">
                            <option value="1"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790014")%></option><!-- 使用eweaver账号 -->
                            <option value="2"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790015")%></option><!-- 用户录入 -->
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780010")%><!-- 账号参数名 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="username" value="j_username"/>
                    </td>
                </tr>

                <tr>
                    <td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790016")%><!-- 密码登入方式 -->
                    </td>
                    <td class="FieldValue">
                        <select name="passtype" id="passtype" onchange="passtypechange(this)">
                            <option value="1"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790014")%><!-- 使用eweaver账号 --></option>
                            <option value="2"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790015")%><!-- 用户录入 --></option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73780011")%><!-- 密码参数名 -->
                    </td>
                    <td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="pass" value="j_password"/>
                    </td>
                </tr>
          
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
                    </td>
                    <td class="FieldValue">
                        <TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="description"></TEXTAREA>

                    </td>
                </tr>
            </table>


            <br>

        </td>
    </tr>
</table>
    </form>
<script type="text/javascript">
  function usernamechange(obj){
      var username=document.all('username');
      if(obj.value==1){
          username.value='j_username';
      }else{
       username.value='';
      }

  }
    function passtypechange(obj){
        var pass=document.all('pass');
        if(obj.value==1){
            pass.value='j_password';
        }else{
            pass.value='';

        }
    }
   function validate(obj){
       Ext.Ajax.request({
                          url: ' <%= request.getContextPath()%>/ServiceAction/com.eweaver.interfaces.outter.servlet.OuttersysAction?action=validate',
                          params:{sysid:obj.value},
                          success: function(res) {
                              if(res.responseText =='ok'){
                                  pop('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790017")%>', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053")%>', null, 'cross');//标识已存在 请更换其他！//错误
                                  obj.value="";
                                  obj.focus();
                              }
                          }
                      });
   }
</script>
  </body>
</html>
