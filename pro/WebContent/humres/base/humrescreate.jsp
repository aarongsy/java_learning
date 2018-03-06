<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.document.weaverocx.WeaverOcx"%>
<%
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
String stationid = StringHelper.null2String(request.getParameter("stationid"));
String reftype = StringHelper.null2String(request.getParameter("reftype"));
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
if(!sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.HumresService.createHumres")){
	String sUrl="/nopermit.jsp";
	response.sendRedirect(sUrl);
}
%>
<%@ include file="/base/init.jsp"%>
<%
   response.setHeader("cache-control", "no-cache");
   response.setHeader("pragma", "no-cache");
   response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT"); 
   SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
   
	OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
    StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
  	//是否启用附件大小控件检测
	String weatherCheckFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b14fbae82000b").getItemvalue());
	//文档附件大小
	String maxFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b153bbc17000b").getItemvalue());
	String stationtype = StringHelper.null2String(request.getParameter("stationtype"));
	String stationsequence = StringHelper.null2String(request.getParameter("stationsequence"));
    
if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
	Setitem layoutsetitem = setitemService.getSetitem("402880e71284a7ed011284fa24910007");
	
	String layoutid = StringHelper.null2String(layoutsetitem.getItemvalue()).trim();
	if(layoutid.endsWith(".jsp")){
		String allparmsurlstr = "";
		for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
			String paraname = e.nextElement().toString().trim();
			String paravalue = StringHelper.trimToNull(request.getParameter(paraname));
			if(!StringHelper.isEmpty(paraname) && !StringHelper.isEmpty(paravalue) &&!"lastdocid".equals(paraname)){
				allparmsurlstr += "&"+paraname+"="+URLEncoder.encode(paravalue,"UTF-8");
			}
		}
		response.sendRedirect(layoutid+"?go=1"+allparmsurlstr);
		return;	
	}
	
%>
<html>
  <head>
  <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
   </style>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/FormfieldService.js'></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/util.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
      <script  type='text/javascript' src='<%=request.getContextPath()%>/js/workflow.js'></script>
      <LINK media=screen href="<%=request.getContextPath()%>/js/src/widget/templates/HtmlTabSet.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
  </head>
  
 
  <body>
<%if("1".equals(weatherCheckFileSize)){%>
<OBJECT classid="<%=WeaverOcx.clsid%>" codebase="<%=WeaverOcx.codebase%>" id="filecheck" style="display:none"></OBJECT>
<%}%>
<input type="hidden" id="402881e50b14f840010b14fbae82000b" value="<%=weatherCheckFileSize%>" />
<input type="hidden" id="402881e50b14f840010b153bbc17000b" value="<%=maxFileSize%>" />
  
<!--"人事卡片"--> 

<!--页面菜单开始-->     
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_turn_left',function(){history.go(-1)});";

%>
<div id="pagemenubar"></div> 
<!--页面菜单结束-->
                       
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=create" name="EweaverForm" enctype="multipart/form-data"   method="post">
		<input type="hidden" name="reftype"  id="reftype" value="<%=reftype%>"/>
        <input type="hidden" name="layoutid"  id="layoutid" value="<%=layoutid%>"/>
<%
	
	FormService fs = (FormService)BaseContext.getBean("formService");
	String formcontent ="";
	Map initparameters = new HashMap();
	initparameters.put("stationid",stationid);
	initparameters.put("stationtype",stationtype);
	initparameters.put("stationsequence",stationsequence);
    if(!stationid.equals("")){
        Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(stationid);
        if(stationinfo!=null&&stationinfo.getOrgid()!=null)
            initparameters.put("orgid",stationinfo.getOrgid());
    }
	Map parameters = new HashMap();
	
	parameters.put("bWorkflowform","0");
	parameters.put("isview","0");
	parameters.put("formid","402881e80c33c761010c33c8594e0005");
	parameters.put("objid","");
	parameters.put("object",new Humres());
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);
	
	parameters = fs.WorkflowView(parameters);		

	formcontent = StringHelper.null2String(parameters.get("formcontent"));

    String ufscript=StringHelper.null2String(parameters.get("ufscript"));
    String directscript=StringHelper.null2String(parameters.get("directscript"));
    String fieldcalscript = StringHelper.null2String(parameters.get("fieldcalscript"));
    String triggercalscript = StringHelper.null2String(parameters.get("triggercalscript"));
    
    if(formcontent.equals(""))
		formcontent = "<b><font color=red>"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000a")+"</font></a>";//没有定义对应的布局，请和系统管理员联系！
	
	String needcheck = StringHelper.null2String(parameters.get("needcheck"));
	
	
 %>
      <%=formcontent %>
</form> 

<script language="javascript">
    Ext.onReady(function(){
                         Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
            <%=pagemenustr%>
        <%}%>
        });
 function getBrowser(viewurl, inputname, inputspan, isneed) {
            var id;
            try {
                id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                }
            }
        }
    var inputid;
  var spanid;
  var temp;
    [].indexOf || (Array.prototype.indexOf = function(v)
{
	for(var i = this.length; i-- && this[i] !== v;);
	return i;
}
);
 var $j = jQuery.noConflict();
$j(document).ready(function($){
    <%=ufscript%>
  <%=directscript%>
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
        document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
       document.getElementById(spanid.replace("input","span")).innerHTML= data.substring(len,length);
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
    function checkUnique(obj,param,isonly,fieldname,tablename){
    if(obj.value.trim()=='')
    return;
     if(isonly==1||param=="")
     {
        param="select "+fieldname+" from "+tablename+" where "+fieldname+" = ?";
     }
    param=param.replace("?","'"+obj.value.ReplaceAll("'","''")+"'");
   if(SQL(param)!=''){
      alert('<%=labelService.getLabelNameByKeyId("402883d934c119410134c11941a20000")%>') ;//数据已存在,请重新输入！
      obj.value='';
      obj.focus();
   }

  }
    function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;
      temp=0;
  }
function onSubmit(){
   	checkfields="<%=needcheck%>";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	onCal();
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    
</script>     

<script language="javascript"> 
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
          if(document.getElementById('input_'+inputname)!=null)
     document.getElementById('input_'+inputname).value="";
    var param = parserRefParam(inputname,param);
	var idsin = document.all(inputname).value;
	var id;
    try{
    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin);
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
            id = openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl,"dialogHeight:"+screen.availHeight+"px;dialogWidth:"+screen.availWidth+"px; center: Yes; help: No; resizable: yes; status: No");

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

function checkFileSize(filepath,maxSize){
    var size=getFileSize(filepath);
    if(size>maxSize)return false;
    return true;
}
    
function getFileSize(filepath){
	if(filepath==''){
		return null;
	}
	try{
		filecheck.FilePath=filepath;
		var size=filecheck.getFileSize()/(1024*1024);
	    return size;
	}
	catch(e){
		alert(e);
		return null;
	}
	return null;
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
				result = result * tmpval;
			}
			rowindex = 0;
			return result;
		}
		function MAX(param, thisindex){
			this.tempIndex = index;//用于进这个函数志强的index值
			var result = 0;
			for(index=0;index<thisindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				if(tmpval > result)
					result = tmpval;
			}
			index = this.tempIndex;//还原在被此函数用了的index值
			return result;
		}
	}catch(e){
	}
}

var task=new Ext.util.DelayedTask(onCal);
</script>     
<SCRIPT FOR = document EVENT = onselectionchange>
var caldelay=200;
task.delay(caldelay,null,this);
</SCRIPT>  
  <script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
</html>
