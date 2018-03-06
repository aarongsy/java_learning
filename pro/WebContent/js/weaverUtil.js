// JavaScript Document
String.prototype.trim=function(){
	return this.replace(/^\s+|\s+$/g,"");
};
String.prototype.endsWith=function(suffix){
	return this.substring(this.length-suffix.length).toLowerCase()==suffix.toLowerCase();
};
String.prototype.startsWith=function(prefix){
	return this.substr(0,prefix.length).toLowerCase()==prefix.toLowerCase();
};
String.prototype.isNumeric=function(){
	return !/[\D]+/i.test(this.trim());
};
String.prototype.LenB=function(){
	//var s=this.replace(/[^\x00-\xff]/g,"AA");
	return this.length;
};
[].indexOf || (Array.prototype.indexOf = function(v){
	for(var i = this.length; i-- && this[i] !== v;);
	return i;
});
if(typeof($)=='undefined'){
	function $(id){return (typeof(id)=='object')?id:document.getElementById(id);}
};

if(typeof(WeaverUtil)=='undefined')
	var WeaverUtil=null;
	
(function(){
if(typeof(WeaverUtil)!='undefined' && WeaverUtil!=null) return;

var propertychangeInterval = null;
var propertychangeObjs = new Array();

WeaverUtil={
	isDefined:function(s){return (typeof(s)!='undefined');},
	isEmpty:function(s){return (!this.isDefined(s) || s==null || s.toString()=='');},
	isObject:function(s){return (typeof(s)=='object');},
	isFunction:function(s){return (typeof(s)=='function');},
	isArray:function(s){return (this.isObject(s) && (s instanceof Array));},
	getPosition:_getPosition,
	imports:_importFiles,
	addEvent:_addEvent,
	isDebug:true,
	log:_log,
	generateId:_generateId,
	load:_load,
	watch: function(obj, fn){
		if(obj.addEventListener && getIEv() != 10){	//IE10也支持addEventListener,所以加一个过滤条件
			obj.addEventListener("DOMAttrModified", fn);
			obj.addEventListener("input", fn);

			//处理js赋值的事件触发问题(firefox可能不需要通过以下的方式来处理，但是chrome和safari不行)
			var objTagName = obj.tagName.toLowerCase();
			var objType = obj.getAttribute("type");
			if(objType){
				objType = objType.toLowerCase();
			}
			var objOnClickStr = obj.getAttribute("onclick");
			if(!objOnClickStr){
				objOnClickStr = "";
			}
			//当是隐藏域和时间控件时，使用此机制，因为这两块一般使用js赋值
			if(objTagName == "input" && (objType == "hidden" || objOnClickStr.indexOf("WdatePicker") != -1)){
				
				function addObjInPropertychangeObjs(theObj, theFn){
					if(!theObj){
						return;
					}
					var flag = false;
					for(var i = 0; i < propertychangeObjs.length; i++){
						if(propertychangeObjs[i]["targetObj"] == theObj){
							flag = true;
							break;
						}
					}
					if(!flag){
						propertychangeObjs.push({"targetObj": theObj, "value": theObj.value, "fn" : theFn});
					}
				}
				
				addObjInPropertychangeObjs(obj, fn);
		
				if(!propertychangeInterval){
					
					function triggerPropertychange(){
						for(var i = 0; i < propertychangeObjs.length; i++){
							var theObj = propertychangeObjs[i]["targetObj"];
							var oldValue = propertychangeObjs[i]["value"];
							if(theObj && theObj.value != oldValue){
								propertychangeObjs[i]["value"] = theObj.value;
								WeaverUtil.fire(theObj);
							}
						}
					}
					
					propertychangeInterval = setInterval(triggerPropertychange, 1000);
				}
		    }
		    //如果是通过addRow添加的子表触发下sql取数
		    if(obj.getAttribute('_trrigger')=='1'){
				WeaverUtil.fire(obj);
				obj.setAttribute('_trrigger',0);
			}
		}else if(obj.attachEvent){
			obj.attachEvent("onpropertychange", fn);
			//如果是通过addRow添加的子表触发下sql取数
			if(obj.getAttribute('_trrigger')=='1'){
				event_fire(obj);
				obj.setAttribute('_trrigger',0);
			}
		}
	},
	fire: function(obj){
		if(obj.addEventListener && getIEv() != 10){
			var attr = obj.getAttributeNode("value");
			var evt = document.createEvent('MutationEvents');   
			evt.initMutationEvent('DOMAttrModified',true,true,attr,null,obj.value,"value",MutationEvent.MODIFICATION);
			obj.dispatchEvent(evt);
		}else{
			if(getIEv()==6||getIEv()==7)
				obj.value=obj.value;
			 else
				obj.fireEvent("onpropertychange");
		}
	}
};
function event_fire(obj){
	if(obj.addEventListener && getIEv() != 10){
		var attr = obj.getAttributeNode("value");
		var evt = document.createEvent('MutationEvents');   
		evt.initMutationEvent('DOMAttrModified',true,true,attr,null,obj.value,"value",MutationEvent.MODIFICATION);
		obj.dispatchEvent(evt);
	}else{
		if(getIEv()==6||getIEv()==7)
			obj.value=obj.value;
		 else
			obj.fireEvent("onpropertychange");
	}
}
/**
 * @param Object o
 * @return {x:*,y:*}
 **/
function _getPosition(o){
	var p1=0,p2=0;
	while(o!=null){
		p1 += o.offsetLeft;
		p2 += o.offsetTop;
		o = o.offsetParent;
	}
	return {"x":p1,"y":p2};
}

function _importFiles(a0){
	var files=null;
	if(typeof(a0)=='string')files=new Array(a0);
	else if(typeof(a0)=='object' && a0 instanceof Array)files=a0;
	if(files==null){alert('imports arguments is not String or array!');return;}
	var lang="javascript";
	for(var i=0;i<files.length;i++){
		var src=files[i];
		if(src.endsWith(".vbs"))lang="VBScript";
		else if(src.endsWith(".css"))lang="styleSheet";
		var s=null;
		if(lang.endsWith('script'))
			s=new Array('<scr','ipt language="',lang,'" type="text/',lang,'" src="',src,'"></scr','ipt>');
		else s=new Array('<link type="text/css" rel="stylesheet" href="',src,'" />');
		document.writeln(s.join(''));
	}//End for.
}

function _addEvent(obj,name,fun,isCapture){
	isCapture=isCapture | false;
	if(document.all)
		obj.attachEvent('on' + name, fun);
	else obj.addEventListener(name, fun,isCapture);
}

function _log(s){
	if(!this.isDebug)return;
	var debugId="WeaverUtil_DebugContainer";
	var o=document.getElementById(debugId);
	if(o==undefined || o==null){
		o=document.createElement("div");
		o.className="WeaverUtilDebugInfo";
		o.id=debugId;
		document.body.appendChild(o);
	}
	o.innerHTML+=_Now()+'--'+s+'<br/>';
}
function _Now(o){
	var d=null;
	var b=false;
	switch(typeof(o)){
	case 'number':
		b=(o==0)?true:false;
		d=(o==0)?new Date():new Date(o);
	break;
	case 'string':
		b=false;d=new Date(Date.parse(o));
	break;
	case 'object':
		//o.constructor=="Date"
		b=false;d=o;
	break;
	default:
		d=new Date();
	}
	var f=function(v){return (v>9)?''+v:'0'+v;}	
	var s=new Array(d.getFullYear(),b?'':"-",f(d.getMonth()+1),b?'':'-',f(d.getDate()),b?'':' ',f(d.getHours()),b?'':':',f(d.getMinutes()),b?'':':',f(d.getSeconds()));
	return s.join('');
}

function _getDateString(){
	return _Now(0);
}

function _generateId(prefix){
	var s=prefix?prefix:"WEAVER";
	return s+Math.ceil((Math.random()*899+100))+_getDateString();
}

function _load(callback){
	if(typeof(callback)!='function')return;
	this.addEvent(window,"load",callback);
}

}());

var SqlEditor={
name:"sqlEditor",
editor:null,
init:function(prefix){
	var span=document.createElement("span");
	span.innerHTML='<textarea id="'+this.name+'" style="display:none;position:absolute;width:600px;height:300px;"></textarea>';
	document.body.appendChild(span);
	this.editor=$(this.name);
	var inputs=document.body.getElementsByTagName("input");
	var len=inputs.length;
	var input=null;
	if(!Ext.isArray(prefix))prefix=[prefix];
	for(var i=0;i<len;i++){
		input=inputs[i];
		if(input.type=='text' && this.isPrefix(prefix,input.name)){
			Ext.EventManager.addListener(input,"focus",SqlEditor.Show);
		}
	}
	inputs=document.body.getElementsByTagName("textarea");
	len=inputs.length;
	for(var i=0;i<len;i++){
		input=inputs[i];
		if(this.isPrefix(prefix,input.name)){
			Ext.EventManager.addListener(input,"focus",SqlEditor.Show);
		}
	}
	Ext.EventManager.addListener(this.editor,"blur",SqlEditor.Hide);
	var w=parseInt(document.body.clientWidth);
	var h=parseInt(document.body.clientHeight);
//	alert(w+","+h+",w:"+document.body.clientWidth);
	var editorW=parseInt(this.editor.style.width);
	var editorH=parseInt(this.editor.style.height);
	//alert(editorW+","+editorH);
	this.editor.style.top=Math.ceil((h-editorH)/2)+"px";
	this.editor.style.left=Math.ceil((w-editorW)/2)+"px";
},
isPrefix:function(arPrefix,name){
	var bl=false;
	for(var i=0;i<arPrefix.length;i++){
		if(name.startsWith(arPrefix[i])){
			bl=true;break;
		}
	}
	return bl;
},
Show:function(e){
	Ext.get(SqlEditor.name).show();
	var o=Event.element(e);	
	SqlEditor.editor.setAttribute("_inputId",o.id);
	SqlEditor.editor.value=o.value;
	SqlEditor.editor.focus();
},
Hide:function(e){
	Ext.get(SqlEditor.name).hide();
	var inputId=SqlEditor.editor.getAttribute("_inputId");
	var val=SqlEditor.editor.value;
	var dom=Ext.getDom(inputId);
	if(dom.tagName!='TEXTAREA')
		val=val.replace(/\r|\n/gi,' ');
	Ext.getDom(inputId).value=val;
}
};

function getBrowserValue(url){
	var ret=null;
	var data = openDialog(contextPath+"/base/popupmain.jsp?url="+encodeURIComponent(url));
	if(typeof(data)!='undefined'){
		if(Object.prototype.toString.apply(data) === '[object Array]'&&data[0]!="0"){
			ret = data;
		}
	};
	return ret;
}
function getIEv(){
	if(!document.all)return 8;
	var strVer=window.navigator.appVersion;
	var iev=0;
	if(strVer.substr(17,4)=="MSIE"){
		iev=strVer.substr(22,(strVer.indexOf(";", 22) - 22));
	}
	return parseInt(iev);
}
