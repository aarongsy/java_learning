<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.mobile.plugin.mode.*"%>
<%@ page import="com.eweaver.mobile.plugin.service.*"%>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%
		EweaverClientServiceImpl clientService = (EweaverClientServiceImpl)BaseContext.getBean("eweaverClientServiceImpl");
        int module = 12;//NumberHelper.string2Int(request.getParameter("module"),1);
        int scope = NumberHelper.string2Int(request.getParameter("scope"),1);
        int pageindex = NumberHelper.string2Int(request.getParameter("pageindex"),0);
        int pagesize = NumberHelper.string2Int(request.getParameter("pagesize"),10);
        String keyword = request.getParameter("keyword");   
        String sessionkey = request.getParameter("sessionkey");
        ServiceUser user = new ServiceUser();
        user.setId(sessionkey);     
        Map<String,Object> result = clientService.getWorkflowInfoList(user, module, scope, pageindex, pagesize, keyword);
        if (result != null && !result.isEmpty()) {
				String error = (String)result.get("error");
				if(error != null && !"".equals(error)) {
					result.put("error", error);
				} else {
				   if(result!=null&&result.get("wfs")!=null) {
				       List<Map<String,String>> list = (List<Map<String,String>>) result.get("wfs");
				       List<Map<String,String>> wflist = new ArrayList<Map<String,String>>();
				       for(Map<String,String> d:list) {
							Map<String,String> wfdata = new HashMap<String,String>();
							String id = StringHelper.null2String((String) d.get("wfid"),"");
							String subject = StringHelper.null2String((String) d.get("wftitle"),"");
							String modulename = StringHelper.null2String((String) d.get("wftype"),"");
							String description = "[所属模块:"+modulename+"]";
							
							wfdata.put("time", "");
							wfdata.put("image", "/download.do?url=/mobile/images/default.png");
							wfdata.put("id", id);
							wfdata.put("isnew", "0");
							wfdata.put("subject", subject);
							wfdata.put("description", description);
							wflist.add(wfdata);
						}
						result.remove("wfs");
						result.put("list",wflist);
						
				   }
				}
				//JSONObject jo = JSONObject.fromObject(result);
				//out.println(jo);
					
				String jsonStr = JSONObject.fromObject(result).toString();
				if (jsonStr != null && !"".equals(jsonStr)) {
					response.setContentType("application/json; charset=utf-8");
					response.getWriter().write(jsonStr);
					response.getWriter().flush();
					response.getWriter().close();
				}
				
		}

 %>
