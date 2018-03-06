<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ page import="com.eweaver.email.model.Sendemail" %>
<%@ page import="com.eweaver.email.model.Getemails" %>
<%@ page import="com.eweaver.email.service.*" %>
<%@ page import="com.eweaver.email.model.Relationset" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ include file="/base/init.jsp"%>
<html>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0049")+"','S','email_transfer',function(){sendemail()});";//发送
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883de35273f910135273f954c0018")+"','D','email_attach',function(){Save()});";//存草稿
   //pagemenustr += "addBtn(tb,'取消','C','cancel',function(){onCancel()});";
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    SendemailService sendemailService = (SendemailService) BaseContext.getBean("sendemailService");
    EmailsetinfoService emailsetinfoService = (EmailsetinfoService) BaseContext.getBean("emailsetinfoService");
    GetemailsService getemailsService = (GetemailsService) BaseContext.getBean("getemailsService");
    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
    RelationsetService relationsetService = (RelationsetService) BaseContext.getBean("relationsetService");
    RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
     String sql="select * from emailsetinfo where isdelete=0 and userid='"+eweaveruser.getId()+"'";
   List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);
   String id=StringHelper.null2String(request.getParameter("id"));
    String transmit=StringHelper.null2String(request.getParameter("transmit"));
    String perhumresid=StringHelper.null2String(request.getParameter("humresid"));
    Humres perhumres=humresService.getHumresById(perhumresid);
    String peremail=perhumres.getEmail();
     Sendemail sendemail=new Sendemail();
     Getemails getemails=new Getemails();
    if("2".equalsIgnoreCase(transmit)){ //表示从收件箱转发过来的
          if(!StringHelper.isEmpty(id)){
              getemails=getemailsService.getGetemails(id);
          }
    }else {
       if(!StringHelper.isEmpty(id)){
         sendemail=sendemailService.getSendemail(id);
    }
    }

    String sendtospan = sendemail.getSendto();
    List sendtolist = StringHelper.string2ArrayList(sendtospan, ",");
    String sendtospanstr = "";
    for (int i = 0; i < sendtolist.size(); i++) {
        String humresid = (String) sendtolist.get(i);
        Humres humres = humresService.getHumresById(humresid);
        if (i == 0) {
            sendtospanstr = humres.getObjname();
        } else {
            sendtospanstr += "," + humres.getObjname();
        }
    }
    String subvalue="";
    String sendtovalue="";
    String sendtospanvalue="";
    String sendtoothervalue="";
    StringBuffer contentvalue=new StringBuffer();
    if("1".equals(transmit)){
         subvalue="FW:"+StringHelper.null2String(sendemail.getSubject());
        if("0".equals(sendemail.getEmailformat())){
        contentvalue.append("---------- "+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0021")+" ----------");//转发邮件信息
         contentvalue.append("<br>");
        contentvalue.append(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")+": "+StringHelper.null2String(sendemail.getSendto()));//收件人
         contentvalue.append("<br>");
         contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0022")+"："+emailsetinfoService.getEmailsetinfo(sendemail.getSendfrom()).getObjname());//发件账户
          contentvalue.append("<br>");
        contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0023")+"："+sendemail.getDatatime());//发送日期
         contentvalue.append("<br>");
          contentvalue.append(labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71c27e80004")+"："+sendemail.getSubject());//主题
          contentvalue.append("<br>");
        contentvalue.append("<br>");
         contentvalue.append(""+sendemail.getContent());
        }else if("1".equals(sendemail.getEmailformat())){
             contentvalue.append("---------- "+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0021")+" ----------");//转发邮件信息
         contentvalue.append("\n");
        contentvalue.append(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")+": "+sendemail.getSendto());//收件人
            contentvalue.append("\n");
         contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0022")+"："+emailsetinfoService.getEmailsetinfo(sendemail.getSendfrom()).getObjname());//发件账户
            contentvalue.append("\n");
        contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0023")+"："+sendemail.getDatatime());//发送日期
            contentvalue.append("\n");
          contentvalue.append(labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71c27e80004")+"："+sendemail.getSubject());//主题
            contentvalue.append("\n");
            contentvalue.append("\n");
         contentvalue.append(""+sendemail.getContent());
        }
    }else if("2".equals(transmit)){
         subvalue="FW:"+StringHelper.null2String(getemails.getSubject());
         contentvalue.append("---------- "+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0021")+" ----------");//转发邮件信息
         contentvalue.append("<br>");
        contentvalue.append(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")+":"+sendtospanstr+" "+StringHelper.null2String(getemails.getMailaddressto()));//收件人
         contentvalue.append("<br>");
         contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0022")+"："+emailsetinfoService.getEmailsetinfo(getemails.getAccountid()).getObjname());//发件账户
          contentvalue.append("<br>");
        contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0023")+"："+getemails.getSentdate());//发送日期
         contentvalue.append("<br>");
          contentvalue.append(labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71c27e80004")+"："+getemails.getSubject());//主题
          contentvalue.append("<br>");
        contentvalue.append("<br>");
         contentvalue.append(""+getemails.getContent());
    }else {
        transmit="0";
     subvalue=StringHelper.null2String(sendemail.getSubject()) ;
        sendtovalue=StringHelper.null2String(sendemail.getSendto());
        sendtospanvalue=sendtospanstr;
        sendtoothervalue=StringHelper.null2String(sendemail.getSendto());
         contentvalue.append(StringHelper.null2String(sendemail.getContent())) ;
    }

    String sqlrelation = "from Relationset where isdelete=0";
    List listrelation = relationsetService.getRelationsets(sqlrelation);
    String refid1="";
    String refid2="";
    for(int i=0;i<listrelation.size();i++){
        Relationset relationset = (Relationset) listrelation.get(i);
        if (relationset.getObjtype().equals("0")) {
            refid1 = relationset.getBrowservalue();
        } else {
            refid2 = relationset.getBrowservalue();
        }

        
    }
    Refobj refobj1=new Refobj();
    Refobj refobj2=new Refobj();
    if(!StringHelper.isEmpty(refid1)){
        refobj1=refobjService.getRefobj(refid1);
    }
    if(!StringHelper.isEmpty(refid2)){
       refobj2=refobjService.getRefobj(refid2);
    }
%>
<head>

    <style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .dropdown .x-btn-left{background:url('');width:0;height:0}
   .dropdown .x-btn-center{background:url('')}
   .dropdown .x-btn-right{background:url('')}
    .dropdown .x-btn-center{text-align:left}
   .x-panel-btns-ct table {width:0}
     .t1 {
    COLOR: #cc0000; TEXT-DECORATION: underline
}
 .x-window-dlg .ext-mb-error {
background:transparent url('<%=request.getContextPath()%>/images/silk/right.gif') no-repeat scroll left top;
}
 </style>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript">
       var scriptcontent=0
       var dlg0;
     Ext.onReady(function() {

         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
    var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>',//人力资源
                 checked: false,
                iconCls:Ext.ux.iconMgr.getIcon('user'),
                checkHandler: onItemCheck
            },
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%>',//通讯录
                 checked: false,
                iconCls:Ext.ux.iconMgr.getIcon('page_portrait_shot'),
                checkHandler: onItemCheck
            }]
    });
          var menusecret = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>',//人力资源
                 checked: false,
                iconCls:Ext.ux.iconMgr.getIcon('user'),
                checkHandler: onItemChecksecret
            },
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%>s',//通讯录
                 checked: false,
                iconCls:Ext.ux.iconMgr.getIcon('page_portrait_shot'),
                checkHandler: onItemChecksecret
            }]
    });
          var menucopy = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>',//人力资源
                 checked: false,
                iconCls:Ext.ux.iconMgr.getIcon('user'),
                checkHandler: onItemCheckcopy
            },
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%>',//通讯录
                 checked: false,
                 iconCls:Ext.ux.iconMgr.getIcon('page_portrait_shot'),
                checkHandler: onItemCheckcopy
            }]
    });
         var tbmenu = new Ext.Button({
             text:'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")%>',//收件人
             menu : menu
         });
         tbmenu.render('menu');
         var tbmenu2 = new Ext.Button({
             text:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0024")%>',//密送
             menu : menusecret
         });
         tbmenu2.render('menusecretsend');

         var tbmenu3 = new Ext.Button({
             text:'<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0025")%>',//抄送
             menu : menucopy
         });
         tbmenu3.render('menucopysend');
         dlg0 = new Ext.Window({
               layout:'border',
               closeAction:'hide',
               plain: true,
               modal :true,
               width:200,
               height:200,
               buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0026")%>',//返回收件箱
                   handler  : function() {
                       location.href='<%=request.getContextPath()%>/email/emailsendtolist.jsp';

                   }
               },{
                   text     : '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0027")%>',//继续写信
                   handler  : function() {
                       location.href='<%=request.getContextPath()%>/email/sendemail.jsp';

                   }

               }],
               items:[{
                   id:'dlgpanel',
                   region:'center',
                    contentEl :'dive'
               }]
           });
           dlg0.render(Ext.getBody());
     });
        function onItemCheck(item, checked){
            if(item.text=="<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>") {//人力资源
	            <%if (!StringHelper.isEmpty(refobj1.getId())) {%>
	                getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=refobj1.getId()%>','sendto','toid','1','<%=refobj1.getId()%>');
	            <%} else {%>
	            	alert('<%=labelService.getLabelNameByKeyId("5421d6b9fdd7482485449c77819d6435")%>');
	            <%}%>
            } else if(item.text='<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%>') {//通讯录
            	<%if (!StringHelper.isEmpty(refobj2.getId())) {%>
                	getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=refobj2.getId()%>','sendto','toid','1','<%=refobj2.getId()%>');
                <%} else {%>
	            	alert('<%=labelService.getLabelNameByKeyId("5421d6b9fdd7482485449c77819d6435")%>');
	            <%}%>
            }
    }
       function onItemChecksecret(item, checked){
            if(item.text=="<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>") {//人力资源
	           	<%if (!StringHelper.isEmpty(refobj1.getId())) {%>
	                getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=refobj1.getId()%>','secretsend','bccid','1','<%=refobj2.getId()%>');
				<%} else {%>
	            	alert('<%=labelService.getLabelNameByKeyId("5421d6b9fdd7482485449c77819d6435")%>');
	            <%}%>
            } else if(item.text='<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%>') {//通讯录
            	<%if (!StringHelper.isEmpty(refobj2.getId())) {%>
                	getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=refobj2.getId()%>','secretsend','bccid','1','<%=refobj2.getId()%>');
                <%} else {%>
	            	alert('<%=labelService.getLabelNameByKeyId("5421d6b9fdd7482485449c77819d6435")%>');
	            <%}%>
       		}
    }
       function onItemCheckcopy(item, checked){
            if(item.text=="<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>") {//人力资源
            	<%if (!StringHelper.isEmpty(refobj1.getId())) {%>
                	getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=refobj1.getId()%>','copysend','ccid','1','<%=refobj2.getId()%>');
                <%} else {%>
	            	alert('<%=labelService.getLabelNameByKeyId("5421d6b9fdd7482485449c77819d6435")%>');
	            <%}%>
            } else if(item.text='<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd2a5efa0019")%>') {//通讯录
            	<%if (!StringHelper.isEmpty(refobj2.getId())) {%>
             		getBrowser('/base/refobj/baseobjbrowser.jsp?id=<%=refobj2.getId()%>','copysend','ccid','1','<%=refobj2.getId()%>');
             	<%} else {%>
	            	alert('<%=labelService.getLabelNameByKeyId("5421d6b9fdd7482485449c77819d6435")%>');
	            <%}%>
            }
    }
 </script>

</head>
<body <%if(!StringHelper.isEmpty(sendemail.getEmailformat())){%>onload="hideemailformat('<%=sendemail.getEmailformat()%>')"<%}%>>

<div id="pagemenubar" style="z-index:100;"></div>
	<form id="eweaverForm" name="EweaverForm">
        <table>


            <colgroup>
                <col width="20%">
                <col width="">
            </colgroup>
            <input type="hidden" name="id" id="id"  value="<%=id%>" />
            <tr>
                <td class="FieldName" nowrap >
                     &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80035")%><!-- 账户 -->
                </td>
                <td class="FieldValue">
                  <select id="sendfrom" name="sendfrom" style="width:40%">
                      <option></option>
                        <%
                           for(int i=0;i<list.size();i++){
                               String objname=StringHelper.null2String((String)((Map)list.get(i)).get("objname"));
                               String aid=StringHelper.null2String((String)((Map)list.get(i)).get("id"));
                               String selected="";
                               if("2".equals(transmit)){
                                   if(aid.equals(getemails.getAccountid())){
                                  selected = "selected";
                               }
                               }else{
                                  if(aid.equals(sendemail.getSendfrom())){
                                  selected = "selected";
                               }
                               }


                        %>
                      <option value="<%=aid%>" <%=selected%>><%=objname%></option>
                          <% } %>
                  </select>
                </td>
            </tr>
          <tr>
                <td class="FieldName" nowrap>
                    <div id="menu" class="dropdown" align="left"></div>
                     &nbsp;&nbsp;&nbsp;<a id="secretsenda" class="t1" href="#" onclick="secretsendclick()"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0024")%><!-- 密送 --></a>  <a id="copysenda" class="t1" href="#" onclick="copysendclick()"><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0025")%><!-- 抄送 --></a>
                </td>
                <td class="FieldValue">
                    <input  type="text" name="sendto" style="width:90%;"  id="sendto" value="<%if(!StringHelper.isEmpty(peremail)){%><%=peremail+","%><%}%>" />
                    <input  type="hidden" name="toid" style="width:90%;"  id="toid" value="" />

                </td>
            </tr>
          <tr style="display:none" id="secretsendtr">
                <td class="FieldName" nowrap >
                    <div id="menusecretsend" class="dropdown" align="left"></div>
                </td>
                <td class="FieldValue">
                    <input  type="text" name="secretsend" style="width:90%;"  id="secretsend" value="" />
                    <input  type="hidden" name="bccid" style="width:90%;"  id="bccid" value="" />
                </td>
            </tr>
          <tr style="display:none" id="copysendtr">
                <td class="FieldName" nowrap>
                    <div id="menucopysend" class="dropdown" align="left"></div>
                </td>
                <td class="FieldValue">
                    <input  type="text" name="copysend" style="width:90%;"  id="copysend" value="" />
                    <input  type="hidden" name="ccid" style="width:90%;"  id="ccid" value="" />
                </td>
            </tr>
      <tr>
                <td class="FieldName" nowrap>
                    &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71c27e80004")%><!-- 主题 -->
                </td>
                <td class="FieldValue">
                    <input  type="text" name="subject" style="width:90%;"   id="subject" value="<%=subvalue%>" />
                </td>
            </tr>



       <tr id="formattr" >
                <td class="FieldName" nowrap>
                    &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001b")%><!-- 邮件格式 -->
                </td>
                <td class="FieldValue">
                    <select id="emailformat" name="emailformat" style="width:40%" onchange="formatemail(this.options[this.options.selectedIndex].value)">
                        <%
                            String checked1="";
                            String checked2="";
                            if("2".equals(transmit)){

                            }else{
                                if ("0".equals(sendemail.getEmailformat())) {
                                    checked1 = "selected";
                                } else if ("1".equals(sendemail.getEmailformat())) {
                                    checked2 = "selected";
                                }
                            }

                        %>
                        <option value="0" <%=checked1%>><%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001c")%><!-- 超文本格式 --></option>
                        <option value="1" <%=checked2%> ><%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001d")%><!-- 纯文本格式 --></option>
                    </select>
                </td>
            </tr>
        <tr>
                <td class="FieldName" nowrap>

                </td>
                    <td class="FieldValue" id="texta0" >
                    <textarea class="InputStyle2" style="width:90%; height:315px" name="content" id="content"><%if("2".equals(transmit)){%><%=StringHelper.null2String(contentvalue.toString())%><%}else{if("0".equals(sendemail.getEmailformat())){%><%=StringHelper.null2String(contentvalue.toString())%><%}}%></textarea>
                    <script >
                            WeaverUtil.load(function(){
                            FCKEditorExt.initEditor('content',false);
                            FCKEditorExt.toolbarExpand(false);
                        });
                    </script>
                   </td>

                   <td class="FieldValue" style="display:none" id="texta1">
                    <textarea class="InputStyle2" style="width:90%; height:315px" name="content2" id="content2"><%if("2".equals(transmit)){%><%=StringHelper.null2String(contentvalue.toString())%><%}else{if("1".equals(sendemail.getEmailformat())){%><%=StringHelper.null2String(contentvalue.toString())%><%}}%></textarea>

                   </td>
            </tr>
       <tr>
                <td class="FieldName" nowrap>
                     &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%><!-- 附件 -->
                </td>
                <td class="FieldValue">
                    <input type="hidden" name="accessory" id="accessory" value=""><a href="#" class="addfile"><input type="file"
                                                                                                      class="addfile"
                                                                                                      name="accessoryfile"
                                                                                                      id="accessoryfile"></a>

                    <div id="divaccessory"
                         style="padding:5px;border:0px;border-style:solid;border-color:#0000ff;height:0px;"></div>
                    <script>
                        var multi_selector = new MultiSelector(document.getElementById('divaccessory'), 100, -1);
                        multi_selector.addElement(document.getElementById('accessoryfile'));
                    </script>
                </td>
            </tr>


        </table>
        </form>
<div id="dive">
    <table>
       <tr>
           <td><img src="<%=request.getContextPath()%>/images/right.gif" alt=""></td>
           <td><h1><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0028")%><!-- 邮件已发送成功！ --></h1></td>
       </tr>
    </table>
</div>
    </body>
<script type="text/javascript">
    function Save(){
          FCKEditorExt.updateContent();
        var id=document.getElementById('id').value;
        var sendfrom=document.getElementById('sendfrom').value;
        var sendto=document.getElementById('sendto').value;
        var subject=document.getElementById('subject').value;
        var content=document.getElementById('content').value;
        var secretsend=document.getElementById('secretsend').value;
        var copysend=document.getElementById('copysend').value;
        var content2=document.getElementById('content2').value;
        var emailformat=document.getElementById('emailformat').value;
          Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=save',
        params:{id:id,sendfrom:sendfrom,sendto:sendto,subject:subject,content:content,secretsend:secretsend,copysend:copysend,content2:content2,emailformat:emailformat},
        success: function() {
            pop( '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001e")%>');//保存成功！
        }
    });
        
    }
    function secretsendclick()
    {
        document.getElementById("secretsenda").style.display="none";

        document.getElementById("secretsendtr").style.display="block";

    }
    function copysendclick(){
        document.getElementById("copysenda").style.display="none";

        document.getElementById("copysendtr").style.display="block";

    }
    function formatemail(value){

    if(value==0){
        document.getElementById("texta0").style.display="block";
        document.getElementById("texta1").style.display="none";
         document.getElementById("content").value=FCKEditorExt.getHtml();
    }else{
          Ext.MessageBox.confirm('','<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001f")%>',function (btn,text){//转换为文本编辑会丢失格式 你确定要转换吗
              if (btn == 'yes') {
                 document.getElementById("content2").value=FCKEditorExt.getText();
              }else{
                document.getElementById("texta0").style.display="block";
                document.getElementById("texta1").style.display="none";
              }
          });
       document.getElementById("texta0").style.display="none";
        document.getElementById("texta1").style.display="block";
    }
    }
     function hideemailformat(value){
           document.getElementById("formattr").style.display="none";
         if(value==1){
            document.getElementById("texta0").style.display="none";
        document.getElementById("texta1").style.display="block";  
          }
    }
     function getBrowser(viewurl,inputname,idsin,isneed,refobjid){
         var idsins=document.getElementById(idsin).value;
    var id;
    try{
        id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
    document.getElementById(inputname).value +=id[1]+",";
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
      function sendemail(){
        FCKEditorExt.updateContent();
        var id=document.getElementById('id').value;
        var sendfrom=document.getElementById('sendfrom').value;
        var sendto=document.getElementById('sendto').value;
        var subject=document.getElementById('subject').value;
        var content=document.getElementById('content').value;
        var secretsend=document.getElementById('secretsend').value;
        var copysend=document.getElementById('copysend').value;
        var content2=document.getElementById('content2').value;
        var emailformat=document.getElementById('emailformat').value;
          if(sendto==""){
            Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0029")%>');//请填写收件人邮件地址！
              return;
          }
          Ext.getCmp('S').disable();
             FCKEditorExt.updateContent();
          Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=save&from=savesendemail',
           isUpload:true,
           form:Ext.get('eweaverForm'),
         params:{id:id,sendfrom:sendfrom,sendto:sendto,subject:subject,content:content,secretsend:secretsend,copysend:copysend,content2:content2,emailformat:emailformat},
        success: function() {
             Ext.getCmp('S').enable();
            dlg0.show();

        }
    });
      }
         var $j = jQuery.noConflict();
      $j(document).ready(function($){
          //to
         $("#sendto").autocomplete("<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=autocomplete", {
		width: 260,
        max:15,
        multiple: true,
		matchContains: true,
        scroll: true,
        scrollHeight: 300,
         multipleSeparator: ",",
        selectFirst: false
         });
          //bcc
          $("#secretsend").autocomplete("<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=autocomplete", {
		width: 260,
        max:15,
         multiple: true,
		matchContains: true,
        matchCase:true,
        scroll: true,
         multipleSeparator: ",",
        scrollHeight: 300,
        selectFirst: false
            });
          //cc
            $("#copysend").autocomplete("<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=autocomplete", {
		width: 260,
        max:15,
        matchCase:true,
        scroll: true,
         multiple: true,
        multipleSeparator: ",",
		matchContains: true,
        scrollHeight: 300,
        selectFirst: false
            });
          $.Autocompleter.Selection = function(field, start, end) {
             if( field.createTextRange ){
              var selRange = field.createTextRange();
              selRange.collapse(true);
              selRange.moveStart("character", start);
              selRange.moveEnd("character", end);
              selRange.select();

       } else if( field.setSelectionRange ){
              field.setSelectionRange(start, end);
          } else {
                 if( field.selectionStart ){
                  field.selectionStart = start;
                  field.selectionEnd = end;
              }
          }
          field.focus();
      };

       });
</script>
</html>