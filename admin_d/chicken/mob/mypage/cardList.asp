<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/admin_d/chicken/mob/includes/meta.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
<!--#include virtual="/admin_d/chicken/mob/includes/styles.asp"-->
<!--#include virtual="/admin_d/chicken/mob/includes/scripts.asp"-->
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
		<!--#include virtual="/admin_d/chicken/mob/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content">

			<!-- 사용가능카드 -->
			<section class="section section_cardList mar-t60">
				<div class="section-header coupon_head">
					<h3>사용 가능한 쿠폰 <strong class="yellow">3</strong>장</h3>
				</div>
				<div class="area">
					<div class="box">
						<div class="img"><a href="/admin_d/chicken/mob/cardView.asp"><img src="/admin_d/chicken/mob/images/mypage/@card1.png" alt=""></a></div>
						<div class="txt">100,000원</div>
					</div>
					<div class="box">
						<div class="img"><a href="/admin_d/chicken/mob/cardView.asp"><img src="/admin_d/chicken/mob/images/mypage/@card2.png" alt=""></a></div>
						<div class="txt">100,000원</div>
					</div>
					<div class="box">
						<div class="img"><a href="/admin_d/chicken/mob/cardView.asp"><img src="/admin_d/chicken/mob/images/mypage/@card3.png" alt=""></a></div>
						<div class="txt">사용완료</div>
					</div>
					<div class="box">
						<div class="img blankBox" onclick="javascript:lpOpen('.lp_cardadd');"><a href="#popup"><img src="/admin_d/chicken/mob/images/mypage/plus.png" alt=""></a></div>
						<div class="txt">선물받은 카드를 등록하세요.</div>
					</div>
				</div>

				<!-- Layer Popup : 카드선물 -->
				<div id="LP_cardGift" class="lp-wrapper lp_cardadd">
					<!-- LP Wrap -->
					<div class="lp-wrap">
						<div class="lp-con">
							<!-- LP Header -->
							<div class="lp-header">
								<h2>카드 선물하기</h2>
							</div>
							<!--// LP Header -->
							<!-- LP Container -->
							<div class="lp-container">
								<!-- LP Content -->
								<div class="lp-content">
									<section class="section">
										<form action="">
											<div class="inner">
												<div class="card_giftPop">
													<dl>
														<dt>카드번호</dt>
														<dd>
															<input type="text" value="숫자 16 또는 18자리만 입력" maxlength="18" class="w-100p">
														</dd>
													</dl>
												</div>
												<div class="alert">
													<span>* 카드 등록 후 적립한 포인트가 보이기까지는 최대 5분의 시간지연이 있을 수 있습니다.</span>
													<span>* 5회이상 잘못 입력하신 경우 24시간 후 재등록 가능합니다.</span>
												</div>
												<div class="btn-wrap two-up pad-t40 bg-white">
													<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>등록하기</span></button>
												</div>
											</div>
										</form>
									</section>
								</div>
								<!--// LP Content -->
							</div>
							<!--// LP Container -->
							<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
						</div>
					</div>
					<!--// LP Wrap -->
				</div>
				<!--// Layer Popup -->
			</section>
			<!-- //사용가능카드 -->

			

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!--#include virtual="/admin_d/chicken/mob/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>