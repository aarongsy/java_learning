<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
    ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");

    String reportId = StringHelper.null2String(request.getParameter("reportId"));
    int type=NumberHelper.getIntegerValue(request.getParameter("type"),1);
    String reportName="";
    String formId="";//分类上的表单定义
    String fieldId="";
    List forms=new ArrayList();
    List layoutlist = new ArrayList();
    if(!reportId.equals("")){
    Reportdef reportdef=reportdefService.getReportdef(reportId);
    formId=reportdef.getFormid();
    reportName=reportdef.getObjname();
    forms=notifyDefineService.getForminfos(formId,forms);
    String strDefHql = "from Formlayout where formid='" + formId + "'";
    List listdef = formlayoutService.findFormlayout(strDefHql);
    layoutlist.addAll(listdef);
    }
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<html>
  <head>
   <script src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%=request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('/images/book.gif'); margin-bottom: 4}
</Style>
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
<script language="javascript">
function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}
function onfocusDo1(){
         if(document.EweaverForm.operationObj.value=="操作对象"){
            document.EweaverForm.operationObj.value="";
         }
}
function onfocusDo2(){
         if(document.EweaverForm.targetObj.value=="目标对象"){
            document.EweaverForm.targetObj.value="";
         }
}
function onblurDo1(){
         if(document.EweaverForm.operationObj.value==""){
             document.EweaverForm.operationObj.value="操作对象";
         }
}
function onblurDo2(){
         if(document.EweaverForm.targetObj.value==""){
             document.EweaverForm.targetObj.value="目标对象";
         }
}
function optionChanged(){
    var mySelect=document.EweaverForm.type;
    for(var i=0;i<mySelect.length;i++){
        if(mySelect.options[i].selected==true){
            window.location="permissionBatchActionCreate.jsp?type="+mySelect.options[i].value+"&reportId=<%=reportId%>";
        }
    }
}
</script>
  </head> 
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionBatchActionAction?action=create" name="EweaverForm" method="post">
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
		        <tr class=Title>
					
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e80ca5d67a010ca5e168090006")%><!--报表信息--></th>
                     <th/>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        	
				<tr>
					<td class="FieldName" nowrap>
					    操作名
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" />
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
					</td>
				</tr>

				<tr>
					<td class="FieldName" nowrap>
					  类型
					<td class="FieldValue">
					    <select name="type" onChange="optionChanged()">
                            <option value="1" <%if(type==1){%>selected<%}%>>授权</option>
                            <option value="2" <%if(type==2){%>selected<%}%>>移交</option>
                        </select>
                    </td>
				</tr>

                 <tr>
                    <td class="FieldName" nowrap>
                        报表
                   </td>
                   <td class="FieldValue">
                         <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/report/reportbrowser.jsp','reportId','reportIdspan','1');"></button>
                         <input type="hidden"   name="reportId" value="<%=reportId%>" />
                         <span id = "reportIdspan" ><%=reportName%></span>
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
                           <option value="<%=formId%>" ><%=formName%></option>
                           <%}%>
                       </select>
                    </td>
                 </tr>
                 <tr <%if(type==1){%>style='display:none'<%}%>>
                    <td class="FieldName" nowrap>
                        字段
                   </td>
                   <td class="FieldValue">
                       <select name="fieldId">

                       </select>
                    </td>
                 </tr>                
                 <tr <%if(type==2){%>style='display:none'<%}%>>
                   <td class="FieldName" nowrap>
                        权限类型
                   </td>
                    <td class="FieldValue">
                        <input type='checkbox' name="optType"  class="InputStyle2" value="3" >查看<br>
                        <input type='checkbox' name="optType"  class="InputStyle2" value="15" >编辑<br>
                        <input type='checkbox' name="optType"  class="InputStyle2" value="105" >删除<br>
                        <input type='checkbox' name="optType"  class="InputStyle2" value="165" >共享
                    </td>
                 </tr>
                 <tr <%if(type==2){%>style='display:none'<%}%>>
                   <td class="FieldName" nowrap>显示布局</td>
                    <td class="FieldValue">
                        <select class="inputstyle" style="width:180px"  name="viewLayoutId" >
                        <option value=""></option>
                        <%
                        for(int i=0; i<layoutlist.size(); i++){
                            Formlayout formlayout=(Formlayout)layoutlist.get(i);
                            String selected = "";%>
                            <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
                        <%}%>
                        </select>
                        优先级
                        <INPUT type=text class="InputStyle2"   name="viewPriority" MAXLENGTH =3>
                     </td>
                 </tr>
                 <tr <%if(type==2){%>style='display:none'<%}%>>
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
                            <option value=<%=formlayout.getId()%>><%=formlayout.getLayoutname()%></option>
                        <%}%>
                        </select>
                        优先级
                        <INPUT type=text class="InputStyle2"   name="editPriority" MAXLENGTH =3>
                    </td>
                 </tr>
				<tr>

                <tr>
					<td class="FieldName" nowrap>
					  卡片类型
					<td class="FieldValue">
                        <select class="inputstyle" style="width:180px"  name="cardtype" >
                            <option value=0 >结果包含流程和表单</option>
                            <option value=1 >结果仅包含表单卡片</option>
                            <option value=2 >结果仅包含流程卡片</option>
                        </select>
                    </td>
				</tr>

                <tr>
					<td class="FieldName" nowrap>
					  操作对象名称
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%;color:#666666" name="operationObj" value="操作对象" onfocus="onfocusDo1()" onblur="onblurDo1()"/>
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
				</tr>
				<tr>                                
					<td class="FieldName" nowrap>
					  目标对象名称
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%;color:#666666" name="targetObj" value="目标对象" onfocus="onfocusDo2()" onblur="onblurDo2()"/>
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
                    </td>
				</tr>

                <tr>
					<td class="Line" colspan=100% nowrap>
					</td>
		        </tr>

		        <tr class=Title>
					<th colspan=2 nowrap>操作描述</th>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="objdesc"></TEXTAREA>
					</td>
				</tr>

</table>

			
			<br>
    
</td>
    </tr>
    </table>
    </form>
<script type="text/javascript">
     function onReturn(){
        document.location.href="<%=request.getContextPath()%>/base/security/permissionBatchAction/permissionBatchActionList.jsp";

    }
function getOptions(formId){
    if(formId!="")
    FormfieldService.getFieldByForm(formId,6,'402881e70bc70ed1010bc75e0361000f',callback)
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
getOptions(document.all("formId").value);
      function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        window.location="permissionBatchActionCreate.jsp?type=<%=type%>&reportId="+id[0]
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
