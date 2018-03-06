<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="org.light.portal.core.PortalUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	JSONArray gaugeDatas = (JSONArray)request.getAttribute("gaugeDatas");
%>
<table>
    <tr>
        <td align='center'>
            <% for(int i = 0; i < gaugeDatas.size(); i++){
				 JSONObject gaugeData = (JSONObject)gaugeDatas.get(i);
				 int height = NumberHelper.getIntegerValue(gaugeData.get("height"), 160);
				 //根据高度去动态计算宽度，因为该仪表盘插件大小其实主要是以高度为主，并且宽度和高度的设置有一个最小比例,越是偏离这个比例显示就越不正常。
				 BigDecimal heightDecimal = new BigDecimal(height);
				 BigDecimal divisor = new BigDecimal(0.8);
				 int width = heightDecimal.divide(divisor, RoundingMode.UP).intValue();
			%>
				<div class="gaugeChart" id="gaugediv_<%=request.getAttribute("responseId")%>_<%=i%>" style="width:<%=width%>px; height:<%=height%>px;"></div>	
			<% } %>
        </td>
    </tr>
</table>
<script>
	setTimeout(function(){
		<% for(int i = 0; i < gaugeDatas.size(); i++){ 
			JSONObject gaugeData = (JSONObject)gaugeDatas.get(i);
			String label = StringHelper.null2String(StringHelper.trimToNull(gaugeData.get("label")), "MPH");
			int minval = NumberHelper.getIntegerValue(gaugeData.get("minval"), 0);
			int maxval = NumberHelper.getIntegerValue(gaugeData.get("maxval"), 160);
			String levelColor = StringHelper.null2String(StringHelper.trimToNull(gaugeData.get("levelColor")), "#A9D70B");
			String daoname = (String) gaugeData.get("dao");
			if(StringHelper.isEmpty(daoname)){
				daoname="baseJdbcDao";
			}
			BaseJdbcDao basejdbc = (BaseJdbcDao) PortalUtil.getBean(daoname);
			String sql = StringHelper.null2String(gaugeData.get("sql"));
			String reportid = StringHelper.null2String(gaugeData.get("reportid"));
			String count ="0";
			if(!StringHelper.isEmpty(sql)){
				List data = basejdbc.executeSqlForList(sql);
				if(data.size()>0){
                   count= StringHelper.null2String(((Map)data.get(0)).values().toArray()[0]);
				}
			}else if(!StringHelper.isEmpty(reportid)){
            	 ReportdefService reportdefService = (ReportdefService) PortalUtil.getBean("reportdefService");
            	 count =""+ reportdefService.getReportDataCountId(reportid);
			}
			int val = NumberHelper.getIntegerValue(count, 0);
			//如果进行了区间颜色设置，解析
			int beginIndex = levelColor.indexOf("{");
			if(beginIndex != -1){
				String currColor = levelColor.substring(0, beginIndex);
				int endIndex = levelColor.indexOf("}", beginIndex);
				if(endIndex != -1){
					String intervalsStr = levelColor.substring(beginIndex + 1, endIndex);
					intervalsStr = StringHelper.trim(intervalsStr);
					String[] intervals = intervalsStr.split(",");
					for(int j = 0; j < intervals.length; j++){
						String interval = StringHelper.trim(intervals[j]);
						String[] intervalArr = interval.split(":");
						if(intervalArr.length == 2){
							String intervalMinMax = StringHelper.trim(intervalArr[0]);
							String intervalColor = StringHelper.trim(intervalArr[1]);
							if(intervalMinMax.split("-").length == 2 && !StringHelper.isEmpty(intervalColor)){
								String intervalMinStr = StringHelper.trim(intervalMinMax.split("-")[0]);
								String intervalMaxStr = StringHelper.trim(intervalMinMax.split("-")[1]);
								int intervalMin = NumberHelper.getIntegerValue(intervalMinStr, 0);
								int intervalMax = NumberHelper.getIntegerValue(intervalMaxStr, 0);
								if(intervalMin <= val && val <= intervalMax){
									currColor = intervalColor;
									break;
								}
							}
						}
					}
				}
				levelColor = StringHelper.null2String(StringHelper.trimToNull(currColor), "#A9D70B");
			}
		%>
			new JustGage({
				id: "gaugediv_<%=request.getAttribute("responseId")%>_<%=i%>", 
				value: <%=val%>, 
				min: <%=minval%>,
				max: <%=maxval%>,
				title: "<%=label%>",
				levelColors: ["<%=levelColor%>"],
				label: "",
				startAnimationTime: 1000,
				startAnimationType: ">",
				refreshAnimationTime: 1000,
				refreshAnimationType: "bounce"
			});
		<% } %>
	},100);
</script>

