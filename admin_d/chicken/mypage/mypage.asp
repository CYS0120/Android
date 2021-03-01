<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지">
<title>마이페이지 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
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
				<div class="myInfo-wrap">
					<div class="myInfo-membership">
						<div class="myInfo-memGrade">
							<p class="memGrade"><strong>박아람</strong>님 안녕하세요!</p>
							<p class="memTxt">세상에서 가장 건강하고 맛잇는 치킨 bbq 입니다.</p>
							<div class="btn-wrap">
								<button type="button" class="btn btn-sm2 btn-grayLine"><span>회원정보 변경</span></button>
								<button type="button" class="btn btn-sm2 btn-black mar-l10"><span>치킨캠프 신청내역</span></button>
							</div>
						</div>
						<!-- <div class="myInfo-inquiry">
							<dl class="itemInfo">
								<dt>1:1 문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
							<dl class="itemInfo">
								<dt>상품문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
						</div> -->
					</div>
					<div class="myInfo-shopping">
						<dl class="itemInfo itemInfo-point" onclick="location.href='/mypage/mileage.asp'">
							<dt>포인트</dt>
							<dd>
								<div class="count"><span>17,380</span>P</div>
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-coupon" onclick="location.href='/mypage/couponList.asp'">
							<dt>쿠폰</dt>
							<dd>
								<div class="count"><span>1</span>장</div>
								<!-- <a href="#" class="link-go">쿠폰 등록하기</a> -->
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-card" onclick="location.href='/mypage/cardList.asp'">
							<dt>카드</dt>
							<dd>
								<div class="count"><span>2</span>장</div>
							</dd>
						</dl>
					</div>
				</div>
				<!--// My Info -->
				<!-- My Menu -->
				<div class="myMenu-wrap on">
					<ul class="myMenu">
						<li><a href="/mypage/orderList.asp">주문내역</a></li>
						<li><a href="/mypage/couponList.asp">쿠폰</a></li>
						<li><a href="/mypage/mileage.asp">포인트</a></li>
						<li><a href="/mypage/cardList2.asp">카드</a></li>
						<li><a href="/mypage/inquiryList.asp">문의내역</a></li>
						<li><a href="/mypage/membership.asp"><span class="ddack">딹</span> 멤버십 안내</a>							
						</li>
					</ul>
				</div>
				<!--// My Menu -->
			</section>
			<!--// Membership -->

			<!-- 주문내역 -->
			<section class="section">
				<div class="section-header">
					<h3>주문내역</h3>
					<a href="#" class="btn_more btn btn-sm btn-grayLine">더보기</a>
				</div>
				<div class="section-body">

					<table border="1" cellspacing="0" class="tbl-order">
						<caption>장바구니</caption>
						<colgroup>
							<col style="width:170px;">
							<col style="width:90px;">
							<col>
							<col style="width:140px;">
							<col style="width:140px;">
							<col style="width:140px;">
							<col style="width:140px;">
						</colgroup>
						<thead>
							<tr>
								<th>주문일/주문번호</th>
								<th colspan="2">상품정보</th>
								<th>결제금액</th>
								<th>배달정보</th>
								<th>주문매장</th>
								<th>주문상태</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									2018.12.12<br/>
									<p class="orderNum">BBQ00001565077</p>
									<a href="#" class="btn btn-sm btn-grayLine">주문상세보기</a>
								</td>
								<td class="img">
									<a href="#"><img src="http://placehold.it/80x80"></a>
								</td>
								<td class="info ta-l">
									<p class="icon">
										<span class="ico-branch yellow">비비큐몰</span>
									</p>
									<p class="menuName">BBQ 매콤달콤 닭날개 구이 <span>외 10개</span></p>
								</td>
								<td>25,000원</td>
								<td>일반주문</td>
								<td>구로점<br/>02-858-9292</td>
								<td>배달완료</td>
							</tr>
							<tr>
								<td>
									2018.12.12<br/>
									<p class="orderNum">BBQ00001565077</p>
									<a href="#" class="btn btn-sm btn-grayLine">주문상세보기</a>
								</td>
								<td class="img">
									<a href="#"><img src="http://placehold.it/80x80"></a>
								</td>
								<td class="info ta-l">
									<p class="icon">
										<span class="ico-branch red">비비큐 치킨</span>
									</p>
									<p class="menuName">BBQ 매콤달콤 닭날개 구이 <span>외 10개</span></p>
								</td>
								<td>25,000원</td>
								<td>일반주문</td>
								<td>구로점<br/>02-858-9292</td>
								<td>
									배송중
									<p class="mar-t5">
										<a href="#" class="btn btn-sm btn-brown">배송조회</a>
									</p>
								</td>
							</tr>
						</tbody>
					</table>

				</div>
			</section>
			<!--// 주문내역 -->

			<!-- 문의내역 -->
			<section class="section mar-t100">
				<div class="section-header">
					<h3>문의내역</h3>
					<a href="#" class="btn_more btn btn-sm btn-grayLine">더보기</a>
				</div>
				<div class="section-body">

					<table border="1" cellspacing="0" class="tbl-list">
						<caption>상품문의</caption>
						<colgroup>
							<col style="width:106px;">
							<col style="width:auto;">
							<col style="width:180px;">
							<col style="width:150px;">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>작성일</th>
								<th>조회</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="#">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
								</td>
								<td>2018-12-20</td>
								<td><span>답변전</span></td>
							</tr>
							<tr>
								<td>1</td>
								<td class="ta-l">
									<span class="ico-branch orange mar-r10">올떡</span>
									<a href="#">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
								</td>
								<td>2018-12-20</td>
								<td><span class="red">답변완료</span></td>
							</tr>
							<tr>
								<td>1</td>
								<td class="ta-l">
									<span class="ico-branch yellow mar-r10">비비큐몰</span>
									<a href="#">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
								</td>
								<td>2018-12-20</td>
								<td><span class="red">답변완료</span></td>
							</tr>
						</tbody>
					</table>

				</div>
			</section>
			<!--// 문의내역 -->

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
