<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="고객센터, BBQ치킨">
<meta name="Description" content="고객센터">
<title>고객센터 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>고객센터</h1>
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
		<article class="content">

			<!-- Tab -->
			<div class="tab-wrap tab-type1">
				<ul class="tab two-up">
					<li><a href="./faqList.asp"><span>자주묻는질문</span></a></li>
					<li class="on"><a href="./inquiryList.asp"><span>고객의소리</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- 고객센터 상단 -->
			<section class="section section-Csinfo">
				<div class="inner">
					<p class="img ico-qa"><span class="ico-only">Q&amp;A</span></p>
					<p class="txt">
						고객님께서 자주 문의하시거나 궁금해하는 질문들을 모아서 정리하였습니다. 찾으시는 내용이 없거나 궁금한 사항이 있으면 고객의 소리에 의견을 남겨주세요. 고객님의 새로운 행복을 위해서 언제나 최선을 다하는 BBQ가 되겠습니다.
					</p>
				</div>
			</section>
			<!-- //고객센터 상단 -->

			<!-- FAQ -->
			<section class="section section_faq">

				<div class="box active">
					<a href="#this" class="question">
						<p>다른 맛도 먹어보고 싶어요. 이런질문내용. 이런저런 질문내용이 여기에 보이고있어요~~</p>
					</a>
					<div class="answer">
						<p>
							안녕하세요 고객님<br>
							딥치즈맛, 스윗허니맛이 있습니다.<br>
							주문 시 참고해주세요.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>다른 맛도 먹어보고 싶어요. 이런질문내용. 이런저런 질문내용이 여기에 보이고있어요~~</p>
					</a>
					<div class="answer">
						<p>
							안녕하세요 고객님<br>
							딥치즈맛, 스윗허니맛이 있습니다.<br>
							주문 시 참고해주세요.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>다른 맛도 먹어보고 싶어요. 이런질문내용. 이런저런 질문내용이 여기에 보이고있어요~~</p>
					</a>
					<div class="answer">
						<p>
							안녕하세요 고객님<br>
							딥치즈맛, 스윗허니맛이 있습니다.<br>
							주문 시 참고해주세요.
						</p>
					</div>
				</div>
			</section>
			<!-- //FAQ -->

			<hr class="line line-12">

			<!-- Call Center -->
			<section class="section section_callCenter section_callCenterCs">
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
			<!-- //Call Center -->

			<!-- 창업문의 -->
			<section class="section section_callCenter section_callCenterCreate">
				<div class="inner">
					<dl class="callCenter">
						<dt>창업문의</dt>
						<dd>
							<div class="callNumber">080-383-9000</div>
							<div class="openTime">연중무휴 상담가능 / 운영시간 06:00~24:00</div>
						</dd>
					</dl>
				</div>
			</section>
			<!-- //창업문의 -->


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