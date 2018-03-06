<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.eweaver.sysinterface.util.ServletUtils" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.mobile.plugin.mode.ClientType" %>
<%@ page import="com.eweaver.mobile.plugin.mode.PluginClientData"%>
<%@ page import="com.eweaver.mobile.plugin.service.EweaverClientServiceImpl" %>
 <%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
	EweaverClientServiceImpl pluginService = (EweaverClientServiceImpl)BaseContext.getBean("eweaverClientServiceImpl");
	MpluginServiceImpl mpluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	MultipartRequest multiRequest = new MultipartRequest(request,".","UTF-8");
	String requestid = StringHelper.null2String((String)multiRequest.getParameter("requestid"));
	String from = StringHelper.null2String((String)multiRequest.getParameter("from"));
	String module = StringHelper.null2String((String)multiRequest.getParameter("module"));
	String scope = StringHelper.null2String((String)request.getParameter("scope"));
	String mobileSession = StringHelper.null2String((String)multiRequest.getParameter("mobileSession"));
	String client = StringHelper.null2String((String)multiRequest.getParameter("client"));
	String type = StringHelper.null2String((String)multiRequest.getParameter("type"));
	String workflowid = StringHelper.null2String((String)multiRequest.getParameter("workflowid"));
	String src = StringHelper.null2String((String)multiRequest.getParameter("src"));
	String clientip = StringHelper.null2String((String)multiRequest.getParameter("clientip"));
	String forwardresourceids = StringHelper.null2String((String)multiRequest.getParameter("forwardresourceids"));
	String remark = StringHelper.null2String((String)multiRequest.getParameter("userSignRemark"));
	String sessionkey = StringHelper.null2String(multiRequest.getParameter("sessionkey"));
	String clienttype = StringHelper.null2String(request.getParameter("clienttype"));
	if(!ClientType.WEB.toString().equalsIgnoreCase(clienttype)){
		if(!StringHelper.isEmpty(clienttype)) {
		    remark = remark + "(来自"+clienttype+"客户端)";
		}
	}
	String nodeid = null;
	String result = "success";
	ServiceUser serviceUser = new ServiceUser();
	serviceUser.setId(sessionkey);
	String nodeids[] = ServletUtils.getParametersStartingWith(multiRequest, "EW_","__nodeid");
	if(nodeids != null) { 
	    nodeid = nodeids[0];
	}
    String rs = "保存成功";
    String code = "1";
    
    JSONObject dataObject = new JSONObject();
	if("submit".equals(src) || "save".equals(src)) {
 		Map <String,Object> params = ServletUtils.getParametersStartingWith(multiRequest, "EW_");  
        if(!params.isEmpty()) {
        	AttachHelper.saveAttachItems(params);
        	JSONObject mainJson = (JSONObject)JSONObject.toJSON(params);
            Map <String,Object> subParams = ServletUtils.getParametersStartingWith(multiRequest, "SUBEW_");
            JSONObject subJson = (JSONObject)JSONObject.toJSON(subParams);
            JSONObject totalJson = new JSONObject();
            totalJson.put("maintable", mainJson);
            totalJson.put("subtable", subJson);
            String jsonData = totalJson.toJSONString();
            WebServiceData webServiceData = null;
            try{
            	
            	webServiceData = pluginService.saveWorkflowData(serviceUser, requestid, workflowid, jsonData);
            	PluginClientData plugClientData = new PluginClientData(webServiceData);
	            if(webServiceData.getStatus() != ServiceStatus.REQUEST_SAVE_IS_SUCCESSFUL) {
	            	rs = webServiceData.getStatusMsg();
	            	if(rs == null || rs.length() == 0) {
	            		rs = "保存失败";
	            		result = "fail"; 
	            		code = "0";
	            	} else {
	            	    rs = "流程处理成功";
	            	    code = "0";
	            	}
	            	
	            } else {
	                if(StringHelper.isEmpty(requestid)) {
	                    requestid = plugClientData.getParamValue("requestid");
	                }
	            	dataObject.put("id", plugClientData.getParamValue("id"));
	            	dataObject.put("requestid", requestid);
	            	rs = "流程处理成功";
	            }      
	        }catch(Exception e){
	            e.printStackTrace();
	        	rs = "保存数据异常:"+e.getMessage();
	        	code = "0";
        		result = "fail";
	        }
                  
        } else {
        	rs = "需要保存的内容为空,无法保存!";
        	code = "0";
        	result = "fail";
        }
	}
       

		String submittype = "submit";
		WebServiceData submitdata = null;
		if("submit".equals(src) && "1".equals(code)){
			try{
				result = pluginService.submitWorkflowRequest(null, requestid, serviceUser, submittype, remark);
				if("success".equalsIgnoreCase(result)){
		        	rs = "流程提交成功";
				} else {
				    rs = result;
				    code = "0";
				}
			} catch(Exception e){
				e.printStackTrace();
				rs = "流程提交异常:"+e.getMessage();
				code = "0";
			}
			
		} else if("reject".equals(src)){
			try{
				result = mpluginService.operateWorkflow(0,nodeid,requestid,remark,sessionkey);
				if("success".equalsIgnoreCase(result)){
		        	rs = "流程退回成功";
				} else {
				    rs = result;
				    code = "0";
				}
			}catch(Exception e) {
				e.printStackTrace();
				rs = "流程退回异常:"+e.getMessage();
				code = "0";
			}
			
		} else if("forward".equals(src)){
			String[] forwardids = StringHelper.null2String(forwardresourceids).split(","); 
			String forwardidvalue = "";
			for(int p=0;forwardids!=null&&forwardids.length>0&&p<forwardids.length;p++){
				String value = forwardids[p];
				if(!StringHelper.isEmpty(value)){
					forwardidvalue+=","+value;
				}
			}
			forwardidvalue = forwardidvalue.startsWith(",")?forwardidvalue.substring(1):forwardidvalue;
			if(clientip==null||"".equals(clientip)){
				String regex = "(((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))";
	            Pattern p = Pattern.compile(regex);
				clientip = StringHelper.null2String(request.getHeader("X-Forwarded-For"),"");
	            Matcher m = p.matcher(clientip);
	            if (clientip == null || "".equals(clientip) || !m.matches()) {
	            	clientip = request.getRemoteAddr();
	            }
			}
			try{
				result = pluginService.forwardWorkflowRequest(requestid,forwardidvalue,remark,serviceUser,clientip);
				if("success".equalsIgnoreCase(result)){
		        	rs = "流程转发成功";
				} else {
				    rs = result;
				    code = "0";
				}
			}catch(Exception e) {
				e.printStackTrace();
				rs = "流程转发异常:"+e.getMessage();
				code = "0";
			}
			
		}
		
		dataObject.put("code", code);
        dataObject.put("message", rs);
        response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(dataObject.toJSONString());
		response.getWriter().flush();
		response.getWriter().close();
%>