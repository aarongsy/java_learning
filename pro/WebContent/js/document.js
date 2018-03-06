/*
 * 文档模块js代码
 * www.weaver.com.cn
 * @author Ricky
 */
function f$(id){
	return document.getElementById(id);
}
function onDraft(){
	f$("docstatus").value="0";
    toCheck();;
}
function onSubmit(){
	f$("docstatus").value="1";
        toCheck();
}
function onSubmitNew(){
	if(document.all('subject')==null){
        checkfields="title,categoryid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
    }else{
        checkfields="subject,categoryid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
    }
	checkmessage="必输项不能为空";
	if(checkForm(EweaverForm,checkfields,checkmessage)){
	  	document.all("targetUrl").value="<%=targetUrl2%>";
	  	f$("docstatus").value="1";
	  	if(SaveDocument()){
			document.EweaverForm.submit();
		}
	}
}
function toCheck(){
	if(f$("fileuploadCheck").value=="1"){
		alert("附件尚未上传完成");
		return;
	}
	checkfields="subject,categoryid,author"+needcheckforms;//填写必须输入的input name，逗号分隔
	checkmessage="必输项不能为空";
	if(checkForm(EweaverForm,checkfields,checkmessage)){
		if(SaveDocument()){
			document.EweaverForm.submit();
		}
	}
}
function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	if(inputname.substring(3,(inputname.length-6))){
        if(f$(inputname.substring(3,(inputname.length-6))))
        	f$(inputname.substring(3,(inputname.length-6))).value="";
    	}
	var id;
	try{
		id=openDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid);
	}catch(e){}
	if (id!=null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
		}else{
			document.all(inputname).value = '';
			if (isneed=='0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
			}
        }
     }
}
// 添加于 2011-08-10 实现文档编辑时关联选择添加文档到文档中
//refid: 选择brow框的id
//docnames:已经添加的目录 如果没有目录添加则 等于 0
//
function docRefobj(refid,docbaseid){
    var idsin = docbaseid; // 取到文档id
	var result = openDialog("/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id="+refid+"&idsin="+idsin);
	if(!result){return;}
	var _id = result[0];
	var _name = result[1];
	alert(_id+"===id");
	alert(_name+"===name");
	if(_id==""&&_name==""){
		return;		
	}else{
	    var htmlStr = [_name];
	    FCKEditorExt.insertDOC(htmlStr);
	}
}

function getBrowser(viewurl, inputname, inputspan, isneed) {
	var id;
	try {
		id = openDialog('/base/popupmain.jsp?url=' + viewurl);
	} catch (e) {}
	if (id != null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
		} else {
			document.all(inputname).value = '';
			if (isneed == '0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
			}
		}
	}
}
function SQL(param){
	param = encode(param);
	if(strSQLs.indexOf(param)!=-1){
		var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
		return retval;
	}else{
        var _url= "/ServiceAction/com.eweaver.base.DataAction?sql="+param;
		var XMLDoc=new ActiveXObject("MSXML");
		XMLDoc.url=_url;
		var XMLRoot=XMLDoc.root;
		var retval = getValidStr(XMLRoot.text);
		strSQLs.push(param);
		strValues.push(retval);
		return retval;
	}
}
function checkdirect(obj){
    inputid=obj.id;
    spanid=obj.name;
    temp=0;
}
/**
 * 改变文档类型
 * @param docType 2-无正文，3-HTML，4：Word，5-Excel，6-PDF，7-PPT，8-Viso，9-WPS文档，10-WPS表格
 */
function onChangeDocType(docType){
    var htmlDIV = f$("htmlDIV");
    var officeDIV = f$("officeDIV");
    var pdfDIV = f$("pdfDIV");
    hideDIV([htmlDIV,officeDIV,pdfDIV]);
    f$("officeType").value=docType;
    switch (docType*1) {
        case 2://无正文
            break;
        case 3://HTML
        	htmlDIV.style.display = '';
            break;
        case 6://pdf
        	pdfDIV.style.display = '';
            break;
        default://office
        	officeDIV.style.display = '';
            initObject(getFileType(docType));
            break;
    }
}
function getFileType(docType){
	 switch (docType*1) {
       case 2://无正文
           return "txt";
       case 3://HTML
           return "html";
       case 4://word
           return ".doc";
       case 5://excel
			return ".xls";
       case 6://pdf
       	return ".pdf";
       case 7://powerpoit
           return ".ppt";
       case 8://visio
           return ".vsd";
       case 9:
       	return ".wps";
       case 10:
       	return ".et";
       default:
           break;
   }
}
function isOffice(fileType){
    return fileType == 4 || fileType == 5 || fileType == 7 || fileType == 8|| fileType == 9|| fileType == 10;
}
function hideDIV(divs){
	for(var i=0;i<divs.length;i++){
		var div = divs[i];
		if(div){
			div.style.display="none";
		}
	}
}
/*iWebOffice控件相关操作*/
function initObject(fileType){
	document.WebOffice.FileType = fileType;
	document.WebOffice.WebSetMsgByName("OFFICEID","");
	if(fileType == ".doc" && f$("wordTemplateAttachId").value != ''){
		document.WebOffice.WebSetMsgByName("OFFICEID",f$("wordTemplateAttachId").value);
	}
	if(fileType == ".xls" && f$("excelTemplateAttachId").value != ''){
		document.WebOffice.WebSetMsgByName("OFFICEID",f$("excelTemplateAttachId").value);
	}
    document.WebOffice.WebOpen();
}

//作用：保存服务文档
function SaveDocument(){
	var fileType = f$("officeType").value;
	if(!isOffice(fileType*1)){
		return true;
	}
	document.WebOffice.FileName =encode(f$('subject').value + document.WebOffice.FileType);
	if(f$("isNewVersion")&&f$("isNewVersion").value=="1"){
		document.WebOffice.WebSetMsgByName("OFFICEID","");
	}else{
		document.WebOffice.WebSetMsgByName("OFFICEID",f$("attachid").value);
	}
	
	document.WebOffice.MaxFileSize=400*1024;;
	if (!document.WebOffice.WebSave()){
		alert(document.WebOffice.Status);
		return false;
	}else{
		f$("attachid").value = document.WebOffice.WebGetMsgByName("OFFICEID");
		return true;
	}
}


//作用：保存office正文到本地
function savelocalFile(){
	try{
		document.WebOffice.WebSaveLocalFile();
	}catch(e){}
}
//作用：打开本地office文件
function openLocalFile(){
	try{
		document.WebOffice.WebOpenLocal();
		//StatusMsg(document.WebOffice.Status);
	}catch(e){alert(e.description);}
}

/*检测是否安装pdf控件*/
function detectedPDF(){
	if(!isAcrobatPluginInstall()){
		f$("IfNoAcrobat").style.display="";
		f$("pdf").style.display="none";
	}else{
		 pdf.setShowToolbar(0);
	}
}
function isAcrobatPluginInstall(){
	if(navigator.plugins && navigator.plugins.length){
		for (x=0; x<navigator.plugins.length;x++ ){
			if(navigator.plugins[x].name== 'Adobe Acrobat'){
				return true;
			}
		}
	}else if(window.ActiveXObject){
		for (x=2; x<10; x++ ){
			try{
				oAcro=eval("new ActiveXObject('PDF.PdfCtrl."+ x +"')");
				if (oAcro){
					return true;
				 }
			}catch(e){}
		}
		try{
			oAcro4=new ActiveXObject('PDF.PdfCtrl.1');
			if (oAcro4){
				return true;
			}
		}catch(e){}
		try{
			oAcro7=new ActiveXObject('AcroPDF.PDF.1');
			if (oAcro7){
				return true;
			}
		}catch(e){}
	}
	return false;
}
/*附件上传操作*/
function addAttach(attachid, attachname,type){
    var oDiv = f$("fileUploadDIV");
    var oPdf = f$("pdfUploadDIV");
    var href = "href='javascript:deleteaddattach(\"" + attachid + "\")'";
    var span = document.createElement("SPAN");
    span.style.margin="0 10 0 5";
    span.id = attachid;
    if("pdf"==type){
    	span.innerHTML = '<img src="/images/silk/accessory.gif" border="0">' + attachname + '<a style="margin:0 5 0 5;" title="删除" href="#" onclick = javascript:deleteaddattach("' + attachid + '","pdf");>删除</a>';
    	oPdf.appendChild(span);
    	f$("attachid").value = attachid;
    	f$("pdfUploadDIV").style.display = "";
    	f$("pdfDIV").style.display = "none";
    }else{
    	span.innerHTML = '<img src="/images/silk/accessory.gif" border="0">' + attachname + '<a style="margin:0 5 0 5;" title="删除" href="#" onclick = javascript:deleteaddattach("' + attachid + '");>删除</a>';
    	f$("addattachid").value += attachid + ",";
    	oDiv.appendChild(span);
    }
}
function deleteaddattach(attachid,modify,type){
    if (confirm("确定删除吗？")) {
        var oSpan = f$(attachid);
        oSpan.removeNode(true);
        if("pdf"==type){
        	f$("attachid").value = "";
        }else{
	        var delattachid = f$("delattachid").value;
	        if (delattachid.length == 0) {
	            f$("delattachid").value += attachid;
	        }
	        else {
	            f$("delattachid").value += "," + attachid;
	        }
	        var addattachidEle = jQuery("input[type='hidden'][name='addattachid']")[0];
	        if(addattachidEle){
	        	var addattachid = addattachidEle.value;
	        	addattachidEle.value = addattachid.replace(attachid + ",", "");
	        }
	        //var addattachid = f$("addattachid").value;
	        //f$("addattachid").value = addattachid.replace(attachid + ",", "");
        }
    }
}
function disabledButton(){
	f$("fileuploadCheck").value="1";
}
function enableButton(){
	f$("fileuploadCheck").value="0";
}
function newVersion(){
	if(confirm('要保存一个新版本吗？')){
		document.EweaverForm.isNewVersion.value="1";
		toCheck();
	}
}
function onDelete(id){
	if( confirm('确定要删除吗？')){
		document.EweaverForm.action="/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=delete";
		document.EweaverForm.submit();
	}
}
function changeScreen(v){
	if(v){
		f$("contentDiv").style.display="none";
		f$("formcomtentDIV").style.display="none";
		//f$("doctypeTable").style.display="none";
		f$("H").style.display="none";
		f$("R").style.display="";
	}else{
		f$("contentDiv").style.display="";
		f$("formcomtentDIV").style.display="";
		//f$("doctypeTable").style.display="";
		f$("H").style.display="";
		f$("R").style.display="none";
	}
}

function changeUploadIframeUrl(v){
	var uploadIframe = document.getElementById("uploadIframe");
	if(uploadIframe){
		var pNameFlag = "formActionObjid=";
		var uploadIframeSrc = uploadIframe.src;
		var newUploadIframeSrc = replaceParamValue(uploadIframeSrc, pNameFlag, v);
		if(newUploadIframeSrc != uploadIframeSrc){
			uploadIframe.src = newUploadIframeSrc;
		}
	}
}

function changeWebOfficeUrl(v){
	if(document.WebOffice){
		var pNameFlag = "docCategoryId=";
		var officeWebUrl = document.WebOffice.WebUrl;
		var newOfficeWebUrl = replaceParamValue(officeWebUrl, pNameFlag, v);
		if(newOfficeWebUrl != officeWebUrl){
			document.WebOffice.WebUrl = newOfficeWebUrl;
		}
	}
}

function replaceParamValue(url, pNameFlag, pValue){
	var tempUrl;
	var pStartIndex = url.lastIndexOf(pNameFlag);
	if(pStartIndex != -1){
		pStartIndex = pStartIndex + pNameFlag.length;
		var pEndIndex;
		if(pStartIndex + 32 <= url.length){
			pEndIndex = pStartIndex + 32;
		}else{
			pEndIndex = url.length;
		}
		var oldCategoryId = url.substring(pStartIndex, pEndIndex);
		if(oldCategoryId != pValue){
			tempUrl = url.substring(0, pStartIndex) + pValue + url.substring(pEndIndex);
		}else{
			tempUrl = url;
		}
	}else{
		tempUrl = url + (url.indexOf("?") == -1 ? "?" : "&") + pNameFlag + pValue;
	}
	return tempUrl;
}