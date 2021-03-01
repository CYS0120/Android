<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>비비큐카드 | BBQ치킨</title>
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "비비큐카드"
%>
	<!--#include virtual="/includes/header.asp"-->
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
			<section class="section section_cardList mar-t60">
				<div class="area">
					<div class="box">
						<div class="img"><img src="/images/mypage/@card1.png" alt=""><span class="money">￦<em>10,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">
							<a href="#" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<!-- <button type="button" onclick="javascript:alert('준비중입니다.');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button> -->
							<button type="button" onclick="javascript:lpOpen('.lp_cardGift');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>
						</div>
					</div>
					<div class="box">
						<div class="img"><img src="/images/mypage/@card2.png" alt=""><span class="money">￦<em>10,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">
							<a href="#" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="javascript:lpOpen('.lp_cardGift');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>
						</div>
					</div>
					<div class="box">
						<div class="img"><img src="/images/mypage/@card3.png" alt=""><span class="money">￦<em>10,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">
							<a href="#" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="javascript:lpOpen('.lp_cardGift');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>
						</div>
					</div>
				</div>
			</section>
			<!-- //사용가능카드 -->

			<!-- Layer Popup : 카드선물 -->
			<div id="LP_cardGift" class="lp-wrapper lp_cardGift">
				<form id="g_form" name="g_form" method="post">
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
													<dt>이름</dt>
													<dd>
														<input type="text" class="w-100p">
													</dd>
												</dl>
												<dl>
													<dt>전화번호</dt>
													<dd>
														<div class="ui-group-email">
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text"></span>
														</div>
													</dd>
												</dl>
												<dl>
													<dt>선물메시지</dt>
													<dd>
														<textarea name="" id="" class="w-100p h-280"></textarea>
													</dd>
												</dl>
											</div>
											
											<div class="btn-wrap two-up pad-t40 bg-white">
												<button type="button" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
												<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
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
				</form>
			</div>
			<!--// Layer Popup -->

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