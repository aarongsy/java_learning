/*
	Copyright (c) 2004-2007, Weaversoft
	All Rights Reserved.

*/



  String.prototype.fn   =   function(n)   
      {   s=""   
          for(i=0;i<n;i++)s+=this   
          return   s   
      }   
  Number.prototype.fix   =   function(num)   
      {with(Math)return   (round(this.valueOf()*pow(10,num))/pow(10,num)).toString().search(/\./i)==-1?(round(this.valueOf()*pow(10,num))/pow(10,num)).toString()+"."+"0".fn(num):(round(this.valueOf()*pow(10,num))/pow(10,num));   
      }   
      	function GT(param1,theobjid,showtype,type){
				var tmpval = getValidStr(eval(param1));
				var objvalue = getValidStr(document.all(theobjid).value);
				if(type == 3)
					objvalue = getValidStr(document.all(theobjid).innerHTML);
				if(tmpval == "" || objvalue == "")
					return objvalue;
				
				var istrue = 0;
				if(type == 1){
					var val1 = tmpval*1;
					var val0 = objvalue * 1;
					if(val0 > val1)
						istrue = 1;
				}else{
					var val1 = tmpval;
					var val0 = objvalue;
					if(val0 > val1)
						istrue = 1;
				}
				
				
				if(istrue == 0){
					if(type == 2 ){
						if(showtype==3)
							document.all(theobjid+"span").innerHTML = "<img src=../images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
			}
			
			
			function GE(param1,theobjid,showtype,type){
				var tmpval = getValidStr(eval(param1));
				var objvalue = getValidStr(document.all(theobjid).value);
				if(type == 3)
					objvalue = getValidStr(document.all(theobjid).innerHTML);
				if(tmpval == "" || objvalue == "")
					return objvalue;
				
				var istrue = 0;
				if(type == 1){
					var val1 = tmpval*1;
					var val0 = objvalue * 1;
					if(val0 >= val1)
						istrue = 1;
				}else{
					var val1 = tmpval;
					var val0 = objvalue;
					if(val0 >= val1)
						istrue = 1;
				}
				
				
				if(istrue == 0){
					if(type == 2 ){
						if(showtype==3)
							document.all(theobjid+"span").innerHTML = "<img src=../images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
			}
			
			function EQ(param1,theobjid,showtype,type){
				var tmpval = getValidStr(eval(param1));
				var objvalue = getValidStr(document.all(theobjid).value);
				if(type == 3)
					objvalue = getValidStr(document.all(theobjid).innerHTML);
				if(tmpval == "" || objvalue == "")
					return objvalue;
				
				var istrue = 0;
				if(type == 1){
					var val1 = tmpval*1;
					var val0 = objvalue * 1;
					if(val0 == val1)
						istrue = 1;
				}else{
					var val1 = tmpval;
					var val0 = objvalue;
					if(val0 == val1)
						istrue = 1;
				}
				
				
				if(istrue == 0){
					if(type == 2 ){
						if(showtype==3)
							document.all(theobjid+"span").innerHTML = "<img src=../images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
			}
			
			function NQ(param1,theobjid,showtype,type){
				var tmpval = getValidStr(eval(param1));
				var objvalue = getValidStr(document.all(theobjid).value);
				if(type == 3)
					objvalue = getValidStr(document.all(theobjid).innerHTML);
				if(tmpval == "" || objvalue == "")
					return objvalue;
				
				var istrue = 0;
				if(type == 1){
					var val1 = tmpval*1;
					var val0 = objvalue * 1;
					if(val0 != val1)
						istrue = 1;
				}else{
					var val1 = tmpval;
					var val0 = objvalue;
					if(val0 != val1)
						istrue = 1;
				}
				
				
				if(istrue == 0){
					if(type == 2 ){
						if(showtype==3)
							document.all(theobjid+"span").innerHTML = "<img src=../images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
			}
			
			function LE(param1,theobjid,showtype,type){
				var tmpval = getValidStr(eval(param1));
				var objvalue = getValidStr(document.all(theobjid).value);
				if(type == 3)
					objvalue = getValidStr(document.all(theobjid).innerHTML);
				if(tmpval == "" || objvalue == "")
					return objvalue;
				
				var istrue = 0;
				if(type == 1){
					var val1 = tmpval*1;
					var val0 = objvalue * 1;
					if(val0 <= val1)
						istrue = 1;
				}else{
					var val1 = tmpval;
					var val0 = objvalue;
					if(val0 <= val1)
						istrue = 1;
				}
				
				
				if(istrue == 0){
					if(type == 2 ){
						if(showtype==3)
							document.all(theobjid+"span").innerHTML = "<img src=../images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
			}
			
			function LT(param1,theobjid,showtype,type){
				var tmpval = getValidStr(eval(param1));
				var objvalue = getValidStr(document.all(theobjid).value);
				if(type == 3)
					objvalue = getValidStr(document.all(theobjid).innerHTML);
				if(tmpval == "" || objvalue == "")
					return objvalue;
				
				var istrue = 0;
				if(type == 1){
					var val1 = tmpval*1;
					var val0 = objvalue * 1;
					if(val0 < val1)
						istrue = 1;
				}else{
					var val1 = tmpval;
					var val0 = objvalue;
					if(val0 < val1)
						istrue = 1;
				}
				
				
				if(istrue == 0){
					if(type == 2 ){
						if(showtype==3)
							document.all(theobjid+"span").innerHTML = "<img src=../images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
			}
			

			function SUM(param){
				var result = 0;
				for(index=0;index<rowindex;index++){
					tmpval = 0;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 0;
					}
					//alert(tmpval);
					result += tmpval;
				}
				rowindex = 0;
				return result;
			}
			
			function RMB(param){
				var tmpval = eval(param)*1;
				var result =  convertCurrency(tmpval);
				return result;
			}
			function COUNT(param){
				var result = 0;
				for(index=0;index<rowindex;index++){
					tmpval = 0;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 0;
					}
					if(tmpval != 0)
						result ++;
				}
				rowindex = 0;
				return result;
			}
			function PROD(param){
				var result = 1;
				for(index=0;index<rowindex;index++){
					tmpval = 1;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 1;
					}
					//alert(tmpval);
					result = result * tmpval;
				}
				rowindex = 0;
				return result;
			}
			function MAX(param){
				var result = 0;
				for(index=0;index<rowindex;index++){
					tmpval = 0;
					try{
					tmpval = eval(param)*1;
					}catch(e){
					tmpval = 0;
					}
					if(tmpval > result)
						result = tmpval;
				}
				rowindex = 0;
				return result;
			}
		
			function SQL(param){	
				var _url= "../ServiceAction/com.eweaver.base.DataAction?sql="+encode(param);
				var XMLDoc=new ActiveXObject("MSXML");
				
					XMLDoc.url=_url;
					var XMLRoot=XMLDoc.root;
		
					var retval = getValidStr(XMLRoot.text);
					return retval;
				//DataService.getValue(setValue,param);
				//return document.all("tmpvalue").value;
			}
			
			function setValue(data){
				document.all("tmpvalue").value=data;
			}
		
			function toPrecision(aNumber,precision){
				var temp2 = new Number(aNumber);
				var temp3 = new Number(precision);
				var returnval =temp2.fix(temp3); 
				return isNaN(returnval)?0:returnval;
			//	var tmp3 = Math.round(temp1*temp2) /temp1;
			//	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
			}
			
			
function addPerson(persontype){
	if(persontype!=1 && persontype !=2 && persontype !=3)
		return;
		var url = "../humres/base/humresbrowserm.jsp";
		var popuptitle = encode("人事卡片");
		
		var b = openDialog("../base//popupmain.jsp?popuptitle="+popuptitle+"&url="+url);
		if(b==undefined){
			return;
		}

   		
		var objid = getValidStr(b[0]);	
		var objname = getValidStr(b[1]);	
		
		if(objid != "" && objname != "") {
			
			var humresid = getEncodeStr(objid);
			var humresname = getEncodeStr(objname);
			
	   		var param=new Object();
			param.action="../ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addoptperson";
			
			var updatestring ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
			updatestring += "<data>";
			updatestring += "<workflowid><%=workflowid%></workflowid>";
			updatestring += "<persontype>"+persontype+"</persontype>";
			updatestring += "<humresid>"+humresid+"</humresid>";
			updatestring += "<humresname>"+humresname+"</humresname>";
			updatestring += "</data>";
			
			param.updatestring=updatestring;		
			param.sourceurl=window.location.pathname;
			var result=showModalDialog("../base//updatedialog.html", param,
				"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
		   	
			if(result){
				var showmessage = "成功将\""+objname+"\"加入到";
				if(persontype==1)
					showmessage += "知会人列表!";
				
				if(persontype==2)
					showmessage += "操作人列表!";
				
				if(persontype==3)
					showmessage += "会签人列表!";
				alert(showmessage);
			}else{
				alert("失败!");
			}
		}
}
function onReturn(){
	window.history.back(-1);
}

function onReject(){
	dlg0.show();
}


function changeIsreject(isreject){
	document.all("isreject").value=isreject;
	
	if(isreject == 1){		
	
	onCal();
	
   		document.EweaverForm.submit();
	}
}

function fillotherselect(elementobj,fieldid,rowindex){
	
	var elementvalue = Trim(getValidStr(elementobj.value));
	
	var objname = "field_"+fieldid+"_fieldcheck";
	
	var fieldcheck = Trim(getValidStr(document.all(objname).value));
		
	if(fieldcheck=="")
		return;
		
//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql = "select ''  id,' '  objname   from selectitem union (select id,objname from selectitem where pid = '"+elementvalue+"')";

	DataService.getValues(sql,{          
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);
   	
}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "field_"+select_array[loop];
			if(rowindex != -1)
				objname += "_"+rowindex;
		    DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
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
				pvalue = getValidStr(document.all(pname).value);
				
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
				
			}
			spos = _fieldcheck.indexOf("$",epos+1);
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


function convertCurrency(currencyDigits) {
// Constants:
 var MAXIMUM_NUMBER = 99999999999.99;
 // Predefine the radix characters and currency symbols for output:
 var CN_ZERO = "零";
 var CN_ONE = "壹";
 var CN_TWO = "贰";
 var CN_THREE = "叁";
 var CN_FOUR = "肆";
 var CN_FIVE = "伍";
 var CN_SIX = "陆";
 var CN_SEVEN = "柒";
 var CN_EIGHT = "捌";
 var CN_NINE = "玖";
 var CN_TEN = "拾";
 var CN_HUNDRED = "佰";
 var CN_THOUSAND = "仟";
 var CN_TEN_THOUSAND = "万";
 var CN_HUNDRED_MILLION = "亿";
 var CN_SYMBOL = "";
 var CN_DOLLAR = "元";
 var CN_TEN_CENT = "角";
 var CN_CENT = "分";
 var CN_INTEGER = "整";
 
// Variables:
 var integral; // Represent integral part of digit number.
 var decimal; // Represent decimal part of digit number.
 var outputCharacters; // The output result.
 var parts;
 var digits, radices, bigRadices, decimals;
 var zeroCount;
 var i, p, d;
 var quotient, modulus;
 
// Validate input string:
 currencyDigits = currencyDigits.toString();
 if (currencyDigits == "") {
  alert("Empty input!");
  return "";
 }
 if (currencyDigits.match(/[^,.\d]/) != null) {
  alert("Invalid characters in the input string!");
  return "";
 }
 if ((currencyDigits).match(/^((\d{1,3}(,\d{3})*(.((\d{3},)*\d{1,3}))?)|(\d+(.\d+)?))$/) == null) {
  alert("Illegal format of digit number!");
  return "";
 }
 
// Normalize the format of input digits:
 currencyDigits = currencyDigits.replace(/,/g, ""); // Remove comma delimiters.
 currencyDigits = currencyDigits.replace(/^0+/, ""); // Trim zeros at the beginning.
 // Assert the number is not greater than the maximum number.
 if (Number(currencyDigits) > MAXIMUM_NUMBER) {
  alert("Too large a number to convert!");
  return "";
 }
 
// Process the coversion from currency digits to characters:
 // Separate integral and decimal parts before processing coversion:
 parts = currencyDigits.split(".");
 if (parts.length > 1) {
  integral = parts[0];
  decimal = parts[1];
  // Cut down redundant decimal digits that are after the second.
  decimal = decimal.substr(0, 2);
 }
 else {
  integral = parts[0];
  decimal = "";
 }
 // Prepare the characters corresponding to the digits:
 digits = new Array(CN_ZERO, CN_ONE, CN_TWO, CN_THREE, CN_FOUR, CN_FIVE, CN_SIX, CN_SEVEN, CN_EIGHT, CN_NINE);
 radices = new Array("", CN_TEN, CN_HUNDRED, CN_THOUSAND);
 bigRadices = new Array("", CN_TEN_THOUSAND, CN_HUNDRED_MILLION);
 decimals = new Array(CN_TEN_CENT, CN_CENT);
 // Start processing:
 outputCharacters = "";
 // Process integral part if it is larger than 0:
 if (Number(integral) > 0) {
  zeroCount = 0;
  for (i = 0; i < integral.length; i++) {
   p = integral.length - i - 1;
   d = integral.substr(i, 1);
   quotient = p / 4;
   modulus = p % 4;
   if (d == "0") {
    zeroCount++;
   }
   else {
    if (zeroCount > 0)
    {
     outputCharacters += digits[0];
    }
    zeroCount = 0;
    outputCharacters += digits[Number(d)] + radices[modulus];
   }
   if (modulus == 0 && zeroCount < 4) {
    outputCharacters += bigRadices[quotient];
   }
  }
  outputCharacters += CN_DOLLAR;
 }
 // Process decimal part if there is:
 if (decimal != "") {
  for (i = 0; i < decimal.length; i++) {
   d = decimal.substr(i, 1);
   if (d != "0") {
    outputCharacters += digits[Number(d)] + decimals[i];
   }
  }
 }
 // Confirm and return the final output string:
 if (outputCharacters == "") {
  outputCharacters = CN_ZERO + CN_DOLLAR;
 }
 if (decimal == "") {
  outputCharacters += CN_INTEGER;
 }
 outputCharacters = CN_SYMBOL + outputCharacters;
 return outputCharacters;
}