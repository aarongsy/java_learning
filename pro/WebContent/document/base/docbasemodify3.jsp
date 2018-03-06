<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjlinkService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjlink"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>

<%
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
RefobjlinkService refobjlinkService=(RefobjlinkService)BaseContext.getBean("refobjlinkService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
String docid = StringHelper.null2String(request.getParameter("id"));
Docbase docbase = docbaseService.getPermissionObjectById(docid);
String categoryids = categoryService.getCategoryidStrByObj(docid);
String categorynames = categoryService.getCategoryPath(categoryids,null,null);
List docauthorList = docbaseService.getAuthorList(docid);
List docattachList = docbaseService.getAttachList(docid);
Map authorMap = docbaseService.getAuthorStringMap(docid);
String attachid = StringHelper.null2String(request.getParameter("attachid"));

Orgunit orgunit=null;
Refobjlink refobjlink3=new Refobjlink();
Refobjlink refobjlink=new Refobjlink();
refobjlink.setObjid1(docid);
refobjlink.setObjtypeid1("402881e70bc70ed1010bc710b74b000d");
refobjlink.setObjtypeid2("402881e60bfee880010bff17101a000c");
refobjlink.setLinktype("docbase6");
if((refobjlinkService.getRefobjlink(refobjlink))!=null){
 refobjlink3= refobjlinkService.getRefobjlink(refobjlink);
 }
String orgid=StringHelper.null2String(refobjlink3.getObjid2());
String orgname="";
orgunit=orgunitService.getOrgunit(orgid);
if(orgunit!=null){
orgname=StringHelper.null2String(orgunit.getObjname());
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
parameters.put("object",docbase);
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
  <%titlename=labelService.getLabelName("402881eb0bd712c6010bd733a5790010");%>
  <%@ include file="/base/toptitle.jsp"%>
  
<!--页面菜单开始-->     
<%
paravaluehm.put("{docid}",docid);
paravaluehm.put("{attachid}",attachid);
if(docbase.getDocstatus().intValue()==0)
pagemenustr += "{Z,"+labelService.getLabelName("402881eb0bcd354e010bcd9c4cf20015")+",javascript:onDraft()}";

%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=modify" enctype="multipart/form-data" name="EweaverForm" method="post">
<input type="hidden" value="<%=docbase.getId()%>" name="id">
<input type="hidden" value="1" name="docstatus">
<input type="hidden" value="0" name="isNewVersion">
<input type="hidden" value="<%=docbase.getObjno()%>" name="objno">
<input type="hidden" value="<%=docbase.getPid()%>" name="pid">
<input type="hidden" value="<%=docbase.getCreator()%>" name="creator">
<input type="hidden" value="<%=currentuser.getId()%>" name="modifier">
<input type="hidden" value="6" name="doctype">
<input type="hidden" value="<%=attachid%>" name="attachid">
<input type="hidden" value="" name="delattachid">

<table class=noborder>       	      	
<tr>
	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bcc0939c60009")%></td>
	<td class="FieldValue">
	<input  onchange="checkinput('subject','subjectspan')" style="WIDTH: 97%;" name="subject" value="<%=StringHelper.null2String(docbase.getSubject())%>">
	<span id=subjectspan></span>
 	</td>
</tr>
<tr><!-- 附件格式 -->
	<td class="FieldName" nowrap  width="15%">附件格式</td>
	<td class="FieldValue" colspan="3">
	<select name="extselectitemfield0"   id="extselectitemfield0" style="width: 200px; height: 18px" >
	<%for(int i=0;i<attachType.size();i++){
	Selectitem attachitem=(Selectitem)attachType.get(i);
	%>
	<option value="<%=attachitem.getId()%>" <%if((attachitem.getId()).equals(docbase.getExtselectitemfield0())){%> selected <%}%>><%=attachitem.getObjname()%></option>
	<%}%>
	</select>
	<span id="extselectitemfield0span" name="extselectitemfield0span" ></span>
	</td>
</tr>
<tr>
	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcd9dfe6b0017")%></td>
	<td class="FieldValue" colspan="3">
	<%
     PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext
		.getBean("permissiondetailService");
	int righttype = permissiondetailService.getAttachOpttype(docid);
      		
   		for (int i=0; i<docattachList.size();i++){
   			if(righttype%3==0){
   		%>
		<div id=<%=((Attach)docattachList.get(i)).getId()%>><a href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=((Attach)docattachList.get(i)).getId()%>&download=1"><%=((Attach)docattachList.get(i)).getObjname()%></a>&nbsp;
		<% if(righttype%7==0){%>
		<a title="删除附件" href="javascript:deleteattach('<%=((Attach)docattachList.get(i)).getId()%>')">删除</a>
		<%}%><br>
		</div>
		<%}
		}%>
 		<table class="noborder" id=attachtd>
			<tr>
				<td>
				<input type=file style="WIDTH: 97%;" name=attach1>
				</td>
			</tr>
		</table>
 		</td>
</tr>
<tr>
	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcdaaae37001e")%></td>
	<td class="FieldValue" colspan="3">
		<textarea style="WIDTH: 99%; HEIGHT: 50px" name="docabstract"><%=StringHelper.null2String(docbase.getDocabstract())%></textarea>
 	</td>
</tr> 
</table>

<table class=noborder id="oDiv" style="display:''">
<colgroup>
	<col width="15%">
	<col width="40%">
	<col width="15%">
	<col width="30%">
</colgroup>
   	<tr>
		<td class="FieldName" nowrap>文档安全级别
		</td>
		<td class="FieldValue">    
		<input type="text"  name="docseclevel" value="<%=docbase.getDocseclevel() %>"/>						
		</td>
		<td class="FieldName" nowrap>
		  <%=labelService.getLabelName("402881e30fa73306010fa79e77890883")%><!-- 组织单元-->
		</td>
		<td class="FieldValue">    
	    <button  class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','1');"></button>
		<input type="hidden"  name="orgunitid" value="<%=orgid%>"/>
		<span id="orgunitidspan"/><%=orgname%></span>
		</td>
		
	</tr>
      	<tr>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda6ab3b001b")%></td>
       		<td class="FieldValue" ><input type="hidden" name="categoryid" value="<%=categoryids%>"/>       			
       			<button class=Browser onclick="javascript:getBrowser('/base/category/categorybrowserm.jsp?method=create&model=docbase&categoryid='+document.EweaverForm.categoryid.value,'categoryid','categoryidspan','1');"></button>
          		<span id="categoryidspan"><%=categorynames%></span>	
           	</td>
           	<td class="FieldName"><%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%></td>
        		<td class="FieldValue"><input type="hidden" name="doctypeid" value="<%=StringHelper.null2String(docbase.getTypeid())%>"/>       			
        			<button  class=Browser onclick=""></button>
           		<span id="doctypeidspan"></span>
           	</td>
      	</tr>
      	<tr>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda7ee32001c")%></td>
       		<td class="FieldValue"><button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp','author','authorspan','1');"></button>
          		<span id="authorspan"><%=(String)authorMap.get("authorspan")%></span>
       			<input type="hidden" name="author" value="<%=(String)authorMap.get("author")%>"/>
       		</td>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda88166001d")%></td>
       		<td class="FieldValue">
       			<button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp','author2','author2span','0');"></button>
          		<span id="author2span"><%=(String)authorMap.get("author2span")%></span>
       			<input type="hidden" name="author2" value="<%=(String)authorMap.get("author2")%>"/>
       		</td>
      	</tr>         
   	<tr><td colspan=4>
   	

   	<%=formcontent %>
   	</td></tr>
   	
   	</tbody>
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
  function checkFiletype(filetype,input){
 	if(filetype==null || input==null || input.value=="")return;
 	if(!new RegExp("^.+\.(?=EXT)(EXT)$".replace(/EXT/g, filetype.split(/\s*,\s*/).join("|")), "gi").test(input.value)){
 		alert("请上传格式为"+filetype+"的文件");
 		document.getElementById(input.name+'div').innerHTML = document.getElementById(input.name+'div').innerHTML;
 	}
}
function newVersion(){
  checkfields="subject,categoryid,doctypeid,author,<%=needcheck%>"+needcheckforms;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空

  if(document.EweaverForm.contentfile.value==''){
  	alert('请选择PDF正文文件');
  	return;
  }
  if(checkForm(EweaverForm,checkfields,checkmessage)){
    if(confirm('要保存一个新版本吗？')){
	  	document.EweaverForm.isNewVersion.value=1;
	  	document.EweaverForm.attachid.value="";
	   	document.EweaverForm.submit();
   	}
  }
}

function onSubmit(){
  checkfields="subject,categoryid";//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空



  if(checkForm(EweaverForm,checkfields,checkmessage)){
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
  var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
  document.EweaverForm.submit();//刷新当前页面
}

function onChangeDocType(doPage,docType){
  if(confirm("改变类型后内容会丢失，确认要改变吗？")){
	window.onbeforeunload=null; 
	location=doPage + '?doctype=' + docType;
	return true;
  }else{
    EweaverForm.sdoctype[0].checked=true;
    return false;
  }
}
function onDelete(id){
     if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
     document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=delete";//输入你的Action
	 document.EweaverForm.submit();
   	}
}
function deleteattach(attachid){
   if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
    	document.all(attachid).style.display="none";
    	var delattachid = document.all("delattachid").value;
    	if(delattachid.length==0){
    		document.all("delattachid").value +=attachid;
    	}else{
    		document.all("delattachid").value += "," + attachid;
    	}
  //  	alert(document.all("delattachid").value );
    }
}
 -->
 </script>
 <!--调用browser -->

<script language="javascript">
 function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=window.showModalDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
function onPopup(url){
		var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
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
			var objname =  select_array[loop];
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

function  newrefobj(inputname,inputspan,doctype,viewurl,isneed,docdir){
        params = ""
          targeturl = "<%=URLEncoder.encode(request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=", "UTF-8")%>"
       //params = getRefobjParams(inputname,doctype) ;
        var id;
        try{
            id = window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl,"dialogHeight:"+screen.availHeight+"px;dialogWidth:"+screen.availWidth+"px; center: Yes; help: No; resizable: yes; status: No");

        }catch(e){return}
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
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
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
	end if
end sub
</script>

  </body>
</html>


