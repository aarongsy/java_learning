<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ include file="/common/taglibs.jsp" %>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
%>
<script>
/*jquery ui
$(function(){
	$('.workflowtabs').tabs({
		//event: 'mouseover',
		ajaxOptions: {
			cache: false,
			error: function( xhr, status, index, anchor ) {
				$( anchor.hash ).html("Couldn't load this tab." );
			}
		},
		load: function(event, ui) {
			rePositionCurrentPortalTab();
    	}
	});
});
*/

function rePositionCurrentPortalTab(){
	var currentTabId = Light.portal.GetFocusedTabId();//tab_page3
    var index = currentTabId.substring(8, currentTabId.length);
	Light.portal.tabs[index].rePositionAll();
	resizeMainPageBodyHeight();
}
</script>
<c:choose>
<c:when test="${mode=='edit'}">
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<table class="viewform" border="0" align="center" style="width:100%" cellspacing="1">
<colgroup>
	<col width="60px"></col>
	<col width="*"></col>
</colgroup>
<tr>
	<td class="FieldName">Id:</td>
	<td class="FieldName">tabs_<%=request.getAttribute("portletId")%></td>
</tr>
<tr>
	<td class="FieldName">Title:</td>
	<td class="FieldName"><input id="title" name="title" maxlength="100" value='<c:out value="${title}"/>'/>
	<c:if test="${not empty col1}">
		<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
	</c:if>
	</td>
</tr>
<tr>
	<td class="FieldName">Params:</td>
	<td class="FieldName">
		<textarea name="params" id="params" style="width:100%;height:100px;word-wrap:break-word;word-break:break-all;overflow:auto;"><c:out value="${params}"/></textarea>
	</td>
</tr>
<tr>
	<td class="FieldName">刷新间隔:</td>
	<td class="FieldName">
		<input class="inputstyle2" onblur="this.value=(parseInt(this.value)>0 && parseInt(this.value)<=5?5:this.value);" onkeypress="checkInt_KeyPress()" name="periodTime" id="periodTime" length="2" size="5" value="<c:out value="${periodTime}"/>"/>分(0为不刷新,最小5分钟)
	</td>
</tr>
<tr>
	<td colspan="2">
		<input type="button" name="btnOk" value="确定" onclick="TabPortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>
		<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/>
	</td>
</tr>
</table>
</form>
</c:when>
<c:otherwise>


<%
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
StringBuffer sb = new StringBuffer();
JSONArray jsonArray = JSONArray.fromObject(request.getAttribute("tabs"));
for(int i=0;i<jsonArray.size();i++){
	JSONObject jsonObj = (JSONObject)jsonArray.get(i);
	if(!jsonObj.isNullObject()){
		String labelname = jsonObj.getString("name");
		String label = jsonObj.getString("label");
		if(!StringHelper.isEmpty(label)){
			String tempLabelName = labelService.getLabelNameByKeyId(label);
			if(!StringHelper.isEmpty(tempLabelName) && !tempLabelName.toLowerCase().equals("undefined")){
				labelname = tempLabelName;
			}
		}
		sb.append("{id:'t"+request.getAttribute("portletId")+"_"+jsonObj.getString("id")+"',title:'"+labelname+"'");
		sb.append(",bodyStyle:'padding:3px;',autoHeight:true,autoWidth:true");
		sb.append(",autoLoad:{url:'"+jsonObj.getString("src")+"',scripts:true,params:'id="+request.getAttribute("portletId")+"");
		if(jsonObj.has("params")){
			sb.append("&tabParams="+jsonObj.getString("params")+"");
		}
		sb.append("',callback:function(t){var t=Ext.getCmp('t"+request.getAttribute("portletId")+"_"+jsonObj.getString("id")+"');");
		sb.append("rePositionCurrentPortalTab();}}},");
	}
}
String items = sb.toString();
if(items.endsWith(",")){
	items = items.substring(0, items.length()-1);
}
if("".equals(items)){
	items = "{}";
}
%>
<script>
Ext.onReady(function(){
	var tabPanel_<%=request.getAttribute("portletId")%> = new Ext.TabPanel({
        renderTo: 'tabs_<%=request.getAttribute("portletId")%>',
        activeTab: 0,
        id:'tabPanel_<%=request.getAttribute("portletId")%>',
		border: false,
        defaults:{autoScroll: true},
        items:[<%=items%>],
	    enableTabScroll: true, 
        width: '100%',
		listeners: {
			'tabchange': function(tabPanel, tab){
				rePositionCurrentPortalTab();
			}
		}
	});
	//EWV2012103314 左菜单收缩展开Tab元素显示不全
	var extTab = tabPanel_<%=request.getAttribute("portletId")%>;
	Ext.EventManager.onWindowResize(function(){
		var o = document.getElementById("tabs_<%=request.getAttribute("portletId")%>");
		if(o){
			while(o.parentNode){
				if(o.tagName=='DIV' && o.id && o.id.indexOf('portletContent')!=-1) break;
				o = o.parentNode;
			}
			extTab.header.dom.style.width = o.style.width;
			if(extTab.header.dom.offsetWidth==0) return;
			extTab.onResize();
		}
	});
});
</script>
<div id="tabs_<%=request.getAttribute("portletId")%>"></div>

</c:otherwise>
</c:choose>