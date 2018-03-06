<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="org.light.portal.core.PortalUtil" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
    String title = (String) request.getAttribute("title");
    if (StringHelper.isEmpty(title))
        title = "仪表盘";
     
    String[] daos= BaseContext.getBeanNames(BaseJdbcDao.class);
    ReportdefService reportdefService=(ReportdefService) PortalUtil.getBean("reportdefService");

    String col1 = StringHelper.null2String(request.getAttribute("col1"));
    
    JSONArray gaugeDatas = (JSONArray)request.getAttribute("gaugeDatas");
%>
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<%=col1 %>"/>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
<tr><td class="FieldName">Id:</td><td class="FieldName">gauge_<%=request.getAttribute("portletId")%></td></tr>
<tr><td class="FieldName">标题:</td><td class="FieldName"><input name="title" id="title" value="<%=StringHelper.StringReplace(title,"\"","&quot;")%>" />
<% if(!StringHelper.isEmpty(col1)){ %>
	<%=labelCustomService.getLabelPicHtml(col1, LabelType.PortletObject) %>
<% } %>
</td></tr>
<tr>
<td class="FieldName" colspan="2">
	<div style="padding:2px 0px;">
		<a id="addGaugeTab_<%=request.getAttribute("portletId")%>" href="javascript:void(0);" style="background:url('/images/silk/add.gif') no-repeat; padding-left:18px;">添加仪表盘</a>
	</div>
	<div id="gaugeTabs_<%=request.getAttribute("portletId")%>">
		<ul>
			<% for(int i = 0; i < gaugeDatas.size(); i++){
				 JSONObject gaugeData = (JSONObject)gaugeDatas.get(i);
			%>
				 <li><a href="#gaugeTab_<%=request.getAttribute("portletId")%>_<%=i%>"><%=StringHelper.null2String(gaugeData.get("label"), "MPH")%></a> <span class="ui-icon ui-icon-close">删除</span></li>	
			<% }%>
		</ul>
		<% for(int i = 0; i < gaugeDatas.size(); i++){ 
			JSONObject gaugeData = (JSONObject)gaugeDatas.get(i);
			String label = StringHelper.null2String(gaugeData.get("label"), "MPH");
			String dao = StringHelper.null2String(gaugeData.get("dao"), "baseJdbcDao");
			String sql = StringHelper.null2String(gaugeData.get("sql"));
			String reportid = StringHelper.null2String(gaugeData.get("reportid"));
			String reportname="";
			try {
				if (!StringHelper.isEmpty(reportid)&&reportdefService.getReportdef(reportid)!=null)
					reportname=reportdefService.getReportdef(reportid).getObjname();
			} catch (Exception e) {
				e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
			}
			String minval = StringHelper.null2String(gaugeData.get("minval"), "0");
			String maxval = StringHelper.null2String(gaugeData.get("maxval"), "160");
			String height = StringHelper.null2String(gaugeData.get("height"), "160");
			String levelColor = StringHelper.null2String(gaugeData.get("levelColor"));
			int order = NumberHelper.getIntegerValue(gaugeData.get("order"), 0);
		%>
		<div id="gaugeTab_<%=request.getAttribute("portletId")%>_<%=i%>">
			<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
				<tr><td class="FieldName">标签:</td><td class="FieldName"><input name="label" value='<%=label%>' /></td></tr>
				<tr><td class="FieldName">数据源:</td><td  class="FieldName">
					<select name="dao">
					<%for(String d:daos){%>
					    <option value='<%=d%>' <%if(dao.equals(d)){%>selected<%}%>><%= d.equals("baseJdbcDao")?"local":d%></option>
					<%}%>
					</select>
				</td></tr>
				<tr><td class="FieldName">sql:</td><td class="FieldName"><textarea style="width:80%;height:100px;" class="inputstyle2"  name="sql"><%=sql%></textarea></td></tr>
				<tr>
					<td class="FieldName">报表:</td>
					<td class="FieldName">
						<button class="Browser" type="button" onclick="Portlet.getBrowser('<%=request.getContextPath()%>/workflow/report/reportbrowser.jsp','reportid<%=i%>','reportidspan<%=i%>','0');"></button>
						<input type="hidden" name="reportid" id="reportid<%=i%>" value='<%=reportid%>'/><span id="reportidspan<%=i%>"><%=reportname%></span>
					</td>
				</tr>
				<tr><td class="FieldName">最小值:</td><td class="FieldName"><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="minval" length="7" size="7" value="<%=minval%>"/></td></tr>
				<tr><td class="FieldName">最大值:</td><td class="FieldName"><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="maxval" length="7" size="7" value="<%=maxval%>"/></td></tr>
				<tr><td class="FieldName">仪表盘高度:</td><td class="FieldName"><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="height" length="7" size="7" value="<%=height%>"/></td></tr>
				<tr>
					<td class="FieldName">颜色:</td>
					<td class="FieldName">
						<textarea style="width:80%;height:40px;" class="inputstyle2" name="levelColor"><%=levelColor%></textarea>
						<img class="imgLevelColor" src="/images/lightbulb.png"/>
					</td>
				</tr>
				<tr><td class="FieldName">显示顺序:</td><td class="FieldName"><input class="inputstyle2" onkeypress="checkInt_KeyPress()" name="order" length="7" size="7" value="<%=order%>"/></td></tr>
			</table>
		</div>
		<%}%>
	</div>
</td>
</tr>
<tr><td colspan="2" align="center"><input type="button" name="btnOk" value="确定" onclick="GaugePortlet.doSubmit(this,'<%=request.getAttribute("responseId")%>')"/>&nbsp;&nbsp;&nbsp;
<input type="submit" value="取消" onclick="document.mode='view';document.pressed='view'"/></td></tr>
</table>
</form>
<script type="text/javascript">

$(document).ready(function(){
	function addLevelColorTipMsg(){
		var tipMsg = "<div style='line-height:20px;'>此处的颜色可以是以下两种格式：<br/> 1.单一颜色值，如#A9D70B或red <br/> 2.根据值区间去设置相应的颜色,假设需要当值在1-100时显示红色，101-200时显示黄色,200以上显示蓝色,则写法为:<br/>blue{1-100:red,101-200:yellow}<br/>{}包裹的部分为区间信息,每个区间信息包含区间范围和其相应的颜色,两者之前用冒号分隔,如1-100:red 如需设置多个区间信息,则多个区间信息之间使用逗号进行分隔<br/>{}前的颜色值blue表示当当前值不在区间设置中时使用blue进行替代</div>";
		$(".imgLevelColor").qtip({content: tipMsg});
	}
	addLevelColorTipMsg();
	var gaugeTabsCount = <%=gaugeDatas.size()%>;
	var $gaugeTabsObj = $("#gaugeTabs_<%=request.getAttribute("portletId")%>").tabs({
		tabTemplate: "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>删除</span></li>",
		add: function( event, ui ) {
			var html = "<table class='viewform' border='0' align='center' style='width:98%' cellspacing='1'>";
			html += "<tr><td class='FieldName'>标签:</td><td class='FieldName'><input name='label' value='MPH'/></td></tr>";
			html += "<tr><td class='FieldName'>数据源:</td><td class='FieldName'>";
			html += "<select  name='dao'>";
			<%for(String d:daos){%>
    			html += "<option value='<%=d%>'><%= d.equals("baseJdbcDao")?"local":d%></option>";
			<%}%>
			html += "</select></td></tr>";
			html += "<tr><td class='FieldName'>sql:</td><td class='FieldName'><textarea style='width:80%;height:100px;' class='inputstyle2'  name='sql'></textarea></td></tr>";
			html += "<tr><td class='FieldName'>报表:</td><td class='FieldName'><button class='Browser' type='button' onclick=Portlet.getBrowser('<%=request.getContextPath()%>/workflow/report/reportbrowser.jsp','reportid"+gaugeTabsCount+"','reportidspan"+gaugeTabsCount+"','0');></button>";
			html += "<input type='hidden' name='reportid' id='reportid"+gaugeTabsCount+"'/><span id='reportidspan"+gaugeTabsCount+"'></span></td></tr>";
			html += "<tr><td class='FieldName'>最小值:</td><td class='FieldName'><input class='inputstyle2' onkeypress='checkInt_KeyPress()' name='minval' length='7' size='7' value='0'/></td></tr>";
			html += "<tr><td class='FieldName'>最大值:</td><td class='FieldName'><input class='inputstyle2' onkeypress='checkInt_KeyPress()' name='maxval' length='7' size='7' value='160'/></td></tr>";
			html += "<tr><td class='FieldName'>仪表盘高度:</td><td class='FieldName'><input class='inputstyle2' onkeypress='checkInt_KeyPress()' name='height' length='7' size='7' value='160'/></td></tr>";
			html += "<tr><td class='FieldName'>颜色:</td><td class='FieldName'><textarea style='width:80%;height:40px;' class='inputstyle2' name='levelColor'></textarea><img class='imgLevelColor' src='/images/lightbulb.png'/></td></tr>";
			html += "<tr><td class='FieldName'>显示顺序:</td><td class='FieldName'><input class='inputstyle2' onkeypress='checkInt_KeyPress()' name='order' length='7' size='7' value='0'/></td></tr>";
			html += "</table>";
			$(ui.panel).append(html);
			$(ui.tab).click();	//选择新建的tab
			addLevelColorTipMsg();
		}
	});
	$("#addGaugeTab_<%=request.getAttribute("portletId")%>").click(function(){
		$gaugeTabsObj.tabs( "add", "#gaugeTab_<%=request.getAttribute("portletId")%>_" + gaugeTabsCount, "MPH");
		gaugeTabsCount++;
	});
	
	$("span.ui-icon-close", $gaugeTabsObj).die("click");

	$("span.ui-icon-close", $gaugeTabsObj).live( "click", function() {
		if($("li", $gaugeTabsObj).length > 1){
			var index = $("li", $gaugeTabsObj).index($( this ).parent());
			$gaugeTabsObj.tabs( "remove", index);
		}else{
			alert("该仪表盘不能删除,请至少保留一个仪表盘");
		}
	});
});
</script>

