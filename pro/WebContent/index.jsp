<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.homepage.service.PagesService" %>
<%@ page import="com.eweaver.base.security.servlet.SwitchUserAction" %>
<%@ page import="com.eweaver.homepage.model.Pages" %>
<%@ page import="com.eweaver.base.security.model.Sysuser" %>
<%@ page import="com.eweaver.homepage.model.WebSkin" %>
<%@ page import="com.eweaver.homepage.dao.WebSkinDao" %>
<%@ page import="org.apache.velocity.VelocityContext" %>
<%@ page import="com.eweaver.base.treeviewer.service.VelocityMacroObject" %>
<%!
private WebSkinDao webSkinDao=(WebSkinDao)BaseContext.getBean("webSkinDao");
private Map getRequestParams(HttpServletRequest request){
	Map paramMap=new HashMap();
	Map map=request.getParameterMap();
	Iterator ite=map.keySet().iterator();
	String tmpObject=null;
	while(ite.hasNext()){
		tmpObject=StringHelper.null2String(ite.next());
		String val=StringHelper.null2String(request.getParameter(tmpObject));
		paramMap.put(tmpObject, val);
	}
	return paramMap;
}
/**
 *如果用户未登录,则默认匿名帐号登录.
 */
private void anonymousLogin(HttpServletRequest request){
	EweaverUser user=BaseContext.getRemoteUser();
	String hql="from Sysuser where longonname='anonymous'";
	List<Sysuser> list1=this.webSkinDao.getList(hql);
	if(user==null && list1!=null && !list1.isEmpty()){
		SwitchUserAction.switchUser(request,list1.get(0));
	}
}
%>
<%
this.anonymousLogin(request);
request.setCharacterEncoding("utf-8");
StringBuffer buf=new StringBuffer();
buf.append("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/jquery.min.js\"></script>\r\n");
buf.append("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/jqueryMenu.js\"></script>\r\n");
buf.append("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/jquery.idTabs.min.js\"></script>\r\n");
buf.append("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/homepage/files/webmain.js\"></script>\r\n");

PagesService pagesService=(PagesService)BaseContext.getBean("pagesService");
String id=StringHelper.null2String(request.getParameter("id"));

if(id.equalsIgnoreCase("4028803222b9d5820122ba18bfe00004") && BaseContext.getRemoteUser()==null){
	out.println("<html><head><meta http-equiv=\"refresh\" content=\"3;URL=/index.jsp\" />");
	out.println("</head><body><h3>未登录!</h3></body></html>");
	return;
}
Pages p=null;
if(StringHelper.isEmpty(id))p=pagesService.getHomepage();
else p=pagesService.getPagesDao().getObjectById(id);
if(p==null){
	out.println("not found default homepage!");return;	
}
String skinName="default";
List<WebSkin> list1=webSkinDao.getList("from WebSkin where isdefault=1");
if(list1!=null && !list1.isEmpty()){
	skinName=list1.get(0).getPath();
}//取得默认皮肤
String path=request.getContextPath()+"/homepage/skin/"+skinName;
buf.append("<style type=\"text/css\">\r\n");
buf.append("@import url("+path+"/menu.css);\r\n");
buf.append("@import url("+path+"/main.css);\r\n");
buf.append("@import url("+path+"/tabs.css);\r\n");
buf.append("</style>");

VelocityContext context=new VelocityContext();
context.put("title",p.getTitle());
context.put("path",path);
context.put("Params",this.getRequestParams(request));
context.put("headerFiles",buf.toString());
context.put("isLogin",(BaseContext.getRemoteUser()!=null));
context.put("Userinfo",BaseContext.getRemoteUser());
///main/logout.jsp
context.put("root",request.getContextPath()+"/homepage");
context.put("GlobalObject",new VelocityMacroObject(out));
VtlEngineHelper.generateFile(p.getFilename(),context,out);
%>