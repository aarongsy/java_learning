﻿String.prototype.ReplaceAll = stringReplaceAll;
function  stringReplaceAll(AFindText,ARepText){  
	raRegExp = new RegExp(AFindText,"g");  
	return this.replace(raRegExp,ARepText);
}

function checkForm(thisform,items,message){
	thisform = thisform;
	items = ","+items + ",";
	for(i=1;i<=thisform.length;i++)	{
		tmpname = thisform.elements[i-1].name;
		tmpvalue = thisform.elements[i-1].value;
	     if(tmpvalue==null){
	        continue;
	    }
		while(tmpvalue.indexOf(" ") == 0 || tmpvalue.indexOf("　") == 0)
			tmpvalue = tmpvalue.substring(1,tmpvalue.length);
		if(tmpname!="" &&items.indexOf(","+tmpname+ ",")!=-1 && tmpvalue == ""){
			 alert(message);
			 return false;
			}
	}	
	if(window.ActiveXObject) {
		if(event!=null &&getValidStr(event.srcElement.disabled) == "false")
		event.srcElement.disabled = true;
	}	
	return true;
}
function isConfirm(message){
   if(!confirm(message)){
       return false;
   }
   return true;
}
function fieldcheck(elementobj,checkrule,objname){
	var elementvalue = Trim(getValidStr(elementobj.value));
	checkrule = Trim(getValidStr(checkrule));
	if(elementvalue=="")
		return;
		
	if(checkrule=="")
		return;		
	var valid=false;
	eval("valid=/"+checkrule+"/.test(\""+elementvalue+"\");");

	if (!valid){
		alert("["+objname+"]"+decode("^8be5^5b57^6bb5^7684^8f93^5165^503c^4e0d^7b26^5408^6821^9a8c^89c4^5219^ff01"));
		
		elementobj.value = "";
	}
}
function fieldcheck2(elementobj,checkrule,objname){
	var elementvalue = Trim(getValidStr(elementobj.innerHTML));
	checkrule = Trim(getValidStr(checkrule));
	if(elementvalue=="")
		return;		
	if(checkrule=="")
		return;		
	var valid=false;
	eval("valid=/"+checkrule+"/.test(\""+elementvalue+"\");");

	if (!valid){
		alert("["+objname+"]"+decode("^8be5^5b57^6bb5^7684^8f93^5165^503c^4e0d^7b26^5408^6821^9a8c^89c4^5219^ff01"));
		
		elementobj.innerHTML = "";
	}
}
function checkInput(elementname,spanid){
	tmpvalue = document.all(elementname).value;

	while(tmpvalue.indexOf(" ") == 0 || tmpvalue.indexOf("　") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""){
		 document.all(spanid).innerHTML='';
	}
	else{
	 document.all(spanid).innerHTML="<IMG src='/vimgs/checkinput.gif' align=absMiddle>";
	 document.all(elementname).value = "";
	 alert("必填项不能为空！");
	}
}
function checkInputLenth(elementname,min,max){
	tmpvalue = document.all(elementname).value;
	tmpvalue = Trim(tmpvalue);
	if(tmpvalue.length>=min && tmpvalue.length<=max){
		 return true;
	}
	else{
		
	 	document.all(elementname).value = "";
	 	msg="请输入"+min+"－"+max+"位字符";
	 	alert(msg);
	 	return false;
	}
}

function checkInt_KeyPress(){
 if(!(window.event.keyCode>=48 && window.event.keyCode<=57))  {
     window.event.keyCode=0;
  }
}
function checkFloat_KeyPress(){
 if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==46))  {
     window.event.keyCode=0;
  }
}
function checkPhone_KeyPress(){
 if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==45))  {
     window.event.keyCode=0;
  }
}
function checkABC_KeyPress(){
 if(!(window.event.keyCode>=65 && window.event.keyCode<=90))  {
     window.event.keyCode=0;
  }
}
function checkQuotes_KeyPress(){
 if(window.event.keyCode==39)  {
     window.event.keyCode=0;
  }
}
function checkEmail(elementname){
	tmpvalue = document.all(elementname).value;
	while(tmpvalue.indexOf(" ") == 0){
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	}
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {
	 document.all(elementname).value = "";
	}
}
function checkinput_char_num(elementname){
	valuechar = document.all(elementname).value.split("") ;
	if(valuechar.length==0){
	    return ;
	}
	notcharnum = false ;
	notchar = false ;
	notnum = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		notchar = false ;
		notnum = false ;
		charnumber = parseInt(valuechar[i]) ; if(isNaN(charnumber)) notnum = true ;
		if(valuechar[i].toLowerCase()<'a' || valuechar[i].toLowerCase()>'z') notchar = true ;
		if(notnum && notchar) notcharnum = true ;
	}
	if(valuechar[0].toLowerCase()<'a' || valuechar[0].toLowerCase()>'z') notcharnum = true ;
	if(notcharnum) document.all(elementname).value = "" ;
}
function RTrim(str){
    var whitespace = new String(" \t\n\r");
    var s = new String(str);
    if (whitespace.indexOf(s.charAt(s.length-1)) != -1) {
        var i = s.length - 1;
        while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1) {
            i--;
        }
        s = s.substring(0, i+1);
    }
    return s;
}
function LTrim(str){
    var whitespace = new String(" \t\n\r");
    var s = new String(str);
    if (whitespace.indexOf(s.charAt(0)) != -1) {
        var j=0, i = s.length;
        while (j < i && whitespace.indexOf(s.charAt(j)) != -1) {
            j++;
        }
        s = s.substring(j, i);
    }
    return s;
}
function Trim(str){
    return RTrim(LTrim(str));
}
function getStringValue(value){
	if (typeof(value)=="string" || typeof(value)=="object")
		return "\""+getValidStr(value)+"\"";
	else if (typeof(value)=="date"){
		return "\""+(new Date(value))+"\"";
	}else if (getValidStr(value)=="")
		return "\"\"";
	else
		return value;
}
function getValidStr(str) {
	str+="";
	if (str=="undefined" || str=="null")
		return "";
	else
		return str;
}
function encode(strIn){
	var intLen=strIn.length;
	var strOut="";
	var strTemp;

	for(var i=0; i<intLen; i++)	{
		strTemp=strIn.charCodeAt(i);
		if (strTemp>255){
			tmp = strTemp.toString(16);
			for(var j=tmp.length; j<4; j++) tmp = "0"+tmp;
			strOut = strOut+"^"+tmp;
		}
		else	{
			if (strTemp < 48 || (strTemp > 57 && strTemp < 65) || (strTemp > 90 && strTemp < 97) || strTemp > 122){
				tmp = strTemp.toString(16);
				for(var j=tmp.length; j<2; j++) tmp = "0"+tmp;
				strOut = strOut+"|"+tmp;
			}
			else{
				strOut=strOut+strIn.charAt(i);
			}
		}
	}
	return (strOut);
}
function decode(strIn){
    var intLen = strIn.length;
    var strOut = "";
    var strTemp;
    
    for (var i = 0; i < intLen; i++) {
        strTemp = strIn.charAt(i);
        switch (strTemp) {
            case "|":
                strTemp = strIn.substring(i + 1, i + 3);
                strTemp = parseInt(strTemp, 16);
                strTemp = String.fromCharCode(strTemp);
                strOut = strOut + strTemp;
                i += 2;
                break;
                
            case "^":
                strTemp = strIn.substring(i + 1, i + 5);
                strTemp = parseInt(strTemp, 16);
                strTemp = String.fromCharCode(strTemp);
                strOut = strOut + strTemp;
                i += 4;
                break;
                
            default:
                strOut = strOut + strTemp;
                break;
                
        }        
    }
    return (strOut);
}

function getEncodeStr(str) {
	return encode(getValidStr(str));
}

function getDecodeStr(str) {
	return ((str)?decode(getValidStr(str)):"");
}
//函数名：fucCheckNUM
//功能介绍：检查是否为数字
//参数说明：要检查的数字
//返回值：1为是数字，0为不是数字
function fucCheckNUM(NUM){
	 var i,j,strTemp;
	 strTemp="0123456789";
	 if ( NUM.length== 0)
	 	return 0
	 for (i=0;i<NUM.length;i++) {
		 j=strTemp.indexOf(NUM.charAt(i)); 
		 if (j==-1) {
		 	alert("请输入数字...");
			 //说明有字符不是数字
			 return 0;			 
		 }
	 }	 
	 //说明是数字
	 return 1;
}
function fucCheckNUM2(NUM){
	 var i,j,strTemp;
	 strTemp=".0123456789";
	 if ( NUM.length== 0)
	 	return 0
	 for (i=0;i<NUM.length;i++) {
		 j=strTemp.indexOf(NUM.charAt(i)); 
		 if (j==-1) {
		 	alert("请输入数字...");
			 return 0;			 
		 }
	 }	 
	 //说明是数字
	 return 1;
}
function goPage(pageno){
  document.VelcroForm.pageno.value=pageno;
  document.VelcroForm.submit();
}  
function prePage(){
  var pageno=document.getElementById("pageno");
  var oValue=pageno.value;
  oValue=oValue*1-1;
  pageno.value=oValue;
	document.VelcroForm.submit();
}  
function nextPage(){
	var pageno=document.getElementById("pageno");
  var oValue=pageno.value;
  oValue=oValue*1+1;
  pageno.value=oValue;
	document.VelcroForm.submit();
} 
/*=========================各个模块名称验证=========================*/
	var XMLHttpReq = false;
 	//创建XMLHttpRequest对象       
    function createXMLHttpRequest() {
		if(window.XMLHttpRequest) { //Mozilla 浏览器
			XMLHttpReq = new XMLHttpRequest();
		}
		else if (window.ActiveXObject) { // IE浏览器
			try {
				XMLHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					XMLHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {}
			}
		}
	}
/**
 * 处理系统表单里名称是否重复
 * objname:input框的name
 * elementobj：文本框本身
 * formid：forminfo的id
 */
function checkname(objname,elementobj,formid,event){
	createXMLHttpRequest();
	var selectDiv =document.getElementById("selectdiv");
	var selectDiv1 =document.getElementById("selectdiv1");
	var inputnameDiv = document.getElementById(objname);	
	//selectDiv.inputid = objname;
	selectDiv.inputname = objname;
	var elementvalue = Trim(getValidStr(encodeURIComponent(elementobj.value)));
	if(elementvalue!=""){	
        var url = "/ServiceAction/com.velcro.base.GetDataAction?action=checkname&formid="+formid+"&elementvalue="+elementvalue;  
	   	XMLHttpReq.open("GET",url,true);
		XMLHttpReq.onreadystatechange = processResponse;//指定响应函数
		XMLHttpReq.send(null);  // 发送请求
	}
	else{
		document.getElementById("selectdiv").innerHTML=""; 
	}
	// 处理返回信息函数   
	function processResponse() {
		if(XMLHttpReq.readyState==0){//如果XMLHttpReq.readyState为0就让他重新调用
			checkname(objname,elementobj,formid);
		}
    	if (XMLHttpReq.readyState == 4) { // 判断对象状态
        	if (XMLHttpReq.status == 200) { // 信息已经成功返回，开始处理信息
                var xmldata=XMLHttpReq.responseXML;	
				var data=formateXML(xmldata);
				setdate(data);
				selectDiv.style.offsetTop = inputnameDiv.offsetTop+23;
				selectDiv.style.display ="";  
            } else { //页面不正常
                window.alert("您所请求的页面有异常。");
            }
        }
    }
 }
 /**
  * 将取得的数据显示在层中
  */
   function setdate(data){
   	var tbsize = data.length;
   	var selectDiv = document.getElementById("selectdiv");
   	selectDiv.innerHTML="";
   	var inputname = selectDiv.inputname;
   	var closeDiv = document.createElement("div");
   	closeDiv.id="closeDiv";
	closeDiv.appendChild(document.createTextNode("×"));
	closeDiv.title="CLOSE";
	closeDiv.onclick = function(){
   		var selectDiv =document.getElementById("selectdiv");
 		selectDiv.style.display ="none";  
 	};
	selectdiv.appendChild(closeDiv);
	for(var i=0; i<tbsize; i++){
		var oDiv = document.createElement("div");
		oDiv.name="nameDIV";
		oDiv.innerHTML = data[i].objname;
		oDiv.onmouseout= function(){this.style.backgroundColor='';this.style.cursor='default'; return true;};
		oDiv.onmouseover= function(){this.style.backgroundColor='#9966FF';this.style.cursor='hand'; return true;};		
		oDiv.onclick = function() {
			var oEvent = window.event;
			var obj = oEvent.srcElement;	
			document.getElementById(inputname).value=obj.innerHTML;
			selectDiv.innerHTML="";
			selectDiv.style.display = "none";
		};		
		
		selectdiv.appendChild(oDiv);
	}
}
/**
 * 将xml数据压入到数组中
 */
function formateXML(xmldata){
	var items=xmldata.getElementsByTagName("item");
	var itemList=new Array();
	if(items==null){
		return itemList;
	}
	for(var i=0;i<items.length;i++){
		var oname=getXmlNodeValue1(xmldata,"objname",i);
		var item={"objname":oname}
		itemList.push(item);
	}
	return itemList;
}
/**
 * 通过各个节点名称取得xml数据
 */
function getXmlNodeValue1(xmldata,tagName,i){	
		var date=xmldata.getElementsByTagName(tagName)[i].firstChild.nodeValue;
		return date;	
}
function getPostion(event){
	var posision = {x:50,y:50};
	var ev = window.event;
	if(arguments.length==3){		
		if (ev.clientX || ev.clientY) {
			posision.x = ev.clientX;
			posision.y = ev.clientY;
		}
	}else{
		if(!ev)	ev = event;		
		if (ev.pageX || ev.pageY) {
			posision.x = ev.pageX;
			posision.y = ev.pageY;
		}
		if (ev.clientX || ev.clientY) {
			posision.x = ev.clientX;
			posision.y = ev.clientY;
		}
	}	
	var scrollTop=document.body.scrollTop;
	var scrollLeft=document.body.scrollLeft;
	posision.x=posision.x+parseInt(scrollLeft);
	posision.y=posision.y+parseInt(scrollTop);
	/*
	var xm=50;
	var ym=50;
	var xmod=posision.x%xm;
	var ymod=posision.y%ym;
	posision.x=(xmod>xm/2)?(posision.x+(xm-xmod)):(posision.x-xmod);
	posision.y=(ymod>ym/2)?(posision.y+(ym-ymod)):(posision.y-ymod);
	*/
	return posision;
}
/*日历选择*/
function getdate(event,field,fieldspan,isneeded){
	var posision = {x:50,y:50};
	var cal = new Calendar();
	var ev = window.event;
	if(arguments.length==3){		
		if (ev.clientX || ev.clientY) {
			posision.x = ev.clientX;
			posision.y = ev.clientY;
		}
		cal.create(arguments[0],arguments[1],arguments[2],posision);
	}else{
		if(!ev)	ev = event;		
		if (ev.pageX || ev.pageY) {
			posision.x = ev.pageX;
			posision.y = ev.pageY;
		}
		if (ev.clientX || ev.clientY) {
			posision.x = ev.clientX;
			posision.y = ev.clientY;
		}
		cal.create(field,fieldspan,isneeded,posision);
	}	
	cal=null;
}
/*时间选择*/
function gettime(event,field,fieldspan,isneeded){
	var posision = {x:50,y:50};
	var timer = new Timer();
	var ev = window.event;
	if(arguments.length==3){		
		if (ev.clientX || ev.clientY) {
			posision.x = ev.clientX;
			posision.y = ev.clientY;
		}
		timer.create(arguments[0],arguments[1],arguments[2],posision);
	}else{
		if(!ev)	ev = event;		
		if (ev.pageX || ev.pageY) {
			posision.x = ev.pageX;
			posision.y = ev.pageY;
		}
		if (ev.clientX || ev.clientY) {
			posision.x = ev.clientX;
			posision.y = ev.clientY;
		}
		timer.create(field,fieldspan,isneeded,posision);
	}
	timer=null;
}
/*当鼠标移动到人员链接上是否显示人员相片用*/
function showimg(url,humresname){
	document.all("hrnamespan").value=humresname;
	document.getElementById("humresimg").src=url;
}