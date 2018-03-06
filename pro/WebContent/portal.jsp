<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.eweaver.base.skin.SkinConstant"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="/base/init.jsp" %>
<html>
<head>
<title>Light Portal</title>
<style type="text/css">
.x-toolbar table {width:0}
#pagemenubar table {width:0}
.x-panel-btns-ct {
    padding: 0px;
}
.x-panel-btns-ct table {width:0}
.ux-maximgb-treegrid-breadcrumbs{
    display:none;
}
.x-btn-text{
	color: #000;
}
body{
	padding: 0px 0px 0px 7px;
	margin:0; 
	overflow-x: hidden; 
	overflow-y: auto;
	/*background: url(/images/bg/22.jpg);*/
	background-position: 0 -150;
}
.portal-tabs{display:none;}
</style>
<!-- 
<link href="/light/theme/master.css" rel="stylesheet" type="text/css">  -->
<link href="/js/jquery/plugins/qtip/jquery.qtip.min.css" rel="stylesheet" type="text/css">
<link href="/css/portal.css?v=12752" rel="stylesheet" type="text/css">
<% if(userMainPage.getIsUseSkin()){ //当前用户选择的首页是使用皮肤的%>
<link id="portal_css" href="<%=currentSkin.getBasePath() %>/<%=SkinConstant.PORTAL_CSS_NAME %>" rel="stylesheet" type="text/css">
<% } %>

<script src='/dwr/interface/RemotePortal.js'></script>
<script src='/dwr/interface/GetemailsService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<jsp:include flush="true" page="/common/meta.jsp"/>
<light:personalAccount/>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/storemenu.js"></script>
<script type="text/javascript" src="/js/ext/ux/ajaxqueue.js"></script>
<script type="text/javascript" src="/light/scripts/template.js"></script>
<script type="text/javascript" src="/light/scripts/aim.js"></script>
<script type="text/javascript" src="/light/scripts/light.js"></script>
<script type="text/javascript" src="/light/scripts/lightAjax.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortalHeader.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortalMenu.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortalBody.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortalFooter.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortal.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortalTab.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortalConfig.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortlet.js"></script>
<script type="text/javascript" src="/light/scripts/lightWindow.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortletConfig.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortletStyle.js"></script>
<script type="text/javascript" src="/light/scripts/lightPortletAction.js"></script>
<script type="text/javascript" src="/light/scripts/lightUtil.js"></script>
<script type="text/javascript" src="/light/scripts/locale/lightResourceBundle_zh_CN.js"></script>
<script type="text/javascript" src="/light/scripts/portletsFun.js"></script>
<script type="text/javascript" src="/chart/fusionchart/FusionCharts.js"></script>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/qtip/jquery.qtip.min.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<SCRIPT type="text/javascript" src="/js/jquery/plugins/jshowoff/jquery.jshowoff.js"></SCRIPT>
<link rel="stylesheet" media="screen" href="/js/jquery/plugins/jshowoff/jshowoff.css" />
<script type="text/javascript" src="/js/jquery/plugins/cycle/jquery.cycle.all.js"></script>
<link  type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/js/jquery/plugins/qtip/jquery.qtip.min.css" />
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/app/cooperation/js/jquery.qtip-1.0.0-rc3.js"></script>
<script type="text/javascript" src="/js/justgage/justgage.1.0.1.min.js"></script>
<script type="text/javascript" src="/js/justgage/raphael.2.1.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/jquery-ui-1.9m7/themes/base/minified/jquery-ui.min.css"/>
<script type="text/javascript" src="/js/jquery/jquery-ui-1.9m7/ui/minified/jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui-1.9m7/ui/minified/jquery.ui.tabs.min.js"></script>
<script type="text/javascript">
var iconBase = '/images';
var contextPath = '';
var currentPortalTabScrolls = 1;
var targetPortalTabId = '<%=StringHelper.null2String(request.getParameter("targetPortalTabId"))%>';

function keyUp(e) {
	e = e||event;
	var srcEle = event.srcElement ? event.srcElement : event.target;
	var f = top.frames[1];
	var o;
	var currKey = e.keyCode||e.which||e.charCode;
	if(currKey==39){
		o = f.document.getElementById("pDot"+(parseInt(f.dotCurrent)+1));
	}else if(currKey==37){
		o = f.document.getElementById("pDot"+(parseInt(f.dotCurrent)-1));
	}
	if(o && srcEle.tagName!="INPUT" && srcEle.tagName!="TEXTAREA"){
		top.frames[1].portalTabSlide(o);
	}
}
$(function(){
	document.body.focus();
	document.onkeydown = keyUp;	
	Light.refreshPortal();
	top.window['TabPortlet'] = TabPortlet;
	top.window['TodoWorkflowPortlet'] = TodoWorkflowPortlet;
});


function slidePortal(t){
	var l = 0;
	if(t==1){
		l = 0;
	}else{
		l = document.documentElement.scrollWidth * (t-1);
	}//alert(l);
	$('html, body').animate({
		scrollLeft : l
	}, 500);
}
function test(){
	var b = Light._CURRENT_TAB;alert(b);
	Light.deleteCookie(b)
	alert(Light._CURRENT_TAB);
}

function loadFormFields(doBind,titleFieldVal,linkFieldVal,contentFieldVal,orderFieldVal){
	var categoryId = document.getElementById("categoryId").value;
	if(categoryId != ''){
	    Ext.Ajax.request({   
			url: '/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=getFormfieldByCategoryidWithJSONData',   
			method : 'post',
			params:{   
				categoryId : categoryId
			}, 
			success: function (response)    
	        {   
	        	function createOption(data){
	        		var option = new Option(data["labelname"] + "-" + data["fieldname"],data["fieldname"]);
	        		return option;
	        	}
				var datas = Ext.decode(response.responseText);
				clearSelect("titleField");
				clearSelect("linkField");
				clearSelect("contentField");
				clearSelect("orderField");
				var titleField = document.getElementById("titleField");
				var linkField = document.getElementById("linkField");
				var contentField = document.getElementById("contentField");
				var orderField = document.getElementById("orderField");
				for(var i = 0; i < datas.length; i++){
					if(datas[i]["htmltype"] == 3){	//带格式文本
						contentField.options.add(createOption(datas[i]));
					}else if(datas[i]["htmltype"] == 1){	//单行文本
						titleField.options.add(createOption(datas[i]));
						linkField.options.add(createOption(datas[i]));
						orderField.options.add(createOption(datas[i]));
					}
				}
				if(doBind){
					bindSelect("titleField",titleFieldVal);
	     			bindSelect("linkField",linkFieldVal);
	     			bindSelect("contentField",contentFieldVal);
	     			bindSelect("orderField",orderFieldVal);
	    		}
	        },
		 	failure: function(response,opts) {    
			 	Ext.Msg.alert('loadFormFields Error', response.responseText);   
			}  
		}); 
    }
}
function clearSelect(selId){
    var sel = document.getElementById(selId);
	while(sel.childNodes.length > 0)	//清空下拉列表
	{
		sel.removeChild(sel.childNodes[0]);
	}	
}
     
function bindSelect(selId,v){
	var sel = document.getElementById(selId);
	for(var i = 0; i < sel.options.length; i++){
		if(sel.options[i].value == v){
			sel.options[i].selected = true;
			break;
		}
	}
}

function doChecked(eleName, v){
	var eles = document.getElementsByName(eleName);
	for(var i = 0; i < eles.length; i++){
		var ele = eles[i];
		if(ele.value == v){
			ele.checked = true;
			break;
		}
	}
}

function hiddenTitleMargin(){
	document.getElementById("titleMarginTopTR").style.display = "none";
	document.getElementById("titleMarginRightTR").style.display = "none";
	var eles = document.getElementsByName("titleDisplayMode");
	var v = "";
	for(var i = 0; i < eles.length; i++){
		var ele = eles[i];
		if(ele.checked ){
			v = ele.value;
			break;
		}
	}
	if(v == "0"){
		document.getElementById("titleMarginTopTR").style.display = "block";
	}else if(v == "1"){
		document.getElementById("titleMarginRightTR").style.display = "block";
	}
}

/*如果门户页面中不包含快捷方式页面,则此对象未定义*/
var shortCutWindow;	//快捷方式窗体对象(由快捷方式页面在页面加载完成之后初始化到门户页面中)

function changeShortCutWidowStyle(shortcutCssPath){
	if(shortCutWindow){
		shortCutWindow.document.getElementById("shortcut_css").href = shortcutCssPath;
	}
}
function openShortCutSetting(){
	openShortCutDialog("/base/shortcut/shortcutmanage.jsp","快速入口设置",650,450)
	var shortCutDialog;
	function openShortCutDialog(url,title,width,height){
	   shortCutDialog = new Ext.Window({
	        layout:'border',
	        closeAction:'hide',
	        plain: true,
	        modal :true,
	        items:[{
		        id:'commondlg',
		        region:'center',
		        xtype     :'iframepanel',
		        frameConfig: {
		            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
		            eventsFollowFrameLinks : false
		        },
		        autoScroll:true
		    }],
		    buttons:[{
               text     : '完成',
               handler  : function() {
                  closeShortCutDialog();
               }

           }]
	    });
	    shortCutDialog.render(Ext.getBody());
	    shortCutDialog.setTitle(title);
	    shortCutDialog.setWidth(width);
	    shortCutDialog.setHeight(height);
	    shortCutDialog.getComponent('commondlg').setSrc(url);
	    shortCutDialog.show();
	}
	
	function closeShortCutDialog(){
		if(shortCutWindow){
			shortCutWindow.location.reload();
		}
		if(shortCutDialog){
			shortCutDialog.close();
		}
	}
}
var shortCutDialog;
function openShortcutChoose(portletId, responseId){
	shortCutDialog = new Ext.Window({
	        layout:'border',
	        closeAction:'hide',
	        plain: true,
	        modal :true,
	        items:[{
		        id:'commondlg',
		        region:'center',
		        xtype     :'iframepanel',
		        frameConfig: {
		            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
		            eventsFollowFrameLinks : false
		        },
		        autoScroll:true
		    }],
		    buttons:[{
               text     : '关闭',
               handler  : function() {
                  shortCutDialog.close();
               }

           }]
	});
    shortCutDialog.render(Ext.getBody());
    shortCutDialog.setTitle("快速入口设置");
    shortCutDialog.setWidth(650);
    shortCutDialog.setHeight(450);
    shortCutDialog.getComponent('commondlg').setSrc("/base/shortcut/shortcutmanage2.jsp?portletId="+portletId + "&responseId=" + responseId);
    shortCutDialog.show();
}
function closeShortcutChoose(portletId, responseId){
	if(shortCutDialog){
		shortCutDialog.close();
	}
	Light.getPortletById(responseId).refresh();
}
function reinitIframe(){

	var iframe = document.getElementById('forum');

	try{

	var bHeight = iframe.contentWindow.document.body.scrollHeight;

	var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
	//iframe.height =100;//Math.min(bHeight, dHeight);
	//alert(bHeight+','+dHeight);
	var height = Math.max(bHeight, dHeight);

	iframe.height =  height;


	}catch (ex){}

}
window.setInterval("reinitIframe()", 1000);
/**
*协作区
*/
function readCowork(requestid,responseId,title){
	onUrl('/app/cooperation/allcowork.jsp?requestid='+requestid,title,'tab'+requestid);
	var t=window.setTimeout(function (){
	   Light.getPortletById(responseId).refresh();
	},3000);
}
</script>
</head>
<body></body>
</html>