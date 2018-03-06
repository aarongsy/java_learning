<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.base.security.model.PermissionBatchAction" %>
<%@ page import="com.eweaver.base.security.model.PermissionBatchActionDetail" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionBatchActionService" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<html>
  <head>
      <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
        <style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
      .x-panel-btns-ct {
        padding: 0px;
    }
    .x-panel-btns-ct table {width:0}
  </style>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
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
<%
String id = StringHelper.null2String(request.getParameter("id"));
String actionId = StringHelper.null2String(request.getParameter("actionId"));
String categoryId = StringHelper.null2String(request.getParameter("categoryId"));
String iscallback = StringHelper.null2String(request.getParameter("iscallback"));
String objName="";
int type=0;
if(request.getParameter("type")!=null&&!"".equals(request.getParameter("type"))){
    type=NumberHelper.getIntegerValue(request.getParameter("type"),1);
}
String realFormId="";//实际表单
String fieldId="";
String workflowinfoId = StringHelper.null2String(request.getParameter("workflowinfoId"));
String unionFieldId="";
String optType="";
String viewLayoutId="";
String editLayoutId="";
Integer viewPriority=-1;
Integer editPriority=-1;
    if (!id.equals("")) {
        PermissionBatchActionService permissionBatchActionService = (PermissionBatchActionService) BaseContext.getBean("permissionBatchActionService");
        PermissionBatchAction act = permissionBatchActionService.getPermissionBatchAction(actionId);

        for (Object o : act.getActionDetails()) {
             PermissionBatchActionDetail actDetail = (PermissionBatchActionDetail) o;
             if(id.equals(actDetail.getId())){
                if(categoryId==null||"".equals(categoryId)){
                    categoryId= StringHelper.null2String(actDetail.getCategoryId());
                }
                objName=StringHelper.null2String(actDetail.getObjname());
                if(type==0){
                    type=NumberHelper.getIntegerValue(actDetail.getType(),1);
                }
                realFormId=StringHelper.null2String(actDetail.getFormId());
                if((workflowinfoId==null||"".equals(workflowinfoId))&&!"true".equals(iscallback)){
                    workflowinfoId=StringHelper.null2String(actDetail.getWorkflowinfoId());
                }

                fieldId=StringHelper.null2String(actDetail.getFieldid());
                unionFieldId=StringHelper.null2String(actDetail.getUnionfieldid());
                optType=StringHelper.null2String(actDetail.getOptType());
                viewLayoutId=StringHelper.null2String(actDetail.getViewLayoutId());
                editLayoutId=StringHelper.null2String(actDetail.getEditLayoutId());
                viewPriority=actDetail.getViewPriority();
                editPriority=actDetail.getEditPriority();
                 break;
             }
        }
    }
NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
String formId="";//分类上的表单定义
List forms=new ArrayList();
String categoryName="";
String workflowinfoName="";
List layoutlist = new ArrayList();
if(!workflowinfoId.equals("")){
formId=workflowinfoService.get(workflowinfoId).getFormid();
workflowinfoName=workflowinfoService.get(workflowinfoId).getObjname();
forms=notifyDefineService.getForminfos(formId,forms);
String strDefHql = "from Formlayout where formid='" + formId + "'";
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
List listdef = formlayoutService.findFormlayout(strDefHql);
layoutlist.addAll(listdef);
}else{
    if(!categoryId.equals("")){
    formId=categoryService.getCategoryById(categoryId).getFormid();
    categoryName=categoryService.getCategoryById(categoryId).getObjname();
    forms=notifyDefineService.getForminfos(formId,forms);
    String strDefHql = "from Formlayout where formid='" + formId + "'";
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    List listdef = formlayoutService.findFormlayout(strDefHql);
    layoutlist.addAll(listdef);
    }
}
%>
 <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=addDetail" name="EweaverForm"  method="post">
   <input type="hidden" name="actionId" value="<%=actionId%>">
   <input type="hidden" name="id" value="<%=id%>">
 <table class=noborder>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	

	  <tr>
    	<td class="Line" colspan=100% nowrap></td>		        	  
	  </tr>
     <tr>
	    <td class="FieldName" nowrap>
			任务名称
	   </td>
	   <td class="FieldValue">
	        <input name="objName"  class="InputStyle2" style="width:95%" value="<%=objName%>">
		</td>
	 </tr>

        <tr id="istypetr">
            <td class="FieldName" nowrap>
              是否通过流程
            <td class="FieldValue">
                <select name="istype" onChange="istypeChanged()">
                    <option value="1" <%if(workflowinfoId==""||workflowinfoId==null){%>selected<%}%>>否</option>
                    <option value="2" <%if(!"".equals(workflowinfoId)&&workflowinfoId!=null){%>selected<%}%>>是</option>
                </select>
            </td>
        </tr>

        <tr id="typetr">
            <td class="FieldName" nowrap>
              类型
            <td class="FieldValue">
                <select name="type" onChange="optionChanged()">
                    <option value="1" <%if(type==1){%>selected<%}%>>授权</option>
                    <option value="2" <%if(type==2){%>selected<%}%>>移交</option>
                </select>
            </td>
        </tr>

     <tr id="workflowinfotr" <%if(workflowinfoId==""||workflowinfoId==null){%>style="display:none"<%}%>>
	    <td class="FieldName" nowrap>
			流程
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflowinfoId','workflowinfoIdspan','1');"></button>
			 <input type="hidden"   name="workflowinfoId" value="<%=workflowinfoId%>" />
			 <span id = "workflowinfoIdspan" ><%=workflowinfoName%></span>
		</td>
	 </tr>

     <tr id="categorytr" <%if(!"".equals(workflowinfoId)&&workflowinfoId!=null){%>style="display:none" <%}%>>
	    <td class="FieldName" nowrap>
			分类
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','categoryId','categoryIdspan','1');"></button>
			 <input type="hidden"   name="categoryId" value="<%=categoryId%>" />
			 <span id = "categoryIdspan" ><%=categoryName%></span>
		</td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			表单
	   </td>
	   <td class="FieldValue">
	        <select name="formId" onchange="getOptions(this.value)">
               <%for(Object form:forms){
                   String formName=((Forminfo)form).getObjname();
                   formId= ((Forminfo)form).getId();
               %>
               <option value="<%=formId%>" <%if(realFormId.equals(formId)){%>selected<%}%>><%=formName%></option>
               <%}%>
           </select>
		</td>
	 </tr>
	 
	 <tr <%if(type!=2){%>style='display:none'<%}%> id="fieldIdtr">
	    <td class="FieldName" nowrap>
			字段
	   </td>
	   <td class="FieldValue">	
           <select name="fieldId">

           </select>
		</td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			主表单关联字段
	   </td>
	   <td class="FieldValue">
           <select name="unionFieldId">

           </select>
		</td>
	 </tr>
     <tr <%if(type==2){%>style='display:none'<%}%> id="optTypetr">
	   <td class="FieldName" nowrap>
			权限类型
	   </td>
		<td class="FieldValue">
            <input type='checkbox' name="optType"  class="InputStyle2" value="3" <%if(optType.indexOf("3")>-1){%>checked<%}%>>查看<br>
            <input type='checkbox' name="optType"  class="InputStyle2" value="15" <%if(optType.indexOf("15")>-1){%>checked<%}%>>编辑<br>
            <input type='checkbox' name="optType"  class="InputStyle2" value="105" <%if(optType.indexOf("105")>-1){%>checked<%}%>>删除<br>
            <input type='checkbox' name="optType"  class="InputStyle2" value="165" <%if(optType.indexOf("165")>-1){%>checked<%}%>>共享
        </td>
	 </tr>	
	 <tr <%if(type==2){%>style='display:none'<%}%> id="viewLayoutIdtr">
	   <td class="FieldName" nowrap>显示布局</td>
		<td class="FieldValue">
            <select class="inputstyle" style="width:180px"  name="viewLayoutId" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                String selected = "";%>
                <option value=<%=formlayout.getId()%> <%if(viewLayoutId.equals(formlayout.getId())){%>selected<%}%>><%=formlayout.getLayoutname()%></option>
            <%}%>
            </select>
            优先级
            <INPUT type=text class="InputStyle2"   name="viewPriority" MAXLENGTH =3 value="<%=viewPriority%>">
         </td>
     </tr>
	 <tr <%if(type==2){%>style='display:none'<%}%> id="editLayoutIdtr">
	   <td class="FieldName" nowrap>
			编辑布局
	   </td>
		<td class="FieldValue">
        <select class="inputstyle" style="width:180px"  name="editLayoutId" >
            <option value=""></option>
            <%
            for(int i=0; i<layoutlist.size(); i++){
                Formlayout formlayout=(Formlayout)layoutlist.get(i);
                String selected = "";%>
                <option value=<%=formlayout.getId()%> <%if(editLayoutId.equals(formlayout.getId())){%>selected<%}%>><%=formlayout.getLayoutname()%></option>
            <%}%>
            </select>
            优先级
            <INPUT type=text class="InputStyle2"   name="editPriority" MAXLENGTH =3 value="<%=editPriority%>">
        </td>
	 </tr>	
	 

	  <tr>
    	<td class="Line" colspan=100% nowrap></td>		        	  
	  </tr>	
	  

	</table>     
 </form>
<script language="javascript"> 
function onSubmit(){
    var type=document.EweaverForm.type;
    var fieldId=document.EweaverForm.fieldId;
    if(type.value=="2"){
        if(fieldId.value==null||fieldId.value==""){
            alert("对不起,字段选择项不能为空.");
            return;
        }
    }
    checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
           document.EweaverForm.submit();
   	}  	
}
function onReturn(){
    window.location="<%=request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionModify.jsp?id=<%=actionId%>" ;
}
function check(){
	checkmessage="<%=labelService.getLabelName("402881e70caedf88010caf372e450010")%>";
   	alert(document.all("fieldtype").value);
   	if(document.all("fieldtype").value == "整数" || document.all("fieldtype").value == "浮点数"){
   	alert("aa");
   		return true;
   	}else{
   	 	alert(checkmessage);
   	 	document.all("issum").value == 0;
   	 	return false;
   	}
}
function getOptions(formId){
    if(formId!=""){
        FormfieldService.getFieldByForm(formId,6,'402881e70bc70ed1010bc75e0361000f',callback);
        FormfieldService.getAllFieldByFormIdExist(formId,callback2);
    }
}
function callback(list){
    DWRUtil.removeAllOptions("fieldId");
    DWRUtil.addOptions("fieldId",list,"id","fieldname");
   <%if(!fieldId.equals("")){%>
    var objselect = document.all("fieldId");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=fieldId%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}
function callback2(list){
    DWRUtil.removeAllOptions("unionFieldId");
    var oOption = document.createElement("OPTION");
    document.forms[0].unionFieldId.options.add(oOption);
    oOption.innerText ="requestid";
    oOption.value = "requestid";
    DWRUtil.addOptions("unionFieldId",list,"id","fieldname");
   <%if(!unionFieldId.equals("")){%>
    var objselect = document.all("unionFieldId");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=unionFieldId%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}

getOptions(document.all("formId").value);

    function optionChanged(){
        var mySelect=document.EweaverForm.type;
        var istype=document.EweaverForm.istype;
        if(istype.value=="2"&&mySelect.value=="2"){
            alert("对不起,选择通过流程后,类型只为为授权!");
            mySelect.value="1";
        }
        if(mySelect.value=="1"){
            document.getElementById("optTypetr").style.display="block";
            document.getElementById("viewLayoutIdtr").style.display="block";
            document.getElementById("editLayoutIdtr").style.display="block";
            document.getElementById("fieldIdtr").style.display="none";
        }else{
            document.getElementById("optTypetr").style.display="none";
            document.getElementById("viewLayoutIdtr").style.display="none";
            document.getElementById("editLayoutIdtr").style.display="none";
            document.getElementById("fieldIdtr").style.display="block";
        }
    }
    function istypeChanged(){
        var mySelect=document.EweaverForm.istype;
        var type=document.EweaverForm.type;
        var formId=document.EweaverForm.formId;
        var fieldId=document.EweaverForm.fieldId;
        var unionFieldId=document.EweaverForm.unionFieldId;
        if(mySelect.value=="2"){
            document.getElementById("workflowinfotr").style.display="block";
            document.getElementById("categorytr").style.display="none";
            document.getElementById("optTypetr").style.display="block";
            document.getElementById("viewLayoutIdtr").style.display="block";
            document.getElementById("editLayoutIdtr").style.display="block";
            document.getElementById("fieldIdtr").style.display="none";
            document.getElementById("workflowinfoIdspan").innerText="";
            document.getElementById("categoryIdspan").innerText="";
            type.options[0].selected=true;
            for(var i=0;i<formId.length;){
                formId.remove(0);
            }
            for(var j=0;j<fieldId.length;){
                fieldId.remove(0);
            }
            for(var k=0;k<unionFieldId.length;){
                unionFieldId.remove(0);
            }
        }else{
            document.getElementById("workflowinfotr").style.display="none";
            document.getElementById("categorytr").style.display="block";
            document.getElementById("workflowinfoIdspan").innerText="";
            document.getElementById("categoryIdspan").innerText="";
            for(var i=0;i<formId.length;){
                formId.remove(0);
            }
            for(var j=0;j<fieldId.length;){
                fieldId.remove(0);
            }
            for(var k=0;k<unionFieldId.length;){
                unionFieldId.remove(0);
            }
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
        window.location="permissionBatchActionDetailCreate.jsp?actionId=<%=actionId%>&iscallback=true&type="+document.all("type").value+"&"+inputname+"="+id[0]+"&id=<%=id%>"
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script> 
  </body>
</html>
