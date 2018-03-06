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
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String formid=StringHelper.null2String(request.getParameter("formid"));
    String  objnamefield="";
    String startdatefield="";
    String enddatefield="";
    String starttimefield="";
    String endtimefield="";
    String anonymityfield="";
    String viewresultfield="";
    if(!StringHelper.isEmpty(formid)){
        String sql="select * from indagateformset where formid='"+formid+"'";
            List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);
        for(Object o:list){
             objnamefield= ((Map) o).get("objnamefield ") == null ? "" : ((Map) o).get("objnamefield ").toString();
            startdatefield= ((Map) o).get("startdatefield") == null ? "" : ((Map) o).get("startdatefield").toString();
            enddatefield= ((Map) o).get("enddatefield") == null ? "" : ((Map) o).get("enddatefield").toString();
            starttimefield= ((Map) o).get("starttimefield") == null ? "" : ((Map) o).get("starttimefield").toString();
            endtimefield= ((Map) o).get("endtimefield") == null ? "" : ((Map) o).get("endtimefield").toString();
            anonymityfield= ((Map) o).get("anonymityfield") == null ? "" : ((Map) o).get("anonymityfield").toString();
            viewresultfield= ((Map) o).get("viewresultfield") == null ? "" : ((Map) o).get("viewresultfield").toString();
        }
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
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=createformset" name="EweaverForm" method="post">

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
					调查名称
					</td>
					<td class="FieldValue">
                        <select id="objnamefield" name="objnamefield">
                        </select>
					</td>
				</tr>
                   <tr  >
                       <td class="FieldName" nowrap>
                           开始日期字段
                       </td>
                       <td class="FieldValue">
                           <select id="startdatefield" name="startdatefield">

                           </select>
                       </td>
                   </tr>
                   <tr id="trsch3" >
                       <td class="FieldName" nowrap>
                           结束日期字段
                       </td>
                       <td class="FieldValue">
                           <select id="enddatefield" name="enddatefield">

                           </select>
                       </td>
                   </tr>


                   <tr id="trsch4" >
                       <td class="FieldName" nowrap>
                           开始时间字段
                       </td>
                       <td class="FieldValue">
                           <select id="starttimefield" name="starttimefield">

                           </select>
                       </td>
                   </tr>


                    <tr id="trsch5" >
                       <td class="FieldName" nowrap>
                           结束时间字段
                       </td>
                       <td class="FieldValue">
                           <select id="endtimefield" name="endtimefield">

                           </select>
                       </td>
                   </tr>

                   <tr id="trsch7" >
                       <td class="FieldName" nowrap>
                           是否允许匿名字段
                       </td>
                       <td class="FieldValue">
                           <select id="anonymityfield" name="anonymityfield">

                           </select>
                       </td>
                   </tr>

                   <tr id="trsch8" >
                       <td class="FieldName" nowrap>
                           投票后是否直接查看结果字段
                       </td>
                       <td class="FieldValue">
                           <select id="viewresultfield" name="viewresultfield">

                           </select>
                       </td>
                   </tr>
			 </table>
	  </td>

</table>
</form>
<script language="javascript">
getobjnameOptions('<%=formid%>');
getdateOptions('<%=formid%>');
gettimeOptions('<%=formid%>');
getanonymityOptions('<%=formid%>');
getviewresultOptions('<%=formid%>');
function getobjnameOptions(formid){
  if(formid!=""){
    FormfieldService.getFieldByForm(formid,1,'1',callbackobjname);
    }
}
 function callbackobjname(list){
    DWRUtil.removeAllOptions("objnamefield");
    DWRUtil.addOptions("objnamefield",list,"id","fieldname");
    var objselect = document.all("objnamefield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=objnamefield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }
function getdateOptions(formid){
  if(formid!=""){
    FormfieldService.getFieldByForm(formid,1,'4',callbackstartdate);
    FormfieldService.getFieldByForm(formid,1,'4',callbackenddate);
    }
}
 function callbackstartdate(list){
    DWRUtil.removeAllOptions("startdatefield");
    DWRUtil.addOptions("startdatefield",list,"id","fieldname");
    var objselect = document.all("startdatefield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=startdatefield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }
function callbackenddate(list){
      DWRUtil.removeAllOptions("enddatefield");
    DWRUtil.addOptions("enddatefield",list,"id","fieldname");
    var objselect = document.all("enddatefield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=enddatefield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function gettimeOptions(formid){
  if(formid!=""){
    FormfieldService.getFieldByForm(formid,1,'5',callbackstarttime);
    FormfieldService.getFieldByForm(formid,1,'5',callbackendtime);
    }
}
 function callbackstarttime(list){
    DWRUtil.removeAllOptions("starttimefield");
    DWRUtil.addOptions("starttimefield",list,"id","fieldname");
    var objselect = document.all("starttimefield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=starttimefield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    }
function callbackendtime(list){
      DWRUtil.removeAllOptions("endtimefield");
    DWRUtil.addOptions("endtimefield",list,"id","fieldname");
    var objselect = document.all("endtimefield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=endtimefield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function getanonymityOptions(formid){
  if(formid!=""){
    FormfieldService.getFieldByForm(formid,4,'',callbackanonymity);
    }
}
function callbackanonymity(list){
    DWRUtil.removeAllOptions("anonymityfield");
    DWRUtil.addOptions("anonymityfield",list,"id","fieldname");
    var objselect = document.all("anonymityfield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=anonymityfield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function getviewresultOptions(formid){
  if(formid!=""){
    FormfieldService.getFieldByForm(formid,4,'',callbackviewresult);
    }
}
function callbackviewresult(list){
    DWRUtil.removeAllOptions("viewresultfield");
    DWRUtil.addOptions("viewresultfield",list,"id","fieldname");
    var objselect = document.all("viewresultfield");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=viewresultfield%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function onSubmit(){
     var objnamefield =document.getElementById('objnamefield').value;
    var startdatefield =document.getElementById('startdatefield').value;
    var enddatefield=document.getElementById('enddatefield').value;
    var starttimefield=document.getElementById('starttimefield').value;
    var endtimefield=document.getElementById('endtimefield').value;
    var anonymityfield=document.getElementById('anonymityfield').value;
    var viewresultfield=document.getElementById('viewresultfield').value;
       if(objnamefield==''||startdatefield==''||enddatefield==''||starttimefield==''||endtimefield==''||anonymityfield==''||viewresultfield==''){
           pop('字段为空','错误',null,'cancel');
           return;
       }
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=createformset',
        params:{formid:'<%=formid%>',objnamefield:objnamefield,startdatefield:startdatefield,enddatefield :enddatefield ,starttimefield :starttimefield ,endtimefield :endtimefield ,anonymityfield :anonymityfield ,viewresultfield :viewresultfield},
        success: function() {
            location.href='<%=request.getContextPath()%>/indagate/indagateformset.jsp?formid=<%=formid%>';
            pop( '设置成功！');
        }
    });

}
</script>
  </body>
</html>
