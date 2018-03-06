(function () {

	var pluginName = 'CustomImage'; 
	
	var commandHandler =  {        
		exec: function (editor) {            
			CKEditorExt.showImageDialog(editor);        
		}    
	};
	
	CKEDITOR.plugins.add(pluginName, {
		init: function (editor) {         
			
			//CKEDITOR.dialog.add(pluginName, this.path + 'dialogs/CustomImage.js');         
			editor.addCommand(pluginName, commandHandler);         
			editor.ui.addButton(pluginName, {             
	     		label: editor.lang.common.image,             
	     		command: pluginName,   
	     		className: "cke_button_image"        
	     	});     
		} 
	});
})();