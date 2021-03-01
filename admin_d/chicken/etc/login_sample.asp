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
		if (type == 1) {
			var popupX = (window.screen.width / 2) - (480 / 2);
			var popupY = (window.screen.height /2) - (680 / 2);

			window.open('./popup_login.asp', '', 'status=no, height=680, width=480, scrollbars=yes, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		} else if (type == 2) {
			var popupX = (window.screen.width / 2) - (480 / 2);
			var popupY = (window.screen.height /2) - (630 / 2);

			window.open('./popup_join01.asp', '', 'status=no, height=630, width=480, scrollbars=yes, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		} else if (type == 3) {
			var popupX = (window.screen.width / 2) - (480 / 2);
			var popupY = (window.screen.height /2) - (680 / 2);

			window.open('./popup_join02.asp', '', 'status=no, height=680, width=480, scrollbars=yes, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		} else if (type == 4) {
			var popupX = (window.screen.width / 2) - (480 / 2);
			var popupY = (window.screen.height /2) - (680 / 2);

			window.open('./popup_join_fail.asp', '', 'status=no, height=680, width=480, scrollbars=yes, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
		}
	}
</script>
</head>

<body>
	<div style="padding:50px 0 0 50px;">
		<button type="button" class="btn btn-md btn-grayLine" onclick="openPop(1)">로그인</button>
		<button type="button" class="btn btn-md btn-red-main btn-line" onclick="openPop(2)">회원가입_01</button>
		<button type="button" class="btn btn-md btn-grayLine" onclick="openPop(3)">회원가입_02</button>
		<button type="button" class="btn btn-md btn-red-main btn-line" onclick="openPop(4)">회원가입_기존회원</button>
	</div>
</html>
