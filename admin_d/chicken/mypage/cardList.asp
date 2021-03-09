<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/admin_d/chicken/includes/meta.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
<!--#include virtual="/admin_d/chicken/includes/styles.asp"-->
<!--#include virtual="/admin_d/chicken/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
});
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/admin_d/chicken/includes/header.asp"-->
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
						<li><a href="/mypage/cardList2.asp">카드</a></li>
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
						<div class="txt-basic16">
							사용 가능한 카드 <span class="orange fs20">2</span>장
						</div>
					</div>
				</div>
				<div class="section-body">
					<div class="card-list">
						<div class="box">
							<div class="img"><a href="/admin_d/chicken/mypage/cardView.asp"><img src="/admin_d/chicken/images/mypage/@card1.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong>100,000</strong>원</p>
							</div>
						</div>
						<div class="box">
							<div class="img"><a href="/admin_d/chicken/mypage/cardView.asp"><img src="/admin_d/chicken/images/mypage/@card2.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong>100,000</strong>원</p>
							</div>
						</div>
						<div class="box">
							<div class="img"><a href="/admin_d/chicken/mypage/cardView.asp"><img src="/admin_d/chicken/images/mypage/@card3.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong>사용완료</strong></p>
							</div>
						</div>
						<div class="box">
							<div class="img blankBox" onclick="javascript:lpOpen('.lp_cardadd');"><img src="/admin_d/chicken/images/mypage/plus.png" alt=""></div>
							<div class="info">
								<p class="txt"><strong>선물받은 카드를 등록하세요.</strong></p>
							</div>
						</div>
					</div>
				</div>
			</section>
			<!--// card List -->

			<!-- Layer Popup : 카드 선물하기 -->
			<div id="lp_cardGiftPop" class="lp-wrapper lp_cardadd">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>카드정보</h2>
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
													<th>카드번호</th>
													<td><input type="text" value="숫자 16 또는 18자리만 입력" maxlength="18" class="w-350"></td>
												</tr>
											</tbody>
										</table>
										<div class="alert">
											<span>* 카드 등록 후 적립한 포인트가 보이기까지는 최대 5분의 시간지연이 있을 수 있습니다.</span>
											<span>* 5회이상 잘못 입력하신 경우 24시간 후 재등록 가능합니다.</span>
										</div>
										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>등록하기</span></button>
										</div>
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
		<!--#include virtual="/admin_d/chicken/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/admin_d/chicken/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
