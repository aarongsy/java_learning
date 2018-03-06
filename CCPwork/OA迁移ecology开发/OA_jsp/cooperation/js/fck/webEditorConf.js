// JavaScript Document,weaverDefaultEditor.js
//FCKConfig.Plugins.Add( 'autogrow' );
FCKConfig.Plugins.Add( 'reportfield');
FCKConfig.Plugins.Add( 'placeholder', 'de,en,es,fr,it,pl');
FCKConfig.Plugins.Add( 'tablecommands', null);
FCKConfig.Plugins.Add( 'simplecommands', null);

FCKConfig.Plugins.Add( 'imgmap', 'zh-cn,en') ;
// FCKConfig.ProtectedSource.Add( /<%[\s\S]*?%>/g ) ;	// ASP style server side code <%...%>
// FCKConfig.ProtectedSource.Add( /<\?[\s\S]*?\?>/g ) ;	// PHP style server side code
// FCKConfig.ProtectedSource.Add( /(<asp:[^\>]+>[\s|\S]*?<\/asp:[^\>]+>)|(<asp:[^\>]+\/>)/gi ) ;	// ASP.Net style tags <asp:control>
FCKConfig.ImageUpload=false;
FCKConfig.ImageBrowser=false;
FCKConfig.LinkBrowser=false;
FCKConfig.FontNames= '宋体;黑体;微软雅黑;楷体;仿宋_GB2312;Arial;Corbel;Comic Sans MS;Courier New;Tahoma;Times New Roman;Verdana' ;
FCKConfig.ToolbarSets["web"] = [
	['Bold','Italic','Underline','StrikeThrough'],
	['Cut','Copy','Paste','Undo','Redo','-','PasteText','PasteWord','SelectAll','RemoveFormat'],
    ['imgmapPopup','Table'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	//['Link','Unlink'],
	['FontFormat','FontName','FontSize'],
	//'/',
	['CustomImage','CustomFlash',/*'Video',*/'Smiley','SpecialChar','PageBreak'],
	['TextColor','BGColor','FitWindow','Source']
];

FCKConfig.ToolbarSets["report"] = [
	['FontFormat','FontName','FontSize'],
	['Bold','Italic','Underline','StrikeThrough'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	'/',
	['OpenField','Table','-','TableInsertRowAfter','TableDeleteRows','TableInsertColumnAfter','TableDeleteColumns','TableInsertCellAfter','TableDeleteCells','TableMergeCells','TableHorizontalSplitCell','TableCellProp'],
	['Cut','Copy','Paste','Undo','Redo'],
	['Link','Unlink'],
	['TextColor','BGColor','FitWindow','Source','About']
];

if(typeof(window.parent.flvBrowserUrl)=="string" && window.parent.flvBrowserUrl!=""){//检测是否加载视频按钮
	var btns=FCKConfig.ToolbarSets["web"][5];
	FCKConfig.ToolbarSets["web"][5]=new Array(btns[0],btns[1],'FlashVideo',btns[2],btns[3],btns[4]);
}

FCKConfig.ToolbarSets["webNoImage"] = [
	['Bold','Italic','Underline','StrikeThrough'],
	['Cut','Copy','Paste','Undo','Redo','-','PasteText','PasteWord','SelectAll','RemoveFormat'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink'],
	[/*'CustomImage','CustomFlash','Video',*/'Smiley','SpecialChar','PageBreak'],
	'/',
	['FontFormat','FontName','FontSize'],
	['TextColor','BGColor','FitWindow','Source']
];


//FCKConfig.ToolbarSets["Default"]=FCKConfig.ToolbarSets["webNoImage"];

FCKConfig.ToolbarSets["Basic"] = [
	['Bold','Italic','-','OrderedList','UnorderedList','-','Link','Unlink','-','About']
] ;

FCKConfig.SmileyPath	= FCKConfig.BasePath + 'images/smiley/qq2007/' ;
FCKConfig.SmileyImages	= ['0.gif','1.gif','2.gif','3.gif','4.gif','5.gif','6.gif','7.gif','8.gif','9.gif','10.gif','11.gif','12.gif','13.gif','14.gif','15.gif','16.gif','17.gif','18.gif','19.gif','20.gif','21.gif','22.gif','23.gif','24.gif','25.gif','26.gif','27.gif','28.gif','29.gif','30.gif','31.gif','32.gif','33.gif','34.gif','35.gif','36.gif','37.gif','38.gif','39.gif','40.gif','41.gif','42.gif','43.gif','44.gif','45.gif','46.gif','47.gif','48.gif','49.gif','50.gif','51.gif','52.gif','53.gif','54.gif','55.gif','56.gif','57.gif','58.gif','59.gif','60.gif','61.gif','62.gif','63.gif','64.gif','65.gif','66.gif','67.gif','68.gif','69.gif','70.gif','71.gif','72.gif','73.gif','74.gif','75.gif','76.gif','77.gif','78.gif','79.gif','80.gif','81.gif','82.gif','83.gif','84.gif','85.gif','86.gif','87.gif','88.gif','89.gif'] ;
FCKConfig.SmileyColumns = 9 ;
FCKConfig.SmileyWindowWidth		= 480 ;
FCKConfig.SmileyWindowHeight	= 435 ;

function LoadUserExtension(){//在FCKEdiotr.html中加载

/**** @20070821 add by yeriwei! ****/
function FCKCustomImageCommand(){//自定义插入图片命令

	this.name='CustomImage';
	this.Execute=function(){
        if(document.all)
		sel=FCK.EditorDocument.selection.createRange();
        else
        sel=FCK.EditorWindow.getSelection();
		window.parent.FCKEditorExt.show({selection:sel,ename:FCK.Name});
	};
	this.GetState=function(){return 0;};
};
function FCKVideoCommand(){//插入视频命令
	this.name='Video';
	this.Execute=function(){/*alert('CommandName:'+this.name);*/};
	this.GetState=function(){return 0;};
}
function FCKFlashVideoCommand(){//插入服务器浏览Flash视频命令
	this.name="FlashVideo";
	this.Execute=function(){
		window.parent.FCKEditorExt.flashVideoDialog();
	};
	this.GetState=function(){return 0;};
}
/*******************************************/
function FCKCustomFlashCommand(){//插入自定义Flash框命令

	this.name='CustomFlash';
	this.Execute=function(){
		var oFakeImage = FCK.Selection.GetSelectedElement() ;
		var oEmbed=null;
		if ( oFakeImage ){
			if ( oFakeImage.tagName == 'IMG' && oFakeImage.getAttribute('_fckflash') )
				oEmbed = FCK.GetRealElement( oFakeImage ) ;
			else
				oFakeImage = null ;
		}
		window.parent.FCKEditorExt.showFlashDialog(oFakeImage,oEmbed);
		/*
		var oFakeImage = FCK.Selection.GetSelectedElement() ;
		var oEmbed=null;
		if ( oFakeImage ){
			if ( oFakeImage.tagName == 'IMG' && oFakeImage.getAttribute('_fckflash') )
				oEmbed = FCK.GetRealElement( oFakeImage ) ;
			else
				oFakeImage = null ;
		}
		var fUrl=(oEmbed==null)?"":oEmbed.src;
		fUrl=prompt("请输入Flash地址，如：http://www.flash8.com/demo.swf",fUrl);
		if(fUrl==undefined || fUrl=="")return;
		else{
			oEmbed=(oEmbed==null)?FCK.EditorDocument.createElement( 'EMBED' ):oEmbed;
			oEmbed.src=fUrl;
			oFakeImage=(oFakeImage==null)?FCKDocumentProcessor_CreateFakeImage('FCK__Flash',oEmbed):oFakeImage;
			oFakeImage.setAttribute('_fckflash', 'true',0) ;
			oFakeImage	= FCK.InsertElementAndGetIt(oFakeImage);
			FCKFlashProcessor.RefreshView(oFakeImage,oEmbed);
		}
		*/
	};
	this.GetState=function(){return 0;};
}

FCKCommands.RegisterCommand('CustomImage',new FCKCustomImageCommand());//注册命令
FCKCommands.RegisterCommand('Video',new FCKVideoCommand());
FCKCommands.RegisterCommand('CustomFlash',new FCKCustomFlashCommand());
FCKCommands.RegisterCommand('FlashVideo',new FCKFlashVideoCommand());


FCKToolbarItems.RegisterItem('CustomImage',new FCKToolbarButton( 'CustomImage',	FCKLang.CustomImage,
																null,null, false, true, 37 ));
FCKToolbarItems.RegisterItem('Video',new FCKToolbarButton( 'Video',	FCKLang.Video,
														  null,null, false, true, 67 ));
FCKToolbarItems.RegisterItem('CustomFlash',new FCKToolbarButton( 'CustomFlash',	FCKLang.CustomFlash,
																null,null, false, true, 38 ));
FCKToolbarItems.RegisterItem('FlashVideo',new FCKToolbarButton( 'FlashVideo',	FCKLang.FlashVideo,
																null,null, false, true, 68 ));
}
