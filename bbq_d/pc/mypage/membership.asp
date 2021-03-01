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
				<li><a href="#">bbq home</a></li>
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
							<dd class="check">
								<div >
									<h4>CHECH.1 회원가입</h4>
									<p>BBQ 홈페이지 또는 모바일 앱에서 회원가입을 합니다.</p>
								</div>
								<div>
									<h4>CHECH.2 회원가입</h4>
									<p>포인트적립은 구매시점으로부터 24시간 이후 적립됩니다(영업일기준)<br>생일쿠폰은 가입 시 등록하신 생일 1달전에 발송됩니다</p>
								</div>
							</dd>
						</dl>
						<dl class="reserve">
							<dt><span class="ddack-mem">딹</span><span class="txt">포인트 적립 기준은 무엇인가요?</span></dt>
							<dd>
								<p>
									<span class="ddack">딹</span>포인트는 BBQ홈페이지, BBQ앱, BBQ가맹점 전화번호로 인입된 주문의 실 결제금액의 5%적립을 원칙으로 합니다.<br>(단, 주류, 음료, 배달서비스 결제금액은 제외됩니다)
								</p>
								<p>회원이BBQ어플리케이션/홈페이지가 아닌 다른 온라인주문채널(배달의민족, 요기요, 배달통 등)을 통해 주문을 하거나, 현금, 상품권, 신용카드 등을 통해 결제를 한 후 하나 이상의 적립카드와 기타의 할인카드 및 쿠폰을 제시하고 이중으로 포인트 누적 또는 할인을 요구 하거나,<br>할인 및 증정품(판촉물, 제품)제공 행사 참여시 적립을 요구했을 때, 기프티콘(e-coupon)으로 결제했을 때, 가맹점은 이를 거부할 수 있습니다.<br>이때 회원은 가맹점의 요구에 따라 <span class="ddack">딹</span> 멤버십포인트, 다른 온라인주문채널, 할인제도, 기프티콘 등 중 하나를 선택하여야 합니다. </p>
							</dd>
						</dl>
					</div>
					<div class="ddack-memInfo">
						<p class="validity">유효기간은 적립일로부터 12개월입니다.</p>
						<div class="use-box">
							<dl>
								<dt><span class="txt">적립된 </span><span class="ddack-mem">딹</span><span class="txt">포인트는 어떻게 사용하나요?</span></dt>
								<dd>회원님의 적립된 <span class="ddack">딹</span> 포인트가 1포인트 이상 부터 현금처럼 사용이 가능하며 BBQ 전 제품 모두 <span class="ddack">딹</span>포인트로 구매 가능합니다. </dd>
							</dl>
						</div>
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
