<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
String id = StringHelper.null2String(request.getParameter("id"));
String max = StringHelper.null2String(request.getParameter("max"));
Docbase docbase = docbaseService.getPermissionObjectById(id);
String sqltype = SqlHelper.getConcatStr();//数据SQL语句连接类型
String isnull = SqlHelper.getisnullStr();//判断是否为空的
String sqlviewurl = "select a.objname"+sqltype +"' ( '"+sqltype +isnull+"(a.objno,'"+"')"+sqltype +"' , '"+sqltype +isnull+"(b.objname,'"+"')"+sqltype + "' )' as objname ,a.id as objid from humres a,orgunit b where a.orgid=b.id and a.isdelete=0 and a.hrstatus='4028804c16acfbc00116ccba13802935' and a.objname like ?";
sqlviewurl = StringHelper.getEncodeStr(sqlviewurl);//对于SQL语句进行转义。因为在后面URL中不能出现+。
int doctype = docbase.getDoctype();
String attachid = StringHelper.trimToNull(request.getParameter("attachid"));
Attach attach =null;
if(attachid!=null){
	attach = attachService.getAttach(attachid);
}

if(attach==null){
	Docattach docattach = docbaseService.getDoccontentLastVerList(id);
	
	if(docattach!=null){
		attachid = docattach.getAttachid();
		attach = attachService.getAttach(attachid);
	}
}

List docattachList = docbaseService.getAttachList(id);
String needcheck = ""; 

//附件操作权限
int righttype = permissiondetailService.getAttachOpttype(id);

%>
<!--页面菜单开始-->
<%
String tabStr="";
boolean hasTab=false;
//if(docbase.getDocstatus().intValue()==0)
//paravaluehm.put("{id}",id);
//PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
//ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(theuri,paravaluehm);
//pagemenustr += menuList.get(0);
String categoryid = null;
int showreply =1;
if(categoryService.getCategoryByObj(id)!=null){
	categoryid = (categoryService.getCategoryidStrByObj(id));
}
Category category = categoryService.getCategoryById(categoryid);
String formcontent ="";
Map initparameters = new HashMap();
Map parameters = new HashMap();
FormlayoutService fls = (FormlayoutService)BaseContext.getBean("formlayoutService");
String  layoutid="";
List layoutlist=fls.getOptLayoutList(id,OptType.MODIFY);
for (Object layout : layoutlist) {
    if(layout==null){
    	continue;
    }
    if (fls.getFormlayoutById((String) layout).getTypeid() == 2){
        layoutid = fls.getFormlayoutById((String) layout).getId();
        break;
    }
}
if(StringHelper.isEmpty(layoutid)){
	layoutid=category.getPEditlayoutid();
}
if(!StringHelper.isEmpty(layoutid)){
	paravaluehm.put("{id}",id);
	paravaluehm.put("{typeid}",layoutid);
}


parameters.put("bWorkflowform","0");
parameters.put("isview","0");
parameters.put("formid","402881e50bff706e010bff7fd5640006");
parameters.put("objid",id);
parameters.put("object",docbase);
parameters.put("layoutid",layoutid);
parameters.put("initparameters",initparameters);

FormService fs = (FormService)BaseContext.getBean("formService");
parameters = fs.WorkflowView(parameters);

formcontent = StringHelper.null2String(parameters.get("formcontent"));
needcheck=StringHelper.null2String(parameters.get("needcheck"));
String ufscript=StringHelper.null2String(parameters.get("ufscript"));
String directscript=StringHelper.null2String(parameters.get("directscript"));
String fieldcalscript = StringHelper.null2String(parameters.get("fieldcalscript"));
String triggercalscript=StringHelper.null2String(parameters.get("triggercalscript"));
/**添加页面扩展**/
//将文档id和分类id放置进参数中,供页面扩展时使用动态参数
paravaluehm.put("{id}",id);	
paravaluehm.put("{categoryid}",categoryid);
PagemenuService pagemenuService = (PagemenuService)BaseContext.getBean("pagemenuService");
//根据uri获取页面扩展
pagemenustr += pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0);
//根据文档分类获取页面扩展
pagemenustr += pagemenuService.getPagemenuStrExt(categoryid,paravaluehm).get(0);

int docattachcanedit=0;
if(NumberHelper.string2Int(category.getDocattachcanedit(),0)==1&&righttype>=5){
	docattachcanedit=1;
}

FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
Formfield formfield=formfieldService.getFormfieldById("4028818411b2334e0111b2335267014f");
int fieldattr=NumberHelper.getIntegerValue(formfield.getFieldattr());
//attach的objname会存入标题加.html
fieldattr=fieldattr>251?251:fieldattr;
%>
<html>
<head>
<script type='text/javascript' language="javascript" src='/dwr/interface/DataService.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/interface/FormbaseService.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/engine.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="/js/dojo.js"></script>
<script type='text/javascript' language="javascript" src='/js/workflow.js'></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type='text/javascript' language="javascript" src='/js/tx/jquery.autocomplete.pack.js'></script>
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
<style type="text/css">
     #pagemenubar table {width:0}
</style>
</head>
<body>
<div id="pagemenubar"></div>
<input type="hidden" id="fileuploadCheck" name="fileuploadCheck" value="0"/>     
<form action="/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=modify" name="EweaverForm" id="EweaverForm" method="post">
<input type="hidden" value="<%=docbase.getId()%>" name="id">
<input type="hidden" value="1" name="docstatus" id="docstatus">
<input type="hidden" value="0" name="isNewVersion" id="isNewVersion">
<input type="hidden" value="<%=docbase.getPid()%>" name="pid">
<input type="hidden" value="<%=docbase.getObjno()%>" name="objno">
<!-- <input type="hidden" value="<%=docbase.getCreator()%>" name="creator"> -->
<!-- <input type="hidden" value="<%=docbase.getCreator()%>" name="creator"> -->
<input type="hidden" value="<%=docbase.getCreator()%>" name="creator2"/>
<input type="hidden" value="<%=currentuser.getId()%>" name="modifier">
<input type="hidden" value="<%=docbase.getDoctype()%>" name="doctype">
<input type="hidden" value="<%=docbase.getDoctype()%>" name="officeType" id="officeType">
<input type="hidden" value="" name="delattachid" id="delattachid">
<input type="hidden" name="attachid" id="attachid" value="<%=attachid%>">
<table id="contentDiv" class="noborder">
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
		<td class="FieldValue" colspan="5">
			<input type="text" class="InputStyle2" style="width: 95%"
				name="subject" id="subject" value="<%=docbase.getSubject()%>"
				onChange="checkInput('subject','subjectspan')" onblur="checkInputByteLenth('subject',0,<%=fieldattr%>)" />
			<span id="subjectspan"></span>
		</td>
	</tr>
	<TR>
		<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e")%></TD><!-- 摘要 -->
		<TD class=FieldValue colspan="5">
			<TEXTAREA style="width: 100%" name="docabstract" id="docabstract" rows="3"><%=StringHelper.null2String(docbase.getDocabstract())%></TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%></TD><!-- 附件 -->
		<TD class=FieldValue colspan="5">
			<span id="fileUploadSPAN">
			<%
				String attachIdsForBatchDownload = "";
				for (int i=0; i < docattachList.size();i++){
					attachIdsForBatchDownload += ((Attach)docattachList.get(i)).getId() + ",";
				}
				if(docattachList.size() > 1 && righttype >= 5){
					attachIdsForBatchDownload = attachIdsForBatchDownload.substring(0, attachIdsForBatchDownload.length() - 1);
			%>
					<div style="margin: 5px 0px;">
						<a href="javascript:batchDownload({formIdOrName : '文档基础信息表', fieldIdOrName : '附件', attachIds : '<%=attachIdsForBatchDownload %>'});" class="batchDowload">全部下载</a>
					</div>
					
			<%
				}
			%>
	 		<%
	   		for (int i=0; i<docattachList.size();i++){
	   			Attach attachsub =(Attach)docattachList.get(i);
	   			if(righttype%3==0){
	   		%>
			<span style="margin:5px;" id ="<%=attachsub.getId()%>" ><img src="/images/silk/accessory.gif" border="0">
			<a style="margin: 2px" href="/ServiceAction/com.eweaver.document.file.FileDownload?docid=<%=id%>&attachid=<%=attachsub.getId()%>&attachcanedit=<%=docattachcanedit%>" target="_blank" title="打开"><%=attachsub.getObjname()%></a>
			&nbsp;
			<% if(righttype%7==0){%>
			<a title="<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>" href="javascript:deleteaddattach('<%=attachsub.getId()%>',true);"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%></a><!-- 删除 -->
			<%}%>
			</span>
	 		<%}
	 		}%>
	 		</span>
	 		<!-- 
			<div id="fileUploadDIV" ></div>
			<iframe width="100%" height="20" name="uploadIframe" id="uploadIframe" frameborder=0 scrolling=no src="/base/fileupload.jsp?formActionType=category&formActionObjid=<%=categoryid %>"></iframe>
			 -->
			<div style="margin: 0px;padding: 0px;">
				<a href="#" class="addfile">
					<input  type="file"  class="addfile" name="addattachid" id="addattachid">
				</a>
				<div id="filelist_addattachid" style="padding: 3px 0px;">
				</div>
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
			<input type="hidden" name="creator" id="creator" value="<%=docbase.getCreator()%>" style="width: 80%">
			<span id="creatorspan"><%=humresService.getHrmresNameById(docbase.getCreator())%></span>
		</TD>
		<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e50ac11cb6010ac180c9790004")%></TD><!-- 文档目录 -->
		<TD class=FieldValue>
			<button type=button class=Browser name="button_categoryids"	onclick="javascript:getrefobj('categoryid','categoryidspan','402883ff3c610d3d013c610d4333004d','','','0');"></button>
			<input type="hidden" id="categoryid" name="categoryid" value="<%=StringHelper.null2String(categoryid)%>" style="width: 80%">
			<span id="categoryidspan"><%=category.getObjname()%></span>
		</TD>
		<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774cceb80008")%></TD><!-- 安全级别 -->
		<TD class=FieldValue>
			<input type="text" name="docseclevel" value="<%=docbase.getDocseclevel()%>" style="width: 80%">
		</TD>
	</TR>
</table>
	<div id="formcomtentDIV" >
		<%=formcontent%>
	</div>
<%if (doctype==2 || doctype==3){%>
<div id="htmlDIV">
	<textarea name="content" id="content" style="height: 400px;"><%=docbaseService.getDocContent(id,attachid)%></textarea>
</div>
<%}%>
<%if (WebOffice.isOffice(doctype)){
	
	%>
<div id="officeDIV" style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
	<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
		<param name="WebUrl" value="<%=WebOffice.mServerName%>">
		<param name="RecordID" value="<%=id%>">
		<param name="OFFICEID" value="<%=attachid%>">
		<param name="Template" value="">
		<param name="FileName" value="<%=attach.getObjname()%>">
		<param name="FileType" value="<%=WebOffice.getFileType(docbase)%>">
		<param name="UserName" value="<%=currentuser.getObjname()%>">
		<param name="EditType" value="1,0">
		<param name="PenColor" value="#FF0000">
        <param name="Print" value="false">
		<param name="PenWidth" value="1">
		<param name="ShowToolBar" value="1">
		<param name="ShowMenu" value="1">
	</object>
</div>
<%}%>

<div id="pdfDIV" style="POSITION: relative;width:100%;height:30px;OVERFLOW:hidden;display:none"></div>
</form>
<script language="javascript">
var insertDOC = "true";
var inputid;
var spanid;
var temp;
var needcheckforms = "<%=needcheck%>";
Ext.onReady(function() {
    Ext.QuickTips.init();
    var tb = new Ext.Toolbar();
    tb.render('pagemenubar');
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")%>','S','accept',function(){javascript:onSubmit()});//提交
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881eb0bd6f028010bd706273c0004")%>','V','building_add',function(){javascript:newVersion()});//保存新版本
    <%
    if(docbase.getDocstatus()==0){
    %>
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9c4cf20015")%>','D','page_white_edit',function(){onDraft()});//草稿
    <%}%>
    <%if(WebOffice.isOffice(doctype)){%>
    //addBtn(tb,'打开本地文件','O','folder_explore',function(){openLocalFile()});
	//addBtn(tb,'保存正文','D','package_down',function(){savelocalFile()});
    <%}%>
    
      //注释掉此段代码,因为如果增加了页面扩展的显示,那么这段代码就没有意义,可以直接在页面扩展中配置出删除功能,而不是采用以下做法
      <%/*if(!pagemenustr.equals("")){*/%>
           <%/*if(pagemenustr.indexOf(labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003"))>-1){*/%>
			  // addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>','D','delete',function(){javascript:onDelete1("<%=id%>")});//删除
         <%/*}}*/%>
    
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890003")%>','H','application',function(){changeScreen(1)});//隐藏属性
    addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890007")%>','R','application_double',function(){changeScreen()});//还原
	<%if(WebOffice.isOffice(doctype)){%>
		//addBtn(tb,'全屏显示','X','application',function(){document.WebOffice.FullSize();});
	<%}%>
	
	<%=pagemenustr%>
    
	f$("R").style.display="none";
	if(document.WebOffice)
	{
		 //以下为自定义菜单↓
    document.WebOffice.AppendMenu("1","<%=labelService.getLabelNameByKeyId("402881e70d962d51010d96fc26cf0006")%>(&L)");//打开本地文件
    document.WebOffice.AppendMenu("2","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0019")%>(&S)");//保存本地文件
    document.WebOffice.AppendMenu("3","<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260004")%>(&U)");//保存远程文件
    document.WebOffice.AppendMenu("12","-");
    document.WebOffice.AppendMenu("13","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001a")%>(&P)");//打印文档
	document.WebOffice.CopyType="1";
	}
	
	<%if(WebOffice.isOffice(doctype)){%>initObject();<%}%>
	
	jQuery("#categoryid").bind("propertychange",function(){
 		if(event.propertyName != "value"){
 			return;
 		}
 		changeUploadIframeUrl(this.value);
 	});
});
WeaverUtil.load(function(){
	if (f$("content")){
		//FCKEditorExt.initEditor('content',false);
		//FCKEditorExt.toolbarExpand(true);
		
		CKEditorExt.whenAllEditorIsReady(function(){
			CKEditorExt.initEditor('content');
		});
	}
});

var $j = jQuery.noConflict();
$j(document).ready(function($){
	<%if(max.equals("true")){%>
	changeScreen(1);
	<%}%>
    <%=ufscript%>
    <%=directscript%>
    $("#input_creator").autocomplete("/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable=humres&viewfield=objname&selfield=<%=sqlviewurl %>&keyfield=id", {
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
	        if(spanid==undefined||spanid==undefined)
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
	       		document.getElementById(spanid.replace("input","span")).innerHTML= data;
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
function initObject(){
 	document.WebOffice.WebSetMsgByName("OFFICEID","<%=attachid%>");
	
    document.WebOffice.WebOpen();
	openMainOffice();
}
/*main.jsp iWebOffice控件初始化*/
function openMainOffice(){
	if(top.document.WebOffice)
	{
		var openflag=top.document.getElementById('webofficeopenflag');
		if(openflag.value=='0')
		{
			top.document.WebOffice.WebOpen();
			openflag.value='1';
		}
	
	}
}
//作用：保存附件到本地
function savelocalFile(pdf){
	if(pdf){
		window.location.href="/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid="+pdf;
	}else{
		window.location.href="/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid=<%=attachid%>";
	}
}


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
<script>
function onDelete1(id){
  if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
     document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=delete";//输入你的Action
	 document.EweaverForm.submit();
  }
}
</script>