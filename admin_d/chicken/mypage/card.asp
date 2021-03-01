<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/admin_d/chicken/includes/meta.asp"-->
<meta name="Keywords" content="비비큐카드, BBQ치킨">
<meta name="Description" content="비비큐카드">
<title>비비큐카드 | BBQ치킨</title>
<!--#include virtual="/admin_d/chicken/includes/styles.asp"-->
<!--#include virtual="/admin_d/chicken/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
});
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/admin_d/chicken/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="#">bbq home</a></li>
				<li>비비큐카드</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			
			<section class="section">
				<div class="section-header">
					<h3>비비큐카드</h3>
				</div>
				<div class="section-body">
					<div class="card-list">
						<div class="box">
							<div class="img"><img src="/admin_d/chicken/images/mypage/@card1.png" alt=""><span class="money">￦<em>10,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box">
							<div class="img"><img src="/admin_d/chicken/images/mypage/@card2.png" alt=""><span class="money">￦<em>20,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box">
							<div class="img"><img src="/admin_d/chicken/images/mypage/@card3.png" alt=""><span class="money">￦<em>30,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box">
							<div class="img"><img src="/admin_d/chicken/images/mypage/@card4.png" alt=""><span class="money">￦<em>40,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box blackBox">
							<div class="img"><a href="#popup" class="popup" onclick="javascript:lpOpen('.lp_cardadd');"><img src="/images/mypage/plus.png" alt=""></a></div>
						</div>
					</div>
				</div>
			</section>

			
			<!-- Layer Popup : 카드 선물하기 -->
			<div id="lp_cardGiftPop" class="lp-wrapper lp_cardGiftPop">
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
										<table border="1" cellspacing="0" class="tbl-member black-line">
											<caption>정보입력</caption>
											<colgroup>
												<col style="width:170px;">
												<col style="width:auto;">
											</colgroup>
											<tbody>
												<tr>
													<th>이름</th>
													<td>
														<input type="text" class="w-150">
													</td>
												</tr>
												<tr>
													<th>휴대전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>선물메세지</th>
													<td>
														<textarea name="" id="" class="w-100p h-150"></textarea>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>결제하기</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
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

			<!--card 등록 popup-->
			<div class="mask"></div>
			<div class="window">
				
				<div class="sitemap_wrap">
					<!--content-->
					<div class="popup_area">
						<form action="">
							<div class="popup_title">
								<span>카드정보</span>
								<a href="/admin_d/chicken/card.asp" class="close"><img src="/admin_d/chicken/images/mypage/close.png" alt=""></a>
							</div>
							<table>
								<!--<colgroup>
									<col width="30%">
									<col width="70%">
								</colgroup-->
								<tr>
									<th>카드번호</th>
									<td><input type="text" value="숫자 16 또는 18자리만 입력" maxlength="18"></td>
								</tr>
								<tr>
									<th>PIN 번호</th>
									<td><input type="text" value="숫자 7자리 입력" maxlength="7"></td>
								</tr>
							</table>
							<div class="popup_btn">
								<input type="submit" value="등록하기" class="btn_red125">
							</div>
						</form>
					</div>
					<!--//content-->
				</div>
			</div>
			<!--//card 등록 popup-->


		</article>
		<!--// Content -->
		
		<!-- QuickMenu -->
		<!--#include virtual="/admin_d/chicken/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/admin_d/chicken/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
