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
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
    response.setHeader("cache-control", "no-cache");
        response.setHeader("pragma", "no-cache");
        response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

    /*pagemenustr += "addBtn(tb,'转发','S','email_transfer',function(){transmit()});";
    pagemenustr += "addBtn(tb,'返回','B','arrow_redo',function(){onReturn()});";*/
    GetemailsService getemailsService  = (GetemailsService) BaseContext.getBean("getemailsService");
    AttachService attachService  = (AttachService) BaseContext.getBean("attachService");
    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
    String getemailid=StringHelper.null2String(request.getParameter("id"));//收件箱的id
     Getemails getemails=new Getemails();
    if(!StringHelper.isEmpty(getemailid)) {
      getemails= getemailsService.getGetemails(getemailid) ;
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
            <input type="hidden" name="id" id="id"  value="<%=getemailid%>" />
            <tr>
             <td class="FieldName" nowrap >
                     <b><%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")%>：</b><!-- 日期 -->
                </td>
                <td class="FieldValue">
                 <%=getemails.getSentdate()%>
                </td>
            </tr>
            <tr>
                <td class="FieldName" nowrap >
                   <b>
                      <%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80034")%><!-- 发件人 -->
                   </b>
                </td>
                <td class="FieldValue">
                 <%=getemails.getSentfrom()%>
                </td>
            </tr>
          <tr>
                <td class="FieldName" nowrap>
                  <b><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")%>：</b><!-- 收件人 -->
                </td>
               <td class="FieldValue">
                   <%=getemails.getMailaddressto()%>
                </td>
            </tr>
      <tr>
                <td class="FieldName" nowrap>
                   <b> <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71c27e80004")%>:</b><!-- 主题 -->
                </td>
                <td class="FieldValue">
                   <%=getemails.getSubject()%>
                </td>
            </tr>
            <tr<%if(StringHelper.isEmpty(getemails.getMailaddresscc())){%> style="display:none" <%}%>>
                <td class="FieldName" nowrap>
                   <b><%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0001")%></b><!-- 抄送人 -->
                </td>
                <td class="FieldValue">
                     <%=getemails.getMailaddresscc()%>
                </td>
            </tr>
                  <tr<%if(StringHelper.isEmpty(getemails.getAttachid())){%> style="display:none" <%}%>>
                <td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%>:<!-- 附件 -->
                </td>
                <td class="FieldValue">
                   <%
                       String attachids=getemails.getAttachid();
                       ArrayList ids=StringHelper.string2ArrayList(attachids,",");
                       for(int i=0;i<ids.size();i++){
                       Attach attach = attachService.getAttach(ids.get(i).toString());
                      String attachname = StringHelper.null2String(attach.getObjname());
                           if(i==0){
                   %>
                      <a href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=attach.getId()%>&download=1"><%=attachname%></a>;
                    <%}else{%>
                    <br>
                       <a href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=attach.getId()%>&download=1"><%=attachname%></a>;
                    <%}}%>
                </td>
            </tr>
                <td class="FieldName" nowrap>
                  <b><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71d7ade0005")%>：</b><!-- 内容 -->
                </td>

                   <td   id="texta1">
                    <%=getemails.getContent()%>

                   </td>
            </tr>


        </table>
        </form>
<script type="text/javascript">
    function onReturn(){
        location.href='<%=request.getContextPath()%>/email/emailsendfromlist.jsp';
    }
    function transmit(){
        location.href='<%=request.getContextPath()%>/email/sendemail.jsp?id=<%=getemailid%>&transmit=1'
    }
</script>
    </body>
</html>