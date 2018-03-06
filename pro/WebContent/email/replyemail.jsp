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
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0049")+"','S','email_transfer',function(){sendemail()});";//发送
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883de35273f910135273f954c0018")+"','S','email_attach',function(){Save()});";//存草稿
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    GetemailsService getemailsService = (GetemailsService) BaseContext.getBean("getemailsService");
    String sql = "select * from emailsetinfo where userid='" + eweaveruser.getId() + "'";
    List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
    String id = StringHelper.null2String(request.getParameter("id"));
    Getemails getemails = new Getemails();
    if (!StringHelper.isEmpty(id)) {
        getemails = getemailsService.getGetemails(id);
    }
    String subvalue = "";
    StringBuffer contentvalue = new StringBuffer();

    subvalue = "RE:" + StringHelper.null2String(getemails.getSubject());
    contentvalue.append("<br>");
    contentvalue.append("<br>");
    contentvalue.append("<br>");
    contentvalue.append("<br>");
    contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f954c0019"));//在
    contentvalue.append(StringHelper.null2String(getemails.getSentdate()));
    contentvalue.append(",");
    contentvalue.append(StringHelper.null2String(getemails.getSentfrom()));
    contentvalue.append(labelService.getLabelNameByKeyId("402883de35273f910135273f954c001a")+"：");//写道
    contentvalue.append("<br>");
    contentvalue.append("<br>");
    contentvalue.append("" + getemails.getContent());


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
                               if(aid.equals(getemails.getAccountid())){
                                  selected = "selected";
                               }
                        %>
                      <option value="<%=aid%>" <%=selected%>><%=objname%></option>
                          <% } %>
                  </select>
                </td>
            </tr>
          <tr>
              <td class="FieldName" nowrap>
                  <%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")%><!-- 收件人 -->
                </td>
                <td class="FieldValue">
                    <input  type="text" name="to" style="width:90%;"   id="to" value="<%=StringHelper.null2String(getemails.getSentfrom())%>" />
                </td>
          </tr>
            <%

            %>
          <tr <%if(StringHelper.isEmpty(getemails.getMailaddresscc())){%> style="display:none" <%}%>>
               <td class="FieldName" nowrap>
                  CC
                </td>
                <td class="FieldValue">
                    <input  type="text" name="cc" style="width:90%;"   id="cc" value="<%=StringHelper.null2String(getemails.getMailaddresscc())%>" />
                </td>
          </tr>

          <tr <% if(StringHelper.isEmpty(getemails.getMailaddressbcc())){%> style="display:none" <%}%>>
            <td class="FieldName" nowrap>
                  BCC
                </td>
                <td class="FieldValue">
                    <input  type="text" name="bcc" style="width:90%;"   id="bcc" value="<%=StringHelper.null2String(getemails.getMailaddressbcc())%>" />
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
                        <option value="0" ><%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001c")%></option><!-- 超文本格式 -->
                        <option value="1"  ><%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c001d")%></option><!-- 纯文本格式 -->
                    </select>
                </td>
            </tr>
        <tr>
        <tr>
                <td class="FieldName" nowrap>

                </td>
                    <td class="FieldValue" id="texta0" >
                    <textarea class="InputStyle2" style="width:90%; height:315px" name="content" id="content"><%=contentvalue%></textarea>
                    <script >
                            WeaverUtil.load(function(){
                            FCKEditorExt.initEditor('content',false);
                            FCKEditorExt.toolbarExpand(false);
                        });
                    </script>
                   </td>
              <td class="FieldValue" style="display:none" id="texta1">
                    <textarea class="InputStyle2" style="width:90%; height:315px" name="content2" id="content2"><%=contentvalue%></textarea>

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
    </body>
<script type="text/javascript">
    function Save(){
          FCKEditorExt.updateContent();
        var sendfrom=document.all('sendfrom').value;
                var subject=document.all('subject').value;
                var content=document.all('content').value;
                var sendtoother=document.all('to').value;
                var secretsendother=document.all('bcc').value;
                var copysendother=document.all('cc').value;
                var content2=document.all('content2').value;
                var accessoryfile=document.all('accessoryfile').value;
                var emailformat=document.all('emailformat').value;
                 Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=save',
        params:{sendfrom:sendfrom,subject:subject,content:content,accessoryfile:accessoryfile,sendtoother:sendtoother,secretsendother:secretsendother,copysendother:copysendother,content2:content2,emailformat:emailformat},
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
     function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
      function sendemail(){ //缺少附件 
        var sendfrom=document.all('sendfrom').value;
        var subject=document.all('subject').value;
        var content=document.all('content').value;
        var sendtoother=document.all('to').value;
        var accessoryfile=document.all('accessoryfile').value;
       var secretsendother=document.all('bcc').value;
       var copysendother=document.all('cc').value;
        var content2=document.all('content2').value;
        var emailformat=document.all('emailformat').value;
          FCKEditorExt.updateContent();
          alert('aaaa');
          Ext.Ajax.request({

        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.email.servlet.EmailAction?action=save&from=savesendemail',
        params:{sendfrom:sendfrom,subject:subject,content:content,accessoryfile:accessoryfile,sendtoother:sendtoother,secretsendother:secretsendother,copysendother:copysendother,content2:content2,emailformat:emailformat},
        success: function() {
            pop( '<%=labelService.getLabelNameByKeyId("402883de35273f910135273f954c0020")%>');//发送成功！
        }
    });
      }
    function onCancel(){
    }
</script>
</html>