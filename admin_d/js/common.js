$(function() {
	$("#SDATE").datepicker({
		dateFormat: 'yy-mm-dd',
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		showMonthAfterYear: true,
		yearSuffix: '년',
		onClose: function( selectedDate ) {
			$( "#EDATE" ).datepicker( "option", "minDate", selectedDate );
		}
	});
	$("#EDATE").datepicker({
		dateFormat: 'yy-mm-dd',
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		showMonthAfterYear: true,
		yearSuffix: '년',
		onClose: function( selectedDate ) {
			$( "#SDATE" ).datepicker( "option", "maxDate", selectedDate );
		}
	});
	$(".SELDATE").datepicker({
		dateFormat: 'yy-mm-dd',
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		showMonthAfterYear: true,
		yearSuffix: '년'
	});

	$('.third_depth').click(function(){
		var submenu = $(this).next('ul');
		if(submenu.is(':visible')){
			submenu.slideUp();
		}else{
			submenu.slideDown();
		}
	});

	$('.mask').click(function () {
		$(this).hide();
		$('.window').hide();
	});
	
	$('.window .close').click(function (e) {
		e.preventDefault();
		$('.mask, .window').hide();
	});

	$('.mask2').click(function () {
		$(this).hide();
		$('.window2').hide();
	});
	
	$('.window2 .close').click(function (e) {
		e.preventDefault();
		$('.mask2, .window2').hide();
	});

    //오버시
    $('#menu_hover li').hover(function(){
        $(this).find('img').attr('src',$(this).find('img').attr('src').replace('_off','_on'));
    },function(){
        $(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_off'));
        //$('.tab-data',this).stop().slideUp(100);
    });
    //클릭시
    $('#menu_hover li').click(function(){
        $('.tab-data').stop().hide();
        $('.tab-data',this).stop().slideDown(100);
    });
});

//쿠키 값 저장
function setCookie( name, value, expiredays ){
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}
//쿠키 값 불러오기
function getCookie( name ){
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length )
	{
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
			endOfCookie = document.cookie.length;
			return unescape( document.cookie.substring( y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
			break;
	}
	return "";
}

function onlyNum(objtext1){ 
	var inText = objtext1.value; 
	var ret; 
	for (var i = 0; i <= inText.length; i++) { 
		ret = inText.charCodeAt(i);
		if ((ret <= 47 && ret > 31) || ret >= 58)  { 
			alert("숫자만을 입력하세요"); 
			objtext1.value = ""; 
			objtext1.focus();
			return false; 
		}
	}
	return true; 
}

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
function wrapWindowByMask2(){
	var maskHeight = $(document).height();
	var maskWidth = $(window).width();

	$('.mask2').css({'width':maskWidth,'height':maskHeight});

	$('.mask2').fadeIn(0);
	$('.mask2').fadeTo("slow",0.6);

	var left = ( $(window).scrollLeft() + ( $(window).width() - $('.window2').width()) / 2 );
	var top = ( $(window).scrollTop() + ( $(window).height() - $('.window2').height()) / 2 );

	$('.window2').css({'left':left,'top':top, 'position':'absolute'});
	$('.window2').show();
}
function OpenUploadIMG(IMGID, UPID){
	UPDIR = $('#'+UPID).val();
	win = window.open('/board/Imgupload.asp?IMGID='+IMGID+'&UPDIR='+UPDIR,'OpenUploadIMG','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,status=no, left=50,top=50, width=600,height=200');
	win.focus();
}
function OpenUploadEIMG(IMGID, UPID){
	UPDIR = $('#'+UPID).val();
	win = window.open('/board/Imgupload_Editor.asp?IMGID='+IMGID+'&UPDIR='+UPDIR,'OpenUploadIMG','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,status=no, left=50,top=50, width=600,height=200');
	win.focus();
}
function OpenUploadFILE(FILEID, UPID){
	UPDIR = $('#'+UPID).val();
	win = window.open('/board/Fileupload.asp?FILEID='+FILEID+'&UPDIR='+UPDIR,'OpenUploadFILE','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,status=no, left=50,top=50, width=600,height=200');
	win.focus();
}