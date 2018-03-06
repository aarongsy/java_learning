(function () {

	var pluginName = 'CustomFlash'; 
	
	var commandHandler =  {        
		exec: function (editor) {            
			CKEditorExt.showFlashDialog(editor);     
		}    
	};
	
	CKEDITOR.plugins.add(pluginName, {
		init: function (editor) {         
			
			editor.addCommand(pluginName, commandHandler);         
			editor.ui.addButton(pluginName, {             
	     		label: editor.lang.common.flash,             
	     		command: pluginName,   
	     		className: "cke_button_flash"        
	     	});     
		} 
	});
})();