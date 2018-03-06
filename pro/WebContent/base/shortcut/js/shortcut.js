$(function(){
	$("#shortcut .handler .setting").bind("click",openSetting);
	loadShortCut();
	initParentShortCutWindow();
});
function doShortCutCycle(){
	$('#shortcut .data').cycle({
        fx:      'scrollRight',	
        prev:    '#shortcut .handler .prev',
	 	next:    '#shortcut .handler .next',
	 	//pager:   '#menuHandler .nav ul',
		speed: 200,	//幻灯片过渡的速度
		timeout: 0,	//不自动切换 
		slideExpr: 'table',
		cleartype:  true
    });
    
    $('#shortcut .data').cycle("pause");
}
function loadShortCut(){
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: encodeURI("/ServiceAction/com.eweaver.base.shortcut.servlet.ShortCutAction?action=getShortCutForShow"),
	 	data: "{}",
	 	async: false,
	 	success: function(responseText, textStatus) 
	 	{
	 		var shortCutDatas = eval("(" + responseText + ")");
	 		var shortCutDataHtml = "";
	 		var pageCount = 8;	//每页的数量
	 		var lineCount = 4;	//每行的数量
	 		for(var i = 0; i < shortCutDatas.length; i+=pageCount){
				if(shortCutDatas.length - i >= pageCount){
					shortCutDataHtml += createTableHtml(i, pageCount);
				}else{
					shortCutDataHtml += createTableHtml(i, (shortCutDatas.length - i));
				}
	 			
	 		}
	 		$("#shortcut .data").append(shortCutDataHtml);
	 		function createTableHtml(dataIndex, eachCount){
	 			
	 			var tableHtml = "<table><tr><td><ul>";
	 			for(var j = 0; j < eachCount; j++){
	 				if(j == lineCount){
	 					tableHtml += "</ul></td></tr><tr><td><ul>";
	 				}
	 				tableHtml += createOneShortCutHtml(shortCutDatas[dataIndex + j]);
	 			}
	 			tableHtml += "</ul></td></tr></table>";
	 			return tableHtml;
	 		}
	 		doShortCutCycle();
	 	},
	 	error: function (XMLHttpRequest, textStatus, errorThrown) {
		    alert(errorThrown);
		}
	});
}
function createOneShortCutHtml(shortCutData){
	var link = shortCutData["data"]["url"];
	var href = "";
	var target = "";
	if(shortCutData["openMode"] == 0){	//当前页面打开
		href = link;
	}else if(shortCutData["openMode"] == 1){	//新窗口打开
		href = link;
		target = "_blank";
	}else{	//tab页打开
		var tabName = shortCutData["data"]["objname"];
		href = "javascript:onUrl('"+link+"','"+tabName+"','tab"+shortCutData["dataSourceId"]+"')";
	}
	var shortCutHtml = "<li><a href=\""+href+"\" target=\""+target+"\"><div class=\"pic\"><img src=\""+shortCutData["data"]["imgpath"]+"\"/></div><div class=\"text\">"+shortCutData["data"]["objname"]+"</div></a></li>";
	return shortCutHtml;
}
function openSetting(){
	if(parent.openShortCutSetting){	//父窗口中打开(通过iframe的方式嵌套在门户中时,会使用此方式)
		parent.openShortCutSetting();
	}else{	//本窗口打开
		openShortCutDialog("/base/shortcut/shortcutmanage.jsp","快速入口设置",650,450);
	}
}
function initParentShortCutWindow(){
	parent.shortCutWindow = window;
}

var shortCutDialog;
function openShortCutDialog(url,title,width,height){
   shortCutDialog = new Ext.Window({
        layout:'border',
        closeAction:'hide',
        plain: true,
        modal :true,
        items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }],
	    buttons:[{
           text     : '完成',
           handler  : function() {
              closeShortCutDialog();
           }
        }]
    });
    shortCutDialog.render(Ext.getBody());
    shortCutDialog.setTitle(title);
    shortCutDialog.setWidth(width);
    shortCutDialog.setHeight(height);
    shortCutDialog.getComponent('commondlg').setSrc(url);
    shortCutDialog.show();
}

function closeShortCutDialog(){
	if(shortCutDialog){
		shortCutDialog.close();
	}
	window.location.reload();
}