<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.skin.service.SkinService"%>
<%@ page import="com.eweaver.base.skin.model.Skin"%>
<%@ page import="java.io.File"%>
<%@page import="com.eweaver.base.security.mainpage.MainPage"%>
<%@page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
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
obj.location = "/main/login.jsp?error=LoginOutTimeException";
</script>
<%
	return;
}
if(null==eweaveruser.getOrgids()){
	eweaveruser.setOrgids("");
}
Humres currentuser = eweaveruser.getHumres();
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
String style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
if(StringHelper.isEmpty(style)){
	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
        style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
}

PermissionruleService ps = (PermissionruleService) BaseContext.getBean("permissionruleService");
boolean isSysAdmin = ps.checkUserRole(eweaveruser.getId(),"402881e50bf0a737010bf0a96ba70004",null); 
/*首页类型*/
MainPageDefined mainPageDefined = (MainPageDefined)BaseContext.getBean("mainPageDefined");
MainPage userMainPage = mainPageDefined.getMainPageByType(eweaveruser.getSysuser().getMainPageType());
/**皮肤设置相关代码**/
String skinid = eweaveruser.getSysuser().getSkinid();
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
