 <script type="text/javascript">
 //文本框变化监听事件 
 $("#txt1,#txt2").change(function(){
   if($("#txt1").val()!=""&&$("#txt2").val()!=""){
     //给txt3和txt4赋值,这里要放一些验证数据逻辑
    var value1=$("#txt1").val();
    var value2=$("#txt2").val();
     $("#txt3").val(value1+value2);
     $("#txt4").val((value1+value2)/2);
   }
});

</script>
