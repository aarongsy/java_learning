(function () {

	var pluginName = 'CustomDocInsert'; 
	
	var commandHandler =  {        
		exec: function (editor) {            
			CKEditorExt.showDocInsertDialog(editor);        
		}    
	};
	
	CKEDITOR.plugins.add(pluginName, {
		init: function (editor) {         
			
			/*editor.addCommand(pluginName, commandHandler);         
			editor.ui.addButton(pluginName, {             
	     		label: editor.lang.custom.DocInsert,             
	     		command: pluginName,   
	     		className: "cke_button_customDocInsert"        
	     	});    */ 
		} 
	});
})();