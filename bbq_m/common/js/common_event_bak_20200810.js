// Layer Popup Open
function lpOpen(el) {
	var $el = $(el);

	$el.stop().fadeIn('fast');
}
// Layer Popup Close
function lpClose(el) {
	var $el = $(el).closest(".lp-wrapper");

	$el.stop().fadeOut('fast');
}

function lpOpen2(el) {
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
function lpClose2(el) {
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
	// Header Menu
	$(document).on('click', '.btn_header_menu', function(e) {
		$(".aside-menu").fadeIn('fast');
	});
	$(document).on('click', '.btn_header_brand', function(e) {
		$(".aside-brand").fadeIn('fast');
	});
	$(document).on('click', '.btn_aside_close', function(e) {
		if ($(".aside").is(":visible")) {
			$(".aside").fadeOut('fast');
		}
	});

	// LNB
	$(".lnb li.node1 a.depth1").on('click', function(e) {
		var $node1 = $(this).closest("li.node1");

		if ($node1.hasClass("hasMenu")) {
			e.preventDefault();

			if ($node1.hasClass("on")) {
				$node1.find(".submenu").stop().slideUp('fast', function(){
					$node1.removeClass("on");
				});
			} else {
				$node1.addClass("on");
				$node1.find(".submenu").stop().slideDown('fast');
				$node1.siblings().removeClass("on");
				$node1.siblings().find(".submenu").stop().slideUp('fast');
			}
		}
	});

	// Scroll Top
	$(window).on("scroll", function(e) {
		if ($(this).scrollTop() > 0) {
			$('.btn_scrollTop').addClass('active');
			$(".wrapper").addClass("scrolled");
		} else {
			$('.btn_scrollTop').removeClass('active');
			$(".wrapper").removeClass("scrolled");
		}
	});
	$(document).on('click', '.btn_scrollTop', function(e) {
		e.preventDefault();

		$('html, body').animate({
			scrollTop: 0
		}, 800);
	});

	// Layer Popup Event;
	$(document).on('click', '.btn_lp_open', function(e){
		e.preventDefault();
	});
	$(document).on('click', '.btn_lp_close', function(e){
		lpClose2("#lp_alert");
//		$(this).closest(".lp-wrapper").stop().fadeOut('fast');
	});

	// Tab Layer Type
	$(".tab-layer li").on('click', function(e){
		var tabIndex = $(this).index();
		var $tabContainer = $(this).closest(".tab-layer").next(".tab-container-layer");

		e.preventDefault();

		$(this).addClass("on").siblings("li").removeClass("on");
		$tabContainer.find(".tab-content").eq(tabIndex).addClass("on").siblings(".tab-content").removeClass("on");
	});
});






function headCtl(){
	/* footer 더보기 버튼*/
	$('.footer_more').click(function(){
		$('#wrap').toggleClass('footer_on');
	})

	$('.select_open').on("click", function(e){
		e.preventDefault();
		var $this = $(this);
		$(".search_select").addClass('on');
	});
	var $search_select = $(".search_select");
	
	$('.select_open').on("focus", function(){
		$search_select.removeClass('on');
	});
	$('.search_select ul li button').click(function(){
		$search_select.removeClass('on');
		var thisVal = $(this).text();
		$('.select_open span').text(thisVal);
	})
	$('.search_select ul li:last-child button').blur(function(){
		$search_select.removeClass('on');
	});
	$(document).click(function(e){
	    if(!$(e.target).closest(".search_select").length > 0 ) {
	    	$search_select.removeClass('on');
	    } 
	});
	
}

	