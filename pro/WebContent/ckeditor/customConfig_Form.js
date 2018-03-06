CKEDITOR.editorConfig = function( config )
{
	config.resize_enabled = false;
	config.font_names = "宋体;黑体;微软雅黑;楷体;仿宋_GB2312;Arial;Corbel;Comic Sans MS;Courier New;Tahoma;Times New Roman;Verdana";
	config.fontSize_sizes = "8pt;9pt;10pt;11pt;12pt;14pt;16pt;18pt;20pt;24pt;28pt;32pt;36pt;48pt;60pt";
	config.defaultLanguage = 'zh-cn';
	config.skin = 'v2';
	config.height = '300px';
	config.toolbarStartupExpanded = false;
	config.removePlugins = 'elementspath';	//移除ckeditor元素路径的插件(和resize_enabled共用可以隐藏状态栏) 
	
	config.font_style =
    {
        element		: 'font',
        styles		: { 'font-family' : '#(family)' },
        overrides	: [ { element : 'font', attributes : { 'face' : null } } ]
    };
	config.fontSize_style =
    {
        element		: 'font',
        styles		: { 'font-size' : '#(size)' },
        overrides	: [ { element : 'font', attributes : { 'size' : null } } ]
    };
	CKEDITOR.config.colorButton_foreStyle =
	{
		element		: 'font',
		styles		: { 'color' : '#(color)' },
		overrides	: [ { element : 'font', attributes : { 'color' : null } } ]
	};
	
	config.toolbar = "eweaver"; 
	
	//自定义的工具栏
	config.toolbar_eweaver = [
		['Cut','Copy','Paste','Undo','Redo','-','PasteText','PasteFromWord','SelectAll','RemoveFormat'],
	    ['Table'],
		['OrderedList','UnorderedList','-','Outdent','Indent'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		['Link','Unlink'],
		['CustomImage','CustomFlash','Smiley','SpecialChar','PageBreak'],
		'/',
		['Bold','Italic','Underline','Strike'],['Format'],['Font'],['FontSize'],
		['TextColor','BGColor','Maximize','Source','About']
	];
	
	var isEnabledFlashVideo = (typeof(flvBrowserUrl) == "string" && flvBrowserUrl != ""); //检测是否加载视频按钮
 	if(isEnabledFlashVideo){
		config.toolbar_eweaver[5].splice(2,0,"CustomFlashVideo");
	}
 	
 	var isEnabledDocInsert = (typeof(insertDOC) == "string" && insertDOC == "true");	////检测是否在编辑文档时添加 插入文档按钮
 	if(isEnabledDocInsert){
 		config.toolbar_eweaver[11].splice(4,0,"CustomDocInsert");
 	}
 	
 	config.extraPlugins = 'CustomImage,CustomFlash,CustomFlashVideo,CustomDocInsert';
}