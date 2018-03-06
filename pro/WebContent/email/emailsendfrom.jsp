<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.service.EmailtypeService" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ page import="com.eweaver.email.service.EmailsetinfoService" %>
<%@ page import="com.eweaver.email.service.SendemailService" %>
<%@ page import="com.eweaver.email.model.Sendemail" %>
<%@ page import="com.eweaver.email.model.Getemails" %>
<%@ page import="com.eweaver.email.service.GetemailsService" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
   /* pagemenustr += "addBtn(tb,'转发','S','email_transfer',function(){transmit()});";
    pagemenustr += "addBtn(tb,'返回','B','arrow_redo',function(){onReturn()});";*/
    SendemailService sendemailService = (SendemailService) BaseContext.getBean("sendemailService");
    EmailsetinfoService emailsetinfoService = (EmailsetinfoService) BaseContext.getBean("emailsetinfoService");
    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
   String sendemailid=StringHelper.null2String(request.getParameter("id"));
     Sendemail sendemail=new Sendemail();
    if(!StringHelper.isEmpty(sendemailid)){
         sendemail=sendemailService.getSendemail(sendemailid);
    }

%>
<head>
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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
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
<body >
<div id="pagemenubar" style="z-index:100;"></div>
	<form id="eweaverForm" name="EweaverForm">
        <table>
            <colgroup>
                <col width="20%">
                <col width="">
            </colgroup>
            <input type="hidden" name="id" id="id"  value="<%=sendemailid%>" />
            <tr>
             <td class="FieldName" nowrap >
                     <b><%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")%>：</b><!-- 日期 -->
                </td>
                <td class="FieldValue">
                 <%=sendemail.getDatatime()%>
                </td>   
            </tr>
            <tr>
                <td class="FieldName" nowrap >
                   <b>
                       <%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80035")%>：<!-- 账户 -->
                   </b>
                </td>
                <td class="FieldValue">
                  <%
                  String accountname=emailsetinfoService.getEmailsetinfo(sendemail.getSendfrom()).getObjname();
                  %>
                    <%=accountname%>
                </td>
            </tr>
          <tr>
                <td class="FieldName" nowrap>
                  <b>收件人：</b>
                </td>
                <td class="FieldValue">
              <%
                    String sendtospan=sendemail.getSendto();
                       List sendtolist=StringHelper.string2ArrayList(sendtospan,",");
                       String sendtospanstr="";
                       for(int i=0;i<sendtolist.size();i++){
                           String humresid=(String)sendtolist.get(i);
                       Humres humres= humresService.getHumresById(humresid);
                           if(i==0){
                              sendtospanstr=humres.getObjname();
                           }else{
                           sendtospanstr+=","+humres.getObjname();
                           }
                       }
                 
                   %>
                      <!--%=sendtospanstr%-->
                </td>
            </tr>
      <tr>
                <td class="FieldName" nowrap>
                   <b> <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71c27e80004")%>:</b><!-- 主题 -->
                </td>
                <td class="FieldValue">
                   <%=sendemail.getSubject()%>
                </td>
            </tr>

                <td class="FieldName" nowrap>
                  <b><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71d7ade0005")%>：</b><!-- 内容 -->
                </td>

                   <td class="FieldValue"  id="texta1">
                    <%=sendemail.getContent()%>
                   </td>
            </tr>


        </table>
        </form>
<script type="text/javascript">
    function onReturn(){
        location.href='<%=request.getContextPath()%>/email/emailsendfromlist.jsp';
    }
    function transmit(){
        location.href='<%=request.getContextPath()%>/email/sendemail.jsp?id=<%=sendemailid%>&transmit=1'
    }
</script>
    </body>
</html>