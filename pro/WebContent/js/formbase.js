function f$(id) {
	return document.getElementById(id);
}
//多选Checkbox函数
function onClickMutiBox(box, fieldid) {
	var field = f$('field_' + fieldid);
	if (box.checked) {
		if (field.value) {
			field.value = field.value + ',' + box.value;
		} else {
			field.value = box.value;
		}
	} else {
		var tempValue = field.value + ',';
		tempValue = tempValue.replace(box.value + ',','');
		field.value = tempValue.substring(0,tempValue.length-1);
	}

}
/*附件上传操作*/
function addAttach(attachid, attachname,fieldid){
	var filetype=attachname.split('.').length>0?attachname.split('.')[1]:'';
    var fieldElement = f$("field_"+fieldid);
    var oDiv = f$("uploadDIV_"+fieldid);
    var span = document.createElement("SPAN");
    span.style.margin="2 10 2 5";
    span.id = attachid;
	span.innerHTML = '<a class="attach '+filetype+'">' + attachname + '</a><a class="delete" title="删除" href="#" onclick = javascript:deleteAttach("'+attachid+'","'+fieldid+'");>删除</a>';
	oDiv.appendChild(span);
	if(fieldElement.value){
		fieldElement.value += ","+attachid;
	}else{
		fieldElement.value += attachid;
	}
	if(needchecklists.indexOf(fieldid)>0){
		$("field_"+fieldid+"fileImg").style.display="none";
	}
}
//附件删除操作
function deleteAttach(attachid,fieldid){
	var fieldElement = f$("field_"+fieldid);
    if (confirm("确定删除吗?")) {
        var oSpan = f$(attachid);
        oSpan.removeNode(true);
    	fieldElement.value += ",";
        fieldElement.value = fieldElement.value.replace(attachid + ",", "");
        fieldElement.value = fieldElement.value.substring(0,fieldElement.value.length-1);
        if(needchecklists.indexOf(fieldid)>0&&!fieldElement.value){
    		$("field_"+fieldid+"fileImg").style.display="";
    	}
    }
}
//附件上传时禁用页面按钮
function disabledButton(){
	if(tb){tb.disable();}   
}
function enableButton(){
	if(tb){tb.enable();}   
}
//带格式文本初始化函数
function initFCK(fieldName,ToolbarSet){
	if(!fieldName)	return;
	if(!ToolbarSet)	ToolbarSet='Default';
	var oFCKeditor = new FCKeditor(fieldName);
	oFCKeditor.Config['DefaultLanguage']='zh-cn';
	oFCKeditor.Config['CustomConfigurationsPath']='/js/fckconfig.js';
	oFCKeditor.Height = 300;
	oFCKeditor.ToolbarSet=ToolbarSet;
	oFCKeditor.ReplaceTextarea();
	return oFCKeditor;
}
function initFormFCK(fieldName){
	return initFCK(fieldName,'FormEditor');
}