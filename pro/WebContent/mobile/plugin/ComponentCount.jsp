<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.mobile.plugin.common.Constants" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
String module = StringHelper.null2String(request.getParameter(Constants.MOBILE_CONFIG_MODULE_PARAM));
String scope = StringHelper.null2String(request.getParameter("scope"));
String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));
String[] conditions = request.getParameterValues("conditions");

if(pluginService.verify(sessionkey)) {
	List cs = new ArrayList();
	
	if(conditions!=null) cs = Arrays.asList(conditions);
	ServiceUser user = new ServiceUser();
	user.setId(sessionkey);
	int unread = 0;
	int count = 0;
	if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")) {
		WebServiceData webServiceData = pluginService.getModuleCount(user,NumberHelper.string2Int(module,1));
		Map result = webServiceData.getMainData();
		if(result!=null) {
			unread = NumberHelper.string2Int(StringHelper.null2String((String)result.get("UNREAD")), 1);
			count = NumberHelper.string2Int(StringHelper.null2String((String)result.get("COUNT")), 0);
		}
	}
	if(module.equals("2")||module.equals("3")) {
		//Map result = ps.getDocumentCount(cs, sessionkey);
		Map result = new HashMap();
		if(result!=null) {
			unread = NumberHelper.string2Int(StringHelper.null2String((String)result.get("UNREAD")), 0);
			count = NumberHelper.string2Int(StringHelper.null2String((String)result.get("COUNT")), 0);
		}
	}
	
	Map result = new HashMap();
	
	result.put("count", count);
	result.put("unread", unread);
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>