
String.prototype.trim=function(){
	return this.replace(/^\s+|\s+$/g,"");
}
String.prototype.endsWith=function(suffix){
	return this.substring(this.length-suffix.length).toLowerCase()==suffix.toLowerCase();
}
String.prototype.startsWith=function(prefix){
	return this.substr(0,prefix.length).toLowerCase()==prefix.toLowerCase();
}
String.prototype.isNumeric=function(){
	return !/[\D]+/i.test(this.trim());
}
String.prototype.LenB=function(){
	//var s=this.replace(/[^\x00-\xff]/g,"AA");
	return this.length;
}
String.prototype.getBytesLength = function() { 
	return this.replace(/[^\x00-\xff]/gi, "--").length; 
}
String.prototype.ReplaceAll = stringReplaceAll; 
function  stringReplaceAll(AFindText,ARepText){  
	raRegExp = new RegExp(AFindText,"g");  
	return this.replace(raRegExp,ARepText);
}

function checkForm(thisform,items,message){
    thisform = thisform;
    var ids=items.split(',');
    items = ","+items + ",";	
	for(var i=0;i<ids.length;i++){
		if(Ext.isEmpty(ids[i]) || !ids[i].endsWith('file')) continue;
		var fieldId=ids[i].substring(0,ids[i].length-4);
		if(!existAttachIds(fieldId)){
			alert(message);
            return false;
		}
	}

    for(i=1;i<=thisform.length;i++){
        tmpname = thisform.elements[i-1].name;
        tmpvalue = thisform.elements[i-1].value;
        if(thisform.elements[i-1].tagName=='TEXTAREA' && document.getElementById(tmpname+'___Frame')!=null){
            tmpvalue=FCKEditorExt.getText(tmpname);
        }
        if(thisform.elements[i-1].tagName=="TEXTAREA" && document.getElementById("cke_" + tmpname)!=null){	//新版ckeditor验证方式
        	tmpvalue=CKEditorExt.getText(tmpname);
        }
        if(tmpvalue==null){
            continue;
        }
        while(tmpvalue.indexOf(" ") == 0 || tmpvalue.indexOf("　") == 0)
            tmpvalue = tmpvalue.substring(1,tmpvalue.length);
        if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && (tmpvalue == ""||tmpvalue=='null')){
             alert(message);
             return false;
        }
    }
    
    if(document.all){
        if(event&&getValidStr(event.srcElement.disabled) == "false"&&event.srcElement.name=="")
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
    var idx=checkrule.indexOf("function:");
    if(idx>-1){
        funcname=checkrule.substring(9);
        scripts="valid="+funcname+"(elementvalue);";
        eval(scripts) ;
        if (!valid) {
            elementobj.value = "";
            elementobj.focus();
        }
        return;
    }
	eval("valid=/"+checkrule+"/.test(\""+elementvalue+"\");");

	if (!valid){
		alert("["+objname+"]"+decode("^8be5^5b57^6bb5^7684^8f93^5165^503c^4e0d^7b26^5408^6821^9a8c^89c4^5219^ff01"));
		
		elementobj.value = "";
        elementobj.focus();
        return false;
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
    var idx=checkrule.indexOf("function:");
        if(idx>-1){
            funcname=checkrule.substring(9);
            scripts="valid="+funcname+"(elementvalue);";
            eval(scripts);
            if (!valid) {
                elementobj.innerHTML = "";
            }
            return;
        }
	eval("valid=/"+checkrule+"/.test(\""+elementvalue+"\");");

	if (!valid){
		alert("["+objname+"]"+decode("^8be5^5b57^6bb5^7684^8f93^5165^503c^4e0d^7b26^5408^6821^9a8c^89c4^5219^ff01"));
		
		elementobj.innerHTML = "";
	}
}
    function checkIdcard(idcard) {
        var Errors = new Array("验证通过!", "身份证号码位数不对!", "身份证号码出生日期超出范围或含有非法字符!", "身份证号码校验错误!", "身份证地区非法!");
        var area = {11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"};
        var idcard,Y,JYM;
        var S,M;
        var idcard_array = new Array();
        idcard_array = idcard.split("");
        if (area[parseInt(idcard.substr(0, 2))] == null) {
            alert(Errors[4])
            return false;
        }
        switch (idcard.length) {
            case 15:
                if ((parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0 || ((parseInt(idcard.substr(6, 2)) + 1900) % 100 == 0 && (parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0 )) {
                    ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性
                }
                else {
                    ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性
                }
                if (ereg.test(idcard))
                    return true;
                else{
                    alert(Errors[2]);
                    return false;
                }
                break;
            case 18:
                if (parseInt(idcard.substr(6, 4)) % 4 == 0 || (parseInt(idcard.substr(6, 4)) % 100 == 0 && parseInt(idcard.substr(6, 4)) % 4 == 0 )) {
                    ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式
                }
                else {
                    ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式
                }
                if (ereg.test(idcard)) {
                    S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 + (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 + (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 + (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 + (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 + (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 + (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 + parseInt(idcard_array[7]) * 1 + parseInt(idcard_array[8]) * 6 + parseInt(idcard_array[9]) * 3;
                    Y = S % 11;
                    M = "F";
                    JYM = "10X98765432";
                    M = JYM.substr(Y, 1);
                    if (M == idcard_array[17])
                        return true;
                    else{
                        alert(Errors[3])
                        return false;
                    }
                }
                else{
                    alert(Errors[2])
                    return false;
                }
                break;
            default:
                alert(Errors[1])
                return false;
                break;
        }
    }
/**
 * 必填验证处理函数
 * @param {Object} elementname
 * @param {Object} spanid
 */
function checkInput(elementname,spanid){
	var tmpvalue = document.all(elementname).value; 
	if(document.all(elementname)){
		if(tmpvalue){
			while(tmpvalue.indexOf(" ") == 0 || tmpvalue.indexOf("　") == 0)
				tmpvalue = tmpvalue.substring(1,tmpvalue.length);
			if(tmpvalue!=""&&tmpvalue!='null'){
		        if(document.all(spanid)!=null)
				 document.all(spanid).innerHTML='';
			}else{
			 document.all(spanid).innerHTML="<IMG src='"+contextPath+"/images/base/checkinput.gif' align=absMiddle>";
			 document.all(elementname).value = "";
			}
		}else{
			 document.all(spanid).innerHTML="<IMG src='"+contextPath+"/images/base/checkinput.gif' align=absMiddle>";
			 document.all(elementname).value = "";
		}
	}
}
/**
 * 验证长度处理函数
 * @param {Object} elementname
 * @param {Object} min
 * @param {Object} max
 * @return {TypeName} 
 */
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

/**
 * 验证字符串字节长度处理函数
 * @param {Object} elementname
 * @param {Object} min
 * @param {Object} max
 * @return {TypeName} 
 */
function checkInputByteLenth(elementname,min,max){
	tmpvalue = document.all(elementname).value;
	tmpvalue = Trim(tmpvalue);
	if(tmpvalue.getBytesLength()>=min && tmpvalue.getBytesLength()<=max){
		 return true;
	}
	else{
	 	document.all(elementname).value = "";
	 	msg="请输入"+min+"－"+max+"位字符";
	 	alert(msg);
	 	return false;
	}
}

function checkInt_KeyPress()
{
 if(!(window.event.keyCode>=48 && window.event.keyCode<=57))
  {
     window.event.keyCode=0;
  }
}


function checkFloat_KeyPress()
{
 if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==46))
  {
     window.event.keyCode=0;
  }
}


function checkPhone_KeyPress()
{
 if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==45))
  {
     window.event.keyCode=0;
  }
}


function checkABC_KeyPress()
{
 if(!(window.event.keyCode>=65 && window.event.keyCode<=90))
  {
     window.event.keyCode=0;
  }
}

function checkQuotes_KeyPress()
{
 if(window.event.keyCode==39)
  {
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


function checkinput_char_num(elementname)
{
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

function checkinput_char_num_spl(elementname)
{
	valuechar = document.all(elementname).value.split("") ;
	if(valuechar.length==0){
	    return ;
	}
	notcharnum = false ;
	notchar = false ;
	notnum = false ;
	notsplit = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		notchar = false ;
		notnum = false ;
		notsplit = false ;
		charnumber = parseInt(valuechar[i]) ; 
		if(isNaN(charnumber)) notnum = true ;
		if(valuechar[i].toLowerCase()<'a' || valuechar[i].toLowerCase()>'z') notchar = true ;
		if(valuechar[i] != '_') notsplit = true;
		if(notnum && notchar && notsplit) notcharnum = true ;
	}
	if(valuechar[0].toLowerCase()<'a' || valuechar[0].toLowerCase()>'z') notcharnum = true ;
	if(notcharnum) document.all(elementname).value = "" ;
}



function RTrim(str)
{
    var whitespace = new String(" \t\n\r");
    var s = new String(str);
    if (whitespace.indexOf(s.charAt(s.length-1)) != -1)
    {
        var i = s.length - 1;
        while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
        {
            i--;
        }
        s = s.substring(0, i+1);
    }
    return s;
}

function LTrim(str)
{
    var whitespace = new String(" \t\n\r");
    var s = new String(str);
    if (whitespace.indexOf(s.charAt(0)) != -1)
    {
        var j=0, i = s.length;
        while (j < i && whitespace.indexOf(s.charAt(j)) != -1)
        {
            j++;
        }
        s = s.substring(j, i);
    }
    return s;
}

function Trim(str)
{
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

function encode(strIn)
{
	var intLen=strIn.length;
	var strOut="";
	var strTemp;

	for(var i=0; i<intLen; i++)
	{
		strTemp=strIn.charCodeAt(i);
		if (strTemp>255)
		{
			tmp = strTemp.toString(16);
			for(var j=tmp.length; j<4; j++) tmp = "0"+tmp;
			strOut = strOut+"^"+tmp;
		}
		else
		{
			if (strTemp < 48 || (strTemp > 57 && strTemp < 65) || (strTemp > 90 && strTemp < 97) || strTemp > 122)
			{
				tmp = strTemp.toString(16);
				for(var j=tmp.length; j<2; j++) tmp = "0"+tmp;
				strOut = strOut+"|"+tmp;
			}
			else
			{
				strOut=strOut+strIn.charAt(i);
			}
		}
	}
	return (strOut);
}

function decode(strIn)
{
	var intLen = strIn.length;
	var strOut = "";
	var strTemp;

	for(var i=0; i<intLen; i++)
	{
		strTemp = strIn.charAt(i);
		switch (strTemp)
		{
			case "|":{
				strTemp = strIn.substring(i+1, i+3);
				strTemp = parseInt(strTemp, 16);
				strTemp = String.fromCharCode(strTemp);
				strOut = strOut+strTemp;
				i += 2;
				break;
			}
			case "^":{
				strTemp = strIn.substring(i+1, i+5);
				strTemp = parseInt(strTemp,16);
				strTemp = String.fromCharCode(strTemp);
				strOut = strOut+strTemp;
				i += 4;
				break;
			}
			default:{
				strOut = strOut+strTemp;
				break;
			}
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

	 for (i=0;i<NUM.length;i++)
	 {

		 j=strTemp.indexOf(NUM.charAt(i)); 

		 if (j==-1)
		 {
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

	 for (i=0;i<NUM.length;i++)
	 {

		 j=strTemp.indexOf(NUM.charAt(i)); 

		 if (j==-1)
		 {
		 	alert("请输入数字...");
			 //说明有字符不是数字

			 return 0;
			 
		 }
	 }
	 
	 //说明是数字

	 return 1;
}

function attachUploadIsUsedUploadifyPlugin(){
	return (typeof(jQuery) != "undefined" && typeof(jQuery.fn.uploadify) != "undefined");
}

var multiUploadObjs = [];	//存放使用jQuery.uploadify插件进行上传的对象,对象内容{"id":xxx,"obj":xxx}
/**
* 通过字段id禁用掉附件上传(子表行删除前调用,避免IE8,9删除行后flash会不断报JS错误)
*/
function destroyMultiUploadObj(id){
	for(var i = 0; i < multiUploadObjs.length; i++){
		if(multiUploadObjs[i]["id"] == id){
			var obj = multiUploadObjs[i]["obj"];
			if(obj && typeof(obj.destroy) == "function"){
				obj.destroy();
				multiUploadObjs.splice(i,1);
				break;
			}
		}
	}
}
/**
* 禁用掉当前页面上所有的附件上传
*/
function destroyAllMultiUploadObj(){
	for(var i = 0; i < multiUploadObjs.length; i++){
		var obj = multiUploadObjs[i]["obj"];
		if(obj && typeof(obj.destroy) == "function"){
			obj.destroy();
			//alert("destroy:" + multiUploadObjs[i]["id"]);
		}
	}
	multiUploadObjs = [];
}

/**
 * 上传附件 处理函数
 * @param {Object} list_target
 * @param {Object} max
 * @param {Object} maxsize
 * @memberOf {TypeName} 
 * @return {TypeName} 
 */
function MultiSelector( list_target, max,maxsize, fieldtype ){

    // Where to write the list
    this.list_target = list_target;
    // How many elements?
    this.count = 0;
    // How many elements?
    this.id = 0;
    // Is there a maximum?
    if( max ){
        this.max = max;
    } else {
        this.max = -1;
    };
    if( maxsize ){
        this.maxsize = maxsize;
    } else {
        this.maxsize = -1;
    };

    /**//**
     * Add a new file input element
     */
    this.addElement = function( element ){

        // Make sure it's a file input element
        if( element.tagName == 'INPUT' && element.type == 'file' ){
			if(isIE10Browser()){
				if(element.className){
					element.className += " addfile_IE10";
				}else{
					element.className = "addfile_IE10";
				}
			}
            // Element name -- what number am I?
            element.name = element.name+'_' + this.id++;

            // Add reference to this object
            element.multi_selector = this;
            // What to do when a file is selected
            element.onchange = function(){
                // New file input
                var new_element = document.createElement( 'input' );
                new_element.type = 'file';
                new_element.size = 1;
                new_element.className = "addfile";
                new_element.name=element.name;
                
                if(this.multi_selector.maxsize<=-1){
	                //获取系统中附件的大小 
                	var maxFileSizeObj=document.getElementById("402881e50b14f840010b153bbc17000b");
                	var maxFileSize="-1";
                	if(maxFileSizeObj)maxFileSize=maxFileSizeObj.value;
                	
				    var sysfileSize= parseInt(maxFileSize);
				    if(!isNaN(sysfileSize)){
				    	this.multi_selector.maxsize=sysfileSize;
				    }
                }
                var weatherCheckFileSizeObj=document.getElementById("402881e50b14f840010b14fbae82000b");
                if(weatherCheckFileSizeObj)weatherCheckFileSize=weatherCheckFileSizeObj.value;
                
                if(weatherCheckFileSize=="1"&&this.multi_selector.maxsize>-1){
			        //firefox
			        if(window.navigator.userAgent.indexOf("Firefox")>=1){
			            if(element.files){
			            	var fileSize=element.files.item(0).fileSize/(1024*1024);
			            	if(fileSize>this.multi_selector.maxsize){
			            		alert('附件必须小于'+this.multi_selector.maxsize+'M');
			                   	clearFileInput(element);
			                    return false;
			            	}
			            }
			        }else{
			            var path=getFullPath(element);
		                if(!checkFileSize(path,this.multi_selector.maxsize)){
		                    alert('附件必须小于'+this.multi_selector.maxsize+'M');
		                   	clearFileInput(element);
		                    return false;
		                }
			        }
                }
                
                //这种取法值能取到主表附件字段  对于抽象表单子表是取不到的
                //field_402880b223ffb124012408ec1136093f_12file  子表附件
                //field_402880b223ffb124012408ec1136093f_1file   子表附件
                //field_402880b223ffb124012408ec1136093ffile     主表附件
                var  el_name = element.name
                var  leftel = el_name.split("file");
                var inputId = "";
                if(leftel.length >= 1 ){
                	inputId = leftel[0]+"file";
                }
                var oImg=Ext.getDom(inputId+"Img");
                if(!Ext.isEmpty(oImg)){
                	if(!Ext.isEmpty(oImg.innerHTML)) oImg.innerHTML='';
                }
                // Add new element
                this.parentNode.insertBefore( new_element, this );

                // Apply 'update' to element
                this.multi_selector.addElement( new_element );

                // Update list
                this.multi_selector.addListRow( this );

                // Hide this: we can't use display:none because Safari doesn't like it
                this.style.position = 'absolute';
                this.style.left = '-1000px';
            };


            // If we've reached maximum number, disable input element
            if( this.max != -1 && this.count >= this.max ){
                element.disabled = true;
            };

            // File element counter
            this.count++;
            // Most recent element
            this.current_element = element;
        } else {
            // This can only be applied to file input elements!
            alert( 'Error: not a file input element' );
        };

    };


    /**//**
     * Add a new row to the list of files
     */
    this.addListRow = function( element ){
		this.list_target.style.display = "";
        // Row div
        var tagName=(this.list_target.tagName=='UL')?"li":"div";
        var new_row = document.createElement(tagName);


        // Delete button
        var new_row_button = document.createElement( 'img' );
        new_row_button.src = contextPath+'/images/base/delete.GIF';
        new_row_button.className='addfile';

        // References
        new_row.element = element;

        // Delete function
        new_row_button.onclick= function(){
        	
        	//这种取法值能取到主表附件字段  对于抽象表单子表是取不到的
        	//var fieldId=this.parentNode.element.name.substring(0,'field_402880b223ffb124012408ec1136093f'.length);
                //field_402880b223ffb124012408ec1136093f_12file  子表附件
                //field_402880b223ffb124012408ec1136093f_1file   子表附件
                //field_402880b223ffb124012408ec1136093ffile     主表附件
                var  el_name1 = this.parentNode.element.name;
                var  leftel1 = el_name1.split("file");
                var fieldId = "";
                if(leftel1.length >= 1 ){
                	fieldId = leftel1[0];
                }
        	
            // Remove element from form
            this.parentNode.element.parentNode.removeChild( this.parentNode.element );

            // Remove this row from the list
            this.parentNode.parentNode.removeChild( this.parentNode );

            // Decrement counter
            this.parentNode.element.multi_selector.count--;

            // Re-enable input element (if it's disabled)
            this.parentNode.element.multi_selector.current_element.disabled = false;
            if(fieldId!=null && !existAttachIds(fieldId)){
 				if(Ext.getDom(fieldId+'fileImg')) Ext.getDom(fieldId+'fileImg').innerHTML='<img src="'+contextPath+'/images/base/checkinput.gif" align=absMiddle>';
		 	}

            
            // Appease Safari
            //    without it Safari wants to reload the browser window
            //    which nixes your already queued uploads
            return false;
        };

        // Set row value
        new_row.innerHTML = element.value;


        // Add button
        new_row.appendChild( new_row_button );

        // Add it to the list
        this.list_target.appendChild( new_row );

    };
    
    if(attachUploadIsUsedUploadifyPlugin()){
    	this.selectedFileCountOnce = 0;
    	this.uploadFileCountOnce = 0;
	    this.addElement = function(fileElement, urlParameters){
	    	var mSelector = this;
	    	
	    	//延迟初始化
	    	jQuery(fileElement).parent().one("mouseover", function(){
	    		uploadifyPluginInit();
	    	});
	    	
	    	function uploadifyPluginInit(){
		    	var fileEleId = fileElement.id;
		    	
		    	mSelector.createAttachHiddenElementIfNotExist(fileEleId);
		    	
		    	mSelector.createFileUploadDetailInfo(fileEleId);
		    	
		    	if(mSelector.maxsize <= -1){
	                //获取系统设置中的附件的大小 
	            	var maxUploadSize = jQuery.ajax({
						url: "/ServiceAction/com.eweaver.base.file.FileUploadAction?action=getMaxUploadSize&fieldtype="+fieldtype,
						async: false
					}).responseText;
				
				    maxUploadSize = parseInt(maxUploadSize);
				    
				    if(!isNaN(maxUploadSize)){
				    	mSelector.maxsize = maxUploadSize;
				    }
	            }
		    	
		    	var urlParameterStr = "";
		    	if(urlParameters){
		    		for(urlKey in urlParameters){
		    			urlParameterStr += "&" + urlKey + "=" + urlParameters[urlKey];
		    		}
		    	}
		    	
		    	jQuery(fileElement).uploadify({
			    	'height'        : 20, 
			    	'width'         : 80,  
			    	'buttonClass'   : 'addfile', 
			    	'buttonText'    : '',
			        'swf'           : '/js/jquery/plugins/uploadify/uploadify.swf',
			        'uploader'      : '/ServiceAction/com.eweaver.base.file.FileUploadAction?action=uploadFile&fieldtype='+fieldtype + urlParameterStr,
			        'auto'          : true,
			        'fileTypeExts'  : '*.*',
			        'fileTypeDesc'  : '所有文件',
			        'queueID'       : fileEleId + '-queue',
			        'removeCompleted' : true,
			        'removeTimeout' : 0,
			        'overrideEvents': ['onSelectError'],
			        'onSelectError' : function(file, errorCode, errorMsg) {
			        	//覆盖onSelectError事件
			            switch(errorCode) {
							case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED:
								if (settings.queueSizeLimit > errorMsg) {
									this.queueData.errorMsg = '有些文件没有被添加到队列中.\n选择的文件的数量超过了剩余的上传限制 (' + errorMsg + ').';
								} else {
									this.queueData.errorMsg = '有些文件没有被添加到队列中.\n选择的文件数超过了队列的大小限制 (' + settings.queueSizeLimit + ').';
								}
								break;
							case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
								this.queueData.errorMsg = '文件 "' + file.name + '" 未加入到上传队列中.\n因为该文件超过大小限制 (' + settings.fileSizeLimit + ').';
								break;
							case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
								this.queueData.errorMsg = '文件 "' + file.name + '" 未加入到上传队列中.\n因为该文件是一个空的文件.';
								break;
							case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
								this.queueData.errorMsg = '文件 "' + file.name + '" 未加入到上传队列中.\n因为该文件是不被接受的文件类型 (' + settings.fileTypeDesc + ').';
								break;
						}
			        },
			        'onSelect' : function(file) {
			        	if(mSelector.maxsize > -1){
			        		if(file.size > (mSelector.maxsize * 1024 * 1024)){
			        			this.cancelUpload(file.id);
								this.queueData.filesCancelled++;
			        			alert("附件["+file.name+"]必须小于"+mSelector.maxsize+"M");
			        			return;
			        		}
			        	}
			        	mSelector.selectedFileCountOnce++;
	        		},
			        'onUploadStart' : function(file) {
			        	mSelector.uploadFileCountOnce++;
			        	mSelector.disabledToolbar();
			        	mSelector.insertOneInfoToFileUploadDetail(fileEleId, file);
			        },
			        'onUploadSuccess' : function(file, data, response){
			        	mSelector.removeFieldCheckImg(fileEleId);
			        	mSelector.clearFileUploadDetailInfo(fileEleId);
			        	mSelector.addAttachIdToAttachHiddenElement(fileEleId, data);
			        	mSelector.addListRow(fileEleId, file, data);
			        },
			        'onQueueComplete' : function(queueData){
			        	mSelector.selectedFileCountOnce = 0;
			        	mSelector.uploadFileCountOnce = 0;
			        	mSelector.enabledToolbar();
			        },
			        'onSWFReady' : function(){
			        	multiUploadObjs.push({"id":fileEleId, "obj":this});
			        }
			    });
		    }
	    };
	    
	    this.addListRow = function(fileEleId, file, attachid){
	    	this.list_target.style.display = "";
	    	// Row div
	        var tagName=(this.list_target.tagName=='UL')?"li":"div";
	        var new_row = document.createElement(tagName);
	
	        // Delete button
	        var new_row_button = document.createElement( 'img' );
	        new_row_button.src = contextPath+'/images/base/delete.GIF';
	        new_row_button.className='addfile';
	        
	        var mSelector = this;
	        // Delete function
	        new_row_button.onclick= function(){
	        	
	        	mSelector.removeAttachIdFromAttachHiddenElement(fileEleId, attachid);
	        	
	            // Remove this row from the list
	            this.parentNode.parentNode.removeChild( this.parentNode );
	
	            // Decrement counter
	            mSelector.count--;
	
	            var fieldId = mSelector.getAttachHiddenElementName(fileEleId);
	            if(fieldId != null && !existAttachIds(fieldId)){
	 				if(Ext.getDom(fieldId+'fileImg')) Ext.getDom(fieldId+'fileImg').innerHTML='<img src="'+contextPath+'/images/base/checkinput.gif" align=absMiddle>';
			 	}
	
	            jQuery.ajax({url: "/ServiceAction/com.eweaver.document.base.servlet.AttachAction?action=delete&ids=" + attachid});
	            
	            if(mSelector.list_target.childNodes.length == 0){
	            	mSelector.list_target.style.display = "none";
	            }
	            
	            return false;
	        };
	        
	        var filename = jQuery.ajax({
				url: "/ServiceAction/com.eweaver.base.file.FileUploadAction?action=getAttachObjnameById&attachid="+attachid,
				async: false
			}).responseText;
			
	        // Set row value
	        new_row.innerHTML = filename +"  (" + this.getFileSizeForShow(file) + ")";
	
	        // Add button
	        new_row.appendChild(new_row_button);
	
	        // Add it to the list
	        this.list_target.appendChild( new_row );
	    };
	    
	    this.disabledToolbar = function(){
			if(typeof(tb) != "undefined" && tb && (tb instanceof Ext.Toolbar)){
				tb.disable();
			}
		};
		
		this.enabledToolbar = function(){
			if(typeof(tb) != "undefined" && tb && (tb instanceof Ext.Toolbar)){
				tb.enable();
			}
		};
		
		this.removeFieldCheckImg = function(fileEleId){
			var fieldId = this.getAttachHiddenElementName(fileEleId);
			var oImg = Ext.getDom(fieldId+"fileImg");
            if(!Ext.isEmpty(oImg)){
            	if(!Ext.isEmpty(oImg.innerHTML)) oImg.innerHTML='';
            }
        };
	    
	    this.getFileSizeForShow = function(file){
	    	var size;
			var unit;
			if(file.size < 1024){
				size = file.size;
				unit = "Byte";
			}else if(file.size < (1024*1024)){
				size = Math.round(file.size / 1024);
				unit = "KB";
			}else{
				size = Math.round(file.size / (1024 * 1024));
				unit = "MB";
			}
			return size + unit;
	    };
	    
	    this.getFileParentElement = function(fileEleId){
	    	var $fileElement = jQuery("#" + fileEleId);
	    	var $fileParentElement = $fileElement.parent();
            if($fileParentElement[0].tagName.toUpperCase() == "A"){
            	return $fileParentElement[0];
            }
            return $fileElement[0];
	    };
	    
	    this.getAttachHiddenElementName = function(fileEleId){
	    	var isFormField = new RegExp("field_.*file").test(fileEleId);
	    	var attachHiddenElementName;
	    	if(isFormField){
	    		attachHiddenElementName = fileEleId.substring(0, fileEleId.length - 4);	
	    	}else{
	    		attachHiddenElementName = fileEleId;
	    	}
	    	return attachHiddenElementName;
	    };
	    
	    this.getAttachHiddenElement = function(fileEleId){
	    	var attachHiddenElementName = this.getAttachHiddenElementName(fileEleId);
	    	var $attachHiddenElement = jQuery("input[type='hidden'][name='"+attachHiddenElementName+"']");
	    	if($attachHiddenElement.length > 0){
	    		return $attachHiddenElement[0];
	    	}else{
	    		return null;
	    	}
	    };
	    
	    this.createAttachHiddenElementIfNotExist = function(fileEleId){
	    	var attachHiddenElement = this.getAttachHiddenElement(fileEleId);
	    	if(attachHiddenElement == null){
	    		var attachHiddenElementName = this.getAttachHiddenElementName(fileEleId);
	    		var $attachHiddenElement = jQuery("<input type=\"hidden\" name=\""+attachHiddenElementName+"\"/>");
	    		var filePElement = this.getFileParentElement(fileEleId);
	    		jQuery(filePElement).after($attachHiddenElement);
	    	}
	    };
	    
	    this.getAttachIdsHiddenElementName = function(fileEleId){
	    	var isFormField = new RegExp("field_.*file").test(fileEleId);
	    	var attachIdsHiddenElementName;
	    	if(isFormField){
	    		attachIdsHiddenElementName = "attachIds" + fileEleId.substring(6, fileEleId.length - 4);	
	    	}else{
	    		attachIdsHiddenElementName = "attachIds" + fileEleId;
	    	}
	    	return attachIdsHiddenElementName;
	    };
	    
	    this.getAttachIdsHiddenElement = function(fileEleId){
	    	var attachIdsHiddenElementName = this.getAttachIdsHiddenElementName(fileEleId);
	    	var $attachIdsHiddenElement = jQuery("input[type='hidden'][name='"+attachIdsHiddenElementName+"']");
	    	if($attachIdsHiddenElement.length > 0){
	    		return $attachIdsHiddenElement[0];
	    	}else{
	    		return null;
	    	}
	    };
	    
	    this.createFileUploadDetailInfo = function(fileEleId){
	    	var $fileUploadDetailInfo = jQuery("<div id=\"fileUploadDetailInfo_"+fileEleId+"\"></div>");
	    	$fileUploadDetailInfo.css({
	    		"display" : "none",
				"height"  : "20px",
				"line-height" : "20px",
				"padding-left" : "3px"
	    	});
	    	var filePElement = this.getFileParentElement(fileEleId);
	    	jQuery(filePElement).after($fileUploadDetailInfo);
	    };
	    
	    this.insertOneInfoToFileUploadDetail = function(fileEleId, file){
	    	var $fileUploadDetailInfo = jQuery("#fileUploadDetailInfo_" + fileEleId);
			$fileUploadDetailInfo.show();
			var fileSize = this.getFileSizeForShow(file);
			$fileUploadDetailInfo.html("<span class=\"fileUploadDetailInfoItem\">正在上传第("+this.uploadFileCountOnce+")个文件，共"+this.selectedFileCountOnce+"个文件上传。 </span>" );
			$fileUploadDetailInfo.find(".fileUploadDetailInfoItem").css({
				"font-size"   : "12px",
				"font-family" : "Microsoft YaHei",
				"background"  : "url(/images/base/loading.gif) no-repeat",
				"background-position" : "0px 2px",
				"padding-left": "18px"
			});
	    };
	    
	    this.clearFileUploadDetailInfo = function(fileEleId){
	    	var $fileUploadDetailInfo = jQuery("#fileUploadDetailInfo_" + fileEleId);
			$fileUploadDetailInfo.find("*").remove();
			$fileUploadDetailInfo.hide();
	    };
	    
	    this.addAttachIdToAttachHiddenElement = function(fileEleId, attachid){
	    	var attachHiddenElement = this.getAttachHiddenElement(fileEleId);
	    	this.addAttachidInValue(attachHiddenElement, attachid);
	    	this.addAttachIdToAttachIdsHiddenElement(fileEleId, attachid);
	    };
	    
	    this.removeAttachIdFromAttachHiddenElement = function(fileEleId, attachid){
	    	var attachHiddenElement = this.getAttachHiddenElement(fileEleId);
	    	this.removeAttachidFromValue(attachHiddenElement, attachid);
	    	this.removeAttachIdFromAttachIdsHiddenElement(fileEleId, attachid);
	    };
	    
	    this.addAttachIdToAttachIdsHiddenElement = function(fileEleId, attachid){
	    	var attachIdsHiddenElement = this.getAttachIdsHiddenElement(fileEleId);
	    	if(attachIdsHiddenElement){
		    	this.addAttachidInValue(attachIdsHiddenElement, attachid);
		    	this.createExistAttachFlag(fileEleId, attachid);
	    	}
	    };
	    
	    this.removeAttachIdFromAttachIdsHiddenElement = function(fileEleId, attachid){
	    	var attachIdsHiddenElement = this.getAttachIdsHiddenElement(fileEleId);
	    	if(attachIdsHiddenElement){
		    	this.removeAttachidFromValue(attachIdsHiddenElement, attachid);
		    	this.removeExistAttachFlag(attachid);
	    	}
	    };
	    
	    this.createExistAttachFlag = function(fileEleId, attachid){
	    	var $existAttachFlag = jQuery("<input type=\"hidden\" name=\"attach"+attachid+"\" value=\""+attachid+"\"/>");
	    	var filePElement = this.getFileParentElement(fileEleId);
	    	jQuery(filePElement).after($existAttachFlag);
	    };
	    
	    this.removeExistAttachFlag = function(attachid){
	    	var $existAttachFlag = jQuery("input[type='hidden'][name='attach"+attachid+"']");
	    	$existAttachFlag.remove();
	    };
	    
	    this.addAttachidInValue = function(element, attachid){
	    	var v = element.value;
	    	if(v == ""){
	    		v = attachid;
	    	}else{
	    		v = v + "," + attachid;
	    	}
	    	element.value = v;
	    };
	    
	    this.removeAttachidFromValue = function(element, attachid){
	    	var v = element.value;
	    	var vArray = v.split(",");
	    	var removeIndex = -1;
	    	for(var i = 0; i < vArray.length; i++){
	    		if(vArray[i] == attachid){
	    			removeIndex = i;
	    			break;
	    		}
	    	}
	    	if(removeIndex != -1){
	    		vArray.splice(removeIndex, 1);
	    	}
	    	
	    	element.value = vArray.toString();
	    };
    }
}

function getFullPath(obj)
{
    if(obj)
    {
        //ie
        if (window.navigator.userAgent.indexOf("MSIE")>=1)
        {
            obj.select();
            obj.parentNode.focus();
            return document.selection.createRange().text;
        }
        //firefox
        else if(window.navigator.userAgent.indexOf("Firefox")>=1)
        {
            if(obj.files)
            {
                return obj.files.item(0).getAsDataURL();
            }
            return obj.value;
        }
        return obj.value;
    }
}

//清空File类型input的值
function clearFileInput(file){
    var form=document.createElement('form');
    document.body.appendChild(form);
    var pos = file.nextSibling;
    var par=file.parentNode;
    form.appendChild(file);
    form.reset();
    if(pos==null){
    	par.appendChild(file);
    }else{
    	par.insertBefore(file, pos);
    }
    document.body.removeChild(form);
}

function addFileList(fieldid,rowindex,max,maxsize) {

var multi_selector = new MultiSelector( document.getElementById('filelist_'+fieldid+'_'+rowindex),max,maxsize);

multi_selector.addElement( document.getElementById( 'field_'+fieldid+'_'+rowindex+'file'));
}

function BrowserImages(_callback){
	var ret=window.showModalDialog(contextPath+"/base/menu/imagesBrowser.jsp");
	_callback(ret);
}

function DelAttach(obj,aid){//删除附件函数
	if(!confirm('确定要删除吗？'))return;
 	obj=obj.parentNode;
 	var fieldId=null;
	var inputs=obj.getElementsByTagName('input');
	if(inputs!=null && inputs.length>0){
		fieldId=inputs[0].getAttribute('_fieldid');
	}
 	obj.parentNode.removeChild(obj);
 	if(typeof(aid)=='string' && document.EweaverForm.delattachid){
 		if(document.EweaverForm.delattachid.value!='') document.EweaverForm.delattachid.value+=",";
 		document.EweaverForm.delattachid.value+=aid;
 		var _val=document.EweaverForm[fieldId].value;
 		if(fieldId!=null && Ext.isEmpty(_val)){
 			if(_val.indexOf(aid)==0) aid=','+aid;
 			document.EweaverForm[fieldId].value=_val.reaplce(aid,'');
 		}
 	}
 	if(fieldId!=null && !existAttachIds(fieldId)){
 		if(Ext.getDom(fieldId+'fileImg')){
 			Ext.getDom(fieldId+'fileImg').innerHTML='<img src="'+contextPath+'/images/base/checkinput.gif" align=absMiddle>';
 		}
 	}
	//alert("v:"+document.EweaverForm.delattachid.value);
	/*var inputId=element.name.substring(0,'field_402880b223ffb124012408ec1136093ffile'.length);
	var oImg=Ext.getDom(inputId);
    if(!Ext.isEmpty(oImg)){
		if(!Ext.isEmpty(oImg.innerHTML)) oImg.innerHTML='';
	}*/

}

/**
 * 验证附件字段是否必填
 * @param {Object} fieldId
 * @return {TypeName} 
 */
function existAttachIds(fieldId){
	if(attachUploadIsUsedUploadifyPlugin()){
		var $field = jQuery("input[type='hidden'][name='"+fieldId+"']");
		if($field.val() == ""){
			return false;
		}else{
			var attachIdsHiddenElementName = "attachIds" + fieldId.substring(6);
			var $attachIdsHiddenElement = jQuery("input[type='hidden'][name='"+attachIdsHiddenElementName+"']");
	    	if($attachIdsHiddenElement.length > 0){
	    		var exitUploadedAttach = false;
	    		var attachids = $field.val().split(",");
	    		for(var i = 0; i < attachids.length; i++){
	    			var $existAttachFlag = jQuery("input[type='hidden'][name='attach"+attachids[i]+"']");
	    			if($existAttachFlag.length > 0){
	    				exitUploadedAttach = true;
	    				break;
	    			}
	    		}
	    		
	    		var filelistElementId = "filelist_" + fieldId.substring(6);
	    		var $filelistElement = jQuery("#" + filelistElementId);
	    		var exitNewUploadAttach = $filelistElement.children().length > 0;
	    		
	    		if(!exitUploadedAttach && !exitNewUploadAttach){
	    			return false;
	    		}
	    	}
	    	return true;	
		}
	}else{
		var tags=Ext.query('input[name*='+fieldId+']');
		tags=tags.concat(Ext.query('input[_fieldid*='+fieldId+']'));
		var exist=false;
		for(var i=0;i<tags.length;i++){
			if(!Ext.isEmpty(tags[i].value) && tags[i].name!=fieldId)
				exist=true;
		}
		if(tags == null || tags=='undefine' || tags.length == 0)
			exist=true;
		return exist;
	}
	
}

function AddAttach(objname,aid,aname){
    if(document.all(objname+"_filespan"))
    return;
    obj=document.all(objname)  ;
    if(obj){
    sp=document.createElement("div");
    sp.id=objname+"_filespan"
    shtml="<a href='/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+aid+"&download=1'>"+aname+"</a><input type='hidden' name='attach"+aid+"' value='"+aid+"'><a  onclick='DelAttach(this);'><img src='/images/delete.GIF' border='0'></a>"
 	sp.innerHTML=shtml;
    obj.parentNode.appendChild(sp);
    }
}

function pop(msg,title,showtime,icon) {
    if(top){
		if(typeof(top.isUseNewMainPage)=='function' && !top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].pop)=='function'){	//传统首页
			top.frames[1].pop(msg,title,showtime,icon);
		}else if(typeof(top.isUseNewMainPage)=='function' && top.isUseNewMainPage() && typeof(top.pop_new) == 'function'){//新页面作为首页
    		top.pop_new(msg,title,showtime,icon);
    	}else{
    		alert(msg);
    	}
	}else{
		alert(msg);
	}
}

function openWin(url, title, image, width, height) {
    if(top){
		if(!top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].openWin)=='function'){	//传统首页
    		top.frames[1].openWin(url, title, image, width, height);
	    }else if(top.isUseNewMainPage() && typeof(top.openWin_new) == 'function'){//新页面作为首页
	    	top.openWin_new(url, title, image, width, height);
	    }else{
	    	alert('openWin function undefined');
		}
	}else{
    	alert('openWin function undefined');
	}
}
function onUrl(url,title,id,inactive,image,onCloseCallbackFn){
	var obj=document.getElementById('attachcanedit');
	if(obj){
		url+="&attachcanedit="+obj.value;
	}
	if(top){
		if(inactive && typeof(inactive) == "function" && !onCloseCallbackFn){
			onCloseCallbackFn = inactive;
			inactive = null;
		}
		if(typeof(top.isUseNewMainPage)=='function' && top.isUseNewMainPage() && typeof(top.onTabUrl) == 'function'){	//新页面打开tab页的方法
			top.onTabUrl(url,title,id,true,null,null,null,onCloseCallbackFn);
		}else if(typeof(top.isUseNewMainPage)=='function' && !top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].onUrl)=='function'){	//现有页面打开tab页的方法
	        top.frames[1].onUrl(url,title,id,inactive,image,onCloseCallbackFn);
	    }else{
	        var str = document.location.toString();
	        var httpstr = str.substring(0,str.lastIndexOf(":"));
	        str = str.substring(str.lastIndexOf(":"),str.length);
	        str = str.substring(0,str.indexOf("/"));
	        window.open(httpstr+str+contextPath+url);
	    }
	}else{
		var str = document.location.toString();
        var httpstr = str.substring(0,str.lastIndexOf(":"));
        str = str.substring(str.lastIndexOf(":"),str.length);
        str = str.substring(0,str.indexOf("/"));
        window.open(httpstr+str+contextPath+url);
	}
}
/*
调整主页面的body高度。
这一般会在页面加载完成之后有异步请求数据填充页面而导致页面高度变化而超出页面本身的高度时调用,
或者其他一些js操作控制页面部分区域显示或者隐藏,从而引起页面高度变化而超出页面本身的高度时调用。
*/
function resizeMainPageBodyHeight(){
	if(top && top.resizeBodyHeightWithCurrentTabIframe){//根据main页面中当前tab页的iframe内容的高度调整main页面的高度
    	top.resizeBodyHeightWithCurrentTabIframe();
    }
}
function addTab(contentPanel,url,title,image){
        id=Ext.id();
        if(Ext.isGecko)
        ;
        else
        url=encodeURI(url);
        if(contextPath!=''&&url.indexOf('http:')==-1&&(url.indexOf(contextPath)==-1||url.indexOf(contextPath)>0))
        url=contextPath+url;
        var max=20;
        if(!title)
        title='';
        if(title.length>max)
        title="<font ext:qtip='" +title+"'>"+title.substring(0,max)+"...</font>";
        var p=contentPanel.add({
                id:id,
                iconCls:image?Ext.ux.iconMgr.getIcon(image):null,
                title: title,
                closable:false,
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{ id:id+'frame', name:id+'frame', frameborder:0 },
                    eventsFollowFrameLinks : false
                },
                defaultSrc:'about:blank',
                autoScroll:true
            });
        p.on('activate',function(){
            if(this.getFrame().getDocumentURI()=='about:blank')
            this.setSrc(url,true);
        });
        return p;
    }
function addBtn(toolbar,text,key,image,handler){
    if(key)
    bid=key
    else
    bid=Ext.id();
    var config={
        id:bid,
        text:text+'('+key+')',
        key:key.toLowerCase(),
        alt:true,
        iconCls:Ext.ux.iconMgr.getIcon(image),
        handler:handler
    }
    toolbar.add(config);
}
function subscribe(subject) {
    if (top.frames[1] && typeof(top.frames[1].subscribe) == 'function')
        top.frames[1].subscribe(subject);
    else
        alert('subscribe function undefined');
}
function publish(subject, content) {
    if (top && !top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].publish) == 'function'){	//传统首页
    	 top.frames[1].publish(subject,content);
    }
       
}
function evalHtml(inHTML){
    var scriptFragment= '(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)';
       var matchAll = new RegExp(scriptFragment, 'img');
       var scripts = inHTML.match(matchAll);
		if(scripts != null){
		   for(var i=0;i<scripts.length;i++){
		       var script= scripts[i];
			   var scriptBegin = '(?:<script.*?>)';
			   script = script.replace(new RegExp(scriptBegin, 'img'),'');
			   var scriptEnd = '(?:<\/script>)';
			   script = script.replace(new RegExp(scriptEnd, 'img'),'');
			   try{
			   eval(script);
			   }catch(e){}
		   }
	   }else{
		   var scriptFragment2= '(?:<script.*?>)';
	       matchAll = new RegExp(scriptFragment2, 'im');
	       var scripts = inHTML.match(matchAll);
			if(scripts != null){
			   for(var i=0;i<scripts.length;i++){
			       var script= scripts[i];
			       var s = document.createElement('script');
				   s.type = 'text/javascript';
				   var indx = script.indexOf("src=");
				   script = script.substring(indx + 5);
				   indx = script.indexOf(".js");
				   script = script.substring(0, indx + 3);
				   s.src = script;
				   document.getElementsByTagName('head')[0].appendChild(s);
			   }
		   }
		}
	   inHTML = inHTML.replace(matchAll,'');
    return inHTML;
}
function getPortlet(portlet,container,params){
        idx= portlet.indexOf("_");
        type=portlet.substring(0,idx);
        id=  portlet.substring(idx+1);
        if(type=='report')
        url='/reportPortlet.lp'
        if(type=='chart')
        url='/chartPortlet.lp'
        if(type=='gauge')
        url='/gaugePortlet.lp'
        if(type=='document')
        url='/docbasePortlet.lp'
        if(type=='workflow')
        url='/todoWorkflowPortlet.lp'
        if(params){
        params.portletId=id;
        params.responseId=container;
        params.mode='view';
        }
        else
        params={portletId:id,responseId:container,mode:'view'};
        Ext.Ajax.request({
            url: contextPath+url,
            params:params,
            success:function (res) {
                document.all(container).innerHTML = evalHtml(res.responseText);
            }
        });
}
/*
	获取当前的系统模式(0.软件模式, 1.网站模式)
	currentSysMode作为隐藏域存放在init.jsp中
*/
function getCurrentSysMode(){
	var currentSysMode = document.getElementById("currentSysMode");
	if(currentSysMode){
		return currentSysMode.value;
	}else{
		alert("error: unknow the currentSysMode, please check !")
	}
}

/*判断当前系统模式是否是网站模式(是：返回true,否则返回false)*/
function currentSysModeIsWebsite(){
	return getCurrentSysMode() == "1";
}

/*判断当前系统模式是否是网站模式(是：返回true,否则返回false)*/
function currentSysModeIsSoftware(){
	return getCurrentSysMode() == "0";
}

function initTabs(){//初始化布局中的Tab页
	var frames=Ext.query('fieldset[class=extTab]');
	var tabs=[];
	var titles=new Array(frames.length);
	var titleIndex={};
	for(var i=0;i<frames.length;i++){
		var legend=Ext.query('legend:first',frames[i]);
		var _title="Default"+i;
		if(Ext.isArray(legend) && legend.length>0){
			_title=legend[0].innerHTML;
			Ext.removeNode(legend[0]);
		}
		titles[i]=_title;
		titleIndex[_title]=i;
	}
	var legends=Ext.query('legend[class=tabTitle]');
	
	var _title='';
	if(Ext.isArray(legends) && legends.length>0) _title=legends[0].innerHTML;
	titles.push(_title);
	titleIndex[_title]=-1;
	var formTab={title:_title,region:'center',autoScroll:true,contentEl:'tab1'};//获取默认的表单Tab页
	if(currentSysModeIsWebsite()){//网站模式(取消滚动条)
		formTab = {title:_title,region:'center',autoScroll:false,contentEl:'tab1',autoHeight: true};
	}
	titles=titles.sort();
	for(var i=0;i<titles.length;i++){
		var index=titleIndex[titles[i]];
		if(index==-1){
			tabs.push(formTab);
			continue;
		}
		var cfg={
			width:Ext.lib.Dom.getViewportWidth(),
            height: Ext.lib.Dom.getViewportHeight(),
            html:frames[index].innerHTML,
            title:titles[i],
            autoScroll:true
        };
        Ext.removeNode(frames[index]);        
        tabs.push(cfg);
    }//end.for
	return tabs;
}
/**
 * 打开模式窗口,统一打开模式窗口大小
 */
function openDialog(url,arguments,features){
	if(!features){
		features = "dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes";
	}
	if(!arguments){
		arguments = window;
	}
	return window.showModalDialog(url,window,features);
}
function onPopup(url){
	return openDialog(url,window);
}

var labelDialog;
var labelDialogWidth = 700;		//作用：供页面js重定义此值来改变不同页面打开窗口的大小
var labelDialogHeight = 300;	//作用：供页面js重定义此值来改变不同页面打开窗口的大小
function openLabel(keyword,labeltype){
   labelDialog = new Ext.Window({
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
	    }]
    });
    labelDialog.render(Ext.getBody());
	var url='/base/label/labelcustommanage.jsp?keyword='+keyword;
	if(labeltype) url+='&labeltype='+labeltype;
    labelDialog.setTitle('多语言标签管理');
    labelDialog.setIconClass(Ext.ux.iconMgr.getIcon('page_white_code'));
    labelDialog.setWidth(labelDialogWidth);
    labelDialog.setHeight(labelDialogHeight);
    labelDialog.getComponent('commondlg').setSrc(url);
    labelDialog.show();
}

function closeLabel(){
	if(labelDialog){
		labelDialog.hide();
	}
}
/*关闭当前活动的tab页,兼容新老首页*/
function closeActiveTab(){
	if(top && top.isUseNewMainPage() && typeof(top.closeTab) == 'function'){	//新首页关闭标签页
		top.closeTab();
	}else{	//传统首页关闭标签页
		var tabpanel = top.frames[1].contentPanel;
		tabpanel.remove(tabpanel.getActiveTab());
	}
}

function checkDateField(){
	jQuery("[datecheck]").each(function () { 
        var datecheck = jQuery(this).attr("datecheck");
        var datefieldname = jQuery(this).attr("datefieldname"); 
        var bool=fieldcheck(this,datecheck,datefieldname);
        if(bool==false){
        	return false
        }
	}); 
	return true;
}
/*见lightPortlet.js PortletWindow.prototype.autoRefresh*/
var weaverBind = function(object, fun) { 
    var args = Array.prototype.slice.call(arguments).slice(2); 
    return function() { 
        return fun.apply(object, args.concat(Array.prototype.slice.call(arguments))); 
    }
}

function batchDownload(cfg){
	var defaultCfg = {
		//formIdOrName : '',		//附件字段所在的表id或名称
		//fieldIdOrName : '',		//附件字段对应的列id或名称
		//attachIds : ''			//附件id集
	};
	
	Ext.apply(defaultCfg, cfg);
	
	var url = "/ServiceAction/com.eweaver.document.file.FileDownload?action=batchDownload";
	for(var key in defaultCfg){
		url += "&" + key + "=" + defaultCfg[key];
	}
	location.href = url;
}

/**
* 调整ext表格的前置条件,当此条件为true时，才进行。
*/
function isResizeExtGridColumn(){
	return !Ext.isIE || isIE10Browser();
}

/**
* 重新调整Ext Grid列表的宽度(仅在isResizeExtGridColumn()方法满足时工作)
*/
function resizeExtGridColumnWidth(obj){
	if(!isResizeExtGridColumn()){
		return;
	}
	var datas;
	if(Object.prototype.toString.call(obj) == '[object Array]'){
		datas = obj;
		changeDatas();
		return datas;
	}else if(obj instanceof Ext.grid.ColumnModel){
		datas = obj.config;
		changeDatas();
		obj.setConfig(datas);
	}
	
	function changeDatas(){
		if(datas.length == 0){
			return;
		}
		var firstDataIsExtObj = (datas[0] instanceof Ext.util.Observable);
		//1.将宽度等于0的列(如果有)调整为具体的值
		var beiginDataIndex = 0;
		if(firstDataIsExtObj){
			beiginDataIndex = 1;
		}
		var greaterZeroWidthSum = 0;	//列宽设置大于0的列的宽度总和
		var greaterZeroCountSum = 0;	//列宽设置大于0的列的数量总和
		for(var i = beiginDataIndex; i < datas.length; i++){
			var data = datas[i];
			if(data.width && data.width > 0){
				greaterZeroWidthSum += data.width;
				greaterZeroCountSum ++;
			}
		}
		greaterZeroWidthSum += 3;  
		var averageWidth;	//平均宽度
		if(greaterZeroCountSum > 0){
			averageWidth = doDivision(greaterZeroWidthSum, greaterZeroCountSum);
		}else{
			averageWidth = 100 / (datas.length - beiginDataIndex);
		}
		//调整宽度，并记录宽度总和
		var sumWidth = 0;
		for(var i = beiginDataIndex; i < datas.length; i++){
			var data = datas[i];
			if(data.width && data.width > 0){
				sumWidth += data.width;
			}else{
				data.width = averageWidth;
				sumWidth += averageWidth;
			}
		}
		//2.按照百分比对列宽度进行调整
		var bodyWidth = document.body.clientWidth;
		if(firstDataIsExtObj){
			bodyWidth = bodyWidth - 25;
		}
		for(var i = beiginDataIndex; i < datas.length; i++){
			var data = datas[i];
			var newWidth = bodyWidth * (data.width / parseFloat(sumWidth));
			newWidth = Math.floor(newWidth);
			data.width = newWidth;
			//data.fixed = true;
		}
		
		/**进行除法运算，保留两位小数**/
		function doDivision(oneNumber, otherNumber){
			return Math.round((oneNumber / parseFloat(otherNumber)) * 100) / 100.00
		}
	}
}

/**
* 获取元素
* 此方法是为了解决document.all在多浏览器中的差异化而引起的一些问题
* 如点击子表新增后新增的子表行中的元素在chrome中无法用document.all获取到
*/
function eweaverGet(idOrName){
	var obj = document.getElementById(idOrName);
	if(obj){
		return obj;
	}
	var tempObjs = document.getElementsByName(idOrName);
	if(tempObjs && tempObjs.length > 0){
		return tempObjs[0];
	}
	return null;
	/**
	* 此处不再使用document.all，因为通过id或name已经可以定位到元素
	* 如果通过id和name都定位不到元素，那么就是与之相应的代码有问题
	* 而不该依附于document.all，document.all在不同浏览器以及不同模式下的差异化很难被处理，也不该被处理，应该避免这种差异化的产生。
	*/
	//return document.all(idOrName);		
}

/*
* 判断是否是IE10浏览器
* 是返回true,否返回false;
*/
function isIE10Browser(){
	var IS_IE10 = navigator.appName.toUpperCase() == "MICROSOFT INTERNET EXPLORER" && navigator.userAgent.indexOf("MSIE 10") >= 0;
	return IS_IE10;
}

/**
* 通过iframe的id获取该iframe指向页面的window对象 (此方法具有多浏览器兼容性)
*/
function getIFrameWindowById(iframeId){
	if(document.getElementById(iframeId) && document.getElementById(iframeId).contentWindow){
		return document.getElementById(iframeId).contentWindow;
	}else if(document.frames[iframeId] && document.frames[iframeId].window){
		return document.frames[iframeId].window;
	}else{
		return null;
	}
}

/*
* 判断浏览器模式是否是IE兼容性视图。
* 是返回true,否返回false;
*/
function isIECompatibilityView(){
	return navigator.appName.toUpperCase() == "MICROSOFT INTERNET EXPLORER" && navigator.userAgent.indexOf("MSIE 7") >= 0;
}

/**
* 调用此方法会向当前页面的body中class增加一些和当前浏览器以及版本有关的样式信息(主要用于方便css hack的书写)
* 当浏览器为IE时，此方法会向body中写入两个样式，分别为：
* eweaver-ie 和 eweaver-ie-大版本 (如IE9为eweaver-ie-9)
* 当为非IE时，此方法会向body中写入样式：eweaver-not-ie
* 目前对非IE时未进行具体浏览器种类以及版本的细化，如有需要，可修改此方法增加相应代码。
*/
function addCssHackFlagToBody(){
	var cssHackFlag = "";
	var browserName = navigator.appName.toUpperCase();
	var isIE = (browserName == "MICROSOFT INTERNET EXPLORER");
	if(isIE){
		cssHackFlag += "eweaver-ie";
		if(typeof(getIEv) == "function"){	//依赖于weaverUtil.js中的getIEv获取IE版本
			cssHackFlag += " eweaver-ie-" + getIEv();
		}
	}else{
		cssHackFlag += "eweaver-not-ie";
	}

	var targetBody = document.body;
	if(targetBody.className){
		targetBody.className += " " + cssHackFlag;
	}else{
		targetBody.className = cssHackFlag;
	}
}

//获取当前事件对应的元素  兼容IE和火狐
function getEventSrcElement(){
	var evt=getEvent();
	if (evt)
	{
		var element=evt.srcElement || evt.target;
		return element;
	} else return null;
	//var element=evt.srcElement || evt.target;
	//return element;
}

function getEvent(){
	if(document.all){
		return window.event;//如果是ie
	}
	func=getEvent.caller;
	while(func!=null){
		var arg0=func.arguments[0];
		if(arg0){
			if((arg0.constructor==Event || arg0.constructor ==MouseEvent)
			||(typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)){
				return arg0;
			}
		}
		func=func.caller;
	}
	return null;
}

function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
	
	var buttonObj = getEventSrcElement();
	if(buttonObj && buttonObj.sapflag){
			var returnvalue = window.showModalDialog("/app/sap/sapbrowser.jsp?fieldid="+inputname+"&nowdate="+(new Date()).getTime(), window, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
			var rvjson = eval(returnvalue);
			if(rvjson==null){
				return;
			}
			var trobj = jQuery(buttonObj).parent().parent();
			for(var i=0;i<rvjson.length;i++){
				var formfieldid = rvjson[i].formfieldid;
				var fieldvalue = rvjson[i].fieldvalue;
				if(formfieldid.indexOf("field_")>-1||formfieldid.indexOf("con")>-1){
					if(fieldvalue=='eweaverclear'){
						document.getElementById(formfieldid).value = '';
						if(document.getElementById(formfieldid+'span')){
							document.getElementById(formfieldid+'span').innerHTML='';
							}
						continue;
					}
					if(document.getElementById(formfieldid).value==''){
						document.getElementById(formfieldid).value = fieldvalue;
					}else{
						document.getElementById(formfieldid).value =document.getElementById(formfieldid).value+','+fieldvalue;
					}
					if(document.getElementById(formfieldid+'span')){
						if(document.getElementById(formfieldid+'span').innerText==''){
							document.getElementById(formfieldid+'span').innerHTML = fieldvalue;
						}else{
							
							document.getElementById(formfieldid+'span').innerHTML =document.getElementById(formfieldid+'span').innerHTML+','+fieldvalue;
						}
					}
				}else{
					
					if(fieldvalue=='eweaverclear'){
						jQuery(trobj).find("[name="+formfieldid+"]").val('');
						if(jQuery(trobj).find("#"+formfieldid+"span")){
							jQuery(trobj).find("#"+formfieldid+"span").html('');
						}
						continue;
					}
					if(jQuery(trobj).find("[name="+formfieldid+"]").val()==''){
						jQuery(trobj).find("[name="+formfieldid+"]").val(fieldvalue);
					}else{
						jQuery(trobj).find("[name="+formfieldid+"]").val(jQuery(trobj).find("[name="+formfieldid+"]").val()+","+fieldvalue);
					}
					if(jQuery(trobj).find("#"+formfieldid+"span")){
						if(jQuery(trobj).find("#"+formfieldid+"span").text()==""){
							jQuery(trobj).find("#"+formfieldid+"span").html(fieldvalue);
						}else{
							jQuery(trobj).find("#"+formfieldid+"span").html(jQuery(trobj).find("#"+formfieldid+"span").html()+','+fieldvalue);
						}
					}
				}
			}
			return ;
	}
	
    if (document.getElementById(inputname.replace("field", "input")) != null&&inputname.indexOf("field")>-1) {
        document.getElementById(inputname.replace("field", "input")).value = "";
    }
    var fck = param.indexOf("function:");
    if (fck > -1) {
    }
    else {
        var param = parserRefParam(inputname, param);
    }
    var idsin = document.getElementsByName(inputname)[0].value;
    var spanhtml=document.getElementsByName(inputspan)[0].innerHTML;
    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
    }
    var id;
    var browserName=navigator.userAgent.toLowerCase();
    var isSafari = /webkit/i.test(browserName) &&!(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName));
    /*
     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
     */
    var isStationBrowserInSafari = isSafari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
    //流程单选 || 工作流程单选 || 工作流程多选
	var isWorkflowBrowserInSafari = isSafari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
	//员工多选
	var isHumresBrowserInSafari = isSafari && refid == '402881eb0bd30911010bd321d8600015';	
	
    if (!Ext.isSafari) {
        try {
            // id=openDialog(url,idsin);
            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
        } 
        catch (e) {
            return
        }
        if (id != null) {
        
            if (id[0] != '0') {
                eweaverGet(inputspan).innerHTML = id[1];
                eweaverGet(inputname).value = id[0];
                if (fck > -1) {
                    funcname = param.substring(9);
                    scripts = "valid=" + funcname + "('" + id[0] + "');";
                    eval(scripts);
                    if (!valid) { //valid默认的返回true;
                        eweaverGet(inputname).value = '';
                        if (isneed == '0') 
                            eweaverGet(inputspan).innerHTML = '';
                        else 
                            eweaverGet(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                    }
                }
            }
            else {
                eweaverGet(inputname).value = '';
                if (isneed == '0') 
                    eweaverGet(inputspan).innerHTML = '';
                else 
                    eweaverGet(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                
            }
        }
    }
    else {
        url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
        var callback = function(){
            try {
                id = dialog.getFrameWindow().dialogValue;
            } 
            catch (e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    eweaverGet(inputname).value = id[0];
                    WeaverUtil.fire(eweaverGet(inputname));
                    eweaverGet(inputspan).innerHTML = id[1];
                    if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) { //valid默认的返回true;
                            eweaverGet(inputname).value = '';
                            if (isneed == '0') 
                                eweaverGet(inputspan).innerHTML = '';
                            else 
                                eweaverGet(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                }
                else {
                    eweaverGet(inputname).value = '';
                    if (isneed == '0') 
                        eweaverGet(inputspan).innerHTML = '';
                    else 
                        eweaverGet(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                    
                }
            }
        }
        var winHeight = Ext.getBody().getHeight() * 0.9;
        var winWidth = Ext.getBody().getWidth() * 0.9;
        if(winHeight>500){//最大高度500
        	winHeight = 500;
        }
        if(winWidth>880){//最大宽度880
        	winWidth = 880;
        }
        var  bodyY = mousePos();//距离body顶部
        var screenY = mouseScreenY();//距离屏幕顶部
        var browserHeight = top.outerHeight;//浏览器窗口高度
        var showY = (bodyY-(screenY-(browserHeight/2)))-winHeight/2;//显示位置为鼠标点击browser的位置---调整到屏幕中央---再往上调整win的一半高度
        if(showY<30){
        	showY = 30;
        }
        var showX = (Ext.getBody().getWidth()-winWidth)/2;
        if(showX<50){
			showX = 50;
        }
        

        if (!win) {
            win = new Ext.Window({
                layout: 'border',
                width: winWidth,
                height: winHeight,
                plain: true,
                modal: true,
                items: {
                    id: 'dialog',
                    region: 'center',
                    iconCls: 'portalIcon',
                    xtype: 'iframepanel',
                    frameConfig: {
                        autoCreate: {
                            id: 'portal',
                            name: 'portal',
                            frameborder: 0
                        },
                        eventsFollowFrameLinks: false
                    },
                    closable: false,
                    autoScroll: true
                }
            });
        }
        win.close = function(){
            this.hide();
            win.getComponent('dialog').setSrc('about:blank');
            callback();
        }
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.setPosition(showX,showY);
        win.show();
    }
   }
  function mouseScreenY(e){//鼠标距离屏幕顶部距离
		  var e = e||window.event;
		  return  e.screenY;
  }
	  
  function mousePos(e){//鼠标距离整个页面body顶部距离
	  var e = e||window.event;
	  return e.clientY+document.body.scrollTop+document.documentElement.scrollTop;
  }
  
  function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
			
		
		strend = inputname.substring(38);
		
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				if(document.getElementsByName(pname).length>0){
					pvalue = getValidStr(document.getElementsByName(pname)[0].value);
				}else{
					pname = "con"+_fieldcheck.substring(spos + 1, epos)+"_value";
					pvalue = getValidStr(document.getElementsByName(pname)[0].value);
				}
				
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
				
			}
			spos = _fieldcheck.indexOf("$");
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
			
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				
				var etag = _fieldcheck.substring(epos);
				
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}