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
	$(document).on('click', '.item-inquiry a', function(e) {
		var $item = $(this).closest(".item-inquiry");

		e.preventDefault();
		
		if ($item.next(".item-content").hasClass("on")) {
			$item.next(".item-content").find(".item").stop().slideUp('fast',function(){
				$item.next(".item-content").removeClass("on");
			});
		} else {
			$item.next(".item-content").addClass("on");
			$item.next(".item-content").find(".item").stop().slideDown('fast');
		}
	});
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
		
			<!-- My Inquiry -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>문의내역</h3>
				</div>
				<div class="section-body">

					<div class="board-view">
						<div class="top">
							<h3>
								<span class="ico-branch red mal-r10">비비큐 치킨</span> 이번에 새로나온 포테이토 종류알려주세요
							</h3>
							<ul class="info">
								<li class="date"><strong>작성일 :</strong> 2018-12-14</li>
								<li><span class="red">답변완료</span></li>
							</ul>
						</div>
						<div class="faq">
							<div class="section section_faq">
								<div class="box active">
									<a href="#this" class="question">
										<p>다른 맛도 먹어보고 싶어요. 이런질문내용. 이런저런 질문내용이 여기에 보이고있어요~~</p>
									</a>
									<div class="answer" style="display:block;">
										<p>
											안녕하세요 고객님<br>
											딥치즈맛, 스윗허니맛이 있습니다.<br>
											주문 시 참고해주세요.
										</p>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
			</section>
			<!--// My Inquiry -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="#" onclick="javascript:return false;" class="btn btn-lg btn-black"><span>목록</span></a>
			</div>

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
