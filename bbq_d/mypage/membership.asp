<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지">
<title>마이페이지 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
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
				<li>bbq home</li>
				<li>마이페이지</li>
			</ul>
		</div>
		<!--// BreadCrumb -->

		<!-- Content -->
		<article class="content">
			<h1>마이페이지</h1>
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

			<!-- 딹 멤버십 안내  -->
			<section class="section">
				<div class="section-header">
					<h3><span class="ddack">딹</span> 멤버십 안내</h3>
				</div>
				<div class="section-body">
					<div class="ddack-memFAQ">
						<dl class="benefit">
							<dt><span class="ddack-mem">딹</span><span class="txt">멤버십회원의 혜택?</span></dt>
							<dd>구매금액의 5% 포인트 적립 / 이벤트 및 쿠폰 등의 다양한 서비스를 제공 받으실 수 있습니다.</dd>
						</dl>
						<dl class="join">
							<dt><span class="ddack-mem">딹</span><span class="txt">멤버십에 가입하려면?</span></dt>
							<dd>BBQ 홈페이지 또는 모바일 앱에서 회원가입을 합니다.</dd>
						</dl>
						<dl class="reserve">
							<dt><span class="ddack-mem">딹</span><span class="txt">포인트 적립 기준은 무엇인가요?</span></dt>
							<dd>
								<p>
									<span class="ddack">딹</span>포인트는 BBQ홈페이지, BBQ앱으로 인입된 주문의 실 결제금액의 5%적립을 원칙으로 합니다.<br>(단, 주류, 음료, 배달서비스 결제금액은 제외되며, 타 프로모션이나 할인행사와 중복적용은 제한됩니다)
								</p>
							</dd>
						</dl>
					</div>
					<div class="ddack-memInfo">
						<p class="validity">유효기간은 적립일로부터 12개월입니다.</p>
						<p class="validity_txt">※ 포인트적립은 구매시점으로부터 최소 72시간 최대 1주일이내 적립됩니다(영업일기준)</p>
						
					</div>

				</div>
			</section>
			<!--// 딹 메버십 안내 -->

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
