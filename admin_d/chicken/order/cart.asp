<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="장바구니, BBQ치킨">
<meta name="Description" content="장바구니 메인">
<title>장바구니 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<link rel="stylesheet" href="/common/css/main.css">
<link rel="stylesheet" href="/common/css/animate.css">
<link rel="stylesheet" href="/common/css/mscrollbar.css">
<!--#include virtual="/includes/scripts.asp"-->
<script src="/common/js/libs/jquery.bxslider.js"></script>
<script src="/common/js/libs/mscrollbar.js"></script>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});


	// scrollbar
	$(".mCustomScrollbar").mCustomScrollbar({
		horizontalScroll:false,
		theme:"light",
		mouseWheelPixels:300,
		advanced:{
			updateOnContentResize: true
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
		
		<!-- Content -->
		<article class="content">
	
			<!-- 주문단계 -->
			<section class="section section-orderStep">
				<ul>
					<li class="step1 on"><span>01 장바구니</span></li>
					<li class="step2"><span>02 주문/결제</span></li>
					<li class="step3"><span>03 주문완료</span></li>
				</ul>
			</section>
			<!-- //주문단계 -->

			<h1>장바구니</h1>

			<!-- 상단 배달정보 -->
			<section class="section section_cartSum">
				<ul>
					<li>
						<strong>배달매장 :</strong>
						<span class="red">구로점</span>
						<span>(02-123-4567)</span>
					</li>
					<li>
						<strong>배달비 :</strong>
						<span>2,000원</span>
					</li>
					<li>
						<strong>배달주소 :</strong>
						<span>서울특별시 관악구 난리로66 무슨빌딩 5층</span>
					</li>
				</ul>
				<a href="#" class="btn btn-sm btn-gray">변경</a>
			</section>
			<!-- //상단 배달정보 -->

			<!-- 장바구니 테이블 -->
			<table border="1" cellspacing="0" class="tbl-cart">
				<caption>장바구니</caption>
				<colgroup>
					<col style="width:50px;">
					<col style="width:141px;">
					<col>
					<col style="width:200px;">
					<col style="width:180px;">
				</colgroup>
				<thead>
					<tr>
						<th><label class="ui-checkbox no-txt"><input type="checkbox"><span></span></label></th>
						<th colspan="2">상품정보</th>
						<th>상품금액</th>
						<th>변경</th>
					</tr>
				</thead>
				<tbody>
					<!--장바구니에 담긴 상품 없을때-->
					<tr>
						<td colspan="5" class="empty">장바구니에 담긴 상품이 없습니다.</td>
					</tr>
					<!--//장바구니에 담긴 상품 없을때-->
					<tr>
						<td class="chk"><label class="ui-checkbox no-txt"><input type="checkbox"><span></span></label></td>
						<td class="img">
							<a href="#"><img src="http://placehold.it/120x120"/></a>
						</td>
						<td class="info ta-l">
							<div class="pdt-info div-table">
								<dl class="tr">
									<dt class="td">황금 올리브 치킨</dt>
									<dd class="td pm">
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
									</dd>
									<dd class="td sum">18,000원</dd>
								</dl>
								<dl class="tr">
									<dt class="td">황금 올리브 치킨</dt>
									<dd class="td pm">
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
									</dd>
									<dd class="td sum">1,000원</dd>
								</dl>
							</div>
						</td>
						<td class="pay">28,500원</td>
						<td><button type="button" class="btn btn-sm btn-grayLine" onclick="javascript:lpOpen('.lp_sideChange');">사이드 변경</button></td>
					</tr>
					<tr>
						<td class="chk"><label class="ui-checkbox no-txt"><input type="checkbox"><span></span></label></td>
						<td class="img">
							<a href="#"><img src="http://placehold.it/120x120"/></a>
						</td>
						<td class="info ta-l">
							<div class="pdt-info div-table">
								<dl class="tr">
									<dt class="td">황금 올리브 치킨</dt>
									<dd class="td pm">
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
									</dd>
									<dd class="td sum">18,000원</dd>
								</dl>
								<dl class="tr">
									<dt class="td">황금 올리브 치킨</dt>
									<dd class="td pm">
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
									</dd>
									<dd class="td sum">1,000원</dd>
								</dl>
								<dl class="tr">
									<dt class="td">황금 올리브 치킨</dt>
									<dd class="td pm">
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
									</dd>
									<dd class="td sum">1,000원</dd>
								</dl>
								<dl class="tr">
									<dt class="td">황금 올리브 치킨</dt>
									<dd class="td pm">
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
									</dd>
									<dd class="td sum">1,000원</dd>
								</dl>
							</div>
						</td>
						<td class="pay">28,500원</td>
						<td><button type="button" class="btn btn-sm btn-grayLine" onclick="javascript:lpOpen('.lp_sideChange');">사이드 변경</button></td>
					</tr>
				</tbody>
			</table>
			<!-- //장바구니 테이블 -->

			<!-- 장바구니 하단 정보 -->
			<div class="cart-botInfo div-table">
				<div class="tr">
					<div class="td lef">
						<button type="button" class="btn btn-sm btn-grayLine">선택삭제</button>
						<button type="button" class="btn btn-sm btn-grayLine">전체삭제</button>
					</div>
					<div class="td rig">
						<span>총 상품금액</span>
						<strong>18,000</strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_plus.png" alt=""></em>
						<span>배달비</span>
						<strong>2,000</strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_equal.png" alt=""></em>
						<span>합계</span>
						<strong class="red">50,000</strong>
						<span>원</span>
					</div>
				</div>
			</div>
			<!-- //장바구니 하단 정보 -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="#" class="btn btn-lg btn-redLine"><span>다른메뉴 더보기</span></a>
				<button type="submit" class="btn btn-lg btn-red"><span>주문하기</span></button>
			</div>

			<!-- Layer Popup : Member Secssion -->
			<div id="lp_sideChange" class="lp-wrapper lp_sideChange">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>사이드 변경</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">

								<div class="menu-cart">
									<div class="inner">
										<div class="left mCustomScrollbar">

											<div class="in-sec">
												<div class="wrap">
													<h3>소스</h3>
													<div class="area">
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
													</div>
												</div>
												
												<div class="wrap">
													<h3>무</h3>
													<div class="area">
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
													</div>
												</div>

												<div class="wrap">
													<h3>음료/주류</h3>
													<div class="area">
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
													</div>
												</div>

												<div class="wrap">
													<h3>사이드메뉴</h3>
													<div class="area">
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
														<div class="box">
															<div class="img">
																<label class="ui-checkbox">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="http://placehold.it/88x88"/>
															</div>
															<div class="info">
																<p class="name">양념소스<span>(딥치즈)</span></p>
																<p class="pay">500원</p>
															</div>
														</div>
												
													</div>
												</div>
											</div>

										</div>
										<div class="right">
											<div class="addmenu mCustomScrollbar">
												<dl>
													<dt>자메이카 통다리 구이</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">19,500원</div>
													</dd>
												</dl>
												<dl>
													<dt>콜라 355ml</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">1,500원</div>
													</dd>
												</dl>
												<dl>
													<dt>콜라 355ml</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">1,500원</div>
													</dd>
												</dl>
												<dl>
													<dt>콜라 355ml</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">1,500원</div>
													</dd>
												</dl>
												<dl>
													<dt>콜라 355ml</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">1,500원</div>
													</dd>
												</dl>
												<dl>
													<dt>콜라 355ml</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">1,500원</div>
													</dd>
												</dl>
												<dl>
													<dt>콜라 355ml</dt>
													<dd>
														<span class="form-pm">
															<button type="button" class="minus">-</button>
															<input type="text" value="1">
															<button type="button" class="plus">+</button>
														</span>
														<div class="mon">1,500원</div>
													</dd>
												</dl>
											</div>
											<div class="calc">
												<div class="top">
													<dl>
														<dt>주문금액</dt>
														<dd>19,500원</dd>
													</dl>
													<dl>
														<dt>추가금액</dt>
														<dd>5,500원</dd>
													</dl>
												</div>
												<div class="bot">
													<dl>
														<dt>결제금액</dt>
														<dd>24,500원</dd>
													</dl>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="btn-wrap two-up mar-t30">
									<button type="submit" class="btn btn-lg btn-red"><span>변경</span></button>
									<button type="button" class="btn btn-lg btn-grayLine"><span>취소</span></button>
								</div>

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
