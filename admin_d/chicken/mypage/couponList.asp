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
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
				<li><a href="#" onclick="javascript:return false;">마이페이지</a></li>
				<li>쿠폰</li>
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
						<div class="myInfo-memGrade silver">
							<p class="memGrade"><strong>박아람</strong>님 안녕하세요!</p>
							<p class="memTxt">세상에서 가장 건강하고 맛잇는 치킨 bbq 입니다.</p>
							<div class="btn-wrap">
								<button type="button" class="btn btn-sm2 btn-grayLine"><span>개인정보 변경</span></button>
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
						<li class="on"><a href="/mypage/couponList.asp">쿠폰</a></li>
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
		
			<!-- 문의내역 -->
			<section class="section">
				<div class="section-header">
					<h3>쿠폰</h3>
					<div class="right">
						<div class="txt-basic16">
							사용 가능한 쿠폰 <span class="orange fs20">3</span>장
						</div>
					</div>
				</div>
				<div class="section-body">

					<table border="1" cellspacing="0" class="tbl-list">
						<caption>쿠폰리스트</caption>
						<colgroup>
							<col>
							<col style="width:180px;">
							<col style="width:130px;">
							<col style="width:250px;">
							<col style="width:120px;">
						</colgroup>
						<thead>
							<tr>
								<th>쿠폰명</th>
								<th>사용조건</th>
								<th>사용처</th>
								<th>유효기간</th>
								<th>남은일자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="#" onclick="javascript:return false;">제너시스 BBQ 통합회원 개인정보 처리방침 개정안내</a>
								</td>
								<td>황금올리브 치킨 주문</td>
								<td>PC/모바일</td>
								<td>2018-12-01 ~ 2018-12-31</td>
								<td><strong class="black">D -15</strong></td>
							</tr>
							<tr>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="#" onclick="javascript:return false;">제너시스 BBQ 통합회원 개인정보 처리방침 개정안내</a>
								</td>
								<td>황금올리브 치킨 주문</td>
								<td>PC/모바일</td>
								<td>2018-12-01 ~ 2018-12-31</td>
								<td><strong class="black">D -15</strong></td>
							</tr>
						</tbody>
					</table>

					<div class="board-pager-wrap">
						<div class="board-pager">
							<a href="#" onclick="javascript:return false;" class="board-nav btn_first">처음</a>
							<a href="#" onclick="javascript:return false;" class="board-nav btn_prev">이전</a>
							<ul class="board-page">
								<li class="on"><a href="#" onclick="javascript:return false;">1</a></li>
								<li><a href="#" onclick="javascript:return false;">2</a></li>
								<li><a href="#" onclick="javascript:return false;">3</a></li>
								<li><a href="#" onclick="javascript:return false;">4</a></li>
								<li><a href="#" onclick="javascript:return false;">5</a></li>
								<li><a href="#" onclick="javascript:return false;">6</a></li>
								<li><a href="#" onclick="javascript:return false;">7</a></li>
								<li><a href="#" onclick="javascript:return false;">8</a></li>
							</ul>
							<a href="#" onclick="javascript:return false;" class="board-nav btn_next">다음</a>
							<a href="#" onclick="javascript:return false;" class="board-nav btn_last">마지막</a>
						</div>
					</div>

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
