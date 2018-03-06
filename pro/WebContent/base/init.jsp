<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.skin.service.SkinService"%>
<%@ page import="com.eweaver.base.skin.model.Skin"%>
<%@ page import="java.io.File"%>
<%@ page import="com.eweaver.base.skin.SkinConstant"%>
<%@page import="com.eweaver.base.security.mainpage.MainPage"%>
<%@page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@ page import="com.eweaver.app.bbs.discuz.client.Client" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
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
SkinService skinService = (SkinService)BaseContext.getBean("skinService");
Skin currentSkin = skinService.getCurrSkinWithUser(suser);

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

if(request.getAttribute("exportExcel")==null){//导出为Excel时不输出该HTML
%>
<html>
  <head>
  <meta http-equiv="X-UA-Compatible" content="IE=5" >
    <link rel="stylesheet" type="text/css" href="/css/global.css">
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
    
     <%if(!"".equals(style)&&!"default".equals(style)){%>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/xtheme-<%=style%>.css"/>
     <%}%>
     
    <link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
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
  </head>
  <body>
  	<div style="margin: 0;padding: 0;display: none;">
  		<!-- 隐藏域参数 -->
		<input type="hidden" id="currentSysMode" value="<%=currentSysMode %>" style="margin: 0;padding: 0;"/>
	</div>
  </body>
</html>
<%
}
%>