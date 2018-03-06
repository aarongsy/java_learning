$(document).ready(function(){
	if ($.browser.msie){
		$("input[@type='text'], input[@type='password'], textarea").focus(function(){$(this).addClass("ie_focus")}).blur(function(){$(this).removeClass("ie_focus")});
	}
})