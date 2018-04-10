<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
	$(document).ready(function(){
		var blurfield="#field13925";//绑定采购订单号
		$(blurfield).bindPropertyChange(function(){	
			var ponos = $(blurfield).val()//采购订单号
			console.log("purchno:"+ponos);
			
            $.post("/cusjsp/test.jsp?ponos=" + ponos, function(data) {
                if (data) {
                    if (data.length > 48) {
                        Dialog.alert("Data acquisition success!");
                        
                     
                    } else {
                        Dialog.alert("Data acquisition failure!");
                    }
                }
            });
			 
		})
	})
	
	/*  function fieldidvalue(fieldid, value) {
        // jQuery(fieldid).val(value);
        // jQuery(fieldid + "span").html(value);
    } */
</script>





