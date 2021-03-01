var cookiedata = document.cookie;
var tabStartIndex = 0;
$(function(){
	"use strict";
	headCtl();
//	formStyle();
//	popupUI();
//	tapMotion();
//	faqMotion();
//	btnTopUi();
//	scrollItem();
//	scrollMoveItem();
//	//footerMore();
});

function headCtl(){

	/* footer 더보기 버튼*/
	$('.footer_more').click(function(){
		$('.wrapper').toggleClass('footer_on');
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
