/* 
getcheck()--------
			|
			|	
			|
 */
<SCRIPT>
function getcheck(){  
	var payterm=document.getElementById('field_付款条件').value 
	var sql='select residuenum from uf_fn_installmentdata  where code=\''+payterm+'\'';  
	DataService.getValues(sql,{        
		callback:function(data)           
		{            
			if(data&&data.length>0){ 
				for (var i=0;i<data.length ; i++) {
					var sql2='update uf_fn_acceptconfirm set  residue=\''+data[0].residuenum+'\' where requestid=\''+requestid+'\' ';                 
				    DataService.executeSql(sql2,{
						callback:function(data){}//residue残余
					});   
				}     
			}               
		}         
	});   
		
}
function ordernum(){   
	DWREngine.setAsync(false);   
	var money='';   
	var tbl=document.getElementById('oTable40285a8d4c1ff2fe014c2045dfda0814');   
	var len=tbl.rows.length-1;   
	var sql='select paytotal from uf_fn_acceptorder where requestid=\''+requestid+'\'';
	DataService.getValues(sql,{            
		callback:function(data)            
		{          
			if(data&&data.length>0){ 
				for (var i=0;i<data.length;i++) { 
					money=money*1+data[i].paytotal*1; 
				} 	 
			}                
		}          
	});  
	document.getElementById('field_总付款金额').value=money;
	document.getElementById('field_总付款金额span').innerHTML=money; 
	DWREngine.setAsync(true);           
}
</SCRIPT>