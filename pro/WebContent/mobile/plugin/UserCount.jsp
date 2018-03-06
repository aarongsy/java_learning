<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
MultipartRequest fu = new MultipartRequest(request,".","UTF-8");


boolean reload=Boolean.valueOf(StringHelper.null2String(fu.getParameter("reload")));

List auths = new ArrayList();

String[] ids = fu.getParameterValues("id");
String[] types = fu.getParameterValues("type");
String[] typenames = fu.getParameterValues("typename");
String[] seclevels = fu.getParameterValues("seclevel");
String[] values = fu.getParameterValues("value");
String[] valuenames = fu.getParameterValues("valuename");
String[] groupids = fu.getParameterValues("groupid");
String authstr = fu.getParameter("auth");
JSONObject authobj = (JSONObject)JSONArray.parse(authstr);
JSONArray autharray = authobj.getJSONArray("auths");
for(int i=0;autharray!=null&&i<autharray.size();i++) {
	JSONObject aobj = (JSONObject)autharray.get(i);
	String id = aobj.getString("id");
	String type = aobj.getString("type");
	String typename = aobj.getString("typename");
	String seclevel = aobj.getString("seclevel");
	String value = aobj.getString("value");
	String valuename = aobj.getString("valuename");
	String groupid = aobj.getString("groupid");
	
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
JSONObject result = new JSONObject();
int count = pluginService.getMobileUserCount(auths, reload);
result.put("count", count+"");
response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(result.toJSONString());
			response.getWriter().flush();
			response.getWriter().close();
%>