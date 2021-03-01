// Layer Popup Open
function lpOpen(el) {
	var $el = $(el);	
	$el.addClass("on");
	$el.stop().fadeIn('fast');
	var win_h = $(window).height() - 80;
	var lp_h = $el.find(".lp-header").height() + $el.find(".lp-container").height();
	$('html').css('overflow','hidden');
	console.log(win_h,lp_h);
	if(lp_h > win_h){
		$el.find(".lp-container").height(win_h - $el.find(".lp-header").height() - 80 + "px");
	}else{
		
	};
}
// Layer Popup Close
function lpClose(el) {
	var $el = $(el).closest(".lp-wrapper");	
	
	$el.stop().fadeOut('fast');
	$el.removeClass("on");
	$("body").css("overflow","");
	$('html').css('overflow','');
}

function setEmail(el, sTarget) {
	var $el = $(el);
	
	$(sTarget).val($el.val());
}

jQuery(document).ready(function(e) {
	$(window).on('scroll', function(e){
		// Gnb Scroll
		$(".header").css('left', -$(this).scrollLeft() +'px');
		$(".main .section").css('left', -$(this).scrollLeft() +'px');

		// Scroll Top
		if ($(this).scrollTop() > 0) {
			$('.btn_scrollTop').addClass('active');
		} else {
			$('.btn_scrollTop').removeClass('active');
		}
	});	
	$(document).on('click', '.btn_scrollTop', function(e) {
		e.preventDefault();
		
		$('html').animate({
			scrollTop: 0
		}, 800);
	});		
	
	// LNB
	$(".lnb").on({
		'mouseenter':function(e){
			$(".bg-lnb").stop().slideDown('fast',function(){
				$(".lnb .submenu").stop().fadeIn('fast');
			});
		},
		'mouseleave':function(e){
			$(".lnb .submenu").stop().fadeOut('fast',function(){
				$(".bg-lnb").stop().slideUp('fast');
			});			
		}
	});
		

	// Layer Popup Event;
	$(document).on('click', '.btn_lp_open', function(e){
		e.preventDefault();
		$(this).addClass("lp_focus");
		$('html').css('overflow','hidden');
	});	
	$(document).on('click', '.btn_lp_close', function(e){
		$(this).closest(".lp-wrapper").stop().fadeOut('fast');
		$(".lp_focus").focus();
		$(".lp_focus").removeClass(".lp_focus");
		$('html').css('overflow','');
	});	
	
	// Tab Layer Type
	$(".tab-layer li").on('click', function(e){
		var tabIndex = $(this).index();
		var $tabContainer = $(this).closest(".tab-layer").next(".tab-container-layer");
		
		e.preventDefault();
		
		$(this).addClass("on").siblings("li").removeClass("on");
		$tabContainer.find(".tab-content").eq(tabIndex).addClass("on").siblings(".tab-content").removeClass("on");		
	});		

	//layer Popup
	function wrapWindowByMask(){
        var maskHeight = $(document).height();
        var maskWidth = $(window).width();

        $('.mask').css({'width':maskWidth,'height':maskHeight});

        $('.mask').fadeIn(0);
        $('.mask').fadeTo("slow",0.6);

        var left = ( $(window).scrollLeft() + ( $(window).width() - $('.window').width()) / 2 );
        var top = ( $(window).scrollTop() + ( $(window).height() - $('.window').height()) / 2 );

        $('.window').css({'left':left,'top':top, 'position':'absolute'});
        $('.window').show();
    }
    
        $('.popup').click(function(e){
            e.preventDefault();
            wrapWindowByMask();
        });

        $('.mask').click(function () {
            $(this).hide();
            $('.window').hide();
        });
        
        $('.window .close').click(function (e) {
            e.preventDefault();
            $('.mask, .window').hide();
        });

});
