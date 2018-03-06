<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="org.light.portal.core.PortalUtil" %>
<%@ page import="com.eweaver.chart.servlet.ChartAction" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
    String title = (String) request.getAttribute("title");
    if (StringHelper.isEmpty(title))
        title = "图表";
    String label = (String) request.getAttribute("label");
    if (StringHelper.isEmpty(label))
        label = "";
    String reportid = (String) request.getAttribute("reportid");
    String dao = (String) request.getAttribute("dao");
    ReportdefService reportdefService=(ReportdefService) PortalUtil.getBean("reportdefService");

    String reportname="";
    try {
        if (!StringHelper.isEmpty(reportid)&&reportdefService.getReportdef(reportid)!=null)
            reportname=reportdefService.getReportdef(reportid).getObjname();
    } catch (Exception e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }
    String[] daos=BaseContext.getBeanNames(BaseJdbcDao.class);
    if (StringHelper.isEmpty(dao))
    dao = "baseJdbcDao";
    String xaxis = (String) request.getAttribute("xaxis");
    if (StringHelper.isEmpty(xaxis))
    xaxis = "";
    String yaxis = (String) request.getAttribute("yaxis");
    if (StringHelper.isEmpty(yaxis))
    yaxis = "";
    String sql = (String) request.getAttribute("sql");
    if (StringHelper.isEmpty(sql))
    sql = "";
    String chartw = (String) request.getAttribute("chartw");
    if (StringHelper.isEmpty(chartw))
    chartw = "650";
    String charth = (String) request.getAttribute("charth");
    if (StringHelper.isEmpty(charth))
    charth = "350";
    String charttype = (String) request.getAttribute("charttype");
    if (StringHelper.isEmpty(charttype))
    charttype = "";
    
    String col1 = StringHelper.null2String(request.getAttribute("col1"));
%>
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<%=col1 %>"/>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
<tr><td class="FieldName">Id:</td><td class="FieldName">chart_<%=request.getAttribute("portletId")%></td></tr>    
<tr><td class="FieldName">标题:</td><td class="FieldName"><input name="title" id="title" maxlength="100" value="<%=StringHelper.StringReplace(title,"\"","&quot;")%>" />
<% if(!StringHelper.isEmpty(col1)){ %>
	<%=labelCustomService.getLabelPicHtml(col1, LabelType.PortletObject) %>
<% } %>
</td></tr>
<tr><td class="FieldName">标签:</td><td class="FieldName"><input name="label" id="label" value='<%=label%>' /></td></tr>
<tr><td class="FieldName">数据源:</td><td  class="FieldName">
<select  name="dao"  id="dao">
<%for(String d:daos){%>
    <option value='<%=d%>' <%if(dao.equals(d)){%>selected<%}%>><%= d.equals("baseJdbcDao")?"local":d%></option>
<%}%>
</select>
</td></tr>
<tr><td class="FieldName">SQL:</td><td class="FieldName"><textarea class="inputstyle2" rows="5" cols="50" name="sql" id="sql" ><%=sql%></textarea></td></tr>
<tr><td class="FieldName">报表:</td><td class="FieldName"><button type="button" class="Browser" onclick="Portlet.getBrowser('<%=request.getContextPath()%>/workflow/report/reportbrowser.jsp','reportid','reportidspan','0');"></button>
<input type="hidden" name="reportid" id="reportid" value='<%=reportid%>'/><span id="reportidspan"><%=reportname%></span></td></tr>
<tr><td class="FieldName">X轴标签:</td><td class="FieldName"><input class="inputstyle2"  name="xaxis" id="xaxis" length="2" size="5" value="<%=xaxis%>"/></td></tr>
<tr><td class="FieldName">Y轴标签:</td><td class="FieldName"><input class="inputstyle2"  name="yaxis" id="yaxis" length="5" size="5" value="<%=yaxis%>"/></td></tr>
<tr><td class="FieldName">图表宽度:</td><td class="FieldName"><input class="inputstyle2"  name="chartw" id="chartw" onkeypress="checkInt_KeyPress()" length="3" size="5" value="<%=chartw%>"/></td></tr>
<tr><td class="FieldName">图表高度:</td><td class="FieldName"><input class="inputstyle2"  name="charth" id="charth" onkeypress="checkInt_KeyPress()" length="3" size="5" value="<%=charth%>"/></td></tr>
<tr><td class="FieldName">类型:</td><td  class="FieldName">
<select  name="charttype"  id="charttype">
<option value='<%=ChartAction.CHARTTYPE_Column3D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Column3D)){%>selected<%}%>>3D柱状图</option>
<option value='<%=ChartAction.CHARTTYPE_Column2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Column2D)){%>selected<%}%>>柱状图</option>
<option value='<%=ChartAction.CHARTTYPE_Bar2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Bar2D)){%>selected<%}%>>横向柱状图</option>
<option value='<%=ChartAction.CHARTTYPE_Pie3D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Pie3D)){%>selected<%}%>>3D饼图</option>
<option value='<%=ChartAction.CHARTTYPE_Pie2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Pie2D)){%>selected<%}%>>饼图</option>
<option value='<%=ChartAction.CHARTTYPE_Doughnut2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Doughnut2D)){%>selected<%}%>>环图</option>
<option value='<%=ChartAction.CHARTTYPE_Line%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Line)){%>selected<%}%>>曲线图</option>
<option value='<%=ChartAction.CHARTTYPE_Area2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_Area2D)){%>selected<%}%>>填充曲线图</option>

<option value='<%=ChartAction.CHARTTYPE_MS_Column3D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Column3D)){%>selected<%}%>>多组3D柱状图</option>
<option value='<%=ChartAction.CHARTTYPE_MS_Column2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Column2D)){%>selected<%}%>>多组2D柱状图</option>
<option value='<%=ChartAction.CHARTTYPE_MS_Bar2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Bar2D)){%>selected<%}%>>多组横向柱状图</option>
<option value='<%=ChartAction.CHARTTYPE_MS_Line%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Line)){%>selected<%}%>>多组曲线图</option>
<option value='<%=ChartAction.CHARTTYPE_MS_Area2D%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Area2D)){%>selected<%}%>>多组填充曲线图</option>

<option value='<%=ChartAction.CHARTTYPE_MS_Column3DLine%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Column3DLine)){%>selected<%}%>>多组3D柱状曲线图</option>
<option value='<%=ChartAction.CHARTTYPE_MS_Column2DLine%>' <%if(charttype.equals(ChartAction.CHARTTYPE_MS_Column2DLine)){%>selected<%}%>>多组2D柱状曲线图</option>
</select>
</td></tr>
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="ChartPortlet.doSubmit(this,'<%=request.getAttribute("responseId")%>')"/>&nbsp;&nbsp;&nbsp;
<input type="submit" value="取消" onclick="document.mode='view';document.pressed='view'"/></td></tr>
</table>
</form>


