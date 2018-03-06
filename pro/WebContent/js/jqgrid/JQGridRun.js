/**
* JQGrid前端核心js, JQGrid初始化，运行，均依赖此JS
* 该JS中将后台Java数据对象抽象成JS相对应的数据对象(部分信息)
* 一来可以从jsp中把JQGrid这块的代码分离出来
* 二来是因为JQGrid中无论是表格宽度还是列宽度都不支持百分比的设置,想要精确的进行一些宽度操作必须要转换,而转换依赖于浏览器分辨率的宽度,这必须要拿到客户端来做
*/
var JQGridRun = {
	
	buildJQGrids : function(infos){
		var tableModels = convertToJQGridTableModels(infos);
		
		var tableModelGroups = groupJQGridTableModels(tableModels);
		
		jQuery.each(tableModelGroups, function(){
			initJQGridByTableModelGroup(this);
		});
		
	}
	
};

function convertToJQGridTableModels(infos){
	var tableModels	= new Array();
	for(var i = 0; i < infos.length; i++){
		var tableModel = new JQGridTableModel(infos[i]);
		tableModel.calculateWidth(true);
		tableModels.push(tableModel);
	}
	return tableModels;
}

function groupJQGridTableModels(tableModels){
	var tableModelGroups = new Array();
	for(var i = 0; i < tableModels.length; i++){
		var tableModel = tableModels[i];
		var tableModelGroup = getJQGridTableModelGroup(tableModelGroups, tableModel.tabGroup);
		if(tableModelGroup == null){
			tableModelGroup = new JQGridTableModelGroup(tableModel.tabGroup);
			tableModelGroup.addTableModel(tableModel);
			tableModelGroups.push(tableModelGroup);
		}else{
			tableModelGroup.addTableModel(tableModel);
		}
	}
	return tableModelGroups;
}

function getJQGridTableModelGroup(tableModelGroups, groupName){
	if(!groupName || groupName == ""){
		return null;
	}
	for(var i = 0; i < tableModelGroups.length; i++){
		if(tableModelGroups[i].groupName == groupName){
			return tableModelGroups[i];
		}
	}
	return null;
}

function JQGridTableModelGroup(groupName){
	this.groupName = groupName;
	this.tableModels = new Array();
}

JQGridTableModelGroup.prototype.addTableModel = function(tableModel){
	this.tableModels.push(tableModel);
};

JQGridTableModelGroup.prototype.orderTableModels = function(){
	this.tableModels.sort(function(a, b){
		return a.orderInTabGroup - b.orderInTabGroup;
	});
};

JQGridTableModelGroup.prototype.isDisplayWithTab = function(){
	return this.tableModels.length > 1;
};

JQGridTableModelGroup.prototype.getFirstTableModel = function(){
	return this.tableModels[0];
};

function JQGridTableModel(info){
	this.jsonInfo = jQuery.parseJSON(info);
	this.layoutid = this.jsonInfo.layoutid;
	this.formid = this.jsonInfo.formid;
	this.caption = this.jsonInfo.caption;
	this.colNames = jQuery.parseJSON(this.jsonInfo.colNames);
	this.colModel = jQuery.parseJSON(this.jsonInfo.colModel);
	this.width = this.jsonInfo.width;
	this.height = this.jsonInfo.height;
	this.colMinWidth = parseInt(this.jsonInfo.colMinWidth);
	this.tabGroup = this.jsonInfo.tabGroup;
	this.orderInTabGroup = parseInt(this.jsonInfo.orderInTabGroup);
}

JQGridTableModel.prototype.calculateWidth = function(isBindEvent){
	var $targetObj = jQuery("#tabs-" + this.formid);	//如果放置在tab页中，则目标对象为tab页
	if($targetObj.length == 0){	//不在tab页中
		var $selfObj = jQuery("#gbox_oTable" + this.formid);
		if($selfObj.length == 0){	//还未初始化成jqGrid,则目标对象是表格本身
			$selfObj = jQuery("#oTable" + this.formid);
		}
		$targetObj = $selfObj.parent();
		if($targetObj.length == 0){
			$targetObj = jQuery("#layoutFrame");
		}
	}
	if(isPercentageWidth(this.jsonInfo.width)){
		var pc = getPercentageCoefficient(this.jsonInfo.width);
		//此处减去2是因为JQGrid表格左右会有边框，预留边框左右的宽度。
		this.width = ($targetObj.width() * pc) - 2;
	}
	
	var totalUnPercentageWidth = 0; //不是百分比的宽度的总和
	var isPercentageWidthColIndex = new Array();
	var tempColModel = jQuery.parseJSON(this.jsonInfo.colModel);
	for(var i = 0; i < tempColModel.length; i++){
		var cm = tempColModel[i];
		if(!cm.hidden && cm.width){
			if(isPercentageWidth(cm.width)){
				isPercentageWidthColIndex.push(i);
			}else{
				totalUnPercentageWidth += parseInt(cm.width);
				cm.width = parseInt(cm.width);
			}
		}
	}
	
	//20为checkbox的宽度，22为右侧滚动条预留的宽度(最起码在总体百分比不超出的情况下预留滚动条的位置会好看一些)
	var enCalculateTableWidth = (this.width - totalUnPercentageWidth) - 20 - 22 - 16;
	
	var unknownAvgWidth = 8 - ((tempColModel.length - 1) * 0.4);
	for(var i = 0; i < isPercentageWidthColIndex.length; i++){
		var cm = tempColModel[isPercentageWidthColIndex[i]];
		var pc = getPercentageCoefficient(cm.width);	
		cm.width = parseInt(enCalculateTableWidth * pc) - unknownAvgWidth;
	}
	
	//进行表格列最小宽度设置
	if(!isNaN(this.colMinWidth) && this.colMinWidth > 0){
		for(var i = 0; i < tempColModel.length; i++){
			var cm = tempColModel[i];
			if(!cm.hidden && cm.width && cm.width < this.colMinWidth){
				cm.width = this.colMinWidth;
			}
		}
	}
	
	this.colModel = tempColModel;
	
	if(isBindEvent){
		var t = this;
		$targetObj.one("resize", function(){
			t.reCalculateWidth();
		});
	}
	
};

JQGridTableModel.prototype.reCalculateWidth = function(){
	this.calculateWidth(false);
	
	jQuery("#oTable" + this.formid).jqGrid('setGridWidth', this.width);
	
	/** 无效,无语 
	for(var i = 0; i < this.colModel.length; i++){
		var cm = this.colModel[i];
		if(!cm.hidden && cm.width){
			jQuery("#oTable" + this.formid).jqGrid('setColProp', cm.name, {width:cm.width});
		}
	}*/
	
};

function isPercentageWidth(width){
	return width.endsWith("%");
}

function getPercentageCoefficient(width){
	width = width.substring(0, width.indexOf("%"));
	return (parseFloat(width)/100);
}

function initJQGridByTableModelGroup(tableModelGroup){
	if(tableModelGroup.isDisplayWithTab()){
		tableModelGroup.orderTableModels();
		var groupName = tableModelGroup.groupName;
		var firstTableModel = tableModelGroup.getFirstTableModel();
		
		var $jqGridTabContainer = jQuery("<div id='jqGridTab_"+groupName+"'></div>");
		$jqGridTabContainer.insertBefore("#oTable" + firstTableModel.formid);
		
		var $jqGridTabHeader = jQuery("<ul></ul>");
		$jqGridTabContainer.append($jqGridTabHeader);
		
		for(var i = 0; i < tableModelGroup.tableModels.length; i++){
			var tableModel = tableModelGroup.tableModels[i];
			
			$jqGridTabHeader.append("<li><a href='#tabs-"+tableModel.formid+"'>"+tableModel.caption+"</a></li>");
			
			var $jqGridTabContent = jQuery("<div id='tabs-"+tableModel.formid+"'></div>");
			$jqGridTabContent.append(jQuery("#oTable" + tableModel.formid));
			
			$jqGridTabContainer.append($jqGridTabContent);
			
			tableModel.caption = "";	//此处将caption清空是为了利用 "JQGrid在caption为空的时候不显示表头的机制"来达到在tab页中显示时隐藏JQGrid表头的目的
			
			initJQGridByTableModel(tableModel);
		}
		
		$jqGridTabContainer.tabs({
			event: "click",
			show: function (event, ui) {
				var tableModel = tableModelGroup.tableModels[ui.index];
				if(!tableModel.widthCalculated){	// widthCalculated 表示宽度是否已被计算过	(避免每次都计算)
					tableModel.reCalculateWidth();
					tableModel.widthCalculated = true;
				}
			}
		});
		
	}else{
		initJQGridByTableModel(tableModelGroup.getFirstTableModel());
	}
}

var allJQGridTableModel = new Array();
function initJQGridByTableModel(tableModel){
	jQuery("#oTable" + tableModel.formid).jqGrid({
		ajaxGridOptions: {
			timeout: 60000
		},
		url:'/ServiceAction/com.eweaver.workflow.request.servlet.JQGridAction?action=getDetailTableDatas',
		datatype: "json",
		postData:{
			layoutid: tableModel.layoutid,
			formid: tableModel.formid
		},
		height: tableModel.height,
		width: tableModel.width,
	   	caption: tableModel.caption,
	   	colNames: tableModel.colNames,
	   	colModel: tableModel.colModel,
	   	multiselect: true,
	   	/*multiboxonly: true,*/
	   	shrinkToFit: false,
	   	toolbar: [true,"top"],
	   	//footerrow : true,
	   	//userDataOnFooter : true,
	   	scrollrows: true,
	   	jsonReader:{
			repeatitems : false
		},
		onHeaderClick: function(){
			for(var i = 0; i < allJQGridTableModel.length; i++){
				allJQGridTableModel[i].reCalculateWidth();
			}
		},
		loadComplete: function(){
			//将已初始化的tableModel存放到一个数组变量中
			allJQGridTableModel.push(tableModel);
			
			//初始化rowindex
			initJQGridRowindex(tableModel.formid);
			
			//为JQgrid生成的checkbox给一个名称，并设置值
			giveNameAndSetValToJQGridCBBox(tableModel.formid);
			
			//运行设置必填的脚本
			runSetNeedCheckScriptWithJQGrid(tableModel.formid);
			
			//运行需要在JQGrid加载完成之后运行的脚本
			runScriptWhenJQGridLoaded(tableModel.formid);
			
			//初始化新增行的方法
			initJQGridAddRowFun(tableModel.formid);
			
			//初始化工具栏按钮
			initJQGridToolButton(tableModel.formid);
			
			//这里手动再调用一下onAddRow，因为之前的onAddRow方法调用时其内部一些JS脚本代码可能在执行的时候表格中的数据并未加载出来,所以在此处再次调用一下
			onAddRow();
			
			if(typeof(jqGridLoadedCallback) == "function"){
				jqGridLoadedCallback(tableModel.formid);
			}
		},
		loadonce: true,
		rowNum: -1,
		gridview: true
	});
}

function initJQGridRowindex(formid){
	var gridUserData = jQuery("#oTable" + formid).getGridParam('userData');
	var dataRowCount = gridUserData.dataRowCount;
	if(dataRowCount){
		eval("rowindex_"+formid+" = " + dataRowCount + ";");
	}
}

function giveNameAndSetValToJQGridCBBox(formid){
	jQuery("tr.jqgrow td:first-child .cbox", "#oTable" + formid).each(function(){
		var name = jQuery(this).attr("name");
		if(!name || name.indexOf("check_node_") == -1){
			jQuery(this).attr("name", "check_node_" + formid);
			var currRowIndex = jQuery(this).parent().parent().find(".jq_r_index").text();
			jQuery(this).attr("value", currRowIndex);
		}
	});
}

function runSetNeedCheckScriptWithJQGrid(formid){
	var gridUserData = jQuery("#oTable" + formid).getGridParam('userData');
	var setNeedCheckScript = gridUserData.setNeedCheckScript;
	if(setNeedCheckScript){
		eval(setNeedCheckScript);
	}
}

function runScriptWhenJQGridLoaded(formid){
	var $ = jQuery;
	var gridUserData = jQuery("#oTable" + formid).getGridParam('userData');
	var scriptForJQGridLoadedRun = gridUserData.scriptForJQGridLoadedRun;
	if(scriptForJQGridLoadedRun){
		eval(scriptForJQGridLoadedRun);
	}
}

function initJQGridAddRowFun(formid){
	var gridUserData = jQuery("#oTable" + formid).getGridParam('userData');
	var addRowFun = gridUserData.addRowFun;
	if(addRowFun){
		eval(addRowFun);
	}
}

function initJQGridToolButton(formid){
	var gridUserData = jQuery("#oTable" + formid).getGridParam('userData');
	var isview = gridUserData.isview;
	if(!isview){
		var $addBtn = jQuery("<button type='button' style='margin:0px 0px 0px 3px;' onclick=\"addJQGridRow('"+formid+"', true);\">新增</button>");
		var $deleteBtn = jQuery("<button type='button' style='margin:0px 0px 0px 3px;' onclick=\"delJQGridRow('"+formid+"');\">删除</button>");
		var $impExcelBtn = jQuery("<button type='button' style='margin:0px 0px 0px 3px;' onclick=\"addrowbyexcel('"+formid+"', true);\">Excel导入</button>");
		
		$addBtn.button({icons: {primary: "ui-icon-circle-plus"}});
		$deleteBtn.button({icons: {primary: "ui-icon-circle-minus"}});
		$impExcelBtn.button({icons: {primary: "ui-icon-circle-arrow-s"}});
		
		var isHaveAddBtn = gridUserData.isHaveAddBtn;
		var isHaveDeleteBtn = gridUserData.isHaveDeleteBtn;
		var isHaveImpExcelBtn = gridUserData.isHaveImpExcelBtn;
		
		if(isHaveAddBtn){
			jQuery("#t_oTable" + formid).append($addBtn);
		}
		if(isHaveDeleteBtn){
			jQuery("#t_oTable" + formid).append($deleteBtn);
		}
		if(isHaveImpExcelBtn){
			jQuery("#t_oTable" + formid).append($impExcelBtn);
		}
	}
}

//将JQGrid的滚动条滚动到最底部
function scrollJQGridToBottom(formid){
	var $bdiv = jQuery(".ui-jqgrid-bdiv","#gbox_oTable" + formid);
	$bdiv.scrollTop($bdiv[0].scrollHeight);
}

/*清除底部行的边框样式(左边框)，处理当有合计时底部行每列宽度和数据列宽度多1像素的问题*/
function clearJQGridFooterRowBorder(formid){
	jQuery(".ui-jqgrid-sdiv tr.footrow").css("border-left","none");
}

//isScrollToBottomWhenRowAdded：行添加后是否将滚动条移动到grid的底部
function addJQGridRow(formid, isScrollToBottomWhenRowAdded){
	
	eval("addrow_jQGrid_" + formid + "('"+formid+"');");
	
   	giveNameAndSetValToJQGridCBBox(formid);
   	/*将JQGrid的滚动条定位到刚新增的行位置*/
   	if(isScrollToBottomWhenRowAdded){
		scrollJQGridToBottom(formid);
	}
   	
	onAddRow();
	
}

function delJQGridRow(formid){
	
	jQuery("#oTable"+formid).find("input[name='check_node_"+formid+"']:checked").each(function(){
		//删除表格行之前禁用掉多附件上传
		jQuery(this).parent().parent().find("a.addfile div.uploadify").each(function(){
			destroyMultiUploadObj(jQuery(this).attr("id"));
		});
		//禁用掉带格式文本
		jQuery(this).parent().parent().find("textarea").each(function(){
			var tid = jQuery(this).attr("id");
			if(jQuery("#cke_" + tid).length > 0){
				CKEditorExt.destroy(tid);
			}
		});
		document.all("delnodes_" + formid).value += ","+jQuery(this).val();
	});
	
	var selRowIds = jQuery("#oTable" + formid).jqGrid('getGridParam','selarrrow');
	if(selRowIds && selRowIds.length > 0){
		for(var i = (selRowIds.length - 1); i >= 0; i--){
			jQuery("#oTable" + formid).jqGrid('delRowData',selRowIds[i]);
		}
	}
		
	onCal();
}

function delAllJQGridRow(formid){
	jQuery("#oTable"+formid).find("input[name='check_node_"+formid+"']").each(function(){
		if(!this.checked){
			this.checked = true;
			this.click();	//仅checked是不够的,如果仅checked, jqGrid的selarrrow获取不到选中的id
		}
	});
	delJQGridRow(formid);
}