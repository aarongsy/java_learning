<%@ page language="java" contentType="application/xml" pageEncoding="GBK"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String nodeid = StringHelper.null2String(request.getParameter("nodeid"));
	String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));
	ServiceUser serviceUser = new ServiceUser();
	serviceUser.setId(sessionkey);
	WebServiceData operatorData = pluginService.getWorkflowNodeOperater(serviceUser,requestid,nodeid);
	List<TableData> dataList = operatorData.getRowList();
		JSONObject dataObject = new JSONObject();
		JSONArray jarray = new JSONArray();
		if(!dataList.isEmpty()) {
			TableData tdata = dataList.get(0);
			List<RowData> rowList = tdata.getRowList();
			for(RowData rdata : rowList) {
				JSONObject jObject = new JSONObject();
				for(ItemData itemData : rdata.getRowMap().values()) {
					jObject.put(itemData.getItemName(), itemData.getItemValue());
				}
				jarray.add(jObject);
			}
		}
		dataObject.put("datas", jarray);
		if(jarray.isEmpty()) {
			dataObject.put("error", "无法获取数据");
		}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(dataObject.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>