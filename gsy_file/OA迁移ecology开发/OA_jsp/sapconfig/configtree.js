$(document).ready(function(){
	reloadTree(3);
});
function reloadTree(showtype){
	var treeid = $("#treeid").val();
	var setting = {
		view: {
			selectedMulti: false,
			addDiyDom:addDiyDom,
			showTitle:true,
			nameIsHTML:true 
		},
		key: {
			title:"showTitle"
		},
		async: {
			enable: true,
			url:"configtreeaction.jsp?treeid="+treeid+"&showtype="+showtype,
			autoParam:["id", "pId","actiontype"]
		},
		callback: {
//			beforeClick: beforeClick,
//			beforeAsync: beforeAsync,
//			onAsyncError: onAsyncError,
//			onAsyncSuccess: onAsyncSuccess
		}
	};
	$.fn.zTree.init($("#configtree"), setting);
	var rootNode = $.fn.zTree.getZTreeObj("configtree").getNodeByParam("id",treeid);
	expandAll();
}
function expandAll() {
	var zTree = $.fn.zTree.getZTreeObj("configtree");
	expandNodes(zTree.getNodes());
}
function expandNodes(nodes) {
	if (!nodes) return;
	var zTree = $.fn.zTree.getZTreeObj("configtree");
	for (var i=0, l=nodes.length; i<l; i++) {
		zTree.expandNode(nodes[i], true, false, false);
		if (nodes[i].isParent && nodes[i].zAsync) {
			expandNodes(nodes[i].children);
		} 
	}
}

function changeShowType(showtype){
	reloadTree(showtype);
}

var addtable = "input,output,";
var addstructure = "input,output,";
var addcolumn = "table,structure,";
var addparameter = "input,output,";
function addDiyDom(treeId, treeNode){
	if(addtable.indexOf(treeNode.actiontype)>-1){
		$("#" + treeNode.tId + "_a")
		.append("<div class='addtable' onclick=\"addElement(this)\" add=\"table\" title='添加表' nodeid="+treeNode.id+">+</div>");
	}
	if(addstructure.indexOf(treeNode.actiontype)>-1){
		$("#" + treeNode.tId + "_a")
		.append("<div class='addstructure' onclick=\"addElement(this)\" add=\"structure\" title='添加结构' nodeid="+treeNode.id+">+</div>");
	}
	if(addcolumn.indexOf(treeNode.actiontype)>-1){
		$("#" + treeNode.tId + "_a")
		.append("<div class='addcolumn' onclick=\"addElement(this)\" add=\"column\" title='添加字段' nodeid="+treeNode.id+">+</div>");
	}
	if(addparameter.indexOf(treeNode.actiontype)>-1){
		$("#" + treeNode.tId + "_a")
		.append("<div class='addparameter' onclick=\"addElement(this)\" add=\"parameter\" title='添加参数' nodeid="+treeNode.id+">+</div>");
	}
	if(treeNode.actiontype!='input'&&treeNode.actiontype!='output'){
		$("#" + treeNode.tId + "_a")
		.append("<div class='deleteElement' onclick=\"deleteElement(this)\" title='删除对象' nodeid="+treeNode.id+">-</div>");
	}
}

//添加元素
function addElement(obj){
	$(".configdiv").hide();
	var treeNode = $.fn.zTree.getZTreeObj("configtree").getNodeByParam("id",$(obj).attr("nodeid"));
	var addelement = $(obj).attr("add");
	var actiontype = treeNode.actiontype;
	$("#ConfigDiv").show();
	$("#Config"+addelement+"Div").show();
//	$("#Config"+addelement+"Div").attr("currentdiv","1");
	$("#addCurrentNode").val(treeNode.id);
	$("#addCurrentActionType").val("addElement"+addelement);
	$("#addCurrentConfigDiv").val("Config"+addelement+"Div");
	show('allConfigDiv');
}

function onSubmit(num){
	if(num==1){
		var currentConfigDiv = $("#addCurrentConfigDiv").val();
		var actiontype = $("#addCurrentActionType").val();
		var nodeid = $("#addCurrentNode").val();
		var param = "actiontype="+actiontype+"&pId="+nodeid;
		$("#"+currentConfigDiv).find("input").each(function(i,val){
			param +="&";
			param += $(val).attr("name");
			param +="=";
			param +=$(val).val();
			
		})
		$.ajax({
			url:"configtreeoperation.jsp?"+param,
			cache:false,
			async:false,
			success:function(data){
				if($.trim(data)=='success'){
					var configtree =  $.fn.zTree.getZTreeObj("configtree");
					var node = configtree.getNodeByParam("id",nodeid);
					node.isParent=true;
					configtree.reAsyncChildNodes(node,'refresh',true);
					$("#"+currentConfigDiv).find("input").each(function(i,val){
						$(val).val('');
					})
					expandAll();
				}
			}
		})
	}
	$(".configdiv").hide();
	
}

function deleteElement(obj){
	var nodeid = $(obj).attr("nodeid");
	var pnode = $.fn.zTree.getZTreeObj("configtree").getNodeByParam("id",nodeid).getParentNode();
	$.ajax({
		url:"configtreeoperation.jsp?actiontype=deleteElement&id="+nodeid,
		cache:false,
		async:false,
		success:function(data){
			if($.trim(data)=='success'){
				var configtree =  $.fn.zTree.getZTreeObj("configtree");
				configtree.reAsyncChildNodes(pnode,'refresh',true);
				expandAll();
			}
		}
	})
}


function show(id) { 
	var oSon = window.document.getElementById(id);  
    if (oSon == null) return;  
    with (oSon){  
     style.display = "block";  
     style.pixelLeft = window.event.clientX + window.document.body.scrollLeft + 6;  
     style.pixelTop = window.event.clientY + window.document.body.scrollTop + 9;  
    }  
} 
