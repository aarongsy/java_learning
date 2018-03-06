
function getleftsap(requestid){
    //检查当前需求数量是否超出 
        var jq = jQuery.noConflict();     
        var feild=' nvl (deliverdnum,0) deliverdnum ';  
        var feild1='nvl (yetnum,0) yetnum';  
        if(tablename=='uf_lo_purchase'){  
                feild='quantity deliverdnum';  
                feild1='nvl((quantity-openquantity),0) yetnum ';   
                    }
      
            // 
            //console.info(idx);  
            //sap需求数量  
        var sapnum=SQL('select  '+feild+' from '+tablename+'  where requestid=\''+requestid+'\'');  
        //console.info('select  '+feild+' from '+tablename+'  where requestid=\''+document.getElementById('field_402864d1493a852601493ab88fc70004_'+idx).value+'\'');  
        //已提需求数  
        var yetnum=SQL('select  '+feild1+' from '+tablename+'  where requestid=\''+requestid+'\'');   
        //console.info('select  '+feild1+' from '+tablename+'  where requestid=\''+document.getElementById('field_402864d1493a852601493ab88fc70004_'+idx).value+'\'');   
        //console.info('sapnum   '+sapnum+'yetnum '+yetnum);  
        /*if(){  
            alert('需求产品不得超出('+(sapnum-yetnum)+')，请检查');  
            return false; 
            } */ 
        return Number(sapnum).sub(yetnum);  
    }
 



function tableopration(function_name){
    //操作子表函数   
           
     var formid = '402864d1493a852601493aaffe2d0003'; 
    //子表表单id oTable402864d1493a852601493aaffe2d0003                                           
       var checknode = 'check_node_'+formid;           
     var checkboxes = document.getElementsByName(checknode);          
    //console.info(checkboxes.length );          
      for(var i=0;
    i<checkboxes.length;
    i++){                                               
                    if(!checkboxes[i].checked){      

                    //代表此行被选中      
                            }
                                                       
                    }
            
     var flag=true;
    if(checkboxes !=null&&checkboxes .length>0){       
         for(var i=0;
        i<checkboxes.length;
        i++){                      
                        flag=(flag&&function_name(i));   
            			           }
           
        	    }
    	
    return flag;
    }
  


//删除明细表中的行，并判断：在删除所有行之后，主类别可以重新选择。     
function dodelete()     
{     
    getcheck();   
    var $ = jQuery.noConflict();      
        delrow('402864d1493a852601493aaffe2d0003');     

    var tbl = document.getElementById('oTable402864d1493a852601493aaffe2d0003');     
    if(tbl.rows.length == 1)     
        {     

         var f1=document.getElementById('field_402864d14931fb7901493292b8960034');   
        if(f1==undefined)   
        {   
             $('#formtype').append(select);   
                    }
           
        else if(f1!=select){   
                     //    getcheck();   
                         $(f1).replaceWith(select);   
                         $('#field_40285a90495b4eb001495fbb50dc2aeb').val('');    
                         $('#field_40285a90495b4eb001495fbb50dc2aebspan').text('');   
                     }
           
              $('#field_402864d14931fb7901493292b8960034span').text('');   
             }
         
             
    }
     
function submitcheck(idx){//检测需求数量是否为0

var nownum=document.getElementById('field_402864d1493a852601493ab890b90010_'+idx).value;
if(nownum=='0')
{
alert('需求数量不能为0，请检查');
return false;
}else
   return true;
}



function checknum(idx){   //需求数量绑定change事件，改变时检测是否超出
                  var jq = jQuery.noConflict();   
                  var feild='deliverdnum';     
                  var feild1='nvl(yetnum,0) yetnum';     
                  //console.info(tablename);  
                  if(tablename=='uf_lo_purchase'){     
                          feild='quantity deliverdnum';     
                          feild1='(nvl(quantity,0)- nvl(openquantity,0)) yetnum ';     
                              }
      
                var requestid=jq('#field_402864d1493a852601493ab88fc70004_'+idx).val();   
                var neednow=jq('#field_402864d1493a852601493ab890b90010_'+idx).val();   
                var leftsap=getleftsap(requestid);  
                document.getElementById('field_402864d1493a852601493ab890b90010_'+idx).onpropertychange=function(){ 
                        var idx=(this.id.split('_'))[2];  
                        var requestid=document.getElementById('field_402864d1493a852601493ab88fc70004_'+idx).value; 
                        var leftsap=getleftsap(requestid); 
                      //  console.info('leftsap  '+leftsap);
                        if(this.value>leftsap){ 
                                       alert('第'+Number(idx).add(1)+'行需求数不能超出'+leftsap+'，请核对，已设置为最大可用数');  
                                       
                                this.value=leftsap;  
                                //暂无需求数     
                                //document.getElementById('field_402864d1493a852601493ac56d300016_'+idx).value =Number(leftsap).sub(this.value);   
                                //document.getElementById('field_402864d1493a852601493ac56d300016_'+idx+'span').innerHTML=Number(leftsap).sub(this.value);          
                                        }
        //(this.value>leftsap
                  return true;
        		   
        		       }
    //change   
        /*if(neednow>leftsap){  
                   jq('#field_402864d1493a852601493ab890b90010_'+idx).val(leftsap);  
                    //暂无需求数     
                    document.getElementById('field_402864d1493a852601493ac56d300016_'+idx).value =0;   
                    document.getElementById('field_402864d1493a852601493ac56d300016_'+idx+'span').innerHTML=0;      
             } //neednow>leftsap*/ 
    }
  //function