$OBJ = {
	'win' : $(window),
	'doc' : $(document),
	'html' : $('html')
}

// 창 높이
function winW(){
	return $OBJ.win.width();
}

// 창 높이
function winH(){
	return $OBJ.win.height();
}

//파일 업로드
function fileDes(a){
	$(a).prev().val($(a).val())
}

// Layer Popup Open
function lpOpen2(el) {
	var $el = $(el);
	$el.stop().fadeIn('fast');
	var win_h = $(window).height() - 80;
}
// Layer Popup Close
function lpClose2(el) {
	var $el = $(el).closest(".lp-wrapper2");
	
	$el.stop().fadeOut('fast');
	$("body").css("overflow","");
}


jQuery(document).ready(function(e){
	
	$(document).on('click', '.btn_lp_close2', function(e){
		$(this).closest(".lp-wrapper2").stop().fadeOut('fast');
		$(".lp_focus").focus();
		$(".lp_focus").removeClass(".lp_focus");
	});	
});
