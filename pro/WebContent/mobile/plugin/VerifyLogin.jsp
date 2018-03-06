<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%
    if(StringHelper.isEmpty(BaseContext.getHttpbasepath())) {
    	String basePath2 = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
		BaseContext.setHttpbasepath(basePath2);
    }    
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
    HumresService humresService = (HumresService)BaseContext.getBean("humresService");
    MultipartRequest multiRequest = new MultipartRequest(request,".","UTF-8"); 
    String id = StringHelper.null2String(request.getParameter("id"));
	String loginId = StringHelper.null2String(multiRequest.getParameter("loginid"));
	String password = StringHelper.null2String(multiRequest.getParameter("password"));
	String dynapass = StringHelper.null2String(multiRequest.getParameter("dynapass"));
	String tokenpass = StringHelper.null2String(multiRequest.getParameter("tokenpass"));
	String language = StringHelper.null2String(multiRequest.getParameter("language"));
	String ipaddress = StringHelper.null2String(multiRequest.getParameter("ipaddress"));
	String ischeckuser = StringHelper.null2String(multiRequest.getParameter("ischeckuser"));
	String auth = StringHelper.null2String(multiRequest.getParameter("auth"));
	List auths = new ArrayList();
	
	JSONObject jjo = JSONObject.fromObject(auth);
	if(jjo.containsKey("auths")) {		
		JSONArray ja = jjo.getJSONArray("auths");
		for(int i=0;ja!=null&&i<ja.size();i++) {			
			JSONObject jao = ja.getJSONObject(i);
			Map map = new HashMap();
			
			String gid="";
			if(jao.containsKey("id"))
				gid = jao.getString("id");
			
			String type="";
			if(jao.containsKey("type"))
				type = jao.getString("type");
			
			String typename="";
			if(jao.containsKey("typename"))
				typename = jao.getString("typename");
			
			String seclevel="";
			if(jao.containsKey("seclevel"))
				seclevel = jao.getString("seclevel");
	
			String value="";
			if(jao.containsKey("value"))
				value = jao.getString("value");
	
			String valuename="";
			if(jao.containsKey("valuename"))
				valuename = jao.getString("valuename");
	
			String groupid="";
			if(jao.containsKey("groupid"))
				groupid = jao.getString("groupid");
	
			map.put("id", gid);
			map.put("type", type);
			map.put("typename", typename);
			map.put("seclevel", seclevel);
			map.put("value", value);
			map.put("valuename", valuename);
			map.put("groupid", groupid);			
			auths.add(map);
		}
	}
		
	WebServiceData webData = pluginService.checkLoginUser(loginId,password);
	Map result = webData.getMainData();
	JSONObject jo = null;
	if(result!=null) {
	    ServiceStatus serviceStatus = webData.getStatus();
	    if(serviceStatus == ServiceStatus.LICENSE_IS_OK) {
	    	jo = JSONObject.fromObject(result);
	    	String userid = (String)jo.get("ID");	    	
	        JSONArray ja = new JSONArray();
	        Humres humres = humresService.getHumresById(userid);
			for(int i = 0 ; i < auths.size(); i ++) {
				Map map=(Map)auths.get(i);
				int sharetype = NumberHelper.string2Int((String)map.get("type"),0);
				int seclevel = NumberHelper.string2Int((String)map.get("seclevel"),0);
				String sharevalue = StringHelper.null2String((String)map.get("value"));
				String groupid=StringHelper.null2String((String)map.get("groupid"));
				if(ja.indexOf(groupid) > -1) {
				    continue;
				}
				if(sharetype == 2 && sharevalue.equalsIgnoreCase(userid)) {
					ja.add(groupid);
				} else if(sharetype == 1) {
					String orgid = humres.getOrgid();
					String orgids = humres.getOrgids();
					if(orgid != null && orgid.equalsIgnoreCase(sharevalue)) {
					    ja.add(groupid);
					} else if(orgids != null && orgids.indexOf(sharevalue) > -1) {
					    ja.add(groupid);
					}
				} else if(sharetype == 3) {
					ja.add(groupid);
				}
			}
			if(ja.isEmpty()) {
				jo.clear();
				jo.put("message","10");
			} else {
				jo.put("groups",ja);
				jo.put("message","1");
	    		jo.put("sessionkey",userid);
	    		MuserSessions.putSessionId((String)jo.get("ID"), jo.get("ID"));
			}	        						
	    } else {
	        String message = "";
	        if(serviceStatus == ServiceStatus.USER_PASSWORD_ERROR) {
	        	message ="102";
	        } else if(serviceStatus == ServiceStatus.USER_NOT_EXIST) {
	            message = "104";
	        } else if(serviceStatus == ServiceStatus.LICENSE_IS_MORE_MAX_NUM_OF_USERS) {
	            message = "003";
	        } else if(serviceStatus == ServiceStatus.LICENSE_IS_INVALID) {
	            message = "004";
	        } else {
	            message = "110";
	        }
	        jo = new JSONObject();
	        jo.put("message",message);
	    }		
	} else {
		jo = new JSONObject();
	    jo.put("message","105");
	}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
