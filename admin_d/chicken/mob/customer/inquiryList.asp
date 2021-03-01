<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="고객센터, BBQ치킨">
<meta name="Description" content="고객센터">
<title>고객센터</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
	// inquiryList
	$(document).on('click', '.inquiryList .item-inquiry', function(e) {
		var $item = $(this).closest(".item");

		e.preventDefault();
		
		if ($item.hasClass("on")) {
			$item.find(".item-content").stop().slideUp('fast', function(){
				$item.removeClass("on");
			});
		} else {
			$item.addClass("on");
			$item.find(".item-content").stop().slideDown('fast');
		}
	});
});
</script>
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>고객센터</h1>
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
		<article class="content">

			<!-- Tab -->
			<div class="tab-wrap tab-type2">
				<ul class="tab">
					<li><a href="./faqList.asp"><span>자주묻는질문</span></a></li>
					<li class="on"><a href="./inquiryList.asp"><span>고객의소리</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- Inquiry List -->
			<div class="inquiryList-wrap inner mar-t70">
				<div class="btn-wrap">
					<a href="./inquiryWrite.asp" class="btn btn-md btn-red w-100p"><span>문의하기</span></a>
					<p class="explain">-문의하신 상담글은 수정, 삭제가 불가능합니다.</p>
				</div>
				<ul class="inquiryList">
					<li class="item">
						<a href="#this" class="item-inquiry">
							<p class="subject">상품문의 드립니다</p>
							<div class="item-footer">
								<p class="date">작성일 : <span>2018-12-30</span></p>
								<span class="state">답변전</span>
							</div>
						</a>
						<div class="item-content">
							<div class="question">
								<p>다른 맛도 먹어보고 싶어요. 이런질문내용. 이런저런 질문내용이 여기에 보이고있어요~~</p>
							</div>
						</div>
					</li>
					<li class="item complete">
						<a href="#this" class="item-inquiry">
							<p class="subject">상품문의 드립니다. 상품문의 드립니다. 상품문의 드립니다.</p>
							<div class="item-footer">
								<p class="date">작성일 : <span>2018-12-30</span></p>
								<span class="state">답변완료</span>
							</div>
						</a>
						<div class="item-content">
							<div class="question">
								<p>다른 맛도 먹어보고 싶어요. 이런질문내용. 이런저런 질문내용이 여기에 보이고있어요~~</p>
							</div>
							<div class="answer">
								<p>
									안녕하세요 고객님<br>
									딥치즈맛, 스윗허니맛이 있습니다.<br>
									주문 시 참고해주세요.
								</p>
							</div>
						</div>
					</li>
				</ul>
			</div>
			<!--// Inquiry List -->
			<!-- Button More -->
			<div class="inner btn-wrap mar-t20">
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
