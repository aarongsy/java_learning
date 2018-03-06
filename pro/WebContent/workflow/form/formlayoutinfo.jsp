<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.File"%>
<%@ page import="com.eweaver.app.bbs.discuz.client.Client" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.LabelConstant"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPage"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.skin.service.SkinService"%>
<%@ page import="com.eweaver.base.skin.model.Skin"%>
<%@ page import="com.eweaver.base.skin.SkinConstant"%>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayoutfield"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.util.FormLayoutTranslate"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>

<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
String basePath2 = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
BaseContext.setHttpbasepath(basePath2);
if(eweaveruser == null){
%>
<script language="javascript">
var obj = window;
while(obj.parent != null && obj.parent != obj)
	obj = obj.parent; 
obj.location = "/main/login.jsp";
</script>
<%
	/***********************************注销的时候注销论坛的用户 start***************************/
	Client uc = new Client();
	String ucsynlogout = uc.uc_user_synlogout();
	request.getSession().setAttribute("ucsynlogout",ucsynlogout);
	request.setAttribute("ucsynlogout",ucsynlogout);
	out.println("注销成功"+ ucsynlogout);
	/***********************************注销的时候注销论坛的用户 end ***************************/
	return;
}
if(null==eweaveruser.getOrgids()){
	eweaveruser.setOrgids("");
}
Humres currentuser = eweaveruser.getHumres();
Sysuser suser = new Sysuser();
SysuserService suserService = (SysuserService) BaseContext.getBean("sysuserService");
suser = suserService.getSysuserByObjid(currentuser.getId());
//数据库类型 1 sqlserver  ;2  oracle
//PropertiesHelper ph = new PropertiesHelper();
String dbtype = SQLMap.getDbtype();
String titlename="WeaverSoft Eweaver";
String titleimage="/images/main/titlebar_bg.jpg";
String pagemenustr="";
String pagemenuorder="0";
HashMap paravaluehm = new HashMap();
paravaluehm.put("{currentuser}",currentuser.getId());
paravaluehm.put("{currentorgunit}",currentuser.getOrgid());
paravaluehm.put("{currentdate}", DateHelper.getCurrentDate());
for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
	String paraname = e.nextElement().toString().trim();
	String paravalue = StringHelper.trimToNull(request.getParameter(paraname));
	if (!StringHelper.isEmpty(paraname)	&& !StringHelper.isEmpty(paravalue)) {
		paravaluehm.put("{"+paraname+"}",paravalue);
	}
}
String theuri = request.getRequestURI().replace(request.getContextPath(),"");
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
SetitemService setitemService0=(SetitemService)BaseContext.getBean("setitemService");
String style=StringHelper.null2String(suser.getStyle());
if(StringHelper.isEmpty(style)){
	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
        style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
}

PermissionruleService ps = (PermissionruleService) BaseContext.getBean("permissionruleService");
boolean isSysAdmin = ps.checkUserRole(eweaveruser.getId(),"402881e50bf0a737010bf0a96ba70004",null); 
/*首页类型*/
MainPageDefined mainPageDefined = (MainPageDefined)BaseContext.getBean("mainPageDefined");

MainPage userMainPage = mainPageDefined.getMainPageByType(suser.getMainPageType());
/**皮肤设置相关代码**/
String skinid = suser.getSkinid();
SkinService skinService = (SkinService)BaseContext.getBean("skinService");
Skin currentSkin = skinService.getSkinById(skinid);
if(currentSkin == null || currentSkin.getId() == null || !currentSkin.isEnabled()){
	currentSkin = skinService.getDefaultSkin();
}else{
	//检查用户的皮肤在物理目录是否存在
	String currentSkinBasePath = currentSkin.getBasePath();
	String currentSkinBasePathOfServer = request.getSession().getServletContext().getRealPath(currentSkinBasePath);
	File currentSkinDir = new File(currentSkinBasePathOfServer);
	if(!currentSkinDir.exists()){
		currentSkin = skinService.getDefaultSkin();
	}
}
/*当前系统模式*/
String currentSysMode;
if(userMainPage.getIsClassic()){//是传统的首页，则当前系统模式一定是软件模式
	currentSysMode = "0";
}else{//非传统的首页，则当前系统模式由皮肤决定
	currentSysMode = currentSkin.getSkinType();
	style = "gray";	//新首页使用Ext样式灰色作为默认的样式(无论之前用户选择的传统模式皮肤是什么颜色)
}

boolean currentSysModeIsWebsite = currentSysMode.equals("1");	//判断当前系统模式是否是网站模式(是：返回true,否则，返回false)
boolean currentSysModeIsSoftware = currentSysMode.equals("0");	//判断当前系统模式是否是软件模式(是：返回true,否则，返回false)
%>





<%
	String forminfoid = StringHelper.null2String(request
			.getParameter("forminfoid"));
	String layoutid = StringHelper.null2String(request
			.getParameter("layoutid"));
	String nodeid = StringHelper.null2String(request
			.getParameter("nodeid"));
	String layoutname = StringHelper.null2String(request
			.getParameter("layoutname"));
	String isdefault = StringHelper.null2String(request
			.getParameter("isdefault"));
	String workflowid = StringHelper.null2String(request
			.getParameter("workflowid"));
	if (nodeid.equals("-1")) {
		nodeid = null;
	}
	String strlayouttype = StringHelper.null2String(request
			.getParameter("layouttype"));
	int typeid = NumberHelper.string2Int(strlayouttype, 2);

	String includedformids = "'" + forminfoid + "'";
	String detailformids = "";
	ForminfoService forminfoService = (ForminfoService) BaseContext
			.getBean("forminfoService");
	Forminfo forminfo = (Forminfo) forminfoService
			.getForminfoById(forminfoid);

	boolean bSystable = false;
	if ("402881e60c85ac00010c864dfcc20057".equals(forminfo
			.getSelectitemid()))
		bSystable = true;

	FormlayoutService formlayoutService = (FormlayoutService) BaseContext
			.getBean("formlayoutService");
	Formlayout formlayout = formlayoutService.getLayoutInfo(layoutid,
			forminfoid, nodeid, String.valueOf(typeid));

	if (bSystable) {
		nodeid = StringHelper.null2String(formlayout.getNodeid());
	}
	int formtype = forminfo.getObjtype().intValue();
	if (!layoutid.equals("")) {
		typeid = formlayout.getTypeid().intValue();
		layoutname = formlayout.getLayoutname();
		isdefault = StringHelper.null2String(formlayout.getIsdefault());
	}
	SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
	boolean isOpenCodeSyntax = setitemService.isOpenCodeSyntax();
%>
<!DOCTYPE html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=5">
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<META HTTP-EQUIV="expires" CONTENT="0">  
<title><%=(StringHelper.isEmpty(layoutid) ? labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000d")
							: labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000e")+ "-")
							+ layoutname%></title><!-- 表单定义工具--><!-- 新建布局 --><!-- 修改布局 -->
							
							
<link rel="stylesheet" type="text/css" href="/css/global.css?<%=System.currentTimeMillis() %>">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css?<%=System.currentTimeMillis() %>" />
<%if(!"".equals(style)&&!"default".equals(style)){%>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/xtheme-<%=style%>.css?<%=System.currentTimeMillis() %>"/>
<%}%>
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css?<%=System.currentTimeMillis() %>">
<script type="text/javascript">
var iconBase = '/images';
var fckBasePath= '/fck/';
var contextPath='';
var style='<%=style%>';
      
/**禁止按Backspace键使网页后退**/
function disabledBackspaceForBackPage(docElement){
	if(docElement.attachEvent){
		document.attachEvent("onkeydown", disabledBackspaceHandler);
	}else if(docElement.addEventListener){
		document.addEventListener("keydown", disabledBackspaceHandler, false);
	}
	
	function disabledBackspaceHandler(e){
		if(e.keyCode == 8){	//enter backspace
			var srcElementType = e.srcElement.type;
			if(srcElementType != "text" && srcElementType != "textarea" && srcElementType != "password"){
				e.returnValue = false;
			}
		}
	}
}
if(document){disabledBackspaceForBackPage(document);}
</script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/js/weaverUtil.js?v=1504"></script>
<script type="text/javascript" language="javascript" src="/app/js/pubUtil.js"></script>
<% if(userMainPage.getIsUseSkin()){//当前用户选择的首页是使用皮肤的 %>
<link rel="stylesheet" type="text/css" id="global_css" href="<%=currentSkin.getBasePath() %>/<%=SkinConstant.GLOBAL_CSS_NAME + "?" + System.currentTimeMillis() %>"/> 
<% } %>
	
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<style type="text/css">
    .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
</style>
<script Language="JavaScript">
    Ext.SSL_SECURE_URL='about:blank';
   	function beforeExit(){
    	if(confirm("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000f")%>")){//确定退出？
			window.close();
   			window.opener.location.reload();
  		}
    }
    Ext.onReady(function() {

     var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'center',contentEl:designerdiv},{region:'east',collapsible: true,
            collapseMode:'mini',
            split:true,
            width: 210,contentEl:properties},{region:'south',contentEl:bottomdiv,height:20}]
	   });
        Ext.EventManager.on('layoutname','keypress',function(e){
           if (event.keyCode == 13) {
               event.keyCode=0;return   false
           }
        });

    })
    
    var showoTRformSearch=1;
    function oTRformSearchShow(){
    	showoTRformSearch=0;//是否显示“查询条件”链接，如果选择“关联表单”下的子表，则显示，如果双击左边“设计”里的字段，则不显示
    }
    
	function getformfield(formid){
		if(document.all(formid+"_fieldstyle")!=null){
			document.all("formstyle").value=document.all(formid+"_fieldstyle").value;			
			oTRfield.style.display="none";
			oTRform.style.display="";
			if(showoTRformSearch==0){
				oTRformSearch.style.display="";
				showoTRformSearch=1;
			}
			else{
				oTRformSearch.style.display="none";
			}
		}else{
			document.all("formstyle").value="3";
			oTRfield.style.display="none";
			oTRform.style.display="none";
			oTRformSearch.style.display="none";			
		}
		
		<%if (!bSystable) {%>
       	DataService.getValues(createList,"select id,labelname from formfield where formid='"+formid+"' and labelname is not null  and isdelete<1");
       	<%}%>
       	return true;
    }
    function createList(data)
	{
	    DWRUtil.removeAllOptions("objfieldid");
	    DWRUtil.addOptions("objfieldid", data,"id","labelname");
    eWebEditor.focus();
	}
function Load_Do()
{ 	
	document.all.eWebEditor.src = "/plugin/ewe/ewebeditor.htm?id=content&style=eweaver&isOpenCodeSyntax=<%=isOpenCodeSyntax%>";
    document.all.eWebEditor.focus();
  
}

function loadfieldstyle(fieldid){	
	if(document.all(fieldid+"_fieldstyle")!=null){
		document.all("fieldstyle").value=document.all(fieldid+"_fieldstyle").value;
		oTRfield.style.display="";
		oTRform.style.display="none";
		oTRformSearch.style.display="none";	
	}else{
		document.all("fieldstyle").value="2";
		oTRfield.style.display="none";
		oTRform.style.display="none";
		oTRformSearch.style.display="none";		
	}
}

function changestyle(objid){
	var fieldid = document.all("objfieldid").value;
	if(document.all(fieldid+"_fieldstyle")!=null){
				document.all(fieldid+"_fieldstyle").value=objid;	
				
  				var text = eWebEditor.getHTML();	
  				_pos = text.indexOf("$"+fieldid+"$");
  				if(_pos != -1){
  					_pos2 = text.indexOf("[",_pos);
  					if(_pos2 != -1){
  						_pos3 = text.indexOf("]",_pos2);
  						
  						var text1 = text.substring(0,_pos2+1);
  						if(objid==0)
	  						text1 += "<%=labelService
					.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%>";//隐藏
	  					else if(objid==1)
	  						text1 += "<%=labelService
					.getLabelNameByKeyId("402881ee0c715de3010c71f03222003e")%>";//只读
	  					else if(objid==2)
	  						text1 += "<%=labelService
					.getLabelNameByKeyId("402881ee0c715de3010c71f0ef500041")%>";//可编辑
	  					else if(objid==3)
	  						text1 += "<%=labelService
					.getLabelNameByKeyId("402881ee0c715de3010c71f152fc0044")%>";//必须输入
  						text1 += text.substring(_pos3);
  						setHTML(text1);
  					}
  						
  				}		
	}
}

function changestyle1(objid){
	var fieldid = document.all("objformid").value;
	if(document.all(fieldid+"_fieldstyle")!=null){
				document.all(fieldid+"_fieldstyle").value=objid;	
				
  				var text = eWebEditor.getHTML();	
  				_pos = text.indexOf("<SPAN id=div"+fieldid+"button");
  				if(_pos != -1){
  					_pos2 = text.indexOf(">",_pos);
  					_pos3 = text.indexOf("</SPAN>",_pos2);
  					if(_pos2 != -1 && _pos3 != -1){
  						var text1 = text.substring(0,_pos2+1);
  						
  						var text3 = text.substring(_pos3);
  						
  						var text2 = "";
  						if(objid==0)
	  						text2 = "";
	  					else if(objid==1)
	  						text2 = "<A href=\"javascript:addrow('"+fieldid+"');\"><IMG title=New height=11 src=\"/images/plus.gif\" width=11 border=0></A>";
	  					else if(objid==2)
	  						text2 = "<A href=\"javascript:delrow('"+fieldid+"');\"><IMG title=Delete height=11 src=\"/images/minus.gif\" width=11 border=0></A>";
	  					else if(objid==3) {
							text2 = "<A href=\"javascript:addrow('"+fieldid+"');\"><IMG title=New height=11 src=\"/images/plus.gif\" width=11 border=0></A>";
							text2 += "&nbsp;";
							text2 += "<A href=\"javascript:delrow('"+fieldid+"');\"><IMG title=Delete height=11 src=\"/images/minus.gif\" width=11 border=0></A>";
	  					}
  						text =  text1+text2+text3;
  						setHTML(text);
  					}
  						
  				}		
	}
}
 var oSel=null;
function cool_webcontrol(control)
{
  var id = "$"+control.value+"$";
  var text = eWebEditor.getHTML();
  var layouttype = document.all("layouttype").value;
  if(text.indexOf(id) != -1 && layouttype==2){
  	alert("<%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0006")%>");//该字段已经存在!
  	return;
  }
  var fieldname = "";
	var len = control.length;
	for(var i = 0; i < len; i++) {
  	
		if ((control.options[i] != null) && (control.options[i].selected)) {
			fieldname = control.options[i].text;
		}
  	}
  var formname = "";
  formlist = document.all("objformid");
  
	var len1 = formlist.length;
	for(var i = 0; i < len1; i++) {
  	
		if ((formlist.options[i] != null) && (formlist.options[i].selected)) {
			formname = formlist.options[i].text;
		}
  	}
  	
  var control_html = formname+"."+fieldname;
  control_html = "[<%=labelService
					.getLabelNameByKeyId("402881ee0c715de3010c71f0ef500041")%>]"+control_html;//可编辑
  
  insertHTML("<input type=text class=\"InputStyle2\"  id=\""+id+"\" name=\""+formlist.value+"\" value=\""+control_html+"\">");
  
  if(document.all(control.value+"_initvalue")==null){
	    var oDiv0 = document.createElement("span");
	    var oDiv = document.createElement("span");
	    var sHtml0 = "<input type=hidden name='"+control.value+"_initvalue' >";
	    sHtml0 += "<input type=hidden name='"+control.value+"_fieldstyle' value='2'>";
	    var sHtml = "<span style=\"display:''\"  name='"+control.value+"_initvaluespan' id='"+control.value+"_initvaluespan' ></span>";
        oDiv0.innerHTML = sHtml0;
	    oDiv.innerHTML = sHtml;
        formulavalue.appendChild(oDiv0);
	    fieldvalue.appendChild(oDiv);
	  
	}
	
}

function cool_webcontrolform(control){
if(control.value=='<%=forminfoid%>')
	return;
if( 1==0 && confirm('<%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0007")%>')){//是否使用该表单的表单布局?
	    

  var id = "$FORM_"+control.value+"$";
  
  var text = eWebEditor.getHTML();
  if(text.indexOf(id) != -1){
  	alert("<%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0008")%>");//该表单已经存在!
  	return;
  }
  if(text.indexOf(control.value) != -1){
  	alert("<%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0009")%>");//该表单中已经设置了某些字段!
  	return;
  }

  var formname = "";
  formlist = document.all("objformid");
  
	var len1 = formlist.length;
	for(var i = 0; i < len1; i++) {
  	
		if ((formlist.options[i] != null) && (formlist.options[i].selected)) {
			formname = formlist.options[i].text;
		}
  	}
  	
  var control_html = formname;
   insertHTML("<input type=text class=\"InputStyle2\" style=\"width:80%;height=100px\" id=\""+id+"\" name=\""+formlist.value+"\" value=\""+control_html+"\">");
  
  //insertHTML("<textarea class=\"FieldValue\" rows=8 style=\"width:80%\" id=\""+id+"\" name=\""+control.value+"\">"+control_html+"</textarea>");
  
	
  	}
}
    var selectarea;


// 在当前文档位置插入.
function insertHTML(html) {
	validateMode()
    eWebEditor.insertHTML(html);
	
}

function setHTML(html){
	validateMode()
	eWebEditor.setHTML(html);
}
function validateMode() {
eWebEditor.setMode('EDIT');
}
function send(){

      if(document.all("layoutname").value==""){
      	alert("<%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000a")%>");//请输入布局名称！
      	return;
      }

   for(i = 0; i < document.all.length; i++){
   	var _id = document.all(i).id;
   	if(_id.indexOf("_initvaluespan")!=-1){
   		var fieldid = _id.substring(0,_id.indexOf("_initvaluespan"));
   		document.all(fieldid+"_initvalue").value = document.all(_id).innerHTML;
   	}
   }
   	document.EweaverForm.submit();
}
function insertLanguageLabel(){
	var returnVal = openLanguageLabelChoose();
	if(returnVal){
		var keyword = returnVal[0];
      	var labelname = returnVal[1];
      	var languageHtml = "<A id=\"<%=LabelConstant.LANGUAGELABEL_TAGNAME%>_"+keyword+"\" name=\"<%=LabelConstant.LANGUAGELABEL_TAGNAME%>\">"+labelname+"</A>";
		insertHTML(languageHtml);
		clearEmptyLanguageLabel();
	}
}
function clearEmptyLanguageLabel(){	//清空空标记标签,尚未实现
	//var allHtml = eWebEditor.getHTML();
	//var allHtml = "<TD class=FieldName noWrap><A id=MultiLanguageLabel_402883e335378d81013537a654710003 name=MultiLanguageLabel>张三51</A><A id=MultiLanguageLabel_402883e335378d81013537a654710003 name=MultiLanguageLabel></A></TD>";
	//alert(allHtml);
	//str.replace(/<font .*?<\/font>/ig,""). 
	//var allHtml=allHtml.replace(/<A id=MultiLanguageLabel_.*\ name=MultiLanguageLabel\>\<\/A\>/,"");
	//alert(allHtml);
	//setHTML(allHtml);
}
function openLanguageLabelChoose(){
	if(Ext.isIE){
		try{
			var url = "/base/label/labelchoose.jsp?labelType=<%=LabelType.FormField%>&formId=<%=forminfoid%>";
			var features = "dialogHeight:500px;dialogWidth:600px;status:no;center:yes;resizable:yes";
			return openDialog(url,window,features);
		}catch(e){return;}
	}else{
		alert("sorry,this operating only can working in IE");
	}
}
</script>
  </head> 
  <body onload="Load_Do();" style="font-family: verdana;font-size: 9pt;MARGIN: 0px;" onunload="reloadmainwin()" >

   <div id='designerdiv' bgcolor="#DDDDDD" width="100%">
					<IFRAME ID="eWebEditor" SRC="#" FRAMEBORDER="0" SCROLLING="no" WIDTH="100%" HEIGHT="100%"></IFRAME>
   </div>
   <div id='properties'>
     <table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
     <colgroup>
         <col width="100%">
     </colgroup>
     <tr class="TableHeader"><td align="center"><b><%=labelService
					.getLabelName("402881ee0c715de3010c71eddb260038")%><!-- 布局类型:--></b><%=FormLayoutTranslate.getLayoutById(typeid)%></td></tr>
	<TR><TD class="Line"></TD></tr>
       <tr class="TableHeader"><td align="center"><b><%=labelService
					.getLabelName("402881ec0bdbf198010bdbf5cf580004")%><!-- 关联表单--></b></td></tr>
      <tr><td align="center"> 
      <select size=5 name="objformid" style="width:100%" onfocus="oTRformSearchShow();" onchange="javascript:getformfield(this.value);" ondblclick="cool_webcontrolform(this)">
      	<option value="<%=forminfoid%>" selected><%=forminfo.getObjname()%></option>
			<%
				if (formtype == 1) {
					String strHql = "from Formlink where oid='" + forminfoid
							+ "' order by pid";
					List list = ((FormlinkService) BaseContext
							.getBean("formlinkService")).findFormlink(strHql);

					for (int i = 0; i < list.size(); i++) {
						Formlink formlink = (Formlink) list.get(i);
						includedformids += ",'" + formlink.getPid() + "'";
			%>	
				<option value="<%=formlink.getPid()%>"><%=((Forminfo) forminfoService
							.getForminfoById(formlink.getPid())).getObjname()%></option>
				<%
					}
					}
				%>	
      </select>
      </td>
      </tr><tr><td align="center"> <select size=15 name="objfieldid" style="width:100%" onchange="javascript:loadfieldstyle(this.value);" ondblclick="cool_webcontrol(this)">
       <%
       	String strHql = "from Formfield where formid='" + forminfoid
       			+ "' and labelname is not null and isdelete<1 order by id";
       	List list = ((FormfieldService) BaseContext
       			.getBean("formfieldService")).findFormfield(strHql);

       	for (int i = 0; i < list.size(); i++) {
       		Formfield formfield = (Formfield) list.get(i);

       		String showValue = formfield.getId();
       %>	
			<option value="<%=showValue%>"><%=formfield.getLabelname()%></option>
			<%
				}
			%>		
      </select>
      </td></tr>      
	<TR><TD class="Line"></TD></tr>
      <form action="/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=modify"  target="_self" name="EweaverForm"  method="post" >
      
     <tr class="TableHeader"><td align="center"><b><%=labelService
					.getLabelName("402881ee0c715de3010c71ef2af1003b")%><!-- 显示样式:--></b></td></tr>
      <tr id=oTRfield name="oTRfield" style="display:'none'"><td  align="center">
      <select name="fieldstyle" style="width:120" onchange="javascript:changestyle(this.value);">
      <option value="0"><%=labelService
					.getLabelName("402881eb0bd66c95010bd68004400003")%><!-- 隐藏--></option>
      <option value="1"><%=labelService
					.getLabelName("402881ee0c715de3010c71f03222003e")%><!-- 只读--></option>
      <option value="2"><%=labelService
					.getLabelName("402881ee0c715de3010c71f0ef500041")%><!-- 可编辑--></option>
      <option value="3"><%=labelService
					.getLabelName("402881ee0c715de3010c71f152fc0044")%><!-- 必须输入--></option>
      </select>
</td></tr>
      <tr id=oTRform  name="oTRform" style="display:'none'"><td  align="center">
      <select name="formstyle" style="width:120" onchange="javascript:changestyle1(this.value);">
      <option value="0"><%=labelService
					.getLabelName("402881ee0c715de3010c71f249c90047")%><!-- 不可添加,不可删除--></option>
      <option value="1"><%=labelService
					.getLabelName("402881ee0c715de3010c71f30607004a")%><!-- 可添加,不可删除--></option>
      <option value="2"><%=labelService
					.getLabelName("402881ee0c715de3010c71f36d25004d")%><!-- 不可添加,可删除--></option>
      <option value="3"><%=labelService
					.getLabelName("402881ee0c715de3010c71f456220050")%><!-- 可添加,可删除--></option>
      </select>
</td>
</tr>
      <input type="hidden" name="layouttype" value="<%=typeid%>">
      <input type="hidden" name="supportedclient" value="0">
      
				<tr id="oTRformSearch"  name="oTRformSearch" style="display:'none'">
					<td class="FieldName" nowrap>
						<a href="javascript:getBrowser();" ><%=labelService
					.getLabelName("402881ee0c715de3010c71f4d7580053")%></a>
						<!-- 查询条件-->
					</td>

				</tr>						
						   
       </table>
      
      <HR>
     <table width="120" border="0" cellspacing="1" cellpadding="3" align="center">
      <tr>
        <td align="center">
            <B><%=labelService
					.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%><!-- 名称 -->:</B>
        </td>
      </tr>
      <tr>
        <td align="center">
            <INPUT type="text" class="InputStyle2" size=50 style="width:118" name="layoutname" value="<%=layoutname%>" onChange="checkInput('layoutname','layoutnamespan')">
            <span id="layoutnamespan"/><%
            	if (layoutname == null || layoutname.equals("")) {
            %><img src=/images/base/checkinput.gif><%
            	}
            %></span>
        </td>
      </tr>
 		<%
 			if (!bSystable) {
 				if (workflowid.length() > 0) {
 		%>
		   <tr>
		      <td align="center">
		         <B>节点:</B>
		      </td>
		   </tr>
		   <tr>
		   <td align="center">
			<select name="nodeid" style="width:120px">
			<option value="">--</option>
		  	<%
		  		NodeinfoService nodeinfoService = (NodeinfoService) BaseContext
		  						.getBean("nodeinfoService");
		  				List nodelist = nodeinfoService
		  						.getNodelistByworkflowid(workflowid);
		  				for (int i = 0; i < nodelist.size(); i++) {
		  					Nodeinfo nodeinfo = (Nodeinfo) nodelist.get(i);
		  					String tempid = nodeinfo.getId();
		  					String tempvalue = nodeinfo.getObjname();
		  	%>	
			<option value="<%=tempid%>" <%=(nodeid != null && nodeid.equals(tempid) ? "selected"
										: "")%>><%=tempvalue%></option>
		<%
			}
		%>		
		</select>
		</td>
		</tr>
		<%
			} else {
		%>
      
      <INPUT type="hidden" name="nodeid" value="<%=nodeid%>">
      <%
      	}
      	}
      %>
      <tr>
        <td align="center">
            <B><%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000b")%><!-- 默认 -->:</B>
        </td>
      </tr>
      <tr>
        <td align="center">
            <select name="isdefault" style="width:120" value="<%=isdefault%>">
                <%
                	String defaultyes = "";
                	String defaultno = "";
                	if ("1".equals(isdefault)) {
                		defaultyes = "selected";
                	} else {
                		defaultno = "selected";
                	}
                %>
            <option value="0" <%=defaultno%>><%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000c")%></option>
            <option value="1" <%=defaultyes%>><%=labelService
					.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000b")%><!-- 默认 --></option>
            </select>
        </td>
      </tr>
    </table>
    <HR>
       <table width="120" border="0" cellspacing="1" cellpadding="3" align="center">
    
      <tr><td align="center"><button type="button" style="width:120;height:30;text-Align:center" onclick="send()"><%=labelService
					.getLabelName("402881ee0c715de3010c71f64c9d0059")%><!-- 保存表单--></button></td></tr>
      <tr><td align="center"><button type="button" style="width:120;height:30;text-Align:center" onclick="beforeExit();"><%=labelService
					.getLabelNameByKeyId("402881eb0bcd354e010bcdc6ba260024")%><!-- 退 &nbsp; 出 --></button></td></tr>
      <INPUT type="hidden" name="content" value="<%=formlayout.getLayoutinfo().replaceAll("\"", "")%>">
      <INPUT type="hidden" name="forminfoid" value="<%=forminfoid%>">
      <INPUT type="hidden" name="layoutid" value="<%=layoutid%>">
      
    </table>
    <%
    	String _layoutid = formlayout.getId();
    	StringBuffer spanhtml = new StringBuffer();
    	if (!StringHelper.isEmpty(_layoutid)) {
    		List layoutfieldlist = formlayoutService.findFormlayoutfieldBy(
    				"layoutid", _layoutid);
    		for (int i = 0; i < layoutfieldlist.size(); i++) {
    			Formlayoutfield _layoutfield = (Formlayoutfield) layoutfieldlist
    					.get(i);
    			String _fieldname = StringHelper.null2String(_layoutfield
    					.getFieldname());
    			String _formid = StringHelper.null2String(_layoutfield
    					.getFormid());
    			int _showstyle = _layoutfield.getShowstyle().intValue();
    			if (!_fieldname.equals("")) {
	    			String _formula = StringHelper.null2String(_layoutfield.getFormula());
    				spanhtml.append(
    						"<span style=\"display:'none'\"  name=\"")
    						.append(_fieldname).append(
    								"_initvaluespan\" id=\"").append(
    								_fieldname)
    						.append("_initvaluespan\" >").append(_formula)
    						.append("</span>");
    %>
  		<input type=hidden name="<%=_fieldname%>_fieldstyle" value="<%=_showstyle%>" >
  		<input type=hidden name="<%=_fieldname%>_initvalue" value="" >

  <%
  	} else if (!_formid.equals("")) {
  				String _formula = StringHelper.null2String(_layoutfield.getDefaultvalue());
  				detailformids += "," + _formid;
  				spanhtml
  						.append(
  								"<span style=\"display:''\"  name=\""
  										+ _formid).append(
  								"_initvaluespan\" id=\"").append(
  								_formid).append("_initvaluespan\" >")
  						.append(_formula).append("</span>");
  %>
  		<input type=hidden name="<%=_formid%>_fieldstyle" value="<%=_showstyle%>" >
  		<input type=hidden name="<%=_formid%>_initvalue" value="" >
  <%
  	}
  		}
  	} else {
  		strHql = "from Formfield where formid in(" + includedformids
  				+ ") and isdelete<1 order by formid";
  		list = ((FormfieldService) BaseContext
  				.getBean("formfieldService")).findFormfield(strHql);

  		for (int i = 0; i < list.size(); i++) {
  			Formfield formfield = (Formfield) list.get(i);
  			spanhtml.append("<span style=\"display:'none'\"  name=\"")
  					.append(formfield.getId()).append(
  							"_initvaluespan\" id=\"").append(
  							formfield.getId()).append(
  							"_initvaluespan\" ></span>");
  %>
  		<input type=hidden name="<%=formfield.getId()%>_fieldstyle" value="2" >
  		<input type=hidden name="<%=formfield.getId()%>_initvalue" value="" >

  <%
  	}

  		strHql = "from Formlink where oid in(" + includedformids
  				+ ") and pid in(" + includedformids
  				+ ") and typeid=2 order by typeid desc";
  		list = ((FormlinkService) BaseContext
  				.getBean("formlinkService")).findFormlink(strHql);

  		for (int i = 0; i < list.size(); i++) {
  			Formlink formlink = (Formlink) list.get(i);

  			detailformids += "," + formlink.getPid();
  			spanhtml.append("<span style=\"display:'none'\"  name=\"")
  					.append(formlink.getPid()).append(
  							"_initvaluespan\" id=\"").append(
  							formlink.getPid()).append(
  							"_initvaluespan\" ></span>");
  %>
  		<input type=hidden name="<%=formlink.getPid()%>_fieldstyle" value="3" >
  		<input type=hidden name="<%=formlink.getPid()%>_initvalue" value="" >
  <%
  	}
  	}
  %>
  	<input type=hidden name="detailformids" value="<%=detailformids%>" />
    <span id="formulavalue" style="display:none">
  </span>
        </form>
   </div>
  <div id='bottomdiv' bgcolor="#DDDDDD" width="100%" colspan=2 nowrap><%=labelService
					.getLabelName("402881ee0c715de3010c71f56a280056")%><!-- 字段属性:-->
  <span id="fieldvalue" width=80%>
    <%=spanhtml.toString()%>
  </span>
  </div>
  <script language=vbs>

</script>	

<script >
  	function reloadmainwin(){
   		window.opener.location.reload();
   	}
   	
   	function getBrowser(){
		
		var fieldid = document.all("objformid").value;
		var condition =  document.all(fieldid+"_initvaluespan").innerHTML;
		while(condition.indexOf("%")!=-1){
			condition=condition.replace("%","@");
		}
		while(condition.indexOf("\"")!=-1){
			condition=condition.replace("\"","syh");
		}
		var url="/workflow/workflow/showcondition.jsp?condition="+encodeURIComponent(condition);
		var id = window.showModalDialog(encodeURI("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url));

		document.all(fieldid+"_initvaluespan").innerHTML=id;
		document.all(fieldid+"_initvalue").value=id;
	}
</script>
</body>
</html>