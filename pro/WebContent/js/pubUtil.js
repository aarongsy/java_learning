
PubUtil=function PubUtil(){};

/**
 * 取当前焦点元素。
 */
PubUtil.getActiveElement=function()
{
  return document.activeElement;//只ie支持
};

/**
 * 查找某一对象。
 * @param n 对象标识。
 * @param d document对象。
 */
PubUtil.findObj=function(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=PubUtil.findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
};


/**
 * 显示/隐藏层.
 * 参数格式:layerId,"",show(hide),layerId,"",show(hide)...
 */
PubUtil.showHideLayers=function() { //v3.0
  var i,p,v,obj,args=PubUtil.showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=PubUtil.findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
};


/**
 * 显示/隐藏对象。
 * @param id 层的id.
 * @param isShow 是否显示.
 * @param doc document.
 */
PubUtil.showHideElement=function(id,isShow,doc)
{
  if(!doc)
    doc=document;  
  var obj=doc.getElementById(id);
  if(!obj)
    return;  
  if(isShow)
  {
    if(obj.style.display!=null) 
      obj.style.display = ""; //obj.style.display = "block"; 
    else 
      obj.visibility = "show"; 
	obj.zIndex=100000;
  }
  else
  {
    if(obj.style.display!=null)
      obj.style.display = "none";
    else
      obj.visibility = "hiden";
  }
};

/**
 * 切换元素的显示状态。
 * @param id 元素的id.
 * @param doc document.
 */
PubUtil.toggleVisible=function(id,doc)
{
  if(!doc)
    doc=document;
  var obj=doc.getElementById(id);
  if(!obj)
    return;
  if(obj.style.display!=null) 
  {
    if(obj.style.display=="none")
      obj.style.display = "";//obj.style.display = "block";
    else
      obj.style.display = "none";
  }
  else
  {
    if(obj.visibility=="hiden")
      obj.visibility = "show";
    else
      obj.visibility = "hiden";
  }
};

/**
 * 将字符串进行HTML过滤，如"&lt;"变为"&amp;lt;"。<br>
 * @param input 要转换的字符串。<br>
 * @param isIgnEnter 是否忽略回车换行符。<br>
 * @return 处理过的字符串。<br>
 */
PubUtil.htmlFilter=function(input)
{
  if(!input || input=="")
    return "";
  var origIns=null;
  var filterStrs=null;
  origIns=new Array('<','>','"','\'','&','\r','\n','?','=');
  filterStrs=new Array("&lt;","&gt;","&quot;","&#39;","&amp;","","<br>","&#63;","&#61;");
  var filtered = "";
  var c = null;
  for(var i=0; i<input.length; i++)
  {
    c = input.charAt(i);
    var isFind=false;
    for(var j=0;j<origIns.length;j++)
    {
      if(c==origIns[j])
      {
        filtered+=filterStrs[j];
        isFind=true;
        break;
      }
    }
    if(!isFind)//没有找到
      filtered+=c;
  }    
  return filtered;
};

/**
 * 将进行HTML过滤后的字符串转换后的字符串恢复到原始值，如"&amp;lt;"转变为"&lt;".
 * @param input 等处理的字符串。
 */
PubUtil.antiHtmlFilter=function(input)

{

  if(input==null || input=="")
 
     return "";
    //这里没有处理大小写，以后要处理。
    
  var origStrArr=new Array("&nbsp;","&lt;","&gt;","&quot;","&#39;","&amp;","<br>","&#63;","&#61;");
 
  var newStrArr=new Array(" ","<",">","\"","\'","&","\n","?","=");
 
  for(var i=0;i<origStrArr.length;i++)

  {
     
    var re = new RegExp(origStrArr[i],"gi");
    input=input.replace(re,newStrArr[i]);
  }
  
  return input;
 
};


/**
 * 将光标移到文字最后。
 * @param elem 输入框。
 */
PubUtil.moveToTextLast=function(elem)
{
  if(!elem)
	  elem=event.srcElement;
  var r =elem.createTextRange();
  r.moveStart("character",elem.value.length);
  r.collapse(true);
  r.select();
};

/**
 * 自动调整textArea的高度。
 * @param textArea textarea控件。
 */
PubUtil.autoTextAreaHeight=function(textArea)
{
  height=textArea.scrollHeight;
  if(height<20)
    height=20;
  textArea.style.posHeight=height;
};


/**
 * 删除select所有的options
 * @param id select字段id。
 */
PubUtil.selectRemoveAll=function(id)
{
	var obj=document.getElementById(id);
	obj.options.length=0;  
};



/**
 * 删除select所有的options
 * @param id select字段id。
 */
PubUtil.selectRemoveAll=function(id)
{
	var obj=document.getElementById(id);
	obj.options.length=0;  
};
/**
 * 删除select其中一项
 * @param id select字段id，optionval 值。
 */
PubUtil.selectRemoveOneById=function(id,optionval)
{
	var selectobj=document.getElementById(id);
	
	var opts =  selectobj.options;
	if(opts==null)return;

	for (var i=0,len=opts.length; i< len ; i++)
	{
		if(opts[i].value==optionval)
		{
			selectobj.remove(i);
			break;
		}
	}
};

/**
 * 增加select的option
 * @param id select字段id，增加的Map数组data，map中的key标识 ，map中的text标识。
 */
PubUtil.addOptionsByMap=function(id,data,key,name)
{
	//根据id查找对象，
	var obj=document.getElementById(id);
	for(var i=0,len=data.length;i<len;i++)
	{
		var valid=data[i].id;
		var valtext=data[i].objname;
		obj.add(new Option(valtext,valid));  
	}
};



/**
 * 创建XMLHTTP对象。
 * @return XMLHTTP对象。
 */
PubUtil.createXMLHttp=function()
{
  var xmlHttp; 
  if (document.all){        // document.all means IE 
    try { 
        xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");         
    } catch (e) { 
        try { 
            xmlHttp=new ActiveXObject("Msxml2.XMLHTTP"); //会有缓存问题，每次返回的都一样
        } catch (e) { 
            xmlHttp=null; 
        } 
    } 
  }else{ 
      try { 
          xmlHttp = new XMLHttpRequest(); 
      } catch (e) { 
          xmlHttp=null; 
      } 
  } 
  if(xmlHttp==null)
    alert("创建XMLHTTP错误，可能您的浏览器不支持!");
  return xmlHttp; 
};
/**
 * 创建XMLHTTP对象。
 * @return XMLHTTP对象。
 */
PubUtil.sendXMLRequest=function(theURL)
{
      var xmlHttpObj=PubUtil.createXMLHttp();        
        if(xmlHttpObj){        
            xmlHttpObj.open('POST',theURL,false);        
            xmlHttpObj.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');        
            xmlHttpObj.send(null);          
            var resultInfo=xmlHttpObj.responseText;        
            return resultInfo;        
        } 
};

/**
 * 对URI进行编码。
 * @param origURI 等编码的URI。
 * @return 编码的URI。
 */
PubUtil.encodeURI=function(origURI)
{
  if(origURI.indexOf("%")==-1)
    return encodeURI(origURI);  
  //return encodeURI(decodeURIComponent(origURI));//不能这样，国为参数值中可能有特殊字符，如?,&。
  //可能程序中以UTF-8编过码，这里要处理一下。
  var pos=origURI.indexOf("?");
  if(pos==-1)
    return origURI;  
  var newURI=encodeURI(origURI.substring(0,pos+1));
  var params=origURI.substring(pos+1);
  var paramArr=params.split("&");
  for(var i=0,size=paramArr.length;i<size;i++)
  {
    if(i>0)
      newURI+="&";
    var paramPair=paramArr[i];
    var pos2=paramPair.indexOf("=");
    if(pos2==-1)
    {
      alert("给定的URI中参数错误，可能未对内容&编码，URI："+origURI);
      return;
    }
    newURI+=encodeURIComponent(paramPair.substring(0,pos2))+"=";
    var value=paramPair.substring(pos2+1);
    if(value.indexOf("%")!=-1)//编过码
    {
      try
      {
        value=decodeURIComponent(value);  
      }
      catch (e)
      {
      }      
    }
    newURI+=value=encodeURIComponent(value);   
  }  
  return newURI;
}


/**
 * 取与子节点对应的指定标签类型父节点。
 * @param childNode 子节点。
 * @param parentTagName 父节点标签类型。
 * @return 父节点，没有找到返回null.
 */
PubUtil.getParentNode=function(childNode,parentTagName)
{
  var tmpObj=childNode.parentNode;
  parentTagName=parentTagName.toLowerCase();
  while(childNode!=null && tmpObj.tagName.toLowerCase()!=parentTagName)
  {
    tmpObj=tmpObj.parentNode;
  }
  return tmpObj;
};

/**
 * 判断当前面元素是否更改过。
 * @param doc document对象。
 * @return 是否更改过。
 */
PubUtil.isPageModified=function(doc)
{
  if(doc==null)
    doc=document;
  for(var i=0;i<doc.forms.length;i++)
  {
    if(PubUtil.isFormModified(doc.forms[i]))
      return true;
  }
  return false;
};

/**
 * 判断指定表单是否更改过。
 * @param formObj form对象。
 * 是否更改过。
 */
PubUtil.isFormModified=function(formObj)
{
  for(var i=0;i<formObj.length;i++)
  {
    if(PubUtil.isElemModified(formObj.elements[i]))
      return true;
  }
  return false;
};

/**
 * 判断当前面元素是否更改过。
 * @param elem 元素对象。
 * 是否更改过。
 */
PubUtil.isElemModified=function(elem)
{
  if(typeof elem.type=="undefined")
    return false;
  var isModified=false;
  switch(elem.type.toLowerCase())
  {
    case "text":
    case "textarea":
    case "password":
    case "file":
      if(elem.defaultValue!=elem.value)
        isModified=true;
      break;
    case "hidden":      
      break;        
    case "select-one":
      var optionArr=elem.options;
      for(var e2=1;e2<optionArr.length;e2++)//单选框第一个option不判断，判断其它项即可得到结果，因可能没有checked的元素而默认第一个.
      {
        if(optionArr[e2].defaultSelected!=optionArr[e2].selected)
        {
          isModified=true;
          break;
        }
      }
      break;
    case "select-multiple":
      var optionArr=elem.options;
      for(var e2=0;e2<optionArr.length;e2++)
      {
        if(optionArr[e2].defaultSelected!=optionArr[e2].selected)
        {
          isModified=true;
          break;
        }
      }
      break;
    case "checkbox":
    case "radio":
    if(elem.defaultChecked!=elem.checked)
      isModified=true;
    break;
  }
  return isModified;
};


/**
 * 表单中多个元素具有相同名称时，将指定的元素的值设置为前一个元素的值。
 * @param elemNames 元素名称集，以","间隔。
 * @param curIndex 当前处理的元素索引，如果为null或-1，则取最后一元素。
 * @param isInnerHTML 如果没有value属性，是否设置innerHTML,默认为true.
 */
PubUtil.copyElemValues=function(elemNames,curIndex,isInnerHTML)
{
  if(isInnerHTML==null)
    isInnerHTML=true;
  var elemNameArr=elemNames.split(",");
  for(var i=0;i<elemNameArr.length;i++)
  {
    var elemName=PubUtil.trim(elemNameArr[i]);
    var elemArr=document.getElementsByName(elemName);
    if(elemArr.length<2)
      continue;
    if(curIndex==null || curIndex==-1)
      curIndex=elemArr.length-1;
    else if(curIndex==0 || curIndex>elemArr.length-1)
      continue;
    if(isInnerHTML && (typeof elemArr[curIndex].value=="undefined"))
    {
      elemArr[curIndex].innerHTML=elemArr[curIndex-1].innerHTML;
    }
    if(typeof elemArr[curIndex].type=="undefined")
       continue;
    switch(elemArr[curIndex].type.toLowerCase())
    {
      case "text":
      case "textarea":
      case "password":
      case "hidden":
      case "file":
        elemArr[curIndex].value=elemArr[curIndex-1].value;
        elemArr[curIndex].defaultValue=elemArr[curIndex-1].defaultValue;
        break;
      case "select-one":
      case "select-multiple":          
        var optionArr=elemArr[curIndex].options;
        var optionArr2=elemArr[curIndex-1].options;
        for(var j=0;j<optionArr.length;j++)
        {
          optionArr[j].selected=optionArr2[j].selected;
          optionArr[j].defaultSelected=optionArr2[j].defaultSelected;
        }
        if(typeof elemArr[curIndex].selectedIndex!="undefined")//多选可能没有这个属性
        {
          elemArr[curIndex].selectedIndex=elemArr[curIndex-1].selectedIndex;
        }
        break;
      case "checkbox":
      case "radio":
        elemArr[curIndex].checked=elemArr[curIndex-1].checked;
        elemArr[curIndex].defaultChecked=elemArr[curIndex-1].defaultChecked;
        break;
      default:        
        break;
    }
  }
};

/**
 * 清除表单中指定元素的值。
 * @param elemNames 元素名称集，以","间隔。
 * @param fromIndex 存在多个同名元素时，起始元素索引，如果为null或-1，则取最后一元素。
 * @param endIndex 存在多个同名元素时，终止元素索引，如果为null或-1，则取最后一元素。
 * @param isInnerHTML 如果没有value属性，是否处理innerHTML,默认为true.
 */
PubUtil.clearElemValues=function(elemNames,startIndex,endIndex,isInnerHTML)
{
  if(isInnerHTML==null)
    isInnerHTML=true;
  var elemNameArr=elemNames.split(",");
  for(var i=0;i<elemNameArr.length;i++)
  {
    var elemName=PubUtil.trim(elemNameArr[i]);
    var elemArr=document.getElementsByName(elemName);
    if(elemArr.length==0)
      continue;
    if(startIndex==null || startIndex==-1)
      startIndex=elemArr.length-1;
    if(endIndex==null || endIndex==-1)
      endIndex=elemArr.length-1;
    for(var j=startIndex;j<=endIndex;j++)
    {
      if(isInnerHTML && (typeof elemArr[j].value=="undefined"))
      {
        elemArr[j].innerHTML="";
      }
      if(typeof elemArr[j].type=="undefined")
        continue;
      switch(elemArr[j].type.toLowerCase())
      {
        case "text":
        case "textarea":
        case "password":
        case "hidden":
        case "file":
          elemArr[j].value="";
          break;
        case "select-one":
        case "select-multiple": 
          elemArr[j].value="";
          var optionArr=elemArr[j].options;
          for(var k=0;k<optionArr.length;k++)
          {
            optionArr[k].selected=false;
          }
          break;
        case "checkbox":
        case "radio":
          elemArr[j].checked=false;
          break;
        default:        
          break;
      }
    }
  }
};


/**
 * 将元素当前值增加某值.
 * @param elem 元素对象。
 * @param addValue 增加的值。
 * @param isInnerHTML 如果没有value属性，是否设置innerHTML,默认为true.
 */
PubUtil.addElemValue=function(elem,addValue,isInnerHTML)
{
  if(elem==null)
    return;
  if(isInnerHTML==null)
    isInnerHTML=true;
  if(elem.tagName=="input" && (elem.type.toLowerCase()=="checkbox" || elem.type.toLowerCase()=="radio"))
    return;
  if(typeof elem.value !="undefined")
  {
    var newValue=parseFloat(addValue)+parseFloat(elem.value);
    if(!isNaN(newValue))
      elem.value=newValue;
  }
  else if(isInnerHTML && (typeof elem.innerHTML!="undefiend"))
  {
    if(isNumber(elem.innerHTML))
    {
      var newValue=parseFloat(addValue)+parseFloat(elem.innerHTML);
      if(!isNaN(newValue))
        elem.innerHTML=newValue;
    }    
  }
};


/**
 * 设置元素值.
 * @param elem 元素对象。
 * @param value 元素值。
 * @param isInnerHTML 如果没有value属性，是否设置innerHTML,默认为true.
 */
PubUtil.setElemValue=function(elem,value,isInnerHTML)
{
  if(elem==null)
    return;
  if(isInnerHTML==null)
    isInnerHTML=true;
  if(elem.tagName=="input" && (elem.type.toLowerCase()=="checkbox" || elem.type.toLowerCase()=="radio"))
  {
    if(value==elem.value)
      elem.checked=true;
    else
      elem.checked=false;
    return;
  }
  if(typeof elem.value !="undefined")
    elem.value=value;//对于select单选也生效。
  else if(isInnerHTML && (typeof elem.innerHTML!="undefiend"))
    elem.innerHTML=value;
};


/**
 * 取元素值.
 * @param elem 元素对象。
 * @param isInnerHTML 如果没有value属性，是否处理innerHTML,默认为true.
 * @return 元素值。
 */
PubUtil.getElemValue=function(elem,isInnerHTML)
{
  if(elem==null)
    return;
  if(isInnerHTML==null)
    isInnerHTML=true;
  if(typeof elem.value !="undefined")
    return elem.value;//对于select单选也生效。
  else if(isInnerHTML && (typeof elem.innerHTML!="undefiend"))
    return elem.innerHTML;
};

/**
 * 根据元素名称取元素对象。
 * @param elemName 元素名称，或id.
 * @param index 如果存在多个同名元素，元素的位置索引，=-1或null时取最后一个.
 * @return 元素对象。
 */
PubUtil.getElemObj=function(elemName,index)
{
  var elemArr=document.getElementsByName(elemName);
  if(elemArr.length==0)
  {
    var elem=document.getElementByID(elemName);
    return elem;
  }
  if(index==-1 || index==null)
    return elemArr[elemArr.length-1];
  if(index>elemArr.length-1)
    return null;
  else
    return elemArr[index];
};

/**
 * 重置子元素值。
 * @param parentElem 父元素集。
 */
PubUtil.resetChildValues=function(parentElem)
{
  var childElems=PubUtil.getEditChildElems(parentElem);
  for(var e=0;e<childElems.length;e++)
  {
    var elem=childElems[e];
	if(!elem.type)
      continue;
    var elemType=elem.type.toLowerCase();
    switch(elemType)
    {
      case "text":
      case "textarea":
      case "password":
      case "hidden":
      case "file":   
        elem.value=elem.defaultValue;
	      break;   
      case "select-one":        
      case "select-multiple":
        elem.value=elem.defaultValue;//必须放在设置selected前面，
        //options原来没有一个选中,设置selected不会改变value。
        var optionArr=elem.options;
        for(var e2=0;e2<optionArr.length;e2++)
        {
          optionArr[e2].selected=optionArr[e2].defaultSelected;
        }
	      break;
      case "checkbox":
      case "radio":
        elem.checked=elem.defaultChecked;
	      break;
    }
  }
};

/**
 * 取编辑子元素集。
 * @param parentElem 父元素对象。
 * @return 编辑子元素集。
 */
PubUtil.getEditChildElems=function(parentElem)
{
  var tmp=parentElem.childNodes;
  if(tmp==null)
    return new Array(0);
  var objArr=new Array(tmp.length);
  for(var i=0;i<tmp.length;i++)//直接用tmp.concat()出错。
  {
    objArr[i]=tmp[i];
  }
  var editElems=new Array();
  var counter=0;
  for(var i=0;i<objArr.length;i++)
  {
    if(typeof objArr[i]!="object")
      continue;
    var isAddChildNodes=true;
    if(typeof objArr[i].type !="undefined")
    {
      isAddChildNodes=false;
      switch(objArr[i].type.toLowerCase())
      {
        case "text":
        case "textarea":
        case "password":
        case "hidden":
        case "file":
        case "select-one":
        case "select-multiple":          
        case "checkbox":
        case "radio":
          editElems[counter++]=objArr[i];
          break;
        default:
          isAddChildNodes=true;
          break;
      }
    }
    if(!isAddChildNodes)
      continue;
    if(objArr[i].childNodes==null)
      continue;
    for(var j=0;j<objArr[i].childNodes.length;j++)
    {
      objArr[objArr.length]=objArr[i].childNodes[j];
    }
    //objArr=objArr.concat(objArr[i].childNodes);//不管用
  }
  return editElems;
};


/**
 * 根据iframe的id取iframe中的document对象。
 * @param iFrameID iframe的id.
 * @return document.
 */
PubUtil.getIFrameDoc=function(iFrameID)
{
  if(Constants.isIE)
  {
    try
    {
	  return eval(iFrameID).document;	
    }
    catch (e)
	{
	  return null;
	}
  }
  return document.getElementById(iFrameID).contentDocument;
};


/**
 * 释放内存。
 */
PubUtil.collectGarbage=function()
{
  try
  {
	CollectGarbage();
  }
  catch (e)
  {
	alert(e);
  }
};

/**
 * 取于对象theobj所在横坐标
 * @param theobj目标对象.
 * @return 横坐标值.
 */
PubUtil.getXPos=function(theobj){
	xPos = eval(theobj).offsetLeft;
	tempEl = eval(theobj).offsetParent;
	while (tempEl != null) {
		xPos += tempEl.offsetLeft;
		tempEl = tempEl.offsetParent;
	}
	return xPos;
}

/**
 * 取于对象theobj所在纵坐标
 * @param theobj目标对象.
 * @return 纵坐标值.
 */
PubUtil.getYPos=function(theobj){
	yPos = eval(theobj).offsetTop;
	tempEl = eval(theobj).offsetParent;
	while (tempEl != null) {
		yPos += tempEl.offsetTop;
		tempEl = tempEl.offsetParent;
	}
	return yPos;
}

/**
 * 查出对div对象显示区域内的某种类型的标签(select)
 * @param objLayer 覆盖对象(div层)
 * @param exConTagInBound 
 * @param tagN  标签类型(select)
 */
PubUtil.fToggleTags=function(objLayer,exConTagInBound,tagN){
	var exConStr = '';
	var arrToggleTags = new Array();
	if(exConTagInBound!='') exConStr=exConTagInBound;
	var arrTags = document.getElementsByTagName(tagN);
	for(var i=0;i<arrTags.length;i++)
		if((exConStr!=''?eval('arrTags.item(i).'+exConStr):true) && PubUtil.fTagInBound(objLayer,arrTags.item(i))){
			if(document.arrExCon && document.arrExCon.length){
			   for(var j=0;document.arrExCon[j];j++) if(eval('arrTags.item(i).'+document.arrExCon[j])) arrToggleTags[arrToggleTags.length] = arrTags.item(i);}
			else arrToggleTags[arrToggleTags.length] = arrTags.item(i);
		}
	return arrToggleTags;
}

/**
 * 查出标签是否在对象objLayer覆盖范围内
 * @param objLayer 覆盖对象(div层)
 * @param aTag  被覆盖对象(如select)
 * @return boolean.
 */
PubUtil.fTagInBound=function(objLayer,aTag){
	with (objLayer){
		var l = parseInt(style.left);
		var t = parseInt(style.top);
		var r = l+parseInt(offsetWidth);
		var b = t+parseInt(offsetHeight);
		var ptLT = PubUtil.fGetXY(aTag);
		return !((ptLT.x>r)||(ptLT.x+aTag.offsetWidth<l)||(ptLT.y>b)||(ptLT.y+aTag.offsetHeight<t));
  }
}

/**
 * 查出对div对象显示区域内的某种类型的标签，
 * @param aTag 为标签类型.
 */
PubUtil.fGetXY=function(aTag){
	var oTmp = aTag;
	var pt = new PubUtil.point(0,0);
	do {
		pt.x += oTmp.offsetLeft;
		pt.y += oTmp.offsetTop;
		if(!oTmp.offsetParent) return false; //for NS
		oTmp = oTmp.offsetParent;
	} while(oTmp.tagName!="BODY");
	return pt;
}

/**
 * 查出对div对象显示区域内的某种类型的标签，objLayer为div,tagN 为标签类型
 */
PubUtil.point=function(iX, iY){
	this.x = iX;
	this.y = iY;
}

/*
 * 隐藏div对象所覆盖范围的select标签
 * @param theobj 覆盖对象(div层)
 * @param cordX  覆盖截止范围横坐标
 * @param cordY  覆盖截止范围纵坐标 (300,400)
 */
PubUtil.hiddenTags=function (theobj,cordX,cordY){ 
	if(!theobj.arrToggleTags) theobj.arrToggleTags=new Array();
	if(!theobj.exCon) theobj.exCon = '';
	if(theobj.arrToggleTags){
		theobj.arrToggleTags = PubUtil.fToggleTags(theobj,theobj.exCon,'select');
		for(var i=0;theobj.arrToggleTags[i];i++) {
			theobj.arrToggleTags[i].style.visibility = "hidden";
			theobj.arrToggleTags[i].style.display = "none";
		}
	}
}

/**
 * 显示div对象所覆盖范围的select标签
 * @param theobj 覆盖对象(div层)
 * @param cordX  覆盖截止范围横坐标
 * @param cordY  覆盖截止范围纵坐标 (300,400)
 */
PubUtil.showTags=function(theobj,cordX,cordY)
{
	if(theobj.arrToggleTags){
		for(var i=0;theobj.arrToggleTags[i];i++) 
		{
			theobj.arrToggleTags[i].style.visibility = "visible";
			theobj.arrToggleTags[i].style.display = "";
		}
		theobj.arrToggleTags.length=0;
	}
}

/**
 * 解析url参数。
 * @param url url值。
 * @return 参数集，数组，参数名=参数值。
 */
PubUtil.parseUrlParam=function(url)
{
  var pos=url.indexOf("?");
  if(pos!=-1)
    url=url.substring(pos+1);
  var arr=url.split("&");
  for(var i=0;i<arr.length;i++)
  {
	arr[i]=PubUtil.replaceAll(arr[i]," ","");
  }
  return arr;
}

/**
 * Trim both of leading spaces and trailing spaces.
 * @param val orig String.
 */
PubUtil.trim=function( val )
{
  return PubUtil.rTrim( PubUtil.lTrim( val ) );
};

/**
 * Trim leading spaces.
 * @param val orig String.
 */
PubUtil.lTrim=function( val )
{
  while( '' + val.charAt(0)==' ' || val.charCodeAt(0)==160 )
  {
    val = val.substring(1,val.length);
  }
  return val;
};

/**
 * Trim trailing spaces.
 * @param val orig String.
 */
PubUtil.rTrim=function( val )
{
  while( '' + val.charAt(val.length-1)==' ' || val.charCodeAt(val.length-1)==160)
  {
    val = val.substring(0,val.length-1)
  }
  return val;
};

/**
 * 求给定字符串的字节长度。
 * @param val 给定值。
 * @return 值的字节长度。
 */
PubUtil.byteLen=function(val)
{
  if(val==null)
    return 0;
  var l=0;
  for(var i=0;i<val.length;i++)
  {
    if(val.charCodeAt(i)<19968)
      l++;
    else
      l+=2;
  }
  return l;
};

/**
 * 替换字符串中所有的指定串。
 * @param str 字符串。
 * @param search 要查找的字符串。
 * @param replace 替换的字符串。
 * @return 替换后的字符串。
 */
PubUtil.replaceAll=function(str,search,replace)
{
  var tempStr=str;
  var str=str.replace(search,replace); //默认只匹配第一个。
  while(str!=tempStr)
  {
    tempStr=str;
    str=str.replace(search,replace);
  }
  return str;
};


/**
 * 判断str是否以str2开头。
 * @param str 字符串。
 * @param str2 字符串2。
 * @param isIgnCase 替换的字符串。
 * @return 替换后的字符串。
 */
PubUtil.startsWith=function(str,str2,isIgnCase)
{   
   if(str==null || str2==null)
	 return false;
   if(str.length<str2.length)
	 return false;
   if(isIgnCase!=null && isIgnCase)
   {
	 str=str.toLowerCase();
	 str2=str2.toLowerCase();
   }
   return str.substring(0,str2.length)==str2;
};

/**
 * 取处理事件的对象。
 * @param event 事件体。
 */
PubUtil.eventCurrentTarget=function(event)
{
  // Internet Explorer
  if (event.srcElement)
    return event.srcElement;
  // W3C DOM
  if (event.currentTarget)
    return event.currentTarget;
};


/**
 * 取激发事件的对象。
 * @param event 事件体。
 */
PubUtil.eventTarget=function(event)
{
  // Internet Explorer
  if (event.srcElement)
    return event.srcElement;
  // W3C DOM
  if (event.target)
    return event.target;
};



/**
 * 动态增加事件。
 * @param obj element object。
 * @param eventType The event type for which the user is registering.
 * @param afunction aPubUtil.listener of type EventListener. 
 * @param isCapture useCapture of type boolean.
 */
PubUtil.addEvent=function(obj, eventType, afunction, isCapture) 
{
  // W3C DOM
  if (obj.addEventListener) {
     obj.addEventListener(eventType, afunction, isCapture);
     return true;
  }
  // Internet Explorer
  else if (obj.attachEvent) {
     return obj.attachEvent("on"+eventType, afunction);
  }
  else
    return false;
};

/**
 * 动态增加事件。
 * @param obj element object。
 * @param eventType The event type for which the user is registering.
 * @param afunction aPubUtil.listener of type EventListener. 
 * @param isCapture useCapture of type boolean.
 */
PubUtil.removeEvent=function(obj, eventType, afunction, isCapture)
{
  if (obj.removeEventListener) {
    obj.removeEventListener(eventType, afunction, isCapture);
    return true;
  }
  else if (obj.detachEvent) {
     return obj.detachEvent("on"+eventType, afunction);
  }
  else
    return false;
};



/**
 * 触发指定的事件。
 * @param elem 对象。
 * @eventName 事件名。
 */
PubUtil.fireEvent=function(elem,eventName)
{
  if(!elem || !eventName)
    return;
  try
  {
    if(elem.fireEvent(eventName))//ie is ok,firefox isn't ok
      return;
  }
  catch(e)
  {
    if(eventName.toLowerCase()=="onchange" && elem.onchange)
    {
      elem.onchange();
      return;
    }
    if(eventName.toLowerCase()=="onclick" && elem.onclick)
    {
      elem.onclick();
      return;
    }
    /*var eventBodyObj=elem.getAttribute(eventName);
    if(!eventBodyObj)
      return;
    var eventBody=eventBodyObj.toString();
    if(eventBody=="undefined")
      return;
    var i=eventBody.indexOf("{");
    if(i>-1)
      eventBody=eventBody.substring(i+1);
    i=eventBody.lastIndexOf("}");
    if(i>-1)
      eventBody=eventBody.substring(0,i);
    eventBody=eventBody.replace(/document/ig,"elem.document");
    eval(eventBody);*/ 
  }   
};
function selectToRadio(fieldid,type,state,direct)     
{     
    var html1='';    
    var selobj= document.getElementsByName(fieldid)[0];     
    var opts = selobj.options;     
    if(opts==null) return;     
         
    var selectid = opts[selobj.selectedIndex].value;  
   
    for(var i=0,len=opts.length;i<len;i++)     
    {   
		var tempchecked='';
        var opt=opts[i];      
        if(opt.value==null||opt.value.length<1)     
        {     
            continue;     
        }     
	
        if(opt.value==selectid) 
				tempchecked='checked=true';
        html1=html1+'<input type='+type+'   name=\''+fieldid+'radio\' '+state+' value=\''+opt.value+'\' onclick=javascript:radioClick(this,\''+fieldid+'\');  '+tempchecked+'> '+opt.text+direct+'  ';     
    }    

    document.getElementById(fieldid+'_radiodiv').innerHTML=html1; 
 
}     
function radioClick(obj,fieldid)     
{     
    var bool=true;     
    var selobj= document.getElementById(fieldid);     
    var objs = document.getElementsByName(obj.name); 
    if(obj.checked)     
    {     
        for(var i=0,len=objs.length;i<len;i++)     
        {     
            if(objs[i]==obj)continue;     
            if(objs[i].checked)objs[i].checked=false;     
        }     
    }     
    for(var i=0,len=objs.length;i<len;i++)     
    {     
        if(objs[i].checked==true)     
        {     
            selobj.value=obj.value;     
            bool=false;     
            break;     
        }     
    }     
    if(bool)     
    {     
        selobj.value='';     
    }     
    PubUtil.fireEvent(selobj,'onchange'); 
}  
function selectToRadioDisp(fieldid,type,state,direct)
{
	var html1=''; 
	var selobj= document.getElementById(fieldid); 
	var sql='select ID,OBJNAME,DSPORDER from selectitem where typeid=(select fieldtype from formfield where id=\''+PubUtil.replaceAll(fieldid,'field_','')+'\') and pid is null and nvl(col1,0)=0 order by DSPORDER';     
      DataService.getValues(sql,{                                               
          callback: function(data){   
              var objid='';  
              var objname='';  
              if(data && data.length>0){  
                 for(var i=0,len=data.length;i<len;i++)  
                 {  

                    objid=data[i].ID?data[i].ID:'';   
                    objname=data[i].OBJNAME?data[i].OBJNAME:'';
					var tempchecked='';   
				
					if(selobj.value==objid) 
							tempchecked='checked=true';
					html1=html1+'<input type='+type+'   name=\''+fieldid+'radio\' '+state+' value=\''+objid+'\'   '+tempchecked+'> '+objname+direct+'  ';     
				
                 }                                                 
              } 
			  document.getElementById(fieldid+'_radiodiv').innerHTML=html1; 
          }                 
      });
}
	function openDlgWin(url,popuptitle) {
	  this.dlg1.getComponent('dlgpanel').setSrc(url);
      this.dlg1.show();
	  //this.dlg1.hide();
	}

	//fieldId必填的字段，isChk--true或者false，是否要设置必填。
function setNeedCheck(fieldId,isChk){
	var spanDom=jQuery('#field_'+fieldId+'span');
	var dom=jQuery('#field_'+fieldId);
	var imgHtml='<img src=\'/images/base/checkinput.gif\'>';
	var value=dom.val();
	var btnDom=jQuery("button[name=button_"+fieldId+"]");
	if(isChk){// 必填项
		if(spanDom.length==0){
			spanDom=jQuery("<span>").attr("id","field_"+fieldId+"span").html(value!=''?"":imgHtml)
			dom.parent().append(spanDom);
		}else {
			var innerHTML=spanDom.html();
			if(innerHTML!=null&&innerHTML.trim()==''){
				spanDom.html(imgHtml);
			}
		}
		if(needchecklists.indexOf('field_'+fieldId)<0){
			needchecklists+=(needchecklists.endsWith(',')?'':',');
			needchecklists+='field_'+fieldId;
		}
		var scripts=dom.attr("onchange");
		var checkScript="checkInput('field_"+fieldId+"','field_"+fieldId+"span');";
		if(scripts==null||scripts.indexOf(checkScript)==-1){
			if(scripts==null){
				scripts=checkScript;
			}else{
				scripts+=checkScript;
			}
			dom.attr("onchange",scripts);
		}
		if(btnDom.length>0){
			var clickscripts=btnDom.attr("onclick");
			if(clickscripts!=null&&clickscripts.indexOf("getrefobj(")!=-1){
				clickscripts=clickscripts.replace(",'0')",",'1')");
				btnDom.attr("onclick",clickscripts);
				if(typeof(isIECompatibilityView) == "function" && isIECompatibilityView()){	//IE兼容性视图
					btnDom[0].onclick = function(){
						eval(clickscripts);
					}
				}
			}
		}
	}else{
		if(spanDom.length>0&&value=='') {
			spanDom.html("");
		}
		needchecklists=needchecklists.replace('field_'+fieldId,'');
		needchecklists=needchecklists.replace(',,',',');
		if(needchecklists.endsWith(',')) needchecklists=needchecklists.substring(0,needchecklists.length-1);
		var scripts=dom.attr("onchange");
		if(scripts!=null&&scripts.indexOf("checkInput('field_"+fieldId+"','field_"+fieldId+"span');")!=-1){
			scripts=scripts.replace("checkInput('field_"+fieldId+"','field_"+fieldId+"span');","");
			dom.attr("onchange",scripts);
		}
		if(btnDom.length>0){
			var clickscripts=btnDom.attr("onclick");
			if(clickscripts!=null&&clickscripts.indexOf("getrefobj(")!=-1){
				clickscripts=clickscripts.replace(",'1')",",'0')");
				btnDom.attr("onclick",clickscripts);
				if(typeof(isIECompatibilityView) == "function" && isIECompatibilityView()){	//IE兼容性视图
					btnDom[0].onclick = function(){
						eval(clickscripts);
					}
				}
			}
		}
	}
}
function submitType(typeid,typevalue) 
{ 
    var isagreeobj=document.getElementById(typeid); 
    if(isagreeobj) 
    { 
        isagreeobj.value=typevalue; 
    } 
    onSubmit(0); 
} 
   function showtable(objid1,objid2){  
      $('table[class=detailtable]').each(function(){ 
    	
          if(this==objid1){   
              $(this).show();   
          }else{   
              $(this).hide();   
          }   
      });   
      $('a[class=othercss],a[class=defaultcss]').each(function(){   
          if(this==objid2){   
              $(this).removeClass('othercss').addClass('defaultcss');   
          }else{   
              $(this).removeClass('defaultcss').addClass('othercss');   
          }   
      });   
   }  
   /**
	 * browser框转化为checkbox示例。
	 * @param fieldid  change object。
	 * @param inputtype 显示类型radio或checkbox.
	 * @param disvalue  必须选的选项. 
	 * @param sqlwhere  追加的查询条件，可以增加order by.
	 * @param checkonly 为true时为单选.
	 * @param readonly  为true时为只读.
	 * @param textdirect 显示文本后缀，一般就空格.
	 * @param style   标签其他样式；
	 */
   function browserToCheckbox(fieldid,inputtype,disvalue,sqlwhere,checkonly,readonly,textdirect,style)
   {
	  var html1=''; 
	  var selobj= document.getElementById(fieldid); 
	  var sqlref='select keyfield,viewfield,filter,reftable from refobj where id=(select fieldtype from formfield where id=\''+PubUtil.replaceAll(fieldid,'field_','')+'\')';     
      DataService.getValues(sqlref,{                                               
          callback: function(dataref){ 
			  var keyfield='';  
			  var viewfield='';
			  var filter=''; 
			  if(dataref && dataref.length>0){ 
				  
				keyfield=dataref[0].keyfield ?dataref[0].keyfield :''; 
				viewfield=dataref[0].viewfield ?dataref[0].viewfield :'';
				filter=dataref[0].filter ?dataref[0].filter :'';
				reftable=dataref[0].reftable ?dataref[0].reftable :'';
				var sql='select t.'+keyfield+' as id,t.'+viewfield+' as objname from '+reftable+' t where 1=1';
				if(filter.length>5)
				{
					sql=sql+' and '+filter;
				}
				if(sqlwhere&&sqlwhere.length>2)
				{
					sql=sql+' and '+sqlwhere;
				}
				DataService.getValues(sql,{                                               
				callback: function(data){ 
					  var objid='';  
					  var objname='';  
					  if(data && data.length>0){  
						 for(var i=0,len=data.length;i<len;i++)  
						 {  
							objid=data[i].id?data[i].id:'';   
							objname=data[i].objname?data[i].objname:'';
							var tempchecked=''; 
							if(selobj.value.indexOf(objid)>-1) 
									tempchecked=' checked=true';
							if(disvalue.indexOf(objid)>-1||readonly) 
									tempchecked=tempchecked+' disabled=true';
							html1=html1+'<input type='+inputtype+'   name=\''+fieldid+'radio\' '+style+' value=\''+objid+'\'  onclick=javascript:checkboxClick(this,\''+fieldid+'\','+checkonly+');   '+tempchecked+'> '+objname+textdirect+'  ';     
						 }                                                 
					  } 
					  document.getElementById(fieldid+'_radiodiv').innerHTML=html1; 
					}                 
				 });
			  }    
          }                 
      });
   }
	function checkboxClick(obj,fieldid,checkonly)     
	{     
		var bool=true;     
		var selobj= document.getElementById(fieldid);     
		var objs = document.getElementsByName(obj.name);
		var tempvalue='';
		if(checkonly&&obj.checked)     
		{   tempvalue=obj.value;
			for(var i=0,len=objs.length;i<len;i++)     
			{     
				if(objs[i]==obj)continue;     
				if(objs[i].checked)objs[i].checked=false;     
			}     
		}  
		else{
			for(var i=0,len=objs.length;i<len;i++)     
			{     
				if(objs[i].checked==true)     
				{     
					tempvalue=tempvalue+objs[i].value+',';         
				}     
			}     
   
  
		}
		if(tempvalue.length>0)tempvalue=tempvalue.substring(0,tempvalue.length-1);
		selobj.value=tempvalue;  
		PubUtil.fireEvent(selobj,'onchange'); 
	}  