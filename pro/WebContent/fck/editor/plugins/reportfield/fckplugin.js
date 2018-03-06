
/*
// Register the related commands.
FCKCommands.RegisterCommand( 'My_Find'		, ) ;
FCKCommands.RegisterCommand( 'My_Replace'	, new FCKDialogCommand( FCKLang['DlgMyReplaceTitle'], FCKLang['DlgMyReplaceTitle']	, FCKConfig.PluginsPath + 'findreplace/replace.html', 340, 200 ) ) ;

// Create the "Find" toolbar button.
var oFindItem		= new FCKToolbarButton( 'My_Find', FCKLang['DlgMyFindTitle'] ) ;
oFindItem.IconPath	= FCKConfig.PluginsPath + 'findreplace/find.gif' ;

FCKToolbarItems.RegisterItem( 'My_Find', oFindItem ) ;			// 'My_Find' is the name used in the Toolbar config.

// Create the "Replace" toolbar button.
var oReplaceItem		= new FCKToolbarButton( 'My_Replace', FCKLang['DlgMyReplaceTitle'] ) ;
oReplaceItem.IconPath	= FCKConfig.PluginsPath + 'findreplace/replace.gif' ;

FCKToolbarItems.RegisterItem( 'My_Replace', oReplaceItem ) ;	// 'My_Replace' is the name used in the Toolbar config.
*/
//====================================================================================================
/*
// ## 1. Define the command to be executed when selecting the context menu item.
var oMyCMCommand = new Object() ;
oMyCMCommand.Name = 'OpenImage' ;

// This is the standard function used to execute the command (called when clicking in the context menu item).
oMyCMCommand.Execute = function()
{
	// This command is called only when an image element is selected (IMG).
	// Get image URL (src).
	var sUrl = FCKSelection.GetSelectedElement().src ;

	// Open the URL in a new window.
	alert(sUrl);
	window.top.open( sUrl ) ;
}

// This is the standard function used to retrieve the command state (it could be disabled for some reason).
oMyCMCommand.GetState = function()
{
	// Let's make it always enabled.
	return FCK_TRISTATE_OFF ;
}
*/


// ## 2. Register our custom command.
//FCKCommands.RegisterCommand( 'OpenImage', oMyCMCommand ) ;
FCKCommands.RegisterCommand( 'OpenField', new FCKDialogCommand('DlgMyFindTitle', '字段属性设置', FCKConfig.PluginsPath + 'reportfield/field.html'	, 500, 350)); 
//-------------------------------------------------------
var DelFieldCmd={
	Name:'DelFieldCmd',
	Execute:function(){
		var e = FCKSelection.GetSelectedElement();
		if(e!=null && e.tagName=='BUTTON'){
			var fieldId=e.getAttribute("name");
			if(fieldId!='') delete window.parent.Report.data[fieldId];
			FCKDomTools.RemoveNode(e);
		}//alert('删除选中元素操作!'+e);
	},
	GetState:function(){return FCK_TRISTATE_OFF;},
	Reg:function(){
		FCKCommands.RegisterCommand( this.Name, this ) ;
	}
};
DelFieldCmd.Reg();
//------------------------------------------------------------------

// Create the "插入字段" toolbar button.
var oFindItem		= new FCKToolbarButton( 'OpenField', '插入字段' );
oFindItem.IconPath	= FCKConfig.PluginsPath + 'reportfield/find.gif' ;
FCKToolbarItems.RegisterItem( 'OpenField', oFindItem ) ;// 'My_Find' is the name used in the Toolbar config.


// ## 3. Define the context menu "listener".
var oMyContextMenuListener = new Object() ;

// This is the standard function called right before sowing the context menu.
oMyContextMenuListener.AddItems = function( contextMenu, tag, tagName )
{
	// Let's show our custom option only for images.
	//if ( tagName == 'IMG' )
	if ( tagName == 'BUTTON' && tag.className=="Field" )
	{
		contextMenu.AddSeparator() ;
		contextMenu.AddItem( 'OpenField', '修改字段' );
		contextMenu.AddItem( 'DelFieldCmd', '删除字段' );
	}
}


// Open the Placeholder dialog on double click.
function Field_OnDoubleClick( field )
{
	if ( field.tagName == 'BUTTON' && field.className=="Field"){
		FCKCommands.GetCommand( 'OpenField' ).Execute() ;
	}
}
FCK.RegisterDoubleClickHandler( Field_OnDoubleClick, 'button' );


// ## 4. Register our context menu listener.
FCK.ContextMenu.RegisterListener( oMyContextMenuListener ) ;
