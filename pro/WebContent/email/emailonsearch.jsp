<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.email.service.EmailtypeService" %>
<%@ page import="com.eweaver.email.model.Emailtype" %>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035249ddfdb01249e0985720006")+"','S','email_magnify',function(){onSearch()});";//搜索
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
       String sql="select * from emailsetinfo where userid='"+eweaveruser.getId()+"'";
   List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);
    String sendtoid=StringHelper.null2String(request.getParameter("sendtoid"));
    String sendtostr="";
    if(!StringHelper.isEmpty(sendtoid)){
       ArrayList listto=StringHelper.string2ArrayList(sendtoid,",");
    for(int i=0;i<listto.size();i++){
        String humresids=listto.get(i).toString();
        Humres humressendto=humresService.getHumresById(humresids);
        if(i==0){
           sendtostr=humressendto.getObjname()+"<"+humressendto.getEmail()+">";
        }else{
          sendtostr+=","+humressendto.getObjname()+"<"+humressendto.getEmail()+">";
        }
    }
    }
    String subject=StringHelper.null2String(request.getParameter("subject"));
    String searchrange=StringHelper.null2String(request.getParameter("searchrang"));
    String selected0="";
    String selected1="";
    String selected2="";
    if("0".equals(searchrange)){
        selected0="selected";
    }else if("1".equals(searchrange)){
        selected1="selected";
    }else{
        selected2="selected";
    }
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
     .dropdown .x-btn-left{background:url('');width:0;height:0}
   .dropdown .x-btn-center{background:url('')}
   .dropdown .x-btn-right{background:url('')}
    .dropdown .x-btn-center{text-align:left}
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
                var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
                text: '<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>',//人力资源
                 checked: false,
                checkHandler: onItemCheck
            },
            {
                text: '<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8003c")%>',//联系人
                 checked: false,
                checkHandler: onItemCheck
            },
            {
                text: '<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8003d")%>',//客户联系人
                 checked: false,
                checkHandler: onItemCheck
            }]
    });
              var tbmenu = new Ext.Button({
             text:'<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec71a0075")%>',//收件人
             menu : menu
         });
            tbmenu.render('menu');
            function onItemCheck(item, checked){
            if(item.text=="<%=labelService.getLabelNameByKeyId("402881ec0bdc2afd010bdd26d4200017")%>")//人力资源
            getBrowser('/humres/base/humresbrowserm.jsp?bid=2','sendto','sendtospan','1')
    }
        });
    </script>
  </head>
<body  <%if(!StringHelper.isEmpty(searchrange)){%>onload="valuechange('<%=searchrange%>')"<%}%>>
<div id="divSum">
<div id="pagemenubar"> </div>
	<form id="EweaverForm" name="EweaverForm"  method="post" action="<%=request.getContextPath()%>/email/emailsearchlist.jsp">
  	<table>
          <colgroup>
					<col width="20%">
					<col width="">
				</colgroup>
          <tr>
              <td  class="FieldName" nowrap> &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8003e")%>：</td><!-- 搜索关键字 -->
              <td  class="FieldValue" ><input type="text" id="subject" name="subject" style="width:90%" value="<%=StringHelper.null2String(subject)%>"></td>
          </tr>
          <tr>
              <td class="FieldName" nowrap> &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f8003f")%>：</td><!-- 搜索范围 -->
              <td class="FieldValue"><select id="searchrang" name="searchrang" style="width:40%" onchange="valuechange(this.options[this.options.selectedIndex].value)">
                   <option value="2" <%=selected2%>><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80040")%></option><!-- 收件箱 -->
                  <option value="0" <%=selected0%>><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80037")%></option><!-- 草稿箱 -->
                  <option value="1" <%=selected1%>><%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80041")%></option><!-- 已发送 -->
              </select> </td>
          </tr>
           <tr id="trsendfrom" style="display:block">
              <td  class="FieldName" nowrap> &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80034")%>：</td><!-- 发件人 -->
              <td  class="FieldValue" ><input type="text" id="sendfrom" name="sendfrom" style="width:90%"></td>
          </tr>
           <tr id="trsendto" style="display:none">
              <td class="FieldName" nowrap> <div id="menu" class="dropdown" align="left"></div></td>
               <td class="FieldValue">
                    <input  type="text" name="sendto" style="width:90%;"  id="sendto" value="<%=StringHelper.null2String(sendtostr)%>" />
                    <input  type="hidden" name="sid" style="width:90%;"  id="sid" value="<%=StringHelper.null2String(sendtoid)%>" />

                </td>
          </tr>
          <tr>
              <td class="FieldName" nowrap> &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80035")%>：</td><!-- 账户 -->
              <td class="FieldValue"><select id="accountid" name="accountid" style="width:40%">
                  <option></option>
                            <%
                               for(int i=0;i<list.size();i++){
                                   String objname=StringHelper.null2String((String)((Map)list.get(i)).get("objname"));
                                   String id=StringHelper.null2String((String)((Map)list.get(i)).get("id"));
                            %>
                          <option value="<%=id%>"><%=objname%></option>
                              <% } %>
              </select> </td>
          </tr>
           <tr>
              <td class="FieldName" nowrap> &nbsp;&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000")%>：</td><!-- 日期 -->
              <td class="FieldValue">   <input type=text class=inputstyle size=10 name="time1"  value="" onclick="WdatePicker()" >
                    <span id="time1span"   ></span>-
                    <input type=text class=inputstyle size=10 name="time2"  value="" onclick="WdatePicker()" >
                    <span id="time2span"  >

                    </span></td>
          </tr>
  	</table>
        </form>
    </div>
    </body>
<script type="text/javascript">
     function getBrowser(viewurl,inputname,inputspan,isneed){
      var searchrang=document.getElementById('searchrang').value;
      var subject=document.getElementById('subject').value;
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
        location.href="<%=request.getContextPath()%>/email/emailonsearch.jsp?sendtoid="+id[0]+"&searchrang="+searchrang+"&subject="+subject;
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }

    function onSearch(){
      document.EweaverForm.submit();
    }
    function valuechange(value){
        if(value==2){ //收件箱
        document.getElementById('trsendfrom').style.display="block";
        document.getElementById('trsendto').style.display="none";
        }else{  //其他
          document.getElementById('trsendfrom').style.display="none";
        document.getElementById('trsendto').style.display="block";
        }

    }
</script>

<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
</html>