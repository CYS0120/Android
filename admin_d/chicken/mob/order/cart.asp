<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="장바구니, BBQ치킨">
<meta name="Description" content="장바구니">
<title>장바구니 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
	$(document).on('click','.btn_sideChange',function(){
		$('.cart-fix').fadeIn(500);
		$('.menu-cart').fadeIn(500);
		$('html').addClass('fix');
	});
	$(document).on('click','.btn_menu_close',function(){
		$('.cart-fix').fadeOut(500);
		$('.menu-cart').fadeOut(500);
		$('html').removeClass('fix');
	});

	$(document).on('click','.delType',function(e){
		if($(this).parent().index() == 0){
			$('.delivery-wrap').show();
			$('.pickup-wrap').hide();
		}
		else if($(this).parent().index() == 1){
			$('.delivery-wrap').hide();
			$('.pickup-wrap').show();
		}
	});
});
</script>
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>장바구니</h1>
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

			<!-- 상단 배달정보 -->
			<section class="section section_cartSum">
				<dl>
					<dt>배달매장 :</dt>
					<dd><span class="red">구로점</span> <em>(02-123-4567)</em></dd>
				</dl>
				<dl class="address">
					<dt>배달주소 :</dt>
					<dd><span class="txt_overflow">서울특별시 관악구 난리로66 무슨서울특별시 관악구 난리로66 무슨</span> <button type="button" onclick="javascript:lpOpen('.lp_orderShipping');" class="btn btn-sm btn-grayLine btn_lp_open">변경</button></dd>
				</dl>
			</section>
			<!-- //상단 배달정보 -->

			<!-- 장바구니 리스트 -->
			<section class="section section_orderDetail pad-t0">

				<!--장바구니 비었을때-->
				<div class="cart_empty"><p>장바구니에 담긴 상품이 없습니다.</p></div>
				<!--//장바구니 비었을때-->

				<div class="order_menu">
					<div class="box div-table">
						<div class="tr">
							<div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
							<div class="td info">
								<div class="sum">
									<dl>
										<dt>황금 올리브 치킨</dt>
										<dd>18,000원 <span>/ 1개</span></dd>
									</dl>
									<dl>
										<dt>- NEW포테이토</dt>
										<dd>10,000원 <span>/ 2개</span></dd>
									</dl>
									<dl>
										<dt>- 무</dt>
										<dd>500원 <span>/ 1개</span></dd>
									</dl>
								</div>
								<div class="mar-t15 ta-r">
									<button type="button" class="btn btn-sm btn-brown btn_sideChange">사이드/수량변경</button>
								</div>
								<button type="button" class="btn_del">삭제</button>
							</div>
						</div>
					</div>
				</div>
				<div class="order_menu">
					<div class="box div-table">
						<div class="tr">
							<div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
							<div class="td info">
								<div class="sum">
									<dl>
										<dt>자메이카 + 올치팝(컵)</dt>
										<dd>18,000원 <span>/ 1개</span></dd>
									</dl>
								</div>
								<div class="mar-t15 ta-r">
									<button type="button" class="btn btn-sm btn-brown btn_sideChange">사이드/수량변경</button>
								</div>
								<button type="button" class="btn_del">삭제</button>
							</div>
						</div>
					</div>
				</div>

				<div class="mar-t40">
					<button type="button" class="btn btn-md btn-redLine w-100p">+ 다른 메뉴 추가하기</button>
				</div>

				<div class="order_calc">
					<div class="top div-table mar-t30">
						<dl class="tr">
							<dt class="td">총 상품금액
							</dt><dd class="td">18,000원</dd>
						</dl>
						<dl class="tr">
							<dt class="td">배달비
							</dt><dd class="td">2,000원</dd>
						</dl>
					</div>
					<div class="bot div-table">
						<dl class="tr">
							<dt class="td">합계</dt>
							<dd class="td">20,000<span>원</span></dd>
						</dl>
					</div>
				</div>

				<div class="mar-t40">
					<button type="submit" class="btn btn-lg btn-red w-100p">주문하기</button>
				</div>
			</section>
			<!-- //장바구니 리스트 -->

			<!-- Layer Popup : 배달지 입력 - 배달주문 -->
			<div id="LP_orderShipping" class="lp-wrapper lp_orderShipping">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>주문 방법 선택</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<form action="">

							<!-- 주문 타입 선택 -->
							<div class="inner">
								<ul class="order-moveType">
									<li>
										<label class="ui-radio delType">
											<input type="radio" name="moveType" checked>
											<span></span> 배달주문
										</label>
									</li>
									<li>
										<label class="ui-radio delType">
											<input type="radio" name="moveType">
											<span></span> 픽업주문
										</label>
									</li>
								</ul>
							</div>
							<!-- //주문 타입 선택 -->

							<!-- 배달 주문 -->
							<div class="delivery-wrap">
								<section class="section section_shipList mar-t40">
									<div class="box">
										<div class="name">
											<span class="red">[기본배달지]</span> 박하나
										</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>
									<div class="box">
										<div class="name">
											박둘
										</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
										</ul>
									</div>
									<div class="box">
										<div class="name">
											박셋
										</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>
								</section>
								<div class="btn-wrap inner mar-t40">
									<button type="submit" class="btn btn-lg btn-black w-100p">배달지 추가</button>
								</div>

								<div class="txt-basic inner mar-t20">
									- 배달지 관리는 마이페이지 &gt; 회원정보변경 &gt; 배달지관리에서 확인하실 수 있습니다.
								</div>
							</div>
							<!--// 배달 주문 -->

							<!-- 픽업 주문 -매장 찾기 전 -->
							<div class="pickup-wrap" style="display:none">
								<h4>픽업 매장</h4>
								<section class="section section_shipList">
									<p class="explain">픽업 매장 찾기를 통해 픽업가능한 매장을<br>선택해 주세요.</p>
								</section>
								<div class="btn-wrap inner mar-t40">
									<button type="button"  onclick="javascript:lpOpen('.lp_shopSearch');" class="btn btn-lg btn-black w-100p btn_lp_open">픽업 매장 찾기</button>
								</div>
							</div>
							<!--// 픽업 주문 -->

							<!-- 픽업 주문 매장 찾기 후 -->
							<div class="pickup-wrap" style="display:none">
								<h4>픽업 매장</h4>
								<section class="section section_shipList">
									<div class="box">
										<div class="name">신대방 1점</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-red w-100p">주문서 작성</button>
											</li>
										</ul>
									</div>
								</section>
								<div class="btn-wrap inner mar-t40">
									<button type="button"  onclick="javascript:lpOpen('.lp_shopSearch');" class="btn btn-lg btn-black w-100p btn_lp_open">픽업 매장 찾기</button>
								</div>
							</div>
							<!--// 픽업 주문 -->
						</form>
					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
			</div>
			<!--// Layer Popup -->

			<!-- Layer Popup : 배달지 입력 - 픽업주문(매장찾기) -->
			<div id="LP_orderShipping" class="lp-wrapper lp_shopSearch">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>매장 찾기</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<form action="">

							<!-- 검색 영역 -->
							<div class="inner">
								<div class="sch-wrap">
									<input type="text" class="sch-word">
									<button type="submit" class="btn-sch"><img src="/images/order/btn_search.png" alt="검색"></button>
								</div>
							</div>
							<!-- //검색 영역 -->

							<!-- 매장 리스트 -->
							<div class="shop-listWrap">
								<section class="section section_shipList mar-t40">
									<div class="box">
										<div class="name">신대방 1점</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>
									<div class="box">
										<div class="name">가산디지털단지점(올리브카페)</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>
								</section>
							</div>
							<!--// 배달 주문 -->
						</form>
					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
			</div>
			<!--// Layer Popup -->

			<!-- 메뉴 담기 -->
			<div class="menu-cart">
				<div class="sideMenu">
					<div class="wrap">
						<h3>소스</h3>
						<div class="area">

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>


							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
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
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
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
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>


							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
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
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>


							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

							<div class="box">
								<div class="img">
									<label>
										<input type="checkbox">
										<img src="http://placehold.it/88x88/ff3300"/>
									</label>
								</div>
								<div class="info">
									<p class="name">양념소스</p>
									<p class="pay">500원</p>
								</div>
							</div>

						</div>
					</div>
				</div>

				<div class="payment">
					<div class="addmenu">
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
							<dt>콜라</dt>
							<dd>
								<span class="form-pm">
									<button type="button" class="minus">-</button>
									<input type="text" value="1">
									<button type="button" class="plus">+</button>
								</span>
								<div class="mon">1,500원</div>
								<!--<button type="button" class="btn_del">삭제</button>-->
							</dd>
						</dl>
						<dl>
							<dt>콜라</dt>
							<dd>
								<span class="form-pm">
									<button type="button" class="minus">-</button>
									<input type="text" value="1">
									<button type="button" class="plus">+</button>
								</span>
								<div class="mon">1,500원</div>
								<!--<button type="button" class="btn_del">삭제</button>-->
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

				<button type="button" class="btn_menu_close">닫기</button>
			</div>
			<!-- //메뉴 담기 -->

			<!-- 장바구니 담기 -->
			<div class="cart-fix on display-n" style="transition:0s;">
				<button type="button" class="btn btn-md btn-red btn_menu_cart">장바구니 담기</button>
			</div>
			<!-- //장바구니 담기 -->


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
