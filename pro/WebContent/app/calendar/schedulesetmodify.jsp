<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.calendar.base.service.SchedulesetService" %>
<%@ page import="com.eweaver.calendar.base.model.Scheduleset" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String id=StringHelper.null2String(request.getParameter("id"));
    SchedulesetService schedulesetService = (SchedulesetService) BaseContext.getBean("schedulesetService");
   ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");

Scheduleset scheduleset=schedulesetService.getSchedulesetDao().getById(id);
    String formspan="";
    if(!StringHelper.isEmpty(scheduleset.getFormid())){                                  
        formspan=forminfoService.getForminfoById(scheduleset.getFormid()).getObjname();
    }
%>
<%
     pagemenustr +="addBtn(tb,'确定','D','accept',function(){onSubmit()});";
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
   <%}%> });
      </script>

  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=transform" name="EweaverForm" method="post">

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
					设置名称
					</td>
					<td class="FieldValue">
					    <input type="text" name="objname" id="objname" class=inputstyle value="<%=StringHelper.null2String(scheduleset.getObjname())%>">
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					表单
					</td>
					<td class="FieldValue">
					    <button type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?objtype=0','formid','formidspan','0');"></button>
                        <input type="hidden"  name="formid" id="formid" value="<%=StringHelper.null2String(scheduleset.getFormid())%>"/>
                        <span id="formidspan"><%=formspan%></span>
					</td>
				</tr>

	                  <tr id="trsch1">
					<td class="FieldName" nowrap>
					标题字段
					</td>
					<td class="FieldValue">
						<select name="title">
                       </select>
					</td>
				</tr>


                   <tr id="trsch2" >
                       <td class="FieldName" nowrap>
                           开始日期字段
                       </td>
                       <td class="FieldValue">
                           <select name="begindatesch">

                           </select>
                       </td>
                   </tr>
                   <tr id="trsch3" >
                       <td class="FieldName" nowrap>
                           结束日期字段
                       </td>
                       <td class="FieldValue">
                           <select name="enddatesch">

                           </select>
                       </td>
                   </tr>


                   <tr id="trsch4" >
                       <td class="FieldName" nowrap>
                           开始时间字段
                       </td>
                       <td class="FieldValue">
                           <select name="begintime">

                           </select>
                       </td>
                   </tr>


                    <tr id="trsch5" >
                       <td class="FieldName" nowrap>
                           结束时间字段
                       </td>
                       <td class="FieldValue">
                           <select name="endtime">

                           </select>
                       </td>
                   </tr>


   <tr id="trsch6" >
                       <td class="FieldName" nowrap>
                           类型字段
                       </td>
                       <td class="FieldValue">
                           <select name="type">

                           </select>
                       </td>
                   </tr>

                   <tr id="trsch7" >
                       <td class="FieldName" nowrap>
                           内容字段
                       </td>
                       <td class="FieldValue">
                           <select name="content">

                           </select>
                       </td>
                   </tr>

                   <tr id="trsch8" >
                       <td class="FieldName" nowrap>
                           颜色字段
                       </td>
                       <td class="FieldValue">
                           <select name="color">

                           </select>
                       </td>
                   </tr>

                   <tr id="trsch9" >
                       <td class="FieldName" nowrap>
                           资源字段
                       </td>
                       <td class="FieldValue">
                           <select name="resources">

                           </select>
                       </td>
                   </tr>
                   <tr id="trsch10" >
                       <td class="FieldName" nowrap>
                           创建人字段
                       </td>
                       <td class="FieldValue">
                           <select name="creator">

                           </select>
                       </td>
                   </tr>
                   <tr >
                       <td class="FieldName" nowrap>
                           说明
                       </td>
                       <td class="FieldValue">
                           <textarea rows="8" cols="50" id="description" name="description" ><%=StringHelper.null2String(scheduleset.getDescription())%></textarea>
                       </td>
                   </tr>
			 </table>
	  </td>

</table>
</form>
<script language="javascript">
        getEnddateOptions(document.all("formid").value);
        getTitleOptions(document.all("formid").value);
        getBegintimeOptions(document.all("formid").value);
        getEndtimeOptions(document.all("formid").value);
        getContentOptions(document.all("formid").value);
        getColorOptions(document.all("formid").value);
        getMembersOptions(document.all("formid").value);
        getCreatorOptions(document.all("formid").value);
        getTypeOptions(document.all("formid").value);
function onSubmit(){
     var titlesch=document.getElementById('title').value;
    var begindatesch=document.getElementById('begindatesch').value;
    var enddatesch=document.getElementById('enddatesch').value;
    var begintime=document.getElementById('begintime').value;
    var endtime=document.getElementById('endtime').value;
    var content=document.getElementById('content').value;
    var color=document.getElementById('color').value;
    var resources=document.getElementById('resources').value;
    var creator=document.getElementById('creator').value;
    var objname=document.getElementById('objname').value;
    var description=document.getElementById('description').value;
    var formid=document.getElementById('formid').value;
	var type = document.getElementById('type').value;
       if(titlesch==''||begindatesch==''||enddatesch==''||begintime==''||endtime==''||content==''||color==''||resources==''){
           pop('字段为空','错误',null,'cancel');
           return;
       }



    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=transform&formid='+formid,
        params:{id:'<%=id%>',objname:objname,type:type,description:description,title:titlesch,begindatesch:begindatesch,enddatesch:enddatesch,content:content,color:color,resources:resources,creator:creator,begintime:begintime,endtime:endtime},
        success: function() {
            pop( '设置成功！');
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
    if(formid!=""){
    FormfieldService.getFieldByForm(formid,6,'',callbackschresource)
    }
}
    function callbackschresource(list){
    DWRUtil.removeAllOptions("resources");
    DWRUtil.addOptions("resources",list,"id","fieldname");
    var objselect = document.all("resources");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getResources()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }
function getCreatorOptions(formid){
    if(formid!=""){
    FormfieldService.getFieldByForm(formid,6,'',callbackcreator)
    }
}
    function callbackcreator(list){
    DWRUtil.removeAllOptions("creator");
    DWRUtil.addOptions("creator",{'':'   '});
    DWRUtil.addOptions("creator",list,"id","fieldname");
    var objselect = document.all("creator");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getCreator()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }

function getEnddateOptions(formid){
    if(formid!="") {
    FormfieldService.getFieldByForm(formid,1,'4',callbackbegindate)
    FormfieldService.getFieldByForm(formid,1,'4',callbackenddate)

    }
}
    function callbackenddate(list){
       DWRUtil.removeAllOptions("enddatesch");
      DWRUtil.addOptions("enddatesch",list,"id","fieldname");
    var objselect = document.all("enddatesch");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getEnddate()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }
    function callbackbegindate(list){
       DWRUtil.removeAllOptions("begindatesch");
      DWRUtil.addOptions("begindatesch",list,"id","fieldname");
    var objselect = document.all("begindatesch");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getBegindate()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }

    function getTitleOptions(formid){
       if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'1',callbacktitle)
    }
    function callbacktitle(list){
         DWRUtil.removeAllOptions("title");
    DWRUtil.addOptions("title",list,"id","fieldname");
    var objselect = document.all("title");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getTitle()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }

      function getBegintimeOptions(formid){
      	if(formid!="")
    		FormfieldService.getFieldByForm(formid,1,'5',callbackbegintime);
    }
    function callbackbegintime(list){
       DWRUtil.removeAllOptions("begintime");
    DWRUtil.addOptions("begintime",list,"id","fieldname");
    var objselect = document.all("begintime");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getBegintime()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }

      function getEndtimeOptions(formid){
      if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'5',callbackendtime);
    }
     function getTypeOptions(formid){
      if(formid!="")
    FormfieldService.getFieldByForm(formid,5,'',callbacktype);
    }
    
     function callbacktype(list){
         DWRUtil.removeAllOptions("type");
    DWRUtil.addOptions("type",list,"id","fieldname");
    var objselect = document.all("type");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getType()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }
    
    function callbackendtime(list){
       DWRUtil.removeAllOptions("endtime");
    DWRUtil.addOptions("endtime",list,"id","fieldname");
    var objselect = document.all("endtime");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getEndtime()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }

     function getContentOptions(formid){
      if(formid!="")
    FormfieldService.getFieldByForm(formid,3,'',callbackcontent);
    }
    function callbackcontent(list){
       DWRUtil.removeAllOptions("content");
    DWRUtil.addOptions("content",list,"id","fieldname");
    var objselect = document.all("content");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=scheduleset.getContent()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }


      function getColorOptions(formid){
      if(formid!="")
    FormfieldService.getFieldByForm(formid,5,'',callbackcolor);
    }
    function callbackcolor(list){
       DWRUtil.removeAllOptions("color");
    DWRUtil.addOptions("color",list,"id","fieldname");
    var objselect = document.all("color");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='') {
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
            getEnddateOptions(document.all("formid").value);
        getTitleOptions(document.all("formid").value);
        getBegintimeOptions(document.all("formid").value);
        getEndtimeOptions(document.all("formid").value);
        getContentOptions(document.all("formid").value);
        getColorOptions(document.all("formid").value);
        getMembersOptions(document.all("formid").value);
        getCreatorOptions(document.all("formid").value);
        getTypeOptions(document.all("formid").value);
        
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
</script>
  </body>
</html>
