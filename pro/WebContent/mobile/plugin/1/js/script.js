/* Author: ZengDongPing*/
var config={
	clientServer:"http://mdev.e-cology.cn/client.do?",   /* Mobile Core服务器地址*/
	newListPageSize:10               /* 新闻列表页面每次加载条数 */
}


var util={
		/*
	 * para
	 * {
	 * 	"loadingTarget":"",//显示Loading的目标地址
	 * 	"url":"",//得数据的URL
	 *  "callback":function(){}  //success回调  
	 * }
	 * 
	 * 
	 * passobj  //所需要传递的json object
	 * {
	 * 	
	 * }
	 * 
	 * */
	 getData:function(url,para,passobj){
	    if(para.loadingTarget!=null) jQuery(para.loadingTarget).showLoading();
		jQuery.ajax({
			type: "post",
		    url: url + "?" + para.paras,
		    dataType: "json", 
		    contentType : "CHARSET=UTF-8", 
		    complete: function(){
				if(para.loadingTarget!=null)  jQuery(para.loadingTarget).hideLoading();
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		       //alert(errorThrown);
		    } , 
		    success:function (data, textStatus) {
		    	para.callback.call(this,data,passobj);
		    } 
	    });
	},

	getDataByAction:function(para,passobj){
		
		jQuery.ajax({
			type: "post",
		    url: para.action + "?" + para.paras,
		    dataType: "json", 
		    contentType : "CHARSET=UTF-8", 
		    complete: function(){

			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		       //alert(errorThrown);
		    } , 
		    success:function (data, textStatus) {
		    	para.callback.call(this,data,passobj);
		    } 
	    });
	},
	/*
	 * 当且仅当data为非空的字符串时返回false，其他情况返回true
	 * @param data： 目标字符串
	 * @return 当且仅当data为非空的字符串时返回false，其他情况返回true
	 * */
	isNullOrEmpty: function (data) {
		if (data == undefined || data == null || data == "") {
			return true;
		}
		return false;
	},
	/*
	 * 指定格式的当前日期字符串
	 * @param format 格式化字符串
	 * @return 指定格式的当前日期字符串
	 */
	getCurrentDate4Format : function (formatstring) {
		var testDate = new Date(); 
		var testStr = testDate.format(formatstring);
		return testStr;
	}
}

/**
 * 为日期增加格式化方法
 * @param format 格式化字符串
 * @return 指定格式的字符串
 */
Date.prototype.format = function(format){ 
	var o = { 
		"M+" : this.getMonth()+1, //month 
		"d+" : this.getDate(),    //day 
		"h+" : this.getHours(),   //hour 
		"m+" : this.getMinutes(), //minute 
		"s+" : this.getSeconds(), //second 
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
		"S" : this.getMilliseconds() //millisecond 
	} 

	if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	} 

	for(var k in o) { 
		if(new RegExp("("+ k +")").test(format)) { 
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
	} 
	return format; 
}

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
     jQuery.post(url,fields,function(data){fun(data)});
}

/**
 * 保存数据
 * @param form
 * @param url
 * @param fun
 * @return
 */
function postToUrl(param,url,fun) {
	jQuery.post(url,param,function(data){fun(data)});
}