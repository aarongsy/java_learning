<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@page import="com.eweaver.workflow.workflow.model.Export"%>
<%@page import="com.eweaver.workflow.workflow.service.ExportService"%>
<%@page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@page import="com.eweaver.workflow.form.model.Formfield"%>
<%@page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ include file="/base/init.jsp"%>
<%!
	private String getConditionForDisplay(Export export){
		StringBuffer buffer = new StringBuffer();
		String condition = export.getCondition();
		if(!StringHelper.isEmpty(condition)){
			buffer.append("<ul>");
			String sql = "select * from exportdetail where exportid='" + export.getId()+ "' and isdelete < 1 order by rowindex asc";
			DataService dataService = new DataService();
			List<Map<String, Object>> exportdetailList = dataService.getValues(sql);
			for(int i = 0; i < exportdetailList.size(); i++){
				Map<String, Object> exportdetail = exportdetailList.get(i);
				buffer.append("<li>").append(convertExportdetailForDisplay(exportdetail)).append("</li>");
			}
			buffer.append("</ul>");
		}
		return buffer.toString();
	}

	private String convertExportdetailForDisplay(Map<String, Object> exportdetail){
		StringBuffer buffer = new StringBuffer();
		
		String condition = StringHelper.null2String(exportdetail.get("condition"));
		String fieldname = StringHelper.null2String(exportdetail.get("fieldname"));
		String opt = StringHelper.null2String(exportdetail.get("opt"));
		String val = StringHelper.null2String(exportdetail.get("val"));
		
		FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
		Formfield formfield = formfieldService.getFormfieldById(fieldname);
		
		String conditionForDisplay = condition.equals("1") ? "并且" : (condition.equals("2") ? "或者" : "");
		buffer.append("<span class=\"part1\">");
		buffer.append(conditionForDisplay);
		buffer.append("</span>");
		
		if(formfield != null && formfield.getId() != null){
			String fieldnameForDisplay = StringHelper.null2String(formfield.getLabelname());
			buffer.append(fieldnameForDisplay);
			buffer.append(getBlankFlag(2));
		}
		
		LabelService labelService = (LabelService)BaseContext.getBean("labelService");
		Map<String, String> optMap = new HashMap<String, String>();
		optMap.put("1", labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f"));
		optMap.put("2", labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c"));
		optMap.put("3", labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c"));
		optMap.put("4", labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d"));
		optMap.put("5", labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d"));
		optMap.put("6", labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e"));
		optMap.put("7", labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c"));
		optMap.put("8", labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f"));
		optMap.put("9", labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e"));
		optMap.put("10", labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f"));
		optMap.put("11", labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c"));
		optMap.put("12", labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d"));
		String optForDisplay = StringHelper.null2String(optMap.get(opt));
		buffer.append(optForDisplay);
		buffer.append(getBlankFlag(2));
		
		if(formfield != null && formfield.getId() != null){
			String valForDisplay = val;
			int htmltype = NumberHelper.getIntegerValue(formfield.getHtmltype());
			if(htmltype == 5 || htmltype == 8){	//选择项 或者 checkbox多选
				SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
				valForDisplay = selectitemService.getSelectitemNameById(val);
			}else if(htmltype == 6){	//关联选择
				RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
				String refobjid = StringHelper.null2String(formfield.getFieldtype());
				Refobj refobj = refobjService.getRefobj(refobjid);
				if(refobj != null && refobj.getId() != null){
					valForDisplay = refobjService.getObjname(refobj, val);
				}
			}
			buffer.append(valForDisplay);
			buffer.append(getBlankFlag(2));
		}
		
		return buffer.toString();
	}
	
	private String getBlankFlag(int count){
		StringBuffer buffer = new StringBuffer();
		for(int i = 0; i < count; i++){
			buffer.append("&nbsp;");
		}
		return buffer.toString();
	}
%>
<%
	NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
	ExportService exportService = (ExportService)BaseContext.getBean("exportService");
	String nodeid = StringHelper.null2String(request.getParameter("nodeid"));
	Nodeinfo nodeinfo = nodeinfoService.get(nodeid);
%>
<html>
<head>
  <title></title>
  <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
  <script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
  <style type="text/css">
	.x-toolbar table {width:0}
	#pagemenubar table {width:0}
	.x-panel-btns-ct {padding: 0px;}
	.x-panel-btns-ct table {width:0}
	   
  	table.layouttable{
  		width: 95%;
  		margin: 0px;
  		margin-top: 15px;
  		margin-left: 25px;
  	}
  	table.detailtable{
  		width: 95%;
  		margin: 0px;
  		margin-top: 2px;
  		margin-left: 25px;
  	}
  	table.layouttable td, table.detailtable td{
  		font-family: Microsoft YaHei !important;
  		padding-left: 6px !important;
  	}
  	td.title{
  		font-weight: bold;
  	}
  	td.conditionTD ul{
  		list-style: none;
  	}
  	td.conditionTD ul li{
  		font-family: Microsoft YaHei;
  	}
  	td.conditionTD ul li span.part1{
  		display: inline-block;
  		font-family: Microsoft YaHei;
  		width: 30px;
  	}
  	#explain{
  		width: 95%;
  		margin-top: 10px;
  		text-align: left;
  		margin-left: 25px;
  	}
  	#explain span{
  		font-family: Microsoft YaHei;
  		font-weight: bold;
  		padding-left: 3px;
  	}
  	#explain ul{
  		list-style: circle;
  		list-style-position: inside;
  	}
  	#explain ul li{
  		font-family: Microsoft YaHei;
  		margin-top: 5px;
  		padding-left: 10px;
  	}
  	#explain ul li font{
  		font-family: Microsoft YaHei;
  	}
  	#clearBtn{
  		margin-left: 10px;
  		font-size: 11px;
  		height: 18px;
  		color: red;
  		cursor: pointer;
  	}
  </style>
  <script type="text/javascript">
  	Ext.onReady(function(){
		document.getElementById("pagemenubar").style.width = document.body.clientWidth + "px";
		Ext.QuickTips.init();
		var tb = new Ext.Toolbar();
		tb.render('pagemenubar');
		addBtn(tb,'保存','S','accept',function(){onSubmit();});
		addBtn(tb,'关闭窗口','C','delete',function(){onClose();});
		
		$("#EweaverForm").ajaxForm({
			beforeSubmit:function(){
				var flag = true;
				$("input[name='exclusivePrioritys']").each(function(){
					if(this.value != "" && isNaN(this.value)){
						flag = false;
						alert("优先级必须是数字，请更正");
						this.focus();
						return;
					}
				});
				if(flag){
					tb.disable();
				}
				return flag;
			},
	        success: function(responseText, statusText, xhr, $form){
				tb.enable();
				var flag;
	        	if(responseText == "true"){
	        		flag = "已定义优先级";
	        	}else{
	        		flag = "未定义优先级";
	        	}
	        	alert("操作成功");
	        	window.parent.returnValue = flag;
                window.parent.close();
			}
		}); 
	});
  	
  	function onSubmit(){
  		$("#EweaverForm").submit();
  	}
  	
  	function onClose(){
  		window.parent.close();
  	}
  	
  	function onClear(){
  		$("input[name='exclusivePrioritys']").val("");
  	}
  </script>
</head>

<body>
  <div id="pagemenubar"></div>
  <table class="layouttable">
  	<colgroup>
	  	<col width="15%"/>
	  	<col width="85%"/>
  	</colgroup>
  	<tr>
  		<td colspan="2" class="title">节点信息</td>
  	</tr>
  	<tr>
  		<td class="FieldName">节点名称</td>
  		<td class="FieldValue"><%=StringHelper.null2String(nodeinfo.getObjname()) %></td>
  	</tr>
  	<tr>
  		<%
  			Integer splittype = nodeinfo.getSplittype();
  			String splittypeStr = splittype == null ? "" : (splittype.intValue() == 1 ? "并行" : "异或");
  		%>
  		<td class="FieldName">后驱转移关系</td>
  		<td class="FieldValue"><%=splittypeStr %></td>
  	</tr>
  </table>
  <form action="/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=changeExclusivePriority" method="post" id="EweaverForm">
  <input type="hidden" name="nodeid" value="<%=nodeid %>"/>
  <table class="detailtable">
  	<colgroup>
	  	<col width="25%"/>
	  	<col width="50%"/>
	  	<col width="25%"/>
  	</colgroup>
  	<tr>
  		<td colspan="3" class="title">出口信息</td>
  	</tr>
  	<tr class="Header">
  		<td>目标节点</td>
  		<td>条件</td>
  		<td>排他性优先级<input type="button" value="清空" id="clearBtn" onclick="javascript:onClear();"/></td>
  	</tr>
  	<%
  		List<Export> exportList = exportService.getOutExportByNodeid(nodeid);
  		//按优先级排序,数字越小优先级越高,则排在前面
  		exportList = exportService.orderExportsByExclusivePriority(exportList);
  		for(int i = 0; i < exportList.size(); i++){
  			Export export = exportList.get(i);
  			String endNodeid = StringHelper.null2String(export.getEndnodeid());
  			Nodeinfo targetNode = nodeinfoService.get(endNodeid);
  			if(targetNode == null || targetNode.getId() == null){
  				continue;
  			}
  	%>
  			<tr>
		  		<td><%=StringHelper.null2String(targetNode.getObjname()) %></td>
		  		<td class="conditionTD">
					<%=getConditionForDisplay(export) %>
				</td>
		  		<td>
		  			<input type="hidden" name="exportids" value="<%=export.getId() %>"/>
		  			<input type="text" name="exclusivePrioritys" value="<%=StringHelper.null2String(export.getExclusivePriority()) %>"/>
		  		</td>
		  	</tr>
  	<%		
  		}
  	%>
  </table>
  </form>  
  <div id="explain">
  	<span>说明：</span>
  	<ul>
  		<li>系统在流程流转的过程中，如出口设置了优先级，则按优先级找符合条件的出口，找到即不再验证其它出口条件。</li>
  		<li>在设置优先级时数字越<font color="red">小</font>，优先级越<font color="red">高</font>。</li>
  		<li>已设置优先级的出口优先级要高于未设置优先级的出口。</li>
  	</ul>
  </div>
</body>
</html>
