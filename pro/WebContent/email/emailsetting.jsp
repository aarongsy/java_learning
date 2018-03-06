<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.service.EmailtypeService" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ page import="com.eweaver.email.service.EserverinfoService" %>
<%@ page import="com.eweaver.email.model.Eserverinfo" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onSubmit()});";//确定
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";//返回
        BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    EserverinfoService eserverinfoService = (EserverinfoService) BaseContext.getBean("eserverinfoService");
    String sql="from Eserverinfo where isdelete=0";
    List list=eserverinfoService.getEserverinfos(sql);
%>
<head>

    <style type="text/css">
        .x-toolbar table {width:0}
        #pagemenubar table {width:0}
          .x-panel-btns-ct {
            padding: 0px;
        }
        .x-panel-btns-ct table {width:0}

       hr{ height:2px;border:none;border-top:1px solid gray;}
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
        <h3><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772e24f50009")%><!-- 基本信息 --></h3>
        <hr >
        <table>
                  <colgroup>
                      <col width="20%">
                      <col width="">
                  </colgroup>
                  <input type="hidden" name="id" id="id"  value="" />
                  <tr>
                      <td class="FieldName" nowrap >
                           <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c000b")%><!-- 账户名称 -->
                      </td>
                      <td class="FieldValue">
                          <input type="text" name="objname" id="objname" style="width:90%;"  onChange="checkInput('objname','objnamespan')" onkeypress="checkQuotes_KeyPress()">
                            <span id="objnamespan" name="objnamespan"/>
						<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
						</span>
                      </td>
                  </tr>

            <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c000c")%><!-- 邮件地址 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="text" name="emailaddress" style="width:90%;"   id="emailaddress" value=""  onChange="checkInput('emailaddress','emailaddressspan')" onkeypress="checkQuotes_KeyPress()"/>
                          <span id="emailaddressspan">
                              <img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
                          </span>
                      </td>
                  </tr>

          <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bccd7f1bd0042")%><!-- 密码 -->
                      </td>
                      <td class="FieldValue">
                          <input  type="password" name="emailpass" style="width:90%;"   id="emailpass" value=""  onChange="checkInput('emailpass','emailpassspan')" onkeypress="checkQuotes_KeyPress()"/>
                          <span id="emailpassspan">
                              <img src=<%=request.getContextPath()%>/images/base/checkinput.gif>
                          </span>
                      </td>
                  </tr>
             <tr>
                      <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c000d")%><!-- 选择服务器 -->
                      </td>
                      <td class="FieldValue">
                          <select id="serverid" name="serverid">
                             <%
                             for(int i=0;i<list.size();i++){
                                 Eserverinfo eserverinfo=(Eserverinfo)list.get(i);

                             %>
                              <option value="<%=eserverinfo.getId()%>"><%=StringHelper.null2String(eserverinfo.getObjname())%></option>
                              <%}%>
                          </select>

                      </td>
                  </tr>
              </table>
	</form>
</body>
<script type="text/javascript">
   function onSubmit(){
       var id=document.getElementById('id').value;
       var objname=document.getElementById('objname').value;
       var emailaddress=document.getElementById('emailaddress').value;
       var emailpass=document.getElementById('emailpass').value;
       var serverid=document.getElementById('serverid').value;
       if(objname==''||emailaddress==''||emailpass==''){
           pop('<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c000a")%>','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053")%>',null,'cross');//请填写必填项!//错误
           return
       }
       if(serverid==""){
           pop('<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c000e")%>','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053")%>',null,'cross');//没有可用的邮件服务器,请与管理员联系.//错误
           return
       }
       Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=emailsettingsave&from=esetinfo',
        params:{id:id,objname:objname,emailaddress:emailaddress,emailpass:emailpass,serverid:serverid},
        success: function(res) {
          if(parent.emailTree)parent.emailTree.topToolbar.items.item('getmail').menu.addMenuItem({id:res.responseText,text:objname,icon : contextPath+'/images/silk/email.gif',handler:parent.onItemCheck})
          location.href="<%=request.getContextPath()%>/email/emailsettinglist.jsp";
        }

       });


   }
    function onReturn(){
        var url='<%=request.getContextPath()%>/email/emailsettinglist.jsp';
        window.location=url;
    }
</script>
</html>