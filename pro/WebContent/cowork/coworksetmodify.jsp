<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.cowork.service.CoworksetService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String id=StringHelper.null2String(request.getParameter("id"));
     CoworksetService coworksetService = (CoworksetService) BaseContext.getBean("coworksetService");
   ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");

Coworkset coworkset=coworksetService.getCoworksetDao().getById(id);
    String formspan="";
    if(!StringHelper.isEmpty(coworkset.getFormid())){
        formspan=forminfoService.getForminfoById(coworkset.getFormid()).getObjname();
    }
    String showreadcheck="";
    String replynotifycheck="";
    if(!StringHelper.isEmpty(coworkset.getId())){
         if(coworkset.getShowunread().intValue()==1){
             showreadcheck="checked";
         }
        if(coworkset.getReplynotify().intValue()==1){
             replynotifycheck="checked";
         }
    }
%>
<%
     pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','D','accept',function(){onSubmit()});";//确定
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
      <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
      <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
      <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
     
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript">
         Ext.onReady(function() {
       Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%> });
      </script>

  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction?action=transform" name="EweaverForm" method="post">
            
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
					<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0003")%><!-- 设置名称 -->
					</td>
					<td class="FieldValue">
					    <input type="text" name="objname" id="objname" class=inputstyle value="<%=StringHelper.null2String(coworkset.getObjname())%>">
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
					</td>
					<td class="FieldValue">
					    <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?objtype=0','formid','formidspan','0');"></button>
                        <input type="hidden"  name="formid" id="formid" value="<%=StringHelper.null2String(coworkset.getFormid())%>"/>
                        <span id="formidspan"><%=formspan%></span>
					</td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790041")%><!-- 主题字段 -->
					</td>
					<td class="FieldValue">
						<select name="subject">
                       </select>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790042")%><!-- 参与人字段 -->
					</td>
					<td class="FieldValue">
						<select name="members">

                       </select>
					</td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790043")%><!-- 显示未读人员 -->
					</td>
					<td class="FieldValue">
						<input type="checkbox" class="InputStyle2"  name="showunread" id="showunread" value=1 onclick="checkvalue()" <%=showreadcheck%>    />
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790044")%><!-- 有新回复时提醒 -->
					</td>
					<td class="FieldValue">
						<input type="checkbox" class="InputStyle2"  name="replynotify" id="replynotify" value=1 onclick="checkvalue()" <%=replynotifycheck%>/>
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883c134f8ef330134f8ef33f80022")%><!-- 结束日期字段 -->
					</td>
					<td class="FieldValue">
						<select name="enddate">

                       </select>
					</td>
				</tr>
						        <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790045")%><!-- 分类字段 -->
					</td>
					<td class="FieldValue">
						<select name="categoryid">

                       </select>
					</td>
				</tr>
					<tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790046")%><!-- 颜色标识字段 -->
					</td>
					<td class="FieldValue">
						<select name="colorfield">

                       </select>
					</td>
				</tr>
                  <tr >
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
                       </td>
                       <td class="FieldValue">
                           <textarea rows="8" cols="50" id="description" name="description" ><%=StringHelper.null2String(coworkset.getDescription())%></textarea>
                       </td>
                   </tr>
			 </table>
	  </td>
</table>
</form>
<script language="javascript">

      getMembersOptions(Ext.getDom("formid").value);
        getEnddateOptions(Ext.getDom("formid").value);
      getSubjectOptions(Ext.getDom("formid").value);
       getCategoryidOptions(Ext.getDom("formid").value);
        getColorfieldOptions(Ext.getDom("formid").value);
      function checkvalue(){
          if(document.all('showunread').checked){
               document.getElementById('showunread').value=1;
          }else{
             document.getElementById('showunread').value=0;
          }

           if(document.all('replynotify').checked){
               document.getElementById('replynotify').value=1;
          }else{
            document.getElementById('replynotify').value=0;
          }
      }
function onSubmit(){
   var objname=document.getElementById('objname').value;
   var members=document.getElementById('members').value;
    var subject=document.getElementById('subject').value;
   var showunread=document.getElementById('showunread').value;
   var replynotify=document.getElementById('replynotify').value;
   var enddate=document.getElementById('enddate').value;
   var description=document.getElementById('description').value;
   var formid=document.getElementById('formid').value;
   var categoryid=document.getElementById('categoryid').value;
   var colorfield=document.getElementById('colorfield').value;
      if(formid==''){
        pop('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790047")%>','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053")%>',null,'cancel')//请选择表单//错误
          return;
      }
   Ext.Ajax.request({
       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction?action=transform&formid='+formid,
       params:{id:'<%=id%>',subject:subject,objname:objname,description:description,enddate:enddate,members:members,showunread:showunread,replynotify:replynotify,categoryid:categoryid,colorfield:colorfield},
       success: function() {
           pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
       }
   });

}    
   function onDelete(id){
     if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
     document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=delete&id="+id;//输入你的Action
	 document.EweaverForm.submit();
   	}
   }
function getMembersOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,6,'402881eb0bd30911010bd321d8600015',callback)
}
function callback(list){
    DWRUtil.removeAllOptions("members");
    var objselect = document.all("members");
    objselect.add(new Option());
    DWRUtil.addOptions("members",list,"id","fieldname");

    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getMembers()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }

}
function getEnddateOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'4',callback1)
}
function callback1(list){
    DWRUtil.removeAllOptions("enddate");
    var objselect = document.all("enddate");
    objselect.add(new Option());
    DWRUtil.addOptions("enddate",list,"id","fieldname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getEnddate()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
   
}

function getCategoryidOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,6,'',callbackc)
}
function callbackc(list){
    DWRUtil.removeAllOptions("categoryid");
    var objselect = document.all("categoryid");
    objselect.add(new Option());
    DWRUtil.addOptions("categoryid",list,"id","fieldname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getCategoryid()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
   
}
function getColorfieldOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,5,'',callbackcolor)
}
function callbackcolor(list){
    DWRUtil.removeAllOptions("colorfield");
    var objselect = document.all("colorfield");
    objselect.add(new Option());
    DWRUtil.addOptions("colorfield",list,"id","fieldname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getColorfield()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
   
}
function getSubjectOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'1',callback2);
}
function callback2(list){
    DWRUtil.removeAllOptions("subject");
    var objselect = document.all("subject");
    objselect.add(new Option())
    DWRUtil.addOptions("subject",list,"id","fieldname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getSubject()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }

}
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog(contextPath+'/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
        document.all(inputname).value = id[0];
        document.all(inputspan).innerHTML = id[1];
        getMembersOptions(Ext.getDom("formid").value);
        getEnddateOptions(Ext.getDom("formid").value);
        getSubjectOptions(Ext.getDom("formid").value);
        getColorfieldOptions(Ext.getDom("formid").value);
        
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src='+contextPath+'/images/base/checkinput.gif>';

            }
         }
 }

</script> 
  </body>
</html>
