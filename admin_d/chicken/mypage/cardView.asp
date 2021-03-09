<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
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
				<li>카드</li>
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
						<li class="on"><a href="/mypage/cardList2.asp">카드</a></li>
						<li><a href="/mypage/inquiryList.asp">문의내역</a></li>
						<li><a href="/mypage/membership.asp"><span class="ddack">딹</span> 멤버십 안내</a>							
						</li>
					</ul>
				</div>
				<!--// My Menu -->
			</section>
			<!--// Membership -->
		
			<!-- card List -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>카드</h3>
				</div>
				<div class="section-body">
					<div class="card-view">
						<div class="box">
							<div class="img"><a href="./cardView.asp"><img src="/images/mypage/@card2.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><span class="fs16">잔액 :</span> <strong>100,000</strong>원</p>
							</div>
						</div>
						<div class="right">
							<table border="1" cellspacing="0" class="tbl-list">
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:120px;">
									<col style="width:auto;">
									<col style="width:120px;">
									<col style="width:150px;">
								</colgroup>
								<thead>
									<tr>
										<th>날짜</th>
										<th>내역</th>
										<th>금액</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black">가산디지털단지점 주문사용</p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black">가산디지털단지점 주문사용</p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black">가산디지털단지점 주문사용</p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p><img src="/images/mypage/ico_heart.png" alt=""></p>
											<p class="fs20 mar-t5 black">카드구매 - <span class="fs16">어디서나 쉽게 사용해보세요</span></p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
								</tbody>
							</table>

						</div>
					</div>

					<div class="btn-wrap two-up inner mar-t60">
						<a href="#" onclick="javascript:return false;" class="btn btn-lg btn-black"><span>목록</span></a>
					</div>

				</div>
			</section>
			<!--// card List -->
			
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
