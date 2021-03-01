<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="포인트, BBQ치킨">
<meta name="Description" content="포인트">
<title>포인트 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>포인트</h1>
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

			<!-- 포인트 요약 -->
			<div class="point-display mar-t60">
				<div class="div-table">
					<div class="tr">
						<div class="td">
							<dl>
								<dt>사용가능 포인트</dt>
								<dd><span>17,380</span>P</dd>
							</dl>
						</div>
						<div class="td">
							<dl>
								<dt>소멸예정 포인트</dt>
								<dd><span>0</span>P</dd>
							</dl>
							<p>(2019-03-01)</p>
						</div>
					</div>
				</div>
			</div>
			<!-- //포인트 요약 -->

			<!-- 포인트 적립내역 -->
			<section class="section section_pointList">
				<div class="section-header cupon_head pad-l0">
					<h3>포인트 적립내역</h3>
				</div>
				<div class="list">
					<div class="box">
						<div class="top">
							<div class="lef">
								<span class="ico-branch red">비비큐 치킨</span>
							</div>
							<div class="rig">+1,000P</div>
						</div>
						<dl>
							<dt>[온라인] 주문 적립</dt>
							<dd>발생일자 : 2018-01-30 / 소멸예정일 : 2018-12-30</dd>
						</dl>
					</div>
					<div class="box">
						<div class="top">
							<div class="lef">
								<span class="ico-branch yellow">비비큐몰</span>
							</div>
							<div class="rig">-1,000P</div>
						</div>
						<dl>
							<dt>[온라인] 주문 적립</dt>
							<dd>발생일자 : 2018-01-30 / 소멸예정일 : -</dd>
						</dl>
					</div>
				</div>
				<div class="mar-t30">
					<button type="button" class="btn btn-md btn-grayLine w-100p">더보기</button>
				</div>
			</section>
			<!-- //포인트 적립내역 -->

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