<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/plugin/iWebOfficeConf.jsp"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
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


CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");

String categoryid=StringHelper.trimToNull(request.getParameter("categoryid"));
String pid = StringHelper.trimToNull(request.getParameter("pid"));
int docType=NumberHelper.string2Int(request.getParameter("doctype"));
String targetUrl =  StringHelper.trimToNull(request.getParameter("targetUrl"));
String subject = "";

String allparmsurlstr = "";
for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	String paraname = e.nextElement().toString().trim();
	String paravalue = StringHelper.trimToNull(request.getParameter(paraname));
	if(!StringHelper.isEmpty(paraname) && !StringHelper.isEmpty(paravalue) &&!"lastdocid".equals(paraname)){
		allparmsurlstr += "&"+paraname+"="+URLEncoder.encode(paravalue,"UTF-8");
	}
}
allparmsurlstr += "&lastdocid=";
String targetUrl2 = request.getContextPath()+"/document/base/docbasecreate2.jsp?1=1"+allparmsurlstr;
String needcheck  = "";

%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'提交并新建','S','application_form_add',function(){onSubmitNew()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcd354e010bcd9c4cf20015")+"','Z','page_white_text',function(){onDraft()()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e70d962d51010d96fc26cf0006")+"','D','page_edit',function(){openLocalFile()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e70d962d51010d96fca8720008")+"','D','page_save',function(){savelocalFile()});";

%>
<html>
<head>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
     <style type="text/css">
     #pagemenubar table {width:0}
</style>
 <script type="text/javascript">
 var contentPanel=null;
         Ext.onReady(function() {
            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
            <%=pagemenustr%>
               tb.add(new Ext.SplitButton(  {
                arrowTooltip : "更多",
                text:'文档格式',
                menu:new Ext.menu.Menu(  {
                    id: 'mainMenu',
                    items: [
                      {
                        text: 'HTML文档',
                          checked: false,
                          iconCls:Ext.ux.iconMgr.getIcon('application_osx'),
                          checkHandler: onItemCheck1
                    },
                      {
                          text: 'WORD文档',
                          checked: false,
                          iconCls:Ext.ux.iconMgr.getIcon('page_word'),
                          checkHandler: onItemCheck2
                    }, {
                        text: 'EXCEL文档',
                            checked: false,
                            iconCls:Ext.ux.iconMgr.getIcon('table'),
                            checkHandler: onItemCheck3
                    }]
                })
                })
            );
        <%}%>
              contentPanel = new Ext.Panel({
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
                        id:'divformcontentPanel',
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
     function onItemCheck1(item,checked){
       onChangeDocType('docbasecreate.jsp?showHTML=true','3');
     }
     function onItemCheck2(item,checked){
     onChangeDocType('docbasecreate2.jsp','4');
     }
     function onItemCheck3(item,checked){
      onChangeDocType('docbasecreate2.jsp','5');
     }
 </script>
</head>
<body onload="initObject();">

<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=create" enctype="multipart/form-data" name="EweaverForm" method="post">
<table class=noborder>		
<tr><td>	



<!-- 文档主表单 -->
<%
	int showreply =1;

	Category category = categoryService.getCategoryById(categoryid);
	String formcontent ="";
	Map initparameters = new HashMap();
	Map parameters = new HashMap();

	Docbase docbase=new Docbase();
	docbase.setPid(pid);
	if(pid!=null && !"".equals(pid)){
		docbase.setSubject("RE--"+docbaseService.getDocbase(pid).getSubject());
	}

	parameters.put("bWorkflowform","0");
    parameters.put("isview","0");
	parameters.put("formid","402881e50bff706e010bff7fd5640006");
	parameters.put("objid",null);
	parameters.put("object",docbase);
	parameters.put("layoutid",category.getPCreatelayoutid());
	parameters.put("initparameters",initparameters);

	FormService fs = (FormService)BaseContext.getBean("formService");
    parameters = fs.WorkflowView(parameters);

	formcontent = StringHelper.null2String(parameters.get("formcontent"));
	if(formcontent.equals(""))
		formcontent = "<b><font color=red>没有定义对应的布局，请和系统管理员联系！</font></a>";

%>
		<input type="hidden" name="docstatus"	value="1" />
		<input type="hidden" name="doctype"	value=<%=docType%> />
		<input type="hidden" value="" name="attachid">
		<input type="hidden" name="setSubject"	value="<%=setSubject%>"/>
		<input type="hidden" name="creator"		value="<%=currentuser.getId()%>"/>
		<input type="hidden" name="modifier"	value="<%=currentuser.getId()%>"/>
		<input type="hidden" name="targetUrl"	value="<%=URLEncoder.encode(StringHelper.null2String(targetUrl))%>"/>
		<input type="hidden" name="categoryid"	value="<%=StringHelper.null2String(categoryid)%>"/>
    <input type="hidden" name="pid"	value="<%=StringHelper.null2String(pid)%>"/>


</td></tr>
</table>
</form>
 <div id="divformcontent">
     <%=formcontent%>
  </div>
 <div id="divcontent">
         <div id="pagemenubar" style="z-index:100;"></div>
     <div id="contentDiv">
          <table class="noborder">
                               <colgroup>
                                   <col width="20%">
                                   <col width="80%">
                               </colgroup>
                                 <td class="FieldName" nowrap>
                                     标题
                               </td>
                                <td class="FieldValue">
                                    <input type="text" class="InputStyle2" style="width:95%" name="title" id="title" value="" onblur="evaluate(this)" onChange="fieldcheck(this,'','标题');checkInput('title','titlespan')" />
                                    <span id="titlespan"><img src=<%= request.getContextPath()%>/images/base/checkinput.gif></span>
                               </td>
                           </table>
         </div>
     <div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;" >
<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="<%=mClassId %>" codebase="<%=mClientName %>">
	<param name="WebUrl" value="<%=mServerUrl%>">
	<param name="RecordID" value="">
	<param name="Template" value="">
	<param name="FileName" value="">
	<param name="FileType" value="<%=docType==4?".doc":".xls"%>">
	<param name="UserName" value="<%=currentuser.getId()%>">
	<param name="ExtParam" value="">
	<param name="EditType" value="1,1">
	<param name="MaxFileSize" value="300*1024">
	<param name="ShowMenu" value="1">
	<param name="ShowToolbar" value="1">
</object>
</div>
 </div>

<script language="javascript">
//初始化对象

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

function initObject(){
    document.WebOffice.WebOpen();
}

//作用：打开服务器文档



function LoadDocument(){
  if (!EweaverForm.WebOffice.WebOpen()){  	 //打开该文档    交互OfficeServer的OPTION="LOADFILE"
     alert(EweaverForm.WebOffice.Status);    //显示状态，从OfficeServer中读取



  }else{
     alert(EweaverForm.WebOffice.Status);    //显示状态，从OfficeServer中读取



  }
}

//作用：保存服务文档



function SaveDocument(){
    if(document.all('subject')==null){
  	document.WebOffice.FileName =document.all('title').value + document.WebOffice.FileType;
    }else{
     document.WebOffice.FileName = document.EweaverForm.subject.value + document.WebOffice.FileType;
    }
  	if (document.WebOffice.WebSave())
  		document.EweaverForm.attachid.value = document.WebOffice.WebGetMsgByName("ATTACHID");
}


//作用：打印文档



function WebOpenPrint(){
  try{
    EweaverForm.WebOffice.WebOpenPrint();
    StatusMsg(EweaverForm.WebOffice.Status);
  }catch(e){}
}


//作用：页面设置



function WebOpenPageSetup(){
   try{
	if (EweaverForm.WebOffice.FileType==".doc"){
	  EweaverForm.WebOffice.WebObject.Application.Dialogs(178).Show();
	}
	if(EweaverForm.WebOffice.FileType==".xls"){
	  EweaverForm.WebOffice.WebObject.Application.Dialogs(7).Show();
	}
   }catch(e){}
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
</script>
<script language="javascript">
 needcheckforms = "<%=needcheck%>";
function onSubmit(){
	checkfields="subject,categoryid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空



	if(checkForm(EweaverForm,checkfields,checkmessage)){	
		SaveDocument();
		document.EweaverForm.submit();
	}
}


function onSubmitNew(){
	checkfields="subject,categoryid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空



	if(checkForm(EweaverForm,checkfields,checkmessage)){	
		SaveDocument();
  		document.all("targetUrl").value="<%=targetUrl2%>";
		document.EweaverForm.submit();
	}
}

function onDraft(){
	 document.all("docstatus").value="0";
   	 onSubmit();
}
var attachno = 1;

function addattach(){
  var attachtd = document.getElementById('attachtd');
  var oRow = attachtd.insertRow();
  var oCell = oRow.insertCell();
  attachno++;
  oCell.innerHTML = "<input type=file style=\"WIDTH: 97%;\" name=attach"+attachno+">";
}

function onHiddenShow(id){
  var o = document.getElementById(id);    
  if(o.style.display=='')
	o.style.display='none';
  else
 	o.style.display='';
}

function onPopup(url){
  var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
  document.EweaverForm.submit();//刷新当前页面
}

function onChangeDocType(doPage,docType){
  if(confirm("改变类型后内容会丢失，确认要改变吗？")){
	window.onbeforeunload=null; 
	if(docType==3){
	location=doPage + "&lastdocid=<%=StringHelper.null2String(request.getParameter("lastdocid"))%>&doctype="  + docType + "&categoryid=" + document.EweaverForm.categoryid.value + "&pid=" + document.EweaverForm.pid.value + "&setSubject="+ document.EweaverForm.setSubject.value +"&&targetUrl=" + document.EweaverForm.targetUrl.value;
	}else{
	location=doPage + "?lastdocid=<%=StringHelper.null2String(request.getParameter("lastdocid"))%>&doctype="  + docType + "&categoryid=" + document.EweaverForm.categoryid.value + "&pid=" + document.EweaverForm.pid.value + "&setSubject="+ document.EweaverForm.setSubject.value +"&&targetUrl=" + document.EweaverForm.targetUrl.value;
	}
	return true;
  }else{
    EweaverForm.doctype[0].checked=true;
    return false;
  }
}
 -->
 </script>
 <!--调用browser -->
<script language="javascript">
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
</script>
 <script type="text/javascript">
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
       function evaluate(obj){
         if(document.all('subject')!=null){
        document.all('subject').readOnly=true;
          document.all('subject').value=obj.value;
         }
      }
 </script>
  </body>
</html>
