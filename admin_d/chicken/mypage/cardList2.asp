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
				<li><a href="#">bbq home</a></li>
				<li><a href="#">마이페이지</a></li>
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
					<div class="right">
						
							<a href="#" class="btn btn-sm2 btn-red w-120">충전하기</a>
					</div>
				</div>
				<div class="section-body">
					<div class="card-view">
						
						
							<table border="1" cellspacing="0" class="tbl-list">
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:5%;">
									<col style="width:5%;">
									<col style="width:auto;">
									<col style="width:10%;">
									<col style="width:7%;">
									<col style="width:7%;">
									<col style="width:10%;">
									<col style="width:10%;">
									<col style="width:7%;">
									<col style="width:7%;">
									<col style="width:7%;">
									<col style="width:2%;">
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<th>구매형태</th>
										<th>카드번호</th>
										<th>거래일시</th>
										<th>입금</th>
										<th>출금</th>
										<th>사용주문번호</th>
										<th>사용가맹점</th>
										<th>거래전금액</th>
										<th>거래금액</th>
										<th>거래후금액</th>
										<th>메세지</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>222</td>
										<td>선불</td>
										<td>0000-0000-1234-1234</td>
										<td>2018.12.12</td>
										<td>30,000</td>
										<td>12,000</td>
										<td>W10000010797432</td>
										<td>구로점</td>
										<td>43,000</td>
										<td>15,000</td>
										<td>28,000</td>
										<td><a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_cardGiftPop2');" class="btn btn-sm btn-grayLine">보기</a></td>
									</tr>
									
								</tbody>
							</table>

						
					</div>

					<div class="board-pager-wrap">
						<div class="board-pager">
							<a href="#" class="board-nav btn_first">처음</a>
							<a href="#" class="board-nav btn_prev">이전</a>
							<ul class="board-page">
								<li class="on"><a href="#">1</a></li>
								<li><a href="#">2</a></li>
								<li><a href="#">3</a></li>
								<li><a href="#">4</a></li>
								<li><a href="#">5</a></li>
								<li><a href="#">6</a></li>
								<li><a href="#">7</a></li>
								<li><a href="#">8</a></li>
							</ul>
							<a href="#" class="board-nav btn_next">다음</a>
							<a href="#" class="board-nav btn_last">마지막</a>
						</div>
					</div>

				</div>
			</section>
			<!--// card List -->

			<!-- Layer Popup : 카드 선물메세지 -->
			<div id="lp_cardGiftPop2" class="lp-wrapper lp_cardGiftPop2">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>선물 메세지</h2>
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
