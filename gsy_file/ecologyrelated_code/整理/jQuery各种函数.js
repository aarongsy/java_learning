/* 
//jQuery api 目录 ！！！
http://jquery.cuishifeng.cn/
//jQuery图书片上传回显
http://blog.csdn.net/qq_28602957/article/details/53783697
//jquery下拉框取值赋值
http://www.jquerycn.cn/a_14228
//js表单回显
http://blog.csdn.net/xujiaolf/article/details/45313353
//Ajax 动态添加复选框
http://blog.csdn.net/xujiaolf/article/details/27339247 
*/
/*********************************jQuery 基本操作****************************************/
//对对象赋值
js获取text、html、属性值、value的方法：
document.getElementById("test").innerText；
document.getElementById("test").innerHTML；
document.getElementById("test").id；
document.getElementById("test1").value;

jQuery获取text、html、属性值、value的方法：
$("#test").text()或者$("#test").innerText
$("#test").html()或者$("#test").innerHTML
$("#test").attr("id")
$("#test").attr("value")或者$("#test1").val()或者$("#test1").value

#例子：只读框赋值：jQuery("#field8090span").html(zfreason); jQuery("#field8090span").text(zfreason);
jQuery中的val()方法只能用于input元素的value值获取

//设置只读 
$("#test").attr("disabled",true);

//取值
$("#test").val(var);
var=$("#test").val();

/*********************************jQuery ajax****************************************/
ajax({ 
  type:"POST", 
  url:"ajax.php", 
  dataType:"json", 
  data:{"val1":"abc","val2":123,"val3":"456"}, 
  beforeSend:function(){ 
    //some js code 
  }, 
  success:function(msg){ 
    console.log(msg) 
  }, 
  error:function(){ 
    console.log("error") 
  } 
})
/*******************************选择框操作****************************************/
//选择框增加选项 （选择框id:#test）
$("#test").append("<option value='5'>测试5</option>");
$("#test").empty();//用的最多 
//显示或者隐藏制定选项
$("#test>option:contains('selection content')").hide();
$("#test>option:contains('selection content')").show();
//删除Select中索引值最大Option(最后一个)
 $("#test  option:last").remove();   
//删除Select中索引值为0的Option(第一个)
 $("#test  option[index='0']").remove();   
//删除Select中Value='3'的Option
 $("#test  option[value='3']").remove();   