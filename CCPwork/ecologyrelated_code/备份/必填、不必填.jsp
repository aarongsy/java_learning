    if(obj=='1'){
        jQuery("#show1").show();
        jQuery("#field11709span").prepend('<img src="/images/BacoError_wev8.gif" align="absmiddle">');
        $G("needcheck").value=$G("needcheck").value+','+'field11709';
    }
    else{
        jQuery("#field11709span").empty();
        var reg = new RegExp(",field11709","g");
        $G("needcheck").value=$G("needcheck").value.replace(reg, "");
        jQuery("#field11709").val("");
        jQuery("#show1").hide();
    }