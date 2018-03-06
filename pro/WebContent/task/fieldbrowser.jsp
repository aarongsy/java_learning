<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page
	import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page
	import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.task.service.WarnConfigService"%>
<%@ page import="com.eweaver.task.model.WarnConfig"%>
<html>
	<head>
		<script
			src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
		<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
		<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
	</head>
	<body>
		<!-- 标题 -->
		<%
			titlename = labelService
					.getLabelName("402881540c9f83d6010c9f9e49aa0009");
		%>

		<!--页面菜单开始-->
		<%
			pagemenustr += "{S,"
					+ labelService
							.getLabelName("402881e60aabb6f6010aabbda07e0009")
					+ ",javascript:browser_onclick()}";
			pagemenustr += "{C," + labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290042") + ",javascript:setCondition2()}";//生成条件
			pagemenustr += "{R,"
					+ labelService
							.getLabelName("402881e60aabb6f6010aabe32990000f")
					+ ",javascript:window.close()}";
		%>
		<div id="pagemenubar" style="z-index: 100;"></div>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束-->
		<%
			WarnConfigService wconfigService = (WarnConfigService)BaseContext.getBean("warnConfigService");
			String formid = request.getParameter("formid");
			String categoryid = request.getParameter("categoryid");
			String workflowid = request.getParameter("workflowid");
			String condition = request.getParameter("condition");//查询条件
			String conditionText = "";
			if(!StringHelper.isEmpty(condition)) {
				WarnConfig wconfig = wconfigService.get(condition);
				if(wconfig != null) {
					condition = wconfig.getWarnedContent();
					conditionText = wconfig.getConditionText();
				}				
			}
			//System.out.println("------formid:" + formid);
			Map conmap1 = new HashMap();
			Map conmap2 = new HashMap();
			
			ForminfoService forminfoService = (ForminfoService) BaseContext
					.getBean("forminfoService");
			FormfieldService formfieldService = (FormfieldService) BaseContext
					.getBean("formfieldService");
			WorkflowinfoService workflowService = (WorkflowinfoService) BaseContext
					.getBean("workflowinfoService");		
			CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");		
			if(!StringHelper.isEmpty(workflowid)){
				Workflowinfo winfo = workflowService.get(workflowid);
				formid = winfo.getFormid();
			}
			if(!StringHelper.isEmpty(categoryid)){
				Category category = categoryService.getCategoryById(categoryid);
				formid = category.getFormid();
			}
			Forminfo forminfo1 = forminfoService.getForminfoById(formid);
			List forminfolists = new ArrayList();
			if(forminfo1.getObjtype() != null) {			
				if (forminfo1.getObjtype().toString().equals("0")) {//实际表单
					//formfieldlist = formfieldService.getAllFieldByFormId(formid);
					//String objtablename = forminfo.getObjtablename();
					forminfolists.add(forminfo1);
				} else if (forminfo1.getObjtype().toString().equals("1")) {//抽象表单
					//FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
					StringBuffer hql = new StringBuffer(
							"from Forminfo a  where a.id in (");
					hql
							.append(
									"select b.pid from Formlink b where  b.typeid=1 and b.oid='")
							.append(formid).append("')");
					forminfolists = forminfoService.getForminfoListByHql(hql
							.toString());
				}
			}
			String[] checkcons = request.getParameterValues("check_con");
			ArrayList ids = new ArrayList();
			ArrayList colnames = new ArrayList();
			ArrayList opts = new ArrayList();
			ArrayList values = new ArrayList();
			ArrayList names = new ArrayList();
			ArrayList opt1s = new ArrayList();
			ArrayList value1s = new ArrayList();
			ids.clear();
			colnames.clear();
			opt1s.clear();
			names.clear();
			value1s.clear();
			opts.clear();
			values.clear();
		%>
		<FORM NAME=EweaverForm STYLE="margin-bottom: 0"
			action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.task.servlet.ConditionsAction?action=modify"
			method="post">
			<input type=hidden id="conditiontext" name="conditiontext" value="">
			<input type=hidden name=objid value="<%=formid%>">

			<b><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60063") %><!-- 原内容 -->： <TEXTAREA  ROWS="2" COLS="60"
				style="width: 100%" readonly><%=StringHelper.null2String(condition)%></TEXTAREA>
			
			</b>
			<br />
			<b> <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60064") %><!-- 新的内容 -->： </b>
			<br />
			<TEXTAREA NAME="conditions" id="conditions" ROWS="5" COLS="60"
				style="width: 100%"></TEXTAREA>
			<select class=inputstyle name="formname"
				onchange="onChangeShareType()" value="">
				<option value="0">
					<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003b") %><!-- 请选择表单名称 -->：
				</option>
				<%
					for (int k = 0; k < forminfolists.size(); k++) {
						Forminfo forminfo = (Forminfo) forminfolists.get(k);
						String formname1 = forminfo.getObjname();
						String objtablename1 = forminfo.getObjtablename();
				%>
				<option value="<%=objtablename1%>"><%=formname1%></option>
				<%
					}
				%>
			</select>
			<%
				for (int k = 0; k < forminfolists.size(); k++) {
					Forminfo forminfo = (Forminfo) forminfolists.get(k);
					//System.out.println("------formid:" +k+"  " + forminfo.getId());
					List formfieldlist = formfieldService
							.getAllFieldByFormIdExist(forminfo.getId());
					String formname = forminfo.getObjname();
					String objtablename = forminfo.getObjtablename();

					String mstyle = "";
					if (k != 0) {
						mstyle = "none";
					}
			%>

			<table width=100% class=viewform id="<%=objtablename%>"
				style="display:'<%=mstyle%>'">

				<B>
					<tr>
						<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %><!-- 表单名称 -->：<%=formname%>
					</tr> </B>

				<%
					int linecolor = 0;
						int tmpcount = 0;
						boolean showsep = true;
						String fieldname = "";
						//System.out.println("------formfieldlist.size():" + formfieldlist.size());
						Iterator fieldit = formfieldlist.iterator();
						while (fieldit.hasNext()) {
							Formfield formfield = (Formfield) fieldit.next();

							tmpcount += 1;
							String id = formfield.getId();

							String htmltype = String.valueOf(formfield.getHtmltype());
							String type = StringHelper.null2String(formfield
									.getFieldtype());

							String _fieldid = StringHelper.null2String(formfield
									.getId());
							String _formid = StringHelper.null2String(formfield
									.getFormid());
							String _fieldname = StringHelper.null2String(formfield
									.getFieldname());
							String _htmltype = StringHelper.null2String(formfield
									.getHtmltype());
							String _fieldtype = StringHelper.null2String(formfield
									.getFieldtype());
							String _fieldattr = StringHelper.null2String(formfield
									.getFieldattr());
							String _fieldcheck = StringHelper.null2String(formfield
									.getFieldcheck());
							String _style = "";
							String _value = "";

							fieldname = formfield.getFieldname();
							String label = formfield.getLabelname();
				%>
				<INPUT TYPE="hidden" name="con<%=id%>_value_fieldname"
					value="<%=fieldname%>">
				<INPUT TYPE="hidden" name="con<%=id%>_value_objtablename"
					value="<%=objtablename%>">
				<INPUT TYPE="hidden" name="con<%=id%>_value1_fieldname"
					value="<%=fieldname%>">
				<INPUT TYPE="hidden" name="con<%=id%>_value1_objtablename"
					value="<%=objtablename%>">

				<tr class=title>
					<%
						if (!htmltype.equals("3") && !htmltype.equals("7")) {
					%>
					<td class="FieldName">
						<INPUT TYPE="checkbox" NAME="check_con<%=id%>"
							id="check_con<%=id%>" onclick="addfield2('con<%=id%>_value')">
					</td>
					<td class="FieldName"><span id="con<%=id%>_value_field"><%=StringHelper.null2String(label)%></span></td>

					<%
						}								
							}
						}
					%>
				</tr>

			</table>



		</FORM>
		<SCRIPT LANGUAGE=VBS>
sub onShowMultiPropValue(objval,inputname)
	tmp = document.all(inputname&"_value").value
	fieldname = document.all(inputname+"_fieldname").value
	objtablename = document.all(inputname+"_objtablename").value
	id1 = window.showModalDialog("<%=request.getContextPath()%>/systeminfo/BrowserMain.jsp?url=<%=request.getContextPath()%>/props/data/PropValueBrowser.jsp?sqlwhere= where propid="&objval&"&resourceids="&tmp)
	if (Not IsEmpty(id1)) then
	if id1(0)<> "" then
		alert(inputname)
		propvalueids = id1(0)
		propvaluenames = id1(1)
		sHtml = propvaluenames
		document.all(inputname&"_value").value= propvalueids

		document.all(inputname&"_valuespan").innerHtml = sHtml
		document.all(inputname&"_name").value= sHtml
		addfield(inputname)	
	else 
		document.all(inputname&"_value").value= ""
		document.all(inputname&"_name").value= ""
		document.all(inputname&"_valuespan").innerHtml = ""
	end if
	end if
end sub

</script>

	</BODY>
</HTML>
<script language=vbs>


sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
		addfield(inputname)	
	end if
end sub
sub gettime(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/clock.jsp",,"dialogHeight:320px;dialogwidth:275px")

	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	addfield(inputname)	
	end if
end sub
</script>


<SCRIPT language=VBS>

Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
    function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var id;
    try{
    id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid);
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
<!--
function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService
							.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

var allfield = new Array();
var allfieldStr="";
function addfield(input){
	document.all("check_" + input.substr(0,input.indexOf("_value"))).checked=true;
	
	var len = allfield.length;
	if(allfieldStr.indexOf(input)==-1){
		allfield[len]=input;
		allfieldStr+=input;
	}
}

function addfield2(input){
	if(document.all("check_" + input.substr(0,input.indexOf("_value"))).checked){
		var len = allfield.length;
		if(allfieldStr.indexOf(input)==-1){
			allfield[len]=input;
			allfieldStr+=input;
		}
	}
}
function setCondition2(){

	document.all("conditions").value="";
	var condition="";
	var conditiontext = "";
	for(var i=0; i<allfield.length; i++){
		var input = allfield[i];
		var fieldname = document.all(input + "_fieldname").value;
		var field = document.all(input + "_field");
		var objtable = document.all(input + "_objtablename");
		var fieldtext = field.innerText;
		//var objtabletext = objtable.options[objtable.selectedIndex].text;
		var objtablename = document.all(input + "_objtablename").value;		
		if(document.all("check_" + input.substr(0,input.indexOf("_value"))).checked){
			fieldname = objtablename.toLowerCase() + '.' + fieldname.toLowerCase();
			condition = '{'+fieldname+'}';
			conditiontext = '{'+fieldtext+'}';
			document.all("conditions").value += condition;		
			document.all("conditiontext").value += conditiontext;				
		}
	}
}

function browser_onclick(){
	var conditions = document.all("conditions").value;
	var conditiontext = document.all("conditiontext").value;
	
	var rvalue = new Array(conditions,conditiontext);
	window.parent.returnValue = rvalue;
    window.parent.close();
}

function onChangeShareType(){
	var id = document.all("formname").value;
	var len=document.all("formname").length;
	for(var i=1; i<len; i++){
		var tempid = document.all("formname")[i].value;
		if(tempid==id){
			document.all(tempid).style.display = '';
		}else{
			document.all(tempid).style.display = 'none';
		}
	}	
}
function isDigit(s)
{
var patrn=/^[0-9]{1,20}$/;
if (!patrn.exec(s)) return false
return true
} 

function fillotherselect(elementobj,fieldid,rowindex){
	addfield("con" +fieldid + "_value");
	
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";
	
	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)
		
	if(fieldcheck=="")
		return;
		
//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql = "select ''  id,' '  objname union (select id,objname from selectitem where pid = '"+elementvalue+"')";
	<%if (dbtype.equals("2")) {%> sql = "select ''  id,' '  objname from dual union (select id,objname from selectitem where pid = '"+elementvalue+"')"; <%}%>

	DataService.getValues(sql,{          
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);
   	
}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;
			
			if(document.getElementById(objname) == null){
				return;
			}

			DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
//-->
</SCRIPT>
<script type="text/javascript">
             function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态(找出为空的数据)
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}
</script>
