<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.service.EmailtypeService" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ page import="com.eweaver.email.model.Eserverinfo" %>
<%@ page import="com.eweaver.email.service.EserverinfoService" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onSubmit()});";//确定
      pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});" ;//返回


%>
<head>

    <style type="text/css">
       hr{ height:2px;border:none;border-top:1px solid gray;}
    </style>
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
<body>

<div id="pagemenubar" style="z-index:100;"></div>
<form id="eweaverForm" name="EweaverForm">
        <h3><%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0003")%><!-- 服务器信息 --></h3>
        <hr >
         <table>
                  <colgroup>
                      <col width="20%">
                      <col width="">
                  </colgroup>
              <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0004")%><!-- 设置名 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="text" name="objname" style="width:90%;"   id="objname" value="" onChange="checkInput('objname','servernamespan')" onkeypress="checkQuotes_KeyPress()"/>
                          <span id="objnamespan">
                              <img src=<%=request.getContextPath()%>/images/base/checkinput.gif>

                          </span>
                      </td>
                  </tr>
                  <tr>
                      <td class="FieldName" nowrap >
                        <select id="servertype" name="servertype" onchange="Changeport(this.options[this.options.selectedIndex].value)">

                            <option value="0" >POP3</option>
                            <option value="1" >IMAP</option>
                        </select>
                      </td>
                      <td class="FieldValue">
                          <input type="text" name="servername" id="servername" value="" style="width:90%;" onChange="checkInput('servername','servernamespan')" onkeypress="checkQuotes_KeyPress()"/>
                          <span id="servernamespan">
                              <img src=<%=request.getContextPath()%>/images/base/checkinput.gif>

                          </span>
                           <span >
                           <input type="checkbox" id="gssl" name="gssl" value="0"  onclick="GCssl(this)" /> SSL
                          </span>
                      </td>
                  </tr>
                <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0005")%><!-- 收信端口号 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="text" name="gport" style="width:90%;"   id="gport" value="110"/>
                      </td>
                  </tr>

            <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0006")%><!-- SMTP服务器 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="text" name="smtpname" style="width:90%;"   id="smtpname" value="" onChange="checkInput('smtpname','smtpnamespan')" onkeypress="checkQuotes_KeyPress()"/>
                          <span id="smtpnamespan">
                              <img src=<%=request.getContextPath()%>/images/base/checkinput.gif>

                          </span>
                          <span >
                           <input type="checkbox" id="sssl" name="sssl" value="0" onclick="SCssl(this)"/> SSL
                          </span>
                      </td>
                  </tr>
             <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0007")%><!-- 发信端口号 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="text" name="sport" style="width:90%;"   id="sport" value="25"/>
                      </td>
                  </tr>

          <tr style="display:none">
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0008")%><!-- 是否需要发件认证 -->
                      </td>
                      <td class="FieldValue">
                          <input type="checkbox" id="isattestation" name="isattestation" value="1"  onclick="isstation(this)"/>
                      </td>
                  </tr>
              <tr style="display:none">
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0009")%><!-- 是否保留服务器上的邮件 -->
                      </td>
                      <td class="FieldValue">
                          <input type="checkbox" id="issave" name="issave" value="1"/>
                      </td>
                  </tr>
              </table>
	</form>
</body>
<script type="text/javascript">
   function onSubmit(){
       var servertype=document.getElementById('servertype').value;
       var servername=document.getElementById('servername').value;
       var isattestation=document.getElementById('isattestation').value;
       var issave=document.getElementById('issave').value;
       var smtpname=document.getElementById('smtpname').value;
       var gport=document.getElementById('gport').value;
       var gssl=document.getElementById('gssl').value;
       var sport=document.getElementById('sport').value;
       var sssl=document.getElementById('sssl').value;
       var objname=document.getElementById('objname').value;
       if(objname==''||servername==''||smtpname==''||gport==''||sport==''){
           pop('<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c000a")%>','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053")%>',null,'cross');//请填写必填项!//错误
           return;
       }
       Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=emailsettingsave&from=eserverinfo',
        params:{objnames:objname,servertype:servertype,servername:servername,isattestation:isattestation,issave:issave,smtpname:smtpname,gport:gport,gssl:gssl,sport:sport,sssl:sssl},
        success: function() {
            var url='<%=request.getContextPath()%>/email/eserversettinglist.jsp';
        window.location=url;
        }

       });


   }
    function isstation(obj){
        if(obj.checked){
            document.getElementById('isattestation').value=1;

        }else{
            document.getElementById('isattestation').value=0;

        }
    }
    function issavecheck(obj){
       if(obj.checked){
           document.getElementById('issave').value=1;

       }else{
           document.getElementById('issave').value=0;

       }
    }
    function onReturn(){
        var url='<%=request.getContextPath()%>/email/eserversettinglist.jsp';
        window.location=url;
    }
    function Changeport(value){
           var gssl=  document.getElementById("gssl").value;
       if(value==0&&gssl==1){
          document.getElementById("gport").value=995;
       }else if(value==1&&gssl==1){
           document.getElementById("gport").value=993;
       }else if(value==0&&gssl==0){
          document.getElementById("gport").value=110;
       }else {
        document.getElementById("gport").value=143;     
       }
    }
    function GCssl(obj){
        var servertype=document.getElementById("servertype").value;
       if(obj.checked&&servertype==0){
            document.getElementById("gssl").value=1
          document.getElementById("gport").value=995;
       }else if(obj.checked&&servertype==1){
            document.getElementById("gssl").value=1
           document.getElementById("gport").value=993;
       }else if(servertype==0){
            document.getElementById("gssl").value=0
          document.getElementById("gport").value=110;
       }else{
            document.getElementById("gssl").value=0
            document.getElementById("gport").value=143;
       }
    }
    function SCssl(obj){
        if(obj.checked){
            document.getElementById('sssl').value=1;
            document.getElementById("sport").value=465;
        }else{
             document.getElementById("sport").value=25;
            document.getElementById('sssl').value=0;
        }
        
    }


</script>
</html>