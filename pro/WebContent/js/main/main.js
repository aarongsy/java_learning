var portalTabId = "tabPortal";
var $portalMenuContainer;//门户下拉菜单(jQuery对象)
var bodyInitialHeight;	//页面初始高度
var menuInitialHeight;	//菜单初始高度
var headerInitialHeight;//顶部初始高度
var contentInitialHeight; //内容区域初始化高度
$(function(){
	buildTopMenu();
	resetTopMenuWidthAndBindPrevNextEvent();
	bindHeaderOptBtnClickHandler();
	$("#searchtype").CRselectBox();
	$(document.body).bind('click',hideAllPopupDIv);
	
	bodyInitialHeight = $(document.body).height();	//初始化页面初始高度
	contentInitialHeight = $(document.body).height() - $("#header").outerHeight();

	positionLoadingDiv();
	//创建门户Tab
	onTabUrl("/portal.jsp", currentPortalTabName, portalTabId, false, true, function(event){
		controlPortalMenuDisplay();
	}, "/images/attach2.gif");
	
	if($("#defaultPMenuId").val() != ''){
		initLeftMenuTree($("#defaultPMenuId").val(), true);
	}
	
	//调帐浏览器窗口大小时触发，如最大化等
	$(window).resize(function(){
		if(currentSysModeIsSoftware()){	//软件模式下
			$(document.body).height($(window).height());
			resizeOrPositionElement();
		}else if(currentSysModeIsWebsite()){	//网站模式下
			if($(window).height() > $(document.body).height()){
				$(document.body).height($(window).height());
				resizeOrPositionElement();
			}
		}else{
			//nothing to do
		}
	});
	
	resizeOrPositionElement();
	
	if(currentSysModeIsSoftware()){	//软件模式下
		doLayout();
	}
	
	doMenuCycle();
	
	contractionOrExpand();	/*展开或者收缩(左侧菜单和头部)*/
	
	menuInitialHeight = $("#menu").height();	//初始化菜单初始高度
	headerInitialHeight = $("#header").height();	//初始化顶部初始高度
	
	showOrHideContractionOrExpand();
	
	$portalMenuContainer = $("#portalMenuContainer"); 
	$portalMenuContainer.mouseleave(function(){	//门户下拉菜单鼠标移出时隐藏
		$(this).hide();
	});
	if($("#isHideMainPageLeft").val() == '1'){	//隐藏首页左侧区域
		$("#rightDiv .levelSplit").click();
	}
	
	doSomeElementAddClassWhenMouseover();
	
});

function doSomeElementAddClassWhenMouseover(){
	addClassWhenMouseover("#header .optButton ul li","mouseover");
	addClassWhenMouseover("#header .optButton ul li span.rtx","rtx_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.sign","sign_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.changePwd","changePwd_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.setSkin","setSkin_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.activeXTest","activeXTest_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.refresh","refresh_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.exit","exit_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.about","about_mouseover");
	addClassWhenMouseover("#header .optButton ul li span.ocs","ocs_mouseover");
	
	$("#header .optButton ul li span").qtip({
		content: {
			attr : 'title'
		},
		position: {
			my: 'top center', 
      		at: 'bottom center',
      		adjust : {
      			x: 0,
      			y: 5
      		}
		},
		style: {
			classes: 'optButtonQtip'
		},
		show: {
            effect: function() {
                $(this).fadeTo(500, 1);
            }
        }
	});
}
function addClassWhenMouseover(selector, className){
	$(selector).mouseover(function(){
		$(this).addClass(className);
	});
	
	$(selector).mouseout(function(){
		$(this).removeClass(className);
	});
}

/*构建tab页右键菜单*/
function buildTabRightMenu(tabId){
	$("#" + tabId).contextMenu({
		menu: 'tabRightMenu'
	}, function(action, el, pos) {
		if(action == "close"){	//关闭
			eweaverTabs.deteleTab(tabId);
		}else if(action == "closeOthers"){	//关闭其它选项卡
			var othersCanClosedTabIds = eweaverTabs.getOthersCanClosedTabIds(tabId);
			eweaverTabs.deteleTabs(othersCanClosedTabIds);
		}else if(action == "closeAll"){	//关闭所有选项卡
			var allCanClosedTabIds = eweaverTabs.getAllCanClosedTabIds();
			eweaverTabs.deteleTabs(allCanClosedTabIds);
		}else if(action == "refresh"){	//刷新
			eweaverTabs.refreshTab(tabId);
		}else if(action.indexOf("selectTab_") != -1){	//选择已打开的tab页
			var selectTabId = action.substring(action.indexOf("selectTab_") + "selectTab_".length, action.length);
			if(eweaverTabs.isInTabHeader(selectTabId)){
				eweaverTabs.selectTab(selectTabId);
			}else if(eweaverTabs.isInTabWithdraw(selectTabId)){
				var selectTab = eweaverTabs.getTabById(selectTabId);
				eweaverTabs.restoreTabOfWithdraw(selectTab);
			}
		}
	});
	
	$("#" + tabId).mousedown(function(e){
		if(e.which == 3){ // 鼠标右键单击事件
			//首先启用有可能被禁用的菜单,因为不同的tab页使用的是一个tabRightMenu,这样可以避免互相影响
			$('#tabRightMenu').enableContextMenuItems('#close,#closeOthers,#closeAll');	
			
			var disableMenuItems = "";	//需要被禁用的右键菜单
			
			var tab = eweaverTabs.getTabById(tabId);
			if(!tab.closeable){	//该tab页不能被关闭,禁用掉关闭按钮
				disableMenuItems += "#close,"; 
			}
			var othersCanClosedTabIds = eweaverTabs.getOthersCanClosedTabIds(tabId);
			//alert(othersCanClosedTabIds.length);
			if(othersCanClosedTabIds.length == 0){	//没有其他可以关闭的tab页
				disableMenuItems += "#closeOthers,"; 
			}
			var allCanClosedTabIds = eweaverTabs.getAllCanClosedTabIds();
			if(allCanClosedTabIds.length == 0){	//在所有的tab页中没有可以关闭的tab页
				disableMenuItems += "#closeAll,"; 
			}
			
			if(disableMenuItems != ""){
				disableMenuItems.substring(0, disableMenuItems.length - 1);
			}
			$('#tabRightMenu').disableContextMenuItems(disableMenuItems);
		}
	});
}

/*在tab页的右键菜单中添加内容*/
function addTabRightMenuContent(tabId, tabName){
	var rightMenuSelectTabs = $("#tabRightMenu li.selectTab");
	if(rightMenuSelectTabs.size() == 0){
		$("#tabRightMenu").append("<li class=\"selectTab separator\" id=\"selectTab_"+tabId+"\"><a href=\"#selectTab_"+tabId+"\">"+tabName+"</a></li>");
	}else{
		if($("#tabRightMenu").find("#selectTab_" + tabId).size() == 0){
			$("#tabRightMenu").append("<li class=\"selectTab\" id=\"selectTab_"+tabId+"\"><a href=\"#selectTab_"+tabId+"\">"+tabName+"</a></li>");
		}
	}
	
	addCurrentSelectedStyleToTabRightMenu(tabId);
}

function deleteTabRightMenuContent(tabId){
	$("#tabRightMenu").find("#selectTab_" + tabId).remove();
}

function addCurrentSelectedStyleToTabRightMenu(tabId){
	var rightMenuSelectTabs = $("#tabRightMenu li.selectTab");
	rightMenuSelectTabs.removeClass("currentSelect");
	$("#tabRightMenu").find("#selectTab_" + tabId).addClass("currentSelect");
}

/*构建顶部下拉菜单*/
function buildTopMenu(){
	$("#header .topMenu").buildMenu({
		//菜单构建时请求的url,支持逐级异步构建,每次会传递当前菜单的id,参数名称为menuId
        template:"/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getmenuhtmlformbmenu",	
        additionalData:"pippo=1",
        openOnRight:false,
        menuSelector: ".topMenuContainer",
        iconPath:"",		//菜单图片根路径
        hasImages:true,		//是否有图片
        fadeInTime:0,		//渐显的时间
        fadeOutTime:0,	//渐隐的时间
        adjustLeft:2,
        minZindex:"auto",
        adjustTop:10,
        opacity:.95,
        shadow:false,
        shadowColor:"#ccc",
        hoverIntent:2,
        submenuHoverIntent:1,
        openOnClick:true,		//是否点击打开
        closeOnMouseOut:true,	//鼠标离开时是否关闭
        closeAfter:150			//关闭延迟时间
      });
}

/*重置顶部菜单的宽度并且如果顶部菜单的宽度超过了最大宽度时添加左右滚动元素并处理相应事件*/
function resetTopMenuWidthAndBindPrevNextEvent(){
	var $topMenuTable = $(".rootVoices");
	var $topMenuTds = $(".rootVoices td.rootVoice");
	
	var tar;
	for(var i = 0; i < document.styleSheets.length; i++){
		var h = document.styleSheets[i].href;
		if(h && h.match(/\/skins\/.*\/main.css/i) != null){
			tar = document.styleSheets[i];
			break;
		}
	}
	
	if(!tar){return;}
	
	var rss = tar.cssRules ? tar.cssRules : tar.rules; 
	var value;
	for(var i = 0; i < rss.length; i++) 
	{ 
		var style = rss[i]; 
		if(style.selectorText.toLowerCase() == ".rootVoices td.rootVoice".toLowerCase()) 
		{ 
			value = style.style["width"]; 
		} 
	}
	
	var topMenuTdWidth = value.replace(/\D/g, ""); //提取数字，替换掉px之类的单位
	$topMenuTable.width(topMenuTdWidth * $topMenuTds.size());
	
	var $topMenuDiv = $("#header .topMenu");
	
	if($topMenuTable.outerWidth(true) > $topMenuDiv.outerWidth(true)){
		var $topMenuPrev = $("#topMenuPrev");
		var $topMenuNext = $("#topMenuNext");
		$topMenuPrev.css("display", "block");
		$topMenuNext.css("display", "block");
		
		var moveWidth = 0;
		var moveSizeOfOnce = $topMenuDiv.outerWidth(true);
		$topMenuPrev.click(function(){
			if(moveWidth >= 0){
				return;
			}
			moveWidth = moveWidth + moveSizeOfOnce;
			$topMenuTable.animate({left: moveWidth + 'px'}, "normal");
		});
		
		$topMenuNext.click(function(){
			//$topMenuTable.css("position","absolute");
			if(Math.abs(moveWidth - moveSizeOfOnce) >= $topMenuTable.outerWidth(true)){
				return;
			}
			moveWidth = moveWidth - moveSizeOfOnce;
			$topMenuTable.animate({left: moveWidth + 'px'}, "normal");
		});
	}
}

//为顶部的操作按钮绑定单击处理程序
function bindHeaderOptBtnClickHandler(){
	$("#header .optButton .changePwd").bind("click", function(){	//密码修改
		var currentUserId = $("#currentUserId").val();
		var url = '/base/security/sysusermodify.jsp?mtype=1&objid=' + currentUserId;
		onTabUrl(url, "密码修改", "tab64395d76e8274b45847321f1524536a1", true);
	});
	
	$("#header .optButton .activeXTest").bind("click", openActiveXDialog);	//插件检测
	$("#header .optButton .setSkin").bind("click", openSkinChooseDialog);	//皮肤设置
	$("#header .optButton .refresh").bind("click", function(){	//刷新
		eweaverTabs.refreshCurrentTab();
	});
	$("#header .optButton .about").bind("click", openwinlics); //关于
	$("#header .optButton .exit").bind("click", logOff);	//退出
}
var isShowLeftMenu = true;
var isShowTop = true;
//显示或隐藏    控制展开或收缩的div
function showOrHideContractionOrExpand(){
	var levelTimOutObjs = new Array();		//存放定时隐藏水平折叠对象的对象集
	var verticalTimOutObjs = new Array();	//存放定时隐藏垂直折叠对象的对象集
	
	//为水平和垂直折叠元素的标记元素绑定鼠标事件(水平和垂直折叠的显示隐藏主要依靠这两个标记元素来实现)
	var $levelSplitFlag = $("#rightDiv .levelSplitFlag");
	var $verticalSplitFlag = $("#rightDiv .verticalSplitFlag");
	$levelSplitFlag.bind("mouseover",function(){
		//alert(2);
		clearAllLevelTimOutObjs();
		levelMouseOver();
	});
	$verticalSplitFlag.bind("mouseover",function(){
		clearAllVerticalTimOutObjs();
		verticalMouseOver();
	});
	
	$levelSplitFlag.bind("mouseout",function(e){
		setLevelSplitHideWidthDelay(2000);
	});
	
	$verticalSplitFlag.bind("mouseout",function(e){
		setVerticalSplitHideWidthDelay(2500);
	});
	
	//为水平和垂直折叠元素绑定鼠标事件
	var $levelSplit = $("#rightDiv .levelSplit");
	$levelSplit.bind("mouseover",clearAllLevelTimOutObjs);
	$levelSplit.bind("mouseout",function(){
		setLevelSplitHideWidthDelay(500);
	});
	
	var $verticalSplit = $("#rightDiv .verticalSplit");
	$verticalSplit.bind("mouseover",clearAllVerticalTimOutObjs);
	$verticalSplit.bind("mouseout",function(e){
		setVerticalSplitHideWidthDelay(500);
	});
	
	//清空存放 "定时隐藏水平折叠对象的" 对象集,并会依次取消所有对象的定时执行
	function clearAllLevelTimOutObjs(){
		//alert(levelTimOutObjs.length);
		for(var i = 0; i < levelTimOutObjs.length; i++){
			clearTimeout(levelTimOutObjs[i]);
		}
		levelTimOutObjs = [];
	}
	
	//清空存放 "定时隐藏垂直折叠对象的" 对象集,并会依次取消所有对象的定时执行
	function clearAllVerticalTimOutObjs(){
		for(var i = 0; i < verticalTimOutObjs.length; i++){
			clearTimeout(verticalTimOutObjs[i]);
		}
		verticalTimOutObjs = [];
	}
	
	//设置水平折叠元素在多少毫秒后隐藏
	function setLevelSplitHideWidthDelay(delayTimes){
		clearAllLevelTimOutObjs();
		var t = setTimeout(function(){
			levelMouseOut();
		},delayTimes);
		levelTimOutObjs.push(t);
	}
	
	//设置垂直折叠元素在多少毫秒后隐藏
	function setVerticalSplitHideWidthDelay(delayTimes){
		clearAllVerticalTimOutObjs();
		var t = setTimeout(function(){
			verticalMouseOut();
		},delayTimes);
		verticalTimOutObjs.push(t);
	}
}
function verticalMouseOver(){
	if(isShowTop){
		$("#rightDiv .verticalSplit").addClass("verticalSplit_Contraction");
	}else{
		$("#rightDiv .verticalSplit").addClass("verticalSplit_Expand");
	}
	$("#rightDiv .verticalSplit").show();
}
function verticalMouseOut(){
	if(isShowTop){
		$("#rightDiv .verticalSplit").removeClass("verticalSplit_Contraction");
	}else{
		$("#rightDiv .verticalSplit").removeClass("verticalSplit_Expand");
	}
	$("#rightDiv .verticalSplit").hide();
}
function levelMouseOver(){
	if(isShowLeftMenu){
		$("#rightDiv .levelSplit").addClass("levelSplit_Contraction");
	}else{
		$("#rightDiv .levelSplit").addClass("levelSplit_Expand");
	}
	$("#rightDiv .levelSplit").show();
}
function levelMouseOut(){
	if(isShowLeftMenu){
		$("#rightDiv .levelSplit").removeClass("levelSplit_Contraction");
	}else{
		$("#rightDiv .levelSplit").removeClass("levelSplit_Expand");
	}
	$("#rightDiv .levelSplit").hide();
}
/*展开或者收缩(左侧菜单和头部)*/
function contractionOrExpand(){
	$("#rightDiv .levelSplit").bind("click",function(){
		if(isShowLeftMenu){
			$("#menuTD").hide(0,function(){
				$("#rightTD").css("width","100%");
				$("#rightDiv .levelSplit").removeClass("levelSplit_Contraction");
				$("#rightDiv .levelSplit").addClass("levelSplit_Expand");
				
				resizeOrPositionElement();
			});
			isShowLeftMenu = false;
		}else{
			$("#menuTD").show(0,function(){
				$("#rightDiv .levelSplit").removeClass("levelSplit_Expand");
				$("#rightDiv .levelSplit").addClass("levelSplit_Contraction");
				resizeOrPositionElement();
			});
			isShowLeftMenu = true;
		}
	});
	
	$("#rightDiv .verticalSplit").bind("click",function(){
		if(isShowTop){
			$("#header").hide(0,function(){
				$("#header").height(0);
				$("#rightDiv .verticalSplit").removeClass("verticalSplit_Contraction");
				$("#rightDiv .verticalSplit").addClass("verticalSplit_Expand");
				resizeOrPositionElement();
			});
			isShowTop = false;
		}else{
			$("#header").height(headerInitialHeight);
			$("#header").show(0,function(){
				$("#rightDiv .verticalSplit").removeClass("verticalSplit_Expand");
				$("#rightDiv .verticalSplit").addClass("verticalSplit_Contraction");
				resizeOrPositionElement();
			});
			isShowTop = true;
		}
	});
}
/*在指定的iframe加载完成之后绑定操作方法(通过Id)*/
function bindFunWhenIframeOnloadById(iframeId, callbackFunction){
	var iframe = document.getElementById(iframeId);
	bindFunWhenIframeOnloadByElement(iframe, callbackFunction);
}
/*在指定的iframe加载完成之后绑定操作方法(通过iframe对象)*/
function bindFunWhenIframeOnloadByElement(iframeElement, callbackFunction){
	if (iframeElement.attachEvent){    
		iframeElement.attachEvent("onload", callbackFunction);
	}else { 
		iframeElement.onload = callbackFunction;
	}
}
/*显示页面加载的div*/
function showLoadingDiv(){
	$("#rightDiv .loading").show();
}
/*隐藏页面加载的div*/
function hideLoadingDiv(){
	$("#rightDiv .loading").hide();
}
/*显示菜单加载的div*/
function showMenuLoadingDiv(){
	$("#menuCenter .menuLoading").show();
}
/*隐藏菜单加载的div*/
function hideMenuLoadingDiv(){
	$("#menuCenter .menuLoading").hide();
}
/*对加载的div的定位进行调整*/
function positionLoadingDiv(){
	var contentWindwHeight = $(window).height() - $("#header").outerHeight();
	$("#rightDiv .loading").css("top",((contentWindwHeight - $("#rightDiv .loading").outerHeight()) / 2) - 100 + "px");
	$("#rightDiv .loading").css("left",(($("#rightDiv").outerWidth() - $("#rightDiv .loading").outerWidth()) / 2) + "px");
}
/*获取指定id的iframe的document对象*/
function getIFrameDocument(frameId){
	if(document.getElementById(frameId) && document.getElementById(frameId).contentDocument){
		return document.getElementById(frameId).contentDocument;
	}else if(document.frames[frameId] && document.frames[frameId].document){
		return document.frames[frameId].document;
	}else{
		return null;
	}
	//return document.getElementById(frameId).contentDocument || document.frames[frameId].document;
}
/*改变页面的高度为页面加载时的初始高度*/
function changeBodyHeightToInitialHeight(){
	$(document.body).height(bodyInitialHeight);
}

/*根据iframe内容的高度调整main页面的高度*/
function resizeBodyHeightWithIframe(iframeId, isDoSelectTab){
	if(currentSysModeIsSoftware()){	//软件模式下
		var portalFrameId = getIframeIdByTabid(portalTabId);
		if(iframeId == portalFrameId && isDoSelectTab){	//是门户,并且是在选中tab页的时候
			//在tab页切换(并且是切换到门户)的时候,重新定位一下门户元素的位置,防止门户元素挤在一起的情况出现。
			var w = document.getElementById(portalFrameId).contentWindow;
			if(w.Light.portal.rePositionCurrentTab){
				w.Light.portal.rePositionCurrentTab();		
			}
		}
		return; //不做页面高度调整
	}
	var bootomEmptyHeight = 0;	//底部留白的高度	
	//TODO firefox下有问题
	//changeBodyHeightToInitialHeight();
	/*此处之所以还原iframe的高度是因为当一个页面的iframe撑高页面后,其他的隐藏的iframe的高度也会随之改变
	     故此处要将iframe的高度还原,然后在显示该iframe之前动态的将其高度改变以符合其应有的显示。
	    在IE下不用做此设置，但FF中就不行，故此处备注说明
	*/
	var iframeDoc = getIFrameDocument(iframeId);
	//需要重新调整页面高度的值
	if(iframeDoc && iframeDoc.body){
		iframeDoc.body.style.overflow = "hidden";
		var menuHeight = $("#menuContainer").outerHeight() + $("#menuHandler").outerHeight();
		
		var iframeHeight = iframeDoc.body.scrollHeight;
		//outerHeight() - height()等于边距值
		var contentHeight = iframeHeight + ($("#content").outerHeight() - $("#content").height());
		if(contentHeight < contentInitialHeight){	//内容区域的最小高度为页面可显示区域减去顶部的高度(忽略footer);
			contentHeight = contentInitialHeight;
		}
		
		//中间高度(取内容区域和菜单中最大的那个高度为准)
		var centerHeight = Math.max(contentHeight, menuHeight);
		var resizedBodyHeight = $("#header").outerHeight() + centerHeight + $("#footer").outerHeight();
		if(resizedBodyHeight < bodyInitialHeight){	//当需要调整的页面高度的值小于初始高度时,则使用初始高度的值
			resizedBodyHeight = bodyInitialHeight;
		}
		$("#" + iframeId).height(contentHeight - ($("#content").outerHeight() - $("#content").height()));
		$(document.body).height(resizedBodyHeight + bootomEmptyHeight);
		resizeOrPositionElement();
	}
}
/*根据iframe内容的高度调整main页面的高度(创建iframe时)*/
function resizeBodyHeightWithIframeCreate(iframeId){
	var iframeDoc = getIFrameDocument(iframeId);
	resizeBodyHeightWithIframe(iframeId, false);
}
/*根据当前tab页的iframe内容的高度调整main页面的高度
(此方法定位为被动的由子页面在内容发生变化时显式的调用来改变主页面高度)*/
function resizeBodyHeightWithCurrentTabIframe(){
	var currentTabid = eweaverTabs.getCurrentTabid();
	var iframeId = getIframeIdByTabid(currentTabid);
	resizeBodyHeightWithIframe(iframeId, false);
}
/*辅助方法,系统创建tab页时生成iframe的id均调用此方法完成*/
function getIframeIdByTabid(tabId){
	return tabId.substring(3) + "frame";
}
function showOrHideMoreTabs(){
	var t = $("#headerTabs ul li.more").offset().top; 
	var l = $("#headerTabs ul li.more").offset().left; 
	var moreT = t + $("#headerTabs ul li.more").outerHeight(true);
	var moreL;
	var tabMoreWidth = $("#tabMore").outerWidth();
	if(l < tabMoreWidth){	//显示在右边
		moreL = l;
		$("#tabMore").css("top", moreT + "px"); 
		$("#tabMore").css("left", moreL + "px"); 
	}else{	//显示在左边
		moreR = $(document.body).width() - l - $("#headerTabs ul li.more").outerWidth(true);
		$("#tabMore").css("top", moreT + "px"); 
		$("#tabMore").css("right", moreR + "px"); 
	}
	
	
	showOrHiddenPopupDIv("tabMore");
}

/*初始化tab页对象*/
var eweaverTabs = new eweaverTabs("headerTabs","content");

/*
打开新页面的方法
url:链接
title:tab页标题
id:tab页id
closeable:是否允许关闭(true允许关闭,否则 false)
expandable:点击是否可以展开
expandCallback:展开时回调的函数
icon:图标
*/
function onTabUrl(url, title, id, closeable, expandable, expandCallback, icon, onCloseCallbackFn){
	eweaverTabs.createTab(id, title, url, closeable, expandable, expandCallback, icon, onCloseCallbackFn);
}
//关闭指定id的tab页
function closeTab(tabId){
	if(!eweaverTabs.hasTab(tabId)){
		tabId = eweaverTabs.getCurrentTabid();	//不包含，则关闭当前的tab页
	}
	eweaverTabs.deteleTab(tabId);
}
//关闭指定id的tab页(仅当存在该Tab页时才执行关闭操作)
function closeTabWhenExist(tabId){
	if(eweaverTabs.hasTab(tabId)){
		eweaverTabs.deteleTab(tabId);
	}
}
//刷新指定id的tab页
function refreshTab(tabId){
	if(!eweaverTabs.hasTab(tabId)){
		tabId = eweaverTabs.getCurrentTabid();	//不包含，则刷新当前的tab页
	}
	eweaverTabs.refreshTab(tabId);
}
//刷新指定id的tab页(如果该id的tab页存在的话)
function refreshTabIfExisted(tabId){
	if(!eweaverTabs.hasTab(tabId)){
		return;
	}
	eweaverTabs.refreshTab(tabId);
}

/*打开或隐藏弹出的Div*/
function showOrHiddenPopupDIv(divId){
	var d = $('#' + divId).css('display');
	//隐藏所有的popup框,用于在多个popup框切换时打开一个时能隐藏其他所有打开的popup框
	hideAllPopupDIv();
	if(d == "block"){
		if(divId == "tabMore"){
			$('#' + divId).hide();
		}else{
			$('#' + divId).hide("normal");
		}
	}else{
		if(divId == "tabMore"){
			$('#' + divId).show();
		}else{
			$('#' + divId).show("normal");
		}
	}
}
/*隐藏所有的弹出Div*/
function hideAllPopupDIv(){
	$('#tabMore').hide();
}

/*初始化左侧菜单树(默认菜单的id和名称)*/
function initLeftMenuTree(defaultPMenuId){
	var setting = {
		view: {
			nameIsHTML: true,
			dblClickExpand: false,
			showLine: false
		},
		async: {
			enable: true,
			url:"/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getmenustrforztree",
			autoParam:["id=node"],
			otherParam: ["node", defaultPMenuId]
		},
		callback: {
			onClick: zExpandNode,
			onAsyncSuccess: function(event, treeId, treeNode, msg){
				hideMenuLoadingDiv();
				changeTreeButton2Img();
				//还原滚动条和滚动内容到顶部
				$("#menuCenter .dragger").css("top","0px");
				$("#menuCenter .customScrollBox .container").css("top","0px");
				
				addClassWhenMouseover(".ztree li", "mouseover");
				
				$(".ztree li a").bind("mouseover", function(){
					$(this).parent().removeClass("noover");
					
					$('.ztree li a:not(#'+this.id+')').each(function(i){
						if(!$(this).hasClass("curSelectedNode")){	//当前选中节点除外
							$(this).parent().addClass("noover");
						}
					});
					
				});
				//alert($('.ztree li a:not(#'+this.id+')').parent().height());
				var bodyHeight = $(document.body).height();
				var headerHeight = $("#header").outerHeight();
				var menuHeight = $("#menuContainer").outerHeight() + $("#menuHandler").outerHeight();
				var footerHeight = $("#footer").outerHeight();
				if((menuHeight + headerHeight + footerHeight) > bodyHeight){
					$(document.body).height(menuHeight + headerHeight + footerHeight);
					resizeOrPositionElement();
				}
			}
		}
	};
	
	/**
	 * 把ztree前面的button换为img
	 * @return
	 */
	function changeTreeButton2Img(){
		$(".ztree li .ico_docu,.ico_close,.ico_open").each(function(){
				if(this.style.display!="none"){
					var src = this.style.backgroundImage;
					if(src.indexOf("url(")!=-1){
						if(!isFireFox2()){
							src = src.substring(4,src.length-1);
						}else{
							src = src.substring(5,src.length-2);
						}
					}
					if(this.nextSibling.tagName!="IMG"){
						$(this).after("<img width='17px' style='background-color:transparent;' height='17px' class='x-tree-node-icon x-tree-node-inline-icon' src="+src+" />");
					}
					$(this).hide();
				}
		 });
	}
	
    function isFireFox2(){
      var i2=navigator.userAgent.toLowerCase().indexOf("firefox");
      return i2>=0;
    }
	
	function zExpandNode(e,treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("leftMenuTree");
		zTree.expandNode(treeNode);
		$('.ztree a:not(.curSelectedNode)').parent().removeClass("ztreeNodeBgColor");
		$('.ztree a:not(.curSelectedNode)').parent().addClass("noover");
		$('.ztree .curSelectedNode').parent().addClass("ztreeNodeBgColor");
	}
	
	showMenuLoadingDiv();
	$.fn.zTree.init($("#leftMenuTree"), setting);
	
	addStyleToCheckedBottomMenu(defaultPMenuId);
}
/*改变左侧菜单树的数据*/
function changeLoadLeftMenuTreeData(pid){
	showMenuLoadingDiv();
	var leftMenuTree = $.fn.zTree.getZTreeObj("leftMenuTree");
	leftMenuTree.setting.async.otherParam = ["node",pid];
	leftMenuTree.reAsyncChildNodes(null, "refresh");
	addStyleToCheckedBottomMenu(pid);
}
/*为底部一级菜单在选中时增加样式*/
function addStyleToCheckedBottomMenu(pid){
	$("#menuBottom ul li a p").removeClass("selected");
	$("#pTag" + pid).addClass("selected");
}

//main页面所有动态改变窗口大小以及动态定位的操作都在此方法中完成
function resizeOrPositionElement(){
	var bodyHeight;
	if(currentSysModeIsSoftware()){	//软件模式下
		bodyHeight = $(document.body).height();
	}else{	//网站模式
		//bodyHeight = jQuery(document.body).height();//修复打开一个新流程页面高度和之前打开的流程页面高度一样高，滚动条很长，下面全是空白
		/*以上注释的部分在网站模式取页面高度时，该高度恒定会是浏览器窗体可视区域的高度。这会导致当子页面内容超出了现有高度，从子页面调用top的resizeOrPositionElement
		来重置高度时不会起到预期的效果。故此次改为使用scrollHeight.
		*/
		bodyHeight = document.body.scrollHeight;
		if(bodyHeight < $(window).height()){
			bodyHeight = $(window).height();
		}
	}
	var headerHeight = $("#header").outerHeight();
	var footerHeight = $("#footer").outerHeight();
	//改变menu div的高度
	var menuHeight = bodyHeight - headerHeight - footerHeight;
	$("#menu").height(menuHeight);
	//改变menuContainer的高度
	if(currentSysModeIsSoftware()){	//软件模式下,对menu中的内容进行高度调整
		var menuHandlerHeight = $("#menuHandler").outerHeight();
		//$("#menuContainer").height(menuHeight - menuHandlerHeight);
		$("#menuContainer").height(menuHeight+46);
	}
	//改变content的高度
	$("#content").height(bodyHeight - headerHeight - footerHeight);
	//loading div的定位:水平居中
	positionLoadingDiv();
}

/*左侧菜单的布局*/
var menuLayout;
function doLayout(){
	var defaultSouthMinSize = 43;	//默认最小化高度
	
	var southSize = $("#menuBottom").height();	//底部高度
	var southMinSize = $("#menuBottom").css("min-height");	//底部最小高度(收缩时)
	if(southMinSize == "auto"){	//在css中未设置min-height属性,或者设置的值是的auto,此时使用默认的最小化高度替代
		southMinSize = defaultSouthMinSize;
	}else{
		southMinSize = southMinSize.replace(/\D/g, "");	//提取数字,提取之前可能有单位,如px等
		$("#menuBottom").css("min-height", "auto");	//更改min-height属性,此属性如果设置为具体的值会影响最小化时高度的正常显示
	}
	
	
	menuLayout = $('#menuContainer').layout({ 
		applyDefaultStyles: true,
		animatePaneSizing: true,
		fxSpeed: 100,
		north__spacing_open: 0,
		south__size: southSize,
		south__minSize: southMinSize
	});
	
	hideBarOfMenuTree();
	
	$("#menuCenter").hoverIntent(slideMenuDown,slideMenuUp);
	
	var menuOuterOfAreaInterval;
	
	function slideMenuUp(){
		menuLayout.sizePane('south', southSize);
		hideBarOfMenuTree();
		//鼠标移开菜单区域时，清除定时器(如果存在定时器)
		if(menuOuterOfAreaInterval){
			clearInterval(menuOuterOfAreaInterval);
			menuOuterOfAreaInterval = null;
		}
	}
	
	function slideMenuDown(){
		slideMenuDownIt();
		
		if(!menuTreeIsOuterOfArea()){	//未超出，则设置定时器监测其在操作树形的过程中是否会发生菜单区域超出
			menuOuterOfAreaInterval = setInterval(slideMenuDownIt, 500);
		}
		
		function slideMenuDownIt(){
			if(menuTreeIsOuterOfArea()){
				menuLayout.sizePane('south', southMinSize);
				setTimeout(showBarOfMenuTree, 500);
				//已收缩底部区域，则清除定时器(如果存在定时器)
				if(menuOuterOfAreaInterval){
					clearInterval(menuOuterOfAreaInterval);
					menuOuterOfAreaInterval = null;
				}
			}
		}
	}
}
/*隐藏左侧菜单树的滚动条*/
function hideBarOfMenuTree(){
	$("#menuCenter").css("overflow","hidden");
}
/*显示左侧树的滚动条*/
function showBarOfMenuTree(){
	$("#menuCenter").css("overflow","auto");
}
/*判断菜单树是否超出了显示区域*/
function menuTreeIsOuterOfArea(){
	return $("#leftMenuTree").outerHeight(true) > $("#menuCenter").height();
}

/*左侧一级菜单的切换效果*/
function doMenuCycle(){
	$('#menuBottom .levelMenu').cycle({
        fx:      'curtainY',	//过渡效果 (经试验，旁边几种效果也还可以，可以做备用: curtainY fadeZoom zoom toss turnUp) 
        //prev:    '#menuHandler .prev',
	 	next:    '#menuHandler .next',
	 	pager:   '#menuHandler .nav ul',
		speed: 200,	//幻灯片过渡的速度
		timeout: 0,	//不自动切换 
		cleartype:  true,
		pagerAnchorBuilder: pagerFactory,
		onPrevNextEvent: doPreNext,
		onPagerEvent: doPager
    });
	
	$('#menuBottom .levelMenu').cycle("pause");
	
	function pagerFactory(idx, slide) {
	   var className = "uncurrent";
	   if(idx == 0){
		   className = "current";
	   }
       return "<li class='"+className+"'></li>";
    };
    
	function doPreNext(isNext, zeroBasedSlideIndex, slideElement){
		changeNavStyle(zeroBasedSlideIndex);
	};
	
	function doPager(zeroBasedSlideIndex, slideElement){
		changeNavStyle(zeroBasedSlideIndex);
	};
	
	function changeNavStyle(currentSlideIndex){
		$("#menuHandler .nav ul li").each(function(i){
  		 	this.className = "uncurrent";
			if(i == currentSlideIndex){
				this.className = "current";
			}
 		});
	}
}




var dotCurrent = 1;

function createPDot(scrolls){
	var box = document.createElement("div");
	box.id = 'pDotBox';
	for(var i=1;i<=scrolls;i++){
		if(i==1){
			box.innerHTML += '<button class="portalTabDot active" dotid="'+i+'" id="pDot'+i+'" onclick="eweaverTabs.portalTabSlide(this)">'+i+'</button>';
		}else{
			box.innerHTML += '<button class="portalTabDot" dotid="'+i+'" id="pDot'+i+'" onclick="eweaverTabs.portalTabSlide(this)"></button>';	
		}
	}
	$('body').append(box);
}

//快捷搜索
function quickSearch(){
	var _objvalue = document.getElementById("objname").value;
	var param = $("#searchtype").val();
	var selectText = $("#searchtype_CRtext").val();
	var temparr = param.split(';');
    var reportid=temparr[0];
    var field=temparr[1];
    var viewtype=temparr[2];
    var url = "";
    if(field.indexOf(",")>-1){
        var tableName=field.substring(field.indexOf(",")+1);
        field=field.substring(0,field.indexOf(","));
        if("humres"==tableName){
            url = contextPath+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&sysmodel=1&reportid="+reportid+"&con"+field+"_value="+_objvalue;
        }else if("docbase"==tableName){
            url = contextPath+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&sysmodel=1&reportid="+reportid+"&con"+field+"_value="+_objvalue;
        }
    }else{
        url = contextPath+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase="+viewtype+"&reportid="+reportid+"&con"+field+"_value="+_objvalue;
    }
    onUrl(url,selectText,'qs'+reportid);
}

/**
 * 添加门户元素
 */
function addPortletContent(){
	var portalFrameId = getIframeIdByTabid(portalTabId);
    document.getElementById(portalFrameId).contentWindow.Light.portal.addContent();
}
            
/**
 * 打开PortalTab,并根据滚屏数调整PortalContainer的宽度。
 * @param {Object} i
 */
function openTab(i){
	var portalFrameId = getIframeIdByTabid(portalTabId);
	var pIframe = document.getElementById(portalFrameId);
	var w = pIframe.contentWindow;
	w.openTab(i);
}
/**
 * 系统管理员切换帐户
 * @param obj SysuserID
 */
function switchSysAdmin(obj) {
	window.location.href="/ServiceAction/com.eweaver.base.security.servlet.SwitchSysAdminAction?id="+obj;
}
/**
 * 打开皮肤设置的界面
 */
function openSkinChooseDialog(){
	var skinChooseFrame = document.getElementById("skinChooseFrame");
	if(!skinChooseFrame){
		$("#skinChoose").html("<iframe id=\"skinChooseFrame\" name=\"skinChooseFrame\" border=\"0\" frameborder=\"no\" style=\"width: 100%; height: 100%; border: 0px;margin: 0px; padding: 0px;\" src=\"/main/skinchoose.jsp\"></iframe>");
	}
	var h;
	if($.browser.msie){
		h = 560;
	}else{
		h = 520;
	}
	$( "#skinChoose" ).dialog({
		title: '皮肤设置',
		width: 805,
		height:h,
		buttons: {
			"关闭": function() {
				$( this ).dialog( "close" );
			}
		}
	});
}

/**
 * 打开插件检测的界面
 */
function openActiveXDialog(){
	var activeChooseFrame = document.getElementById("activeChooseFrame");
	if(!activeChooseFrame){
		$("#skinChoose").html("<iframe id=\"activeChooseFrame\" name=\"activeChooseFrame\" border=\"0\" frameborder=\"no\" style=\"width: 100%; height: 100%; border: 0px;margin: 0px; padding: 0px;\" src=\"/activeXRemind/activeXTest.jsp\"></iframe>");
	}
	var h;
	if($.browser.msie){
		h = 560;
	}else{
		h = 520;
	}
	$( "#skinChoose" ).dialog({
		title: '插件检测',
		width: 805,
		height:h,
		buttons: {
			"关闭": function() {
				$( this ).dialog( "close" );
			}
		}
	});
}
/**
 * 关闭皮肤设置的界面并跳转到指定的url
 */
function closeSkinChooseDialogAndToTargetUrl(targetUrl){
	$("#skinChoose").dialog( "close" );
	toTargetUrl(targetUrl);
}
/**
 * 原pop方法在新页面中换了个名字,还是委托调用之前的pop方法
 * 取新名字只是为了防止未定义方法时js递归依赖的时候造成混淆理解
 */
function pop_new(msg,title,showtime,icon){
	pop(msg,title,showtime,icon);
}

/**
 * 原openWin方法在新页面中换了个名字,还是委托调用之前的openWin方法
 * 取新名字只是为了防止未定义方法时js递归依赖的时候造成混淆理解
 */
function openWin_new(url, title, image, width, height) {
	openWin(url, title, image, width, height);
}

/*刷新门户流程元素*/
function refreshPortalWorkflowElement(){
	var portalFrameId = getIframeIdByTabid(portalTabId);
    var portalWindow = document.getElementById(portalFrameId).contentWindow;
    if(portalWindow && portalWindow.TabPortlet){ //刷新流程Tab元素.
    	portalWindow.TabPortlet.refreshRequestTab();
    }
    
    if(portalWindow && portalWindow.TodoWorkflowPortlet){ //刷新流程元素.
    	portalWindow.TodoWorkflowPortlet.refresh();
    }
}

/*是否使用新的首页(/main/mian.jsp 和 /mian/index.jsp 均包含此方法, 返回结果相反)*/
function isUseNewMainPage(){
	return true;
}

function leftFrame(){
	this.commonDialog = new commonDialog();
	function commonDialog(){
		this.hidden = true;
	}
	commonDialog.prototype.hide = function(){
		//nothing to do
	}
}
var leftFrame = new leftFrame();

function contentPanel(){

}
contentPanel.prototype.getActiveTab = function(){
	return eweaverTabs.getTabById(eweaverTabs.getCurrentTabid());
}
var contentPanel = new contentPanel();

