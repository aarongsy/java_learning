<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
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
<%@ page import="java.io.InputStream" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.cowork.service.CoworksetService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%
/*获取协作区设置信息*/
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
//新建文档的
String targeturlfordoc = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=";
DataService ds = new DataService();
CoWorkService cwService = new CoWorkService();
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
//获取参数
String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
String editmode = StringHelper.null2String(request.getParameter("editmode")).trim();
String isedit = StringHelper.null2String(request.getParameter("isedit"));
if(StringHelper.isEmpty(editmode))
	editmode = "0";
String formid="";
String replyformid="";
String layoutid = "";//布局id
Coworkset coworkset = CoworkHelper.getCoworkset();
if(coworkset!=null && !"".equals(coworkset.getId())){
	formid = StringHelper.null2String(coworkset.getFormid());
	replyformid = StringHelper.null2String(coworkset.getReplyformid());
	if("0".equals(editmode)){
		if(StringHelper.isEmpty(requestid)){
			layoutid = StringHelper.null2String(coworkset.getCreatelayout());
		}else{
			layoutid = StringHelper.null2String(coworkset.getEditlayout());
		}
	}else{
		if(isedit.equals("1")){
			layoutid = StringHelper.null2String(coworkset.getEditlayout());
		}else{
			layoutid = StringHelper.null2String(coworkset.getViewlayout());
		}
	}
}else{
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
//初始化Service类
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
FormService fs = (FormService) BaseContext.getBean("formService");
FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
FormBaseService fbs = (FormBaseService)BaseContext.getBean("formbaseService");
CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");

Map parameters = new HashMap();
String bNewworkflow = "1"; //是否新建表单
String bView="0"; //如果需要显示布局 则 bView="1"
if(!StringHelper.isEmpty(requestid) && "1".equals(StringHelper.null2String(request.getParameter("isshow")))){ 
	bView="1";
}
String bWorkflowform="2";
String bviewmode="2"; 
String workflowid=""; 
String nodeid="";
String initparameterstr ="";

Map initparameters = new HashMap();
if("1".equals(editmode)){ // 编辑页面
	bNewworkflow="0";
	initparameters.put("requestid",requestid);
	initparameters.put("editmode",editmode);
	parameters.put("layoutid",layoutid);
	parameters.put("bView",bView);
	parameters.put("bNewworkflow",bNewworkflow);
	parameters.put("bWorkflowform",bWorkflowform);
	parameters.put("initparameters",initparameters); 
	parameters.put("bviewmode",bviewmode);
	parameters.put("requestid",requestid);
	parameters.put("workflowid",workflowid);
	parameters.put("formid",formid);
	parameters.put("nodeid",nodeid);
}else{ //首次打开新建
	parameters.put("bNewworkflow",bNewworkflow);
	parameters.put("bView",bView);
	parameters.put("bWorkflowform",bWorkflowform);
	parameters.put("bviewmode",bviewmode);
	parameters.put("workflowid",workflowid);
	parameters.put("nodeid",nodeid);
	parameters.put("formid",formid);
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);
}
parameters = fs.WorkflowView(parameters);
layoutid = StringHelper.null2String(parameters.get("layoutid"));
String needcheckfields = StringHelper.null2String(parameters.get("needcheck"));
String formcontent = StringHelper.null2String(parameters.get("formcontent"));
String fieldcalscript = StringHelper.null2String(parameters.get("fieldcalscript"));
String onaddrowscript = StringHelper.null2String(parameters.get("onaddrowscript"));
String triggercalscript=StringHelper.null2String(parameters.get("triggercalscript"));
String ufscript=StringHelper.null2String(parameters.get("ufscript"));
String directscript=StringHelper.null2String(parameters.get("directscript"));
String fieldJSFormulas=StringHelper.null2String(parameters.get("fieldJSFormulas"));
String categoryfield="";
if (!StringHelper.isEmpty(formid)) {
    List<Formfield> fields = formfieldService.getAllFieldByFormId(formid);
    for(Formfield field:fields){
        if(field.getFieldname().equalsIgnoreCase("categoryid")){
           categoryfield="field_"+field.getId();
            break;
        }
    }
}
//菜单初始化
if("1".equals(editmode)){
	if(isedit.equals("1")){
		pagemenustr ="addBtn(tb,'"+labelService.getLabelName("提交")+"','S','accept',function(){onSubmit(2)});";//提交按钮
	}else{
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("编辑")+"','E','application_form_edit',function(){onEdit()});";//返回
	}
}else{
	pagemenustr ="addBtn(tb,'"+labelService.getLabelName("提交")+"','S','accept',function(){onSubmit(2)});";//提交按钮   
}
String pagemenustr2 ="addBtn(tb2,'"+labelService.getLabelName("保存")+"','C','accept',function(){onSave2()});";//提交按钮
String pagemenustr3 ="addBtn(tb3,'"+labelService.getLabelName("保存")+"','H','accept',function(){onSave3()});";//提交按钮
String pagemenustr4 ="addBtn(tb4,'"+labelService.getLabelName("保存")+"','W','accept',function(){onSave4()});";//提交按钮
//是否启用附件大小控件检测
String weatherCheckFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b14fbae82000b").getItemvalue());
//文档附件大小
String maxFileSize=StringHelper.null2String(setitemService0.getSetitem("402881e50b14f840010b153bbc17000b").getItemvalue());
%>
<html>
 <head>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/interface/SelectitemService.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/document.js'></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
<LINK media=screen href="<%= request.getContextPath()%>/js/src/widget/templates/HtmlTabSet.css" type="text/css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    .x-panel-btns-ct {
         padding: 0px;
    }
    .x-panel-btns-ct table {width:0}
    .x-panel-body {
         border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
         border-right:#99bbe8 0px solid
    }
    .x-panel-body-noheader{
         border-top:#99bbe8 0px solid
    }
</style>
<script type="text/javascript">
var tb =null;
var tb2 =null;
var tb3 =null;
var tb4 =null;
Ext.onReady(function() {
   Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
   <%}%>
   <%if(!StringHelper.isEmpty(requestid) && !pagemenustr2.equals("")){%>
       tb2 = new Ext.Toolbar();
       tb2.render('pagemenubar2');
       <%=pagemenustr2%>
   <%}%>
   <%if(!StringHelper.isEmpty(requestid) && !pagemenustr3.equals("")){%>
       tb3 = new Ext.Toolbar();
       tb3.render('pagemenubar3');
       <%=pagemenustr3%>
   <%}%>
   <%if(!StringHelper.isEmpty(requestid) && !pagemenustr4.equals("")){%>
       tb4 = new Ext.Toolbar();
       tb4.render('pagemenubar4');
       <%=pagemenustr4%>
   <%}%>
   <%if(!StringHelper.isEmpty(requestid)){%>
   var maintabPanel = new Ext.TabPanel({
        height:'auto',   
        width:'100%',   
        autoTabs:true,                  //自动扫描页面中的有效div然后转换为标签   
        deferredRender:false,           //不进行延时渲染   
        //deferredRender:true,   
        activeTab:0,                    //默认激活第一个标签   
        animScroll:true,               //使用动画滚动效果   
        enableTabScroll:true,          //tab标签超宽时自动出现滚动条   
        applyTo:'panel'                //此处必须使用applayTo定位 
	});
   <%}%>
});
  
//来自 formbase.jsp
var fieldJSFormulas = <%=fieldJSFormulas%>;
var needchecklists = "<%=needcheckfields%>";
var id = "<%=StringHelper.null2String(coworkset.getId())%>";
var workflowid = "<%=StringHelper.null2String(workflowid)%>";
var nodeid = "<%=StringHelper.null2String(nodeid)%>";

</script>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script> <!-- 之前的jquery不支持属性*= -->
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/aop.pack.js"></script>    
<script type="text/javascript" src="/js/main.js"></script>    
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" language="javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<style>
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>
<script type="text/javascript">
    var jq = jQuery.noConflict();
    var win;
	function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
	    //if (document.getElementById(inputname.replace("field", "input")) != null) {
	    //    document.getElementById(inputname.replace("field", "input")).value = "";
	   // }
	    var fck = param.indexOf("function:");
	    if (fck > -1) {
	    }
	    else {
	        var param = parserRefParam(inputname, param);
	    }
	    var idsin = document.getElementById(inputname).value;
	    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
	    
	    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
	        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
	    }
	    var id;
	    /*
	     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
	     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
	     */
	    var isStationBrowserInSafari = jQuery.browser.safari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
	    //流程单选 || 工作流程单选 || 工作流程多选
		var isWorkflowBrowserInSafari = jQuery.browser.safari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
		//员工多选
		var isHumresBrowserInSafari = jQuery.browser.safari && refid == '402881eb0bd30911010bd321d8600015';	
		if(!Ext.isSafari){
	        try {
	            // id=openDialog(url,idsin);
	            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
	        } 
	        catch (e) {
	            return
	        }
	        if (id != null) {
	        
	            if (id[0] != '0') {
	                document.getElementById(inputname).value = id[0];
	                document.getElementById(inputspan).innerHTML = id[1];
	                if (fck > -1) {
	                    funcname = param.substring(9);
	                    scripts = "valid=" + funcname + "('" + id[0] + "');";
	                    eval(scripts);
	                    if (!valid) { //valid默认的返回true;
	                    	document.getElementById(inputname).value = '';
	                        if (isneed == '0') 
	                        	document.getElementById(inputspan).innerHTML = '';
	                        else 
	                        	document.getElementById(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    }
	                }
	            }
	            else {
	            	document.getElementById(inputname).value = '';
	                if (isneed == '0') 
	                	document.getElementById(inputspan).innerHTML = '';
	                else 
	                	document.getElementById(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                
	            }
	        }
	    }
	    else {
	        url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
	        var callback = function(){
	            try {
	                id = dialog.getFrameWindow().dialogValue;
	            } 
	            catch (e) {
	            }
	            if (id != null) {
	                if (id[0] != '0') {
	                    document.all(inputname).value = id[0];
	                    WeaverUtil.fire(document.all(inputname));
	                    document.all(inputspan).innerHTML = id[1];
	                    if (fck > -1) {
	                        funcname = param.substring(9);
	                        scripts = "valid=" + funcname + "('" + id[0] + "');";
	                        eval(scripts);
	                        if (!valid) { //valid默认的返回true;
	                            document.all(inputname).value = '';
	                            if (isneed == '0') 
	                                document.all(inputspan).innerHTML = '';
	                            else 
	                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                        }
	                    }
	                }
	                else {
	                    document.all(inputname).value = '';
	                    if (isneed == '0') 
	                        document.all(inputspan).innerHTML = '';
	                    else 
	                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    
	                }
	            }
	        }
		    var winHeight = Ext.getBody().getHeight() * 0.9;
		    var winWidth = Ext.getBody().getWidth() * 0.9;
		    if(winHeight>500){//最大高度500
		    	winHeight = 500;
		    }
		    if(winWidth>880){//最大宽度800
		    	winWidth = 880;
		    }
	        if (!win) {
	            win = new Ext.Window({
	                layout: 'border',
	                width:winWidth,
	                height:winHeight,
	                plain: true,
	                modal: true,
	                items: {
	                    id: 'dialog',
	                    region: 'center',
	                    iconCls: 'portalIcon',
	                    xtype: 'iframepanel',
	                    frameConfig: {
	                        autoCreate: {
	                            id: 'portal',
	                            name: 'portal',
	                            frameborder: 0
	                        },
	                        eventsFollowFrameLinks: false
	                    },
	                    closable: false,
	                    autoScroll: true
	                }
	            });
	        }
	        win.close = function(){
	            this.hide();
	            win.getComponent('dialog').setSrc('about:blank');
	            callback();
	        }
	        win.render(Ext.getBody());
	        var dialog = win.getComponent('dialog');
	        dialog.setSrc(url);
	        win.show();
	    }
	}
    function  newrefobj(inputname,inputspan,doctype,viewurl,isneed,docdir){
        params = ""
        targeturl = "<%=URLEncoder.encode(targeturlfordoc, "UTF-8")%>"
        var url = "/base/popupmain.jsp?url=/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl;
        var id;
        try{
            id = openDialog(url);

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
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }
    function onEdit(){
    	document.location.href="/app/cooperation/createcowork.jsp?requestid=<%=requestid%>&editmode=1&isedit=1";
    }
    
    function onSave2(){
       var id = document.getElementById('id2').value;
	   var orgid=document.getElementById('orgid2').value;
	   var creator=document.getElementById('creator2').value;
	   var createdate=document.getElementById('createdate2').value;
	   var createtime=document.getElementById('createtime2').value;
	   var coworklevel="";
		  var radio=document.getElementsByName("coworklevel2");
		  for(var i=0;i<radio.length;i++){
			if(radio[i].checked==true){
			  coworklevel=radio[i].value;
			  break;
			}
		  }
	   var begindate=document.getElementById('begindate2').value;
	   var begintime=document.getElementById('begintime2').value;
	   var datetype=document.getElementById('datetype').value;
	   var enddate=document.getElementById('enddate2').value;
	   var endtime=document.getElementById('endtime2').value;
	   var isshowunread=document.getElementById('isshowunread2').value;
	   var isreply=document.getElementById('isreply2').value;
	   var isshowreply=document.getElementById('isshowreply2').value;
	   var isquote=document.getElementById('isquote2').value;
	   var isshowadd=document.getElementById('isshowadd2').value;
	   var viewtype=document.getElementById('viewtype2').value;
	   var showlayoutid=document.getElementById('showlayoutid2').value;
	   var showaddlayout=document.getElementById('showaddlayout2').value;
	   if(begindate=='' || begintime=='' ){
	     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
	       return;
	   }
	   if(datetype=="1"){
		   if(enddate=='' || endtime=='' ){
		     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
		       return;
		   }
	   }
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=saverule',
	       params:{id:id,requestid:'<%=requestid%>',orgid:orgid,creator:creator,createdate:createdate,createtime:createtime,coworklevel:coworklevel,begindate:begindate,begintime:begintime,datetype:datetype,enddate:enddate,endtime:endtime,isshowunread:isshowunread,isreply:isreply,isshowreply:isshowreply,isquote:isquote,isshowadd:isshowadd,viewtype:viewtype,showlayoutid:showlayoutid,showaddlayout:showaddlayout},
	       sync:true,
	       success: function() {
	           pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
	       }
	   });
    }
    
    function checkEmpty(obj,spanstr){
	var value = obj.value;
	if(value && value!=''){
		document.getElementById(spanstr).innerHTML="";
	}else{
		document.getElementById(spanstr).innerHTML="<img src='<%=request.getContextPath()%>/images/base/checkinput.gif'>";
	}
    }
    
    function checkEndDate(obj){
      var value=obj.value;
      var enddate = document.getElementById("enddate");
      if(value==="0"){
        enddate.style.display="none";
      }else{
    	//enddate.style.display="block";
        enddate.style.display="";//在新建协作的规则设置TAB页中，当结束日期限制为指定范围时，结束日期、结束时间在表格中显示错位
      }
    }
</script>
</head>
<body>
<input type="hidden" id="weatherCheckFileSize" value="<%=weatherCheckFileSize%>" />
<input type="hidden" id="maxFileSize" value="<%=maxFileSize%>" />
<div id="panel">   
<div class="x-tab"  title="基本信息">
<div id="pagemenubar"></div>
<form action="/ServiceAction/com.eweaver.app.cooperation.CoworkAction" target="_self" enctype="multipart/form-data"  name="EweaverForm"  id="EweaverForm"  method="post">
<input type="hidden" name="action" value="savecowork">
<%if("0".equals(editmode)){ %>
<input type="hidden" name="type" value="createcowork">
<%}else if ("1".equals(editmode)){ %>	
<input type="hidden" name="type" value="updatecowork">
<%}%>
<input type="hidden" name="targetUrl">
<input type="hidden" name="formid" value="<%=formid%>">
<input type="hidden" name="layoutid" value="<%=layoutid%>">
<input type="hidden" name="requestid" value="<%=requestid%>">
<input type="hidden" name="editmode" value="<%=editmode%>">
<div id="formcomtentDIV">
<%=formcontent%>
</div>
</form>
</div>   
<%if(!StringHelper.isEmpty(requestid)){ %>
<div class="x-tab" title="规则设置">
<%
List<Map<String,Object>> list2 = ds.getValues("select * from COWORKRULE where requestid='"+requestid+"' and ISDELETE=0");
Map<String,Object> m2 = new HashMap<String,Object>();
boolean temp2=false;
if(list2!=null && list2.size()>0){
	m2=list2.get(0);
	temp2=true;
}
%>
<div id="pagemenubar2"style="z-index:100;"></div>
		 <table class=layouttable border="1">
				<colgroup> 
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>	
                <tr>
					<td class="FieldName" nowrap>
					<%if(temp2){
					String id2=StringHelper.null2String(m2.get("id"));
					%>
				    <input type="hidden" id="id2" name="id2" value="<%=id2 %>">		
					<%}else{ %>
					<input type="hidden" id="id2" name="id2" value="">
					<%} %>
					创建者
					</td>
					<td class="FieldValue" >
					  <%if(temp2){
					  String humresid = StringHelper.null2String(m2.get("creator"));
					  String hobjname = ds.getValue("select objname from humres where id='"+humresid+"'");
					  %>
						  <a href=javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=humresid%>','<%=hobjname %>','tab<%=humresid%>') >&nbsp;<%=hobjname%>&nbsp;</a>
						  <input type="hidden" id="creator2" name="creator2" value="<%=humresid%>">
					  <%}else{%>
						  <a href=javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=eweaveruser.getHumres().getId()%>','<%=eweaveruser.getHumres().getObjname() %>','tab<%=eweaveruser.getHumres().getId()%>') >&nbsp;<%=eweaveruser.getHumres().getObjname() %>&nbsp;</a>
						  <input type="hidden" id="creator2" name="creator2" value="<%=eweaveruser.getHumres().getId()%>">
					  <%}%>
					</td>
					<td class="FieldName" nowrap>
					部门
					</td>
					<td class="FieldValue" >
					   <%if(temp2){
						   String orgid = StringHelper.null2String(m2.get("orgid"));
						   String oobjname = ds.getValue("select objname from orgunit where id='"+orgid+"'");
					   %><input type="hidden" id="orgid2" name="orgid2" value="<%=orgid%>"><%=oobjname%><%
					   }else{
						   String oobjname = ds.getValue("select objname from orgunit where id='"+eweaveruser.getOrgid()+"'");
						   %><input type="hidden" id="orgid2" name="orgid2" value="<%=eweaveruser.getOrgid() %>"><%=oobjname%><%
					   } %>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					创建日期
					</td>
					<td class="FieldValue" >
					   <%if(temp2){
						   String createdate = StringHelper.null2String(m2.get("createdate"));
					   %><input type="hidden" id="createdate2" name="createdate2" value="<%=createdate%>"><%=createdate%><%
					   }else{
						   %><input type="hidden" id="createdate2" name="createdate2" value="<%=DateHelper.getCurrentDate() %>"><%=DateHelper.getCurrentDate() %><%
					   } %>
					</td>
					<td class="FieldName" nowrap>
					创建时间
					</td>
					<td class="FieldValue" >
					    <%if(temp2){
						   String createtime = StringHelper.null2String(m2.get("createtime"));
					   %><input type="hidden" id="createtime2" name="createtime2" value="<%=createtime%>"><%=createtime%><%
					   }else{
						   %><input type="hidden" id="createtime2" name="createtime2" value="<%=DateHelper.getCurrentTime() %>"><%=DateHelper.getCurrentTime() %><%
					   } %>
					</td>
				</tr>
				<tr style="display: none;">
					<td class="FieldName" nowrap>
					重要程度
					</td>
					<td class="FieldValue" colspan="3">
					   <%if(temp2){
						   int coworklevel = Integer.parseInt(m2.get("coworklevel")+""); 
						   %>
						   <input type="radio" name="coworklevel2" value="0" id="coworklevel0" <%if(coworklevel==0){ %> checked="checked"<%} %>/>正常&nbsp;&nbsp;&nbsp;&nbsp;
					       <input type="radio" name="coworklevel2" value="1" id="coworklevel1" <%if(coworklevel==1){ %> checked="checked"<%} %>/>紧急
						  <%
					   }else{ %>
					    <input type="radio" name="coworklevel2" value="0" id="coworklevel0" checked="checked"/>正常&nbsp;&nbsp;&nbsp;&nbsp;
					    <input type="radio" name="coworklevel2" value="1" id="coworklevel1"/>紧急
					    <%} %>
					</td>
				</tr>
				<tr>
				<%
				String begindate ="";
				String begintime = "";
				String enddate="";
				String endtime="";
				String datetype="";
				if(temp2){
					begindate = StringHelper.null2String(m2.get("begindate"));
					begintime = StringHelper.null2String(m2.get("begintime"));
					enddate = StringHelper.null2String(m2.get("enddate"));
					endtime = StringHelper.null2String(m2.get("endtime"));
					datetype = StringHelper.null2String(m2.get("datetype"));
				}
				%>
					<td class="FieldName" nowrap>
					起始日期
					</td>
					<td class="FieldValue" >
					    <input type="text" onchange="checkEmpty(this,'begindate2span')" name="begindate2" id="begindate2" class=inputstyle value="<%=begindate%>"  onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','请假开始日期');return false;" datecheck="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)" >
					    <span id="begindate2span"><%if(StringHelper.isEmpty(begindate)){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
					<td class="FieldName" nowrap>
					起始时间
					</td>
					<td class="FieldValue" >
					    <input type="text" onchange="checkEmpty(this,'begintime2span')" name="begintime2" id="begintime2" class=inputstyle value="<%=begintime%>" onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})" onblur="fieldcheck(this,'^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$','请假开始时间')" >
					    <span id="begintime2span"><%if(StringHelper.isEmpty(begintime)){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					结束日期限制
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="datetype" name="datetype" onchange="checkEndDate(this);">
					    <option value="1" <%if("1".equals(datetype)){%>selected="selected" <%} %>>指定范围</option>
					    <option value="0" <%if("0".equals(datetype)){%>selected="selected" <%} %>>长期有效</option>
					    </select>
					</td>
				</tr>
				<tr id="enddate" style="display:<%if("0".equals(datetype)){ %> none;<%} %>">
					<td class="FieldName" nowrap>
					结束日期
					</td>
					<td class="FieldValue" >
					    <input type="text" onchange="checkEmpty(this,'enddate2span')" name="enddate2" id="enddate2" class=inputstyle value="<%=enddate%>"  onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','请假开始日期');return false;" datecheck="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)" >
					    <span id="enddate2span"><%if(StringHelper.isEmpty(enddate)){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
					<td class="FieldName" nowrap>
					结束时间
					</td>
					<td class="FieldValue" >
					    <input type="text" onchange="checkEmpty(this,'endtime2span')" name="endtime2" id="endtime2" class=inputstyle value="<%=endtime%>" onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})" onblur="fieldcheck(this,'^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$','请假开始时间')" >
					    <span id="endtime2span"><%if(StringHelper.isEmpty(endtime)){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<%
				int isshowunread =0;
				int isreply = 0;
				int isshowreply=0;
				int isquote=0;
				int isshowadd =0;
				int viewtype = 0;
				String  showlayoutid="";
				String showaddlayout="";
				if(temp2){
					isshowunread = Integer.parseInt(m2.get("isshowunread")+"");
					isreply = Integer.parseInt(m2.get("isreply")+"");
					isshowreply = Integer.parseInt(m2.get("isshowreply")+"");
					isquote = Integer.parseInt(m2.get("isquote")+"");
					isshowadd = Integer.parseInt(m2.get("isshowadd")+"");
					viewtype = Integer.parseInt(m2.get("viewtype")+"");
					showlayoutid = StringHelper.null2String(m2.get("showlayoutid"));
					showaddlayout= StringHelper.null2String(m2.get("showaddlayout"));
				}
				%>
				<tr>
					<td class="FieldName" nowrap>
					是否显示未查看数
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="isshowunread2" name="isshowunread2">
					    <option value="0" <%if(isshowunread==0){%>selected="selected"<%}%>>是</option>
					    <option value="1" <%if(isshowunread==1){%>selected="selected"<%}%>>否</option>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					是否允许回复
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="isreply2" name="isreply2">
					    <option value="0" <%if(isreply==0){%>selected="selected"<%}%>>是</option>
					    <option value="1" <%if(isreply==1){%>selected="selected"<%}%>>否</option>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					是否显示回复数
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="isshowreply2" name="isshowreply2">
					    <option value="0" <%if(isshowreply==0){%>selected="selected"<%}%>>是</option>
					    <option value="1" <%if(isshowreply==1){%>selected="selected"<%}%>>否</option>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					是否允许引用
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="isquote2" name="isquote2">
					    <option value="0" <%if(isquote==0){%>selected="selected"<%}%>>是</option>
					    <option value="1" <%if(isquote==1){%>selected="selected"<%}%>>否</option>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					是否显示相关资源
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="isshowadd2" name="isshowadd2">
					    <option value="0" <%if(isshowadd==0){%>selected="selected"<%}%>>是</option>
					    <option value="1" <%if(isshowadd==1){%>selected="selected"<%}%>>否</option>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					是否显示附加信息
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="viewtype2" name="viewtype2">
					    <option value="0" <%if(viewtype==0){%>selected="selected"<%}%>>是</option>
					    <option value="1" <%if(viewtype==1){%>selected="selected"<%}%>>否</option>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					附加功能显示布局
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="showaddlayout2" name="showaddlayout2">
					    <%
					    String sql="SELECT id,layoutname FROM formlayout WHERE formid='"+replyformid+"' and typeid='2' and isdelete=0"; 
					    List<Map<String,String>> selectl = ds.getValues(sql);
					    if(selectl!=null && selectl.size()>0){
					    	for(Map<String,String> m:selectl){
					    		if(!"".equals(showaddlayout)){
					    		%>
					    		<option value="<%=m.get("id") %>" <%if(showaddlayout.equals(m.get("id"))){%>selected="selected"<%}%>><%=m.get("layoutname") %></option>
					    		<%}else{%>
					    		<option value="<%=m.get("id") %>" <%if(m.get("id").equals(coworkset.getDefshow2())){%>selected="selected"<%}%>><%=m.get("layoutname") %></option>
					    		<%
					    		}
					    	}
					    }
					    %>
					    </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作描述显示布局
					</td>
					<td class="FieldValue" colspan="3">
					    <select id="showlayoutid2" name="showlayoutid2">
					    <%
					    String sql1="SELECT id,layoutname FROM formlayout WHERE formid='"+formid+"' and typeid='1' and isdelete=0"; 
					    List<Map<String,String>> selectlsit = ds.getValues(sql1);
					    if(selectlsit!=null && selectlsit.size()>0){
					    	for(Map<String,String> m:selectlsit){
					    		if(!"".equals(showlayoutid)){
						    		%>
						    		<option value="<%=m.get("id") %>" <%if(showlayoutid.equals(m.get("id"))){%>selected="selected"<%}%>><%=m.get("layoutname") %></option>
						    		<%
					    		}else{
					    			%>
						    		<option value="<%=m.get("id") %>" <%if(m.get("id").equals(coworkset.getDefshow1())){%>selected="selected"<%}%>><%=m.get("layoutname") %></option>
						    		<%	
					    		}
					    	}
					    }
					    %>
					    </select>
					</td>
				</tr>
		</table>
</div> 
<div class="x-tab" title="权限定义">
<script type="text/javascript" >
function addRow3(){
	var table = document.getElementById("table3");
	var rowscount = table.rows.length-1;
	var row = table.insertRow(table.rows.length);
	row.setAttribute("id","row3"+rowscount);
	row.style.display="";
	var cell1 = row.insertCell(0);
	cell1.className ="FieldName"; 
	cell1.setAttribute("id","cell3"+rowscount+"_1");
	cell1.innerHTML="<select name=\"oprule3"+rowscount+"\" id=\"oprule3"+rowscount+"\"><option value=\"0\">参与者</option><option value=\"1\">负责人</option></select>";
	var cell2 = row.insertCell(1);
	cell2.className ="FieldName";
	cell2.setAttribute("id","cell3"+rowscount+"_2");
	cell2.innerHTML ="<select name=\"opunit3"+rowscount+"\" id=\"opunit3"+rowscount+"\" onchange=\"selOnchang('"+rowscount+"',this)\"><option value=\"0\">特定参与者</option><option value=\"1\">特定组织单元</option><option value=\"2\">特定岗位</option><option value=\"3\">特定角色</option><option value=\"4\">所有人</option></select>";
	var cell3 = row.insertCell(2);
	cell3.className ="FieldName";
	cell3.setAttribute("id","cell3"+rowscount+"_3");
	cell3.innerHTML ="<button type=\"button\" class=\"Browser\" id=\"content3"+rowscount+"btn\"  name=\"content3"+rowscount+"btn\" onclick=\"getBrow('"+rowscount+"')\"></button><input type=\"hidden\"  name=\"content3"+rowscount+"\" id=\"content3"+rowscount+"\" value=\"\"><span id=\"content3"+rowscount+"span\"></span>";
	var cell4 = row.insertCell(3);
	cell4.className ="FieldName";
	cell4.setAttribute("id","cell3"+rowscount+"_4");
	cell4.innerHTML ="<INPUT type=\"text\" class=\"InputStyle2\"  id=\"minseclevel3"+rowscount+"\" name=\"minseclevel3"+rowscount+"\" size=\"6\" onkeyup=\"value=value.replace(/[^\\d]/g,'') \" onbeforepaste=\"clipboardData.setData('text',clipboardData.getData('text').replace(/[^\\d]/g,''))\">&nbsp;-&nbsp;<input type=\"text\" class=\"InputStyle2\"  id=\"maxseclevel3"+rowscount+"\" name=\"maxseclevel3"+rowscount+"\" size=\"6\" onkeyup=\"value=value.replace(/[^\\d]/g,'') \" onbeforepaste=\"clipboardData.setData('text',clipboardData.getData('text').replace(/[^\\d]/g,''))\">";
	var cell5 = row.insertCell(4);
	cell5.className ="FieldName";
	cell5.setAttribute("id","cell3"+rowscount+"_5");
	cell5.innerHTML ="<input type=\"button\" value=\"删除\" onclick=\"delTableRow3('"+rowscount+"')\"/><input type=\"hidden\"  name=\"id3"+rowscount+"\" id=\"id3"+rowscount+"\" value=\"\"><input type=\"hidden\"  name=\"del3"+rowscount+"\" id=\"del3"+rowscount+"\" value=\"0\">";
	
}

function delTableRow3(i){
	var table = document.getElementById("table3");
    table.rows["row3"+i].style.display="none";
    document.getElementById["del3"+i].value="1";
	//table.deleteRow(rowid);
}

function getBrow(i){
	var opunit = document.getElementById("opunit3"+i).value;
	var refobjid="";
	var refobjurl="";
	if(opunit==0){//特定操作者
		refobjid="402881eb0bd30911010bd321d8600015";
	    refobjurl="/humres/base/humresinfo.jsp?id=";
	}else if(opunit==1){//特定组织单元
		refobjid="40287e8e12066bba0112068b730f0e9c";
	    refobjurl="/base/orgunit/orgunitview.jsp?id=";
	}else if(opunit==2){//特定岗位
		refobjid="40288041120a675e01120a7ce31a0019";
	    refobjurl="/humres/base/stationinfoview.jsp?id=";
	}else if(opunit==3){//特定角色
		refobjid="4028819a0f3024fb010f302895d20004";
	    refobjurl="/base/security/sysrole/sysroleview.jsp";
	}else if(opunit==4){//所有人
		refobjid="402881eb0bd30911010bd321d8600015";
	    refobjurl="/humres/base/humresinfo.jsp?id=";
	}
	var a = "content3"+i;
	var b = "content3"+i+"span";
	getrefobj(a,b,refobjid,'',refobjurl,'0');
}

function selOnchang(i,obj){
	var value= obj.value;
	if(value==4){//所有人
		document.getElementById("cell3"+i+"_3").innerHTML="";
	}else{
		document.getElementById("cell3"+i+"_3").innerHTML="<button type=\"button\" class=Browser id=\"content3"+i+"btn\"  name=\"content3"+i+"btn\" onclick=\"getBrow('"+i+"')\"></button><input type=\"hidden\"  name=\"content3"+i+"\" id=\"content3"+i+"\" value=\"\"><span id=\"content3"+i+"span\"></span>";
	}
}
 
function onSave3(){
	var table = document.getElementById("table3");
	var rowscount = table.rows.length-1;
	if(rowscount==0){
		   Ext.Ajax.timeout = 900000;
		   Ext.Ajax.request({
		       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=delpermission',
		       params:{requestid:"<%=requestid%>"},
		       sync:true,
		       success: function() {
		           pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
		       }
		   });
	}
	var temp=false;
	var num=0;
	for(var i=0;i<rowscount;i++){
       var oprule = document.getElementById('oprule3'+i).value;
	   var opunit=document.getElementById('opunit3'+i).value;
	   var content="";
	   if(opunit!="4"){
		   content=document.getElementById('content3'+i).value;
	   }
	   var minseclevel=document.getElementById('minseclevel3'+i).value;
	   var maxseclevel=document.getElementById('maxseclevel3'+i).value;
	   var del=document.getElementById('del3'+i).value;
	   if(opunit!="4" && content=='' && del=="0"){
	     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
	       return;
	   }
	}
	for(var i=0;i<rowscount;i++){
       var oprule = document.getElementById('oprule3'+i).value;
	   var opunit=document.getElementById('opunit3'+i).value;
	   var content="";
	   if(opunit!="4"){
		   content=document.getElementById('content3'+i).value;
	   }
	   var minseclevel=document.getElementById('minseclevel3'+i).value;
	   var maxseclevel=document.getElementById('maxseclevel3'+i).value;
	   var id="";
	   if(document.getElementById('id3'+i)&&document.getElementById('id3'+i).value){
		   id=document.getElementById('id3'+i).value;
	   }
	   var del=document.getElementById('del3'+i).value;
	   if(opunit!="4" && content=='' && del=="0"){
	     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
	       return;
	   }else{
		   Ext.Ajax.timeout = 900000;
		   Ext.Ajax.request({
		       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=savepermission',
		       params:{id:id,del:del,oprule:oprule,requestid:'<%=requestid%>',opunit:opunit,content:content,minseclevel:minseclevel,maxseclevel:maxseclevel},
		       sync:true,
		       success: function(res) {
		    	    var xml=res.responseXML;
                    var status = xml.getElementsByTagName("msg")[0].text+"";
		    	   document.getElementById("id3"+i).value=status;
		           num+=1;
		           if(num==rowscount){
					   temp=true;
				   }
		           if(temp){
						pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
					}else if (i==rowscount-1 && !temp){
						pop( '设置失败');//！
					}
		       }
		   });
	  }
    }
}
</script>
<div id="pagemenubar3"></div>
<TABLE class=layouttable border=1 id="table3">
<COLGROUP>
<COL width="10%">
<COL width="15%">
<COL width="50%">
<COL width="15%">
<COL width="10%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue>参与角色</TD>
<TD class=FieldValue>参与类型</TD>
<TD class=FieldValue>内容</TD>
<TD class=FieldValue>安全级别</TD>
<TD class=FieldValue><input type="button" value="添加共享" onclick="javascript:addRow3()"/></TD>
</TR>
<% 
List<Map<String,Object>> list3 = ds.getValues("select * from COWORKPERMISSION where requestid='"+requestid+"' and ISDELETE=0 order by oprule asc,opunit asc");
Map<String,Object> m3 = new HashMap<String,Object>();
if(list3!=null && list3.size()>0){
for(int i=0;i<list3.size();i++){
	m3=list3.get(i);
   int oprule = Integer.parseInt(m3.get("oprule")+"");
   int opunit=Integer.parseInt(m3.get("opunit")+"");
   String id3=StringHelper.null2String(m3.get("id"));
   String content=StringHelper.null2String(m3.get("content"));
   String contentspan ="";
   String sql3_1="";
   if(opunit==0){
	   sql3_1 = "select objname,id from humres where id in ('"+content.replace(",","','")+"')";
   }else if(opunit==1){
	   sql3_1 = "select objname,id from orgunit where id in ('"+content.replace(",","','")+"')";
   }else if(opunit==2){
	   sql3_1 = "select objname,id from stationinfo  where id in ('"+content.replace(",","','")+"')";
   }else if(opunit==3){
	   sql3_1 = "SELECT rolename AS objname,id as id FROM Sysrole where id in ('"+content.replace(",","','")+"')";
   }
   if(opunit!=4){
	   List<Map<String,Object>> list3_1 = ds.getValues(sql3_1);
	   for(int j=0;j<list3_1.size();j++){
		   Map<String,Object> m3_1 = list3_1.get(j);
		   String id3_1 =StringHelper.null2String(m3_1.get("id"));
		   if(j!=list3_1.size()-1){
			   if(opunit==0){
			      contentspan+="<a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+id3_1+"','"+StringHelper.null2String(m3_1.get("objname"))+"','tab"+id3_1+"') >"+StringHelper.null2String(m3_1.get("objname"))+"</a>"+",";
			   }else{
				   contentspan+=StringHelper.null2String(m3_1.get("objname"))+",";
			   }
		   }else{
			   if(opunit==0){
				   contentspan+="<a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+id3_1+"','"+StringHelper.null2String(m3_1.get("objname"))+"','tab"+id3_1+"') >"+StringHelper.null2String(m3_1.get("objname"))+"</a>";
			   }else{
				   contentspan+=StringHelper.null2String(m3_1.get("objname"));
			   }
		   }
	   }
   }
   int minseclevel=NumberHelper.string2Int(m3.get("minseclevel"),-1);
   int maxseclevel=NumberHelper.string2Int(m3.get("maxseclevel"),-1);
%>
<TR id="row3<%=i %>">
<TD class=FieldName  id="cell3<%=i %>_1">
<select name="oprule3<%=i %>" id="oprule3<%=i %>">
   <option value="0" <%if(oprule==0){%>selected="selected"<%} %>>参与者</option>
   <option value="1" <%if(oprule==1){%>selected="selected"<%} %>>负责人</option>
</select>
</TD>
<TD class=FieldName  id="cell3<%=i %>_2">
<select name="opunit3<%=i %>" id="opunit3<%=i %>" onchange="selOnchang('<%=i %>',this)">
   <option value="0" <%if(opunit==0){%>selected="selected"<%} %>>特定参与者</option>
   <option value="1" <%if(opunit==1){%>selected="selected"<%} %>>特定组织单元</option>
   <option value="2" <%if(opunit==2){%>selected="selected"<%} %>>特定岗位</option>
   <option value="3" <%if(opunit==3){%>selected="selected"<%} %>>特定角色</option>
   <option value="4" <%if(opunit==4){%>selected="selected"<%} %>>所有人</option>
</select>
</TD>
<TD class=FieldName  id="cell3<%=i %>_3">
<%if(opunit!=4){%>
<button type="button" class=Browser id="content3<%=i %>btn"  name="content3<%=i %>btn" onclick="getBrow('<%=i %>')"></button>
<input type="hidden"  name="content3<%=i %>" id="content3<%=i %>" value="<%=content %>"><span id="content3<%=i %>span"><%=contentspan %></span>
<%} %>
</TD>
<TD class=FieldName  id="cell3<%=i %>_4">
<INPUT type="text" value="<%=minseclevel!=-1?minseclevel+"":"" %>" class="InputStyle2"  id="minseclevel3<%=i %>" name="minseclevel3<%=i %>" size="6" onkeyup="value=value.replace(/[^\d]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">&nbsp;-&nbsp;
<input type="text" value="<%=maxseclevel!=-1?maxseclevel+"":"" %>" class="InputStyle2"  id="maxseclevel3<%=i %>" name="maxseclevel3<%=i %>" size="6" onkeyup="value=value.replace(/[^\d]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">
</TD>
<TD class=FieldName  id="cell3<%=i %>_5">
<input type="button" value="删除" onclick="delTableRow3('<%=i %>')"/>
<input type="hidden"  name="id3<%=i %>" id="id3<%=i %>" value="<%=id3 %>">
<input type="hidden"  name="del3<%=i %>" id="del3<%=i %>" value="0">
</TD>
</TR>
<%}} %>
</TBODY>
</TABLE>
</div>   
<div class="x-tab" title="相关资源">
<script type="text/javascript" >
function addRow4(){
	var table = document.getElementById("table4");
	var rowscount = table.rows.length-1;
	var row = table.insertRow(table.rows.length);
	row.setAttribute("id","row4"+rowscount);
	row.style.display="";
	var cell1 = row.insertCell(0);
	cell1.className ="FieldName"; 
	var html1="<select id=\"fieldid4"+rowscount+"\" name=\"fieldid4"+rowscount+"\" >";
<%
List<Map<String,String>> list4_2 = ds.getValues("select id,labelname from formfield where formid='"+replyformid+"' and isdelete=0 ");
if(list4_2!=null && list4_2.size()>0){
	for(Map<String,String> m4_2:list4_2){
		String id4_1=StringHelper.null2String(m4_2.get("id"));
		String fieldname_1=StringHelper.null2String(m4_2.get("labelname"));
		%>
		html1+="<option value=\"<%=id4_1 %>\"><%=fieldname_1 %></option>";
		<%
	}
}
%>
    html1+="</select>";
	cell1.innerHTML=html1;
	var cell2 = row.insertCell(1);
	cell2.className ="FieldName";
	cell2.innerHTML ="<input type=\"text\" value=\"\" id=\"fieldname4"+rowscount+"\" name=\"fieldname4"+rowscount+"\" value=\"\"/>";
	var cell3 = row.insertCell(2);
	cell3.className ="FieldName";
	cell3.innerHTML ="<input type=\"text\" id=\"ordernum4"+rowscount+"\" name=\"ordernum4"+rowscount+"\" value=\"\" onkeyup=\"value=value.replace(/[^\\d]/g,'')\" onbeforepaste=\"clipboardData.setData('text',clipboardData.getData('text').replace(/[^\\d]/g,''))\"/>";
	var cell4 = row.insertCell(3);
	cell4.className ="FieldName";
	cell4.innerHTML ="<select id=\"orderfield4"+rowscount+"\" name=\"orderfield4"+rowscount+"\"><option value=\"0\" >时间倒序</option><option value=\"1\">时间升序</option></select>";
	var cell5 = row.insertCell(4);
	cell5.className ="FieldName";
	cell5.innerHTML ="<input type=\"button\" value=\"删除\" onclick=\"delTableRow4('"+rowscount+"')\"/><input type=\"hidden\"  name=\"id4"+rowscount+"\" id=\"id4"+rowscount+"\" value=\"\"><input type=\"hidden\"  name=\"del4"+rowscount+"\" id=\"del4"+rowscount+"\" value=\"0\">";
}

function delTableRow4(i){
	var table = document.getElementById("table4");
    table.rows["row4"+i].style.display="none";
    document.getElementById["del4"+i].value="1";
	//table.deleteRow(rowid);
}

function onSave4(){
	var table = document.getElementById("table4");
	var rowscount = table.rows.length-1;
	if(rowscount==0){
		   Ext.Ajax.timeout = 900000;
		   Ext.Ajax.request({
		       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=deladdfun',
		       params:{requestid:"<%=requestid%>"},
		       sync:true,
		       success: function() {
		           pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
		       }
		   });
	}
	var temp=false;
	var num=0;
	for(var i=0;i<rowscount;i++){
       var fieldid = document.getElementById('fieldid4'+i).value;
	   var fieldname=document.getElementById('fieldname4'+i).value;
	   var ordernum=document.getElementById('ordernum4'+i).value;
	   var orderfield=document.getElementById('orderfield4'+i).value;
	   var id="";
	   if(document.getElementById('id4'+i)&&document.getElementById('id4'+i).value){
		   id=document.getElementById('id4'+i).value;
	   }
	   var del=document.getElementById('del4'+i).value;
		   Ext.Ajax.timeout = 900000;
		   Ext.Ajax.request({
		       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=saveaddfun',
		       params:{id:id,del:del,fieldid:fieldid,requestid:'<%=requestid%>',fieldname:fieldname,ordernum:ordernum,orderfield:orderfield},
		       sync:true,
		       success: function(res) {
		    	    var xml=res.responseXML;
                    var status = xml.getElementsByTagName("msg")[0].text+"";
		    	   document.getElementById("id4"+i).value=status;
		           num+=1;
		           if(num==rowscount){
					   temp=true;
				   }
		           if(temp){
						pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
					}else if (i==rowscount-1 && !temp){
						pop( '设置失败');//！
					}
		       }
		   });
    }
}
</script>
<div id="pagemenubar4"></div>
<TABLE class=layouttable border=1 id="table4">
<COLGROUP>
<COL width="25%">
<COL width="30%">
<COL width="15%">
<COL width="15%">
<COL width="15%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue>字段</TD>
<TD class=FieldValue>显示名称</TD>
<TD class=FieldValue>顺序</TD>
<TD class=FieldValue>默认排序</TD>
<TD class=FieldValue><input type="button" value="添加项" onclick="addRow4()"/></TD>
</TR>
<%
List<Map<String,Object>> list4 = ds.getValues("select * from coworkaddfun where requestid='"+requestid+"' and ISDELETE=0 order by ordernum asc");
Map<String,Object> m4 = new HashMap<String,Object>();
if(list4!=null && list4.size()>0){
for(int i=0;i<list4.size();i++){
	m4=list4.get(i);
	String id4= StringHelper.null2String(m4.get("id"));
	String fieldid = StringHelper.null2String(m4.get("fieldid"));
	String fieldname = StringHelper.null2String(m4.get("fieldname"));
	int ordernum = NumberHelper.string2Int(m4.get("ordernum"),-1);
	int orderfield = NumberHelper.string2Int(m4.get("orderfield"),0);
%>
<TR id="row4<%=i %>">
<TD class=FieldName >
<select id="fieldid4<%=i %>" name="fieldid4<%=i %>" >
<%
List<Map<String,String>> list4_1 = ds.getValues("select id,labelname from formfield where formid='"+replyformid+"' and isdelete=0 ");
if(list4_1!=null && list4_1.size()>0){
	for(Map<String,String> m4_1:list4_1){
		String id4_1=StringHelper.null2String(m4_1.get("id"));
		String fieldname_1=StringHelper.null2String(m4_1.get("labelname"));
		%>
		<option value="<%=id4_1 %>"  <%=id4_1.equals(fieldid)?"selected='selected'":"" %>><%=fieldname_1 %></option>
		<%
	}
}
%>
</select>
</TD>
<TD class=FieldName >
<input type="text" id="fieldname4<%=i %>" name="fieldname4<%=i %>" value="<%=fieldname %>"/>
</TD>
<TD class=FieldName >
<input type="text" id="ordernum4<%=i %>" name="ordernum4<%=i %>" value="<%=ordernum!=-1?ordernum+"":"" %>" onkeyup="value=value.replace(/[^\d]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))"/>
</TD>
<TD class=FieldName >
<select id="orderfield4<%=i %>" name="orderfield4<%=i %>">
   <option value="0" <%=orderfield==0?"selected='selected'":"" %>>时间倒序</option>
   <option value="1" <%=orderfield==1?"selected='selected'":"" %>>时间升序</option>
</select>
</TD>
<TD class=FieldName >
<input type="button" value="删除" onclick="delTableRow4('<%=i %>')"/>
<input type="hidden"  name="id4<%=i %>" id="id4<%=i %>" value="<%=id4 %>">
<input type="hidden"  name="del4<%=i %>" id="del4<%=i %>" value="0">
</TD>
</TR>
<%}} %>
</TBODY>
</TABLE>
</div>   
<%} %>
</div>
  </body>
</html>
<script language="javascript">
  var tableformatted = false; 
  var inputid;
  var spanid;
  var temp;
[].indexOf || (Array.prototype.indexOf = function(v){
	for(var i = this.length; i-- && this[i] !== v;);
	return i;
});

jq(document).ready(function($){
    <%=ufscript%>
    <%=directscript%>
   $.Autocompleter.Selection = function(field, start, end) {
         var flag;
       if(Ext.isIE){
         flag= field.createTextRange; //在firefox下span不显示 原因是因为  firefox不支持createTextRange 
       }else{
         flag=true;
       }
       if(flag){
           if (Ext.isIE) { 
               var selRange = field.createTextRange();
               selRange.collapse(true);
               selRange.moveStart("character", start);
               selRange.moveEnd("character", end);
               selRange.select();
           }
        if(inputid==undefined||spanid==undefined)
           return;
         var len=field.value.indexOf("  ");
           var lenspance=field.value.indexOf(" ");
             if(temp==0&&len>0){
             temp=1;
         var  length=field.value.length;
           var data=field.value;
        document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
       document.getElementById('field'+spanid+'span').innerHTML= data.substring(len,length);
         }else if(temp==0&&lenspance>0){

           var data=field.value;
        document.getElementById(inputid).value=data;
       document.getElementById('field'+spanid+'span').innerHTML= data;
             }else
             {
               document.getElementById(inputid).value="";

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
 function checkUnique(obj,param,isonly,fieldname,tablename){
    if(obj.value.trim()=='')
    return;
     if(isonly==1||param=="")
     {
        param="select "+fieldname+" from "+tablename+" where "+fieldname+" = ? and requestid in (select id from formbase where isdelete=0)";
     }
    param=param.replace("?","'"+obj.value.ReplaceAll("'","''")+"'");
   if(SQL(param)!=''){
      alert('<%=labelService.getLabelNameByKeyId("402883d934c119410134c11941a20000") %>') ;//数据已存在,请重新输入！
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
  function SQL(param){
				param = encode(param);

				if(strSQLs.indexOf(param)!=-1){
					var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
					return retval;

				}else{
                    var _url= "/ServiceAction/com.eweaver.base.DataAction?sql="+param;
                    var retval;
                    Ext.Ajax.request({
                        url:_url,
                        sync:true,                        
                        success: function(res) {
                                  var doc=res.responseXML;
                                  var root = doc.documentElement;
                            retval = getValidStr(root.text);
                            strSQLs.push(param);
                            strValues.push(retval);
                        }
                    });
					return retval;
				}             
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
function onAddRow(){
	onCal();
	try{
		<%=onaddrowscript%>
		for(var i = 0; i < fieldJSFormulas.length; i++){
			var f = fieldJSFormulas[i];
			if(f.isDetailField){
				bindJsCodeToField(f.fieldid, f.code, f.eventMode, false, f.htmltype, f.fieldtype, f.isDetailField);
			}
		}
	}catch(e){}
}

      function formatTable(t) {
          if (t.innerHTML.indexOf('oTable') < 0)
              return;
          var datarow ;
          for (i = 0; i < t.rows.length; i++) {
              tablerow = t.rows[i];
              if (tablerow.cells[0] && tablerow.cells[0].firstChild && tablerow.cells[0].firstChild.id && tablerow.cells[0].firstChild.id.indexOf('oTable') == 0) {
                  datarow = t.rows[i];
              }
          }
          if (datarow == null)
              return;
          var rowheight = new Array();
          tablecount = datarow.cells.length;
          rowcount = datarow.cells[0].firstChild.rows.length;
          equalrowcount=0;
          if (rowcount > 10)
              caldelay = 10000;
          for (i = 0; i < rowcount; i++) {
              equalcount = 0;
              for (j = 0; j < tablecount; j++) {
                  otable = datarow.cells[j].firstChild;
                  orows = otable.rows;
                  if (j > 0 && orows[i].clientHeight == datarow.cells[j - 1].firstChild.rows[i].clientHeight)
                      equalcount++
                  if (!rowheight[i])
                      rowheight[i] = orows[i].clientHeight;
                  else if (rowheight[i] < orows[i].clientHeight)
                      rowheight[i] = orows[i].clientHeight;
              }
              if (equalcount == tablecount - 1){
                  equalrowcount++;
              }
          }
          if(equalrowcount==rowcount)
            return;
          for (i = 0; i < datarow.cells.length; i++) {
              otable = datarow.cells[i].firstChild;
              orows = otable.rows;
              for (j = 0; j < orows.length; j++) {
                  orows[j].cells[0].style.height = rowheight[j];
              }
          }
      }
onAddRow();
var task=new Ext.util.DelayedTask(onCal);
</script>
<SCRIPT FOR = document EVENT = onselectionchange>
var caldelay=200;
task.delay(caldelay,null,this);
</SCRIPT>
<script language="javascript">

    //*************************简易Javascript Map(start)*************************//
    var objectKey = new Array(100);
    var objectValue = new Array(100);
    var timevalue = "";
    function getMapValue(key){
        for(var i=0;i<objectKey.length;i++){
            if(objectKey[i]==key){
                timevalue = objectValue[i];
            }
        }
    }
    //*************************简易Javascript Map(end)*************************//

    //*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(start)*************************//
	<%
	List list = formlayoutService.findFormlayoutfieldByLayoutid(layoutid);
	Map map = new HashMap();
	for (int i = 0; i < list.size(); i++) {
		Formlayoutfield formlayoutfield = (Formlayoutfield) list.get(i);
		if("$currenttime$".equals(formlayoutfield.getFormula()==null?"":formlayoutfield.getFormula().trim())){
    %>
        if(document.all("field_<%=formlayoutfield.getFieldname()%>")!=null){
            objectKey[<%=i%>]="field_<%=formlayoutfield.getFieldname()%>";
            objectValue[<%=i%>]=document.all("field_<%=formlayoutfield.getFieldname()%>").value;
        }else{
            var i=0;
            while(document.all("field_<%=formlayoutfield.getFieldname()%>_"+i)!=null){
                objectKey[<%=i++%>]="field_<%=formlayoutfield.getFieldname()%>_"+i;
                objectValue[<%=i++%>]=document.all("field_<%=formlayoutfield.getFieldname()%>_"+i).value;
                i++;
            }
        }
    <%
        }
	}%>
//*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(end)*************************//
function onDelete(link){
	delmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>";
	if(confirm(delmessage)){
		document.all("action").value="deleteformbase";
		document.all("targetUrl").value=link;
		document.EweaverForm.submit();
	}
}
function onSubmit(issave){
	//needchecklists = "<%=needcheckfields%>";
		if(typeof(onSubmitBefore)=='function'){
			
		try{
			var submitBefore = onSubmitBefore(issave);
			if(!submitBefore) return;
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}
  checkfields="requestname,"+needchecklists;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空
	onCal();
	if(typeof(onSubmitBefore)=='function'){
		try{
			var submitBefore = onSubmitBefore(issave);

		if(!submitBefore) return;
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}

  var needcheck = 0;
  if(issave == 0){

  }else
   		needcheck = 1;

  if(needcheck == 1){
	  if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/
            <%if(!StringHelper.isEmpty(categoryfield)){%>
          if(document.getElementById('<%=categoryfield%>'))
            document.getElementById('categoryid').value=document.getElementById('<%=categoryfield%>').value;
            <%}%>

 //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(start)**************************//
    for(var num=0;num<objectKey.length;num++){
        if(objectKey[num]!=""&&objectKey[num]!=null){
            getMapValue(objectKey[num]);
            if(timevalue==document.all(objectKey[num]).value){
                document.all(objectKey[num]).value="$currenttime$";
            }
        }
    }
    //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(end)**************************//
               document.EweaverForm.submit();
	  }
  }
  //document.all("isreject").value = "0";
}
 function onSubmitNew(issave)
 {
	if(typeof(onSubmitBefore)=='function'){	
		try{
			var submitBefore = onSubmitBefore(issave);
			if(!submitBefore) return;
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}
	//needchecklists = "<%=needcheckfields%>";
  checkfields="requestname,"+needchecklists;//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空
  document.all('subnew').value='createnew';

	onCal();

  var needcheck = 0;
  if(issave == 0){

  }else
   		needcheck = 1;

  if(needcheck == 1){
	  if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/
            <%if(!StringHelper.isEmpty(categoryfield)){%>
          if(document.getElementById('<%=categoryfield%>'))
            document.getElementById('categoryid').value=document.getElementById('<%=categoryfield%>').value;
            <%}%>
	   		document.EweaverForm.submit();
	  }
  }
 }
function doAction(requestid,customid){
       Ext.Ajax.request({
                   url: '/ServiceAction/com.eweaver.workflow.form.servlet.FormbaseAction?action=doaction',
                   params:{requestid:requestid,customid:customid},
                   sync:true,
                   success: function(res) {
                       if(res.responseText == 'noright')
                       {
                            Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
                         Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0056") %>') ;//编辑权限的人才可以变更卡片数据！
                       }else{
                            Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934c11ccb0134c11ccbb80000") %>',function(){//变更卡片数据成功！
                              window.location.href='/workflow/request/formbase.jsp?requestid='+requestid;
                           });

                       }
                   }
               });
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

    function sendMsg(msg,humres,type){
          this.daliog0.getComponent('dlgpanel').setSrc('<%= request.getContextPath()%>/msg/createmsg.jsp?catcher='+humres+'&objid=<%=coworkset.getId()%>&msg='+encodeURIComponent(msg));
          this.daliog0.show();
    }
    function importDetail(requestid,categoryid,layoutid){
          this.daliog1.getComponent('dlgpanel').setSrc('<%= request.getContextPath()%>/workflow/form/exportdrecordbyexcel.jsp?requestid='+requestid+'&categoryid='+categoryid+'&layoutid='+layoutid);
          this.daliog1.show();
    }
    
    function printcategory(requestid,categoryid){
    	onUrl('/workflow/request/formbaseprintpre.jsp?requestid='+requestid+'&categoryid='+categoryid,'打印','tab402881eb0bcd354e010bcdc91c700028');
    }
    
    function loadView(vid,cid,_params,_callback){
        if(Ext.isEmpty(_params))_params='';
        $(cid).style.height="50px";
        $(cid).style.width="100%";
        var myMask = new Ext.LoadMask($(cid), {msg:"<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0057") %>",removeMask:true});//请稍等,数据加载中...
        var ofg={
            url: contextPath+'/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?action=partview',
            method:'POST',
            timeout:180000,//三分钟
            success:function(resp,opt){
                myMask.hide();
                var ret=resp.getResponseHeader.ret;
                if(parseInt(ret)<0){
                    opt.failure(resp,opt);
                }else{
                    $(cid).innerHTML=resp.responseText;
                    if(typeof(_callback)=='function')_callback();
                }
            },
            failure:function(resp,opt){
                myMask.hide();
                alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0058") %>{'+vid+'}<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0059") %>:'+resp);//视图模板     加载错误
                $(cid).innerHTML='<pre>'+resp.responseText+'</pre>';
            },
            //headers:{ 'my-header': 'foo'}
            params:{id:vid,where:_params}
        };
        myMask.show();
        Ext.Ajax.request(ofg);
    }//end fun.
    //---------------------
    function addrowbyexcel(id) {

	var ids=window.showModalDialog(contextPath+'/base/popupmain.jsp?url='+contextPath+'/document/file/fileuploadbrowser.jsp?mode=1');
	if(!ids) {
		return;
	}
	var docid = ids[0];
	var myMask = new Ext.LoadMask(Ext.getBody(), {
			msg: '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005a") %>',//正在导入,请稍后...
			removeMask: true //完成后移除
		});
	myMask.show();
	Ext.Ajax.request({    
		   url : contextPath+'/ServiceAction/com.eweaver.workflow.request.servlet.XlsFormAction',    
		   //params :参数列表    
		   timeout:300000,
		   sync:true,
		   params : {    
				 //取得所选第一行中id列的值    
				  docid:docid,
				  formid:id    
			},    
			//success:响应成功后的回调函数    
		   success : function(response) {    
				// 解码JSON格式数据为一个对象.返回的数据为json数据.{id:'1'}  
				 myMask.hide();
				// alert('0');
				if(response.responseText == '') {
					alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005b") %>');//文件内容为空,请选择正确的文件
					return;
				}
				var respText = eval(response.responseText);   
				//alert(response.responseText);
				var j = 0;
				var l = (respText.length);
				if(l > 0) {
					 var el = document.getElementsByTagName('input');       
					 var len = el.length;     
					  
					 for(var i=0; i<len; i++) {               
						if((el[i].type=='checkbox') && (el[i].name=='check_node_'+id)) {      
							el[i].checked = true;       
							maxIndex = el[i].value;    
						}       
					 }      
					 delrow(id);     	 
				}
				//alert(response.responseText);
				for(var one = 0; one < l; one++) { 
					//maxIndex = one;
					//alert(respText[one].length);
					var ll = respText[one].length;
					addrow(id); 
					maxIndex++;
					for(var key = 0;key < ll;key ++)  {
						if(respText[one][key]) {
							var cellid = respText[one][key].id;
							var obj = Ext.getDom('field_'+cellid+'_'+maxIndex); 
							var objspan = Ext.getDom('field_'+cellid+'_'+maxIndex+'span'); 
							if(objspan && obj.type == 'hidden') { 
								objspan.innerHTML = respText[one][key].value; 	
								obj.value=respText[one][key].value;	
								var btn = Ext.getDom('button_'+cellid+'_'+maxIndex);
								if(btn){
									getrefobjview(obj,objspan,btn);
								}									
							}
							//alert(obj.type);
							if(obj && obj.type == 'text'){ 
								obj.value=respText[one][key].value;
							}

							if(obj && obj.tagName == 'SELECT'){
								DWREngine.setAsync(false);
								obj.value=respText[one][key].value;
								obj.fireEvent('onchange');
								DWREngine.setAsync(true);
							}
							if(obj && obj.type == 'checkbox'){ 
								obj.value=respText[one][key].value;
								if(obj.value == '1') {
									obj.checked=true;
								} else {
									obj.checked=false;
								}
							}  
							 if(obj && obj.tagName == 'TEXTAREA'){ 
									obj.innerText=respText[one][key].value;										
							}
						}
				}  
					
				}
				 //alert('1');
			},    
	   //failure:处理当http返回是404或500的错误,不是业务错误       
		   failure : function(response) {    
					   Ext.Msg.alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>');//错误, 无法访问后台
					myMask.hide();
		   }    
	})   
}

    function getrefobjview(obj,objspan,btn){
    	//对browser显示进行处理---start--- 	
			DWREngine.setAsync(false);
			var start = btn.onclick.toString().indexOf(objspan.id)+objspan.id.length+3;
			var refobjid = btn.onclick.toString().substring(start,start+32);
			if(refobjid){
				var sql = "";
				var browservalues = obj.value.split(",");
				var sql = "select reftable,keyfield,viewfield from refobj where ID='"+refobjid+"'";
				var reftable = "";
				var keyfield = "";
				var viewfield = "";
				 DataService.getValues(sql,{                                               
			          callback: function(data){   
			              if(data && data.length>0){ 
			            	  reftable = data[0].reftable;
			            	  keyfield = data[0].keyfield;
			            	  viewfield = data[0].viewfield;
			              } 
			          }                 
			      }); 
			      var showtext = "";
				for(var i=0;i<browservalues.length;i++){
			      if(browservalues[i].length==32){
						sql =  "select "+viewfield+" from "+reftable+" where "+keyfield+"= '"+browservalues[i]+"'";
						DataService.getValue(sql,function(value){
							if(showtext==""){
								showtext=value;
							}else{
								showtext=showtext+","+value;
							}
						});
					}
			      }
				objspan.innerHTML=showtext;
			}
			DWREngine.setAsync(true);
	//对browser显示进行处理---end---
    }
    //---------------------
     function impmaintablebyexcel(id) {
		var ids=openDialog('/base/popupmain.jsp?url=/document/file/fileuploadbrowser.jsp?mode=1');
		if(!ids) {
			return;
		}
		var docid = ids[0];
		var myMask = new Ext.LoadMask(Ext.getBody(), {
                        msg: '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005a") %>',//正在导入,请稍后...
                        removeMask: true //完成后移除
                    });
                myMask.show();
         Ext.Ajax.request({    
                   url : '/ServiceAction/com.eweaver.workflow.request.servlet.XlsFormAction?action=impmaintable',    
                   //params :参数列表    
                   params : {    
                         //取得所选第一行中id列的值    
                          docid:docid,
                          formid:id    
                    },    
                    //success:响应成功后的回调函数    
                   success : function(response) {    
                        // 解码JSON格式数据为一个对象.返回的数据为json数据.{id:'1'}  
                         myMask.hide();
                        if(response.responseText == '') {
							alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005b") %>');//文件内容为空,请选择正确的文件
							return;
						}
                        var respText = eval(response.responseText);   
						var j = 0;
						var l = (respText.length);
                        for(var one = 0; one < l; one++) { 
							var ll = respText[one].length;
							//alert(ll);
	                        for(var key = 0;key < ll;key ++)  {
	                        	if(respText[one][key]) {
	                        		var cellid = respText[one][key].id;
	                        		var obj = Ext.getDom('field_'+cellid); 
	                        		var objspan = Ext.getDom('field_'+cellid+'span'); 
	                        	
									if(objspan && obj.type == 'hidden') { 
										objspan.innerHTML = respText[one][key].value; 	
										obj.value=respText[one][key].value;
										var btn = Ext.getDom('button_'+cellid);
										if(btn){
											getrefobjview(obj,objspan,btn);
										}		
																			
									} else if(obj && (obj.type == 'text' || obj.tagName == 'SELECT' )){ 
										obj.value=respText[one][key].value;
										if(obj.tagName == 'SELECT'){
											DWREngine.setAsync(false);
											obj.fireEvent('onchange');
											DWREngine.setAsync(true);
										}
									} else if(obj && obj.type == 'checkbox'){ 
										obj.value=respText[one][key].value;
										if(obj.value == '1') {
											obj.checked=true;
										} else {
											obj.checked=false;
										}
									} else if(obj && obj.tagName == 'TEXTAREA'){ 
										obj.innerText=respText[one][key].value;										
									}
									
	                        	}
                        	}  
						}
						alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005d") %>');//导入完毕！
                    },    
                    failure : function(response) {   
                                myMask.hide(); 
                                Ext.Msg.alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>");//错误, 无法访问后台    
                    }    
		})   
    }
     function selectAll (obj,formid) {
	     var objname = "check_node_"+formid;
	     var checks = document.getElementsByName(objname);
	     for(var i = 0 ; i < checks.length ; i ++) {
	     	checks[i].checked = obj.checked;
	     }
     } 
function ifAllowUpload(element) {
  //****************************判断文件是否符合上传格式 start***********************************//
    <%
         Properties mapping = new Properties();
         InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("im.properties");
         try {
             mapping.load(inputStream);
         } catch (Exception e) {
             //log.error(e);
         }
         Enumeration keys = mapping.keys();
         String fileUploadType = "";
         while (keys.hasMoreElements()) {
            String col = (String) keys.nextElement();
            if (col.indexOf("fileUploadType") > -1)
            	fileUploadType = mapping.getProperty(col);
         }
    %>
    if (element != null && element.value != "") {
       var suffix = element.value.substring(element.value.lastIndexOf(".")+1);
       if ("<%=fileUploadType%>".indexOf(suffix) != -1) {
           alert("附件上传格式不正确！");
           return false;
       }
    }
   /** var filearr = document.getElementsByTagName("input");
    for (var f=0;f<filearr.length;f++) {
        if(filearr[f].type=="file") {
            if (filearr[f].value != "" && typeof(filearr[f].value) != "undefined") {
                var suffix = filearr[f].value.substring(filearr[f].value.lastIndexOf(".")+1);
            	if ("<%=fileUploadType%>".indexOf(suffix) != -1) {
                    alert("附件上传格式不正确！");
                    return false;
                }
            }
        }
    }**/
    return true;
    //****************************判断文件是否符合上传格式 end***********************************//
}
</script>
<script type="text/javascript" src="/js/bindJSToFormfield.js"></script>