<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>카드</h1>
		<div class="btn-header btn-header-nav">
			<button type="button" onClick="javascript:history.back();" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
			<button type="button" class="btn btn_header_menu"><span class="ico-only">메뉴</span></button>
		</div>
		<div class="btn-header btn-header-mnu">
			<button type="button" class="btn btn_header_cart"><span class="ico-only">장바구니</span></button>
			<button type="button" class="btn btn_header_brand"><span class="ico-only">패밀리브랜드</span></button>
		</div>
	</header>
	<!--// Header -->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content">

			<!-- 사용가능카드 -->
			<section class="section section_cardView">
				<div class="area">
					<div class="box">
						<div class="img"><a href="./cardView.asp"><img src="/images/mypage/@card.jpg" alt=""></a></div>
						<div class="txt">100,000원</div>
					</div>
				</div>
			</section>
			<!-- //사용가능카드 -->

			<section class="section section_cardUse mar-t60">
				<div class="section-header">
					<h3>이용내역</h3>
				</div>
				<div class="section-body">
					<!-- Order List -->
					<div class="area">
						<div class="box">
							<div class="top">
								<div class="lef"><span class="ico-branch red">비비큐치킨</span></div>
								<div class="rig">-18,000원</div>
							</div>
							<div class="mid">
								<div class="lef">
									<h4 class="prod">신대방점 주문사용</h4>
									<div class="date">2018.11.07</div>
								</div>
								<div class="rig">
									<a href="#" class="btn btn-sm btn-grayLine2">상세보기</a>
								</div>
							</div>
						</div>
						<div class="box">
							<div class="top">
								<div class="lef"><span class="ico-branch red">비비큐치킨</span></div>
								<div class="rig">-18,000원</div>
							</div>
							<div class="mid">
								<div class="lef">
									<h4 class="prod">신대방점 주문사용</h4>
									<div class="date">2018.11.07</div>
								</div>
								<div class="rig">
									<a href="#" class="btn btn-sm btn-grayLine2">상세보기</a>
								</div>
							</div>
						</div>
						<div class="box">
							<div class="top">
								<div class="lef"><img src="/images/mypage/ico_heart.png" alt=""></div>
								<div class="rig">-18,000원</div>
							</div>
							<div class="mid">
								<div class="lef w-100p">
									<h4 class="prod">카드구매 <em>- 어디서나 쉽게 사용해보세요</em></h4>
									<div class="date">2018.11.07</div>
								</div>
								<!-- <div class="rig">
									<a href="#" class="btn btn-sm btn-grayLine2">상세보기</a>
								</div> -->
							</div>
						</div>
					</div>
					<!--// Order List -->
				</div>
			</section>

			<!-- Button More -->
			<div class="btn-wrap mar-t20 inner">
				<a href="#" class="btn btn-md btn-black w-100p btn_list_more"><span>목록</span></a>
			</div>
			<!--// Button More -->


		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>