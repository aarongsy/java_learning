<%@ page contentType="text/html; charset=UTF-8"%>
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
<%@ page import="com.eweaver.base.security.mainpage.MainPage"%>
<%@ page import="com.eweaver.base.security.mainpage.MainPageDefined"%>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
String basePath2 = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
BaseContext.setHttpbasepath(basePath2);
if(eweaveruser == null){
	return;
}
String style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
/*首页类型*/
MainPageDefined mainPageDefined = (MainPageDefined)BaseContext.getBean("mainPageDefined");
MainPage userMainPage = mainPageDefined.getMainPageByType(eweaveruser.getSysuser().getMainPageType());
/**皮肤设置相关代码**/
String skinid = eweaveruser.getSysuser().getSkinid();
SkinService skinService = (SkinService)BaseContext.getBean("skinService");
Skin currentSkin = skinService.getSkinById(skinid);
if(currentSkin == null || currentSkin.getId() == null){
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
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}

String type = StringHelper.null2String(request.getParameter("type")).equals("")?"1":StringHelper.null2String(request.getParameter("type"));
String tagid = StringHelper.null2String(request.getParameter("tagid"));
String coworkid = StringHelper.null2String(request.getParameter("requestid"));
%>
<html>
<head>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript">
	function resize() {
       //document.body.rows = document.getElementById("frameLeft").contentWindow.document.body.scrollHeight +",*";
       document.body.rows="100%,*";
       //document.body.cols="404,*";
    }
</script>
</head>
  <frameset BORDER=0 FRAMEBORDER=no  cols="404,*" noresize="noresize" name="frameBottom" id="frameBottom"  border="0" style="height: auto;">
	<frame BORDER="0" FRAMEBORDER="no" noresize="noresize" src="<%= request.getContextPath()%>/app/cooperation/coworklist.jsp?type=<%=type%>&tagid=<%=tagid%>&coworkid=<%=coworkid %>" name="frameLeft" id="frameLeft" scrolling="no">
	<frame BORDER="0" FRAMEBORDER="no" noresize="noresize" src="<%= request.getContextPath()%>/app/cooperation/showcowork.jsp" name="frameRight" id="frameRight" <%if(currentSysModeIsWebsite){%>scrolling="no"<%}else{%>scrolling="auto"<%}%> >
  </frameset>
</html>
