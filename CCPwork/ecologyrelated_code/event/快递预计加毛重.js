<script type="text/javascript">
jQuery(function(){
       
	var Swhetherregion = jQuery("#field13429");
	var Swhethertype = jQuery("#field13431");
	var Ttest = jQuery("#field13435");
	var Bdeliverregion=jQuery("#field13430");
	var Sdelivertypr=jQuery("#field13432");
        //alert(Bdeliverregion.attr("title")); 
	Swhethertype.val("1");
	//Ttest.attr('disabled',true);
	Swhetherregion.bind("change",function(){
		if (Swhertherregion.val() == 1){//否
			Bdeliverregion.hide();
			
		}else{
			Bdeliverregion.show();
			Bdeliverregion.val("null");
		}
		
	});
	Swhethertype.bind("change",function(){
		if (Swhethertype.val() == 0){
			Sdelivertypr.val("null");
			Sdelivertypr.show();
			//Sdelivertypr.append("<option value='9999'>测试5</option>"); 
		}else if(Swhethertype.val()==1){
                        Sdelivertypr.val("null");
			//Sdelivertypr.val("无");
			//Sdelivertypr.options.add(new Option("无","9"));
			//Sdelivertypr.val("9");
			//Sdelivertypr.append("<option value='5'>测试5</option>"); 
			//$("#field13432  option[value='9999']").remove();   
			//Sdelivertypr.empty();
		}
	});
	
});	
</script>


