<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지 메인">
<title>마이페이지 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>마이페이지</h1>
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
		<article class="content content-gray">

			<div class="section-wrap">
				<!-- Membership Info -->
				<section class="section section_membership">
					<h3 class="blind">나의 쇼핑정보</h3>
					<div class="section-body inner">

						<div class="memGrade gold"><!-- silver, bronze -->
							<p><strong>박아람</strong>님 안녕하세요!</p>
							<p class="txt">세상에서 가장 건강하고 맛잇는 치킨 bbq 입니다.</p>
							<p class="mar-t15"><a href="#" class="btn btn-sm btn-grayLine">회원정보 변경</a></p>
						</div>

						<!-- 치킨캠프 -->
						<div class="ckcamp">
							<a href="#"><span>치킨캠프 신청내역 확인하기</span></a>
						</div>
						<!-- //치킨캠프 -->


						<div class="myInfo-wrap">
							<ul class="myInfo">
								<li onclick="location.href='/mypage/couponList.asp'">
									<dl class="item-info item_cupon">
										<dt>쿠폰</dt>
										<dd>
											<div class="count"><span>1</span>장</div>
											<!-- <a href="#" class="link-go">쿠폰 등록하기</a> -->
										</dd>
									</dl>
								</li>
								<li onclick="location.href='/mypage/mileage.asp'">
									<dl class="item-info item_point">
										<dt>포인트</dt>
										<dd>
											<div class="count"><span>17,380</span>P</div>
										</dd>
									</dl>
								</li>
								<li onclick="location.href='/mypage/cardList.asp'">
									<dl class="item-info item_card">
										<dt>카드</dt>
										<dd>
											<div class="count"><span>2</span>장</div>
										</dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
					<div class="btn-wrap mar-t20">
						<div class="inner">
							<a type="href" class="btn btn-md btn-grayLine2 w-100p btn-arr"><em class="ddack">딹</em><span>멤버십 안내</span></a>
						</div>
					</div>
				</section>
				<!--// Membership Info -->

				<!-- Recent Order -->
				<section class="section section_recentOrder">
					<div class="section-header">
						<h3>주문내역</h3>
						<div class="rig"><a href="#" class="more">더보기</a></div>
					</div>
					<div class="section-body">
						<!-- Order List -->
						<div class="orderList-wrap">
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
						</div>
						<!--// Order List -->
						<!-- Button More -->
						<div class="btn-wrap mar-t20 inner">
							<button type="button" class="btn btn-md btn-grayLine w-100p btn_list_more"><span>더보기</span></button>
						</div>
						<!--// Button More -->
					</div>
				</section>
				<!--// Recent Order -->
			</div>

			<!-- 문의내역 -->
			<div class="section-wrap">
				<section class="section section_mypageInq">
					<div class="section-header">
						<h3>주문내역</h3>
						<div class="rig"><a href="#" class="more">더보기</a></div>
					</div>
					<div class="inquiryList-wrap inner">
						<ul class="inquiryList mar0">
							<li class="item">
								<a href="#this" class="item-inquiry">
									<p class="mar-b15"><span class="ico-branch red">비비큐치킨</span></p>
									<p class="subject">상품문의 드립니다</p>
									<div class="item-footer">
										<p class="date">작성일 : <span>2018-12-30</span></p>
										<span class="state">답변전</span>
									</div>
								</a>
							</li>
							<li class="item">
								<a href="#this" class="item-inquiry">
									<p class="mar-b15"><span class="ico-branch red">비비큐치킨</span></p>
									<p class="subject">상품문의 드립니다</p>
									<div class="item-footer">
										<p class="date">작성일 : <span>2018-12-30</span></p>
										<span class="state">답변전</span>
									</div>
								</a>
							</li>
							<li class="item complete">
								<a href="#this" class="item-inquiry">
									<p class="mar-b15"><span class="ico-branch orange">올떡</span></p>
									<p class="subject">상품문의 드립니다</p>
									<div class="item-footer">
										<p class="date">작성일 : <span>2018-12-30</span></p>
										<span class="state">답변완료</span>
									</div>
								</a>
							</li>
						</ul>
					</div>
				</section>
			</div>
			<!--// 문의내역 -->

			<!-- Support -->
			<div class="section-wrap">
				<section class="section section_support">
					<ul class="support">
						<li><a href="/customer/faqList.asp">자주하는질문</a></li>
						<li><a href="/customer/inquiryWrite.asp">고객의소리</a></li>
						<li><a href="#">e-쿠폰 등록</a></li>
						<li><a href="/mypage/membership.asp">멤버십 안내</a></li>
					</ul>
				</section>
			</div>
			<!--// Support -->

			<!-- Call Center -->
			<section class="section section_callCenter">
				<div class="inner">
					<dl class="callCenter">
						<dt>고객센터</dt>
						<dd>
							<div class="callNumber">080-3436-0507</div>
							<div class="openTime">운영시간 10:00~18:00 (토요일, 공휴일은 휴무)</div>
						</dd>
					</dl>
				</div>
			</section>
			<!--// Call Center -->

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
