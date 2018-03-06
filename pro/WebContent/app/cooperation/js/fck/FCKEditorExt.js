// JavaScript Document
var FCKEditorExt=null;
(function(){
	function $(o){return (typeof(o)=='string')?document.getElementById(o):o;}
	FCKEditorExt={
		editorName:[],
		editorObjs:{},//FF下多个编辑器时用FCKEditorApi获取不到前面的对象,只能获取最后一次
		isEn:false,
		initEditor:_initEditor,
		//initUploadImage:_initUploadImage,
		id:'insertObjectContainer',
		updateContent:_updateContent,
		getHtml:_getHtml,
		setHtml:_setHtml,
		insertHtml:_insertHtml,
		getText:_getText,
		selectImageType:_selectImageType,
		Ok:_Ok,
		Cancel:_Cancel,
		show:_show,
		showFlashDialog:_showFlashDialog,
		flashVideoDialog:_flashVideoDialog,
		switchEditMode:_switchEditMode,
		switchTextMode:_switchTextMode,
		removeFile:_removeFile,
		FullScreen:_fullScreen,
		InsertVideo:_InsertVideo,
		_sel:null,/**记录前次选中的对象*/
		checkText:_checkText,
		_loadComplete:_loadComplete,
		toolbarExpand:_toolbarExpand,
		DEFAULT:'web',
		NO_IMAGE:'web',//'webNoImage',
		WEB_IMAGE:'web',
		REPORT:'report',
		stripScripts:_stripScripts,
		filterXss:_filterXss
	};
var isInit=false;
var _formName=null;
//var fckBasePath=contextPath+'/fck/';

function isEmpty(s){return (typeof(s)=='undefined' || s==null || s.toString()=='');}

function _getFormObjByElement(elName){//根据textarea.name或者input.name获得Form对象
	var oForm=null;
	if($(elName)){
		oForm=$(elName).form;
	}else{
		oForm=document.all(elName).form;
	}
	if(typeof(oForm.name)=='undefined') alert('Textarea.form没有<form name="**"...属性');
	return oForm.name;
}

function _initEditor(/*formName,*/name,isEnglish,toolbar){
	isEnglish=false;
    var sBasePath=fckBasePath;
	this.editorName[this.editorName.length]=name;
	var _formName=null;
	//_formName=_getFormObjByElement(name);
	//_overLoadSubmit();//覆盖用户自定义Submit
	var oFCKeditor = new FCKeditor(name);
	
	oFCKeditor.Config["CustomConfigurationsPath"]=sBasePath+"webEditorConf.js";
	oFCKeditor.Config['BasePath']=fckBasePath+'editor/';
	
	if(typeof(isEnglish)=='number')isEnglish=(isEnglish==8)?true:false;
	if(isEnglish){//非中文是读取，否则默认为简体中文
		oFCKeditor.Config["DefaultLanguage"]="en";
		this.isEn=true;
	}
	if(!toolbar)toolbar=this.DEFAULT;
	oFCKeditor.ToolbarSet=toolbar;
	oFCKeditor.ReplaceTextarea();
		//oFCKeditor.Create();
	var isNonImage=true;
	if(toolbar!=this.REPORT){//默认开启除报表外的所有工具栏上传图片
		/*if(toolbar==this.WEB_IMAGE)isNonImage=true;
		else isNonImage=false;*/
		isNonImage=false;
		_initUploadImage(_formName,isNonImage,name);//将编辑器中的图片上传整合到当前Form下,默认带图片，可以上传。
	}
	//this.editorObjs[name]=oFCKeditor;
	isInit=true;//标记初始化完成
}
	function _updateContent(ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		if(isTextMode)return;//文本编辑时不更新textArea的内容
		var oEditor = FCKeditorAPI.GetInstance(ename);
		//var s='<scr'+'ipt id="_initFVideo">initFlashVideo();</scr'+'ipt><span>&nbsp;</span>';
		$(ename).value=oEditor.GetXHTML(true);
	}
	function _getHtml(ename){
		if(!isInit)return "";
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		this.updateContent(ename);
		return 	$(ename).value;
	}
	function _getText(ename){
		if(!isInit)return "";
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		 this.updateContent(ename);
        var s=FCKeditorAPI.GetInstance(ename).GetXHTML(true);
		if(isEmpty(s))return s;
		s=Ext.util.Format.htmlDecode(s);
		s=Ext.util.Format.stripTags(s);
		return s;
	}
	function _setHtml(s,ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		if(isTextMode)	_switchEditMode(ename);//如果是文本编辑状态则切换回来.
		var oEditor = FCKeditorAPI.GetInstance(ename);
		oEditor.SetHTML(s);
	}
	var currentImgType=2;//默认是本地文件类型
	var imgsCount=0;//默认上传的图片数为0
	function _selectImageType(o){
		if(currentImgType==o.value)return;
		$('imgUrlSpan').style.display=(o.value==1)?'':'none';
		$('imgFileSpan').style.display=(o.value==2)?'':'none';
		$('imgFileSpanTemp').style.display=(o.value==2)?'block':'none';
		currentImgType=o.value;
	}
		var en=new Array('',
			'URL can not be empty or illegal Address',
			'Please select a image file,addresses can not be empty!',
			'Are you confirm delete the image(Y/N)?',
			'You must be on WYSIWYG mode!',
			'example',
			'Insert image',
			'web image',
			'local image',
			'image url',
			'select image',
			'Ok',
			'Cancel',
			'Conversion to text edit mode will be lost format settings, to determine switch?',
			'Insert FlashVideo',
			'Incorrect Flash Video URL');
		var ch=new Array('',
			'URL地址不能为空或非法地址',
			'请选择图片文件，地址不能为空!',
			'确认删除该图片吗(Y/N)?',
			'必须切换到可视化编辑状态再操作!',
			'例如',
			'插入图片',
			'网络图片',
			'本地图片',
			'图片地址',
			'选择图片',
			'确定',
			'取消',
			'转换至文本编辑会丢失格式设置,确定切换吗(Y/N)?',
			'插入Flash',
			'不正确的Flash视频格式');
	function _getLabel(i){
		return FCKEditorExt.isEn?en[i]:ch[i];
	}
	function _appendFlashVideo(fUrl){
		var s=new Array('<img class="editorFlashVideo" _flashUrl="',fUrl,'" src="/fck/FlashVideo.jpg" width="96" height="96"/>'
		).join("");
		_insertHtml(s);//添加代码至编辑器
/*		var iFVideo='<scr'+'ipt id="_initFVideo">initFlashVideo();</scr'+'ipt>';		
		var oDoc = FCKeditorAPI.GetInstance(FCKEditorExt.editorName).EditorDocument;

		var jss=oDoc.getElementByTagName("script");
		alert("jss:"+jss.length);
		for(var i=0;i<jss.length;i++){
			alert(jss[i].id);
			if(jss[i].id=="_initFVideo"){jss[i].removeNode(true);break;}
		}
		if(oDoc.getElementById("_initFVideo")){
			oDoc.getElementById("_initFVideo").removeNode(true);
			alert('exist node!');
		}
			
		oDoc.focus();
		oDoc.execCommand("SelectAll");
		var rng=oDoc.selection.createRange();
		rng.collapse(false);
		rng.select();
		FCKeditorAPI.GetInstance(FCKEditorExt.editorName).InsertHtml(iFVideo);
*/		
		//var js=eDoc.createElement("span");
		//js.innerHTML='<script src="../../ab.js"/>';
		//eDoc.body.appendChild(js);
	}
	function _InsertFlashObject(ename){//插入Flash操作执行
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		var fUrl=$('flashUrl').value;
		if($('isFlashVideoUrl').checked){
			_appendFlashVideo(fUrl);
		}else{
			var FCK = FCKeditorAPI.GetInstance(ename);
			var win=$(ename+"___Frame").contentWindow;
			oEmbed=(oEmbed==null)?FCK.EditorDocument.createElement( 'EMBED' ):oEmbed;
			oEmbed.src=fUrl;
			oFakeImage=(oFakeImage==null)?win.FCKDocumentProcessor_CreateFakeImage('FCK__Flash',oEmbed):oFakeImage;
			oFakeImage.setAttribute('_fckflash', 'true',0) ;
			oFakeImage	= FCK.InsertElementAndGetIt(oFakeImage);
			win.FCKFlashProcessor.RefreshView(oFakeImage,oEmbed);
		}
	}
	function _invalidUrl(val){
		return (val=='' || val.toLowerCase()=='http://' || val.substring(0,4).toLowerCase()!='http');
	}
	String.prototype.endsWith=function(suffix){
		var L1 = this.length ;
		var L2 = suffix.length ;
		if ( L2 > L1 )
			return false ;
		return ( L2 == 0 || this.substr( L1 - L2, L2 ) == suffix );
	}
	String.prototype.trim=function(){
		return this.replace(/^\s+|\s+$/g,"");
	}
    var imgMask;
	function _Ok(){
        if(insertType==INSERT_FLASH){//执行插入Flash的操作
			var sUrl=$('flashUrl').value;
			if(_invalidUrl(sUrl)){
				alert(_getLabel(1));
			}else{
				if($('isFlashVideoUrl').checked && !sUrl.toLowerCase().endsWith(".flv")){
					alert(_getLabel(15));
					return;
				}
				_InsertFlashObject();//合法地址保存
				this.Cancel();
			}
			return;	
		};//End if,insert falseh ===========================
		var imgTypeId=(currentImgType==1)?'imgUrl':'imgFile';
		var val=$(imgTypeId).value;
		var isFile=(imgTypeId=='imgFile');
		if(imgTypeId=='imgUrl' && _invalidUrl(val)){
			alert(_getLabel(1));return;
		}
		if(imgTypeId=='imgFile' && val==''){
			alert(_getLabel(2));return;
		}
        if(isFile) {
            var dotpos=Ext.getDom('imgFile').value.lastIndexOf('.') ;
            var filename=Ext.getDom('imgFile').value;
            var errortype=false;
            if(dotpos==-1)
            errortype=true;
            var filetype=Ext.util.Format.lowercase(filename.substring(dotpos+1));
            supportedtype='jpg|jpeg|gif|png';
            if(supportedtype.indexOf(filetype)==-1)
            errortype=true;
            if(errortype) {
               $('attachForm').reset();
               pop('不支持的图片类型');
               return;
            }
            if(!imgMask)
            imgMask=new Ext.LoadMask(Ext.getBody(),{msg:'请稍候...'})
            imgMask.show();
            Ext.Ajax.request({
                url: contextPath + '/ServiceAction/com.eweaver.document.file.FileUploadAction?action=ajax',
                form:'attachForm',
                params:{ 
				   imgFile:filename 
				},
                isUpload:true,
                success: function(res) {
                    imgMask.hide()
                    val = contextPath + '/ServiceAction/com.eweaver.document.file.FileDownload?attachid=' + res.responseText + '&download=1';
                    var sHtml = ['<img alt="docimages_',imgsCount,'" src="',val,'"/>'];
                    var isSucc = _insertHtml(sHtml.join(''),FCKEditorExt._sel.ename);
                    if (!isSucc)return;
                }
            });
            this.Cancel();
        }else{
            var sHtml = ['<img id="',_generateId(),'" alt="',val,'" src="',val,'"/>'];
            var isSucc = _insertHtml(sHtml.join(''));
            if (!isSucc)return;
            this.Cancel();
        }
	}
	function _newInputFile(_v){
		/*imgsCount+=1;
		var o=$('imgFile');
		o.removeAttribute("id");
		var s='<input type="file" id="imgFile" name="docimages_'+imgsCount+'" size="30"/>';
		var newFile=document.createElement(s);//使用Input标记时name属性无法赋值，改用字符串Html代码
		$('imgFileSpan').insertBefore(newFile,o);
		o.style.display='none';*/
	}
	function _removeFile(obj,fileName,ename){
		if(!confirm(_getLabel(3)))return;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		var oDoc = FCKeditorAPI.GetInstance(ename).EditorDocument;
		if(oDoc.getElementById(fileName))
			oDoc.getElementById(fileName).removeNode(true);//删除编辑器内的图片
		
		var files=document.getElementsByName(fileName);		
		if(files.length>0){
			files[0].removeNode(true);
		}
		obj.parentNode.removeNode(true);
	}
	function _generateId(){
		var s="img_";
		return s+Math.ceil((Math.random()*8999+1000));
	}
	
	function _insertHtml(sHtml,ename){//将Html插入到编辑器中去。
		var isSucc=false;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		
		var oEditor = FCKeditorAPI.GetInstance(ename);
		
		// Check the active editing mode.
		if ( oEditor.EditMode == 0){//FCK_EDITMODE_WYSIWYG=0
			//var oFakeImage = oEditor.Selection.GetSelectedElement() ;
            if(document.all){
	            if(FCKEditorExt._sel.selection){
					oEditor.EditorDocument.focus();//先设置焦点，然后重置高亮选块
	                //oEditor.EditorDocument.selection=FCKEditorExt._sel;
					FCKEditorExt._sel.selection.select();
				}else{
	                oEditor.EditorWindow.focus();//先设置焦点，然后重置高亮选块
	                FCKEditorExt._sel.select();
	            }
	        }//end if.
			oEditor.InsertHtml(sHtml);
			FCKEditorExt._sel=null;
			//alert(sHtml);
			isSucc=true;
		}else alert(_getLabel(4));
		return isSucc;
	}
	function _Cancel(){
		$(this.id).style.display='none';
		$(this.id+'_Image').style.display='none';
		$(this.id+'_Flash').style.display='none';
		$('imgUrl').value='http://';
		$('flashUrl').value='http://';
	}
	function _show(sel){
		var cid=this.id;
		
		if($('attachForm')) $('attachForm').reset();
        if($(cid).style.display=='block')return;
		insertType=INSERT_IMAGE;
		$(cid).firstChild.innerHTML=_getLabel(6);
		this._sel=sel;
		$(cid).style.display='block';
		$(cid+'_Image').style.display='block';
		$(cid+'_Flash').style.display='none';
	}
	function _InsertVideo(){
		var sUrl=prompt(_getLabel(5)+"：mms://www.weaver.com.cn/demo.wmv","http://");
		if(sUrl==undefined || sUrl=="");
		else{
			var w=300,h=200;
			var arHtml=new Array(
"<span><object align='middle'  codebase='http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701' ",
" classid='CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95'",
" class='OBJECT'  id='MediaPlayer'  width='",w,"'  height='",h,"'  autostartvalue='-1' >",
<!--img src=http://www.baidu.com/img/logo-yy.gif align=absbottom hspace=2 alt='::URL::' border=0-->
"<param name='showstatusbar'  value='-1' ></param>",
"<param name='filename'  value='",sUrl,"' ></param>",
"<param name='autostart'  value='-1' ></param>",
"<embed src='",sUrl,"'  type='application/x-oleobject' width='",w,"' height='",h,"'></embed>",
"</object></span>");
			_insertHtml(arHtml.join(''));
		}
	}
	var sCssText=new Array('<style>\n','.editorImgWin{position:absolute; height: 168px;  width: 399px; background-color: #FFFFFF;font-size:9pt; border: 1px Solid #666;display:none;}\n',
	'.editorImgWin input label{display:inline;}\n',
	'</style>').join('');
	document.writeln(sCssText);
	function _initUploadImage(formName,isNonFile,ename){
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		if(isNonFile)currentImgType=1;
		var oFrm=$(formName);
		//oFrm=(oFrm==null)?document.getElementsByName(formName)[0]:oFrm;
		//if(!oFrm){alert('No formName is '+formName);return;}
		var pos=_getPosition($(ename));//+"___Frame"

		var s=new Array(
		'<div id="insertObjectContainer" class="editorImgWin" style="left:',pos.x+200,'px; top:',pos.y+40,'px;">',
	'<div style="font-weight:bold;height:17px;font-size:10pt;padding-top:3px;padding-left:30px;background-color:#CCC;border-bottom:1px solid #666">',_getLabel(6),'</div><br />',
	'<span id="insertObjectContainer_Image">',
	'<div style="padding-left:10px;padding-bottom:10px;',isNonFile?'display:none;':'','">',
	'<label for="imgTypeUrl"><input style="width:20px;" type="radio" name="imgType" onclick="FCKEditorExt.selectImageType(this)" id="imgTypeUrl" value="1" ',isNonFile?' checked="checked" ':'',' />',_getLabel(7),'</label>',
	isNonFile?'':'<label for="imgTypeFile"><input style="width:20px;" onclick="FCKEditorExt.selectImageType(this)" type="radio" name="imgType" checked="checked" id="imgTypeFile" value="2"/>'+_getLabel(8)+'</label>',
	'</div>',
	'<div style="padding-left:10px;">',
		'<span id="imgUrlSpan" style="display:',isNonFile?'':'none','">'+_getLabel(9)+'：<input name="imgUrl" value="http://" id="imgUrl" style="width:280px;" size="40"/></span>',
		isNonFile?'':'<span id="imgFileSpan">'+_getLabel(10)+'：<input style="width:280px;" type="file" id="imgFile" name="docimages_0" size="30">',
		isNonFile?'':'<input type="hidden" name="docimages_num" id="docimages_num" value="0"/>',
		isNonFile?'':'</span>',
		isNonFile?'':'<span id="imgFileSpanTemp"></span>',
	'</div>',
	'</span>',
	'<span style="display:none;padding-left:10px;" id="insertObjectContainer_Flash">',
	'<label for="isFlashVideoUrl"><input style="width:20px;" type="checkbox" id="isFlashVideoUrl">是否Flash视频(*.flv)</label><br>',
	'Flash地址:<input id="flashUrl" style="width:280px;" size="40">',
	'</span>',
	'<br/><div align="center"><button accesskey="O" onclick="FCKEditorExt.Ok();" >',_getLabel(11),'(<u>O</u>)</button>&nbsp;&nbsp;&nbsp;',
	'<button type="button" onclick="FCKEditorExt.Cancel();" accesskey="C">',_getLabel(12),'(<u>C</u>)</button>',
	'</div></div>');
		var span=document.createElement("span");
        if(!Ext.get('attachForm')){
            Ext.DomHelper.append(Ext.getBody(),{tag:'form',id:'attachForm'});
            Ext.get('attachForm').appendChild(span);
            span.innerHTML=s.join('');
        }		
	}
	
	function _switchEditMode(ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		var oEditor = FCKeditorAPI.GetInstance(ename) ;
		if(isTextMode){
			$(ename).style.display='none';
			$(ename+"___Frame").style.display='block';
			oEditor.SetHTML($(ename).value);
			isTextMode=false;
			return;//从文本编辑模式切换至可视化状态
		}
		oEditor.SwitchEditMode();
	}
	var isTextMode=false;
	function _switchTextMode(a,ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		if(isTextMode)return;
		var isSwitched=false;
		var editmode=function(){
		    var oEditor = FCKeditorAPI.GetInstance(ename);
			var txt=oEditor.GetXHTML(true);
			var div=document.createElement("div");
			div.innerHTML=txt;
            if(typeof(div.innerText)!='undefined')    //firefox 出现undefined
			$(ename).value=div.innerText;
			$(ename).style.display='block';
			$(ename+"___Frame").style.display='none';
			isTextMode=true;
			isSwitched=true;       
		}
				
         if(typeof(a)=="undefined"){        
		     if(confirm(_getLabel(13)))  editmode(ename);
		              
		}else{
		     editmode(ename);
		}
		return isSwitched;
	}
	function _fullScreen(ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		var oEditor = FCKeditorAPI.GetInstance(ename);
		oEditor.Commands.GetCommand("FitWindow").Execute();
	}
	function _getPosition(o){
		var p1= o.offsetLeft,p2= o.offsetTop;
		do {
			o = o.offsetParent;
			if(isEmpty(o))break;
			p1 += o.offsetLeft;
			p2 += o.offsetTop;
		}while( o.tagName.toLowerCase()!="body");
        if(p1<0) p1=0;
        if(p2<0) p2=0;
		return {"x":p1,"y":p2};
	}
	var INSERT_IMAGE=1;
	var INSERT_FLASH=2;
	var insertType=1;
	var oFakeImage=null;
	var oEmbed=null
	function _flashVideoDialog(){
		if(typeof(flvBrowserUrl)=="undefined")return;
		if(flvBrowserUrl!=null && flvBrowserUrl!=""){//跳出视频列表文件框
			var sArgs="dialogWidth:600px,dialogHeight:450px";
			var ret=window.showModalDialog(flvBrowserUrl,"",sArgs);
			if(ret){
				_appendFlashVideo(ret);
			}
		}
	}
	function _showFlashDialog(ooFakeImage,ooEmbed){
		if($(this.id).style.display=='block')return;
		//初始化
		oFakeImage=ooFakeImage;
		var oEmbed=ooEmbed;
		var fUrl=(oEmbed==null)?"http://":oEmbed.src;
		$('flashUrl').value=fUrl;
		/////////////////////////////////////////
		insertType=INSERT_FLASH;
		$(this.id).firstChild.innerHTML=_getLabel(14);
		$('isFlashVideoUrl').checked=false;
		$(this.id).style.display='block';
		$(this.id+'_Image').style.display='none';
		$(this.id+'_Flash').style.display='block';
	
	}
	
	var _checkId="spadsdnId";
	var _txtChecked={};
	function _checkText(arg0,ename){
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		if(arg0=="INIT"){
			if(Ext.isEmpty(Ext.getDom(_checkId+ename))){
				//_checkId="spadsdnId";
				var t=$(ename);
				t=(t==null)?document.all[ename]:t;
				Ext.DomHelper.insertAfter(t,{tag:'span',id:_checkId+ename,html:'<img src="'+contextPath+'/images/base/checkinput.gif" align="absMiddle">'});
			}//当已经存在标记时，则直接读取。
			_doCheck(ename);
			return;	
		}else{
			//if(typeof(arg0)=="string")_checkId=arg0;//如果已经存在红叹号标记，则记录
			//else if(typeof(arg0)=="object")_checkId=arg0.id;
			_txtChecked[ename]=true;
		}
	}

	function _doCheck(ename){
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		var oFrm=$(ename+"___Frame");
		var sImg='<img src="'+contextPath+'/images/base/checkinput.gif" align="absMiddle">';
		var spanId=_checkId+ename;
		function setCheck(){
			var html=FCKEditorExt.getText(ename);
			if(Ext.isEmpty(html)) $(spanId).innerHTML=sImg;
			else $(spanId).innerHTML="";
		}
		oFrm.attachEvent("onfocus",setCheck);
		oFrm.attachEvent("onblur",setCheck);
		setCheck();
	}
	
	var isLoaded=false;//标记编辑器是否装载完成
	function _loadComplete(o){
		isLoaded=true;
		if(typeof(_txtChecked[o.Name])=='boolean' && _txtChecked[o.Name])
			_checkText("INIT",o.Name);//初始化感叹号
		
		//_toolbarExpand(_isExpand,o.Name);
		if(_isExpand) o.ToolbarSet.Expand();
		else o.ToolbarSet.Collapse() ;
		
		if(typeof(FCKEditorExt['complete'])=='function')FCKEditorExt['complete'](o);
		/********************************************/
	}

	var _isExpand=true;
	function _toolbarExpand(isExpand,ename){
		if(isEmpty(ename)) ename=FCKEditorExt.editorName[FCKEditorExt.editorName.length-1];
		if(!isLoaded){//未初始化完成
			_isExpand=(isExpand==undefined)?true:isExpand;
			return;
		}
		var oEditor = FCKeditorAPI.GetInstance(ename);
		if(isExpand)
			oEditor.ToolbarSet.Expand();
		else
			oEditor.ToolbarSet.Collapse() ;
	}
	
	function _stripScripts(s){
		var script=new RegExp('(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)', 'img');
		//var object=new RegExp('(?:<object.*?>)((\n|\r|.)*?)(?:<\/object>)', 'img');
		var iframe=new RegExp('(?:<iframe.*?>)((\n|\r|.)*?)(?:<\/iframe>)', 'img');
		return s.replace(script,'').replace(iframe,'');//.replace(object,'');
	}
	
	function _filterXss(s){
		var errReg1=/(<\w+ [^<>]*)onload='[^']*' ?([^<>]*\/?>)/img;
		var errReg2=/(<\w+ [^<>]*)onload="[^"]*" ?([^<>]*\/?>)/img;
		var loadReg1=/(<\w+ [^<>]*)onerror='[^']*' ?([^<>]*\/?>)/img;
		var loadReg2=/(<\w+ [^<>]*)onerror="[^"]*" ?([^<>]*\/?>)/img;
		var erpReg1=/(<\w+ [^<>]*)style='.+expression\(.*\)[^']*'([^<>]*\/?>)/img;
		var erpReg2=/(<\w+ [^<>]*)style=".+expression\(.*\)[^"]*"([^<>]*\/?>)/img;
		s=s.replace(errReg1,"$1$2").replace(loadReg1,"$1$2").replace(erpReg1,"$1$2");
		s=s.replace(errReg2,"$1$2").replace(loadReg2,"$1$2").replace(erpReg2,"$1$2");
		s=_stripScripts(s);
		return s;
	}
	
}());

function FCKeditor_OnComplete(editorInstance)
{
	FCKEditorExt._loadComplete(editorInstance);
}
