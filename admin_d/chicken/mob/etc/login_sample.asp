<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="로그인 회원가입 팝업, BBQ치킨">
<meta name="Description" content="로그인 회원가입 팝업">
<title>로그인 회원가입 팝업 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
	function openPop(type){
		// if (type == 1) {
		// 	var popupX = (window.screen.width / 2) - (480 / 2);
		// 	var popupY = (window.screen.height /2) - (680 / 2);

		// 	window.open('./popup_login.asp', '', 'status=no, height=680, width=480, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		// } else if (type == 2) {
		// 	var popupX = (window.screen.width / 2) - (480 / 2);
		// 	var popupY = (window.screen.height /2) - (630 / 2);

		// 	window.open('./popup_join01.asp', '', 'status=no, height=630, width=480, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		// } else if (type == 3) {
		// 	var popupX = (window.screen.width / 2) - (480 / 2);
		// 	var popupY = (window.screen.height /2) - (680 / 2);

		// 	window.open('./popup_join03.asp', '', 'status=no, height=680, width=480, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		// } else if (type == 4) {
		// 	var popupX = (window.screen.width / 2) - (480 / 2);
		// 	var popupY = (window.screen.height /2) - (680 / 2);

		// 	window.open('./popup_join_fail.asp', '', 'status=no, height=680, width=480, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		// }
	}
</script>
</head>

<body>
	<div style="margin:50px 0 0 50px;">
		<a href="./popup_login.asp" class="btn btn-md btn-grayLine" target="_blank">로그인</a>
		<a href="./popup_join01.asp" class="btn btn-md btn-black btn-line" target="_blank">회원가입_01</a>
		<a href="./popup_join02.asp" class="btn btn-md btn-grayLine" target="_blank">회원가입_02</a>
		<a href="./popup_join_fail.asp" class="btn btn-md btn-black btn-line" target="_blank">회원가입_기존회원</a>
	</div>
</html>
