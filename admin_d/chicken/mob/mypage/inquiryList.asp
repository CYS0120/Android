<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="나의 상담내역, BBQ치킨">
<meta name="Description" content="나의 상담내역">
<title>나의 상담내역</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>나의 상담내역</h1>
		<div class="btn-header btn-header-nav">
			<button type="button" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
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
			<!-- Inquiry -->
			<section class="section-wrap section_inquiry">
	
				<h2 class="blind">상품문의</h2>

				<!-- Inquiry List -->
				<div class="inquiryList-wrap">
					<div class="btn-wrap">
						<button type="button" class="btn btn-md btn-red w-100p"><span>문의하기</span></button>
						<p class="explain">-문의하신 상담글은 수정, 삭제가 불가능합니다.</p>
					</div>

					<!-- 주문 내역 검색 -->
					<form class="form_selType mar-t40">
						<select name="" id="">
							<option value="">전체브랜드 보기</option>
						</select>
					</form>
					<!-- //주문 내역 검색 -->

					<ul class="inquiryList mar-t0">
						<li class="item">
							<a href="./inquiryView.asp" class="item-inquiry">
								<p class="mar-b10">
									<span class="ico-branch red">비비큐치킨</span>
								</p>
								<p class="subject">상품문의 드립니다</p>
								<div class="item-footer">
									<p class="date">작성일 : <span>2018-12-30</span></p>
									<span class="state">답변전</span>
								</div>
							</a>
						</li>
						<li class="item">
							<a href="./inquiryView.asp" class="item-inquiry">
								<p class="mar-b10">
									<span class="ico-branch orange">올떡</span>
								</p>
								<p class="subject">상품문의 드립니다</p>
								<div class="item-footer">
									<p class="date">작성일 : <span>2018-12-30</span></p>
									<span class="state">답변전</span>
								</div>
							</a>
						</li>
						<li class="item">
							<a href="./inquiryView.asp" class="item-inquiry">
								<p class="mar-b10">
									<span class="ico-branch yellow">비비큐몰</span>
								</p>
								<p class="subject">상품문의 드립니다</p>
								<div class="item-footer">
									<p class="date">작성일 : <span>2018-12-30</span></p>
									<span class="state">답변전</span>
								</div>
							</a>
						</li>
					</ul>
				</div>
				<!--// Inquiry List -->
				<!-- Button More -->
				<div class="btn-wrap mar-t20">
					<button type="button" class="btn btn-md btn-grayLine w-100p btn_list_more"><span>더보기</span></button>
				</div>
				<!--// Button More -->

			</section>
			<!-- Inquiry -->
				
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
