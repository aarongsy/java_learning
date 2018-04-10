<script type='text/javascript'>
var buyorder=jQuery("#field13991");
var suppliercode=jQuery("#field13926");
//var suppliercode_span=jQuery("#field13926span");
// var suppliercode=jQuery("#field13931");
// var suppliercode_span=jQuery("#field13931span");

	jQuery(function(){
		// getsupplyinfo();
		buyorder.bindPropertyChange(function(){
			var buyorder=jQuery("#field13991");
			var suppliercode=jQuery("#field13926");
			var requestid = buyorder.val();
			var purchno = buyorder.val();
			getsupplyinfo();
			//var suppliercode_span=jQuery("#field13926span");
			
		});
		/* addRow0('0');//
		addRow0('0');//明细表0添加行
		addRow1('1');//
		addRow1('1');//明细表1添加行 */
	});

	function getsupplyinfo(){
		alert("1");
		var buyorder=jQuery("#field13991");
		var suppliercode=jQuery("#field13926");
		var requestid = buyorder.val();
	    var purchno = buyorder.val();
		jQuery.ajax({
			// url:"/app/weikuan/getsupplyinfo.jsp",
			// url:"/cusjsp/fn/getsupplyinfo.jsp",
			url:"/cusjsp/fn/currentusername.jsp",
			//oa/app/weaver/ecology/cusjsp/fn/getsupplyinfo.jsp
			// data:{requestid:requestid,purchno:purchno
			// },
			type :"GET",
			async:false,
			success:function(res){
				console.log("success");
				var temp1=jQuery.trim(res);
				alert("res="+temp1);
				var temp;
				temp = eval('('+res.responseText+')');
				
				//suppliercode.html(jsonResult .LIFNR);
				//suppliercode.val(jsonResult .LIFNR);
				//console.log("jsonResult"+temp);
				// console.log(jsonResult .LIFNR);
				
			}
		});
	}
</script>