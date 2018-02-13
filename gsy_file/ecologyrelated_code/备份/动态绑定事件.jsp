function bindchange(id, fun) {
    var old_val = jQuery(id).val();
    setInterval(function() {
        var new_val = jQuery(id).val();
        if(old_val != new_val) {
            old_val = new_val;
            fun();
        }
    }, 50);
}


jQuery(document).ready(function() {
//调用绑定的事件方法
    bindchange("#field", fun);
}); 