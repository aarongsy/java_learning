$(function(){
	var tb = new Ext.Toolbar();
	tb.render('pagemenubar');
	addBtn(tb,'保存','S','accept',function(){doSubmit();});
	addOrRemoveClass();
	bindEvent();
	$("#leftDiv .groupName ul li a").doSwitch();
	
	$("#EweaverForm").ajaxForm({
		beforeSubmit:function(){
			tb.disable();
			return true;
		},
        success: function(responseText, statusText, xhr, $form){
        	if(responseText == "1"){
        		if(top.pop){
					top.pop("<span>保存成功！<span>");
				}else{
					alert("保存成功！");
				}
				clearChangedEntryWidthForm();
				reductionAllEntry();
        	}else{
        		alert("保存失败！");
        		clearChangedEntryWidthForm();
        	}
        	tb.enable();
        }
	}); 
	
	addFlagToEntryWhenSubInputChange();
});

function doSubmit(){
	if (!formCheck()) return;
	copyChangedEntryInForm();
	$("#EweaverForm").submit();
}

function formCheck()
{        
  var mm=/^\d+$/;
  if(!mm.test(document.getElementById("402883c33c8f80bf013c8f80c4480293").value))
  {
     alert("弹出提醒时间间隔请输入0或正整数");
     return false;
  }
  return true;
}



function addFlagToEntryWhenSubInputChange(){
	var $entrys = $("#rightDiv .setting .group").children(".entry");
	$entrys.each(function(){
		var $entry = $(this);
		$(":input",$entry).each(function(){
			var eventName;
			if(this.type == "hidden"){	//隐藏域
				eventName = "propertychange";
			}else{
				eventName = "change";
			}
			$(this).bind(eventName,function(){
				$entry.attr("isChanged","true");
			});
		});
	});
}

function copyChangedEntryInForm(){
	var $changedEntrys = $("#rightDiv .setting .group").children(".entry[isChanged='true']");
	var $cloneChangedEntrys = $changedEntrys.clone();
	$("#EweaverForm").append($cloneChangedEntrys);
	var checkboxNames = new Array();
	$cloneChangedEntrys.find(":checkbox").each(function(){
		var isContains = false;
		for(var i = 0; i < checkboxNames.length; i++){
			if(checkboxNames[i] == $(this).attr("name")){
				isContains = true;
				break;
			}
		}
		if(!isContains){
			checkboxNames.push($(this).attr("name"));
		}
	});
	for(var i = 0; i < checkboxNames.length; i++){
		var $checkedObj = $("input[type='checkbox'][name='"+checkboxNames[i]+"']:checked",$cloneChangedEntrys);
		if($checkedObj.length == 0){
			$("#EweaverForm").append("<input type='hidden' name='"+checkboxNames[i]+"' value=''/>");
		}
	}
}

function clearChangedEntryWidthForm(){
	$("#EweaverForm").empty();
}

function reductionAllEntry(){
	$("#rightDiv .setting .group").children(".entry").removeAttr("isChanged");
}

function addOrRemoveClass(){
	var $groupNameObj = $("#leftDiv .groupName ul li a");
	$groupNameObj.bind("click",function(){
		$("#leftDiv .groupName ul li .tag").css("display", "none");
		$groupNameObj.removeClass("current");
		$(this).parent().find(".tag").css("display","block");
		$(this).addClass("current");
		cancelSearch();
	});
	
	$groupNameObj.bind("mouseover",function(){
		$(this).addClass("over");
	});
	
	$groupNameObj.bind("mouseout",function(){
		$(this).removeClass("over");
	});
	
	var $searchTextObj = $("#search input[type='text']");
	$searchTextObj.bind("focus",function(){
		$(this).addClass("focus");
	});
	$searchTextObj.bind("blur",function(){
		$(this).removeClass("focus");
	});
	$searchTextObj[0].focus();
	
	$("#search .tip").bind("click",function(){
		$searchTextObj[0].focus();
	});
	/*
	var $entryObj = $("#rightDiv .setting .group .entry");
	$entryObj.bind("mouseover",function(){
		$(this).addClass("over");
	});
	
	$entryObj.bind("mouseout",function(){
		$(this).removeClass("over");
	});*/
}

function bindEvent(){
	var $searchTextObj = $("#search input[type='text']");
	$searchTextObj.bind("keyup", function(){
		var v = $(this).val();
		if(v != ""){
			$("#search .tip").hide();
			$("#cancelSearchBtn").show();
			doSearch();
		}else{
			$("#search .tip").show();
			$("#cancelSearchBtn").hide();
			resetSearch();
			hideSearchResult();
		}
	});
	
	$("#cancelSearchBtn").bind("click",cancelSearch);
}

var searchResultInfo = new Array();
/*执行搜索*/
function doSearch(){
	resetSearch();
	var $searchTextObj = $("#search input[type='text']");
	var searchKey = $searchTextObj.val();	//用于搜索的关键字
	var $groups = $("#rightDiv .setting").not("#searchResultDiv").find(".group");
	$groups.each(function(i){
		var $entrys = $(this).find(".entry").not(".subEntry");
		$entrys.each(function(j){
			var $label = $(this).find(".label").first();
			var keyIndex = $label.html().toLowerCase().indexOf(searchKey.toLowerCase());
			if(keyIndex != -1){
				searchKey = $label.html().substr(keyIndex, searchKey.length);	//忽略大小写比较后,searchKey必须重新从字符串中截取才能正常完成下面的替换
				var sourceLabel = $label.html();
				$label.html($label.html().ReplaceAll(searchKey,"<label class=\"searchKey\">" + searchKey + "</label>"));
				searchResultInfo.push({'groupIndex' : i , 'entryIndex' : j , 'entryObj' : $(this), 'sourceLabel' : sourceLabel});
				$("#searchResultDiv .group").append($(this));
			}
		});
	});
	showSearchResult();
}

/*取消搜索*/
function cancelSearch(){
	var $searchTextObj = $("#search input[type='text']");
	if($searchTextObj.val() != ""){
		$searchTextObj.val("");	//通过清空搜索框的值来触发其propertychange事件
		if(document.createEvent){
			var evt = document.createEvent("Events");
			evt.initEvent("keyup", true, true);
			$searchTextObj[0].dispatchEvent(evt);
		}else{
			$searchTextObj[0].fireEvent("onkeyup");
		}
	}
}

/*重置搜索结果(将搜索结果从搜索页面还原到列表页面)*/
function resetSearch(){
	var $groups = $("#rightDiv .setting").not("#searchResultDiv").find(".group");
	for(var i = 0; i < searchResultInfo.length; i++){
		var data = searchResultInfo[i];
		var groupIndex = data['groupIndex'];
		var entryIndex = data['entryIndex'];
		var $entry = data['entryObj'];
		var sourceLabel = data['sourceLabel'];
		var $label = $entry.find(".label").first();
		$label.html(sourceLabel);
		if(entryIndex == 0){
			var $firstEntry = $groups.eq(groupIndex).find(".entry").not(".subEntry").first();
			if($firstEntry.length != 0){	//存在第一个,则插入到第一个之前
				$firstEntry.before($entry);
				//$entry.insertBefore($firstEntry);
			}else{	//一个都不存在，则追加
				$groups.eq(groupIndex).append($entry);
			}
		}else{
			$groups.eq(groupIndex).find(".entry").not(".subEntry").eq(entryIndex - 1).after($entry);
		}
	}
	searchResultInfo = [];
}

/*显示搜索结果页面*/
function showSearchResult(){
	$("#searchResultDiv").show();	
}

/*隐藏搜索结果页面*/
function hideSearchResult(){
	$("#searchResultDiv").hide();	
}

function radioChecked(n,v){
	$("input[type='radio'][name='"+n+"']").each(function(i){
		if($(this).val() == v){
			$(this).attr("checked","checked");
			return;
		}
	});;
}

function clearSelect(selId){
 	var sel = document.getElementById(selId);
	while(sel.childNodes.length > 0)	//清空下拉列表
	{
		sel.removeChild(sel.childNodes[0]);
	}	
 }
 
function bindSelect(selId,v){
 	var sel = document.getElementById(selId);
 	for(var i = 0; i < sel.options.length; i++){
 		if(sel.options[i].value == v){
 			sel.options[i].selected = true;
 			break;
 		}
 	}
 }
 
function hiddenOrShowBorrow(){
	var v = $("input[type='radio'][name='292e269b2d530567012d5a31ef5gt092'][checked='checked']").val();
	var isDocBorrowEnabled = (v == "1");
	if(isDocBorrowEnabled){
		document.getElementById("docBorrow").style.display = "block";
	}else{
		document.getElementById("docBorrow").style.display = "none";
	}
}

function controlEleShowOrHideWidthRadio(radioName, eleId){
	var v = $("input[type='radio'][name='"+radioName+"']:checked").val();
	var isEnabled = (v == "1");
	if(isEnabled){
		$("#" + eleId).show();
	}else{
		$("#" + eleId).hide();
	}
}

function setpassdate(){
	var v = $("#ff808081349eb5d201349eb5e2890002").val();
	var spanobj1 = document.getElementById('custom');
	var spanobj2 = document.getElementById('customdatediv');
	if(v == "ff808081349e68f001349e8521300007"){
		spanobj1.style.display = 'none';
		spanobj2.style.display = 'none';
	}else{
		spanobj2.style.display = 'inline';
		if(v == "ff808081349e68f001349e7944840006"){
			spanobj1.style.display = 'inline';
		}else{
			spanobj1.style.display = 'none';
		}
	}
}

function addTipMsg(tipId,msg){
	$("#"+tipId).qtip({content: msg});
}

function initData(){
	var myMask = new Ext.LoadMask(Ext.getBody(), {
	    msg: '正在处理，请稍后...',
	    removeMask: true //完成后移除
	});
	myMask.show();
	
	Ext.Ajax.request({
		timeout:100000000,
        url: '/ServiceAction/com.eweaver.workflow.request.servlet.TodoitemsAction',
        params:{},
        success: function(request) {
        	Ext.Msg.alert('',request.responseText);
            myMask.hide();
        },
        failure: function (request) {
	        Ext.Msg.alert('','请求超时！');
	        myMask.hide();
	    }
    });
}

function initManagers(obj){
	obj.disabled=true;
	obj.value="处理中...";
	obj.title="请检查系统控制台是否完成";
	DWREngine.setAsync(false);
	HumresService.initAllHumresManagers();
	DWREngine.setAsync(true);
}

function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	if(inputname.substring(3,(inputname.length-6))){
        if(document.getElementById(inputname.substring(3,(inputname.length-6))))
        	document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
    	}
	var id;
	try{
		id=openDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid);
	}catch(e){}
	if (id!=null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
		}else{
			document.all(inputname).value = '';
			if (isneed=='0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
			}
        }
    }
}

function myKeyDown() {
    var k = window.event.keyCode;
    if ((k == 46) || (k == 8) || (k == 189) || (k == 109) || (k == 110) || (k > 48 && k <= 57) || (k >= 96 && k <= 105) || (k >= 37 && k <= 40))
    { }
    else if (k == 13) {
        window.event.keyCode = 9;
    }
    else {
        window.event.returnValue = false;
    }
}

var preStatusV;
function controlJqGridStatusTipDisplay(v){
	if(preStatusV != v){
		$(".jqGridStatusTip").hide(0,function(){
			$("#jqGridStatusTip" + v).show(0);
		});
		preStatusV = v;
	}
}

function controlTipDisplay(id){
	$("#" + id).slideToggle(300);
}

function radioChange_PhoneType(){
	var phoneType=jQuery("input[type='radio'][name='402883213fe5804e013fe58054ef0000']:checked").val();
	if(phoneType=="402883213fe593d1013fe593d7680000"){//商信通短信接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("短信接口接连IP：");
		jQuery("#402883213fe5804e013fe58054f00002_span").html("短信接口访问端口：");
		jQuery("#402883213fe5804e013fe58054f00003_span").html("短信接口账号：");
		jQuery("#402883213fe5804e013fe58054f00004_span").html("短信接口账号密码：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").show();
		jQuery("#402883213fe5804e013fe58054f00003_div").show();
		jQuery("#402883213fe5804e013fe58054f00004_div").show();
		jQuery("#402883213fe5804e013fe58054f00005_div").hide();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}else if(phoneType=="402883213fe593d1013fe593d7680001"){//EMPP短信接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("短信接口接连IP：");
		jQuery("#402883213fe5804e013fe58054f00002_span").html("短信接口访问端口：");
		jQuery("#402883213fe5804e013fe58054f00003_span").html("短信接口账号：");
		jQuery("#402883213fe5804e013fe58054f00004_span").html("短信接口账号密码：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").show();
		jQuery("#402883213fe5804e013fe58054f00003_div").show();
		jQuery("#402883213fe5804e013fe58054f00004_div").show();
		jQuery("#402883213fe5804e013fe58054f00005_div").hide();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}else if(phoneType=="402883213fe593d1013fe593d7680002"){//金格短信猫接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("短信接口接连IP：");
		jQuery("#402883213fe5804e013fe58054f00002_span").html("短信接口访问端口：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").show();
		jQuery("#402883213fe5804e013fe58054f00003_div").hide();
		jQuery("#402883213fe5804e013fe58054f00004_div").hide();
		jQuery("#402883213fe5804e013fe58054f00005_div").hide();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}else if(phoneType=="402883213fe593d1013fe593d7680004"){//金仓短信猫接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("注册码：");
		jQuery("#402883213fe5804e013fe58054f00002_span").html("串口：");
		jQuery("#402883213fe5804e013fe58054f00003_span").html("波特率：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").show();
		jQuery("#402883213fe5804e013fe58054f00003_div").show();
		jQuery("#402883213fe5804e013fe58054f00004_div").hide();
		jQuery("#402883213fe5804e013fe58054f00005_div").hide();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}else if(phoneType=="402883213fe593d1013fe593d7680005"){//EMA短信接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("短信接口接连IP：");
		jQuery("#402883213fe5804e013fe58054f00002_span").html("英斯克分配企业代码：");
		jQuery("#402883213fe5804e013fe58054f00003_span").html("英斯克设定密码：");
		jQuery("#402883213fe5804e013fe58054f00004_span").html("英斯克分配用户帐号：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").show();
		jQuery("#402883213fe5804e013fe58054f00003_div").show();
		jQuery("#402883213fe5804e013fe58054f00004_div").show();
		jQuery("#402883213fe5804e013fe58054f00005_div").hide();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}else if(phoneType=="402883213fe593d1013fe593d7680006"){//JDBC短信接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("数据源名称：");
		jQuery("#402883213fe5804e013fe58054f00002_span").html("sql：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").show();
		jQuery("#402883213fe5804e013fe58054f00003_div").hide();
		jQuery("#402883213fe5804e013fe58054f00004_div").hide();
		jQuery("#402883213fe5804e013fe58054f00005_span").html("<font color='#ff0000'>sql格式：insert tablename(mobile,msg) values(?,?) mobile：手机号、msg：短信内容</font>");
		jQuery("#402883213fe5804e013fe58054f00005_div").show();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}else if(phoneType=="402883213fe593d1013fe593d7680007"){//配置文件
		jQuery("#402883213fe5804e013fe58054f00001_div").hide();
		jQuery("#402883213fe5804e013fe58054f00002_div").hide();
		jQuery("#402883213fe5804e013fe58054f00003_div").hide();
		jQuery("#402883213fe5804e013fe58054f00004_div").hide();
		jQuery("#402883213fe5804e013fe58054f00005_span").html("<font color='#ff0000'>除以上类型之外自定义开发短信接口</font>");
		jQuery("#402883213fe5804e013fe58054f00005_div").show();
		jQuery("#402883213fe5804e013fe58054f00006_div").hide();
	}else if(phoneType=="402883213fe593d1013fe593d7680008"){//亿美短信接口
		jQuery("#402883213fe5804e013fe58054ef0001_span").html("客户端序列号：");
		jQuery("#402883213fe5804e013fe58054f00003_span").html("要注册的关键字：");
		jQuery("#402883213fe5804e013fe58054f00004_span").html("软件序列号密码：");
		jQuery("#402883213fe5804e013fe58054f00001_div").show();
		jQuery("#402883213fe5804e013fe58054f00002_div").hide();
		jQuery("#402883213fe5804e013fe58054f00003_div").show();
		jQuery("#402883213fe5804e013fe58054f00004_div").show();
		jQuery("#402883213fe5804e013fe58054f00005_div").hide();
		jQuery("#402883213fe5804e013fe58054f00006_div").show();
	}
}

function testPhoneConnect(){
	var myMask = new Ext.LoadMask(Ext.getBody(), {
	    msg: '正在处理，请稍后...',
	    removeMask: true //完成后移除
	});
	myMask.show();
	
	Ext.Ajax.request({
		timeout:100000000,
        url: '/ServiceAction/com.eweaver.base.msg.servlet.SmsAction?action=phoneconnect',
        params:{},
        success: function(rs) {
        	jQuery("#phoneconnect_message").html("<font color='#ff0000'>"+rs.responseText+"</font>");
            myMask.hide();
        },
        failure: function (rs) {
	        Ext.Msg.alert('','请求超时！');
	        myMask.hide();
	    }
    });
}

function doSSOAccountHistory(flag){
	var str = 0==flag ? "加密" : "解密";
	if(confirm("确定"+str+"所有历史记录？")){
		jQuery.ajax({
			url: "/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=SSOAccountHistory&flag="+flag+"&r="+Math.random(),
			success: function(){
				alert(str+"完成。");
			}
		});
	}
}