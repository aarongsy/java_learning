<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.mobile.plugin.common.Constants"%>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
String module = null;
String scope = null;
String detailid = null;
String pageindex = null;
String pagesize = null;
String keyword = null;
String sessionkey = null;
String setting = null;
String[] conditions = null;
if(ServletFileUpload.isMultipartContent(request)) {
	MultipartRequest multiRequest = new MultipartRequest(request,".","UTF-8");
	 module = StringHelper.null2String(multiRequest.getParameter(Constants.MOBILE_CONFIG_MODULE_PARAM));
	 scope = StringHelper.null2String(multiRequest.getParameter("scope"));
	 detailid = StringHelper.null2String(multiRequest.getParameter("detailid"));
	 pageindex = StringHelper.null2String(multiRequest.getParameter("pageindex"));
	 pagesize = StringHelper.null2String(multiRequest.getParameter("pagesize"));
	 keyword = StringHelper.null2String(multiRequest.getParameter("keyword"));
	 sessionkey = StringHelper.null2String(multiRequest.getParameter("sessionkey"));
	 setting = StringHelper.null2String(multiRequest.getParameter("setting"));
	 conditions = multiRequest.getParameterValues("conditions");
} else {
	 HttpServletRequest multiRequest = request;
	 module = StringHelper.null2String(multiRequest.getParameter(Constants.MOBILE_CONFIG_MODULE_PARAM));
	 scope = StringHelper.null2String(multiRequest.getParameter("scope"));
	 detailid = StringHelper.null2String(multiRequest.getParameter("detailid"));
	 pageindex = StringHelper.null2String(multiRequest.getParameter("pageindex"));
	 pagesize = StringHelper.null2String(multiRequest.getParameter("pagesize"));
	 keyword = StringHelper.null2String(multiRequest.getParameter("keyword"));
	 sessionkey = StringHelper.null2String(multiRequest.getParameter("sessionkey"));
	 setting = StringHelper.null2String(multiRequest.getParameter("setting"));
	 conditions = multiRequest.getParameterValues("conditions");
}

if(!StringHelper.isEmpty(keyword)) {
	keyword = java.net.URLDecoder.decode(keyword,"UTF-8");
}
if(pluginService.verify(sessionkey)) {

	List cs = new ArrayList();
	
	if(conditions!=null) cs = Arrays.asList(conditions);
	
	Map result = new HashMap();
	if(!StringHelper.isEmpty(setting)) {
		setting = setting.replaceAll(",","','");
		setting = "('"+setting+"')";
	}
	
	if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")) {
	
		if(!StringHelper.isEmpty(keyword)) {
			cs.add(" (rb.requestname like '%" + keyword + "%') ");
			//cs.add(keyword);
		}
		
		if(!StringHelper.isEmpty(detailid)) {
			cs.add(" (rb.id = '"+detailid+"') ");
		}
		if(!StringHelper.isEmpty(setting)) {
			cs.add(" and exists( select 'x' from workflowinfo where id= rb.workflowid and moduleid in "+setting+")");
		}
		result = (Map) pluginService.getWorkflowList( NumberHelper.string2Int2(module),  NumberHelper.string2Int2(scope), cs,  NumberHelper.string2Int2(pageindex),  NumberHelper.string2Int2(pagesize), sessionkey);
	}
	
	if(module.equals("2")||module.equals("3")) {
		if(!StringHelper.isEmpty(keyword)) {
			cs.add(" and (subject like '%"+keyword+"%') ");
		}
		
		if(!StringHelper.isEmpty(detailid)) {
			cs.add(" and (id = '"+detailid+"') ");
		}
		if(!StringHelper.isEmpty(setting)) {
			cs.add(" and exists( select 'x' from categorylink where objid = tbalias.id and categoryid in "+setting+")");
		}

		result = pluginService.getDocumentList(NumberHelper.string2Int2(module,2),cs, NumberHelper.string2Int2(pageindex),NumberHelper.string2Int2(pagesize), sessionkey);
	}
	
	if(module.equals("6")) {
		if(!StringHelper.isEmpty(keyword)) {
			cs.add(" (humres.objname like '%"+keyword+"%' or humres.objno like '%"+keyword+"%' )");
		}
		
		if(!StringHelper.isEmpty(detailid)) {
			cs.add(" (humres.id = '"+detailid+"') ");
		}

		result = pluginService.getUserList(cs, NumberHelper.string2Int2(pageindex,1), NumberHelper.string2Int2(pagesize,10), sessionkey);
	}
	
	String key = "list";
	
	if(result!=null&&result.get("list")!=null) {
		
		List<Map<String,Object>> list = (List<Map<String,Object>>) result.get("list");

		if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")) {
			List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> d:list) {
				Map<String,Object> newdata = new HashMap<String,Object>();
				
				String time = StringHelper.null2String((String) d.get("recivetime"),"");
				String image = StringHelper.null2String((String) d.get("creatorpic"),"");
				String id = StringHelper.null2String((String) d.get("wfid"),"");
				String isnew = StringHelper.null2String((String) d.get("isnew"),"");
				String subject = StringHelper.null2String((String) d.get("wftitle"),"");
				String description = "" +
									 "[" + StringHelper.null2String((String) d.get("wftype"),"") + "]" +
									 //"   接收时间 : " + StringHelper.null2String((String) d.get("recivetime"),"") +
									 " 节点 :" + StringHelper.null2String((String) d.get("status"),"") +
									 " 创建人 :" + StringHelper.null2String((String) d.get("creator"),"") +
									 " 创建时间 :" + StringHelper.null2String((String) d.get("createtime"),"");
				if(StringHelper.isEmpty(image)) {
				    image = "/download.do?url=/mobile/images/default.png";
				} else {
				    image = "/download.do?url=" + image;
				}
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", subject);
				newdata.put("description", description);
				newlist.add(newdata);
			}
			result.put(key,newlist);
		} else if(module.equals("2")||module.equals("3")) {
			List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> d:list) {
				Map<String,Object> newdata = new HashMap<String,Object>();
				
				String time = StringHelper.null2String((String) d.get("time"),"");
				String image = StringHelper.null2String((String) d.get("image"),"");
				String id = StringHelper.null2String((String) d.get("id"),"");
				String isnew = StringHelper.null2String((String) d.get("isnew"),"");
				String subject = StringHelper.null2String((String) d.get("subject"),"");
				String description = "" +
									 "   所有者 : " + StringHelper.null2String((String) d.get("creator"),"") +
									 "   创建时间 : " + StringHelper.null2String((String) d.get("createdate"),"") +
									 "   修改时间 : " + StringHelper.null2String((String) d.get("modifydate"),"");
				
				if(StringHelper.isEmpty(image)) {
				    image = "/download.do?url=/mobile/images/default.png";
				} else {
				    image = "/download.do?url=" + image;
				}
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", subject);
				newdata.put("description", description);
				newlist.add(newdata);
			}
			result.put(key,newlist);
		} else if(module.equals("6")) {
			List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> d:list) {
				Map<String,Object> newdata = new HashMap<String,Object>();
				
				String time = "";
				String image = StringHelper.null2String((String) d.get("headerpic"),"");
				String id = StringHelper.null2String((String) d.get("id"),"");
				String isnew = "";
				String subject = StringHelper.null2String((String) d.get("lastname"),"");
				String description = "" +
									 " [" + StringHelper.null2String((String) d.get("jobtitle"),"") + "]" +
									 " " + StringHelper.null2String((String) d.get("dept"),"") + " / " +
									 "" + StringHelper.null2String((String) d.get("subcom"),"");
				if(StringHelper.isEmpty(image)) {
				    image = "/download.do?url=/mobile/images/default.png";
				} else {
				    image = "/download.do?url=" + image;
				}
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", subject);
				newdata.put("description", description);
				newlist.add(newdata);
			}
			result.put(key,newlist);
		}		
	}	
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>