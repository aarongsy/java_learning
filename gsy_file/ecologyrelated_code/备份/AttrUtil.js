/*!
 * AttrUtil for Ecology8 v1.0
 *
 * Author: TimothyZ
 * 
 * Date: 2017-12-14
 */
/**
 * 用于设置只读，编辑，必填。
 * @param identity 元素id，例如field13069 identity=13069
 * AttUtil.readOnly("13069");//设置只读
 * AttUtil.editorial("13069");//设置编辑
 * AttUtil.mustInput("13069");//设置必填
 * 以上三个方法用于设置文本，下拉框等，其他未测试
 * 以下三个方法用于设置浏览按钮
 * AttUtil.bReadOnly("13069");//设置只读
 * AttUtil.bEditorial("13069");//设置编辑
 * AttUtil.bMustInput("13069");//设置必填
 */
var AttrUtil = function(){
    function appendCheck(identity){
        jQuery("input[name='needcheck']").val(function (i, v) {
            if(v.search(identity)==-1)
            return v+",field"+identity;
            return v;
        });
    }

    function removeCheck(identity){
        jQuery("input[name='needcheck']").val(function (i, v) {
            if(v.search(identity)!=-1)
            return v.replace(",field" + identity, "");
            return v;
        });
    }

    function readOnly(identity){
        var $target = jQuery("#field"+identity);
        var $targetspan = jQuery("#field"+identity+"span");
        $targetspan.empty();
        $target.css({'display':'none'}).attr({'viewtype':'0'});
        if(jQuery("#field"+identity+"_readonlytext").length==0)$target.after("<span id='field"+identity+"_readonlytext' style='line-height:30px!important;'>"+$target.val()+"</span>");
        removeCheck(identity);
    }

    function editorial(identity){
        var $target = jQuery("#field"+identity);
        var $targetspan = jQuery("#field"+identity+"span");
        $targetspan.empty();
        jQuery("#field"+identity+"_readonlytext").remove();
        $target.css({'display':'inline-block'}).attr({'viewtype':'0'});
        removeCheck(identity);
    }

    function mustInput(identity){
        var $target = jQuery("#field"+identity);
        var $targetspan = jQuery("#field"+identity+"span");
        jQuery("#field"+identity+"_readonlytext").remove();
        $target.css({'display':'inline-block'}).attr({'viewtype':'1'});
        if($target.val()=='')$targetspan.empty().html("<img src='/images/BacoError_wev8.gif' align='absMiddle'>");
        appendCheck(identity);
    }

    function bReadOnly(identity){
        var $target = jQuery("#field"+identity);
        var $targetspan = jQuery("#field"+identity+"span");
        var $targetspanimg = jQuery("#field"+identity+"spanimg");
        $targetspanimg.empty();
        var copyspan = $targetspan.clone();
        copyspan.children("span").find("span").remove();
        $target.attr({'viewtype':'0'}).removeAttr("ismustinput").removeAttr("_ismustinput").siblings("div.e8_os").css({'display':'none'});
        if(jQuery("#field"+identity+"_readonlytext").length==0)$target.after("<span id='field"+identity+"_readonlytext' style='line-height:30px!important;'>"+copyspan.html()+"</span>");
        removeCheck(identity);
    }

    function bEditorial(identity){
        var $target = jQuery("#field"+identity);
        var $targetspanimg = jQuery("#field"+identity+"spanimg");
        $targetspanimg.empty();
        jQuery("#field"+identity+"_readonlytext").remove();
        $target.attr({'viewtype':'0'}).removeAttr("ismustinput").removeAttr("_ismustinput").siblings("div.e8_os").css({'display':'block'});
        removeCheck(identity);
    }

    function bMustInput(identity){
        var $target = jQuery("#field"+identity);
        var $targetspanimg = jQuery("#field"+identity+"spanimg");
        jQuery("#field"+identity+"_readonlytext").remove();
        $target.attr({'viewtype':'1','ismustinput':2,'_ismustinput':2}).siblings("div.e8_os").css({'display':'block'});
        if($target.val()=='')$targetspanimg.empty().html("<img src='/images/BacoError_wev8.gif' align='absMiddle'>");
        appendCheck(identity);
    }

    return {
        readOnly : readOnly,
        editorial : editorial,
        mustInput : mustInput,
        bReadOnly : bReadOnly,
        bEditorial : bEditorial,
        bMustInput : bMustInput
    }
}();