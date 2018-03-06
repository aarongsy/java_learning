<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>


<% 
   String id = StringHelper.null2String(request.getParameter("id"));
   String formId="";

   NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
   ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
   FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");    
   NotifyDefine notifyDefine = notifyDefineService.get(id);
   formId=notifyDefine.getFormId();
   List forms=new ArrayList();
   forms=notifyDefineService.getForminfos(formId,forms);
%>  
<html>
  <head>
   <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  </head>
   
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
//pagemenustr += "{C,"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+",javascript:location.href='"+request.getContextPath()+"/base/notify/notifyDefineCreate.jsp'}";
pagemenustr += "{D,"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+",javascript:onDelete()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";

    List<Formfield> timefields=formfieldService.getFieldByForm(notifyDefine.getFormId(),1,"5");
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

 <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=modify" name="EweaverForm"  method="post">
 <input type="hidden" name="categoryId" value="<%=notifyDefine.getCategoryId()%>">
 <table class=noborder>
    <input type="hidden" name="id" value="<%=id%>"/>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	
	<tr class=Title>
		<th colspan=2 nowrap>提醒信息</th>
	</tr>
	<tr>
    	<td class="Line" colspan=2 nowrap>
		</td>		        	  
	 </tr>	
	 <tr>
	    <td class="FieldName" nowrap>
			提醒名称
	   </td>
	   <td class="FieldValue">
			<input type="text" class="InputStyle2" style="width=95%" name="notifyName" value="<%=StringHelper.null2String(notifyDefine.getNotifyName())%>" onchange='checkInput("notifyName","notifyNamespan")'/>
			<span id = "notifyNamespan"></span>
		</td>
	 </tr>	
 	 <tr>
	    <td class="FieldName" nowrap>
			提醒内容
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="content" value="<%=StringHelper.null2String(notifyDefine.getContent())%>"/>
		</td>
	 </tr>
	 <tr>
	   <td class="FieldName" nowrap>
			提醒类型
	   </td>
	   <td class="FieldValue">
			<select name="remindType" onchange="typechange()">
               <option value="1" <%if(notifyDefine.getRemindType()==1){%>selected<%}%>>到期提醒</option>
               <option value="4" <%if(notifyDefine.getRemindType()==4){%>selected<%}%>>即时提醒</option>
           </select>
		</td>
	 </tr>
     <tr>
	   <td class="FieldName" nowrap>
			提醒方式
	   </td>
	   <td class="FieldValue">
            <input type='checkbox' name='ispopup' value="1" <%if(notifyDefine.getIspopup()==1){%>checked<%}%>>弹出式提醒
            <input type='checkbox' name='isemail' value="1" <%if(notifyDefine.getIsemail()==1){%>checked<%}%>>邮件提醒
            <input type='checkbox' name='issms' value="1" <%if(notifyDefine.getIssms()==1){%>checked<%}%>>短信提醒
            <input type='checkbox' name='isrtx' value="1" <%if(notifyDefine.getIsrtx()==1){%>checked<%}%>>即时通讯
		</td>
	 </tr>
  	 <tr id="beforetimetr" <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	   <td class="FieldName" nowrap>
			提前时间
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" name="ahead" value="<%=StringHelper.null2String(notifyDefine.getAhead())%>" onkeypress="checkInt_KeyPress()" size="1"/>&nbsp;天&nbsp;
           <%if(timefields!=null&&timefields.size()!=0){%>
             <input type="text" class="InputStyle2" name="ahour" value="<%=StringHelper.null2String(notifyDefine.getAhour())%>" onkeypress="checkInt_KeyPress()" size="1"/>&nbsp;<span id="ahourspan">小时</span>&nbsp;
             <input type="text" class="InputStyle2" name="aminutes" value="<%=StringHelper.null2String(notifyDefine.getAminutes())%>" onkeypress="checkInt_KeyPress()" size="1"/>&nbsp;<span id="aminutesspan">分</span>&nbsp;
		   <%}%>
       </td>
	 </tr>
  	 <tr id="formtr" <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	   <td class="FieldName" nowrap>
			实际表单
	   </td>
	   <td class="FieldValue">
           <select name="formId" onchange="getOptions(this.value)">
               <%for(Object form:forms){
                   String formName=((Forminfo)form).getObjname();
                   formId= ((Forminfo)form).getId();
               %>
               <option value="<%=formId%>" <%if(formId.equals(notifyDefine.getFormId())){%>selected<%}%>><%=formName%></option>
               <%}%>
           </select>
		</td>
	 </tr>
     <tr id="datefieldtr" <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	   <td class="FieldName" nowrap>
			表单日期字段
	   </td>
	   <td class="FieldValue">
           <select name="dateField">
           <%
               List<Formfield> fields=formfieldService.getFieldByForm(notifyDefine.getFormId(),1,"4");
              for(Formfield field:fields){
            %>
            <option value="<%=field.getFieldname()%>" <%if(field.getFieldname().equals(notifyDefine.getDateField())){%>selected<%}%>><%=field.getFieldname()%></option>
            <%}%>
           </select>
		</td>
	 </tr>
     <tr id="timefieldtr" <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	   <td class="FieldName" nowrap>
			表单时间字段
	   </td>
	   <td class="FieldValue">
           <select name="timeField">
           <%
              for(Formfield field:timefields){
            %>
            <option value="<%=field.getFieldname()%>" <%if(field.getFieldname().equals(notifyDefine.getTimeField())){%>selected<%}%>><%=field.getFieldname()%></option>
            <%}%>
           </select>
		</td>
	 </tr>
 </table>
 </form>
 

<script language="javascript">

    function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
function onSubmit(){
    var notifyname = document.all("notifyName");
    if(notifyname.value==""){
        alert("名称不能为空.");
        return;            
    }
    var content = document.all("content");
    if(content.value==""){
        alert("提醒内容不能为空.");
        return;
    }
    var aminutes = document.all("aminutes");
    var remindType = document.all("remindType").value;
    if(aminutes!=null){
        var num = aminutes.value;
        if(num==""){
            num=0;
        }
        if(aminutes.style.display!="none"&&parseInt(num)<5&&remindType!=4){
            alert("提前分钟不能小于5.");
            return;
        }
    }
    document.EweaverForm.submit();
}    

function onDelete(){
 EweaverForm.action = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=delete";
 document.EweaverForm.submit();
 }
 function getOptions(formId){
    FormfieldService.getFieldByForm(formId,1,4,callback);
    FormfieldService.getFieldByForm(formId,1,5,timecallback)
}
function callback(list){
    DWRUtil.removeAllOptions("dateField");
    DWRUtil.addOptions("dateField",list,"fieldname","fieldname");
}
function timecallback(list){
    DWRUtil.removeAllOptions("timeField");
    DWRUtil.addOptions("timeField",list,"fieldname","fieldname");
}
function typechange(){
    var value = document.all("remindType").value;
    if(value==4){
        document.getElementById("beforetimetr").style.display="none";
        document.getElementById("formtr").style.display="none";
        document.getElementById("datefieldtr").style.display="none";
        document.getElementById("timefieldtr").style.display="none";
    }else{
        document.getElementById("beforetimetr").style.display="block";
        document.getElementById("formtr").style.display="block";
        document.getElementById("datefieldtr").style.display="block";
        document.getElementById("timefieldtr").style.display="block";
    }
}
</script>
  </body>
</html>
