<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="나의 상담내역, BBQ치킨">
<meta name="Description" content="나의 상담내역">
<title>회원정보 변경 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
});
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="/">bbq home</a></li>
				<li><a href="#" onclick="javascript:return false;">마이페이지</a></li>
				<li>회원정보 변경</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<!--#include virtual="/includes/mypage.inc.asp"-->
				<!--// My Info -->
				<!-- My Menu -->
				<!--#include virtual="/includes/mypagemenu.inc.asp"-->
				<!--// My Menu -->
			</section>
			<!--// Membership -->
		
			<!-- card List -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>회원정보 변경</h3>
				</div>
				<div class="section-body">

					<form action="#" class="memEdit-pwd">
						<h5>고객님의 개인정보를 안전하게 보호하기 위해<br/>비밀번호를 다시 한번 입력해 주세요.</h5>
						<div class="form">
							<input type="text" placeholder="비밀번호를 입력하세요.">
							<button type="submit" class="btn btn-md3 btn-black">확인</button>
						</div>
						<p class="alert">비밀번호가 다르게 입력되었습니다. 다시 입력해주세요.</p>
					</form>

				</div>
			</section>
			<!--// card List -->
			
		</article>
		<!--// Content -->
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
