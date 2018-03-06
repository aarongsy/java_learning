var prefixes = ["MSXML2.DomDocument", "Microsoft.XMLDOM", "MSXML.DomDocument", "MSXML3.DomDocument"];
var dom;
var thumbCount = 4;
var FolderLeavings = 4;
var menuMargin = 14;

var arrayFolder;
var tbl;
var fileTD;
var rightArrow;
var handleOffsetHeight;

var currentThumbCount,currentMenuId;
var isSuccessful;
var dragging = false;

function getDomObject(){
	for (var i = 0; i < prefixes.length; i++) {
		try{
			dom = new ActiveXObject(prefixes[i]);
			if(dom){
				return dom;
			}
		}catch(e){
			//TODO;
		}
	}
}

window.onload = function(){
	//window.resizeBy(0,0);
	/*initialize*/
	getDomObject();
	getXML();
	getCookie();
	isSuccessful = createMenu();
	if(isSuccessful){
		arrayFolder = new Array();
		tbl = document.getElementById("tbl");
		fileTD = document.getElementById("fileTD");
		rightArrow = document.getElementById("rightArrow");
		if(tbl.rows.length-4>=currentThumbCount){
			for(var i=0;i<currentThumbCount;i++){delRow();}
		}
		getHandleOffsetHeight();
	}
};

window.onbeforeunload = function(){
	setCookie(currentThumbCount,currentMenuId);
};

window.onresize = function(){
	if(isSuccessful){
		//TD4861
		if(window.document.body.offsetWidth<155 && window.document.body.offsetWidth>0) parent.document.getElementById("mainFrameSet").cols = "155,*";
		getHandleOffsetHeight();
	}
};

function getHandleOffsetHeight(){
	var tblTop = 0;
	obj = tbl.rows[3];
	while(obj.tagName!="BODY"){

		tblTop += obj.offsetTop;
		obj = obj.offsetParent;
	}
	handleOffsetHeight = tblTop;
}

var ctThemeXPBase = '../images/base/ThemeXP/';

var ctThemeXP1 = {
	folderLeft: [['<img alt="" src="' + ctThemeXPBase + 'folder1.gif" />', '<img alt="" src="' + ctThemeXPBase + 'folderopen1.gif" />']],
  	folderRight: [['', '']],
	folderConnect: [[['<img alt="" src="' + ctThemeXPBase + 'plus.gif" />','<img alt="" src="' + ctThemeXPBase + 'minus.gif" />'],
					 ['<img alt="" src="' + ctThemeXPBase + 'plusbottom.gif" />','<img alt="" src="' + ctThemeXPBase + 'minusbottom.gif" />']]],
	itemLeft: ['<img alt="" src="' + ctThemeXPBase + 'page.gif" />'],
	itemRight: [''],
	itemConnect: [['<img alt="" src="' + ctThemeXPBase + 'join.gif" />', '<img alt="" src="' + ctThemeXPBase + 'joinbottom.gif" />']],
	spacer: [['<img alt="" src="' + ctThemeXPBase + 'line.gif" />', '<img alt="" src="' + ctThemeXPBase + 'spacer.gif" />']],
	themeLevel: 1
};

function loadHTML(){
	var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	//if(nodeMenubar.getAttribute("extra")!=null){
	//	return false;
	//}
	with(document.getElementById("ifrm2")){
		style.width = "0";
		style.height = "0";
	}
	with(document.getElementById("ifrm")){
		style.width = "100%";
		style.height = "100%";
		contentWindow.document.body.style.margin = "0";
		contentWindow.document.body.style.padding = "2px 0 5px 2px";
		//if(nodeMenubar.getAttribute("extra")==null){
			contentWindow.document.body.innerHTML = "<div ID='myMenuID_DIV' style='width:100%;height:100%;'></div>";
			try{
				contentWindow.ctDraw("myMenuID_DIV", eval("myMenu_"+nodeMenubar.getAttribute("id")),ctThemeXP1,'ThemeXP',0,0);
				contentWindow.ctExpandTree('myMenuID_DIV',1);
			}catch(e){
				//TODO
			}
			detachEvent("onload",loadHTML);
		//}
	}
}

function loadJSP(){
	var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	if(nodeMenubar.getAttribute("extra")==null){
		return false;
	}
	with(document.getElementById("ifrm")){
		style.width = "0";
		style.height = "0";
	}
	with(document.getElementById("ifrm2")){
		style.width = "100%";
		style.height = "100%";
		contentWindow.document.body.innerHTML = "";
		if(nodeMenubar.getAttribute("extra")=="sysset"){
			detachEvent("onload",loadJSP);
			var srcStr = "../base/menu/menusystem.jsp";
			contentWindow.location.replace(srcStr);
		}
	}
}

function createMenu(){
	var oTbl,oTR,oTD,oCurrentNode;

	oTbl = document.createElement("table");
	oTbl.id = "tbl";
	oTbl.cellSpacing = "1";
	oTbl.className = "OTTable";

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	if(dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']")==null){
		currentMenuId=0;
	}
	oCurrentNode = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	if(oCurrentNode==null) return false;
	oTD.setAttribute("menuid",oCurrentNode.getAttribute("id"));
	oTD.className = "folder";
	oTD.innerHTML = "<img src='"+oCurrentNode.getAttribute("icon")+"'/>" + oCurrentNode.getAttribute("name");

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.id = "fileTD";
	oTD.className = "file";

	var oIframe = document.createElement("iframe");
	oIframe.id = "ifrm";
	oIframe.style.width = "0";
	oIframe.style.height = "0";
	oIframe.frameBorder = "0";
	oIframe.src = "leftTree.htm";
	oIframe.attachEvent("onload",loadHTML);
	oTD.appendChild(oIframe);

	var oIframe2 = document.createElement("iframe");
	oIframe2.id = "ifrm2";
	oIframe2.style.width = "0";
	oIframe2.style.height = "0";
	oIframe2.frameBorder = "0";
	oIframe2.src = "leftTree.htm";
	oIframe2.attachEvent("onload",loadHTML);
	oTD.appendChild(oIframe2);

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.className = "handle";
	oTD.innerHTML = "<img src=\"../images/main/StyleGray/handleH.gif\" style=\"margin-top:1px\"/>";
	oTD.onmousedown = function(){mousedown();};
	oTD.onmouseup = function(){mouseup();};
	oTD.onmousemove = function(){mousemove();};

	var oNodes = dom.selectNodes("//menubar");
	for(i=0;i<oNodes.length;i++){
		oTR = oTbl.insertRow();
		oTD = oTR.insertCell();
		oTD.setAttribute("menuid",dom.selectSingleNode("//menubar["+i+"]").getAttribute("id"));
		if(dom.selectSingleNode("//menubar["+i+"]").getAttribute("id")==currentMenuId){
			oTD.className = "folderMouseOver";
		}else{
			oTD.className = "folder";
			oTD.attachEvent("onmouseover",folderMouseOver);
			oTD.attachEvent("onmouseout",folderMouseOut);
		}
		oTD.onclick = function(){slideFolder(this);};
		oTD.innerHTML = "<img src='"+dom.selectSingleNode("//menubar["+i+"]").getAttribute("icon")+"'/>" + dom.selectSingleNode("//menubar["+i+"]").getAttribute("name");
	}

	oTR = oTbl.insertRow();
	oTD = oTR.insertCell();
	oTD.id = "thumbBox";
	oTD.innerHTML = "<img id='rightArrow' src='../images/main/rArrow.gif' onclick='showFav()'/>";

	document.getElementById("divMenuBox").rows[0].cells[0].appendChild(oTbl);
	return true;
}

function folderMouseOver(){
	var o = window.event.srcElement;
	if(o.tagName!="IMG") o.className = "folderMouseOver";
}

function folderMouseOut(){
	var o = window.event.srcElement;
	if(o.tagName!="IMG") o.className = "folder";
}

function slideFolder(o){
	o.detachEvent("onmouseover",folderMouseOver);
	o.detachEvent("onmouseout",folderMouseOut);
	
	if(currentMenuId!=null && currentMenuId!=o.getAttribute("menuid")){
		if(tbl.rows[3+parseInt(currentMenuId)]!=null && (tbl.rows.length-1)!=(3+parseInt(currentMenuId))){
			tbl.rows[3+parseInt(currentMenuId)].cells[0].className = "folder";
			tbl.rows[3+parseInt(currentMenuId)].cells[0].attachEvent("onmouseover",folderMouseOver);
			tbl.rows[3+parseInt(currentMenuId)].cells[0].attachEvent("onmouseout",folderMouseOut);
		}
	}
	currentMenuId = o.getAttribute("menuid");

	var nodeMenubar = dom.selectSingleNode("//menubar[@id='"+currentMenuId+"']");
	tbl.rows[0].firstChild.innerHTML = "<img src='"+nodeMenubar.getAttribute("icon")+"'/>" + nodeMenubar.getAttribute("name");

	var oIframe = document.getElementById("ifrm");
	var oIframe2 = document.getElementById("ifrm2");
	//if(nodeMenubar.getAttribute("extra")==null){
		loadHTML();
	//}else if(nodeMenubar.getAttribute("extra")=="sysset"){
	//	loadJSP();
	//}
	setCookie(currentThumbCount,currentMenuId);
}

function mousedown(){
	el = window.event.srcElement;
	while(el.tagName!="TD"){
		el = el.parentElement;
	}
	el.setCapture();
	dragging = true;
}

function mouseup(){
	el.releaseCapture();
	dragging = false;
}

function mousemove(){
	//TD3973
	//modified by hubo,2006-03-16
	if(!dragging){	
		return false;
	}else{
		getHandleOffsetHeight();
	}

	window.event.cancelBubble = false;
	cliX = window.event.clientX;
	cliY = window.event.clientY;

	if(cliY<100) return false;
	//window.status = "handleOffsetHeight="+handleOffsetHeight;
	if(cliY>handleOffsetHeight+25 && tbl.rows.length<=FolderCount && tbl.rows.length>FolderLeavings){
		delRow();
		currentThumbCount++;
		handleOffsetHeight+=25;
	}
	if(cliY<handleOffsetHeight-25 && tbl.rows.length<FolderCount && tbl.rows.length>=FolderLeavings){
		addRow();
		currentThumbCount--;
		handleOffsetHeight-=25;
	}
	//setCookie(currentThumbCount,currentMenuId);
}

function delRow(){
	if(tbl.rows[tbl.rows.length-2].firstChild.className=="handle") return false;
	arrayFolder.push(tbl.rows[tbl.rows.length-2].firstChild.getAttribute("menuid")+"|"+tbl.rows[tbl.rows.length-2].firstChild.innerHTML);
	
	var oImg = document.createElement("img");
	oImg.setAttribute("menuid",tbl.rows[tbl.rows.length-2].firstChild.getAttribute("menuid"));
	oImg.setAttribute("menuname",tbl.rows[tbl.rows.length-2].firstChild.children[0].nextSibling.nodeValue);
	oImg.alt = tbl.rows[tbl.rows.length-2].firstChild.children[0].nextSibling.nodeValue;
	oImg.style.cursor = "hand";
	oImg.src = tbl.rows[tbl.rows.length-2].firstChild.firstChild.src;
	oImg.onclick = function(){slideFolder(this)};

	if(arrayFolder.length<=thumbCount){
		tbl.rows[tbl.rows.length-1].firstChild.insertBefore(oImg,rightArrow);
	}else{
		insertToPopupMenu(oImg);
	}

	tbl.deleteRow(tbl.rows.length-2);
}

function insertToPopupMenu(o){
	var tbl,tbl2,tr,td;
	tbl = document.createElement("table");
	tbl.cellspacing = 0;
	tbl.cellpadding = 0;
	tbl.width = "100%";
	tbl.height = "100%";
	tr = tbl.insertRow();
	td = tr.insertCell();
	td.width = 28;
	td.innerHTML = "<img src='"+o.src+"'/>";
	td = tr.insertCell();
	td.innerHTML = o.getAttribute("menuname");

	tbl2 = document.getElementById("divFavContent").firstChild.firstChild;
	tr = tbl2.insertRow();
	td = tr.insertCell();
	tr.height = 25;
	td.className = "popupMenuRow";
	td.setAttribute("menuid",o.getAttribute("menuid"));
	td.appendChild(tbl);
}

function addRow(){
	var oTR = tbl.insertRow(tbl.rows.length-1);
	var oTD = document.createElement("td");
	var arrayTmp = arrayFolder.pop().split("|");
	oTD.setAttribute("menuid",arrayTmp[0]);
	oTD.innerHTML = arrayTmp[1];
	if(arrayTmp[0]==currentMenuId){
		oTD.className = "folderMouseOver";
	}else{
		oTD.className = "folder";
		oTD.attachEvent("onmouseover",folderMouseOver);
		oTD.attachEvent("onmouseout",folderMouseOut);
	}
	oTD.onclick = function(){slideFolder(this)};
	oTR.appendChild(oTD);

	if(document.getElementById("divFavContent").firstChild.firstChild.rows.length>2){
		document.getElementById("divFavContent").firstChild.firstChild.deleteRow();
	}else{
		var tmp = tbl.rows[tbl.rows.length-1].firstChild;
		tmp.removeChild(tmp.children[tmp.children.length-2]);
	}
}

function setCookie(cThumbCount,cMenuId){ 
	var cookieDate = new Date();
	cookieDate.setTime(cookieDate.getTime() + 10*365*24*60*60*1000);
	document.cookie = "cookieLeftMenu166="+cThumbCount+","+cMenuId+";expires="+cookieDate.toGMTString();
}

function getCookie(){ 
	try{
		var cookieData = new String(document.cookie); 
		var cookieHeader = "cookieLeftMenu166=" 
		var cookieStart = cookieData.indexOf(cookieHeader) + cookieHeader.length; 
		var cookieEnd = cookieData.indexOf(";", cookieStart); 
		if(cookieEnd==-1){ 
			cookieEnd = cookieData.length;
		}
		if(cookieData.indexOf(cookieHeader)!=-1){ 
			currentThumbCount = cookieData.substring(cookieStart, cookieEnd).split(",")[0];
			currentMenuId = cookieData.substring(cookieStart, cookieEnd).split(",")[1];
		}else{
			currentThumbCount = 0;
			currentMenuId = dom.selectSingleNode("//menubar[0]").getAttribute("id");
		}
	}catch(e){}
}