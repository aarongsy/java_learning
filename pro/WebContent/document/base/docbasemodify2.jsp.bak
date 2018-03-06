<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/plugin/iWebOfficeConf.jsp"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjlinkService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjlink"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<%
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
RefobjlinkService refobjlinkService=(RefobjlinkService)BaseContext.getBean("refobjlinkService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
String docid = StringHelper.null2String(request.getParameter("id"));
String attachid = StringHelper.null2String(request.getParameter("attachid"));
int mode = NumberHelper.string2Int(request.getParameter("mode"),1);//mode=1,表示正文；mode=2表示附件
String targeturlfordoc = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=";

Docbase docbase = docbaseService.getPermissionObjectById(docid);
int docType = docbase.getDoctype().intValue();
String categoryids = categoryService.getCategoryidStrByObj(docid);
String needcheck = "";

%>
<%
     paravaluehm.put("{id}", docid);
    paravaluehm.put("{attachid}", attachid);
PagemenuService _pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");
List list= _pagemenuService.getPagemenuStrExt(theuri,paravaluehm);
    for(int i=0;i<list.size();i++){
        String str=list.get(i).toString();
         pagemenustr+=str;
    }

String tabStr="";
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
if(mode==1){

	//文档主表单
	String categoryid = null;
	int showreply =1;
	if(categoryService.getCategoryByObj(docid)!=null)
		categoryid = (categoryService.getCategoryidStrByObj(docid));

	Category category = categoryService.getCategoryById(categoryid);
	String formcontent ="";
	Map initparameters = new HashMap();
	Map parameters = new HashMap();
    FormlayoutService fls = (FormlayoutService)BaseContext.getBean("formlayoutService");
    String  layoutid="";
    List layoutlist=fls.getOptLayoutList(docid,OptType.MODIFY);
    for (Object layout : layoutlist) {
            if(layout==null)
            continue;
            if (fls.getFormlayoutById((String) layout).getTypeid() == 2)
                layoutid = fls.getFormlayoutById((String) layout).getId();
            break;
        }
    if(StringHelper.isEmpty(layoutid))
    layoutid=category.getPEditlayoutid();
    if(!StringHelper.isEmpty(layoutid)){
		paravaluehm.put("{id}",docid);
		paravaluehm.put("{typeid}",layoutid);
        ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(layoutid,paravaluehm);
		pagemenustr += menuList.get(0);
        tabStr += menuList.get(1);
	}

if(docbase.getDocstatus().intValue()==0)
 pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcd354e010bcd9c4cf20015")+"','Z','page_white_text',function(){onDraft()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e70d962d51010d96fc26cf0006")+"','O','page_edit',function(){openLocalFile()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e70d962d51010d96fca8720008")+"','S','page_edit',function(){savelocalFile()});";

%>
<html>
  <head>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <style type="text/css">
          #pagemenubar table {
              width: 0
          }
      </style>
      <script type="text/javascript">
           Ext.onReady(function() {
               Ext.QuickTips.init();
           <%if(!pagemenustr.equals("")){%>
               var tb = new Ext.Toolbar();
               tb.render('pagemenubar');
           <%=pagemenustr%>
           <%}%>
                  var contentPanel = new Ext.Panel({
            region:'center',
            layout:'border',
            id:'contentPane',
            renderTo: Ext.get('EweaverForm'),
            deferredRender:false,
            autoScroll:true,
            items: [
                    {
                        region: 'center',
                        contentEl: 'divcontent',

                        autoScroll:true
                    },
                    {
                        region: 'south',
                        contentEl: 'divformcontent',
                         split: true,
                        collapseMode:'mini' ,
                        autoScroll:true,
                         collapsed:true
                    }
                ]
        });
               new Ext.Viewport({
                   layout: 'border',
                   items: [
                         contentPanel
                   ]
               });
           });
      </script>
  </head>
  <body onload="initObject();">
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=modify" enctype="multipart/form-data" name="EweaverForm" method="post">
<table class=noborder>
<tr><td>	

 <%
	parameters.put("bWorkflowform","0");
    parameters.put("isview","0");
	parameters.put("formid","402881e50bff706e010bff7fd5640006");
	parameters.put("objid",docid);
	parameters.put("object",docbase);
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);

	FormService fs = (FormService)BaseContext.getBean("formService");
    parameters = fs.WorkflowView(parameters);

	formcontent = StringHelper.null2String(parameters.get("formcontent"));
	if(formcontent.equals(""))
		formcontent = "<b><font color=red>没有定义对应的布局，请和系统管理员联系！</font></a>";

%>
<input type="hidden" value="<%=docbase.getId()%>" name="id">
<input type="hidden" value="1" name="docstatus">
<input type="hidden" value="0" name="isNewVersion">
<input type="hidden" value="<%=docbase.getObjno()%>" name="objno">
<input type="hidden" value="<%=docbase.getPid()%>" name="pid">
<input type="hidden" value="<%=docbase.getCreator()%>" name="creator">
<input type="hidden" value="<%=currentuser.getId()%>" name="modifier">
<input type="hidden" value="<%=attachid%>" name="attachid">
<input type="hidden" value="" name="oldattachid">
<input type="hidden" value="<%=mode%>" name="mode">
<input type="hidden" value="" name="delattachid">
<input type="hidden" name="categoryid" value="<%=StringHelper.null2String(categoryids)%>"/>
<input type="hidden" value="<%=docbase.getDoctype()%>" name="doctype">


</td></tr>
</table>
</form>
     <div id="divformcontent">
<%=formcontent%>
        </div>
<%}%>

     <div id="divcontent">
        <div id="pagemenubar" style="z-index:100;"></div>
     <div>
          <table class="noborder">
                               <colgroup>
                                   <col width="20%">
                                   <col width="80%">
                               </colgroup>
                                 <td class="FieldName" nowrap>
                                     标题
                               </td>
                                <td class="FieldValue">
                                    <input type="text" class="InputStyle2" style="width:95%" name="title" id="title" value="<%=docbase.getSubject()%>" onblur="evaluate(this)" onChange="fieldcheck(this,'','标题');checkInput('title','titlespan')" />
                                    <span id="titlespan"><img src=<%= request.getContextPath()%>/images/base/checkinput.gif></span>
                               </td>
                           </table>
         </div>
<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="<%=mClassId %>" codebase="<%=mClientName %>">
								<%--<param name="WebUrl" value="<%=mServerUrl%>">--%>
								<%--<param name="RecordID" value="<%=docid%>">--%>
								<%--<param name="Template" value="">--%>
								<%--<param name="FileType" value="<%=docType==4?".doc":".xls"%>">--%>
								<%--<param name="UserName" value="<%=currentuser.getObjname()%>">--%>
								<%--<param name="EditType" value="-1,0,1,1,1,1,0">--%>
								<%--<param name="PenColor" value="#FF0000">--%>
								<%--<param name="PenWidth" value="1">--%>
								<%--<param name="Print" value="false">--%>
								<%--<param name="ShowToolBar" value="0">--%>
								<%--<param name="ShowMenu" value="0">--%>
								<param name="WebUrl" value="<%=mServerUrl%>">
								<param name="RecordID" value="<%=docid%>">
								<param name="Template" value="">
								<param name="FileName" value="">
								<param name="MaxFileSize" value="300*1024">
								<param name="FileType" value="<%=docType==4?".doc":".xls"%>">
	<param name="UserName" value="<%=currentuser.getId()%>">
	<param name="ExtParam" value="">
	<param name="EditType" value="1,1">
	<param name="ShowMenu" value="1">
	<param name="ShowToolbar" value="1"></object>
</div>  
  </div>

<script language="javascript">
 <!--
 function initObject(){
 	document.WebOffice.WebSetMsgByName("ATTACHID",document.EweaverForm.attachid.value);
   	document.WebOffice.WebOpen(); //打开文档
}
function SaveDocument(){
<%if(mode==1){%>
     if(document.all('subject')==null){
  	document.WebOffice.FileName =document.all('title').value + document.WebOffice.FileType;
    }else{
     document.WebOffice.FileName = document.all("subject").value + document.WebOffice.FileType;
    }
<%}%>
 	if (document.WebOffice.WebSave()){
 		document.EweaverForm.oldattachid.value = document.EweaverForm.attachid.value;
		document.EweaverForm.attachid.value = document.WebOffice.WebGetMsgByName("ATTACHID");  
		}

}
function newVersion(){
  checkfields="subject,categoryid";//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空


  //if(checkForm(EweaverForm,checkfields,checkmessage)){
    if(confirm('要保存一个新版本吗？')){
	  	document.EweaverForm.isNewVersion.value=1;
	  	document.WebOffice.WebSetMsgByName("ATTACHID","");
	  	SaveDocument();
	   	document.EweaverForm.submit();
   	}
  //}
}

//作用：保存office正文到本地
function savelocalFile(){
   try{
	document.WebOffice.WebSaveLocalFile();
   }catch(e){}
}

//作用：打开本地office文件
function openLocalFile(){
   try{
	document.WebOffice.WebOpenLocalFile();
   }catch(e){}
}

function onSubmit(){
<%if(mode==1){%>
  checkfields="subject,categoryid,doctypeid,author,<%=needcheck%>";//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空


  if(checkForm(EweaverForm,checkfields,checkmessage)){
  	document.WebOffice.WebSetMsgByName("ATTACHID",document.EweaverForm.attachid.value);
  	SaveDocument();
  	document.EweaverForm.submit();
  }
<%}else{%>
	document.WebOffice.WebSetMsgByName("ATTACHID",document.EweaverForm.attachid.value);
  	SaveDocument();
  	document.EweaverForm.submit();
<%}%>
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

<script type="text/javascript">
        function getVersion(docid,attachid){
     var url ="/document/base/docbaseversion.jsp?id="+docid+"&attachid="+attachid ;
       var id;
    try{
    id=window.showModalDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+url);
    }catch(e){return}
     if (id!=null) {
        if (id[0] != '0') {
            <%if(mode==1){%>
            window.location.href="docbasemodify2.jsp?id="+id[0]+"&attachid="+id[1]
            <%}else{%>
	window.location.href="docbasemodify2.jsp?id="+id[0]+"&attachid="+id[1]+"&mode=2"
            <%}%>
        }
     }
 }
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
</script>
<script language="javascript"> 
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

          function evaluate(obj){
         if(document.all('subject')!=null){
               document.all('subject').readOnly=true;
          document.all('subject').value=obj.value;
         }
          }
</script>     
  <script type="text/javascript">
      function getrefobj(inputname,inputspan,refid,viewurl,isneed){

        if(inputname.substring(3,(inputname.length-6))){
            if(document.getElementById(inputname.substring(3,(inputname.length-6))))
     document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
        }
    var id;
    try{
    id=window.showModalDialog(contextPath+'/base/popupmain.jsp?url='+contextPath+'/base/refobj/baseobjbrowser.jsp?id='+refid);
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
  </body>
</html>

