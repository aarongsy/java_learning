/**
 * 保存数据
 * @param form
 * @param url
 * @param fun
 * @return
 */
function saveToUrl(form,url,fun) {
     var fields = $(form).serialize();
     //alert('f:' + fields);
     $.post(url,fields,function(data){fun(data)});
}

/**
 * 保存数据
 * @param form
 * @param url
 * @param fun
 * @return
 */
function postToUrl(param,url,fun) {
     $.post(url,param,function(data){fun(data)});
}

function checkFields(fields) {
	if(fields && fields.length > 0) {
		for(var i = 0; i < fields.length; i ++) {
			var field = fields[i];
			var fv = $('#ew_' + field.name).val();
			if(fv == '') {
				alert(field.text + '必须填写！');
				return true;
			}
		}
	}
	return false;
}


/**
 * 加载数据
 * @param form
 * @param url
 * @param fun
 * @return
 */
function loadFromDb(url,fields) {
	//var fields = $(form).serializeArray();
    $.post(url,fields,function(data){
    	var vdata = eval(data);
    	var len = vdata.length;
    	for(var i = 0; i < len; i ++) {
    		var field = vdata[i];
    		//alert(field.name);
    		//alert(field.name + ':' + field.value);
    		$('#ew_' + field.name).val(field.value);
    		$('#ew_' + field.name+'span').html(field.value);		
    	}
    	setCheckBox();
    });
}

/**
 * 加载数据
 * @param form
 * @param url
 * @param fun
 * @return
 */
function loadFromDb(url,fields,infun) {
	//var fields = $(form).serializeArray();
    $.post(url,fields,function(data){
    	var vdata = eval(data);
    	var len = vdata.length;
    	for(var i = 0; i < len; i ++) {
    		var field = vdata[i];
    		$('#ew_' + field.name).val(field.value);
    		$('#ew_' + field.name+'span').html(field.value);
    	}
    	setCheckBox();
    	if(infun) {
    		infun();
    	}   	
    });
}

/**
 * 加载数据并生成列表
 * @param form
 * @param url
 * @param fun
 * @return
 */
function loadFromDbForList(url,fields,id) {

    $.post(url,fields,function(data){
    	if(data == ''){
    		return;
    	}
    	var vdata = eval(data);
    	var len = vdata.length;
    	var str='<table>';
    	for(var i = 0; i < len; i ++) {
    		var field = vdata[i];
    		if(field.objname) {
    			str +='<tr><td>[' + field.actiontype + ']</td>'
        		str +='<td>' + field.objname + '</td>'
        		str +='<td>' + field.edithref + '</td>'
        		str +='<td>' + field.delhref + '</td></tr>'  
    		}      		  		
    	}
    	str += '</table>';
    	document.getElementById(id).innerHTML = str;
    });
}

/**
 * 设置成功信息
 * @return
 */
function setSuccess(msg) {
	$('#message').html('<font color=\'red\'>'+msg+'</font>');
	setTimeout("$('#message').html('')",1000);
}

/**
 * 清除成功信息
 * @return
 */
function clearSucess() {
	$('#message').html('')
}

function setCheckBox() {
	$("input[type='checkbox']").each(function(){
		var val = $(this).val();
        if(val == 1){
        	$(this).attr("checked",'true');
        } 
	});
}

function fillit(id,value) {
	if(value != '') {
		$(id).val($(id).val() + '{' + value + '}');	
	}	
}

function openWind(url,param,title,callback){
	asyncbox.open({
	 	title:title,
　　　	url : url,
　　　	data : param,
　　　	width : 500,
　　　	height : 500,
        callback : callback
		});
}

/**
 * @param id
 * @param ids
 * @return
 */
function hideOther(id,ids) {
	$("#"+id).change(function(){
			var size = ids.length;
			if(this.value != -1) {
				for(var i = 0 ; i < size ; i ++) {
					$("#"+ids[i]).hide();
				}
			} else {
				for(var i = 0 ; i < size ; i ++) {
					$("#"+ids[i]).show();
				}
			}			
	    }
	);
}

/**
 * @param id
 * @param ids
 * @return
 */
function hideOtherByIdValue(id,ids) {
	var idValue = $("#"+id).val();
	//alert(idValue);
	if(idValue != -1){
		var size = ids.length;
		for(var i = 0 ; i < size ; i ++) {
			$("#"+ids[i]).hide();
		}
	}
}

function fillFields(id,objtype,objid,otherid) {
	 if(objid != '' && objtype != '') {
		 var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=getfields';
		 var fields = 'objid='+objid + '&objtype='+objtype;
		 $("#ew_objid").val(objid);
		 $("#ew_objtype").val(objtype);
		 $.post(url,fields,function(data){
	    	if(data == ''){
	    		return;
	    	}
	    	var vdata = eval(data);
	    	var len = vdata.length;
	    	var str='<select onchange=\'fillit('+otherid+',this.value)\'><option></option>';
	    	var table = '';    
	    	for(var i = 0; i < len; i ++) {
	    		var field = vdata[i];
				var tabledesc = field.tabledesc;
				var fielddesc = field.fielddesc;
				var fieldname = field.fieldname;
				table = tabledesc;
	    		if(tabledesc && fielddesc) {
					str += '<option value=\''+fieldname+'\'>'+fielddesc + '-' + tabledesc+ '</option>';
	    		}      		  		
	    	}
			str += '</select>';
	    	document.getElementById(id).innerHTML = str;
	    });
	 }
}

/**
 * 接口调用
 * @param params e.g requestid=
 * @return
 */
function callInterface(async,interfaceid,objid,params,fun) {
	var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=callInterface&reqid='
		+objid+'&interfaceId='+interfaceid;
	jQuery.ajaxSetup({async: async});
	jQuery.post(url,params,function(data){
		if(fun){
		    fun(data);
		} else {
			alert(data);
		}		
	});
}


/**
 * 接口调用
 * @param params e.g requestid=
 * @return
 */
function callSimpleInterface(async,interfaceid,paraName,paraValue) {
	var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=callInterface&reqid='
		+objid+'&interfaceId='+interfaceid;
	jQuery.ajaxSetup({async: async});
	var rs = '';
	var params = '[{'+paraName+':#'+paraValue+'#}]';
	jQuery.post(url,params,function(data){
		var jdata = eval(data);
		if(jdata && jdata.lenght && jdata.length > 0) {
			
		}
	});
}

/**	
 * 添加明细行
 * @param {Object} formid 明细表ID
 * @param {Object} data 需要填充的数据
 */
var _subtabindex = 0;
function addDetail(formid,data,fun){
	var _objname = 'check_node_'+formid; 
	var checkboxes = document.getElementsByName(_objname);   
	var len = checkboxes.length;   
	var maxIndex = 0;       
	for(var i=0; i<len; i++) {                      
		if((checkboxes[i].type=='checkbox') && (checkboxes[i].name=='check_node_'+formid )) {
			checkboxes[i].checked = true;               
			maxIndex = checkboxes[i].value;            
		}               
	}     
 	delrow(formid); 
 	var _rindex =  parseInt(maxIndex ) + 1;    
    if(_subtabindex == 0) {  
    	_subtabindex = _rindex;     
    } else {    
    	_rindex = _subtabindex;    
    }  
	if(data&&data.length>0){ 
		for(var i=0;i<data.length;i++){ 
			addrow(formid);
			fun(_rindex,data[i]);
			_subtabindex++;    
			_rindex = _subtabindex;
		}
	}   
}

function null2str(str){
	if(str == null || str == 'undefined') { str = '';}
	return str;
}


//设置字段值 
function setFieldValueWithspan(cellid,index,value,spanvalue) {  
    var remark = '';  
    if(index >= 0) {  
       remark = '_'+index;  
    }  
    var obj = document.getElementById('field_'+cellid+remark);   
    var objspan = document.getElementById('field_'+cellid+remark+'span');   
    if(objspan && obj.type == 'hidden') {   
        objspan.innerHTML = spanvalue;       
        obj.value=value;                                          
    }  
     
    if(obj && (obj.type == 'text'  || obj.tagName == 'SELECT')){   
        obj.value=value;  
    }  
}

//设置字段值 
function setFieldValue(cellid,index,value) {  
    var remark = '';  
    if(index >= 0) {  
       remark = '_'+index;  
    }  
    var obj = document.getElementById('field_'+cellid+remark);   
    var objspan = document.getElementById('field_'+cellid+remark+'span');   
    if(objspan && obj.type == 'hidden') {   
        objspan.innerHTML = value;       
        obj.value=value;                                          
    }  
     
    if(obj && (obj.type == 'text'  || obj.tagName == 'SELECT')){   
        obj.value=value;  
    }  
}  