
jQuery(function(){
   leftTimer(2018,11,11,11,11,11);
});

function leftTimer(year,month,day,hour,minute,second){
  //计算剩余的毫秒数 
  var leftTime = (new Date(year,month-1,day,hour,minute,second))-(new Date()); 
  //计算剩余的天数
  var days = parseInt(leftTime/1000/60/60/24);  
  //计算剩余的小时
  var hours = parseInt(leftTime/1000/60/60%24);
  //计算剩余的分钟
  var minutes = parseInt(leftTime/1000/60%60);
  //计算剩余的秒数
  var seconds = parseInt(leftTime/1000%60);
  //刺激的毫秒
  var miliseconds = parseInt(leftTime%1000);
    days = dateformalise(days); 
    hours = dateformalise(hours); 
    minutes = dateformalise(minutes); 
    seconds = dateformalise(seconds); 
    milisec  = dateformalise(miliseconds);
    jQuery("#field13251").val(days+"天" + hours+"小时" + minutes+"分"+seconds+"秒"+milisec+"毫秒");
    setTimeout('leftTimer(2018,1,19,17,15,0)',10);//jQuery("#field13251").val(time);
  
}
  function dateformalise(curtime){
     if (curtime <10)
     {
        curtime ="0"+curtime; 
     }
     return curtime;
   }

   
   