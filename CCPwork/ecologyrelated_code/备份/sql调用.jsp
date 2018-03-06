    jQuery.ajax({ 
        async:false,
        type:'post',                 
        url:'/IandE/gewaipin/BPATB_1.jsp?',               
        data:{flowno:flowno,no:no},   
        cache:false,    
        dataType:'json',        
        success: function(res) {  
            chujia1=res.chujia1;     
        }    
    }); 
	
	
	
	

    jQuery.getJSON('/EHSM/...',{sql:sql},function(data){
        A=data.a;
    });