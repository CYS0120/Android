<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="쿠폰, BBQ치킨">
<meta name="Description" content="쿠폰">
<title>쿠폰 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>쿠폰</h1>
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

			<!-- 사용가능쿠폰 -->
			<section class="section section_couponUseOk mar-t60">
				<div class="section-header coupon_head">
					<h3>사용 가능한 쿠폰 <strong class="yellow">3</strong>장</h3>
				</div>
				<div class="area">

					<div class="box">
						<div class="coupon">
							<div class="tit div-table">
								<ul class="tr">
									<li class="td device"><span class="ico-branch red">비비큐치킨</span></li>
									<li class="td day">D-15</li>
								</ul>
							</div>
							<dl class="info">
								<dt>[스테디셀러] 황금올리브 1+1 쿠폰</dt>
								<dd>
									유효기간 : 2018-12-01 ~ 2018-12-31<br/>
									사용처 : PC · 모바일 · App
								</dd>
							</dl>
						</div>
						<div class="txt">
							- 황금올리브 치킨 주문시 사용 가능<br/>
							- 타 쿠폰과 중복 사용불가
						</div>
					</div>

					<div class="box">
						<div class="coupon">
							<div class="tit div-table">
								<ul class="tr">
									<li class="td device"><span class="ico-branch yellow">비비큐몰</span></li>
									<li class="td day">D-15</li>
								</ul>
							</div>
							<dl class="info">
								<dt>[스테디셀러] 황금올리브 1+1 쿠폰</dt>
								<dd>
									유효기간 : 2018-12-01 ~ 2018-12-31<br/>
									사용처 : PC · 모바일 · App
								</dd>
							</dl>
						</div>
						<div class="txt">
							- 황금올리브 치킨 주문시 사용 가능<br/>
							- 타 쿠폰과 중복 사용불가
						</div>
					</div>

				</div>
			</section>
			<!-- //사용가능쿠폰 -->

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