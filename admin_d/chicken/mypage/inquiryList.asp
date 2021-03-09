<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="나의 상담내역, BBQ치킨">
<meta name="Description" content="나의 상담내역">
<title>나의 상담내역 | BBQ치킨</title>
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
				<li>문의내역</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
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
						<li><a href="/mypage/couponList.asp">쿠폰</a></li>
						<li><a href="/mypage/mileage.asp">포인트</a></li>
						<li><a href="/mypage/cardList2.asp">카드</a></li>
						<li class="on"><a href="/mypage/inquiryList.asp">문의내역</a></li>
						<li><a href="/mypage/membership.asp"><span class="ddack">딹</span> 멤버십 안내</a>							
						</li>
					</ul>
				</div>
				<!--// My Menu -->
			</section>
			<!--// Membership -->
		
			<!-- My Inquiry List -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>문의내역</h3>
					<div class="right">
						<select name="" id="" class="w-250">
							<option value="">전체브랜드 보기</option>
							<option value="">비비큐치킨</option>
							<option value="">비비큐몰</option>
							<option value="">행복한집밥</option>
							<option value="">닭익는마을</option>
							<option value="">참숯바베큐</option>
							<option value="">우쿠야</option>
							<option value="">올떡</option>
							<option value="">소신</option>
							<option value="">와타미</option>
						</select>
					</div>
				</div>
				<div class="section-body">
					<div class="boardList-wrap">

						<table border="1" cellspacing="0" class="tbl-list">
							<caption>문의내역 리스트</caption>
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
										<a href="./inquiryView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
									</td>
									<td>2018-12-20</td>
									<td><span>답변전</span></td>
								</tr>
								<tr>
									<td>1</td>
									<td class="ta-l">
										<span class="ico-branch orange mar-r10">올떡</span>
										<a href="./inquiryView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
									</td>
									<td>2018-12-20</td>
									<td><span class="red">답변완료</span></td>
								</tr>
								<tr>
									<td>1</td>
									<td class="ta-l">
										<span class="ico-branch yellow mar-r10">비비큐몰</span>
										<a href="./inquiryView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
									</td>
									<td>2018-12-20</td>
									<td><span class="red">답변완료</span></td>
								</tr>
							</tbody>
						</table>

					</div>
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
						<div class="btn-area"><a href="#" onclick="javascript:return false;" class="btn btn-red">문의하기</a></div>
					</div>
				</div>
			</section>
			<!--// My Inquiry List -->
			
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
