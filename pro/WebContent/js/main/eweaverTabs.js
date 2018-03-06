/*首页tab页*/
function eweaverTabs(tabPanel,contentPanel){
	this.tabPanel = tabPanel;
	this.contentPanel = contentPanel;
	this.currentTabid = "";
	this.tabContainer = new Array();			//tab容器
	this.tabIdContainer = new Array();			//tabid容器
	this.withdrawTabContainer = new Array();	//被撤下的tab容器
	this.withdrawTabIdContainer = new Array();	//被撤下的tabid容器
	this.tabTitleMaxLength = 20;	//tab页标题显示的最大长度,超过此长度会被截取
	this.tabOpenDisorderContainer = new Array();	//tab页打开顺序集
}
/*首页tab对象*/
function eweaverTab(tabId, tabName, tabUrl, closeable, expandable, expandCallback, icon, tabShowName, onCloseCallbackFn){
	this.id = tabId.substring(3);
	this.tabId = tabId;
	this.tabName = tabName;
	this.tabUrl = tabUrl;
	this.closeable = closeable;
	this.expandable = expandable;
	this.expandCallback = expandCallback;
	this.icon = icon;
	this.width = -1;	//宽度,在创建的时候会被赋值
	this.tabShowName = tabShowName;	//tab显示名称,长度超过最大长度时可能被截取
	this.onCloseCallbackFn = onCloseCallbackFn;
}
/*刷新当前的tab页*/
eweaverTabs.prototype.refreshCurrentTab = function(){
	var currentTabid = this.getCurrentTabid();
	this.refreshTab(currentTabid);
}
/*刷新指定id的tab页*/
eweaverTabs.prototype.refreshTab = function(tabId){
	var iframeId = getIframeIdByTabid(tabId);
	var iframeDoc = getIFrameDocument(iframeId);
	if(iframeDoc){
		showLoadingDiv(); //显示页面加载中
		iframeDoc.location.reload();	//刷新iframe
	}	
}
/*取一个随机的tabid,长度为32位,兼容系统中有打开tab页没传递tabid的情况*/
eweaverTabs.prototype.getRandomTabid = function(){
	var ranTabid = "";
	for(var i = 0; i < 32; i++){
		ranTabid += Math.floor(Math.random()*10); 
	}
	return ranTabid;
}
/*获取当前tab页的id*/
eweaverTabs.prototype.getCurrentTabid = function(){
	return this.currentTabid;
}
/*通过tabId获取tab对象*/
eweaverTabs.prototype.getTabById = function(tabId){
	for(var i = 0; i < this.tabContainer.length; i++){
		if(tabId == this.tabContainer[i].tabId){
			return this.tabContainer[i];
		}
	}
	for(var i = 0; i < this.withdrawTabContainer.length; i++){
		if(tabId == this.withdrawTabContainer[i].tabId){
			return this.withdrawTabContainer[i];
		}
	}
	return null;
}
/*以指定的tabId作为参照物,获取其他的可以关闭的tab页的id集,以数组形式返回*/
eweaverTabs.prototype.getOthersCanClosedTabIds = function(tabId){
	var tabIds = this.getAllCanClosedTabIds();
	var removeIndex = -1;
	for(var i = 0; i < tabIds.length; i++){
		if(tabIds[i] == tabId){
			removeIndex = i;
			break;
		}
	}
	if(removeIndex != -1){
		tabIds.splice(removeIndex, 1);
	}
	return tabIds;
}
/*获取所有可以关闭的tab页的id集,以数组形式返回*/
eweaverTabs.prototype.getAllCanClosedTabIds = function(){
	var tabIds = new Array();
	for(var i = 0; i < this.tabContainer.length; i++){
		if(this.tabContainer[i].closeable){
			tabIds.push(this.tabContainer[i].tabId);
		}
	}
	for(var i = 0; i < this.withdrawTabContainer.length; i++){
		if(this.withdrawTabContainer[i].closeable){
			tabIds.push(this.withdrawTabContainer[i].tabId);
		}
	}
	return tabIds;
}
/*判断是否包含指定id的tab页*/
eweaverTabs.prototype.hasTab = function(tabId){
	return this.isInTabHeader(tabId) || this.isInTabWithdraw(tabId);
}
/*判断在tab头中是否包含指定id的tab页*/
eweaverTabs.prototype.isInTabHeader = function(tabId){
	for(var i = 0; i < this.tabIdContainer.length; i++){
		if(tabId == this.tabIdContainer[i]){
			return true;
		}
	}
	return false;
}
/*判断在被撤下的tab区域中是否包含指定id的tab页*/
eweaverTabs.prototype.isInTabWithdraw = function(tabId){
	for(var i = 0; i < this.withdrawTabIdContainer.length; i++){
		if(tabId == this.withdrawTabIdContainer[i]){
			return true;
		}
	}
	return false;
}
/*获取所有的tab*/
eweaverTabs.prototype.getAllTabWidth = function(){
	var w = 0;
	for(var i = 0; i < this.tabIdContainer.length; i++){
		var tabId = this.tabIdContainer[i];
		w = w + $("#li" + tabId).outerWidth(true);
	}
	return w;
}
/*获取tab容器(ul)的宽度*/
eweaverTabs.prototype.getContainerWidth = function(){
	return $("#headerTabs ul").width();
}
/*获取元素"更多"的宽度*/
eweaverTabs.prototype.getMoreElementWidth = function(){
	return $("#headerTabs ul li.more").width();
}
/*显示元素"更多"*/
eweaverTabs.prototype.showMoreElement = function(){
	$("#headerTabs ul li.more").show();
}
/*隐藏元素"更多",如果没有被撤下的tab*/
eweaverTabs.prototype.hideMoreElementIfNoWithdrawTab = function(){
	if($("#tabMore ul li").size() == 0){
		$("#headerTabs ul li.more").hide();
		$("#tabMore").hide();
	}
}
/*获取空闲的tab宽度*/
eweaverTabs.prototype.getFreeTabWidth = function(){
	return (this.getContainerWidth() - this.getMoreElementWidth()) - this.getAllTabWidth();
}
/*判断当前所有tab的总宽度是否超出了tab容器的宽度(超出返回true,否则返回false)*/
eweaverTabs.prototype.isOuterOfWidth = function(){
	return (this.getContainerWidth() - this.getMoreElementWidth() - 5) < this.getAllTabWidth();
}
/*根据"更多tab"区域在浏览器窗口最大的可视高度来动态添加或删除滚动条*/
eweaverTabs.prototype.addOrRemoveTabMoreScoll = function(){
	var windowHeight = $(window).height();
	var headerHeight = $("#header").outerHeight(true);
	var tabMoreHeight = $("#tabMore").outerHeight(true);
	var tabMoreMaxHeight = (windowHeight - headerHeight - 50);
	if(tabMoreHeight > tabMoreMaxHeight){
		$("#tabMore").css({
			"height" : 	tabMoreMaxHeight + "px",
			"overflow-y" : "scroll"
		});
	}else{
		$("#tabMore").css({
			"height" : 	"auto",
			"overflow-y" : "hidden"
		});
	}
}
/*从前面撤下tab,如果tab总宽度超出了tab容器宽度*/
eweaverTabs.prototype.withdrawTabIfOuterOfWidth = function(){
	if(this.isOuterOfWidth()){
		if(this.tabIdContainer.length == 1){
			return;
		}
		var tab = this.tabContainer[1];
		var tabId = this.tabIdContainer[1];
		
		this.tabContainer.splice(1, 1);
		this.tabIdContainer.splice(1, 1);	//从索引1开始撤下,保留门户的 tab
		
		this.withdrawTabContainer.push(tab);
		this.withdrawTabIdContainer.push(tabId);	//保存撤下的tabid的容器
		
		$('#' + this.tabPanel + " ul li:nth-child(2)").remove();	//nth-child从1开始计数
		
		this.createWithdrawTab(tab);
		
		this.showMoreElement();
		
		this.withdrawTabIfOuterOfWidth();	//递归撤下,直到不超出容器的宽度为止
		
	}
}
/*创建一个被撤下的tab*/
eweaverTabs.prototype.createWithdrawTab = function(tab){
	var tip = "";
	if(tab.tabShowName != tab.tabName){
		tip = tab.tabName;
	}
	var html = "<li id=\"li"+tab.tabId+"\"><a id=\""+tab.tabId+"\" title='"+tip+"'><p>";
	if(tab.closeable){
		html += "<span class=\"tabclose\"></span>";
	}
	html += tab.tabShowName+"</p></a></li>";
	$("#tabMore ul").append(html);
	var s = this;
	
	$("#" + tab.tabId).find(".tabclose").bind("click",function(event){
		s.deteleWithdrawTab(tab.tabId);
		event.stopPropagation();    //  阻止事件冒泡		
	});
	$("#" + tab.tabId).bind("click",function(){
		s.restoreTabOfWithdraw(tab);
		hideAllPopupDIv();
	});
	
	addClassWhenMouseover("#" + tab.tabId,"mouseover");
	
	this.addOrRemoveTabMoreScoll();
}
/*删除一个被撤下的tab*/
eweaverTabs.prototype.deteleWithdrawTab = function(tabId){
	this.deteleWithdrawTabHeader(tabId);	/*从被撤下的tab区域删除指定的tab头(不删除iframe)*/
	
	var iframeId = getIframeIdByTabid(tabId);
 	$('#' + this.contentPanel).find("#" + iframeId).remove();	//删除iframe
 	
	this.hideMoreElementIfNoWithdrawTab();/*隐藏元素"更多",如果没有被撤下的tab*/
	
	deleteTabRightMenuContent(tabId);
	
}
/*从被撤下的tab区域删除指定的tab头(不删除iframe)*/
eweaverTabs.prototype.deteleWithdrawTabHeader = function(tabId){
	var removeIndex = -1;
	for(var i = 0; i < this.withdrawTabIdContainer.length; i++){
		if(tabId == this.withdrawTabIdContainer[i]){
			removeIndex = i;
		}
	}
	if(removeIndex != -1){	//从被撤下的tab容器中删除此tab和tabId
		this.withdrawTabContainer.splice(removeIndex, 1);
		this.withdrawTabIdContainer.splice(removeIndex, 1);	
	}
	$("#tabMore ul").find("#li" + tabId).remove();	//从撤下的tab区域删除此tab
	
	this.addOrRemoveTabMoreScoll();
}
/*恢复被撤下的tab*/
eweaverTabs.prototype.restoreTabOfWithdraw = function(tab){
	this.tabContainer.push(tab);		//保存tab和tabId到tab容器中
	this.tabIdContainer.push(tab.tabId);
	
	this.deteleWithdrawTabHeader(tab.tabId);	/*从被撤下的tab区域删除指定的tab头(不删除iframe)*/
	
	this.createTabHeader(tab);	//创建tab头部
	
	this.selectTab(tab.tabId);	//选中该tab
	
	this.withdrawTabIfOuterOfWidth();	//从前面撤下tab,如果tab总宽度超出了tab容器宽度
}
/*
恢复被撤下的tab(当被显示的tab被删除时)
在恢复被撤下的tab时一直会恢复到可显示区域被填满位置,恢复时从宽度最小的被撤下tab开始
*/
eweaverTabs.prototype.restoreTabOfWithdrawWhenDeleteTab = function(){
	if(this.withdrawTabContainer.length == 0){
		return;
	}
	var freeTabWidth = this.getFreeTabWidth();	//获取空闲的tab宽度 
	var minWidthTab = this.getMinWidthTabOfWithdraw();
	if(minWidthTab.width <= freeTabWidth){
		this.restoreTabOfWithdraw(minWidthTab);
		this.hideMoreElementIfNoWithdrawTab();
		this.restoreTabOfWithdrawWhenDeleteTab();	//递归恢复被撤下的tab(如果宽度足够的话)
	}
}
/*在所有被撤下的tab中获取宽度最小的tab*/
eweaverTabs.prototype.getMinWidthTabOfWithdraw = function(){
	var minWidth = -1;
	var minIndex = -1;
	for(var i = 0; i < this.withdrawTabContainer.length; i++){
		var w = this.withdrawTabContainer[i].width;
		if(i == 0){
			minWidth = w;
			minIndex = i;
		}else if(w < minWidth){
			minWidth = w;
			minIndex = i;
		}
	}
	if(minIndex != -1){
		return this.withdrawTabContainer[minIndex];
	}else{
		return null;
	}
}
/*清除tabId中的特殊字符*/
eweaverTabs.prototype.removeTabidSpecialChar = function(tabId){
	tabId = tabId.ReplaceAll("\\.", "");	//将id中的.替换掉
	tabId = tabId.ReplaceAll("-", "");	//将id中的-替换掉
	tabId = tabId.ReplaceAll("\\(", "");	//将id中的(替换掉
	tabId = tabId.ReplaceAll("\\)", "");	//将id中的)替换掉
	tabId = tabId.ReplaceAll(" ", "");	//将id中的空格替换掉
	tabId = tabId.ReplaceAll("=", "");	//将id中的等号替换掉
	tabId = tabId.ReplaceAll(",", "");	//将id中的逗号替换掉
	tabId = tabId.ReplaceAll("&", "");	//将id中的&号替换掉
	tabId = tabId.ReplaceAll("#", "");	//将id中的#号替换掉
	tabId = tabId.ReplaceAll("@", "");	//将id中的@号替换掉
	return tabId;
}
/*保存或者改变指定id的tab在顺序集中的位置*/
eweaverTabs.prototype.saveOrChangeTabOpenOrder = function(tabId){
	var index = this.getTabidIndexFromTabOpenDisorderContainer(tabId);
	if(index == -1){	//不存在,则添加到末尾
		this.tabOpenDisorderContainer.push(tabId);
	}else{	//存在,删除后添加到末尾
		this.tabOpenDisorderContainer.splice(index, 1);
		this.tabOpenDisorderContainer.push(tabId);
	}
}
/*获取打开或选中当前tab页之前被选中的tab的id*/
eweaverTabs.prototype.getPrevOpenedTabid = function(){
	if(this.tabOpenDisorderContainer.length != 0){
		return this.tabOpenDisorderContainer[this.tabOpenDisorderContainer.length - 1];
	}
	return "";
}
/*从顺序集中删除指定id的tab*/
eweaverTabs.prototype.deleteTabidFromTabOpenDisorderContainer = function(tabId){
	var removeIndex = this.getTabidIndexFromTabOpenDisorderContainer(tabId);
	if(removeIndex != -1){
		this.tabOpenDisorderContainer.splice(removeIndex, 1);
	}
}
/*获取指定id的tab在顺序集中的索引位置*/
eweaverTabs.prototype.getTabidIndexFromTabOpenDisorderContainer = function(tabId){
	var index = -1;
	for(var i = 0; i < this.tabOpenDisorderContainer.length; i++){
		if(this.tabOpenDisorderContainer[i] == tabId){
			index = i;
			break;
		}
	}
	return index;
}
/*创建Tab页*/
eweaverTabs.prototype.createTab = function(tabId, tabName, tabUrl, closeable, expandable, expandCallback, icon, onCloseCallbackFn){

	if(!tabId){
		tabId = this.getRandomTabid();
	}
	
	tabId = this.removeTabidSpecialChar(tabId);//清除tabId中的特殊字符
	
	if(this.isInTabHeader(tabId)){
		this.selectTab(tabId);
		var t = this.getTabById(tabId);
		if(t.tabUrl != tabUrl){	//虽然打开的是同一个id的tab页，但是url有变化,此时用新的url刷新iframe
			var iframeId = getIframeIdByTabid(tabId);
			document.getElementById(iframeId).src = tabUrl;
			t.tabUrl = tabUrl;
		}
		return;
	}else if(this.isInTabWithdraw(tabId)){
		var t = this.getTabById(tabId);
		this.restoreTabOfWithdraw(t);	//恢复被撤下的tab
		return;
	}
	
	var tabShowName; 
	if(tabName.length > this.tabTitleMaxLength){
		tabShowName = tabName.substring(0, this.tabTitleMaxLength) + "...";
	}else{
		tabShowName = tabName;
	}
	var tab = new eweaverTab(tabId, tabName, tabUrl, closeable, expandable, expandCallback, icon, tabShowName, onCloseCallbackFn);
	
	/*创建tab页头部*/
	this.createTabHeader(tab);
	
	/*创建内容区域iframe*/
	$('#' + this.contentPanel + " iframe").css("display","none"); //先隐藏所有的iframe
	var iframeId = getIframeIdByTabid(tabId);
	showLoadingDiv(); //显示页面加载中
	/*改变页面的高度为页面加载时的初始高度,因为如果新建的页面中如果包含ext相关的元素,此时这些元素会使用百分比进行高宽设置，那么可能存在以下情况:
	  当第一个打开的页面高度为900时,第二个打开的页面如果包含ext相关的元素则会使用百分比高宽设置，会导致该页面的高度也会和第一个打开的页面的高度一样，
	 可能它本身并不需要这么高的高度。
	*/
	changeBodyHeightToInitialHeight();
	$('#' + this.contentPanel).append("<iframe src='"+tabUrl+"' class='contentFrame' frameborder='0' id='"+iframeId+"'></iframe>");
	//iframe加载完成之后
	bindFunWhenIframeOnloadById(iframeId, function(){
		hideLoadingDiv();//隐藏页面加载中
		resizeBodyHeightWithIframeCreate(iframeId);//在iframe创建时改变页面的高度
		//showOrHideContractionOrExpand(iframeId);	//显示或隐藏    控制展开或收缩的div
	});	
	
	tab.width = $("#li" + tabId).outerWidth(true);
	this.tabContainer.push(tab);
	this.tabIdContainer.push(tabId);
	
	this.saveOrChangeTabOpenOrder(tabId);
	
	this.currentTabid = tabId;
	
	/*从前面撤下tab,如果tab总宽度超出了tab容器宽度*/
	this.withdrawTabIfOuterOfWidth();
};
eweaverTabs.prototype.createTabHeader = function(tab){
	var tabId = tab.tabId;
	var tabName = tab.tabName;
	var closeable = tab.closeable;
	var expandable = tab.expandable;
	var expandCallback = tab.expandCallback;
	var icon = tab.icon;
	var tabShowName = tab.tabShowName;
	
	var tip = "";
	if(tabShowName != tabName){
		tip = tabName;
	}
	
	$('#' + this.tabPanel + " ul li a").removeClass("tabselected");	
	var tabHtml = "<li id='li"+tabId+"'><a class=\"tabselected\" href=\"javascript:void(0);\" id='"+tabId+"' title='"+tip+"'><div class=\"pad\"></div><p onclick=\"javascript:eweaverTabs.selectTab('"+tabId+"');\" onmouseover=\"$('#"+tabId+" p .tabclose').css('display','inline');\" onmouseout=\"$('#"+tabId+" p .tabclose').css('display','none');\">"
	if(icon){
		tabHtml += "<span class=\"tabicon\"><img src=\""+icon+"\"/></span>";
	}
	if(closeable){
		tabHtml += "<span class=\"tabclose\" onclick=\"javascript:eweaverTabs.deteleTab('"+tabId+"');\"></span>";
	}
	tabHtml += "<label class=\"tabname\">" + tabShowName + "</label>";
	if(expandable){
		tabHtml += "<span class=\"tabexpand\"></span>";
	}
	tabHtml += "</p></a></li>";
	
	$('#' + this.tabPanel + ' ul > li:last-child').before(tabHtml);  
	
	if(expandable && expandCallback){
		$("#" + tabId + " .tabexpand").bind("click",{'tabId':tabId},expandCallback);
	}
	
	//绑定双击关闭事件
	if(closeable){
		$("#" + tabId).bind("dblclick",function(){
			eweaverTabs.deteleTab(tabId);
		});
	}
	
	addTabRightMenuContent(tabId, tabShowName);
	buildTabRightMenu(tabId);	//构建tab右键菜单
}
/*选中tab页*/
eweaverTabs.prototype.selectTab = function(tabId){
	if(tabId == this.currentTabid){	//点击的tab页是当前tab页,不做任何操作
		return;
	}
	
	var hasFrame = false;
	var iframeId = getIframeIdByTabid(tabId);
	$('#' + this.contentPanel + " iframe").each(function(i){
   		if(this.id == iframeId){
			hasFrame = true;
			return;
		}
 	});
	
	if(!hasFrame){	//没有该frame，直接返回，解决 firefox点击删除tab会先持续删除，然后同时会执行选中本身的问题。
		return;
	}
	
	$('#' + this.currentTabid).removeClass("tabselected");
	$('#' + tabId).addClass("tabselected");
	
	var currentIframeId = getIframeIdByTabid(this.currentTabid);
	$('#' + currentIframeId).css("display","none");
	$('#' + iframeId).css("display","block");
	resizeBodyHeightWithIframe(iframeId, true);
	
	this.saveOrChangeTabOpenOrder(tabId);
	
	this.currentTabid = tabId;
	
	addCurrentSelectedStyleToTabRightMenu(tabId);
};
eweaverTabs.prototype.onDeleteIframe = function(iframeId){
	//禁用掉关闭的tab页面的附件
	var iframeWindow = getIFrameWindowById(iframeId);
	if(iframeWindow && typeof(iframeWindow.destroyAllMultiUploadObj) == "function"){
		iframeWindow.destroyAllMultiUploadObj();
	}
};
/*删除tab页*/
eweaverTabs.prototype.deteleTab = function(tabId){
	if(!tabId){
		return;
	}
	
	var tab = this.getTabById(tabId);
	if(tab.onCloseCallbackFn && typeof(tab.onCloseCallbackFn) == "function"){
		try{
			tab.onCloseCallbackFn();
		}catch(e){
		}
	}
	
	var removeIndex = -1;
	$('#' + this.tabPanel + " ul li a").each(function(i){
   		if(this.id == tabId){
			removeIndex = i;
			return;
		}
 	});
 	
 	var iframeId = getIframeIdByTabid(tabId);
 	$('#' + this.tabPanel + " ul").find("#li" + tabId).remove();
 	this.onDeleteIframe(iframeId);
 	$('#' + this.contentPanel).find("#" + iframeId).remove();
	
	this.tabContainer.splice(removeIndex, 1);
	this.tabIdContainer.splice(removeIndex, 1);
	this.deleteTabidFromTabOpenDisorderContainer(tabId); 
	
	if(tabId == this.currentTabid  && this.tabIdContainer.length != 0){	//当删除的tab页是当前的tab页时,选中其他tab页
		var prevOpenedTabid = this.getPrevOpenedTabid();
		if(prevOpenedTabid != "" && this.hasTab(prevOpenedTabid)){	//上一个打开的tab页id不为空，并且同时存在此tab时,选中此tab页
			this.selectTab(prevOpenedTabid);
		}else{
			var selectTabidIndex;
			if(removeIndex == this.tabIdContainer.length){	//删除的是最后一个tab页,则向前选中其他tab页
				selectTabidIndex = removeIndex - 1;
			}else{	//向后选中其他tab页(此时removeIndex的位置已经由其后的一个tab页填充)
				selectTabidIndex = removeIndex;
			}
			this.selectTab(this.tabIdContainer[selectTabidIndex]);
		}
	}
	
	this.restoreTabOfWithdrawWhenDeleteTab();	//恢复被撤下的tab
	
	deleteTabRightMenuContent(tabId);
}
/*删除多个tab页,tabIds可以是一个数组集*/
eweaverTabs.prototype.deteleTabs = function(tabIds){
	for(var i = 0; i < tabIds.length; i++){
		var tabId = tabIds[i];
		if(this.isInTabHeader(tabId)){
			this.deteleTab(tabId);
		}else if(this.isInTabWithdraw(tabId)){
			this.deteleWithdrawTab(tabId);
		}
	}
}

/**
 * 点击滚屏按钮滑动门户,并设置滚屏按钮的CSS。
 */
eweaverTabs.prototype.portalTabSlide = function(ele, tabId){
	var dots = ele.parentNode.childNodes;
	var dotTarget = ele.getAttribute('dotid');

	if(dotCurrent==dotTarget){
		return false;
	}
	for(var i=0;i<dots.length;i++){
		if(dots[i].getAttribute('dotid')==dotTarget){
			//dots[i].setAttribute('className', 'portalTabDot active');
			dots[i].innerText = dotTarget;
		}else{
			//dots[i].setAttribute('className', 'portalTabDot');
			dots[i].innerText = '';
		}
	}

	var w = $('#Portal')[0].contentWindow;
	w.slidePortal(dotTarget);
	w.document.body.focus();
	
	dotCurrent = dotTarget;
}

eweaverTabs.prototype.changeTabname = function(tabId, tabName){
	var tab = this.getTabById(tabId);
	var tabShowName; 
	if(tabName.length > this.tabTitleMaxLength){
		tabShowName = tabName.substring(0, this.tabTitleMaxLength) + "...";
	}else{
		tabShowName = tabName;
	}
	tab.tabName = tabName;
	tab.tabShowName = tabShowName;
	
	var tip = "";
	if(tabShowName != tabName){
		tip = tabName;
	}
	
	var $tabHeader = $("#"+tabId, $("#"+this.tabPanel));
	$tabHeader.attr("title", tip);
	$tabHeader.find("p .tabname").text(tabShowName);
	
	/*从前面撤下tab,如果tab总宽度超出了tab容器宽度*/
	this.withdrawTabIfOuterOfWidth();
};