function checkForm(thisform,items,message)
{
	thisform = thisform;
	items = items + ",";

	for(i=1;i<=thisform.length;i++)
	{
	tmpname = thisform.elements[i-1].name;
	tmpvalue = thisform.elements[i-1].value;
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0 || tmpvalue.indexOf("　") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);

	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert(message);
		 return false;
		}

	}
	return true;
}

function isConfirm(message){
   if(!confirm(message)){
       return false;
   }
       return true;
}



function checkInput(elementname,spanid){
	tmpvalue = document.all(elementname).value;

	while(tmpvalue.indexOf(" ") == 0 || tmpvalue.indexOf("　") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""){
		 document.all(spanid).innerHTML='';
	}
	else{
	 document.all(spanid).innerHTML="<IMG src='../images/checkinput.gif' align=absMiddle>";
	 document.all(elementname).value = "";
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