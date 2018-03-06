<%@ include file="/base/init.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.base.label.model.LabelCustom"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.module.service.ModuleService"%>
<%@ page import="com.eweaver.base.module.model.Module"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="org.light.portal.core.entity.PortalTab"%>
<%@ page import="org.light.portal.core.service.PortalService"%>
<%@ page import="org.light.portal.core.entity.PortletObject"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONValue"%>
<%@ page import="org.json.simple.JSONArray"%>
<%
String keyword = request.getParameter("keyword");
String labeltype = request.getParameter("labeltype");
String portletId = "";
if(LabelType.Shortcut.toString().equals(labeltype)){
	String[] tmpArr = keyword.split("\\|");
	portletId = tmpArr[0];
	keyword = tmpArr[1];
}
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
List<LabelCustom> labelCustomList = labelCustomService.getLabelCustomsByKeyword(keyword);
List<Selectitem> selectitemList = selectitemService.getSelectitemList("4028803522c5ca070122c5d78b8f0002", null);
if(labelCustomList.isEmpty()){ //兼容升级版的程序
	if(LabelType.FormField.toString().equals(labeltype)){
		FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
		Formfield formfield = formfieldService.getFormfieldById(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(formfield);
		labelCustomList.add(labelCustom);
	}else if(LabelType.Menu.toString().equals(labeltype)){
		MenuService menuService = (MenuService)BaseContext.getBean("menuService");
		Menu menu = menuService.getMenu(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(menu);
		labelCustomList.add(labelCustom);
	}else if(LabelType.ReportField.toString().equals(labeltype)){
		ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
		Reportfield reportfield = reportfieldService.getReportfieldById(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(reportfield);
		labelCustomList.add(labelCustom);
	}else if(LabelType.Workflowinfo.toString().equals(labeltype)){
		WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
		Workflowinfo workflowinfo = workflowinfoService.get(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(workflowinfo);
		labelCustomList.add(labelCustom);
	}else if(LabelType.Nodeinfo.toString().equals(labeltype)){
		NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
		Nodeinfo nodeinfo = nodeinfoService.get(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(nodeinfo);
		labelCustomList.add(labelCustom);
	}else if(LabelType.PortalTab.toString().equals(labeltype)){
		PortalService portalService = (PortalService) BaseContext.getBean("portalService");
		PortalTab portalTab = portalService.getPortalTabByCol1(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(portalTab);
		labelCustomList.add(labelCustom);
	}else if(LabelType.PortletObject.toString().equals(labeltype)){
		PortalService portalService = (PortalService) BaseContext.getBean("portalService");
		PortletObject portletObject = portalService.getPortletObjectByCol1(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(portletObject);
		labelCustomList.add(labelCustom);
	}else if(LabelType.Category.toString().equals(labeltype)){
		CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
		Category category = categoryService.getCategoryById(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(category);
		labelCustomList.add(labelCustom); 
	}else if(LabelType.Module.toString().equals(labeltype)){
		ModuleService moduleService = (ModuleService)BaseContext.getBean("moduleService");
		Module module = moduleService.getModule(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(module);
		labelCustomList.add(labelCustom); 
	}else if(LabelType.Selectitem.toString().equals(labeltype)){
		Selectitem selectitem = selectitemService.getSelectitemById(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(selectitem);
		labelCustomList.add(labelCustom); 
	}else if(LabelType.Setitem.toString().equals(labeltype)){
		SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
		Setitem setitem = setitemService.getSetitem(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(setitem);
		labelCustomList.add(labelCustom); 
	}else if(LabelType.Pagemenu.toString().equals(labeltype)){
		PagemenuService pagemenuService = (PagemenuService) BaseContext.getBean("pagemenuService");
		Pagemenu pagemenu = pagemenuService.get(keyword);
		LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabel(pagemenu);
		labelCustomList.add(labelCustom); 
	}else if(LabelType.Shortcut.toString().equals(labeltype)){
		PortalService portalService = (PortalService)BaseContext.getBean("portalService");
		PortletObject portletObject = portalService.getPortletById(NumberHelper.getIntegerValue(portletId));
		String params = portletObject.getParameter();
		if(!StringHelper.isEmpty(params)){
			JSONObject jsonObj = (JSONObject)JSONValue.parse(params);
			JSONArray shortcutDatas = (JSONArray)jsonObj.get("shortcutDatas");
			JSONObject theShortcut = null;
			for(int i = 0; i < shortcutDatas.size(); i++){
				JSONObject shortcutData = (JSONObject)shortcutDatas.get(i);
				String shortcutId = StringHelper.null2String(shortcutData.get("shortcutId"));
				if(("shortcut_" + shortcutId).equals(keyword)){
					theShortcut = shortcutData;
					break;
				}
			}
			if(theShortcut != null){
				LabelCustom labelCustom = labelCustomService.createOrModifyDefaultCNLabelOfShortcut(theShortcut);
				labelCustomList.add(labelCustom); 
			}
		}
	}else{
		throw new RuntimeException("Unknow The LabelType : " + labeltype);
	}
}
%>
<html> 
<head>

<style type="text/css">
.x-toolbar table {width:0}
#pagemenubar table {width:0}
.x-panel-btns-ct table {width:0}
</style>
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript">
     Ext.onReady(function() {
         Ext.QuickTips.init();
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         addBtn(tb,'提交','S','accept',function(){onSubmit()});
         addBtn(tb,'关闭','C','exclamation',function(){onClose()});
     });
 </script>
</head>
<body style="overflow: hidden;">
<div id="pagemenubar" style="z-index:100;"></div>
<form action="/ServiceAction/com.eweaver.base.label.servlet.LabelCustomAction?action=manageCustomLabel"  target="_self"  name="EweaverForm" method="post">
	<input type="hidden" name="keyword" value="<%=keyword%>">
	<input type="hidden" name="labeltype" value="<%=labeltype%>">
	<table id="langTable" border=1>
		<colgroup>
			<col width="50%">
			<col width="*">
		</colgroup>				
		<tr class="header">
			<td>显示名称</td>
			<td>语言</td>
		</tr>
		<%for(int i=0; i < selectitemList.size(); i++){
			Selectitem selectitem = selectitemList.get(i);
			String language = selectitem.getObjname();
			LabelCustom labelCustom = new LabelCustom();
			for(int j = 0; j < labelCustomList.size(); j++){
				LabelCustom labelCustom2 = labelCustomList.get(j);
				if(language.equals(labelCustom2.getLanguage())){
					labelCustom = labelCustom2;
					break;
				}
			}
		%>
		<tr height="25px">
			<td>
				<%if(language.equals("zh_CN")){	//中文不允许更改(在此页面) %>
					<input type="hidden" name="labelname" value="<%=StringHelper.null2String(labelCustom.getLabelname()) %>">
					<%=StringHelper.null2String(labelCustom.getLabelname()) %>
				<%} else{%>
					<input type="text" name="labelname" value="<%=StringHelper.null2String(labelCustom.getLabelname()) %>" style="width:90%">
				<%}%>
			</td>
			<td><input type="hidden" id="language" name="language" value="<%=language%>"><%=selectitem.getObjdesc()%></td>
		</tr>
		<%}%>
	</table>
</form>
<script language="javascript">
function onSubmit(){
	document.EweaverForm.submit();
}
function onClose(){
	if(parent.closeLabel){
		parent.closeLabel();
	}
}
</script>
</body>
</html>