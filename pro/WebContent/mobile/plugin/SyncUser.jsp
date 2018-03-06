<%@ page language="java" contentType="application/json" pageEncoding="GBK"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%
MultipartRequest fu = new MultipartRequest(request,".","UTF-8");
boolean reload=Boolean.valueOf(StringHelper.null2String(fu.getParameter("reload")));
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
List auths = new ArrayList();

String[] ids = fu.getParameterValues("id");
String[] types = fu.getParameterValues("type");
String[] typenames = fu.getParameterValues("typename");
String[] seclevels = fu.getParameterValues("seclevel");
String[] values = fu.getParameterValues("value");
String[] valuenames = fu.getParameterValues("valuename");
String[] groupids = fu.getParameterValues("groupid");

for(int i=0;ids!=null&&i<ids.length;i++) {
	String id = ids[i];
	String type = types[i];
	String typename = typenames[i];
	String seclevel = seclevels[i];
	String value = values[i];
	String valuename = valuenames[i];
	String groupid = groupids[i];
	
	Map auth = new HashMap();
	auth.put("id", id);
	auth.put("type", type);
	auth.put("typename", typename);
	auth.put("seclevel", seclevel);
	auth.put("value", value);
	auth.put("valuename", valuename);
	auth.put("groupid", groupid);
	
	auths.add(auth);
}

Map result=new HashMap();

auths=pluginService.syncUserAuth(auths);

result.put("auths",auths);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>