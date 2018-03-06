		var keyword = "searchKeys";
		var suggest_action = "/ServiceAction/com.eweaver.searchengine.servlet.SuggestAction";
		var temp_str;
		
		
		var $=function(node){
			return document.getElementById(node);
		}
		
		var $$=function(node){
			return document.getElementsByTagName(node);
		}
		
		 String.prototype.Trim=function(){   
  			return   this.replace(/(^\s*)|(\s*$)/g,"");   
  		}
  		
		function ajax_keyword(){
			var xmlhttp;
			try{
				xmlhttp=new XMLHttpRequest();
				}
			catch(e){
				xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
				}
			xmlhttp.onreadystatechange=function(){
			if (xmlhttp.readyState==4){
				if (xmlhttp.status==200){
					var data=xmlhttp.responseText;
					if(data != 1) {
						$("suggest").innerHTML=data;
						$("suggest").style.display="";
					} else {						
						$("suggest").style.display="none";
						$("suggest").innerHTML="";
					}
					
					}
				}
			}
			xmlhttp.open("post", suggest_action, true);
			xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
			xmlhttp.send("keyword="+$(keyword).value);
		}
		
		function keyupdeal(e){
			var keyc;
			if(window.event){
				keyc=e.keyCode;
				}
			else if(e.which){
				keyc=e.which;
				}
			if(keyc!=40 && keyc!=38){
				if($(keyword).value.Trim().length > 0){
					ajax_keyword();
					temp_str=$(keyword).value;
				} else {					
					$("suggest").style.display="none";
					$("suggest").innerHTML="";
				}
			}
			
		}
		
	window.onresize=function() {
		$("suggest").style.left=$("searchKeys").offsetLeft;
	}	
	
	function setword(obj) {
		$("searchKeys").value = $(obj).innerHTML;
		$("suggest").style.display="none";
		$("suggest").innerHTML="";
		document.VelcroForm.submit();
	}
	
	function setCss(obj) {
		obj.style.cursor = "hand";
		obj.style.background="#dac";
	}
	
	function setLeaveCss(obj) {
		obj.style.background="#fff";
	}
	
	document.onclick=function() {
		$("suggest").style.display="none";
		$("suggest").innerHTML="";
	}
		