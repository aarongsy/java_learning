<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.mobile.plugin.common.Page" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%


String method = StringHelper.null2String(request.getParameter("method"));
String browserId = request.getParameter("browserTypeId");
String customBrowType = StringHelper.null2String(request.getParameter("customBrowType"));
String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));

int pageNo = NumberHelper.string2Int(request.getParameter("pageno"), 1);
int pageSize = NumberHelper.string2Int(request.getParameter("pageSize"), 10);
String keyword = request.getParameter("keyword");
keyword = java.net.URLDecoder.decode(keyword, "UTF-8");
boolean isDis = "1".equals(StringHelper.null2String(request.getParameter("isDis"))) ? true : false;
if (!isDis) {
	request.getRequestDispatcher("/mobile/plugin/dialog.jsp").forward(request, response);
	return;
}
EweaverClientServiceImpl eweaverClientService = (EweaverClientServiceImpl)BaseContext.getBean("eweaverClientServiceImpl");
ServiceUser user = new ServiceUser();
user.setId(sessionkey);
Page tpage = new Page();
tpage.setPageNo(pageNo);
tpage.setPageSize(pageSize);
tpage = eweaverClientService.listBrowser(user, keyword, null, browserId, tpage);
JSONObject jo = JSONObject.fromObject(tpage);
//jo.put()
response.setContentType("application/json; charset=utf-8");
response.getWriter().print(jo.toString());
response.getWriter().flush();
%>
