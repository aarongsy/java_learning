//-----------------------------------------
// 选择框用转换程序 start
//-----------------------------------------
if (typeof(SYSTEM_SHOW_MODAL_DIALOG) == "undefined" && typeof(SYSTEM_SHOW_MODAL_DIALOG) != "fucntion") {
	//系统模态窗口
	var SYSTEM_SHOW_MODAL_DIALOG = window.showModalDialog;
	if (window.showModalDialog == SYSTEM_SHOW_MODAL_DIALOG) {
		//重写系统模态窗口
		window.showModalDialog = function () {
			var url	= arguments[0];
			var parent = arguments[1];
			var dialogParent = arguments[2];

			if (!parent) {
				parent = "";
			}
			//ff下窗口不剧中问题统一处理
			if (!dialogParent) {
				dialogParent = "dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";";
			} else if (dialogParent != "" && dialogParent.indexOf("dialogTop") == -1) {
				dialogParent += ";dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";";
			}
			var returnValue;
			//调用系统模态窗口弹出function
			var rtnValue = SYSTEM_SHOW_MODAL_DIALOG(url, parent, dialogParent); 
			//ie下如果调用的是js，而返回值是vb则转换成json
			if (window.ActiveXObject) {
				//返回值是vb
				if (rtnValue != undefined && rtnValue != null && typeof(rtnValue) == "unknown") {
					var func = window.showModalDialog.caller;
					//判断调用模态窗口者是否是js
					if (typeof(func) == "function") {
						var tempArray = new VBArray(rtnValue).toArray();
						var tempJsonData = "{";
						if (tempArray != null) {
							for (var i=0; i<tempArray.length; i++) {
								if (i == 0) {
									tempJsonData += "id:\"" + tempArray[i] + "\"";
								} else if (i == 1) {
									tempJsonData += "name:\"" + tempArray[i] + "\"";
								} else {
									tempJsonData += "key" + i + ":\"" + tempArray[i] + "\"";
								}
								
								if (i < tempArray.length - 1) {
									tempJsonData += ", ";
								}
							}
						}
						tempJsonData += "}";
						
						returnValue =  eval('(' + tempJsonData + ')');
						return returnValue;
					}
				} else if (typeof(rtnValue) == "object"){
					//alert(window.showModalDialog.caller.caller);
					var func = window.showModalDialog.caller;
					try {
						window.console.log("href:" + window.location.href);
						window.console.log("caller type:" + typeof(func));
						window.console.log("caller content:" + func);
					} catch (e) {}
					//判断调用模态窗口者是否是vb
					if ((typeof(func) == "function" && func.toString().indexOf("function onclick()") != -1) || typeof(func) == "object") {
						return string2VbArray(json2String(rtnValue));
					} else {
						var	regex = new RegExp("jsid[ ]{0,}=[ ]{0,}new VBArray[\(]id[\)].toArray[\(][\)]", "g"); // 创建正则表达式对象。  
						var r = func.toString().match(regex);
					　　 if (r != null && r != undefined && r != "") {
						 	return string2VbArray(json2String(rtnValue));
					 	}
					}
				}
			}
			return rtnValue;
		};
	}
}