<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.document.base.model.Docattach"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>

<%
String setSubject=StringHelper.null2String(request.getParameter("setSubject"));
if(!StringHelper.isEmpty(setSubject))
	setSubject=StringHelper.getDecodeStr(setSubject);
	OrgunitService orgunitService=(OrgunitService)BaseContext.getBean("orgunitService");
String orgunitid = currentuser.getOrgid();
String orgunitname = ((OrgunitService)BaseContext.getBean("orgunitService")).getOrgunit(orgunitid).getObjname();

CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");

String categoryid = StringHelper.trimToNull(request.getParameter("categoryid"));
String doctypeid = StringHelper.trimToNull(request.getParameter("doctypeid"));
if(doctypeid==null){doctypeid="402881e70bc7d577010bc7dbb6a40009";}
String pid = StringHelper.trimToNull(request.getParameter("pid"));
int docType=NumberHelper.string2Int(request.getParameter("doctype"));
String targetUrl =  StringHelper.trimToNull(request.getParameter("targetUrl"));

String subject = "";
String categorypath = "";
if(categoryid!=null){
	Categorylink categorylink = categoryService.getCategorylinkByCategory(categoryid,"Doctype");
	if(categorylink!=null)doctypeid =  categorylink.getObjid();
}
if (pid!=null){
	if(docbaseService.getDocbase(pid)!=null){
		Docbase pdocbase = docbaseService.getDocbase(pid);
		categoryid = categoryService.getCategoryidStrByObj(pdocbase.getId());
		doctypeid = pdocbase.getTypeid();
		subject += labelService.getLabelName("402881e50b60af4a010b60e027890002") + ":" + StringHelper.null2String(pdocbase.getSubject());
	}
}
//Category category = categoryService.getCategory(categoryid);

String templetContent="";

categorypath = categoryService.getCategoryPath(categoryid,null,null);

if(!StringHelper.isEmpty(setSubject)){
	subject=setSubject+"_"+subject;
	setSubject=StringHelper.getEncodeStr(setSubject);
}

String allparmsurlstr = "";
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String paraname = e.nextElement().toString().trim();
	String paravalue = StringHelper.trimToNull(request.getParameter(paraname));
	if(!StringHelper.isEmpty(paraname) && !StringHelper.isEmpty(paravalue) &&!"lastdocid".equals(paraname)){
		allparmsurlstr += "&"+paraname+"="+URLEncoder.encode(paravalue,"UTF-8");
	}
}
allparmsurlstr += "&lastdocid=";
String targetUrl2 = request.getContextPath()+"/document/base/docbasecreate3.jsp?1=1"+allparmsurlstr;
String orgname="";
String orgid="";
String currentuserid=StringHelper.null2String(currentuser.getId());
if(!StringHelper.isEmpty(currentuserid)){
orgid=StringHelper.null2String(currentuser.getOrgid());
	if(!StringHelper.isEmpty(orgid))
	orgname=StringHelper.null2String(orgunitService.getOrgunit(orgid).getObjname());
}
	String layoutid = "";

FormService fs = (FormService)BaseContext.getBean("formService");
String formcontent ="";
Map initparameters = new HashMap();
Map parameters = new HashMap();

parameters.put("bWorkflowform","0");
parameters.put("isview","0");
parameters.put("formid","402881e50bff706e010bff7fd5640006");
parameters.put("objid","");
parameters.put("object",docbaseService.getDocbase(StringHelper.null2String(request.getParameter("lastdocid"))));

parameters.put("layoutid",layoutid);
parameters.put("initparameters",initparameters);

parameters = fs.WorkflowView(parameters);		

formcontent = StringHelper.null2String(parameters.get("formcontent"));

String needcheck = StringHelper.null2String(parameters.get("needcheck"));

SelectitemService selectitemService =(SelectitemService)BaseContext.getBean("selectitemService");
List attachType=selectitemService.getSelectitemList("4028814811ba15ab0111ba8992244970",null);
%>
<html>
  <head>
  </head>
  <body>
  <!-- 标题 -->
  <%titlename=labelService.getLabelName("402881eb0bcd354e010bcd9b96570014");%>
  <%@ include file="/base/toptitle.jsp"%>
  	
<!--页面菜单开始-->     
<%
pagemenustr += "{C,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{S,提交并新建,javascript:onSubmitNew()}";
pagemenustr += "{Z,"+labelService.getLabelName("402881eb0bcd354e010bcd9c4cf20015")+",javascript:onDraft()}";
pagemenustr += "{H,"+labelService.getLabelName("402881eb0bcd354e010bcd9d231f0016")+",javascript:onHiddenShow('oDiv')}";
pagemenustr += "{F,"+labelService.getLabelName("402881eb0bcd354e010bcd9dfe6b0017")+",javascript:addattach()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  

<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=create" enctype="multipart/form-data" name="EweaverForm" method="post">
<input type="hidden" value="1" name="docstatus">
<input type="hidden" value="<%=setSubject%>" name="setSubject">
<input type="hidden" value="<%=StringHelper.null2String(pid)%>" name="pid">
<input type="hidden" value="<%=currentuser.getId()%>" name="creator">
<input type="hidden" value="<%=currentuser.getId()%>" name="modifier">
<input type="hidden" value="<%=URLEncoder.encode(StringHelper.null2String(targetUrl))%>" name="targetUrl">

<table class=noborder>     	      	
<tr><!-- 标题 -->
	<td class="FieldName" nowrap width="15%"><%=labelService.getLabelName("402881eb0bcbfd19010bcc0939c60009")%></td>
	<td class="FieldValue" >
	<input onchange="checkInput('subject','subjectspan')" style="WIDTH: 97%;" name="subject" value="<%=subject%>">
	<span id=subjectspan><img src="/images/base/checkinput.gif" align=absMiddle></span>
	</td>	
</tr>
<tr><!-- 附件格式 -->
	<td class="FieldName" nowrap>附件格式</td>
	<td class="FieldValue" colspan="3">
	<select name="extselectitemfield0"   id="extselectitemfield0" style="width: 200px; height: 18px" >
	<%for(int i=0;i<attachType.size();i++){
	Selectitem attachitem=(Selectitem)attachType.get(i);
	%>
	<option value="<%=attachitem.getId()%>"><%=attachitem.getObjname()%></option>
	<%}%>
	</select>
	<span id="extselectitemfield0span" name="extselectitemfield0span" ></span>
	</td>
</tr>
<tr><!-- 附件 -->
	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcd9dfe6b0017")%></td>
	<td class="FieldValue" colspan="3">
	<table class="noborder">
	<tr>
		<td nowrap><input readonly type=text style="WIDTH: 85%;" name="addedFile" id="addedFile">&nbsp;<button onclick="javascript:addFile();">FTP上传</button></td>
	</tr>
	</table>
	<table class="noborder" id=attachtd>
		<tr>
			<td>
			<input type=file style="WIDTH: 97%;" name=attach1>
			</td>
		</tr>
	</table>
	</td>
</tr>
<tr><!-- 摘要 -->
	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcdaaae37001e")%></td>
	<td class="FieldValue" colspan="3">
		<textarea style="WIDTH: 99%;" rows="5" name="docabstract"></textarea>
 	</td>
</tr> 
</table>	
<table class=noborder id="oDiv" style="display:''">
<!-- 列宽控制 -->
<colgroup>
	<col width="15%">
	<col width="40%">
	<col width="15%">
	<col width="30%">
</colgroup>
   	<tr>
   		<td class="FieldName" nowrap width="10%">文档安全级别</td>
		<td class="FieldValue"><input type="text"  name="docseclevel" value="10"/></td>   		
   		<td class="FieldName" nowrap><%=labelService.getLabelName("402881e30fa73306010fa79e77890883")%></td><!-- 组织单元-->
		<td class="FieldValue">    
		    <button  class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','1');"></button>
			<input type="hidden"  name="orgunitid" value="<%=orgid%>"/>
			<span id="orgunitidspan"/><%=orgname%></span>
		</td>
   	</tr>        	
   	<tr>
   		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda6ab3b001b")%></td>
   		<td class="FieldValue"><input type="hidden" name="categoryid" value="<%=StringHelper.null2String(categoryid)%>"/>       			
  			<button class=Browser onclick="javascript:getBrowser('/base/category/categorybrowserm.jsp?method=create&model=docbase&categoryid='+document.EweaverForm.categoryid.value,'categoryid','categoryidspan','1');"></button>
     		<span id="categoryidspan"><%=categorypath%><%if(StringHelper.isEmpty(categorypath)){%><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle><%}%></span>
       	</td>
       	<td class="FieldName"><%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%></td>
   		<td class="FieldValue"><input type="hidden" name="doctypeid" value="<%=StringHelper.null2String(doctypeid)%>"/>       			
   			<button  class=Browser onclick=""></button>
      		<span id="doctypeidspan"></span>
       	</td>
   	</tr>
   	<tr>
   		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda7ee32001c")%></td>
   		<td class="FieldValue">
   			<button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp','author','authorspan','1');"></button>
      		<span id="authorspan"><%=currentuser.getObjname()%></span>
   			<input type="hidden" name="author" value="<%=currentuser.getId()%>"/>
   		</td>
   		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda88166001d")%></td>
   		<td class="FieldValue">
   			<button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp','author2','author2span','0');"></button>
      		<span id="author2span"></span>
   			<input type="hidden" name="author2" value=""/>
   		</td>
   	</tr>
   	<tr>
      	<td colspan=4><%=formcontent %></td>
   	</tr>          	
   	<tr>
      	<td class="FieldName" nowrap><%=labelService.getLabelName("402881b70d19c4c0010d1aca65550015")%> </td>
   		<td class="FieldValue" colspan="3">
		<input onclick="onChangeDocType('docbasecreate.jsp','0')" type="radio" name="doctype" value="3">无正文 
		<input onclick="onChangeDocType('docbasecreate.jsp?showHTML=true','3')" type="radio" name="doctype" value="3"><%=labelService.getLabelName("402881eb0bcd354e010bcda34a970018")%> 
   		<input onclick="onChangeDocType('docbasecreate2.jsp','4')" type=radio name=doctype value="4"><%=labelService.getLabelName("402881eb0bcd354e010bcda450910019")%>
   		<input onclick="onChangeDocType('docbasecreate2.jsp','5')" type=radio name=doctype value="5"><%=labelService.getLabelName("402881eb0bcd354e010bcda4b538001a")%>
   		<input type="radio" name="doctype" value="6" checked ><%=labelService.getLabelName("402881db0ddea365010ddede0039001d")%> 
   		</td>
   	</tr>          	
</table>    
<table class=noborder>			
	<tr style="HEIGHT: 100px">
		<td class="FieldName" nowrap width="15%"><%=labelService.getLabelName("402881eb0bcd354e010bcd9dfe6b0017")%></td>
		<td class="FieldValue" colspan="3" >
		<b>请上传正文PDF文件</b>
		<div id="contentfilediv"><input type=file style="WIDTH: 97%;" name=contentfile onchange="checkFiletype('PDF',this)"></div>    	      		
 		</td>
  	</tr>
</table>
</form>
<script language="javascript">
 <!--
function addFile(){
	var url='/document/file/filebrowser.jsp';
	//var path=showModalDialog(url,window,"dialogTop:100px;dialogLeft:100px;dialogHeight:600px;dialogWidth:800px;");
	openWin(url,600,800);
}
function openWin(url,height,width){
	var left=(screen.width-width)/2;
	var top=(screen.height-height)/2-30;
	window.open("<%=request.getContextPath()%>"+url, "", "height="+height+", width="+width+", top="+top+", left="+left+", toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}
 function checkFiletype(filetype,input){
 	if(filetype==null || input==null || input.value=="")return;
 	if(!new RegExp("^.+\.(?=EXT)(EXT)$".replace(/EXT/g, filetype.split(/\s*,\s*/).join("|")), "gi").test(input.value)){
 		alert("请上传格式为"+filetype+"的文件");
 		document.getElementById(input.name+'div').innerHTML = document.getElementById(input.name+'div').innerHTML;
 	}
}
 needcheckforms = "<%=needcheck%>";
function onSubmit(){
  checkfields="subject,categoryid,doctypeid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空



  if(checkForm(EweaverForm,checkfields,checkmessage)){
   	document.EweaverForm.submit();
  }
}

function onSubmitNew(){
  checkfields="subject,categoryid,doctypeid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空



  if(checkForm(EweaverForm,checkfields,checkmessage)){
  	document.all("targetUrl").value="<%=targetUrl2%>";
   	document.EweaverForm.submit();
  }
}

var attachno = 1
function onDraft(){
   	 document.EweaverForm.docstatus.value=0;
   	 onSubmit();
}

function onHiddenShow(id){
  var o = document.getElementById(id);    
  if(o.style.display=='')
	o.style.display='none';
  else
 	o.style.display='';
}

function addattach(){
  var attachtd = document.getElementById('attachtd');
  var oRow = attachtd.insertRow();
  var oCell = oRow.insertCell();
  attachno++;
  oCell.innerHTML = "<input type=file style=\"WIDTH: 97%;\" name=attach"+attachno+">";
}

function onPopup(url){
  var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
  document.EweaverForm.submit();//刷新当前页面
}

function onChangeDocType(doPage,docType){
  if(confirm("<%= labelService.getLabelName("402881eb0bcd354e010bcde5f5970034")%>")){
	window.onbeforeunload=null; 
	if(docType==3){
	location=doPage + "&lastdocid=<%=StringHelper.null2String(request.getParameter("lastdocid"))%>&doctype="  + docType + "&doctypeid="+ document.EweaverForm.doctypeid.value +"&categoryid=" + document.EweaverForm.categoryid.value + "&pid=" + document.EweaverForm.pid.value + "&setSubject="+ document.EweaverForm.setSubject.value +"&&targetUrl=" + document.EweaverForm.targetUrl.value;
	}else{
	location=doPage + "?lastdocid=<%=StringHelper.null2String(request.getParameter("lastdocid"))%>&doctype="  + docType + "&doctypeid="+ document.EweaverForm.doctypeid.value +"&categoryid=" + document.EweaverForm.categoryid.value + "&pid=" + document.EweaverForm.pid.value + "&setSubject="+ document.EweaverForm.setSubject.value +"&&targetUrl=" + document.EweaverForm.targetUrl.value;
	}
	return true;
  }else{
    EweaverForm.sdoctype[0].checked=true;
    return false;
  }
}
 -->
 </script>
 <!--调用browser -->

<script language="javascript">
 function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+viewurl);
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
function onPopup(url){
		var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
	}
	
function fillotherselect(elementobj,fieldid,rowindex){
	
	var elementvalue = Trim(getValidStr(elementobj.value));
	
	var objname = "field_"+fieldid+"_fieldcheck";
	
	var fieldcheck = Trim(getValidStr(document.all(objname).value));
		
	if(fieldcheck=="")
		return;
		
//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql = "select ''  id,' '  objname   from selectitem union (select id,objname from selectitem where pid = '"+elementvalue+"')";

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
			var objname = select_array[loop];
			if(rowindex != -1)
				objname += "_"+rowindex;
		    DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
	
	function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
			
		
		strend = inputname.substring(38);
		
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				pvalue = getValidStr(document.all(pname).value);
				
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
				
			}
			spos = _fieldcheck.indexOf("$",epos+1);
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
			
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				
				var etag = _fieldcheck.substring(epos);
				
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}
 function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    param = parserRefParam(inputname,param);
	idsin = document.all(inputname).value;
	var id;
    try{
    id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id="+refid+"&"+param+"&idsin="+idsin);
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

</script>     
<script language=vbs>

sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	end if
end sub
sub gettime(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("/plugin/clock.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	end if
end sub
</script>

  </body>
</html>

