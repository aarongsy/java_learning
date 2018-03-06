//for formbase.jsp and workflow.jsp 变量fieldJSFormulas在jsp页面中定义
Ext.onReady(function() {
	setTimeout(function(){
		for(var i = 0; i < fieldJSFormulas.length; i++){
			var f = fieldJSFormulas[i];
			bindJsCodeToField(f.fieldid, f.code, f.eventMode, f.isWinOnloadRun, f.htmltype, f.fieldtype, f.isDetailField);
		}
	},500);
});

var fieldBindFunInfos = new Array();
function bindJsCodeToField(fieldid, code, eventMode, isWinOnloadRun, htmltype, fieldtype, isDetailField){
	var jqFieldObj = getJQFieldObj(fieldid, eventMode, htmltype, isDetailField);
	var eventName = getEventNameForBind(fieldid, eventMode, htmltype, fieldtype);
	
	//移除事件绑定(主要可能针对子表)
	for(var i = 0; i < fieldBindFunInfos.length; i++){
		var fieldBindFunInfo = fieldBindFunInfos[i];
		if(fieldBindFunInfo["fieldid"] == fieldid && fieldBindFunInfo["eventName"] == eventName){
			var unBindFun = fieldBindFunInfo["runFun"];
			jqFieldObj.unbind(eventName, unBindFun); 
			fieldBindFunInfos.splice(i, 1);
			break;
		}
	}
	
	var runFun = function(){
   		if(eventName == "propertychange" && event.propertyName != "value"){
   			return;
   		}
   		integrateCodeForAFun(code);
   	};
   	
	jqFieldObj.bind(eventName, runFun);
	
	//记录字段时间绑定信息
	var fieldBindFunInfo = {"fieldid": fieldid , "eventName": eventName , "runFun": runFun};
	fieldBindFunInfos.push(fieldBindFunInfo);
	
	if(isWinOnloadRun){
		integrateCodeForAFun(code);
	}
   	
    	
   	function getJQFieldObj(fieldid, eventMode, htmltype){
   		if(!isDetailField){	//字段是主表字段
   			if(htmltype == "3"){	//带格式文本
    			return jQuery("#field_"+fieldid+"___Frame").contents().find("iframe").contents().find("body");
    		}else if(htmltype == "4"){	//checkbox
    			return jQuery("input[name='field_"+fieldid+"']");
    		}else if(htmltype == "8"){	//checkbox 多选
    			return jQuery("#field_"+fieldid).parent().find("input[type='checkbox'][onclick*='"+fieldid+"']");
    		}else if(htmltype == "6"){	//关联选择
    			if(eventMode == "click"){
    				return jQuery("button[class='Browser'][name='button_"+fieldid+"']");
    			}else if(eventMode == "change"){
    				return jQuery("input[type='hidden'][name='field_"+fieldid+"']");
    			}
    		}else if(htmltype == "7"){	//附件
    			if(eventMode == "click"){
    				return jQuery("#field_"+fieldid+"file");
    			}else if(eventMode == "change"){
    				return jQuery("input[type='hidden'][name='field_"+fieldid+"']");
    			}
    		}
    		return jQuery("#field_"+fieldid);
   		}else{	//字段是子表字段
   			var detailFieldJQObj = jQuery("*[name*='field_"+fieldid+"_']").filter(function(i){
   				var n = jQuery(this).attr("name");
   				if(!isNaN(n.substring(n.lastIndexOf("_") + 1))){
   					return true;
   				}
   			});
   			if(htmltype == "3"){	//带格式文本
   				return jQuery("*[id*='field_"+fieldid+"_'][id$='___Frame']").contents().find("iframe").contents().find("body");
   			}if(htmltype == "8"){	//checkbox 多选
    			return detailFieldJQObj.parent().find("input[type='checkbox'][onclick*='"+fieldid+"']");
    		}else if(htmltype == "6"){	//关联选择
    			if(eventMode == "click"){
    				return jQuery("button[class='Browser'][name*='button_"+fieldid+"_']").filter(isTheNameEndWithNumber);
    			}else if(eventMode == "change"){
    				return jQuery("input[type='hidden'][name*='field_"+fieldid+"_']").filter(isTheNameEndWithNumber);
    			}
    		}else if(htmltype == "7"){	//附件
    			if(eventMode == "click"){
    				return jQuery("input[name*='field_"+fieldid+"_'][name*='file']");
    			}else if(eventMode == "change"){
    				return jQuery("input[type='hidden'][name*='field_"+fieldid+"_']").filter(isTheNameEndWithNumber);
    			}
    		}
   			return detailFieldJQObj;
   		}
   		
   		function isTheNameEndWithNumber(i){
   			var n = jQuery(this).attr("name");
  				if(!isNaN(n.substring(n.lastIndexOf("_") + 1))){
  					return true;
  				}
   		}
   	}
    	
   	function getEventNameForBind(fieldid, eventMode, htmltype, fieldtype){
   		var eventName = eventMode;
   		if(eventMode == "change"){
   			if(htmltype == "1"){	//单行文本
   				if(fieldtype == "4" || fieldtype == "5" || fieldtype == "6"){	//日期,时间,日期时间
   					eventName = "propertychange";
   				}
   			}else if(htmltype == "6"){	//关联选择
   				eventName = "propertychange";		
   			}else if(htmltype == "7"){	//附件
   				eventName = "propertychange";
   			}
   		}
   		
   		return eventName;
   	}
    	
   	//将代码整合成一个函数
   	function integrateCodeForAFun(code){
   		var variableNames = new Array();
   		var variableStartIndex = -1;
   		for(var i = 0; i < code.length; i++){	//抽取代码中的变量到数组中
			var c = code.charAt(i);
			if(c == '$'){
				if(variableStartIndex == -1){
					variableStartIndex = i;
				}else{
					var variableName = code.substring(variableStartIndex + 1, i);
					variableStartIndex = -1;
					
					//排除重复添加
					var isRepeat = false;						
					for(var j = 0; j < variableNames.length; j++){
						if(variableNames[j] == variableName){
							isRepeat = true;
							break;
						}
					}
					if(!isRepeat){
						variableNames.push(variableName);
					}
				}
			}
		}
   		
   		//获取变量的值并用这些变量值填充到代码的变量中
   		for(var i = 0; i < variableNames.length; i++){
   			var variableName = variableNames[i];
   			var variableValue = jQuery("*[name='field_" + variableName + "']").val();
   			code = code.ReplaceAll("\\$"+variableName+"\\$",variableValue);
   		}
   		
   		try{
			eval(code);
   		}catch(e){
   			alert("字段绑定的JS函数执行异常,请检查\n异常信息如下：\n" + e.message);
   		}
   		
   	}
}