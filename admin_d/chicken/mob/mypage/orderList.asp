<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="주문내역, BBQ치킨">
<meta name="Description" content="주문내역">
<title>주문내역 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>주문내역</h1>
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

			<!-- 주문 내역 검색 -->
			<form class="form_orderSel">
				<select name="" id="">
					<option value="">전체브랜드 보기</option>
				</select>
			</form>
			<!-- //주문 내역 검색 -->

			<!-- 주문 내역 출력 -->
			<section class="section">

				<ul class="orderList orderList_item">
					<li class="item">
						<a href="./orderView.asp" class="item-order">
							<div class="item-header">
								<span class="branch ico-branch red">비비큐치킨</span>
								<span class="orderDate"><strong>신대방점</strong> <em>|</em> <strong>2018.11.29</strong></span>
							</div>
							<h4 class="prod">자메이카 통다리 구이 <em>외 4개</em></h4>
							<div class="price"><span>17,380</span>원</div>
						</a>
						<div class="btn-wrap">
							<ul class="in-sec">
								<li class="btn_1"><a href="#this"><img src="/images/mypage/ico_order_basic.png" alt=""> <span class="red">일반주문</span></a></li>
								<li class="btn_2"><a href="#this"><img src="/images/mypage/ico_order_ok.png" alt=""> <span>배송완료</span></a></li>
								<li class="btn_3"><a href="./orderView.asp" class="btn btn-sm btn-grayLine">상세보기</a></li>
							</ul>
						</div>
					</li>
					<li class="item">
						<a href="./orderView.asp" class="item-order">
							<div class="item-header">
								<span class="branch ico-branch red">비비큐치킨</span>
								<span class="orderDate"><strong>신대방점</strong> <em>|</em> <strong>2018.11.29</strong></span>
							</div>
							<h4 class="prod">자메이카 통다리 구이 <em>외 4개</em></h4>
							<div class="price"><span>17,380</span>원</div>
						</a>
						<div class="btn-wrap">
							<ul class="in-sec">
								<li class="btn_1"><a href="#this"><img src="/images/mypage/ico_order_basic.png" alt=""> <span class="red">일반주문</span></a></li>
								<li class="btn_2"><a href="#this"><img src="/images/mypage/ico_order_no.png" alt=""> <span>주문취소</span></a></li>
								<li class="btn_3"><a href="./orderView.asp" class="btn btn-sm btn-grayLine">상세보기</a></li>
							</ul>
						</div>
					</li>
					<li class="item">
						<a href="./orderView.asp" class="item-order">
							<div class="item-header">
								<span class="branch ico-branch yellow">비비큐몰</span>
								<span class="orderDate"><strong>2018.11.29</strong></span>
							</div>
							<h4 class="prod">자메이카 통다리 구이 <em>외 4개</em></h4>
							<div class="price"><span>17,380</span>원</div>
						</a>
						<div class="btn-wrap">
							<ul class="in-sec">
								<li class="btn_1"><a href="#this"><img src="/images/mypage/ico_order_pick.png" alt=""> <span class="red">픽업주문</span></a></li>
								<li class="btn_2"><a href="#this"><img src="/images/mypage/ico_order_no.png" alt=""> <span>주문취소</span></a></li>
								<li class="btn_3"><a href="./orderView.asp" class="btn btn-sm btn-grayLine">상세보기</a></li>
							</ul>
						</div>
					</li>
					<li class="item">
						<a href="./orderView.asp" class="item-order">
							<div class="item-header">
								<span class="branch ico-branch red">비비큐치킨</span>
								<span class="orderDate"><strong>신대방점</strong> <em>|</em> <strong>2018.11.29</strong></span>
							</div>
							<h4 class="prod">자메이카 통다리 구이 <em>외 4개</em></h4>
							<div class="price"><span>17,380</span>원</div>
						</a>
						<div class="btn-wrap">
							<ul class="in-sec">
								<li class="btn_1"><a href="#this"><img src="/images/mypage/ico_order_tb.png" alt=""> <span class="red">택배주문</span></a></li>
								<li class="btn_2"><a href="#this"><img src="/images/mypage/ico_order_ok.png" alt=""> <span>배송완료</span></a></li>
								<li class="btn_3"><a href="./orderView.asp" class="btn btn-sm btn-grayLine">상세보기</a></li>
							</ul>
						</div>
					</li>
				</ul>

			</section>
			<!-- //주문 내역 출력 -->

			<!-- Button More -->
			<div class="btn-wrap mar-t20 inner">
				<button type="button" class="btn btn-md btn-grayLine w-100p btn_list_more"><span>더보기</span></button>
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