(function () {

	var pluginName = 'CustomFlashVideo'; 
	
	var commandHandler =  {        
		exec: function (editor) {            
			CKEditorExt.showFlashVideoDialog(editor);        
		}    
	};
	
	CKEDITOR.plugins.add(pluginName, {
		init: function (editor) {         
			
			/*editor.addCommand(pluginName, commandHandler);         
			editor.ui.addButton(pluginName, {             
	     		label: editor.lang.custom.FlashVideo,             
	     		command: pluginName,   
	     		className: "cke_button_customFlashVideo"        
	     	});     */
		} 
	});
})();