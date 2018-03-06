//选择
function getSelectedData(input){
	var _id = input.cells[0].innerText;
	var _name = input.cells[1].innerText;
    var resultArray = new Array();
    resultArray[0]= _id;
    resultArray[1]= _name;
    window.parent.returnValue=resultArray;
    window.close();
}
//清除
function btnclear_onclick(){
    var resultArray = new Array();
    resultArray[0]= "";
    resultArray[1]= "";
    window.parent.returnValue=resultArray;
    window.close();
}

function node_ondbclick(key,text){
    var resultArray = new Array();
    resultArray[0]= key;
    resultArray[1]= text;
    window.parent.returnValue=resultArray;
    window.close();
}

function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	idsin = document.all(inputname).value;
	var result = window.showModalDialog("/vbase/popupmain.jsp?url=/vbase/refobj/baseobjbrowser.jsp?id="+refid+"&idsin="+idsin);
	if(!result){return;}
	var _id = result[0];
	var _name = result[1];
	if(_id==""){
		document.all(inputname).value = "";
		if(isneed == "1"){
			document.all(inputspan).innerHTML = "<img src=/vimgs/checkinput.gif>";
		}else{
			document.all(inputspan).innerHTML = "";
		}
		
	}else{
		document.all(inputname).value = _id;
		document.all(inputspan).innerHTML = _name;	
	}
}

//如果存在同名函数,则后定义的会覆盖先定义的
function getrefobjwf(inputname,inputspan,refid,param,viewurl,isneed){
	if(param != ""){
		param = parserRefParam(inputname,param);
	}
	idsin = document.all(inputname).value;
	var result = window.showModalDialog("/vbase/popupmain.jsp?url=/vbase/refobj/baseobjbrowser.jsp?id="+refid+"&"+param+"&idsin="+idsin);
	if(!result){return;}
	var _id = result[0];
	var _name = result[1];
	if(_id==""){
		document.all(inputname).value = "";
		if(isneed == "1"){
			document.all(inputspan).innerHTML = "<img src=/vimgs/checkinput.gif>";
		}else{
			document.all(inputspan).innerHTML = "";
		}
	}else{
		document.all(inputname).value = _id;
		document.all(inputspan).innerHTML = _name;	
	}
	if(param != ""){
		onCal();
	}
}

function getBrowser(url,inputname,inputspan,isneed){
	var idsin = document.all(inputname).value;
	var result = window.showModalDialog(baserootpath+"/vbase/popupmain.jsp?url="+url+"&idsin=" + idsin);
	if(!result){return;}
	var _id = result[0];
	var _name = result[1];
	if(_id==""){
		document.all(inputname).value = "";
		if(isneed == "1"){
			document.all(inputspan).innerHTML = "<img src="+baserootpath+"/vimgs/checkinput.gif>";
		}else{
			document.all(inputspan).innerHTML = "";
		}
	}else{
		document.all(inputname).value = _id;
		document.all(inputspan).innerHTML = _name;	
	}
}
function getBrowseriscludesub(url,inputname,inputspan,isneed){	
	var iscludesub=document.all("iscludesub").value;
	var idsin = document.all(inputname).value;
	var result = window.showModalDialog("/vbase/popupmain.jsp?url="+url+"&idsin=" + idsin+"&iscludesub="+iscludesub);
	if(!result){return;}
	var _id = result[0];
	var _name = result[1];
	if(_id==""){
		document.all(inputname).value = "";
		document.all("iscludesub").value="";
		if(isneed == "1"){
			document.all(inputspan).innerHTML = "<img src=/vimgs/checkinput.gif>";
		}else{
			document.all(inputspan).innerHTML = "";
		}
	}else{
		document.all(inputname).value = _id;
		document.all("iscludesub").value=result[2];
		document.all(inputspan).innerHTML = _name;	
	}
}