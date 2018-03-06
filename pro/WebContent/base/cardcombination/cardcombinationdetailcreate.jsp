<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.base.security.model.Cardcombinationdetail" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
    String id = StringHelper.null2String(request.getParameter("id"));
   String actionId = StringHelper.null2String(request.getParameter("actionId"));
    CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");

    String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
    String formId="";//分类上的表单定义
    String actionformId="";
    String fieldid="";
    String changfield="";
    String actionchangefield="";
      String changfield2="";
    String actionchangefield2="";
         String changfield3="";
    String actionchangefield3="";
    String realFormId="";
    String objname=StringHelper.null2String(request.getParameter("objname"));
    String unionFieldId="";
    String categoryName="";
    List forms=new ArrayList();
      CardCombinationService cardCombinationService = (CardCombinationService) BaseContext.getBean("cardCombinationService");
        Cardcombination cbin = cardCombinationService.getCardBination(actionId);
         actionformId=cbin.getFormid();
    if (!id.equals("")) {

        for (Object o : cbin.getActionDetails()) {
             Cardcombinationdetail actDetail = (Cardcombinationdetail) o;
             if(id.equals(actDetail.getId())){
                if(categoryid==null||"".equals(categoryid)){
                    categoryid= StringHelper.null2String(actDetail.getCategoryid());
                }

                realFormId=StringHelper.null2String(actDetail.getFormid());
                objname=StringHelper.null2String(actDetail.getObjname());
                fieldid=StringHelper.null2String(actDetail.getFieldid());
                 changfield=StringHelper.null2String(actDetail.getChangfield());
                 actionchangefield=StringHelper.null2String(actDetail.getActionchangefield());
                  changfield2=StringHelper.null2String(actDetail.getChangefield2());
                 actionchangefield2=StringHelper.null2String(actDetail.getActionchangefield2());
                  changfield3=StringHelper.null2String(actDetail.getChangefield3());
                 actionchangefield3=StringHelper.null2String(actDetail.getActionchangefield3());

                 break;
             }
        }
    }
   if(!categoryid.equals("")){
    formId=categoryService.getCategoryById(categoryid).getFormid();
    categoryName=categoryService.getCategoryById(categoryid).getObjname();
    forms=notifyDefineService.getForminfos(formId,forms);
    }

    FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");


%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
<html>
  <head>
   <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <style type="text/css">
     #pagemenubar table {width:0}
</style>
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
<div id="pagemenubar"></div>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=addDetail" name="EweaverForm" method="post">
 <input type="hidden" name="actionid" value="<%=actionId%>"/>
 <input type="hidden" name="id" value="<%=id%>"/>
		       <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
		        <tr class=Title>

					<th colspan=2 nowrap></th>
                     <th/>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldName" nowrap>
					    <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790054")%><!-- 任务名 -->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" id="objname" value="<%=objname%>" />
						<img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
					</td>
				</tr>

                 <tr>
                      <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%><!-- 分类 -->
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/category/categorybrowser.jsp','categoryid','categoryIdspan','1');"></button>
			 <input type="hidden"   name="categoryid" value="<%=categoryid%>"/>
			 <span id = "categoryIdspan"><%=categoryName%></span>
		</td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
	   </td>
	   <td class="FieldValue">
	        <select name="formid" onchange="getOptions(this.value)">
               <%for(Object form:forms){
                   String formName=((Forminfo)form).getObjname();
                   formId= ((Forminfo)form).getId();
               %>
               <option value="<%=formId%>" <%if(realFormId.equals(formId)){%>selected<%}%>><%=formName%></option>
               <%}%>
           </select>
		</td>
	 </tr>

	 <tr id="fieldIdtr">
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790055")%><!-- 与主表关联字段 -->
	   </td>
	   <td class="FieldValue">
           <select name="fieldid">

           </select>
		</td>
	 </tr>

                   <tr>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790056")%><!-- 变更字段1 -->
                       </td>
                       <td class="FieldValue">
                          <table>
                              <tr>
                                  <td><select name="changfield" onchange="changfield1(this)"></select></td>
                                   <td id="actionchangetr" width="" <%if(StringHelper.isEmpty(changfield)){%>style="display:none"<%}%>> <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790057")%> <select name="actionchangefield"> </select></td><!-- 主表对应的字段1 -->
                              </tr>
                          </table>
                       </td>
                   </tr>

                  <tr>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790058")%><!-- 变更字段2 -->
                       </td>
                       <td class="FieldValue">
                           <table>
                               <tr>
                                   <td><select name="changfield2" onchange="changfield1(this)"></select></td>
                                    <td id="actionchangetr2" width="" <%if(StringHelper.isEmpty(changfield2)){%>style="display:none"<%}%>> <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790059")%> <!-- 主表对应的字段2 --><select name="actionchangefield2">
                                </select></td>
                               </tr>
                           </table>
                       </td>
                   </tr>
                                      <tr>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379005a")%><!-- 变更字段3 -->
                       </td>
                       <td class="FieldValue" >
                              <table>
                               <tr>
                                   <td><select name="changfield3" onchange="changfield1(this)"></select></td>
                                    <td id="actionchangetr3" width="" <%if(StringHelper.isEmpty(changfield3)){%>style="display:none"<%}%>> <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379005b")%><!-- 主表对应的字段3 --> <select name="actionchangefield3">
                                </select></td>
                               </tr>
                           </table>

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
    </form>
<script type="text/javascript">
    function onSubmit(){
           checkfields="";
           checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
           if(checkForm(EweaverForm,checkfields,checkmessage)){
               document.EweaverForm.submit();
           }
    }

    function onReturn(){
        document.location.href="<%=request.getContextPath()%>/base/cardcombination/cardcombinationlist.jsp";

    }
function getOptions(formId){
    if(formId!=""){
        FormfieldService.getAllFieldByFormIdExist(formId, callback2);
        FormfieldService.getAllFieldByFormIdExist(formId, callback3);
        FormfieldService.getAllFieldByFormIdExist(formId, callback7);
        FormfieldService.getAllFieldByFormIdExist(formId, callback8);
    }
}
function getMainoptions(formId){
         if(formId!=""){
             <%
             if(!StringHelper.isEmpty(changfield)){
                  Formfield formfield=formfieldService.getFormfieldById(changfield);
                  int htmltype=formfield.getHtmltype();
                  String fieldtype=formfield.getFieldtype();
             %>
             var htmltype='<%=htmltype%>';
             var fieldtype='<%=fieldtype%>';
             FormfieldService.getFieldByForm(formId,htmltype,fieldtype,callback4);
             <%}%>
             <%
               if(!StringHelper.isEmpty(changfield2)){
                Formfield formfield=formfieldService.getFormfieldById(changfield2);
                  int htmltype=formfield.getHtmltype();
                  String fieldtype=formfield.getFieldtype();
             %>
              var htmltype='<%=htmltype%>';
             var fieldtype='<%=fieldtype%>';
             FormfieldService.getFieldByForm(formId,htmltype,fieldtype,callback5);
             <%}%>
              <%
               if(!StringHelper.isEmpty(changfield3)){
                 Formfield formfield=formfieldService.getFormfieldById(changfield3);
                  int htmltype=formfield.getHtmltype();
                  String fieldtype=formfield.getFieldtype();
              %>
              var htmltype='<%=htmltype%>';
             var fieldtype='<%=fieldtype%>';
             FormfieldService.getFieldByForm(formId,htmltype,fieldtype,callback6);
             <%}%>

         }
}
function callback2(list){
    DWRUtil.removeAllOptions("fieldid");
    DWRUtil.addOptions("fieldid",list,"id","fieldname");
   <%if(!fieldid.equals("")){%>
    var objselect = document.all("fieldid");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=fieldid%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    <%}%>
}
    function callback3(list) {
        var objselect = document.all('changfield');
        DWRUtil.removeAllOptions("changfield");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText = " ";
        oOption.value = "";
        DWRUtil.addOptions("changfield", list, "id", "fieldname");
        var objselect = document.all("changfield");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=changfield%>') {
                objselect.options[i].selected = true;
                break;
            }
        }

    }
    function callback4(list) {
        var objselect = document.all('actionchangefield');
        DWRUtil.removeAllOptions("actionchangefield");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText = " ";
        oOption.value = "";
        DWRUtil.addOptions("actionchangefield", list, "id", "fieldname");
        var objselect = document.all("actionchangefield");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=actionchangefield%>') {
                objselect.options[i].selected = true;
                break;
            }
        }

    }
    function callback5(list) {
        var objselect = document.all('actionchangefield2');
        DWRUtil.removeAllOptions("actionchangefield2");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText = " ";
        oOption.value = "";
        DWRUtil.addOptions("actionchangefield2", list, "id", "fieldname");
        var objselect = document.all("actionchangefield2");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=actionchangefield2%>') {
                objselect.options[i].selected = true;
                break;
            }
        }

    }
    function callback6(list) {
        var objselect = document.all('actionchangefield3');
        DWRUtil.removeAllOptions("actionchangefield3");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText = " ";
        oOption.value = "";
        DWRUtil.addOptions("actionchangefield3", list, "id", "fieldname");
        var objselect = document.all("actionchangefield3");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=actionchangefield3%>') {
                objselect.options[i].selected = true;
                break;
            }
        }

    }
        function callback7(list){
        var objselect=document.all('changfield2');
    DWRUtil.removeAllOptions("changfield2");
         var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText =" ";
        oOption.value = "";
    DWRUtil.addOptions("changfield2",list,"id","fieldname");
    var objselect = document.all("changfield2");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=changfield2%>') {
            objselect.options[i].selected = true;
            break;
        }
        }

}
    function callback8(list) {
        var objselect = document.all('changfield3');
        DWRUtil.removeAllOptions("changfield3");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText = " ";
        oOption.value = "";
        DWRUtil.addOptions("changfield3", list, "id", "fieldname");
        var objselect = document.all("changfield3");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=changfield3%>') {
                objselect.options[i].selected = true;
                break;
            }
        }

    }
getOptions(document.all("formId").value);
getMainoptions('<%=actionformId%>');
 function getBrowser(viewurl,inputname,inputspan,isneed){
     var objname=document.all('objname').value;
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        window.location="cardcombinationdetailcreate.jsp?&id=<%=id%>&actionId=<%=actionId%>&categoryid="+id[0]+"&objname="+objname;

    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
    function changfield1(obj){
        var actionchangetr = document.all('actionchangetr');
        var actionchangetr2 = document.all('actionchangetr2');
        var actionchangetr3 = document.all('actionchangetr3');
        if (obj.name == 'changfield') {
            if (obj.value == '') {
                actionchangetr.style.display = 'none';
                 document.all('actionchangefield').value='';
            } else {
                actionchangetr.style.display = 'block';
                Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=getfieldtype',
                     params:{formfieldid:obj.value},
                     success: function(res) {
                        var rest= res.responseText;
                        var htmltype=rest.substring(0,rest.indexOf(";"));
                       var fieldtype=rest.substring(rest.indexOf(";")+1,rest.length);
                         var formid=document.all("formId").value;
                         FormfieldService.getFieldByForm('<%=actionformId%>',htmltype,fieldtype,callback4);
                     }
                 });
            }
        } else if (obj.name == 'changfield2') {
            if (obj.value == '') {
                actionchangetr2.style.display = 'none';
                document.all('actionchangefield2').value='';

            } else {
                actionchangetr2.style.display = 'block';
                  Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=getfieldtype',
                     params:{formfieldid:obj.value},
                     success: function(res) {
                        var rest= res.responseText;
                        var htmltype=rest.substring(0,rest.indexOf(";"));
                       var fieldtype=rest.substring(rest.indexOf(";")+1,rest.length);
                         FormfieldService.getFieldByForm('<%=actionformId%>',htmltype,fieldtype,callback5);
                     }
                 });
            }
        } else if (obj.name == 'changfield3') {
            if (obj.value == '') {
                actionchangetr3.style.display = 'none';
                document.all('actionchangefield3').value='';

            } else {
                actionchangetr3.style.display = 'block';
                  Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=getfieldtype',
                     params:{formfieldid:obj.value},
                     success: function(res) {
                        var rest= res.responseText;
                        var htmltype=rest.substring(0,rest.indexOf(";"));
                       var fieldtype=rest.substring(rest.indexOf(";")+1,rest.length);
                         FormfieldService.getFieldByForm('<%=actionformId%>',htmltype,fieldtype,callback6);
                     }
                 });
            }
        }


    }
</script>
  </body>
</html>
