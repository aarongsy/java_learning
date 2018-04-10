<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->
<script type="text/javascript">
	$(document).ready(function(){
		var blurfield="#field13991";//绑定采购订单号
		//$(blurfield).bind('change',function(){
		$(blurfield).bindPropertyChange(function(){	
			alert();
			var ponos = $(blurfield).val()//采购订单号
			console.log("purchno:"+ponos);
			// deleteAll(0);
			if (ponos==''){
				return;
			}
			$.post("/cusjsp/fn/e8_applicant_0329.jsp?ponos="+ponos,function(data){
				if(data){
				$("#field13925").val(data);
					if(data.length> 48){
						Dialog.alert("Data acquisition success!");
						var ponoses = data.split("![]");
						for (var i = 1; i < ponoses.length;i++){
							console.log(ponoses[i]);
							var fields = ponoses[i].split("|");
							addRow0(0);
							var hang_number = parseInt(jQuery("#indexnum0").val())-1;//行数
							
							jQuery("#field_13958"+hang_number).val(fields[0]);//明细字段短文本
							//fieldidvalue("#field_13958"+hang_number,fields[0]);
							console.log("明细字段赋值");
					    }
					}else{
						Dialog.alert("Data acquisition failure!");
						Dialog.alert(data);
					}
				}
			});
		})
	})
	
	 function fieldidvalue(fieldid, value) {
        jQuery(fieldid).val(value);
        jQuery(fieldid + "span").html(value);
    }
</script>