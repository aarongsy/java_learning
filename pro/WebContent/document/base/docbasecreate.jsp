<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.word.service.WordModuleService"%>
<%@page import="com.eweaver.word.model.WordModule"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.document.base.model.Docattach"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%
String pid = StringHelper.trimToNull(request.getParameter("pid"));
String title = StringHelper.getDecodeStr(StringHelper.null2String(request.getParameter("title")));
String targetUrl = StringHelper.null2String(request.getParameter("targetUrl"));
String categoryid = StringHelper.trimToNull(request.getParameter("categoryid"));
String needcheck = StringHelper.null2String(request.getParameter("needcheck"));
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
FormService fs = (FormService) BaseContext.getBean("formService");
WordModuleService wordModuleService = (WordModuleService)BaseContext.getBean("wordModuleService");
Map initparameters = new HashMap();
Map parameters = new HashMap();
String sqltype = SqlHelper.getConcatStr();//数据SQL语句连接类型
String isnull = SqlHelper.getisnullStr();//判断是否为空的
String sqlviewurl = "select a.objname"+sqltype +"' ( '"+sqltype +isnull+"(a.objno,'"+"')"+sqltype +"' , '"+sqltype +isnull+"(b.objname,'"+"')"+sqltype + "' )' as objname ,a.id as objid from humres a,orgunit b where a.orgid=b.id and a.isdelete=0 and a.hrstatus='4028804c16acfbc00116ccba13802935' and a.objname like ?";
sqlviewurl = StringHelper.getEncodeStr(sqlviewurl);//对于SQL语句进行转义。因为在后面URL中不能出现+。
if (!StringHelper.isEmpty(pid)) {//回复
	title = labelService.getLabelNameByKeyId("402881e50b60af4a010b60e027890002")+"：" + docbaseService.getDocbase(pid).getSubject();
}
String allparmsurlstr = "";
for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
	String paraname = e.nextElement().toString().trim();
	String paravalue = StringHelper.trimToNull(request.getParameter(paraname));
	if (!StringHelper.isEmpty(paraname)	&& !StringHelper.isEmpty(paravalue)	&& !"lastdocid".equals(paraname)&&!"categoryid".equals(paraname)) {
		allparmsurlstr += "&" + paraname + "="+ URLEncoder.encode(paravalue, "UTF-8");
		initparameters.put(paraname,paravalue);
	}
}
allparmsurlstr += "&lastdocid=";
String targetUrl2 = request.getContextPath()+ "/document/base/docbasecreate.jsp?1=1" + allparmsurlstr;

int showreply = 1;
Category category = categoryService.getCategoryById(categoryid);
String templetContent = ""; String wordTemplateAttachId = ""; String excelTemplateAttachId = "";
if(!StringHelper.isEmpty(category.getRefHtmlTemplateId())){
	WordModule wordModule = wordModuleService.getWordModule(category.getRefHtmlTemplateId());
	if(!StringHelper.isEmpty(wordModule.getOrgids())){
		if(wordModuleService.checkTemplatePermissionByOrgid(wordModule.getOrgids()) || isSysAdmin)
			templetContent = wordModule.getHtmlContent();
	}else{
		templetContent = wordModule.getHtmlContent();
	}
}
if(!StringHelper.isEmpty(category.getRefWordTemplateId())){
	WordModule wordModule = wordModuleService.getWordModule(category.getRefWordTemplateId());
	if(!StringHelper.isEmpty(wordModule.getOrgids())){
		if(wordModuleService.checkTemplatePermissionByOrgid(wordModule.getOrgids()) || isSysAdmin)
			wordTemplateAttachId = wordModule.getAttachid();
	}else{
		wordTemplateAttachId = wordModule.getAttachid();
	}
}
if(!StringHelper.isEmpty(category.getRefExcelTemplateId())){
	WordModule wordModule = wordModuleService.getWordModule(category.getRefExcelTemplateId());
	if(!StringHelper.isEmpty(wordModule.getOrgids())){
		if(wordModuleService.checkTemplatePermissionByOrgid(wordModule.getOrgids()) || isSysAdmin)
			excelTemplateAttachId = wordModule.getAttachid();
	}else{
		excelTemplateAttachId = wordModule.getAttachid();
	}
}


Docbase docbase = new Docbase();
docbase.setPid(pid);
docbase.setSubject(title);

parameters.put("bWorkflowform", "0");
parameters.put("isview", "0");
parameters.put("formid", "402881e50bff706e010bff7fd5640006");
parameters.put("objid", null);
parameters.put("object", docbase);
parameters.put("layoutid", category.getPCreatelayoutid());
parameters.put("initparameters", initparameters);

parameters = fs.WorkflowView(parameters);

String formcontent = StringHelper.null2String(parameters.get("formcontent"));
String ufscript = StringHelper.null2String(parameters.get("ufscript"));
String directscript = StringHelper.null2String(parameters.get("directscript"));
String fieldcalscript = StringHelper.null2String(parameters.get("fieldcalscript"));
String triggercalscript=StringHelper.null2String(parameters.get("triggercalscript"));
/**添加页面扩展**/
//将分类id放置进参数中,供页面扩展时使用动态参数
paravaluehm.put("{categoryid}",categoryid);
PagemenuService pagemenuService = (PagemenuService)BaseContext.getBean("pagemenuService");
//根据uri获取页面扩展
pagemenustr += pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0);
//根据文档分类获取页面扩展
pagemenustr += pagemenuService.getPagemenuStrExt(categoryid,paravaluehm).get(0);

FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
Formfield formfield=formfieldService.getFormfieldById("4028818411b2334e0111b2335267014f");
int fieldattr=NumberHelper.getIntegerValue(formfield.getFieldattr());
//attach的objname会存入标题加.html
fieldattr=fieldattr>251?251:fieldattr;
%>
<html>
 <head>
<script type='text/javascript' language="javascript" src='/dwr/interface/DataService.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/engine.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type='text/javascript' language="javascript" src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type='text/javascript' language="javascript" src='/js/workflow.js'></script>
<script type='text/javascript' language="javascript" src='/js/document.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript">
function fillotherselect(elementobj,fieldid,rowindex){
	 var elementvalue = Trim(getValidStr(elementobj.value));
	 var objname = "field_"+fieldid+"_fieldcheck";
	 if(!document.all(objname)){
	  return;
	 }
	 var fieldcheck = Trim(getValidStr(document.getElementsByName(objname)[0].value));
	 if(fieldcheck=="")
	  return;
	    var sql = "select * from (select '' id,' ' objname,0 dsporder from selectitem union select s.id,s.objname,s.dsporder from selectitem s where pid = '"+elementvalue+"') t order by dsporder";
	    DWREngine.setAsync(false);
	 DataService.getValuesWithReplaceByLabelCustom(sql,'s.id','s.objname',{          
	  callback:function(dataFromServer) {
	   createList(dataFromServer, fieldcheck,rowindex);
	  }
	 });
	 DWREngine.setAsync(true);
	    
	}

	      function createList(data,fieldcheck,rowindex)
	 { 
	  var select_array =fieldcheck.split(",");
	  var len = select_array.length;
	  for(var i=0;i<len;i++){
	   var objname = select_array[i];
	   if(rowindex != -1)
	     objname += "_"+rowindex;
	   removeAllOptions(document.all(objname));
	         addOptions(document.all(objname), data);
	   fillotherselect(document.all(objname),objname,rowindex);
	  }
	 }

	        function removeAllOptions(obj) {
	       var len = obj.options.length;
	       for (var i = len; i >= 0; i--) {
	           obj.options[i] = null
	       }
	   }

	   function addOptions(obj, data) {
	       var len = data.length;
	       for (var i=0; i<len; i++) {

	           if(data[i].id==null){
	             data[i].id="";
	           }
	           obj.options.add(new Option(data[i].objname,data[i].id ));
	       }
	    }

</script>
<LINK media=screen href="/js/src/widget/templates/HtmlTabSet.css" type="text/css">
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
</head>
<body>
<div id="pagemenubar"></div>
<div id="menu"></div>
<input type="hidden" id="fileuploadCheck" name="fileuploadCheck" value="0"/>
<form action="/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=create<%=allparmsurlstr%>"	name="EweaverForm" method="post">
	<input type="hidden" id="modifier" name="modifier" value="<%=currentuser.getId()%>" />
	<input type="hidden" id="targetUrl" name="targetUrl" value="<%=URLEncoder.encode((targetUrl),"UTF-8")%>" />
	<input type="hidden" id="pid" name="pid" value="<%=StringHelper.null2String(pid)%>" />
	<input type="hidden" id="docstatus" name="docstatus" value="">
	<input type="hidden" value="" id="attachid" name="attachid">
	<input type="hidden" value="" id="delattachid" name="delattachid">
	<input type="hidden" id="wordTemplateAttachId" name="wordTemplateAttachId" value="<%=StringHelper.null2String(wordTemplateAttachId)%>"/>
	<input type="hidden" id="excelTemplateAttachId" name="excelTemplateAttachId" value="<%=StringHelper.null2String(excelTemplateAttachId)%>"/>
	<table id="contentDiv" >
		<colgroup>
			<col width="8%">
			<col width="25%">
			<col width="8%">
			<col width="25%">
			<col width="8%">
			<col width="26%">
		</colgroup>
		<tr>
			<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009")%></td><!-- 标题 -->
			<td class="FieldValue" colspan="5" nowrap="nowrap">
				<input type="text" style="width: 98%"
					name="subject" id="subject" value="<%=title%>"
					onChange="checkInput('subject','subjectspan')" onblur="checkInputByteLenth('subject',0,<%=fieldattr%>)" />
				<span id="subjectspan"><img src=/images/base/checkinput.gif>
				</span>
			</td>
		</tr>
		<TR>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e")%></TD><!-- 摘要 -->
			<TD class=FieldValue colspan="5">
				<TEXTAREA style="width: 98%;font-size: 11px" name="docabstract" id="docabstract" rows="3"></TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%></TD><!-- 附件 -->
			<TD class=FieldValue colspan="5">
				<!-- 
				<div id="fileUploadDIV" ></div>
				<iframe width="100%" height="20" name="uploadIframe" id="uploadIframe" frameborder=0 scrolling=no src="/base/fileupload.jsp?formActionType=category&formActionObjid=<%=categoryid %>"></iframe>
				 -->
				<a href="#" class="addfile">
					<input  type="file"  class="addfile" name="addattachid" id="addattachid">
				</a>
				<div id="filelist_addattachid" style="padding: 3px 0px;">
				</div>
				<script type="text/javascript">
					var multi_selector = new MultiSelector( document.getElementById('filelist_addattachid'), 100,-1);
					multi_selector.addElement(document.getElementById('addattachid'), {"formActionType" : "category", "formActionObjid" : "<%=categoryid %>"});
				</script>
			</TD>
		</TR>
		<TR>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890001")%></TD><!-- 文档作者 -->
			<TD class=FieldValue>
				<input type="text" class="InputStyle2" name="creatorinput" id="input_creator" onfocus="checkdirect(this)"/ >
				<button type=button class=Browser name="button_creator" onclick="javascript:getrefobj('creator','creatorspan','402881e70bc70ed1010bc75e0361000f','','/humres/base/humresview.jsp?id=','0');"></button>
				<input type="hidden" name="creator" id="creator" value="<%=currentuser.getId()%>" style="width: 80%">
				<span id="creatorspan" ><%=currentuser.getObjname()%></span>
			</TD>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e50ac11cb6010ac180c9790004")%></TD><!-- 文档目录 -->
			<TD class=FieldValue>
				<button type=button class=Browser name="button_categoryids"	onclick="javascript:getrefobj('categoryid','categoryidspan','402883ff3c610d3d013c610d4333004d','','','0');"></button>
				<input type="hidden" id="categoryid" name="categoryid" value="<%=StringHelper.null2String(categoryid)%>" style="width: 80%">
				<span id="categoryidspan" ><%=category.getObjname()%></span>
			</TD>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774cceb80008")%></TD><!-- 安全级别 -->
			<TD class=FieldValue>
				<input type="text" name="docseclevel" value="10" style="width: 80%">
			</TD>
		</TR>
	</table>
	<div id="formcomtentDIV">
	<%=formcontent%>
	</div>
	<table class="noborder" id="doctypeTable">
		<TR>
			<TD class=FieldName width="8%"><%=labelService.getLabelNameByKeyId("402881b70d19c4c0010d1aca65550015")%></TD><!-- 文档格式 -->
			<TD class=FieldValue >
				<input type="hidden" name=officeType id="officeType" value="3" />
				<!-- input type="radio" name="doctype" id="txt" value="2" onclick="onChangeDocType(2)">无正文-->
				<input type="radio" name="doctype" id="html" value="3" checked   onclick="onChangeDocType(3)"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda34a970018")%><!-- HTML文档 -->
				<input type="radio" name="doctype" id="word" value="4"  onclick="onChangeDocType(4)"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda450910019")%><!-- WORD文档 -->
				<input type="radio" name="doctype" id="excel" value="5" onclick="onChangeDocType(5)"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda4b538001a")%><!-- EXCEL文档 -->
				<input type="radio" name="doctype" id="powerpoint" value="7" onclick="onChangeDocType(7)"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890002")%><!-- PPT幻灯片 -->
				<!--  
				<input type="radio" name="doctype" id="visio" value="8" onclick="onChangeDocType(8)">Viso
				<input type="radio" name="doctype" id="wps" value="9" onclick="onChangeDocType(9)">WPS文档
				<input type="radio" name="doctype" id="et" value="10" onclick="onChangeDocType(10)">WPS表格
				<input type="radio" name="doctype" id="pdf" value="6" onclick="onChangeDocType(6)">PDF文档
				-->
			</TD>
		</TR>
	</table>
	<div id="htmlDIV">
		<textarea name="content" id="content" style="height: 400px;"><%=templetContent%></textarea>
	</div>
	<div id="officeDIV" style="POSITION: relative;width:100%;height:660px;OVERFLOW:hidden;display:none">
		<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
			<% 
				String mServerName = WebOffice.mServerName;
				mServerName = mServerName + (mServerName.indexOf("?") == -1 ? "?" : "&") + "docCategoryId=" + categoryid;
			%>
			<param name="WebUrl" value="<%=mServerName%>">
			<param name="RecordID" value=""><!-- 文档模板，暂未启用 -->
			<param name="Template" value="">
			<param name="FileName" value="">
			<param name="FileType" value="">
			<param name="UserName" value="<%=currentuser.getId()%>">
			<param name="ExtParam" value="">
			<param name="EditType" value="1,1">
			<param name="PenColor" value="#FF0000">
			<param name="PenWidth" value="1">
			<param name="Print" value="1">
			<param name="ShowToolBar" value="1">
			<param name="ShowMenu" value="1">
		</object>	
	</div>
	<div id="pdfUploadDIV" style="display:none"></div>
	<div id="pdfDIV" style="POSITION: relative;width:100%;height:30px;OVERFLOW:hidden;display:none">
		<iframe width="100%" height="20" name="pdfIframe" id="pdfIframe" frameborder=0 scrolling=auto src="/base/fileupload.jsp?type=pdf"></iframe>
	</div>
</form>
<script language="javascript">
var insertDOC = "true";
var inputid;
var spanid;
var temp;
var needcheckforms = "<%=needcheck%>";
var $j = jQuery.noConflict();
var tb = new Ext.Toolbar();
WeaverUtil.load(function() {
	//FCKEditorExt.initEditor('content', false);
	//FCKEditorExt.toolbarExpand(true);
	
	CKEditorExt.whenAllEditorIsReady(function(){
		CKEditorExt.initEditor('content');
	});

	onChangeDocType(3);//默认是html形式
});
Ext.onReady(function() {
    Ext.QuickTips.init();
    tb.render('pagemenubar');
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")%>','S','accept',function(){onSubmit()});//保存
    if("<%=category.getIsfastnew() %>"==0)
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402883d934c15ec70134c15ec8720000")%>','N','page_add',function(){onSubmitNew()});//保存并新建
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9c4cf20015")%>','D','page_white_edit',function(){onDraft()});//草稿
    // addBtn(tb,'获取文档源文件内容','O','folder_explore',function(){alert(FCKEditorExt.getHtml());});
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890003")%>','H','application',function(){changeScreen(1)});//隐藏属性
    addBtn(tb,'还原','R','application_double',function(){changeScreen()});
	// addBtn(tb,'添加文档','X','application',function(){docRefobj('402881e70ebfb96c010ebfbf16de0004','')});
    <%=pagemenustr%>
	//f$("O").style.display="none";
    f$("R").style.display="none";
	//f$("X").style.display="none";
	 //以下为自定义菜单↓
    document.WebOffice.AppendMenu("1","<%=labelService.getLabelNameByKeyId("402881e70d962d51010d96fc26cf0006")%>(&L)");//打开本地文件
    document.WebOffice.AppendMenu("2","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0019")%>(&S)");//保存本地文件
    document.WebOffice.AppendMenu("3","<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260004")%>(&U)");//保存远程文件
    document.WebOffice.AppendMenu("12","-");
    document.WebOffice.AppendMenu("13","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001a")%>(&P)");//打印文档
	document.WebOffice.CopyType="1";
 	jQuery("#categoryid").bind("propertychange",function(){
 		if(event.propertyName != "value"){
 			return;
 		}
 		changeUploadIframeUrl(this.value);
 		
 		changeWebOfficeUrl(this.value);
 	});
});
$j(document).ready(function($){
	<%=ufscript%>
	<%=directscript%>
	$("#input_creator").autocomplete("/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable=humres&viewfield=objname&selfield=<%=sqlviewurl%>&keyfield=id", {
		width: 260,
        max:15,
        matchCase:true,
        scroll: true,
        scrollHeight: 300, 
        selectFirst: false});
    $("#input_creator").result(function(event, data, formatted) {
        if (data){
            document.getElementById('modifier').value=data[1];
            document.getElementById("creator").value=data[1];
        }
    });
	$.Autocompleter.Selection = function(field, start, end) {
    if( field.createTextRange ){
        var selRange = field.createTextRange();
		selRange.collapse(true);
		selRange.moveStart("character", start);
		selRange.moveEnd("character", end);
		selRange.select();
        if(!spanid)
           return;
        var len=field.value.indexOf("  ");
        if(temp==0&&len>0){
        	temp=1;
         	var  length=field.value.length;
          	var data=field.value;
        	document.getElementById(inputid).value=field.value.substring(0,length);
       		document.getElementById(spanid.replace("input","span")).innerHTML= data.substring(0,length);
         }else{
         	var data=field.value;
        	document.getElementById(inputid).value=data;
         	document.getElementById(spanid.replace("input","span")).innerHTML=data;
         }
	} else if( field.setSelectionRange ){
    	field.setSelectionRange(start, end);
	} else {
    	if( field.selectionStart ){
			field.selectionStart = start;
			field.selectionEnd = end;
		}
	}
	field.focus();
	};
});

var strSQLs = new Array();
var strValues = new Array();
<%=triggercalscript%>

function SQL(param){
	param = encode(param);

	if(strSQLs.indexOf(param)!=-1){
		var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
		return retval;
	}else{
		var _url= "/ServiceAction/com.eweaver.base.DataAction?sql="+encodeURIComponent(param);
		//将Msxml.xmldocument加载xml文件改为JQuery自带的Ajax封装类并同步加载
		var xmlrequest=jQuery.ajax({
			type: "GET",
			async:false,
			url: _url,
			error:function (XMLHttpRequest, textStatus, errorThrown){
					alert('Error:'+errorThrown);
					return '';
			}
		});
		var XMLDoc=xmlrequest.responseXML;//返回结果集的Xmldom对象，即原先new ActiveXObject创建的对象
		var XMLRoot=XMLDoc.documentElement;//返回根结点，在FireFox下不是该属性名称且XMLRoot.text属性也不可用。
		//var retval = getValidStr(XMLRoot.text);
		if(XMLRoot==null)
			XMLRoot = loadXML(xmlrequest.responseText.replace(/&mdash;/g, '-')).documentElement;
		var retval = XMLRoot.firstChild ? getValidStr(XMLRoot.firstChild.nodeValue) : "";
		strSQLs.push(param);
		strValues.push(retval);
		return retval;
	}
}
var loadXML = function(xmlFile){ 
    var xmlDoc; 
    if(window.ActiveXObject){ 
        var ARR_ACTIVEX = ["MSXML4.DOMDocument","MSXML3.DOMDocument","MSXML2.DOMDocument","MSXML.DOMDocument","Microsoft.XmlDom"]; 
        for (var i = 0;i < ARR_ACTIVEX.length;i++) { 
            try { 
                var objXML = new ActiveXObject(ARR_ACTIVEX[i]); 
                xmlDoc = objXML; 
                break; 
            } catch (e) {} 
        } 
        if (xmlDoc) { 
            xmlDoc.async = false; 
            xmlDoc.loadXML(xmlFile); 
        }else{ 
            return; 
        } 
    }else if (document.implementation && document.implementation.createDocument){//判断是不是遵从标准的浏览器 
        //建立DOM对象的标准方法 
        xmlDoc = document.implementation.createDocument('', '', null); 
        xmlDoc.load(xmlFile); 
    }else{ 
        return null; 
    } 
    return xmlDoc; 
}

function onCal(){
 try{
	var rowindex = 0;
    <%=fieldcalscript%>


	function SUM(param){
		var result = 0;
		for(index=0;index<rowindex;index++){
			tmpval = 0;
			try{
			tmpval = eval(param)*1;
			}catch(e){
			tmpval = 0;
			}
			//alert(tmpval);
			result += tmpval;
		}
		rowindex = 0;
		return result;
	}

	function RMB(param){
		var tmpval = eval(param)*1;
		var result =  convertCurrency(tmpval);
		return result;
	}
	function COUNT(param){
		var result = 0;
		for(index=0;index<rowindex;index++){
			tmpval = 0;
			try{
			tmpval = eval(param)*1;
			}catch(e){
			tmpval = 0;
			}
			if(tmpval != 0)
				result ++;
		}
		rowindex = 0;
		return result;
	}
	function PROD(param){
		var result = 1;
		for(index=0;index<rowindex;index++){
			tmpval = 1;
			try{
			tmpval = eval(param)*1;
			}catch(e){
			tmpval = 1;
			}
			//alert(tmpval);
			result = result * tmpval;
		}
		rowindex = 0;
		return result;
	}
	function MAX(param){
		var result = 0;
		for(index=0;index<rowindex;index++){
			tmpval = 0;
			try{
			tmpval = eval(param)*1;
			}catch(e){
			tmpval = 0;
			}
			if(tmpval > result)
				result = tmpval;
		}
		rowindex = 0;
		return result;
	}
 }catch(e){}
}
var inputs = document.EweaverForm.getElementsByTagName("input");
for (i = 0; i < inputs.length; i++) {
    inputel = inputs[i];
    if(inputel.value&&inputel.value!='')
      inputel.fireEvent('onpropertychange');
}
var task=new Ext.util.DelayedTask(onCal);
</script>

<SCRIPT FOR = document EVENT = onselectionchange>
task.delay(200,null,this);
</SCRIPT>
</body>
</html>

<script language="javascript" for=WebOffice event="OnMenuClick(vIndex,vCaption)">
  if (vIndex==1){  
    WebOpenLocal();     //打开本地文件
  }
  if (vIndex==2){  
    WebSaveLocal();     //保存本地文件
  }
  if (vIndex==3){
    SaveDocument();     //保存正文到服务器上（不退出）
  }
  if (vIndex==5){  
    WebOpenSignature(); //签名印章
  }
  if (vIndex==6){  
    WebShowSignature(); //验证签章
  }
  if (vIndex==8){  
    WebSaveVersion();   //保存版本
  }
  if (vIndex==9){  
    WebOpenVersion();   //打开版本
  }
  if (vIndex==11){
    SaveDocument();     //保存正文到服务器上
    webform.submit();   //然后退出
  }
  if (vIndex==13){  
    WebOpenPrint();     //打印文档
  }
</script>
