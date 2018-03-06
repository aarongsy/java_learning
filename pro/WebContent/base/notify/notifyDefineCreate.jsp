<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>

<%
   NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
    String categoryId = StringHelper.null2String(request.getParameter("categoryId"));
    String formId = StringHelper.null2String(request.getParameter("formId"));
    List forms=new ArrayList();
   forms=notifyDefineService.getForminfos(formId,forms);
  
%>



<html>
  <head>
   <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  </head>
  <body><!--"系统权限"-->  
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->   

 <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=create" name="EweaverForm"  method="post">
 <input type="hidden" name="categoryId" value="<%=categoryId%>">
 <table class=noborder>
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
			 <input type="text" class="InputStyle2" style="width=95%" name="notifyName" onchange='checkInput("notifyName","notifyNamespan")'/>
			 <span id = "notifyNamespan"><img src=<%=request.getContextPath()%>/images/base/checkinput.gif></span>
		</td>
	 </tr>	
 	 <tr>
	   <td class="FieldName" nowrap>
			提醒内容
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="content"/>
		</td>
	 </tr> 	
	 <tr>
	   <td class="FieldName" nowrap>
			提醒类型
	   </td>
	   <td class="FieldValue">
           <select name="remindType" onchange="typechange()">
               <option value="1">到期提醒</option>
               <option value="4">即时提醒</option>
           </select>
		</td>
	 </tr>
     <tr>
	   <td class="FieldName" nowrap>
			提醒方式
	   </td>
	   <td class="FieldValue">
            <input type='checkbox' name='ispopup' value="1" checked>弹出式提醒
            <input type='checkbox' name='isemail' value="1">邮件提醒
            <input type='checkbox' name='issms' value="1">短信提醒
            <input type='checkbox' name='isrtx' value="1">即时通讯
		</td>
	 </tr>
	 <tr id="beforetimetr">
	   <td class="FieldName" nowrap>
			提前时间
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" name="ahead" onkeypress="checkInt_KeyPress()" size="1"/>&nbsp;天&nbsp;
             <input type="text" class="InputStyle2" name="ahour" onkeypress="checkInt_KeyPress()" size="1"/>&nbsp;<span id="ahourspan">小时</span>&nbsp;
             <input type="text" class="InputStyle2" name="aminutes" onkeypress="checkInt_KeyPress()" size="1"/>&nbsp;<span id="aminutesspan">分</span>&nbsp;
		</td>
	 </tr>
     <tr id="formtr">
	   <td class="FieldName" nowrap>
			实际表单
	   </td>
	   <td class="FieldValue">
           <select name="formId" onchange="getOptions(this.value)">
               <%for(Object form:forms){
                   String formName=((Forminfo)form).getObjname();
                   formId= ((Forminfo)form).getId();
               %>
               <option value="<%=formId%>" ><%=formName%></option>
               <%}%>
           </select>
		</td>
	 </tr>
     <tr id="datefieldtr">
	   <td class="FieldName" nowrap>
			表单日期字段
	   </td>
	   <td class="FieldValue">
           <select name="dateField" id="dateField">
               
           </select>
		</td>
	 </tr>
     <tr id="timefieldtr">
	   <td class="FieldName" nowrap>
			表单时间字段
	   </td>
	   <td class="FieldValue">
           <select name="timeField" id="timeField">

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
    var num = aminutes.value;
    if(num==""){
        num=0;
    }
    if(aminutes.style.display!="none"&&parseInt(num)<5&&remindType!=4){
        alert("提前分钟不能小于5.");
        return;
    }
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
    if(list==""){
        document.all("ahour").style.display="none";
        document.all("aminutes").style.display="none";
        document.getElementById("ahourspan").style.display="none";
        document.getElementById("aminutesspan").style.display="none";
    }
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
getOptions(document.all("formId").value);

</script>     
  </body>
</html>
