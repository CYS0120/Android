<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "회원정보변경"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!-- 정보변경 비밀번호 입력 -->
			<section class="section section_pwd mar-t60">
				<div class="txt">
					고객님의 개인정보를 안전하게 보호하기 위해 
					비밀번호를 다시 한번 입력해 주세요.
				</div>
				<form action="" class="form">
					<p><input type="password" class="w-100p"></p>
					<p class="mar-t20"><button type="submit" onclick="location.href='./memEdit.asp'" class="btn btn-lg btn-black w-100p">확인</button></p>
				</form>
			</section>
			<!-- //정보변경 비밀번호 입력 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
