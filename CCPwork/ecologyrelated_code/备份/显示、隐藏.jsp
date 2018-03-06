jQuery(document).ready(function() {
    jQuery("#show1").after('<tr id=a1><td id=b1 colspan=4></td></tr>');
    jQuery(".show_1").prependTo("#b1");
    jQuery("#show2").after('<tr id=a2><td id=b2 colspan=4></td></tr>');
    jQuery(".show_2").prependTo("#b2");
    jQuery("#button1").html(jQuery("<input type='button' value='显示/隐藏' id='btn1'>"));
    jQuery("#btn1").click(function(){hidetr('#a1');});
    jQuery("#button2").html(jQuery("<input type='button' value='显示/隐藏' id='btn2'>"));
    jQuery("#btn2").click(function(){hidetr('#a2');});
});

function hidetr(id){
    if(jQuery(id).is(":hidden"))
    {
        jQuery(id).show();
    }
    else
    {
        jQuery(id).hide();
    }
}