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
							document.all(theobjid+"span").innerHTML = "<img src="+contextPath+"/images/checkinput.gif align=absMiddle>";
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
							document.all(theobjid+"span").innerHTML = "<img src="+contextPath+"/images/checkinput.gif align=absMiddle>";
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
							document.all(theobjid+"span").innerHTML = "<img src="+contextPath+"/images/checkinput.gif align=absMiddle>";
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
							document.all(theobjid+"span").innerHTML = "<img src="+contextPath+"/images/checkinput.gif align=absMiddle>";
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
							document.all(theobjid+"span").innerHTML = "<img src="+contextPath+"/images/checkinput.gif align=absMiddle>";
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
							document.all(theobjid+"span").innerHTML = "<img src="+contextPath+"/images/checkinput.gif align=absMiddle>";
						else
							document.all(theobjid+"span").innerHTML = "";
					}
					return "";				
				}
				return objvalue;
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

			
function addPerson(persontype,remark){
	if(persontype!=1 && persontype !=2 && persontype !=3&& persontype !=4)
		return;
		var url = contextPath+"/humres/base/humresbrowserm.jsp";
        if(persontype==4)
        url = contextPath+"/humres/base/humresbrowser.jsp";
        var popuptitle = encode("人事卡片");

		var b = openDialog("/base/popupmain.jsp?popuptitle=&url="+url);
		if(b==undefined){
			return;
		}
		

		var objid = getValidStr(b[0]);
		var objname = getValidStr(b[1]);

		if(objid != "" && objname != "") {

			var humresid = getEncodeStr(objid);
			var humresname = getEncodeStr(objname);

	   		var param=new Object();
	   		param.action=contextPath+"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addoptperson";

			var updatestring ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
			updatestring += "<data>";
			updatestring += "<requestid>"+requestid+"</requestid>";
			updatestring += "<persontype>"+persontype+"</persontype>";
			updatestring += "<humresid>"+humresid+"</humresid>";
			updatestring += "<humresname>"+humresname+"</humresname>";
			updatestring += "<remark>"+remark+"</remark>";
			updatestring += "</data>";

			param.updatestring=updatestring;		
			param.sourceurl=window.location.pathname;
			var result=showModalDialog(contextPath+"/base//updatedialog.html", param,
				"dialogHeight:5px; dialogWidth: 20px; center: Yes; help: No; resizable: yes; status: No");

			if(result){
				var showmessage = "";
				if(persontype==1)
					showmessage += "成功将流程转发给\""+objname+"\"。";

				if(persontype==2)
					showmessage += "成功将\""+objname+"\"添加为非会签操作人。";

				if(persontype==3)
					showmessage += "成功将\""+objname+"\"添加为会签操作人。";

                if(persontype==4){
					showmessage = "成功将流程移交给\""+objname+"\",您不再对此流程拥有权限。";
					top.frames[1].pop(showmessage);
					TodoworkPortletRefresh();
					var tabpanel=top.frames[1].contentPanel;
					tabpanel.remove(tabpanel.getActiveTab());
					return;
				}

				top.frames[1].pop(showmessage);
				TodoworkPortletRefresh();
				return;
            }else{
				top.frames[1].pop("操作失败!");
			}
		}
}
function onReturn(){
	window.history.back(-1);
}

function onReject(){
    if(CKEditorExt.getText('remark')==''){
        alert("请填写签字意见");
        return;
    }
	dlg0.show();
}
/** 刷新待办事宜元素的列表 */
function TodoworkPortletRefresh(){
//var protalTab=top.frames[1].contentPanel.items.first();
	var obj=top.frames[1];//refresh TodoWorkflowPortlet
	if(typeof(obj)=='object'){
		obj=obj.frames[0];
		if(typeof(obj)=='object'){
			obj=obj.TodoWorkflowPortlet;
			if(typeof(obj)=='object') obj.refresh();
		}
	}//end if.
}

function changeIsreject(isreject){
	document.all("isreject").value=isreject;
	
	if(isreject == 1){
		onCal();
		TodoworkPortletRefresh();
   		document.EweaverForm.submit();
	}
}

function fillotherselect(elementobj,fieldid,rowindex){
	var elementvalue = Trim(getValidStr(elementobj.value));
	var objname = "field_"+fieldid+"_fieldcheck";
	if(!document.all(objname)){
		return;
	}
	var fieldcheck = Trim(getValidStr(document.getElementsByName(objname)[0].value));
	if(fieldcheck=="")
		return;
	var sql = "select * from (select '' id,' ' objname,0 dsporder from selectitem union select s.id,s.objname,s.dsporder from selectitem s where pid = '"+elementvalue+"' and col1 is null) t order by dsporder";
	DataService.getValuesWithReplaceByLabelCustom(sql,'s.id','s.objname',{          
		callback:function(dataFromServer) {
			createList(dataFromServer, fieldcheck,rowindex);
		}
	});
}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "field_"+select_array[loop];
			if(rowindex != -1)
				objname += "_"+rowindex;
			var selectObj = document.getElementById(objname);
			 removeAllOptions(document.all(objname));

            if(document.all(objname+'span')!=null){
           document.all(objname+'span').innerHTML="<IMG src='"+contextPath+"/images/base/checkinput.gif' align=absMiddle>";
	         document.all(objname).value = "";  }
             addOptions(document.all(objname), data);
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
    
       function removeAllOptions(obj) {
	       var len = obj.options.length;
	       for (var i = len; i >= 0; i--) {
	           obj.options[i] = null
	       }
  	 }
       
	 function addOptions(obj, data) {
 
       var len = data.length;
       for (var i=0; i<len; i++) {
 
           if(data[i].id==null){
             data[i].id="";
           }
           obj.options.add(new Option(data[i].objname,data[i].id ));
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
				if(strend!=""&&(document.getElementsByName(pname)[0]==null||document.getElementsByName(pname)[0]=="undefined")){
					pname="field_"+ _fieldcheck.substring(spos + 1, epos);//点击的是字表的内容，sqlwhere验证字段在主表不在子表的时候，改为取主表的字段
				}
				pvalue = getValidStr(document.getElementsByName(pname)[0].value);
				
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


function convertCurrency(currencyDigits) {
// Constants:
 var MAXIMUM_NUMBER = 999999999999.99;
 // Predefine the radix characters and currency symbols for output:
 var CN_NEGATIVE = "负";
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
 var isNegative = false;
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
 if (currencyDigits.substring(0,1)=='-') {
 	isNegative=true;
  	currencyDigits = currencyDigits.substring(1);
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
 if(isNegative)	outputCharacters = CN_NEGATIVE + outputCharacters;
 return outputCharacters;
}

function handleAddRow(){
	
}
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
		if (f$('checkbox_'+fieldid)!=null) {
		   f$('checkbox_'+fieldid).innerHTML = "";
		}
	} else {
		var tempValue = field.value + ',';
		tempValue = tempValue.replace(box.value + ',','');
		field.value = tempValue.substring(0,tempValue.length-1);
		if (field.value==""&&f$('checkbox_'+fieldid)!=null) {
			f$('checkbox_'+fieldid).innerHTML = "<img src=\"/images/base/checkinput.gif\" align=absMiddle>";
		}
	}

}