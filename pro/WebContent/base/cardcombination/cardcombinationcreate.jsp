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
    String objname=StringHelper.null2String(request.getParameter("objname"));
    String reportId = StringHelper.null2String(request.getParameter("reportId"));
    String reportName="";
    String comFieldId="";
    String formId="";//分类上的表单定义
    String fieldId="";
    List forms=new ArrayList();
    if(!reportId.equals("")){
    Reportdef reportdef=reportdefService.getReportdef(reportId);
    formId=reportdef.getFormid();
    reportName=reportdef.getObjname();
    forms=notifyDefineService.getForminfos(formId,forms);

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
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
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

           //alert(document.EweaverForm.action);
           document.EweaverForm.submit();
   	}
}

</script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=create" name="EweaverForm" method="post">
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
					    <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790052")%><!-- 操作名 -->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" value="<%=objname%>" />
						<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
					</td>
				</tr>

                 <tr>
                      <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402881f00c9078ba010c907b291a0006")%><!-- 报表 -->
	   </td>
	    <td class="FieldValue">
                         <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/report/reportbrowser.jsp','reportId','reportIdspan','1');"></button>
                         <input type="hidden"   name="reportId" value="<%=reportId%>" />
                         <span id = "reportIdspan" ><%=reportName%></span>
                    </td>
	 </tr>
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
	   </td>
	   <td class="FieldValue">
	        <select name="formId" onchange="getOptions(this.value)">
               <%for(Object form:forms){
                   String formName=((Forminfo)form).getObjname();
                   formId= ((Forminfo)form).getId();
               %>
               <option value="<%=formId%>"><%=formName%></option>
               <%}%>
           </select>
		</td>
	 </tr>

                   <tr>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790053")%><!-- 合并模糊查询字段 -->
                       </td>
                       <td class="FieldValue">
                           <select name="comFieldId">
                           </select>
                       </td>
                   </tr>


		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 --></th>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 name="description"></TEXTAREA>
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
        document.location.href="<%=request.getContextPath()%>/base/cardcombination/cardcombinationlist.jsp";
       
    }
function getOptions(formId){
    if(formId!=""){

       FormfieldService.getAllFieldByFormIdExist(formId,callback2);
    }
}

function callback2(list){
    DWRUtil.removeAllOptions("comFieldId");
    DWRUtil.addOptions("comFieldId",list,"id","fieldname");
   <%if(!comFieldId.equals("")){%>
    var objselect = document.all("unionFieldId");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=comFieldId%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}

getOptions(document.all("formId").value);
     function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    var objname=document.all("objname").value;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
          window.location="cardcombinationcreate.jsp?reportId="+id[0]+"&objname="+objname;
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
